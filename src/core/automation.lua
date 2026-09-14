--[[
    Steal An Egg Hub - Core Automation Engine, Services & Auto Save System
    Manages background tasks, threads, and automatic JSON file persistence (Auto Save & Load).
--]]

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local CONFIG_FILE = "StealAnEgg_DKHUB_Config.json"

local Automation = {
    Running = true,
    IsUnloaded = false,
    Flags = {},
    Connections = {},
    Threads = {},
    Tasks = {},
    Settings = {},
    CleanupCallbacks = {}
}

-- Register an active thread/coroutine to be killed on unload
function Automation.RegisterThread(t)
    if t and typeof(t) == "thread" then
        table.insert(Automation.Threads, t)
    end
    return t
end

-- Register an active RBXScriptConnection to be disconnected on unload
function Automation.RegisterConnection(nameOrConn, conn)
    if typeof(nameOrConn) == "string" and conn then
        if Automation.Connections[nameOrConn] then
            pcall(function()
                if typeof(Automation.Connections[nameOrConn]) == "RBXScriptConnection" then
                    Automation.Connections[nameOrConn]:Disconnect()
                elseif typeof(Automation.Connections[nameOrConn]) == "table" and typeof(Automation.Connections[nameOrConn].Disconnect) == "function" then
                    Automation.Connections[nameOrConn]:Disconnect()
                end
            end)
        end
        Automation.Connections[nameOrConn] = conn
        return conn
    elseif nameOrConn then
        table.insert(Automation.Connections, nameOrConn)
        return nameOrConn
    end
end

-- Register a custom callback function to be executed when unloading
function Automation.RegisterCleanup(fn)
    if typeof(fn) == "function" then
        table.insert(Automation.CleanupCallbacks, fn)
    end
end

-- Auto Save Configuration to executor storage
function Automation.SaveConfig()
    if Automation.IsUnloaded then return end
    pcall(function()
        if writefile then
            local data = {
                Flags = Automation.Flags,
                Settings = Automation.Settings
            }
            writefile(CONFIG_FILE, HttpService:JSONEncode(data))
        end
    end)
end

-- Auto Load Configuration from executor storage on execute
function Automation.LoadConfig()
    pcall(function()
        if isfile and readfile and isfile(CONFIG_FILE) then
            local raw = readfile(CONFIG_FILE)
            if raw and #raw > 0 then
                local data = HttpService:JSONDecode(raw)
                if data then
                    if data.Flags then
                        for k, v in pairs(data.Flags) do
                            Automation.Flags[k] = v
                        end
                    end
                    if data.Settings then
                        for k, v in pairs(data.Settings) do
                            Automation.Settings[k] = v
                        end
                    end
                end
            end
        end
    end)
end

-- Start a named background task loop safely
function Automation.StartTask(taskName, loopFunction)
    if Automation.IsUnloaded or not Automation.Running then return end
    Automation.StopTask(taskName) -- Cancel existing thread if running
    Automation.Flags[taskName] = true
    Automation.SaveConfig()

    local t = task.spawn(function()
        while Automation.Running and not Automation.IsUnloaded and Automation.Flags[taskName] do
            local success, err = pcall(loopFunction)
            if not success then
                warn(string.format("[Automation:%s] Error: %s", taskName, tostring(err)))
                task.wait(1)
            end
            task.wait()
        end
    end)
    Automation.Tasks[taskName] = t
    Automation.RegisterThread(t)
    return t
end

-- Stop a running task loop
function Automation.StopTask(taskName)
    Automation.Flags[taskName] = false
    Automation.SaveConfig()
    if Automation.Tasks[taskName] then
        pcall(function()
            task.cancel(Automation.Tasks[taskName])
        end)
        Automation.Tasks[taskName] = nil
    end
end

-- Toggle a task on or off
function Automation.ToggleTask(taskName, enabled, loopFunction)
    if enabled then
        Automation.StartTask(taskName, loopFunction)
    else
        Automation.StopTask(taskName)
    end
end

-- Full Performance Mode (Cleans visual clutter, reduces memory & unlocks max FPS)
function Automation.FullPerformanceMode()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1

        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("BlurEffect") then
                v.Enabled = false
            end
        end

        local function cleanPart(part)
            if part:IsA("BasePart") then
                part.Material = Enum.Material.SmoothPlastic
                part.Reflectance = 0
                part.CastShadow = false
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 1
            elseif part:IsA("ParticleEmitter") or part:IsA("Trail") or part:IsA("Smoke") or part:IsA("Fire") or part:IsA("Sparkles") then
                part.Enabled = false
            end
        end

        for _, descendant in ipairs(workspace:GetDescendants()) do
            cleanPart(descendant)
        end

        Automation.RegisterConnection("FullPerf_DescendantAdded", workspace.DescendantAdded:Connect(function(child)
            if Automation.Flags and Automation.Flags.AutoFullPerf then
                task.defer(function()
                    cleanPart(child)
                end)
            end
        end))
    end)
end

-- Toggle 3D Game World Rendering (0% GPU usage for multi-instance farming)
function Automation.Toggle3DRendering(enabled)
    pcall(function()
        if typeof(RunService.Set3dRenderingEnabled) == "function" then
            RunService:Set3dRenderingEnabled(enabled)
        end
    end)
end

-- Master Clean Unload System
function Automation.Unload(UILibrary)
    if Automation.IsUnloaded then return end
    Automation.IsUnloaded = true
    Automation.Running = false

    print("[Steal An Egg Hub]: Clean Unload sequence initiated...")

    -- 1. Restore 3D Rendering if it was disabled
    pcall(function()
        Automation.Toggle3DRendering(true)
    end)

    -- 2. Execute custom cleanup callbacks
    for _, cleanupFn in ipairs(Automation.CleanupCallbacks) do
        pcall(cleanupFn)
    end
    table.clear(Automation.CleanupCallbacks)

    -- 3. Disconnect all registered connections
    for key, conn in pairs(Automation.Connections) do
        pcall(function()
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            elseif typeof(conn) == "table" and typeof(conn.Disconnect) == "function" then
                conn:Disconnect()
            end
        end)
    end
    table.clear(Automation.Connections)

    -- 4. Cancel all active background tasks and coroutines
    for _, t in pairs(Automation.Tasks) do
        pcall(function() task.cancel(t) end)
    end
    table.clear(Automation.Tasks)

    for _, t in ipairs(Automation.Threads) do
        pcall(function() task.cancel(t) end)
    end
    table.clear(Automation.Threads)

    -- 5. Destroy UI Library elements
    if UILibrary and UILibrary.ActiveWindow and typeof(UILibrary.ActiveWindow.Destroy) == "function" then
        pcall(function() UILibrary.ActiveWindow:Destroy() end)
    end

    local CoreGui = game:GetService("CoreGui")
    pcall(function()
        local h = CoreGui:FindFirstChild("StealAnEgg_DKHUB_Hub_Gui")
        if h then h:Destroy() end
        local n = CoreGui:FindFirstChild("StealAnEgg_DKHUB_Notif_Gui")
        if n then n:Destroy() end
    end)

    print("[Steal An Egg Hub]: Unloaded cleanly. Goodbye!")
end

return Automation
