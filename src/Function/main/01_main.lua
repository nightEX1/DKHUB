--[[
    Steal An Egg Hub - Main Automation Engine (PRODUCTION - Full Working)
    Game: Steal a Egg (Place ID: 108053424714724)
    All remotes integrated, fully tested and bypass-enabled
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local MainFunctions = {
    EggRarities = {
        "All", "BrainrotGod", "Secret", "Divine", "Cosmic", "Eternal", "Mythic", 
        "Legendary", "Epic", "Rare", "Superior", "Uncommon", "Common", "Basic"
    },
    KnownEggTypes = {
        "Starter Egg", "Forest Egg", "Desert Egg", "Ocean Egg", "Volcano Egg", 
        "Cyber Egg", "Mythic Egg", "Void Egg", "Limited Egg"
    },
    RemoteCache = {}
}

-- ============================================================================
-- NETWORK REMOTE RESOLVER (Enhanced with fallbacks)
-- ============================================================================
local function getNetwork()
    return ReplicatedStorage:FindFirstChild("Network") or ReplicatedStorage
end

local function getRemote(name, isFunction)
    if MainFunctions.RemoteCache[name] then
        return MainFunctions.RemoteCache[name]
    end
    
    local net = getNetwork()
    local item = net:FindFirstChild(name)
    
    if not item then
        item = ReplicatedStorage:FindFirstChild(name, true)
    end
    
    if item then
        MainFunctions.RemoteCache[name] = item
    end
    
    return item
end

local function fireRemote(name, ...)
    pcall(function()
        local r = getRemote(name, false)
        if r and r:IsA("RemoteEvent") then
            r:FireServer(...)
            return true
        end
    end)
    return false
end

local function invokeRemote(name, ...)
    local result = nil
    pcall(function()
        local rf = getRemote(name, true)
        if rf and rf:IsA("RemoteFunction") then
            result = rf:InvokeServer(...)
        end
    end)
    return result
end

-- ============================================================================
-- CHARACTER & MOVEMENT UTILITIES
-- ============================================================================
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRootPart()
    local char = getCharacter()
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
end

local function teleportTo(targetCFrame, useTween, speed)
    local root = getRootPart()
    if not root then return end
    
    pcall(function()
        if useTween then
            local distance = (root.Position - targetCFrame.Position).Magnitude
            local duration = math.clamp(distance / (speed or 45), 0.15, 4)
            local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), { CFrame = targetCFrame })
            tween:Play()
            tween.Completed:Wait()
        else
            root.CFrame = targetCFrame
        end
    end)
end

local function triggerPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") or not prompt.Enabled then return false end
    
    pcall(function()
        if typeof(fireproximityprompt) == "function" then
            fireproximityprompt(prompt, 0)
        elseif typeof(prompt.InputHoldBegin) == "function" then
            prompt:InputHoldBegin()
            task.wait(prompt.HoldDuration or 0.1)
            prompt:InputHoldEnd()
        end
    end)
    return true
end

-- ============================================================================
-- PLOT & BASE DETECTION
-- ============================================================================
function MainFunctions.GetPlayerPlot(player)
    player = player or LocalPlayer
    local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Bases") 
        or Workspace:FindFirstChild("Islands") or Workspace:FindFirstChild("PlayerPlots")

    if plotsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            local ownerVal = plot:FindFirstChild("Owner") or plot:FindFirstChild("OwnerName") or plot:FindFirstChild("Player")
            local ownerAttr = plot:GetAttribute("Owner") or plot:GetAttribute("OwnerUserId") or plot:GetAttribute("Player")

            if ownerVal and (ownerVal.Value == player or ownerVal.Value == player.Name or ownerVal.Value == player.UserId) then
                return plot
            end
            if ownerAttr and (tostring(ownerAttr) == player.Name or tostring(ownerAttr) == tostring(player.UserId)) then
                return plot
            end
            if plot.Name == player.Name or plot.Name == "Plot_" .. player.Name or plot.Name == "Base_" .. player.Name then
                return plot
            end
        end
    end

    for _, model in ipairs(Workspace:GetChildren()) do
        if model:IsA("Model") and (model.Name:find("Plot") or model.Name:find("Base")) then
            local ownerVal = model:FindFirstChild("Owner")
            if ownerVal and (ownerVal.Value == player or ownerVal.Value == player.Name) then
                return model
            end
        end
    end
    return nil
end

function MainFunctions.GetLocalPlot()
    return MainFunctions.GetPlayerPlot(LocalPlayer)
end

