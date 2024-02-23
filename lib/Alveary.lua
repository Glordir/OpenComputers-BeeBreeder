local Inventory = require "Inventory"


---@class Alveary: Inventory
---@field public slots ALVEARY_SLOTS


---@enum ALVEARY_SLOTS The slots in an Alveary
---
local ALVEARY_SLOTS = {
    drone = 2,
    princess = 1
}


---Creates a new Alveary
---@param side Side
---@return Alveary
---
local function createAlveary(side)
    local inventory = Inventory(side)

    local apiary = setmetatable({
        slots = ALVEARY_SLOTS
    }, {__index = inventory}) --[[@as Apiary]]

    return apiary
end


return createAlveary
