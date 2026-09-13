-- DKHUB PREMIUM VISUAL UI
-- Visual-only UI kit: no game functions, automation, callbacks or executor logic.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("DKHUB_PREMIUM_UI")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DKHUB_PREMIUM_UI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local P = {
    black = Color3.fromRGB(5, 5, 9),
    panel = Color3.fromRGB(13, 13, 21),
    panel2 = Color3.fromRGB(23, 20, 34),
    red = Color3.fromRGB(224, 36, 67),
    pink = Color3.fromRGB(255, 74, 133),
    purple = Color3.fromRGB(133, 77, 255),
    cyan = Color3.fromRGB(70, 206, 255),
    white = Color3.fromRGB(255, 255, 255),
    muted = Color3.fromRGB(151, 150, 173),
}

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function animate(obj, duration, props, style, direction)
    local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function gradient(parent, name, colors, rotation)
    local g = Instance.new("UIGradient")
    g.Name = name
    g.Color = ColorSequence.new(colors)
    g.Rotation = rotation or 0
    g.Parent = parent
    return g
end

-- Floating atmospheric glow behind the window.
local aura = Instance.new("Frame")
aura.Name = "Aura"
aura.AnchorPoint = Vector2.new(0.5, 0.5)
aura.Position = UDim2.fromScale(0.5, 0.5)
aura.Size = UDim2.fromScale(0.80, 0.68)
aura.BackgroundColor3 = P.red
aura.BackgroundTransparency = 0.90
aura.BorderSizePixel = 0
aura.ZIndex = 0
aura.Parent = gui
corner(aura, 30)
gradient(aura, "AuraGradient", {
    ColorSequenceKeypoint.new(0, P.purple),
    ColorSequenceKeypoint.new(0.5, P.red),
    ColorSequenceKeypoint.new(1, P.cyan),
}, 25)

task.spawn(function()
    while gui.Parent do
        animate(aura, 2.8, {Size = UDim2.fromScale(0.84, 0.72), BackgroundTransparency = 0.94}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
        animate(aura, 2.8, {Size = UDim2.fromScale(0.80, 0.68), BackgroundTransparency = 0.90}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
    end
end)

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.51)
shadow.Size = UDim2.fromScale(0.705, 0.575)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.20
shadow.BorderSizePixel = 0
shadow.ZIndex = 1
shadow.Parent = gui
corner(shadow, 18)

local card = Instance.new("Frame")
card.Name = "DKHUB"
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.fromScale(0.5, 0.5)
card.Size = UDim2.fromScale(0.69, 0.55)
card.BackgroundColor3 = P.panel
card.BorderSizePixel = 0
card.ClipsDescendants = true
card.ZIndex = 2
card.Parent = gui
corner(card, 16)
local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 16 / 9
aspect.DominantAxis = Enum.DominantAxis.Width
aspect.Parent = card

local cardGradient = gradient(card, "PanelGradient", {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 14, 30)),
    ColorSequenceKeypoint.new(0.45, P.panel),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 16, 28)),
}, 125)

