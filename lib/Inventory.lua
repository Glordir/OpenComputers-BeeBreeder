---@class Inventory
---@field side Side


---Creates a new Inventory
---@param side Side
---@return Inventory
---
local function createInventory(side)
    return {side = side}
end


return createInventory
