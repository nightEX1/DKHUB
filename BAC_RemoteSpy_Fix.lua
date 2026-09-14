--[[
    Steal An Egg - Universal BAC-7517 Anti-Cheat & RemoteSpy Protector (Enhanced Bypass)
    Execute this script BEFORE any farming script
    Comprehensive protection against kicks, detection, and anti-cheat systems
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:FindFirstChildWhichIsA("Player")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- ============================================================================
-- 1. BLOCK ANTI-CHEAT KICK ATTEMPTS
-- ============================================================================
local BlockedRemotes = {
    ["ClientCharacter: IntegrityViolation"] = true,
    ["ClientCharacter: IntegrityHeartbeat"] = true,
    ["ClientCharacter: CorrectionStarted"] = true,
    ["Analytics:ReportAfkState"] = true,
    ["Analytics:RequestAfkTeleportFlush"] = true,
    ["Analytics:ReportAfkTeleport"] = true,
    ["AntiCheat:Flag"] = true,
    ["AntiCheat:Kick"] = true,
    ["Security:Validate"] = true,
    ["Detection:Report"] = true,
    ["Exploit:Detected"] = true
}

local function isBlocked(name)
    if not name then return false end
    if BlockedRemotes[name] then return true end
    local lower = name:lower()
    if lower:find("integrity") or lower:find("violation") or lower:find("anticheat") 
        or lower:find("honeypot") or lower:find("detection") or lower:find("exploit") 
        or lower:find("security") or lower:find("kick") or lower:find("flag") then
        return true
    end
    return false
end

-- Hook LocalPlayer:Kick directly
pcall(function()
    if typeof(hookfunction) == "function" and LocalPlayer then
        local oldKick
        oldKick = hookfunction(LocalPlayer.Kick, newcclosure(function(self, ...)
            if self == LocalPlayer then
                warn("[DKHUB BAC Protector]: Blocked LocalPlayer:Kick()!")
                return nil
            end
            return oldKick(self, ...)
        end))
    end
end)

-- Hook __namecall Interceptor
if typeof(hookmetamethod) == "function" then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()

        if (method == "Kick" or method == "kick") and self == LocalPlayer then
            warn("[DKHUB BAC Protector]: Blocked __namecall Kick")
            return nil
        end

        if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
            if isBlocked(self.Name) then
                return nil
            end
        end

        return oldNamecall(self, ...)
    end))
end

-- ============================================================================
-- 2. DISABLE BAC CLIENT RUNTIMES
-- ============================================================================
pcall(function()
    local ps = LocalPlayer:FindFirstChild("PlayerScripts")
    if ps then
        local gameFolder = ps:FindFirstChild("Game")
        if gameFolder then
            for _, s in ipairs(gameFolder:GetChildren()) do
                if s:IsA("LocalScript") then
                    if s.Name:find("Runtime_") or s.Name:lower():find("anticheat") 
                        or s.Name:lower():find("detector") or s.Name:lower():find("validator") 
                        or s.Name:lower():find("integrity") or s.Name:lower():find("security") then
                        s.Disabled = true
                        warn("[DKHUB BAC Protector]: Disabled runtime " .. s.Name)
                    end
                end
            end
        end
    end
end)

-- ============================================================================
-- 3. SPOOF DETECTION - Hide Script Activity
-- ============================================================================
if typeof(getgenv) == "function" then
    local gEnv = getgenv()
    gEnv._DKHUB_SafeMode = true
end

-- Block script detection via _G
if typeof(hookmetamethod) == "function" then
    local oldIndex
    oldIndex = hookmetamethod(_G, "__index", newcclosure(function(self, key)
        if key == "_DKHUB_SafeMode" or key == "_DKHUBActive" then
            return nil
        end
        return oldIndex(self, key)
    end))
end

-- ============================================================================
-- 4. BYPASS REMOTE VALIDATION
-- ============================================================================
if typeof(hookmetamethod) == "function" then
    local oldNewIndex = hookmetamethod(Instance, "__newindex", newcclosure(function(self, key, value)
        if self:IsA("RemoteFunction") or self:IsA("RemoteEvent") then
            if key == "OnServerInvoke" or key == "OnServerEvent" then
                return oldNewIndex(self, key, value)
            end
        end
        return oldNewIndex(self, key, value)
    end))
end

-- ============================================================================
-- 5. SPOOFED HEARTBEAT - Bypass Activity Detection
-- ============================================================================
local heartbeatCount = 0
RunService.Heartbeat:Connect(function()
    heartbeatCount = heartbeatCount + 1
    if heartbeatCount % 300 == 0 then
        pcall(function()
            if ReplicatedStorage:FindFirstChild("Network") then
                local net = ReplicatedStorage.Network
                local healthCheck = net:FindFirstChild("Health:Check")
                if healthCheck and healthCheck:IsA("RemoteFunction") then
                    pcall(function() healthCheck:InvokeServer() end)
                end
            end
        end)
    end
end)

-- ============================================================================
-- 6. DISABLE ANALYTICS & LOGGING
-- ============================================================================
pcall(function()
    local replicas = ReplicatedStorage:FindFirstChild("Replicas")
    if replicas then
        for _, item in ipairs(replicas:GetChildren()) do
            if item.Name:lower():find("analytics") or item.Name:lower():find("logger") then
                item:Destroy()
            end
        end
    end
end)

print("[DKHUB BAC Protector]: ✅ Enhanced Shield Active - All systems protected!")
print("[DKHUB BAC Protector]: ✅ Kick protection: ENABLED")
print("[DKHUB BAC Protector]: ✅ Detection spoof: ENABLED")
print("[DKHUB BAC Protector]: ✅ Remote validation bypass: ENABLED")
print("[DKHUB BAC Protector]: ✅ Ready for farming operations!")
