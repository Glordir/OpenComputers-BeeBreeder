local BeeContainer = require "BeeContainer"
local Component = require "component"
local Log = require "log"
local filter = require("util").filter
local Transposer = require "Transposer"

---@class BasicManager The basic manager of all physical connections and interactions.
---@field apiaries Apiary[]
---@field chests Chest[]
---@field transposer Transposer
local BasicManager = {}


---
---Initializes the basic manager.
---
---This function will find all connected chests and apiaries and store them.
function BasicManager.init()
    BasicManager.transposer = Transposer(Component.transposer.address)
    BasicManager.apiaries = BasicManager.transposer:findApiaries()
    BasicManager.chests = BasicManager.transposer:findChests()
end


---Get all available bees
---
---This function checks all connected chests and returns all bees that are in them.
---
---@return BeeContainer
function BasicManager.getBees()
    local bee_container = BeeContainer()
    for _, chest in ipairs(BasicManager.chests) do
        bee_container:addBees(chest:getBees())
    end

    return bee_container
end


--function BasicManager.getEmptyApiaries()
--    return filter(BasicManager.apiaries, function (apiary) return apiary.isEmpty() end)
--end


function BasicManager.breed(apiary, princess, drone)
    BasicManager.transposer:movePrincess(princess, apiary)
    BasicManager.transposer:moveDrone(drone, apiary)
end


function BasicManager.sortAllBees(breeding_plan)
    Log.error("BasicManager.sortAllBees is not yet implemented")
end


---Move the passed be to the new location
---@param bee Bee
---@param new_location Location
---
function BasicManager.moveBee(bee, new_location)
    BasicManager.transposer:moveBee(bee, new_location)
end


---Move the passed bees to the new location
---@param bee_container BeeContainer
---@param new_location Location
---
function BasicManager.moveBees(bee_container, new_location)
    for _, bee in ipairs(bee_container:getBees()) do
        BasicManager.moveBee(bee, new_location)
    end
end


return BasicManager
