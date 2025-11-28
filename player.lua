-- ============================================
-- PLAYER.LUA - Module pour WalkSpeed et JumpPower
-- ============================================

local PlayerModule = {}

-- Table pour stocker les connections
local HumanModCons = {}
local normalWalkSpeed = 16
local normalJumpPower = 50

-- Charge les utils depuis GitHub
local repo = "https://raw.githubusercontent.com/uniondeliver/ElbestadtHUB/main/"
local Utils = loadstring(game:HttpGet(repo .. "utils.lua"))()

-- Setup du module Player (WalkSpeed & JumpPower)
function PlayerModule.Setup(groupbox, Options, Toggles)

    -- ============================================
    -- WALKSPEED
    -- ============================================

    -- Toggle pour activer le walkspeed modifier
    groupbox:AddToggle("WalkspeedToggle", {
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

    -- Slider pour choisir notre Vitesse
    groupbox:AddSlider("WalkspeedSlider", {
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

    -- ============================================
    -- JUMPPOWER
    -- ============================================

    -- Toggle pour activer le jumppower modifier
    groupbox:AddToggle("JumppowerToggle", {
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

    -- Slider pour choisir le JumpPower
    groupbox:AddSlider("JumppowerSlider", {
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
end

return PlayerModule
