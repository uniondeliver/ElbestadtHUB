-- ============================================
-- MAIN.LUA - Script principal Elbestadt Hub
-- ============================================
-- Ce script charge tous les modules et setup l'interface
-- C'est le SEUL fichier à exécuter dans Wave executor

-- ============================================
-- CONFIGURATION
-- ============================================

-- URL de ton repo GitHub
local repo = "https://raw.githubusercontent.com/uniondeliver/ElbestadtHUB/refs/heads/master/"

-- URL de la library Linoria
local linoriaRepo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

-- Cache busting pour forcer le rechargement
local cacheBust = "?v=" .. tostring(os.time())

-- ============================================
-- CHARGEMENT DES UTILS
-- ============================================

local Utils = loadstring(game:HttpGet(repo .. "utils.lua" .. cacheBust))()

-- Stocke Utils globalement pour que tous les modules y aient accès
getgenv().Utils = Utils

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

local PlayerModule = loadstring(game:HttpGet(repo .. "player.lua" .. cacheBust))()
local MiningModule = loadstring(game:HttpGet(repo .. "mining.lua" .. cacheBust))()
local ForgeModule = loadstring(game:HttpGet(repo .. "forge.lua" .. cacheBust))()
local PurchasesModule = loadstring(game:HttpGet(repo .. "purchases.lua" .. cacheBust))()

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
ForgeModule.Setup(ForgeGroup, ForgeAutoGroup, Options, Toggles, Library)

-- ============================================
-- TAB PURCHASES
-- ============================================

local PurchaseTab = Tabs.Purchases
local PurchasePotions = PurchaseTab:AddLeftGroupbox("Purchases Potions")
local PurchasePickaxes = PurchaseTab:AddRightGroupbox("Purchase Pickaxes")

-- Setup du module Purchases
PurchasesModule.Setup(PurchasePotions, PurchasePickaxes, Options, Toggles)

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
-- KEYBIND POUR TOGGLE L'UI
-- ============================================

Library:OnUnload(function()
    print("[Elbestadt Hub] UI déchargée")
end)

-- Ajoute une keybind pour toggle l'UI (RightShift par défaut)
Library.ToggleKeybind = Options.MenuKeybind or Enum.KeyCode.RightShift

-- ============================================
-- NOTIFICATION DE CHARGEMENT
-- ============================================

Library:Notify("Elbestadt Hub chargé avec succès!", 5)
Library:Notify("Appuie sur RightShift pour toggle l'UI", 5)
