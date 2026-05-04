local logger = require 'shared.utils.logger'

local M = {}

---@param source integer
---@param item string
---@param count integer
---@return boolean
function M.addItem(source, item, count)
    if count <= 0 then return true end
    local ok, success = pcall(function()
        return exports.ox_inventory:AddItem(source, item, count)
    end)
    if not ok then
        logger.error(('inventory_bridge.addItem failed src=%s item=%s err=%s'):format(source, item, tostring(success)))
        return false
    end
    return success ~= false
end

---@param source integer
---@param item string
---@param count integer
---@param slot? integer
---@return boolean
function M.removeItem(source, item, count, slot)
    if count <= 0 then return true end
    local ok, success = pcall(function()
        return exports.ox_inventory:RemoveItem(source, item, count, nil, slot)
    end)
    if not ok then
        logger.error(('inventory_bridge.removeItem failed src=%s item=%s err=%s'):format(source, item, tostring(success)))
        return false
    end
    return success ~= false
end

---@param source integer
---@param item string
---@return integer
function M.getCount(source, item)
    local ok, count = pcall(function()
        return exports.ox_inventory:GetItem(source, item, nil, true)
    end)
    if not ok then return 0 end
    return tonumber(count) or 0
end

return M
