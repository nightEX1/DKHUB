--[[
    DKHUB  |  Main · Autofarm · Setting · Automation · Webhook
    ไม่ต้องพึ่ง library ภายนอก  |  RightShift = ซ่อน/แสดง UI
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ========== CONFIG (ค่าที่ UI ควบคุม) ==========
local Config = {
    AutoFarm = false,
    FarmSpeed = 16,
    AutoCollect = false,
    AntiAFK = true,
    AutoRejoin = false,
    AutoLoop = false,
    LoopDelay = 5,
    WebhookUrl = "",
    WebhookEnabled = false,
}

-- ========== THEME ==========
local T = {
    Bg = Color3.fromRGB(16, 16, 22),
    Side = Color3.fromRGB(22, 22, 30),
    Card = Color3.fromRGB(30, 30, 40),
    Accent = Color3.fromRGB(124, 92, 255),
    Text = Color3.fromRGB(235, 235, 245),
    Sub = Color3.fromRGB(145, 145, 165),
    Off = Color3.fromRGB(52, 52, 68),
}

-- ========== HELPERS ==========
local function New(class, props, children)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    for _, c in ipairs(children or {}) do c.Parent = o end
    return o
end

local function Corner(r) return New("UICorner", { CornerRadius = UDim.new(0, r or 8) }) end
local function Pad(p) return New("UIPadding", {
    PaddingTop = UDim.new(0, p), PaddingBottom = UDim.new(0, p),
    PaddingLeft = UDim.new(0, p), PaddingRight = UDim.new(0, p) }) end

local function Tween(o, t, props)
    TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function GetParent()
    local ok, ui = pcall(function() return gethui and gethui() end)
    if ok and ui then return ui end
    ok = pcall(function() return CoreGui.Name end)
    if ok then return CoreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- ลบ UI เก่าถ้ารันซ้ำ
local parent = GetParent()
local old = parent:FindFirstChild("DKHUB")
if old then old:Destroy() end

-- ========== WINDOW ==========
local Gui = New("ScreenGui", { Name = "DKHUB", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
Gui.Parent = parent

local Window = New("Frame", {
    Size = UDim2.fromOffset(580, 380),
    Position = UDim2.new(0.5, -290, 0.5, -190),
    BackgroundColor3 = T.Bg, BorderSizePixel = 0, Parent = Gui,
}, { Corner(12), New("UIStroke", { Color = T.Accent, Transparency = 0.6, Thickness = 1 }) })

local Top = New("Frame", { Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Parent = Window })
New("TextLabel", {
    Text = "⚡  DKHUB", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = T.Text,
    TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 0), Size = UDim2.new(1, -90, 1, 0), Parent = Top,
})

local function TopBtn(txt, x, cb)
    local b = New("TextButton", {
        Text = txt, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = T.Sub,
        BackgroundColor3 = T.Card, Size = UDim2.fromOffset(26, 26),
        Position = UDim2.new(1, x, 0, 8), AutoButtonColor = false, Parent = Top,
    }, { Corner(6) })
    b.MouseButton1Click:Connect(cb)
    return b
end

local Body = New("Frame", {
    Size = UDim2.new(1, 0, 1, -42), Position = UDim2.fromOffset(0, 42),
    BackgroundTransparency = 1, Parent = Window,
})
TopBtn("–", -66, function() Body.Visible = not Body.Visible
    Tween(Window, 0.2, { Size = Body.Visible and UDim2.fromOffset(580, 380) or UDim2.fromOffset(580, 42) }) end)
TopBtn("✕", -34, function() Gui:Destroy() end)

-- Drag
do
    local dragging, start, startPos
    Top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, start, startPos = true, i.Position, Window.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - start
            Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

UIS.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightShift then Window.Visible = not Window.Visible end
end)

-- ========== NOTIFY ==========
local Toasts = New("Frame", {
    Size = UDim2.fromOffset(260, 300), Position = UDim2.new(1, -276, 1, -316),
    BackgroundTransparency = 1, Parent = Gui,
}, { New("UIListLayout", { VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 6) }) })

local function Notify(title, msg)
    local f = New("Frame", { Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = T.Card, Parent = Toasts },
        { Corner(8), Pad(8), New("UIStroke", { Color = T.Accent, Transparency = 0.5 }) })
    New("TextLabel", { Text = title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = T.Text,
        TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), Parent = f })
    New("TextLabel", { Text = msg, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = T.Sub,
        TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 18), Size = UDim2.new(1, 0, 0, 16), Parent = f })
    task.delay(3, function() if f.Parent then f:Destroy() end end)
