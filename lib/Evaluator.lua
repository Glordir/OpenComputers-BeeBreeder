---@class Evaluator
---@field private target_bee_traits IBeeTraits
---@field public new fun(target_bee_traits: IBeeTraits): Evaluator
---@field public getScore fun(self: Evaluator, bee: Bee): integer
---@field private getGeneScore fun(self: Evaluator, bee_traits: IBeeTraits): integer
---
local Evaluator = setmetatable({}, {__call = function (evaluator, ...)
    return evaluator.new(...)
end})


---Constructor for the Evaluator class
---@param target_bee_traits IBeeTraits
---@return Evaluator
---
function Evaluator.new(target_bee_traits)
    local instance = {
        target_bee_traits = target_bee_traits
    }

    return setmetatable(instance, {__index = Evaluator})
end


function Evaluator:getScore(bee)
    local score = self:getGeneScore(bee.active) + self:getGeneScore(bee.inactive)
    if bee.active:getSpecies() ~= self.target_bee_traits:getSpecies() and bee.inactive:getSpecies() ~= self.target_bee_traits:getSpecies() then
        score = score + 1000
    end

    return score
end


---Calculates the difference between the passed gene and the target bee traits.
---@param bee_traits IBeeTraits
---@return integer
---
function Evaluator:getGeneScore(bee_traits)
    local score = 0

    if bee_traits:getFertility() ~= self.target_bee_traits:getFertility() then
        score = score + 100
    end
    if bee_traits:getArea() ~= self.target_bee_traits:getArea() then
        score = score + 1
    end
    if bee_traits:getPollination() ~= self.target_bee_traits:getPollination() then
        score = score + 1
    end
    if bee_traits:getProductionSpeed() ~= self.target_bee_traits:getProductionSpeed() then
        score = score + 1
    end
    if bee_traits:getFlower() ~= self.target_bee_traits:getFlower() then
        score = score + 1
    end
    if bee_traits:getEffect() ~= self.target_bee_traits:getEffect() then
        score = score + 1
    end
    if bee_traits:getSpecies() ~= self.target_bee_traits:getSpecies() then
        score = score + 1
    end
    if bee_traits:getLifespan() ~= self.target_bee_traits:getLifespan() then
        score = score + 1
    end
    if bee_traits:getTemperatureTolerance() ~= self.target_bee_traits:getTemperatureTolerance() then
        score = score + 1
    end
    if bee_traits:getHumidityTolerance() ~= self.target_bee_traits:getHumidityTolerance() then
        score = score + 1
    end
    if bee_traits:isTolerantFlyer() ~= self.target_bee_traits:isTolerantFlyer() then
        score = score + 1
    end
    if bee_traits:isNocturnal() ~= self.target_bee_traits:isNocturnal() then
        score = score + 1
    end
    if bee_traits:isCaveDwelling() ~= self.target_bee_traits:isCaveDwelling() then
        score = score + 1
    end

    return score
end


return Evaluator
