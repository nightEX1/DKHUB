-- DKHUB | Steal an Egg UI
-- Safe UI shell for your own Roblox Studio experience.
-- Switch callbacks are local and ready to connect to your own game systems.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("DKHUB_StealAnEgg")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DKHUB_StealAnEgg"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local C = {
    bg = Color3.fromRGB(10, 10, 14),
    panel = Color3.fromRGB(18, 18, 25),
    panel2 = Color3.fromRGB(25, 25, 34),
    red = Color3.fromRGB(228, 42, 62),
    red2 = Color3.fromRGB(255, 76, 91),
    white = Color3.fromRGB(255, 255, 255),
    text = Color3.fromRGB(220, 220, 230),
    muted = Color3.fromRGB(145, 146, 160),
    green = Color3.fromRGB(62, 210, 137),
}

local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
    return s
end

local function tw(obj, time, props, style)
    local t = TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function label(parent, name, text, pos, size, font, textSize, color)
    local l = Instance.new("TextLabel")
    l.Name = name
    l.Position = pos
    l.Size = size
    l.BackgroundTransparency = 1
    l.Font = font or Enum.Font.Gotham
    l.Text = text
    l.TextSize = textSize or 14
    l.TextColor3 = color or C.text
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 5
    l.Parent = parent
    return l
end

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.505)
shadow.Size = UDim2.fromScale(0.70, 0.57)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.35
shadow.BorderSizePixel = 0
shadow.ZIndex = 1
shadow.Parent = gui
round(shadow, 16)

local window = Instance.new("Frame")
window.Name = "Window"
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.Position = UDim2.fromScale(0.5, 0.5)
window.Size = UDim2.fromScale(0.69, 0.55)
window.BackgroundColor3 = C.panel
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.ZIndex = 2
window.Parent = gui
round(window, 15)
local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 16 / 9
aspect.Parent = window
local outline = stroke(window, C.red, 2, 0.05)

-- Moving white highlight on the red border.
local shine = Instance.new("UIGradient")
shine.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.red),
    ColorSequenceKeypoint.new(0.44, C.red),
    ColorSequenceKeypoint.new(0.50, C.white),
    ColorSequenceKeypoint.new(0.56, C.red),
    ColorSequenceKeypoint.new(1, C.red),
})
shine.Offset = Vector2.new(-1, 0)
shine.Parent = outline
task.spawn(function()
    while gui.Parent do
        shine.Offset = Vector2.new(-1, 0)
        tw(shine, 1.7, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear).Completed:Wait()
        task.wait(0.7)
    end
end)

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = C.bg
header.BorderSizePixel = 0
header.ZIndex = 4
header.Parent = window

label(header, "Title", "DKHUB", UDim2.fromOffset(16, 5), UDim2.new(0.5, 0, 0, 22), Enum.Font.GothamBold, 20, C.white)
label(header, "Subtitle", "STEAL AN EGG  •  CONTROL PANEL", UDim2.fromOffset(17, 28), UDim2.new(0.7, 0, 0, 14), Enum.Font.Gotham, 9, C.muted)

local function topButton(name, text, x)
    local b = Instance.new("TextButton")
    b.Name = name
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, x, 0.5, 0)
    b.Size = UDim2.fromOffset(32, 31)
    b.BackgroundColor3 = C.panel2
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.TextColor3 = C.white
    b.TextSize = 16
    b.ZIndex = 6
    b.Parent = header
    round(b, 8)
    b.MouseEnter:Connect(function() tw(b, 0.12, {BackgroundColor3 = C.red}) end)
    b.MouseLeave:Connect(function() tw(b, 0.12, {BackgroundColor3 = C.panel2}) end)
    return b
end

local close = topButton("Close", "×", -10)
local minimize = topButton("Minimize", "□", -49)

local side = Instance.new("Frame")
side.Name = "Sidebar"
side.Position = UDim2.fromOffset(0, 48)
side.Size = UDim2.new(0.25, 0, 1, -48)
side.BackgroundColor3 = C.bg
side.BorderSizePixel = 0
side.ZIndex = 4
side.Parent = window

local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0.25, 0, 0, 48)
content.Size = UDim2.new(0.75, 0, 1, -48)
content.BackgroundColor3 = C.panel
content.BorderSizePixel = 0
content.ZIndex = 3
content.Parent = window

local tabButtons = {}
local pages = {}
local function makeTab(name, text, y)
    local b = Instance.new("TextButton")
    b.Name = name .. "Tab"
    b.Position = UDim2.fromScale(0.10, y)
    b.Size = UDim2.fromScale(0.80, 0.105)
    b.BackgroundColor3 = C.bg
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamSemibold
    b.Text = text
    b.TextColor3 = C.muted
    b.TextSize = 12
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.ZIndex = 6
    b.Parent = side
    round(b, 8)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, 12)
    p.Parent = b
    tabButtons[name] = b
    return b
