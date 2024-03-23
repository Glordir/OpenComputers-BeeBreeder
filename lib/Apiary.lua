local BreederBlock = require "BreederBlock"
local Config = require "Config"
local Log = require "Log"


---@class Apiary: BreederBlock
---@field private transposer Transposer
---
local Apiary = setmetatable({}, {__call = function (apiary, ...)
    return apiary.new(...)
end,
__index = BreederBlock
})


---Creates a new Apiary
---@param side Side
---@param transposer Transposer
---@return Apiary
---
function Apiary.new(side, transposer)
    local apiary = BreederBlock(side, transposer) --[[@as Apiary]]

    return setmetatable(apiary, {__index = Apiary})
end


---Check if the apiary is ready for a new breeding pair
---@param self Apiary
---@return boolean
---
function Apiary:mayBreed()
    -- Return false if the princess slot is full
    if self.transposer:getStackSize(self.side, self:getPrincessSlot()) ~= 0 then
        return false
    end

    if Config.allowOblivionFrameDestructionInApiary then
        return true
    end

    -- Return false if the apiary contains an Oblivion frame with more than 75% damage
    for frame_slot = 10, 12 do
        local item = self.transposer:getItemInSlot(self.side, frame_slot)
        if item ~= nil and item.label == "Oblivion Frame" then
            local damage = item.damage
            local max_damage = item.maxDamage

            if damage == nil or max_damage == nil then
                Log.error("The Oblivion Frame is missing the damage or maxDamage attribute!")
                return false
            end

            if damage / max_damage > 0.75 then
                return false
            end
        end
    end

    return true
end


return Apiary
