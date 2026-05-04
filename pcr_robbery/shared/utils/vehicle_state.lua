--- m/s. Anything at or below this is treated as stationary.
local STATIONARY_SPEED_M_S = 0.5

local M = {}

---@param entity integer
---@return boolean
function M.isStationary(entity)
    return GetEntitySpeed(entity) <= STATIONARY_SPEED_M_S
end

return M
