---@alias Side
---| 0 # bottom
---| 1 # top
---| 2 # north
---| 3 # south
---| 4 # west
---| 5 # east


---@class Location
---@field public side Side
---@field public slot number


---Creates a new Location
---@param side Side
---@param slot number
---@return Location
---
local function createLocation(side, slot)
    return {side = side, slot = slot}
end


return createLocation
