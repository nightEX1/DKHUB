-- DKHUB TEST UI
-- Safe Roblox Studio UI script: title, TEST label, and smooth open/close toggle.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("DKHUB_TestUI")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "DKHUB_TestUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.5)
shadow.Size = UDim2.fromOffset(322, 182)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.65
shadow.BorderSizePixel = 0
shadow.Parent = gui

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 14)
shadowCorner.Parent = shadow

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = UDim2.fromOffset(310, 170)
panel.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
panel.BorderSizePixel = 0
panel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 84, 105)
stroke.Transparency = 0.35
stroke.Thickness = 1
stroke.Parent = panel

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Position = UDim2.fromOffset(18, 12)
title.Size = UDim2.new(1, -36, 0, 30)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "DKHUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 21
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local divider = Instance.new("Frame")
divider.Position = UDim2.fromOffset(18, 49)
divider.Size = UDim2.new(1, -36, 0, 1)
divider.BackgroundColor3 = Color3.fromRGB(75, 78, 96)
divider.BackgroundTransparency = 0.35
divider.BorderSizePixel = 0
divider.Parent = panel

local testLabel = Instance.new("TextLabel")
testLabel.Name = "TestLabel"
testLabel.Position = UDim2.fromOffset(18, 62)
testLabel.Size = UDim2.new(1, -36, 0, 28)
testLabel.BackgroundTransparency = 1
testLabel.Font = Enum.Font.Gotham
testLabel.Text = "TEST"
testLabel.TextColor3 = Color3.fromRGB(205, 208, 220)
testLabel.TextSize = 17
testLabel.TextXAlignment = Enum.TextXAlignment.Left
testLabel.Parent = panel

local toggle = Instance.new("TextButton")
toggle.Name = "ToggleButton"
toggle.Position = UDim2.fromOffset(18, 108)
toggle.Size = UDim2.new(1, -36, 0, 42)
toggle.BackgroundColor3 = Color3.fromRGB(61, 119, 255)
toggle.AutoButtonColor = false
toggle.BorderSizePixel = 0
toggle.Font = Enum.Font.GothamSemibold
toggle.Text = "ปิด UI"
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.TextSize = 15
toggle.Parent = panel

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 9)
toggleCorner.Parent = toggle

local open = true
local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function setOpen(value)
    open = value
    local targetPosition = open and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0.5, 1.25)
    local targetShadow = open and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0.5, 1.25)
    TweenService:Create(panel, tweenInfo, {Position = targetPosition}):Play()
    TweenService:Create(shadow, tweenInfo, {Position = targetShadow}):Play()
    toggle.Text = open and "ปิด UI" or "เปิด UI"
end

toggle.MouseButton1Click:Connect(function()
    setOpen(not open)
end)

-- Smooth hover feedback.
toggle.MouseEnter:Connect(function()
    TweenService:Create(toggle, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(83, 137, 255)
    }):Play()
end)

toggle.MouseLeave:Connect(function()
    TweenService:Create(toggle, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(61, 119, 255)
    }):Play()
end)

-- Touch-friendly button activation is handled by TextButton automatically.
