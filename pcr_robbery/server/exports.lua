local logger         = require 'shared.utils.logger'
local robberyService = require 'modules.robbery_service'

local START_EMOTE_EVENT = 'pcr_robbery:client:startedOpenEmote'
local STOP_EMOTE_EVENT  = 'pcr_robbery:client:stoppedOpenEmote'

--- ox_inventory `server.export` hook for package items.
--- - `usingItem` fires before usetime: kick off the emote on the client.
--- - `usedItem`  fires after usetime:  stop the emote, drop the loot.
--- A cancelled use never reaches `usedItem`, so loot never drops on cancel.
---@param event string
---@param item { name: string }
---@param inventory { id: integer | string }
local function usePackage(event, item, inventory)
    local source = tonumber(inventory.id)
    if not source then
        logger.warn('usePackage: non-numeric inventory.id, ignoring')
        return
    end

    if event == 'usingItem' then
        TriggerClientEvent(START_EMOTE_EVENT, source)
    elseif event == 'usedItem' then
        TriggerClientEvent(STOP_EMOTE_EVENT, source)
        robberyService.openPackage(source, item.name)
    end
end

exports('usePackage', usePackage)
