-- ============================================
-- FORGE.LUA - Module pour open forge et auto forge
-- ============================================

local ForgeModule = {}

function ForgeModule.Setup(groupbox, autoGroupbox, Options, Toggles, Library)
local Utils = getgenv().Utils

    -- NOUVEAU: Services requis
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TweenService = game:GetService("TweenService") -- NOUVEAU
    local HttpService = game:GetService("HttpService")
    local MinigameConnection = nil
    local MeltInProgress = false
    local HammerInProgress = false
    local PourInProgress = false -- NOUVEAU: Flag pour AutoPour

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
    -- (Inchangé)
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
        -- NOTE: On suppose que "Bottom" existe pour la position basse.
        local BottomButton = Heater:FindFirstChild("Bottom") 

        if not TopButton then return end

        MeltInProgress = true

        -- Position du bouton Top et Bottom (si Bottom n'existe pas, on revient à l'ancienne valeur)
        local centerX = TopButton.AbsolutePosition.X + TopButton.AbsoluteSize.X / 2
        local topY = TopButton.AbsolutePosition.Y + TopButton.AbsoluteSize.Y / 2
        local bottomY = BottomButton and (BottomButton.AbsolutePosition.Y + BottomButton.AbsoluteSize.Y / 2) or (topY + 150)

        -- Clique et maintient sur Top
        VirtualInputManager:SendMouseButtonEvent(centerX, topY, 0, true, game, 0)
        task.wait(0.03)

        -- Pattern: Top → Bas → Top → Bas → Top → Bas (3 cycles)
        for i = 1, 3 do
            -- "Saute" en bas (Mouvement rapide)
            VirtualInputManager:SendMouseMoveEvent(centerX, bottomY, game)
            task.wait(0.05) -- Délai en bas

            -- "Saute" en haut
            VirtualInputManager:SendMouseMoveEvent(centerX, topY, game)
            task.wait(0.05) -- Délai en haut
        end

        -- Relâche
        VirtualInputManager:SendMouseButtonEvent(centerX, topY, 0, false, game, 0)

        MeltInProgress = false
    end

    local function AutoPour()
        if PourInProgress then return end -- NOUVEAU

        local ForgeGui = getForgeGui()
        if not ForgeGui then 
            PourInProgress = false
            return 
        end

        local PourMinigame = ForgeGui:FindFirstChild("PourMinigame")
        if not PourMinigame or not PourMinigame.Visible then 
            PourInProgress = false
            return 
        end

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
            PourInProgress = true -- Bloque l'exécution

            -- NOUVEAU: Utilise TweenService pour simuler un mouvement rapide mais non instantané
            local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear) 
            local goal = { Position = TargetBar.Position }
            local tween = TweenService:Create(PlayerBar, tweenInfo, goal)
            tween:Play()
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

        -- NOUVEAU: Ajout du Jitter (variation aléatoire) pour moins de détection
        local jitterX = math.random(-10, 10)
        local jitterY = math.random(-10, 10)

        local posX = ClickArea.AbsolutePosition.X + ClickArea.AbsoluteSize.X / 2 + jitterX
        local posY = ClickArea.AbsolutePosition.Y + ClickArea.AbsoluteSize.Y / 2 + jitterY

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
                PourInProgress = false -- NOUVEAU: Reset du flag AutoPour
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