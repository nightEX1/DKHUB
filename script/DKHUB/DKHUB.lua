-- DKHUB DEVELOPER PANEL
-- Empty visual framework with Home, Chain and Settings navigation.
-- No game functions, automation, executor control or external script runner.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("DKHUB_DEVELOPER_PANEL")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DKHUB_DEVELOPER_PANEL"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local C = {
    black = Color3.fromRGB(7, 7, 11),
    sidebar = Color3.fromRGB(10, 10, 16),
    panel = Color3.fromRGB(16, 16, 24),
    card = Color3.fromRGB(24, 23, 34),
    red = Color3.fromRGB(224, 35, 65),
    pink = Color3.fromRGB(255, 77, 132),
    purple = Color3.fromRGB(135, 75, 255),
    white = Color3.fromRGB(255, 255, 255),
    text = Color3.fromRGB(222, 221, 234),
    muted = Color3.fromRGB(145, 145, 167),
}

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function outline(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
    return s
end

local function tween(obj, duration, properties, style)
    local t = TweenService:Create(obj, TweenInfo.new(duration, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), properties)
    t:Play()
    return t
end

local function gradient(obj, name, colors, rotation)
    local g = Instance.new("UIGradient")
    g.Name = name
    g.Color = ColorSequence.new(colors)
    g.Rotation = rotation or 0
    g.Parent = obj
    return g
end

local function makeText(parent, name, value, position, size, font, textSize, color)
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
    l.ZIndex = 10
    l.Parent = parent
    return l
end

-- Mobile-friendly large panel.
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
local windowBorder = outline(window, C.red, 2, 0.02)
local windowBorderGradient = gradient(windowBorder, "BorderShine", {
    ColorSequenceKeypoint.new(0, C.red),
    ColorSequenceKeypoint.new(0.42, C.red),
    ColorSequenceKeypoint.new(0.50, C.white),
    ColorSequenceKeypoint.new(0.65, C.pink),
    ColorSequenceKeypoint.new(1, C.purple),
}, 0)

-- A top-most frame keeps child backgrounds from covering the red edge.
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
local maskStroke = outline(borderMask, C.red, 3, 0)
gradient(maskStroke, "MaskShine", {
    ColorSequenceKeypoint.new(0, C.red),
    ColorSequenceKeypoint.new(0.45, C.pink),
    ColorSequenceKeypoint.new(0.50, C.white),
    ColorSequenceKeypoint.new(0.58, C.purple),
    ColorSequenceKeypoint.new(1, C.red),
}, 0)

task.spawn(function()
    while gui.Parent do
        windowBorderGradient.Offset = Vector2.new(-1, 0)
        tween(windowBorderGradient, 1.65, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear).Completed:Wait()
        task.wait(0.5)
    end
end)

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = C.black
header.BorderSizePixel = 0
header.ZIndex = 5
header.Parent = window
gradient(header, "HeaderGradient", {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 9, 28)),
    ColorSequenceKeypoint.new(0.5, C.black),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 15, 28)),
}, 0)

local title = makeText(header, "Title", "DKHUB", UDim2.fromOffset(21, 8), UDim2.new(0.50, 0, 0, 28), Enum.Font.GothamBlack, 24, C.white)
local titleGradient = gradient(title, "TitleGradient", {
    ColorSequenceKeypoint.new(0, C.white),
    ColorSequenceKeypoint.new(0.45, C.pink),
    ColorSequenceKeypoint.new(0.70, C.purple),
    ColorSequenceKeypoint.new(1, C.white),
}, 0)
task.spawn(function()
    while gui.Parent do
        titleGradient.Offset = Vector2.new(-1, 0)
        tween(titleGradient, 2.3, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear).Completed:Wait()
        task.wait(0.5)
    end
end)
makeText(header, "Subtitle", "DEVELOPER PANEL  /  EMPTY FRAMEWORK", UDim2.fromOffset(23, 37), UDim2.new(0.70, 0, 0, 14), Enum.Font.GothamMedium, 9, C.muted)

local function headerButton(name, value, offset)
    local b = Instance.new("TextButton")
    b.Name = name
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, offset, 0.5, 0)
    b.Size = UDim2.fromOffset(39, 37)
    b.BackgroundColor3 = C.card
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.Text = value
    b.TextColor3 = C.white
    b.TextSize = 18
    b.ZIndex = 12
    b.Parent = header
    corner(b, 10)
    local s = outline(b, C.red, 1, 0.45)
    b.MouseEnter:Connect(function() tween(b, 0.15, {BackgroundColor3 = C.red}); tween(s, 0.15, {Transparency = 0}) end)
    b.MouseLeave:Connect(function() tween(b, 0.15, {BackgroundColor3 = C.card}); tween(s, 0.15, {Transparency = 0.45}) end)
    return b
