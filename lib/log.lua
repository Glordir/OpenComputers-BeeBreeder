local colors = require "colors"
local component = require "component"

local gpu = component.getPrimary("gpu")


--- Config:
local C = {log_level = "debug", logfile = "log.txt"}


--- Helper Functions (Forward Declaration):
local coloredPrint
local logToFile


--- Log:
local Log = {}


local log_level_name_table = {debug = 0, info = 1, warn = 2, error = 3}
Log.log_level = log_level_name_table[C.log_level]

Log.write_to_file = C.logfile ~= nil
Log.logfile = io.open(C.logfile, "w")


function Log.debug(...)
    if Log.log_level > 0 then
        return
    end

    coloredPrint(colors.lightblue, "[DEBUG] ", ...)
    logToFile("[DEBUG] ", ...)
end

function Log.info(...)
    if Log.log_level > 1 then
        return
    end

    coloredPrint(colors.green, "[INFO] ", ...)
    logToFile("[INFO] ", ...)
end

function Log.warn(...)
    if Log.log_level > 2 then
        return
    end

    coloredPrint(colors.yellow, "[WARN] ", ...)
    logToFile("[WARN] ", ...)
end

function Log.error(...)
    coloredPrint(colors.red, "[ERROR] ", ...)
    logToFile("[ERROR] ", ...)
end


--- Helper Functions (Implementation):
coloredPrint = function (color, prefix, ...)
    local old_color = gpu.setForeground(color, true)
    io.write(prefix)
    print(...)
    gpu.setForeground(old_color)
end


logToFile = function (prefix, ...)
    if Log.write_to_file then
        Log.logfile:write(prefix)
        Log.logfile:write(tostring(...) .. "\n")
    end
end


return Log