end

-- ========== SIDEBAR + PAGES ==========
local Side = New("Frame", { Size = UDim2.new(0, 140, 1, 0), BackgroundColor3 = T.Side, BorderSizePixel = 0, Parent = Body },
    { Corner(12), Pad(8), New("UIListLayout", { Padding = UDim.new(0, 4) }) })
local PageHolder = New("Frame", { Size = UDim2.new(1, -150, 1, -8), Position = UDim2.fromOffset(146, 0),
    BackgroundTransparency = 1, Parent = Body })

local Tabs, Current = {}, nil

local function CreateTab(name, icon)
    local btn = New("TextButton", {
        Text = icon .. "  " .. name, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = T.Sub,
        TextXAlignment = Enum.TextXAlignment.Left, BackgroundColor3 = T.Accent, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34), AutoButtonColor = false, Parent = Side,
    }, { Corner(8), New("UIPadding", { PaddingLeft = UDim.new(0, 12) }) })

    local page = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = T.Accent, Visible = false,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = PageHolder,
    }, { New("UIListLayout", { Padding = UDim.new(0, 8) }), New("UIPadding", { PaddingRight = UDim.new(0, 6) }) })

    local function select()
        if Current then
            Current.page.Visible = false
            Tween(Current.btn, 0.15, { BackgroundTransparency = 1, TextColor3 = T.Sub })
        end
        Current = { page = page, btn = btn }
        page.Visible = true
        Tween(btn, 0.15, { BackgroundTransparency = 0, TextColor3 = Color3.new(1, 1, 1) })
    end
    btn.MouseButton1Click:Connect(select)
    table.insert(Tabs, select)

    -- ---------- components ----------
    local P = {}

    local function Card(h)
        return New("Frame", { Size = UDim2.new(1, 0, 0, h or 40), BackgroundColor3 = T.Card, Parent = page }, { Corner(8) })
    end
    local function Label(parentF, text, size)
        return New("TextLabel", { Text = text, Font = Enum.Font.Gotham, TextSize = size or 13, TextColor3 = T.Text,
            TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1,
            Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -80, 1, 0), Parent = parentF })
    end

    function P:Section(text)
        New("TextLabel", { Text = string.upper(text), Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = T.Accent,
            TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Parent = page })
    end

    function P:Label(text)
        local c = Card(36)
        local l = Label(c, text)
        return { Set = function(_, t) l.Text = t end }
    end

    function P:Toggle(text, default, cb)
        local c = Card(40)
        Label(c, text)
        local sw = New("Frame", { Size = UDim2.fromOffset(40, 20), Position = UDim2.new(1, -52, 0.5, -10),
            BackgroundColor3 = default and T.Accent or T.Off, Parent = c }, { Corner(10) })
        local knob = New("Frame", { Size = UDim2.fromOffset(16, 16),
            Position = default and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2),
            BackgroundColor3 = Color3.new(1, 1, 1), Parent = sw }, { Corner(8) })
        local state = default
        local function set(v)
            state = v
            Tween(sw, 0.15, { BackgroundColor3 = v and T.Accent or T.Off })
            Tween(knob, 0.15, { Position = v and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2) })
            if cb then task.spawn(cb, v) end
        end
        New("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = c })
            .MouseButton1Click:Connect(function() set(not state) end)
        if default and cb then task.spawn(cb, true) end
        return { Set = function(_, v) set(v) end }
    end

    function P:Slider(text, min, max, default, cb)
        local c = Card(52)
        local l = New("TextLabel", { Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = T.Text,
            TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1,
            Position = UDim2.fromOffset(12, 6), Size = UDim2.new(1, -70, 0, 18), Parent = c })
        local val = New("TextLabel", { Text = tostring(default), Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = T.Accent,
            TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1,
            Position = UDim2.new(1, -62, 0, 6), Size = UDim2.fromOffset(50, 18), Parent = c })
        local bar = New("Frame", { Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 1, -16),
            BackgroundColor3 = T.Off, Parent = c }, { Corner(3) })
        local fill = New("Frame", { Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = T.Accent, Parent = bar }, { Corner(3) })

        local dragging = false
        local function update(x)
            local r = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local v = math.floor(min + (max - min) * r + 0.5)
            fill.Size = UDim2.new(r, 0, 1, 0)
            val.Text = tostring(v)
            if cb then cb(v) end
        end
        bar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true; update(i.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                update(i.Position.X)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
    end

    function P:Button(text, cb)
        local b = New("TextButton", { Text = text, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Color3.new(1, 1, 1),
            BackgroundColor3 = T.Accent, Size = UDim2.new(1, 0, 0, 36), AutoButtonColor = false, Parent = page }, { Corner(8) })
        b.MouseEnter:Connect(function() Tween(b, 0.12, { BackgroundTransparency = 0.2 }) end)
        b.MouseLeave:Connect(function() Tween(b, 0.12, { BackgroundTransparency = 0 }) end)
        b.MouseButton1Click:Connect(function() if cb then cb() end end)
    end

    function P:Input(text, placeholder, default, cb)
        local c = Card(40)
        Label(c, text).Size = UDim2.new(0.35, 0, 1, 0)
        local box = New("TextBox", { Text = default or "", PlaceholderText = placeholder, Font = Enum.Font.Gotham, TextSize = 12,
            TextColor3 = T.Text, PlaceholderColor3 = T.Sub, BackgroundColor3 = T.Off, ClearTextOnFocus = false,
            TextTruncate = Enum.TextTruncate.AtEnd, Size = UDim2.new(0.65, -20, 0, 26),
            Position = UDim2.new(0.35, 8, 0.5, -13), Parent = c }, { Corner(6) })
        box.FocusLost:Connect(function() if cb then cb(box.Text) end end)
    end

    return P, select
end

-- ========== ฟังก์ชันหลัก (ใส่โค้ดของคุณตรงนี้) ==========
local function StartAutoFarm()
    task.spawn(function()
        while Config.AutoFarm do
            -- TODO: ใส่ logic Autofarm (ใช้ Config.FarmSpeed ได้)
            task.wait(0.1)
        end
    end)
end

local function StartAutoCollect()
    task.spawn(function()
        while Config.AutoCollect do
            -- TODO: ใส่ logic เก็บของ
            task.wait(0.5)
        end
    end)
end

local function StartAutoLoop()
    task.spawn(function()
        while Config.AutoLoop do
            -- TODO: ใส่ logic ที่ให้ทำซ้ำทุก Config.LoopDelay วินาที
            task.wait(Config.LoopDelay)
        end
    end)
end

local function SendWebhook(msg)
    if Config.WebhookUrl == "" then return Notify("Webhook", "ใส่ URL ก่อน") end
    local body = HttpService:JSONEncode({
        username = "DKHUB",
        embeds = {{ title = "DKHUB", description = msg, color = 8148223, timestamp = DateTime.now():ToIsoDate() }},
    })
    local req = (syn and syn.request) or http_request or request
    local ok, err = pcall(function()
        if req then
            req({ Url = Config.WebhookUrl, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
        else
            HttpService:PostAsync(Config.WebhookUrl, body)
        end
    end)
    Notify("Webhook", ok and "ส่งสำเร็จ ✔" or ("ผิดพลาด: " .. tostring(err)))
end

-- ========== TAB: MAIN ==========
local Main, selectMain = CreateTab("Main", "🏠")
Main:Section("Info")
Main:Label("ผู้เล่น: " .. LocalPlayer.Name)
Main:Label("Game ID: " .. tostring(game.PlaceId))
local fpsLabel = Main:Label("FPS: ...")
Main:Section("Quick Actions")
Main:Button("Copy Game ID", function()
    if setclipboard then setclipboard(tostring(game.PlaceId)); Notify("Main", "คัดลอกแล้ว") else Notify("Main", "executor ไม่รองรับ") end
end)

do -- FPS counter
    local frames, last = 0, os.clock()
    RunService.RenderStepped:Connect(function()
        frames += 1
        if os.clock() - last >= 1 then
            fpsLabel:Set("FPS: " .. frames)
            frames, last = 0, os.clock()
        end
    end)
end

-- ========== TAB: AUTOFARM ==========
local Farm = CreateTab("Autofarm", "🌾")
Farm:Section("Farm")
Farm:Toggle("Auto Farm", Config.AutoFarm, function(v) Config.AutoFarm = v; if v then StartAutoFarm() end end)
Farm:Toggle("Auto Collect", Config.AutoCollect, function(v) Config.AutoCollect = v; if v then StartAutoCollect() end end)
Farm:Slider("Farm Speed", 1, 100, Config.FarmSpeed, function(v) Config.FarmSpeed = v end)

-- ========== TAB: SETTING ==========
local Set = CreateTab("Setting", "⚙️")
Set:Section("General")
Set:Toggle("Anti AFK", Config.AntiAFK, function(v) Config.AntiAFK = v end)
Set:Label("ซ่อน/แสดง UI: กด RightShift")
Set:Section("Danger Zone")
Set:Button("Destroy UI", function() Config.AutoFarm, Config.AutoCollect, Config.AutoLoop = false, false, false; Gui:Destroy() end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    if not Config.AntiAFK then return end
    local ok, vu = pcall(function() return game:GetService("VirtualUser") end)
    if ok then vu:CaptureController(); vu:ClickButton2(Vector2.new()) end
end)

-- ========== TAB: AUTOMATION ==========
local Auto = CreateTab("Automation", "🤖")
Auto:Section("Loop")
Auto:Toggle("Auto Loop", Config.AutoLoop, function(v) Config.AutoLoop = v; if v then StartAutoLoop() end end)
Auto:Slider("Loop Delay (วินาที)", 1, 60, Config.LoopDelay, function(v) Config.LoopDelay = v end)
Auto:Section("Server")
Auto:Toggle("Auto Rejoin เมื่อหลุด", Config.AutoRejoin, function(v) Config.AutoRejoin = v end)

pcall(function()
    CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(c)
        if Config.AutoRejoin and c.Name == "ErrorPrompt" then
            task.wait(2)
            game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        end
    end)
end)

-- ========== TAB: WEBHOOK ==========
local Hook = CreateTab("Webhook", "🔔")
Hook:Section("Discord")
Hook:Input("Webhook URL", "https://discord.com/api/webhooks/...", Config.WebhookUrl, function(t) Config.WebhookUrl = t end)
Hook:Toggle("เปิดการแจ้งเตือน", Config.WebhookEnabled, function(v) Config.WebhookEnabled = v end)
Hook:Button("ส่งข้อความทดสอบ", function() SendWebhook("✅ ทดสอบ Webhook จาก " .. LocalPlayer.Name) end)

-- เปิดแท็บแรก
selectMain()
Notify("DKHUB", "โหลดสำเร็จ — กด RightShift เพื่อซ่อน")
