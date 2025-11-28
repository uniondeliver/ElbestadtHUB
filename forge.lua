-- ============================================
-- FORGE.LUA - Module pour open forge et auto forge
-- ============================================

local ForgeModule = {}

-- Charge les utils depuis GitHub
local repo = "https://raw.githubusercontent.com/uniondeliver/ElbestadtHUB/main/"
local Utils = loadstring(game:HttpGet(repo .. "utils.lua"))()

-- Setup du module Forge
function ForgeModule.Setup(groupbox, autoGroupbox, Options, Toggles)

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

    -- Toggle pour auto-forge
    autoGroupbox:AddToggle("AutoForgeToggle", {
        Text = "Enable Auto Forge",
        Default = false,
        Tooltip = "Automatise le processus de forge",
        Callback = function(Value)
            if Value then
                -- TODO: Logique d'auto forge
                print("[Forge] Auto forge activé")
            else
                print("[Forge] Auto forge désactivé")
            end
        end
    })

    -- Dropdown pour choisir le minerai à forger
    autoGroupbox:AddDropdown("OreSelection", {
        Values = {"Iron", "Gold", "Diamond", "Emerald"},
        Default = 1,
        Multi = false,
        Text = "Select Ore",
        Tooltip = "Choisis le minerai à forger"
    })
end

return ForgeModule
