-- DKHUB UI
-- Black/red 16:9-style panel with smooth open/close, minimize icon and Account details.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local oldGui = playerGui:FindFirstChild("DKHUB_UI")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DKHUB_UI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local RED = Color3.fromRGB(210, 30, 45)
local BLACK = Color3.fromRGB(8, 8, 10)
local PANEL = Color3.fromRGB(14, 14, 17)
local WHITE = Color3.fromRGB(255, 255, 255)
local MUTED = Color3.fromRGB(190, 190, 198)

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

local function playTween(instance, duration, properties, style, direction)
    local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(instance, info, properties)
    t:Play()
    return t
end

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.505)
shadow.Size = UDim2.fromScale(0.685, 0.47)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.4
shadow.BorderSizePixel = 0
shadow.ZIndex = 1
shadow.Parent = gui
corner(shadow, 14)

local card = Instance.new("Frame")
card.Name = "MainWindow"
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.fromScale(0.5, 0.5)
card.Size = UDim2.fromScale(0.68, 0.46)
card.BackgroundColor3 = PANEL
card.BorderSizePixel = 0
card.ClipsDescendants = true
card.ZIndex = 2
card.Parent = gui
corner(card, 12)

local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 16 / 9
aspect.DominantAxis = Enum.DominantAxis.Width
aspect.Parent = card

local border = Instance.new("UIStroke")
border.Name = "RedBorder"
border.Color = RED
border.Thickness = 2
border.Parent = card

local shine = Instance.new("UIGradient")
shine.Name = "WhiteShine"
shine.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, RED),
    ColorSequenceKeypoint.new(0.43, RED),
    ColorSequenceKeypoint.new(0.50, WHITE),
    ColorSequenceKeypoint.new(0.57, RED),
    ColorSequenceKeypoint.new(1, RED),
})
shine.Offset = Vector2.new(-1, 0)
shine.Parent = border

local shineRunning = true
task.spawn(function()
    while shineRunning and gui.Parent do
        shine.Offset = Vector2.new(-1, 0)
        playTween(shine, 1.8, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut).Completed:Wait()
        task.wait(0.65)
    end
end)

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = BLACK
header.BorderSizePixel = 0
header.ZIndex = 3
header.Parent = card

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Position = UDim2.fromOffset(14, 0)
title.Size = UDim2.new(0.45, 0, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "DKHUB"
title.TextColor3 = WHITE
title.TextSize = 19
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 4
title.Parent = header

local function makeHeaderButton(name, text, x)
    local b = Instance.new("TextButton")
    b.Name = name
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, x, 0.5, 0)
    b.Size = UDim2.fromOffset(31, 30)
    b.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.TextColor3 = WHITE
    b.TextSize = 15
    b.ZIndex = 4
    b.Parent = header
    corner(b, 7)
    b.MouseEnter:Connect(function() playTween(b, 0.14, {BackgroundColor3 = RED}) end)
    b.MouseLeave:Connect(function() playTween(b, 0.14, {BackgroundColor3 = Color3.fromRGB(28, 28, 33)}) end)
    return b
end

local closeButton = makeHeaderButton("CloseButton", "×", -10)
local minimizeButton = makeHeaderButton("MinimizeButton", "□", -48)

local separator = Instance.new("Frame")
separator.Name = "HeaderSeparator"
separator.Position = UDim2.new(0, 12, 1, -1)
separator.Size = UDim2.new(1, -24, 0, 1)
separator.BackgroundColor3 = RED
separator.BorderSizePixel = 0
separator.ZIndex = 4
separator.Parent = header

local body = Instance.new("Frame")
body.Name = "Body"
body.Position = UDim2.fromOffset(0, 42)
body.Size = UDim2.new(1, 0, 1, -42)
body.BackgroundColor3 = PANEL
body.BorderSizePixel = 0
body.ZIndex = 3
body.Parent = card

local accountButton = Instance.new("TextButton")
accountButton.Name = "AccountButton"
accountButton.Position = UDim2.fromScale(0.06, 0.20)
accountButton.Size = UDim2.fromScale(0.88, 0.25)
accountButton.BackgroundColor3 = BLACK
accountButton.AutoButtonColor = false
accountButton.BorderSizePixel = 0
accountButton.Font = Enum.Font.GothamSemibold
accountButton.Text = "Account"
accountButton.TextColor3 = WHITE
accountButton.TextSize = 17
accountButton.TextXAlignment = Enum.TextXAlignment.Left
accountButton.ZIndex = 4
accountButton.Parent = body
corner(accountButton, 8)
local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 14)
padding.Parent = accountButton
local accountStroke = Instance.new("UIStroke")
accountStroke.Color = RED
accountStroke.Thickness = 1
accountStroke.Transparency = 0.25
accountStroke.Parent = accountButton

local hint = Instance.new("TextLabel")
hint.Name = "Hint"
hint.Position = UDim2.fromScale(0.06, 0.54)
hint.Size = UDim2.fromScale(0.88, 0.16)
hint.BackgroundTransparency = 1
hint.Font = Enum.Font.Gotham
hint.Text = "กด Account เพื่อดูข้อมูลการล็อกอิน"
hint.TextColor3 = MUTED
hint.TextSize = 13
hint.TextXAlignment = Enum.TextXAlignment.Left
hint.ZIndex = 4
hint.Parent = body

