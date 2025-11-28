-- ============================================
-- UTILS.LUA - Fonctions utilitaires partagées
-- ============================================

local Utils = {}

-- Fonction pour obtenir ton personnage (cherche dans workspace.Living)
function Utils.GetCharacter()
    local player = game.Players.LocalPlayer
    return workspace.Living:FindFirstChild(player.Name)
end

-- Fonction pour décharger l'UI existante
function Utils.UnloadUI()
    if getgenv().Library then
        -- Détruit la fenêtre si elle existe
        if getgenv().Library.Unload then
            getgenv().Library:Unload()
        end

        -- Nettoie les variables globales
        getgenv().Library = nil
        getgenv().Options = nil
        getgenv().Toggles = nil
    end

    -- Détruit tous les ScreenGuis créés par le script (au cas où)
    for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
        if gui:IsA("ScreenGui") and (gui.Name:find("Linoria") or gui.Name:find("mspaint")) then
            gui:Destroy()
        end
    end
end

return Utils
