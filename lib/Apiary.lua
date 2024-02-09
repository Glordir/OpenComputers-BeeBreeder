local Inventory = require "Inventory"


---@class Apiary: Inventory
---@field public slots APIARY_SLOTS


---@enum APIARY_SLOTS The slots in an Apiary
---
local APIARY_SLOTS = {
    drone = 2,
    princess = 1,
    ---@type integer[]
    frames = {10, 11, 12}
}


---Creates a new Apiary
---@param side Side
---@return Apiary
---
local function createApiary(side)
    local inventory = Inventory(side)

    local apiary = setmetatable({
        slots = APIARY_SLOTS
    }, {__index = inventory}) --[[@as Apiary]]

    return apiary
end


return createApiary
