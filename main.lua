-- ============================================
-- MAIN.LUA - Script principal Elbestadt Hub
-- ============================================
-- Ce script charge tous les modules et setup l'interface
-- C'est le SEUL fichier à exécuter dans Wave executor

-- ============================================
-- CONFIGURATION
-- ============================================

-- URL de ton repo GitHub
local repo = "https://raw.githubusercontent.com/uniondeliver/ElbestadtHUB/main/"

-- URL de la library Linoria
local linoriaRepo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

-- ============================================
-- CHARGEMENT DES UTILS
-- ============================================

local Utils = loadstring(game:HttpGet(repo .. "utils.lua"))()

-- Décharge l'ancienne UI avant de charger la nouvelle
pcall(Utils.UnloadUI)

-- ============================================
-- CHARGEMENT DE LA LIBRARY LINORIA
-- ============================================

local Library = loadstring(game:HttpGet(linoriaRepo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(linoriaRepo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(linoriaRepo .. "addons/SaveManager.lua"))()

-- Stocke Library globalement pour pouvoir l'unload plus tard
getgenv().Library = Library

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

-- ============================================
-- CRÉATION DE LA FENÊTRE
-- ============================================

local Window = Library:CreateWindow({
    Title = "Elbestadt Hub",
    Footer = "version: 1.0.0",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

-- ============================================
-- CRÉATION DES TABS
-- ============================================

local Tabs = {
    Home = Window:AddTab("Home", "house"),
    Main = Window:AddTab("Main", "menu"),
    Player = Window:AddTab("Player","user"),
    Purchases = Window:AddTab("Purchases", "dollar-sign"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- ============================================
-- CHARGEMENT DES MODULES
-- ============================================

local PlayerModule = loadstring(game:HttpGet(repo .. "player.lua"))()
local MiningModule = loadstring(game:HttpGet(repo .. "mining.lua"))()
local ForgeModule = loadstring(game:HttpGet(repo .. "forge.lua"))()

-- ============================================
-- TAB PLAYER
-- ============================================

local PlayerTab = Tabs.Player
local MovementsGroup = PlayerTab:AddLeftGroupbox("Movements")

-- Setup du module Player (WalkSpeed & JumpPower)
PlayerModule.Setup(MovementsGroup, Options, Toggles)

-- ============================================
-- TAB MAIN
-- ============================================

local MainTab = Tabs.Main

-- Forge Group
local ForgeGroup = MainTab:AddLeftGroupbox("Forge")

-- Mining Group
local MiningGroup = MainTab:AddRightGroupbox("Auto Mining")

-- Auto Forge Group
local ForgeAutoGroup = MainTab:AddRightGroupbox("Auto Forge")

-- Setup des modules
MiningModule.Setup(MiningGroup, Options, Toggles)
ForgeModule.Setup(ForgeGroup, ForgeAutoGroup, Options, Toggles)

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
-- UI SETTINGS TAB
-- ============================================

-- Setup ThemeManager et SaveManager
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore ces options spécifiques dans le SaveManager
SaveManager:IgnoreThemeSettings()

-- Setup folder pour les configs
SaveManager:SetFolder("ElbestadtHub")

-- Build config menu dans le UI Settings tab
SaveManager:BuildConfigSection(Tabs["UI Settings"])

-- Build theme section dans le UI Settings tab
ThemeManager:ApplyToTab(Tabs["UI Settings"])

-- Load autoload config si disponible
SaveManager:LoadAutoloadConfig()

-- ============================================
-- NOTIFICATION DE CHARGEMENT
-- ============================================

Library:Notify("Elbestadt Hub chargé avec succès!", 5)

print("[Elbestadt Hub] Tous les modules ont été chargés avec succès!")
print("[Elbestadt Hub] Version: 1.0.0")
