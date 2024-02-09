local Log = require "Log"


local util = {}

function util.filter(t, predicate)
    local out = {}

    for _, value in ipairs(t) do
        if predicate(value) then
            table.insert(out, value)
        end
    end

    return out
end


---Prints the passed variable
---@param var any
---@param output table?
---@param level integer?
---@param indent_first_line boolean?
function util.prettyPrint(var, output, level, indent_first_line)
    output = output or io.stdout
    level = level or 0

    local indentation = string.rep("  ", level)
    local first_indentation = indent_first_line and indentation or ""

    if type(var) == "table" then
        output:write(first_indentation .. "{\n")
        for key, value in pairs(var) do
            output:write(indentation .. tostring(key) .. " - ")
            util.prettyPrint(value, output, level + 1, false)
        end
        output:write(indentation .. "}\n")
    else
        output:write(first_indentation .. tostring(var) .. "\n")
    end
end


---Write the variable to the filename
---@param var any
---@param filename string
function util.writeVariableToFile(var, filename)
    local output_file = io.open(filename, "w")
    if output_file == nil then
        Log.warn("Unable to open '" .. filename .. "' for writing.")
        return
    end

    util.prettyPrint(var, output_file)
    output_file:close()
end


---Converts a boolean to an integer (true -> 1, false -> 0)
---@param b boolean
---@return integer
function util.booleanToInt(b)
    return b and 1 or 0
end


return util
