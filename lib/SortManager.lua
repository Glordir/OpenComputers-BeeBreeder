local Component = require "component"
local Transposer = require "Transposer"
local BeeContainer = require "BeeContainer"
local Log = require "Log"


---@class SortManager
---@field private transposer Transposer
---@field private input_chest Chest
---@field private output_chest Chest
---@field private target_bee_traits IBeeTraits
---
local SortManager = setmetatable({}, {__call = function (manager, ...)
    return manager.new(...)
end})


---Constructor for the SortManager class
---@param input_chest Chest
---@param output_chest Chest # Needs to be a Compressed Chest
---@param target_bee_traits IBeeTraits
---@return SortManager
---
function SortManager.new(input_chest, output_chest, target_bee_traits)
    ---@type SortManager
    local instance = {
        transposer = Transposer(Component.transposer.address),
        input_chest = input_chest,
        output_chest = output_chest,
        target_bee_traits = target_bee_traits
    }

    return setmetatable(instance, {__index = SortManager})
end


---Return true if there are any bees in the input chests
---@return boolean
---
function SortManager:areBeesInInputChest()
    return next(self.input_chest:getBees():getBees()) ~= nil
end


---Moves all bees from the input chest to the correct column in the output chest.
function SortManager:sortAllBees()
    for _, bee in ipairs(self.input_chest:getBees():getBees()) do        
        local delta
        delta = self:getBeeDelta(bee)
        if bee.active:getSpecies() ~= self.target_bee_traits:getSpecies() and bee.inactive:getSpecies() ~= self.target_bee_traits:getSpecies() then
            delta = delta + 15
            if delta > 20 then
                delta = 20
            end
        end

        while not self:moveBeeIntoColumn(bee, delta + 1) do
            delta = delta + 1
        end
    end
end


---Calculates the difference between the passed bee and the target bee.
---@param bee Bee
---@return integer
function SortManager:getBeeDelta(bee)
    ---@type IBeeTraits[]
    local genes = {bee.active, bee.inactive}

    local delta = 0
    for _, gene in ipairs(genes) do
        if gene:getFertility() ~= self.target_bee_traits:getFertility() then
            delta = delta + 1
        end
        if gene:getArea() ~= self.target_bee_traits:getArea() then
            delta = delta + 1
        end
        if gene:getPollination() ~= self.target_bee_traits:getPollination() then
            delta = delta + 1
        end
        if gene:getProductionSpeed() ~= self.target_bee_traits:getProductionSpeed() then
            delta = delta + 1
        end
        if gene:getFlower() ~= self.target_bee_traits:getFlower() then
            delta = delta + 1
        end
        if gene:getEffect() ~= self.target_bee_traits:getEffect() then
            delta = delta + 1
        end
        if gene:getSpecies() ~= self.target_bee_traits:getSpecies() then
            delta = delta + 1
        end
        if gene:getLifespan() ~= self.target_bee_traits:getLifespan() then
            delta = delta + 1
        end
        if gene:getTemperatureTolerance() ~= self.target_bee_traits:getTemperatureTolerance() then
            delta = delta + 1
        end
        if gene:getHumidityTolerance() ~= self.target_bee_traits:getHumidityTolerance() then
            delta = delta + 1
        end
        if gene:isTolerantFlyer() ~= self.target_bee_traits:isTolerantFlyer() then
            delta = delta + 1
        end
        if gene:isNocturnal() ~= self.target_bee_traits:isNocturnal() then
            delta = delta + 1
        end
        if gene:isCaveDwelling() ~= self.target_bee_traits:isCaveDwelling() then
            delta = delta + 1
        end
    end

    return delta
end


---Move the passed bee into the specified column 
---@param bee any
---@param column any
---@return boolean
function SortManager:moveBeeIntoColumn(bee, column)
    local slot = column
    local moved_all_bees

    repeat
        moved_all_bees = self.transposer:moveBeeIntoSlot(bee, self.output_chest, slot)
        slot = slot + 27
    until moved_all_bees or slot > 243

    return moved_all_bees
end


return SortManager
