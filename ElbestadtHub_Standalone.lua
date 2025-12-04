-- ============================================
-- ELBESTADT HUB - STANDALONE VERSION
-- ============================================
-- Script tout-en-un pour The Forge
-- Tous les modules sont intégrés dans ce fichier

-- ============================================
-- UTILS MODULE
-- ============================================

local Utils = {}

function Utils.GetCharacter()
    local player = game.Players.LocalPlayer
    return workspace.Living:FindFirstChild(player.Name)
end

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

getgenv().Utils = Utils

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
    Visuals = Window:AddTab("Visuals", "eye"),
    Purchases = Window:AddTab("Purchases", "dollar-sign"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- ============================================
-- PLAYER MODULE
-- ============================================

local HumanModCons = {}
local normalWalkSpeed = 16
local normalJumpPower = 50

local PlayerTab = Tabs.Player
local MovementsGroup = PlayerTab:AddLeftGroupbox("Movements")

-- WalkSpeed
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

-- JumpPower
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
-- FORGE MODULE
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MinigameConnection = nil
local AutoForgeEnabled = false
local MeltSkipped = false
local PourSkipped = false

local function getForgeGui()
    local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
    return PlayerGui and PlayerGui:FindFirstChild("Forge")
end

local function simulateClick(x, y)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.03)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

local MainTab = Tabs.Main
local ForgeGroup = MainTab:AddLeftGroupbox("Forge")
local MiningGroup = MainTab:AddRightGroupbox("Auto Mining")
local ForgeAutoGroup = MainTab:AddRightGroupbox("Auto Forge")

-- Forge Buttons
ForgeGroup:AddButton({
    Text = "Open Forge",
    Func = function()
        local forge = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Forge")
        if not forge then return end

        local prompt = forge:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            fireproximityprompt(prompt)
        else
            pcall(function()
                ReplicatedStorage.Shared.Packages.Knit.Services.ForgeService.RF.StartForge:InvokeServer(forge)
            end)
        end
    end,
    Tooltip = "Ouvre la forge de n'importe où"
})

ForgeGroup:AddButton({
    Text = "Open Marbles (seller)",
    Func = function()
        local marbles = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Marbles")
        if not marbles then return end

        local prompt = marbles:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            fireproximityprompt(prompt)
        else
            pcall(function()
                ReplicatedStorage.Shared.Packages.Knit.Services.ProximityService.RF.Dialogue:InvokeServer(marbles)
            end)
        end
    end,
    Tooltip = "Vendre de n'importe où"
})

-- Auto Forge
local ChangeSequence = ReplicatedStorage.Shared.Packages.Knit.Services.ForgeService.RF.ChangeSequence

local function AutoForge()
    if not AutoForgeEnabled then return end

    local ForgeGui = getForgeGui()
    if not ForgeGui then
        MeltSkipped = false
        PourSkipped = false
        return
    end

    -- AUTO MELT
    local MeltMinigame = ForgeGui:FindFirstChild("MeltMinigame")
    if MeltMinigame and MeltMinigame.Visible then
        if not MeltSkipped then
            MeltSkipped = true
            task.spawn(function()
                task.wait(1)
                pcall(function()
                    ChangeSequence:InvokeServer("Pour", {ClientTime = workspace:GetServerTimeNow()})
                end)
            end)
        end
        return
    else
        MeltSkipped = false
    end

    -- AUTO POUR
    local PourMinigame = ForgeGui:FindFirstChild("PourMinigame")
    if PourMinigame and PourMinigame.Visible then
        if not PourSkipped then
            PourSkipped = true
            task.spawn(function()
                task.wait(1)
                pcall(function()
                    ChangeSequence:InvokeServer("Hammer", {ClientTime = workspace:GetServerTimeNow()})
                end)
            end)
        end
        return
    else
        PourSkipped = false
    end

    -- AUTO HAMMER
    local HammerMinigame = ForgeGui:FindFirstChild("HammerMinigame")
    if HammerMinigame and HammerMinigame.Visible then
        local ClickArea = HammerMinigame:FindFirstChild("ClickArea") or HammerMinigame
        local posX = ClickArea.AbsolutePosition.X + ClickArea.AbsoluteSize.X / 2
        local posY = ClickArea.AbsolutePosition.Y + ClickArea.AbsoluteSize.Y / 2
        simulateClick(posX, posY)
    end
