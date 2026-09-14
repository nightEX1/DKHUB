--[[
    Steal An Egg - Universal BAC-7517 Anti-Cheat & RemoteSpy Protector (Standalone)
    Execute this script BEFORE or WITH any RemoteSpy (SimpleSpy, Hydroxide, Potassium, etc.)
    Prevents BAC-7517 kicks, honeypot remotes, and metamethod hook detection.
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:FindFirstChildWhichIsA("Player")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BlockedRemotes = {
    ["ClientCharacter: IntegrityViolation"] = true,
    ["ClientCharacter: IntegrityHeartbeat"] = true,
    ["ClientCharacter: CorrectionStarted"] = true,
    ["Analytics:ReportAfkState"] = true,
    ["Analytics:RequestAfkTeleportFlush"] = true,
    ["Analytics:ReportAfkTeleport"] = true
}

local function isBlocked(name)
    if not name then return false end
    if BlockedRemotes[name] then return true end
    local lower = name:lower()
    if lower:find("integrity") or lower:find("violation") or lower:find("anticheat") or lower:find("honeypot") then
        return true
    end
    return false
end

-- 1. Hook LocalPlayer:Kick directly
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

-- 2. Clean __namecall Interceptor
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

-- 3. Disable BAC Client Runtimes safely
pcall(function()
    local ps = LocalPlayer:FindFirstChild("PlayerScripts")
    if ps then
        local gameFolder = ps:FindFirstChild("Game")
        if gameFolder then
            for _, s in ipairs(gameFolder:GetChildren()) do
                if s:IsA("LocalScript") and (s.Name:find("Runtime_") or s.Name:lower():find("anticheat")) then
                    s.Disabled = true
                    warn("[DKHUB BAC Protector]: Disabled runtime " .. s.Name)
                end
            end
        end
    end
end)

print("[DKHUB BAC Protector]: Standalone Shield Active (Zero Overhead).")
