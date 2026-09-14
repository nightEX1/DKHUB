--[[
    DKHUB - Steal An Egg Hub (PRODUCTION v2 - FULL BYPASS)
    Complete Anti-Cheat Bypass + Stealth Mode + Premium UI
    Red & Dark Theme with Smooth Animations
    Drag Icon + Toggle System + UI Modules
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

-- ============================================================================
-- UI-ONLY BUILD: bypass code removed.
-- ============================================================================
-- PREMIUM UI LIBRARY - RED & DARK THEME
-- ============================================================================
local UILibrary = (function()
    local UILibrary = {}
    
    UILibrary.Theme = {
        Primary = Color3.fromRGB(235, 35, 58),      -- Crimson Red
        PrimaryDark = Color3.fromRGB(55, 7, 15),    -- Dark Red
        Background = Color3.fromRGB(7, 7, 11),    -- Almost Black
        Surface = Color3.fromRGB(15, 13, 20),       -- Dark Grey
        SurfaceLight = Color3.fromRGB(31, 18, 25),  -- Lighter Grey
        Text = Color3.fromRGB(255, 255, 255),       -- White
        TextMuted = Color3.fromRGB(176, 158, 165),  -- Grey
        Accent = Color3.fromRGB(255, 70, 84),       -- Red Accent
        Success = Color3.fromRGB(34, 197, 94),      -- Green
        Font = Enum.Font.GothamMedium,
        FontBold = Enum.Font.GothamBold
    }

    function UILibrary:Notify(options)
        options = options or {}
        local title = options.Title or "Notification"
        local content = options.Content or ""
        local duration = options.Duration or 3.5

        local container = CoreGui
        local notifGui = container:FindFirstChild("DKHUB_Notif")
        if not notifGui then
            notifGui = Instance.new("ScreenGui")
            notifGui.Name = "DKHUB_Notif"
            notifGui.ResetOnSpawn = false
            notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            notifGui.Parent = container
        end

        local holder = notifGui:FindFirstChild("NotifHolder")
        if not holder then
            holder = Instance.new("Frame")
            holder.Name = "NotifHolder"
            holder.Size = UDim2.new(0, 340, 1, -40)
            holder.Position = UDim2.new(1, -360, 0, 20)
            holder.BackgroundTransparency = 1
            holder.Parent = notifGui

            local layout = Instance.new("UIListLayout")
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 10)
            layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            layout.Parent = holder
        end

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 80)
        card.BackgroundColor3 = UILibrary.Theme.Surface
        card.Parent = holder

        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 12)
        cardCorner.Parent = card

        local cardStroke = Instance.new("UIStroke")
        cardStroke.Color = UILibrary.Theme.Primary
        cardStroke.Thickness = 2
        cardStroke.Parent = card

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, -20, 0, 22)
        titleLbl.Position = UDim2.new(0, 15, 0, 8)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Font = UILibrary.Theme.FontBold
        titleLbl.Text = title
        titleLbl.TextColor3 = UILibrary.Theme.Primary
        titleLbl.TextSize = 14
        titleLbl.Parent = card

        local contentLbl = Instance.new("TextLabel")
        contentLbl.Size = UDim2.new(1, -20, 0, 40)
        contentLbl.Position = UDim2.new(0, 15, 0, 32)
        contentLbl.BackgroundTransparency = 1
        contentLbl.Font = UILibrary.Theme.Font
        contentLbl.Text = content
        contentLbl.TextColor3 = UILibrary.Theme.Text
        contentLbl.TextSize = 12
        contentLbl.TextWrapped = true
        contentLbl.Parent = card

        TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        
        task.delay(duration, function()
            if card and card.Parent then
                TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 400, 0, 0)}):Play()
                task.wait(0.3)
                card:Destroy()
            end
        end)
    end

    function UILibrary:CreateWindow(options)
        options = options or {}
        local titleText = options.Title or "DKHUB"

        local container = CoreGui
        local existing = container:FindFirstChild("DKHUB_Main")
        if existing then existing:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "DKHUB_Main"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 999999
        gui.Parent = container

        -- DKHUB startup splash: large pulsing mark + smooth 0-100% progress.
        local splash = Instance.new("Frame")
        splash.Name = "DKHUB_Loading"
        splash.Size = UDim2.fromScale(1, 1)
        splash.BackgroundColor3 = UILibrary.Theme.Background
        splash.BorderSizePixel = 0
        splash.ZIndex = 100
        splash.Parent = gui
        local splashMark = Instance.new("TextLabel")
        splashMark.AnchorPoint = Vector2.new(0.5, 0.5)
        splashMark.Position = UDim2.fromScale(0.5, 0.42)
        splashMark.Size = UDim2.fromOffset(190, 120)
        splashMark.BackgroundTransparency = 1
        splashMark.Font = UILibrary.Theme.FontBold
        splashMark.Text = "DK"
        splashMark.TextColor3 = UILibrary.Theme.Primary
        splashMark.TextStrokeColor3 = UILibrary.Theme.Accent
        splashMark.TextStrokeTransparency = 0.15
        splashMark.TextSize = 82
        splashMark.ZIndex = 102
        splashMark.Parent = splash
        local splashSub = Instance.new("TextLabel")
        splashSub.AnchorPoint = Vector2.new(0.5, 0)
        splashSub.Position = UDim2.fromScale(0.5, 0.53)
        splashSub.Size = UDim2.fromOffset(260, 24)
        splashSub.BackgroundTransparency = 1
        splashSub.Font = UILibrary.Theme.FontBold
        splashSub.Text = "DKHUB  /  LOADING"
        splashSub.TextColor3 = UILibrary.Theme.TextMuted
        splashSub.TextSize = 11
        splashSub.ZIndex = 102
        splashSub.Parent = splash
        local loadTrack = Instance.new("Frame")
        loadTrack.AnchorPoint = Vector2.new(0.5, 0)
        loadTrack.Position = UDim2.fromScale(0.5, 0.62)
        loadTrack.Size = UDim2.fromOffset(270, 8)
        loadTrack.BackgroundColor3 = UILibrary.Theme.Surface
        loadTrack.BorderSizePixel = 0
        loadTrack.ZIndex = 102
        loadTrack.Parent = splash
        local loadTrackCorner = Instance.new("UICorner")
        loadTrackCorner.CornerRadius = UDim.new(1, 0)
        loadTrackCorner.Parent = loadTrack
        local loadFill = Instance.new("Frame")
        loadFill.Size = UDim2.new(0, 0, 1, 0)
        loadFill.BackgroundColor3 = UILibrary.Theme.Primary
        loadFill.BorderSizePixel = 0
        loadFill.ZIndex = 103
        loadFill.Parent = loadTrack
        local loadFillCorner = Instance.new("UICorner")
        loadFillCorner.CornerRadius = UDim.new(1, 0)
        loadFillCorner.Parent = loadFill
        local loadPercent = Instance.new("TextLabel")
        loadPercent.AnchorPoint = Vector2.new(0.5, 0)
        loadPercent.Position = UDim2.fromScale(0.5, 0.65)
        loadPercent.Size = UDim2.fromOffset(100, 22)
        loadPercent.BackgroundTransparency = 1
        loadPercent.Font = UILibrary.Theme.FontBold
        loadPercent.Text = "0%"
        loadPercent.TextColor3 = UILibrary.Theme.Primary
        loadPercent.TextSize = 12
        loadPercent.ZIndex = 102
        loadPercent.Parent = splash
        task.spawn(function()
            for percent = 0, 100 do
                loadFill:TweenSize(UDim2.new(percent / 100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.018, true)
                loadPercent.Text = tostring(percent) .. "%"
                splashMark.TextTransparency = (percent % 12 < 6) and 0.05 or 0.22
                task.wait(0.018)
            end
            task.wait(0.25)
            splash:Destroy()
        end)

        -- Main Window
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = UDim2.new(0, 520, 0, 390)
        mainFrame.Position = UDim2.new(0.5, -260, 0.5, -195)
        mainFrame.BackgroundColor3 = UILibrary.Theme.Background
        mainFrame.BorderSizePixel = 0
        mainFrame.Parent = gui

        local mainCorner = Instance.new("UICorner")
        mainCorner.CornerRadius = UDim.new(0, 15)
        mainCorner.Parent = mainFrame

        local mainStroke = Instance.new("UIStroke")
        mainStroke.Color = UILibrary.Theme.Primary
        mainStroke.Thickness = 3
        mainStroke.Parent = mainFrame

        -- Header
        local header = Instance.new("Frame")
        header.Name = "Header"
        header.Size = UDim2.new(1, 0, 0, 50)
        header.BackgroundColor3 = UILibrary.Theme.Background
        header.BorderSizePixel = 0
        header.Parent = mainFrame

        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, 15)
        headerCorner.Parent = header

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, -100, 1, 0)
        titleLbl.Position = UDim2.new(0, 20, 0, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Font = UILibrary.Theme.FontBold
        titleLbl.Text = titleText
        titleLbl.TextColor3 = Color3.new(1, 1, 1)
        titleLbl.TextSize = 16
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = header

        -- Control Buttons
        local minBtn = Instance.new("TextButton")
        minBtn.Name = "MinBtn"
        minBtn.Size = UDim2.new(0, 35, 0, 30)
        minBtn.Position = UDim2.new(1, -75, 0.5, -15)
        minBtn.BackgroundColor3 = UILibrary.Theme.Surface
        minBtn.AutoButtonColor = false
        minBtn.Font = UILibrary.Theme.FontBold
        minBtn.Text = "−"
        minBtn.TextColor3 = UILibrary.Theme.Primary
        minBtn.TextSize = 18
        minBtn.Parent = header

        local minCorner = Instance.new("UICorner")
        minCorner.CornerRadius = UDim.new(0, 6)
        minCorner.Parent = minBtn

        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "CloseBtn"
        closeBtn.Size = UDim2.new(0, 35, 0, 30)
        closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
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

        -- Drag Functionality
        local dragging = false
        local dragStart = nil
        local startPos = nil

        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = mainFrame.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and dragStart then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        -- Sidebar
        local sidebar = Instance.new("ScrollingFrame")
        sidebar.Name = "Sidebar"
        sidebar.Size = UDim2.new(0, 160, 1, -50)
        sidebar.Position = UDim2.new(0, 0, 0, 50)
        sidebar.BackgroundColor3 = UILibrary.Theme.Surface
        sidebar.BorderSizePixel = 0
        sidebar.ScrollBarThickness = 2
        sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
        sidebar.Parent = mainFrame

        local sidebarList = Instance.new("UIListLayout")
        sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
        sidebarList.Padding = UDim.new(0, 2)
        sidebarList.Parent = sidebar

        local sidebarPadding = Instance.new("UIPadding")
        sidebarPadding.PaddingTop = UDim.new(0, 8)
        sidebarPadding.PaddingLeft = UDim.new(0, 8)
        sidebarPadding.PaddingRight = UDim.new(0, 8)
        sidebarPadding.Parent = sidebar

        -- Content Area
        local contentArea = Instance.new("ScrollingFrame")
        contentArea.Name = "ContentArea"
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

        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingTop = UDim.new(0, 12)
        contentPadding.PaddingBottom = UDim.new(0, 12)
        contentPadding.PaddingLeft = UDim.new(0, 12)
        contentPadding.PaddingRight = UDim.new(0, 12)
        contentPadding.Parent = contentArea

        -- Floating Minimize Icon (DRAGABLE)
        local floatIcon = Instance.new("Frame")
        floatIcon.Name = "FloatIcon"
        floatIcon.Size = UDim2.new(0, 72, 0, 72)
        floatIcon.Position = UDim2.new(0, 18, 0.5, -36)
        floatIcon.BackgroundColor3 = UILibrary.Theme.Primary
        floatIcon.BorderSizePixel = 0
        floatIcon.Parent = gui

        local floatCorner = Instance.new("UICorner")
        floatCorner.CornerRadius = UDim.new(0, 18)
        floatCorner.Parent = floatIcon

        local floatStroke = Instance.new("UIStroke")
        floatStroke.Color = UILibrary.Theme.Accent
        floatStroke.Thickness = 3
        floatStroke.Parent = floatIcon

        -- Icon Text
        local iconText = Instance.new("TextLabel")
        iconText.Size = UDim2.new(1, 0, 1, 0)
        iconText.BackgroundTransparency = 1
        iconText.Font = UILibrary.Theme.FontBold
        iconText.Text = "DK"
        iconText.TextColor3 = Color3.new(1, 1, 1)
        iconText.TextSize = 22
        iconText.Parent = floatIcon
        local iconHint = Instance.new("TextLabel")
        iconHint.Name = "ToggleHint"
        iconHint.AnchorPoint = Vector2.new(0.5, 0)
        iconHint.Position = UDim2.new(0.5, 0, 1, 4)
        iconHint.Size = UDim2.new(0, 110, 0, 18)
        iconHint.BackgroundTransparency = 1
        iconHint.Font = UILibrary.Theme.FontBold
        iconHint.Text = "DKHUB  •  MENU"
        iconHint.TextColor3 = UILibrary.Theme.Primary
        iconHint.TextSize = 9
        iconHint.Parent = floatIcon

        -- Float Icon Drag + click toggle (dragging will not toggle the menu).
        local fDragging = false
        local fMoved = false
        local fDragStart = nil
        local fStartPos = nil
        floatIcon.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                fDragging = true
                fMoved = false
                fDragStart = input.Position
                fStartPos = floatIcon.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if fDragging and fDragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - fDragStart
                if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then fMoved = true end
                floatIcon.Position = UDim2.new(fStartPos.X.Scale, fStartPos.X.Offset + delta.X, fStartPos.Y.Scale, fStartPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if fDragging and not fMoved then
                    mainFrame.Visible = not mainFrame.Visible
                    TweenService:Create(floatIcon, TweenInfo.new(0.2), {BackgroundColor3 = mainFrame.Visible and UILibrary.Theme.Primary or UILibrary.Theme.PrimaryDark}):Play()
                end
                fDragging = false
            end
        end)

        -- Window Events
        minBtn.MouseButton1Click:Connect(function()
            mainFrame.Visible = false
        end)

        local windowObj = {
            Gui = gui,
            MainFrame = mainFrame,
            ContentArea = contentArea,
            Tabs = {},
            ActiveTab = nil
        }

        function windowObj:AddTab(options)
            options = options or {}
            local tabTitle = options.Title or "Tab"
            local tabIdx = #windowObj.Tabs + 1

            -- Tab Button
            local tabBtn = Instance.new("TextButton")
            tabBtn.Name = "TabBtn_" .. tabTitle
            tabBtn.Size = UDim2.new(1, 0, 0, 40)
            tabBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            tabBtn.BackgroundTransparency = 1
            tabBtn.AutoButtonColor = false
            tabBtn.Font = UILibrary.Theme.FontBold
            tabBtn.Text = tabTitle
            tabBtn.TextColor3 = UILibrary.Theme.TextMuted
            tabBtn.TextSize = 12
            tabBtn.Parent = sidebar

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = tabBtn

            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = UILibrary.Theme.Primary
            btnStroke.Transparency = 1
            btnStroke.Thickness = 2
            btnStroke.Parent = tabBtn

            -- Tab Container
            local container = Instance.new("Frame")
            container.Name = "Container_" .. tabTitle
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
                Container = container,
                Index = tabIdx
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
                return sec
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

                local cardStroke = Instance.new("UIStroke")
                cardStroke.Color = UILibrary.Theme.Primary
                cardStroke.Transparency = 0.28
                cardStroke.Thickness = 2
                cardStroke.Parent = card

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, -60, 0.5, 0)
                titleLbl.Position = UDim2.new(0, 12, 0, 6)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = UILibrary.Theme.FontBold
                titleLbl.Text = options.Title or "Toggle"
                titleLbl.TextColor3 = UILibrary.Theme.Text
                titleLbl.TextSize = 12
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = card

                local descLbl = Instance.new("TextLabel")
                descLbl.Size = UDim2.new(1, -60, 0.5, 0)
                descLbl.Position = UDim2.new(0, 12, 0.5, 0)
                descLbl.BackgroundTransparency = 1
                descLbl.Font = UILibrary.Theme.Font
                descLbl.Text = options.Description or ""
                descLbl.TextColor3 = UILibrary.Theme.TextMuted
                descLbl.TextSize = 10
                descLbl.TextXAlignment = Enum.TextXAlignment.Left
                descLbl.TextWrapped = true
                descLbl.Parent = card

                -- Toggle Switch
                local switchTrack = Instance.new("Frame")
                switchTrack.Size = UDim2.new(0, 45, 0, 24)
                switchTrack.Position = UDim2.new(1, -50, 0.5, -12)
                switchTrack.BackgroundColor3 = state and UILibrary.Theme.Primary or UILibrary.Theme.SurfaceLight
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
                    local targetColor = val and UILibrary.Theme.Primary or UILibrary.Theme.SurfaceLight
                    TweenService:Create(knob, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
                    TweenService:Create(switchTrack, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
                    TweenService:Create(cardStroke, TweenInfo.new(0.3), {Color = val and Color3.new(1, 1, 1) or UILibrary.Theme.Primary}):Play()
                    pcall(callback, val)
                end

                card.MouseButton1Click:Connect(function()
                    updateToggle(not state)
                end)

                card.MouseEnter:Connect(function()
                    TweenService:Create(card, TweenInfo.new(0.2), {BackgroundColor3 = UILibrary.Theme.SurfaceLight}):Play()
                end)
                card.MouseLeave:Connect(function()
                    TweenService:Create(card, TweenInfo.new(0.2), {BackgroundColor3 = UILibrary.Theme.Surface}):Play()
                end)

                function toggleObj:SetValue(val)
                    updateToggle(val)
                end

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
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = UILibrary.Theme.Accent}):Play()
                end)
                btn.MouseLeave:Connect(function()
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = UILibrary.Theme.Primary}):Play()
                end)
            end

            function tabObj:AddInput(id, options)
                options = options or {}
                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 58)
                card.BackgroundColor3 = UILibrary.Theme.Surface
                card.Parent = container
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 8)
                corner.Parent = card
                local stroke = Instance.new("UIStroke")
                stroke.Color = UILibrary.Theme.Primary
                stroke.Transparency = 0.28
                stroke.Thickness = 2
                stroke.Parent = card
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.34, 0, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.BackgroundTransparency = 1
                label.Font = UILibrary.Theme.FontBold
                label.Text = options.Title or "Input"
                label.TextColor3 = UILibrary.Theme.Text
                label.TextSize = 11
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = card
                local box = Instance.new("TextBox")
                box.Size = UDim2.new(0.58, 0, 0, 32)
                box.Position = UDim2.new(0.38, 0, 0.5, -16)
                box.BackgroundColor3 = UILibrary.Theme.Background
                box.BorderSizePixel = 0
                box.ClearTextOnFocus = false
                box.Font = UILibrary.Theme.Font
                box.PlaceholderText = options.Placeholder or "Enter value..."
                box.Text = options.Default or ""
                box.TextColor3 = UILibrary.Theme.Text
                box.PlaceholderColor3 = UILibrary.Theme.TextMuted
                box.TextSize = 11
                box.TextXAlignment = Enum.TextXAlignment.Left
                box.Parent = card
                local boxCorner = Instance.new("UICorner")
                boxCorner.CornerRadius = UDim.new(0, 6)
                boxCorner.Parent = box
                local inputObj = {Value = box.Text, TextBox = box}
                box.FocusLost:Connect(function()
                    inputObj.Value = box.Text
                    if options.Callback then pcall(options.Callback, box.Text) end
                end)
                return inputObj
            end

            function tabObj:AddSlider(id, options)
                options = options or {}
                local minVal, maxVal = options.Min or 0, options.Max or 100
                local val = options.Default or minVal
                local callback = options.Callback or function() end

                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 50)
                card.BackgroundColor3 = UILibrary.Theme.Surface
                card.Parent = container

                local cardCorner = Instance.new("UICorner")
                cardCorner.CornerRadius = UDim.new(0, 8)
                cardCorner.Parent = card

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, -50, 0, 18)
                titleLbl.Position = UDim2.new(0, 12, 0, 6)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = UILibrary.Theme.FontBold
                titleLbl.Text = options.Title or "Slider"
                titleLbl.TextColor3 = UILibrary.Theme.Text
                titleLbl.TextSize = 12
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = card

                local valLbl = Instance.new("TextLabel")
                valLbl.Size = UDim2.new(0, 45, 0, 18)
                valLbl.Position = UDim2.new(1, -50, 0, 6)
                valLbl.BackgroundTransparency = 1
                valLbl.Font = UILibrary.Theme.FontBold
                valLbl.Text = tostring(val)
                valLbl.TextColor3 = UILibrary.Theme.Primary
                valLbl.TextSize = 12
                valLbl.TextXAlignment = Enum.TextXAlignment.Right
                valLbl.Parent = card

                local slider = Instance.new("TextButton")
                slider.Size = UDim2.new(1, -24, 0, 6)
                slider.Position = UDim2.new(0, 12, 0, 32)
                slider.BackgroundColor3 = UILibrary.Theme.SurfaceLight
                slider.Text = ""
                slider.AutoButtonColor = false
                slider.Parent = card

                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(1, 0)
                sliderCorner.Parent = slider

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new((val - minVal) / (maxVal - minVal), 0, 1, 0)
                fill.BackgroundColor3 = UILibrary.Theme.Primary
                fill.Parent = slider

                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(1, 0)
                fillCorner.Parent = fill

                local function updateSlider(pos)
                    local relX = pos.X - slider.AbsolutePosition.X
                    local pct = math.clamp(relX / slider.AbsoluteSize.X, 0, 1)
                    val = math.floor(minVal + (maxVal - minVal) * pct)
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    valLbl.Text = tostring(val)
                    pcall(callback, val)
                end

                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        updateSlider(input.Position)
                    end
                end)

                return {Value = val}
            end

            tabBtn.MouseButton1Click:Connect(function()
                for _, tab in ipairs(windowObj.Tabs) do
                    tab.Container.Visible = false
                    TweenService:Create(tab.Button, TweenInfo.new(0.2), {TextColor3 = UILibrary.Theme.TextMuted}):Play()
                end
                container.Visible = true
                tabBtn.TextColor3 = UILibrary.Theme.Primary
                windowObj.ActiveTab = tabObj
            end)

            tabBtn.MouseEnter:Connect(function()
                TweenService:Create(tabBtn, TweenInfo.new(0.15), {BackgroundColor3 = UILibrary.Theme.SurfaceLight, BackgroundTransparency = 0.3}):Play()
            end)
            tabBtn.MouseLeave:Connect(function()
                if windowObj.ActiveTab ~= tabObj then
                    TweenService:Create(tabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1}):Play()
                end
            end)

            table.insert(windowObj.Tabs, tabObj)
            return tabObj
        end

        closeBtn.MouseButton1Click:Connect(function()
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -325, 0.5, -500)}):Play()
            task.wait(0.3)
            gui:Destroy()
        end)

        return windowObj
    end

    return UILibrary
