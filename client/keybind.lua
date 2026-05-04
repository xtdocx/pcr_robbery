local config      = require 'shared.config'
local interaction = require 'client.interaction'

local KEYBIND_NAME = 'pcr_search_vehicle'

local function onSearchKeyPressed()
    interaction.searchCurrentVehicle()
end

lib.addKeybind({
    name        = KEYBIND_NAME,
    description = config.searchKeyDescription,
    defaultKey  = config.searchKeyDefault,
    onPressed   = onSearchKeyPressed,
})
