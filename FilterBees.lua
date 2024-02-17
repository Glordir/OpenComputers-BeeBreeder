local Log = require "log"
local BeeTraits = require "BeeTraits"
local FilterManager = require "FilterManager"


---@type { [string]: Side }
local char_to_side = {U = 1, D = 0, N = 2, E = 5, S = 3, W = 4}


---@type { [string]: fun(val1: string|integer|boolean, val2: string|integer|boolean): boolean }
local operator_to_function = {
    ["<="] = function (val1, val2) return val1 <= val2 end,
    ["<"] = function (val1, val2) return val1 < val2 end,
    [">="] = function (val1, val2) return val1 >= val2 end,
    [">"] = function (val1, val2) return val1 > val2 end,
    ["~="] = function (val1, val2) return val1 ~= val2 end,
    ["=="] = function (val1, val2) return val1 == val2 end
}


---@type { [string]: fun(traits: BeeTraits): string|integer|boolean }
local trait_to_getter = {
    s = BeeTraits.getSpecies,
    f = BeeTraits.getFertility,
    l = BeeTraits.getLifespan,
    p = BeeTraits.getProductionSpeed,
    t = BeeTraits.getTemperatureTolerance,
    h = BeeTraits.getHumidityTolerance,
    e = BeeTraits.getEffect,
    a = BeeTraits.getArea,
    w = BeeTraits.getFlower,
    x = BeeTraits.getPollination,
    r = BeeTraits.isTolerantFlyer,
    n = BeeTraits.isNocturnal,
    c = BeeTraits.isCaveDwelling
}

local function printChestSelectionMenu()
    print("----------------------------------------")
    print("Possible Chests:")
    print("[U] Up")
    print("[D] Down")
    print("[N] North")
    print("[E] East")
    print("[S] South")
    print("[W] West")
    print("----------------------------------------")
    print("Usage: <Source>+ <Target>")
    print("Example: 'N E', 'NESW U'")
end


local function printFilterSelectionMenu()
    print("----------------------------------------")
    print("Selectors:")
    print("\t[V] For all")
    print("\t[E] There exists")
    print("\t[Y] Clear Chest")
    print("\t[Z] Abort")
    print("----------------------------------------")
    print("Traits:")
    print("\t[s] Species")
    print("\t[f] Fertility (1-4)")
    print("\t[l] Lifespan (1-9)")
    print("\t[p] Production Speed (1-8)")
    print("\t[t] Temperature Tolerance (1-10)")
    print("\t[h] Humidity Tolerance (1-10)")
    print("\t[e] Effect (1-67)")
    print("\t[a] Area (1-4)")
    print("\t[w] Flower (1-27)")
    print("\t[x] Pollination (1-8)")
    print("\t[r] Rain (1/0)")
    print("\t[n] Night (1/0)")
    print("\t[c] Cave (1/0)")
    print("----------------------------------------")
    print("Usage: <Trait><Comparison Operator><Value>")
    print("Example: 'Vs==Noble', 'Ef>=3', 'Y'")
end


---Asks the user to select the source and target chests, and returns the result
---@return Side[]
---@return Side
---
local function selectChests()
    local source, target, _

    repeat
        printChestSelectionMenu()
        local user_input = io.read()
        _, _, source, target = string.find(user_input, "([UDNESW]+)%s+([UDNESW])")

        if source == nil or target == nil then
            Log.info("Unable to match the user input with the expected pattern. User input: " .. user_input)
            print("Invalid user input, please try again.")
        end
    until source ~= nil and target ~= nil


    local source_sides = {}
    for i = 1, #source do
        local c = source:sub(i, i)
        local side = char_to_side[c]
        table.insert(source_sides, side)
    end

    local target_side = char_to_side[target]

    return source_sides, target_side
end


local function constructFilter(match_all, trait_getter, comparison_function, value)
    if match_all then
        return function (bee)
            return comparison_function(trait_getter(bee.active), value) and comparison_function(trait_getter(bee.inactive), value)
        end
    else
        return function (bee)
            return comparison_function(trait_getter(bee.active), value) or comparison_function(trait_getter(bee.inactive), value)
        end
    end
end


---@alias Selection
---| 1 # abort
---| 2 # move_all
---| 3 # match_string
---| 4 # match_integer
---| 5 # match_boolean


local function getFilter()
    local _, found_match, selector, trait, comparison_function, value

    ---@type Selection?
    local matched_selection

    ---@type { [Selection]: string }
    local patterns = {
        "Z",
        "Y",
        "([EV])%s*([s])%s*([<>~=]=?)%s*([%l%u ]+)",
        "([EV])%s*([flptheawx])%s*([<>~=]=?)%s*(%d+)",
        "([EV])%s*([rnc])%s*([~=]=)%s*([01])"
    }

    local attempt = 0

    repeat
        if attempt ~= 0 then
            Log.info("Unable to match the user input with the expected pattern. User input: " .. user_input)
            print("Invalid user input, please try again.")
        end
        if attempt % 10 == 0 then
            printFilterSelectionMenu()
        end

        comparison_function = nil
        local comparison_operator = nil

        local user_input = io.read()

        for selection, pattern in pairs(patterns) do
            if matched_selection == nil then
                found_match, _, selector, trait, comparison_operator, value = string.find(user_input, pattern)
                if found_match ~= nil then
                    matched_selection = selection
                    Log.debug("Matched selection " .. selection)
                end
            end
        end

        if comparison_operator then
            comparison_function = operator_to_function[comparison_operator]
        end
        attempt = attempt + 1
    until (matched_selection == 1 or matched_selection == 2) or (comparison_function ~= nil)

    if matched_selection == 1 then
        return nil
    elseif matched_selection == 2 then
        return function (bee) return true end
    end

    if matched_selection == 4 then
        value = tonumber(value)
    elseif matched_selection == 5 then
        value = value == 1
    end

    local trait_getter = trait_to_getter[trait]
    return constructFilter(selector == "V", trait_getter, comparison_function, value)
end


local function main()
    print("Disclaimer: This program will ignore all items that are not analyzed bees.")

    local filter_manager = FilterManager()

    while true do
        local sources, target = selectChests()
        local bee_container = filter_manager:getBeesInChests(sources)

        local filter = getFilter()
        if filter == nil then
            return
        end

        local analyzed_bee_container = bee_container:filter(function (bee)
            return bee:isAnalyzed()
        end)
        local filtered_bee_container = analyzed_bee_container:filter(filter)

        local moved_all, stacks, bee_count = filter_manager:moveBeesIntoChest(filtered_bee_container, target)

        if moved_all then
            print("Moved all " .. bee_count .. " bees in " .. stacks .. " stacks to the selected chest.")
        else
            print("Moved only " .. bee_count .. " bees in " .. stacks .. " stacks to the selected chest.")
        end
    end
end


main()
