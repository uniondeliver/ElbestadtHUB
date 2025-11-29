-- ============================================
-- ESP.LUA - Module pour ESP (Player & Ores)
-- ============================================

local ESPModule = {}

function ESPModule.Setup(groupbox, Options, Toggles, Library)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local ESPObjects = {}
    local ESPConnection = nil

    -- ============================================
    -- HELPER FUNCTIONS
    -- ============================================

    local function createESP(object, name, color)
        -- Highlight pour voir à travers les murs
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = color
        highlight.OutlineColor = color
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = object

        -- BillboardGui pour afficher le nom et la distance
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

        local character = LocalPlayer.Character
        if not character or not character.PrimaryPart then return true end

        local distance = (character.PrimaryPart.Position - espData.Object.Position).Magnitude
        espData.TextLabel.Text = string.format("%s\n[%.0f studs]", espData.Object.Name, distance)

        return true
    end

    -- ============================================
    -- PLAYER ESP
    -- ============================================

    local function addPlayerESP(player)
        if player == LocalPlayer then return end

        local function onCharacterAdded(character)
            task.wait(0.5) -- Attendre que le character soit chargé

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

    -- ============================================
    -- ORE ESP
    -- ============================================

    local OreESPs = {}

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
        -- Cherche les ores dans workspace.Ores (ajuste selon ton jeu)
        local oresFolder = workspace:FindFirstChild("Ores")
        if not oresFolder then return end

        for _, ore in oresFolder:GetChildren() do
            if ore:IsA("BasePart") and Toggles.OreESP.Value then
                addOreESP(ore)
            end
        end
    end

    -- ============================================
    -- UPDATE LOOP
    -- ============================================

    local function updateESPs()
        -- Update Player ESP distances
        for userId, espData in pairs(ESPObjects) do
            if not updateESPDistance(espData) then
                removeESP(espData)
                ESPObjects[userId] = nil
            end
        end

        -- Update Ore ESP distances
        for ore, espData in pairs(OreESPs) do
            if not updateESPDistance(espData) then
                removeOreESP(ore)
            end
        end
    end

    -- ============================================
    -- UI CONTROLS
    -- ============================================

    groupbox:AddToggle("PlayerESP", {
        Text = "Player ESP",
        Default = false,
        Tooltip = "Voir les joueurs à travers les murs",
        Callback = function(Value)
            if Value then
                -- Ajouter ESP pour tous les joueurs existants
                for _, player in Players:GetPlayers() do
                    addPlayerESP(player)
                end

                -- Ajouter ESP pour les nouveaux joueurs
                Players.PlayerAdded:Connect(function(player)
                    if Toggles.PlayerESP.Value then
                        addPlayerESP(player)
                    end
                end)

                Players.PlayerRemoving:Connect(function(player)
                    removePlayerESP(player)
                end)
            else
                -- Retirer tous les ESP joueurs
                for userId, espData in pairs(ESPObjects) do
                    removeESP(espData)
                end
                ESPObjects = {}
            end
        end
    })

    groupbox:AddToggle("OreESP", {
        Text = "Ore ESP",
        Default = false,
        Tooltip = "Voir les minerais à travers les murs",
        Callback = function(Value)
            if Value then
                scanForOres()

                -- Re-scan toutes les 5 secondes pour nouveaux ores
                task.spawn(function()
                    while Toggles.OreESP.Value do
                        scanForOres()
                        task.wait(5)
                    end
                end)
            else
                -- Retirer tous les ESP ores
                for ore, espData in pairs(OreESPs) do
                    removeESP(espData)
                end
                OreESPs = {}
            end
        end
    })

    -- Connection pour update les distances
    ESPConnection = RunService.RenderStepped:Connect(function()
        if Toggles.PlayerESP.Value or Toggles.OreESP.Value then
            updateESPs()
        end
    end)
end

return ESPModule
