local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/i77lhm/Libraries/refs/heads/main/Xezios/Library.lua"))()

local rgb = Color3.fromRGB
local DefaultAccent = rgb(155, 92, 92)

local Config = {}
Config.ESP = { 
    Enabled = false, Box = true, Name = true, Distance = true, Tracer = true, TracerOrigin = "Bottom", Skeleton = false, SelfESP = false, 
    MurdererColor = rgb(255, 0, 0), SheriffColor = rgb(0, 0, 255), InnocentColor = rgb(0, 255, 0), UnknownColor = rgb(255, 255, 255), 
    PlayerChams = false, PlayerGlow = false, MurdererWarning = false, WarningImageId = "rbxassetid://80149355922337",
    WeaponESP = false, WeaponBox = true, WeaponDistance = true, WeaponTracer = true, WeaponTracerOrigin = "Bottom", WeaponDot = true, WeaponChams = true, WeaponImage = false, WeaponGlow = false,
    WeaponColor = rgb(255, 200, 50), WeaponBoxColor = rgb(255, 200, 50), WeaponTracerColor = rgb(255, 200, 50), WeaponDotColor = rgb(255, 255, 255),
    WeaponImageId = "rbxassetid://80149355922337",
    CoinESP = false, CoinBox = true, CoinDistance = true, CoinTracer = true, CoinTracerOrigin = "Bottom", CoinColor = rgb(255, 255, 0)
}
Config.Combat = { 
    ShootMurderer = false, ShootMurdererFOV = 360, ShootMurdererBone = "Head", 
    KillSheriff = false, 
    BulletTP = false,
    SilentAim = false, SilentAimFOV = 150, SilentAim360 = false, SilentAimBone = "Head",
    Aimbot = false, AimbotFOV = 150, AimbotSmoothness = 3, AimbotBone = "Head", AimbotBind = Enum.KeyCode.E, StickyAim = false, WallCheck = false, 
    SharpAim = false, SharpAimFOV = 150, SharpAimColor = rgb(255, 255, 255), SharpAimShowFOV = true, SharpAimBone = "Head", 
    HitboxEnabled = false, HitboxSize = 10, HitboxTransparency = 0.5, KillAura = false, KillAuraDistance = 30, KillAll = false, Triggerbot = false, TriggerbotDelay = 50, DiedSounds = false, DiedSoundID = "rbxassetid://4817809188", AutoFling = false 
}
Config.Farm = { AutoCoins = false, FarmSpeed = 100, AutoXP = false }
Config.Movement = { Fly = false, FlySpeed = 50, Noclip = false, Speed = false, SpeedValue = 50, InfiniteJump = false, GravityZero = false, Spin = false, SpinSpeed = 10, JumpHack = false, JumpPower = 100, SmoothFall = false }
Config.Visuals = { 
    FOV = 70, InvisHead = false, Chams = { Enabled = false, Color = rgb(138, 43, 226) }, 
    ChinaHat = { Enabled = false, Color = rgb(0, 150, 255), Width = 3, Height = 3, Depth = 3, OffsetX = 0, OffsetY = 0, OffsetZ = 0 }, 
    Trail = { Enabled = false, Color = rgb(138, 43, 226), Width = 1, Time = 1, Follow = "Torso" }, 
    SelfAura = false, AuraColor = rgb(138, 43, 226), AuraCount = 50, AuraGlow = true, 
    Dick = { Enabled = false, Color = rgb(255, 200, 180) }, 
    Fullbright = false, NightMode = false, NightModeIntensity = 0, RainbowAmbient = false, RainbowSpeed = 5, CustomAmbient = false, AmbientColor = rgb(138, 43, 226), CustomFog = false, FogColor = rgb(138, 43, 226), FogStart = 0, FogEnd = 200, BulletTracers = false, TracerColor = rgb(155, 125, 175), TracerSize = 0.4, TracerTime = 1, CustomSkybox = false, SkyboxName = "Black Storm", WorldMods = false, Brightness = 0, ClockTime = 0, Exposure = 0, CharacterMaterial = false, CharColor = rgb(155, 125, 175), ToolMaterial = false, ToolColor = rgb(155, 125, 175), WalkSteps = false, FootParticles = false, FootParticleColor = rgb(255, 0, 255), FootMode = "Default", FootParticleCount = 50, FootParticleGlow = true,
    ParticleAura = false, ParticleAuraType = "angel", ParticleAuraColor = rgb(133, 220, 255), MotionBlur = false, AspectRatio = false, AspectRatioValue = 1
}
Config.Animation = { Enabled = false, ID = "rbxassetid://507771019", Speed = 1 }
Config.AnimPack = { Enabled = false, idle = "Default", walk = "Default", run = "Default", jump = "Default", climb = "Default", fall = "Default" }
Config.Misc = { AntiAFK = true, AntiFling = false, GunSoundChanger = false, GunSoundID = "rbxassetid://4817809188", GunSoundVolume = 3, WalkFling = false, MenuName = "luausense" }
Config.Players = { AutoTp = false }

local OriginalLighting = { Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart, FogColor = Lighting.FogColor, Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient, ExposureCompensation = Lighting.ExposureCompensation }
local OriginalGravity = Workspace.Gravity

local CachedChar, CachedRoot, CachedHum, CachedHead = nil, nil, nil, nil
local function UpdateCache()
    local char = LocalPlayer.Character
    if char ~= CachedChar then
        CachedChar = char
        CachedRoot = char and char:FindFirstChild("HumanoidRootPart")
        CachedHum = char and char:FindFirstChildOfClass("Humanoid")
        CachedHead = char and char:FindFirstChild("Head")
    end
    if CachedChar and (not CachedRoot or not CachedRoot.Parent) then
        CachedRoot = CachedChar:FindFirstChild("HumanoidRootPart")
        CachedHum = CachedChar:FindFirstChildOfClass("Humanoid")
        CachedHead = CachedChar:FindFirstChild("Head")
    end
end

local State = {}
State.ESPObjects = {}
State.playerChamsHighlights = {}
State.hitboxData = {}
State.weaponHighlight = nil
State.chinaHats = {}
State.chamsData = {}
State.trails = {}
State.dicks = {}
State.FOVCircle = Drawing.new("Circle")
State.aimbotFOVCircle = Drawing.new("Circle")
State.silentAimFOVCircle = Drawing.new("Circle")
State.stickyTarget = nil
State.aimbotKeyHeld = false
State.lastTrigger = 0
State.autoFarmRunning = false
State.autoFarmStartPos = nil
State.antiFlingConn = nil
State.smoothFallConn = nil
State.spinAngle = 0
State.lastSpinState = false
State.animInstance = Instance.new("Animation")
State.animTrack = nil
State.animPlaying = false
State.lastHealthTracker = {}
State.wasAliveTracker = {}
State.warningImage = nil
State.warningLabel = nil
State.selectedPlayerName = nil
State.playerNames = {}
State.warningImages = { {name = "Default", id = "rbxassetid://80149355922337"} }
State.customImageId = ""
State.customImageName = ""
State.walkFlingCooldowns = {}
State.weaponImageGui = nil
State.weaponImageLabel = nil
State.skeletonESP = {}
State.whitelist = {}
State.wlSections = {}
State.particleAuraParts = {}
State.wlVisuals = {}
State.motionBlurEffect = nil
State.lastLookVector = nil
State.walkStepsEmitter = nil
State.footParticleEmitter = nil
State.selfAuraEmitter = nil
State.adminMusic = nil
State.autoFlingCooldown = nil

State.weaponESP = { Box = Drawing.new("Quad"), DistanceText = Drawing.new("Text"), Tracer = Drawing.new("Line"), Dot = Drawing.new("Circle") }
State.weaponESP.Box.Thickness = 1.5; State.weaponESP.Box.Filled = false; State.weaponESP.Box.Transparency = 0; State.weaponESP.Box.Visible = false
State.weaponESP.DistanceText.Size = 13; State.weaponESP.DistanceText.Center = true; State.weaponESP.DistanceText.Outline = true; State.weaponESP.DistanceText.OutlineColor = rgb(0,0,0); State.weaponESP.DistanceText.Transparency = 0; State.weaponESP.DistanceText.Visible = false
State.weaponESP.Tracer.Thickness = 1; State.weaponESP.Tracer.Transparency = 0; State.weaponESP.Tracer.Visible = false
State.weaponESP.Dot.Thickness = 0; State.weaponESP.Dot.Radius = 4; State.weaponESP.Dot.Filled = true; State.weaponESP.Dot.Transparency = 0; State.weaponESP.Dot.Visible = false

State.coinDrawings = {}
State.FOVCircle.Thickness = 1; State.FOVCircle.Transparency = 0; State.FOVCircle.NumSides = 60; State.FOVCircle.Filled = false
State.aimbotFOVCircle.Thickness = 1; State.aimbotFOVCircle.Transparency = 0; State.aimbotFOVCircle.NumSides = 60; State.aimbotFOVCircle.Filled = false
State.silentAimFOVCircle.Thickness = 1; State.silentAimFOVCircle.Transparency = 0; State.silentAimFOVCircle.NumSides = 60; State.silentAimFOVCircle.Filled = false

getgenv().luausense_Admin = getgenv().luausense_Admin or {}
getgenv().luausense_Admin.Commands = getgenv().luausense_Admin.Commands or {}

local function IsAdmin()
    return LocalPlayer.UserId == 1219983923
        or LocalPlayer.Name:lower() == "V_ka13277"
        or LocalPlayer.DisplayName:lower() == "d3vstvenn1c"
end

local function SetupGui(name)
    local sg = Instance.new("ScreenGui"); sg.Name = name; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true; sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local parent = nil; pcall(function() parent = CoreGui end)
    if not parent then pcall(function() parent = LocalPlayer:FindFirstChild("PlayerGui") end) end
    if parent then sg.Parent = parent else task.spawn(function() local pg = LocalPlayer:WaitForChild("PlayerGui", 5) if pg then sg.Parent = pg end end) end
    return sg
end

local function IsAlive(player)
    if not player or not player.Parent then return false end
    local char = player.Character; if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid"); return hum and hum.Health > 0
end

local function GetMM2Role(player)
    if not player then return "Unknown" end
    local function scan(container)
        if not container then return nil end
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") then
                local n = item.Name:lower()
                if n:match("knife") or n:match("blade") or n:match("dagger") or n:match("axe") or n:match("sword") or n:match("murder") then return "Murderer" end
                if n:match("gun") or n:match("pistol") or n:match("revolver") or n:match("sheriff") then return "Sheriff" end
            end
        end; return nil
    end
    return scan(player.Character) or scan(player:FindFirstChild("Backpack")) or "Innocent"
end

local function GetClosestPlayerToMouse(fov, roleFilter, bone)
    local closest, closestDist = nil, fov or math.huge
    local mousePos = UserInputService:GetMouseLocation()
    local mouseVec2 = Vector2.new(mousePos.X, mousePos.Y)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) and (not roleFilter or GetMM2Role(player) == roleFilter) then
            local char = player.Character
            local part = char:FindFirstChild(bone or "Head") or char:FindFirstChild("HumanoidRootPart")
            if part then 
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if fov == math.huge or (onScreen and pos.Z > 0) then
                    local dist = (Vector2.new(pos.X, pos.Y) - mouseVec2).Magnitude
                    if dist < closestDist then closestDist = dist; closest = player end 
                end 
            end 
        end
    end
    return closest
end

local function PlaySound(soundId) pcall(function() local s = Instance.new("Sound"); s.SoundId = soundId; s.Volume = 3; s.Parent = workspace; s:Play(); s.Ended:Connect(function() s:Destroy() end) end) end

local function GetTracerOrigin(mode)
    local cam = Workspace.CurrentCamera or Camera
    if not cam then return Vector2.new(0,0) end
    local vp = cam.ViewportSize
    if mode == "Bottom" then return Vector2.new(vp.X/2, vp.Y)
    elseif mode == "Middle" then return Vector2.new(vp.X/2, vp.Y/2)
    elseif mode == "Top" then return Vector2.new(vp.X/2, 0)
    elseif mode == "Mouse" then 
        local m = UserInputService:GetMouseLocation()
        return Vector2.new(m.X, m.Y)
    end
    return Vector2.new(vp.X/2, vp.Y)
end

do
    local sg = SetupGui("luausenseWarning")
    State.warningImage = Instance.new("ImageLabel"); State.warningImage.Size = UDim2.new(0, 100, 0, 100); State.warningImage.Position = UDim2.new(0.5, -50, 0, 50); State.warningImage.BackgroundTransparency = 1; State.warningImage.Image = Config.ESP.WarningImageId; State.warningImage.ImageColor3 = rgb(255, 0, 0); State.warningImage.Visible = false; State.warningImage.Parent = sg
    State.warningLabel = Instance.new("TextLabel"); State.warningLabel.Size = UDim2.new(0, 300, 0, 30); State.warningLabel.Position = UDim2.new(0.5, -150, 0, 160); State.warningLabel.BackgroundTransparency = 1; State.warningLabel.Text = "MURDERER NEARBY!"; State.warningLabel.TextColor3 = rgb(255, 0, 0); State.warningLabel.Font = Enum.Font.GothamBold; State.warningLabel.TextSize = 24; State.warningLabel.Visible = false; State.warningLabel.Parent = sg
end

local function UpdateWarningAndTimer()
    if Config.ESP.MurdererWarning then
        UpdateCache()
        if CachedRoot then
            local c = false
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and IsAlive(player) and GetMM2Role(player) == "Murderer" then
                    local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if r and (r.Position - CachedRoot.Position).Magnitude <= 50 then c = true break end
                end
            end
            State.warningImage.Visible = c; State.warningLabel.Visible = c
        else
            State.warningImage.Visible = false; State.warningLabel.Visible = false
        end
    else
        State.warningImage.Visible = false; State.warningLabel.Visible = false
    end
end

LocalPlayer.Idled:Connect(function() if Config.Misc.AntiAFK then local vu = game:GetService("VirtualUser"); vu:CaptureController(); vu:ClickButton2(Vector2.new()) end end)
LocalPlayer.CharacterAdded:Connect(function() CachedChar = nil end)

local skeletonBonesR15 = {{1,"Head","UpperTorso"},{2,"UpperTorso","LowerTorso"},{3,"UpperTorso","LeftUpperArm"},{4,"LeftUpperArm","LeftLowerArm"},{5,"LeftLowerArm","LeftHand"},{6,"UpperTorso","RightUpperArm"},{7,"RightUpperArm","RightLowerArm"},{8,"RightLowerArm","RightHand"},{9,"LowerTorso","LeftUpperLeg"},{10,"LeftUpperLeg","LeftLowerLeg"},{11,"LeftLowerLeg","LeftFoot"},{12,"LowerTorso","RightUpperLeg"},{13,"RightUpperLeg","RightLowerLeg"},{14,"RightLowerLeg","RightFoot"}}
local skeletonBonesR6 = {{1,"Head","Torso"},{2,"Torso","Left Arm"},{3,"Torso","Right Arm"},{4,"Torso","Left Leg"},{5,"Torso","Right Leg"}}

local function CreateESP(player)
    if State.ESPObjects[player] then return end
    local obj = {}
    obj.Box = Drawing.new("Quad"); obj.Box.Thickness = 1.5; obj.Box.Filled = false; obj.Box.Transparency = 0; obj.Box.Visible = false
    obj.NameText = Drawing.new("Text"); obj.NameText.Size = 13; obj.NameText.Center = true; obj.NameText.Outline = true; obj.NameText.OutlineColor = rgb(0,0,0); obj.NameText.Transparency = 0; obj.NameText.Visible = false
    obj.RoleText = Drawing.new("Text"); obj.RoleText.Size = 11; obj.RoleText.Center = true; obj.RoleText.Outline = true; obj.RoleText.OutlineColor = rgb(0,0,0); obj.RoleText.Transparency = 0; obj.RoleText.Visible = false
    obj.DistanceText = Drawing.new("Text"); obj.DistanceText.Size = 11; obj.DistanceText.Center = true; obj.DistanceText.Outline = true; obj.DistanceText.OutlineColor = rgb(0,0,0); obj.DistanceText.Transparency = 0; obj.DistanceText.Visible = false
    obj.Tracer = Drawing.new("Line"); obj.Tracer.Thickness = 1; obj.Tracer.Transparency = 0; obj.Tracer.Visible = false
    State.ESPObjects[player] = obj; State.skeletonESP[player] = {}
    for i=1, 14 do
        State.skeletonESP[player][i] = Drawing.new("Line"); State.skeletonESP[player][i].Thickness = 1; State.skeletonESP[player][i].Transparency = 0; State.skeletonESP[player][i].Visible = false
    end
end

local function RemoveESP(player)
    local obj = State.ESPObjects[player]; if not obj then return end
    pcall(function() obj.Box:Remove() end); pcall(function() obj.NameText:Remove() end); pcall(function() obj.RoleText:Remove() end); pcall(function() obj.DistanceText:Remove() end); pcall(function() obj.Tracer:Remove() end)
    State.ESPObjects[player] = nil
    if State.skeletonESP[player] then for _, l in ipairs(State.skeletonESP[player]) do pcall(function() l:Remove() end) end; State.skeletonESP[player] = nil end
    if State.playerChamsHighlights[player] then pcall(function() State.playerChamsHighlights[player]:Destroy() end); State.playerChamsHighlights[player] = nil end
end

for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(function(p) RemoveESP(p) end)

local function HideObj(obj)
    pcall(function()
        obj.Box.Visible = false; obj.NameText.Visible = false; obj.RoleText.Visible = false; obj.DistanceText.Visible = false; obj.Tracer.Visible = false
        obj.Box.PointA = Vector2.new(-9999,-9999); obj.Box.PointB = Vector2.new(-9999,-9999); obj.Box.PointC = Vector2.new(-9999,-9999); obj.Box.PointD = Vector2.new(-9999,-9999)
        obj.NameText.Position = Vector2.new(-9999,-9999); obj.RoleText.Position = Vector2.new(-9999,-9999); obj.DistanceText.Position = Vector2.new(-9999,-9999); obj.Tracer.From = Vector2.new(-9999,-9999); obj.Tracer.To = Vector2.new(-9999,-9999)
    end)
end

