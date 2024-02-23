---@alias Side
---| 0 # bottom
---| 1 # top
---| 2 # north
---| 3 # south
---| 4 # west
---| 5 # east


---@class Location
---@field public side Side
---@field public slot integer

local Location = setmetatable({}, {__call = function (location, ...)
    return location.new(...)
end})


---Constructor for the Location class
---@param side Side
---@param slot integer
---@return Location
---
function Location.new(side, slot)
    return setmetatable({side = side, slot = slot}, {__tostring = Location.toString, __eq = Location.eq})
end


---Returns the string representation of the location
---@return string
function Location:toString()
    return "[" .. self.side .. ", " .. self.slot .. "]"
end


---Checks if the passed location is the same as self
---@param other Location
---@return boolean
---
function Location:eq(other)
    return self.side == other.side and self.slot == other.slot
end


return Location
