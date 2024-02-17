local Log = require "log"


local FromNative = {}

---Converts the native territory to my area representation
---@param width integer
---@return Area
function FromNative.area(width)
    if width == 9 then
        return 1
    elseif width == 11 then
        return 2
    elseif width == 13 then
        return 3
    elseif width == 15 then
        return 3
    end

    Log.error("[FromNative.area] cannot convert the given width '" .. tostring(width) .. "' to a valid area. Using default value 1 (Average)")
    return 1
end


local native_pollination_to_my_pollination = {
    [5] = 1,
    [10] = 2,
    [15] = 3,
    [20] = 4,
    [25] = 5,
    [30] = 6,
    [35] = 7,
    [99] = 8
}


---Converts the native pollination speed to my pollination speed representation
---@param native_pollination integer
---@return Pollination
function FromNative.pollination(native_pollination)
    local pollination = native_pollination_to_my_pollination[native_pollination]
    if pollination == nil then
        Log.warn("[FromNative.pollination] cannot convert the given native pollination '" .. tostring(pollination) .. "' to my pollination representation. Using default value 1 (Slowest)")
        return 1
    end
    return pollination
end


---Converts the native production speed to my production speed representation
---@param native_speed number
---@return ProductionSpeed
function FromNative.productionSpeed(native_speed)
    if native_speed < 0.31 then
        return 1
    elseif native_speed < 0.61 then
        return 2
    elseif native_speed < 0.81 then
        return 3
    elseif native_speed < 1.01 then
        return 4
    elseif native_speed < 1.21 then
        return 5
    elseif native_speed < 1.41 then
        return 6
    elseif native_speed < 1.71 then
        return 7
    elseif native_speed < 2.01 then
        return 8
    end

    Log.warn("[FromNative.prodcutionSpeed] cannot convert the given native speed '" .. tostring(native_speed) .. "' to a valid speed. Using default value (Slowest)")
    return 1
end


---@enum Flower
local flower_name_to_number = {
    Books = 1,
    Cacti = 2,
    ["Dead Bushes"] = 3,
    End = 4,
    Ender = 5,
    ["Exotic Flowers"] = 6,
    Flowers = 7,
    Fruit = 8,
    Gourds = 9,
    Jungle = 10,
    Leaves = 11,
    ["Lily Pads"] = 12,
    Mushroom = 13,
    Mystical = 14,
    ["Mystical Flowers"] = 15,
    Nether = 16,
    Node = 17,
    Redstone = 18,
    Reeds = 19,
    Rocks = 20,
    Saplings = 21,
    Sea = 22,
    Snow = 23,
    ["Thaumic Flowers"] = 24,
    ["Thaumic Shards"] = 25,
    Wheat = 26,
    Wood = 27
}


---Converts the native pollination speed to my pollination speed representation
---@param flower_name string
---@return Flower
function FromNative.flower(flower_name)
    local flower_number = flower_name_to_number[flower_name]
    if flower_number == nil then
        Log.warn("[FromNative.flower] cannot convert the given flower '" .. tostring(flower_number) .. "' to an integer. Using default value 7 (Flowers)")
        return 7
    end
    return flower_number
end


---@enum Effect
local effect_name_to_number = {
    Ablaze = 1,
    Acidic = 2,
    ["Aggress."] = 3,
    Batty = 4,
    Beatific = 5,
    Bovine = 6,
    Brainy = 7,
    Catty = 8,
    Cleansing = 9,
    Creepers = 10,
    Creeper = 11,
    Crumbling = 12,
    Darkness = 13,
    Drunkard = 14,
    Ectoplasm = 15,
    Empowering = 16,
    Ends = 17,
    Explorer = 18,
    Fertile = 19,
    Festive = 20,
    Fireworks = 21,
    Flammable = 22,
    Freezing = 23,
    Ghastly = 24,
    Gravity = 25,
    Growth = 26,
    Heroic = 27,
    Howling = 28,
    Hunger = 29,
    Invisible = 30,
    Lightning = 31,
    Magnification = 32,
    Meteor = 33,
    Mining = 34,
    Mushroom = 35,
    Mycophilic = 36,
    Neighsayer = 37,
    None = 38,
    Plucky = 39,
    Poison = 40,
    Porcine = 41,
    Power = 42,
    Purifying = 43,
    Radioactive = 44,
    Ravening = 45,
    Reanimation = 46,
    Recharging = 47,
    Repulsion = 48,
    Resurrection = 49,
    Ripening = 50,
    Skeletons = 51,
    Slowness = 52,
    Snow = 53,
    Spidery = 54,
    Swiftness = 55,
    Tainting = 56,
    Teleport = 57,
    ["Time Warp"] = 58,
    Tipsy = 59,
    Transmuting = 60,
    Unstable = 61,
    Water = 62,
    Wispy = 63,
    Wither = 64,
    Withering = 65,
    Wooly = 66,
    Zombies = 67
}


---@param effect_name string
---@return Effect
function FromNative.effect(effect_name)
    local effect = effect_name_to_number[effect_name]
    if effect == nil then
        Log.warn("[FromNative.effect] cannot convert the given effect name '" .. tostring(effect_name) .. "' to an integer. Using default value 38 (None)")
        return 38
    end
    return effect

end


local native_lifespan_to_number = {
    [10] = 1,
    [20] = 2,
    [30] = 3,
    [35] = 4,
    [40] = 5,
    [45] = 6,
    [50] = 7,
    [60] = 8,
    [70] = 9
}


---Converts the native lifespan to my lifespan representation
---@param native_lifespan integer
---@return Lifespan
function FromNative.lifespan(native_lifespan)
    local lifespan = native_lifespan_to_number[native_lifespan]
    if lifespan == nil then
        Log.warn("[FromNative.lifespan] cannot convert the given native lifespan '" .. tostring(native_lifespan) .. "' to my lifespan representation. Using default value 1 (Shortest)")
        return 1
    end
    return lifespan
end


local tolerance_string_to_number = {
    ["None"] = 1,
    ["Down 1"] = 2,
    ["Up 1"] = 3,
    ["Down 2"] = 4,
    ["Up 2"] = 5,
    ["Down 3"] = 6,
    ["Up 3"] = 7,
    ["Both 1"] = 8,
    ["Both 2"] = 9,
    ["Both 3"] = 10
}


---Converts the tolerance string to my tolerance representation
---@param tolerance_string string
---@return Tolerance
function FromNative.tolerance(tolerance_string)
    local tolerance = tolerance_string_to_number[tolerance_string]
    if tolerance == nil then
        Log.warn("[FromNative.tolerance] cannot convert the given tolerance string '" .. tostring(tolerance_string) .. "' to an integer. Using default value 1 (None)")
        return 1
    end
    return tolerance
end


return FromNative
