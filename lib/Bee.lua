local BeeTraits = require "BeeTraitsCompressed"
local Location = require "Location"
local Log = require "Log"


---@alias Gender
---| 1 # Drone
---| 2 # Princess
---| 3 # Queen


---@class Bee
---@field public active IBeeTraits? Only exists for bees that are analyzed
---@field public inactive IBeeTraits? Only exists for bees that are analyzed
---@field public gender Gender
---@field public location Location
---@field private species string? Only exists for bees that are not analyzed
---
local Bee = setmetatable({}, {__call = function (bee, ...)
    return bee.new(...)
end})


---Constructor for the Bee class
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
        data.species = ""
        return setmetatable(data, {__index = Bee, __tostring = Bee.toString, __eq = Bee.eq})
    end

    local individual = native_bee.individual
    local is_analyzed = individual.isAnalyzed

    if is_analyzed then
        data.active = BeeTraits(individual.active)
        data.inactive = BeeTraits(individual.inactive)
    else
        data.species = individual.displayName
    end

    return setmetatable(data, {__index = Bee, __tostring = Bee.toString, __eq = Bee.eq})
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


---Returns true if the bee is a drone
---@return boolean
function Bee:isDrone()
    return self.gender == 1
end


---Returns true if the bee is a princess
---@return boolean
function Bee:isPrincess()
    return self.gender == 2
end


---Returns true if the bee is a queen
---@return boolean
function Bee:isQueen()
    return self.gender == 3
end


---Set the location of the bee
---@param inventory Inventory
---@param slot integer
---
function Bee:setLocation(inventory, slot)
    self.location.side = inventory.side
    self.location.slot = slot
end


---Returns the string representation of the bee
---@return string
function Bee:toString()
    return "Bee: { active: " .. tostring(self.active) ..
        ", inactive: " .. tostring(self.inactive) ..
        ", gender: " .. tostring(self.gender) ..
        ", location: " .. tostring(self.location) ..
        ", species: " .. tostring(self.species) .. " }"
end


---Checks if the passed bee is the same as self
---@param other Bee
---@return boolean
---
function Bee:eq(other)
    return self.location == other.location and self.gender == other.gender and self.active == other.active and self.inactive == other.inactive and self.species == other.species
end


return Bee
