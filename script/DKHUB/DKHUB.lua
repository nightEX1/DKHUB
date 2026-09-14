-- DKHUB // HORIZON DASHBOARD
-- A fresh visual-only UI concept: top navigation, editorial cards and calm neon accents.
-- TEST controls only change their visual state; no game automation is included.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("DKHUB_HORIZON")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DKHUB_HORIZON"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local C = {
    ink = Color3.fromRGB(8, 9, 13),
    surface = Color3.fromRGB(17, 18, 24),
    surface2 = Color3.fromRGB(25, 26, 34),
    border = Color3.fromRGB(52, 54, 67),
    red = Color3.fromRGB(239, 57, 78),
    coral = Color3.fromRGB(255, 105, 100),
    violet = Color3.fromRGB(143, 106, 255),
    cyan = Color3.fromRGB(89, 208, 224),
    white = Color3.fromRGB(247, 247, 250),
    text = Color3.fromRGB(220, 220, 230),
    muted = Color3.fromRGB(135, 137, 151),
    off = Color3.fromRGB(61, 63, 73),
    card = Color3.fromRGB(25, 26, 34),
}

local FONT = {
    display = Enum.Font.GothamBlack,
    heading = Enum.Font.GothamBold,
    control = Enum.Font.GothamSemibold,
    body = Enum.Font.Gotham,
    mono = Enum.Font.Code,
}

