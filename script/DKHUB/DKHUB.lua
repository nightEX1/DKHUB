-- DKHUB CLEAN DASHBOARD UI
-- Polished visual-only dashboard. TEST switches are intentionally non-functional.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local previous = playerGui:FindFirstChild("DKHUB_CLEAN_DASHBOARD")
if previous then previous:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DKHUB_CLEAN_DASHBOARD"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local C = {
    black = Color3.fromRGB(6, 7, 11),
    sidebar = Color3.fromRGB(10, 11, 17),
    panel = Color3.fromRGB(16, 17, 25),
    card = Color3.fromRGB(24, 25, 36),
    cardHover = Color3.fromRGB(34, 30, 46),
    red = Color3.fromRGB(226, 39, 66),
    pink = Color3.fromRGB(255, 86, 142),
    purple = Color3.fromRGB(133, 78, 255),
    white = Color3.fromRGB(255, 255, 255),
    text = Color3.fromRGB(226, 226, 239),
    muted = Color3.fromRGB(144, 146, 168),
    off = Color3.fromRGB(49, 50, 63),
}

local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function line(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
    return s
end

local function move(obj, duration, props, style)
    local t = TweenService:Create(obj, TweenInfo.new(duration, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function text(parent, name, value, position, size, font, textSize, color, align)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Text = value
    label.Position = position
    label.Size = size
    label.BackgroundTransparency = 1
    label.Font = font or Enum.Font.Gotham
    label.TextSize = textSize or 14
    label.TextColor3 = color or C.text
    label.TextXAlignment = align or Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.ZIndex = 10
    label.Parent = parent
    return label
end

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
round(shadow, 22)

local window = Instance.new("Frame")
window.Name = "Window"
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.Position = UDim2.fromScale(0.5, 0.5)
window.Size = UDim2.fromScale(0.94, 0.88)
window.BackgroundColor3 = C.panel
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.ZIndex = 2
window.Parent = gui
round(window, 20)
local windowLine = line(window, C.red, 2, 0.08)

local backgroundGradient = Instance.new("UIGradient")
backgroundGradient.Name = "BackgroundGradient"
backgroundGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 15, 34)),
    ColorSequenceKeypoint.new(0.46, C.panel),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 16, 28)),
})
backgroundGradient.Rotation = 125
backgroundGradient.Parent = window

task.spawn(function()
    while gui.Parent do
        move(backgroundGradient, 4, {Offset = Vector2.new(0.28, 0)}, Enum.EasingStyle.Sine).Completed:Wait()
        move(backgroundGradient, 4, {Offset = Vector2.new(-0.28, 0)}, Enum.EasingStyle.Sine).Completed:Wait()
    end
end)

-- Header.
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 62)
header.BackgroundColor3 = C.black
header.BackgroundTransparency = 0.02
header.BorderSizePixel = 0
header.ZIndex = 5
header.Parent = window

local title = text(header, "Title", "DKHUB", UDim2.fromOffset(22, 6), UDim2.new(0.45, 0, 0, 30), Enum.Font.GothamBlack, 25, C.white)
local titleGradient = Instance.new("UIGradient")
titleGradient.Name = "TitleGradient"
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.white),
    ColorSequenceKeypoint.new(0.48, C.pink),
    ColorSequenceKeypoint.new(0.75, C.purple),
    ColorSequenceKeypoint.new(1, C.white),
})
titleGradient.Parent = title

task.spawn(function()
    while gui.Parent do
        titleGradient.Offset = Vector2.new(-1, 0)
        move(titleGradient, 2.2, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear).Completed:Wait()
        task.wait(0.6)
    end
end)
text(header, "Subtitle", "CLEAN VISUAL DASHBOARD", UDim2.fromOffset(24, 38), UDim2.new(0.65, 0, 0, 13), Enum.Font.GothamMedium, 9, C.muted)