end

label(side, "MenuTitle", "MENU", UDim2.fromScale(0.12, 0.08), UDim2.fromScale(0.76, 0.08), Enum.Font.GothamBold, 10, C.red2)
local homeTab = makeTab("Home", "⌂   Home", 0.19)
local eggTab = makeTab("Eggs", "◈   Eggs", 0.32)
local accountTab = makeTab("Account", "●   Account", 0.45)
label(side, "Version", "DKHUB v1.0", UDim2.fromScale(0.12, 0.90), UDim2.fromScale(0.76, 0.06), Enum.Font.Gotham, 9, C.muted)

local function makePage(name)
    local p = Instance.new("Frame")
    p.Name = name .. "Page"
    p.Size = UDim2.fromScale(1, 1)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ZIndex = 4
    p.Parent = content
    pages[name] = p
    return p
end

local function setTab(name)
    for n, b in pairs(tabButtons) do
        local active = n == name
        tw(b, 0.16, {BackgroundColor3 = active and C.red or C.bg, TextColor3 = active and C.white or C.muted})
    end
    for n, p in pairs(pages) do p.Visible = n == name end
end

local function switch(parent, name, titleText, description, y, default, callback)
    local row = Instance.new("Frame")
    row.Name = name .. "Row"
    row.Position = UDim2.fromScale(0.07, y)
    row.Size = UDim2.fromScale(0.86, 0.14)
    row.BackgroundColor3 = C.panel2
    row.BorderSizePixel = 0
    row.ZIndex = 5
    row.Parent = parent
    round(row, 9)
    label(row, "Title", titleText, UDim2.fromScale(0.05, 0.13), UDim2.fromScale(0.68, 0.35), Enum.Font.GothamSemibold, 12, C.white)
    label(row, "Description", description, UDim2.fromScale(0.05, 0.52), UDim2.fromScale(0.68, 0.25), Enum.Font.Gotham, 9, C.muted)
    local button = Instance.new("TextButton")
    button.Name = "Switch"
    button.Position = UDim2.fromScale(0.79, 0.27)
    button.Size = UDim2.fromScale(0.15, 0.45)
    button.BackgroundColor3 = default and C.red or C.bg
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.Text = ""
    button.ZIndex = 7
    button.Parent = row
    round(button, 20)
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.fromScale(0.42, 0.72)
    knob.Position = default and UDim2.fromScale(0.53, 0.14) or UDim2.fromScale(0.05, 0.14)
    knob.BackgroundColor3 = C.white
    knob.BorderSizePixel = 0
    knob.ZIndex = 8
    knob.Parent = button
    round(knob, 20)
    local enabled = default
    local function render(value)
        enabled = value
        tw(button, 0.18, {BackgroundColor3 = enabled and C.red or C.bg})
        tw(knob, 0.18, {Position = enabled and UDim2.fromScale(0.53, 0.14) or UDim2.fromScale(0.05, 0.14)})
        if callback then callback(enabled) end
    end
    button.MouseButton1Click:Connect(function() render(not enabled) end)
    return row, render
end

local home = makePage("Home")
label(home, "Heading", "Welcome back, " .. player.Name, UDim2.fromScale(0.07, 0.08), UDim2.fromScale(0.86, 0.10), Enum.Font.GothamBold, 18, C.white)
label(home, "Info", "จัดการฟังก์ชันของเกมจากแผงควบคุมของคุณ", UDim2.fromScale(0.07, 0.18), UDim2.fromScale(0.86, 0.06), Enum.Font.Gotham, 10, C.muted)
local status = Instance.new("Frame")
status.Position = UDim2.fromScale(0.07, 0.29)
status.Size = UDim2.fromScale(0.86, 0.15)
status.BackgroundColor3 = C.bg
status.BorderSizePixel = 0
status.ZIndex = 5
status.Parent = home
round(status, 9)
label(status, "Status", "●  READY", UDim2.fromScale(0.06, 0.21), UDim2.fromScale(0.5, 0.30), Enum.Font.GothamBold, 12, C.green)
label(status, "Place", "PlaceId: " .. tostring(game.PlaceId), UDim2.fromScale(0.06, 0.58), UDim2.fromScale(0.8, 0.20), Enum.Font.Gotham, 9, C.muted)
local _, setNotify = switch(home, "Notifications", "Egg Notifications", "แจ้งเตือนเมื่อมีไข่เกิดในแมพ", 0.51, true)
local _, setSound = switch(home, "Sound", "UI Sounds", "เปิดเสียงตอบสนองของปุ่ม", 0.67, true)

