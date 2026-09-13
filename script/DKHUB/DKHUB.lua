-- DKHUB CYBERPUNK NEON UI
-- Visual-only interface. TEST switches change appearance only and do not run game actions.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("DKHUB_CYBERPUNK")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DKHUB_CYBERPUNK"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local C = {
    black = Color3.fromRGB(3, 5, 12),
    deep = Color3.fromRGB(7, 9, 19),
    panel = Color3.fromRGB(10, 13, 27),
    card = Color3.fromRGB(13, 17, 35),
    red = Color3.fromRGB(255, 25, 94),
    magenta = Color3.fromRGB(255, 50, 180),
    purple = Color3.fromRGB(122, 61, 255),
    blue = Color3.fromRGB(25, 174, 255),
    cyan = Color3.fromRGB(29, 235, 255),
    white = Color3.fromRGB(242, 247, 255),
    text = Color3.fromRGB(205, 216, 245),
    muted = Color3.fromRGB(105, 124, 170),
    off = Color3.fromRGB(25, 35, 63),
}

local function round(o, r)
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

local function tween(o, duration, props, style, direction)
    local t = TweenService:Create(o, TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function makeText(parent, name, value, position, size, font, textSize, color, align)
    local l = Instance.new("TextLabel")
    l.Name = name
    l.Text = value
    l.Position = position
    l.Size = size
    l.BackgroundTransparency = 1
    l.Font = font or Enum.Font.Gotham
    l.TextSize = textSize or 14
    l.TextColor3 = color or C.text
    l.TextXAlignment = align or Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.ZIndex = 10
    l.Parent = parent
    return l
end

local function makeGradient(parent, name, points, rotation)
    local g = Instance.new("UIGradient")
    g.Name = name
    g.Color = ColorSequence.new(points)
    g.Rotation = rotation or 0
    g.Parent = parent
    return g
end

-- Large mobile panel with a narrow margin.
local aura = Instance.new("Frame")
aura.Name = "NeonAura"
aura.AnchorPoint = Vector2.new(0.5, 0.5)
aura.Position = UDim2.fromScale(0.5, 0.5)
aura.Size = UDim2.fromScale(0.97, 0.91)
aura.BackgroundColor3 = C.magenta
aura.BackgroundTransparency = 0.93
aura.BorderSizePixel = 0
aura.ZIndex = 0
aura.Parent = gui
round(aura, 18)
makeGradient(aura, "AuraGradient", {
    ColorSequenceKeypoint.new(0, C.red),
    ColorSequenceKeypoint.new(0.45, C.purple),
    ColorSequenceKeypoint.new(1, C.blue),
}, 20)

task.spawn(function()
    while gui.Parent do
        tween(aura, 2.5, {BackgroundTransparency = 0.97, Size = UDim2.fromScale(0.985, 0.925)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
        tween(aura, 2.5, {BackgroundTransparency = 0.91, Size = UDim2.fromScale(0.97, 0.91)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
    end
end)

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.505)
shadow.Size = UDim2.fromScale(0.955, 0.895)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.15
shadow.BorderSizePixel = 0
shadow.ZIndex = 1
shadow.Parent = gui
round(shadow, 16)

local window = Instance.new("Frame")
window.Name = "DKHUB"
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.Position = UDim2.fromScale(0.5, 0.5)
window.Size = UDim2.fromScale(0.94, 0.88)
window.BackgroundColor3 = C.deep
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.ZIndex = 2
window.Parent = gui
round(window, 14)
local windowStroke = stroke(window, C.magenta, 2, 0)
local edgeGradient = makeGradient(windowStroke, "EdgeFlow", {
    ColorSequenceKeypoint.new(0, C.red),
    ColorSequenceKeypoint.new(0.25, C.magenta),
    ColorSequenceKeypoint.new(0.50, C.blue),
    ColorSequenceKeypoint.new(0.75, C.purple),
    ColorSequenceKeypoint.new(1, C.red),
}, 0)

task.spawn(function()
    while gui.Parent do
        edgeGradient.Offset = Vector2.new(-1, 0)
        tween(edgeGradient, 1.35, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear).Completed:Wait()
        task.wait(0.35)
    end
end)

-- Header.
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 54)
header.BackgroundColor3 = C.black
header.BorderSizePixel = 0
header.ZIndex = 5
header.Parent = window
local topLine = Instance.new("Frame")
topLine.Name = "TopNeonLine"
topLine.Position = UDim2.fromScale(0.03, 1)
topLine.Size = UDim2.fromScale(0.94, 0.012)
topLine.BackgroundColor3 = C.magenta
topLine.BorderSizePixel = 0
topLine.ZIndex = 12
topLine.Parent = header
makeGradient(topLine, "TopLineGradient", {
    ColorSequenceKeypoint.new(0, C.blue),
    ColorSequenceKeypoint.new(0.5, C.magenta),
    ColorSequenceKeypoint.new(1, C.red),
}, 0)

local logo = makeText(header, "Logo", "DKHUB", UDim2.fromOffset(20, 4), UDim2.new(0.55, 0, 0, 29), Enum.Font.GothamBlack, 23, C.white)
local logoGradient = makeGradient(logo, "LogoGradient", {
    ColorSequenceKeypoint.new(0, C.magenta),
    ColorSequenceKeypoint.new(0.48, C.white),
    ColorSequenceKeypoint.new(1, C.blue),
}, 0)
task.spawn(function()
    while gui.Parent do
        logoGradient.Offset = Vector2.new(-1, 0)
        tween(logoGradient, 2, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear).Completed:Wait()
        task.wait(0.45)
    end
end)
makeText(header, "HeaderTag", "CYBERPUNK // TEST BUILD", UDim2.fromOffset(22, 31), UDim2.new(0.60, 0, 0, 12), Enum.Font.GothamMedium, 8, C.muted)

local function headerButton(name, symbol, x)
    local b = Instance.new("TextButton")
    b.Name = name
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, x, 0.5, 0)
    b.Size = UDim2.fromOffset(35, 33)
    b.BackgroundColor3 = C.panel
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.Text = symbol
    b.TextColor3 = C.white
    b.TextSize = 16
    b.ZIndex = 14
    b.Parent = header
    round(b, 7)
    local s = stroke(b, C.blue, 1, 0.35)
    b.MouseEnter:Connect(function() tween(b, 0.14, {BackgroundColor3 = C.red}); tween(s, 0.14, {Transparency = 0}) end)
    b.MouseLeave:Connect(function() tween(b, 0.14, {BackgroundColor3 = C.panel}); tween(s, 0.14, {Transparency = 0.35}) end)
    return b
end

local minimize = headerButton("Minimize", "□", -53)
local close = headerButton("Close", "×", -10)

-- Navigation rail.
local rail = Instance.new("Frame")
rail.Name = "NavigationRail"
rail.Position = UDim2.fromOffset(0, 54)
rail.Size = UDim2.new(0.18, 0, 1, -54)
rail.BackgroundColor3 = C.black
rail.BorderSizePixel = 0
rail.ZIndex = 6
rail.Parent = window
local railLine = Instance.new("Frame")
railLine.Name = "RailLine"
railLine.Position = UDim2.new(1, -1, 0, 12)
railLine.Size = UDim2.new(0, 1, 1, -24)
railLine.BackgroundColor3 = C.purple
railLine.BackgroundTransparency = 0.30
railLine.BorderSizePixel = 0
railLine.ZIndex = 12
railLine.Parent = rail

local main = Instance.new("Frame")
main.Name = "Main"
main.Position = UDim2.new(0.18, 0, 0, 54)
main.Size = UDim2.new(0.82, 0, 1, -54)
main.BackgroundTransparency = 1
main.BorderSizePixel = 0
main.ZIndex = 4
main.Parent = window

makeText(rail, "RailTitle", "NAV", UDim2.fromScale(0.22, 0.06), UDim2.fromScale(0.56, 0.06), Enum.Font.GothamBold, 9, C.blue, Enum.TextXAlignment.Center)
local tabs = {}
local pages = {}
local function page(name)
    local p = Instance.new("Frame")
    p.Name = name .. "Page"
    p.Size = UDim2.fromScale(1, 1)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ZIndex = 5
    p.Parent = main
    pages[name] = p
    return p
end
local home = page("Home")
local chain = page("Chain")
local settings = page("Settings")

local function navButton(name, symbol, caption, y)
    local b = Instance.new("TextButton")
    b.Name = name .. "Nav"
    b.Position = UDim2.fromScale(0.18, y)
    b.Size = UDim2.fromScale(0.64, 0.12)
    b.BackgroundColor3 = C.black
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Text = ""
    b.ZIndex = 13
    b.Parent = rail
    round(b, 8)
    local ico = makeText(b, "Icon", symbol, UDim2.fromScale(0.08, 0.08), UDim2.fromScale(0.84, 0.45), Enum.Font.GothamBold, 22, C.muted, Enum.TextXAlignment.Center)
    local cap = makeText(b, "Caption", caption, UDim2.fromScale(0.06, 0.51), UDim2.fromScale(0.88, 0.31), Enum.Font.GothamBold, 8, C.muted, Enum.TextXAlignment.Center)
    tabs[name] = {button = b, icon = ico, caption = cap}
    return b
end
local homeNav = navButton("Home", "⌂", "HOME", 0.16)
local chainNav = navButton("Chain", "⛓", "CHAIN", 0.32)
local settingsNav = navButton("Settings", "⚙", "SETTINGS", 0.48)
makeText(rail, "RailFooter", "v2.0", UDim2.fromScale(0.20, 0.91), UDim2.fromScale(0.60, 0.05), Enum.Font.GothamMedium, 8, C.muted, Enum.TextXAlignment.Center)

local function activate(name)
    for n, data in pairs(tabs) do
        local on = n == name
        tween(data.button, 0.16, {BackgroundColor3 = on and C.red or C.black})
        tween(data.icon, 0.16, {TextColor3 = on and C.white or C.muted})
        tween(data.caption, 0.16, {TextColor3 = on and C.white or C.muted})
    end
    for n, p in pairs(pages) do p.Visible = n == name end
end

local function pageTitle(parent, titleValue, subtitleValue)
    local h = makeText(parent, "PageTitle", titleValue, UDim2.fromScale(0.07, 0.07), UDim2.fromScale(0.86, 0.11), Enum.Font.GothamBlack, 25, C.white)
    local hGradient = makeGradient(h, "PageTitleGradient", {
        ColorSequenceKeypoint.new(0, C.white),
        ColorSequenceKeypoint.new(0.55, C.cyan),
        ColorSequenceKeypoint.new(1, C.magenta),
    }, 0)
    task.spawn(function()
        while gui.Parent do
            hGradient.Offset = Vector2.new(-1, 0)
            tween(hGradient, 2.4, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear).Completed:Wait()
            task.wait(0.6)
        end
    end)
    makeText(parent, "PageSubtitle", subtitleValue, UDim2.fromScale(0.08, 0.18), UDim2.fromScale(0.84, 0.07), Enum.Font.Gotham, 10, C.muted)
end

local function panel(parent, name, position, size)
    local p = Instance.new("Frame")
    p.Name = name
    p.Position = position
    p.Size = size
    p.BackgroundColor3 = C.card
    p.BackgroundTransparency = 0.10
    p.BorderSizePixel = 0
    p.ZIndex = 8
    p.Parent = parent
    round(p, 8)
    local s = stroke(p, C.blue, 1, 0.55)
    return p, s
end

local function testToggle(parent, name, caption, pos)
    local row = panel(parent, name, pos, UDim2.fromScale(0.88, 0.14))
    makeText(row, "Caption", caption, UDim2.fromScale(0.07, 0.18), UDim2.fromScale(0.62, 0.30), Enum.Font.GothamBold, 11, C.text)
    makeText(row, "Hint", "TEST / VISUAL ONLY", UDim2.fromScale(0.07, 0.54), UDim2.fromScale(0.62, 0.20), Enum.Font.GothamMedium, 8, C.muted)
    local button = Instance.new("TextButton")
    button.Name = "Switch"
    button.Position = UDim2.fromScale(0.78, 0.28)
    button.Size = UDim2.fromScale(0.16, 0.44)
    button.BackgroundColor3 = C.red
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.Text = ""
    button.ZIndex = 15
    button.Parent = row
    round(button, 20)
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.fromScale(0.40, 0.72)
    knob.Position = UDim2.fromScale(0.55, 0.14)
    knob.BackgroundColor3 = C.white
    knob.BorderSizePixel = 0
    knob.ZIndex = 16
    knob.Parent = button
    round(knob, 20)
    local state = true
    button.MouseButton1Click:Connect(function()
        state = not state
        tween(button, 0.18, {BackgroundColor3 = state and C.red or C.off})
        tween(knob, 0.18, {Position = state and UDim2.fromScale(0.55, 0.14) or UDim2.fromScale(0.05, 0.14)})
        -- Intentionally no functional action.
    end)
end

-- HOME PAGE.
pageTitle(home, "TEST", "CYBERPUNK CONTROL CENTER  //  VISUAL PREVIEW")
local hero, heroStroke = panel(home, "Hero", UDim2.fromScale(0.07, 0.30), UDim2.fromScale(0.88, 0.23))
heroStroke.Color = C.magenta
makeText(hero, "HeroSmall", "DKHUB // SYSTEM ONLINE", UDim2.fromScale(0.06, 0.14), UDim2.fromScale(0.80, 0.18), Enum.Font.GothamBold, 9, C.pink)
makeText(hero, "HeroTitle", "YOUR SPACE. YOUR CONTROL.", UDim2.fromScale(0.06, 0.34), UDim2.fromScale(0.88, 0.30), Enum.Font.GothamBlack, 18, C.white)
makeText(hero, "HeroSub", "A clean visual framework for future modules.", UDim2.fromScale(0.06, 0.70), UDim2.fromScale(0.88, 0.16), Enum.Font.Gotham, 9, C.muted)
makeGradient(hero, "HeroGradient", {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 8, 32)),
    ColorSequenceKeypoint.new(0.55, C.card),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 20, 42)),
}, 0)

