local robberyService = require 'modules.robbery_service'

local function onSearchedVehicle(source, netId, vehicleClass)
    return robberyService.searchVehicle(source, netId, vehicleClass)
end

local function onSoldPackage(source, itemName)
    return robberyService.sellPackage(source, itemName)
end

lib.callback.register('pcr_robbery:server:searchedVehicle', onSearchedVehicle)
lib.callback.register('pcr_robbery:server:soldPackage',     onSoldPackage)
