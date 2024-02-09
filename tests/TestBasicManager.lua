local BasicManager = require "BasicManager"
local writeVariableToFile = require("util").writeVariableToFile


---Print the bee in a pretty format
---@param bee Bee
local function printBee(bee)
    print("Side: " .. bee.location.side .. " \tSlot: " .. bee.location.slot .. " \tSpecies: " .. bee:getSpecies())
end


BasicManager.init()
local bees = BasicManager.getBees()


for _, bee in ipairs(bees.bees) do
    printBee(bee)
end

writeVariableToFile(bees.bees, "bee.txt")