testToggle(home, "LaunchTest", "LAUNCH TEST", UDim2.fromScale(0.07, 0.59))
testToggle(home, "PerformanceTest", "PERFORMANCE TEST", UDim2.fromScale(0.07, 0.75))

-- CHAIN PAGE.
pageTitle(chain, "CHAIN", "EMPTY MODULE NETWORK  //  READY FOR DESIGN")
local chainHero, chainStroke = panel(chain, "ChainHero", UDim2.fromScale(0.07, 0.30), UDim2.fromScale(0.88, 0.16))
chainStroke.Color = C.purple
makeText(chainHero, "Count", "00", UDim2.fromScale(0.06, 0.17), UDim2.fromScale(0.25, 0.62), Enum.Font.GothamBlack, 24, C.cyan)
makeText(chainHero, "Label", "ACTIVE MODULES", UDim2.fromScale(0.33, 0.24), UDim2.fromScale(0.56, 0.22), Enum.Font.GothamBold, 10, C.text)
makeText(chainHero, "Hint", "Everything is empty by design.", UDim2.fromScale(0.33, 0.53), UDim2.fromScale(0.56, 0.20), Enum.Font.Gotham, 9, C.muted)
for i = 1, 3 do
    local slot, slotStroke = panel(chain, "Module" .. i, UDim2.fromScale(0.07, 0.51 + (i - 1) * 0.15), UDim2.fromScale(0.88, 0.11))
    slotStroke.Color = i == 1 and C.red or (i == 2 and C.purple or C.blue)
    makeText(slot, "Slot", "MODULE 0" .. i, UDim2.fromScale(0.06, 0.16), UDim2.fromScale(0.40, 0.30), Enum.Font.GothamBold, 10, C.text)
    makeText(slot, "Empty", "EMPTY", UDim2.fromScale(0.70, 0.16), UDim2.fromScale(0.23, 0.30), Enum.Font.GothamBold, 9, C.muted, Enum.TextXAlignment.Right)
