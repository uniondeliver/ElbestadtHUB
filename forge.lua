-- ============================================
-- FORGE.LUA - Module pour open forge et auto forge
-- ============================================

local ForgeModule = {}

function ForgeModule.Setup(groupbox, autoGroupbox, Options, Toggles, Library)
    local Utils = getgenv().Utils

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local MinigameConnection = nil
    local AutoForgeEnabled = false

    -- ============================================
    -- HELPER FUNCTIONS
    -- ============================================

    local function getForgeGui()
        local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
        return PlayerGui and PlayerGui:FindFirstChild("Forge")
    end

    local function simulateClick(x, y)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait(0.03)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end

    -- ============================================
    -- FORGE BUTTONS
    -- ============================================

    groupbox:AddButton({
        Text = "Open Forge",
        Func = function()
            local forge = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Forge")
            if not forge then return end

            local prompt = forge:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            else
                pcall(function()
                    ReplicatedStorage.Shared.Packages.Knit.Services.ForgeService.RF.StartForge:InvokeServer(forge)
                end)
            end
        end,
        Tooltip = "Ouvre la forge de n'importe où"
    })

    groupbox:AddButton({
        Text = "Open Marbles (seller)",
        Func = function()
            local marbles = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Marbles")
            if not marbles then return end

            local prompt = marbles:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            else
                pcall(function()
                    ReplicatedStorage.Shared.Packages.Knit.Services.ProximityService.RF.Dialogue:InvokeServer(marbles)
                end)
            end
        end,
        Tooltip = "Vendre de n'importe où"
    })

    -- ============================================
    -- AUTO MINIGAMES
    -- ============================================

    local ChangeSequence = ReplicatedStorage.Shared.Packages.Knit.Services.ForgeService.RF.ChangeSequence

    local MeltSkipped = false
    local PourSkipped = false

    local function AutoForge()
        if not AutoForgeEnabled then return end

        local ForgeGui = getForgeGui()
        if not ForgeGui then
            MeltSkipped = false
            PourSkipped = false
            return
        end

        -- AUTO MELT
        local MeltMinigame = ForgeGui:FindFirstChild("MeltMinigame")
        if MeltMinigame and MeltMinigame.Visible then
            if not MeltSkipped then
                MeltSkipped = true
                task.wait(0.1)
                pcall(function()
                    ChangeSequence:InvokeServer("Pour", {ClientTime = tick()})
                end)
            end
            return
        else
            MeltSkipped = false
        end

        -- AUTO POUR
        local PourMinigame = ForgeGui:FindFirstChild("PourMinigame")
        if PourMinigame and PourMinigame.Visible then
            if not PourSkipped then
                PourSkipped = true
                task.wait(0.1)
                pcall(function()
                    ChangeSequence:InvokeServer("Hammer", {ClientTime = tick()})
                end)
            end
            return
        else
            PourSkipped = false
        end

        -- AUTO HAMMER
        local HammerMinigame = ForgeGui:FindFirstChild("HammerMinigame")
        if HammerMinigame and HammerMinigame.Visible then
            local ClickArea = HammerMinigame:FindFirstChild("ClickArea") or HammerMinigame
            local posX = ClickArea.AbsolutePosition.X + ClickArea.AbsoluteSize.X / 2
            local posY = ClickArea.AbsolutePosition.Y + ClickArea.AbsoluteSize.Y / 2
            simulateClick(posX, posY)
        end
    end

    -- ============================================
    -- UI CONTROLS
    -- ============================================

    local AutoForgeToggle = autoGroupbox:AddToggle("AutoForgeToggle", {
        Text = "Auto Complete Minigames",
        Default = false,
        Tooltip = "Complète automatiquement les minijeux",
        Callback = function(Value)
            AutoForgeEnabled = Value

            if Value then
                MinigameConnection = RunService.RenderStepped:Connect(AutoForge)
            else
                if MinigameConnection then
                    MinigameConnection:Disconnect()
                    MinigameConnection = nil
                end
                MeltSkipped = false
                PourSkipped = false
            end
        end
    })

    AutoForgeToggle:AddKeyPicker("AutoForgeKeybind", {
        Text = "Auto Forge",
        Default = "F",
        Mode = "Toggle",
        SyncToggleState = true
    })
end

return ForgeModule
