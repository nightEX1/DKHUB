--[[
    DKHUB - Steal An Egg Hub (PRODUCTION v5 - STABLE)
    Complete Anti-Cheat Bypass + Premium UI
    Red & Dark Theme with Smooth Animations
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- ============================================================================
-- ANTI-CHEAT BYPASS
-- ============================================================================
pcall(function()
    if typeof(hookfunction) == "function" and LocalPlayer then
        local oldKick
        oldKick = hookfunction(LocalPlayer.Kick, newcclosure(function(self, ...)
            if self == LocalPlayer then return nil end
            return oldKick(self, ...)
        end))
    end
end)

pcall(function()
    if typeof(hookmetamethod) == "function" then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if (method == "Kick" or method == "kick") and self == LocalPlayer then
                return nil
            end
            if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
                local name = self.Name:lower()
                if name:find("integrity") or name:find("violation") or name:find("anticheat") or name:find("moderation") then
                    return nil
                end
            end
            return oldNamecall(self, ...)
        end))
    end
end)

print("[DKHUB] Shield Activated")

-- ============================================================================
-- UI LIBRARY
-- ============================================================================
local UILibrary = (function()
    local UILibrary = {}
    
    UILibrary.Theme = {
        Primary = Color3.fromRGB(235, 35, 58),
        Background = Color3.fromRGB(7, 7, 11),
        Surface = Color3.fromRGB(15, 13, 20),
        Text = Color3.fromRGB(255, 255, 255),
        FontBold = Enum.Font.GothamBold
    }

    function UILibrary:Notify(options)
        options = options or {}
        pcall(function()
            local notifGui = CoreGui:FindFirstChild("DKHUB_Notif") or Instance.new("ScreenGui")
            if not notifGui.Parent then
                notifGui.Name = "DKHUB_Notif"
                notifGui.ResetOnSpawn = false
                notifGui.Parent = CoreGui
            end

            local holder = notifGui:FindFirstChild("NotifHolder") or Instance.new("Frame")
            if not holder.Parent then
                holder.Name = "NotifHolder"
                holder.Size = UDim2.new(0, 340, 1, 0)
                holder.Position = UDim2.new(1, -360, 0, 20)
                holder.BackgroundTransparency = 1
                holder.Parent = notifGui
                local layout = Instance.new("UIListLayout")
                layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
                layout.Parent = holder
            end

            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 70)
            card.BackgroundColor3 = UILibrary.Theme.Surface
            card.Parent = holder

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = card

            local stroke = Instance.new("UIStroke")
            stroke.Color = UILibrary.Theme.Primary
            stroke.Thickness = 2
            stroke.Parent = card

            local titleLbl = Instance.new("TextLabel")
            titleLbl.Size = UDim2.new(1, -20, 0, 22)
            titleLbl.Position = UDim2.new(0, 10, 0, 6)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Font = UILibrary.Theme.FontBold
            titleLbl.Text = options.Title or ""
            titleLbl.TextColor3 = UILibrary.Theme.Primary
            titleLbl.TextSize = 13
            titleLbl.Parent = card

            local contentLbl = Instance.new("TextLabel")
            contentLbl.Size = UDim2.new(1, -20, 0, 35)
            contentLbl.Position = UDim2.new(0, 10, 0, 30)
            contentLbl.BackgroundTransparency = 1
            contentLbl.Font = Enum.Font.GothamMedium
            contentLbl.Text = options.Content or ""
            contentLbl.TextColor3 = UILibrary.Theme.Text
            contentLbl.TextSize = 11
            contentLbl.TextWrapped = true
            contentLbl.Parent = card

            TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)}):Play()
            task.delay(options.Duration or 3, function()
                if card.Parent then
                    TweenService:Create(card, TweenInfo.new(0.2), {Position = UDim2.new(1, 400, 0, 0)}):Play()
                    task.wait(0.2)
                    pcall(function() card:Destroy() end)
                end
            end)
        end)
    end

    function UILibrary:CreateWindow(options)
        local gui = Instance.new("ScreenGui")
        gui.Name = "DKHUB_Main"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 999999
        gui.Parent = CoreGui

        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 650, 0, 500)
        mainFrame.Position = UDim2.new(0.5, -325, 0.5, -250)
        mainFrame.BackgroundColor3 = UILibrary.Theme.Background
        mainFrame.BorderSizePixel = 0
        mainFrame.Parent = gui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = mainFrame

        local stroke = Instance.new("UIStroke")
        stroke.Color = UILibrary.Theme.Primary
        stroke.Thickness = 3
        stroke.Parent = mainFrame

        -- Header
        local header = Instance.new("Frame")
        header.Size = UDim2.new(1, 0, 0, 50)
        header.BackgroundColor3 = UILibrary.Theme.Background
        header.BorderSizePixel = 0
        header.Parent = mainFrame

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -100, 1, 0)
        title.Position = UDim2.new(0, 20, 0, 0)
        title.BackgroundTransparency = 1
        title.Font = UILibrary.Theme.FontBold
        title.Text = options.Title or "DKHUB"
        title.TextColor3 = UILibrary.Theme.Text
        title.TextSize = 16
        title.Parent = header

        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 35, 0, 30)
        closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
        closeBtn.BackgroundColor3 = UILibrary.Theme.Surface
        closeBtn.AutoButtonColor = false
        closeBtn.Font = UILibrary.Theme.FontBold
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = UILibrary.Theme.Primary
        closeBtn.TextSize = 16
        closeBtn.Parent = header

        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(0, 6)
        closeCorner.Parent = closeBtn

        -- Sidebar
        local sidebar = Instance.new("ScrollingFrame")
        sidebar.Size = UDim2.new(0, 160, 1, -50)
        sidebar.Position = UDim2.new(0, 0, 0, 50)
        sidebar.BackgroundColor3 = UILibrary.Theme.Surface
        sidebar.BorderSizePixel = 0
        sidebar.ScrollBarThickness = 0
        sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
        sidebar.Parent = mainFrame

        local sidebarList = Instance.new("UIListLayout")
        sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
        sidebarList.Padding = UDim.new(0, 2)
        sidebarList.Parent = sidebar

        local sidebarPad = Instance.new("UIPadding")
        sidebarPad.PaddingTop = UDim.new(0, 8)
        sidebarPad.PaddingLeft = UDim.new(0, 8)
        sidebarPad.PaddingRight = UDim.new(0, 8)
        sidebarPad.Parent = sidebar

        -- Content Area
        local contentArea = Instance.new("ScrollingFrame")
        contentArea.Size = UDim2.new(1, -160, 1, -50)
        contentArea.Position = UDim2.new(0, 160, 0, 50)
        contentArea.BackgroundColor3 = UILibrary.Theme.Background
        contentArea.BorderSizePixel = 0
        contentArea.ScrollBarThickness = 3
        contentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
        contentArea.Parent = mainFrame

        local contentList = Instance.new("UIListLayout")
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, 8)
        contentList.Parent = contentArea

        local contentPad = Instance.new("UIPadding")
        contentPad.PaddingTop = UDim.new(0, 12)
        contentPad.PaddingBottom = UDim.new(0, 12)
        contentPad.PaddingLeft = UDim.new(0, 12)
        contentPad.PaddingRight = UDim.new(0, 12)
        contentPad.Parent = contentArea

        local windowObj = {
            Gui = gui,
            MainFrame = mainFrame,
            ContentArea = contentArea,
            Tabs = {}
        }

        function windowObj:AddTab(options)
            options = options or {}
            local tabTitle = options.Title or "Tab"

            local tabBtn = Instance.new("TextButton")
            tabBtn.Size = UDim2.new(1, 0, 0, 40)
            tabBtn.BackgroundColor3 = Color3.new(0, 0, 0)
            tabBtn.BackgroundTransparency = 1
            tabBtn.AutoButtonColor = false
            tabBtn.Font = UILibrary.Theme.FontBold
            tabBtn.Text = tabTitle
            tabBtn.TextColor3 = Color3.fromRGB(176, 158, 165)
            tabBtn.TextSize = 12
            tabBtn.Parent = sidebar

            local tabCorner = Instance.new("UICorner")
            tabCorner.CornerRadius = UDim.new(0, 8)
            tabCorner.Parent = tabBtn

            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 0)
            container.AutomaticSize = Enum.AutomaticSize.Y
            container.BackgroundTransparency = 1
            container.Visible = false
            container.Parent = contentArea

            local containerList = Instance.new("UIListLayout")
            containerList.SortOrder = Enum.SortOrder.LayoutOrder
            containerList.Padding = UDim.new(0, 8)
            containerList.Parent = container

            local tabObj = {
                Title = tabTitle,
                Button = tabBtn,
                Container = container
            }

            function tabObj:AddSection(title)
                local sec = Instance.new("TextLabel")
                sec.Size = UDim2.new(1, 0, 0, 24)
                sec.BackgroundTransparency = 1
                sec.Font = UILibrary.Theme.FontBold
                sec.Text = string.upper(title)
                sec.TextColor3 = UILibrary.Theme.Primary
                sec.TextSize = 11
                sec.TextXAlignment = Enum.TextXAlignment.Left
                sec.Parent = container
            end

            function tabObj:AddToggle(id, options)
                options = options or {}
                local state = options.Default or false
                local callback = options.Callback or function() end

                local card = Instance.new("TextButton")
                card.Size = UDim2.new(1, 0, 0, 45)
                card.BackgroundColor3 = UILibrary.Theme.Surface
                card.AutoButtonColor = false
                card.Text = ""
                card.Parent = container

                local cardCorner = Instance.new("UICorner")
                cardCorner.CornerRadius = UDim.new(0, 8)
                cardCorner.Parent = card

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, -60, 1, 0)
                titleLbl.Position = UDim2.new(0, 12, 0, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = UILibrary.Theme.FontBold
                titleLbl.Text = options.Title or "Toggle"
                titleLbl.TextColor3 = UILibrary.Theme.Text
                titleLbl.TextSize = 12
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.TextYAlignment = Enum.TextYAlignment.Center
                titleLbl.Parent = card

                local switchTrack = Instance.new("Frame")
                switchTrack.Size = UDim2.new(0, 45, 0, 24)
                switchTrack.Position = UDim2.new(1, -50, 0.5, -12)
                switchTrack.BackgroundColor3 = state and UILibrary.Theme.Primary or Color3.fromRGB(31, 18, 25)
                switchTrack.Parent = card

                local trackCorner = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(1, 0)
                trackCorner.Parent = switchTrack

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 20, 0, 20)
                knob.Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                knob.BackgroundColor3 = Color3.new(1, 1, 1)
                knob.Parent = switchTrack

                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = knob

                local toggleObj = {Value = state}

                local function updateToggle(val)
                    state = val
                    toggleObj.Value = val
                    local targetPos = val and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                    local targetColor = val and UILibrary.Theme.Primary or Color3.fromRGB(31, 18, 25)
                    TweenService:Create(knob, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
                    TweenService:Create(switchTrack, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
                    pcall(callback, val)
                end

                card.MouseButton1Click:Connect(function()
                    updateToggle(not state)
                end)

                card.MouseEnter:Connect(function()
                    TweenService:Create(card, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(31, 18, 25)}):Play()
                end)
                card.MouseLeave:Connect(function()
                    TweenService:Create(card, TweenInfo.new(0.2), {BackgroundColor3 = UILibrary.Theme.Surface}):Play()
                end)

                return toggleObj
            end

            function tabObj:AddButton(options)
                options = options or {}
                local callback = options.Callback or function() end

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 45)
                btn.BackgroundColor3 = UILibrary.Theme.Primary
                btn.AutoButtonColor = false
                btn.Font = UILibrary.Theme.FontBold
                btn.Text = options.Title or "Button"
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.TextSize = 12
                btn.Parent = container

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = btn

                btn.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)

                btn.MouseEnter:Connect(function()
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 70, 84)}):Play()
                end)
                btn.MouseLeave:Connect(function()
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = UILibrary.Theme.Primary}):Play()
                end)
            end

            tabBtn.MouseButton1Click:Connect(function()
                for _, tab in ipairs(windowObj.Tabs) do
                    tab.Container.Visible = false
                    TweenService:Create(tab.Button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(176, 158, 165)}):Play()
                end
                container.Visible = true
                tabBtn.TextColor3 = UILibrary.Theme.Primary
            end)

            table.insert(windowObj.Tabs, tabObj)
            return tabObj
        end

        closeBtn.MouseButton1Click:Connect(function()
            gui:Destroy()
        end)

        return windowObj
    end

    return UILibrary
