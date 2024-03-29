---@class Config
---@field public loadFromFile fun()
---@field public breederSpecies string
---@field public allowOblivionFrameDestructionInApiary string
---@field public inputInventoryName string
---@field public outputInventoryName string
---@field public trashInventoryNames string
---@field public logLevel string
---@field public logFilePath string
---
local Config = {}


-- Note:
-- The functions in this file cannot use the Log class (and use print instead) because the config needs to be loaded before the logger can be used


-- Helper Functions (Forward Declarations)
local setDefaultsIfInvalid
local setDefaultIfInvalid


function Config.loadFromFile()
    local readConfig, err = loadfile("settings.conf", "t", Config)

    if readConfig then
        -- Execute the loaded config 'program' and store the result in 'config'
        readConfig()
    else
        print("[EARLY-WARN] Unable to load the settings.conf file, using default values. Error Message: " .. err)
    end

    setDefaultsIfInvalid()
end


setDefaultsIfInvalid = function ()
    setDefaultIfInvalid("breederSpecies", "Magenta")
    setDefaultIfInvalid("allowOblivionFrameDestructionInApiary", false)
    setDefaultIfInvalid("inputInventoryName", "tile.CompressedChest")
    setDefaultIfInvalid("trashInventoryNames", {["tile.extrautils:trashcan"] = true, ["tile.extrautils:filing"] = true})
    setDefaultIfInvalid("logLevel", "info")
    setDefaultIfInvalid("logFilePath", "log.txt")
end


setDefaultIfInvalid = function (setting_name, default_value)
    local loaded_setting = Config[setting_name]
    if loaded_setting == nil or type(loaded_setting) ~= type(default_value) then
        print("[EARLY-WARN] Invalid setting " .. setting_name .. " in settings.conf, using default value.")
        Config[setting_name] = default_value
    end
end


Config.loadFromFile()
return Config