end

local closeButton = headerButton("Close", "×", -12)
local minimizeButton = headerButton("Minimize", "□", -60)
local headerLine = Instance.new("Frame")
headerLine.Name = "HeaderLine"
headerLine.Position = UDim2.new(0, 20, 1, -1)
headerLine.Size = UDim2.new(1, -40, 0, 1)
headerLine.BackgroundColor3 = C.red
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 13
headerLine.Parent = header
gradient(headerLine, "LineGradient", {
    ColorSequenceKeypoint.new(0, C.red),
    ColorSequenceKeypoint.new(0.5, C.white),
    ColorSequenceKeypoint.new(1, C.purple),
}, 0)

-- Sidebar with the three main function icons.
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Position = UDim2.fromOffset(0, 60)
sidebar.Size = UDim2.new(0.22, 0, 1, -60)
sidebar.BackgroundColor3 = C.sidebar
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 6
sidebar.Parent = window

local sidebarLine = Instance.new("Frame")
sidebarLine.Name = "SidebarLine"
sidebarLine.Position = UDim2.new(1, -1, 0, 12)
sidebarLine.Size = UDim2.new(0, 1, 1, -24)
sidebarLine.BackgroundColor3 = C.red
sidebarLine.BackgroundTransparency = 0.35
sidebarLine.BorderSizePixel = 0
sidebarLine.ZIndex = 9
sidebarLine.Parent = sidebar

makeText(sidebar, "MenuLabel", "MENU", UDim2.fromScale(0.18, 0.07), UDim2.fromScale(0.64, 0.06), Enum.Font.GothamBold, 10, C.red)

local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0.22, 0, 0, 60)
content.Size = UDim2.new(0.78, 0, 1, -60)
content.BackgroundColor3 = C.panel
content.BorderSizePixel = 0
content.ZIndex = 4
content.Parent = window

local tabs = {}
local pages = {}
local function createPage(name)
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

local function createTab(name, symbol, caption, y)
    local b = Instance.new("TextButton")
    b.Name = name .. "Tab"
    b.Position = UDim2.fromScale(0.14, y)
    b.Size = UDim2.fromScale(0.72, 0.12)
    b.BackgroundColor3 = C.sidebar
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Text = ""
    b.ZIndex = 11
    b.Parent = sidebar
    corner(b, 10)
    local icon = makeText(b, "Icon", symbol, UDim2.fromScale(0.12, 0.12), UDim2.fromScale(0.28, 0.72), Enum.Font.GothamBold, 22, C.muted)
    icon.TextXAlignment = Enum.TextXAlignment.Center
    local captionLabel = makeText(b, "Caption", caption, UDim2.fromScale(0.42, 0.20), UDim2.fromScale(0.52, 0.58), Enum.Font.GothamSemibold, 11, C.muted)
    tabs[name] = {button = b, icon = icon, caption = captionLabel}
    return b
end

local home = createPage("Home")
local chain = createPage("Chain")
local settings = createPage("Settings")

local function setActive(name)
    for tabName, data in pairs(tabs) do
        local active = tabName == name
        tween(data.button, 0.18, {BackgroundColor3 = active and C.red or C.sidebar})
        tween(data.icon, 0.18, {TextColor3 = active and C.white or C.muted})
        tween(data.caption, 0.18, {TextColor3 = active and C.white or C.muted})
    end
    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end
end

local homeTab = createTab("Home", "⌂", "HOME", 0.17)
local chainTab = createTab("Chain", "⛓", "CHAIN", 0.32)
local settingsTab = createTab("Settings", "⚙", "SETTINGS", 0.47)
makeText(sidebar, "Footer", "DKHUB UI", UDim2.fromScale(0.18, 0.90), UDim2.fromScale(0.64, 0.06), Enum.Font.GothamMedium, 9, C.muted)

