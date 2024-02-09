local Chest = require "Chest"
local Component = require "component"
local Transposer = require "Transposer"


local transposer = Transposer(Component.transposer.address)
local chest = Chest(transposer, 1)


---Print the bee in a pretty format
---@param bee Bee
local function printBee(bee)
    print("Side: " .. bee.location.side .. " \tSlot: " .. bee.location.slot .. " \tBee: " .. bee:getSpecies())
end


local bees = chest:getBees()
for _, bee in ipairs(bees.bees) do
    printBee(bee)
end