local function UpdateESP()
    local cam = Workspace.CurrentCamera or Camera
    if not cam then return end
    
    for _, obj in pairs(State.ESPObjects) do pcall(HideObj, obj) end
    for _, sk in pairs(State.skeletonESP) do for _, l in ipairs(sk) do pcall(function() l.Visible = false; l.From = Vector2.new(-9999,-9999); l.To = Vector2.new(-9999,-9999) end) end end
    if not Config.ESP.Enabled then return end
    local toRemove = {}
    for player, obj in pairs(State.ESPObjects) do
        if not player or not player.Parent then 
            table.insert(toRemove, player) 
        else
            local char = player.Character
            if char then
                local hum, root, head = char:FindFirstChildOfClass("Humanoid"), char:FindFirstChild("HumanoidRootPart"), char:FindFirstChild("Head")
                if hum and root and head and hum.Health > 0 then
                    local isSelf = (player == LocalPlayer)
                    if not isSelf or Config.ESP.SelfESP then
                        local rootPos, onScreen = cam:WorldToViewportPoint(root.Position)
                        if onScreen and rootPos.Z >= 0 then
                            local role = GetMM2Role(player); local color = Config.ESP.UnknownColor
                            if role == "Murderer" then color = Config.ESP.MurdererColor elseif role == "Sheriff" then color = Config.ESP.SheriffColor elseif role == "Innocent" then color = Config.ESP.InnocentColor end
                            if State.whitelist[player] and State.whitelist[player].ESPColor then color = State.whitelist[player].ESPColor end
                            local headPos = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)); local legPos = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                            local height = math.abs(headPos.Y - legPos.Y); if height < 10 then height = 10 end; local halfWidth = height / 4.44
                            if Config.ESP.Box then pcall(function() obj.Box.Visible = true; obj.Box.PointA = Vector2.new(rootPos.X - halfWidth, headPos.Y); obj.Box.PointB = Vector2.new(rootPos.X + halfWidth, headPos.Y); obj.Box.PointC = Vector2.new(rootPos.X + halfWidth, legPos.Y); obj.Box.PointD = Vector2.new(rootPos.X - halfWidth, legPos.Y); obj.Box.Color = color end) end
                            if Config.ESP.Name then pcall(function() obj.NameText.Visible = true; obj.NameText.Text = player.DisplayName; obj.NameText.Position = Vector2.new(rootPos.X, headPos.Y - 18); obj.NameText.Color = color end) end
                            pcall(function() obj.RoleText.Visible = true; obj.RoleText.Text = "[" .. role:upper() .. "]"; obj.RoleText.Position = Vector2.new(rootPos.X, headPos.Y - 32); obj.RoleText.Color = color end)
                            if Config.ESP.Distance then pcall(function() local dist = math.floor((cam.CFrame.Position - root.Position).Magnitude); obj.DistanceText.Visible = true; obj.DistanceText.Text = "[" .. dist .. "m]"; obj.DistanceText.Position = Vector2.new(rootPos.X, legPos.Y + 4); obj.DistanceText.Color = color end) end
                            if Config.ESP.Tracer and not isSelf then pcall(function() obj.Tracer.Visible = true; obj.Tracer.From = GetTracerOrigin(Config.ESP.TracerOrigin); obj.Tracer.To = Vector2.new(rootPos.X, rootPos.Y); obj.Tracer.Color = color end) end
                            if Config.ESP.Skeleton then
                                local bones = char:FindFirstChild("UpperTorso") and skeletonBonesR15 or skeletonBonesR6
                                for _, bone in ipairs(bones) do
                                    local idx = bone[1]; local p1n = bone[2]; local p2n = bone[3]
                                    local p1 = char:FindFirstChild(p1n); local p2 = char:FindFirstChild(p2n)
                                    if p1 and p2 then
                                        local pos1, vis1 = cam:WorldToViewportPoint(p1.Position); local pos2, vis2 = cam:WorldToViewportPoint(p2.Position)
                                        local line = State.skeletonESP[player] and State.skeletonESP[player][idx]
                                        if line and vis1 and vis2 then
                                            pcall(function() line.Visible = true; line.From = Vector2.new(pos1.X, pos1.Y); line.To = Vector2.new(pos2.X, pos2.Y); line.Color = color end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    for _, p in ipairs(toRemove) do RemoveESP(p) end
end

local function UpdatePlayerChams()
    for player, hl in pairs(State.playerChamsHighlights) do
        local shouldHave = (Config.ESP.PlayerChams and player ~= LocalPlayer) or (State.whitelist[player] and State.whitelist[player].Chams)
        if not player or not player.Parent or not IsAlive(player) or not shouldHave or (hl.Parent and hl.Parent ~= player.Character) then
            pcall(function() hl:Destroy() end); State.playerChamsHighlights[player] = nil
        end
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            local shouldHave = (Config.ESP.PlayerChams) or (State.whitelist[player] and State.whitelist[player].Chams)
            if shouldHave then
                local char = player.Character
                if char then
                    local role = GetMM2Role(player); local color = Config.ESP.UnknownColor
                    if role == "Murderer" then color = Config.ESP.MurdererColor elseif role == "Sheriff" then color = Config.ESP.SheriffColor elseif role == "Innocent" then color = Config.ESP.InnocentColor end
                    if State.whitelist[player] and State.whitelist[player].ESPColor then color = State.whitelist[player].ESPColor end
                    
                    if not State.playerChamsHighlights[player] or not State.playerChamsHighlights[player].Parent or State.playerChamsHighlights[player].Parent ~= char then
                        pcall(function() if State.playerChamsHighlights[player] then State.playerChamsHighlights[player]:Destroy() end end)
                        local hl = Instance.new("Highlight"); hl.Parent = char; hl.FillColor = color; hl.OutlineColor = color; hl.FillTransparency = 0.5; hl.OutlineTransparency = 0; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; State.playerChamsHighlights[player] = hl
                    else
                        State.playerChamsHighlights[player].FillColor = color; State.playerChamsHighlights[player].OutlineColor = color
                        if Config.ESP.PlayerGlow then State.playerChamsHighlights[player].OutlineTransparency = 1; State.playerChamsHighlights[player].FillTransparency = 0.2
                        else State.playerChamsHighlights[player].OutlineTransparency = 0; State.playerChamsHighlights[player].FillTransparency = 0.5 end
                    end
                end
            end
        end
    end
end

local function UpdateWeaponESP()
    State.weaponESP.Box.Visible = false; State.weaponESP.DistanceText.Visible = false; State.weaponESP.Tracer.Visible = false; State.weaponESP.Dot.Visible = false
    if not Config.ESP.WeaponESP then if State.weaponHighlight then pcall(function() State.weaponHighlight:Destroy() end) State.weaponHighlight = nil end return end
    local gun = Workspace:FindFirstChild("GunDrop", true)
    if not gun or not gun.Parent then if State.weaponHighlight then pcall(function() State.weaponHighlight:Destroy() end) State.weaponHighlight = nil end return end
    if Config.ESP.WeaponChams then
        if not State.weaponHighlight or not State.weaponHighlight.Parent then
            if State.weaponHighlight then pcall(function() State.weaponHighlight:Destroy() end) end
            State.weaponHighlight = Instance.new("Highlight"); State.weaponHighlight.Parent = gun; State.weaponHighlight.FillColor = Config.ESP.WeaponColor; State.weaponHighlight.OutlineColor = Config.ESP.WeaponColor; State.weaponHighlight.FillTransparency = 0.5; State.weaponHighlight.OutlineTransparency = 0; State.weaponHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        else
            State.weaponHighlight.FillColor = Config.ESP.WeaponColor; State.weaponHighlight.OutlineColor = Config.ESP.WeaponColor
            if Config.ESP.WeaponGlow then State.weaponHighlight.OutlineTransparency = 1; State.weaponHighlight.FillTransparency = 0.2
            else State.weaponHighlight.OutlineTransparency = 0; State.weaponHighlight.FillTransparency = 0.5 end
        end
    else
        if State.weaponHighlight then pcall(function() State.weaponHighlight:Destroy() end) State.weaponHighlight = nil end
    end
    local pos, onScreen = Camera:WorldToViewportPoint(gun.Position)
    if not onScreen or pos.Z < 0 then return end
    local bs = 25
    if Config.ESP.WeaponBox then State.weaponESP.Box.Visible = true; State.weaponESP.Box.PointA = Vector2.new(pos.X - bs, pos.Y - bs); State.weaponESP.Box.PointB = Vector2.new(pos.X + bs, pos.Y - bs); State.weaponESP.Box.PointC = Vector2.new(pos.X + bs, pos.Y + bs); State.weaponESP.Box.PointD = Vector2.new(pos.X - bs, pos.Y + bs); State.weaponESP.Box.Color = Config.ESP.WeaponBoxColor end
    if Config.ESP.WeaponDistance then local d = math.floor((Camera.CFrame.Position - gun.Position).Magnitude); State.weaponESP.DistanceText.Visible = true; State.weaponESP.DistanceText.Text = "[Gun " .. d .. "m]"; State.weaponESP.DistanceText.Position = Vector2.new(pos.X, pos.Y + 30); State.weaponESP.DistanceText.Color = Config.ESP.WeaponColor end
    if Config.ESP.WeaponTracer then State.weaponESP.Tracer.Visible = true; State.weaponESP.Tracer.From = GetTracerOrigin(Config.ESP.WeaponTracerOrigin); State.weaponESP.Tracer.To = Vector2.new(pos.X, pos.Y); State.weaponESP.Tracer.Color = Config.ESP.WeaponTracerColor end
    if Config.ESP.WeaponDot then State.weaponESP.Dot.Visible = true; State.weaponESP.Dot.Position = Vector2.new(pos.X, pos.Y); State.weaponESP.Dot.Color = Config.ESP.WeaponDotColor end
end

local function UpdateCoinESP()
    local coinContainer = Workspace:FindFirstChild("CoinContainer", true)
    local currentCoins = coinContainer and coinContainer:GetChildren() or {}
    for coin, d in pairs(State.coinDrawings) do
        if not coin or not coin.Parent or not table.find(currentCoins, coin) then
            pcall(function() d.Box:Remove() end); pcall(function() d.DistanceText:Remove() end); pcall(function() d.Tracer:Remove() end)
            State.coinDrawings[coin] = nil
        else
            d.Box.Visible = false; d.DistanceText.Visible = false; d.Tracer.Visible = false
        end
    end
    if not Config.ESP.CoinESP then return end
    for _, coin in ipairs(currentCoins) do
        if coin:IsA("BasePart") then
            local pos, onScreen = Camera:WorldToViewportPoint(coin.Position)
            if onScreen and pos.Z > 0 then
                if not State.coinDrawings[coin] then
                    State.coinDrawings[coin] = { Box = Drawing.new("Quad"), DistanceText = Drawing.new("Text"), Tracer = Drawing.new("Line") }
                    State.coinDrawings[coin].Box.Thickness = 1.5; State.coinDrawings[coin].Box.Filled = false; State.coinDrawings[coin].Box.Transparency = 0
                    State.coinDrawings[coin].DistanceText.Size = 13; State.coinDrawings[coin].DistanceText.Center = true; State.coinDrawings[coin].DistanceText.Outline = true; State.coinDrawings[coin].DistanceText.OutlineColor = rgb(0,0,0); State.coinDrawings[coin].DistanceText.Transparency = 0
                    State.coinDrawings[coin].Tracer.Thickness = 1; State.coinDrawings[coin].Tracer.Transparency = 0
                end
                local d = State.coinDrawings[coin]
                local bs = 15
                if Config.ESP.CoinBox then d.Box.Visible = true; d.Box.PointA = Vector2.new(pos.X - bs, pos.Y - bs); d.Box.PointB = Vector2.new(pos.X + bs, pos.Y - bs); d.Box.PointC = Vector2.new(pos.X + bs, pos.Y + bs); d.Box.PointD = Vector2.new(pos.X - bs, pos.Y + bs); d.Box.Color = Config.ESP.CoinColor end
                if Config.ESP.CoinDistance then local dist = math.floor((Camera.CFrame.Position - coin.Position).Magnitude); d.DistanceText.Visible = true; d.DistanceText.Text = "[Coin " .. dist .. "m]"; d.DistanceText.Position = Vector2.new(pos.X, pos.Y + 20); d.DistanceText.Color = Config.ESP.CoinColor end
                if Config.ESP.CoinTracer then d.Tracer.Visible = true; d.Tracer.From = GetTracerOrigin(Config.ESP.CoinTracerOrigin); d.Tracer.To = Vector2.new(pos.X, pos.Y); d.Tracer.Color = Config.ESP.CoinColor end
            end
        end
    end
end

local function ShootMurderer()
    UpdateCache()
    if not CachedChar then return end
    local tool = CachedChar:FindFirstChildOfClass("Tool")
    if not tool or not (tool.Name:lower():match("gun") or tool.Name:lower():match("pistol")) then return end
    local fov = Config.Combat.ShootMurdererFOV >= 360 and math.huge or Config.Combat.ShootMurdererFOV
    local t = GetClosestPlayerToMouse(fov, "Murderer", Config.Combat.ShootMurdererBone)
    if t and t.Character then
        local p = t.Character:FindFirstChild(Config.Combat.ShootMurdererBone) or t.Character:FindFirstChild("Head")
        if p then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Position)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Position)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Position)
            pcall(function() tool:Activate() end)
            if mouse1click then pcall(function() mouse1click() end) end
        end
    end
end

local function KillSheriffStep()
    if not Config.Combat.KillSheriff then return end
    if GetMM2Role(LocalPlayer) ~= "Murderer" then return end
    UpdateCache()
    if not CachedRoot or not CachedChar then return end
    local tool = CachedChar:FindFirstChildOfClass("Tool")
    if not tool then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) and GetMM2Role(player) == "Sheriff" and not (State.whitelist[player] and State.whitelist[player].IgnoreKill) then
            local char = player.Character; local theirRoot = char:FindFirstChild("HumanoidRootPart")
            if theirRoot then
                theirRoot.CFrame = CachedRoot.CFrame * CFrame.new(0, 0, -3)
                tool:Activate()
                task.wait(0.1)
            end
            break
        end
    end
end

local function IsVisible(tp)
    if not Config.Combat.WallCheck then return true end
    local o = Camera.CFrame.Position; local d = tp.Position - o
    local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = {LocalPlayer.Character}
    local r = Workspace:Raycast(o, d, rp)
    if r then return r.Instance:IsDescendantOf(tp.Parent) end
    return true
end

local function UpdateAimStep()
    local mousePos = UserInputService:GetMouseLocation()
    local mouseVec2 = Vector2.new(mousePos.X, mousePos.Y)

    State.FOVCircle.Visible = Config.Combat.SharpAim and Config.Combat.SharpAimShowFOV; State.FOVCircle.Radius = Config.Combat.SharpAimFOV; State.FOVCircle.Position = mouseVec2; State.FOVCircle.Color = Config.Combat.SharpAimColor
    State.aimbotFOVCircle.Visible = Config.Combat.Aimbot; State.aimbotFOVCircle.Radius = Config.Combat.AimbotFOV; State.aimbotFOVCircle.Position = mouseVec2
    State.silentAimFOVCircle.Visible = Config.Combat.SilentAim and not Config.Combat.SilentAim360; State.silentAimFOVCircle.Radius = Config.Combat.SilentAimFOV; State.silentAimFOVCircle.Position = mouseVec2; State.silentAimFOVCircle.Color = rgb(255,255,0)

    if Config.Combat.SharpAim then
        UpdateCache()
        if CachedChar then
            local tool = CachedChar:FindFirstChildOfClass("Tool")
            if tool and (tool.Name:lower():match("gun") or tool.Name:lower():match("pistol")) then
                local t = GetClosestPlayerToMouse(Config.Combat.SharpAimFOV, nil, Config.Combat.SharpAimBone)
                if t and t.Character then
                    local p = t.Character:FindFirstChild(Config.Combat.SharpAimBone) or t.Character:FindFirstChild("Head")
                    if p then Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Position) end
                end
            end
        end
    end

    if Config.Combat.Aimbot and State.aimbotKeyHeld then
        local a = 1 / Config.Combat.AimbotSmoothness; if a > 1 then a = 1 end
        if Config.Combat.StickyAim and State.stickyTarget and IsAlive(State.stickyTarget) then
            local c = State.stickyTarget.Character; local p = c:FindFirstChild(Config.Combat.AimbotBone) or c:FindFirstChild("Head")
            if p and IsVisible(p) then
                local pos, on = Camera:WorldToViewportPoint(p.Position)
                if on then
                    local m = (Vector2.new(pos.X, pos.Y) - mouseVec2).Magnitude
                    if m <= Config.Combat.AimbotFOV then local tcf = CFrame.new(Camera.CFrame.Position, p.Position); Camera.CFrame = Camera.CFrame:Lerp(tcf, a) return end
                end
            end
            State.stickyTarget = nil
        end
        local t = GetClosestPlayerToMouse(Config.Combat.AimbotFOV, nil, Config.Combat.AimbotBone)
        if t then
            local c = t.Character; local p = c:FindFirstChild(Config.Combat.AimbotBone) or c:FindFirstChild("Head")
            if p and IsVisible(p) then State.stickyTarget = t; local tcf = CFrame.new(Camera.CFrame.Position, p.Position); Camera.CFrame = Camera.CFrame:Lerp(tcf, a) end
        end
    end
end

local function UpdateHitbox()
    for player, parts in pairs(State.hitboxData) do
        if not player or not player.Parent or not IsAlive(player) or not Config.Combat.HitboxEnabled then
            for part, orig in pairs(parts) do if part and part.Parent then pcall(function() part.Size = orig.Size; part.Transparency = orig.Transparency; part.CanCollide = orig.CanCollide; part.CanTouch = orig.CanTouch; part.CanQuery = orig.CanQuery end) end end
            State.hitboxData[player] = nil
        end
    end
    if not Config.Combat.HitboxEnabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            local char = player.Character; if char then
                if not State.hitboxData[player] then State.hitboxData[player] = {} end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if not State.hitboxData[player][part] then State.hitboxData[player][part] = { Size = part.Size, Transparency = part.Transparency, CanCollide = part.CanCollide, CanTouch = part.CanTouch, CanQuery = part.CanQuery } end
                        part.Size = Vector3.new(Config.Combat.HitboxSize, Config.Combat.HitboxSize, Config.Combat.HitboxSize); part.Transparency = Config.Combat.HitboxTransparency; part.CanCollide = false; part.CanTouch = true; part.CanQuery = true
                    end
                end
            end
        end
    end
end

local function KillAuraStep()
    if not Config.Combat.KillAura then return end
    if GetMM2Role(LocalPlayer) ~= "Murderer" then return end
    UpdateCache()
    if not CachedRoot or not CachedChar then return end
    local tool = CachedChar:FindFirstChildOfClass("Tool")
    if not tool then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) and GetMM2Role(player) ~= "Murderer" and not (State.whitelist[player] and State.whitelist[player].IgnoreKill) then
            local char = player.Character; local theirRoot = char:FindFirstChild("HumanoidRootPart")
            if theirRoot and (theirRoot.Position - CachedRoot.Position).Magnitude <= Config.Combat.KillAuraDistance then
                local savedCF = theirRoot.CFrame; local look = CachedRoot.CFrame.LookVector
                theirRoot.CFrame = CachedRoot.CFrame + Vector3.new(look.X * 3, look.Y * 3, look.Z * 3)
                task.spawn(function() pcall(function() tool:Activate() end); task.wait(0.1); theirRoot.CFrame = savedCF end)
            end
        end
    end
end

