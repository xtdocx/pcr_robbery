local LEVELS = {
    DEBUG = 1,
    INFO  = 2,
    WARN  = 3,
    ERROR = 4,
}

local activeLevel = LEVELS.INFO

local function format(levelName, message)
    return ('[pcr_robbery][%s] %s'):format(levelName, message)
end

local M = {}

---@param name 'DEBUG' | 'INFO' | 'WARN' | 'ERROR'
function M.setLevel(name)
    local level = LEVELS[name]
    if not level then return end
    activeLevel = level
end

function M.debug(message)
    if activeLevel > LEVELS.DEBUG then return end
    print(format('DEBUG', message))
end

function M.info(message)
    if activeLevel > LEVELS.INFO then return end
    print(format('INFO', message))
end

function M.warn(message)
    if activeLevel > LEVELS.WARN then return end
    print(format('WARN', message))
end

function M.error(message)
    print(format('ERROR', message))
end

return M
