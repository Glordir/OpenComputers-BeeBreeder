local BeeTraits = require "BeeTraits"
local Location = require "Location"
local Log = require "log"


---@alias Gender
---| 1 # Drone
---| 2 # Princess
---| 3 # Queen


---@class Bee
---@field public active BeeTraits? Only exists for bees that are analyzed
---@field public gender Gender
---@field public inactive BeeTraits? Only exists for bees that are analyzed
---@field public location Location
---@field private species string? Only exists for bees that are not analyzed
---
local Bee = setmetatable({}, {__call = function (bee, ...)
    return bee.new(...)
end})


---Constructor for the BeeV2 class
---@param native_bee table
---@param side Side
---@param slot integer
---@return Bee
---
function Bee.new(native_bee, side, slot)
    local data = {}

    data.location = Location(side, slot)

    if native_bee.name == "Forestry:beeDroneGE" then
        data.gender = 1
    elseif native_bee.name == "Forestry:beePrincessGE" then
        data.gender = 2
    elseif native_bee.name == "Forestry:beeQueenGE" then
        data.gender = 3
    else
        Log.warn("[Bee.new] passed item is not a bee, creating default bee")
        data.gender = 1
        data.is_analyzed = false
        data.species = ""
        return setmetatable(data, {__index = Bee})
    end

    local individual = native_bee.individual
    data.is_analyzed = individual.isAnalyzed

    if data.is_analyzed then
        data.active = BeeTraits(individual.active)
        data.inactive = BeeTraits(individual.inactive)
    else
        data.species = individual.displayName
    end

    return setmetatable(data, {__index = Bee})
end


---@return string
function Bee:getSpecies()
    if self:isAnalyzed() then
        return self.active:getSpecies()
    else
        return self.species
    end
end


---Checks whether the bee is analyzed or not
---@return boolean
function Bee:isAnalyzed()
    return self.active ~= nil
end


return Bee