end

local AutoForgeToggle = ForgeAutoGroup:AddToggle("AutoForgeToggle", {
    Text = "Auto Complete Minigames",
    Default = false,
    Tooltip = "Complète automatiquement les minijeux",
    Callback = function(Value)
        AutoForgeEnabled = Value

        if Value then
            MinigameConnection = RunService.RenderStepped:Connect(AutoForge)
        else
            if MinigameConnection then
                MinigameConnection:Disconnect()
                MinigameConnection = nil
            end
            MeltSkipped = false
            PourSkipped = false
        end
    end
})

AutoForgeToggle:AddKeyPicker("AutoForgeKeybind", {
    Text = "Auto Forge",
    Default = "F",
    Mode = "Toggle",
    SyncToggleState = true
})

-- ============================================
-- MINING MODULE
-- ============================================

MiningGroup:AddToggle("AutoMineToggle", {
    Text = "Enable Auto Mine",
    Default = false,
    Tooltip = "Active ou désactive le minage automatique",
    Callback = function(Value)
        -- TODO
    end
})

MiningGroup:AddToggle("TeleportToRockToggle", {
    Text = "Teleport to Rock",
    Default = false,
    Tooltip = "Se téléporte automatiquement au rocher le plus proche",
    Callback = function(Value)
        -- TODO
    end
})

MiningGroup:AddDropdown("OreTypeSelection", {
    Values = {"All", "Iron", "Gold", "Diamond", "Emerald"},
    Default = 1,
    Multi = false,
    Text = "Select Ore Type",
    Tooltip = "Choisis le type de minerai à miner"
})

-- ============================================
-- ESP MODULE
-- ============================================

local ESPObjects = {}
local ESPConnection = nil
local OreESPs = {}

local function createESP(object, name, color)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = object

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = object

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = color
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextSize = 16
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = name
    textLabel.Parent = billboard

    return {
        Highlight = highlight,
        Billboard = billboard,
        TextLabel = textLabel,
        Object = object
    }
end

local function removeESP(espData)
    if espData.Highlight then espData.Highlight:Destroy() end
    if espData.Billboard then espData.Billboard:Destroy() end
end

local function updateESPDistance(espData)
    if not espData.Object or not espData.Object:IsDescendantOf(workspace) then
        return false
    end

    local character = Players.LocalPlayer.Character
    if not character or not character.PrimaryPart then return true end

    local distance = (character.PrimaryPart.Position - espData.Object.Position).Magnitude
    espData.TextLabel.Text = string.format("%s\n[%.0f studs]", espData.Object.Name, distance)

    return true
end

local function addPlayerESP(player)
    if player == Players.LocalPlayer then return end

    local function onCharacterAdded(character)
        task.wait(0.5)

        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local espData = createESP(hrp, player.Name, Color3.fromRGB(255, 100, 100))
        ESPObjects[player.UserId] = espData
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end

    player.CharacterAdded:Connect(onCharacterAdded)
end

local function removePlayerESP(player)
    local espData = ESPObjects[player.UserId]
    if espData then
        removeESP(espData)
        ESPObjects[player.UserId] = nil
    end
end

local function addOreESP(ore)
    if OreESPs[ore] then return end

    local color = Color3.fromRGB(100, 255, 100)
    local espData = createESP(ore, ore.Name, color)
    OreESPs[ore] = espData
end

local function removeOreESP(ore)
    local espData = OreESPs[ore]
    if espData then
        removeESP(espData)
        OreESPs[ore] = nil
    end
end

local function scanForOres()
    local oresFolder = workspace:FindFirstChild("Ores")
    if not oresFolder then return end

    for _, ore in oresFolder:GetChildren() do
        if ore:IsA("BasePart") and Toggles.OreESP.Value then
            addOreESP(ore)
        end
    end
