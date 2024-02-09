local Log = require "Log"

---@class IManager
---@field __index IManager
---@field __metatable IManager
---@field new fun(): IManager
---@field getBees fun(): nil
---@field getEmptyApiaries fun(): table
---@field breed fun(apiary: Apiary, princess: Princess, drone: Drone): boolean
---@field sortAllBees fun(IBreedingPlan): nil
--- Interface of the Manager.
---
--- Manages all physical aspects of the Bee Breeder v2.
---
--- Can be called as a function to create a new instance of the Manager
---
local IManager = setmetatable({}, {__call = function (manager, ...) return manager.new(...) end})
IManager.__index = IManager


---
---Creates a new instance of an IManager
---
---This is only the abstract function definition, not a concrete implementation. This function will print an error.
---
---This function returns an `IManager`.
---
---@return IManager
function IManager.new()
    local instance = setmetatable({}, IManager)
    return instance
end

---
---Creates a new instance of an IManager
---
---This is only the abstract function definition, not a concrete implementation. This function will print an error.
---
---This function returns an `IManager`.
function IManager:getBees()
    Log.error("IManager doesn't implement 'getBees()'")
end


function IManager:getEmptyApiaries()
    Log.error("IManager doesn't implement 'getEmptyApiaries()'")
end


function IManager:breed(apiary, princess, drone)
    Log.error("IManager doesn't implement 'breed(apiary, princess, drone)'")
end


function IManager:sortAllBees(breeding_plan)
    Log.error("IManager doesn't implement 'sortAllBees(breeding_plan)'")
end


return IManager
