local config = require 'shared.config'

local M = {}

local function send(source, payload)
    if not payload then return end
    lib.notify(source, payload)
end

---@param source integer
---@param tier string
function M.tier(source, tier)
    send(source, config.notifications[tier])
end

---@param source integer
function M.empty(source)
    send(source, config.notifications.empty)
end

---@param source integer
function M.jackpot(source)
    send(source, config.notifications.jackpot)
end

---@param source integer
function M.alerted(source)
    send(source, config.notifications.alerted)
end

---@param source integer
---@param amount integer
function M.fence(source, amount)
    local payload = config.notifications.fence
    if not payload then return end
    send(source, {
        type        = payload.type,
        title       = payload.title,
        description = ('%s ($%d)'):format(payload.description, amount),
    })
end

return M
