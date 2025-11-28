-- ============================================
-- FORGE.LUA - Module pour open forge et auto forge
-- ============================================

local ForgeModule = {}

-- Setup du module Forge
function ForgeModule.Setup(groupbox, autoGroupbox, Options, Toggles)
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
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")

    -- Fonction pour automatiser le minijeu Heater
    local function AutoHeater()
        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        local ForgeGui = PlayerGui:FindFirstChild("Forge")

        if not ForgeGui then return end

        local MeltMinigame = ForgeGui:FindFirstChild("MeltMinigame")
        if not MeltMinigame or not MeltMinigame.Visible then return end

        local Heater = MeltMinigame:FindFirstChild("Heater")
        if not Heater or not Heater.Visible then return end

        -- Simule mouvement souris bas vers haut rapidement
        local baseX = Heater.AbsolutePosition.X + Heater.AbsoluteSize.X / 2
        local topY = Heater.AbsolutePosition.Y
        local bottomY = Heater.AbsolutePosition.Y + Heater.AbsoluteSize.Y

        -- Mouvement rapide de bas en haut
        for y = bottomY, topY, -5 do
            VirtualInputManager:SendMouseMoveEvent(baseX, y, game)
            task.wait(0.001)
        end

        -- Mouvement rapide de haut en bas
        for y = topY, bottomY, 5 do
            VirtualInputManager:SendMouseMoveEvent(baseX, y, game)
            task.wait(0.001)
        end
    end

    -- Toggle pour auto-compléter les minijeux
    autoGroupbox:AddToggle("AutoForgeToggle", {
        Text = "Auto Complete Minigames",
        Default = false,
        Tooltip = "Complète automatiquement les minijeux quand tu les lances",
        Callback = function(Value)
            if Value then
                -- Démarre la détection automatique des minijeux
                HeaterConnection = RunService.RenderStepped:Connect(function()
                    if Toggles.AutoForgeToggle.Value then
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