end)()

-- ============================================================================
-- UI-ONLY BUILD: automation scheduler removed.
-- ============================================================================

-- ============================================================================
-- CREATE MAIN WINDOW
-- ============================================================================
local Window = UILibrary:CreateWindow({Title = "DKHUB"})

local ProfileTab = Window:AddTab({Title = "Profile"})
ProfileTab:AddSection("PROFILE")
local profileName = ProfileTab:AddInput("ProfileName", {Title = "Name", Placeholder = "Your display name", Default = LocalPlayer and LocalPlayer.DisplayName or "Player"})
local profileInfo = Instance.new("TextLabel")
profileInfo.Size = UDim2.new(1, 0, 0, 86)
profileInfo.BackgroundColor3 = UILibrary.Theme.Surface
profileInfo.Font = UILibrary.Theme.Font
profileInfo.TextColor3 = UILibrary.Theme.Text
profileInfo.TextSize = 12
profileInfo.TextWrapped = true
profileInfo.TextXAlignment = Enum.TextXAlignment.Left
profileInfo.Parent = ProfileTab.Container
local profileCorner = Instance.new("UICorner")
profileCorner.CornerRadius = UDim.new(0, 8)
profileCorner.Parent = profileInfo
local startedAt = os.clock()
local startedClock = os.date("%H:%M:%S")
task.spawn(function()
    while Window.Gui and Window.Gui.Parent do
        local elapsed = math.max(0, math.floor(os.clock() - startedAt))
        profileInfo.Text = string.format("  Name: %s\n  Started: %s\n  Runtime: %02d:%02d:%02d\n  Real time: %s", profileName.Value, startedClock, math.floor(elapsed / 3600), math.floor((elapsed % 3600) / 60), elapsed % 60, os.date("%Y-%m-%d %H:%M:%S"))
        task.wait(1)
    end
end)

