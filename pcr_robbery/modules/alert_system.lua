local config = require 'shared.config'

local DISPATCH_EVENT = 'pcr_robbery:server:dispatchedAlert'

local M = {}

--- Dispatch a vehicle break-in alert. Bind `pcr_robbery:server:dispatchedAlert`
--- in your dispatch resource (ps-dispatch, cd_dispatch, ox_dispatch, etc.).
---@param coords vector3
---@param tier string
function M.dispatch(coords, tier)
    TriggerEvent(DISPATCH_EVENT, {
        coords       = coords,
        tier         = tier,
        title        = config.alert.title,
        blipSprite   = config.alert.blipSprite,
        blipColor    = config.alert.blipColor,
        blipDuration = config.alert.blipDuration,
    })
end

return M