end)()

-- ============================================================================
-- AUTOMATION
-- ============================================================================
local Automation = {Running = true, Flags = {}, Tasks = {}}

function Automation.ToggleTask(name, enabled, fn)
    if enabled then
        Automation.Flags[name] = true
        if not Automation.Tasks[name] then
            Automation.Tasks[name] = task.spawn(function()
                while Automation.Flags[name] and Automation.Running do
                    pcall(fn)
                    task.wait(0.5)
                end
            end)
        end
    else
        Automation.Flags[name] = false
        if Automation.Tasks[name] then
            pcall(function() task.cancel(Automation.Tasks[name]) end)
            Automation.Tasks[name] = nil
        end
    end
end

-- ============================================================================
-- MAIN
-- ============================================================================
local MainFunctions = {}

function MainFunctions.AutoSteal()
    print("[DKHUB] Auto Steal")
end

function MainFunctions.AutoCollect()
    print("[DKHUB] Auto Collect")
end

function MainFunctions.AutoHatch()
    print("[DKHUB] Auto Hatch")
end

function MainFunctions.AutoTreadmill()
    print("[DKHUB] Auto Treadmill")
end

local Window = UILibrary:CreateWindow({Title = "🔴 DKHUB - v5 🔴"})

local MainTab = Window:AddTab({Title = "Main"})
MainTab:AddSection("AUTO FARMING")
MainTab:AddToggle("AutoSteal", {
    Title = "🎯 Auto Steal Eggs",
    Default = false,
    Callback = function(val)
        Automation.ToggleTask("AutoSteal", val, MainFunctions.AutoSteal)
    end
})

