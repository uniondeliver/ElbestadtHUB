-- ============================================
-- ECOS STAMINA SCRIPT
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ============================================
-- CONFIGURATION
-- ============================================

local STAMINA_VALUE = 100 -- Valeur de stamina à maintenir
local SPAM_DELAY = 0.1 -- Délai entre chaque spam (en secondes)

-- ============================================
-- HOOK METHOD (Recommandé)
-- ============================================

local function setupStaminaHook()
    local UpdateStamina = ReplicatedStorage.Events.UpdateStamina

    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if self == UpdateStamina and method == "FireServer" then
            -- Remplace la valeur de stamina par 100
            args[1] = STAMINA_VALUE
            return OldNamecall(self, unpack(args))
        end

        return OldNamecall(self, ...)
    end)

    print("[Ecos] Stamina hook activé - Stamina maintenue à", STAMINA_VALUE)
end

-- ============================================
-- SPAM METHOD (Alternative)
-- ============================================

local SpamConnection = nil

local function startStaminaSpam()
    if SpamConnection then
        SpamConnection:Disconnect()
    end

    local UpdateStamina = ReplicatedStorage.Events.UpdateStamina

    SpamConnection = game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
            UpdateStamina:FireServer(STAMINA_VALUE)
        end)
    end)

    print("[Ecos] Stamina spam activé - Spam toutes les", SPAM_DELAY, "secondes")
end

local function stopStaminaSpam()
    if SpamConnection then
        SpamConnection:Disconnect()
        SpamConnection = nil
        print("[Ecos] Stamina spam désactivé")
    end
end

-- ============================================
-- MAIN
-- ============================================

print("=".rep(50))
print("ECOS STAMINA SCRIPT")
print("=".rep(50))
print("")
print("Choisissez votre méthode:")
print("1. Hook Method (Recommandé) - Intercepte et modifie automatiquement")
print("2. Spam Method - Spam le remote constamment")
print("")

-- Par défaut, utilise la méthode Hook
setupStaminaHook()

-- Pour utiliser le spam à la place, décommente la ligne suivante:
-- startStaminaSpam()

print("")
print("Script chargé avec succès!")
print("Stamina maintenue à:", STAMINA_VALUE)
print("=".rep(50))
