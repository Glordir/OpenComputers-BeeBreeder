local BasicManager = require "BasicManager"
local BeeTraits = require "BeeTraits"
local BeeTraitsCompact = require "BeeTraitsCompact"


BasicManager.init()
local bees = BasicManager.getBees()


for i, bee in ipairs(bees.bees) do
    if bee.native_bee.individual.isAnalyzed then
        local beeTraits = BeeTraits(bee.native_bee.individual.active) --[[@as BeeTraits]]
    local beeTraitsCompact = BeeTraitsCompact(bee.native_bee.individual.active) --[[@as BeeTraitsCompact]]

    assert(beeTraits:getFertility() == beeTraitsCompact:getFertility(), "Fertility doesn't match")
    assert(beeTraits:getTerritory() == beeTraitsCompact:getTerritory(), "Territiry doesn't match")
    assert(beeTraits:getPollination() == beeTraitsCompact:getPollination(), "Pollination speed doesn't match")
    assert(beeTraits:getProductionSpeed() == beeTraitsCompact:getProductionSpeed(), "Production speed doesn't match")
    assert(beeTraits:getFlower() == beeTraitsCompact:getFlower(), "Flower type doesn't match")
    assert(beeTraits:getEffect() == beeTraitsCompact:getEffect(), "Effect doesn't match")
    assert(beeTraits:getSpecies() == beeTraitsCompact:getSpecies(), "Species doesn't match")
    assert(beeTraits:getLifespan() == beeTraitsCompact:getLifespan(), "Lifespan doesn't match")
    assert(beeTraits:getTemperatureTolerance() == beeTraitsCompact:getTemperatureTolerance(), "Temperature Tolerance doesn't match")
    assert(beeTraits:isTolerantFlyer() == beeTraitsCompact:isTolerantFlyer(), "Tolerant flyer status doesn't match")
    assert(beeTraits:isNocturnal() == beeTraitsCompact:isNocturnal(), "Nocturnal status doesn't match")
    assert(beeTraits:isCaveDwelling() == beeTraitsCompact:isCaveDwelling(), "Cave dwelling status doesn't match")
    assert(beeTraits:getHumidityTolerance() == beeTraitsCompact:getHumidityTolerance(), "Humidity Tolerance doesn't match")

    print("Bee " .. i .. " matches")
    end
end

print("All representations of all the bees in the chests match!")