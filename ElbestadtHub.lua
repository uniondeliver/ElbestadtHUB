local EncodingService = game:GetService("EncodingService")
local RunService = game:GetService("RunService")

-- Fonction pour décharger l'UI existante
local function UnloadUI()
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

-- Décharge l'ancienne UI avant de charger la nouvelle
pcall(UnloadUI)

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- Stocke Library globalement pour pouvoir l'unload plus tard
getgenv().Library = Library

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

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

-- Fonction pour obtenir ton personnage
local function GetCharacter()
    local player = game.Players.LocalPlayer
    return workspace.Living:FindFirstChild(player.Name)
end

local HumanModCons = {}
local normalWalkSpeed = 16

-- ============================================
-- TAB PLAYER
-- ============================================
local PlayerTab = Tabs.Player
local MovementsGroup = PlayerTab:AddLeftGroupbox("Movements")

-- Toggle pour activer le walkspeed modifier
MovementsGroup:AddToggle("WalkspeedToggle", {
    Text = "Enable WalkSpeed",
    Default = false,
    Tooltip = "Active ou désactive la modification de vitesse",
    Callback = function(Value)
        if Value then
            local character = GetCharacter()
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

            local character = GetCharacter()
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = normalWalkSpeed
                end
            end
        end
    end
})

-- Slider pour choisir notre Vitesse
MovementsGroup:AddSlider("WalkspeedSlider", {
    Text = "WalkSpeed",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        if Toggles.WalkspeedToggle.Value then
            local character = GetCharacter()
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = Value
                end
            end
        end
    end
})

-- Toggle pour activer le jumppower modifier
MovementsGroup:AddToggle("JumppowerToggle", {
    Text = "Enable JumpPower",
    Default = false,
    Tooltip = "Active ou désactive la modification de saut",
    Callback = function(Value)
        if Value then
            local character = GetCharacter()
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

            local character = GetCharacter()
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = 50
                end
            end
        end
    end
})

-- Slider pour choisir le JumpPower
MovementsGroup:AddSlider("JumppowerSlider", {
    Text = "JumpPower",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        if Toggles.JumppowerToggle.Value then
            local character = GetCharacter()
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
-- TAB MAIN
-- ============================================
local MainTab = Tabs.Main
local ForgeGroup = MainTab:AddLeftGroupbox("Forge")

-- Bouton pour ouvrir la forge de n'importe où
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

-- Bouton pour ouvrir le menu de Marbles
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

local MiningGroup = MainTab:AddRightGroupbox("Auto Mining")

local ForgeAutoGroup = MainTab:AddRightGroupbox("Auto Forge")

-- Toggle pour auto-forge
ForgeAutoGroup:AddToggle("AutoForgeToggle", {
    Text = "Enable Auto Forge",
    Default = false,
    Tooltip = "Automatise le processus de forge",
    Callback = function(Value)
        if Value then
            -- TODO: Logique d'auto forge
        end
    end
})

-- Dropdown pour choisir le minerai à forger
ForgeAutoGroup:AddDropdown("OreSelection", {
    Values = {"Iron", "Gold", "Diamond", "Emerald"},
    Default = 1,
    Multi = false,
    Text = "Select Ore",
    Tooltip = "Choisis le minerai à forger"
})

---------------------------------------------------------------------------------------
-----------------------------PURCHASES----------------------------------------------------------
---------------------------------------------------------------------------------------
local PurchaseTab = Tabs.Purchases
local PurchasePotions = PurchaseTab:AddLeftGroupbox("Purchases Potions")

PurchasePotions:AddButton("" , {
    Text = "Damage Potion I   250 $",
	Func = function()
		-- TODO: Acheter Damage Potion I
	end,
	DoubleClick = true,
})

PurchasePotions:AddButton("" , {
    Text = "Health Potion I   150 $",
	Func = function()
		-- TODO: Acheter Health Potion I
	end,
	DoubleClick = true,
})

PurchasePotions:AddButton("" , {
    Text = "Miner Potion I   500 $",
	Func = function()
		-- TODO: Acheter Miner Potion I
	end,
	DoubleClick = true,
})

PurchasePotions:AddButton("" , {
    Text = "Luck Potion I   350 $",
	Func = function()
		-- TODO: Acheter Luck Potion I
	end,
	DoubleClick = true,
})

PurchasePotions:AddButton("" , {
    Text = "Speed Potion I   200 $",
	Func = function()
		-- TODO: Acheter Speed Potion I
	end,
	DoubleClick = true,
})

local PurchasePickaxes = PurchaseTab:AddRightGroupbox("Purchase Pickaxes")

PurchasePickaxes:AddButton("", {
    Text = "Bronze Pickaxe   150 $",
	Func = function()
		-- TODO: Acheter Bronze Pickaxe
	end,
	DoubleClick = true,
})

PurchasePickaxes:AddButton("", {
    Text = "Iron Pickaxe  500 $",
	Func = function()
		-- TODO: Acheter Iron Pickaxe
	end,
	DoubleClick = true,
})

PurchasePickaxes:AddButton("", {
    Text = "Gold Pickaxe  1500 $",
	Func = function()
		-- TODO: Acheter Gold Pickaxe
	end,
	DoubleClick = true,
})

PurchasePickaxes:AddButton("", {
    Text = "Platinium Pickaxe  5.000 $",
	Func = function()
		-- TODO: Acheter Platinium Pickaxe
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
