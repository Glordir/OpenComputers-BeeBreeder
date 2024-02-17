local BeeContainer = require "BeeContainer"
local Inventory = require "Inventory"


---@class Chest: Inventory
---@field transposer Transposer
---
local Chest = setmetatable({}, {__call = function (chest, ...)
    return chest.new(...)
end,
__index = Inventory}
)


---Creates a new instance of Chest
---@param transposer Transposer
---@param side Side
---@return Chest
---
function Chest.new(transposer, side)
    local chest = Inventory(side) --[[@as Chest]]
    chest.transposer = transposer
    return setmetatable(chest, {__index = Chest})
end


---Get all contained Bees
---@return BeeContainer
---
function Chest:getBees()
    local bees = BeeContainer()

    local all_items = self.transposer:getItems(self.side)
    if all_items == nil then
        return bees
    end

    for slot, item in pairs(all_items) do
        if next(item) ~= nil and item.name ~= nil and string.find(item.name, "^Forestry:bee[DPQ]") then
            bees:addNativeBee(item, self.side, slot + 1)
        end
    end

    return bees
end


return Chest