task.spawn(function()
    while gui.Parent do
        animate(cardGradient, 3.8, {Offset = Vector2.new(0.35, 0)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
        animate(cardGradient, 3.8, {Offset = Vector2.new(-0.35, 0)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
    end
end)

local border = stroke(card, P.red, 2, 0.02)
local borderGradient = gradient(border, "PrismaticBorder", {
    ColorSequenceKeypoint.new(0, P.red),
    ColorSequenceKeypoint.new(0.28, P.pink),
    ColorSequenceKeypoint.new(0.50, P.white),
    ColorSequenceKeypoint.new(0.72, P.purple),
    ColorSequenceKeypoint.new(1, P.red),
}, 0)

task.spawn(function()
    while gui.Parent do
        borderGradient.Offset = Vector2.new(-1, 0)
        animate(borderGradient, 1.55, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut).Completed:Wait()
        task.wait(0.45)
    end
end)

-- Decorative light particles.
for i = 1, 9 do
    local dot = Instance.new("Frame")
    dot.Name = "LightDot" .. i
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.fromScale(0.10 + ((i * 0.097) % 0.80), 0.18 + ((i * 0.173) % 0.66))
    dot.Size = UDim2.fromOffset(i % 3 + 2, i % 3 + 2)
    dot.BackgroundColor3 = (i % 2 == 0) and P.pink or P.cyan
    dot.BackgroundTransparency = 0.35
    dot.BorderSizePixel = 0
    dot.ZIndex = 3
    dot.Parent = card
    corner(dot, 8)
    task.spawn(function()
        while gui.Parent do
            animate(dot, 1.4 + (i * 0.08), {BackgroundTransparency = 0.85, Size = UDim2.fromOffset(5, 5)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
            animate(dot, 1.4 + (i * 0.08), {BackgroundTransparency = 0.35, Size = UDim2.fromOffset(i % 3 + 2, i % 3 + 2)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
        end
    end)
end

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 54)
header.BackgroundColor3 = P.black
header.BackgroundTransparency = 0.04
header.BorderSizePixel = 0
header.ZIndex = 5
header.Parent = card

gradient(header, "HeaderGradient", {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 8, 24)),
    ColorSequenceKeypoint.new(0.50, P.black),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 15, 28)),
}, 0)

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Position = UDim2.fromOffset(18, 7)
title.Size = UDim2.new(0.55, 0, 0, 24)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.Text = "DKHUB"
title.TextColor3 = P.white
title.TextSize = 21
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 8
title.Parent = header
local titleGradient = gradient(title, "TitleGradient", {
    ColorSequenceKeypoint.new(0, P.white),
    ColorSequenceKeypoint.new(0.45, P.pink),
    ColorSequenceKeypoint.new(1, P.white),
}, 0)
task.spawn(function()
    while gui.Parent do
        titleGradient.Offset = Vector2.new(-1, 0)
        animate(titleGradient, 2.2, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear).Completed:Wait()
        task.wait(0.6)
    end
end)

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Position = UDim2.fromOffset(19, 32)
subtitle.Size = UDim2.new(0.65, 0, 0, 13)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.GothamMedium
subtitle.Text = "PREMIUM VISUAL INTERFACE"
subtitle.TextColor3 = P.muted
subtitle.TextSize = 9
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 8
subtitle.Parent = header

local function headerButton(name, text, xOffset)
    local b = Instance.new("TextButton")
    b.Name = name
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, xOffset, 0.5, 0)
    b.Size = UDim2.fromOffset(34, 33)
    b.BackgroundColor3 = P.panel2
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.TextColor3 = P.white
    b.TextSize = 16
    b.ZIndex = 9
    b.Parent = header
    round(b, 9)
    local s = stroke(b, P.red, 1, 0.55)
    b.MouseEnter:Connect(function()
        animate(b, 0.16, {BackgroundColor3 = P.redBright})
        animate(s, 0.16, {Transparency = 0})
    end)
    b.MouseLeave:Connect(function()
        animate(b, 0.16, {BackgroundColor3 = P.panel2})
        animate(s, 0.16, {Transparency = 0.55})
    end)
    return b
end

local closeButton = headerButton("Close", "×", -10)
local minimizeButton = headerButton("Minimize", "□", -51)

local line = Instance.new("Frame")
line.Name = "HeaderLine"
line.Position = UDim2.new(0, 16, 1, -1)
line.Size = UDim2.new(1, -32, 0, 1)
line.BackgroundColor3 = P.red
line.BorderSizePixel = 0
line.ZIndex = 9
line.Parent = header
local lineGradient = gradient(line, "LineGradient", {
    ColorSequenceKeypoint.new(0, P.red),
    ColorSequenceKeypoint.new(0.5, P.white),
    ColorSequenceKeypoint.new(1, P.purple),
}, 0)
task.spawn(function()
    while gui.Parent do
        lineGradient.Offset = Vector2.new(-1, 0)
        animate(lineGradient, 1.5, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear).Completed:Wait()
        task.wait(0.5)
    end
end)

-- Empty showcase area.
local showcase = Instance.new("Frame")
showcase.Name = "EmptyShowcase"
showcase.Position = UDim2.fromOffset(0, 54)
showcase.Size = UDim2.new(1, 0, 1, -54)
showcase.BackgroundTransparency = 1
showcase.BorderSizePixel = 0
showcase.ZIndex = 4
showcase.Parent = card

local centerOrb = Instance.new("Frame")
centerOrb.Name = "CenterOrb"
centerOrb.AnchorPoint = Vector2.new(0.5, 0.5)
centerOrb.Position = UDim2.fromScale(0.5, 0.49)
centerOrb.Size = UDim2.fromOffset(7, 7)
centerOrb.BackgroundColor3 = P.white
centerOrb.BorderSizePixel = 0
centerOrb.ZIndex = 5
centerOrb.Parent = showcase
corner(centerOrb, 10)
local orbStroke = stroke(centerOrb, P.pink, 2, 0.1)

task.spawn(function()
    while gui.Parent do
        animate(centerOrb, 1.5, {Size = UDim2.fromOffset(13, 13), BackgroundTransparency = 0.25}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
        animate(centerOrb, 1.5, {Size = UDim2.fromOffset(7, 7), BackgroundTransparency = 0}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
    end
end)

local accent = Instance.new("Frame")
accent.Name = "BottomAccent"
accent.AnchorPoint = Vector2.new(0.5, 1)
accent.Position = UDim2.fromScale(0.5, 0.91)
accent.Size = UDim2.fromScale(0.20, 0.008)
accent.BackgroundColor3 = P.red
accent.BorderSizePixel = 0
accent.ZIndex = 5
accent.Parent = showcase
corner(accent, 10)
gradient(accent, "AccentGradient", {
    ColorSequenceKeypoint.new(0, P.red),
    ColorSequenceKeypoint.new(0.5, P.white),
    ColorSequenceKeypoint.new(1, P.purple),
}, 0)

local icon = Instance.new("TextButton")
icon.Name = "DKHUB_Icon"
icon.AnchorPoint = Vector2.new(0.5, 0.5)
icon.Position = UDim2.fromScale(0.88, 0.82)
icon.Size = UDim2.fromOffset(62, 62)
icon.BackgroundColor3 = P.black
icon.AutoButtonColor = false
icon.BorderSizePixel = 0
icon.Font = Enum.Font.GothamBlack
icon.Text = "DK"
icon.TextColor3 = P.white
icon.TextSize = 18
icon.Visible = false
icon.ZIndex = 20
icon.Parent = gui
corner(icon, 31)
local iconStroke = stroke(icon, P.pink, 2, 0)
gradient(iconStroke, "IconGradient", {
    ColorSequenceKeypoint.new(0, P.red),
    ColorSequenceKeypoint.new(0.5, P.white),
    ColorSequenceKeypoint.new(1, P.purple),
}, 0)

local minimized = false
local closed = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = true
    animate(card, 0.38, {Position = UDim2.fromScale(0.5, 1.26)}, Enum.EasingStyle.Back)
    animate(shadow, 0.38, {Position = UDim2.fromScale(0.5, 1.28)}, Enum.EasingStyle.Back)
    animate(aura, 0.38, {Position = UDim2.fromScale(0.5, 1.24)}, Enum.EasingStyle.Back)
    task.delay(0.22, function()
        if minimized and not closed then
            icon.Visible = true
            icon.Size = UDim2.fromOffset(8, 8)
            animate(icon, 0.34, {Size = UDim2.fromOffset(62, 62)}, Enum.EasingStyle.Back)
        end
    end)
end)

icon.MouseEnter:Connect(function() animate(icon, 0.16, {BackgroundColor3 = Color3.fromRGB(27, 12, 35)}) end)
icon.MouseLeave:Connect(function() animate(icon, 0.16, {BackgroundColor3 = P.black}) end)
icon.MouseButton1Click:Connect(function()
    minimized = false
    icon.Visible = false
    animate(card, 0.42, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)
    animate(shadow, 0.42, {Position = UDim2.fromScale(0.5, 0.51)}, Enum.EasingStyle.Back)
    animate(aura, 0.42, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)
end)

closeButton.MouseButton1Click:Connect(function()
    closed = true
    animate(card, 0.30, {Position = UDim2.fromScale(0.5, 1.35)}, Enum.EasingStyle.Back)
    animate(shadow, 0.30, {Position = UDim2.fromScale(0.5, 1.37)}, Enum.EasingStyle.Back)
    task.delay(0.34, function() if closed then gui:Destroy() end end)
end)

-- Drag the premium window by its header.
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
        aura.Position = UDim2.new(card.Position.X.Scale, card.Position.X.Offset, card.Position.Y.Scale, card.Position.Y.Offset)
    end
end)