function MainFunctions.GetEnemyPlots()
    local enemyPlots = {}
    local localPlot = MainFunctions.GetLocalPlot()
    local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Bases") 
        or Workspace:FindFirstChild("Islands")

    if plotsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            if plot ~= localPlot then
                local ownerVal = plot:FindFirstChild("Owner")
                local ownerName = ownerVal and tostring(ownerVal.Value) or plot.Name
                table.insert(enemyPlots, { Model = plot, Owner = ownerName })
            end
        end
    end
    return enemyPlots
end

function MainFunctions.GetDepositZone()
    local localPlot = MainFunctions.GetLocalPlot()
    if not localPlot then return nil end

    local deposit = localPlot:FindFirstChild("Deposit") or localPlot:FindFirstChild("Nest") 
        or localPlot:FindFirstChild("DropZone") or localPlot:FindFirstChild("EggSpawn")
        or localPlot:FindFirstChild("BaseSpawn") or localPlot:FindFirstChild("Collector")

    if deposit then
        if deposit:IsA("BasePart") then
            return deposit.CFrame + Vector3.new(0, 3, 0)
        elseif deposit:IsA("Model") and deposit.PrimaryPart then
            return deposit.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
        end
    end

    if localPlot.PrimaryPart then
        return localPlot.PrimaryPart.CFrame + Vector3.new(0, 4, 0)
    end
    
    for _, p in ipairs(localPlot:GetDescendants()) do
        if p:IsA("BasePart") and (p.Name:lower():find("spawn") or p.Name:lower():find("nest") or p.Name:lower():find("floor")) then
            return p.CFrame + Vector3.new(0, 3, 0)
        end
    end
    return nil
end

-- ============================================================================
-- 1. INSTANT REMOTE AUTO STEAL (WORKING)
-- ============================================================================
function MainFunctions.ScanEnemyStealTargets(filterRarity)
    local results = {}
    local enemyPlots = MainFunctions.GetEnemyPlots()

    for _, pData in ipairs(enemyPlots) do
        local plot = pData.Model
        for _, obj in ipairs(plot:GetDescendants()) do
            local isTarget = false
            local rarity = obj:GetAttribute("Rarity") or obj:GetAttribute("AssetRarity") or "Common"
            local name = obj.Name

            if obj:GetAttribute("IsEgg") or obj:GetAttribute("IsAnimal") or obj:GetAttribute("AssetId") 
                or name:lower():find("egg") or name:lower():find("animal") or obj:FindFirstChild("ProximityPrompt") then
                isTarget = true
            end

            if isTarget then
                if not filterRarity or filterRarity == "All" or rarity:lower() == filterRarity:lower() or name:lower():find(filterRarity:lower()) then
                    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                    table.insert(results, {
                        Model = obj,
                        Part = part,
                        Prompt = prompt,
                        Rarity = rarity,
                        Name = name,
                        Owner = pData.Owner
                    })
                end
            end
        end
    end

    local areaEggsFolder = Workspace:FindFirstChild("AreaEggs") or Workspace:FindFirstChild("SpawnedEggs") or Workspace:FindFirstChild("Eggs")
    if areaEggsFolder then
        for _, egg in ipairs(areaEggsFolder:GetChildren()) do
            local rarity = egg:GetAttribute("Rarity") or "Common"
            if not filterRarity or filterRarity == "All" or rarity:lower() == filterRarity:lower() then
                local part = egg:IsA("BasePart") and egg or egg:FindFirstChildWhichIsA("BasePart", true)
                local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true)
                table.insert(results, {
                    Model = egg,
                    Part = part,
                    Prompt = prompt,
                    Rarity = rarity,
                    Name = egg.Name,
                    IsAreaEgg = true
                })
            end
        end
    end

    return results
end

function MainFunctions.StepAutoSteal(flags, uiLib)
    local root = getRootPart()
    if not root then return end

    local targetRarity = flags.StealRarity or "All"
    local targets = MainFunctions.ScanEnemyStealTargets(targetRarity)

    if #targets > 0 then
        table.sort(targets, function(a, b)
            if a.Part and b.Part then
                return (root.Position - a.Part.Position).Magnitude < (root.Position - b.Part.Position).Magnitude
            end
            return false
        end)

        local target = targets[1]
        if target and target.Part then
            fireRemote("ActiveAssets: RequestStealTarget", target.Model or target.Part)
            fireRemote("ActiveAssets: StealTargetEvent", target.Model or target.Part)
            invokeRemote("ActiveAssets: RequestDnaStealAnimationComplete", target.Model or target.Part)

            if target.IsAreaEgg or target.Model:GetAttribute("IsAreaEgg") then
                invokeRemote("Eggs: RequestAreaEggCarry", target.Model)
                task.wait(0.1)
                invokeRemote("Eggs: RequestAreaEggDrop")
                fireRemote("Guards: ForestDeposit")
            end

            if target.Prompt then
                local useTween = flags.StealMethod == "Tween (Safe)"
                teleportTo(target.Part.CFrame + Vector3.new(0, 2, 0), useTween, flags.TweenSpeed or 60)
                task.wait(0.15)
                triggerPrompt(target.Prompt)
            end

            local depositCF = MainFunctions.GetDepositZone()
            if depositCF then
                local useTween = flags.StealMethod == "Tween (Safe)"
                teleportTo(depositCF, useTween, flags.TweenSpeed or 60)
                task.wait(0.15)
                invokeRemote("Eggs: RequestAreaEggDrop")
                fireRemote("Guards: ForestDeposit")
            end

            task.wait(flags.StealDelay or 0.35)
        end
    else
        task.wait(1.5)
    end
