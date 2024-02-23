local Component = require "component"
local Transposer = require "Transposer"
local BeeContainer = require "BeeContainer"
local Log = require "Log"


---@class FilterManager
---@field private transposer Transposer
---@field private chests { [Side]: Chest }
---
local FilterManager = setmetatable({}, {__call = function (manager, ...)
    return manager.new()
end})


---Constructor for the FilterManager class
---@return FilterManager
---
function FilterManager.new()
    ---@type FilterManager
    local instance = {
        transposer = Transposer(Component.transposer.address),
        chests = {}
    }
    for _, chest in ipairs(instance.transposer:findChests()) do
        instance.chests[chest.side] = chest
    end

    return setmetatable(instance, {__index = FilterManager})
end


---Get all the bees in the specified chests.
---@param sides Side[]
---@return BeeContainer
---
function FilterManager:getBeesInChests(sides)
    local bee_container = BeeContainer()
    for _, side in ipairs(sides) do
        local chest = self.chests[side]
        if chest ~= nil then
            bee_container:addBees(chest:getBees())
        else
            Log.info("[FilterManager:getBeesInChests] There is no chest on side " .. side .. ". Ignoring this side.")
        end
    end

    return bee_container
end


---Move all the passed bees into the specified chests.
---@param bee_container BeeContainer
---@param target_side Side
---@return boolean moved_all # True if all the passed bees were moved.
---@return integer slots # The amount of item-stacks that were moved.
---@return integer bee_count # The amount of bees that were moved (>= slots).
---
function FilterManager:moveBeesIntoChest(bee_container, target_side)
    local chest = self.chests[target_side]
    if chest == nil then
        Log.info("[FilterManager:moveBeesIntoChest] There is no chest on side " .. target_side .. ". Ignoring the move command.")
        return false, 0, 0
    end

    local moved_all_bees = true
    local moved_bee_amount = 0
    local moved_stack_amount = 0
    for _, bee in ipairs(bee_container:getBees()) do
        local moved_all_bees_in_stack, amount = self.transposer:moveBeeIntoChest(bee, chest)

        moved_all_bees = moved_all_bees and moved_all_bees_in_stack
        if amount >= 1 then
            moved_bee_amount = moved_bee_amount + amount
            moved_stack_amount = moved_stack_amount + 1
        end
    end

    return moved_all_bees, moved_stack_amount, moved_bee_amount
end


return FilterManager
