local Log = require "Log"
local BasicManager = require "BasicManager"
local Component = require "component"
local Transposer = require "Transposer"
local Chest = require "Chest"


---Find the input chest.
---@param transposer Transposer
---@return Chest
---
local function findInputChest(transposer)
    print("Make sure that the input chest contains the analyzed breeder bee (Magenta) and a bee with the target species.")
    print("The buffer chest needs to be empty!")
    print("To continue, press Enter ...")
    local _ = io.read()

    local input_chest = nil

    repeat
        for _, chest in ipairs(transposer:findChests()) do
            if chest.side > 1 then
                local contained_bees = chest:getBees():getBees()
                if next(contained_bees) ~= nil then
                    input_chest = chest
                end
            end
        end
    until input_chest ~= nil

    Log.debug("Found the input chest on side " .. tostring(input_chest.side) .. ".")
    return input_chest --[[@as Chest]]
end


---Find the buffer chest.
---@param transposer Transposer
---@param input_chest Chest
---@return Chest?
---
local function findBufferChest(transposer, input_chest)
    for _, chest in ipairs(transposer:findChests()) do
        if chest.side > 1 and chest.side ~= input_chest.side then
            Log.debug("Found the buffer chest on side " .. tostring(chest.side) .. ".")
            return chest
        end
    end

    Log.warn("Couldn't find the buffer chest. (Reminder: It needs to be at the same height as the transposer)")
    return nil
end


---Construct the target bee traits from the breeder bee (Magenta) and the 2nd bee (target species) in the input chest.
---@param input_chest Chest
---@return BeeTraits?
---
local function findTargetBeeTraits(input_chest)
    local contained_bees = input_chest:getBees():getBees()
    local target_bee_traits

    for _, bee in ipairs(contained_bees) do
        if bee:getSpecies() == "Magenta" and bee:isAnalyzed() then
            target_bee_traits = bee.active:copy()
            Log.debug("Found the breeder bee (Magenta).")
        end
    end

    if target_bee_traits == nil then
        Log.warn("Unable to find the breeder bee (Magenta) in the input chest.")
        return nil
    end

    for _, bee in ipairs(contained_bees) do
        local bee_species = bee:getSpecies()
        if bee_species ~= "Magenta" then
            target_bee_traits:setSpecies(bee_species)
            Log.debug("Found the bee with the target species (" .. bee_species .. ").")

            return target_bee_traits
        end
    end

    Log.warn("Unable to find the bee with the target species in the input chest.")
    return nil
end


---Initializes the manager.
---@return BasicManager?
---
local function init()
	Log.debug("Started init")

    ---@type Transposer
    local transposer = Transposer(Component.transposer.address)

    local input_chest = findInputChest(transposer)
    local buffer_chest = findBufferChest(transposer, input_chest)
    -- The output chest is always at the bottom
    local output_chest = Chest(transposer, 0)
    local trash_can = transposer:findTrashCan()
    if trash_can == nil then
        Log.error("Unable to find the trash can.")
        return
    end

    local target_bee_traits = findTargetBeeTraits(input_chest)

    local manager = BasicManager(input_chest, buffer_chest, output_chest, trash_can, target_bee_traits)

	Log.debug("Finished init")
    return manager
end


---The main loop: Breeds a princess and a drone. Returns true until a pair with the best traits is found, or an error occures.
---@param manager BasicManager
---@return boolean
---
local function loop(manager)
	Log.debug("Started loop")

    manager:sortNewBees()

    if manager:isFinished() then
        Log.info("Found a pair with the best traits.")
        return false
    end

    if manager:isAlvearyEmpty() then
        local successfull_breeding = manager:breed()
	    Log.debug("Finished loop, returning " .. tostring(successfull_breeding))
        return successfull_breeding
    end

    Log.debug("Alveary is not empty.")
    Log.debug("Finished loop")
    return true
end


---Empty the buffer chest.
---@param manager BasicManager
---@return boolean # true if all the bees in the buffer chest were moved into other chests / the trash can.
---
local function cleanup(manager)
    return manager:cleanupBufferedFemale() and manager:cleanupBufferedDrones()
end


local function main()
	local manager = init()
    if manager == nil then
        return
    end

    local running = true

	while running do
		running = loop(manager)
        os.sleep(1)
	end

    cleanup(manager)

    Log.info("The program finished.")
end


main()