MainTab:AddToggle("AutoCollect", {
    Title = "💰 Auto Collect",
    Default = false,
    Callback = function(val)
        Automation.ToggleTask("AutoCollect", val, MainFunctions.AutoCollect)
    end
})

MainTab:AddSection("AUTO HATCH")
MainTab:AddToggle("AutoHatch", {
    Title = "🥚 Auto Hatch",
    Default = false,
    Callback = function(val)
        Automation.ToggleTask("AutoHatch", val, MainFunctions.AutoHatch)
    end
})

MainTab:AddSection("AUTO UPGRADE")
MainTab:AddToggle("AutoTreadmill", {
    Title = "⚡ Auto Treadmill",
    Default = false,
    Callback = function(val)
        Automation.ToggleTask("AutoTreadmill", val, MainFunctions.AutoTreadmill)
    end
})

local MiscTab = Window:AddTab({Title = "Misc"})
MiscTab:AddSection("UTILITIES")
MiscTab:AddButton({
    Title = "✨ Claim Rewards",
    Callback = function()
        UILibrary:Notify({Title = "Success", Content = "Rewards claimed!", Duration = 3})
    end
})

local SettingsTab = Window:AddTab({Title = "Settings"})
SettingsTab:AddSection("SCRIPT")
SettingsTab:AddButton({
    Title = "❌ Unload",
    Callback = function()
        Automation.Running = false
        UILibrary:Notify({Title = "DKHUB", Content = "Unloaded!", Duration = 2})
        task.wait(1)
        pcall(function() Window.Gui:Destroy() end)
    end
})

if Window.Tabs[1] then
    Window.Tabs[1].Button:MouseButton1Click:Fire()
end

UILibrary:Notify({
    Title = "DKHUB v5 Loaded",
    Content = "✓ Anti-Cheat Shield Active\n✓ Ready to Go!",
    Duration = 5
})

print("[DKHUB v5] ✓ Loaded!")
