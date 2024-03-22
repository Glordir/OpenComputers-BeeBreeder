local BreederBlock = require "BreederBlock"


---@class Alveary: BreederBlock
---@field private transposer Transposer
---
local Alveary = setmetatable({}, {__call = function (alveary, ...)
    return alveary.new(...)
end,
__index = BreederBlock
})


---Creates a new Alveary
---@param side Side
---@param transposer Transposer
---@return Alveary
---
function Alveary.new(side, transposer)
    local alveary = BreederBlock(side, transposer) --[[@as Alveary]]

    return setmetatable(alveary, {__index = Alveary})
end


---Check if the alveary is ready for a new breeding pair
---@param self Alveary
---@return boolean
---
function Alveary:mayBreed()
    -- Return true if the princess slot is empty
    return self.transposer:getStackSize(self.side, self:getPrincessSlot()) == 0
end


return Alveary
