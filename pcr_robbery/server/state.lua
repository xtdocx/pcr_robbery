---@type table<integer, true>
local robbedSet = {}

local M = {}

---@param netId integer
---@return boolean
function M.isRobbed(netId)
    return robbedSet[netId] == true
end

---@param netId integer
function M.markRobbed(netId)
    robbedSet[netId] = true
end

---@param netId integer
function M.clear(netId)
    robbedSet[netId] = nil
end

function M.size()
    local count = 0
    for _ in pairs(robbedSet) do count = count + 1 end
    return count
end

return M
