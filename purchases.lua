-- ============================================
-- PURCHASES.LUA - Module pour les achats (potions et pickaxes)
-- ============================================

local PurchasesModule = {}

-- Setup du module Purchases
function PurchasesModule.Setup(purchasePotions, purchasePickaxes, Options, Toggles)
    -- Récupère Utils depuis getgenv (chargé dans main.lua)
    local Utils = getgenv().Utils

    -- ============================================
    -- POTIONS
    -- ============================================

    purchasePotions:AddButton("", {
        Text = "Damage Potion I   250 $",
        Func = function()
            -- TODO: Acheter Damage Potion I
        end,
        DoubleClick = true,
    })

    purchasePotions:AddButton("", {
        Text = "Health Potion I   150 $",
        Func = function()
            -- TODO: Acheter Health Potion I
        end,
        DoubleClick = true,
    })

    purchasePotions:AddButton("", {
        Text = "Miner Potion I   500 $",
        Func = function()
            -- TODO: Acheter Miner Potion I
        end,
        DoubleClick = true,
    })

    purchasePotions:AddButton("", {
        Text = "Luck Potion I   350 $",
        Func = function()
            -- TODO: Acheter Luck Potion I
        end,
        DoubleClick = true,
    })

    purchasePotions:AddButton("", {
        Text = "Speed Potion I   200 $",
        Func = function()
            -- TODO: Acheter Speed Potion I
        end,
        DoubleClick = true,
    })

    -- ============================================
    -- PICKAXES
    -- ============================================

    purchasePickaxes:AddButton("", {
        Text = "Bronze Pickaxe   150 $",
        Func = function()
            -- TODO: Acheter Bronze Pickaxe
        end,
        DoubleClick = true,
    })

    purchasePickaxes:AddButton("", {
        Text = "Iron Pickaxe  500 $",
        Func = function()
            -- TODO: Acheter Iron Pickaxe
        end,
        DoubleClick = true,
    })

    purchasePickaxes:AddButton("", {
        Text = "Gold Pickaxe  1500 $",
        Func = function()
            -- TODO: Acheter Gold Pickaxe
        end,
        DoubleClick = true,
    })

    purchasePickaxes:AddButton("", {
        Text = "Platinium Pickaxe  5.000 $",
        Func = function()
            -- TODO: Acheter Platinium Pickaxe
        end,
        DoubleClick = true,
    })
end

return PurchasesModule
