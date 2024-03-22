---@alias Fertility 1 | 2 | 3 | 4


---@alias Area
---| 1 # Average: 9x6x9
---| 2 # Large: 11x8x11
---| 3 # Larger: 13x?x13
---| 4 # Largest: 15x13x15


---@alias Pollination
---| 1 # Slowest: 5
---| 2 # Slower: 10
---| 3 # Slow: 15
---| 4 # Normal: 20
---| 5 # Fast: 25
---| 6 # Faster: 30
---| 7 # Fastest: 35
---| 8 # Maximum: 99


---@alias ProductionSpeed
---| 1 # Slowest: 0.3
---| 2 # Slower: 0.6
---| 3 # Slow: 0.8
---| 4 # Normal: 1.0
---| 5 # Fast: 1.2
---| 6 # Faster: 1.4
---| 7 # Fastest: 1.7
---| 8 # Blinding: 2.0


---@alias Lifespan
---| 1 # Shortest 10
---| 2 # Shorter 20
---| 3 # Short 30
---| 4 # Shortened 35
---| 5 # Normal 40
---| 6 # Elongated 45
---| 7 # Long 50
---| 8 # Longer 60
---| 9 # Longest 70


---@alias Tolerance
---| 1 # None
---| 2 # Down 1
---| 3 # Up 1
---| 4 # Down 2
---| 5 # Up 2
---| 6 # Down 3
---| 7 # Up 3
---| 8 # Down 4
---| 9 # Up 4
---| 10 # Down 5
---| 11 # Up 5
---| 12 # Both 1
---| 13 # Both 2
---| 14 # Both 3
---| 15 # Both 4
---| 16 # Both 5


---@class IBeeTraits
---@field public new fun(native_bee_traits: table): IBeeTraits
---@field public copy fun(source: IBeeTraits): IBeeTraits
---
---@field public setFertility fun(self: IBeeTraits, fertility: Fertility)
---@field public setArea fun(self: IBeeTraits, area: Area)
---@field public setPollination fun(self: IBeeTraits, pollination: Pollination)
---@field public setProductionSpeed fun(self: IBeeTraits, speed: ProductionSpeed)
---@field public setFlower fun(self: IBeeTraits, flower: Flower)
---@field public setEffect fun(self: IBeeTraits, effect: Effect)
---@field public setSpecies fun(self: IBeeTraits, species: string)
---@field public setLifespan fun(self: IBeeTraits, lifespan: Lifespan)
---@field public setTemperatureTolerance fun(self: IBeeTraits, tolerance: Tolerance)
---@field public setHumidityTolerance fun(self: IBeeTraits, tolerance: Tolerance)
---@field public setTolerantFlyer fun(self: IBeeTraits, is_tolerant_flyer: boolean)
---@field public setNocturnal fun(self: IBeeTraits, is_nocturnal: boolean)
---@field public setCaveDwelling fun(self: IBeeTraits, is_cave_dwelling: boolean)
---
---@field public getFertility fun(self: IBeeTraits): Fertility
---@field public getArea fun(self: IBeeTraits): Area
---@field public getPollination fun(self: IBeeTraits): Pollination
---@field public getProductionSpeed fun(self: IBeeTraits): ProductionSpeed
---@field public getFlower fun(self: IBeeTraits): Flower
---@field public getEffect fun(self: IBeeTraits): Effect
---@field public getSpecies fun(self: IBeeTraits): string
---@field public getLifespan fun(self: IBeeTraits): Lifespan
---@field public getTemperatureTolerance fun(self: IBeeTraits): Tolerance
---@field public getHumidityTolerance fun(self: IBeeTraits): Tolerance
---@field public isTolerantFlyer fun(self: IBeeTraits): boolean
---@field public isNocturnal fun(self: IBeeTraits): boolean
---@field public isCaveDwelling fun(self: IBeeTraits): boolean
---
---@field public toString fun(self: IBeeTraits): string
---@field public eq fun(self: IBeeTraits, other: IBeeTraits): boolean

