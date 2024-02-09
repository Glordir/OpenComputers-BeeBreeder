local Apiary = require "Apiary"
local Chest = require "Chest"
local Component = require "component"
local Location = require "Location"


---@class Transposer
---@field private proxy table
---
local Transposer = setmetatable({}, {__call = function (transposer, ...)
    return transposer.new(...)
end})

Transposer.__index = Transposer


---Creates a new instance of Transposer
---@param address string
---@return Transposer
---
function Transposer.new(address)
    local instance = setmetatable({}, Transposer)
    instance.proxy = Component.proxy(address)
    return instance
end


---Move the princess into the princess slot of the apiary
---@param princess Bee
---@param apiary Apiary
---@return boolean true if the princess was moved
---
function Transposer:movePrincess(princess, apiary)
    return self:moveBee(princess, Location(apiary.side, apiary.slots.princess --[[@as number]]))
end


---Move the drone into the drone slot of the apiary
---@param drone Bee
---@param apiary Apiary
---@return boolean true if the drone was moved
---
function Transposer:moveDrone(drone, apiary)
    return self:moveBee(drone, Location(apiary.side, apiary.slots.drone --[[@as number]]))
end


---Move the bee into the specified location
---@param bee Bee
---@param new_location Location
---@return boolean true if the bee was moved
---
function Transposer:moveBee(bee, new_location)
    local inventory_size = self.proxy.getInventorySize(new_location.side)
    if inventory_size < new_location.slot then
        return false
    end

    local moved_item_count = self.proxy.transferItem(bee.location.side, new_location.side, 1, bee.location.slot, new_location.slot)
    return moved_item_count ~= 0
end


---Gets all items in the specified inventory
---@param side Side
---@return table[]?
function Transposer:getItems(side)
    if self.proxy.getInventorySize(side) == nil then
        return nil
    end

    return self.proxy.getAllStacks(side).getAll()
end


---Returns an array of all connected apiaries
---@return Apiary[]
---
function Transposer:findApiaries()
    ---@type Apiary[]
    local apiaries = {}
    for side = 0, 5 do
        local name = self.proxy.getInventoryName(side)
        if name == "tile.for.apiculture" then
            table.insert(apiaries, Apiary(side))
        end
    end

    return apiaries
end


---Returns an array of all connected chests
---
---Currently supports only Compressed Chests
---@return Chest[]
---
function Transposer:findChests()
    ---@type Chest[]
    local chests = {}
    for side = 0, 5 do
        local name = self.proxy.getInventoryName(side)
        if name == "tile.CompressedChest" then
            table.insert(chests, Chest(self, side))
        end
    end

    return chests
end


return Transposer
