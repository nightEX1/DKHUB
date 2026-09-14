--[[
    Steal An Egg Hub - Main Tab Sub-Menu UI
    Configures Auto Steal, Auto Collect, Auto Hatch, Treadmill Farm, Base Upgrades, and Rebirth.
--]]

return function(MainTab, Automation, MainFunctions, MiscFunctions, UILibrary)
    ----------------------------------------------------------------------------
    -- A. SUPER AUTO STEAL (REMOTE & PROXIMITY INTEGRATED)
    ----------------------------------------------------------------------------
    MainTab:AddSection("Auto Steal Eggs & Assets")

    local AutoStealToggle = MainTab:AddToggle("AutoStealToggle", {
        Title = "Enable Super Auto Steal",
        Description = "Instantly steals target eggs/animals from enemy plots, bypasses steal animation, and secures them to your base",
        Default = false
    })

    AutoStealToggle:OnChanged(function(Value)
        Automation.Flags.AutoSteal = Value
        Automation.ToggleTask("AutoSteal", Value, function()
            MainFunctions.StepAutoSteal(Automation.Flags, UILibrary)
        end)
    end)

    local StealRarityDropdown = MainTab:AddDropdown("StealRarityDropdown", {
        Title = "Target Rarity Tier",
        Description = "Select which egg/animal rarity to target",
        Values = MainFunctions.EggRarities,
        Default = "All",
        Callback = function(Value)
            Automation.Flags.StealRarity = Value
        end
    })
    Automation.Flags.StealRarity = StealRarityDropdown.Value or "All"

    local StealMethodDropdown = MainTab:AddDropdown("StealMethodDropdown", {
        Title = "Movement Mode",
        Description = "Instant TP (fastest) or Smooth Tween (safe mode)",
        Values = { "Instant TP", "Tween (Safe)" },
        Default = "Instant TP",
        Callback = function(Value)
            Automation.Flags.StealMethod = Value
        end
    })
    Automation.Flags.StealMethod = StealMethodDropdown.Value or "Instant TP"

    local StealDelaySlider = MainTab:AddSlider("StealDelaySlider", {
        Title = "Steal Delay (Sec)",
        Min = 0.1,
        Max = 2.0,
        Default = 0.35,
        Rounding = 2,
        Callback = function(Value)
            Automation.Flags.StealDelay = Value
        end
    })
    Automation.Flags.StealDelay = StealDelaySlider.Value or 0.35

    ----------------------------------------------------------------------------
    -- B. AUTO COLLECT INCOME & OFFLINE MONEY
    ----------------------------------------------------------------------------
    MainTab:AddSection("Auto Collect & Cash Flow")

    local AutoCollectToggle = MainTab:AddToggle("AutoCollectToggle", {
        Title = "Auto Collect Animal & Plot Income",
        Description = "Automatically claims coin drops, animal earnings, and redeems offline vault cash",
        Default = false
    })

    AutoCollectToggle:OnChanged(function(Value)
        Automation.Flags.AutoCollect = Value
        Automation.ToggleTask("AutoCollect", Value, function()
            MainFunctions.StepAutoCollect(Automation.Flags)
        end)
    end)

    local CollectDelaySlider = MainTab:AddSlider("CollectDelaySlider", {
        Title = "Collect Interval (Sec)",
        Min = 0.2,
        Max = 4.0,
        Default = 1.0,
        Rounding = 1,
        Callback = function(Value)
            Automation.Flags.CollectDelay = Value
        end
    })
    Automation.Flags.CollectDelay = CollectDelaySlider.Value or 1.0

    MainTab:AddButton({
        Title = "Sell All Non-Favorite Assets Now",
        Description = "Instantly clears inventory and sells all unlocked assets/pets for maximum cash",
        Callback = function()
            MainFunctions.SellAllAssets(UILibrary)
        end
    })

    ----------------------------------------------------------------------------
    -- C. AUTO HATCH & FAST EGG GROWTH
    ----------------------------------------------------------------------------
    MainTab:AddSection("Auto Hatch & Egg Growth")

    local AutoHatchToggle = MainTab:AddToggle("AutoHatchToggle", {
        Title = "Enable Auto Hatch",
        Description = "Continuously buys and opens selected eggs",
        Default = false
    })

    AutoHatchToggle:OnChanged(function(Value)
        Automation.Flags.AutoHatch = Value
        Automation.ToggleTask("AutoHatch", Value, function()
            MainFunctions.StepAutoHatch(Automation.Flags)
        end)
    end)

    local SelectedEggDropdown = MainTab:AddDropdown("SelectedEggDropdown", {
        Title = "Select Egg Type",
        Description = "Choose which egg model/tier to hatch",
        Values = MainFunctions.KnownEggTypes,
        Default = "Starter Egg",
        Callback = function(Value)
            Automation.Flags.SelectedEgg = Value
        end
    })
    Automation.Flags.SelectedEgg = SelectedEggDropdown.Value or "Starter Egg"

    local AutoSkipGrowthToggle = MainTab:AddToggle("AutoSkipGrowthToggle", {
        Title = "Auto Skip Growth Time (Instant Ready)",
        Description = "Instantly skips the egg growth timer so eggs mature immediately",
        Default = true
    })
    AutoSkipGrowthToggle:OnChanged(function(Value)
        Automation.Flags.AutoSkipGrowth = Value
    end)
    Automation.Flags.AutoSkipGrowth = true

    local AutoPlaceEggToggle = MainTab:AddToggle("AutoPlaceEggToggle", {
        Title = "Auto Place Eggs to Plot",
        Description = "Automatically places new eggs into your base pen/nest",
        Default = true
    })
    AutoPlaceEggToggle:OnChanged(function(Value)
        Automation.Flags.AutoPlaceEgg = Value
    end)
    Automation.Flags.AutoPlaceEgg = true

    local FastHatchToggle = MainTab:AddToggle("FastHatchToggle", {
        Title = "Fast Hatch (Skip Cutscenes)",
        Description = "Bypasses opening animations for rapid-fire hatching",
        Default = true
    })
    FastHatchToggle:OnChanged(function(Value)
        Automation.Flags.FastHatch = Value
    end)
    Automation.Flags.FastHatch = true

    local HatchCountSlider = MainTab:AddSlider("HatchCountSlider", {
        Title = "Hatch Batch Count",
        Min = 1,
        Max = 8,
        Default = 1,
        Rounding = 0,
        Callback = function(Value)
            Automation.Flags.HatchCount = Value
        end
    })
    Automation.Flags.HatchCount = HatchCountSlider.Value or 1

    ----------------------------------------------------------------------------
    -- D. AUTO TREADMILL (SPEED & POWER FARM)
    ----------------------------------------------------------------------------
    MainTab:AddSection("Auto Treadmill (Speed & Power Farm)")

    local AutoTreadmillToggle = MainTab:AddToggle("AutoTreadmillToggle", {
        Title = "Enable Auto Treadmill Farm",
        Description = "Continuously farms Speed Power and upgrades your treadmill for maximum multiplier",
        Default = false
    })

    AutoTreadmillToggle:OnChanged(function(Value)
        Automation.Flags.AutoTreadmill = Value
        Automation.ToggleTask("AutoTreadmill", Value, function()
            MainFunctions.StepAutoTreadmill(Automation.Flags)
        end)
    end)

    local AutoUpgradeTreadmillToggle = MainTab:AddToggle("AutoUpgradeTreadmillToggle", {
        Title = "Auto Upgrade Treadmill Level",
        Description = "Automatically purchases treadmill upgrades when enough points are gained",
        Default = true
    })
    AutoUpgradeTreadmillToggle:OnChanged(function(Value)
        Automation.Flags.AutoUpgradeTreadmill = Value
    end)
    Automation.Flags.AutoUpgradeTreadmill = true

    local AutoEquipBestTreadmillToggle = MainTab:AddToggle("AutoEquipBestTreadmillToggle", {
        Title = "Auto Equip Best Treadmill",
        Description = "Automatically equips highest tier unlocked treadmill",
        Default = true
    })
    AutoEquipBestTreadmillToggle:OnChanged(function(Value)
        Automation.Flags.AutoEquipBestTreadmill = Value
    end)
    Automation.Flags.AutoEquipBestTreadmill = true

    ----------------------------------------------------------------------------
    -- E. AUTO BASE UPGRADES & PET MANAGER
    ----------------------------------------------------------------------------
    MainTab:AddSection("Auto Base Upgrades & Pet Manager")

    local AutoUpgradeBaseToggle = MainTab:AddToggle("AutoUpgradeBaseToggle", {
        Title = "Auto Upgrade Base & Defenses",
        Description = "Automatically buys base walls, laser gates, and defenses as soon as you have enough coins",
        Default = false
    })

    AutoUpgradeBaseToggle:OnChanged(function(Value)
        Automation.Flags.AutoUpgradeBase = Value
        Automation.ToggleTask("AutoUpgradeBase", Value, function()
            MainFunctions.StepAutoUpgradeBase(Automation.Flags)
        end)
    end)

    local AutoEquipBestPetsToggle = MainTab:AddToggle("AutoEquipBestPetsToggle", {
        Title = "Auto Equip Best Income Pets",
        Description = "Constantly ensures your highest income earning pets are equipped in your pen",
        Default = true
    })
    AutoEquipBestPetsToggle:OnChanged(function(Value)
        Automation.Flags.AutoEquipBest = Value
    end)
    Automation.Flags.AutoEquipBest = true

    ----------------------------------------------------------------------------
    -- F. AUTO REBIRTH
    ----------------------------------------------------------------------------
    MainTab:AddSection("Auto Rebirth")

    local AutoRebirthToggle = MainTab:AddToggle("AutoRebirthToggle", {
        Title = "Enable Auto Rebirth",
        Description = "Automatically triggers rebirth once required coins/stats are reached to multiply coin earnings",
        Default = false
    })

    AutoRebirthToggle:OnChanged(function(Value)
        Automation.Flags.AutoRebirth = Value
        Automation.ToggleTask("AutoRebirth", Value, function()
            MainFunctions.StepAutoRebirth(Automation.Flags)
        end)
    end)
end