local MainTab = Window:AddTab({Title = "Main"})
MainTab:AddSection("MAIN FUNCTIONS")
MainTab:AddButton({Title = "Main functions coming soon", Callback = function() UILibrary:Notify({Title = "Main", Content = "This section is ready for your next modules.", Duration = 3}) end})
MainTab:AddButton({Title = "UI test notification", Callback = function() UILibrary:Notify({Title = "DKHUB", Content = "UI is connected and working.", Duration = 3}) end})

local WebhookTab = Window:AddTab({Title = "Webhook"})
WebhookTab:AddSection("WEBHOOK SETTINGS")
local webhookUrl = ""
local webhookInput = WebhookTab:AddInput("WebhookUrl", {Title = "Webhook URL", Placeholder = "https://discord.com/api/webhooks/...", Callback = function(value) webhookUrl = value end})
WebhookTab:AddButton({Title = "Test / Save Webhook URL", Callback = function()
    webhookUrl = webhookInput.TextBox.Text
    UILibrary:Notify({Title = "Webhook", Content = webhookUrl:match("^https://") and "URL saved locally." or "Please enter a valid HTTPS URL.", Duration = 3})
end})
WebhookTab:AddButton({Title = "Clear Webhook URL", Callback = function() webhookUrl = ""; webhookInput.TextBox.Text = ""; UILibrary:Notify({Title = "Webhook", Content = "URL cleared.", Duration = 2}) end})

local SettingsTab = Window:AddTab({Title = "Settings"})
SettingsTab:AddSection("SETTINGS")
SettingsTab:AddToggle("CompactMode", {Title = "Compact mode", Description = "Keep the menu smaller to show more of the game.", Default = true})
SettingsTab:AddToggle("Animations", {Title = "UI animations", Description = "Enable smooth transitions and feedback.", Default = true})
SettingsTab:AddButton({Title = "Unload UI", Callback = function() if Window.Gui then Window.Gui:Destroy() end end})
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, 0, 0, 58)
info.BackgroundColor3 = UILibrary.Theme.Surface
info.Font = UILibrary.Theme.Font
info.Text = "  DKHUB\n  UI modules: Profile / Main / Webhook / Settings"
info.TextColor3 = UILibrary.Theme.Text
info.TextSize = 11
info.TextXAlignment = Enum.TextXAlignment.Left
info.Parent = SettingsTab.Container
local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = info

Window:SelectTab(1)
UILibrary:Notify({Title = "DKHUB", Content = "Profile, Main, Webhook and Settings loaded.", Duration = 4})
print("[DKHUB] UI modules loaded successfully")
