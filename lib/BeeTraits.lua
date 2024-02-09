local FromNative = require "FromNative"
local booleanToInt = require "util".booleanToInt


---@alias Fertility 1 | 2 | 3 | 4


---@alias Territory
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
---| 1 # Down 3
---| 2 # Down 2
---| 3 # Down 1
---| 4 # None
---| 5 # Up 1
---| 6 # Up 2
---| 7 # Up 3
---| 8 # Both 1
---| 9 # Both 2
---| 10 # Both 3


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
    local territory = FromNative.territory(native_bee_traits.territory[1])
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

    local traits = (fertility << 37) |
        (territory << 34) |
        (pollination << 30) |
        (production_speed << 26) |
        (flower << 21) |
        (effect << 15) |
        (lifespan << 11) |
        (temperature_tolerance << 7) |
        (booleanToInt(tolerant_flyer) << 6) |
        (booleanToInt(nocturnal) << 5) |
        (booleanToInt(cave_dwelling) << 4) |
        humidity_tolerance

    table.insert(data, traits)

    local instance = setmetatable(data, {__index = BeeTraits}) --[[@as BeeTraits]]
    return instance
end


---@return Fertility
function BeeTraits:getFertility()
    return (self[2] & 0xE000000000) >> 37
end


---@return Territory
function BeeTraits:getTerritory()
    return (self[2] & 0x1C00000000) >> 34
end


---@return Pollination
function BeeTraits:getPollination()
    return (self[2] & 0x3C0000000) >> 30
end


---@return ProductionSpeed
function BeeTraits:getProductionSpeed()
    return (self[2] & 0x3C000000) >> 26
end


---@return Flower
function BeeTraits:getFlower()
    return (self[2] & 0x3E00000) >> 21
end


---@return Effect
function BeeTraits:getEffect()
    return (self[2] & 0x1F8000) >> 15
end


---@return string
function BeeTraits:getSpecies()
    return self[1]
end


---@return Lifespan
function BeeTraits:getLifespan()
    return (self[2] & 0x7800) >> 11
end


---@return Tolerance
function BeeTraits:getTemperatureTolerance()
    return (self[2] & 0x780) >> 7
end


---@return boolean
function BeeTraits:isTolerantFlyer()
    return (self[2] & 0x40) == 0x40
end


---@return boolean
function BeeTraits:isNocturnal()
    return (self[2] & 0x20) == 0x20
end


---@return boolean
function BeeTraits:isCaveDwelling()
    return (self[2] & 0x10) == 0x10
end


---@return Tolerance
function BeeTraits:getHumidityTolerance()
    return self[2] & 0xF
end


return BeeTraits
