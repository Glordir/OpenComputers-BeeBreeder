local FromNative = require "FromNative"
local booleanToInt = require "util".booleanToInt


---@class BeeTraitsCompressed: IBeeTraits
---@field private traits integer
---@field private species string
---
local BeeTraitsCompressed = setmetatable({}, {__call = function (bee_traits, ...)
    return bee_traits.new(...)
end})


---Constructor for the BeeTraitsCompressed class
---@param native_bee_traits table
---@return BeeTraitsCompressed
---
function BeeTraitsCompressed.new(native_bee_traits)
    local data = {}
    table.insert(data, native_bee_traits.species.name)

    local fertility = native_bee_traits.fertility
    local area = FromNative.area(native_bee_traits.territory[1])
    local pollination = FromNative.pollination(native_bee_traits.flowering)
    local production_speed = FromNative.productionSpeed(native_bee_traits.speed)
    local flower = FromNative.flower(native_bee_traits.flowerProvider)
    local effect = FromNative.effect(native_bee_traits.effect)
    local lifespan = FromNative.lifespan(native_bee_traits.lifespan)
    local temperature_tolerance = FromNative.tolerance(native_bee_traits.temperatureTolerance)
    local tolerant_flyer = native_bee_traits.tolerantFlyer
    local nocturnal = native_bee_traits.nocturnal
    local cave_dwelling = native_bee_traits.caveDwelling
    local humidity_tolerance = FromNative.tolerance(native_bee_traits.humidityTolerance)

    local traits = (fertility << 39) |
        (area << 36) |
        (pollination << 32) |
        (production_speed << 28) |
        (flower << 23) |
        (effect << 17) |
        (lifespan << 13) |
        (temperature_tolerance << 8) |
        (booleanToInt(tolerant_flyer) << 7) |
        (booleanToInt(nocturnal) << 6) |
        (booleanToInt(cave_dwelling) << 5) |
        humidity_tolerance

    table.insert(data, traits)

    local instance = setmetatable(data, {__index = BeeTraitsCompressed, __tostring = BeeTraitsCompressed.toString, __eq = BeeTraitsCompressed.eq})
    return instance
end


---Returns a copy of the BeeTraitsCompressed instance
---@return BeeTraitsCompressed
function BeeTraitsCompressed:copy()
    local data = {}
    table.insert(data, self[1])
    table.insert(data, self[2])

    return setmetatable(data, getmetatable(self))
end


---@param fertility Fertility
function BeeTraitsCompressed:setFertility(fertility)
    self[2] = (self[2] & ~0x38000000000) | (fertility << 39)
end


---@param area Area
function BeeTraitsCompressed:setArea(area)
    self[2] = (self[2] & ~0x7000000000) | (area << 36)
end


---@param pollination Pollination
function BeeTraitsCompressed:setPollination(pollination)
    self[2] = (self[2] & ~0xF00000000) | (pollination << 32)
end


---@param speed ProductionSpeed
function BeeTraitsCompressed:setProductionSpeed(speed)
    self[2] = (self[2] & ~0xF0000000) | (speed << 28)
end


---@param flower Flower
function BeeTraitsCompressed:setFlower(flower)
    self[2] = (self[2] & ~0xF800000) | (flower << 23)
end


---@param effect Effect
function BeeTraitsCompressed:setEffect(effect)
    self[2] = (self[2] & ~0x7E0000) | (effect << 17)
end


---@param species string
function BeeTraitsCompressed:setSpecies(species)
    self[1] = species
end


---@param lifespan Lifespan
function BeeTraitsCompressed:setLifespan(lifespan)
    self[2] = (self[2] & ~0x1E000) | (lifespan << 13)
end


---@param tolerance Tolerance
function BeeTraitsCompressed:setTemperatureTolerance(tolerance)
    self[2] = (self[2] & ~0x1F00) | (tolerance << 8)
end


---@param is_tolerant_flyer boolean
function BeeTraitsCompressed:setTolerantFlyer(is_tolerant_flyer)
    self[2] = (self[2] & ~0x80) | (booleanToInt(is_tolerant_flyer) << 7)
end


---@param is_nocturnal boolean
function BeeTraitsCompressed:setNocturnal(is_nocturnal)
    self[2] = (self[2] & ~0x40) | (booleanToInt(is_nocturnal) << 6)
end


---@param is_cave_dwelling boolean
function BeeTraitsCompressed:setCaveDwelling(is_cave_dwelling)
    self[2] = (self[2] & ~0x20) | (booleanToInt(is_cave_dwelling) << 5)
end


---@param tolerance Tolerance
function BeeTraitsCompressed:setHumidityTolerance(tolerance)
    self[2] = (self[2] & ~0x1F) | tolerance
end


---@return Fertility
function BeeTraitsCompressed:getFertility()
    return (self[2] & 0x38000000000) >> 39
end


---@return Area
function BeeTraitsCompressed:getArea()
    return (self[2] & 0x7000000000) >> 36
end


---@return Pollination
function BeeTraitsCompressed:getPollination()
    return (self[2] & 0xF00000000) >> 32
end


---@return ProductionSpeed
function BeeTraitsCompressed:getProductionSpeed()
    return (self[2] & 0xF0000000) >> 28
end


---@return Flower
function BeeTraitsCompressed:getFlower()
    return (self[2] & 0xF800000) >> 23
end


---@return Effect
function BeeTraitsCompressed:getEffect()
    return (self[2] & 0x7E0000) >> 17
end


---@return string
function BeeTraitsCompressed:getSpecies()
    return self[1]
end


---@return Lifespan
function BeeTraitsCompressed:getLifespan()
    return (self[2] & 0x1E000) >> 13
end


---@return Tolerance
function BeeTraitsCompressed:getTemperatureTolerance()
    return (self[2] & 0x1F00) >> 8
end


---@return boolean
function BeeTraitsCompressed:isTolerantFlyer()
    return (self[2] & 0x80) == 0x80
end


---@return boolean
function BeeTraitsCompressed:isNocturnal()
    return (self[2] & 0x40) == 0x40
end


---@return boolean
function BeeTraitsCompressed:isCaveDwelling()
    return (self[2] & 0x20) == 0x20
end


---@return Tolerance
function BeeTraitsCompressed:getHumidityTolerance()
    return self[2] & 0x1F
end


---Returns the string representation of the bee traits
---@return string
function BeeTraitsCompressed:toString()
    return "BeeTraitsCompressed: { Fert: " .. self:getFertility() ..
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
---@param other BeeTraitsCompressed
---@return boolean
---
function BeeTraitsCompressed:eq(other)
    return self[1] == other[1] and self[2] == other[2]
end


return BeeTraitsCompressed