local function headerButton(name, symbol, offset)
    local b = Instance.new("TextButton")
    b.Name = name
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, offset, 0.5, 0)
    b.Size = UDim2.fromOffset(39, 37)
    b.BackgroundColor3 = C.card
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.Text = symbol
    b.TextColor3 = C.white
    b.TextSize = 18
    b.ZIndex = 12
    b.Parent = header
    round(b, 10)
    local bLine = line(b, C.red, 1, 0.50)
    b.MouseEnter:Connect(function() move(b, 0.15, {BackgroundColor3 = C.red}); move(bLine, 0.15, {Transparency = 0}) end)
    b.MouseLeave:Connect(function() move(b, 0.15, {BackgroundColor3 = C.card}); move(bLine, 0.15, {Transparency = 0.50}) end)
    return b
end

local minimize = headerButton("Minimize", "□", -60)
local close = headerButton("Close", "×", -12)
local headerLine = Instance.new("Frame")
headerLine.Name = "HeaderLine"
headerLine.Position = UDim2.new(0, 20, 1, -1)
headerLine.Size = UDim2.new(1, -40, 0, 1)
headerLine.BackgroundColor3 = C.red
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 13
headerLine.Parent = header

-- Sidebar.
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Position = UDim2.fromOffset(0, 62)
sidebar.Size = UDim2.new(0.225, 0, 1, -62)
sidebar.BackgroundColor3 = C.sidebar
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 6
sidebar.Parent = window

text(sidebar, "Menu", "MENU", UDim2.fromScale(0.16, 0.07), UDim2.fromScale(0.68, 0.06), Enum.Font.GothamBold, 10, C.red)
local sideLine = Instance.new("Frame")
sideLine.Position = UDim2.new(1, -1, 0, 14)
sideLine.Size = UDim2.new(0, 1, 1, -28)
sideLine.BackgroundColor3 = C.red
sideLine.BackgroundTransparency = 0.45
sideLine.BorderSizePixel = 0
sideLine.ZIndex = 9
sideLine.Parent = sidebar

local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0.225, 0, 0, 62)
content.Size = UDim2.new(0.775, 0, 1, -62)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ZIndex = 4
content.Parent = window

local pages = {}
local tabs = {}
local function page(name)
    local p = Instance.new("Frame")
    p.Name = name .. "Page"
    p.Size = UDim2.fromScale(1, 1)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ZIndex = 5
    p.Parent = content
    pages[name] = p
    return p
end

local home = page("Home")
local chain = page("Chain")
local settings = page("Settings")

local function nav(name, symbol, caption, y)
    local b = Instance.new("TextButton")
    b.Name = name .. "Button"
    b.Position = UDim2.fromScale(0.13, y)
    b.Size = UDim2.fromScale(0.74, 0.115)
    b.BackgroundColor3 = C.sidebar
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Text = ""
    b.ZIndex = 12
    b.Parent = sidebar
    round(b, 10)
    local ico = text(b, "Icon", symbol, UDim2.fromScale(0.08, 0.10), UDim2.fromScale(0.27, 0.80), Enum.Font.GothamBold, 21, C.muted, Enum.TextXAlignment.Center)
    local cap = text(b, "Caption", caption, UDim2.fromScale(0.40, 0.12), UDim2.fromScale(0.53, 0.76), Enum.Font.GothamSemibold, 11, C.muted)
    tabs[name] = {button = b, icon = ico, caption = cap}
    return b
end

local homeButton = nav("Home", "⌂", "HOME", 0.17)
local chainButton = nav("Chain", "⛓", "CHAIN", 0.31)
local settingsButton = nav("Settings", "⚙", "SETTINGS", 0.45)
text(sidebar, "Footer", "DKHUB / UI", UDim2.fromScale(0.16, 0.91), UDim2.fromScale(0.68, 0.05), Enum.Font.GothamMedium, 9, C.muted)

