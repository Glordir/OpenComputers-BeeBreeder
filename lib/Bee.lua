local Location = require "Location"


---@class Bee
---@field native_bee table
---@field location Location


---Converts a 'native' bee to my bee representation
---@param native_bee table
---@param side Side
---@param slot number
---@return Bee
---
local function convertBee(native_bee, side, slot)
    return {native_bee = native_bee, location = Location(side, slot)}
end


return convertBee
