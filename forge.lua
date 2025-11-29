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
    local MeltInProgress = false
    local PourInProgress = false
    local HammerInProgress = false

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
    -- AUTO MINIGAMES (INSTANT SKIP)
    -- ============================================

    local function AutoMelt()
        if MeltInProgress then return end

        local ForgeGui = getForgeGui()
        if not ForgeGui then return end

        local MeltMinigame = ForgeGui:FindFirstChild("MeltMinigame")
        if not MeltMinigame or not MeltMinigame.Visible then return end

        MeltInProgress = true

        -- Skip instantanément vers Pour
        pcall(function()
            local ChangeSequence = ReplicatedStorage.Shared.Packages.Knit.Services.ForgeService.RF.ChangeSequence
            ChangeSequence:InvokeServer("Pour")
        end)

        task.wait(0.2)
        MeltInProgress = false
    end

    local function AutoPour()
        if PourInProgress then return end

        local ForgeGui = getForgeGui()
        if not ForgeGui then return end

        local PourMinigame = ForgeGui:FindFirstChild("PourMinigame")
        if not PourMinigame or not PourMinigame.Visible then return end

        PourInProgress = true

        -- Skip instantanément vers Hammer
        pcall(function()
            local ChangeSequence = ReplicatedStorage.Shared.Packages.Knit.Services.ForgeService.RF.ChangeSequence
            ChangeSequence:InvokeServer("Hammer")
        end)

        task.wait(0.2)
        PourInProgress = false
    end

    local function AutoHammer()
        if HammerInProgress then return end

        local ForgeGui = getForgeGui()
        if not ForgeGui then return end

        local HammerMinigame = ForgeGui:FindFirstChild("HammerMinigame")
        if not HammerMinigame or not HammerMinigame.Visible then return end

        HammerInProgress = true

        local ClickArea = HammerMinigame:FindFirstChild("ClickArea") or HammerMinigame
        local posX = ClickArea.AbsolutePosition.X + ClickArea.AbsoluteSize.X / 2
        local posY = ClickArea.AbsolutePosition.Y + ClickArea.AbsoluteSize.Y / 2

        simulateClick(posX, posY)

        task.wait(0.05)
        HammerInProgress = false
    end

    -- ============================================
    -- UI CONTROLS
    -- ============================================

    local AutoForgeToggle = autoGroupbox:AddToggle("AutoForgeToggle", {
        Text = "Auto Complete Minigames",
        Default = false,
        Tooltip = "Complète automatiquement les minijeux",
        Callback = function(Value)
            if Value then
                MinigameConnection = RunService.RenderStepped:Connect(function()
                    AutoMelt()
                    AutoPour()
                    AutoHammer()
                end)
            else
                if MinigameConnection then
                    MinigameConnection:Disconnect()
                    MinigameConnection = nil
                end
                -- Reset les flags
                MeltInProgress = false
                PourInProgress = false
                HammerInProgress = false
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
