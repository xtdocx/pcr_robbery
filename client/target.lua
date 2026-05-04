local config      = require 'shared.config'
local interaction = require 'client.interaction'

local SELL_OPTION_ID  = 'pcr_robbery:sell'
local FENCE_ZONE_NAME = 'pcr_robbery:fence'

local function onSelectSell()
    interaction.openSellMenu()
end

local function registerTargets()
    exports.ox_target:addBoxZone({
        name     = FENCE_ZONE_NAME,
        coords   = config.fence.coords,
        size     = config.fence.size,
        rotation = config.fence.heading,
        options  = {
            {
                name     = SELL_OPTION_ID,
                icon     = 'fa-solid fa-sack-dollar',
                label    = 'Sell Packages',
                onSelect = onSelectSell,
            },
        },
    })
end

local function removeTargets()
    exports.ox_target:removeZone(FENCE_ZONE_NAME)
end

registerTargets()

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    removeTargets()
end)
