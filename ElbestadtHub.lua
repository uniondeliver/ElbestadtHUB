-- ============================================
-- ELBESTADT HUB - Script complet en un seul fichier
-- ============================================
-- Version: 1.0.0
-- Auteur: uniondeliver
-- GitHub: https://github.com/uniondeliver/ElbestadtHUB

-- ============================================
-- UTILS
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
        if getgenv().Library.Unload then
            getgenv().Library:Unload()
        end
        getgenv().Library = nil
        getgenv().Options = nil
        getgenv().Toggles = nil
    end

    for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
        if gui:IsA("ScreenGui") and (gui.Name:find("Linoria") or gui.Name:find("mspaint")) then
            gui:Destroy()
        end
    end
end

-- Décharge l'ancienne UI
pcall(Utils.UnloadUI)

-- ============================================
-- CHARGEMENT LINORIA
-- ============================================

local linoriaRepo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(linoriaRepo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(linoriaRepo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(linoriaRepo .. "addons/SaveManager.lua"))()

getgenv().Library = Library

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

-- ============================================
-- CRÉATION FENÊTRE
-- ============================================

local Window = Library:CreateWindow({
    Title = "Elbestadt Hub",
    Footer = "version: 1.0.0",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Home = Window:AddTab("Home", "house"),
    Main = Window:AddTab("Main", "menu"),
    Player = Window:AddTab("Player","user"),
    Purchases = Window:AddTab("Purchases", "dollar-sign"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- ============================================
-- VARIABLES GLOBALES
-- ============================================

local HumanModCons = {}
local normalWalkSpeed = 16
local normalJumpPower = 50

-- ============================================
-- TAB PLAYER - MOVEMENTS
-- ============================================

local PlayerTab = Tabs.Player
local MovementsGroup = PlayerTab:AddLeftGroupbox("Movements")

-- WalkSpeed Toggle
MovementsGroup:AddToggle("WalkspeedToggle", {
    Text = "Enable WalkSpeed",
    Default = false,
    Tooltip = "Active ou désactive la modification de vitesse",
    Callback = function(Value)
        if Value then
            local character = Utils.GetCharacter()
            if not character then return end

            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end

            local function ApplyWalkSpeed()
                if humanoid then
                    humanoid.WalkSpeed = Options.WalkspeedSlider.Value
                end
            end

            ApplyWalkSpeed()

            if HumanModCons.wsLoop then
                HumanModCons.wsLoop:Disconnect()
            end

            HumanModCons.wsLoop = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(ApplyWalkSpeed)

            if HumanModCons.wsCA then
                HumanModCons.wsCA:Disconnect()
            end

            HumanModCons.wsCA = workspace.Living.ChildAdded:Connect(function(child)
                local player = game.Players.LocalPlayer
                if child.Name == player.Name then
                    task.wait(0.5)
                    humanoid = child:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        ApplyWalkSpeed()
                        if HumanModCons.wsLoop then
                            HumanModCons.wsLoop:Disconnect()
                        end
                        HumanModCons.wsLoop = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(ApplyWalkSpeed)
                    end
                end
            end)
        else
            if HumanModCons.wsLoop then
                HumanModCons.wsLoop:Disconnect()
                HumanModCons.wsLoop = nil
            end
            if HumanModCons.wsCA then
                HumanModCons.wsCA:Disconnect()
                HumanModCons.wsCA = nil
            end

            local character = Utils.GetCharacter()
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = normalWalkSpeed
                end
            end
        end
    end
})

-- WalkSpeed Slider
MovementsGroup:AddSlider("WalkspeedSlider", {
    Text = "WalkSpeed",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        if Toggles.WalkspeedToggle.Value then
            local character = Utils.GetCharacter()
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = Value
                end
            end
        end
    end
})

-- JumpPower Toggle
MovementsGroup:AddToggle("JumppowerToggle", {
    Text = "Enable JumpPower",
    Default = false,
    Tooltip = "Active ou désactive la modification de saut",
    Callback = function(Value)
        if Value then
            local character = Utils.GetCharacter()
            if not character then return end

            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end

            local function ApplyJumpPower()
                if humanoid then
                    humanoid.JumpPower = Options.JumppowerSlider.Value
                end
            end

            ApplyJumpPower()

            if HumanModCons.jpLoop then
                HumanModCons.jpLoop:Disconnect()
            end

            HumanModCons.jpLoop = humanoid:GetPropertyChangedSignal("JumpPower"):Connect(ApplyJumpPower)

            if HumanModCons.jpCA then
                HumanModCons.jpCA:Disconnect()
            end

            HumanModCons.jpCA = workspace.Living.ChildAdded:Connect(function(child)
                local player = game.Players.LocalPlayer
                if child.Name == player.Name then
                    task.wait(0.5)
                    humanoid = child:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        ApplyJumpPower()
                        if HumanModCons.jpLoop then
                            HumanModCons.jpLoop:Disconnect()
                        end
                        HumanModCons.jpLoop = humanoid:GetPropertyChangedSignal("JumpPower"):Connect(ApplyJumpPower)
                    end
                end
            end)
        else
            if HumanModCons.jpLoop then
                HumanModCons.jpLoop:Disconnect()
                HumanModCons.jpLoop = nil
            end
            if HumanModCons.jpCA then
                HumanModCons.jpCA:Disconnect()
                HumanModCons.jpCA = nil
            end

            local character = Utils.GetCharacter()
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = normalJumpPower
                end
            end
        end
    end
})

-- JumpPower Slider
MovementsGroup:AddSlider("JumppowerSlider", {
    Text = "JumpPower",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        if Toggles.JumppowerToggle.Value then
            local character = Utils.GetCharacter()
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = Value
                end
            end
        end
    end
})

-- ============================================
-- TAB MAIN - FORGE
-- ============================================

local MainTab = Tabs.Main
local ForgeGroup = MainTab:AddLeftGroupbox("Forge")

-- Open Forge Button
ForgeGroup:AddButton({
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

-- Open Marbles Button
ForgeGroup:AddButton({
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
-- TAB MAIN - MINING
-- ============================================

local MiningGroup = MainTab:AddRightGroupbox("Auto Mining")

-- Auto Mine Toggle
MiningGroup:AddToggle("AutoMineToggle", {
    Text = "Enable Auto Mine",
    Default = false,
    Tooltip = "Active ou désactive le minage automatique",
    Callback = function(Value)
        if Value then
            print("[Mining] Auto mine activé")
        else
            print("[Mining] Auto mine désactivé")
        end
    end
})

-- Teleport to Rock Toggle
MiningGroup:AddToggle("TeleportToRockToggle", {
    Text = "Teleport to Rock",
    Default = false,
    Tooltip = "Se téléporte automatiquement au rocher le plus proche",
    Callback = function(Value)
        if Value then
            print("[Mining] Teleport to rock activé")
        else
            print("[Mining] Teleport to rock désactivé")
        end
    end
})

-- Ore Type Selection
MiningGroup:AddDropdown("OreTypeSelection", {
    Values = {"All", "Iron", "Gold", "Diamond", "Emerald"},
    Default = 1,
    Multi = false,
    Text = "Select Ore Type",
    Tooltip = "Choisis le type de minerai à miner"
})

-- ============================================
-- TAB MAIN - AUTO FORGE
-- ============================================

local ForgeAutoGroup = MainTab:AddRightGroupbox("Auto Forge")

-- Auto Forge Toggle
ForgeAutoGroup:AddToggle("AutoForgeToggle", {
    Text = "Enable Auto Forge",
    Default = false,
    Tooltip = "Automatise le processus de forge",
    Callback = function(Value)
        if Value then
            print("[Forge] Auto forge activé")
        else
            print("[Forge] Auto forge désactivé")
        end
    end
})

-- Ore Selection for Auto Forge
ForgeAutoGroup:AddDropdown("OreSelection", {
    Values = {"Iron", "Gold", "Diamond", "Emerald"},
    Default = 1,
    Multi = false,
    Text = "Select Ore",
    Tooltip = "Choisis le minerai à forger"
})

-- ============================================
-- TAB PURCHASES
-- ============================================

local PurchaseTab = Tabs.Purchases
local PurchasePotions = PurchaseTab:AddLeftGroupbox("Purchases Potions")

PurchasePotions:AddDropdown("PurchasesPotions", {
    Text = "A dropdown",
    Values = {"This", "is", "a", "dropdown"},
    Default = 1,
    Multi = false,
})

-- ============================================
-- UI SETTINGS
-- ============================================

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("ElbestadtHub")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()

-- ============================================
-- NOTIFICATION
-- ============================================

Library:Notify("Elbestadt Hub chargé avec succès!", 5)

print("[Elbestadt Hub] Script chargé!")
print("[Elbestadt Hub] Version: 1.0.0")
