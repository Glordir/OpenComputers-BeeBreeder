local Component = require "component"
local SortManager = require "SortManager"
local Transposer = require "Transposer"
local Log = require "Log"


---Get the target bee traits, input chest and output chest.
---@return BeeTraits target_bee_traits
---@return Chest input_chest
---@return Chest output_chest
---
local function getConfig()
    print("Make sure that all connected chests contain 0 bees.")
    print("To continue, press Enter ...")
    local _ = io.read()

    local transposer = Transposer(Component.transposer.address) --[[@as Transposer]]
    local input_chest = nil
    local breeder_bee_traits = nil

    print("Put the breeder bee (with best traits) into the input chest. It needs to be analyzed")
    repeat
        for _, chest in ipairs(transposer:findChests()) do
            local contained_bees = chest:getBees():getBees()
            if next(contained_bees) ~= nil then
                if contained_bees[1]:isAnalyzed() then
                    input_chest = chest
                    breeder_bee_traits = contained_bees[1].active:copy()
                else
                    Log.info("The breeder bee is not analyzed.")
                end
            end
        end
    until input_chest ~= nil and breeder_bee_traits ~= nil
    Log.info("Found the breeder bee (" .. breeder_bee_traits:getSpecies() .. ") in the chest on side " .. input_chest.side .. ".")

    local output_chest = nil
    local target_species = nil

    print("Put a bee with the target species into the output chest.")
    repeat
        for _, chest in ipairs(transposer:findChests()) do
            local contained_bees = chest:getBees():getBees()
            if next(contained_bees) ~= nil then
                local species = contained_bees[1]:getSpecies()
                if species ~= breeder_bee_traits:getSpecies() then
                    output_chest = chest
                    target_species = species
                end
            end
        end
    until output_chest ~= nil and target_species ~= nil
    breeder_bee_traits:setSpecies(target_species)
    Log.info("Found the target species (" .. breeder_bee_traits:getSpecies() .. ") in the chest on side " .. output_chest.side .. ".")

    return breeder_bee_traits, input_chest, output_chest
end


local function main()
    print("Disclaimer: This program will ignore all items that are not analyzed bees.\n")

    local target_bee, input_chest, output_chest = getConfig()
    Log.debug(target_bee, input_chest, output_chest)
    local sort_manager = SortManager(input_chest, output_chest, target_bee)

    while true do
        sort_manager:sortAllBees()
    end
end


main()
