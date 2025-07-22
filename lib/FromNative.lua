local Log = require "Log"


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
    ['forestry.allele.effect.aggressive'] = 1,
    ['forestry.allele.effect.beatific'] = 2,
    ['forestry.allele.effect.creeper'] = 3,
    ['forestry.allele.effect.drunkard'] = 4,
    ['forestry.allele.effect.exploration'] = 5,
    ['forestry.allele.effect.glacial'] = 6,
    ['forestry.allele.effect.fertile'] = 7,
    ['forestry.allele.effect.heroic'] = 8,
    ['forestry.allele.effect.ignition'] = 9,
    ['forestry.allele.effect.misanthrope'] = 10,
    ['forestry.allele.effect.miasmic'] = 11,
    ['forestry.allele.effect.mycophilic'] = 12,
    ['forestry.allele.effect.none'] = 13,
    ['forestry.allele.effect.radioactive'] = 14,
    ['forestry.allele.effect.reanimation'] = 15,
    ['forestry.allele.effect.repulsion'] = 16,
    ['forestry.allele.effect.resurrection'] = 17,
    ['forestry.allele.effect.snowing'] = 18,
    ['extrabees.effect.acid'] = 19,
    ['extrabees.effect.birthday'] = 20,
    ['extrabees.effect.blindness'] = 21,
    ['extrabees.effect.bonemeal_fruit'] = 22,
    ['extrabees.effect.bonemeal_mushroom'] = 23,
    ['extrabees.effect.bonemeal_sapling'] = 24,
    ['extrabees.effect.confusion'] = 25,
    ['extrabees.effect.ectoplasm'] = 26,
    ['extrabees.effect.festival'] = 27,
    ['extrabees.effect.fireworks'] = 28,
    ['extrabees.effect.food'] = 29,
    ['extrabees.effect.gravity'] = 30,
    ['extrabees.effect.hunger'] = 31,
    ['extrabees.effect.lightning'] = 32,
    ['extrabees.effect.meteor'] = 33,
    ['extrabees.effect.power'] = 34,
    ['extrabees.effect.radioactive'] = 35,
    ['extrabees.effect.slow'] = 36,
    ['extrabees.effect.spawn_creeper'] = 37,
    ['extrabees.effect.spawn_skeleton'] = 38,
    ['extrabees.effect.spawn_zombie'] = 39,
    ['extrabees.effect.teleport'] = 40,
    ['extrabees.effect.thief'] = 41,
    ['extrabees.effect.water'] = 42,
    ['extrabees.effect.wither'] = 43,
    ['magicbees.effectAblaze'] = 44,
    ['magicbees.effectAMWisp'] = 45,
    ['magicbees.effectBatty'] = 46,
    ['magicbees.effectBovine'] = 47,
    ['magicbees.effectBrainy'] = 48,
    ['magicbees.effectCanine'] = 49,
    ['magicbees.effectCatty'] = 50,
    ['magicbees.effectChicken'] = 51,
    ['magicbees.effectCrumbling'] = 52,
    ['magicbees.effectCurative'] = 53,
    ['magicbees.effectDigSpeed'] = 54,
    ['magicbees.effectDreaming'] = 55,
    ['magicbees.effectGhastly'] = 56,
    ['magicbees.effectHorse'] = 57,
    ['magicbees.effectInvisibility'] = 58,
    ['magicbees.effectManaDrain'] = 59, --This one seems to be a mistake in the code at https://github.com/GTNewHorizons/MagicBees/blob/2e7e1a3efcdeb8db08e227a8fa4741a528e87feb/src/main/java/magicbees/bees/Allele.java#L231
    ['magicbees.effectManaDrainer'] = 60,
    ['magicbees.effectMoveSpeed'] = 61,
    ['magicbees.effectNodeEmpower'] = 62,
    ['magicbees.effectNodePurifying'] = 63,
    ['magicbees.effectNodeRavening'] = 64,
    ['magicbees.effectNodeRepair'] = 65,
    ['magicbees.effectNodeTainting'] = 66,
    ['magicbees.effectPorcine'] = 67,
    ['magicbees.effectSheep'] = 68,
    ['magicbees.effectSlowSpeed'] = 69,
    ['magicbees.effectSpidery'] = 70,
    ['magicbees.effectTEBasalz'] = 71,
    ['magicbees.effectTEBlitz'] = 72,
    ['magicbees.effectTEBlizzy'] = 73,
    ['magicbees.effectTransmuting'] = 74,
    ['magicbees.effectVisRecharge'] = 75,
    ['magicbees.effectWispy'] = 76,
    ['magicbees.effectWithering'] = 77
}


---@param effect_name string
---@return Effect
function FromNative.effect(effect_name)
    local effect = effect_name_to_number[effect_name]
    if effect == nil then
        Log.warn("[FromNative.effect] cannot convert the given effect name '" .. tostring(effect_name) .. "' to an integer. Using default value 38 (None)")
        return effect_name_to_number['forestry.allele.effect.none']
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
    ["NONE"] = 1,
    ["DOWN_1"] = 2,
    ["UP_1"] = 3,
    ["DOWN_2"] = 4,
    ["UP_2"] = 5,
    ["DOWN_3"] = 6,
    ["UP_3"] = 7,
    ["DOWN_4"] = 8,
    ["UP_4"] = 9,
    ["DOWN_5"] = 10,
    ["UP_5"] = 11,
    ["BOTH_1"] = 12,
    ["BOTH_2"] = 13,
    ["BOTH_3"] = 14,
    ["BOTH_4"] = 15,
    ["BOTH_5"] = 16
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
