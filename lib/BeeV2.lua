local Log = require "log"
local BeeTraitsCompact = require "BeeTraitsCompact"


---@alias Gender
---| 1 # Drone
---| 2 # Princess
---| 3 # Queen


---@class BeeV2
---@field public active BeeTraits?
---@field public inactive BeeTraits?
---@field public is_analyzed boolean
---@field public gender Gender
---
local BeeV2 = setmetatable({}, {__call = function (bee, ...)
    return bee.new(...)
end})


---Constructor for the BeeV2 class
---@param native_bee any
---@return BeeV2
function BeeV2.new(native_bee)
    local data = {}

    if native_bee.name == "Forestry:beeDroneGE" then
        data.gender = 1
    elseif native_bee.name == "Forestry:beePrincessGE" then
        data.gender = 2
    elseif native_bee.name == "Forestry:beeQueenGE" then
        data.gender = 3
    else
        Log.warn("[BeeV2.new] passed item is not a bee, creating default bee")
        return setmetatable({gender = 1, is_analyzed = false}, {__index = BeeV2})
    end

    local individual = native_bee.individual
    data.is_analyzed = individual.is_analyzed

    if data.is_analyzed then
        data.active = BeeTraitsCompact(individual.active)
        data.inactive = BeeTraitsCompact(individual.inactive)
    end

    return setmetatable({data}, {__index = BeeV2})
end


return BeeV2
