local FromNative = require "FromNative"
local booleanToInt = require "util".booleanToInt


---@class BeeTraits: IBeeTraits
---@field private species string
---@field private fertility Fertility
---@field private area Area
---@field private pollination Pollination
---@field private production_speed ProductionSpeed
---@field private flower Flower
---@field private effect Effect
---@field private lifespan Lifespan
---@field private temperature_tolerance Tolerance
---@field private humidity_tolerance Tolerance
---@field private is_tolerant_flyer boolean
---@field private is_nocturnal boolean
---@field private is_cave_dwelling boolean
---
local BeeTraits = setmetatable({}, {__call = function (bee_traits, ...)
    return bee_traits.new(...)
end})


---Constructor for the BeeTraits class
---@param native_bee_traits table
---@return BeeTraits
---
function BeeTraits.new(native_bee_traits)
    local data = {}

    data.species = native_bee_traits.species.name
    data.fertility = native_bee_traits.fertility
    data.area = FromNative.area(native_bee_traits.territory[1])
    data.pollination = FromNative.pollination(native_bee_traits.flowering)
    data.production_speed = FromNative.productionSpeed(native_bee_traits.speed)
    data.flower = FromNative.flower(native_bee_traits.flowerProvider)
    data.effect = FromNative.effect(native_bee_traits.effect)
    data.lifespan = FromNative.lifespan(native_bee_traits.lifespan)
    data.temperature_tolerance = FromNative.tolerance(native_bee_traits.temperatureTolerance)
    data.tolerant_flyer = native_bee_traits.tolerantFlyer
    data.nocturnal = native_bee_traits.nocturnal
    data.cave_dwelling = native_bee_traits.caveDwelling
    data.humidity_tolerance = FromNative.tolerance(native_bee_traits.humidityTolerance)

    local instance = setmetatable(data, {__index = BeeTraits, __tostring = BeeTraits.toString, __eq = BeeTraits.eq})
    return instance
end


---Returns a copy of the BeeTraits instance
---@return BeeTraits
function BeeTraits:copy()
    local copy = {}
    for k, v in pairs(self) do
        copy[k] = v
    end

    return setmetatable(copy, getmetatable(self))
end


---@param species string
function BeeTraits:setSpecies(species)
    self.species = species
end


---@param fertility Fertility
function BeeTraits:setFertility(fertility)
    self.fertility = fertility
end


---@param area Area
function BeeTraits:setArea(area)
    self.area = area
end


---@param pollination Pollination
function BeeTraits:setPollination(pollination)
    self.pollination = pollination
end


---@param speed ProductionSpeed
function BeeTraits:setProductionSpeed(speed)
    self.production_speed = speed
end


---@param flower Flower
function BeeTraits:setFlower(flower)
    self.flower = flower
end


---@param effect Effect
function BeeTraits:setEffect(effect)
    self.effect = effect
end


---@param lifespan Lifespan
function BeeTraits:setLifespan(lifespan)
    self.lifespan = lifespan
end


---@param tolerance Tolerance
function BeeTraits:setTemperatureTolerance(tolerance)
    self.temperature_tolerance = tolerance
end


---@param tolerance Tolerance
function BeeTraits:setHumidityTolerance(tolerance)
    self.humidity_tolerance = tolerance
end


---@param is_tolerant_flyer boolean
function BeeTraits:setTolerantFlyer(is_tolerant_flyer)
    self.is_tolerant_flyer = is_tolerant_flyer
end


---@param is_nocturnal boolean
function BeeTraits:setNocturnal(is_nocturnal)
    self.is_nocturnal = is_nocturnal
end


---@param is_cave_dwelling boolean
function BeeTraits:setCaveDwelling(is_cave_dwelling)
    self.is_cave_dwelling = is_cave_dwelling
end


---@return string
function BeeTraits:getSpecies()
    return self.species
end


---@return Fertility
function BeeTraits:getFertility()
    return self.fertility
end


---@return Area
function BeeTraits:getArea()
    return self.area
end


---@return Pollination
function BeeTraits:getPollination()
    return self.pollination
end


---@return ProductionSpeed
function BeeTraits:getProductionSpeed()
    return self.production_speed
end


---@return Flower
function BeeTraits:getFlower()
    return self.flower
end


---@return Effect
function BeeTraits:getEffect()
    return self.effect
end


---@return Lifespan
function BeeTraits:getLifespan()
    return self.lifespan
end


---@return Tolerance
function BeeTraits:getTemperatureTolerance()
    return self.temperature_tolerance
end


---@return Tolerance
function BeeTraits:getHumidityTolerance()
    return self.humidity_tolerance
end


---@return boolean
function BeeTraits:isTolerantFlyer()
    return self.is_tolerant_flyer
end


---@return boolean
function BeeTraits:isNocturnal()
    return self.is_nocturnal
end


---@return boolean
function BeeTraits:isCaveDwelling()
    return self.is_cave_dwelling
end


---Returns the string representation of the bee traits
---@return string
function BeeTraits:toString()
    return "BeeTraits: { Fert: " .. self:getFertility() ..
        ", Area: " .. self:getArea() ..
        ", Poll: " .. self:getPollination() ..
        ", ProdSpeed: " .. self:getProductionSpeed() ..
        ", Flower: " .. self:getFlower() ..
        ", Eff: " .. self:getEffect() ..
        ", Spe: " .. self:getSpecies() ..
        ", Life: " .. self:getLifespan() ..
        ", TempTol: " .. self:getTemperatureTolerance() ..
        ", HumTol: " .. self:getHumidityTolerance() ..
        ", Rain: " .. tostring(self:isTolerantFlyer()) ..
        ", Night: " .. tostring(self:isNocturnal()) ..
        ", Cave: " .. tostring(self:isCaveDwelling()) .. " }"
end


---Checks if the passed bee trait is the same as self
---@param other BeeTraits
---@return boolean
---
function BeeTraits:eq(other)
    for k, v in pairs(self) do
        if other[k] ~= v then
            return false
        end
    end

    return true
end


return BeeTraits
