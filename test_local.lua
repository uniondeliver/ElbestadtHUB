-- ============================================
-- TEST LOCAL - Charge avec readfile + loadstring
-- ============================================
-- Copie ce script dans ton executor pour tester localement

local basePath = "c:\\Users\\'tzert\\Documents\\tHE fORGE\\"

print("🔄 Chargement depuis le disque local avec readfile...")

-- Charge le script principal avec readfile + loadstring
local success, err = pcall(function()
    local scriptContent = readfile(basePath .. "main.lua")
    loadstring(scriptContent)()
end)

if success then
    print("✅ Script chargé avec succès!")
else
    warn("❌ Erreur:", err)
end
