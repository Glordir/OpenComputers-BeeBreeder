local FromNative = require "FromNative"


---@alias Fertility 1 | 2 | 3 | 4


---@alias Territory
---| 1 # Average: 9x6x9
---| 2 # Large: 11x8x11
---| 3 # Largest: 15x13x15


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
---@field private fertility Fertility
---@field private territory Territory
---@field private pollination Pollination
---@field private production_speed ProductionSpeed
---@field private flower Flower
---@field private effect Effect
---@field private species string
---@field private lifespan Lifespan
---@field private temperature_tolerance Tolerance
---@field private tolerant_flyer boolean
---@field private nocturnal boolean
---@field private cave_dwelling boolean
---@field private humidity_tolerance Tolerance
---
local BeeTraits = setmetatable({}, {__call = function (bee_traits, ...)
    return bee_traits.new(...)
end})


---Constructor for the BeeTraits class
---@param native_bee_traits table
---@return BeeTraits
---
function BeeTraits.new(native_bee_traits)
    local instance = setmetatable({
        fertility = native_bee_traits.fertility,
        territory = FromNative.territory(native_bee_traits.territory[0]),
        pollination = FromNative.pollination(native_bee_traits.flowering),
        production_speed = FromNative.productionSpeed(native_bee_traits.speed),
        flower = FromNative.flower(native_bee_traits.flowerProvider),
        effect = FromNative.effect(native_bee_traits.effect),
        species = native_bee_traits.species.name,
        lifespan = FromNative.lifespan(native_bee_traits.lifespan),
        temperature_tolerance = FromNative.tolerance(native_bee_traits.temperatureTolerance),
        tolerant_flyer = native_bee_traits.tolerantFlyer,
        nocturnal = native_bee_traits.nocturnal,
        cave_dwelling = native_bee_traits.caveDwelling,
        humidity_tolerance = FromNative.tolerance(native_bee_traits.humidityTolerance)
    },
    {__index = BeeTraits}) --[[@as BeeTraits]]

    return instance
end


---@return Fertility
function BeeTraits:getFertility()
    return self.fertility
end


---@return Territory
function BeeTraits:getTerritory()
    return self.territory
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


---@return string
function BeeTraits:getSpecies()
    return self.species
end


---@return Lifespan
function BeeTraits:getLifespan()
    return self.lifespan
end


---@return Tolerance
function BeeTraits:getTemperatureTolerance()
    return self.temperature_tolerance
end


---@return boolean
function BeeTraits:isTolerantFlyer()
    return self.tolerant_flyer
end


---@return boolean
function BeeTraits:isNocturnal()
    return self.nocturnal
end


---@return boolean
function BeeTraits:isCaveDwelling()
    return self.cave_dwelling
end


---@return Tolerance
function BeeTraits:getHumidityTolerance()
    return self.humidity_tolerance
end


return BeeTraits
