-- DKHUB DEV PREVIEW entry point.
-- Loads the full UI/tab layout while replacing gameplay actions with notices.
-- Put this file as a LocalScript under the src folder in Roblox Studio.

local root = script.Parent
local UILibrary = require(root.core.ui_library)
local MainTabBuilder = require(root.tabs.main)
local MiscTabBuilder = require(root.tabs.misc)
local SettingsTabBuilder = require(root.tabs.settings)

local function notify(title, content)
    if UILibrary and typeof(UILibrary.Notify) == "function" then
        UILibrary:Notify({Title = title, Content = content, Duration = 3})
    end
end

-- Safe preview adapter: the complete UI is wired, but actions do not touch
-- remotes, other players, teleportation, bypasses, or automation loops.
local Automation = {
    Flags = {},
    IsUnloaded = false,
    Connections = {},
}
function Automation.ToggleTask(name, enabled)
    notify("DEV PREVIEW", name .. (enabled and " enabled (preview only)" or " disabled"))
end
function Automation.RegisterConnection(_, connection)
    if connection and typeof(connection.Disconnect) == "function" then
        connection:Disconnect()
    end
end
function Automation.SaveConfig() notify("DEV PREVIEW", "Save is disabled in preview mode") end
function Automation.LoadConfig() notify("DEV PREVIEW", "Load is disabled in preview mode") end
function Automation.FullPerformanceMode() notify("DEV PREVIEW", "Performance preview only") end
function Automation.Toggle3DRendering() notify("DEV PREVIEW", "3D rendering preview only") end
function Automation.Unload()
    Automation.IsUnloaded = true
    if UILibrary.ActiveWindow and UILibrary.ActiveWindow.Gui then
        UILibrary.ActiveWindow.Gui:Destroy()
    end
end

local function safeFunctions(name, source, defaults)
    local proxy = defaults or {}
    return setmetatable(proxy, {
        __index = function(_, key)
            local value = source and source[key]
            if typeof(value) == "function" then
                return function()
                    notify("DEV PREVIEW", name .. ": " .. key .. " is preview-only")
                end
            end
            return function()
                notify("DEV PREVIEW", name .. ": " .. tostring(key) .. " is preview-only")
            end
        end
    })
end

local MainFunctions = safeFunctions("Main", nil, {
    EggRarities = {"All", "Common", "Rare", "Epic", "Legendary", "Mythic"},
    KnownEggTypes = {"Starter Egg", "Forest Egg", "Desert Egg", "Limited Egg"},
})
local MiscFunctions = safeFunctions("Misc", nil)

local window = UILibrary:CreateWindow({
    Title = "DKHUB DEV PREVIEW",
    SubTitle = "Horizon UI / Safe Test Mode",
})

local mainTab = window:AddTab({Title = "Main", Icon = "home"})
local miscTab = window:AddTab({Title = "Misc", Icon = "settings"})
local settingsTab = window:AddTab({Title = "Settings", Icon = "settings"})

-- Builders are connected to the same window and shared state.
-- Their gameplay callbacks resolve to the safe preview adapter above.
MainTabBuilder(mainTab, Automation, MainFunctions, MiscFunctions, UILibrary)
MiscTabBuilder(miscTab, Automation, MiscFunctions, MainFunctions, UILibrary)
SettingsTabBuilder(settingsTab, Automation, MainFunctions, window, UILibrary)

notify("DKHUB DEV PREVIEW", "UI, tabs, and function modules connected")
return window
