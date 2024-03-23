local Log = require "Log"
local BasicManager = require "BasicManager"
local Component = require "component"
local Transposer = require "Transposer"
local Chest = require "Chest"
local Config = require "Config"


---Find the input chest.
---@param transposer Transposer
---@return Chest
---
local function findInputChest(transposer)
    print("Make sure that the input chest contains the analyzed breeder bee (" .. Config.breederSpecies .. ") and a bee with the target species.")
    print("The buffer chest needs to be empty!")
    print("To continue, press Enter ...")
    local _ = io.read()

    local input_chest = nil

    repeat
        for _, chest in ipairs(transposer:findInputChests()) do
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
    -- Todo: Remove the buffer chest, for now it just uses a chest with the same type as the input chest
    for _, chest in ipairs(transposer:findInputChests()) do
        if chest.side > 1 and chest.side ~= input_chest.side then
            Log.debug("Found the buffer chest on side " .. tostring(chest.side) .. ".")
            return chest
        end
    end

    Log.error("Couldn't find the buffer chest. (Reminder: It needs to be at the same height as the transposer)")
    return nil
end


---Construct the target bee traits from the breeder bee and the 2nd bee (target species) in the input chest.
---@param input_chest Chest
---@return IBeeTraits?
---
local function findTargetBeeTraits(input_chest)
    local contained_bees = input_chest:getBees():getBees()
    local target_bee_traits

    for _, bee in ipairs(contained_bees) do
        if bee:getSpecies() == Config.breederSpecies and bee:isAnalyzed() then
            target_bee_traits = bee.active:copy()
            Log.info("Found the breeder bee (" .. Config.breederSpecies .. ").")
        end
    end

    if target_bee_traits == nil then
        Log.warn("Unable to find the breeder bee (" .. Config.breederSpecies .. ") in the input chest.")
        return nil
    end

    for _, bee in ipairs(contained_bees) do
        local bee_species = bee:getSpecies()
        if bee_species ~= Config.breederSpecies then
            target_bee_traits:setSpecies(bee_species)
            Log.info("Found the bee with the target species (" .. bee_species .. ").")

            return target_bee_traits
        end
    end

    Log.warn("Unable to find the bee with the target species in the input chest.")
    return nil
end


---Finds the connected inventories
---@return Chest? input_chest
---@return Chest? buffer_chest
---@return Chest? output_chest
---@return Inventory? trash_can
---
local function findInventories()
    ---@type Transposer
    local transposer = Transposer(Component.transposer.address)

    local input_chest = findInputChest(transposer)
    local buffer_chest = findBufferChest(transposer, input_chest)
    -- The output chest is always at the bottom
    local output_chest = Chest(transposer, 0)
    local trash_can = transposer:findTrashCan()

    if buffer_chest == nil then
        Log.error("Unable to find the buffer chest.")
        return
    elseif trash_can == nil then
        Log.error("Unable to find the trash can.")
        return
    end

    return input_chest, buffer_chest, output_chest, trash_can
end


---The main loop: Breeds a princess and a drone. Returns true until a pair with the best traits is found, or an error occures.
---@param manager BasicManager
---@return boolean
---
local function loop(manager)
    manager:sortNewBees()

    if manager:isFinished() then
        Log.info("Found a pair with the best traits.")
        return false
    end

    if manager:isBreederReady() then
        return manager:breed()
    end

    Log.debug("Breeder Block is not empty.")
    return true
end


---Empty the buffer chest.
---@param manager BasicManager
---@return boolean # true if all the bees in the buffer chest were moved into other chests / the trash can.
---
local function cleanup(manager)
    manager:sortNewBees()
    return manager:cleanupBufferedFemale() and manager:cleanupBufferedDrones()
end


local function breedNewSpecies(input_chest, buffer_chest, output_chest, trash_can)
    local target_bee_traits = findTargetBeeTraits(input_chest)
    local manager = BasicManager(input_chest, buffer_chest, output_chest, trash_can, target_bee_traits)
    if manager == nil then
        return
    end

    local running = true

	while running do
		running = loop(manager)
        os.sleep(1)
	end

    os.sleep(5)
    cleanup(manager)

    Log.info("Finished breeding species " .. target_bee_traits:getSpecies())
end


---Check if a non-breederSpecies bee is in the chests
---@param chest Chest
---@return boolean
---
local function isNewSpeciesAvailable(chest)
    local bees = chest:getBees():getBees()
    for _, bee in ipairs(bees) do
        if bee:getSpecies() ~= Config.breederSpecies then
            return true
        end
    end

    return false
end


local function main()
    Config.loadFromFile()

    local input_chest, buffer_chest, output_chest, trash_can = findInventories()
    local to_breed = isNewSpeciesAvailable(input_chest)

	while to_breed do
        local successfull = breedNewSpecies(input_chest, buffer_chest, output_chest, trash_can)
        if successfull == false then
            return
        end

        to_breed = isNewSpeciesAvailable(input_chest)
    end

    Log.info("No more new species found. Exiting program")
end


main()
