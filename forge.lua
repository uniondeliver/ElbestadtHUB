-- ============================================
-- FORGE.LUA - Module pour open forge et auto forge
-- ============================================

local ForgeModule = {}

function ForgeModule.Setup(groupbox, autoGroupbox, Options, Toggles, Library)
    local Utils = getgenv().Utils

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local MinigameConnection = nil
    local AutoForgeEnabled = false

    -- ============================================
    -- HELPER FUNCTIONS
    -- ============================================

    local function getForgeGui()
        local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
        return PlayerGui and PlayerGui:FindFirstChild("Forge")
    end

    local function simulateClick(x, y)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait(0.03)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end

    -- ============================================
    -- FORGE BUTTONS
    -- ============================================

    groupbox:AddButton({
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

    groupbox:AddButton({
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

    -- ============================================
    -- AUTO MINIGAMES (HOOK METHOD)
    -- ============================================

    local ChangeSequenceRemote = ReplicatedStorage.Shared.Packages.Knit.Services.ForgeService.RF.ChangeSequence
    getgenv().ForgeSkipNext = nil

    -- Hook namecall pour remplacer les arguments
    local namecall
    namecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod():lower()

        if self == ChangeSequenceRemote and method == "invokeserver" then
            -- Remplacer le premier argument si on a un skip en attente
            args[1] = getgenv().ForgeSkipNext or args[1]
            return namecall(self, unpack(args))
        end

        return namecall(self, ...)
    end)

    -- Détection des minigames et préparation du skip
    local lastMeltCheck = 0
    local lastPourCheck = 0
    local lastHammerCheck = 0

    local function AutoForge()
        if not AutoForgeEnabled then return end

        local ForgeGui = getForgeGui()
        if not ForgeGui then
            getgenv().ForgeSkipNext = nil
            return
        end

        local currentTime = tick()

        -- AUTO MELT: Prépare "Pour" comme prochain argument
        local MeltMinigame = ForgeGui:FindFirstChild("MeltMinigame")
        if MeltMinigame and MeltMinigame.Visible then
            if currentTime - lastMeltCheck > 0.5 then
                lastMeltCheck = currentTime
                getgenv().ForgeSkipNext = "Pour"
            end
            return
        end

        -- AUTO POUR: Prépare "Hammer" comme prochain argument
        local PourMinigame = ForgeGui:FindFirstChild("PourMinigame")
        if PourMinigame and PourMinigame.Visible then
            if currentTime - lastPourCheck > 0.5 then
                lastPourCheck = currentTime
                getgenv().ForgeSkipNext = "Hammer"
            end
            return
        end

        -- AUTO HAMMER: Click rapide
        local HammerMinigame = ForgeGui:FindFirstChild("HammerMinigame")
        if HammerMinigame and HammerMinigame.Visible then
            if currentTime - lastHammerCheck > 0.1 then
                lastHammerCheck = currentTime
                local ClickArea = HammerMinigame:FindFirstChild("ClickArea") or HammerMinigame
                local posX = ClickArea.AbsolutePosition.X + ClickArea.AbsoluteSize.X / 2
                local posY = ClickArea.AbsolutePosition.Y + ClickArea.AbsoluteSize.Y / 2
                simulateClick(posX, posY)
            end
            return
        end

        -- Aucun minigame visible, reset le skip
        getgenv().ForgeSkipNext = nil
    end

    -- ============================================
    -- UI CONTROLS
    -- ============================================

    local AutoForgeToggle = autoGroupbox:AddToggle("AutoForgeToggle", {
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
                -- Reset tout
                getgenv().ForgeSkipNext = nil
                lastMeltCheck = 0
                lastPourCheck = 0
                lastHammerCheck = 0
            end
        end
    })

    AutoForgeToggle:AddKeyPicker("AutoForgeKeybind", {
        Text = "Auto Forge",
        Default = "F",
        Mode = "Toggle",
        SyncToggleState = true
    })
end

return ForgeModule
