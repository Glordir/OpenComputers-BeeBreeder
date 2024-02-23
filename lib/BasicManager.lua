local Component = require "component"
local Evaluator = require "Evaluator"
local Log = require "Log"
local PriorityQueue = require "PriorityQueue"
local Transposer = require "Transposer"

---@class BasicManager The basic manager of all physical connections and interactions.
---@field alveary Alveary
---@field input_chest Chest
---@field buffer_chest Chest
---@field output_chest Chest
---@field transposer Transposer
---@field available_drones PriorityQueue
---@field evaluator Evaluator
---@field breeder_drones Bee[]
---@field female Bee?
---
local BasicManager = setmetatable({}, {__call = function (manager, ...)
    return manager.new(...)
end})


---Constructor for the BasicManager class
---@param input_chest Chest
---@param buffer_chest Chest
---@param output_chest Chest
---@param target_bee_traits BeeTraits
---@return BasicManager
---
function BasicManager.new(input_chest, buffer_chest, output_chest, target_bee_traits)
    local instance = {
        transposer = Transposer(Component.transposer.address) --[[@as Transposer]],
        input_chest = input_chest,
        buffer_chest = buffer_chest,
        output_chest = output_chest,
        available_drones = PriorityQueue(),
        evaluator = Evaluator(target_bee_traits),
        breeder_drones = {}
    }
    instance.alveary = instance.transposer:findAlveary()

    return setmetatable(instance, {__index = BasicManager})
end


---Get all new bees
---
---This functions returns all bees that are in the input chest.
---
---@return BeeContainer
function BasicManager:getNewBees()
    return self.input_chest:getBees()
end


function BasicManager:wasBeeMoved(bee)
    if bee == nil then
        return true
    end

    local slot = bee.location.slot
    local actual_bee = self.buffer_chest:getBee(bee.location.slot)
    if actual_bee == nil or actual_bee ~= bee then
        Log.warn("[BasicManager:wasBeeMoved] The bee in slot " .. tostring(slot) .. " was moved.")
        return true
    end
    return false
end


function BasicManager:useBreederDrone()
    for i = #self.breeder_drones, 1, -1 do
        local drone = self.breeder_drones[i]
        local drone_slot = drone.location.slot

        if self:wasBeeMoved(drone) then
            self.breeder_drones[i] = nil
            if i ~= 1 then
                Log.info("[BasicManager:useBreederDrone] Trying with another breeder drone stack.")
            else
                Log.warn("[BasicManager:breed] No breeder drones are left!")
                return false
            end
        else
            local drone_amount = self.transposer:getStackSize(self.buffer_chest.side, drone_slot)
            if drone_amount == 1 then
                self.breeder_drones[i] = nil
            end

            self.transposer:moveDrone(drone, self.alveary)
            return true
        end
    end

    return false
end


---Breed a princess and a drone
---@return boolean # false if an error occurred
function BasicManager:breed()
    if self.female == nil then
        Log.debug("[BasicManager:breed] Waiting for a princess/queen.")
        return true
    end

    -- Make sure that the princess/queen was not moved
    if self:wasBeeMoved(self.female) then
        return false
    end

    if self.female:isQueen() then
        self.transposer:moveFemale(self.female, self.alveary)
        self.female = nil
        return true
    end

    local princess_score = self.evaluator:getScore(self.female)

    -- If the princess has only 1 different species, or is a breeder princess
    if princess_score > 1 and princess_score ~= 1002 then
        if next(self.breeder_drones) == nil then
            Log.warn("[BasicManager:breed] No breeder drones are left!")
            return false
        end


        local found_breeder_drone = self:useBreederDrone()
        if not found_breeder_drone then
            return false
        end

        self.transposer:moveFemale(self.female, self.alveary)
        self.female = nil
        Log.info("[BasicManager:breed] Breeding a breeder drone with a princess with score " .. tostring(princess_score) .. ".")

        return true
    end

    -- If the princess has at least 2 non-target traits (and is not a breeder princess)
    if self.available_drones:empty() then
        Log.warn("[BasicManager:breed] No viable drones were found.")
        return false
    end
    local drone, priority = self.available_drones:peek()

    if self:wasBeeMoved(drone) then
        return false
    end

    if self.transposer:getStackSize(self.buffer_chest.side, drone.location.slot) == 1 then
        self.available_drones:pop()
    end

    self.transposer:moveDrone(drone, self.alveary)
    self.transposer:moveFemale(self.female, self.alveary)
    self.female = nil
    Log.info("[BasicManager:breed] Breeding a princess with score " .. tostring(princess_score) .. " with a drone with score " .. tostring(priority) .. ".")

    return true
