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

        -- Utilise les positions manuelles
        if ManualTopPos and ManualBottomPos then
            -- Maintient le clic et bouge de haut en bas en boucle
            VirtualInputManager:SendMouseButtonEvent(ManualTopPos.X, ManualTopPos.Y, 0, true, game, 0)

            -- Mouvement de haut en bas
            for y = ManualTopPos.Y, ManualBottomPos.Y, 10 do
                VirtualInputManager:SendMouseMoveEvent(ManualTopPos.X, y, game)
                task.wait(0.002)
            end

            -- Mouvement de bas en haut
            for y = ManualBottomPos.Y, ManualTopPos.Y, -10 do
                VirtualInputManager:SendMouseMoveEvent(ManualTopPos.X, y, game)
                task.wait(0.002)
            end

            VirtualInputManager:SendMouseButtonEvent(ManualTopPos.X, ManualTopPos.Y, 0, false, game, 0)
        end
    end

    -- Fonction pour automatiser le minijeu Pour
    local function AutoPour()
        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        local ForgeGui = PlayerGui:FindFirstChild("Forge")
        if not ForgeGui then return end

        local PourMinigame = ForgeGui:FindFirstChild("PourMinigame")
        if not PourMinigame or not PourMinigame.Visible then return end

        -- Trouve la barre principale
        local Bar = PourMinigame:FindFirstChild("bar") or PourMinigame:FindFirstChild("Bar")
        if not Bar then return end

        -- Trouve la barre du joueur et la cible (bloc orange)
        local PlayerBar = Bar:FindFirstChild("playerbar") or Bar:FindFirstChild("PlayerBar")
        local TargetBar = Bar:FindFirstChild("target") or Bar:FindFirstChild("Target") or Bar:FindFirstChild("fish")

        -- Si on ne trouve pas les barres, cherche dans tous les enfants
        if not PlayerBar or not TargetBar then
            for _, child in Bar:GetDescendants() do
                if child:IsA("Frame") or child:IsA("ImageLabel") then
                    -- Cherche la barre orange/target
                    if child.BackgroundColor3 == Color3.fromRGB(255, 165, 0) or
                       child.Name:lower():find("target") or
                       child.Name:lower():find("orange") then
                        TargetBar = child
                    -- Cherche la barre du joueur
                    elseif child.Name:lower():find("player") then
                        PlayerBar = child
                    end
                end
            end
        end

        if PlayerBar and TargetBar then
            -- Utilise la technique du Lerp pour suivre la cible
            local UnfilteredTargetPosition = PlayerBar.Position:Lerp(TargetBar.Position, 0.7)
            local TargetPosition = UDim2.fromScale(
                math.clamp(UnfilteredTargetPosition.X.Scale, 0.15, 0.85),
                UnfilteredTargetPosition.Y.Scale
            )

            -- Déplace directement la barre du joueur
            PlayerBar.Position = TargetPosition
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
