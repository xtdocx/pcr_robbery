local weightedRandom = require 'shared.utils.weighted_random'

---@class LootEntry
---@field item string
---@field qty { min: integer, max: integer }
---@field chance number
---@field jackpot? boolean

---@class LootRoll
---@field item string
---@field count integer
---@field jackpot boolean

---@class LootTable : OxClass
---@field private entries LootEntry[]
local LootTable = lib.class('LootTable')

---@param entries LootEntry[]
function LootTable:constructor(entries)
    assert(type(entries) == 'table', 'LootTable requires an entries table')
    self.private = { entries = entries }
end

--- Roll `count` random rewards from the table (with replacement).
---@param count integer
---@return LootRoll[]
function LootTable:roll(count)
    local entries = self.private.entries
    local rolls = {}
    local rollsCount = 0
    for _ = 1, count do
        local index = weightedRandom.pickIndexByChance(entries)
        local entry = entries[index]
        if entry then
            rollsCount = rollsCount + 1
            rolls[rollsCount] = {
                item    = entry.item,
                count   = weightedRandom.intBetween(entry.qty.min, entry.qty.max),
                jackpot = entry.jackpot == true,
            }
        end
    end
    return rolls
end

return LootTable