local accountPanel = Instance.new("Frame")
accountPanel.Name = "AccountPanel"
accountPanel.Position = UDim2.fromScale(0.06, 0.20)
accountPanel.Size = UDim2.fromScale(0.88, 0.58)
accountPanel.BackgroundColor3 = BLACK
accountPanel.BorderSizePixel = 0
accountPanel.Visible = false
accountPanel.ZIndex = 5
accountPanel.Parent = body
corner(accountPanel, 8)
local accountPanelStroke = Instance.new("UIStroke")
accountPanelStroke.Color = RED
accountPanelStroke.Thickness = 1
accountPanelStroke.Parent = accountPanel

local function makeInfo(name, text, y)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Position = UDim2.fromScale(0.05, y)
    label.Size = UDim2.fromScale(0.9, 0.2)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = MUTED
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 6
    label.Parent = accountPanel
    return label
end

local accountTitle = makeInfo("AccountTitle", "Account", 0.10)
accountTitle.Font = Enum.Font.GothamBold
accountTitle.TextColor3 = WHITE
accountTitle.TextSize = 16
local userInfo = makeInfo("UserInfo", "user : " .. player.Name, 0.38)
local mapName = workspace:GetAttribute("MapName") or tostring(game.PlaceId)
local mapInfo = makeInfo("MapInfo", "map : " .. mapName, 0.62)

local backButton = Instance.new("TextButton")
backButton.Name = "BackButton"
backButton.Position = UDim2.fromScale(0.70, 0.78)
backButton.Size = UDim2.fromScale(0.25, 0.14)
backButton.BackgroundColor3 = RED
backButton.AutoButtonColor = false
backButton.BorderSizePixel = 0
backButton.Font = Enum.Font.GothamSemibold
backButton.Text = "กลับ"
backButton.TextColor3 = WHITE
backButton.TextSize = 13
backButton.ZIndex = 6
backButton.Parent = accountPanel
corner(backButton, 6)

local icon = Instance.new("TextButton")
icon.Name = "DKHUB_Icon"
icon.AnchorPoint = Vector2.new(0.5, 0.5)
icon.Position = UDim2.fromScale(0.88, 0.82)
icon.Size = UDim2.fromOffset(58, 58)
icon.BackgroundColor3 = BLACK
icon.AutoButtonColor = false
icon.BorderSizePixel = 0
icon.Font = Enum.Font.GothamBold
icon.Text = "DK"
icon.TextColor3 = WHITE
icon.TextSize = 17
icon.Visible = false
icon.ZIndex = 10
icon.Parent = gui
corner(icon, 29)
local iconStroke = Instance.new("UIStroke")
iconStroke.Color = RED
iconStroke.Thickness = 2
iconStroke.Parent = icon

local minimized = false
local closed = false
local function setMinimized(value)
    minimized = value
    if minimized then
        playTween(card, 0.3, {Position = UDim2.fromScale(0.5, 1.25)})
        playTween(shadow, 0.3, {Position = UDim2.fromScale(0.5, 1.27)})
        task.delay(0.2, function()
            if minimized and not closed then
                icon.Visible = true
                icon.Size = UDim2.fromOffset(8, 8)
                playTween(icon, 0.25, {Size = UDim2.fromOffset(58, 58)})
            end
        end)
    else
        icon.Visible = false
        playTween(card, 0.3, {Position = UDim2.fromScale(0.5, 0.5)})
        playTween(shadow, 0.3, {Position = UDim2.fromScale(0.5, 0.505)})
    end
end

accountButton.MouseButton1Click:Connect(function()
    accountButton.Visible = false
    hint.Visible = false
    accountPanel.Visible = true
    accountPanel.Size = UDim2.fromScale(0.88, 0.1)
    playTween(accountPanel, 0.25, {Size = UDim2.fromScale(0.88, 0.58)})
end)

backButton.MouseButton1Click:Connect(function()
    playTween(accountPanel, 0.2, {Size = UDim2.fromScale(0.88, 0.1)}).Completed:Connect(function()
        accountPanel.Visible = false
        accountButton.Visible = true
        hint.Visible = true
        accountPanel.Size = UDim2.fromScale(0.88, 0.58)
    end)
end)

minimizeButton.MouseButton1Click:Connect(function() setMinimized(true) end)
icon.MouseButton1Click:Connect(function() setMinimized(false) end)
closeButton.MouseButton1Click:Connect(function()
    closed = true
    shineRunning = false
    playTween(card, 0.25, {Position = UDim2.fromScale(0.5, 1.3)})
    playTween(shadow, 0.25, {Position = UDim2.fromScale(0.5, 1.32)})
    task.delay(0.28, function() if closed then gui:Destroy() end end)
end)

-- Drag the window using the header on mouse or touch.
local dragging = false
local dragStart
local startPosition
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = card.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        card.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        shadow.Position = UDim2.new(card.Position.X.Scale, card.Position.X.Offset, card.Position.Y.Scale, card.Position.Y.Offset + 5)
    end
end)
