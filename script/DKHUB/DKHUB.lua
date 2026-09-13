-- DKHUB MOBILE TEST UI
-- Large mobile-friendly visual UI with TEST switches.
-- Visual-only template: switches control UI effects, not game automation.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("DKHUB_MOBILE_TEST")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DKHUB_MOBILE_TEST"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local C = {
    black = Color3.fromRGB(5, 5, 9),
    panel = Color3.fromRGB(14, 14, 21),
    panel2 = Color3.fromRGB(24, 23, 34),
    red = Color3.fromRGB(224, 35, 65),
    pink = Color3.fromRGB(255, 78, 135),
    purple = Color3.fromRGB(135, 76, 255),
    cyan = Color3.fromRGB(61, 208, 255),
    green = Color3.fromRGB(66, 220, 143),
    white = Color3.fromRGB(255, 255, 255),
    text = Color3.fromRGB(222, 221, 235),
    muted = Color3.fromRGB(148, 148, 170),
}

local function corner(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = o
end

local function addStroke(o, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Transparency = transparency or 0
    s.Parent = o
    return s
end

local function tw(o, duration, props, style, direction)
    local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(o, info, props)
    t:Play()
    return t
end

local function addGradient(o, name, colors, rotation)
    local g = Instance.new("UIGradient")
    g.Name = name
    g.Color = ColorSequence.new(colors)
    g.Rotation = rotation or 0
    g.Parent = o
    return g
end

local function text(parent, name, value, position, size, font, textSize, color)
    local l = Instance.new("TextLabel")
    l.Name = name
    l.Text = value
    l.Position = position
    l.Size = size
    l.BackgroundTransparency = 1
    l.Font = font or Enum.Font.Gotham
    l.TextSize = textSize or 14
    l.TextColor3 = color or C.text
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 8
    l.Parent = parent
    return l
end

-- Nearly full-screen mobile card; still leaves a thin margin so the game remains visible.
local aura = Instance.new("Frame")
aura.Name = "Aura"
aura.AnchorPoint = Vector2.new(0.5, 0.5)
aura.Position = UDim2.fromScale(0.5, 0.5)
aura.Size = UDim2.fromScale(0.97, 0.91)
aura.BackgroundColor3 = C.red
aura.BackgroundTransparency = 0.91
aura.BorderSizePixel = 0
aura.ZIndex = 0
aura.Parent = gui
corner(aura, 26)
addGradient(aura, "AuraGradient", {
    ColorSequenceKeypoint.new(0, C.purple),
    ColorSequenceKeypoint.new(0.5, C.red),
    ColorSequenceKeypoint.new(1, C.cyan),
}, 25)

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.505)
shadow.Size = UDim2.fromScale(0.955, 0.895)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.22
shadow.BorderSizePixel = 0
shadow.ZIndex = 1
shadow.Parent = gui
corner(shadow, 22)

local window = Instance.new("Frame")
window.Name = "DKHUB"
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.Position = UDim2.fromScale(0.5, 0.5)
window.Size = UDim2.fromScale(0.94, 0.88)
window.BackgroundColor3 = C.panel
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.ZIndex = 2
window.Parent = gui
corner(window, 20)

local windowGradient = addGradient(window, "WindowGradient", {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 14, 34)),
    ColorSequenceKeypoint.new(0.45, C.panel),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 18, 30)),
}, 125)
local frameStroke = addStroke(window, C.red, 2, 0.02)
local borderGradient = addGradient(frameStroke, "WhiteShine", {
    ColorSequenceKeypoint.new(0, C.red),
    ColorSequenceKeypoint.new(0.42, C.red),
    ColorSequenceKeypoint.new(0.50, C.white),
    ColorSequenceKeypoint.new(0.58, C.pink),
    ColorSequenceKeypoint.new(1, C.purple),
}, 0)

-- Top-most border mask: keeps dark child backgrounds from covering the red edge.
local borderMask = Instance.new("Frame")
borderMask.Name = "BorderMask"
borderMask.AnchorPoint = Vector2.new(0.5, 0.5)
borderMask.Position = window.Position
borderMask.Size = window.Size
borderMask.BackgroundTransparency = 1
borderMask.BorderSizePixel = 0
borderMask.Active = false
borderMask.ZIndex = 50
borderMask.Parent = gui
corner(borderMask, 20)
local maskStroke = addStroke(borderMask, C.red, 3, 0)
local maskGradient = addGradient(maskStroke, "MaskShine", {
    ColorSequenceKeypoint.new(0, C.red),
    ColorSequenceKeypoint.new(0.45, C.pink),
    ColorSequenceKeypoint.new(0.50, C.white),
    ColorSequenceKeypoint.new(0.58, C.purple),
    ColorSequenceKeypoint.new(1, C.red),
}, 0)

