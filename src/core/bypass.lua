--[[
    Steal An Egg Hub - Unified Clean Anti-Cheat Shield & Stealth Logger
    Zero lag, O(1) hashmap checks, no recursion, and unified RemoteSpy support.
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:FindFirstChildWhichIsA("Player")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Bypass = {}

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

function Bypass.Init()
    local gEnv = (typeof(getgenv) == "function" and getgenv()) or _G
    if gEnv._DKHUBBypassActive then return end
    gEnv._DKHUBBypassActive = true
    gEnv._DKHUBRemoteLogs = gEnv._DKHUBRemoteLogs or {}

    -- 1. Direct LocalPlayer.Kick neutralization
    pcall(function()
        if typeof(hookfunction) == "function" and LocalPlayer then
            local oldKick
            oldKick = hookfunction(LocalPlayer.Kick, newcclosure(function(self, ...)
                if self == LocalPlayer then
                    warn("[DKHUB Shield]: Blocked LocalPlayer:Kick() call")
                    return nil
                end
                return oldKick(self, ...)
            end))
        end
    end)

    -- 2. Single Unified __namecall Interceptor
    pcall(function()
        if typeof(hookmetamethod) == "function" then
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()

                -- Block client-side Kick
                if (method == "Kick" or method == "kick") and self == LocalPlayer then
                    warn("[DKHUB Shield]: Blocked Kick via __namecall")
                    return nil
                end

                -- Filter & Log Remotes
                if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
                    local name = self.Name
                    if isBlocked(name) then
                        return nil
                    end

                    -- If Stealth Remote Spy is enabled
                    if gEnv._DKHUBLogRemotes then
                        pcall(function()
                            local logList = gEnv._DKHUBRemoteLogs
                            if logList then
                                local entry = string.format("[%s] %s:%s()", os.date("%X"), self:GetFullName(), method)
                                table.insert(logList, 1, entry)
                                if #logList > 100 then table.remove(logList) end
                            end
                        end)
                    end
                end

                return oldNamecall(self, ...)
            end))
        end
    end)

    -- 3. Disable game runtime anti-cheat scripts safely
    task.defer(function()
        pcall(function()
            local ps = LocalPlayer:FindFirstChild("PlayerScripts")
            if ps then
                local gameFolder = ps:FindFirstChild("Game")
                if gameFolder then
                    for _, s in ipairs(gameFolder:GetChildren()) do
                        if s:IsA("LocalScript") and s.Name:find("Runtime_") then
                            s.Disabled = true
                        end
                    end
                end
            end
        end)
    end)

    print("[DKHUB Shield]: Unified Anti-Cheat Shield active.")
end

return Bypass
