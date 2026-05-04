local M = {}

--- Picks a key from a `{ key = weight }` table using weighted random selection.
---@param weights table<string|number, number>
---@return string|number? selectedKey
function M.pickWeighted(weights)
    local totalWeight = 0
    for _, weight in pairs(weights) do
        totalWeight = totalWeight + weight
    end
    if totalWeight <= 0 then return nil end

    local roll = math.random() * totalWeight
    local accumulator = 0
    for key, weight in pairs(weights) do
        accumulator = accumulator + weight
        if roll <= accumulator then
            return key
        end
    end
end

--- Picks an entry index from `entries[i].chance` using weighted random.
---@param entries { chance: number }[]
---@return integer
function M.pickIndexByChance(entries)
    local totalChance = 0
    local entriesCount = #entries
    for i = 1, entriesCount do
        totalChance = totalChance + entries[i].chance
    end
    if totalChance <= 0 then return 1 end

    local roll = math.random() * totalChance
    local accumulator = 0
    for i = 1, entriesCount do
        accumulator = accumulator + entries[i].chance
        if roll <= accumulator then
            return i
        end
    end
    return entriesCount
end

--- Random integer in [min, max].
---@param min integer
---@param max integer
---@return integer
function M.intBetween(min, max)
    if min >= max then return min end
    return math.random(min, max)
end

return M
