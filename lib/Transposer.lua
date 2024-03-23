local Apiary = require "Apiary"
local Alveary = require "Alveary"
local Chest = require "Chest"
local Component = require "component"
local Inventory = require "Inventory"
local Log = require "Log"
local Config = require "Config"


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


---Move the bee into the specified inventory.
---@param bee Bee
---@param inventory Inventory
---@param amount integer? # Default value: all the bees in the slot
---@return boolean # True if all bees were successfully moved
---@return integer amount # The amount of bees that were successfully moved
---
function Transposer:moveBeeIntoInventory(bee, inventory, amount)
    local bees_in_slot = self.proxy.getSlotStackSize(bee.location.side, bee.location.slot)
    amount = amount or bees_in_slot

    local moved_amount = self.proxy.transferItem(bee.location.side, inventory.side, amount, bee.location.slot)
    return moved_amount == amount, moved_amount
end


---Move the bee into the specified slot in the specified chest.
---@param bee Bee
---@param chest Chest
---@param target_slot integer
---@param amount integer? # Default value: all the bees in the slot
---@return boolean # True if all bees were successfully moved
---@return integer amount # The amount of bees that were successfully moved
---
function Transposer:moveBeeIntoSlot(bee, chest, target_slot, amount)
    local bees_in_slot = self.proxy.getSlotStackSize(bee.location.side, bee.location.slot)
    amount = amount or bees_in_slot

    local moved_amount = self.proxy.transferItem(bee.location.side, chest.side, amount, bee.location.slot, target_slot)
    return moved_amount == amount, moved_amount
end


---Gets all items in the specified inventory
---@param side Side
---@return table[]? # The slot where the item is is equal to the index in the table + 1
---
function Transposer:getItems(side)
    if self.proxy.getInventorySize(side) == nil then
        return nil
    end

    return self.proxy.getAllStacks(side).getAll()
end


---Gets all items in the specified inventory
---@param side Side
---@param slot integer
---@return table[]
---
function Transposer:getItemInSlot(side, slot)
    return self.proxy.getStackInSlot(side, slot)
end


---Gets the size of the stack in the specified slot in the specified inventory
---@param side Side
---@param slot integer
---@return integer?
---
function Transposer:getStackSize(side, slot)
    if self.proxy.getInventorySize(side) == nil then
        return nil
    end

    return self.proxy.getSlotStackSize(side, slot)
end


---Returns the breeder block, if it is connected
---@return BreederBlock?
---
function Transposer:findBreederBlock()
    local alveary = self:findAlveary()
    if alveary ~= nil then
        return alveary
    end

    local apiaries = self:findApiaries()
    local apiary_count = #apiaries
    if apiary_count == 0 then
        Log.warn("Found no alveary and no apiary!")
    elseif apiary_count > 1 then
        Log.warn("Found more than 1 apiary!")
    else
        return apiaries[1]
    end
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
            table.insert(apiaries, Apiary(side, self))
        end
    end

    return apiaries
end


---Returns the alveary, if it is connected
---@return Alveary?
---
function Transposer:findAlveary()
    for side = 0, 5 do
        local name = self.proxy.getInventoryName(side)
        if name == "tile.for.alveary" then
            return Alveary(side, self)
        end
    end
end


---Returns an array of all connected input chests
---@return Chest[]
---
function Transposer:findInputChests()
    ---@type Chest[]
    local chests = {}
    for side = 0, 5 do
        local name = self.proxy.getInventoryName(side)
        if name == Config.inputInventoryName then
            table.insert(chests, Chest(self, side))
        end
    end

    return chests
end


---Returns an array of all connected output chests
---@return Chest[]
---
function Transposer:findOutputChests()
    ---@type Chest[]
    local chests = {}
    for side = 0, 5 do
        local name = self.proxy.getInventoryName(side)
        if name == Config.outputInventoryName then
            table.insert(chests, Chest(self, side))
        end
    end

    return chests
end


---Returns the inventory corresponding to the trash output.
---@return Inventory?
---
function Transposer:findTrashCan()
    for side = 0, 5 do
        local name = self.proxy.getInventoryName(side)
        if Config.trashInventoryNames[name] == true then
            return Inventory(side)
        end
    end
    return nil
end


return Transposer
