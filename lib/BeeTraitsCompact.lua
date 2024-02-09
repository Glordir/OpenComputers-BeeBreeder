local FromNative = require "FromNative"
local booleanToInt = require "util".booleanToInt


---@class BeeTraitsCompact
---@field private traits integer
---@field private species string
---
local BeeTraitsCompact = setmetatable({}, {__call = function (bee_traits_compact, ...)
    return bee_traits_compact.new(...)
end})


---Constructor for the BeeTraitsCompact class
---@param native_bee_traits table
---@return BeeTraitsCompact
---
function BeeTraitsCompact.new(native_bee_traits)
    local data = {}
    table.insert(data, native_bee_traits.species.name)

    local fertility = native_bee_traits.fertility
    local territory = FromNative.territory(native_bee_traits.territory[0])
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

    local traits = (fertility << 36) |
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

    local instance = setmetatable(data, {__index = BeeTraitsCompact}) --[[@as BeeTraitsCompact]]
    return instance
end


---@return Fertility
function BeeTraitsCompact:getFertility()
    return (self[2] & 0x7000000000) >> 36
end


---@return Territory
function BeeTraitsCompact:getTerritory()
    return (self[2] & 0xC00000000) >> 34
end


---@return Pollination
function BeeTraitsCompact:getPollination()
    return (self[2] & 0x3C0000000) >> 30
end


---@return ProductionSpeed
function BeeTraitsCompact:getProductionSpeed()
    return (self[2] & 0x3C000000) >> 26
end


---@return Flower
function BeeTraitsCompact:getFlower()
    return (self[2] & 0x3E00000) >> 21
end


---@return Effect
function BeeTraitsCompact:getEffect()
    return (self[2] & 0x1F8000) >> 15
end


---@return string
function BeeTraitsCompact:getSpecies()
    return self[1]
end


---@return Lifespan
function BeeTraitsCompact:getLifespan()
    return (self[2] & 0x7800) >> 11
end


---@return Tolerance
function BeeTraitsCompact:getTemperatureTolerance()
    return (self[2] & 0x780) >> 7
end


---@return boolean
function BeeTraitsCompact:isTolerantFlyer()
    return (self[2] & 0x40) == 0x40
end


---@return boolean
function BeeTraitsCompact:isNocturnal()
    return (self[2] & 0x20) == 0x20
end


---@return boolean
function BeeTraitsCompact:isCaveDwelling()
    return (self[2] & 0x10) == 0x10
end


---@return Tolerance
function BeeTraitsCompact:getHumidityTolerance()
    return self[2] & 0xF
end


return BeeTraitsCompact