local function activePage(name)
    for n, data in pairs(tabs) do
        local on = n == name
        move(data.button, 0.18, {BackgroundColor3 = on and C.red or C.sidebar})
        move(data.icon, 0.18, {TextColor3 = on and C.white or C.muted})
        move(data.caption, 0.18, {TextColor3 = on and C.white or C.muted})
    end
    for n, p in pairs(pages) do p.Visible = n == name end
end

local function pageHeader(parent, heading, description)
    text(parent, "Heading", heading, UDim2.fromScale(0.08, 0.09), UDim2.fromScale(0.84, 0.10), Enum.Font.GothamBold, 22, C.white)
    text(parent, "Description", description, UDim2.fromScale(0.08, 0.19), UDim2.fromScale(0.84, 0.07), Enum.Font.Gotham, 10, C.muted)
end

local function card(parent, name, caption, position, height)
    local c = Instance.new("Frame")
    c.Name = name
    c.Position = position
    c.Size = UDim2.fromScale(0.84, height or 0.13)
    c.BackgroundColor3 = C.card
    c.BackgroundTransparency = 0.08
    c.BorderSizePixel = 0
    c.ZIndex = 8
    c.Parent = parent
    round(c, 11)
    line(c, C.red, 1, 0.70)
    text(c, "Caption", caption, UDim2.fromScale(0.06, 0.12), UDim2.fromScale(0.72, 0.35), Enum.Font.GothamSemibold, 12, C.text)
    return c
end

-- HOME: clean info cards and intentionally inactive test switches.
pageHeader(home, "HOME", "Overview and visual test controls")
local statusCard = card(home, "StatusCard", "INTERFACE STATUS", UDim2.fromScale(0.08, 0.31), 0.16)
text(statusCard, "Status", "READY", UDim2.fromScale(0.06, 0.48), UDim2.fromScale(0.45, 0.32), Enum.Font.GothamBold, 14, Color3.fromRGB(75, 220, 145))
text(statusCard, "StatusHint", "Visual-only mode", UDim2.fromScale(0.53, 0.48), UDim2.fromScale(0.40, 0.32), Enum.Font.Gotham, 10, C.muted, Enum.TextXAlignment.Right)

local function testSwitch(parent, name, caption, position, default)
    local row = card(parent, name, caption, position, 0.105)
    local button = Instance.new("TextButton")
    button.Name = "TestSwitch"
    button.Position = UDim2.fromScale(0.80, 0.25)
    button.Size = UDim2.fromScale(0.14, 0.50)
    button.BackgroundColor3 = default and C.red or C.off
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.Text = ""
    button.ZIndex = 13
    button.Parent = row
    round(button, 20)
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.fromScale(0.38, 0.72)
    knob.Position = default and UDim2.fromScale(0.57, 0.14) or UDim2.fromScale(0.05, 0.14)
    knob.BackgroundColor3 = C.white
    knob.BorderSizePixel = 0
    knob.ZIndex = 14
    knob.Parent = button
    round(knob, 20)
    local state = default
    button.MouseButton1Click:Connect(function()
        state = not state
        move(button, 0.18, {BackgroundColor3 = state and C.red or C.off})
        move(knob, 0.18, {Position = state and UDim2.fromScale(0.57, 0.14) or UDim2.fromScale(0.05, 0.14)})
        -- Intentionally no action: TEST switch is visual-only.
    end)
end

testSwitch(home, "TestOne", "TEST SWITCH 01", UDim2.fromScale(0.08, 0.52), true)
testSwitch(home, "TestTwo", "TEST SWITCH 02", UDim2.fromScale(0.08, 0.65), false)
testSwitch(home, "TestThree", "TEST SWITCH 03", UDim2.fromScale(0.08, 0.78), true)

