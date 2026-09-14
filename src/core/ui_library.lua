--[[
    Steal An Egg Hub - DKHUB Native UI Library
    Distinctive Bespoke Visual Identity (DKHUB Cosmic Obsidian Aesthetic #A855F7)
    Features: Full-Screen Sub-Panel Dropdown Overlays, Live Search, Multi-Select Quick Actions,
    Collapsible Sections, Responsive Mobile/Touch Dragging, Floating Toggle Bubble, Zero Dependencies.
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local UILibrary = {}

UILibrary.Theme = {
    Background      = Color3.fromRGB(15, 12, 24),       -- Deep Cosmic Obsidian (#0F0C18)
    Sidebar         = Color3.fromRGB(22, 17, 36),       -- Deep Slate Violet (#161124)
    Header          = Color3.fromRGB(22, 17, 36),       -- Header Bar
    Card            = Color3.fromRGB(28, 22, 46),       -- Card Surface (#1C162E)
    CardHover       = Color3.fromRGB(40, 31, 66),       -- Card Hover State (#281F42)
    CardSelected    = Color3.fromRGB(52, 38, 86),       -- Card Selected (#342656)
    Border          = Color3.fromRGB(58, 45, 94),       -- Crisp Border Stroke (#3A2D5E)
    BorderActive    = Color3.fromRGB(168, 85, 247),     -- Accent Border (#A855F7)
    Accent          = Color3.fromRGB(168, 85, 247),     -- DKHUB Signature Violet (#A855F7)
    AccentHover     = Color3.fromRGB(192, 132, 252),   -- Radiant Lilac (#C084FC)
    AccentActive    = Color3.fromRGB(216, 180, 254),   -- Light Lavender (#D8B4FE)
    Text            = Color3.fromRGB(248, 246, 255),    -- Crisp White (#F8F6FF)
    TextMuted       = Color3.fromRGB(170, 158, 210),    -- Slate Lavender (#AA9ED2)
    TextSubtle      = Color3.fromRGB(118, 106, 154),    -- Darker Lavender (#766A9A)
    ToggleOff       = Color3.fromRGB(48, 37, 76),       -- Track Off (#30254C)
    ToggleOn        = Color3.fromRGB(168, 85, 247),     -- Track On (#A855F7)
    Danger          = Color3.fromRGB(244, 63, 94),      -- Rose Red (#F43F5E)
    Success         = Color3.fromRGB(52, 211, 153),     -- Mint Green (#34D399)
    Font            = Enum.Font.GothamMedium,
    FontBold        = Enum.Font.GothamBold
}

UILibrary.Toggles = {}
UILibrary.Dropdowns = {}

local function getGuiContainer()
    if typeof(gethui) == "function" then
        local ok, h = pcall(gethui)
        if ok and h and typeof(h) == "Instance" then return h end
    end
    local lp = LocalPlayer or Players.LocalPlayer or Players:FindFirstChildWhichIsA("Player")
    if lp then
        local pg = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 5)
        if pg then return pg end
    end
    local okCore, cg = pcall(function() return CoreGui end)
    if okCore and cg then return cg end
    return CoreGui
end

--------------------------------------------------------------------------------
-- TOAST NOTIFICATION SYSTEM
--------------------------------------------------------------------------------
function UILibrary:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local content = options.Content or options.SubContent or ""
    local duration = options.Duration or 3.5

    local container = getGuiContainer()
    local notifGui = container:FindFirstChild("StealAnEgg_DKHUB_Notif_Gui")
    if not notifGui then
        notifGui = Instance.new("ScreenGui")
        notifGui.Name = "StealAnEgg_DKHUB_Notif_Gui"
        notifGui.ResetOnSpawn = false
        notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        notifGui.Parent = container
    end

    local holder = notifGui:FindFirstChild("NotifHolder")
    if not holder then
        holder = Instance.new("Frame")
        holder.Name = "NotifHolder"
        holder.Size = UDim2.new(0, 310, 1, -40)
        holder.Position = UDim2.new(1, -325, 0, 20)
        holder.BackgroundTransparency = 1
        holder.Parent = notifGui

        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 8)
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Parent = holder
    end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 68)
    card.BackgroundColor3 = UILibrary.Theme.Background
    card.BackgroundTransparency = 0.05
    card.Position = UDim2.new(1, 350, 0, 0)
    card.Parent = holder

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = UILibrary.Theme.Accent
    cardStroke.Thickness = 1.5
    cardStroke.Parent = card

    local leftPip = Instance.new("Frame")
    leftPip.Size = UDim2.new(0, 4, 1, -12)
    leftPip.Position = UDim2.new(0, 6, 0, 6)
    leftPip.BackgroundColor3 = UILibrary.Theme.Accent
    leftPip.Parent = card

    local pipCorner = Instance.new("UICorner")
    pipCorner.CornerRadius = UDim.new(0, 2)
    pipCorner.Parent = leftPip

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -30, 0, 20)
    titleLbl.Position = UDim2.new(0, 16, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = UILibrary.Theme.FontBold
    titleLbl.Text = title
    titleLbl.TextColor3 = UILibrary.Theme.AccentHover
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = card

    local contentLbl = Instance.new("TextLabel")
    contentLbl.Size = UDim2.new(1, -30, 0, 32)
    contentLbl.Position = UDim2.new(0, 16, 0, 28)
    contentLbl.BackgroundTransparency = 1
    contentLbl.Font = UILibrary.Theme.Font
    contentLbl.Text = content
    contentLbl.TextColor3 = UILibrary.Theme.Text
    contentLbl.TextSize = 11
    contentLbl.TextWrapped = true
    contentLbl.TextXAlignment = Enum.TextXAlignment.Left
    contentLbl.TextYAlignment = Enum.TextYAlignment.Top
    contentLbl.Parent = card

    -- Progress Bar Indicator
    local progBar = Instance.new("Frame")
    progBar.Size = UDim2.new(1, -12, 0, 2)
    progBar.Position = UDim2.new(0, 6, 1, -4)
    progBar.BackgroundColor3 = UILibrary.Theme.Accent
    progBar.BorderSizePixel = 0
    progBar.Parent = card

    -- Animate in
    card.Position = UDim2.new(1, 350, 0, 0)
    TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    TweenService:Create(progBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 2)
    }):Play()

    -- Auto dismiss
    task.delay(duration, function()
        if card and card.Parent then
            local tween = TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 350, 0, 0),
                BackgroundTransparency = 1
            })
            tween:Play()
            tween.Completed:Connect(function()
                card:Destroy()
            end)
        end
    end)
end

--------------------------------------------------------------------------------
-- MAIN WINDOW CONSTRUCTOR
--------------------------------------------------------------------------------
function UILibrary:CreateWindow(options)
    options = options or {}
    local titleText = options.Title or "Steal An Egg Hub"
    local subTitleText = options.SubTitle or "v1.0 Edition"
    local minimizeKey = options.MinimizeKey or Enum.KeyCode.RightControl

    local container = getGuiContainer()
    local existing = container:FindFirstChild("StealAnEgg_DKHUB_Hub_Gui")
    if existing then
        existing:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "StealAnEgg_DKHUB_Hub_Gui"
    gui.ResetOnSpawn = false
    gui.Enabled = true
    gui.DisplayOrder = 999999
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = container

    local windowObj = {
        Gui = gui,
        MainFrame = nil,
        ContentArea = nil,
        Tabs = {},
        ActiveTab = nil,
        CurrentActiveDropdown = nil,
        Connections = {}
    }
    UILibrary.ActiveWindow = windowObj

    local isMobile = UserInputService.TouchEnabled and not (UserInputService.KeyboardEnabled and UserInputService.MouseEnabled)
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1024, 768)
    local isSmallScreen = isMobile or (viewport.X < 750 or viewport.Y < 480)

    -- Dynamic proportional window sizing (optimized for mobile touchscreens and desktop)
    local frameWidth, frameHeight, sidebarWidth, headerHeight
    if isSmallScreen then
        frameWidth = math.clamp(math.floor(viewport.X * 0.84), 320, 520)
        frameHeight = math.clamp(math.floor(viewport.Y * 0.82), 260, 360)
        sidebarWidth = 120
        headerHeight = 36
    else
        frameWidth = 600
        frameHeight = 440
        sidebarWidth = 140
        headerHeight = 38
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.fromOffset(frameWidth, frameHeight)
    mainFrame.Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2)
    mainFrame.BackgroundColor3 = UILibrary.Theme.Background
    mainFrame.BackgroundTransparency = 0.02
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = false
    mainFrame.Parent = gui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = UILibrary.Theme.Border
    mainStroke.Thickness = 1.5
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainStroke.Parent = mainFrame

    -- Auto adjust window size if viewport orientation changes
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            local vp = workspace.CurrentCamera.ViewportSize
            local curSmall = isMobile or (vp.X < 750 or vp.Y < 480)
            local targetW, targetH
            if curSmall then
                targetW = math.clamp(math.floor(vp.X * 0.84), 320, 520)
                targetH = math.clamp(math.floor(vp.Y * 0.82), 260, 360)
            else
                targetW = 600
                targetH = 440
            end
            mainFrame.Size = UDim2.fromOffset(targetW, targetH)
        end)
    end

    ----------------------------------------------------------------------------
    -- FLOATING MOBILE TOGGLE BUBBLE (TOUCH & MOUSE DRAGGABLE)
    ----------------------------------------------------------------------------
    local floatIconSize = isSmallScreen and 38 or 44
    local floatIcon = Instance.new("ImageButton")
    floatIcon.Name = "FloatMinimizeIcon"
    floatIcon.Size = UDim2.fromOffset(floatIconSize, floatIconSize)
    floatIcon.Position = UDim2.new(0, 15, 0.5, -floatIconSize/2)
    floatIcon.BackgroundColor3 = UILibrary.Theme.Sidebar
    floatIcon.BackgroundTransparency = 0.1
    floatIcon.AutoButtonColor = false
    floatIcon.Parent = gui

    local floatCorner = Instance.new("UICorner")
    floatCorner.CornerRadius = UDim.new(1, 0)
    floatCorner.Parent = floatIcon

    local floatStroke = Instance.new("UIStroke")
    floatStroke.Color = UILibrary.Theme.Accent
    floatStroke.Thickness = 2
    floatStroke.Parent = floatIcon

    local iconUrl = "https://raw.githubusercontent.com/xDKHUB-hub/DKHUB/main/icon.png"
    pcall(function()
        if writefile and readfile then
            if not isfile("DKHUB_icon.png") then
                local imgData = game:HttpGet(iconUrl, true)
                if imgData and #imgData > 100 then
                    writefile("DKHUB_icon.png", imgData)
                end
            end
            if getcustomasset and isfile("DKHUB_icon.png") then
                floatIcon.Image = getcustomasset("DKHUB_icon.png")
            end
        end
    end)

    -- Floating Icon Drag Physics
    local fDragging, fDragInput, fDragStart, fStartPos, fClickStartPos
    floatIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            fDragging = true
            fDragStart = input.Position
            fStartPos = floatIcon.Position
            fClickStartPos = input.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    fDragging = false
                end
            end)
        end
    end)

    floatIcon.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            fDragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == fDragInput and fDragging then
            local delta = input.Position - fDragStart
            floatIcon.Position = UDim2.new(fStartPos.X.Scale, fStartPos.X.Offset + delta.X, fStartPos.Y.Scale, fStartPos.Y.Offset + delta.Y)
        end
    end)

    floatIcon.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and fClickStartPos then
            local dist = (input.Position - fClickStartPos).Magnitude
            if dist < 8 then
                mainFrame.Visible = not mainFrame.Visible
            end
        end
    end)

    ----------------------------------------------------------------------------
    -- HEADER BAR & WINDOW CONTROLS
    ----------------------------------------------------------------------------
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, headerHeight)
    header.BackgroundColor3 = UILibrary.Theme.Header
    header.BorderSizePixel = 0
    header.Parent = mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)
    headerCorner.Parent = header

    local headerBottomFiller = Instance.new("Frame")
    headerBottomFiller.Name = "HeaderBottomFiller"
    headerBottomFiller.Size = UDim2.new(1, 0, 0, 12)
    headerBottomFiller.Position = UDim2.new(0, 0, 1, -12)
    headerBottomFiller.BackgroundColor3 = UILibrary.Theme.Header
    headerBottomFiller.BorderSizePixel = 0
    headerBottomFiller.Parent = header

    local headerCover = Instance.new("Frame")
    headerCover.Size = UDim2.new(1, 0, 0, 1)
    headerCover.Position = UDim2.new(0, 0, 1, -1)
    headerCover.BackgroundColor3 = UILibrary.Theme.Border
    headerCover.BorderSizePixel = 0
    headerCover.Parent = header

    -- Left Brand Accent Pip
    local brandPip = Instance.new("Frame")
    brandPip.Size = UDim2.new(0, 4, 0, isSmallScreen and 14 or 18)
    brandPip.Position = UDim2.new(0, 10, 0.5, isSmallScreen and -7 or -9)
    brandPip.BackgroundColor3 = UILibrary.Theme.Accent
    brandPip.Parent = header

    local brandPipCorner = Instance.new("UICorner")
    brandPipCorner.CornerRadius = UDim.new(0, 2)
    brandPipCorner.Parent = brandPip

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0, isSmallScreen and 240 or 380, 1, 0)
    titleLbl.Position = UDim2.new(0, 20, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = UILibrary.Theme.FontBold
    titleLbl.Text = titleText .. "  <font color='#A855F7'>" .. subTitleText .. "</font>"
    titleLbl.RichText = true
    titleLbl.TextColor3 = UILibrary.Theme.Text
    titleLbl.TextSize = isSmallScreen and 11.5 or 12.5
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titleLbl.Parent = header

    -- Control Buttons (Minimize & Close)
    local ctrlBtnWidth = isSmallScreen and 24 or 28
    local ctrlBtnHeight = isSmallScreen and 22 or 26

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, ctrlBtnWidth, 0, ctrlBtnHeight)
    minBtn.Position = UDim2.new(1, -(ctrlBtnWidth * 2 + 10), 0.5, -ctrlBtnHeight/2)
    minBtn.BackgroundColor3 = UILibrary.Theme.Card
    minBtn.AutoButtonColor = false
    minBtn.Font = UILibrary.Theme.FontBold
    minBtn.Text = "-"
    minBtn.TextColor3 = UILibrary.Theme.TextMuted
    minBtn.TextSize = isSmallScreen and 12 or 14
    minBtn.Parent = header

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 5)
    minCorner.Parent = minBtn

    local minStroke = Instance.new("UIStroke")
    minStroke.Color = UILibrary.Theme.Border
    minStroke.Thickness = 1
    minStroke.Parent = minBtn

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, ctrlBtnWidth, 0, ctrlBtnHeight)
    closeBtn.Position = UDim2.new(1, -(ctrlBtnWidth + 6), 0.5, -ctrlBtnHeight/2)
    closeBtn.BackgroundColor3 = UILibrary.Theme.Card
    closeBtn.AutoButtonColor = false
    closeBtn.Font = UILibrary.Theme.FontBold
    closeBtn.Text = "X"
    closeBtn.TextColor3 = UILibrary.Theme.Danger
    closeBtn.TextSize = isSmallScreen and 11 or 12
    closeBtn.Parent = header

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeBtn

    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = UILibrary.Theme.Border
    closeStroke.Thickness = 1
    closeStroke.Parent = closeBtn

    minBtn.MouseEnter:Connect(function()
        TweenService:Create(minBtn, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.CardHover, TextColor3 = UILibrary.Theme.Text }):Play()
    end)
    minBtn.MouseLeave:Connect(function()
        TweenService:Create(minBtn, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.Card, TextColor3 = UILibrary.Theme.TextMuted }):Play()
    end)
    minBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.Danger, TextColor3 = Color3.new(1, 1, 1) }):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.Card, TextColor3 = UILibrary.Theme.Danger }):Play()
    end)
    closeBtn.MouseButton1Click:Connect(function()
        if Automation and typeof(Automation.Unload) == "function" then
            Automation.Unload(UILibrary)
        elseif windowObj and typeof(windowObj.Destroy) == "function" then
            windowObj:Destroy()
        end
    end)

    -- Draggable Window Header logic
    local dragging, dragInput, dragStart, startPos
    table.insert(windowObj.Connections, header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end))

    table.insert(windowObj.Connections, header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end))

    table.insert(windowObj.Connections, UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))

    table.insert(windowObj.Connections, UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == minimizeKey then
            mainFrame.Visible = not mainFrame.Visible
        end
    end))

    ----------------------------------------------------------------------------
    -- SIDEBAR NAVIGATION (LEFT SIDE - SCROLLABLE FOR 9+ TABS)
    ----------------------------------------------------------------------------
    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, sidebarWidth, 1, -headerHeight)
    sidebar.Position = UDim2.new(0, 0, 0, headerHeight)
    sidebar.BackgroundTransparency = 1
    sidebar.BorderSizePixel = 0
    sidebar.ScrollBarThickness = 2
    sidebar.ScrollBarImageColor3 = UILibrary.Theme.Accent
    sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebar.Parent = mainFrame

    local sidebarDivider = Instance.new("Frame")
    sidebarDivider.Name = "SidebarDivider"
    sidebarDivider.Size = UDim2.new(0, 1, 1, -(headerHeight + 10))
    sidebarDivider.Position = UDim2.new(0, sidebarWidth, 0, headerHeight)
    sidebarDivider.BackgroundColor3 = UILibrary.Theme.Border
    sidebarDivider.BorderSizePixel = 0
    sidebarDivider.Parent = mainFrame

    local sidebarList = Instance.new("UIListLayout")
    sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarList.Padding = UDim.new(0, 4)
    sidebarList.Parent = sidebar

    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 8)
    sidebarPadding.PaddingBottom = UDim.new(0, 12)
    sidebarPadding.PaddingLeft = UDim.new(0, 6)
    sidebarPadding.PaddingRight = UDim.new(0, 6)
    sidebarPadding.Parent = sidebar

    ----------------------------------------------------------------------------
    -- CONTENT AREA (RIGHT SIDE)
    ----------------------------------------------------------------------------
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -sidebarWidth, 1, -headerHeight)
    contentArea.Position = UDim2.new(0, sidebarWidth, 0, headerHeight)
    contentArea.BackgroundTransparency = 1
    contentArea.BorderSizePixel = 0
    contentArea.Parent = mainFrame

    ----------------------------------------------------------------------------
    -- DEDICATED FULL SUB-PANEL OVERLAY FOR DROPDOWNS
    ----------------------------------------------------------------------------
    local subPanel = Instance.new("Frame")
    subPanel.Name = "DropdownSubPanel"
    subPanel.Size = UDim2.new(1, 0, 1, 0)
    subPanel.Position = UDim2.new(0, 0, 0, 0)
    subPanel.BackgroundColor3 = UILibrary.Theme.Background
    subPanel.BackgroundTransparency = 0
    subPanel.BorderSizePixel = 0
    subPanel.ZIndex = 40
    subPanel.Visible = false
    subPanel.Parent = contentArea

    local subPanelCorner = Instance.new("UICorner")
    subPanelCorner.CornerRadius = UDim.new(0, 10)
    subPanelCorner.Parent = subPanel

    local spLeftFiller = Instance.new("Frame")
    spLeftFiller.Size = UDim2.new(0, 10, 1, 0)
    spLeftFiller.Position = UDim2.new(0, 0, 0, 0)
    spLeftFiller.BackgroundColor3 = UILibrary.Theme.Background
    spLeftFiller.BorderSizePixel = 0
    spLeftFiller.ZIndex = 40
    spLeftFiller.Parent = subPanel

    -- SubPanel Header Bar
    local spHeader = Instance.new("Frame")
    spHeader.Name = "SubPanelHeader"
    spHeader.Size = UDim2.new(1, 0, 0, headerHeight)
    spHeader.BackgroundColor3 = UILibrary.Theme.Sidebar
    spHeader.BorderSizePixel = 0
    spHeader.ZIndex = 41
    spHeader.Parent = subPanel

    local spHeaderCorner = Instance.new("UICorner")
    spHeaderCorner.CornerRadius = UDim.new(0, 10)
    spHeaderCorner.Parent = spHeader

    local spHeaderBottomFiller = Instance.new("Frame")
    spHeaderBottomFiller.Size = UDim2.new(1, 0, 0, 12)
    spHeaderBottomFiller.Position = UDim2.new(0, 0, 1, -12)
    spHeaderBottomFiller.BackgroundColor3 = UILibrary.Theme.Sidebar
    spHeaderBottomFiller.BorderSizePixel = 0
    spHeaderBottomFiller.ZIndex = 41
    spHeaderBottomFiller.Parent = spHeader

    local spHeaderLeftFiller = Instance.new("Frame")
    spHeaderLeftFiller.Size = UDim2.new(0, 10, 1, 0)
    spHeaderLeftFiller.Position = UDim2.new(0, 0, 0, 0)
    spHeaderLeftFiller.BackgroundColor3 = UILibrary.Theme.Sidebar
    spHeaderLeftFiller.BorderSizePixel = 0
    spHeaderLeftFiller.ZIndex = 41
    spHeaderLeftFiller.Parent = spHeader

    local spHeaderBorder = Instance.new("Frame")
    spHeaderBorder.Size = UDim2.new(1, 0, 0, 1)
    spHeaderBorder.Position = UDim2.new(0, 0, 1, -1)
    spHeaderBorder.BackgroundColor3 = UILibrary.Theme.Border
    spHeaderBorder.BorderSizePixel = 0
    spHeaderBorder.ZIndex = 42
    spHeaderBorder.Parent = spHeader

    local spBackBtn = Instance.new("TextButton")
    spBackBtn.Name = "SubPanelBackBtn"
    spBackBtn.Size = UDim2.new(0, 82, 0, 28)
    spBackBtn.Position = UDim2.new(0, 10, 0.5, -14)
    spBackBtn.BackgroundColor3 = UILibrary.Theme.Card
    spBackBtn.AutoButtonColor = false
    spBackBtn.Font = UILibrary.Theme.FontBold
    spBackBtn.Text = "< Return"
    spBackBtn.TextColor3 = UILibrary.Theme.AccentHover
    spBackBtn.TextSize = 12
    spBackBtn.ZIndex = 42
    spBackBtn.Parent = spHeader

    local spBackCorner = Instance.new("UICorner")
    spBackCorner.CornerRadius = UDim.new(0, 6)
    spBackCorner.Parent = spBackBtn

    local spBackStroke = Instance.new("UIStroke")
    spBackStroke.Color = UILibrary.Theme.Border
    spBackStroke.Thickness = 1
    spBackStroke.Parent = spBackBtn

    local spTitleLbl = Instance.new("TextLabel")
    spTitleLbl.Name = "SubPanelTitle"
    spTitleLbl.Size = UDim2.new(1, -220, 1, 0)
    spTitleLbl.Position = UDim2.new(0, 100, 0, 0)
    spTitleLbl.BackgroundTransparency = 1
    spTitleLbl.Font = UILibrary.Theme.FontBold
    spTitleLbl.Text = "Select Options"
    spTitleLbl.TextColor3 = UILibrary.Theme.Text
    spTitleLbl.TextSize = 13
    spTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    spTitleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    spTitleLbl.ZIndex = 42
    spTitleLbl.Parent = spHeader

    local spBadge = Instance.new("TextLabel")
    spBadge.Name = "SubPanelBadge"
    spBadge.Size = UDim2.new(0, 100, 0, 24)
    spBadge.Position = UDim2.new(1, -112, 0.5, -12)
    spBadge.BackgroundColor3 = UILibrary.Theme.CardHover
    spBadge.Font = UILibrary.Theme.FontBold
    spBadge.Text = "0 Selected"
    spBadge.TextColor3 = UILibrary.Theme.AccentActive
    spBadge.TextSize = 11
    spBadge.ZIndex = 42
    spBadge.Parent = spHeader

    local spBadgeCorner = Instance.new("UICorner")
    spBadgeCorner.CornerRadius = UDim.new(0, 12)
    spBadgeCorner.Parent = spBadge

    local spBadgeStroke = Instance.new("UIStroke")
    spBadgeStroke.Color = UILibrary.Theme.BorderActive
    spBadgeStroke.Thickness = 1
    spBadgeStroke.Parent = spBadge

    -- Search Bar Container
    local spSearchContainer = Instance.new("Frame")
    spSearchContainer.Name = "SearchContainer"
    spSearchContainer.Size = UDim2.new(1, -20, 0, 34)
    spSearchContainer.Position = UDim2.new(0, 10, 0, 50)
    spSearchContainer.BackgroundColor3 = UILibrary.Theme.Card
    spSearchContainer.ZIndex = 41
    spSearchContainer.Parent = subPanel

    local spSearchCorner = Instance.new("UICorner")
    spSearchCorner.CornerRadius = UDim.new(0, 6)
    spSearchCorner.Parent = spSearchContainer

    local spSearchStroke = Instance.new("UIStroke")
    spSearchStroke.Color = Color3.fromRGB(60, 55, 75)
    spSearchStroke.Thickness = 1
    spSearchStroke.Parent = spSearchContainer

    local spSearchBox = Instance.new("TextBox")
    spSearchBox.Name = "SubPanelSearchBox"
    spSearchBox.Size = UDim2.new(1, -40, 1, 0)
    spSearchBox.Position = UDim2.new(0, 10, 0, 0)
    spSearchBox.BackgroundTransparency = 1
    spSearchBox.Font = UILibrary.Theme.Font
    spSearchBox.PlaceholderText = "Search item name..."
    spSearchBox.Text = ""
    spSearchBox.TextColor3 = Color3.fromRGB(240, 240, 245)
    spSearchBox.PlaceholderColor3 = Color3.fromRGB(140, 135, 160)
    spSearchBox.TextSize = 12
    spSearchBox.TextXAlignment = Enum.TextXAlignment.Left
    spSearchBox.ClearTextOnFocus = false
    spSearchBox.ZIndex = 42
    spSearchBox.Parent = spSearchContainer

    spSearchBox.Focused:Connect(function()
        TweenService:Create(spSearchStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(90, 85, 110) }):Play()
    end)
    spSearchBox.FocusLost:Connect(function()
        TweenService:Create(spSearchStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(60, 55, 75) }):Play()
    end)

    local spClearSearchBtn = Instance.new("TextButton")
    spClearSearchBtn.Name = "ClearSearchBtn"
    spClearSearchBtn.Size = UDim2.new(0, 24, 0, 24)
    spClearSearchBtn.Position = UDim2.new(1, -28, 0.5, -12)
    spClearSearchBtn.BackgroundTransparency = 1
    spClearSearchBtn.Font = UILibrary.Theme.FontBold
    spClearSearchBtn.Text = "X"
    spClearSearchBtn.TextColor3 = UILibrary.Theme.TextMuted
    spClearSearchBtn.TextSize = 11
    spClearSearchBtn.ZIndex = 42
    spClearSearchBtn.Parent = spSearchContainer

    -- Quick Action Toolbar (Select All / Clear All / Invert for Multi-Select)
    local spToolbar = Instance.new("Frame")
    spToolbar.Name = "SubPanelToolbar"
    spToolbar.Size = UDim2.new(1, -20, 0, 30)
    spToolbar.Position = UDim2.new(0, 10, 0, 90)
    spToolbar.BackgroundTransparency = 1
    spToolbar.ZIndex = 41
    spToolbar.Parent = subPanel

    local spSelectAllBtn = Instance.new("TextButton")
    spSelectAllBtn.Name = "SelectAllBtn"
    spSelectAllBtn.Size = UDim2.new(0.32, -4, 1, 0)
    spSelectAllBtn.Position = UDim2.new(0, 0, 0, 0)
    spSelectAllBtn.BackgroundColor3 = UILibrary.Theme.Card
    spSelectAllBtn.AutoButtonColor = false
    spSelectAllBtn.Font = UILibrary.Theme.FontBold
    spSelectAllBtn.Text = "+ Select All"
    spSelectAllBtn.TextColor3 = UILibrary.Theme.AccentHover
    spSelectAllBtn.TextSize = 11
    spSelectAllBtn.ZIndex = 42
    spSelectAllBtn.Parent = spToolbar

    local spSelectAllCorner = Instance.new("UICorner")
    spSelectAllCorner.CornerRadius = UDim.new(0, 5)
    spSelectAllCorner.Parent = spSelectAllBtn

    local spSelectAllStroke = Instance.new("UIStroke")
    spSelectAllStroke.Color = UILibrary.Theme.Border
    spSelectAllStroke.Thickness = 1
    spSelectAllStroke.Parent = spSelectAllBtn

    local spClearAllBtn = Instance.new("TextButton")
    spClearAllBtn.Name = "ClearAllBtn"
    spClearAllBtn.Size = UDim2.new(0.32, -4, 1, 0)
    spClearAllBtn.Position = UDim2.new(0.34, 0, 0, 0)
    spClearAllBtn.BackgroundColor3 = UILibrary.Theme.Card
    spClearAllBtn.AutoButtonColor = false
    spClearAllBtn.Font = UILibrary.Theme.FontBold
    spClearAllBtn.Text = "- Clear All"
    spClearAllBtn.TextColor3 = UILibrary.Theme.TextMuted
    spClearAllBtn.TextSize = 11
    spClearAllBtn.ZIndex = 42
    spClearAllBtn.Parent = spToolbar

    local spClearAllCorner = Instance.new("UICorner")
    spClearAllCorner.CornerRadius = UDim.new(0, 5)
    spClearAllCorner.Parent = spClearAllBtn

    local spClearAllStroke = Instance.new("UIStroke")
    spClearAllStroke.Color = UILibrary.Theme.Border
    spClearAllStroke.Thickness = 1
    spClearAllStroke.Parent = spClearAllBtn

    local spInvertBtn = Instance.new("TextButton")
    spInvertBtn.Name = "InvertBtn"
    spInvertBtn.Size = UDim2.new(0.32, -4, 1, 0)
    spInvertBtn.Position = UDim2.new(0.68, 0, 0, 0)
    spInvertBtn.BackgroundColor3 = UILibrary.Theme.Card
    spInvertBtn.AutoButtonColor = false
    spInvertBtn.Font = UILibrary.Theme.FontBold
    spInvertBtn.Text = "<> Invert"
    spInvertBtn.TextColor3 = UILibrary.Theme.TextMuted
    spInvertBtn.TextSize = 11
    spInvertBtn.ZIndex = 42
    spInvertBtn.Parent = spToolbar

    local spInvertCorner = Instance.new("UICorner")
    spInvertCorner.CornerRadius = UDim.new(0, 5)
    spInvertCorner.Parent = spInvertBtn

    local spInvertStroke = Instance.new("UIStroke")
    spInvertStroke.Color = UILibrary.Theme.Border
    spInvertStroke.Thickness = 1
    spInvertStroke.Parent = spInvertBtn

    -- Options List Scrolling Frame
    local spListFrame = Instance.new("ScrollingFrame")
    spListFrame.Name = "SubPanelListFrame"
    spListFrame.Size = UDim2.new(1, -20, 1, -170)
    spListFrame.Position = UDim2.new(0, 10, 0, 126)
    spListFrame.BackgroundTransparency = 1
    spListFrame.ScrollBarThickness = 5
    spListFrame.ScrollBarImageColor3 = UILibrary.Theme.Accent
    spListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    spListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    spListFrame.ZIndex = 41
    spListFrame.Parent = subPanel

    local spListLayout = Instance.new("UIListLayout")
    spListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    spListLayout.Padding = UDim.new(0, 6)
    spListLayout.Parent = spListFrame

    local spListPadding = Instance.new("UIPadding")
    spListPadding.PaddingTop = UDim.new(0, 4)
    spListPadding.PaddingBottom = UDim.new(0, 10)
    spListPadding.PaddingLeft = UDim.new(0, 2)
    spListPadding.PaddingRight = UDim.new(0, 6)
    spListPadding.Parent = spListFrame

    -- Bottom Summary & Apply Footer
    local spFooter = Instance.new("Frame")
    spFooter.Name = "SubPanelFooter"
    spFooter.Size = UDim2.new(1, 0, 0, 42)
    spFooter.Position = UDim2.new(0, 0, 1, -42)
    spFooter.BackgroundColor3 = UILibrary.Theme.Sidebar
    spFooter.BorderSizePixel = 0
    spFooter.ZIndex = 41
    spFooter.Parent = subPanel

    local spFooterCorner = Instance.new("UICorner")
    spFooterCorner.CornerRadius = UDim.new(0, 10)
    spFooterCorner.Parent = spFooter

    local spFooterTopFiller = Instance.new("Frame")
    spFooterTopFiller.Size = UDim2.new(1, 0, 0, 12)
    spFooterTopFiller.Position = UDim2.new(0, 0, 0, 0)
    spFooterTopFiller.BackgroundColor3 = UILibrary.Theme.Sidebar
    spFooterTopFiller.BorderSizePixel = 0
    spFooterTopFiller.ZIndex = 41
    spFooterTopFiller.Parent = spFooter

    local spFooterLeftFiller = Instance.new("Frame")
    spFooterLeftFiller.Size = UDim2.new(0, 10, 1, 0)
    spFooterLeftFiller.Position = UDim2.new(0, 0, 0, 0)
    spFooterLeftFiller.BackgroundColor3 = UILibrary.Theme.Sidebar
    spFooterLeftFiller.BorderSizePixel = 0
    spFooterLeftFiller.ZIndex = 41
    spFooterLeftFiller.Parent = spFooter

    local spFooterBorder = Instance.new("Frame")
    spFooterBorder.Size = UDim2.new(1, 0, 0, 1)
    spFooterBorder.Position = UDim2.new(0, 0, 0, 0)
    spFooterBorder.BackgroundColor3 = UILibrary.Theme.Border
    spFooterBorder.BorderSizePixel = 0
    spFooterBorder.ZIndex = 42
    spFooterBorder.Parent = spFooter

    local spFooterLbl = Instance.new("TextLabel")
    spFooterLbl.Size = UDim2.new(1, -140, 1, 0)
    spFooterLbl.Position = UDim2.new(0, 14, 0, 0)
    spFooterLbl.BackgroundTransparency = 1
    spFooterLbl.Font = UILibrary.Theme.Font
    spFooterLbl.Text = "Ready"
    spFooterLbl.TextColor3 = UILibrary.Theme.TextMuted
    spFooterLbl.TextSize = 11
    spFooterLbl.TextXAlignment = Enum.TextXAlignment.Left
    spFooterLbl.ZIndex = 42
    spFooterLbl.Parent = spFooter

    local spApplyBtn = Instance.new("TextButton")
    spApplyBtn.Name = "SubPanelApplyBtn"
    spApplyBtn.Size = UDim2.new(0, 110, 0, 28)
    spApplyBtn.Position = UDim2.new(1, -120, 0.5, -14)
    spApplyBtn.BackgroundColor3 = UILibrary.Theme.Accent
    spApplyBtn.AutoButtonColor = false
    spApplyBtn.Font = UILibrary.Theme.FontBold
    spApplyBtn.Text = "Apply & Done"
    spApplyBtn.TextColor3 = Color3.new(1, 1, 1)
    spApplyBtn.TextSize = 11
    spApplyBtn.ZIndex = 42
    spApplyBtn.Parent = spFooter

    local spApplyCorner = Instance.new("UICorner")
    spApplyCorner.CornerRadius = UDim.new(0, 6)
    spApplyCorner.Parent = spApplyBtn

    ----------------------------------------------------------------------------
    -- WINDOW OBJECT & SUB-PANEL STATE CONTROLLER
    ----------------------------------------------------------------------------
    windowObj.MainFrame = mainFrame
    windowObj.ContentArea = contentArea

    local function closeDropdownSubPanel()
        if subPanel.Visible then
            subPanel.Visible = false
            if windowObj.ActiveTab and windowObj.ActiveTab.Container then
                windowObj.ActiveTab.Container.Visible = true
            end
            if windowObj.CurrentActiveDropdown and windowObj.CurrentActiveDropdown.UpdateTriggerBtn then
                windowObj.CurrentActiveDropdown:UpdateTriggerBtn()
            end
            windowObj.CurrentActiveDropdown = nil
        end
    end

    table.insert(windowObj.Connections, spBackBtn.MouseButton1Click:Connect(closeDropdownSubPanel))
    table.insert(windowObj.Connections, spApplyBtn.MouseButton1Click:Connect(closeDropdownSubPanel))
    table.insert(windowObj.Connections, spClearSearchBtn.MouseButton1Click:Connect(function()
        spSearchBox.Text = ""
    end))

    table.insert(windowObj.Connections, spSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        if windowObj.CurrentActiveDropdown and typeof(windowObj.CurrentActiveDropdown.OnSearchChanged) == "function" then
            windowObj.CurrentActiveDropdown.OnSearchChanged(spSearchBox.Text)
        end
    end))

    table.insert(windowObj.Connections, spSelectAllBtn.MouseButton1Click:Connect(function()
        if windowObj.CurrentActiveDropdown and typeof(windowObj.CurrentActiveDropdown.OnSelectAll) == "function" then
            windowObj.CurrentActiveDropdown.OnSelectAll()
        end
    end))

    table.insert(windowObj.Connections, spClearAllBtn.MouseButton1Click:Connect(function()
        if windowObj.CurrentActiveDropdown and typeof(windowObj.CurrentActiveDropdown.OnClearAll) == "function" then
            windowObj.CurrentActiveDropdown.OnClearAll()
        end
    end))

    table.insert(windowObj.Connections, spInvertBtn.MouseButton1Click:Connect(function()
        if windowObj.CurrentActiveDropdown and typeof(windowObj.CurrentActiveDropdown.OnInvert) == "function" then
            windowObj.CurrentActiveDropdown.OnInvert()
        end
    end))

    function windowObj:Destroy()
        closeDropdownSubPanel()
        if windowObj.Connections then
            for _, conn in ipairs(windowObj.Connections) do
                pcall(function()
                    if typeof(conn) == "RBXScriptConnection" then
                        conn:Disconnect()
                    elseif typeof(conn) == "table" and typeof(conn.Disconnect) == "function" then
                        conn:Disconnect()
                    end
                end)
            end
            windowObj.Connections = {}
        end
        if gui and gui.Parent then
            gui:Destroy()
        end
    end

    local TAB_ICONS = {
        ["main"]         = "rbxassetid://10723407389", -- Home (Main Hub)
        ["home"]         = "rbxassetid://10723407389",
        ["dashboard"]    = "rbxassetid://10723346959",
        ["garden"]       = "rbxassetid://10734965572", -- Sprout (Garden & Plants)
        ["sprout"]       = "rbxassetid://10734965572",
        ["plant"]        = "rbxassetid://10734965572",
        ["farm"]         = "rbxassetid://10734965572",
        ["shop"]         = "rbxassetid://10734952479", -- Shopping Cart (Shop)
        ["shopping"]     = "rbxassetid://10734952479",
        ["store"]        = "rbxassetid://10734952273",
        ["buy"]          = "rbxassetid://10734952479",
        ["sell"]         = "rbxassetid://10709811110", -- Coins (Sell Market)
        ["coins"]        = "rbxassetid://10709811110",
        ["money"]        = "rbxassetid://10709811110",
        ["dollar"]       = "rbxassetid://10723343958",
        ["pet"]          = "rbxassetid://10723345518", -- Pet Egg (Pet / Hatching)
        ["pets"]         = "rbxassetid://10723345518",
        ["egg"]          = "rbxassetid://10723345518",
        ["heart"]        = "rbxassetid://10723406885",
        ["mailbox"]      = "rbxassetid://10734885430", -- Mail (Mailbox)
        ["mail"]         = "rbxassetid://10734885430",
        ["fall harvest"] = "rbxassetid://10747363809", -- Trophy (Fall Harvest Event)
        ["fall"]         = "rbxassetid://10747363809",
        ["harvest"]      = "rbxassetid://10747363809",
        ["event"]        = "rbxassetid://10747363809",
        ["trophy"]       = "rbxassetid://10747363809",
        ["apple"]        = "rbxassetid://10709761889",
        ["misc"]         = "rbxassetid://10734975692", -- Swords (Misc / Combat / Tools)
        ["miscellaneous"]= "rbxassetid://10734975692",
        ["swords"]       = "rbxassetid://10734975692",
        ["tools"]        = "rbxassetid://10747383470",
        ["wrench"]       = "rbxassetid://10747383470",
        ["settings"]     = "rbxassetid://10734950309", -- Settings Gear (Settings)
        ["config"]       = "rbxassetid://10734950309"
    }

    function windowObj:SelectTab(tabIndex)
        closeDropdownSubPanel()
        for idx, tab in ipairs(windowObj.Tabs) do
            if idx == tabIndex then
                TweenService:Create(tab.Button, TweenInfo.new(0.18), { BackgroundColor3 = UILibrary.Theme.Card, BackgroundTransparency = 0 }):Play()
                if tab.TitleLabel then
                    TweenService:Create(tab.TitleLabel, TweenInfo.new(0.18), { TextColor3 = UILibrary.Theme.AccentHover }):Play()
                end
                if tab.IconImage then
                    TweenService:Create(tab.IconImage, TweenInfo.new(0.18), { ImageColor3 = UILibrary.Theme.AccentHover }):Play()
                end
                tab.Stroke.Color = UILibrary.Theme.BorderActive
                tab.Stroke.Transparency = 0.4
                tab.Indicator.Visible = true
                tab.Container.Visible = true
                windowObj.ActiveTab = tab
            else
                TweenService:Create(tab.Button, TweenInfo.new(0.18), { BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1 }):Play()
                if tab.TitleLabel then
                    TweenService:Create(tab.TitleLabel, TweenInfo.new(0.18), { TextColor3 = UILibrary.Theme.TextMuted }):Play()
                end
                if tab.IconImage then
                    TweenService:Create(tab.IconImage, TweenInfo.new(0.18), { ImageColor3 = UILibrary.Theme.TextMuted }):Play()
                end
                tab.Stroke.Transparency = 1
                tab.Indicator.Visible = false
                tab.Container.Visible = false
            end
        end
    end

    ----------------------------------------------------------------------------
    -- TAB BUILDER (DISTINCTIVE BESPOKE SIDEBAR WITH ICONS)
    ----------------------------------------------------------------------------
    function windowObj:AddTab(options)
        options = options or {}
        local tabTitle = options.Title or "Tab"
        local tabIcon = options.Icon
        local tabIdx = #windowObj.Tabs + 1

        local iconAsset = nil
        if tabIcon and typeof(tabIcon) == "string" and tabIcon ~= "" then
            if tabIcon:find("rbxassetid://") or tabIcon:find("http") or tabIcon:find("rbxasset://") then
                iconAsset = tabIcon
            else
                iconAsset = TAB_ICONS[tabIcon:lower()] or tabIcon
            end
        else
            iconAsset = TAB_ICONS[tabTitle:lower()]
        end

        -- Tab Button on Sidebar
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "TabBtn_" .. tabTitle
        tabBtn.Size = UDim2.new(1, 0, 0, 36)
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        tabBtn.BackgroundTransparency = 1
        tabBtn.AutoButtonColor = false
        tabBtn.Text = ""
        tabBtn.ClipsDescendants = true
        tabBtn.Parent = sidebar

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn

        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = UILibrary.Theme.Border
        btnStroke.Thickness = 1
        btnStroke.Transparency = 1
        btnStroke.Parent = tabBtn

        local activeIndicator = Instance.new("Frame")
        activeIndicator.Size = UDim2.new(0, 3, 0, 18)
        activeIndicator.Position = UDim2.new(0, 2, 0.5, -9)
        activeIndicator.BackgroundColor3 = UILibrary.Theme.Accent
        activeIndicator.Visible = false
        activeIndicator.Parent = tabBtn

        local indCorner = Instance.new("UICorner")
        indCorner.CornerRadius = UDim.new(0, 2)
        indCorner.Parent = activeIndicator

        -- Tab Icon
        local iconImg = nil
        if iconAsset and iconAsset ~= "" then
            iconImg = Instance.new("ImageLabel")
            iconImg.Name = "TabIcon"
            iconImg.Size = UDim2.new(0, 16, 0, 16)
            iconImg.Position = UDim2.new(0, 10, 0.5, -8)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = iconAsset
            iconImg.ImageColor3 = UILibrary.Theme.TextMuted
            iconImg.Parent = tabBtn
        end

        -- Tab Title Label
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Name = "TabTitle"
        titleLbl.Size = UDim2.new(1, iconImg and -34 or -16, 1, 0)
        titleLbl.Position = UDim2.new(0, iconImg and 32 or 10, 0, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Font = UILibrary.Theme.FontBold
        titleLbl.Text = tabTitle
        titleLbl.TextColor3 = UILibrary.Theme.TextMuted
        titleLbl.TextSize = 12
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
        titleLbl.Parent = tabBtn

        -- Tab Content ScrollingFrame
        local container = Instance.new("ScrollingFrame")
        container.Name = "TabContainer_" .. tabTitle
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 5
        container.ScrollBarImageColor3 = UILibrary.Theme.Accent
        container.Visible = false
        container.AutomaticCanvasSize = Enum.AutomaticSize.Y
        container.CanvasSize = UDim2.new(0, 0, 0, 0)
        container.Parent = contentArea

        local containerList = Instance.new("UIListLayout")
        containerList.SortOrder = Enum.SortOrder.LayoutOrder
        containerList.Padding = UDim.new(0, 8)
        containerList.Parent = container

        local containerPadding = Instance.new("UIPadding")
        containerPadding.PaddingTop = UDim.new(0, 10)
        containerPadding.PaddingBottom = UDim.new(0, 20)
        containerPadding.PaddingLeft = UDim.new(0, 12)
        containerPadding.PaddingRight = UDim.new(0, 12)
        containerPadding.Parent = container

        containerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            container.CanvasSize = UDim2.new(0, 0, 0, containerList.AbsoluteContentSize.Y + 30)
        end)

        local currentSectionContainer = nil
        local function getParentContainer()
            return currentSectionContainer or container
        end

        local tabObj = {
            Title = tabTitle,
            Button = tabBtn,
            TitleLabel = titleLbl,
            IconImage = iconImg,
            Stroke = btnStroke,
            Indicator = activeIndicator,
            Container = container,
            Index = tabIdx
        }

        tabBtn.MouseEnter:Connect(function()
            if windowObj.ActiveTab ~= tabObj then
                TweenService:Create(tabBtn, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.CardHover, BackgroundTransparency = 0.5 }):Play()
                if titleLbl then
                    TweenService:Create(titleLbl, TweenInfo.new(0.15), { TextColor3 = UILibrary.Theme.Text }):Play()
                end
                if iconImg then
                    TweenService:Create(iconImg, TweenInfo.new(0.15), { ImageColor3 = UILibrary.Theme.Text }):Play()
                end
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if windowObj.ActiveTab ~= tabObj then
                TweenService:Create(tabBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1 }):Play()
                if titleLbl then
                    TweenService:Create(titleLbl, TweenInfo.new(0.15), { TextColor3 = UILibrary.Theme.TextMuted }):Play()
                end
                if iconImg then
                    TweenService:Create(iconImg, TweenInfo.new(0.15), { ImageColor3 = UILibrary.Theme.TextMuted }):Play()
                end
            end
        end)
        tabBtn.MouseButton1Click:Connect(function()
            windowObj:SelectTab(tabIdx)
        end)

        ------------------------------------------------------------------------
        -- 1. SECTION BUILDER (COLLAPSIBLE BY DEFAULT, STATIC FOR MAILBOX STATUS/TARGET)
        ------------------------------------------------------------------------
        function tabObj:AddSection(sectionTitle, options)
            local titleText = ""
            local isCollapsible = true
            local defaultOpen = false

            if typeof(sectionTitle) == "table" then
                options = sectionTitle
                titleText = options.Title or "Section"
                if options.Collapsible ~= nil then isCollapsible = options.Collapsible end
                if options.Collapse == false then isCollapsible = false end
                if options.Static == true then isCollapsible = false end
                if options.DefaultOpen ~= nil then defaultOpen = options.DefaultOpen end
            else
                titleText = tostring(sectionTitle or "Section")
                options = options or {}
                if options.Collapsible ~= nil then isCollapsible = options.Collapsible end
                if options.Collapse == false then isCollapsible = false end
                if options.Static == true then isCollapsible = false end
                if options.DefaultOpen ~= nil then defaultOpen = options.DefaultOpen end
            end

            if options.Static == true or options.Collapsible == false then
                isCollapsible = false
            end

            if not isCollapsible then
                -- Static Header on Main Panel (Always visible, directly on container)
                currentSectionContainer = container

                local secHeader = Instance.new("Frame")
                secHeader.Name = "StaticSectionHeader_" .. titleText
                secHeader.Size = UDim2.new(1, 0, 0, 24)
                secHeader.BackgroundTransparency = 1
                secHeader.Parent = container

                local pip = Instance.new("Frame")
                pip.Size = UDim2.new(0, 3, 0, 14)
                pip.Position = UDim2.new(0, 2, 0.5, -7)
                pip.BackgroundColor3 = UILibrary.Theme.Accent
                pip.BorderSizePixel = 0
                pip.Parent = secHeader

                local pipCorner = Instance.new("UICorner")
                pipCorner.CornerRadius = UDim.new(0, 2)
                pipCorner.Parent = pip

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, -20, 1, 0)
                titleLbl.Position = UDim2.new(0, 12, 0, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = UILibrary.Theme.FontBold
                titleLbl.Text = string.upper(titleText)
                titleLbl.TextColor3 = UILibrary.Theme.AccentHover
                titleLbl.TextSize = 11
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = secHeader

                local sectionObj = {
                    Frame = secHeader,
                    ContentHolder = container
                }
                function sectionObj:AddButton(opts) return tabObj:AddButton(opts) end
                function sectionObj:AddToggle(id, opts) return tabObj:AddToggle(id, opts) end
                function sectionObj:AddSlider(id, opts) return tabObj:AddSlider(id, opts) end
                function sectionObj:AddDropdown(id, opts) return tabObj:AddDropdown(id, opts) end
                function sectionObj:AddInput(id, opts) return tabObj:AddInput(id, opts) end
                function sectionObj:AddParagraph(opts) return tabObj:AddParagraph(opts) end
                return sectionObj
            else
                -- Collapsible Section Card (Accordion)
                local secCard = Instance.new("Frame")
                secCard.Name = "Section_" .. titleText
                secCard.Size = UDim2.new(1, 0, 0, 0)
                secCard.AutomaticSize = Enum.AutomaticSize.Y
                secCard.BackgroundTransparency = 1
                secCard.Parent = container

                local secHeader = Instance.new("TextButton")
                secHeader.Name = "SectionHeader"
                secHeader.Size = UDim2.new(1, 0, 0, 32)
                secHeader.BackgroundColor3 = UILibrary.Theme.Card
                secHeader.AutoButtonColor = false
                secHeader.Text = ""
                secHeader.ClipsDescendants = true
                secHeader.Parent = secCard

                local secCorner = Instance.new("UICorner")
                secCorner.CornerRadius = UDim.new(0, 6)
                secCorner.Parent = secHeader

                local secStroke = Instance.new("UIStroke")
                secStroke.Color = UILibrary.Theme.Border
                secStroke.Thickness = 1
                secStroke.Parent = secHeader

                local pip = Instance.new("Frame")
                pip.Size = UDim2.new(0, 3, 0, 14)
                pip.Position = UDim2.new(0, 8, 0.5, -7)
                pip.BackgroundColor3 = UILibrary.Theme.Accent
                pip.BorderSizePixel = 0
                pip.Parent = secHeader

                local pipCorner = Instance.new("UICorner")
                pipCorner.CornerRadius = UDim.new(0, 2)
                pipCorner.Parent = pip

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, -50, 1, 0)
                titleLbl.Position = UDim2.new(0, 18, 0, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = UILibrary.Theme.FontBold
                titleLbl.Text = string.upper(titleText)
                titleLbl.TextColor3 = UILibrary.Theme.AccentHover
                titleLbl.TextSize = 11
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = secHeader

                local arrowLbl = Instance.new("TextLabel")
                arrowLbl.Size = UDim2.new(0, 24, 1, 0)
                arrowLbl.Position = UDim2.new(1, -28, 0, 0)
                arrowLbl.BackgroundTransparency = 1
                arrowLbl.Font = UILibrary.Theme.FontBold
                arrowLbl.Text = defaultOpen and "v" or ">"
                arrowLbl.TextColor3 = UILibrary.Theme.TextMuted
                arrowLbl.TextSize = 12
                arrowLbl.Parent = secHeader

                local contentHolder = Instance.new("Frame")
                contentHolder.Name = "ContentHolder"
                contentHolder.Size = UDim2.new(1, 0, 0, 0)
                contentHolder.Position = UDim2.new(0, 0, 0, 36)
                contentHolder.AutomaticSize = Enum.AutomaticSize.Y
                contentHolder.BackgroundTransparency = 1
                contentHolder.Visible = defaultOpen
                contentHolder.Parent = secCard

                local contentList = Instance.new("UIListLayout")
                contentList.SortOrder = Enum.SortOrder.LayoutOrder
                contentList.Padding = UDim.new(0, 6)
                contentList.Parent = contentHolder

                local isExpanded = defaultOpen
                secHeader.MouseEnter:Connect(function()
                    TweenService:Create(secHeader, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.CardHover }):Play()
                    TweenService:Create(secStroke, TweenInfo.new(0.15), { Color = UILibrary.Theme.BorderActive }):Play()
                end)
                secHeader.MouseLeave:Connect(function()
                    TweenService:Create(secHeader, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.Card }):Play()
                    TweenService:Create(secStroke, TweenInfo.new(0.15), { Color = isExpanded and UILibrary.Theme.BorderActive or UILibrary.Theme.Border }):Play()
                end)
                secHeader.MouseButton1Click:Connect(function()
                    isExpanded = not isExpanded
                    contentHolder.Visible = isExpanded
                    arrowLbl.Text = isExpanded and "v" or ">"
                    if isExpanded then
                        TweenService:Create(secStroke, TweenInfo.new(0.2), { Color = UILibrary.Theme.BorderActive }):Play()
                    else
                        TweenService:Create(secStroke, TweenInfo.new(0.2), { Color = UILibrary.Theme.Border }):Play()
                    end
                end)

                currentSectionContainer = contentHolder

                local sectionObj = {
                    Frame = secCard,
                    ContentHolder = contentHolder
                }
                function sectionObj:AddButton(opts) return tabObj:AddButton(opts) end
                function sectionObj:AddToggle(id, opts) return tabObj:AddToggle(id, opts) end
                function sectionObj:AddSlider(id, opts) return tabObj:AddSlider(id, opts) end
                function sectionObj:AddDropdown(id, opts) return tabObj:AddDropdown(id, opts) end
                function sectionObj:AddInput(id, opts) return tabObj:AddInput(id, opts) end
                function sectionObj:AddParagraph(opts) return tabObj:AddParagraph(opts) end
                return sectionObj
            end
        end

        function tabObj:AddStaticSection(title)
            return tabObj:AddSection(title, { Collapsible = false })
        end

        function tabObj:AddCollapse(options)
            return tabObj:AddSection(options)
        end

        ------------------------------------------------------------------------
        -- 2. PARAGRAPH / INFO CARD BUILDER
        ------------------------------------------------------------------------
        function tabObj:AddParagraph(options)
            options = options or {}
            local pTitle = options.Title or "Paragraph"
            local pContent = options.Content or options.Description or ""
            local isScrollable = options.Scrollable == true or options.MaxHeight ~= nil
            local maxHeight = options.MaxHeight or 170

            local card = Instance.new("Frame")
            card.Size = isScrollable and UDim2.new(1, 0, 0, maxHeight + 36) or UDim2.new(1, 0, 0, 0)
            card.AutomaticSize = isScrollable and Enum.AutomaticSize.None or Enum.AutomaticSize.Y
            card.BackgroundColor3 = UILibrary.Theme.Card
            card.ClipsDescendants = true
            card.Parent = getParentContainer()

            local cardCorner = Instance.new("UICorner")
            cardCorner.CornerRadius = UDim.new(0, 6)
            cardCorner.Parent = card

            local cardStroke = Instance.new("UIStroke")
            cardStroke.Color = UILibrary.Theme.Border
            cardStroke.Thickness = 1
            cardStroke.Parent = card

            local pad = Instance.new("UIPadding")
            pad.PaddingTop = UDim.new(0, 8)
            pad.PaddingBottom = UDim.new(0, 8)
            pad.PaddingLeft = UDim.new(0, 10)
            pad.PaddingRight = UDim.new(0, 10)
            pad.Parent = card

            local listLayout = Instance.new("UIListLayout")
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Padding = UDim.new(0, 4)
            listLayout.Parent = card

            local tLbl = Instance.new("TextLabel")
            tLbl.Size = UDim2.new(1, 0, 0, 18)
            tLbl.BackgroundTransparency = 1
            tLbl.Font = UILibrary.Theme.FontBold
            tLbl.Text = pTitle
            tLbl.TextColor3 = UILibrary.Theme.Text
            tLbl.TextSize = 12
            tLbl.TextXAlignment = Enum.TextXAlignment.Left
            tLbl.TextTruncate = Enum.TextTruncate.AtEnd
            tLbl.LayoutOrder = 1
            tLbl.Parent = card

            local cLbl
            local scroller = nil

            if isScrollable then
                scroller = Instance.new("ScrollingFrame")
                scroller.Name = "ContentScroller"
                scroller.Size = UDim2.new(1, 0, 0, maxHeight)
                scroller.BackgroundTransparency = 1
                scroller.BorderSizePixel = 0
                scroller.ScrollBarThickness = 4
                scroller.ScrollBarImageColor3 = UILibrary.Theme.Accent
                scroller.ScrollingDirection = Enum.ScrollingDirection.Y
                scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
                scroller.CanvasSize = UDim2.new(0, 0, 0, 0)
                scroller.LayoutOrder = 2
                scroller.ClipsDescendants = true
                scroller.Parent = card

                local scrollerPad = Instance.new("UIPadding")
                scrollerPad.PaddingRight = UDim.new(0, 4)
                scrollerPad.Parent = scroller

                cLbl = Instance.new("TextLabel")
                cLbl.Name = "ContentLabel"
                cLbl.Size = UDim2.new(1, 0, 0, 0)
                cLbl.AutomaticSize = Enum.AutomaticSize.Y
                cLbl.BackgroundTransparency = 1
                cLbl.Font = UILibrary.Theme.Font
                cLbl.Text = pContent
                cLbl.TextColor3 = UILibrary.Theme.TextMuted
                cLbl.TextSize = 11
                cLbl.TextWrapped = true
                cLbl.TextXAlignment = Enum.TextXAlignment.Left
                cLbl.Parent = scroller
            else
                cLbl = Instance.new("TextLabel")
                cLbl.Name = "ContentLabel"
                cLbl.Size = UDim2.new(1, 0, 0, 0)
                cLbl.AutomaticSize = Enum.AutomaticSize.Y
                cLbl.BackgroundTransparency = 1
                cLbl.Font = UILibrary.Theme.Font
                cLbl.Text = pContent
                cLbl.TextColor3 = UILibrary.Theme.TextMuted
                cLbl.TextSize = 11
                cLbl.TextWrapped = true
                cLbl.TextXAlignment = Enum.TextXAlignment.Left
                cLbl.LayoutOrder = 2
                cLbl.Parent = card
            end

            local paraObj = { Frame = card, Scroller = scroller }
            function paraObj:SetDesc(newDesc)
                cLbl.Text = tostring(newDesc or "")
            end
            function paraObj:SetContent(newDesc)
                cLbl.Text = tostring(newDesc or "")
            end
            function paraObj:SetTitle(newTitle)
                tLbl.Text = tostring(newTitle or "")
            end
            return paraObj
        end

        ------------------------------------------------------------------------
        -- 3. BUTTON CARD BUILDER
        ------------------------------------------------------------------------
        function tabObj:AddButton(options)
            options = options or {}
            local bTitle = options.Title or "Button"
            local bDesc = options.Description or ""
            local bIcon = options.Icon
            local callback = options.Callback or function() end

            local card = Instance.new("TextButton")
            card.Size = UDim2.new(1, 0, 0, bDesc ~= "" and 50 or 38)
            card.BackgroundColor3 = UILibrary.Theme.Card
            card.AutoButtonColor = false
            card.Text = ""
            card.ClipsDescendants = true
            card.Parent = getParentContainer()

            local cardCorner = Instance.new("UICorner")
            cardCorner.CornerRadius = UDim.new(0, 6)
            cardCorner.Parent = card

            local cardStroke = Instance.new("UIStroke")
            cardStroke.Color = UILibrary.Theme.Border
            cardStroke.Thickness = 1
            cardStroke.Parent = card

            local btnIconImg = nil
            if bIcon and typeof(bIcon) == "string" and bIcon ~= "" then
                btnIconImg = Instance.new("ImageLabel")
                btnIconImg.Name = "ButtonIcon"
                btnIconImg.Size = UDim2.new(0, 16, 0, 16)
                btnIconImg.Position = UDim2.new(0, 10, 0.5, -8)
                btnIconImg.BackgroundTransparency = 1
                btnIconImg.Image = bIcon
                btnIconImg.ImageColor3 = UILibrary.Theme.AccentHover
                btnIconImg.Parent = card
            end

            local textOffset = btnIconImg and 32 or 10

            local tLbl = Instance.new("TextLabel")
            tLbl.Size = UDim2.new(1, -(textOffset + 10), 0, bDesc ~= "" and 18 or 38)
            tLbl.Position = UDim2.new(0, textOffset, 0, bDesc ~= "" and 6 or 0)
            tLbl.BackgroundTransparency = 1
            tLbl.Font = UILibrary.Theme.FontBold
            tLbl.Text = bTitle
            tLbl.TextColor3 = UILibrary.Theme.Text
            tLbl.TextSize = 12
            tLbl.TextXAlignment = Enum.TextXAlignment.Left
            tLbl.TextTruncate = Enum.TextTruncate.AtEnd
            tLbl.ClipsDescendants = true
            tLbl.Parent = card

            if bDesc ~= "" then
                local dLbl = Instance.new("TextLabel")
                dLbl.Size = UDim2.new(1, -(textOffset + 10), 0, 16)
                dLbl.Position = UDim2.new(0, textOffset, 0, 26)
                dLbl.BackgroundTransparency = 1
                dLbl.Font = UILibrary.Theme.Font
                dLbl.Text = bDesc
                dLbl.TextColor3 = UILibrary.Theme.TextMuted
                dLbl.TextSize = 10
                dLbl.TextXAlignment = Enum.TextXAlignment.Left
                dLbl.TextTruncate = Enum.TextTruncate.AtEnd
                dLbl.ClipsDescendants = true
                dLbl.Parent = card
            end

            card.MouseEnter:Connect(function()
                TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.CardHover }):Play()
                TweenService:Create(cardStroke, TweenInfo.new(0.15), { Color = UILibrary.Theme.BorderActive }):Play()
            end)
            card.MouseLeave:Connect(function()
                TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.Card }):Play()
                TweenService:Create(cardStroke, TweenInfo.new(0.15), { Color = UILibrary.Theme.Border }):Play()
            end)
            card.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        ------------------------------------------------------------------------
        -- 4. TOGGLE CARD BUILDER
        ------------------------------------------------------------------------
        function tabObj:AddToggle(id, options)
            options = options or {}
            local tTitle = options.Title or "Toggle"
            local tDesc = options.Description or ""
            local state = options.Default or false
            local callback = options.Callback or function() end

            local card = Instance.new("TextButton")
            card.Size = UDim2.new(1, 0, 0, tDesc ~= "" and 50 or 38)
            card.BackgroundColor3 = UILibrary.Theme.Card
            card.AutoButtonColor = false
            card.Text = ""
            card.ClipsDescendants = true
            card.Parent = getParentContainer()

            local cardCorner = Instance.new("UICorner")
            cardCorner.CornerRadius = UDim.new(0, 6)
            cardCorner.Parent = card

            local cardStroke = Instance.new("UIStroke")
            cardStroke.Color = UILibrary.Theme.Border
            cardStroke.Thickness = 1
            cardStroke.Parent = card

            local tLbl = Instance.new("TextLabel")
            tLbl.Size = UDim2.new(1, -65, 0, tDesc ~= "" and 18 or 38)
            tLbl.Position = UDim2.new(0, 10, 0, tDesc ~= "" and 6 or 0)
            tLbl.BackgroundTransparency = 1
            tLbl.Font = UILibrary.Theme.FontBold
            tLbl.Text = tTitle
            tLbl.TextColor3 = UILibrary.Theme.Text
            tLbl.TextSize = 12
            tLbl.TextXAlignment = Enum.TextXAlignment.Left
            tLbl.TextTruncate = Enum.TextTruncate.AtEnd
            tLbl.ClipsDescendants = true
            tLbl.Parent = card

            if tDesc ~= "" then
                local dLbl = Instance.new("TextLabel")
                dLbl.Size = UDim2.new(1, -65, 0, 16)
                dLbl.Position = UDim2.new(0, 10, 0, 26)
                dLbl.BackgroundTransparency = 1
                dLbl.Font = UILibrary.Theme.Font
                dLbl.Text = tDesc
                dLbl.TextColor3 = UILibrary.Theme.TextMuted
                dLbl.TextSize = 10
                dLbl.TextXAlignment = Enum.TextXAlignment.Left
                dLbl.TextTruncate = Enum.TextTruncate.AtEnd
                dLbl.ClipsDescendants = true
                dLbl.Parent = card
            end

            -- Interactive Switch Track & Knob
            local switchTrack = Instance.new("Frame")
            switchTrack.Size = UDim2.new(0, 42, 0, 22)
            switchTrack.Position = UDim2.new(1, -52, 0.5, -11)
            switchTrack.BackgroundColor3 = state and UILibrary.Theme.ToggleOn or UILibrary.Theme.ToggleOff
            switchTrack.ClipsDescendants = true
            switchTrack.Parent = card

            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(1, 0)
            trackCorner.Parent = switchTrack

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            knob.BackgroundColor3 = Color3.new(1, 1, 1)
            knob.Parent = switchTrack

            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = knob

            local onChangedCallbacks = {}
            local toggleObj = { Value = state }

            local function updateToggle(val, fireCallback)
                state = val
                toggleObj.Value = val
                local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
                local targetColor = state and UILibrary.Theme.ToggleOn or UILibrary.Theme.ToggleOff

                TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetPos }):Play()
                TweenService:Create(switchTrack, TweenInfo.new(0.2), { BackgroundColor3 = targetColor }):Play()

                if fireCallback then
                    pcall(callback, state)
                    for _, cb in ipairs(onChangedCallbacks) do
                        pcall(cb, state)
                    end
                end
            end

            card.MouseEnter:Connect(function()
                TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.CardHover }):Play()
                TweenService:Create(cardStroke, TweenInfo.new(0.15), { Color = UILibrary.Theme.BorderActive }):Play()
            end)
            card.MouseLeave:Connect(function()
                TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.Card }):Play()
                TweenService:Create(cardStroke, TweenInfo.new(0.15), { Color = UILibrary.Theme.Border }):Play()
            end)

            local function triggerClick()
                updateToggle(not state, true)
            end

            card.MouseButton1Click:Connect(triggerClick)

            function toggleObj:OnChanged(fn)
                if typeof(fn) == "function" then
                    table.insert(onChangedCallbacks, fn)
                end
            end
            function toggleObj:SetValue(val, doCallback)
                local fire = (doCallback ~= false)
                updateToggle(val, fire)
            end
            function toggleObj:GetValue()
                return state
            end
            if id and type(id) == "string" then
                UILibrary.Toggles[id] = toggleObj
            end
            return toggleObj
        end

        ------------------------------------------------------------------------
        -- 5. SLIDER CARD BUILDER
        ------------------------------------------------------------------------
        function tabObj:AddSlider(id, options)
            options = options or {}
            local sTitle = options.Title or "Slider"
            local sMin = options.Min or 0
            local sMax = options.Max or 100
            local sDefault = options.Default or sMin
            local sRounding = options.Rounding or 0
            local callback = options.Callback or function() end

            local currentVal = math.clamp(sDefault, sMin, sMax)
            local onChangedCallbacks = {}

            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 50)
            card.BackgroundColor3 = UILibrary.Theme.Card
            card.Parent = getParentContainer()

            local cardCorner = Instance.new("UICorner")
            cardCorner.CornerRadius = UDim.new(0, 6)
            cardCorner.Parent = card

            local cardStroke = Instance.new("UIStroke")
            cardStroke.Color = UILibrary.Theme.Border
            cardStroke.Thickness = 1
            cardStroke.Parent = card

            local tLbl = Instance.new("TextLabel")
            tLbl.Size = UDim2.new(1, -70, 0, 18)
            tLbl.Position = UDim2.new(0, 10, 0, 6)
            tLbl.BackgroundTransparency = 1
            tLbl.Font = UILibrary.Theme.FontBold
            tLbl.Text = sTitle
            tLbl.TextColor3 = UILibrary.Theme.Text
            tLbl.TextSize = 12
            tLbl.TextXAlignment = Enum.TextXAlignment.Left
            tLbl.Parent = card

            local valLbl = Instance.new("TextLabel")
            valLbl.Size = UDim2.new(0, 55, 0, 18)
            valLbl.Position = UDim2.new(1, -65, 0, 6)
            valLbl.BackgroundTransparency = 1
            valLbl.Font = UILibrary.Theme.FontBold
            valLbl.Text = tostring(currentVal)
            valLbl.TextColor3 = UILibrary.Theme.AccentHover
            valLbl.TextSize = 12
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.Parent = card

            local sliderTrack = Instance.new("TextButton")
            sliderTrack.Size = UDim2.new(1, -20, 0, 6)
            sliderTrack.Position = UDim2.new(0, 10, 0, 32)
            sliderTrack.BackgroundColor3 = UILibrary.Theme.ToggleOff
            sliderTrack.Text = ""
            sliderTrack.AutoButtonColor = false
            sliderTrack.Parent = card

            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(1, 0)
            trackCorner.Parent = sliderTrack

            local alpha = (currentVal - sMin) / (sMax - sMin)
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(alpha, 0, 1, 0)
            fill.BackgroundColor3 = UILibrary.Theme.Accent
            fill.Parent = sliderTrack

            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = fill

            local draggingSlider = false
            local function updateSlider(inputPos, fireCallback)
                local relX = inputPos.X - sliderTrack.AbsolutePosition.X
                local pct = math.clamp(relX / sliderTrack.AbsoluteSize.X, 0, 1)
                local val = sMin + (sMax - sMin) * pct

                if sRounding > 0 then
                    local mult = 10^sRounding
                    val = math.floor(val * mult + 0.5) / mult
                else
                    val = math.floor(val + 0.5)
                end

                currentVal = val
                fill.Size = UDim2.new(pct, 0, 1, 0)
                valLbl.Text = tostring(currentVal)

                if fireCallback then
                    pcall(callback, currentVal)
                    for _, cb in ipairs(onChangedCallbacks) do
                        pcall(cb, currentVal)
                    end
                    if Automation and typeof(Automation.SaveConfig) == "function" then
                        Automation.SaveConfig()
                    end
                end
            end

            sliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    updateSlider(input.Position, true)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input.Position, true)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                end
            end)

            local sliderObj = { Value = currentVal }
            function sliderObj:OnChanged(fn)
                if typeof(fn) == "function" then
                    table.insert(onChangedCallbacks, fn)
                end
            end
            function sliderObj:SetValue(val)
                val = math.clamp(val, sMin, sMax)
                currentVal = val
                sliderObj.Value = val
                local pct = (currentVal - sMin) / (sMax - sMin)
                fill.Size = UDim2.new(pct, 0, 1, 0)
                valLbl.Text = tostring(currentVal)
            end
            return sliderObj
        end

        ------------------------------------------------------------------------
        -- 6. FULL SUB-PANEL SEARCHABLE DROPDOWN BUILDER (BESPOKE UX)
        ------------------------------------------------------------------------
        function tabObj:AddDropdown(id, options)
            options = options or {}
            local dTitle = options.Title or "Dropdown"
            local dDesc = options.Description or ""
            local values = options.Values or {}
            local isMulti = options.Multi or false
            local default = options.Default
            local callback = options.Callback or function() end

            local onChangedCallbacks = {}
            local currentChoice

            local function cloneDict(t)
                local copy = {}
                if type(t) == "table" then
                    for k, v in pairs(t) do
                        if v == true or type(v) == "string" then
                            local keyName = (type(v) == "string" and type(k) == "number") and v or tostring(k)
                            copy[keyName] = true
                        end
                    end
                end
                return copy
            end

            if isMulti then
                currentChoice = cloneDict(default)
            else
                if type(default) == "number" and values[default] then
                    currentChoice = values[default]
                elseif type(default) == "string" and default ~= "" then
                    currentChoice = default
                else
                    currentChoice = values[1] or ""
                end
            end

            local card = Instance.new("TextButton")
            card.Size = UDim2.new(1, 0, 0, dDesc ~= "" and 52 or 40)
            card.BackgroundColor3 = UILibrary.Theme.Card
            card.AutoButtonColor = false
            card.Text = ""
            card.ClipsDescendants = true
            card.Parent = getParentContainer()

            local cardCorner = Instance.new("UICorner")
            cardCorner.CornerRadius = UDim.new(0, 6)
            cardCorner.Parent = card

            local cardStroke = Instance.new("UIStroke")
            cardStroke.Color = UILibrary.Theme.Border
            cardStroke.Thickness = 1
            cardStroke.Parent = card

            local btnWidth = 125
            local btnOffset = -(btnWidth + 10)

            local tLbl = Instance.new("TextLabel")
            tLbl.Size = UDim2.new(1, btnOffset - 8, 0, dDesc ~= "" and 18 or 40)
            tLbl.Position = UDim2.new(0, 10, 0, dDesc ~= "" and 6 or 0)
            tLbl.BackgroundTransparency = 1
            tLbl.Font = UILibrary.Theme.FontBold
            tLbl.Text = dTitle
            tLbl.TextColor3 = UILibrary.Theme.Text
            tLbl.TextSize = 12
            tLbl.TextXAlignment = Enum.TextXAlignment.Left
            tLbl.TextTruncate = Enum.TextTruncate.AtEnd
            tLbl.ClipsDescendants = true
            tLbl.Parent = card

            if dDesc ~= "" then
                local dLbl = Instance.new("TextLabel")
                dLbl.Size = UDim2.new(1, btnOffset - 8, 0, 16)
                dLbl.Position = UDim2.new(0, 10, 0, 26)
                dLbl.BackgroundTransparency = 1
                dLbl.Font = UILibrary.Theme.Font
                dLbl.Text = dDesc
                dLbl.TextColor3 = UILibrary.Theme.TextMuted
                dLbl.TextSize = 10
                dLbl.TextXAlignment = Enum.TextXAlignment.Left
                dLbl.TextTruncate = Enum.TextTruncate.AtEnd
                dLbl.ClipsDescendants = true
                dLbl.Parent = card
            end

            local dropBtn = Instance.new("TextButton")
            dropBtn.Size = UDim2.new(0, btnWidth, 0, 26)
            dropBtn.Position = UDim2.new(1, btnOffset, 0.5, -13)
            dropBtn.BackgroundColor3 = UILibrary.Theme.Sidebar
            dropBtn.AutoButtonColor = false
            dropBtn.Font = UILibrary.Theme.FontBold
            dropBtn.TextColor3 = UILibrary.Theme.AccentHover
            dropBtn.TextSize = 11
            dropBtn.TextTruncate = Enum.TextTruncate.AtEnd
            dropBtn.ClipsDescendants = true
            dropBtn.Parent = card

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = dropBtn

            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = UILibrary.Theme.Border
            btnStroke.Thickness = 1
            btnStroke.Parent = dropBtn

            card.MouseEnter:Connect(function()
                TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.CardHover }):Play()
                TweenService:Create(cardStroke, TweenInfo.new(0.15), { Color = UILibrary.Theme.BorderActive }):Play()
            end)
            card.MouseLeave:Connect(function()
                TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.Card }):Play()
                TweenService:Create(cardStroke, TweenInfo.new(0.15), { Color = UILibrary.Theme.Border }):Play()
            end)

            local function getDisplayText()
                if isMulti then
                    local selectedCount = 0
                    for _, sel in pairs(currentChoice) do
                        if sel then selectedCount = selectedCount + 1 end
                    end
                    if selectedCount == 0 then
                        return "None Selected >"
                    elseif selectedCount == #values and #values > 0 then
                        return string.format("All (%d) Selected >", selectedCount)
                    else
                        return string.format("Selected (%d) >", selectedCount)
                    end
                else
                    local strVal = tostring(currentChoice or "")
                    if strVal == "" then strVal = "None" end
                    return strVal .. " >"
                end
            end

            local function updateTriggerBtnText()
                dropBtn.Text = getDisplayText()
            end
            updateTriggerBtnText()

            dropBtn.MouseEnter:Connect(function()
                TweenService:Create(dropBtn, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.CardHover }):Play()
                TweenService:Create(btnStroke, TweenInfo.new(0.15), { Color = UILibrary.Theme.BorderActive }):Play()
            end)
            dropBtn.MouseLeave:Connect(function()
                TweenService:Create(dropBtn, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.Sidebar }):Play()
                TweenService:Create(btnStroke, TweenInfo.new(0.15), { Color = UILibrary.Theme.Border }):Play()
            end)

            local dropObj = {
                Value = currentChoice
            }

            local function fireChoiceChanged()
                dropObj.Value = currentChoice
                updateTriggerBtnText()
                pcall(callback, currentChoice)
                for _, cb in ipairs(onChangedCallbacks) do
                    pcall(cb, currentChoice)
                end
                if Automation and typeof(Automation.SaveConfig) == "function" then
                    Automation.SaveConfig()
                end
            end

            local activeSearchQuery = ""

            local function renderSubPanelOptions()
                -- Clear previous items
                for _, child in ipairs(spListFrame:GetChildren()) do
                    if child:IsA("TextButton") or child:IsA("Frame") then
                        child:Destroy()
                    end
                end

                local query = activeSearchQuery:lower():gsub("^%s*(.-)%s*$", "%1")
                local visibleCount = 0
                local totalSelected = 0

                if isMulti then
                    for _, sel in pairs(currentChoice) do
                        if sel then totalSelected = totalSelected + 1 end
                    end
                else
                    if currentChoice and currentChoice ~= "" then totalSelected = 1 end
                end

                spBadge.Text = isMulti and string.format("%d Selected", totalSelected) or (currentChoice or "None")
                spFooterLbl.Text = string.format("Total: %d of %d items selected", totalSelected, #values)

                for _, optVal in ipairs(values) do
                    local strVal = tostring(optVal)
                    if query == "" or strVal:lower():find(query, 1, true) then
                        visibleCount = visibleCount + 1

                        local isSelected = isMulti and (currentChoice[strVal] == true) or (strVal == tostring(currentChoice))

                        local itemCard = Instance.new("TextButton")
                        itemCard.Name = "Item_" .. strVal
                        itemCard.Size = UDim2.new(1, 0, 0, 36)
                        itemCard.BackgroundColor3 = isSelected and UILibrary.Theme.CardSelected or UILibrary.Theme.Card
                        itemCard.AutoButtonColor = false
                        itemCard.Text = ""
                        itemCard.ZIndex = 42
                        itemCard.Parent = spListFrame

                        local itemCorner = Instance.new("UICorner")
                        itemCorner.CornerRadius = UDim.new(0, 6)
                        itemCorner.Parent = itemCard

                        local itemStroke = Instance.new("UIStroke")
                        itemStroke.Color = isSelected and UILibrary.Theme.BorderActive or UILibrary.Theme.Border
                        itemStroke.Thickness = isSelected and 1.5 or 1
                        itemStroke.Parent = itemCard

                        local itemTitle = Instance.new("TextLabel")
                        itemTitle.Size = UDim2.new(1, -70, 1, 0)
                        itemTitle.Position = UDim2.new(0, 12, 0, 0)
                        itemTitle.BackgroundTransparency = 1
                        itemTitle.Font = isSelected and UILibrary.Theme.FontBold or UILibrary.Theme.Font
                        itemTitle.Text = strVal
                        itemTitle.TextColor3 = isSelected and UILibrary.Theme.Text or UILibrary.Theme.TextMuted
                        itemTitle.TextSize = 12
                        itemTitle.TextXAlignment = Enum.TextXAlignment.Left
                        itemTitle.TextTruncate = Enum.TextTruncate.AtEnd
                        itemTitle.ZIndex = 43
                        itemTitle.Parent = itemCard

                        -- Indicator Badge / Checkbox (Native UI Frame)
                        local indicator = Instance.new("Frame")
                        indicator.Size = UDim2.new(0, 22, 0, 22)
                        indicator.Position = UDim2.new(1, -32, 0.5, -11)
                        indicator.BackgroundColor3 = isSelected and UILibrary.Theme.Accent or UILibrary.Theme.Sidebar
                        indicator.ZIndex = 43
                        indicator.Parent = itemCard

                        local indCorner = Instance.new("UICorner")
                        indCorner.CornerRadius = isMulti and UDim.new(0, 4) or UDim.new(1, 0)
                        indCorner.Parent = indicator

                        local indStroke = Instance.new("UIStroke")
                        indStroke.Color = isSelected and UILibrary.Theme.AccentHover or UILibrary.Theme.Border
                        indStroke.Thickness = 1
                        indStroke.Parent = indicator

                        local innerDot = Instance.new("Frame")
                        innerDot.Size = isMulti and UDim2.new(0, 10, 0, 10) or UDim2.new(0, 8, 0, 8)
                        innerDot.Position = isMulti and UDim2.new(0.5, -5, 0.5, -5) or UDim2.new(0.5, -4, 0.5, -4)
                        innerDot.BackgroundColor3 = Color3.new(1, 1, 1)
                        innerDot.Visible = isSelected
                        innerDot.ZIndex = 44
                        innerDot.Parent = indicator

                        local dotCorner = Instance.new("UICorner")
                        dotCorner.CornerRadius = isMulti and UDim.new(0, 2) or UDim.new(1, 0)
                        dotCorner.Parent = innerDot

                        -- Click toggle handler
                        itemCard.MouseButton1Click:Connect(function()
                            if isMulti then
                                currentChoice[strVal] = not currentChoice[strVal]
                                if not currentChoice[strVal] then
                                    currentChoice[strVal] = nil
                                end
                                fireChoiceChanged()
                                renderSubPanelOptions()
                            else
                                currentChoice = strVal
                                fireChoiceChanged()
                                renderSubPanelOptions()
                                task.delay(0.12, function()
                                    closeDropdownSubPanel()
                                end)
                            end
                        end)

                        itemCard.MouseEnter:Connect(function()
                            if not (isMulti and currentChoice[strVal] or strVal == tostring(currentChoice)) then
                                TweenService:Create(itemCard, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.CardHover }):Play()
                            end
                        end)
                        itemCard.MouseLeave:Connect(function()
                            if not (isMulti and currentChoice[strVal] or strVal == tostring(currentChoice)) then
                                TweenService:Create(itemCard, TweenInfo.new(0.15), { BackgroundColor3 = UILibrary.Theme.Card }):Play()
                            end
                        end)
                    end
                end

                if visibleCount == 0 then
                    local emptyLbl = Instance.new("TextLabel")
                    emptyLbl.Size = UDim2.new(1, 0, 0, 60)
                    emptyLbl.BackgroundTransparency = 1
                    emptyLbl.Font = UILibrary.Theme.Font
                    emptyLbl.Text = "No matching items found."
                    emptyLbl.TextColor3 = UILibrary.Theme.TextSubtle
                    emptyLbl.TextSize = 12
                    emptyLbl.ZIndex = 42
                    emptyLbl.Parent = spListFrame
                end
            end

            local function openThisSubPanel()
                activeSearchQuery = ""
                spSearchBox.Text = ""
                spTitleLbl.Text = dTitle

                if isMulti then
                    spToolbar.Visible = true
                    spListFrame.Position = UDim2.new(0, 10, 0, 126)
                    spListFrame.Size = UDim2.new(1, -20, 1, -170)
                else
                    spToolbar.Visible = false
                    spListFrame.Position = UDim2.new(0, 10, 0, 90)
                    spListFrame.Size = UDim2.new(1, -20, 1, -134)
                end

                windowObj.CurrentActiveDropdown = {
                    UpdateTriggerBtn = updateTriggerBtnText,
                    OnSearchChanged = function(text)
                        activeSearchQuery = text or ""
                        renderSubPanelOptions()
                    end,
                    OnSelectAll = function()
                        if not isMulti then return end
                        local query = activeSearchQuery:lower():gsub("^%s*(.-)%s*$", "%1")
                        for _, optVal in ipairs(values) do
                            local strVal = tostring(optVal)
                            if query == "" or strVal:lower():find(query, 1, true) then
                                currentChoice[strVal] = true
                            end
                        end
                        fireChoiceChanged()
                        renderSubPanelOptions()
                    end,
                    OnClearAll = function()
                        if not isMulti then return end
                        local query = activeSearchQuery:lower():gsub("^%s*(.-)%s*$", "%1")
                        if query == "" then
                            currentChoice = {}
                        else
                            for _, optVal in ipairs(values) do
                                local strVal = tostring(optVal)
                                if strVal:lower():find(query, 1, true) then
                                    currentChoice[strVal] = nil
                                end
                            end
                        end
                        fireChoiceChanged()
                        renderSubPanelOptions()
                    end,
                    OnInvert = function()
                        if not isMulti then return end
                        local query = activeSearchQuery:lower():gsub("^%s*(.-)%s*$", "%1")
                        for _, optVal in ipairs(values) do
                            local strVal = tostring(optVal)
                            if query == "" or strVal:lower():find(query, 1, true) then
                                if currentChoice[strVal] then
                                    currentChoice[strVal] = nil
                                end
                            else
                                currentChoice[strVal] = true
                            end
                        end
                        fireChoiceChanged()
                        renderSubPanelOptions()
                    end
                }

                -- Hide current tab container and show SubPanel
                if windowObj.ActiveTab and windowObj.ActiveTab.Container then
                    windowObj.ActiveTab.Container.Visible = false
                end
                subPanel.Visible = true
                renderSubPanelOptions()
            end

            dropBtn.MouseButton1Click:Connect(function()
                openThisSubPanel()
            end)
            card.MouseButton1Click:Connect(function()
                openThisSubPanel()
            end)

            function dropObj:OnChanged(fn)
                if typeof(fn) == "function" then
                    table.insert(onChangedCallbacks, fn)
                end
            end

            function dropObj:SetValues(newVals)
                values = newVals or {}
                if isMulti then
                    local validSet = {}
                    for _, v in ipairs(values) do validSet[tostring(v)] = true end
                    for k, _ in pairs(currentChoice) do
                        if not validSet[k] then currentChoice[k] = nil end
                    end
                else
                    local found = false
                    for _, v in ipairs(values) do
                        if tostring(v) == tostring(currentChoice) then
                            found = true
                            break
                        end
                    end
                    if not found then
                        currentChoice = values[1] or ""
                    end
                end
                dropObj.Value = currentChoice
                updateTriggerBtnText()
                if subPanel.Visible and windowObj.CurrentActiveDropdown and windowObj.CurrentActiveDropdown.UpdateTriggerBtn == updateTriggerBtnText then
                    renderSubPanelOptions()
                end
            end

            function dropObj:SetValue(val)
                if isMulti then
                    currentChoice = cloneDict(val)
                else
                    if type(val) == "number" and values[val] then
                        currentChoice = values[val]
                    else
                        currentChoice = tostring(val or "")
                    end
                end
                dropObj.Value = currentChoice
                updateTriggerBtnText()
                if subPanel.Visible and windowObj.CurrentActiveDropdown and windowObj.CurrentActiveDropdown.UpdateTriggerBtn == updateTriggerBtnText then
                    renderSubPanelOptions()
                end
                fireChoiceChanged()
            end

            if id and type(id) == "string" then
                UILibrary.Dropdowns[id] = dropObj
            end

            return dropObj
        end

        ------------------------------------------------------------------------
        -- 7. TEXT INPUT CARD BUILDER
        ------------------------------------------------------------------------
        function tabObj:AddInput(id, options)
            options = options or {}
            local iTitle = options.Title or "Input"
            local iDesc = options.Description or ""
            local default = options.Default or ""
            local placeholder = options.Placeholder or "Enter value..."
            local numeric = options.Numeric or false
            local finished = options.Finished or false
            local callback = options.Callback or function() end

            local onChangedCallbacks = {}

            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, iDesc ~= "" and 52 or 40)
            card.BackgroundColor3 = UILibrary.Theme.Card
            card.ClipsDescendants = true
            card.Parent = getParentContainer()

            local cardCorner = Instance.new("UICorner")
            cardCorner.CornerRadius = UDim.new(0, 6)
            cardCorner.Parent = card

            local cardStroke = Instance.new("UIStroke")
            cardStroke.Color = UILibrary.Theme.Border
            cardStroke.Thickness = 1
            cardStroke.Parent = card

            local boxWidth = numeric and 75 or 135
            local boxOffset = -(boxWidth + 10)

            local tLbl = Instance.new("TextLabel")
            tLbl.Size = UDim2.new(1, boxOffset - 8, 0, iDesc ~= "" and 18 or 40)
            tLbl.Position = UDim2.new(0, 10, 0, iDesc ~= "" and 6 or 0)
            tLbl.BackgroundTransparency = 1
            tLbl.Font = UILibrary.Theme.FontBold
            tLbl.Text = iTitle
            tLbl.TextColor3 = UILibrary.Theme.Text
            tLbl.TextSize = 12
            tLbl.TextXAlignment = Enum.TextXAlignment.Left
            tLbl.TextTruncate = Enum.TextTruncate.AtEnd
            tLbl.ClipsDescendants = true
            tLbl.Parent = card

            if iDesc ~= "" then
                local dLbl = Instance.new("TextLabel")
                dLbl.Size = UDim2.new(1, boxOffset - 8, 0, 16)
                dLbl.Position = UDim2.new(0, 10, 0, 26)
                dLbl.BackgroundTransparency = 1
                dLbl.Font = UILibrary.Theme.Font
                dLbl.Text = iDesc
                dLbl.TextColor3 = UILibrary.Theme.TextMuted
                dLbl.TextSize = 10
                dLbl.TextXAlignment = Enum.TextXAlignment.Left
                dLbl.TextTruncate = Enum.TextTruncate.AtEnd
                dLbl.ClipsDescendants = true
                dLbl.Parent = card
            end

            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(0, boxWidth, 0, 26)
            textBox.Position = UDim2.new(1, boxOffset, 0.5, -13)
            textBox.BackgroundColor3 = UILibrary.Theme.Sidebar
            textBox.Font = UILibrary.Theme.Font
            textBox.Text = tostring(default)
            textBox.PlaceholderText = placeholder
            textBox.TextColor3 = Color3.fromRGB(240, 240, 245)
            textBox.PlaceholderColor3 = Color3.fromRGB(140, 135, 160)
            textBox.TextSize = 11
            textBox.TextXAlignment = numeric and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
            textBox.TextYAlignment = Enum.TextYAlignment.Center
            textBox.TextTruncate = Enum.TextTruncate.AtEnd
            textBox.ClipsDescendants = true
            textBox.ClearTextOnFocus = false
            textBox.Parent = card

            local tbPad = Instance.new("UIPadding")
            tbPad.PaddingLeft = UDim.new(0, 6)
            tbPad.PaddingRight = UDim.new(0, 6)
            tbPad.Parent = textBox

            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 5)
            boxCorner.Parent = textBox

            local boxStroke = Instance.new("UIStroke")
            boxStroke.Color = Color3.fromRGB(60, 55, 75)
            boxStroke.Thickness = 1
            boxStroke.Parent = textBox

            textBox.Focused:Connect(function()
                TweenService:Create(boxStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(90, 85, 110) }):Play()
            end)
            textBox.FocusLost:Connect(function()
                TweenService:Create(boxStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(60, 55, 75) }):Play()
            end)

            local inputObj = { Value = textBox.Text }

            local function fireInput()
                local txt = textBox.Text
                if numeric then
                    txt = txt:gsub("[^%d%.%-]", "")
                end
                inputObj.Value = txt
                pcall(callback, txt)
                for _, cb in ipairs(onChangedCallbacks) do
                    pcall(cb, txt)
                end
                if Automation and typeof(Automation.SaveConfig) == "function" then
                    Automation.SaveConfig()
                end
            end

            if finished then
                textBox.FocusLost:Connect(function()
                    fireInput()
                end)
            else
                textBox:GetPropertyChangedSignal("Text"):Connect(function()
                    fireInput()
                end)
            end

            function inputObj:OnChanged(fn)
                if typeof(fn) == "function" then
                    table.insert(onChangedCallbacks, fn)
                end
            end
            function inputObj:SetValue(val)
                textBox.Text = tostring(val or "")
                fireInput()
            end
            return inputObj
        end

        table.insert(windowObj.Tabs, tabObj)
        if #windowObj.Tabs == 1 then
            windowObj:SelectTab(1)
        end

        return tabObj
    end

    return windowObj
end

return UILibrary
