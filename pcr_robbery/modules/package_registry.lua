local Package = require 'shared.classes.package'
local config  = require 'shared.config'
local logger  = require 'shared.utils.logger'

---@type table<string, Package>
local byTier = {}

---@type table<string, Package>
local byItem = {}

local function build()
    for tier, item in pairs(config.packageItems) do
        local entries = config.lootTables[tier]
        if not entries then
            logger.warn(('package_registry: no loot table for tier "%s"'):format(tier))
            entries = {}
        end

        local package = Package:new({
            tier        = tier,
            item        = item,
            lootEntries = entries,
            rewardCount = config.rewardsPerPackage[tier] or { min = 2, max = 3 },
            cashRange   = config.cashRange[tier]         or { min = 0, max = 0 },
            emptyChance = config.emptyPackageChance[tier] or 0,
            alertChance = config.alertChance[tier]        or 0,
        })

        byTier[tier] = package
        byItem[item] = package
    end
end

build()

local M = {}

---@param tier string
---@return Package?
function M.byTier(tier)
    return byTier[tier]
end

---@param itemName string
---@return Package?
function M.byItem(itemName)
    return byItem[itemName]
end

return M