end

-- SETTINGS PAGE.
pageTitle(settings, "SETTINGS", "VISUAL PREFERENCES  //  TEST CONTROLS")
local settingsHero, settingsStroke = panel(settings, "SettingsHero", UDim2.fromScale(0.07, 0.30), UDim2.fromScale(0.88, 0.16))
settingsStroke.Color = C.blue
makeText(settingsHero, "Title", "VISUAL ENGINE", UDim2.fromScale(0.06, 0.17), UDim2.fromScale(0.62, 0.30), Enum.Font.GothamBlack, 16, C.white)
makeText(settingsHero, "Hint", "Changes below are UI demonstrations only.", UDim2.fromScale(0.06, 0.54), UDim2.fromScale(0.82, 0.20), Enum.Font.Gotham, 9, C.muted)
testToggle(settings, "BorderTest", "BORDER SHINE", UDim2.fromScale(0.07, 0.51))
testToggle(settings, "GlowTest", "NEON GLOW", UDim2.fromScale(0.07, 0.67))
testToggle(settings, "ParticleTest", "LIGHT PARTICLES", UDim2.fromScale(0.07, 0.83))

homeNav.MouseButton1Click:Connect(function() activate("Home") end)
chainNav.MouseButton1Click:Connect(function() activate("Chain") end)
settingsNav.MouseButton1Click:Connect(function() activate("Settings") end)
activate("Home")

