--[[
    Steal An Egg Hub - Misc Tab Sub-Menu UI
    Configures Rewards Claimer, Combat Slap Aura, Player Mods, ESP Visuals, Stealth Remote Spy, Teleports, and Boosters.
--]]

local Players = game:GetService("Players")

return function(MiscTab, Automation, MiscFunctions, MainFunctions, UILibrary)
    ----------------------------------------------------------------------------
    -- A. REWARDS & QUEST AUTO-CLAIMER
    ----------------------------------------------------------------------------
    MiscTab:AddSection("Rewards & Quest Auto-Claimer")

    MiscTab:AddButton({
        Title = "Claim All Index & Collection Rewards",
        Description = "Instantly claims all cash and limited egg rewards from your discovered animal index",
        Callback = function()
            MiscFunctions.ClaimAllIndexRewards(UILibrary)
        end
    })

    MiscTab:AddButton({
        Title = "Claim Roblox Group Rewards",
        Description = "Claims daily/perk reward for joining the game's group",
        Callback = function()
            MiscFunctions.ClaimGroupRewards(UILibrary)
        end
    })

    MiscTab:AddButton({
        Title = "Auto Complete Guard & Pen Tutorial",
        Description = "Instantly finishes new player tutorial milestones and unlocks all area mechanics",
        Callback = function()
            MiscFunctions.AutoCompleteTutorial(UILibrary)
        end
    })

    ----------------------------------------------------------------------------
    -- B. COMBAT & SLAP AURA
    ----------------------------------------------------------------------------
    MiscTab:AddSection("Combat & Slap Aura")

    local CombatAuraToggle = MiscTab:AddToggle("CombatAuraToggle", {
        Title = "Enable Slap & Weapon Aura",
        Description = "Automatically triggers equipped bats, slaps, taser guns, and medusa head on nearby enemies",
        Default = false
    })
    CombatAuraToggle:OnChanged(function(Value)
        Automation.Flags.CombatAura = Value
    end)

    local AuraRangeSlider = MiscTab:AddSlider("AuraRangeSlider", {
        Title = "Aura Detection Range (Studs)",
        Min = 10,
        Max = 50,
        Default = 25,
        Rounding = 0,
        Callback = function(Value)
            Automation.Flags.AuraRange = Value
        end
    })
    Automation.Flags.AuraRange = AuraRangeSlider.Value or 25
    MiscFunctions.InitCombatAura(Automation.Flags, Automation)

    ----------------------------------------------------------------------------
    -- C. PLAYER MODIFICATIONS
    ----------------------------------------------------------------------------
    MiscTab:AddSection("Player Enhancements")

    local WalkSpeedToggle = MiscTab:AddToggle("WalkSpeedToggle", {
        Title = "Enable Custom WalkSpeed",
        Description = "Modify your character's movement speed",
        Default = false
    })
    WalkSpeedToggle:OnChanged(function(Value)
        Automation.Flags.WalkSpeedEnabled = Value
    end)

    local WalkSpeedSlider = MiscTab:AddSlider("WalkSpeedSlider", {
        Title = "WalkSpeed Value",
        Min = 16,
        Max = 250,
        Default = 32,
        Rounding = 0,
        Callback = function(Value)
            Automation.Flags.WalkSpeedValue = Value
        end
    })
    Automation.Flags.WalkSpeedValue = WalkSpeedSlider.Value or 32

    local JumpPowerToggle = MiscTab:AddToggle("JumpPowerToggle", {
        Title = "Enable Custom JumpPower",
        Description = "Modify your character's jump height",
        Default = false
    })
    JumpPowerToggle:OnChanged(function(Value)
        Automation.Flags.JumpPowerEnabled = Value
    end)

    local JumpPowerSlider = MiscTab:AddSlider("JumpPowerSlider", {
        Title = "JumpPower Value",
        Min = 50,
        Max = 300,
        Default = 75,
        Rounding = 0,
        Callback = function(Value)
            Automation.Flags.JumpPowerValue = Value
        end
    })
    Automation.Flags.JumpPowerValue = JumpPowerSlider.Value or 75

    local InfiniteJumpToggle = MiscTab:AddToggle("InfiniteJumpToggle", {
        Title = "Infinite Jump",
        Description = "Allows jumping indefinitely in mid-air",
        Default = false
    })
    InfiniteJumpToggle:OnChanged(function(Value)
        Automation.Flags.InfiniteJump = Value
    end)

    local NoclipToggle = MiscTab:AddToggle("NoclipToggle", {
        Title = "Noclip (Walk Through Walls)",
        Description = "Disables collision to easily bypass enemy base walls and laser barriers",
        Default = false
    })
    NoclipToggle:OnChanged(function(Value)
        Automation.Flags.Noclip = Value
    end)

    MiscFunctions.InitPlayerMods(Automation.Flags, Automation)

    ----------------------------------------------------------------------------
    -- D. VISUALS & ALL-RARITY ESP
    ----------------------------------------------------------------------------
    MiscTab:AddSection("Visuals & All-Rarity ESP")

    local EggESPToggle = MiscTab:AddToggle("EggESPToggle", {
        Title = "Egg ESP (Color-Coded Rarity)",
        Description = "Highlights all eggs with color tags (BrainrotGod, Cosmic, Divine, Mythic, etc.)",
        Default = false
    })
    EggESPToggle:OnChanged(function(Value)
        Automation.Flags.EggESP = Value
    end)
    MiscFunctions.InitEggESP(Automation.Flags, Automation)

    local PlayerESPToggle = MiscTab:AddToggle("PlayerESPToggle", {
        Title = "Player ESP & Box Highlight",
        Description = "Highlights players with name, health, distance, and visual cham box",
        Default = false
    })
    PlayerESPToggle:OnChanged(function(Value)
        Automation.Flags.PlayerESP = Value
    end)
    MiscFunctions.InitPlayerESP(Automation.Flags, Automation)

    ----------------------------------------------------------------------------
    -- E. STEALTH REMOTE SPY & LOGGER (NO HOOK CONFLICTS)
    ----------------------------------------------------------------------------
    MiscTab:AddSection("Stealth Remote Spy & Logger")

    local RemoteSpyToggle = MiscTab:AddToggle("StealthRemoteSpyToggle", {
        Title = "Enable Stealth Remote Spy",
        Description = "Silently logs all RemoteEvent and RemoteFunction calls in game without triggering BAC checks",
        Default = false
    })
    RemoteSpyToggle:OnChanged(function(Value)
        Automation.Flags.StealthRemoteSpy = Value
        if Value then
            MiscFunctions.InitStealthRemoteSpy(Automation.Flags, Automation, UILibrary)
            if UILibrary then
                UILibrary:Notify({ Title = "Remote Spy Active", Content = "Logging remotes safely to console and clipboard.", Duration = 3 })
            end
        end
    end)

    MiscTab:AddButton({
        Title = "Copy All Logged Remotes to Clipboard",
        Description = "Copies the complete formatted history of captured remote calls",
        Callback = function()
            MiscFunctions.DumpRemoteLogsToClipboard(UILibrary)
        end
    })

    MiscTab:AddButton({
        Title = "Clear Remote Logs",
        Description = "Resets the captured remote call buffer",
        Callback = function()
            MiscFunctions.ClearRemoteLogs(UILibrary)
        end
    })

    ----------------------------------------------------------------------------
    -- F. TELEPORT UTILITIES
    ----------------------------------------------------------------------------
    MiscTab:AddSection("Teleport Utilities")

    MiscTab:AddButton({
        Title = "Teleport to My Base",
        Description = "Instantly teleports to your own base deposit zone",
        Callback = function()
            MiscFunctions.TeleportToMyBase(MainFunctions, UILibrary)
        end
    })

    local function getPlayerNames()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer then
                table.insert(list, p.Name)
            end
        end
        if #list == 0 then table.insert(list, "No other players") end
        return list
    end

    local selectedPlayerToTp = nil
    local PlayerTeleportDropdown = MiscTab:AddDropdown("PlayerTeleportDropdown", {
        Title = "Select Player Base",
        Description = "Choose a target player's base to teleport to",
        Values = getPlayerNames(),
        Default = getPlayerNames()[1] or "",
        Callback = function(Value)
            selectedPlayerToTp = Value
        end
    })
    selectedPlayerToTp = PlayerTeleportDropdown.Value

    Players.PlayerAdded:Connect(function()
        pcall(function() PlayerTeleportDropdown:SetValues(getPlayerNames()) end)
    end)
    Players.PlayerRemoving:Connect(function()
        pcall(function() PlayerTeleportDropdown:SetValues(getPlayerNames()) end)
    end)

    MiscTab:AddButton({
        Title = "Teleport to Selected Player Base",
        Description = "Teleport to the base of the selected player",
        Callback = function()
            if selectedPlayerToTp and selectedPlayerToTp ~= "No other players" then
                MiscFunctions.TeleportToPlayerBase(selectedPlayerToTp, MainFunctions, UILibrary)
            else
                if UILibrary then UILibrary:Notify({ Title = "Teleport", Content = "No valid player selected!", Duration = 3 }) end
            end
        end
    })

    MiscTab:AddButton({
        Title = "Teleport to Shop / Spawn",
        Description = "Instantly teleports to the map shop and egg vendors",
        Callback = function()
            MiscFunctions.TeleportToShop(UILibrary)
        end
    })

    ----------------------------------------------------------------------------
    -- G. SERVER CONTROLS & PERFORMANCE BOOSTER
    ----------------------------------------------------------------------------
    MiscTab:AddSection("Server & Performance Booster")

    local AntiAFKToggle = MiscTab:AddToggle("AntiAFKToggle", {
        Title = "Anti-AFK (20-Min Idle Bypass)",
        Description = "Prevents Roblox from disconnecting you for being idle",
        Default = true
    })
    AntiAFKToggle:OnChanged(function(Value)
        Automation.Flags.AntiAFK = Value
    end)
    Automation.Flags.AntiAFK = true
    MiscFunctions.InitAntiAFK(Automation, UILibrary)

    MiscTab:AddButton({
        Title = "Rejoin Current Server",
        Description = "Reconnect to the same server instance",
        Callback = function()
            MiscFunctions.RejoinServer(UILibrary)
        end
    })

    MiscTab:AddButton({
        Title = "Server Hop (Different Server)",
        Description = "Find and join a different public server",
        Callback = function()
            MiscFunctions.ServerHop(UILibrary)
        end
    })

    local FullPerfToggle = MiscTab:AddToggle("FullPerfToggle", {
        Title = "Full Performance (FPS Booster)",
        Description = "Disables shadows, cleans textures, and optimizes rendering for high FPS",
        Default = false
    })
    FullPerfToggle:OnChanged(function(Value)
        Automation.Flags.AutoFullPerf = Value
        if Value then
            Automation.FullPerformanceMode()
            if UILibrary then
                UILibrary:Notify({ Title = "Performance Boost", Content = "Full Performance mode activated!", Duration = 3 })
            end
        end
    end)

    local Disable3DToggle = MiscTab:AddToggle("Disable3DRenderToggle", {
        Title = "Disable 3D Rendering (0% GPU Usage)",
        Description = "Disables 3D viewport rendering for ultra-efficient multi-account background farming",
        Default = false
    })
    Disable3DToggle:OnChanged(function(Value)
        Automation.Flags.Disable3DRendering = Value
        Automation.Toggle3DRendering(not Value)
    end)
end
