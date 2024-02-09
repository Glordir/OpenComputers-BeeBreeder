local colors = require "colors"
local component = require "component"

local gpu = component.getPrimary("gpu")


--- Config:
local C = {log_level = "debug", logfile = nil}


--- Helper Function (Forward Declaration):
local coloredPrint


--- Log:
local Log = {}


local log_level_name_table = {debug = 0, info = 1, warn = 2, error = 3}
Log.log_level = log_level_name_table[C.log_level]

Log.logfile = C.logfile
Log.write_to_file = Log.logfile ~= nil


function Log.debug(...)
    if Log.log_level > 0 then
        return
    end

    coloredPrint(colors.lightblue, "[DEBUG] " .. ...)
end

function Log.info(...)
    if Log.log_level > 1 then
        return
    end

    coloredPrint(colors.green, "[INFO] " .. ...)
end

function Log.warn(...)
    if Log.log_level > 2 then
        return
    end

    coloredPrint(colors.yellow, "[WARN] " .. ...)
end

function Log.error(...)
    coloredPrint(colors.red, "[ERROR] " .. ...)
end


--- Helper Function (Implementation):
function coloredPrint(color, ...)
    local old_color = gpu.setForeground(color)
    print(...)
    gpu.setForeground(old_color)
end


return Log
