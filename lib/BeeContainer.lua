local Log = require "Log"
local convertBee = require "Bee"


---@class BeeContainer
---@field bees Bee[]
local BeeContainer = {}


---Adds the passed bees to the internal bee list.
---@param bees Bee[]
---
function BeeContainer:addBees(bees)
    for _, bee in ipairs(bees) do
        table.insert(self.bees, bee)
    end
end

---Adds the passed bee to the internal bee list
---@param native_bee table
---@param side Side
---@param slot number
---
function BeeContainer:addNativeBee(native_bee, side, slot)
    local bee = convertBee(native_bee, side, slot)

    self:addBees({bee})
end


---Create a new Bee Container
---@return BeeContainer
---
local function createBeeContainer()
    return setmetatable({
        bees = {}
    }, {__index = BeeContainer}) --[[@as BeeContainer]]
end


return createBeeContainer