local function emptyPage(page, heading, subheading, symbol)
    local badge = Instance.new("Frame")
    badge.Name = "IconBadge"
    badge.AnchorPoint = Vector2.new(0.5, 0)
    badge.Position = UDim2.fromScale(0.5, 0.13)
    badge.Size = UDim2.fromOffset(62, 62)
    badge.BackgroundColor3 = C.card
    badge.BorderSizePixel = 0
    badge.ZIndex = 7
    badge.Parent = page
    corner(badge, 18)
    local bs = outline(badge, C.red, 1, 0.2)
    gradient(bs, "BadgeGradient", {
        ColorSequenceKeypoint.new(0, C.red),
        ColorSequenceKeypoint.new(0.5, C.white),
        ColorSequenceKeypoint.new(1, C.purple),
    }, 0)
    local icon = makeText(badge, "Symbol", symbol, UDim2.fromScale(0.08, 0.03), UDim2.fromScale(0.84, 0.94), Enum.Font.GothamBold, 30, C.white)
    icon.TextXAlignment = Enum.TextXAlignment.Center
    local h = makeText(page, "Heading", heading, UDim2.fromScale(0.08, 0.38), UDim2.fromScale(0.84, 0.10), Enum.Font.GothamBold, 20, C.white)
    h.TextXAlignment = Enum.TextXAlignment.Center
    local s = makeText(page, "Subheading", subheading, UDim2.fromScale(0.08, 0.50), UDim2.fromScale(0.84, 0.10), Enum.Font.Gotham, 11, C.muted)
    s.TextXAlignment = Enum.TextXAlignment.Center
    local empty = Instance.new("Frame")
    empty.Name = "EmptySlot"
    empty.AnchorPoint = Vector2.new(0.5, 0)
    empty.Position = UDim2.fromScale(0.5, 0.57)
    empty.Size = UDim2.fromScale(0.70, 0.07)
    empty.BackgroundColor3 = C.card
    empty.BackgroundTransparency = 0.25
    empty.BorderSizePixel = 0
    empty.ZIndex = 7
    empty.Parent = page
    corner(empty, 10)
    outline(empty, C.red, 1, 0.65)
    local slot = makeText(empty, "SlotText", "EMPTY FUNCTION SLOT", UDim2.fromScale(0.05, 0.12), UDim2.fromScale(0.90, 0.76), Enum.Font.GothamMedium, 10, C.muted)
    slot.TextXAlignment = Enum.TextXAlignment.Center
end

emptyPage(home, "HOME", "พื้นที่ว่างสำหรับฟังก์ชันหลักในอนาคต", "⌂")
emptyPage(chain, "CHAIN", "พื้นที่ว่างสำหรับฟังก์ชันเชนในอนาคต", "⛓")
emptyPage(settings, "SETTINGS", "พื้นที่ว่างสำหรับการตั้งค่าในอนาคต", "⚙")

-- Reusable visual controls for the empty framework.
local function makeToggle(parent, name, caption, position, default, callback)
    local row = Instance.new("Frame")
    row.Name = name .. "Row"
    row.Position = position
    row.Size = UDim2.fromScale(0.84, 0.105)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.12
    row.BorderSizePixel = 0
    row.ZIndex = 12
    row.Parent = parent
    corner(row, 9)
    makeText(row, "Caption", caption, UDim2.fromScale(0.06, 0.18), UDim2.fromScale(0.62, 0.64), Enum.Font.GothamSemibold, 11, C.text)
    local button = Instance.new("TextButton")
    button.Name = "Switch"
    button.Position = UDim2.fromScale(0.79, 0.23)
    button.Size = UDim2.fromScale(0.15, 0.54)
    button.BackgroundColor3 = default and C.red or C.black
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.Text = ""
    button.ZIndex = 14
    button.Parent = row
    corner(button, 20)
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.fromScale(0.38, 0.72)
    knob.Position = default and UDim2.fromScale(0.57, 0.14) or UDim2.fromScale(0.05, 0.14)
    knob.BackgroundColor3 = C.white
    knob.BorderSizePixel = 0
    knob.ZIndex = 15
    knob.Parent = button
    corner(knob, 20)
    local enabled = default
    local function render(value)
        enabled = value
        tween(button, 0.18, {BackgroundColor3 = enabled and C.red or C.black})
        tween(knob, 0.18, {Position = enabled and UDim2.fromScale(0.57, 0.14) or UDim2.fromScale(0.05, 0.14)})
        if callback then callback(enabled) end
    end
    button.MouseButton1Click:Connect(function() render(not enabled) end)
    return render
end

local function makeModuleSlot(parent, name, caption, position)
    local slot = Instance.new("TextButton")
    slot.Name = name
    slot.Position = position
    slot.Size = UDim2.fromScale(0.84, 0.105)
    slot.BackgroundColor3 = C.card
    slot.AutoButtonColor = false
    slot.BorderSizePixel = 0
    slot.Text = ""
    slot.ZIndex = 12
    slot.Parent = parent
    corner(slot, 9)
    outline(slot, C.red, 1, 0.60)
    makeText(slot, "Caption", caption, UDim2.fromScale(0.06, 0.17), UDim2.fromScale(0.62, 0.66), Enum.Font.GothamSemibold, 11, C.text)
    local empty = makeText(slot, "State", "EMPTY", UDim2.fromScale(0.70, 0.17), UDim2.fromScale(0.24, 0.66), Enum.Font.GothamBold, 10, C.muted)
    empty.TextXAlignment = Enum.TextXAlignment.Right
    slot.MouseEnter:Connect(function() tween(slot, 0.15, {BackgroundColor3 = Color3.fromRGB(38, 27, 45)}) end)
    slot.MouseLeave:Connect(function() tween(slot, 0.15, {BackgroundColor3 = C.card}) end)
    return slot