local function KillAllStep()
    if not Config.Combat.KillAll then return end
    if GetMM2Role(LocalPlayer) ~= "Murderer" then return end
    UpdateCache()
    if not CachedRoot or not CachedChar then return end
    local tool = CachedChar:FindFirstChildOfClass("Tool")
    if not tool then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) and GetMM2Role(player) ~= "Murderer" and not (State.whitelist[player] and State.whitelist[player].IgnoreKill) then
            local char = player.Character; local theirRoot = char:FindFirstChild("HumanoidRootPart")
            if theirRoot then theirRoot.CFrame = CachedRoot.CFrame * CFrame.new(0, 0, -3); tool:Activate(); task.wait(0.1) end
        end
    end
end

local function UpdateHitEffects()
    if not Config.Combat.DiedSounds then State.lastHealthTracker = {}; State.wasAliveTracker = {}; return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character; local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                local currentHP = math.floor(hum.Health); local wasAlive = State.wasAliveTracker[player]; local isAliveNow = currentHP > 0
                if Config.Combat.DiedSounds and wasAlive and not isAliveNow then PlaySound(Config.Combat.DiedSoundID) end
                State.lastHealthTracker[player] = currentHP; State.wasAliveTracker[player] = isAliveNow
            else
                State.wasAliveTracker[player] = false
            end
        end
    end
end

local function make_point(position, lifetime)
    local part = Instance.new("Part")
    part.Transparency = 1; part.Anchored = true; part.CanCollide = false; part.CanQuery = false; part.Size = Vector3.new(1, 1, 1)
    part.CFrame = CFrame.new(position)
    Instance.new("Attachment", part)
    Debris:AddItem(part, lifetime)
    part.Parent = Workspace
    return part
end

local function create_tracer(startPos, endPos, color)
    local duration = Config.Visuals.TracerTime or 1
    local start_part = make_point(startPos, duration + 0.5)
    local end_part = make_point(endPos, duration + 0.5)
    local beam = Instance.new("Beam")
    beam.FaceCamera = true; beam.TextureSpeed = 1.5; beam.TextureLength = 2; beam.Width0 = 0.25; beam.Width1 = 0.25
    beam.LightEmission = 3; beam.LightInfluence = 0; beam.Brightness = 2.5; beam.Texture = "rbxassetid://12781800668"
    beam.Color = ColorSequence.new(color)
    beam.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 0.1) })
    beam.Attachment0 = start_part.Attachment; beam.Attachment1 = end_part.Attachment
    beam.Parent = start_part
    task.delay(duration, function()
        if beam.Parent then TweenService:Create(beam, TweenInfo.new(0.3), { Width0 = 0, Width1 = 0 }):Play() end
    end)
end

local okConn, gunFiredRemote = pcall(function() return ReplicatedStorage:WaitForChild("ClientServices"):WaitForChild("WeaponService"):WaitForChild("GunFired") end)
if okConn and gunFiredRemote then
    gunFiredRemote.OnClientEvent:Connect(function(gun, start_value, end_value)
        if Config.Visuals.BulletTracers then
            UpdateCache()
            if CachedChar and typeof(gun) == "Instance" and gun:IsDescendantOf(CachedChar) then
                local sPos = typeof(start_value) == "Vector3" and start_value or (typeof(start_value) == "Instance" and start_value:IsA("BasePart") and start_value.Position)
                local ePos = typeof(end_value) == "Vector3" and end_value or (typeof(end_value) == "Instance" and end_value:IsA("BasePart") and end_value.Position)
                if sPos and ePos then create_tracer(sPos, ePos, Config.Visuals.TracerColor) end
            end
        end
    end)
end

local function GetMurderer()
    local ok, roles = pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
        return remote and remote:InvokeServer()
    end)
    if not ok or typeof(roles) ~= "table" then return end
    for k, v in pairs(roles) do
        if v.Role == "Murderer" then
            return typeof(k) == "Instance" and k or Players:FindFirstChild(k)
        end
    end
end

local function BulletTPShoot()
    local murderer = GetMurderer()
    if not murderer or not murderer.Character then return end
    local hrp = murderer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local char = LocalPlayer.Character
    if not char then return end
    local gun = char:FindFirstChild("Gun")
    if not gun then return end
    local shootRemote = gun:FindFirstChild("Shoot")
    local handle = gun:FindFirstChild("Handle")
    if not shootRemote or not handle then return end
    local targetPos = hrp.Position
    local direction = (targetPos - handle.Position).Unit
    local fakeOrigin = targetPos - direction * 3
    local shootCF = CFrame.lookAt(fakeOrigin, targetPos)
    local hitCF = CFrame.new(targetPos)
    pcall(function()
        shootRemote:FireServer(shootCF, hitCF)
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if Config.Combat.BulletTP and input.KeyCode == Enum.KeyCode.T then
        BulletTPShoot()
    end
end)

task.spawn(function()
    local okWS, WeaponService = pcall(function() return require(ReplicatedStorage:WaitForChild("ClientServices", 10):WaitForChild("WeaponService", 10)) end)
    if okWS and WeaponService and WeaponService.GetMouseTargetCFrame then
        local oldGet = WeaponService.GetMouseTargetCFrame
        WeaponService.GetMouseTargetCFrame = function(self, ...)
            if Config.Combat.SilentAim then
                local lp = LocalPlayer
                local localTool = nil
                UpdateCache()
                if CachedChar then
                    local tool = CachedChar:FindFirstChildOfClass("Tool")
                    if tool and (tool.Name == "Gun" or tool.Name == "Knife") then localTool = tool.Name end
                end
                if not localTool and lp:FindFirstChild("Backpack") then
                    local tool = lp.Backpack:FindFirstChildOfClass("Tool")
                    if tool and (tool.Name == "Gun" or tool.Name == "Knife") then localTool = tool.Name end
                end
                
                if localTool then
                    local mousePos = UserInputService:GetMouseLocation()
                    local mouseVec2 = Vector2.new(mousePos.X, mousePos.Y)
                    local closest, dist = nil, math.huge
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= lp and IsAlive(p) then
                            local char = p.Character
                            local hasKnife, hasGun = false, false
                            for _, loc in ipairs({char, p:FindFirstChild("Backpack")}) do
                                if loc then
                                    for _, item in ipairs(loc:GetChildren()) do
                                        if item:IsA("Tool") then
                                            if item.Name == "Knife" then hasKnife = true end
                                            if item.Name == "Gun" then hasGun = true end
                                        end
                                    end
                                end
                            end
                            
                            local valid = false
                            if localTool == "Gun" then
                                valid = hasKnife
                            elseif localTool == "Knife" then
                                valid = hasGun or not hasKnife
                            end
                            
                            if valid then
                                local hrp = char:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    local bone = Config.Combat.SilentAimBone
                                    local targetPart = char:FindFirstChild(bone) or hrp
                                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                                    if Config.Combat.SilentAim360 then
                                        local d3 = (targetPart.Position - Camera.CFrame.Position).Magnitude
                                        if d3 < dist then dist = d3; closest = targetPart end
                                    else
                                        if onScreen then
                                            local d2 = (Vector2.new(screenPos.X, screenPos.Y) - mouseVec2).Magnitude
                                            if d2 < dist and d2 <= Config.Combat.SilentAimFOV then
                                                dist = d2; closest = targetPart
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if closest then
                        return CFrame.new(closest.Position + Vector3.new(0, 0.5, 0))
                    end
                end
            end
            return oldGet(self, ...)
        end
    end
end)

local function TriggerbotStep()
    if not Config.Combat.Triggerbot then return end
    local target = Mouse.Target
    if target then
        local char = target.Parent; local player = Players:GetPlayerFromCharacter(char)
        if player and player ~= LocalPlayer then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                if tick() - State.lastTrigger >= (Config.Combat.TriggerbotDelay / 1000) then
                    UpdateCache()
                    if CachedChar then local tool = CachedChar:FindFirstChildOfClass("Tool") if tool then pcall(function() tool:Activate() end) end end
                    State.lastTrigger = tick()
                end
            end
        end
    end
end

local function WalkFlingStep()
    if not Config.Misc.WalkFling then return end
    UpdateCache()
    if not CachedRoot or not CachedHum then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) and not (State.whitelist[player] and State.whitelist[player].IgnoreKill) then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (root.Position - CachedRoot.Position).Magnitude
                if dist < 8 then
                    if not State.walkFlingCooldowns[player] or tick() - State.walkFlingCooldowns[player] > 2 then
                        State.walkFlingCooldowns[player] = tick()
                        task.spawn(function()
                            pcall(function()
                                local savedPos = CachedRoot.CFrame
                                CachedRoot.CFrame = root.CFrame * CFrame.new(0, 0, -3)
                                CachedRoot.AssemblyLinearVelocity = (root.Position - CachedRoot.Position).Unit * 500 + Vector3.new(0, 100, 0)
                                task.wait(0.1)
                                CachedRoot.CFrame = savedPos
                            end)
                        end)
                    end
                end
            end
        end
    end
end

