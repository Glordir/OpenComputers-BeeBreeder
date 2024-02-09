local BasicManager = require "BasicManager"
local BeeTraits = require "BeeTraits"
local writeVariableToFile = require("util").writeVariableToFile
local prettyPrint = require("util").prettyPrint


---Print the bee in a pretty format
---@param bee Bee
local function printBee(bee)
    print("Side: " .. bee.location.side .. " \tSlot: " .. bee.location.slot .. " \tBee: " .. bee.native_bee.label)
end


BasicManager.init()
local bees = BasicManager.getBees()


for _, bee in ipairs(bees.bees) do
    printBee(bee)
end

writeVariableToFile(bees.bees[1], "bee.txt")


local beeTraits = BeeTraits(bees.bees[1].native_bee.individual.active)
writeVariableToFile(beeTraits, "beeTraits.txt")
prettyPrint(beeTraits)