local eggs = makePage("Eggs")
label(eggs, "Heading", "Egg Controls", UDim2.fromScale(0.07, 0.08), UDim2.fromScale(0.86, 0.10), Enum.Font.GothamBold, 18, C.white)
label(eggs, "Info", "สวิตช์เหล่านี้เป็นจุดเชื่อมสำหรับระบบในเกมของคุณเอง", UDim2.fromScale(0.07, 0.18), UDim2.fromScale(0.86, 0.06), Enum.Font.Gotham, 10, C.muted)
local _, setMarkers = switch(eggs, "Markers", "Show Egg Markers", "แสดงตำแหน่งไข่ที่ระบบเกมอนุญาต", 0.30, false)
local _, setAutoOpen = switch(eggs, "AutoOpen", "Auto Open Menu", "เปิดหน้าต่างไข่อัตโนมัติเมื่อกดจุดโต้ตอบ", 0.46, false)
local _, setCompact = switch(eggs, "Compact", "Compact Notifications", "รวมการแจ้งเตือนให้อยู่ในบรรทัดเดียว", 0.62, true)

local account = makePage("Account")
label(account, "Heading", "Account", UDim2.fromScale(0.07, 0.08), UDim2.fromScale(0.86, 0.10), Enum.Font.GothamBold, 18, C.white)
label(account, "User", "user : " .. player.Name, UDim2.fromScale(0.07, 0.27), UDim2.fromScale(0.86, 0.08), Enum.Font.Gotham, 13, C.text)
label(account, "Map", "map : " .. tostring(workspace:GetAttribute("MapName") or game.PlaceId), UDim2.fromScale(0.07, 0.39), UDim2.fromScale(0.86, 0.08), Enum.Font.Gotham, 13, C.text)
label(account, "Note", "UI นี้ออกแบบสำหรับประสบการณ์ที่คุณเป็นเจ้าของ", UDim2.fromScale(0.07, 0.62), UDim2.fromScale(0.86, 0.08), Enum.Font.Gotham, 10, C.muted)

homeTab.MouseButton1Click:Connect(function() setTab("Home") end)
eggTab.MouseButton1Click:Connect(function() setTab("Eggs") end)
accountTab.MouseButton1Click:Connect(function() setTab("Account") end)
setTab("Home")

local minimized = false
local closed = false
local icon = Instance.new("TextButton")
icon.Name = "DKHUB_Icon"
icon.AnchorPoint = Vector2.new(0.5, 0.5)
icon.Position = UDim2.fromScale(0.88, 0.82)
icon.Size = UDim2.fromOffset(58, 58)
icon.BackgroundColor3 = C.bg
icon.AutoButtonColor = false
icon.BorderSizePixel = 0
icon.Font = Enum.Font.GothamBold
icon.Text = "DK"
icon.TextColor3 = C.white
icon.TextSize = 17
icon.Visible = false
icon.ZIndex = 20
icon.Parent = gui
round(icon, 29)
stroke(icon, C.red, 2, 0)

minimize.MouseButton1Click:Connect(function()
    minimized = true
    tw(window, 0.3, {Position = UDim2.fromScale(0.5, 1.25)})
    tw(shadow, 0.3, {Position = UDim2.fromScale(0.5, 1.27)})
    task.delay(0.22, function() if minimized and not closed then icon.Visible = true end end)
end)
icon.MouseButton1Click:Connect(function()
    minimized = false
    icon.Visible = false
    tw(window, 0.3, {Position = UDim2.fromScale(0.5, 0.5)})
    tw(shadow, 0.3, {Position = UDim2.fromScale(0.5, 0.505)})
end)
close.MouseButton1Click:Connect(function()
    closed = true
    tw(window, 0.25, {Position = UDim2.fromScale(0.5, 1.3)})
    tw(shadow, 0.25, {Position = UDim2.fromScale(0.5, 1.32)})
    task.delay(0.28, function() if closed then gui:Destroy() end end)
end)

-- Drag the header with mouse or touch.
local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = window.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        shadow.Position = UDim2.new(window.Position.X.Scale, window.Position.X.Offset, window.Position.Y.Scale, window.Position.Y.Offset + 5)
    end
end)

-- Public callback table for your own game systems.
_G.DKHUB_StealAnEgg = {
    setNotifications = setNotify,
    setSound = setSound,
    setEggMarkers = setMarkers,
    setAutoOpen = setAutoOpen,
    setCompactNotifications = setCompact,
}