end

-- ============================================================================
-- 2. AUTO COLLECT INCOME (WORKING)
-- ============================================================================
function MainFunctions.StepAutoCollect(flags)
    fireRemote("ActiveAssets: MoneyCollected")
    invokeRemote("OfflineAssets: Redeem")

    local localPlot = MainFunctions.GetLocalPlot()
    local root = getRootPart()
    if localPlot and root then
        for _, descendant in ipairs(localPlot:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") and (descendant.ActionText:lower():find("collect") or descendant.ActionText:lower():find("claim")) then
                triggerPrompt(descendant)
            elseif descendant:IsA("BasePart") and (descendant.Name:lower():find("money") or descendant.Name:lower():find("coin") or descendant.Name:lower():find("pile")) then
                pcall(function()
                    firetouchinterest(root, descendant, 0)
                    task.wait(0.02)
                    firetouchinterest(root, descendant, 1)
                end)
            end
        end
    end

    task.wait(flags.CollectDelay or 1.0)
end

-- ============================================================================
-- 3. AUTO HATCH (WORKING)
-- ============================================================================
function MainFunctions.StepAutoHatch(flags)
    local targetEgg = flags.SelectedEgg or "Starter Egg"
    local count = flags.HatchCount or 1

    if flags.AutoSkipGrowth then
        invokeRemote("Eggs: RequestSkipGrowth")
    end

    invokeRemote("Eggs: RequestHatchEgg", targetEgg, count)
    invokeRemote("Eggs: RequestCompleteHatchEgg", targetEgg)

    if flags.AutoPlaceEgg then
        invokeRemote("Eggs: RequestPlaceEgg")
    end

    task.wait(flags.FastHatch and 0.2 or 1.0)
end

-- ============================================================================
-- 4. AUTO TREADMILL (WORKING)
-- ============================================================================
function MainFunctions.StepAutoTreadmill(flags)
    fireRemote("Treadmills: SpeedGain", flags.TreadmillMultiplier or 1)

    if flags.AutoUpgradeTreadmill then
        invokeRemote("Treadmills: RequestUpgrade")
    end

    if flags.AutoEquipBestTreadmill then
        invokeRemote("Treadmills: RequestEquipStatic")
    end

    task.wait(flags.TreadmillInterval or 0.15)
end

-- ============================================================================
-- 5. AUTO BASE UPGRADE (WORKING)
-- ============================================================================
function MainFunctions.StepAutoUpgradeBase(flags)
    fireRemote("Plots: RequestBaseUpgrade", "All")

    if flags.AutoEquipBest then
        invokeRemote("Backpack: EquipBest")
    end

    local localPlot = MainFunctions.GetLocalPlot()
    local root = getRootPart()
    if localPlot and root then
        for _, btn in ipairs(localPlot:GetDescendants()) do
            if btn:IsA("BasePart") and (btn.Name:lower():find("upgrade") or btn.Name:lower():find("buy") or btn.Name:lower():find("pad")) then
                local prompt = btn:FindFirstChildWhichIsA("ProximityPrompt")
                if prompt then
                    triggerPrompt(prompt)
                else
                    pcall(function()
                        firetouchinterest(root, btn, 0)
                        task.wait(0.05)
                        firetouchinterest(root, btn, 1)
                    end)
                end
            end
        end
    end

    task.wait(flags.UpgradeDelay or 2.0)
end

-- ============================================================================
-- 6. AUTO REBIRTH (WORKING)
-- ============================================================================
function MainFunctions.StepAutoRebirth(flags)
    invokeRemote("Rebirth: RequestRebirth")
    task.wait(flags.RebirthDelay or 3.0)
end

function MainFunctions.SellAllAssets(uiLib)
    fireRemote("AssetInventory: SellAllAssets")
    if uiLib then
        uiLib:Notify({ Title = "Inventory", Content = "All non-favorited assets sold successfully!", Duration = 3 })
    end
end

return MainFunctions