-- CHAIN: empty module slots with no actions attached.
pageHeader(chain, "CHAIN", "Empty modules ready for future design")
local chainInfo = card(chain, "ChainInfo", "MODULE COLLECTION", UDim2.fromScale(0.08, 0.31), 0.14)
text(chainInfo, "Info", "0 active modules", UDim2.fromScale(0.06, 0.48), UDim2.fromScale(0.80, 0.32), Enum.Font.Gotham, 11, C.muted)
for i = 1, 3 do
    local slot = card(chain, "ModuleSlot" .. i, "MODULE SLOT 0" .. i, UDim2.fromScale(0.08, 0.49 + (i - 1) * 0.14), 0.105)
    local empty = text(slot, "Empty", "EMPTY", UDim2.fromScale(0.72, 0.20), UDim2.fromScale(0.22, 0.60), Enum.Font.GothamBold, 10, C.muted, Enum.TextXAlignment.Right)
    slot.MouseEnter:Connect(function() move(slot, 0.15, {BackgroundColor3 = C.cardHover}) end)
    slot.MouseLeave:Connect(function() move(slot, 0.15, {BackgroundColor3 = C.card}) end)
end

-- SETTINGS: visual-only toggles.
pageHeader(settings, "SETTINGS", "Customize the appearance of this interface")
local settingsInfo = card(settings, "SettingsInfo", "VISUAL PREFERENCES", UDim2.fromScale(0.08, 0.31), 0.14)
text(settingsInfo, "Info", "All controls are UI demonstrations", UDim2.fromScale(0.06, 0.48), UDim2.fromScale(0.84, 0.32), Enum.Font.Gotham, 10, C.muted)
testSwitch(settings, "SettingOne", "TEST BORDER", UDim2.fromScale(0.08, 0.51), true)
testSwitch(settings, "SettingTwo", "TEST GLOW", UDim2.fromScale(0.08, 0.64), false)
testSwitch(settings, "SettingThree", "TEST PARTICLES", UDim2.fromScale(0.08, 0.77), true)

homeButton.MouseButton1Click:Connect(function() activePage("Home") end)
chainButton.MouseButton1Click:Connect(function() activePage("Chain") end)
settingsButton.MouseButton1Click:Connect(function() activePage("Settings") end)
activePage("Home")

-- Minimized icon: one tap opens; drag moves it without opening.
local icon = Instance.new("TextButton")
icon.Name = "DKHUB_Icon"
icon.AnchorPoint = Vector2.new(0.5, 0.5)
icon.Position = UDim2.fromScale(0.86, 0.84)
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
round(icon, 33)
local iconLine = line(icon, C.pink, 2, 0)

local minimized = false
local closed = false
local iconDragging = false
local iconMoved = false
local iconStart
local iconOrigin

minimize.MouseButton1Click:Connect(function()
    minimized = true
    move(window, 0.30, {Position = UDim2.fromScale(0.5, 1.30)}, Enum.EasingStyle.Back)
    move(shadow, 0.30, {Position = UDim2.fromScale(0.5, 1.32)}, Enum.EasingStyle.Back)
    task.delay(0.20, function()
        if minimized and not closed then
            window.Visible = false
            shadow.Visible = false
            icon.Visible = true
            icon.Size = UDim2.fromOffset(8, 8)
            move(icon, 0.30, {Size = UDim2.fromOffset(66, 66)}, Enum.EasingStyle.Back)
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
    window.Position = UDim2.fromScale(0.5, 1.30)
    shadow.Position = UDim2.fromScale(0.5, 1.32)
    move(window, 0.38, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)
    move(shadow, 0.38, {Position = UDim2.fromScale(0.5, 0.505)}, Enum.EasingStyle.Back)
end)

close.MouseButton1Click:Connect(function()
    closed = true
    move(window, 0.25, {Position = UDim2.fromScale(0.5, 1.35)}, Enum.EasingStyle.Back)
    move(shadow, 0.25, {Position = UDim2.fromScale(0.5, 1.37)}, Enum.EasingStyle.Back)
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

-- Drag the main window from its header.
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
    end
end)
