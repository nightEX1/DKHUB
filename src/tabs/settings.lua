--[[
    Steal An Egg Hub - Settings Tab Sub-Menu UI
    Configures Config Persistence, UI Keybinds, and Master Clean Unloader.
--]]

return function(SettingsTab, Automation, MainFunctions, Window, UILibrary)
    ----------------------------------------------------------------------------
    -- A. AUTOMATIC CONFIG PERSISTENCE
    ----------------------------------------------------------------------------
    SettingsTab:AddSection("Automatic Config Persistence")

    SettingsTab:AddParagraph({
        Title = "Auto-Save System",
        Content = "All enabled features, toggles, and slider parameters are automatically saved to 'StealAnEgg_DKHUB_Config.json' upon change."
    })

    SettingsTab:AddButton({
        Title = "Save Settings Now",
        Description = "Manually trigger auto-save for your current configuration",
        Callback = function()
            if Automation and typeof(Automation.SaveConfig) == "function" then
                Automation.SaveConfig()
                if UILibrary and typeof(UILibrary.Notify) == "function" then
                    UILibrary:Notify({ Title = "Config Manager", Content = "Settings saved to StealAnEgg_DKHUB_Config.json", Duration = 3 })
                end
            end
        end
    })

    SettingsTab:AddButton({
        Title = "Reload Settings",
        Description = "Reload saved configuration from StealAnEgg_DKHUB_Config.json",
        Callback = function()
            if Automation and typeof(Automation.LoadConfig) == "function" then
                Automation.LoadConfig()
                if UILibrary and typeof(UILibrary.Notify) == "function" then
                    UILibrary:Notify({ Title = "Config Manager", Content = "Configuration reloaded successfully!", Duration = 3 })
                end
            end
        end
    })

    ----------------------------------------------------------------------------
    -- B. UI CONTROLS & INFO
    ----------------------------------------------------------------------------
    SettingsTab:AddSection("Interface & Shortcuts")

    SettingsTab:AddParagraph({
        Title = "Toggle UI Keybind",
        Content = "Press [Right Control] on keyboard to toggle UI visibility.\nOn Mobile & Touch devices, use the draggable floating DKHUB icon."
    })

    ----------------------------------------------------------------------------
    -- C. SCRIPT CONTROLS & CLEAN UNLOAD
    ----------------------------------------------------------------------------
    SettingsTab:AddSection("Script Controls")

    SettingsTab:AddParagraph({
        Title = "Master Clean Unloader",
        Content = "Cleanly terminates all background automation loops, disconnects event listeners, restores normal character state, and removes UI elements."
    })

    SettingsTab:AddButton({
        Title = "Unload Script Hub",
        Description = "Closes interface and cleanly terminates all active connections & background loops",
        Callback = function()
            if Automation and typeof(Automation.Unload) == "function" then
                Automation.Unload(UILibrary)
            end
        end
    })
end