end

local function updateESPs()
    for userId, espData in pairs(ESPObjects) do
        if not updateESPDistance(espData) then
            removeESP(espData)
            ESPObjects[userId] = nil
        end
    end

    for ore, espData in pairs(OreESPs) do
        if not updateESPDistance(espData) then
            removeOreESP(ore)
        end
    end
end

local VisualsTab = Tabs.Visuals
local ESPGroup = VisualsTab:AddLeftGroupbox("ESP")

ESPGroup:AddToggle("PlayerESP", {
    Text = "Player ESP",
    Default = false,
    Tooltip = "Voir les joueurs à travers les murs",
    Callback = function(Value)
        if Value then
            for _, player in Players:GetPlayers() do
                addPlayerESP(player)
            end

            Players.PlayerAdded:Connect(function(player)
                if Toggles.PlayerESP.Value then
                    addPlayerESP(player)
                end
            end)

            Players.PlayerRemoving:Connect(function(player)
                removePlayerESP(player)
            end)
        else
            for userId, espData in pairs(ESPObjects) do
                removeESP(espData)
            end
            ESPObjects = {}
        end
    end
})

ESPGroup:AddToggle("OreESP", {
    Text = "Ore ESP",
    Default = false,
    Tooltip = "Voir les minerais à travers les murs",
    Callback = function(Value)
        if Value then
            scanForOres()

            task.spawn(function()
                while Toggles.OreESP.Value do
                    scanForOres()
                    task.wait(5)
                end
            end)
        else
            for ore, espData in pairs(OreESPs) do
                removeESP(espData)
            end
            OreESPs = {}
        end
    end
})

RunService.RenderStepped:Connect(function()
    if Toggles.PlayerESP and Toggles.PlayerESP.Value or Toggles.OreESP and Toggles.OreESP.Value then
        updateESPs()
    end
end)

-- ============================================
-- PURCHASES MODULE
-- ============================================

local PurchaseTab = Tabs.Purchases
local PurchasePotions = PurchaseTab:AddLeftGroupbox("Purchases Potions")
local PurchasePickaxes = PurchaseTab:AddRightGroupbox("Purchase Pickaxes")

PurchasePotions:AddButton({
    Text = "Damage Potion I   250 $",
    Func = function()
        -- TODO
    end,
    DoubleClick = true,
})

PurchasePotions:AddButton({
    Text = "Health Potion I   150 $",
    Func = function()
        -- TODO
    end,
    DoubleClick = true,
})

PurchasePotions:AddButton({
    Text = "Miner Potion I   500 $",
    Func = function()
        -- TODO
    end,
    DoubleClick = true,
})

PurchasePotions:AddButton({
    Text = "Luck Potion I   350 $",
    Func = function()
        -- TODO
    end,
    DoubleClick = true,
})

PurchasePotions:AddButton({
    Text = "Speed Potion I   200 $",
    Func = function()
        -- TODO
    end,
    DoubleClick = true,
})

PurchasePickaxes:AddButton({
    Text = "Bronze Pickaxe   150 $",
    Func = function()
        -- TODO
    end,
    DoubleClick = true,
})

PurchasePickaxes:AddButton({
    Text = "Iron Pickaxe  500 $",
    Func = function()
        -- TODO
    end,
    DoubleClick = true,
})

PurchasePickaxes:AddButton({
    Text = "Gold Pickaxe  1500 $",
    Func = function()
        -- TODO
    end,
    DoubleClick = true,
})

PurchasePickaxes:AddButton({
    Text = "Platinium Pickaxe  5.000 $",
    Func = function()
        -- TODO
    end,
    DoubleClick = true,
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

Library:OnUnload(function()
    print("[Elbestadt Hub] UI déchargée")
end)

Library.ToggleKeybind = Options.MenuKeybind or Enum.KeyCode.RightShift

Library:Notify("Elbestadt Hub chargé avec succès!", 5)
Library:Notify("Appuie sur RightShift pour toggle l'UI", 5)
