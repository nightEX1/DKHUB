-- DKHUB UI KIT
-- Visual-only interface template. No game automation, no callbacks, no game controls.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("DKHUB_UI_KIT")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DKHUB_UI_KIT"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local COLOR = {
    black = Color3.fromRGB(7, 7, 10),
    panel = Color3.fromRGB(15, 15, 20),
    panel2 = Color3.fromRGB(23, 23, 30),
    red = Color3.fromRGB(221, 32, 49),
    redBright = Color3.fromRGB(255, 71, 86),
    white = Color3.fromRGB(255, 255, 255),
    gray = Color3.fromRGB(150, 151, 165),
}

local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

local function addStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function animate(instance, duration, properties, style)
    local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

-- Soft shadow behind the card.
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.505)
shadow.Size = UDim2.fromScale(0.705, 0.575)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.28
shadow.BorderSizePixel = 0
shadow.ZIndex = 1
shadow.Parent = gui
addCorner(shadow, 17)

-- Main card: inset 16:9 layout so the scene remains visible.
local card = Instance.new("Frame")
card.Name = "DKHUB"
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.fromScale(0.5, 0.5)
card.Size = UDim2.fromScale(0.69, 0.55)
card.BackgroundColor3 = COLOR.panel
card.BorderSizePixel = 0
card.ClipsDescendants = true
card.ZIndex = 2
card.Parent = gui
addCorner(card, 15)

local ratio = Instance.new("UIAspectRatioConstraint")
ratio.Name = "SixteenByNine"
ratio.AspectRatio = 16 / 9
ratio.DominantAxis = Enum.DominantAxis.Width
ratio.Parent = card

-- Red frame with a white moving shine.
local frameStroke = addStroke(card, COLOR.red, 2, 0.02)
local shine = Instance.new("UIGradient")
shine.Name = "WhiteShine"
shine.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, COLOR.red),
    ColorSequenceKeypoint.new(0.42, COLOR.red),
    ColorSequenceKeypoint.new(0.50, COLOR.white),
    ColorSequenceKeypoint.new(0.58, COLOR.red),
    ColorSequenceKeypoint.new(1.00, COLOR.red),
})
shine.Offset = Vector2.new(-1, 0)
shine.Parent = frameStroke

task.spawn(function()
    while gui.Parent do
        shine.Offset = Vector2.new(-1, 0)
        animate(shine, 1.65, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear).Completed:Wait()
        task.wait(0.65)
    end
end)

-- Header.
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 52)
header.BackgroundColor3 = COLOR.black
header.BorderSizePixel = 0
header.ZIndex = 4
header.Parent = card

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Position = UDim2.fromOffset(18, 7)
title.Size = UDim2.new(0.55, 0, 0, 23)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "DKHUB"
title.TextColor3 = COLOR.white
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Position = UDim2.fromOffset(19, 31)
subtitle.Size = UDim2.new(0.65, 0, 0, 13)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "UI KIT  /  VISUAL TEMPLATE"
subtitle.TextColor3 = COLOR.gray
subtitle.TextSize = 9
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 6
subtitle.Parent = header

local function headerButton(name, text, xOffset)
    local button = Instance.new("TextButton")
    button.Name = name
    button.AnchorPoint = Vector2.new(1, 0.5)
    button.Position = UDim2.new(1, xOffset, 0.5, 0)
    button.Size = UDim2.fromOffset(33, 32)
    button.BackgroundColor3 = COLOR.panel2
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.TextColor3 = COLOR.white
    button.TextSize = 16
    button.ZIndex = 7
    button.Parent = header
    addCorner(button, 8)
    button.MouseEnter:Connect(function()
        animate(button, 0.13, {BackgroundColor3 = COLOR.redBright})
    end)
    button.MouseLeave:Connect(function()
        animate(button, 0.13, {BackgroundColor3 = COLOR.panel2})
    end)
    return button
end

