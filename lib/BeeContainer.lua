local Bee = require "Bee"
local BeeTraits = require "BeeTraits"
local Log = require "log"


---@class BeeContainer
---@field private bees Bee[]
---@field private highest_bee_traits BeeTraits?
---@field private lowest_bee_traits BeeTraits?
---@field private species table<string, boolean> A Set, if species["Noble"] == true then this container contains a Noble bee
---@field private flowers table<Flower, boolean> A Set, if flowers["Cacti"] == true then this container contains a bee that requires a cactus as a flower
---
local BeeContainer = setmetatable({}, {__call = function (bee_container)
    return bee_container.new()
end})


---Constructor for the BeeContainer class
---@return BeeContainer
---
function BeeContainer.new()
    return setmetatable({
        bees = {},
        flowers = {},
        species = {}
    }, {__index = BeeContainer})
end


---Adds the passed bees to the internal bee list.
---@param bee_container BeeContainer
---
function BeeContainer:addBees(bee_container)
    for _, bee in ipairs(bee_container:getBees()) do
        self:addBee(bee)
    end
end


---Adds the passed bee to the internal bee list.
---@param bee Bee
---
function BeeContainer:addBee(bee)
    table.insert(self.bees, bee)
    self:updateStatistics(bee)
end


---Adds the passed bee to the internal bee list
---@param native_bee table
---@param side Side
---@param slot integer
---
function BeeContainer:addNativeBee(native_bee, side, slot)
    local bee = Bee(native_bee, side, slot)
    self:addBee(bee)
end


---Updates the highest_bee_traits, lowest_bee_traits and species to include the passed bee 
---@param bee Bee
function BeeContainer:updateStatistics(bee)
    if not bee:isAnalyzed() then
        return
    end

    if self.highest_bee_traits == nil then
        self.highest_bee_traits = bee.active:copy()
        self.highest_bee_traits:setSpecies("")
        self.highest_bee_traits:setFlower(1)

        self.lowest_bee_traits = bee.active:copy()
        self.lowest_bee_traits:setSpecies("")
        self.lowest_bee_traits:setFlower(1)
    end

    self:updateStatisticsTrait(bee, BeeTraits.getFertility, BeeTraits.setFertility)
    self:updateStatisticsTrait(bee, BeeTraits.getTerritory, BeeTraits.setTerritory)
    self:updateStatisticsTrait(bee, BeeTraits.getPollination, BeeTraits.setPollination)
    self:updateStatisticsTrait(bee, BeeTraits.getProductionSpeed, BeeTraits.setProductionSpeed)
    self:updateStatisticsTrait(bee, BeeTraits.getEffect, BeeTraits.setEffect)
    self:updateStatisticsTrait(bee, BeeTraits.getLifespan, BeeTraits.setLifespan)
    self:updateStatisticsTrait(bee, BeeTraits.getTemperatureTolerance, BeeTraits.setTemperatureTolerance)
    self:updateStatisticsTrait(bee, BeeTraits.getHumidityTolerance, BeeTraits.setHumidityTolerance)

    self:updateStatisticsBooleanTrait(bee, BeeTraits.isTolerantFlyer, BeeTraits.setTolerantFlyer)
    self:updateStatisticsBooleanTrait(bee, BeeTraits.isNocturnal, BeeTraits.setNocturnal)
    self:updateStatisticsBooleanTrait(bee, BeeTraits.isCaveDwelling, BeeTraits.setCaveDwelling)

    self.species[bee.active:getSpecies()] = true
    self.species[bee.inactive:getSpecies()] = true

    self.flowers[bee.active:getFlower()] = true
    self.flowers[bee.inactive:getFlower()] = true
end


---Updates the trait in highest_bee_traits and lowest_bee_traits to include the passed bee 
---@generic T
---@param bee Bee
---@param getTrait fun(bee: BeeTraits):`T`
---@param setTrait fun(bee: BeeTraits, trait: T)
function BeeContainer:updateStatisticsTrait(bee, getTrait, setTrait)
    local active_fertility = getTrait(bee.active)
    local inactive_fertility = getTrait(bee.inactive)
    local current_highest_fertility = getTrait(self.highest_bee_traits)
    local current_lowest_fertility = getTrait(self.lowest_bee_traits)

    setTrait(self.highest_bee_traits, math.max(active_fertility, inactive_fertility, current_highest_fertility))
    setTrait(self.lowest_bee_traits, math.min(active_fertility, inactive_fertility, current_lowest_fertility))
end


---Updates the boolean trait in highest_bee_traits and lowest_bee_traits to include the passed bee 
---@generic T
---@param bee Bee
---@param getBooleanTrait fun(bee: BeeTraits): boolean
---@param setBooleanTrait fun(bee: BeeTraits, boolean_trait: boolean)
function BeeContainer:updateStatisticsBooleanTrait(bee, getBooleanTrait, setBooleanTrait)
    local active_fertility = getBooleanTrait(bee.active)
    local inactive_fertility = getBooleanTrait(bee.inactive)
    local current_highest_fertility = getBooleanTrait(self.highest_bee_traits)
    local current_lowest_fertility = getBooleanTrait(self.lowest_bee_traits)

    setBooleanTrait(self.highest_bee_traits, active_fertility or inactive_fertility or current_highest_fertility)
    setBooleanTrait(self.lowest_bee_traits, active_fertility and inactive_fertility and current_lowest_fertility)
end


---Gets all the contained bees
function BeeContainer:getBees()
    return self.bees
end


---Gets all the lowest bee traits (if any bees exist)
---@return BeeTraits?
function BeeContainer:getLowestBeeTraits()
    return self.lowest_bee_traits
end


---Gets all the highest bee traits (if any bees exist)
---@return BeeTraits?
function BeeContainer:getHighestBeeTraits()
    return self.highest_bee_traits
end


---Get all contained species
---@return table<string, boolean> # With the species as the key
function BeeContainer:getSpecies()
    return self.species
end


---Get all the required flowers for all contained bees
---@return table<Flower, boolean> # With the flowers as the key
function BeeContainer:getFlowers()
    return self.flowers
end


return BeeContainer
