local config = require 'shared.config'

local START_EMOTE_EVENT = 'pcr_robbery:client:startedOpenEmote'
local STOP_EMOTE_EVENT  = 'pcr_robbery:client:stoppedOpenEmote'

local function startEmote()
    pcall(function()
        exports['scully_emotemenu']:playEmoteByCommand(config.openPackageEmote)
    end)
end

local function stopEmote()
    pcall(function()
        exports['scully_emotemenu']:cancelEmote()
    end)
end

local function onStartEvent()
    if GetInvokingResource() then return end
    startEmote()
end

local function onStopEvent()
    if GetInvokingResource() then return end
    stopEmote()
end

RegisterNetEvent(START_EMOTE_EVENT, onStartEvent)
RegisterNetEvent(STOP_EMOTE_EVENT,  onStopEvent)