local effects = {
    gradient = true,
    border = true,
    particles = true,
    pulse = true,
    glow = true,
}

-- Premium animations.
task.spawn(function()
    while gui.Parent do
        if effects.gradient then
            tw(windowGradient, 4, {Offset = Vector2.new(0.35, 0)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
            tw(windowGradient, 4, {Offset = Vector2.new(-0.35, 0)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
        else task.wait(0.4) end
    end
end)

task.spawn(function()
    while gui.Parent do
        if effects.border then
            borderGradient.Offset = Vector2.new(-1, 0)
            tw(borderGradient, 1.5, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear).Completed:Wait()
            task.wait(0.45)
        else task.wait(0.4) end
    end
end)

task.spawn(function()
    while gui.Parent do
        if effects.glow then
            tw(aura, 2.4, {BackgroundTransparency = 0.95, Size = UDim2.fromScale(0.985, 0.925)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
            tw(aura, 2.4, {BackgroundTransparency = 0.89, Size = UDim2.fromScale(0.97, 0.91)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
        else task.wait(0.4) end
    end
end)

local particles = {}
for i = 1, 14 do
    local dot = Instance.new("Frame")
    dot.Name = "TestParticle" .. i
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.fromScale(0.08 + ((i * 0.071) % 0.84), 0.15 + ((i * 0.117) % 0.72))
    dot.Size = UDim2.fromOffset(2 + i % 3, 2 + i % 3)
    dot.BackgroundColor3 = i % 2 == 0 and C.pink or C.cyan
    dot.BackgroundTransparency = 0.32
    dot.BorderSizePixel = 0
    dot.ZIndex = 4
    dot.Parent = window
    corner(dot, 9)
    table.insert(particles, dot)
    task.spawn(function()
        while gui.Parent do
            if effects.particles then
                tw(dot, 1.2 + i * 0.04, {BackgroundTransparency = 0.88, Size = UDim2.fromOffset(6, 6)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
                tw(dot, 1.2 + i * 0.04, {BackgroundTransparency = 0.32, Size = UDim2.fromOffset(2 + i % 3, 2 + i % 3)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
            else task.wait(0.4) end
        end
    end)
end

-- Header.
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 62)
header.BackgroundColor3 = C.black
header.BackgroundTransparency = 0.03
header.BorderSizePixel = 0
header.ZIndex = 6
header.Parent = window
addGradient(header, "HeaderGradient", {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 8, 31)),
    ColorSequenceKeypoint.new(0.5, C.black),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 16, 32)),
}, 0)

local title = text(header, "Title", "DKHUB", UDim2.fromOffset(22, 7), UDim2.new(0.55, 0, 0, 29), Enum.Font.GothamBlack, 26, C.white)
local titleGradient = addGradient(title, "TitleShine", {
    ColorSequenceKeypoint.new(0, C.white),
    ColorSequenceKeypoint.new(0.45, C.pink),
    ColorSequenceKeypoint.new(0.70, C.purple),
    ColorSequenceKeypoint.new(1, C.white),
}, 0)
task.spawn(function()
    while gui.Parent do
        titleGradient.Offset = Vector2.new(-1, 0)
        tw(titleGradient, 2.2, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear).Completed:Wait()
        task.wait(0.55)
    end
end)
text(header, "Subtitle", "MOBILE TEST INTERFACE", UDim2.fromOffset(24, 37), UDim2.new(0.65, 0, 0, 14), Enum.Font.GothamMedium, 10, C.muted)

local function headerButton(name, value, x)
    local b = Instance.new("TextButton")
    b.Name = name
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, x, 0.5, 0)
    b.Size = UDim2.fromOffset(40, 38)
    b.BackgroundColor3 = C.panel2
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.Text = value
    b.TextColor3 = C.white
    b.TextSize = 19
    b.ZIndex = 9
    b.Parent = header
    corner(b, 10)
    local s = addStroke(b, C.red, 1, 0.45)
    b.MouseEnter:Connect(function() tw(b, 0.15, {BackgroundColor3 = C.redBright}); tw(s, 0.15, {Transparency = 0}) end)
    b.MouseLeave:Connect(function() tw(b, 0.15, {BackgroundColor3 = C.panel2}); tw(s, 0.15, {Transparency = 0.45}) end)
    return b
end

local closeButton = headerButton("Close", "×", -12)
local minimizeButton = headerButton("Minimize", "□", -61)
local headerLine = Instance.new("Frame")
headerLine.Name = "HeaderLine"
headerLine.Position = UDim2.new(0, 20, 1, -1)
headerLine.Size = UDim2.new(1, -40, 0, 1)
headerLine.BackgroundColor3 = C.red
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 10
headerLine.Parent = header
addGradient(headerLine, "LineShine", {
    ColorSequenceKeypoint.new(0, C.red),
    ColorSequenceKeypoint.new(0.5, C.white),
    ColorSequenceKeypoint.new(1, C.purple),
}, 0)

-- Blank content with TEST showcase.
local content = Instance.new("Frame")
content.Name = "TestContent"
content.Position = UDim2.fromOffset(0, 62)
content.Size = UDim2.new(1, 0, 1, -62)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ZIndex = 5
content.Parent = window

local test = text(content, "TestText", "TEST", UDim2.fromScale(0.08, 0.16), UDim2.fromScale(0.84, 0.17), Enum.Font.GothamBlack, 28, C.white)
test.TextXAlignment = Enum.TextXAlignment.Center
local testGradient = addGradient(test, "TestGradient", {
    ColorSequenceKeypoint.new(0, C.white),
    ColorSequenceKeypoint.new(0.35, C.pink),
    ColorSequenceKeypoint.new(0.65, C.purple),
    ColorSequenceKeypoint.new(1, C.white),
}, 0)
task.spawn(function()
    while gui.Parent do
        if effects.gradient then
            testGradient.Offset = Vector2.new(-1, 0)
            tw(testGradient, 1.9, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear).Completed:Wait()
            task.wait(0.5)
        else task.wait(0.4) end
    end
end)

local pulseOrb = Instance.new("Frame")
pulseOrb.Name = "PulseOrb"
pulseOrb.AnchorPoint = Vector2.new(0.5, 0.5)
pulseOrb.Position = UDim2.fromScale(0.5, 0.49)
pulseOrb.Size = UDim2.fromOffset(10, 10)
pulseOrb.BackgroundColor3 = C.white
pulseOrb.BorderSizePixel = 0
pulseOrb.ZIndex = 7
pulseOrb.Parent = content
corner(pulseOrb, 10)
local pulseStroke = addStroke(pulseOrb, C.pink, 2, 0)

task.spawn(function()
    while gui.Parent do
        if effects.pulse then
            tw(pulseOrb, 1.3, {Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 0.25}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
            tw(pulseOrb, 1.3, {Size = UDim2.fromOffset(10, 10), BackgroundTransparency = 0}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
        else task.wait(0.4) end
    end
end)

local underline = Instance.new("Frame")
underline.Name = "TestUnderline"
underline.AnchorPoint = Vector2.new(0.5, 0)
underline.Position = UDim2.fromScale(0.5, 0.36)
underline.Size = UDim2.fromScale(0.20, 0.008)
underline.BackgroundColor3 = C.red
underline.BorderSizePixel = 0
underline.ZIndex = 7
underline.Parent = content
corner(underline, 10)
addGradient(underline, "UnderlineGradient", {
    ColorSequenceKeypoint.new(0, C.red),
    ColorSequenceKeypoint.new(0.5, C.white),
    ColorSequenceKeypoint.new(1, C.purple),
}, 0)

local switchLabel = text(content, "SwitchTitle", "VISUAL TEST SWITCHES", UDim2.fromScale(0.08, 0.55), UDim2.fromScale(0.84, 0.07), Enum.Font.GothamBold, 11, C.redBright)
switchLabel.TextXAlignment = Enum.TextXAlignment.Center

local function makeSwitch(name, labelText, y, default, effectName)
    local row = Instance.new("Frame")
    row.Name = name .. "Row"
    row.Position = UDim2.fromScale(0.08, y)
    row.Size = UDim2.fromScale(0.84, 0.095)
    row.BackgroundColor3 = C.panel2
    row.BackgroundTransparency = 0.16
    row.BorderSizePixel = 0
    row.ZIndex = 7
    row.Parent = content
    corner(row, 9)
    text(row, "Label", labelText, UDim2.fromScale(0.05, 0.18), UDim2.fromScale(0.66, 0.64), Enum.Font.GothamSemibold, 12, C.text)
    local button = Instance.new("TextButton")
    button.Name = "Switch"
    button.Position = UDim2.fromScale(0.79, 0.23)
    button.Size = UDim2.fromScale(0.15, 0.54)
    button.BackgroundColor3 = default and C.red or C.black
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.Text = ""
    button.ZIndex = 9
    button.Parent = row
    corner(button, 20)
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.fromScale(0.38, 0.72)
    knob.Position = default and UDim2.fromScale(0.57, 0.14) or UDim2.fromScale(0.05, 0.14)
    knob.BackgroundColor3 = C.white
    knob.BorderSizePixel = 0
    knob.ZIndex = 10
    knob.Parent = button
    corner(knob, 20)
    local enabled = default
    local function render(value)
        enabled = value
        tw(button, 0.20, {BackgroundColor3 = enabled and C.red or C.black})
        tw(knob, 0.20, {Position = enabled and UDim2.fromScale(0.57, 0.14) or UDim2.fromScale(0.05, 0.14)})
        effects[effectName] = enabled
    end
    button.MouseButton1Click:Connect(function() render(not enabled) end)
    return render
end

makeSwitch("Gradient", "Gradient Color", 0.64, true, "gradient")
makeSwitch("Border", "Border Shine", 0.745, true, "border")
makeSwitch("Particles", "Light Particles", 0.85, true, "particles")

-- Minimize icon.
local icon = Instance.new("TextButton")
icon.Name = "DKHUB_Icon"
icon.AnchorPoint = Vector2.new(0.5, 0.5)
icon.Position = UDim2.fromScale(0.87, 0.84)
icon.Size = UDim2.fromOffset(66, 66)
icon.BackgroundColor3 = C.black
icon.AutoButtonColor = false
icon.BorderSizePixel = 0
icon.Font = Enum.Font.GothamBlack
icon.Text = "DK"
icon.TextColor3 = C.white
icon.TextSize = 19
icon.Visible = false
icon.ZIndex = 30
icon.Parent = gui
corner(icon, 33)
local iconStroke = addStroke(icon, C.pink, 2, 0)
addGradient(iconStroke, "IconShine", {
    ColorSequenceKeypoint.new(0, C.red),
    ColorSequenceKeypoint.new(0.5, C.white),
    ColorSequenceKeypoint.new(1, C.purple),
}, 0)

local minimized = false
local closed = false
local iconDragging = false
local iconMoved = false
local iconDragStart
local iconStartPosition
minimizeButton.MouseButton1Click:Connect(function()
    minimized = true
    tw(window, 0.40, {Position = UDim2.fromScale(0.5, 1.30)}, Enum.EasingStyle.Back)
    tw(shadow, 0.40, {Position = UDim2.fromScale(0.5, 1.32)}, Enum.EasingStyle.Back)
    tw(aura, 0.40, {Position = UDim2.fromScale(0.5, 1.28)}, Enum.EasingStyle.Back)
    tw(borderMask, 0.40, {Position = UDim2.fromScale(0.5, 1.30)}, Enum.EasingStyle.Back)
    task.delay(0.24, function()
        if minimized and not closed then
            icon.Visible = true
            icon.Size = UDim2.fromOffset(8, 8)
            tw(icon, 0.35, {Size = UDim2.fromOffset(66, 66)}, Enum.EasingStyle.Back)
        end
    end)
end)
icon.MouseButton1Click:Connect(function()
    if iconMoved then
        iconMoved = false
        return
    end
    minimized = false
    icon.Visible = false
    tw(window, 0.42, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)
    tw(shadow, 0.42, {Position = UDim2.fromScale(0.5, 0.505)}, Enum.EasingStyle.Back)
    tw(aura, 0.42, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)
    tw(borderMask, 0.42, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)
end)
closeButton.MouseButton1Click:Connect(function()
    closed = true
    tw(window, 0.30, {Position = UDim2.fromScale(0.5, 1.35)}, Enum.EasingStyle.Back)
    tw(shadow, 0.30, {Position = UDim2.fromScale(0.5, 1.37)}, Enum.EasingStyle.Back)
    tw(borderMask, 0.30, {Position = UDim2.fromScale(0.5, 1.35)}, Enum.EasingStyle.Back)
    task.delay(0.34, function() if closed then gui:Destroy() end end)
end)

-- The minimized icon can be repositioned on touch or mouse.
icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = true
        iconMoved = false
        iconDragStart = input.Position
        iconStartPosition = icon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                iconDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - iconDragStart
        if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then
            iconMoved = true
        end
        icon.Position = UDim2.new(iconStartPosition.X.Scale, iconStartPosition.X.Offset + delta.X, iconStartPosition.Y.Scale, iconStartPosition.Y.Offset + delta.Y)
    end
end)

-- Drag support for mouse and touch.
local dragging = false
local dragStart
local startPosition
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = window.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        window.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + d.X, startPosition.Y.Scale, startPosition.Y.Offset + d.Y)
        shadow.Position = UDim2.new(window.Position.X.Scale, window.Position.X.Offset, window.Position.Y.Scale, window.Position.Y.Offset + 5)
        aura.Position = UDim2.new(window.Position.X.Scale, window.Position.X.Offset, window.Position.Y.Scale, window.Position.Y.Offset)
        borderMask.Position = window.Position
    end
end)
