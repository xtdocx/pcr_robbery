local config         = require 'shared.config'
local weightedRandom = require 'shared.utils.weighted_random'

local DEFAULT_TIER = 'common'

local M = {}

---@param vehicleClass integer
---@return table<string, number>
local function getWeightsForClass(vehicleClass)
    return config.classWeights[vehicleClass] or config.defaultClassWeights
end

--- Choose a package tier for a vehicle by class.
---@param vehicleClass integer
---@return string tier
function M.assignTier(vehicleClass)
    local weights = getWeightsForClass(vehicleClass)
    local tier = weightedRandom.pickWeighted(weights)
    return tier or DEFAULT_TIER
end

return M
