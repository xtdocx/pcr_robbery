local config       = require 'shared.config'
local vehicleState = require 'shared.utils.vehicle_state'

local STATEBAG_ROBBED  = 'pcr_robbery:robbed'
local SELL_CONTEXT_ID  = 'pcr_robbery_sell'
local SEARCH_ANIM_DICT = 'mp_car_bomb'
local SEARCH_ANIM_CLIP = 'car_bomb_mechanic'
local SEARCH_ANIM_FLAG = 49 -- upper body + loop, lets the ped stay in seat

local M = {}

local function getCurrentVehicle()
    local ped = PlayerPedId()
    if not IsPedSittingInAnyVehicle(ped) then return nil end
    return GetVehiclePedIsIn(ped, false)
end

local function isVehicleRobbed(entity)
    return Entity(entity).state[STATEBAG_ROBBED] == true
end

local function startSearchAnim(ped)
    if not lib.requestAnimDict(SEARCH_ANIM_DICT, 5000) then return end
    TaskPlayAnim(ped, SEARCH_ANIM_DICT, SEARCH_ANIM_CLIP, 4.0, -4.0, -1, SEARCH_ANIM_FLAG, 0, false, false, false)
end

local function stopSearchAnim(ped)
    StopAnimTask(ped, SEARCH_ANIM_DICT, SEARCH_ANIM_CLIP, 1.0)
end

local function runSkillCheck()
    return exports['bl_ui']:CircleProgress(
        config.skillCheck.iterations,
        config.skillCheck.difficulty
    ) == true
end

function M.searchCurrentVehicle()
    local vehicle = getCurrentVehicle()
    if not vehicle then return end

    if isVehicleRobbed(vehicle) then
        lib.notify({ type = 'error', description = 'Already searched.' })
        return
    end

    if not vehicleState.isStationary(vehicle) then
        lib.notify({ type = 'error', description = 'Stop the vehicle first.' })
        return
    end

    local ped = PlayerPedId()
    startSearchAnim(ped)
    runSkillCheck()
    stopSearchAnim(ped)

    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    if not netId or netId == 0 then return end

    local vehicleClass = GetVehicleClass(vehicle)
    local result = lib.callback.await('pcr_robbery:server:searchedVehicle', false, netId, vehicleClass)
    if not result or not result.success then
        lib.notify({ type = 'error', description = 'Nothing of value here.' })
    end
end

local function sellOnePackage(args)
    local result = lib.callback.await('pcr_robbery:server:soldPackage', false, args.item)
    if not result or not result.success then
        lib.notify({ type = 'error', description = 'Could not sell that package.' })
    end
end

local function buildSellOptions()
    local options = {}
    local optionsCount = 0
    for tier, item in pairs(config.packageItems) do
        local count = exports.ox_inventory:Search('count', item) or 0
        if count > 0 then
            optionsCount = optionsCount + 1
            options[optionsCount] = {
                title       = ('Sell %s package'):format(tier),
                description = ('Owned: %d'):format(count),
                icon        = 'fa-solid fa-box',
                onSelect    = sellOnePackage,
                args        = { item = item, tier = tier },
            }
        end
    end
    return options, optionsCount
end

function M.openSellMenu()
    local options, optionsCount = buildSellOptions()
    if optionsCount == 0 then
        lib.notify({ type = 'error', description = 'No packages to sell.' })
        return
    end
    lib.registerContext({ id = SELL_CONTEXT_ID, title = 'Fence', options = options })
    lib.showContext(SELL_CONTEXT_ID)
end

return M