local function FlingPlayer(targetPlayer)
    if type(targetPlayer) == "string" then targetPlayer = Players:FindFirstChild(targetPlayer) end
    if not targetPlayer or not IsAlive(targetPlayer) then return end
    UpdateCache()
    if not CachedRoot or not CachedHum then return end
    local tCharacter = targetPlayer.Character; local tHumanoid = tCharacter and tCharacter:FindFirstChildOfClass("Humanoid"); local tRootPart = tHumanoid and tHumanoid.RootPart; local tHead = tCharacter and tCharacter:FindFirstChild("Head")
    local accessory = tCharacter and tCharacter:FindFirstChildOfClass("Accessory"); local handle = accessory and accessory:FindFirstChild("Handle")
    if CachedChar and CachedHum and CachedRoot then
        if CachedRoot.AssemblyLinearVelocity.Magnitude < 50 then getgenv().OldPos = CachedRoot:GetPivot() end
        if tHumanoid and tHumanoid.Sit then return end
        if tHead then workspace.CurrentCamera.CameraSubject = tHead elseif handle then workspace.CurrentCamera.CameraSubject = handle else workspace.CurrentCamera.CameraSubject = tHumanoid end
        if not tCharacter:FindFirstChildWhichIsA("BasePart") then return end
        local function FPos(basePart, pos, ang) CachedRoot.CFrame = CFrame.new(basePart.Position) * pos * ang; CachedChar:PivotTo(CFrame.new(basePart.Position) * pos * ang); CachedRoot.AssemblyLinearVelocity = Vector3.new(9e7, 9e7 * 10, 9e7); CachedRoot.AssemblyAngularVelocity = Vector3.new(9e8, 9e8, 9e8) end
        local function SFBasePart(basePart)
            local timeToWait = 2; local time = tick(); local angle = 0
            repeat
                if CachedRoot and tHumanoid then
                    if basePart.AssemblyLinearVelocity.Magnitude < 50 then
                        angle = angle + 100
                        FPos(basePart, CFrame.new(0, 1.5, 0) + tHumanoid.MoveDirection * basePart.AssemblyLinearVelocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                        FPos(basePart, CFrame.new(0, -1.5, 0) + tHumanoid.MoveDirection * basePart.AssemblyLinearVelocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                        FPos(basePart, CFrame.new(2.25, 1.5, -2.25) + tHumanoid.MoveDirection * basePart.AssemblyLinearVelocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                        FPos(basePart, CFrame.new(-2.25, -1.5, 2.25) + tHumanoid.MoveDirection * basePart.AssemblyLinearVelocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                        FPos(basePart, CFrame.new(0, 1.5, 0) + tHumanoid.MoveDirection, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                        FPos(basePart, CFrame.new(0, -1.5, 0) + tHumanoid.MoveDirection, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                    else
                        FPos(basePart, CFrame.new(0, 1.5, tHumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                        FPos(basePart, CFrame.new(0, -1.5, -tHumanoid.WalkSpeed), CFrame.Angles(0, 0, 0)); task.wait()
                        FPos(basePart, CFrame.new(0, 1.5, tHumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                        FPos(basePart, CFrame.new(0, 1.5, tRootPart.AssemblyLinearVelocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                        FPos(basePart, CFrame.new(0, -1.5, -tRootPart.AssemblyLinearVelocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0)); task.wait()
                        FPos(basePart, CFrame.new(0, 1.5, tRootPart.AssemblyLinearVelocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                        FPos(basePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                        FPos(basePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0)); task.wait()
                        FPos(basePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0)); task.wait()
                        FPos(basePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0)); task.wait()
                    end
                else break end
            until basePart.AssemblyLinearVelocity.Magnitude > 500 or basePart.Parent ~= targetPlayer.Character or targetPlayer.Parent ~= Players or targetPlayer.Character ~= tCharacter or tHumanoid.Sit or CachedHum.Health <= 0 or tick() > time + timeToWait
        end
        workspace.FallenPartsDestroyHeight = 0 / 0
        local bv = Instance.new("BodyVelocity"); bv.Name = "EpixVel"; bv.Parent = CachedRoot; bv.Velocity = Vector3.new(9e8, 9e8, 9e8); bv.MaxForce = Vector3.new(1 / 0, 1 / 0, 1 / 0)
        CachedHum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        if tRootPart and tHead then
            if (tRootPart.CFrame.p - tHead.CFrame.p).Magnitude > 5 then SFBasePart(tHead) else SFBasePart(tRootPart) end
        elseif tRootPart and not tHead then SFBasePart(tRootPart)
        elseif not tRootPart and tHead then SFBasePart(tHead)
        elseif not tRootPart and not tHead and accessory and handle then SFBasePart(handle)
        else return end
        bv:Destroy(); CachedHum:SetStateEnabled(Enum.HumanoidStateType.Seated, true); workspace.CurrentCamera.CameraSubject = CachedHum
        repeat
            CachedRoot.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0); CachedChar:PivotTo(getgenv().OldPos * CFrame.new(0, .5, 0)); CachedHum:ChangeState("GettingUp")
            for _, x in ipairs(CachedChar:GetChildren()) do if x:IsA("BasePart") then x.AssemblyLinearVelocity = Vector3.new(); x.AssemblyAngularVelocity = Vector3.new() end end
            task.wait()
        until (CachedRoot.Position - getgenv().OldPos.p).Magnitude < 25
        workspace.FallenPartsDestroyHeight = workspace.FallenPartsDestroyHeight; getgenv().OldPos = nil
    end
end

local function FlingByRole(role)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) and GetMM2Role(player) == role then FlingPlayer(player) break end
    end
end

local function FlingAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then task.spawn(function() FlingPlayer(player) end) end
    end
end

local function AutoFlingStep()
    if not Config.Combat.AutoFling then return end
    if not State.selectedPlayerName then return end
    local target = Players:FindFirstChild(State.selectedPlayerName)
    if target and IsAlive(target) and not State.whitelist[target] then
        if not State.autoFlingCooldown or tick() - State.autoFlingCooldown > 5 then State.autoFlingCooldown = tick() task.spawn(function() FlingPlayer(target) end) end
    end
end

local function AutoTpStep()
    if not Config.Players.AutoTp then return end
    if not State.selectedPlayerName then return end
    local target = Players:FindFirstChild(State.selectedPlayerName)
    if target and IsAlive(target) then
        UpdateCache()
        if CachedRoot and target.Character then
            local theirRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if theirRoot then
                local offset = theirRoot.CFrame * CFrame.new(-1.5, 0, 4)
                CachedRoot.CFrame = CFrame.lookAt(offset.Position, theirRoot.Position)
            end
        end
    end
end

local function FlyStep()
    if not Config.Movement.Fly then return end
    UpdateCache()
    if not CachedRoot then return end
    local cam = Camera.CFrame; local move = Vector3.new(0, 0, 0)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
    if move.Magnitude > 0 then move = move.Unit * Config.Movement.FlySpeed end
    pcall(function() CachedRoot.AssemblyLinearVelocity = move end)
end

local function NoclipStep()
    if not Config.Movement.Noclip and not State.autoFarmRunning then return end
    UpdateCache()
    if not CachedChar then return end
    for _, part in ipairs(CachedChar:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end
end

local function WalkSpeedStep()
    UpdateCache()
    if not CachedHum then return end
    CachedHum.WalkSpeed = Config.Movement.Speed and Config.Movement.SpeedValue or 16
end

local function JumpHackStep()
    if not Config.Movement.JumpHack then return end
    UpdateCache()
    if not CachedHum then return end
    CachedHum.UseJumpPower = true; CachedHum.JumpPower = Config.Movement.JumpPower
end

local function GravityStep() Workspace.Gravity = Config.Movement.GravityZero and 0 or OriginalGravity end

local function SetSmoothFall(enabled)
    Config.Movement.SmoothFall = enabled
    if enabled then
        if State.smoothFallConn then State.smoothFallConn:Disconnect() end
        State.smoothFallConn = RunService.Heartbeat:Connect(function()
            UpdateCache()
            if CachedRoot and CachedHum and CachedHum.Health > 0 then
                if CachedRoot.AssemblyLinearVelocity.Y < 0 then CachedRoot.AssemblyLinearVelocity = Vector3.new(CachedRoot.AssemblyLinearVelocity.X, CachedRoot.AssemblyLinearVelocity.Y * 0.5, CachedRoot.AssemblyLinearVelocity.Z) end
            end
        end)
    else
        if State.smoothFallConn then State.smoothFallConn:Disconnect() State.smoothFallConn = nil end
    end
end

local function SpinStep()
    if not Config.Movement.Spin then
        if State.lastSpinState then UpdateCache() if CachedHum then CachedHum.AutoRotate = true end end
        State.lastSpinState = false; return
    end
    State.lastSpinState = true
    UpdateCache()
    if not CachedRoot or not CachedHum then return end
    CachedHum.AutoRotate = false
    State.spinAngle = State.spinAngle + Config.Movement.SpinSpeed
    local pos = CachedRoot.Position; local lookDir = Vector3.new(math.cos(math.rad(State.spinAngle)), 0, math.sin(math.rad(State.spinAngle)))
    CachedRoot.CFrame = CFrame.new(pos, pos + lookDir)
end

UserInputService.JumpRequest:Connect(function()
    if Config.Movement.InfiniteJump then UpdateCache() if CachedHum then CachedHum:ChangeState(Enum.HumanoidStateType.Jumping) end end
end)

LocalPlayer.CharacterAdded:Connect(function()
    State.chamsData[LocalPlayer] = nil; State.trails[LocalPlayer] = nil; State.dicks[LocalPlayer] = nil
    if State.chinaHats[LocalPlayer] then pcall(function() State.chinaHats[LocalPlayer]:Destroy() end) State.chinaHats[LocalPlayer] = nil end
    if State.selfAuraEmitter then pcall(function() State.selfAuraEmitter:Destroy() end) State.selfAuraEmitter = nil end
    if State.walkStepsEmitter then pcall(function() State.walkStepsEmitter:Destroy() end) State.walkStepsEmitter = nil end
    if State.footParticleEmitter then pcall(function() State.footParticleEmitter:Destroy() end) State.footParticleEmitter = nil end
end)

local function UpdateInvisHead() if Config.Visuals.InvisHead then UpdateCache() if CachedHead then CachedHead.Transparency = 1 end end end

local function UpdateChams()
    for player, data in pairs(State.chamsData) do
        if (not player or not player.Parent or not IsAlive(player)) or not Config.Visuals.Chams.Enabled then
            for part, orig in pairs(data) do if part and part.Parent then pcall(function() part.Material = orig.Material; part.Color = orig.Color; part.Transparency = orig.Transparency end) end end
            State.chamsData[player] = nil
        end
    end
    if Config.Visuals.Chams.Enabled and IsAlive(LocalPlayer) then
        UpdateCache()
        if not State.chamsData[LocalPlayer] then State.chamsData[LocalPlayer] = {} end
        for _, part in ipairs(CachedChar:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "ChinaHat" and not part:IsA("Tool") then
                if not State.chamsData[LocalPlayer][part] then State.chamsData[LocalPlayer][part] = { Material = part.Material, Color = part.Color, Transparency = part.Transparency } end
                part.Material = Enum.Material.ForceField; part.Color = Config.Visuals.Chams.Color; part.Transparency = 0.3
            elseif part:IsA("Accessory") then
                local handle = part:FindFirstChild("Handle")
                if handle and handle:IsA("BasePart") then
                    if not State.chamsData[LocalPlayer][handle] then State.chamsData[LocalPlayer][handle] = { Material = handle.Material, Color = handle.Color, Transparency = handle.Transparency } end
                    handle.Material = Enum.Material.ForceField; handle.Color = Config.Visuals.Chams.Color; handle.Transparency = 0.3
                end
            end
        end
    end
end

local function UpdateChinaHat()
    for player, hat in pairs(State.chinaHats) do
        if (not player or not player.Parent or not IsAlive(player)) or not Config.Visuals.ChinaHat.Enabled or player ~= LocalPlayer then pcall(function() hat:Destroy() end) State.chinaHats[player] = nil end
    end
    if Config.Visuals.ChinaHat.Enabled and IsAlive(LocalPlayer) then
        UpdateCache()
        if CachedHead then
            local w = Config.Visuals.ChinaHat.Width or 3; local h = Config.Visuals.ChinaHat.Height or 3; local d = Config.Visuals.ChinaHat.Depth or 3
            local ox = Config.Visuals.ChinaHat.OffsetX or 0; local oy = Config.Visuals.ChinaHat.OffsetY or 0; local oz = Config.Visuals.ChinaHat.OffsetZ or 0
            local size = Vector3.new(w, h, d)
            local offset = Vector3.new(ox, (h / 2) + CachedHead.Size.Y/2 + 0.5 + oy, oz)
            local mat = Enum.Material.ForceField
            if not State.chinaHats[LocalPlayer] or not State.chinaHats[LocalPlayer].Parent then
                local hat = Instance.new("Part"); hat.Name = "ChinaHat"; hat.Size = size; hat.CFrame = CFrame.new(CachedHead.Position + offset); hat.Anchored = true; hat.CanCollide = false; hat.CanQuery = false; hat.Material = mat; hat.Transparency = 0.3; hat.Color = Config.Visuals.ChinaHat.Color; hat.Parent = Workspace
                local mesh = Instance.new("SpecialMesh"); mesh.MeshType = Enum.MeshType.FileMesh; mesh.MeshId = "rbxassetid://1033714"; mesh.Scale = size; mesh.Parent = hat
                State.chinaHats[LocalPlayer] = hat
            else
                State.chinaHats[LocalPlayer].Size = size; State.chinaHats[LocalPlayer].CFrame = CFrame.new(CachedHead.Position + offset); State.chinaHats[LocalPlayer].Material = mat; State.chinaHats[LocalPlayer].Color = Config.Visuals.ChinaHat.Color; State.chinaHats[LocalPlayer]:FindFirstChild("SpecialMesh").Scale = size
            end
        end
    end
end

local function UpdateTrail()
    if not Config.Visuals.Trail.Enabled or not IsAlive(LocalPlayer) then
        for _, t in pairs(State.trails) do pcall(function() t.trail:Destroy(); t.att0:Destroy(); t.att1:Destroy() end) end State.trails = {}
    else
        UpdateCache()
        if CachedRoot then
            if State.trails[LocalPlayer] and not State.trails[LocalPlayer].trail.Parent then State.trails[LocalPlayer] = nil end
            if not State.trails[LocalPlayer] then
                local att0 = Instance.new("Attachment", CachedRoot); att0.Name = "TrailAtt0"
                local att1 = Instance.new("Attachment", CachedRoot); att1.Name = "TrailAtt1"
                local trail = Instance.new("Trail", CachedChar); trail.Attachment0 = att0; trail.Attachment1 = att1
                trail.Lifetime = Config.Visuals.Trail.Time; trail.Color = ColorSequence.new(Config.Visuals.Trail.Color)
                trail.Transparency = NumberSequence.new(0, 1); trail.WidthScale = NumberSequence.new(Config.Visuals.Trail.Width, 0)
                State.trails[LocalPlayer] = { trail = trail, att0 = att0, att1 = att1 }
            else
                State.trails[LocalPlayer].trail.Lifetime = Config.Visuals.Trail.Time
                State.trails[LocalPlayer].trail.Color = ColorSequence.new(Config.Visuals.Trail.Color)
                State.trails[LocalPlayer].trail.WidthScale = NumberSequence.new(Config.Visuals.Trail.Width, 0)
            end
            local follow = Config.Visuals.Trail.Follow or "Torso"
            if follow == "Head" then
                State.trails[LocalPlayer].att0.Position = Vector3.new(0, 1.5, 0)
                State.trails[LocalPlayer].att1.Position = Vector3.new(0, 1, 0)
            elseif follow == "Legs" then
                State.trails[LocalPlayer].att0.Position = Vector3.new(0, -1, 0)
                State.trails[LocalPlayer].att1.Position = Vector3.new(0, -1.5, 0)
            else
                State.trails[LocalPlayer].att0.Position = Vector3.new(0, 1, 0)
                State.trails[LocalPlayer].att1.Position = Vector3.new(0, -1, 0)
            end
        end
    end
end

local function UpdateSelfAura()
    UpdateCache()
    if not CachedRoot then return end
    if Config.Visuals.SelfAura then
        local tex = "rbxassetid://243660364"
        if not State.selfAuraEmitter or not State.selfAuraEmitter.Parent or State.selfAuraEmitter.Texture ~= tex then
            if State.selfAuraEmitter then pcall(function() State.selfAuraEmitter:Destroy() end) end
            State.selfAuraEmitter = Instance.new("ParticleEmitter", CachedRoot)
            State.selfAuraEmitter.Texture = tex; State.selfAuraEmitter.Rate = Config.Visuals.AuraCount; State.selfAuraEmitter.Lifetime = NumberRange.new(2); State.selfAuraEmitter.Speed = NumberRange.new(5); State.selfAuraEmitter.VelocitySpread = 360; State.selfAuraEmitter.Size = NumberSequence.new(1); State.selfAuraEmitter.Color = ColorSequence.new(Config.Visuals.AuraColor); State.selfAuraEmitter.LightEmission = Config.Visuals.AuraGlow and 1 or 0
        end
        State.selfAuraEmitter.Rate = Config.Visuals.AuraCount; State.selfAuraEmitter.Color = ColorSequence.new(Config.Visuals.AuraColor); State.selfAuraEmitter.LightEmission = Config.Visuals.AuraGlow and 1 or 0; State.selfAuraEmitter.Enabled = true
    else
        if State.selfAuraEmitter then State.selfAuraEmitter.Enabled = false pcall(function() State.selfAuraEmitter:Destroy() end) State.selfAuraEmitter = nil end
    end
end

local function UpdateDick()
    if not Config.Visuals.Dick.Enabled or not IsAlive(LocalPlayer) then
        for _, parts in pairs(State.dicks) do for _, p in ipairs(parts) do pcall(function() p:Destroy() end) end end State.dicks = {}
    else
        UpdateCache()
        if CachedRoot and not State.dicks[LocalPlayer] then
            local shaft = Instance.new("Part"); shaft.Size = Vector3.new(0.3, 0.3, 1.5); shaft.Transparency = 0.1; shaft.Material = Enum.Material.Neon; shaft.Color = Config.Visuals.Dick.Color; shaft.CanCollide = false; shaft.Anchored = false; shaft.Parent = CachedChar
            local wS = Instance.new("Weld"); wS.Part0 = CachedRoot; wS.Part1 = shaft; wS.C0 = CFrame.new(0, -1.5, -1.5); wS.Parent = shaft
            local tip = Instance.new("Part"); tip.Shape = Enum.PartType.Ball; tip.Size = Vector3.new(0.4, 0.4, 0.4); tip.Transparency = 0.1; tip.Material = Enum.Material.Neon; tip.Color = Config.Visuals.Dick.Color; tip.CanCollide = false; tip.Anchored = false; tip.Parent = CachedChar
            local wT = Instance.new("Weld"); wT.Part0 = shaft; wT.Part1 = tip; wT.C0 = CFrame.new(0, 0, -0.95); wT.Parent = tip
            local lb = Instance.new("Part"); lb.Shape = Enum.PartType.Ball; lb.Size = Vector3.new(0.35, 0.35, 0.35); lb.Transparency = 0.1; lb.Material = Enum.Material.Neon; lb.Color = Config.Visuals.Dick.Color; lb.CanCollide = false; lb.Anchored = false; lb.Parent = CachedChar
            local wLB = Instance.new("Weld"); wLB.Part0 = shaft; wLB.Part1 = lb; wLB.C0 = CFrame.new(-0.22, -0.3, 0.6); wLB.Parent = lb
            local rb = Instance.new("Part"); rb.Shape = Enum.PartType.Ball; rb.Size = Vector3.new(0.35, 0.35, 0.35); rb.Transparency = 0.1; rb.Material = Enum.Material.Neon; rb.Color = Config.Visuals.Dick.Color; rb.CanCollide = false; rb.Anchored = false; rb.Parent = CachedChar
            local wRB = Instance.new("Weld"); wRB.Part0 = shaft; wRB.Part1 = rb; wRB.C0 = CFrame.new(0.22, -0.3, 0.6); wRB.Parent = rb
            State.dicks[LocalPlayer] = { shaft, tip, lb, rb }
        elseif CachedRoot and State.dicks[LocalPlayer] then for _, part in ipairs(State.dicks[LocalPlayer]) do part.Color = Config.Visuals.Dick.Color end end
    end
end

local function UpdateParticleAura()
    UpdateCache()
    if not CachedChar then return end
    if not Config.Visuals.ParticleAura or not IsAlive(LocalPlayer) then
        for _, p in pairs(State.particleAuraParts) do pcall(function() p:Destroy() end) end State.particleAuraParts = {}
        return
    end
    if #State.particleAuraParts == 0 then
        local auras = { ["starlight"] = "rbxassetid://134645216613107", ["heavenly"] = "rbxassetid://139300897520961", ["ribbon"] = "rbxassetid://132069507632161", ["sakura"] = "rbxassetid://81755778619404", ["angel"] = "rbxassetid://97658130917593", ["wind"] = "rbxassetid://80694081850877", ["flow"] = "rbxassetid://119913533725648", ["star"] = "rbxassetid://73754563740680" }
        local id = auras[Config.Visuals.ParticleAuraType]
        if id then pcall(function() local model = game:GetObjects(id)[1] if model then for _, child in ipairs(model:GetChildren()) do local localPart = CachedChar:FindFirstChild(child.Name) if localPart then for _, c in ipairs(child:GetChildren()) do c.Name = "\0\0"; c.Parent = localPart; table.insert(State.particleAuraParts, c) end end end model:Destroy() end end) end
    end
    local color = Config.Visuals.ParticleAuraColor
    local colorSeq = ColorSequence.new(color)
    for _, p in pairs(State.particleAuraParts) do
        pcall(function()
            if p:IsA("ParticleEmitter") or p:IsA("Beam") or p:IsA("Trail") then p.Color = colorSeq
            elseif p:IsA("PointLight") then p.Color = color
            elseif p:IsA("MeshPart") or p:IsA("Part") then p.Color = color end
            for _, d in ipairs(p:GetDescendants()) do
                if d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then d.Color = colorSeq
                elseif d:IsA("PointLight") then d.Color = color
                elseif d:IsA("MeshPart") or d:IsA("Part") then d.Color = color end
            end
        end)
    end
end

local function UpdateWhitelistVisuals()
    for player, wl in pairs(State.whitelist) do
        if not State.wlVisuals[player] then State.wlVisuals[player] = {} end
        local vis = State.wlVisuals[player]
        
        if not player or not player.Parent or not IsAlive(player) then
            if vis.ChinaHat then vis.ChinaHat:Destroy() vis.ChinaHat = nil end
            if vis.Trail then pcall(function() vis.Trail.trail:Destroy() vis.Trail.att0:Destroy() vis.Trail.att1:Destroy() end) vis.Trail = nil end
            if vis.Aura then vis.Aura:Destroy() vis.Aura = nil end
            if vis.Dick then for _, p in ipairs(vis.Dick) do p:Destroy() end vis.Dick = nil end
            if vis.WalkSteps then vis.WalkSteps:Destroy() vis.WalkSteps = nil end
            if vis.FootParticles then vis.FootParticles:Destroy() vis.FootParticles = nil end
            if vis.ParticleAura then for _, p in ipairs(vis.ParticleAura) do p:Destroy() end vis.ParticleAura = nil end
            if vis.OrigMats then vis.OrigMats = nil end
        else
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")
                if root and head then
                    if vis.Char ~= char then
                        vis.Char = char
                        vis.OrigMats = nil
                    end
                    
                    head.Transparency = wl.InvisHead and 1 or 0
                    
                    if wl.ChinaHat then
                        if not vis.ChinaHat or not vis.ChinaHat.Parent then
                            vis.ChinaHat = Instance.new("Part"); vis.ChinaHat.Name = "ChinaHat"; vis.ChinaHat.Size = Vector3.new(3,3,3); vis.ChinaHat.Anchored = true; vis.ChinaHat.CanCollide = false; vis.ChinaHat.Material = Enum.Material.ForceField; vis.ChinaHat.Transparency = 0.3; vis.ChinaHat.Color = wl.ESPColor; vis.ChinaHat.Parent = Workspace
                            local mesh = Instance.new("SpecialMesh"); mesh.MeshType = Enum.MeshType.FileMesh; mesh.MeshId = "rbxassetid://1033714"; mesh.Scale = Vector3.new(3,3,3); mesh.Parent = vis.ChinaHat
                        end
                        vis.ChinaHat.CFrame = CFrame.new(head.Position + Vector3.new(0, head.Size.Y/2 + 2, 0))
                        vis.ChinaHat.Color = wl.ESPColor
                    else
                        if vis.ChinaHat then vis.ChinaHat:Destroy(); vis.ChinaHat = nil end
                    end
                    
                    if wl.Trail then
                        if not vis.Trail or not vis.Trail.trail or not vis.Trail.trail.Parent then
                            local att0 = Instance.new("Attachment", root); att0.Position = Vector3.new(0, 1, 0)
                            local att1 = Instance.new("Attachment", root); att1.Position = Vector3.new(0, -1, 0)
                            local trail = Instance.new("Trail", char); trail.Attachment0 = att0; trail.Attachment1 = att1; trail.Lifetime = 1; trail.Transparency = NumberSequence.new(0, 1); trail.WidthScale = NumberSequence.new(1, 0)
                            vis.Trail = { trail = trail, att0 = att0, att1 = att1 }
                        end
                        vis.Trail.trail.Color = ColorSequence.new(wl.ESPColor)
                    else
                        if vis.Trail then pcall(function() vis.Trail.trail:Destroy(); vis.Trail.att0:Destroy(); vis.Trail.att1:Destroy() end); vis.Trail = nil end
                    end
                    
                    if wl.SelfAura then
                        if not vis.Aura or not vis.Aura.Parent then
                            vis.Aura = Instance.new("ParticleEmitter", root); vis.Aura.Texture = "rbxassetid://243660364"; vis.Aura.Rate = 50; vis.Aura.Lifetime = NumberRange.new(2); vis.Aura.Speed = NumberRange.new(5); vis.Aura.VelocitySpread = 360; vis.Aura.Size = NumberSequence.new(1); vis.Aura.LightEmission = 1
                        end
                        vis.Aura.Color = ColorSequence.new(wl.ESPColor)
                        vis.Aura.Enabled = true
                    else
                        if vis.Aura then vis.Aura:Destroy(); vis.Aura = nil end
                    end
                    
                    if wl.Dick then
                        if not vis.Dick then
                            local shaft = Instance.new("Part"); shaft.Size = Vector3.new(0.3, 0.3, 1.5); shaft.Transparency = 0.1; shaft.Material = Enum.Material.Neon; shaft.Color = wl.ESPColor; shaft.CanCollide = false; shaft.Anchored = false; shaft.Parent = char
                            local wS = Instance.new("Weld"); wS.Part0 = root; wS.Part1 = shaft; wS.C0 = CFrame.new(0, -1.5, -1.5); wS.Parent = shaft
                            local tip = Instance.new("Part"); tip.Shape = Enum.PartType.Ball; tip.Size = Vector3.new(0.4, 0.4, 0.4); tip.Transparency = 0.1; tip.Material = Enum.Material.Neon; tip.Color = wl.ESPColor; tip.CanCollide = false; tip.Anchored = false; tip.Parent = char
                            local wT = Instance.new("Weld"); wT.Part0 = shaft; wT.Part1 = tip; wT.C0 = CFrame.new(0, 0, -0.95); wT.Parent = tip
                            vis.Dick = { shaft, tip }
                        end
                        for _, p in ipairs(vis.Dick) do p.Color = wl.ESPColor end
                    else
                        if vis.Dick then for _, p in ipairs(vis.Dick) do p:Destroy() end vis.Dick = nil end
                    end
                    
                    if wl.WalkSteps then
                        if not vis.WalkSteps or not vis.WalkSteps.Parent then
                            vis.WalkSteps = Instance.new("ParticleEmitter", root); vis.WalkSteps.Texture = "rbxassetid://243660364"; vis.WalkSteps.Rate = 20; vis.WalkSteps.Lifetime = NumberRange.new(1); vis.WalkSteps.Speed = NumberRange.new(0); vis.WalkSteps.Size = NumberSequence.new(1); vis.WalkSteps.Color = ColorSequence.new(wl.ESPColor); vis.WalkSteps.LockedToPart = true
                        end
                        vis.WalkSteps.Enabled = (root.AssemblyLinearVelocity.Magnitude > 1)
                    else
                        if vis.WalkSteps then vis.WalkSteps:Destroy(); vis.WalkSteps = nil end
                    end
                    
                    if wl.FootParticles then
                        if not vis.FootParticles or not vis.FootParticles.Parent then
                            vis.FootParticles = Instance.new("ParticleEmitter", root); vis.FootParticles.Texture = "rbxassetid://243660364"; vis.FootParticles.Speed = NumberRange.new(2, 5); vis.FootParticles.VelocitySpread = 45; vis.FootParticles.Size = NumberSequence.new(1.5); vis.FootParticles.Lifetime = NumberRange.new(1, 2); vis.FootParticles.Rate = 50; vis.FootParticles.Color = ColorSequence.new(wl.ESPColor)
                        end
                        vis.FootParticles.Enabled = (root.AssemblyLinearVelocity.Magnitude > 1)
                    else
                        if vis.FootParticles then vis.FootParticles:Destroy(); vis.FootParticles = nil end
                    end

                    if wl.CharMat then
                        if not vis.OrigMats then
                            vis.OrigMats = {}
                            for _, part in ipairs(char:GetChildren()) do
                                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                    vis.OrigMats[part] = { Material = part.Material, Color = part.Color }
                                end
                            end
                        end
                        for _, part in ipairs(char:GetChildren()) do
                            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                part.Material = Enum.Material.ForceField
                                part.Color = wl.ESPColor
                            end
                        end
                    else
                        if vis.OrigMats then
                            for part, orig in pairs(vis.OrigMats) do
                                if part and part.Parent then
                                    part.Material = orig.Material
                                    part.Color = orig.Color
                                end
                            end
                            vis.OrigMats = nil
                        end
                    end

                    if wl.ToolMat then
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then
                            for _, part in ipairs(tool:GetChildren()) do
                                if part:IsA("BasePart") then
                                    part.Material = Enum.Material.ForceField
                                    part.Color = wl.ESPColor
                                end
                            end
                        end
                    end

                    if wl.GunSound then
                        local gun = char:FindFirstChild("Gun") or char:FindFirstChildOfClass("Tool")
                        if gun and gun.Name:lower():match("gun") then
                            local handle = gun:FindFirstChild("Handle")
                            if handle then
                                local shot = handle:FindFirstChild("Gunshot")
                                if shot and shot:IsA("Sound") then
                                    shot.SoundId = Config.Misc.GunSoundID
                                    shot.Volume = Config.Misc.GunSoundVolume
                                end
                            end
                        end
                    end

                    if wl.ParticleAura then
                        if not vis.ParticleAura or #vis.ParticleAura == 0 then
                            local auras = { ["angel"] = "rbxassetid://97658130917593" }
                            local id = auras["angel"]
                            if id then
                                pcall(function()
                                    local model = game:GetObjects(id)[1]
                                    if model then
                                        vis.ParticleAura = {}
                                        for _, child in ipairs(model:GetChildren()) do
                                            local localPart = char:FindFirstChild(child.Name)
                                            if localPart then
                                                for _, c in ipairs(child:GetChildren()) do
                                                    c.Name = "\0\0"
                                                    c.Parent = localPart
                                                    table.insert(vis.ParticleAura, c)
                                                end
                                            end
                                        end
                                        model:Destroy()
                                    end
                                end)
                            end
                        end
                        if vis.ParticleAura then
                            local colorSeq = ColorSequence.new(wl.ESPColor)
                            for _, p in ipairs(vis.ParticleAura) do
                                pcall(function()
                                    if p:IsA("ParticleEmitter") or p:IsA("Beam") or p:IsA("Trail") then p.Color = colorSeq
                                    elseif p:IsA("PointLight") then p.Color = wl.ESPColor
                                    elseif p:IsA("MeshPart") or p:IsA("Part") then p.Color = wl.ESPColor end
                                end)
                            end
                        end
                    else
                        if vis.ParticleAura then
                            for _, p in ipairs(vis.ParticleAura) do p:Destroy() end
                            vis.ParticleAura = nil
                        end
                    end
                end
            end
        end
    end
end

local function UpdateMotionBlur()
    if Config.Visuals.MotionBlur then
        if not State.motionBlurEffect then State.motionBlurEffect = Instance.new("BlurEffect") State.motionBlurEffect.Parent = Lighting end
        local look = Camera.CFrame.LookVector
        if State.lastLookVector then local delta = (look - State.lastLookVector).Magnitude State.motionBlurEffect.Size = math.clamp(delta * 1000, 0, 24) end
        State.lastLookVector = look
    else
        if State.motionBlurEffect then pcall(function() State.motionBlurEffect:Destroy() end) State.motionBlurEffect = nil end
    end
end

local function UpdateAspectRatio()
    if Config.Visuals.AspectRatio then local cf = Camera.CFrame local rot = CFrame.new(0, 0, 0, 1, 0, 0, 0, Config.Visuals.AspectRatioValue, 0, 0, 0, 1) Camera.CFrame = CFrame.new(cf.Position) * (cf - cf.Position) * rot end
end

local function UpdateLighting()
    if Config.Visuals.CustomFog then Lighting.FogColor = Config.Visuals.FogColor; Lighting.FogStart = Config.Visuals.FogStart; Lighting.FogEnd = Config.Visuals.FogEnd else Lighting.FogColor = OriginalLighting.FogColor; Lighting.FogStart = OriginalLighting.FogStart; Lighting.FogEnd = OriginalLighting.FogEnd end
    if Config.Visuals.Fullbright then Lighting.Brightness = 2; Lighting.ClockTime = 12; Lighting.Ambient = rgb(255, 255, 255); Lighting.OutdoorAmbient = rgb(255, 255, 255)
    else
        if not Config.Visuals.NightMode then Lighting.Brightness = OriginalLighting.Brightness; Lighting.ClockTime = OriginalLighting.ClockTime else Lighting.Brightness = Config.Visuals.NightModeIntensity; Lighting.ClockTime = 0 end
        if not Config.Visuals.CustomAmbient and not Config.Visuals.RainbowAmbient then Lighting.Ambient = OriginalLighting.Ambient; Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient end
    end
    if Config.Visuals.CustomAmbient and not Config.Visuals.RainbowAmbient then Lighting.Ambient = Config.Visuals.AmbientColor; Lighting.OutdoorAmbient = Config.Visuals.AmbientColor end
    if Config.Visuals.RainbowAmbient then local hue = tick() % (Config.Visuals.RainbowSpeed > 0 and Config.Visuals.RainbowSpeed or 1); hue = hue / (Config.Visuals.RainbowSpeed > 0 and Config.Visuals.RainbowSpeed or 1); Lighting.Ambient = Color3.fromHSV(hue, 1, 1); Lighting.OutdoorAmbient = Color3.fromHSV(hue, 1, 1) end
    if Config.Visuals.WorldMods then Lighting.Brightness = Config.Visuals.Brightness; Lighting.ClockTime = Config.Visuals.ClockTime; Lighting.ExposureCompensation = Config.Visuals.Exposure
    else
        if not Config.Visuals.Fullbright and not Config.Visuals.NightMode then Lighting.Brightness = OriginalLighting.Brightness; Lighting.ClockTime = OriginalLighting.ClockTime end
        Lighting.ExposureCompensation = OriginalLighting.ExposureCompensation
    end
end

local SkyboxAssets = {} SkyboxAssets["Black Storm"] = { Bk = "rbxassetid://15502511288", Dn = "rbxassetid://15502508460", Ft = "rbxassetid://15502510289", Lf = "rbxassetid://15502507918", Rt = "rbxassetid://15502509398", Up = "rbxassetid://15502511911" } SkyboxAssets["Blue Space"] = { Bk = "rbxassetid://15536110634", Dn = "rbxassetid://15536112543", Ft = "rbxassetid://15536116141", Lf = "rbxassetid://15536114370", Rt = "rbxassetid://15536118762", Up = "rbxassetid://15536117282" } SkyboxAssets["Realistic"] = { Bk = "rbxassetid://653719502", Dn = "rbxassetid://653718790", Ft = "rbxassetid://653719067", Lf = "rbxassetid://653719190", Rt = "rbxassetid://653718931", Up = "rbxassetid://653719321" } SkyboxAssets["Pink"] = { Bk = "rbxassetid://12216109205", Dn = "rbxassetid://12216109875", Ft = "rbxassetid://12216109489", Lf = "rbxassetid://12216110170", Rt = "rbxassetid://12216110471", Up = "rbxassetid://12216108877" } SkyboxAssets["Stormy"] = { Bk = "http://www.roblox.com/asset/?id=18703245834", Dn = "http://www.roblox.com/asset/?id=18703243349", Ft = "http://www.roblox.com/asset/?id=18703240532", Lf = "http://www.roblox.com/asset/?id=18703237556", Rt = "http://www.roblox.com/asset/?id=18703235430", Up = "http://www.roblox.com/asset/?id=18703232671" }
local customSky = nil
local function UpdateSkybox()
    if Config.Visuals.CustomSkybox then
        local assets = SkyboxAssets[Config.Visuals.SkyboxName]
        if assets then if customSky then customSky:Destroy() end for _, s in ipairs(Lighting:GetChildren()) do if s:IsA("Sky") then s:Destroy() end end customSky = Instance.new("Sky") customSky.SkyboxBk = assets.Bk customSky.SkyboxDn = assets.Dn customSky.SkyboxFt = assets.Ft customSky.SkyboxLf = assets.Lf customSky.SkyboxRt = assets.Rt customSky.SkyboxUp = assets.Up customSky.Parent = Lighting end
    else
        if customSky then customSky:Destroy() customSky = nil end
    end
end

local function UpdateCharacterMaterial()
    UpdateCache()
    if not CachedChar then return end
    if Config.Visuals.CharacterMaterial then for _, part in ipairs(CachedChar:GetChildren()) do if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Material = Enum.Material.ForceField part.Color = Config.Visuals.CharColor end end end
    if Config.Visuals.ToolMaterial then local tool = CachedChar:FindFirstChildOfClass("Tool") if tool then for _, part in ipairs(tool:GetChildren()) do if part:IsA("BasePart") then part.Material = Enum.Material.ForceField part.Color = Config.Visuals.ToolColor end end end end
    if CachedRoot then
        if Config.Visuals.WalkSteps then
            local tex = "rbxassetid://243660364"
            if not State.walkStepsEmitter or not State.walkStepsEmitter.Parent or State.walkStepsEmitter.Texture ~= tex then
                if State.walkStepsEmitter then pcall(function() State.walkStepsEmitter:Destroy() end) end
                State.walkStepsEmitter = Instance.new("ParticleEmitter", CachedRoot) State.walkStepsEmitter.Texture = tex State.walkStepsEmitter.Rate = 20 State.walkStepsEmitter.Lifetime = NumberRange.new(1) State.walkStepsEmitter.Speed = NumberRange.new(0) State.walkStepsEmitter.VelocitySpread = 0 State.walkStepsEmitter.Size = NumberSequence.new(1) State.walkStepsEmitter.Color = ColorSequence.new(Config.Visuals.CharColor) State.walkStepsEmitter.LockedToPart = true
            end
            State.walkStepsEmitter.Enabled = (CachedRoot.AssemblyLinearVelocity.Magnitude > 1)
        else
            if State.walkStepsEmitter then State.walkStepsEmitter:Destroy() State.walkStepsEmitter = nil end
        end
    end
end

local function UpdateFootParticles()
    UpdateCache()
    if not CachedRoot then return end
    if Config.Visuals.FootParticles then
        local tex = "rbxassetid://243660364"
        if not State.footParticleEmitter or not State.footParticleEmitter.Parent or State.footParticleEmitter.Texture ~= tex then
            if State.footParticleEmitter then pcall(function() State.footParticleEmitter:Destroy() end) end
            State.footParticleEmitter = Instance.new("ParticleEmitter", CachedRoot) State.footParticleEmitter.Texture = tex State.footParticleEmitter.Speed = NumberRange.new(2, 5) State.footParticleEmitter.VelocitySpread = 45 State.footParticleEmitter.Size = NumberSequence.new(1.5) State.footParticleEmitter.Lifetime = NumberRange.new(1, 2) State.footParticleEmitter.Rate = Config.Visuals.FootParticleCount State.footParticleEmitter.Color = ColorSequence.new(Config.Visuals.FootParticleColor) State.footParticleEmitter.LightEmission = Config.Visuals.FootParticleGlow and 1 or 0
        end
        State.footParticleEmitter.Texture = tex State.footParticleEmitter.Rate = Config.Visuals.FootParticleCount State.footParticleEmitter.LightEmission = Config.Visuals.FootParticleGlow and 1 or 0 State.footParticleEmitter.Color = ColorSequence.new(Config.Visuals.FootParticleColor) State.footParticleEmitter.Enabled = (CachedRoot.AssemblyLinearVelocity.Magnitude > 1)
    else
        if State.footParticleEmitter then State.footParticleEmitter:Destroy() State.footParticleEmitter = nil end
    end
end

local function UpdateGunSound()
    if not Config.Misc.GunSoundChanger then return end
    UpdateCache()
    if not CachedChar then return end
    local gun = CachedChar:FindFirstChild("Gun") or CachedChar:FindFirstChildOfClass("Tool")
    if gun and gun.Name:lower():match("gun") then
        local handle = gun:FindFirstChild("Handle")
        if handle then
            local shot = handle:FindFirstChild("Gunshot")
            if shot and shot:IsA("Sound") then
                if shot.SoundId ~= Config.Misc.GunSoundID then shot.SoundId = Config.Misc.GunSoundID end
                if shot.Volume ~= Config.Misc.GunSoundVolume then shot.Volume = Config.Misc.GunSoundVolume end
            end
        end
    end
end

local function UpdateVisuals()
    pcall(UpdateInvisHead) pcall(UpdateChams) pcall(UpdateChinaHat) pcall(UpdateTrail) pcall(UpdateSelfAura) pcall(UpdateDick) pcall(UpdateLighting) pcall(UpdateSkybox) pcall(UpdateCharacterMaterial) pcall(UpdateFootParticles) pcall(UpdateParticleAura) pcall(UpdateMotionBlur) pcall(UpdateAspectRatio) pcall(UpdateGunSound) pcall(UpdateWhitelistVisuals)
    Camera.FieldOfView = Config.Visuals.FOV
end

local function LoadAnimTrack(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid
    if State.animTrack then pcall(function() State.animTrack:Stop() end) State.animTrack = nil end
    pcall(function()
        State.animTrack = animator:LoadAnimation(State.animInstance)
        State.animTrack.Looped = true
        State.animTrack.Priority = Enum.AnimationPriority.Action
        if Config.Animation.Enabled then
            task.wait(0.3)
            State.animTrack:Play()
            State.animTrack:AdjustSpeed(Config.Animation.Speed)
            State.animPlaying = true
        end
    end)
end
local function SetAnimationID(id) Config.Animation.ID = id State.animInstance.AnimationId = id if LocalPlayer.Character then LoadAnimTrack(LocalPlayer.Character) end end
local function ToggleAnimation(enabled)
    Config.Animation.Enabled = enabled
    if enabled then
        if State.animTrack and not State.animPlaying then State.animTrack:Play() State.animTrack:AdjustSpeed(Config.Animation.Speed) State.animPlaying = true
        elseif not State.animTrack and LocalPlayer.Character then LoadAnimTrack(LocalPlayer.Character) end
    else
        if State.animTrack and State.animPlaying then State.animTrack:Stop() State.animPlaying = false end
    end
end
LocalPlayer.CharacterAdded:Connect(function(char) task.wait(0.5) LoadAnimTrack(char) end) if LocalPlayer.Character then task.spawn(function() LoadAnimTrack(LocalPlayer.Character) end) end

local allAnimPacks = {}
allAnimPacks["Default"] = { idle = "rbxassetid://507766666", walk = "rbxassetid://507777826", run = "rbxassetid://913376220", jump = "rbxassetid://507765000", climb = "rbxassetid://507726368", fall = "rbxassetid://507767968" }
allAnimPacks["Rthro"] = { idle = "rbxassetid://2510196951", walk = "rbxassetid://2510202577", run = "rbxassetid://2510198475", jump = "rbxassetid://2510197830", climb = "rbxassetid://2510192778", fall = "rbxassetid://2510195892" }
allAnimPacks["DaHoodian"] = { idle = "rbxassetid://782841498", walk = "rbxassetid://616168032", run = "rbxassetid://616163682", jump = "rbxassetid://1083218792", climb = "rbxassetid://1083439238", fall = "rbxassetid://707829716" }
allAnimPacks["Ninja"] = { idle = "rbxassetid://656117400", walk = "rbxassetid://656121766", run = "rbxassetid://656118852", jump = "rbxassetid://656117878", climb = "rbxassetid://656114359", fall = "rbxassetid://656115606" }
allAnimPacks["Zombie"] = { idle = "rbxassetid://616158929", walk = "rbxassetid://616168032", run = "rbxassetid://616163682", jump = "rbxassetid://616161997", climb = "rbxassetid://616156119", fall = "rbxassetid://616157476" }
allAnimPacks["Stylish"] = { idle = "rbxassetid://616136790", walk = "rbxassetid://616146177", run = "rbxassetid://616140816", jump = "rbxassetid://616139451", climb = "rbxassetid://616133594", fall = "rbxassetid://616134815" }
allAnimPacks["Pirate"] = { idle = "rbxassetid://750781874", walk = "rbxassetid://750785693", run = "rbxassetid://750783738", jump = "rbxassetid://750782230", climb = "rbxassetid://750779899", fall = "rbxassetid://750780242" }
allAnimPacks["Toy"] = { idle = "rbxassetid://782841498", walk = "rbxassetid://782843345", run = "rbxassetid://782842708", jump = "rbxassetid://782847020", climb = "rbxassetid://782843869", fall = "rbxassetid://782846423" }
allAnimPacks["Vampire"] = { idle = "rbxassetid://1083445855", walk = "rbxassetid://1083473930", run = "rbxassetid://1083462077", jump = "rbxassetid://1083455352", climb = "rbxassetid://1083439238", fall = "rbxassetid://1083443587" }
allAnimPacks["Werewolf"] = { idle = "rbxassetid://1083195517", walk = "rbxassetid://1083178339", run = "rbxassetid://1083216690", jump = "rbxassetid://1083218792", climb = "rbxassetid://1083182000", fall = "rbxassetid://1083189019" }
allAnimPacks["Superhero"] = { idle = "rbxassetid://616111295", walk = "rbxassetid://616122287", run = "rbxassetid://616117076", jump = "rbxassetid://616115533", climb = "rbxassetid://616104706", fall = "rbxassetid://616108001" }

local function ApplyAnimPackToChar(character)
    if not character then return end
    local animate = character:FindFirstChild("Animate")
    if not animate or not Config.AnimPack.Enabled then return end
    local function apply(animType, packName, childName, animChildName)
        local pack = allAnimPacks[packName] if not pack then return end
        local container = animate:FindFirstChild(childName) if container then local animObj = container:FindFirstChild(animChildName) if animObj then animObj.AnimationId = pack[animType] end end
    end
    apply("idle", Config.AnimPack.idle, "idle", "Animation1") apply("walk", Config.AnimPack.walk, "walk", "WalkAnim") apply("run", Config.AnimPack.run, "run", "RunAnim")
    apply("jump", Config.AnimPack.jump, "jump", "JumpAnim") apply("climb", Config.AnimPack.climb, "climb", "ClimbAnim") apply("fall", Config.AnimPack.fall, "fall", "FallAnim")
end
LocalPlayer.CharacterAdded:Connect(function(char) task.wait(0.5) ApplyAnimPackToChar(char) end) if LocalPlayer.Character then ApplyAnimPackToChar(LocalPlayer.Character) end

local function GrabGun()
    local gun = Workspace:FindFirstChild("GunDrop", true)
    if gun then UpdateCache() if CachedRoot then local savepos = CachedRoot.CFrame CachedRoot.CFrame = gun.CFrame * CFrame.new(0, 2, 0) task.wait(0.3) CachedRoot.CFrame = savepos end end
end
local mapsList = {"Factory", "Bank 2", "Bio Lab", "Hospital3", "Hotel2", "House2", "Mansion2", "MilBase", "Office3", "PoliceStation", "ResearchFacility", "Workplace"}
local function TPToMap()
    UpdateCache()
    if not CachedRoot then return end
    for _, mapName in ipairs(mapsList) do
        local map = Workspace:FindFirstChild(mapName) if map then local part = map:FindFirstChildWhichIsA("BasePart", true) if part then CachedRoot.CFrame = part.CFrame * CFrame.new(0, 5, 0) return end end end
    end
end
local function TPToSpawn() UpdateCache() if CachedRoot then CachedRoot.CFrame = CFrame.new(14, 516, -25) end end

local function StartAutoFarm()
    if State.autoFarmRunning then return end
    State.autoFarmRunning = true
    task.spawn(function()
        UpdateCache() if CachedRoot then State.autoFarmStartPos = CachedRoot.CFrame end
        TPToMap()
        task.wait(1)
        while State.autoFarmRunning and Config.Farm.AutoCoins do
            local mapExists = false
            for _, mapName in ipairs(mapsList) do if Workspace:FindFirstChild(mapName) then mapExists = true break end end
            if mapExists then
                local coinContainer = Workspace:FindFirstChild("CoinContainer", true)
                if coinContainer then
                    local closestCoin = nil
                    local minDist = math.huge
                    UpdateCache()
                    if CachedRoot then
                        for _, coin in ipairs(coinContainer:GetChildren()) do
                            if coin:IsA("BasePart") and coin.Parent then
                                local dist = (coin.Position - CachedRoot.Position).Magnitude
                                if dist < minDist then minDist = dist closestCoin = coin end
                            end
                        end
                        if closestCoin and closestCoin.Parent then
                            CachedRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            if firetouchinterest then
                                firetouchinterest(CachedRoot, closestCoin, 0)
                                firetouchinterest(CachedRoot, closestCoin, 1)
                                task.wait(0.1)
                            else
                                CachedRoot.CFrame = CFrame.new(closestCoin.Position + Vector3.new(0, 2, 0))
                                task.wait(0.1)
                                CachedRoot.CFrame = CFrame.new(closestCoin.Position)
                                task.wait(0.15)
                            end
                        else
                            task.wait(0.1)
                        end
                    end
                end
            end
            RunService.RenderStepped:Wait()
        end
        UpdateCache() if CachedRoot and State.autoFarmStartPos then CachedRoot.CFrame = State.autoFarmStartPos end
        State.autoFarmRunning = false
    end)
end

local function AutoFarmXPStep()
    if not Config.Farm.AutoXP then return end
    UpdateCache()
    if not CachedRoot then return end
    local myRole = GetMM2Role(LocalPlayer)
    if myRole == "Murderer" then
        local tool = CachedChar:FindFirstChildOfClass("Tool")
        if not tool or not tool.Name:lower():match("knife") then local knife = LocalPlayer.Backpack:FindFirstChild("Knife") if knife then CachedHum:EquipTool(knife) end end
        tool = CachedChar:FindFirstChildOfClass("Tool")
        if tool then for _, player in ipairs(Players:GetPlayers()) do if player ~= LocalPlayer and IsAlive(player) and GetMM2Role(player) ~= "Murderer" and not (State.whitelist[player] and State.whitelist[player].IgnoreKill) then local theirRoot = player.Character:FindFirstChild("HumanoidRootPart") if theirRoot then theirRoot.CFrame = CachedRoot.CFrame * CFrame.new(0, 0, -3) tool:Activate() task.wait(0.1) end end end end
    else CachedRoot.CFrame = CFrame.new(14, 516, -25) end
end

local function TeleportToPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character then UpdateCache() if CachedRoot then local theirRoot = target.Character:FindFirstChild("HumanoidRootPart") if theirRoot then CachedRoot.CFrame = theirRoot.CFrame + Vector3.new(0, 0, 3) end end end end
end
local function SpectatePlayer(playerName) local target = Players:FindFirstChild(playerName) if target and target.Character then local hum = target.Character:FindFirstChildOfClass("Humanoid") if hum then Camera.CameraSubject = hum end end end
local function Unspectate() UpdateCache() if CachedHum then Camera.CameraSubject = CachedHum end end

local function SpecByRole(role)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) and GetMM2Role(player) == role then SpectatePlayer(player.Name) break end
    end
end

local function ServerHop()
    pcall(function()
        local placeId = game.PlaceId
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        local response = game:HttpGet(url)
        local data = HttpService:JSONDecode(response)
        local servers = {}
        if data and data.data then
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers then
                    table.insert(servers, server.id)
                end
            end
        end
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(placeId, randomServer, LocalPlayer)
        end
    end)
end

local PlayerDropdown
local function RefreshPlayerNames() State.playerNames = {} for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(State.playerNames, p.Name) end end if PlayerDropdown then PlayerDropdown.RefreshOptions(State.playerNames) end end
RefreshPlayerNames()
Players.PlayerAdded:Connect(function() task.wait(1) RefreshPlayerNames() end)
Players.PlayerRemoving:Connect(function() task.wait(1) RefreshPlayerNames() end)

Players.PlayerRemoving:Connect(function(p)
    if State.whitelist[p] then
        State.whitelist[p] = nil
        if State.wlVisuals[p] then
            local vis = State.wlVisuals[p]
            if vis.ChinaHat then vis.ChinaHat:Destroy() end
            if vis.Trail then pcall(function() vis.Trail.trail:Destroy() vis.Trail.att0:Destroy() vis.Trail.att1:Destroy() end) end
            if vis.Aura then vis.Aura:Destroy() end
            if vis.Dick then for _, part in ipairs(vis.Dick) do part:Destroy() end end
            if vis.WalkSteps then vis.WalkSteps:Destroy() end
            if vis.FootParticles then vis.FootParticles:Destroy() end
            if vis.ParticleAura then for _, part in ipairs(vis.ParticleAura) do part:Destroy() end end
            State.wlVisuals[p] = nil
        end
        if State.wlSections[p] then pcall(function() State.wlSections[p].Items.Section:Destroy() end) State.wlSections[p] = nil end
        if State.playerChamsHighlights[p] then pcall(function() State.playerChamsHighlights[p]:Destroy() end); State.playerChamsHighlights[p] = nil end
    end
end)

RunService.RenderStepped:Connect(function()
    pcall(UpdateWarningAndTimer) 
    pcall(UpdateESP) 
    pcall(UpdatePlayerChams) pcall(UpdateWeaponESP) pcall(UpdateCoinESP) pcall(UpdateAimStep) pcall(UpdateHitbox) pcall(KillAuraStep) pcall(KillAllStep) pcall(KillSheriffStep) pcall(TriggerbotStep) pcall(UpdateHitEffects) pcall(WalkFlingStep) pcall(AutoFlingStep) pcall(AutoTpStep) pcall(FlyStep) pcall(NoclipStep) pcall(WalkSpeedStep) pcall(JumpHackStep) pcall(GravityStep) pcall(SpinStep) pcall(UpdateVisuals) pcall(AutoFarmXPStep)
end)

local function InitUI()
    local Window = Library:Window({Prefix = "luausense", Suffix = "PRIME"}) Library:RefreshTheme("accent", DefaultAccent)
    local Tabs = {} Tabs.Combat = Window:Tab({Name = "Combat"}) Tabs.Visuals = Window:Tab({Name = "Visuals"}) Tabs.Movement = Window:Tab({Name = "Movement"}) Tabs.Farm = Window:Tab({Name = "Farm"}) Tabs.Misc = Window:Tab({Name = "Misc"}) Tabs.Players = Window:Tab({Name = "Players"})

    local shootS = Tabs.Combat:Section({Name = "Shoot Murderer", Side = "Left"}) local shootT = shootS:Toggle({Name = "Enabled", callback = function(v) Config.Combat.ShootMurderer = v end}) shootT:Keybind({Name = "Shoot Bind", Mode = "Hold", Callback = function(bool) if bool then ShootMurderer() end end}) shootS:Slider({Name = "FOV", Min = 10, Max = 360, Default = 360, Decimal = 0.1, Callback = function(int) Config.Combat.ShootMurdererFOV = int end}) shootS:Dropdown({Name = "Target Bone", Options = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"}, Default = "Head", Callback = function(v) Config.Combat.ShootMurdererBone = v end})
    local killShS = Tabs.Combat:Section({Name = "Kill Sheriff (Murd Only)", Side = "Left"}) local killShT = killShS:Toggle({Name = "Enabled", callback = function(v) Config.Combat.KillSheriff = v end})
    
    local btpS = Tabs.Combat:Section({Name = "Bullet TP (Press T)", Side = "Left"})
    btpS:Toggle({Name = "Enabled", callback = function(v) Config.Combat.BulletTP = v end})

    local saS = Tabs.Combat:Section({Name = "Silent Aim", Side = "Left"})
    local saT = saS:Toggle({Name = "Enabled", callback = function(v) Config.Combat.SilentAim = v end})
    saS:Toggle({Name = "360 FOV", callback = function(v) Config.Combat.SilentAim360 = v end})
    saS:Slider({Name = "FOV", Min = 10, Max = 500, Default = 150, Decimal = 0.1, Callback = function(int) Config.Combat.SilentAimFOV = int end})
    saS:Dropdown({Name = "Target Bone", Options = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"}, Default = "Head", Callback = function(v) Config.Combat.SilentAimBone = v end})

    local aimS = Tabs.Combat:Section({Name = "Aimbot", Side = "Left"}) local aimT = aimS:Toggle({Name = "Enabled (Hold Bind)", callback = function(v) Config.Combat.Aimbot = v end}) aimT:Keybind({Name = "Aimbot Bind", Key = Config.Combat.AimbotBind, Mode = "Hold", Callback = function(bool) State.aimbotKeyHeld = bool if not bool then State.stickyTarget = nil end end}) aimS:Toggle({Name = "Sticky Aim", callback = function(v) Config.Combat.StickyAim = v end}) aimS:Toggle({Name = "Wall Check", callback = function(v) Config.Combat.WallCheck = v end}) aimS:Slider({Name = "FOV", Min = 10, Max = 500, Default = 150, Decimal = 0.1, Callback = function(int) Config.Combat.AimbotFOV = int end}) aimS:Slider({Name = "Smoothness", Min = 0.1, Max = 10, Default = 3, Decimal = 0.1, Callback = function(int) Config.Combat.AimbotSmoothness = int end}) aimS:Dropdown({Name = "Target Bone", Options = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"}, Default = "Head", Callback = function(v) Config.Combat.AimbotBone = v end})
    local sharpS = Tabs.Combat:Section({Name = "Sharp Aim", Side = "Left"}) local sharpT = sharpS:Toggle({Name = "Enabled", callback = function(v) Config.Combat.SharpAim = v end}) sharpT:Colorpicker({Name = "FOV Color", Flag = "sharp_aim_color", Callback = function(c) Config.Combat.SharpAimColor = c end}) sharpS:Toggle({Name = "Show FOV", callback = function(v) Config.Combat.SharpAimShowFOV = v end}) sharpS:Slider({Name = "FOV", Min = 10, Max = 500, Default = 150, Decimal = 0.1, Callback = function(int) Config.Combat.SharpAimFOV = int end}) sharpS:Dropdown({Name = "Target Bone", Options = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"}, Default = "Head", Callback = function(v) Config.Combat.SharpAimBone = v end})
    local tbS = Tabs.Combat:Section({Name = "Triggerbot", Side = "Left"}) local tbT = tbS:Toggle({Name = "Enabled", callback = function(v) Config.Combat.Triggerbot = v end}) tbT:Keybind({Name = "Triggerbot Bind", Mode = "Toggle", Callback = function(bool) Config.Combat.Triggerbot = bool end}) tbS:Slider({Name = "Delay", Min = 0, Max = 500, Default = 50, Decimal = 0.1, Callback = function(int) Config.Combat.TriggerbotDelay = int end})
    local hbS = Tabs.Combat:Section({Name = "Hitbox Expander", Side = "Right"}) local hbT = hbS:Toggle({Name = "Enabled", callback = function(v) Config.Combat.HitboxEnabled = v end}) hbT:Keybind({Name = "Hitbox Bind", Mode = "Toggle", Callback = function(bool) Config.Combat.HitboxEnabled = bool end}) hbS:Slider({Name = "Size", Min = 1, Max = 20, Default = 10, Decimal = 0.1, Callback = function(int) Config.Combat.HitboxSize = int end}) hbS:Slider({Name = "Transparency", Min = 0, Max = 1, Default = 0.5, Decimal = 0.1, Callback = function(int) Config.Combat.HitboxTransparency = int end})
    local auraS = Tabs.Combat:Section({Name = "Kill Aura (Murd Only)", Side = "Right"}) local kaT = auraS:Toggle({Name = "Enabled", callback = function(v) Config.Combat.KillAura = v end}) kaT:Keybind({Name = "Kill Aura Bind", Mode = "Toggle", Callback = function(bool) Config.Combat.KillAura = bool end}) auraS:Slider({Name = "Distance", Min = 5, Max = 100, Default = 30, Decimal = 0.1, Callback = function(int) Config.Combat.KillAuraDistance = int end})
    local killAllS = Tabs.Combat:Section({Name = "Kill All (Murd Only)", Side = "Right"}) local katT = killAllS:Toggle({Name = "Enabled", callback = function(v) Config.Combat.KillAll = v end}) katT:Keybind({Name = "Kill All Bind", Mode = "Toggle", Callback = function(bool) Config.Combat.KillAll = bool end})
    local ggS = Tabs.Combat:Section({Name = "Grab Gun", Side = "Right"}) local ggT = ggS:Toggle({Name = "Grab", callback = function(v) if v then GrabGun() end end}) ggT:Keybind({Name = "Grab Gun Bind", Mode = "Hold", Callback = function(bool) if bool then GrabGun() end end})

    local espV = Tabs.Visuals:Section({Name = "Role ESP", Side = "Left"}) local espT = espV:Toggle({Name = "Enabled", callback = function(v) Config.ESP.Enabled = v end}) espT:Keybind({Name = "ESP Bind", Mode = "Toggle", Callback = function(bool) Config.ESP.Enabled = bool end}) espV:Toggle({Name = "Self ESP", callback = function(v) Config.ESP.SelfESP = v end}) espV:Toggle({Name = "Box", callback = function(v) Config.ESP.Box = v end}) espV:Toggle({Name = "Skeleton", callback = function(v) Config.ESP.Skeleton = v end}) espV:Toggle({Name = "Name", callback = function(v) Config.ESP.Name = v end}) espV:Toggle({Name = "Distance", callback = function(v) Config.ESP.Distance = v end}) espV:Toggle({Name = "Tracer", callback = function(v) Config.ESP.Tracer = v end}) espV:Dropdown({Name = "Tracer Origin", Options = {"Bottom", "Middle", "Top", "Mouse"}, Default = "Bottom", Callback = function(v) Config.ESP.TracerOrigin = v end}) local mcT = espV:Toggle({Name = "Murderer Color", callback = function() end}) mcT:Colorpicker({Name = "Murderer", Flag = "esp_murderer_color", Callback = function(c) Config.ESP.MurdererColor = c end}) local scT = espV:Toggle({Name = "Sheriff Color", callback = function() end}) scT:Colorpicker({Name = "Sheriff", Flag = "esp_sheriff_color", Callback = function(c) Config.ESP.SheriffColor = c end}) local icT = espV:Toggle({Name = "Innocent Color", callback = function() end}) icT:Colorpicker({Name = "Innocent", Flag = "esp_innocent_color", Callback = function(c) Config.ESP.InnocentColor = c end})
    local pchamsV = Tabs.Visuals:Section({Name = "Player Chams", Side = "Left"}) pchamsV:Toggle({Name = "Enabled (Through Walls)", callback = function(v) Config.ESP.PlayerChams = v end}) pchamsV:Toggle({Name = "Glow (Remove Outline)", callback = function(v) Config.ESP.PlayerGlow = v end})
    local warnV = Tabs.Visuals:Section({Name = "Murderer Warning", Side = "Left"}) warnV:Toggle({Name = "Enabled", callback = function(v) Config.ESP.MurdererWarning = v end}) warnV:Textbox({Name = "Custom Image ID", Callback = function(text) State.customImageId = text end}) warnV:Textbox({Name = "Custom Image Name", Callback = function(text) State.customImageName = text end}) local imageDropdown local function RefreshImageDropdown() local names = {} for _, img in ipairs(State.warningImages) do table.insert(names, img.name) end if imageDropdown then imageDropdown.RefreshOptions(names) end end warnV:Button({Name = "Add Custom Image", Callback = function() if State.customImageId ~= "" and State.customImageName ~= "" then local id = State.customImageId:match("rbxassetid://(%d+)") or State.customImageId:match("(%d+)") or State.customImageId table.insert(State.warningImages, {name = State.customImageName, id = "rbxassetid://" .. id}) RefreshImageDropdown() end end}) imageDropdown = warnV:Dropdown({Name = "Warning Image", Options = {"Default"}, Default = "Default", Callback = function(v) for _, img in ipairs(State.warningImages) do if img.name == v then Config.ESP.WarningImageId = img.id if State.warningImage then State.warningImage.Image = img.id end break end end end})
    local wepV = Tabs.Visuals:Section({Name = "Weapon ESP", Side = "Left"}) local weT = wepV:Toggle({Name = "Enabled", callback = function(v) Config.ESP.WeaponESP = v end}) weT:Keybind({Name = "Weapon ESP Bind", Mode = "Toggle", Callback = function(bool) Config.ESP.WeaponESP = bool end}) wepV:Toggle({Name = "Box", callback = function(v) Config.ESP.WeaponBox = v end}) wepV:Toggle({Name = "Distance", callback = function(v) Config.ESP.WeaponDistance = v end}) wepV:Toggle({Name = "Tracer", callback = function(v) Config.ESP.WeaponTracer = v end}) wepV:Dropdown({Name = "Tracer Origin", Options = {"Bottom", "Middle", "Top", "Mouse"}, Default = "Bottom", Callback = function(v) Config.ESP.WeaponTracerOrigin = v end}) wepV:Toggle({Name = "Dot", callback = function(v) Config.ESP.WeaponDot = v end}) wepV:Toggle({Name = "Chams (Highlight)", callback = function(v) Config.ESP.WeaponChams = v end}) wepV:Toggle({Name = "Glow", callback = function(v) Config.ESP.WeaponGlow = v end}) wepV:Toggle({Name = "Image ESP", callback = function(v) Config.ESP.WeaponImage = v end}) wepV:Textbox({Name = "Image ID", Callback = function(text) local id = text:match("rbxassetid://(%d+)") or text:match("(%d+)") or text Config.ESP.WeaponImageId = "rbxassetid://" .. id if State.weaponImageLabel then State.weaponImageLabel.Image = Config.ESP.WeaponImageId end end}) local wcT = wepV:Toggle({Name = "Main Color", callback = function() end}) wcT:Colorpicker({Name = "Color", Flag = "weapon_color", Callback = function(c) Config.ESP.WeaponColor = c end}) local wbcT = wepV:Toggle({Name = "Box Color", callback = function() end}) wbcT:Colorpicker({Name = "Box", Flag = "weapon_box_color", Callback = function(c) Config.ESP.WeaponBoxColor = c end}) local wtcT = wepV:Toggle({Name = "Tracer Color", callback = function() end}) wtcT:Colorpicker({Name = "Tracer", Flag = "weapon_tracer_color", Callback = function(c) Config.ESP.WeaponTracerColor = c end}) local wdcT = wepV:Toggle({Name = "Dot Color", callback = function() end}) wdcT:Colorpicker({Name = "Dot", Flag = "weapon_dot_color", Callback = function(c) Config.ESP.WeaponDotColor = c end})
    local coinV = Tabs.Visuals:Section({Name = "Coin ESP", Side = "Left"}) local ceT = coinV:Toggle({Name = "Enabled", callback = function(v) Config.ESP.CoinESP = v end}) coinV:Toggle({Name = "Box", callback = function(v) Config.ESP.CoinBox = v end}) coinV:Toggle({Name = "Distance", callback = function(v) Config.ESP.CoinDistance = v end}) coinV:Toggle({Name = "Tracer", callback = function(v) Config.ESP.CoinTracer = v end}) coinV:Dropdown({Name = "Tracer Origin", Options = {"Bottom", "Middle", "Top", "Mouse"}, Default = "Bottom", Callback = function(v) Config.ESP.CoinTracerOrigin = v end}) local ccT = coinV:Toggle({Name = "Coin Color", callback = function() end}) ccT:Colorpicker({Name = "Color", Flag = "coin_color", Callback = function(c) Config.ESP.CoinColor = c end})
    local hitV = Tabs.Visuals:Section({Name = "Died Sounds", Side = "Left"}) hitV:Toggle({Name = "Died Sounds", callback = function(v) Config.Combat.DiedSounds = v end}) hitV:Dropdown({Name = "Died Sound", Options = {"Gamesense", "Bubble", "Neverlose (RBX)", "Fatality"}, Default = "Gamesense", Callback = function(v) local sounds = {["Gamesense"] = "rbxassetid://4817809188", ["Bubble"] = "rbxassetid://6534947588", ["Neverlose (RBX)"] = "rbxassetid://97643101798871", ["Fatality"] = "rbxassetid://106586644436584"} Config.Combat.DiedSoundID = sounds[v] or sounds["Gamesense"] end})

    local selfV = Tabs.Visuals:Section({Name = "Self Visuals", Side = "Right"}) local ihT = selfV:Toggle({Name = "Invisible Head", callback = function(v) Config.Visuals.InvisHead = v end}) ihT:Keybind({Name = "Invis Head Bind", Mode = "Toggle", Callback = function(bool) Config.Visuals.InvisHead = bool end}) local chT = selfV:Toggle({Name = "Chams (Self)", callback = function(v) Config.Visuals.Chams.Enabled = v end}) chT:Keybind({Name = "Chams Bind", Mode = "Toggle", Callback = function(bool) Config.Visuals.Chams.Enabled = bool end}) chT:Colorpicker({Name = "Chams Color", Flag = "chams_color", Callback = function(c) Config.Visuals.Chams.Color = c end})
    local htT = selfV:Toggle({Name = "China Hat", callback = function(v) Config.Visuals.ChinaHat.Enabled = v end}) htT:Keybind({Name = "China Hat Bind", Mode = "Toggle", Callback = function(bool) Config.Visuals.ChinaHat.Enabled = bool end}) htT:Colorpicker({Name = "Hat Color", Flag = "hat_color", Callback = function(c) Config.Visuals.ChinaHat.Color = c end}) selfV:Slider({Name = "Width", Min = 1, Max = 10, Default = 3, Decimal = 0.1, Callback = function(int) Config.Visuals.ChinaHat.Width = int end}) selfV:Slider({Name = "Height", Min = 1, Max = 10, Default = 3, Decimal = 0.1, Callback = function(int) Config.Visuals.ChinaHat.Height = int end}) selfV:Slider({Name = "Depth", Min = 1, Max = 10, Default = 3, Decimal = 0.1, Callback = function(int) Config.Visuals.ChinaHat.Depth = int end}) selfV:Slider({Name = "Offset X", Min = -5, Max = 5, Default = 0, Decimal = 0.1, Callback = function(int) Config.Visuals.ChinaHat.OffsetX = int end}) selfV:Slider({Name = "Offset Y", Min = -5, Max = 5, Default = 0, Decimal = 0.1, Callback = function(int) Config.Visuals.ChinaHat.OffsetY = int end}) selfV:Slider({Name = "Offset Z", Min = -5, Max = 5, Default = 0, Decimal = 0.1, Callback = function(int) Config.Visuals.ChinaHat.OffsetZ = int end})
    local trT = selfV:Toggle({Name = "Trail", callback = function(v) Config.Visuals.Trail.Enabled = v end}) trT:Keybind({Name = "Trail Bind", Mode = "Toggle", Callback = function(bool) Config.Visuals.Trail.Enabled = bool end}) trT:Colorpicker({Name = "Trail Color", Flag = "trail_color", Callback = function(c) Config.Visuals.Trail.Color = c end}) selfV:Slider({Name = "Trail Width", Min = 0.1, Max = 10, Default = 1, Decimal = 0.1, Callback = function(int) Config.Visuals.Trail.Width = int end}) selfV:Slider({Name = "Trail Time", Min = 0.1, Max = 5, Default = 1, Decimal = 0.1, Callback = function(int) Config.Visuals.Trail.Time = int end}) selfV:Dropdown({Name = "Follow", Options = {"Head", "Torso", "Legs"}, Default = "Torso", Callback = function(v) Config.Visuals.Trail.Follow = v end})
    local auT = selfV:Toggle({Name = "Self Aura", callback = function(v) Config.Visuals.SelfAura = v end}) auT:Keybind({Name = "Aura Bind", Mode = "Toggle", Callback = function(bool) Config.Visuals.SelfAura = bool end}) auT:Colorpicker({Name = "Aura Color", Flag = "aura_color", Callback = function(c) Config.Visuals.AuraColor = c end}) selfV:Slider({Name = "Count", Min = 1, Max = 200, Default = 50, Decimal = 0.1, Callback = function(int) Config.Visuals.AuraCount = int end}) selfV:Toggle({Name = "Glow", callback = function(v) Config.Visuals.AuraGlow = v end})
    local dkT = selfV:Toggle({Name = "Dick", callback = function(v) Config.Visuals.Dick.Enabled = v end}) dkT:Keybind({Name = "Dick Bind", Mode = "Toggle", Callback = function(bool) Config.Visuals.Dick.Enabled = bool end}) dkT:Colorpicker({Name = "Dick Color", Flag = "dick_color", Callback = function(c) Config.Visuals.Dick.Color = c end})
    local paT = selfV:Toggle({Name = "Particle Aura", callback = function(v) Config.Visuals.ParticleAura = v end}) paT:Colorpicker({Name = "Particle Aura Color", Flag = "particle_aura_color", Callback = function(c) Config.Visuals.ParticleAuraColor = c end}) selfV:Dropdown({Name = "Aura Type", Options = {"starlight", "heavenly", "ribbon", "sakura", "angel", "wind", "flow", "star"}, Default = "angel", Callback = function(v) Config.Visuals.ParticleAuraType = v for _, p in pairs(State.particleAuraParts) do pcall(function() p:Destroy() end) end State.particleAuraParts = {} end})

    local matV = Tabs.Visuals:Section({Name = "Materials", Side = "Right"}) local cmT = matV:Toggle({Name = "Character Material", callback = function(v) Config.Visuals.CharacterMaterial = v end}) cmT:Colorpicker({Name = "Char Color", Flag = "char_color", Callback = function(c) Config.Visuals.CharColor = c end}) local tmT = matV:Toggle({Name = "Tool Material", callback = function(v) Config.Visuals.ToolMaterial = v end}) tmT:Colorpicker({Name = "Tool Color", Flag = "tool_color", Callback = function(c) Config.Visuals.ToolColor = c end})
    local lightV = Tabs.Visuals:Section({Name = "Lighting", Side = "Right"}) lightV:Slider({Name = "Camera FOV", Min = 1, Max = 120, Default = 70, Decimal = 0.1, Callback = function(int) Config.Visuals.FOV = int end}) local fbT = lightV:Toggle({Name = "Fullbright", callback = function(v) Config.Visuals.Fullbright = v end}) fbT:Keybind({Name = "Fullbright Bind", Mode = "Toggle", Callback = function(bool) Config.Visuals.Fullbright = bool end}) local nmT = lightV:Toggle({Name = "Night Mode", callback = function(v) Config.Visuals.NightMode = v end}) nmT:Keybind({Name = "Night Bind", Mode = "Toggle", Callback = function(bool) Config.Visuals.NightMode = bool end}) lightV:Slider({Name = "Intensity", Min = 0, Max = 2, Default = 0, Decimal = 0.1, Callback = function(int) Config.Visuals.NightModeIntensity = int end}) local rbT = lightV:Toggle({Name = "Rainbow Ambient", callback = function(v) Config.Visuals.RainbowAmbient = v end}) rbT:Keybind({Name = "Rainbow Bind", Mode = "Toggle", Callback = function(bool) Config.Visuals.RainbowAmbient = bool end}) lightV:Slider({Name = "Speed", Min = 1, Max = 10, Default = 5, Decimal = 0.1, Callback = function(int) Config.Visuals.RainbowSpeed = int end}) local caT = lightV:Toggle({Name = "Custom Ambient", callback = function(v) Config.Visuals.CustomAmbient = v end}) caT:Colorpicker({Name = "Ambient Color", Flag = "ambient_color", Callback = function(c) Config.Visuals.AmbientColor = c end}) local fogT = lightV:Toggle({Name = "Custom Fog", callback = function(v) Config.Visuals.CustomFog = v end}) fogT:Colorpicker({Name = "Fog Color", Flag = "fog_color", Callback = function(c) Config.Visuals.FogColor = c end}) lightV:Slider({Name = "Fog Start", Min = 0, Max = 1000, Default = 0, Decimal = 0.1, Callback = function(int) Config.Visuals.FogStart = int end}) lightV:Slider({Name = "Fog End", Min = 50, Max = 5000, Default = 200, Decimal = 0.1, Callback = function(int) Config.Visuals.FogEnd = int end})
    local worldV = Tabs.Visuals:Section({Name = "World & Tracers", Side = "Right"}) local btT = worldV:Toggle({Name = "Bullet Tracers (Gun Only)", callback = function(v) Config.Visuals.BulletTracers = v end}) btT:Colorpicker({Name = "Tracer Color", Flag = "tracer_color", Callback = function(c) Config.Visuals.TracerColor = c end}) worldV:Slider({Name = "Tracer Size", Min = 0.1, Max = 3, Default = 0.4, Decimal = 0.1, Callback = function(int) Config.Visuals.TracerSize = int end}) worldV:Slider({Name = "Tracer Time", Min = 0.1, Max = 10, Default = 1, Decimal = 0.1, Callback = function(int) Config.Visuals.TracerTime = int end}) local skT = worldV:Toggle({Name = "Custom Skybox", callback = function(v) Config.Visuals.CustomSkybox = v end}) worldV:Dropdown({Name = "Skybox", Options = {"Black Storm", "Blue Space", "Realistic", "Pink", "Stormy"}, Default = "Black Storm", Callback = function(v) Config.Visuals.SkyboxName = v end}) local wmT = worldV:Toggle({Name = "World Mods", callback = function(v) Config.Visuals.WorldMods = v end}) wmT:Keybind({Name = "World Bind", Mode = "Toggle", Callback = function(bool) Config.Visuals.WorldMods = bool end}) worldV:Slider({Name = "Brightness", Min = 0, Max = 10, Default = 0, Decimal = 0.1, Callback = function(int) Config.Visuals.Brightness = int end}) worldV:Slider({Name = "Clock Time", Min = 0, Max = 24, Default = 0, Decimal = 0.1, Callback = function(int) Config.Visuals.ClockTime = int end}) worldV:Slider({Name = "Exposure", Min = -3, Max = 3, Default = 0, Decimal = 0.1, Callback = function(int) Config.Visuals.Exposure = int end})
    local mbT = worldV:Toggle({Name = "Motion Blur", callback = function(v) Config.Visuals.MotionBlur = v end}) local arT = worldV:Toggle({Name = "Aspect Ratio", callback = function(v) Config.Visuals.AspectRatio = v end}) worldV:Slider({Name = "Aspect Value", Min = 0.1, Max = 2, Default = 1, Decimal = 0.1, Callback = function(int) Config.Visuals.AspectRatioValue = int end})

    local moveS = Tabs.Movement:Section({Name = "Movement", Side = "Left"}) local flyT = moveS:Toggle({Name = "Fly", callback = function(v) Config.Movement.Fly = v end}) flyT:Keybind({Name = "Fly Bind", Mode = "Toggle", Callback = function(bool) Config.Movement.Fly = bool end}) moveS:Slider({Name = "Fly Speed", Min = 10, Max = 200, Default = 50, Decimal = 0.1, Callback = function(int) Config.Movement.FlySpeed = int end}) local ncT = moveS:Toggle({Name = "Noclip", callback = function(v) Config.Movement.Noclip = v end}) ncT:Keybind({Name = "Noclip Bind", Mode = "Toggle", Callback = function(bool) Config.Movement.Noclip = bool end}) local spT = moveS:Toggle({Name = "Speed Hack", callback = function(v) Config.Movement.Speed = v end}) spT:Keybind({Name = "Speed Bind", Mode = "Toggle", Callback = function(bool) Config.Movement.Speed = bool end}) moveS:Slider({Name = "Speed Value", Min = 16, Max = 200, Default = 50, Decimal = 0.1, Callback = function(int) Config.Movement.SpeedValue = int end}) local jhT = moveS:Toggle({Name = "Jump Hack", callback = function(v) Config.Movement.JumpHack = v end}) jhT:Keybind({Name = "Jump Hack Bind", Mode = "Toggle", Callback = function(bool) Config.Movement.JumpHack = bool end}) moveS:Slider({Name = "Jump Power", Min = 50, Max = 300, Default = 100, Decimal = 0.1, Callback = function(int) Config.Movement.JumpPower = int end}) local ijT = moveS:Toggle({Name = "Infinite Jump", callback = function(v) Config.Movement.InfiniteJump = v end}) ijT:Keybind({Name = "Inf Jump Bind", Mode = "Toggle", Callback = function(bool) Config.Movement.InfiniteJump = bool end}) local grT = moveS:Toggle({Name = "GravityZero", callback = function(v) Config.Movement.GravityZero = v end}) grT:Keybind({Name = "Gravity Bind", Mode = "Toggle", Callback = function(bool) Config.Movement.GravityZero = bool end}) moveS:Toggle({Name = "Smooth Fall", callback = function(v) SetSmoothFall(v) end})
    local spinS = Tabs.Movement:Section({Name = "Spin", Side = "Left"}) local spinT = spinS:Toggle({Name = "Enabled", callback = function(v) Config.Movement.Spin = v end}) spinT:Keybind({Name = "Spin Bind", Mode = "Toggle", Callback = function(bool) Config.Movement.Spin = bool end}) spinS:Slider({Name = "Spin Speed", Min = 1, Max = 50, Default = 10, Decimal = 0.1, Callback = function(int) Config.Movement.SpinSpeed = int end})
    local tpS = Tabs.Movement:Section({Name = "Teleport", Side = "Left"}) tpS:Button({Name = "TP to Spawn", Callback = function() TPToSpawn() end}) tpS:Button({Name = "TP to Map", Callback = function() TPToMap() end})

    local farmS = Tabs.Farm:Section({Name = "Auto Farm", Side = "Left"}) local acT = farmS:Toggle({Name = "Auto Farm Coins (TP + Noclip)", callback = function(v) Config.Farm.AutoCoins = v if v then StartAutoFarm() end end}) acT:Keybind({Name = "Farm Bind", Mode = "Toggle", Callback = function(bool) Config.Farm.AutoCoins = bool if bool then StartAutoFarm() end end})
    local xpS = Tabs.Farm:Section({Name = "Auto Farm XP", Side = "Left"}) xpS:Toggle({Name = "Enabled", callback = function(v) Config.Farm.AutoXP = v end})

    local flingS = Tabs.Misc:Section({Name = "Fling", Side = "Left"}) flingS:Button({Name = "Fling Murderer", Callback = function() FlingByRole("Murderer") end}) flingS:Button({Name = "Fling Sheriff/Hero", Callback = function() FlingByRole("Sheriff") end}) flingS:Button({Name = "Fling All", Callback = function() FlingAll() end})
    local afS = Tabs.Misc:Section({Name = "Anti-Fling", Side = "Left"}) local afT = afS:Toggle({Name = "Enabled", callback = function(v) Config.Misc.AntiFling = v if v then State.antiFlingConn = RunService.Heartbeat:Connect(function() UpdateCache() if CachedRoot and CachedHum and CachedHum.Health > 0 then local vel = CachedRoot.AssemblyLinearVelocity local rotVel = CachedRoot.AssemblyAngularVelocity local maxSpeed = CachedHum.WalkSpeed + 30 if vel.Magnitude > maxSpeed then CachedRoot.AssemblyLinearVelocity = vel.Unit * maxSpeed end if rotVel.Magnitude > 50 then CachedRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0) end end end) else if State.antiFlingConn then State.antiFlingConn:Disconnect() State.antiFlingConn = nil end end end})
    local gsS = Tabs.Misc:Section({Name = "Gun Sound Changer", Side = "Left"}) local gsT = gsS:Toggle({Name = "Enabled", callback = function(v) Config.Misc.GunSoundChanger = v end}) gsT:Keybind({Name = "Gun Sound Bind", Mode = "Toggle", Callback = function(bool) Config.Misc.GunSoundChanger = bool end}) gsS:Slider({Name = "Volume", Min = 0, Max = 10, Default = 3, Decimal = 0.1, Callback = function(int) Config.Misc.GunSoundVolume = int end}) gsS:Dropdown({Name = "Gun Sound", Options = {"Gamesense", "Bubble", "Neverlose", "Fatality", "Laser"}, Default = "Gamesense", Callback = function(v) local s = {["Gamesense"] = "rbxassetid://4817809188", ["Bubble"] = "rbxassetid://6534947588", ["Neverlose"] = "rbxassetid://97643101798871", ["Fatality"] = "rbxassetid://106586644436584", ["Laser"] = "rbxassetid://160248522"} Config.Misc.GunSoundID = s[v] or s["Gamesense"] end})
    local animS = Tabs.Misc:Section({Name = "Animation Player", Side = "Right"}) local anT = animS:Toggle({Name = "Enabled", callback = function(v) ToggleAnimation(v) end}) anT:Keybind({Name = "Animation Bind", Mode = "Toggle", Callback = function(bool) anT:Set(bool) ToggleAnimation(bool) end}) animS:Dropdown({Name = "Animation", Options = {"Wave", "Dance", "Bow", "Shy", "Fall", "Floss", "Yungblud Happier Jump", "Godlike", "Sturdy Dance - Ice Spice", "Old Town Road Dance - Lil Nas X (LNX)", "Mae Stephens - Piano Hands", "Elton John - Heart Skip", "Baby Queen - Bouncy Twirl"}, Default = "Wave", Callback = function(v) local anims = {["Wave"] = "rbxassetid://507770239", ["Dance"] = "rbxassetid://507771019", ["Bow"] = "rbxassetid://507768375", ["Shy"] = "rbxassetid://507770239", ["Fall"] = "rbxassetid://507767968", ["Floss"] = "rbxassetid://10714340543", ["Yungblud Happier Jump"] = "rbxassetid://15609995579", ["Godlike"] = "rbxassetid://10714347256", ["Sturdy Dance - Ice Spice"] = "rbxassetid://17746180844", ["Old Town Road Dance - Lil Nas X (LNX)"] = "rbxassetid://10714391240", ["Mae Stephens - Piano Hands"] = "rbxassetid://16553163212", ["Elton John - Heart Skip"] = "rbxassetid://11309255148", ["Baby Queen - Bouncy Twirl"] = "rbxassetid://14352343065"} if anims[v] then SetAnimationID(anims[v]) end end})
    animS:Slider({Name = "Speed", Min = 0.1, Max = 5, Default = 1, Decimal = 0.1, Callback = function(int) Config.Animation.Speed = int if State.animTrack and State.animPlaying then State.animTrack:AdjustSpeed(int) end end})
    local packS = Tabs.Misc:Section({Name = "Animation Packs", Side = "Right"}) local packEnableT = packS:Toggle({Name = "Enable Custom Pack", callback = function(v) Config.AnimPack.Enabled = v if v and LocalPlayer.Character then ApplyAnimPackToChar(LocalPlayer.Character) end end}) packEnableT:Keybind({Name = "Pack Toggle Bind", Mode = "Toggle", Callback = function(bool) Config.AnimPack.Enabled = bool if bool and LocalPlayer.Character then ApplyAnimPackToChar(LocalPlayer.Character) end end}) local packList = {"Default", "Rthro", "DaHoodian", "Ninja", "Zombie", "Stylish", "Pirate", "Toy", "Vampire", "Werewolf", "Superhero"} packS:Dropdown({Name = "Idle", Options = packList, Default = "Default", Callback = function(v) Config.AnimPack.idle = v if LocalPlayer.Character then ApplyAnimPackToChar(LocalPlayer.Character) end end}) packS:Dropdown({Name = "Walk", Options = packList, Default = "Default", Callback = function(v) Config.AnimPack.walk = v if LocalPlayer.Character then ApplyAnimPackToChar(LocalPlayer.Character) end end}) packS:Dropdown({Name = "Run", Options = packList, Default = "Default", Callback = function(v) Config.AnimPack.run = v if LocalPlayer.Character then ApplyAnimPackToChar(LocalPlayer.Character) end end}) packS:Dropdown({Name = "Jump", Options = packList, Default = "Default", Callback = function(v) Config.AnimPack.jump = v if LocalPlayer.Character then ApplyAnimPackToChar(LocalPlayer.Character) end end}) packS:Dropdown({Name = "Climb", Options = packList, Default = "Default", Callback = function(v) Config.AnimPack.climb = v if LocalPlayer.Character then ApplyAnimPackToChar(LocalPlayer.Character) end end}) packS:Dropdown({Name = "Fall", Options = packList, Default = "Default", Callback = function(v) Config.AnimPack.fall = v if LocalPlayer.Character then ApplyAnimPackToChar(LocalPlayer.Character) end end})
    local miscS = Tabs.Misc:Section({Name = "Misc", Side = "Right"}) local afkT = miscS:Toggle({Name = "Anti-AFK", callback = function(v) Config.Misc.AntiAFK = v end}) afkT:Keybind({Name = "Anti-AFK Bind", Mode = "Toggle", Callback = function(bool) Config.Misc.AntiAFK = bool end}) local wfT = miscS:Toggle({Name = "Walk Fling (Touch)", callback = function(v) Config.Misc.WalkFling = v end}) wfT:Keybind({Name = "Walk Fling Bind", Mode = "Toggle", Callback = function(bool) Config.Misc.WalkFling = bool end})
    miscS:Button({Name = "Spec Murderer", Callback = function() SpecByRole("Murderer") end})
    miscS:Button({Name = "Spec Sheriff", Callback = function() SpecByRole("Sheriff") end})
    miscS:Button({Name = "Unspec", Callback = function() Unspectate() end})

    local playerActS = Tabs.Players:Section({Name = "Player Actions", Side = "Right"}) 
    PlayerDropdown = playerActS:Dropdown({Name = "Select Player", Options = State.playerNames, Default = "None", Callback = function(v) State.selectedPlayerName = v end}) 
    playerActS:Button({Name = "Refresh Players", Callback = function() RefreshPlayerNames() end}) 
    playerActS:Button({Name = "Teleport", Callback = function() if State.selectedPlayerName then TeleportToPlayer(State.selectedPlayerName) end end}) 
    playerActS:Button({Name = "Fling", Callback = function() if State.selectedPlayerName then FlingPlayer(State.selectedPlayerName) end end}) 
    playerActS:Button({Name = "Spectate", Callback = function() if State.selectedPlayerName then SpectatePlayer(State.selectedPlayerName) end end}) 
    playerActS:Button({Name = "Unspectate", Callback = function() Unspectate() end}) 
    playerActS:Toggle({Name = "Auto Fling", callback = function(v) Config.Combat.AutoFling = v end})
    playerActS:Toggle({Name = "Auto Tp (Shoulder)", callback = function(v) Config.Players.AutoTp = v end})
    playerActS:Button({Name = "Add to Whitelist", Callback = function() 
        local p = Players:FindFirstChild(State.selectedPlayerName) 
        if p and not State.whitelist[p] then
            State.whitelist[p] = {
                ESPColor = rgb(0, 255, 0), IgnoreKill = true, InvisHead = false, Chams = false, ChinaHat = false, Trail = false, 
                SelfAura = false, Dick = false, WalkSteps = false, FootParticles = false, CharMat = false, ToolMat = false, 
                BulletTracers = false, GunSound = false, ParticleAura = false
            }
            State.wlVisuals[p] = {} 
            local sec = Tabs.Players:Section({Name = "WL: " .. p.Name, Side = "Left"})
            State.wlSections[p] = sec
            sec:Colorpicker({Name = "ESP Color", Flag = "wl_color_"..p.Name, Callback = function(c) if State.whitelist[p] then State.whitelist[p].ESPColor = c end end})
            sec:Toggle({Name = "Ignore in Kill Aura/All", Callback = function(v) if State.whitelist[p] then State.whitelist[p].IgnoreKill = v end end})
            sec:Button({Name = "Teleport", Callback = function() TeleportToPlayer(p.Name) end})
            sec:Button({Name = "Spectate", Callback = function() SpectatePlayer(p.Name) end})
            sec:Button({Name = "Fling", Callback = function() FlingPlayer(p) end})
            sec:Button({Name = "Unwhitelist", Callback = function() 
                if State.whitelist[p] then
                    State.whitelist[p] = nil
                    if State.wlSections[p] then pcall(function() State.wlSections[p].Items.Section:Destroy() end) State.wlSections[p] = nil end
                    if State.wlVisuals[p] then
                        local vis = State.wlVisuals[p]
                        if vis.ChinaHat then vis.ChinaHat:Destroy() end
                        if vis.Trail then pcall(function() vis.Trail.trail:Destroy() vis.Trail.att0:Destroy() vis.Trail.att1:Destroy() end) end
                        if vis.Aura then vis.Aura:Destroy() end
                        if vis.Dick then for _, part in ipairs(vis.Dick) do part:Destroy() end end
                        if vis.WalkSteps then vis.WalkSteps:Destroy() end
                        if vis.FootParticles then vis.FootParticles:Destroy() end
                        if vis.ParticleAura then for _, part in ipairs(vis.ParticleAura) do part:Destroy() end end
                        State.wlVisuals[p] = nil
                    end
                    if State.playerChamsHighlights[p] then pcall(function() State.playerChamsHighlights[p]:Destroy() end); State.playerChamsHighlights[p] = nil end
                end
            end})
            sec:Toggle({Name = "Invisible Head", Callback = function(v) if State.whitelist[p] then State.whitelist[p].InvisHead = v end end})
            sec:Toggle({Name = "Chams", Callback = function(v) if State.whitelist[p] then State.whitelist[p].Chams = v end end})
            sec:Toggle({Name = "China Hat", Callback = function(v) if State.whitelist[p] then State.whitelist[p].ChinaHat = v end end})
            sec:Toggle({Name = "Trail", Callback = function(v) if State.whitelist[p] then State.whitelist[p].Trail = v end end})
            sec:Toggle({Name = "Self Aura", Callback = function(v) if State.whitelist[p] then State.whitelist[p].SelfAura = v end end})
            sec:Toggle({Name = "Dick", Callback = function(v) if State.whitelist[p] then State.whitelist[p].Dick = v end end})
            sec:Toggle({Name = "Walk Steps", Callback = function(v) if State.whitelist[p] then State.whitelist[p].WalkSteps = v end end})
            sec:Toggle({Name = "Foot Particles", Callback = function(v) if State.whitelist[p] then State.whitelist[p].FootParticles = v end end})
            sec:Toggle({Name = "Character Material", Callback = function(v) if State.whitelist[p] then State.whitelist[p].CharMat = v end end})
            sec:Toggle({Name = "Tool Material", Callback = function(v) if State.whitelist[p] then State.whitelist[p].ToolMat = v end end})
            sec:Toggle({Name = "Bullet Tracers", Callback = function(v) if State.whitelist[p] then State.whitelist[p].BulletTracers = v end end})
            sec:Toggle({Name = "Gun Sound Changer", Callback = function(v) if State.whitelist[p] then State.whitelist[p].GunSound = v end end})
            sec:Toggle({Name = "Particle Aura", Callback = function(v) if State.whitelist[p] then State.whitelist[p].ParticleAura = v end end})
        end
    end})

    local SettingsTab = Window:Tab({Name = "Settings"})
    local ConfigSection = SettingsTab:Section({Name = "Config System", Side = "Left"})
    local ConfigList = {}
    local ConfigDropdown
    local CurrentConfigName = ""
    local function RefreshConfigList()
        local list = {}
        pcall(function()
            if not isfolder("xezios/configs") then makefolder("xezios/configs") end
            for _, file in listfiles("xezios/configs") do
                local name = file:match("([^\\/]+)%.cfg$")
                if name then table.insert(list, name) end
            end
        end)
        ConfigList = list
        if ConfigDropdown then ConfigDropdown.RefreshOptions(ConfigList) end
    end
    ConfigDropdown = ConfigSection:Dropdown({Name = "Configs", Options = {}, Callback = function(v) CurrentConfigName = v end})
    ConfigSection:Textbox({Name = "Config Name", Default = "", Callback = function(v) CurrentConfigName = v end})
    ConfigSection:Button({Name = "Save", Callback = function()
        if CurrentConfigName == "" then return end
        pcall(function()
            if not isfolder("xezios/configs") then makefolder("xezios/configs") end
            writefile("xezios/configs/" .. CurrentConfigName .. ".cfg", Library:GetConfig())
            RefreshConfigList()
        end)
    end})
    ConfigSection:Button({Name = "Load", Callback = function()
        if CurrentConfigName == "" then return end
        pcall(function()
            if isfile("xezios/configs/" .. CurrentConfigName .. ".cfg") then
                Library:LoadConfig(readfile("xezios/configs/" .. CurrentConfigName .. ".cfg"))
            end
        end)
    end})
    ConfigSection:Button({Name = "Delete", Callback = function()
        if CurrentConfigName == "" then return end
        pcall(function()
            if isfile("xezios/configs/" .. CurrentConfigName .. ".cfg") then
                delfile("xezios/configs/" .. CurrentConfigName .. ".cfg")
                RefreshConfigList()
            end
        end)
    end})
    RefreshConfigList()

    local ThemeSection = SettingsTab:Section({Name = "Theme & Menu", Side = "Right"})
    ThemeSection:Label({Name = "Accent Color"}):Colorpicker({Callback = function(c) Library:RefreshTheme("accent", c) end, Color = DefaultAccent})
    ThemeSection:Label({Name = "Window Outline"}):Colorpicker({Callback = function(c) Library:RefreshTheme("window_outline", c) end, Color = rgb(0, 0, 0)})
    ThemeSection:Label({Name = "Inline Elements"}):Colorpicker({Callback = function(c) Library:RefreshTheme("inline", c) end, Color = rgb(25, 27, 27)})
    ThemeSection:Label({Name = "Main Background"}):Colorpicker({Callback = function(c) Library:RefreshTheme("background", c) end, Color = rgb(17, 19, 19)})
    ThemeSection:Label({Name = "Visible Backgrounds"}):Colorpicker({Callback = function(c) Library:RefreshTheme("visible_backgrounds", c) end, Color = rgb(20, 23, 22)})
    ThemeSection:Label({Name = "Text Color"}):Colorpicker({Callback = function(c) Library:RefreshTheme("text_color", c) end, Color = rgb(221, 223, 222)})
    ThemeSection:Label({Name = "Glow Effect"}):Colorpicker({Callback = function(c) Library:RefreshTheme("glow", c) end, Color = rgb(0, 0, 0)})
    ThemeSection:Label({Name = "Deselected Elements"}):Colorpicker({Callback = function(c) Library:RefreshTheme("deselected", c) end, Color = rgb(89, 91, 91)})

    Window.Tweening = true
    local MenuBindLabel = ThemeSection:Label({Name = "Menu Bind"})
    MenuBindLabel:Keybind({Name = "Menu Bind", Callback = function(bool)
        if Window.Tweening then return end
        Window.ToggleMenu(bool)
    end, Default = true})
    task.delay(2, function() Window.Tweening = false end)

    local LinksSection = SettingsTab:Section({Name = "Links", Side = "Left"})
    LinksSection:Button({Name = "Copy Telegram", Callback = function() if setclipboard then setclipboard("https://t.me/luausense") end end})
    LinksSection:Button({Name = "Copy Discord", Callback = function() if setclipboard then setclipboard("https://discord.gg/zNbunbjbx") end end})
    
    local ServerSection = SettingsTab:Section({Name = "Server", Side = "Left"})
    ServerSection:Button({Name = "Server Hop", Callback = function() ServerHop() end})

    if IsAdmin() then
        local AdminTab = Window:Tab({Name = "Admin"})
        local adminKickS = AdminTab:Section({Name = "Kick User", Side = "Left"})
        local adminKickDropdown
        local adminSelectedKick = nil
        local adminKickReason = ""
        local function RefreshAdminPlayers()
            local list = {}
            for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(list, p.Name) end end
            if adminKickDropdown then adminKickDropdown.RefreshOptions(list) end
        end
        adminKickDropdown = adminKickS:Dropdown({Name = "Select User", Options = {}, Callback = function(v) adminSelectedKick = v end})
        adminKickS:Textbox({Name = "Reason", Callback = function(v) adminKickReason = v end})
        adminKickS:Button({Name = "Kick User", Callback = function()
            if adminSelectedKick then
                getgenv().luausense_Admin.Commands.Kick = {User = adminSelectedKick, Reason = adminKickReason ~= "" and adminKickReason or "Kicked by Admin"}
            end
        end})
        adminKickS:Button({Name = "Refresh", Callback = function() RefreshAdminPlayers() end})
        RefreshAdminPlayers()

        local adminMusicS = AdminTab:Section({Name = "Play Music", Side = "Left"})
        local musicID = ""
        adminMusicS:Textbox({Name = "Sound ID", Callback = function(v) musicID = v end})
        adminMusicS:Button({Name = "Play", Callback = function()
            getgenv().luausense_Admin.Commands.Music = {ID = musicID, Action = "Play"}
        end})
        adminMusicS:Button({Name = "Stop", Callback = function()
            getgenv().luausense_Admin.Commands.Music = {ID = "", Action = "Stop"}
        end})

        local adminVisualsS = AdminTab:Section({Name = "Visuals", Side = "Left"})
        adminVisualsS:Toggle({Name = "Rainbow Everything", callback = function(v)
            getgenv().luausense_Admin.Commands.Rainbow = v
        end})
    end
end
InitUI()

task.spawn(function()
    local lastKick = nil
    local lastMusic = nil
    local lastRainbow = nil
    while task.wait(0.5) do
        local cmds = getgenv().luausense_Admin.Commands
        if cmds then
            if cmds.Kick and cmds.Kick ~= lastKick then
                lastKick = cmds.Kick
                if cmds.Kick.User == LocalPlayer.Name then
                    LocalPlayer:Kick(cmds.Kick.Reason)
                end
            end
            if cmds.Music and cmds.Music ~= lastMusic then
                lastMusic = cmds.Music
                if cmds.Music.Action == "Play" then
                    pcall(function()
                        if State.adminMusic then State.adminMusic:Stop() State.adminMusic:Destroy() end
                        State.adminMusic = Instance.new("Sound")
                        State.adminMusic.SoundId = "rbxassetid://" .. cmds.Music.ID
                        State.adminMusic.Volume = 3
                        State.adminMusic.Parent = workspace
                        State.adminMusic:Play()
                    end)
                else
                    if State.adminMusic then State.adminMusic:Stop() State.adminMusic:Destroy() State.adminMusic = nil end
                end
            end
            if cmds.Rainbow ~= nil and cmds.Rainbow ~= lastRainbow then
                lastRainbow = cmds.Rainbow
                Config.Visuals.RainbowAmbient = cmds.Rainbow
            end
        end
    end
end)

print("[luausense | MM2 v17.0] Loaded - Xezios UI - CONTINUE BUG FIXED")
