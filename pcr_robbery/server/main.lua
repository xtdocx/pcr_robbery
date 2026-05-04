local config = require 'shared.config'
local logger = require 'shared.utils.logger'
local state  = require 'server.state'

logger.setLevel(config.logLevel)

require 'server.callbacks'
require 'server.exports'

local VEHICLE_TYPE = 2

local function onEntityRemoved(entity)
    if GetEntityType(entity) ~= VEHICLE_TYPE then return end
    local netId = NetworkGetNetworkIdFromEntity(entity)
    if not netId or netId == 0 then return end
    state.clear(netId)
end

AddEventHandler('entityRemoved', onEntityRemoved)

logger.info('initialized')
