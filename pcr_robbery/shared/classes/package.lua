local LootTable      = require 'shared.classes.loot_table'
local weightedRandom = require 'shared.utils.weighted_random'

---@class PackageDef
---@field tier string
---@field item string
---@field lootEntries LootEntry[]
---@field rewardCount { min: integer, max: integer }
---@field cashRange { min: integer, max: integer }
---@field emptyChance number
---@field alertChance number

---@class PackageContents
---@field empty boolean
---@field rolls LootRoll[]
---@field cash integer

---@class Package : OxClass
---@field tier string
---@field item string
---@field alertChance number
local Package = lib.class('Package')

---@param def PackageDef
function Package:constructor(def)
    self.tier        = def.tier
    self.item        = def.item
    self.alertChance = def.alertChance

    self.private = {
        lootTable   = LootTable:new(def.lootEntries),
        rewardCount = def.rewardCount,
        cashRange   = def.cashRange,
        emptyChance = def.emptyChance,
    }
end

--- Roll the contents of an opened package.
---@return PackageContents
function Package:open()
    if math.random() < self.private.emptyChance then
        return { empty = true, rolls = {}, cash = 0 }
    end

    local rewardCount = self.private.rewardCount
    local count = weightedRandom.intBetween(rewardCount.min, rewardCount.max)
    local rolls = self.private.lootTable:roll(count)

    local cashRange = self.private.cashRange
    local cash = weightedRandom.intBetween(cashRange.min, cashRange.max)

    return { empty = false, rolls = rolls, cash = cash }
end

--- Whether opening this package should trigger a police alert.
---@return boolean
function Package:rollAlert()
    if self.alertChance >= 1.0 then return true end
    return math.random() < self.alertChance
end

return Package
