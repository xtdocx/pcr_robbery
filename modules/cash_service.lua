local logger = require 'shared.utils.logger'

local CASH_ITEM = 'money'

local M = {}

--- Give cash to a player. Defaults to the ox_inventory `money` item.
---@param source integer
---@param amount integer
---@return boolean
function M.give(source, amount)
    if amount <= 0 then return true end
    local ok, success = pcall(function()
        return exports.ox_inventory:AddItem(source, CASH_ITEM, amount)
    end)
    if not ok then
        logger.warn(('cash_service.give failed src=%s amount=%s'):format(source, amount))
        return false
    end
    return success ~= false
end

return M
