local config             = require 'shared.config'
local logger              = require 'shared.utils.logger'
local weightedRandom      = require 'shared.utils.weighted_random'
local packageAssignment   = require 'modules.package_assignment'
local packageRegistry     = require 'modules.package_registry'
local inventoryBridge     = require 'modules.inventory_bridge'
local cashService         = require 'modules.cash_service'
local alertSystem         = require 'modules.alert_system'
local playerService       = require 'modules.player_service'
local notificationService = require 'modules.notification_service'
local state               = require 'server.state'

local STATEBAG_ROBBED       = 'pcr_robbery:robbed'
local VEHICLE_TYPE          = 2
local MAX_INTERACT_DISTANCE = 4.0

local M = {}

local function reject(source, netId, reason)
    logger.warn(('searchVehicle rejected src=%s netId=%s reason=%s'):format(source, netId, reason))
    return nil
end

---@param source integer
---@param netId integer
---@return integer? entity
local function validateInteraction(source, netId)
    if type(netId) ~= 'number' or netId == 0 then return reject(source, netId, 'bad_netid') end
    if state.isRobbed(netId) then return reject(source, netId, 'already_robbed') end

    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity or entity == 0 then return reject(source, netId, 'no_entity') end
    if GetEntityType(entity) ~= VEHICLE_TYPE then return reject(source, netId, 'not_vehicle') end

    local playerCoords = playerService.getCoords(source)
    if not playerCoords then return reject(source, netId, 'no_player_coords') end

    local vehicleCoords = GetEntityCoords(entity)
    if #(playerCoords - vehicleCoords) > MAX_INTERACT_DISTANCE then
        return reject(source, netId, 'too_far')
    end

    return entity
end

local function depositRolls(source, rolls)
    local jackpotHit = false
    for i = 1, #rolls do
        local roll = rolls[i]
        inventoryBridge.addItem(source, roll.item, roll.count)
        if roll.jackpot then jackpotHit = true end
    end
    return jackpotHit
end

local function maybeAlert(source, package)
    if not package:rollAlert() then return false end
    local coords = playerService.getCoords(source)
    if not coords then return false end
    alertSystem.dispatch(coords, package.tier)
    return true
end

---@param source integer
---@param netId integer
---@param vehicleClass integer? client-reported, sanitized below
---@return { success: boolean, tier: string? }
function M.searchVehicle(source, netId, vehicleClass)
    local entity = validateInteraction(source, netId)
    if not entity then return { success = false } end

    if type(vehicleClass) ~= 'number' then vehicleClass = nil end
    local tier = packageAssignment.assignTier(vehicleClass)
    local package = packageRegistry.byTier(tier)
    if not package then
        logger.warn(('searchVehicle: missing package for tier "%s"'):format(tier))
        return { success = false }
    end

    state.markRobbed(netId)
    Entity(entity).state:set(STATEBAG_ROBBED, true, true)

    if not inventoryBridge.addItem(source, package.item, 1) then
        logger.warn(('searchVehicle: failed to add %s to src=%s'):format(package.item, source))
        return { success = false }
    end

    notificationService.tier(source, tier)
    return { success = true, tier = tier }
end

--- Server-side handler for opening a package. Called from ox_inventory's
--- `usingItem` server export. Item consumption is handled by ox_inventory.
---@param source integer
---@param itemName string
---@return { success: boolean, tier: string?, empty: boolean?, alerted: boolean? }
function M.openPackage(source, itemName)
    local package = packageRegistry.byItem(itemName)
    if not package then return { success = false } end

    local contents = package:open()

    if contents.empty then
        notificationService.empty(source)
        return { success = true, tier = package.tier, empty = true, alerted = false }
    end

    local jackpotHit = depositRolls(source, contents.rolls)
    if contents.cash > 0 then
        cashService.give(source, contents.cash)
    end

    local alerted = maybeAlert(source, package)

    if jackpotHit then
        notificationService.jackpot(source)
    end
    if alerted then
        notificationService.alerted(source)
    end

    return { success = true, tier = package.tier, empty = false, alerted = alerted }
end

---@param source integer
---@param itemName string
---@return { success: boolean, amount: integer? }
function M.sellPackage(source, itemName)
    local package = packageRegistry.byItem(itemName)
    if not package then return { success = false } end

    local playerCoords = playerService.getCoords(source)
    if not playerCoords then return { success = false } end
    if #(playerCoords - config.fence.coords) > config.fenceDistance then
        return { success = false }
    end

    if inventoryBridge.getCount(source, itemName) < 1 then
        return { success = false }
    end

    local range = config.sellPrice[package.tier]
    if not range then return { success = false } end

    if not inventoryBridge.removeItem(source, itemName, 1) then
        return { success = false }
    end

    local amount = weightedRandom.intBetween(range.min, range.max)
    cashService.give(source, amount)
    notificationService.fence(source, amount)
    return { success = true, amount = amount }
end

return M
