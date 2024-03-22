local Inventory = require "Inventory"
local Location = require "Location"


---@class BreederBlock: Inventory
---@field public new fun(side: Side, transposer: Transposer): BreederBlock
---@field public addPrincess fun(self: BreederBlock, princess: Bee)
---@field public addDrone fun(self: BreederBlock, drone: Bee)
---@field protected getPrincessSlot fun(): integer
---@field protected getDroneSlot fun(): integer
---
---@field public mayBreed fun(self: BreederBlock): boolean # Implement this in derived classes
---
---@field protected transposer Transposer
---
local BreederBlock = setmetatable({}, {__call = function (breeder_block, ...)
    return breeder_block.new(...)
end,
__index = Inventory
})


---Creates a new Breeder Block
---@param side Side
---@param transposer Transposer
---@return BreederBlock
---
function BreederBlock.new(side, transposer)
    local breeder_block = Inventory(side) --[[@as BreederBlock]]
    breeder_block.transposer = transposer

    return setmetatable(breeder_block, {__index = BreederBlock})
end


---Move the princess into the princess slot
---@param princess Bee
---
function BreederBlock:addPrincess(princess)
    self.transposer:moveBee(princess, Location(self.side, self:getPrincessSlot()))
end


---Move the drone into the drone slot
---@param drone Bee
---
function BreederBlock:addDrone(drone)
    self.transposer:moveBee(drone, Location(self.side, self:getDroneSlot()))
end


---Get the slot number for the princess
---@return integer
---
function BreederBlock.getPrincessSlot()
    return 1
end


---Get the slot number for the drone
---@return integer
---
function BreederBlock.getDroneSlot()
    return 2
end


return BreederBlock