end

makeText(home, "QuickTitle", "QUICK CONTROLS", UDim2.fromScale(0.08, 0.67), UDim2.fromScale(0.84, 0.05), Enum.Font.GothamBold, 10, C.red)
makeToggle(home, "HomeAnimation", "UI Animations", UDim2.fromScale(0.08, 0.73), true, function(value)
    windowBorderGradient.Enabled = value
    titleGradient.Enabled = value
end)
makeToggle(home, "HomeGlow", "Glow Effects", UDim2.fromScale(0.08, 0.85), true, function(value)
    shadow.BackgroundTransparency = value and 0.22 or 0.65
end)

makeText(chain, "ModuleTitle", "MODULE SLOTS", UDim2.fromScale(0.08, 0.67), UDim2.fromScale(0.84, 0.05), Enum.Font.GothamBold, 10, C.red)
makeModuleSlot(chain, "Module01", "Module Slot 01", UDim2.fromScale(0.08, 0.73))
makeModuleSlot(chain, "Module02", "Module Slot 02", UDim2.fromScale(0.08, 0.85))

makeText(settings, "SettingTitle", "INTERFACE SETTINGS", UDim2.fromScale(0.08, 0.67), UDim2.fromScale(0.84, 0.05), Enum.Font.GothamBold, 10, C.red)
makeToggle(settings, "BorderSetting", "Border Shine", UDim2.fromScale(0.08, 0.73), true, function(value)
    windowBorderGradient.Enabled = value
end)
makeToggle(settings, "HeaderSetting", "Header Glow", UDim2.fromScale(0.08, 0.85), true, function(value)
    header.BackgroundTransparency = value and 0 or 0.18
end)

homeTab.MouseButton1Click:Connect(function() setActive("Home") end)
chainTab.MouseButton1Click:Connect(function() setActive("Chain") end)
settingsTab.MouseButton1Click:Connect(function() setActive("Settings") end)
setActive("Home")

-- Minimize icon.
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
corner(icon, 33)
local iconBorder = outline(icon, C.pink, 2, 0)
gradient(iconBorder, "IconGradient", {
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
    tween(window, 0.4, {Position = UDim2.fromScale(0.5, 1.30)}, Enum.EasingStyle.Back)
    tween(shadow, 0.4, {Position = UDim2.fromScale(0.5, 1.32)}, Enum.EasingStyle.Back)
    tween(borderMask, 0.4, {Position = UDim2.fromScale(0.5, 1.30)}, Enum.EasingStyle.Back)
    task.delay(0.25, function()
        if minimized and not closed then
            window.Visible = false
            shadow.Visible = false
            borderMask.Visible = false
            icon.Visible = true
            icon.Size = UDim2.fromOffset(8, 8)
            tween(icon, 0.35, {Size = UDim2.fromOffset(66, 66)}, Enum.EasingStyle.Back)
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
    borderMask.Visible = true
    window.Position = UDim2.fromScale(0.5, 1.30)
    shadow.Position = UDim2.fromScale(0.5, 1.32)
    borderMask.Position = UDim2.fromScale(0.5, 1.30)
    tween(window, 0.42, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)
    tween(shadow, 0.42, {Position = UDim2.fromScale(0.5, 0.505)}, Enum.EasingStyle.Back)
    tween(borderMask, 0.42, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)
end)
closeButton.MouseButton1Click:Connect(function()
    closed = true
    tween(window, 0.3, {Position = UDim2.fromScale(0.5, 1.35)}, Enum.EasingStyle.Back)
    tween(shadow, 0.3, {Position = UDim2.fromScale(0.5, 1.37)}, Enum.EasingStyle.Back)
    tween(borderMask, 0.3, {Position = UDim2.fromScale(0.5, 1.35)}, Enum.EasingStyle.Back)
    task.delay(0.34, function() if closed then gui:Destroy() end end)
end)

icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = true
        iconMoved = false
        iconDragStart = input.Position
        iconStartPosition = icon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then iconDragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - iconDragStart
        if math.abs(d.X) > 4 or math.abs(d.Y) > 4 then iconMoved = true end
        icon.Position = UDim2.new(iconStartPosition.X.Scale, iconStartPosition.X.Offset + d.X, iconStartPosition.Y.Scale, iconStartPosition.Y.Offset + d.Y)
    end
end)

-- Drag the window using the header.
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
        borderMask.Position = window.Position
    end
end)