local function corner(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = o
end

local function stroke(o, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = o
    return s
end

local function tween(o, duration, props, style)
    local t = TweenService:Create(o, TweenInfo.new(duration, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function label(parent, name, value, position, size, font, textSize, color, align)
    local l = Instance.new("TextLabel")
    l.Name = name
    l.Text = value
    l.Position = position
    l.Size = size
    l.BackgroundTransparency = 1
    l.Font = font or FONT.body
    l.TextSize = textSize or 14
    l.TextColor3 = color or C.text
    l.TextXAlignment = align or Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.ZIndex = 10
    l.Parent = parent
    return l
end

local function gradient(parent, name, colors, rotation)
    local g = Instance.new("UIGradient")
    g.Name = name
    g.Color = ColorSequence.new(colors)
    g.Rotation = rotation or 0
    g.Parent = parent
    return g
end

-- Outer frame with a slim red light instead of a glowing neon box.
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.505)
shadow.Size = UDim2.fromScale(0.955, 0.895)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.25
shadow.BorderSizePixel = 0
shadow.ZIndex = 1
shadow.Parent = gui
corner(shadow, 18)

local aura = shadow

local window = Instance.new("Frame")
window.Name = "DKHUB"
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.Position = UDim2.fromScale(0.5, 0.5)
window.Size = UDim2.fromScale(0.94, 0.88)
window.BackgroundColor3 = C.surface
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.ZIndex = 2
window.Parent = gui
corner(window, 16)
local windowBorder = stroke(window, C.border, 1, 0.05)
local edgeMask = Instance.new("Frame")
edgeMask.Name = "EdgeMask"
edgeMask.AnchorPoint = Vector2.new(0.5, 0.5)
edgeMask.Position = window.Position
edgeMask.Size = window.Size
edgeMask.BackgroundTransparency = 1
edgeMask.BorderSizePixel = 0
edgeMask.Active = false
edgeMask.ZIndex = 60
edgeMask.Parent = gui
corner(edgeMask, 16)
local edgeMaskStroke = stroke(edgeMask, C.border, 2, 0)

local leftAccent = Instance.new("Frame")
leftAccent.Name = "LeftAccent"
leftAccent.Position = UDim2.fromScale(0.012, 0.05)
leftAccent.Size = UDim2.fromScale(0.004, 0.90)
leftAccent.BackgroundColor3 = C.red
leftAccent.BorderSizePixel = 0
leftAccent.ZIndex = 9
leftAccent.Parent = window
corner(leftAccent, 6)
local accentGradient = gradient(leftAccent, "AccentGradient", {
    ColorSequenceKeypoint.new(0, C.red),
    ColorSequenceKeypoint.new(0.5, C.coral),
    ColorSequenceKeypoint.new(1, C.violet),
}, 90)
task.spawn(function()
    while gui.Parent do
        tween(accentGradient, 2.2, {Offset = Vector2.new(0, 0.8)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
        tween(accentGradient, 2.2, {Offset = Vector2.new(0, -0.8)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
    end
end)

-- Header with top navigation.
local header = Instance.new("Frame")
header.Name = "TopBar"
header.Size = UDim2.new(1, 0, 0, 64)
header.BackgroundColor3 = C.ink
header.BorderSizePixel = 0
header.ZIndex = 5
header.Parent = window
label(header, "Brand", "DKHUB", UDim2.fromOffset(24, 7), UDim2.new(0.25, 0, 0, 27), FONT.display, 23, C.white)
label(header, "BrandSub", "HORIZON / UI KIT", UDim2.fromOffset(25, 36), UDim2.new(0.30, 0, 0, 13), FONT.mono, 8, C.muted)

local nav = Instance.new("Frame")
nav.Name = "TopNavigation"
nav.AnchorPoint = Vector2.new(0.5, 0.5)
nav.Position = UDim2.new(0.52, 0, 0.5, 0)
nav.Size = UDim2.fromScale(0.42, 0.60)
nav.BackgroundColor3 = C.surface2
nav.BorderSizePixel = 0
nav.ZIndex = 7
nav.Parent = header
corner(nav, 9)
stroke(nav, C.border, 1, 0.2)

local pages = {}
local tabs = {}
local function createPage(name)
    local p = Instance.new("Frame")
    p.Name = name .. "Page"
    p.Position = UDim2.fromOffset(0, 64)
    p.Size = UDim2.new(1, 0, 1, -64)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ZIndex = 4
    p.Parent = window
    pages[name] = p
    return p
end
local home = createPage("Home")
local chain = createPage("Chain")
local settings = createPage("Settings")

local function createTab(name, caption, x)
    local b = Instance.new("TextButton")
    b.Name = name .. "Tab"
    b.Position = UDim2.fromScale(x, 0.12)
    b.Size = UDim2.fromScale(0.30, 0.76)
    b.BackgroundColor3 = C.surface2
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Font = FONT.control
    b.Text = caption
    b.TextSize = 10
    b.TextColor3 = C.muted
    b.ZIndex = 9
    b.Parent = nav
    corner(b, 7)
    local marker = Instance.new("Frame")
    marker.Name = "ActiveMarker"
    marker.AnchorPoint = Vector2.new(0.5, 1)
    marker.Position = UDim2.fromScale(0.5, 1)
    marker.Size = UDim2.fromScale(0.40, 0.06)
    marker.BackgroundColor3 = C.red
    marker.BackgroundTransparency = 1
    marker.BorderSizePixel = 0
    marker.ZIndex = 10
    marker.Parent = b
    corner(marker, 5)
    tabs[name] = {button = b, marker = marker}
    return b
end
local homeTab = createTab("Home", "HOME", 0.03)
local chainTab = createTab("Chain", "CHAIN", 0.35)
local settingsTab = createTab("Settings", "SETTINGS", 0.67)

local close = Instance.new("TextButton")
close.Name = "Close"
close.AnchorPoint = Vector2.new(1, 0.5)
close.Position = UDim2.new(1, -14, 0.5, 0)
close.Size = UDim2.fromOffset(34, 32)
close.BackgroundColor3 = C.surface2
close.AutoButtonColor = false
close.BorderSizePixel = 0
close.Font = FONT.heading
close.Text = "×"
close.TextSize = 17
close.TextColor3 = C.white
close.ZIndex = 9
close.Parent = header
corner(close, 8)
local minimize = close:Clone()
minimize.Name = "Minimize"
minimize.Position = UDim2.new(1, -54, 0.5, 0)
minimize.Text = "−"
minimize.Parent = header
for _, b in ipairs({close, minimize}) do
    b.MouseEnter:Connect(function() tween(b, 0.15, {BackgroundColor3 = C.red}) end)
    b.MouseLeave:Connect(function() tween(b, 0.15, {BackgroundColor3 = C.surface2}) end)
end

local function activate(name)
    for n, data in pairs(tabs) do
        local on = n == name
        tween(data.button, 0.18, {BackgroundColor3 = on and C.red or C.surface2, TextColor3 = on and C.white or C.muted})
        tween(data.marker, 0.18, {BackgroundTransparency = on and 0 or 1})
    end
    for n, page in pairs(pages) do page.Visible = n == name end
end

local function pageHeading(parent, kicker, titleValue, description)
    label(parent, "Kicker", kicker, UDim2.fromScale(0.07, 0.07), UDim2.fromScale(0.86, 0.05), FONT.mono, 9, C.red)
    label(parent, "Title", titleValue, UDim2.fromScale(0.07, 0.13), UDim2.fromScale(0.86, 0.11), FONT.display, 24, C.white)
    label(parent, "Description", description, UDim2.fromScale(0.07, 0.24), UDim2.fromScale(0.86, 0.06), FONT.body, 10, C.muted)
end

local function makeCard(parent, name, position, size, edgeColor)
    local card = Instance.new("Frame")
    card.Name = name
    card.Position = position
    card.Size = size
    card.BackgroundColor3 = C.card
    card.BorderSizePixel = 0
    card.ZIndex = 8
    card.Parent = parent
    corner(card, 10)
    local edge = stroke(card, edgeColor or C.border, 1, 0.22)
    card.MouseEnter:Connect(function()
        tween(card, 0.16, {BackgroundColor3 = Color3.fromRGB(30, 31, 42)})
        tween(edge, 0.16, {Transparency = 0})
    end)
    card.MouseLeave:Connect(function()
        tween(card, 0.16, {BackgroundColor3 = C.card})
        tween(edge, 0.16, {Transparency = 0.22})
    end)
    return card
end

local function makeSwitch(parent, name, caption, pos, default)
    local row = makeCard(parent, name, pos, UDim2.fromScale(0.41, 0.15), C.border)
    label(row, "Caption", caption, UDim2.fromScale(0.08, 0.16), UDim2.fromScale(0.66, 0.28), FONT.control, 10, C.text)
    label(row, "Hint", "TEST / VISUAL ONLY", UDim2.fromScale(0.08, 0.52), UDim2.fromScale(0.66, 0.22), FONT.mono, 8, C.muted)
    local toggle = Instance.new("TextButton")
    toggle.Name = "Switch"
    toggle.Position = UDim2.fromScale(0.78, 0.30)
    toggle.Size = UDim2.fromScale(0.15, 0.40)
    toggle.BackgroundColor3 = default and C.red or C.off
    toggle.AutoButtonColor = false
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.ZIndex = 13
    toggle.Parent = row
    corner(toggle, 18)
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.fromScale(0.40, 0.72)
    knob.Position = default and UDim2.fromScale(0.55, 0.14) or UDim2.fromScale(0.05, 0.14)
    knob.BackgroundColor3 = C.white
    knob.BorderSizePixel = 0
    knob.BorderSizePixel = 0
    knob.ZIndex = 14
    knob.Parent = toggle
    corner(knob, 20)
    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        tween(toggle, 0.18, {BackgroundColor3 = state and C.red or C.off})
        tween(knob, 0.18, {Position = state and UDim2.fromScale(0.55, 0.14) or UDim2.fromScale(0.05, 0.14)})
        -- Intentionally visual-only.
    end)
end

-- Home page: two-column editorial dashboard.
pageHeading(home, "01 / OVERVIEW", "A QUIET PLACE TO BUILD.", "A clean, reusable interface framework for your future modules.")
local welcome = makeCard(home, "WelcomeCard", UDim2.fromScale(0.07, 0.35), UDim2.fromScale(0.54, 0.27), C.red)
label(welcome, "Eyebrow", "DKHUB / HORIZON", UDim2.fromScale(0.07, 0.14), UDim2.fromScale(0.82, 0.16), FONT.mono, 9, C.coral)
label(welcome, "Headline", "YOUR SPACE.\nYOUR CONTROL.", UDim2.fromScale(0.07, 0.29), UDim2.fromScale(0.82, 0.45), FONT.display, 17, C.white)
label(welcome, "Footnote", "Visual-only framework", UDim2.fromScale(0.07, 0.79), UDim2.fromScale(0.82, 0.12), FONT.body, 9, C.muted)
local ready = makeCard(home, "ReadyCard", UDim2.fromScale(0.64, 0.35), UDim2.fromScale(0.29, 0.27), C.violet)
label(ready, "Kicker", "STATUS", UDim2.fromScale(0.10, 0.16), UDim2.fromScale(0.80, 0.15), FONT.mono, 8, C.muted)
label(ready, "Value", "READY", UDim2.fromScale(0.10, 0.32), UDim2.fromScale(0.80, 0.28), FONT.heading, 17, C.cyan)
label(ready, "Hint", "No active modules", UDim2.fromScale(0.10, 0.70), UDim2.fromScale(0.80, 0.14), FONT.body, 9, C.muted)
label(home, "SwitchHeading", "VISUAL TESTS", UDim2.fromScale(0.07, 0.69), UDim2.fromScale(0.86, 0.05), FONT.mono, 9, C.red)
makeSwitch(home, "GlowTest", "GLOW", UDim2.fromScale(0.07, 0.76), true)
makeSwitch(home, "MotionTest", "MOTION", UDim2.fromScale(0.52, 0.76), true)

-- Chain page: simple empty state with module cards.
pageHeading(chain, "02 / MODULES", "NOTHING CONNECTED YET.", "A modular area prepared for future visual components.")
local empty = makeCard(chain, "EmptyState", UDim2.fromScale(0.07, 0.35), UDim2.fromScale(0.86, 0.23), C.violet)
label(empty, "Mark", "⛓", UDim2.fromScale(0.06, 0.18), UDim2.fromScale(0.16, 0.52), FONT.heading, 25, C.violet, Enum.TextXAlignment.Center)
label(empty, "Title", "EMPTY MODULE SPACE", UDim2.fromScale(0.25, 0.20), UDim2.fromScale(0.68, 0.23), FONT.heading, 13, C.text)
label(empty, "Desc", "Add your own visual modules here later.", UDim2.fromScale(0.25, 0.53), UDim2.fromScale(0.68, 0.20), FONT.body, 9, C.muted)
for i = 1, 3 do
    local slot = makeCard(chain, "Slot" .. i, UDim2.fromScale(0.07 + (i - 1) * 0.30, 0.67), UDim2.fromScale(0.26, 0.16), i == 1 and C.red or (i == 2 and C.violet or C.cyan))
    label(slot, "Number", "0" .. i, UDim2.fromScale(0.10, 0.16), UDim2.fromScale(0.80, 0.25), FONT.mono, 9, C.muted, Enum.TextXAlignment.Center)
    label(slot, "Empty", "EMPTY", UDim2.fromScale(0.08, 0.47), UDim2.fromScale(0.84, 0.24), FONT.control, 10, C.text, Enum.TextXAlignment.Center)
end

-- Settings page: balanced controls and visual-only state.
pageHeading(settings, "03 / PREFERENCES", "MAKE IT YOURS.", "Every control below is a visual demonstration and does not run game actions.")
local settingsInfo = makeCard(settings, "SettingsInfo", UDim2.fromScale(0.07, 0.35), UDim2.fromScale(0.86, 0.17), C.cyan)
label(settingsInfo, "Label", "VISUAL ENGINE", UDim2.fromScale(0.06, 0.20), UDim2.fromScale(0.42, 0.22), FONT.heading, 12, C.text)
label(settingsInfo, "Text", "Use the switches to preview states.", UDim2.fromScale(0.06, 0.55), UDim2.fromScale(0.84, 0.18), FONT.body, 9, C.muted)
label(settings, "SettingsHeading", "PREVIEW CONTROLS", UDim2.fromScale(0.07, 0.61), UDim2.fromScale(0.86, 0.05), FONT.mono, 9, C.red)
makeSwitch(settings, "BorderTest", "BORDER", UDim2.fromScale(0.07, 0.69), true)
makeSwitch(settings, "GlowTest", "GLOW", UDim2.fromScale(0.52, 0.69), false)
makeSwitch(settings, "ParticleTest", "PARTICLES", UDim2.fromScale(0.07, 0.86), true)
makeSwitch(settings, "CompactTest", "COMPACT", UDim2.fromScale(0.52, 0.86), false)

homeTab.MouseButton1Click:Connect(function() activate("Home") end)
chainTab.MouseButton1Click:Connect(function() activate("Chain") end)
settingsTab.MouseButton1Click:Connect(function() activate("Settings") end)
activate("Home")

-- Minimize / restore icon.
local icon = Instance.new("TextButton")
icon.Name = "DKHUB_Icon"
icon.AnchorPoint = Vector2.new(0.5, 0.5)
icon.Position = UDim2.fromScale(0.86, 0.84)
icon.Size = UDim2.fromOffset(64, 64)
icon.BackgroundColor3 = C.ink
icon.AutoButtonColor = false
icon.BorderSizePixel = 0
icon.Font = FONT.display
icon.Text = "DK"
icon.TextColor3 = C.white
icon.TextSize = 18
icon.Visible = false
icon.ZIndex = 40
icon.Parent = gui
corner(icon, 14)
stroke(icon, C.red, 2, 0)
local iconTop = Instance.new("Frame")
iconTop.Name = "IconTop"
iconTop.Position = UDim2.fromScale(0.16, 0.16)
iconTop.Size = UDim2.fromScale(0.68, 0.035)
iconTop.BackgroundColor3 = C.coral
iconTop.BorderSizePixel = 0
iconTop.ZIndex = 41
iconTop.Parent = icon
corner(iconTop, 4)

local minimized = false
local closed = false
local iconDragging = false
local iconMoved = false
local iconStart
local iconOrigin
minimize.MouseButton1Click:Connect(function()
    minimized = true
    tween(window, 0.28, {Position = UDim2.fromScale(0.5, 1.30)}, Enum.EasingStyle.Back)
    tween(shadow, 0.28, {Position = UDim2.fromScale(0.5, 1.32)}, Enum.EasingStyle.Back)
    tween(aura, 0.28, {Position = UDim2.fromScale(0.5, 1.29)}, Enum.EasingStyle.Back)
    tween(edgeMask, 0.28, {Position = UDim2.fromScale(0.5, 1.30)}, Enum.EasingStyle.Back)
    task.delay(0.20, function()
        if minimized and not closed then
            window.Visible = false
            shadow.Visible = false
            aura.Visible = false
            edgeMask.Visible = false
            icon.Visible = true
            icon.Size = UDim2.fromOffset(8, 8)
            tween(icon, 0.30, {Size = UDim2.fromOffset(64, 64)}, Enum.EasingStyle.Back)
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
    window.Visible = true
    shadow.Visible = true
    aura.Visible = true
    edgeMask.Visible = true
    window.Position = UDim2.fromScale(0.5, 1.30)
    shadow.Position = UDim2.fromScale(0.5, 1.32)
    aura.Position = UDim2.fromScale(0.5, 1.29)
    edgeMask.Position = UDim2.fromScale(0.5, 1.30)
    tween(window, 0.36, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)
    tween(shadow, 0.36, {Position = UDim2.fromScale(0.5, 0.505)}, Enum.EasingStyle.Back)
    tween(aura, 0.36, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)
    tween(edgeMask, 0.36, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)
end)
close.MouseButton1Click:Connect(function()
    closed = true
    tween(window, 0.25, {Position = UDim2.fromScale(0.5, 1.35)}, Enum.EasingStyle.Back)
    tween(shadow, 0.25, {Position = UDim2.fromScale(0.5, 1.37)}, Enum.EasingStyle.Back)
    tween(edgeMask, 0.25, {Position = UDim2.fromScale(0.5, 1.35)}, Enum.EasingStyle.Back)
    task.delay(0.30, function() if closed then gui:Destroy() end end)
end)

icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = true
        iconMoved = false
        iconStart = input.Position
        iconOrigin = icon.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then iconDragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - iconStart
        if math.abs(d.X) > 4 or math.abs(d.Y) > 4 then iconMoved = true end
        local camera = workspace.CurrentCamera
        if camera then
            local v = camera.ViewportSize
            local x = math.clamp(iconOrigin.X.Scale * v.X + iconOrigin.X.Offset + d.X, 34, v.X - 34)
            local y = math.clamp(iconOrigin.Y.Scale * v.Y + iconOrigin.Y.Offset + d.Y, 34, v.Y - 34)
            icon.Position = UDim2.fromOffset(x, y)
        end
    end
end)

-- Drag the new top bar.
local dragging = false
local dragStart
local windowOrigin
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        windowOrigin = window.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        window.Position = UDim2.new(windowOrigin.X.Scale, windowOrigin.X.Offset + d.X, windowOrigin.Y.Scale, windowOrigin.Y.Offset + d.Y)
        shadow.Position = UDim2.new(window.Position.X.Scale, window.Position.X.Offset, window.Position.Y.Scale, window.Position.Y.Offset + 5)
        aura.Position = UDim2.new(window.Position.X.Scale, window.Position.X.Offset, window.Position.Y.Scale, window.Position.Y.Offset)
        edgeMask.Position = window.Position
    end
end)
