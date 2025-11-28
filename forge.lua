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
    -- AUTO MINIGAMES
    -- ============================================

    local function AutoMelt()
        if MeltInProgress then return end

        local ForgeGui = getForgeGui()
        if not ForgeGui then return end

        local MeltMinigame = ForgeGui:FindFirstChild("MeltMinigame")
        if not MeltMinigame or not MeltMinigame.Visible then return end

        local Heater = MeltMinigame:FindFirstChild("Heater")
        if not Heater or not Heater.Visible then return end

        local TopButton = Heater:FindFirstChild("Top")
        if not TopButton then return end

        MeltInProgress = true

        -- Position du bouton Top (ajusté 8px plus bas)
        local centerX = TopButton.AbsolutePosition.X + TopButton.AbsoluteSize.X / 2
        local topY = TopButton.AbsolutePosition.Y + TopButton.AbsoluteSize.Y / 2 + 50

        local dragDistance = 150

        -- Clique et maintient sur Top
        VirtualInputManager:SendMouseButtonEvent(centerX, topY, 0, true, game, 0)
        task.wait(0.05)

        -- Drag lent vers le bas
        for y = topY, topY + dragDistance, 5 do
            VirtualInputManager:SendMouseMoveEvent(centerX, y, game)
            task.wait(0.02)
        end

        -- Drag lent vers le haut
        for y = topY + dragDistance, topY - dragDistance, -5 do
            VirtualInputManager:SendMouseMoveEvent(centerX, y, game)
            task.wait(0.02)
        end

        -- Retour au centre
        for y = topY - dragDistance, topY, 5 do
            VirtualInputManager:SendMouseMoveEvent(centerX, y, game)
            task.wait(0.02)
        end

        -- Relâche
        VirtualInputManager:SendMouseButtonEvent(centerX, topY, 0, false, game, 0)

        MeltInProgress = false
    end

    local function AutoPour()
        local ForgeGui = getForgeGui()
        if not ForgeGui then return end

        local PourMinigame = ForgeGui:FindFirstChild("PourMinigame")
        if not PourMinigame or not PourMinigame.Visible then return end

        local Frame = PourMinigame:FindFirstChild("Frame")
        if not Frame then return end

        local Area = Frame:FindFirstChild("Area")
        local Line = Frame:FindFirstChild("Line")
        if not Area or not Line then return end

        local Pattern = Area:FindFirstChild("Pattern")
        if not Pattern then return end

        local TargetBar = Pattern:FindFirstChildOfClass("ImageLabel")
        local PlayerBar = Line:FindFirstChildOfClass("ImageLabel")

        if PlayerBar and TargetBar then
            PlayerBar.Position = TargetBar.Position
        end
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