-- Stable minimize behavior.
local icon = Instance.new("TextButton")
icon.Name = "DKHUB_Icon"
icon.AnchorPoint = Vector2.new(0.5, 0.5)
icon.Position = UDim2.fromScale(0.86, 0.84)
icon.Size = UDim2.fromOffset(64, 64)
icon.BackgroundColor3 = C.black
icon.AutoButtonColor = false
icon.BorderSizePixel = 0
icon.Font = Enum.Font.GothamBlack
icon.Text = "DK"
icon.TextColor3 = C.white
icon.TextSize = 18
icon.Visible = false
icon.ZIndex = 40
icon.Parent = gui
round(icon, 32)
local iconStroke = stroke(icon, C.magenta, 2, 0)
makeGradient(iconStroke, "IconFlow", {
    ColorSequenceKeypoint.new(0, C.red),
    ColorSequenceKeypoint.new(0.5, C.blue),
    ColorSequenceKeypoint.new(1, C.purple),
}, 0)

local minimized = false
local closed = false
local iconDragging = false
local iconMoved = false
local iconStart
local iconOrigin

minimize.MouseButton1Click:Connect(function()
    minimized = true
    tween(window, 0.28, {Position = UDim2.fromScale(0.5, 1.32)}, Enum.EasingStyle.Back)
    tween(shadow, 0.28, {Position = UDim2.fromScale(0.5, 1.34)}, Enum.EasingStyle.Back)
    tween(aura, 0.28, {Position = UDim2.fromScale(0.5, 1.30)}, Enum.EasingStyle.Back)
    task.delay(0.20, function()
        if minimized and not closed then
            window.Visible = false
            shadow.Visible = false
            aura.Visible = false
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
    window.Position = UDim2.fromScale(0.5, 1.32)
    shadow.Position = UDim2.fromScale(0.5, 1.34)
    aura.Position = UDim2.fromScale(0.5, 1.30)
    tween(window, 0.36, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)
    tween(shadow, 0.36, {Position = UDim2.fromScale(0.5, 0.505)}, Enum.EasingStyle.Back)
    tween(aura, 0.36, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)
end)

close.MouseButton1Click:Connect(function()
    closed = true
    tween(window, 0.25, {Position = UDim2.fromScale(0.5, 1.38)}, Enum.EasingStyle.Back)
    tween(shadow, 0.25, {Position = UDim2.fromScale(0.5, 1.40)}, Enum.EasingStyle.Back)
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
        icon.Position = UDim2.new(iconOrigin.X.Scale, iconOrigin.X.Offset + d.X, iconOrigin.Y.Scale, iconOrigin.Y.Offset + d.Y)
    end
end)

-- Drag main window by its header.
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
    end
end)
