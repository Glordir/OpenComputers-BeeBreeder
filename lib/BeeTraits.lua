local FromNative = require "FromNative"
local booleanToInt = require "util".booleanToInt


---@alias Fertility 1 | 2 | 3 | 4


---@alias Area
---| 1 # Average: 9x6x9
---| 2 # Large: 11x8x11
---| 3 # Larger: 13x?x13
---| 4 # Largest: 15x13x15


---@alias Pollination
---| 1 # Slowest: 5
---| 2 # Slower: 10
---| 3 # Slow: 15
---| 4 # Normal: 20
---| 5 # Fast: 25
---| 6 # Faster: 30
---| 7 # Fastest: 35
---| 8 # Maximum: 99


---@alias ProductionSpeed
---| 1 # Slowest: 0.3
---| 2 # Slower: 0.6
---| 3 # Slow: 0.8
---| 4 # Normal: 1.0
---| 5 # Fast: 1.2
---| 6 # Faster: 1.4
---| 7 # Fastest: 1.7
---| 8 # Blinding: 2.0


---@alias Lifespan
---| 1 # Shortest 10
---| 2 # Shorter 20
---| 3 # Short 30
---| 4 # Shortened 35
---| 5 # Normal 40
---| 6 # Elongated 45
---| 7 # Long 50
---| 8 # Longer 60
---| 9 # Longest 70


---@alias Tolerance
---| 1 # None
---| 2 # Down 1
---| 3 # Up 1
---| 4 # Down 2
---| 5 # Up 2
---| 6 # Down 3
---| 7 # Up 3
---| 8 # Down 4
---| 9 # Up 4
---| 10 # Down 5
---| 11 # Up 5
---| 12 # Both 1
---| 13 # Both 2
---| 14 # Both 3
---| 15 # Both 4
---| 16 # Both 5


---@class BeeTraits
---@field private traits integer
---@field private species string
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

    local instance = setmetatable(data, {__index = BeeTraits, __tostring = BeeTraits.toString, __eq = BeeTraits.eq})
    return instance
end


---Returns a copy of the BeeTraits instance
---@return BeeTraits
function BeeTraits:copy()
    local data = {}
    table.insert(data, self[1])
    table.insert(data, self[2])

    return setmetatable(data, getmetatable(self))
end


---@param fertility Fertility
function BeeTraits:setFertility(fertility)
    self[2] = (self[2] & ~0x38000000000) | (fertility << 39)
end


---@param area Area
function BeeTraits:setArea(area)
    self[2] = (self[2] & ~0x7000000000) | (area << 36)
end


---@param pollination Pollination
function BeeTraits:setPollination(pollination)
    self[2] = (self[2] & ~0xF00000000) | (pollination << 32)
end


---@param speed ProductionSpeed
function BeeTraits:setProductionSpeed(speed)
    self[2] = (self[2] & ~0xF0000000) | (speed << 28)
end


---@param flower Flower
function BeeTraits:setFlower(flower)
    self[2] = (self[2] & ~0xF800000) | (flower << 23)
end


---@param effect Effect
function BeeTraits:setEffect(effect)
    self[2] = (self[2] & ~0x7E0000) | (effect << 17)
end


---@param species string
function BeeTraits:setSpecies(species)
    self[1] = species
end


---@param lifespan Lifespan
function BeeTraits:setLifespan(lifespan)
    self[2] = (self[2] & ~0x1E000) | (lifespan << 13)
end


---@param tolerance Tolerance
function BeeTraits:setTemperatureTolerance(tolerance)
    self[2] = (self[2] & ~0x1F00) | (tolerance << 8)
end


---@param is_tolerant_flyer boolean
function BeeTraits:setTolerantFlyer(is_tolerant_flyer)
    self[2] = (self[2] & ~0x80) | (booleanToInt(is_tolerant_flyer) << 7)
end


---@param is_nocturnal boolean
function BeeTraits:setNocturnal(is_nocturnal)
    self[2] = (self[2] & ~0x40) | (booleanToInt(is_nocturnal) << 6)
end


---@param is_cave_dwelling boolean
function BeeTraits:setCaveDwelling(is_cave_dwelling)
    self[2] = (self[2] & ~0x20) | (booleanToInt(is_cave_dwelling) << 5)
end


---@param tolerance Tolerance
function BeeTraits:setHumidityTolerance(tolerance)
    self[2] = (self[2] & ~0x1F) | tolerance
end


---@return Fertility
function BeeTraits:getFertility()
    return (self[2] & 0x38000000000) >> 39
end


---@return Area
function BeeTraits:getArea()
    return (self[2] & 0x7000000000) >> 36
end


---@return Pollination
function BeeTraits:getPollination()
    return (self[2] & 0xF00000000) >> 32
end


---@return ProductionSpeed
function BeeTraits:getProductionSpeed()
    return (self[2] & 0xF0000000) >> 28
end


---@return Flower
function BeeTraits:getFlower()
    return (self[2] & 0xF800000) >> 23
end


---@return Effect
function BeeTraits:getEffect()
    return (self[2] & 0x7E0000) >> 17
end


---@return string
function BeeTraits:getSpecies()
    return self[1]
end


---@return Lifespan
function BeeTraits:getLifespan()
    return (self[2] & 0x1E000) >> 13
end


---@return Tolerance
function BeeTraits:getTemperatureTolerance()
    return (self[2] & 0x1F00) >> 8
end


---@return boolean
function BeeTraits:isTolerantFlyer()
    return (self[2] & 0x80) == 0x80
end


---@return boolean
function BeeTraits:isNocturnal()
    return (self[2] & 0x40) == 0x40
end


---@return boolean
function BeeTraits:isCaveDwelling()
    return (self[2] & 0x20) == 0x20
end


---@return Tolerance
function BeeTraits:getHumidityTolerance()
    return self[2] & 0x1F
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
    return self[1] == other[1] and self[2] == other[2]
end


return BeeTraits
