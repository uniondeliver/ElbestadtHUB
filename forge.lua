-- ============================================
-- FORGE.LUA - Module pour open forge et auto forge
-- ============================================

local ForgeModule = {}

-- Setup du module Forge
function ForgeModule.Setup(groupbox, autoGroupbox, Options, Toggles, Library)
    -- Récupère Utils depuis getgenv (chargé dans main.lua)
    local Utils = getgenv().Utils

    -- ============================================
    -- FORGE BUTTONS
    -- ============================================

    -- Bouton pour ouvrir la forge de n'importe où
    groupbox:AddButton({
        Text = "Open Forge",
        Func = function()
            local forge = workspace:WaitForChild("Proximity"):WaitForChild("Forge")
            local prompt = forge:FindFirstChildOfClass("ProximityPrompt")

            if prompt then
                fireproximityprompt(prompt)
            else
                local args = {forge}
                game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ForgeService"):WaitForChild("RF"):WaitForChild("StartForge"):InvokeServer(unpack(args))
            end
        end,
        DoubleClick = false,
        Tooltip = "Ouvre la forge de n'importe où"
    })

    -- Bouton pour ouvrir le menu de Marbles
    groupbox:AddButton({
        Text = "Open Marbles (seller)",
        Func = function()
            local Marbles = workspace:WaitForChild("Proximity"):WaitForChild("Marbles")
            local prompt = Marbles:FindFirstChildOfClass("ProximityPrompt")

            if prompt then
                fireproximityprompt(prompt)
            else
                local args = {Marbles}
                game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ProximityService"):WaitForChild("RF"):WaitForChild("Dialogue"):InvokeServer(unpack(args))
            end
        end,
        DoubleClick = false,
        Tooltip = "Vendre de n'importe où"
    })

    -- ============================================
    -- AUTO FORGE
    -- ============================================

    -- Variables pour l'auto forge
    local MinigameConnection = nil
    local UserInputService = game:GetService("UserInputService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")

    -- Variables pour stocker les positions manuelles pour Melt
    local ManualTopPos = Vector2.new(448, 558)
    local ManualBottomPos = Vector2.new(409, 1371)

    -- Fonction pour automatiser le minijeu Melt (Heater)
    local function AutoMelt()
        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        local ForgeGui = PlayerGui:FindFirstChild("Forge")
        if not ForgeGui then return end

        local MeltMinigame = ForgeGui:FindFirstChild("MeltMinigame")
        if not MeltMinigame or not MeltMinigame.Visible then return end

        local Heater = MeltMinigame:FindFirstChild("Heater")
        if not Heater or not Heater.Visible then return end

        -- Trouve le bouton Top (bouton vert)
        local TopButton = Heater:FindFirstChild("Top")
        if not TopButton then return end

        -- Calcule la position du bouton Top
        local topX = TopButton.AbsolutePosition.X + TopButton.AbsoluteSize.X / 2
        local topY = TopButton.AbsolutePosition.Y + TopButton.AbsoluteSize.Y / 2

        -- Position du bas (bas du Heater)
        local bottomY = Heater.AbsolutePosition.Y + Heater.AbsoluteSize.Y

        -- Clique et maintient sur le bouton Top
        VirtualInputManager:SendMouseButtonEvent(topX, topY, 0, true, game, 0)

        -- Mouvement de haut en bas (reste appuyé)
        for y = topY, bottomY, 10 do
            VirtualInputManager:SendMouseMoveEvent(topX, y, game)
            task.wait(0.002)
        end

        -- Mouvement de bas en haut (reste appuyé)
        for y = bottomY, topY, -10 do
            VirtualInputManager:SendMouseMoveEvent(topX, y, game)
            task.wait(0.002)
        end

        -- Relâche le clic
        VirtualInputManager:SendMouseButtonEvent(topX, topY, 0, false, game, 0)
    end

    -- Fonction pour automatiser le minijeu Pour
    local function AutoPour()
        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        local ForgeGui = PlayerGui:FindFirstChild("Forge")
        if not ForgeGui then return end

        local PourMinigame = ForgeGui:FindFirstChild("PourMinigame")
        if not PourMinigame or not PourMinigame.Visible then return end

        -- Chemin exact pour le bloc orange (Pattern)
        local Frame = PourMinigame:FindFirstChild("Frame")
        if not Frame then return end

        local Area = Frame:FindFirstChild("Area")
        if not Area then return end

        local Pattern = Area:FindFirstChild("Pattern")
        if not Pattern then return end

        -- Force l'ImageLabel dans le Pattern (le bloc orange/target)
        local TargetBar = Pattern:FindFirstChildOfClass("ImageLabel")

        -- Chemin exact pour la barre du joueur (Line)
        local Line = Frame:FindFirstChild("Line")
        if not Line then return end

        local PlayerBar = Line:FindFirstChild("ImageLabel")

        if PlayerBar and TargetBar then
            -- Déplace directement la barre du joueur sur le target
            PlayerBar.Position = TargetBar.Position
        end
    end

    -- Fonction pour automatiser le minijeu Hammer
    local function AutoHammer()
        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        local ForgeGui = PlayerGui:FindFirstChild("Forge")
        if not ForgeGui then return end

        local HammerMinigame = ForgeGui:FindFirstChild("HammerMinigame")
        if not HammerMinigame or not HammerMinigame.Visible then return end

        -- Trouve la zone à cliquer
        local ClickArea = HammerMinigame:FindFirstChild("ClickArea") or HammerMinigame

        local posX = ClickArea.AbsolutePosition.X + ClickArea.AbsoluteSize.X / 2
        local posY = ClickArea.AbsolutePosition.Y + ClickArea.AbsoluteSize.Y / 2

        -- Clique rapidement
        VirtualInputManager:SendMouseButtonEvent(posX, posY, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(posX, posY, 0, false, game, 0)
    end

    -- Fonction principale qui détecte et exécute le bon minijeu
    local function AutoMinigame()
        AutoMelt()
        AutoPour()
        AutoHammer()
    end

    -- Bouton pour définir la position TOP (haut)
    autoGroupbox:AddButton({
        Text = "Set TOP Position",
        Func = function()
            local mousePos = UserInputService:GetMouseLocation()
            ManualTopPos = Vector2.new(mousePos.X, mousePos.Y)
            Library:Notify("TOP position enregistrée: " .. tostring(mousePos), 3)
        end,
        DoubleClick = false,
        Tooltip = "Clique pour enregistrer la position HAUTE de la souris"
    })

    -- Bouton pour définir la position BOTTOM (bas)
    autoGroupbox:AddButton({
        Text = "Set BOTTOM Position",
        Func = function()
            local mousePos = UserInputService:GetMouseLocation()
            ManualBottomPos = Vector2.new(mousePos.X, mousePos.Y)
            Library:Notify("BOTTOM position enregistrée: " .. tostring(mousePos), 3)
        end,
        DoubleClick = false,
        Tooltip = "Clique pour enregistrer la position BASSE de la souris"
    })

    -- Bouton pour reset les positions manuelles
    autoGroupbox:AddButton({
        Text = "Reset Positions",
        Func = function()
            ManualTopPos = nil
            ManualBottomPos = nil
            Library:Notify("Positions réinitialisées", 3)
        end,
        DoubleClick = false,
        Tooltip = "Réinitialise les positions manuelles"
    })

    -- Toggle pour auto-compléter les minijeux
    autoGroupbox:AddToggle("AutoForgeToggle", {
        Text = "Auto Complete Minigames",
        Default = false,
        Tooltip = "Complète automatiquement les minijeux quand tu les lances",
        Callback = function(Value)
            -- Logique inversée: Value = false signifie activé
            if not Value then
                -- Démarre la détection automatique des minijeux
                MinigameConnection = RunService.RenderStepped:Connect(function()
                    if not Toggles.AutoForgeToggle.Value then
                        AutoMinigame()
                    end
                end)
            else
                -- Arrête la détection
                if MinigameConnection then
                    MinigameConnection:Disconnect()
                    MinigameConnection = nil
                end
            end
        end
    })
end

return ForgeModule
