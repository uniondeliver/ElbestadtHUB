-- ============================================
-- MINING.LUA - Module pour auto mine et teleport to rock
-- ============================================

local MiningModule = {}

-- Setup du module Mining
function MiningModule.Setup(groupbox, Options, Toggles)
    -- Récupère Utils depuis getgenv (chargé dans main.lua)
    local Utils = getgenv().Utils

    -- ============================================
    -- AUTO MINING
    -- ============================================

    -- Toggle pour auto mine
    groupbox:AddToggle("AutoMineToggle", {
        Text = "Enable Auto Mine",
        Default = false,
        Tooltip = "Active ou désactive le minage automatique",
        Callback = function(Value)
            if Value then
                -- TODO: Logique d'auto mine à implémenter
                print("[Mining] Auto mine activé")
            else
                -- Stop auto mine
                print("[Mining] Auto mine désactivé")
            end
        end
    })

    -- Toggle pour teleport to rock
    groupbox:AddToggle("TeleportToRockToggle", {
        Text = "Teleport to Rock",
        Default = false,
        Tooltip = "Se téléporte automatiquement au rocher le plus proche",
        Callback = function(Value)
            if Value then
                -- TODO: Logique de téléportation aux rochers
                print("[Mining] Teleport to rock activé")
            else
                print("[Mining] Teleport to rock désactivé")
            end
        end
    })

    -- Dropdown pour choisir le type de minerai à miner
    groupbox:AddDropdown("OreTypeSelection", {
        Values = {"All", "Iron", "Gold", "Diamond", "Emerald"},
        Default = 1,
        Multi = false,
        Text = "Select Ore Type",
        Tooltip = "Choisis le type de minerai à miner"
    })
end

return MiningModule
