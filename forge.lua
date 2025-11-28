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
    local HeaterConnection = nil
    local UserInputService = game:GetService("UserInputService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")

    -- Variables pour stocker les positions manuelles
    -- Positions enregistrées pour le minijeu (modifiables via les boutons)
    local ManualTopPos = Vector2.new(448, 558)
    local ManualBottomPos = Vector2.new(409, 1371)

    -- Fonction pour automatiser le minijeu Heater
    local function AutoHeater()
        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        local ForgeGui = PlayerGui:FindFirstChild("Forge")

        if not ForgeGui then return end

        local MeltMinigame = ForgeGui:FindFirstChild("MeltMinigame")
        if not MeltMinigame or not MeltMinigame.Visible then return end

        local Heater = MeltMinigame:FindFirstChild("Heater")
        if not Heater or not Heater.Visible then return end

        -- Utilise les positions manuelles si elles sont définies
        if ManualTopPos and ManualBottomPos then
            -- Commence par le haut (bouton vert) et maintient le clic
            VirtualInputManager:SendMouseButtonEvent(ManualTopPos.X, ManualTopPos.Y, 0, true, game, 0)

            -- Mouvement rapide de haut en bas (avec clic maintenu)
            for y = ManualTopPos.Y, ManualBottomPos.Y, 5 do
                VirtualInputManager:SendMouseMoveEvent(ManualTopPos.X, y, game)
                task.wait(0.001)
            end

            -- Mouvement rapide de bas en haut (avec clic maintenu)
            for y = ManualBottomPos.Y, ManualTopPos.Y, -5 do
                VirtualInputManager:SendMouseMoveEvent(ManualTopPos.X, y, game)
                task.wait(0.001)
            end

            -- Relâche le clic
            VirtualInputManager:SendMouseButtonEvent(ManualTopPos.X, ManualTopPos.Y, 0, false, game, 0)
        else
            -- Fallback sur la position calculée
            local baseX = Heater.AbsolutePosition.X + Heater.AbsoluteSize.X / 2
            local topY = Heater.AbsolutePosition.Y
            local bottomY = Heater.AbsolutePosition.Y + Heater.AbsoluteSize.Y

            VirtualInputManager:SendMouseButtonEvent(baseX, topY, 0, true, game, 0)

            for y = topY, bottomY, 5 do
                VirtualInputManager:SendMouseMoveEvent(baseX, y, game)
                task.wait(0.001)
            end

            for y = bottomY, topY, -5 do
                VirtualInputManager:SendMouseMoveEvent(baseX, y, game)
                task.wait(0.001)
            end

            VirtualInputManager:SendMouseButtonEvent(baseX, topY, 0, false, game, 0)
        end
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
                HeaterConnection = RunService.RenderStepped:Connect(function()
                    if not Toggles.AutoForgeToggle.Value then
                        AutoHeater()
                    end
                end)
            else
                -- Arrête la détection
                if HeaterConnection then
                    HeaterConnection:Disconnect()
                    HeaterConnection = nil
                end
            end
        end
    })
end

return ForgeModule