local closeButton = headerButton("Close", "×", -10)
local minimizeButton = headerButton("Minimize", "□", -50)

local headerLine = Instance.new("Frame")
headerLine.Name = "HeaderLine"
headerLine.Position = UDim2.new(0, 15, 1, -1)
headerLine.Size = UDim2.new(1, -30, 0, 1)
headerLine.BackgroundColor3 = COLOR.red
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 7
headerLine.Parent = header

-- Empty content area: intentionally no game functions.
local emptyContent = Instance.new("Frame")
emptyContent.Name = "EmptyContent"
emptyContent.Position = UDim2.fromOffset(0, 52)
emptyContent.Size = UDim2.new(1, 0, 1, -52)
emptyContent.BackgroundColor3 = COLOR.panel
emptyContent.BorderSizePixel = 0
emptyContent.ZIndex = 3
emptyContent.Parent = card

local centerGlow = Instance.new("Frame")
centerGlow.Name = "CenterGlow"
centerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
centerGlow.Position = UDim2.fromScale(0.5, 0.48)
centerGlow.Size = UDim2.fromScale(0.42, 0.05)
centerGlow.BackgroundColor3 = COLOR.red
centerGlow.BackgroundTransparency = 0.82
centerGlow.BorderSizePixel = 0
centerGlow.ZIndex = 4
centerGlow.Parent = emptyContent
addCorner(centerGlow, 20)

local bottomLine = Instance.new("Frame")
bottomLine.Name = "BottomAccent"
bottomLine.AnchorPoint = Vector2.new(0.5, 1)
bottomLine.Position = UDim2.fromScale(0.5, 0.92)
bottomLine.Size = UDim2.fromScale(0.22, 0.008)
bottomLine.BackgroundColor3 = COLOR.red
bottomLine.BorderSizePixel = 0
bottomLine.ZIndex = 4
bottomLine.Parent = emptyContent
addCorner(bottomLine, 10)

-- Small floating icon shown after minimize.
local icon = Instance.new("TextButton")
icon.Name = "DKHUB_Icon"
icon.AnchorPoint = Vector2.new(0.5, 0.5)
icon.Position = UDim2.fromScale(0.88, 0.82)
icon.Size = UDim2.fromOffset(60, 60)
icon.BackgroundColor3 = COLOR.black
icon.AutoButtonColor = false
icon.BorderSizePixel = 0
icon.Font = Enum.Font.GothamBold
icon.Text = "DK"
icon.TextColor3 = COLOR.white
icon.TextSize = 18
icon.Visible = false
icon.ZIndex = 20
icon.Parent = gui
addCorner(icon, 30)
addStroke(icon, COLOR.redBright, 2, 0)

local minimized = false
local closed = false

minimizeButton.MouseButton1Click:Connect(function()
    minimized = true
    animate(card, 0.30, {Position = UDim2.fromScale(0.5, 1.25)})
    animate(shadow, 0.30, {Position = UDim2.fromScale(0.5, 1.27)})
    task.delay(0.2, function()
        if minimized and not closed then
            icon.Visible = true
            icon.Size = UDim2.fromOffset(8, 8)
            animate(icon, 0.24, {Size = UDim2.fromOffset(60, 60)})
        end
    end)
end)

icon.MouseButton1Click:Connect(function()
    minimized = false
    icon.Visible = false
    animate(card, 0.30, {Position = UDim2.fromScale(0.5, 0.5)})
    animate(shadow, 0.30, {Position = UDim2.fromScale(0.5, 0.505)})
end)

closeButton.MouseButton1Click:Connect(function()
    closed = true
    animate(card, 0.25, {Position = UDim2.fromScale(0.5, 1.30)})
    animate(shadow, 0.25, {Position = UDim2.fromScale(0.5, 1.32)})
    task.delay(0.28, function()
        if closed then gui:Destroy() end
    end)
end)

-- Drag support for mouse and touch.
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
