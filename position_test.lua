-- ============================================
-- POSITION TEST - Script pour capturer les positions de souris
-- ============================================
-- Utilise ce script pour trouver les bonnes positions pour le minijeu

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Variables pour stocker les positions
local TopPosition = nil
local BottomPosition = nil
local isRecording = false

print("=== Position Test Script ===")
print("Appuie sur 'T' pour enregistrer la position TOP (haut)")
print("Appuie sur 'B' pour enregistrer la position BOTTOM (bas)")
print("Appuie sur 'P' pour afficher les positions enregistrées")
print("Appuie sur 'C' pour copier le code dans le clipboard")

-- Détection des touches
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    local mousePos = UserInputService:GetMouseLocation()

    if input.KeyCode == Enum.KeyCode.T then
        TopPosition = Vector2.new(mousePos.X, mousePos.Y)
        print("[TOP] Position enregistrée: X=" .. mousePos.X .. ", Y=" .. mousePos.Y)

    elseif input.KeyCode == Enum.KeyCode.B then
        BottomPosition = Vector2.new(mousePos.X, mousePos.Y)
        print("[BOTTOM] Position enregistrée: X=" .. mousePos.X .. ", Y=" .. mousePos.Y)

    elseif input.KeyCode == Enum.KeyCode.P then
        if TopPosition and BottomPosition then
            print("=== Positions enregistrées ===")
            print("TOP: X=" .. TopPosition.X .. ", Y=" .. TopPosition.Y)
            print("BOTTOM: X=" .. BottomPosition.X .. ", Y=" .. BottomPosition.Y)
            print("Distance: " .. (BottomPosition.Y - TopPosition.Y) .. " pixels")
        else
            print("Aucune position enregistrée!")
        end

    elseif input.KeyCode == Enum.KeyCode.C then
        if TopPosition and BottomPosition then
            local code = string.format([[
-- Positions enregistrées pour le minijeu
local ManualTopPos = Vector2.new(%d, %d)
local ManualBottomPos = Vector2.new(%d, %d)
]], TopPosition.X, TopPosition.Y, BottomPosition.X, BottomPosition.Y)

            print("=== Code à copier ===")
            print(code)

            -- Essaie de copier dans le clipboard
            if setclipboard then
                setclipboard(code)
                print("✓ Code copié dans le clipboard!")
            else
                print("⚠ Fonction setclipboard non disponible, copie manuellement le code ci-dessus")
            end
        else
            print("Enregistre d'abord les positions TOP et BOTTOM!")
        end
    end
end)

-- Test visuel en temps réel
task.spawn(function()
    while true do
        task.wait(0.1)
        local mousePos = UserInputService:GetMouseLocation()
        -- Affiche la position actuelle dans la console toutes les 0.1 secondes
        -- print("Position actuelle: X=" .. mousePos.X .. ", Y=" .. mousePos.Y)
    end
end)

print("Script chargé! Commence à enregistrer tes positions.")
