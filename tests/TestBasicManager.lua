local BasicManager = require "BasicManager"
local writeVariableToFile = require("util").writeVariableToFile


---Print the bee in a pretty format
---@param bee Bee
local function printBee(bee)
    print("Side: " .. bee.location.side .. " \tSlot: " .. bee.location.slot .. " \tSpecies: " .. bee:getSpecies())
end


BasicManager.init()
local bees = BasicManager.getBees()


for _, bee in ipairs(bees:getBees()) do
    printBee(bee)
end

print("Species: ")
for species, _ in pairs(bees:getSpecies()) do
    print(species)
end

print("\nFlowers: ")
for flower, _ in pairs(bees:getFlowers()) do
    print(flower)
end

print("\nlowest bee traits: ", bees:getLowestBeeTraits())
print("\nhighest bee traits: ", bees:getHighestBeeTraits())