end


function BasicManager:sortNewBees()
    local new_bees = self:getNewBees():getBees()

    for _, bee in ipairs(new_bees) do
        if bee:isDrone() then
            local started_new_stack = self:bufferBee(bee)
            if started_new_stack then
                local score = self.evaluator:getScore(bee)
                self.available_drones:put(bee, score)

                if score == 1002 then
                    table.insert(self.breeder_drones, bee)
                end
            end
        else
            self.female = bee
            self:bufferBee(bee)
        end
    end
end


function BasicManager:bufferBee(bee)
    for slot = 1, 243 do
        local moved_all, moved_amount = self.transposer:moveBeeIntoSlot(bee, self.buffer_chest, slot)
        if moved_all then
            bee:setLocation(self.buffer_chest, slot)

            local new_stack_size = self.transposer:getStackSize(self.buffer_chest.side, slot)
            return new_stack_size == moved_amount
        end
    end
end


---Returns true if both a princess and a drone with the best traits exist in the buffer chest.
---@return boolean
function BasicManager:isFinished()
    if self.female ~= nil and self.female:isPrincess() and self.evaluator:getScore(self.female) == 0 and not self:wasBeeMoved(self.female) and not self.available_drones:empty() then
        local drone, drone_score = self.available_drones:peek()
        return drone_score == 0 and not self:wasBeeMoved(drone)
    end
    return false
end


---Tries to move the princess/queen and at most 1 stack of the best drones into the output chest.
function BasicManager:moveBestBeesToOutput()
    if self.female == nil then
        Log.info("[BasicManager:moveBestBeesToOutput] No princess/queen found.")
    elseif self:wasBeeMoved(self.female) then
        local score = self.evaluator:getScore(self.female)
        Log.warn("[BasicManager:moveBestBeesToOutput] The princess/queen (score " .. tostring(score) ..") was moved.")
    else
        local moved_amount = self.transposer:moveBeeIntoChest(self.female, self.output_chest)
        local score = self.evaluator:getScore(self.female)
        if moved_amount == 0 then
            Log.info("[BasicManager:moveBestBeesToOutput] The princess/queen (score " .. tostring(score) ..") couldn't be moved into the output chest.")
        else
            self.female = nil
            Log.info("[BasicManager:moveBestBeesToOutput] The princess/queen with score " .. tostring(score) .. " was moved into the output chest.")
        end
    end

    if self.available_drones:empty() then
        Log.info("[BasicManager:moveBestBeesToOutput] No good drones were found.")
        return
    end
    local drone, score = self.available_drones:peek()

    if self:wasBeeMoved(drone) then
        Log.warn("[BasicManager:moveBestBeesToOutput] The best drone (score " .. tostring(score) ..") was moved.")
    else
        local amount_of_drones = self.transposer:getStackSize(self.buffer_chest.side, drone.location.slot)
        local moved_amount = self.transposer:moveBeeIntoChest(drone, self.output_chest)
        if moved_amount == 0 then
            Log.info("[BasicManager:moveBestBeesToOutput] The drone (score " .. tostring(score) ..") couldn't be moved into the output chest.")
        elseif moved_amount ~= amount_of_drones then
            Log.info("[BasicManager:moveBestBeesToOutput] Not all of the best drones (score " .. tostring(score) .. " could be moved into the output chest.")
        else
            self.available_drones:pop()
            Log.info("[BasicManager:moveBestBeesToOutput] The drones with score " .. tostring(score) .. " were moved into the output chest.")
        end
    end
end


function BasicManager:isAlvearyEmpty()
    return self.transposer:getStackSize(self.alveary.side, self.alveary.slots.princess --[[@as integer]]) == 0
end


return BasicManager
