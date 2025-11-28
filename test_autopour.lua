-- ============================================
-- TEST AUTO POUR - Script standalone pour tester
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

print("=== AUTO POUR TEST SCRIPT ===")
print("Ce script va automatiquement suivre le bloc orange dans le minijeu Pour")
print("Lance le minijeu Pour pour tester!")

local AutoPourConnection = nil

local function AutoPour()
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local ForgeGui = PlayerGui:FindFirstChild("Forge")
    if not ForgeGui then return end

    local PourMinigame = ForgeGui:FindFirstChild("PourMinigame")
    if not PourMinigame or not PourMinigame.Visible then return end

    -- Chemin exact pour le bloc orange (Pattern)
    local Frame = PourMinigame:FindFirstChild("Frame")
    if not Frame then
        print("❌ Frame non trouvé")
        return
    end

    local Area = Frame:FindFirstChild("Area")
    if not Area then
        print("❌ Area non trouvé")
        return
    end

    local Pattern = Area:FindFirstChild("Pattern")
    if not Pattern then
        print("❌ Pattern non trouvé")
        return
    end

    -- Force l'ImageLabel dans le Pattern (le bloc orange/target)
    local TargetBar = Pattern:FindFirstChildOfClass("ImageLabel")
    if not TargetBar then
        print("❌ TargetBar (ImageLabel dans Pattern) non trouvé")
        return
    end

    -- Chemin exact pour la barre du joueur (Line)
    local Line = Frame:FindFirstChild("Line")
    if not Line then
        print("❌ Line non trouvé")
        return
    end

    local PlayerBar = Line:FindFirstChild("ImageLabel")
    if not PlayerBar then
        print("❌ PlayerBar (ImageLabel dans Line) non trouvé")
        return
    end

    -- Déplace directement la barre du joueur sur le target
    PlayerBar.Position = TargetBar.Position

    -- Debug: affiche les positions (seulement une fois toutes les 60 frames)
    if tick() % 1 < 0.016 then
        print("✅ AutoPour actif - Target Y:", TargetBar.Position.Y.Scale, "Player Y:", PlayerBar.Position.Y.Scale)
    end
end

-- Démarre la boucle RenderStepped
AutoPourConnection = RunService.RenderStepped:Connect(function()
    AutoPour()
end)

print("✅ Script AUTO POUR démarré!")
print("Pour arrêter le script, tape dans la console: AutoPourConnection:Disconnect()")

-- Expose la connection globalement pour pouvoir l'arrêter
getgenv().AutoPourConnection = AutoPourConnection
