local Log = require "log"
local manager = require "BasicManager"

local running = true


local manager
local breeding_plan


local function init()
	Log.debug("Started init")

    manager.init()
    breeding_plan = IBreedingPlan(manager:getBees())

	Log.debug("Finished init")
end


local function loop()
	Log.debug("Started loop")

    breeding_plan:updateBees(manager:getBees())

    if breeding_plan:achievedGoal() then
        breeding_plan:updateGoal()
    end

    local empty_apiaries = manager:getEmptyApiaries()
    for _, apiary in ipairs(empty_apiaries) do
        local princess, drone = breeding_plan:getNextPair()

        Log.info("Starting to breed " .. princess .. " and " .. drone)
        manager:breed(apiary, princess, drone)
    end

    manager:sortAllBees(breeding_plan)

	Log.debug("Finished loop")
end


local function main()
	init()

	while running do
		loop()
	end
end


main()
