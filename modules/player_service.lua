local M = {}

--- Resolve an ox_core player object for `source`, if available.
---@param source integer
---@return table?
function M.getPlayer(source)
    if not Ox or not Ox.GetPlayer then return nil end
    return Ox.GetPlayer(source)
end

--- Live ped coordinates for a player. Returns nil if ped is missing.
---@param source integer
---@return vector3?
function M.getCoords(source)
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return nil end
    return GetEntityCoords(ped)
end

return M
