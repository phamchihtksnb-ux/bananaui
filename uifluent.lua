task.wait("5")
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Maru hub",
    Text = "Success!",
    Icon = "rbxassetid://9681970193",
    Duration = 5
})

loadstring(game:HttpGet("https://raw.githubusercontent.com/nguyenhuuthanhnhan2k11-ai/Redskidhub/refs/heads/main/Auto%20join%20team"))()
task.wait("1.5")
task.spawn(function()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("LoadingScreen") then
    playerGui:FindFirstChild("LoadingScreen"):Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LoadingScreen"
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local background = Instance.new("Frame")
background.Name = "Background"
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.new(0, 0, 0)
background.BackgroundTransparency = 0.5
background.BorderSizePixel = 0
background.ZIndex = 1
background.Parent = screenGui

local circle = Instance.new("Frame")
circle.Name = "Circle"
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.Position = UDim2.new(0.5, 0, 0.45, 0)
circle.Size = UDim2.new(0, 90, 0, 90)
circle.BackgroundTransparency = 1
circle.ZIndex = 2
circle.Parent = background

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = circle

local circleStroke = Instance.new("UIStroke")
circleStroke.Color = Color3.new(1, 1, 1)
circleStroke.Thickness = 10
circleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
circleStroke.Parent = circle

local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.AnchorPoint = Vector2.new(0.5, 0.5)
loadingText.Position = UDim2.new(0.5, 0, 0.45, 90)
loadingText.Size = UDim2.new(0, 300, 0, 40)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 28
loadingText.ZIndex = 2
loadingText.Parent = background

local blinkTween = TweenService:Create(
    loadingText,
    TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, 0),
    {TextTransparency = 0.4}
)
blinkTween:Play()

local originalSize = circle.Size
local pulseSize = UDim2.new(0, originalSize.X.Offset * 1.15, 0, originalSize.Y.Offset * 1.15)
local pulseLoopActive = true

local function playPulse()
    if not pulseLoopActive then return end

    local growTween = TweenService:Create(
        circle,
        TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        {Size = pulseSize}
    )

    growTween:Play()

    growTween.Completed:Connect(function()
        if not pulseLoopActive then return end

        TweenService:Create(
            circle,
            TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
            {Size = originalSize}
        ):Play()
    end)
end

local elapsed = 0

while elapsed < 12 do
    task.wait(1)
    elapsed += 1

    if elapsed == 5 or elapsed == 10 then
        playPulse()
    end
end

blinkTween:Cancel()
pulseLoopActive = false

local fadeOutBg = TweenService:Create(
    background,
    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {BackgroundTransparency = 1}
)

local fadeOutCircle = TweenService:Create(
    circleStroke,
    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Transparency = 1}
)

local fadeOutText = TweenService:Create(
    loadingText,
    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {TextTransparency = 1}
)

fadeOutBg:Play()
fadeOutCircle:Play()
fadeOutText:Play()

fadeOutBg.Completed:Wait()

screenGui:Destroy()

end)
task.spawn(function()

    local HttpService = game:GetService("HttpService")

    local Players = game:GetService("Players")

    local LP = Players.LocalPlayer



    repeat task.wait() until game:IsLoaded()

    repeat task.wait() until LP and LP.Character



    local success, err = pcall(function()

        local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer

local v1 = next
local v2 = {
    ReplicatedStorage:FindFirstChild("Util"),
    ReplicatedStorage:FindFirstChild("Common"),
    ReplicatedStorage:FindFirstChild("Remotes"),
    ReplicatedStorage:FindFirstChild("Assets"),
    ReplicatedStorage:FindFirstChild("FX"),
}
local v3 = nil
local u4 = nil
local u5 = nil

while true do
    local v6
    v3, v6 = v1(v2, v3)
    if v3 == nil then break end
    local v7 = next
    local v8 = v6:GetChildren()
    local v9 = nil
    while true do
        local v10
        v9, v10 = v7(v8, v9)
        if v9 == nil then break end
        if v10:IsA("RemoteEvent") and v10:GetAttribute("Id") then
            u5 = v10:GetAttribute("Id")
            u4 = v10
        end
    end
    v6.ChildAdded:Connect(function(p11)
        if p11:IsA("RemoteEvent") and p11:GetAttribute("Id") then
            u5 = p11:GetAttribute("Id")
            u4 = p11
        end
    end)
end

local Modules        = ReplicatedStorage:WaitForChild("Modules")
local Net            = Modules:WaitForChild("Net")
local RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
local RegisterHit    = Net:WaitForChild("RE/RegisterHit")
local ShootGunEvent  = Net:WaitForChild("RE/ShootGunEvent")
local GunValidator   = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Validator2")

local BuddhaRange = {
    Normal = 200,
    V1     = 999,
    V2     = 1500,
}

local BuddhaState = {
    Version  = 0,
    LastTick = 0,
}

local function DetectBuddha()
    if tick() - BuddhaState.LastTick < 0.25 then return end
    BuddhaState.LastTick = tick()
    local char = Player.Character
    if not char then BuddhaState.Version = 0 return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then BuddhaState.Version = 0 return end
    local dv = (hum:FindFirstChild("BodyDepthScale") and hum.BodyDepthScale.Value) or 1
    local wv = (hum:FindFirstChild("BodyWidthScale")  and hum.BodyWidthScale.Value)  or 1
    local sx = hrp.Size.X
    if     dv >= 3.8 or wv >= 3.8 or sx >= 9   then BuddhaState.Version = 2
    elseif dv >= 1.9 or wv >= 1.9 or sx >= 4.5 then BuddhaState.Version = 1
    else                                              BuddhaState.Version = 0
    end
end

local function GetCurrentRange()
    if     BuddhaState.Version == 2 then return BuddhaRange.V2
    elseif BuddhaState.Version == 1 then return BuddhaRange.V1
    else                                  return BuddhaRange.Normal
    end
end

local function GetCDMult()
    if     BuddhaState.Version == 2 then return 0.70
    elseif BuddhaState.Version == 1 then return 0.82
    else                                  return 1.0
    end
end

local Config = {
    AttackMobs       = true,
    AttackPlayers    = true,
    AttackCooldown   = 0.12,
    ComboResetTime   = 0.3,
    MaxCombo         = 4,
    HitboxLimbs      = {
        "RightLowerArm", "RightUpperArm",
        "LeftLowerArm",  "LeftUpperArm",
        "RightHand",     "LeftHand",
        "UpperTorso",    "LowerTorso",
        "Head",          "HumanoidRootPart",
    },
    AutoClickEnabled = true,
}

local FastAttack = {}
FastAttack.__index = FastAttack

function FastAttack.new()
    local self = setmetatable({
        Debounce        = 0,
        ComboDebounce   = 0,
        ShootDebounce   = 0,
        M1Combo         = 0,
        EnemyRootPart   = nil,
        Connections     = {},
        Overheat = {
            Dragonstorm = {
                MaxOverheat   = 3,
                Cooldown      = 0,
                TotalOverheat = 0,
                Distance      = 350,
                Shooting      = false,
            }
        },
        ShootsPerTarget = {["Dual Flintlock"] = 2},
        SpecialShoots   = {
            ["Skull Guitar"] = "TAP",
            ["Bazooka"]      = "Position",
            ["Cannon"]       = "Position",
            ["Dragonstorm"]  = "Overheat",
        },
    }, FastAttack)
    pcall(function()
        self.CombatFlags   = require(Modules.Flags).COMBAT_REMOTE_THREAD
        self.ShootFunction = getupvalue(require(ReplicatedStorage.Controllers.CombatController).Attack, 9)
        local LocalScript  = Player:WaitForChild("PlayerScripts"):FindFirstChildOfClass("LocalScript")
        if LocalScript and getsenv then
            self.HitFunction = getsenv(LocalScript)._G.SendHitsToServer
        end
    end)
    return self
end

function FastAttack:IsEntityAlive(entity)
    local h = entity and entity:FindFirstChild("Humanoid")
    return h and h.Health > 0
end

function FastAttack:CheckStun(Character, Humanoid, ToolTip)
    local Stun = Character:FindFirstChild("Stun")
    local Busy = Character:FindFirstChild("Busy")
    if Humanoid.Sit and (ToolTip == "Sword" or ToolTip == "Melee" or ToolTip == "Blox Fruit") then
        return false
    elseif (Stun and Stun.Value > 0) or (Busy and Busy.Value) then
        return false
    end
    return true
end

function FastAttack:GetBladeHits(Character, Distance)
    local Position  = Character:GetPivot().Position
    Distance        = Distance or GetCurrentRange()
    local BladeHits = {}
    self.EnemyRootPart = nil

    local function PickLimb(enemy)
        if BuddhaState.Version >= 1 then
            local t = enemy:FindFirstChild("UpperTorso") or enemy:FindFirstChild("Torso")
            if t then return t end
        end
        local rng = Config.HitboxLimbs[math.random(#Config.HitboxLimbs)]
        return enemy:FindFirstChild(rng) or enemy:FindFirstChild("HumanoidRootPart")
    end

    local function ProcessTargets(Folder)
        if not Folder then return end
        for _, Enemy in ipairs(Folder:GetChildren()) do
            if Enemy ~= Character and self:IsEntityAlive(Enemy) then
                local BasePart = PickLimb(Enemy)
                if BasePart and (Position - BasePart.Position).Magnitude <= Distance then
                    if not self.EnemyRootPart then
                        self.EnemyRootPart = BasePart
                    end
                    table.insert(BladeHits, {Enemy, BasePart})
                end
            end
        end
    end

    if Config.AttackMobs    then ProcessTargets(Workspace:FindFirstChild("Enemies"))    end
    if Config.AttackPlayers then ProcessTargets(Workspace:FindFirstChild("Characters")) end

    return BladeHits
end

function FastAttack:GetClosestEnemy(Character, Distance)
    local BladeHits = self:GetBladeHits(Character, Distance)
    local Closest, MinDist = nil, math.huge
    local Origin = Character:GetPivot().Position
    for _, Hit in ipairs(BladeHits) do
        local Mag = (Origin - Hit[2].Position).Magnitude
        if Mag < MinDist then
            MinDist = Mag
            Closest = Hit[2]
        end
    end
    return Closest
end

function FastAttack:GetCombo()
    local Combo = (tick() - self.ComboDebounce) <= Config.ComboResetTime and self.M1Combo or 0
    Combo = Combo >= Config.MaxCombo and 1 or Combo + 1
    self.ComboDebounce = tick()
    self.M1Combo = Combo
    return Combo
end

function FastAttack:GetValidator2()
    local _v1 = getupvalue(self.ShootFunction, 15)
    local _v2 = getupvalue(self.ShootFunction, 13)
    local _v3 = getupvalue(self.ShootFunction, 16)
    local _v4 = getupvalue(self.ShootFunction, 17)
    local _v5 = getupvalue(self.ShootFunction, 14)
    local _v6 = getupvalue(self.ShootFunction, 12)
    local _v7 = getupvalue(self.ShootFunction, 18)
    local _v8 = _v6 * _v2
    local _v9 = (_v5 * _v2 + _v6 * _v1) % _v3
    _v9       = (_v9 * _v3 + _v8) % _v4
    _v5       = math.floor(_v9 / _v3)
    _v6       = _v9 - _v5 * _v3
    _v7       = _v7 + 1
    setupvalue(self.ShootFunction, 15, _v1)
    setupvalue(self.ShootFunction, 13, _v2)
    setupvalue(self.ShootFunction, 16, _v3)
    setupvalue(self.ShootFunction, 17, _v4)
    setupvalue(self.ShootFunction, 14, _v5)
    setupvalue(self.ShootFunction, 12, _v6)
    setupvalue(self.ShootFunction, 18, _v7)
    return math.floor(_v9 / _v4 * 16777215), _v7
end

function FastAttack:FireEncodedRemote(head, hits)
    if not u4 or not u5 then return end
    pcall(function()
        local encodedName = string.gsub("RE/RegisterHit", ".", function(ch)
            return string.char(bit32.bxor(
                string.byte(ch),
                math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1
            ))
        end)
        local seed      = Net.seed:InvokeServer()
        local encodedId = bit32.bxor(u5 + 909090, seed * 2)
        cloneref(u4):FireServer(encodedName, encodedId, head, hits)
    end)
end

function FastAttack:ShootInTarget(TargetPosition)
    local Character = Player.Character
    if not self:IsEntityAlive(Character) then return end
    local Equipped = Character:FindFirstChildOfClass("Tool")
    if not Equipped or Equipped.ToolTip ~= "Gun" then return end
    local Cooldown = Equipped:FindFirstChild("Cooldown") and Equipped.Cooldown.Value or 0.3
    if (tick() - self.ShootDebounce) < Cooldown then return end
    local ShootType = self.SpecialShoots[Equipped.Name] or "Normal"
    if ShootType == "Position" or (ShootType == "TAP" and Equipped:FindFirstChild("RemoteEvent")) then
        Equipped:SetAttribute("LocalTotalShots", (Equipped:GetAttribute("LocalTotalShots") or 0) + 1)
        pcall(function() GunValidator:FireServer(self:GetValidator2()) end)
        if ShootType == "TAP" then
            Equipped.RemoteEvent:FireServer("TAP", TargetPosition)
        else
            ShootGunEvent:FireServer(TargetPosition)
        end
    else
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end
    self.ShootDebounce = tick()
end

function FastAttack:UseNormalClick(Character, Humanoid, Cooldown)
    self.EnemyRootPart = nil
    local BladeHits    = self:GetBladeHits(Character)
    if not self.EnemyRootPart then return end

    local noisedCD = Cooldown + (math.random() * 0.018)
    RegisterAttack:FireServer(noisedCD)

    if self.CombatFlags and self.HitFunction then
        self.HitFunction(self.EnemyRootPart, BladeHits)
    else
        RegisterHit:FireServer(
            self.EnemyRootPart,
            BladeHits,
            {},
            tostring(Player.UserId):sub(2,4) .. tostring(coroutine.running()):sub(11,15)
        )
    end

    self:FireEncodedRemote(self.EnemyRootPart, BladeHits)
end

function FastAttack:UseFruitM1(Character, Equipped, Combo)
    local Targets = self:GetBladeHits(Character)
    if not Targets[1] then return end
    local Direction = (Targets[1][2].Position - Character:GetPivot().Position).Unit
    pcall(function() Equipped.LeftClickRemote:FireServer(Direction, Combo) end)
end

function FastAttack:Attack()
    DetectBuddha()
    if not Config.AutoClickEnabled then return end
    local now = tick()
    if (now - self.Debounce) < (Config.AttackCooldown * GetCDMult()) then return end
    local Character = Player.Character
    if not Character or not self:IsEntityAlive(Character) then return end
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid then return end
    local Equipped = Character:FindFirstChildOfClass("Tool")
    if not Equipped then return end
    local ToolTip = Equipped.ToolTip
    if not table.find({"Melee", "Blox Fruit", "Sword", "Gun"}, ToolTip) then return end
    local Cooldown = Equipped:FindFirstChild("Cooldown") and Equipped.Cooldown.Value or Config.AttackCooldown
    if not self:CheckStun(Character, Humanoid, ToolTip) then return end
    local Combo = self:GetCombo()
    Cooldown = Cooldown + (Combo >= Config.MaxCombo and 0.05 or 0)
    self.Debounce = (Combo >= Config.MaxCombo and ToolTip ~= "Gun") and (now + 0.05) or now
    if ToolTip == "Blox Fruit" and Equipped:FindFirstChild("LeftClickRemote") then
        self:UseFruitM1(Character, Equipped, Combo)
    elseif ToolTip == "Gun" then
        local Target = self:GetClosestEnemy(Character, GetCurrentRange())
        if Target then self:ShootInTarget(Target.Position) end
    else
        self:UseNormalClick(Character, Humanoid, Cooldown)
    end
end

task.spawn(function()
    while task.wait(0.0001) do
        DetectBuddha()
        local _Character = Player.Character
        local v13 = _Character and _Character:FindFirstChild("HumanoidRootPart")
        if not v13 then continue end
        local scanRange = GetCurrentRange()
        local u17 = {}
        for _, container in ipairs({
            Workspace:FindFirstChild("Enemies"),
            Workspace:FindFirstChild("Characters")
        }) do
            if not container then continue end
            for _, v22 in ipairs(container:GetChildren()) do
                if v22 == _Character then continue end
                local _HRP = v22:FindFirstChild("HumanoidRootPart")
                local _HUM = v22:FindFirstChild("Humanoid")
                if not _HRP or not _HUM then continue end
                if _HUM.Health <= 0 then continue end
                if (_HRP.Position - v13.Position).Magnitude > scanRange then continue end
                for _, part in ipairs(v22:GetChildren()) do
                    if part:IsA("BasePart") then
                        u17[#u17 + 1] = {v22, part}
                    end
                end
            end
        end
        local _Tool = _Character:FindFirstChildOfClass("Tool")
        if #u17 > 0 and _Tool then
            local weaponType = _Tool:GetAttribute("WeaponType")
            if weaponType == "Melee" or weaponType == "Sword" then
                pcall(function()
                    Net["RE/RegisterAttack"]:FireServer()
                    local _Head = u17[1][1]:FindFirstChild("Head")
                    if not _Head then return end
                    Net["RE/RegisterHit"]:FireServer(
                        _Head, u17, {},
                        tostring(Player.UserId):sub(2,4) .. tostring(coroutine.running()):sub(11,15)
                    )
                    if u4 and u5 then
                        local encodedName = string.gsub("RE/RegisterHit", ".", function(p31)
                            return string.char(bit32.bxor(
                                string.byte(p31),
                                math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1
                            ))
                        end)
                        local seed      = Net.seed:InvokeServer()
                        local encodedId = bit32.bxor(u5 + 909090, seed * 2)
                        cloneref(u4):FireServer(encodedName, encodedId, _Head, u17)
                    end
                end)
            end
        end
    end
end)

local Register_Hit    = Net:WaitForChild("RE/RegisterHit")
local Register_Attack = Net:WaitForChild("RE/RegisterAttack")
local Funcs           = {}

local function GetAllBladeHits()
    local bladehits = {}
    local char = Player.Character
    if not char then return bladehits end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return bladehits end
    local range = GetCurrentRange()
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return bladehits end
    for _, v in pairs(enemies:GetChildren()) do
        if not v:FindFirstChild("Humanoid") then continue end
        if not v:FindFirstChild("HumanoidRootPart") then continue end
        if not v:FindFirstChild("Head") then continue end
        if v.Humanoid.Health <= 0 then continue end
        table.insert(bladehits, v)
    end
    return bladehits
end

local function GetPlayerHit()
    local bladehits = {}
    local char = Player.Character
    if not char then return bladehits end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return bladehits end
    local range = GetCurrentRange()
    local chars = workspace:FindFirstChild("Characters")
    if not chars then return bladehits end
    for _, v in pairs(chars:GetChildren()) do
        if v.Name == Player.Name then continue end
        if not v:FindFirstChild("Humanoid") then continue end
        if not v:FindFirstChild("HumanoidRootPart") then continue end
        if v.Humanoid.Health <= 0 then continue end
        if (v.HumanoidRootPart.Position - hrp.Position).Magnitude > range then continue end
        table.insert(bladehits, v)
    end
    return bladehits
end

function Funcs:Attack()
    local bladehits = {}
    for _, v in pairs(GetAllBladeHits()) do table.insert(bladehits, v) end
    for _, v in pairs(GetPlayerHit())    do table.insert(bladehits, v) end
    if #bladehits == 0 then return end

    local args = {[1] = nil, [2] = {}, [4] = "078da341"}
    for r, v in pairs(bladehits) do
        Register_Attack:FireServer(0)
        if not args[1] then args[1] = v.Head end
        args[2][r] = {[1] = v, [2] = v.HumanoidRootPart}
    end
    Register_Hit:FireServer(unpack(args))

    if u4 and u5 then
        pcall(function()
            local encodedName = string.gsub("RE/RegisterHit", ".", function(ch)
                return string.char(bit32.bxor(
                    string.byte(ch),
                    math.floor(workspace:GetServerTimeNow() / 10 % 10) + 1
                ))
            end)
            local seed      = Net.seed:InvokeServer()
            local encodedId = bit32.bxor(u5 + 909090, seed * 2)
            local hitTable  = {}
            for r, v in pairs(bladehits) do
                for _, part in ipairs(v:GetChildren()) do
                    if part:IsA("BasePart") then
                        hitTable[#hitTable + 1] = {v, part}
                    end
                end
            end
            cloneref(u4):FireServer(encodedName, encodedId, bladehits[1].Head, hitTable)
        end)
    end
end

local AttackInstance = FastAttack.new()

table.insert(AttackInstance.Connections, RunService.Stepped:Connect(function()
    AttackInstance:Attack()
end))

pcall(function()
    for _, v in pairs(getgc(true)) do
        if typeof(v) == "function" and iscclosure(v) then
            local info = debug.getinfo(v)
            local name = info and info.name
            if name == "Attack" or name == "attack" or name == "RegisterHit" then
                hookfunction(v, function(...)
                    AttackInstance:Attack()
                    return v(...)
                end)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.25) do
        DetectBuddha()
    end
end)
        
    end)



    if not success then

        warn("Falha ao executar auto-load:", err)

    end

end)

do

  ply = game.Players

  plr = ply.LocalPlayer

  Root = plr.Character.HumanoidRootPart

  replicated = game:GetService("ReplicatedStorage")

  Lv = game.Players.LocalPlayer.Data.Level.Value

  TeleportService = game:GetService("TeleportService")

  TW = game:GetService("TweenService")

  Lighting = game:GetService("Lighting")  

  Enemies = workspace.Enemies

  vim1 = game:GetService("VirtualInputManager")

  vim2 = game:GetService("VirtualUser")

  TeamSelf = plr.Team

  RunSer = game:GetService("RunService")

  Stats = game:GetService("Stats")  

  Energy = plr.Character.Energy.Value

  Boss = {}

  BringConnections = {}

  MaterialList = {}

  NPCList = {}  

  shouldTween = false

  SoulGuitar = false

  KenTest = true

  debug = false

  Brazier1 = false

  Brazier2 = false

  Brazier3 = false  

  Sec = 0.1

  ClickState = 0

  Num_self = 25

end
QuestYama_1 = false; QuestYama_2 = false; QuestYama_3 = false
QuestTushita_1 = false; QuestTushita_2 = false; QuestTushita_3 = false
_G.T1Yama = false; _G.T2Yama = false; _G.T3Yama = false
_G.DoneT1 = false; _G.DoneT2 = false; _G.DoneT3 = false
_G.CDK = false; _G.CDK_YM = false; _G.CDK_TS = false
_G.Auto_Tushita = false; _G.Auto_Yama = false
_G.Auto_Soul_Guitar = false; _G.AutoMatSoul = false
Quest1 = false; Quest2 = false; Quest3 = false; Quest4 = false
repeat local start = plr.PlayerGui:WaitForChild("Main"):WaitForChild("Loading") and game:IsLoaded() wait() until start

World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715

World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657

World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

Sea = World1 or World2 or World3 or plr:Kick("❌ Error : A[12]Blox Fruits ❌ Incorrect place ID, please wait for an update. ")

Marines = function() replicated.Remotes.CommF_:InvokeServer("SetTeam","Marines") end

Pirates = function() replicated.Remotes.CommF_:InvokeServer("SetTeam","Pirates") end

if World1 then Boss = {"The Gorilla King","Bobby","The Saw","Yeti","Mob Leader","Vice Admiral","Saber Expert","Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg","Ice Admiral","Greybeard"}

elseif World2 then Boss = {"Diamond","Jeremy","Fajita","Don Swan","Smoke Admiral","Awakened Ice Admiral","Tide Keeper","Darkbeard","Cursed Captain","Order"}

elseif World3 then Boss = {"Stone","Hydra Leader","Kilo Admiral","Captain Elephant","Beautiful Pirate","Cake Queen","Longma","Soul Reaper"}

end

if World1 then MaterialList = {"Leather + Scrap Metal", "Angel Wings", "Magma Ore", "Fish Tail"}

elseif World2 then MaterialList = {"Leather + Scrap Metal", "Radioactive Material", "Ectoplasm", "Mystic Droplet", "Magma Ore", "Vampire Fang"}

elseif World3 then MaterialList = {"Scrap Metal", "Demonic Wisp", "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Fish Tail", "Mini Tusk"}

end

local DungeonTables = {"Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Human: Buddha","Sand","Bird: Phoenix","Dough"}

local RenMon = {"Snow Lurker","Arctic Warrior","Hidden Key","Awakened Ice Admiral"}

local CursedTables = {["Mob"] = "Mythological Pirate",["Mob2"] = "Cursed Skeleton","Hell's Messenger",["Mob3"] = "Cursed Skeleton","Heaven's Guardian"}

local Past = {"Part","SpawnLocation","Terrain","WedgePart","MeshPart"}

local BartMon = {"Swan Pirate","Jeremy"}

local CitizenTable = {"Forest Pirate","Captain Elephant"}

local Human_v3_Mob = {"Fajita","Jeremy","Diamond"}

local AllBoats = {"Beast Hunter","Lantern","Guardian","Grand Brigade","Dinghy","Sloop","The Sentinel"}

local mastery1 = {"Cookie Crafter"}

local mastery2 = {"Reborn Skeleton"}

local PosMsList = {["Pirate Millionaire"] = CFrame.new(-712.8272705078125, 98.5770492553711, 5711.9541015625),["Pistol Billionaire"] = CFrame.new(-723.4331665039062, 147.42906188964844, 5931.9931640625),["Dragon Crew Warrior"] = CFrame.new(7021.50439453125, 55.76270294189453, -730.1290893554688),["Dragon Crew Archer"] = CFrame.new(6625, 378, 244),["Female Islander"] = CFrame.new(4692.7939453125, 797.9766845703125, 858.8480224609375),["Venomous Assailant"] = CFrame.new(4902, 670, 39), ["Marine Commodore"] = CFrame.new(2401, 123, -7589),["Marine Rear Admiral"] = CFrame.new(3588, 229, -7085),["Fishman Raider"] = CFrame.new(-10941, 332, -8760),["Fishman Captain"] = CFrame.new(-11035, 332, -9087),["Forest Pirate"] = CFrame.new(-13446, 413, -7760),["Mythological Pirate"] = CFrame.new(-13510, 584, -6987),["Jungle Pirate"] = CFrame.new(-11778, 426, -10592),["Musketeer Pirate"] = CFrame.new(-13282, 496, -9565),["Reborn Skeleton"] = CFrame.new(-8764, 142, 5963),["Living Zombie"] = CFrame.new(-10227, 421, 6161),["Demonic Soul"] = CFrame.new(-9579, 6, 6194),["Posessed Mummy"] = CFrame.new(-9579, 6, 6194),["Peanut Scout"] = CFrame.new(-1993, 187, -10103),["Peanut President"] = CFrame.new(-2215, 159, -10474),["Ice Cream Chef"] = CFrame.new(-877, 118, -11032),["Ice Cream Commander"] = CFrame.new(-877, 118, -11032),["Cookie Crafter"] = CFrame.new(-2021, 38, -12028),["Cake Guard"] = CFrame.new(-2024, 38, -12026),["Baking Staff"] = CFrame.new(-1932, 38, -12848),["Head Baker"] = CFrame.new(-1932, 38, -12848),["Cocoa Warrior"] = CFrame.new(95, 73, -12309),["Chocolate Bar Battler"] = CFrame.new(647, 42, -12401),["Sweet Thief"] = CFrame.new(116, 36, -12478),["Candy Rebel"] = CFrame.new(47, 61, -12889),["Ghost"] = CFrame.new(5251, 5, 1111)}

EquipWeapon = function(text)

  if not text then return end

  if plr.Backpack:FindFirstChild(text) then

	plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild(text))

  end

end

weaponSc = function(weapon)

  for __in, v in pairs(plr.Backpack:GetChildren()) do

    if v:IsA("Tool") then

      if v.ToolTip == weapon then EquipWeapon(v.Name) end

    end

  end

end

hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Death),function() end)

hookfunction(require(game:GetService("ReplicatedStorage"):WaitForChild("GuideModule")).ChangeDisplayedNPC,function()end)

hookfunction(error, function()end)

hookfunction(warn, function()end)

local Rock = workspace:FindFirstChild("Rocks")

if Rock then Rock:Destroy()end

gay = (function()

  local lighting = game:GetService("Lighting")

  local lightingLayers = lighting:FindFirstChild("LightingLayers")

  if lightingLayers and game:GetService("Lighting") and game:GetService("Lighting") then

    local darkFog = lightingLayers:FindFirstChild("DarkFog")

    if darkFog then darkFog:Destroy() end

  end

  local Water = workspace._WorldOrigin["Foam;"]

  if Water and workspace._WorldOrigin["Foam;"] then Water:Destroy() end        

end)()

local Attack = {}

Attack.__index = Attack

Attack.Alive = function(model) if not model then return end local Humanoid = model:FindFirstChild("Humanoid") return Humanoid and Humanoid.Health > 0 end

Attack.Pos = function(model,dist) return (Root.Position - mode.Position).Magnitude <= dist end

Attack.Dist = function(model,dist) return (Root.Position - model:FindFirstChild("HumanoidRootPart").Position).Magnitude <= dist end

Attack.DistH = function(model,dist) return (Root.Position - model:FindFirstChild("HumanoidRootPart").Position).Magnitude > dist end

Attack.Kill = function(model,Succes)

  if model and Succes then

  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end

  PosMon = model:GetAttribute("Locked").Position

  BringEnemy()

  EquipWeapon(_G.SelectWeapon)

  local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")

  local ToolTip = Equipped.ToolTip

  -- Đã chỉnh sửa: Fruit giữ nguyên 5 studs, còn lại đổi thành độ cao bạn muốn (ví dụ: 15 studs)
  local height = (ToolTip == "Blox Fruit") and 5 or 15

  if ToolTip == "Blox Fruit" then
    _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, height, 0) * CFrame.Angles(0, math.rad(90), 0))
else
    _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, height, 0) * CFrame.Angles(0, math.rad(180), 0))
end

for i = 1, 3 do
local function requestEntrance(aJ)
    local args = {"requestEntrance", aJ}
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local char = player.Character.HumanoidRootPart
        local oldcframe = char.CFrame
        char.CFrame = CFrame.new(oldcframe.X, oldcframe.Y + 50, oldcframe.Z)
        task.wait(0.5)
    end
end

function topos(Tween_Pos)
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character 
            and player.Character:FindFirstChild("Humanoid") 
            and player.Character:FindFirstChild("HumanoidRootPart") 
            and player.Character.Humanoid.Health > 0 then
            
            if not TweenSpeed then
                TweenSpeed = 350
            end
            
            local hrp = player.Character.HumanoidRootPart
            local DefualtY = Tween_Pos.Y
            local TargetY = Tween_Pos.Y
            local targetCFrameWithDefualtY = CFrame.new(Tween_Pos.X, DefualtY, Tween_Pos.Z)
            local targetPos = Tween_Pos.Position
            local oldcframe = hrp.CFrame
            
            local Distance = (targetPos - hrp.Position).Magnitude
            
            if Distance <= 300 then
                hrp.CFrame = Tween_Pos
            end
            
            local aM = CheckNearestTeleporter(Tween_Pos)
            if aM then
                pcall(function()
                    if tween then tween:Cancel() end
                end)
                requestEntrance(aM)
            end
            
            local b1 = CFrame.new(hrp.CFrame.X, DefualtY, hrp.CFrame.Z)
            local IngoreY = true
            
            local tweenfunc = {}
            local aN = game:GetService("TweenService")
            local aO = TweenInfo.new(
                (targetPos - hrp.Position).Magnitude / TweenSpeed,
                Enum.EasingStyle.Linear
            )
            
            if IngoreY and (b1.Position - targetCFrameWithDefualtY.Position).Magnitude > 5 then
                hrp.CFrame = CFrame.new(hrp.CFrame.X, DefualtY, hrp.CFrame.Z)
                
                tween = aN:Create(hrp, aO, {CFrame = targetCFrameWithDefualtY})
                tween:Play()
                
                function tweenfunc:Stop()
                    tween:Cancel()
                end
                
                tween.Completed:Wait()
                hrp.CFrame = CFrame.new(hrp.CFrame.X, TargetY, hrp.CFrame.Z)
            else
                tween = aN:Create(hrp, aO, {CFrame = Tween_Pos})
                tween:Play()
                
                function tweenfunc:Stop()
                    tween:Cancel()
                end
                
                tween.Completed:Wait()
                hrp.CFrame = CFrame.new(hrp.CFrame.X, TargetY, hrp.CFrame.Z)
            end
            
            if not tween then
                return tween
            end
            return tweenfunc
        end
    end)
end
    _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, height, 0))
    task.wait(0.1)
end

if RandomCFrame then
    task.wait(.5) _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, height, 25))
    task.wait(.5) _tp(model.HumanoidRootPart.CFrame * CFrame.new(25, height, 0))
    task.wait(.5) _tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, height, 0))
    task.wait(.5) _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, height, 25))
    task.wait(.5) _tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, height, 0))
end

end
end

Attack.Kill2 = function(model,Succes)

  if model and Succes then

  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end

  PosMon = model:GetAttribute("Locked").Position

  BringEnemy()

  EquipWeapon(_G.SelectWeapon)

  local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")

  local ToolTip = Equipped.ToolTip

  -- Đã chỉnh sửa: Fruit giữ nguyên 10 studs, còn lại đổi độ cao (ví dụ: 25 studs)
  local height2 = (ToolTip == "Blox Fruit") and 10 or 25

  if ToolTip == "Blox Fruit" then 
      _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, height2, 0) * CFrame.Angles(0,math.rad(90),0)) 
  else 
      _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, height2, 8) * CFrame.Angles(0,math.rad(180),0))
  end

  if RandomCFrame then 
      wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, height2, 25)) 
      wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(25, height2, 0)) 
      wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, height2, 0)) 
      wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, height2, 25)) 
      wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, height2, 0)) 
  end

  end

end

Attack.KillSea = function(model,Succes)

  if model and Succes then

  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end

  PosMon = model:GetAttribute("Locked").Position

  BringEnemy()

  EquipWeapon(_G.SelectWeapon)

  local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")

  local ToolTip = Equipped.ToolTip

  if ToolTip == "Blox Fruit" then _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,10,0) * CFrame.Angles(0,math.rad(90),0)) else notween(model.HumanoidRootPart.CFrame * CFrame.new(0,50,8)) wait(.85)notween(model.HumanoidRootPart.CFrame * CFrame.new(0,400,0)) wait(1)end

  end

end

Attack.Sword = function(model,Succes)

  if model and Succes then

  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end

  PosMon = model:GetAttribute("Locked").Position

  BringEnemy()

  weaponSc("Sword")

  _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0))

  if RandomCFrame then wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30 ,0)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))end

  end

end

Attack.Mas = function(model,Succes)

  if model and Succes then

  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end

  PosMon = model:GetAttribute("Locked").Position

  BringEnemy()

    if model.Humanoid.Health <= HealthM then

      _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,20,0))

      Useskills("Blox Fruit","Z")

      Useskills("Blox Fruit","X")

      Useskills("Blox Fruit","C")

    else

      weaponSc("Melee")

      _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0))

    end

  end

end

Attack.Masgun = function(model,Succes)

  if model and Succes then

  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end

  PosMon = model:GetAttribute("Locked").Position

  BringEnemy()

    if model.Humanoid.Health <= HealthM then

      _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,35,8))

      Useskills("Gun","Z")

      Useskills("Gun","X")

    else

      weaponSc("Melee")

      _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0))

    end

  end

end

statsSetings = function(Num, value)

  if Num == "Melee" then

    if plr.Data.Points.Value ~= 0 then

      replicated.Remotes.CommF_:InvokeServer("AddPoint","Melee",value)

    end

  elseif Num == "Defense" then

    if plr.Data.Points.Value ~= 0 then

      replicated.Remotes.CommF_:InvokeServer("AddPoint","Defense",value)

    end

  elseif Num == "Sword" then

    if plr.Data.Points.Value ~= 0 then

      replicated.Remotes.CommF_:InvokeServer("AddPoint","Sword",value)

    end

  elseif Num == "Gun" then

    if plr.Data.Points.Value ~= 0 then

      replicated.Remotes.CommF_:InvokeServer("AddPoint","Gun",value)

    end

  elseif Num == "Devil" then

    if plr.Data.Points.Value ~= 0 then

      replicated.Remotes.CommF_:InvokeServer("AddPoint","Demon Fruit",value)

    end

  end

end

BringEnemy = function()
    pcall(function()
        if not getgenv().BringMonster then return end
        if not PosMon then return end

        local _char = plr.Character
        if not _char then return end
        local _root = _char:FindFirstChild("HumanoidRootPart")
        if not _root then return end

        local targetCF  = typeof(PosMon) == "CFrame"
            and PosMon
            or  CFrame.new(PosMon)
        local pinCF     = targetCF * CFrame.new(0, 3, 0)
        local maxPull   = 20
        local pulled    = 0
        local bringRange = 888

        local targetName = nil
        if Mon and Mon ~= "" then
            targetName = Mon
        end

        local function LockMob(v, hrp, hum)
            hrp.CFrame     = pinCF
            hrp.CanCollide = false

            local head = v:FindFirstChild("Head")
            if head then
                head.CFrame     = pinCF * CFrame.new(0, 2, 0)
                head.CanCollide = false
            end

            hum.WalkSpeed  = 0
            hum.JumpPower  = 0
            hum.AutoRotate = false

            local anim = hum:FindFirstChildOfClass("Animator")
            if anim then anim:Destroy() end

            for _, t in ipairs(v:GetChildren()) do
                if t:IsA("Script") or t:IsA("LocalScript") then
                    t.Disabled = true
                end
            end

            if hrp:FindFirstChild("_Lock") then
                hrp._Lock.Velocity = Vector3.new(0, 0, 0)
                hrp._Lock.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            else
                local bv       = Instance.new("BodyVelocity")
                bv.Name        = "_Lock"
                bv.MaxForce    = Vector3.new(1e9, 1e9, 1e9)
                bv.Velocity    = Vector3.new(0, 0, 0)
                bv.Parent      = hrp
            end

            pcall(function()
                sethiddenproperty(plr, "SimulationRadius", math.huge)
            end)

            hum:ChangeState(11)
        end

        local enemyFolder = workspace:FindFirstChild("Enemies")
        if enemyFolder then
            for _, v in ipairs(enemyFolder:GetChildren()) do
                if pulled >= maxPull then break end

                if targetName and v.Name ~= targetName then continue end

                local hrp = v:FindFirstChild("HumanoidRootPart")
                local hum = v:FindFirstChild("Humanoid")
                if not hrp or not hum or hum.Health <= 0 then continue end
                if (hrp.Position - _root.Position).Magnitude > bringRange then continue end

                LockMob(v, hrp, hum)
                pulled = pulled + 1
            end
        end
    end)
end

task.spawn(function()
    while task.wait(0.05) do
        BringEnemy()
    end
end)

Useskills = function(weapon, skill)

  if weapon == "Melee" then

    weaponSc("Melee")

    if skill == "Z" then

      vim1:SendKeyEvent(true, "Z", false, game);

      vim1:SendKeyEvent(false, "Z", false, game);

    elseif skill == "X" then

      vim1:SendKeyEvent(true, "X", false, game);

      vim1:SendKeyEvent(false, "X", false, game);

    elseif skill == "C" then

      vim1:SendKeyEvent(true, "C", false, game);

      vim1:SendKeyEvent(false, "C", false, game);

    end

  elseif weapon == "Sword" then

    weaponSc("Sword")

    if skill == "Z" then

      vim1:SendKeyEvent(true, "Z", false, game);

      vim1:SendKeyEvent(false, "Z", false, game);

    elseif skill == "X" then

      vim1:SendKeyEvent(true, "X", false, game);

      vim1:SendKeyEvent(false, "X", false, game);

    end

  elseif weapon == "Blox Fruit" then

    weaponSc("Blox Fruit")

    if skill == "Z" then

      vim1:SendKeyEvent(true, "Z", false, game);

      vim1:SendKeyEvent(false, "Z", false, game);

    elseif skill == "X" then

      vim1:SendKeyEvent(true, "X", false, game);

      vim1:SendKeyEvent(false, "X", false, game);

    elseif skill == "C" then

      vim1:SendKeyEvent(true, "C", false, game);

      vim1:SendKeyEvent(false, "C", false, game);        

    elseif skill == "V" then

      vim1:SendKeyEvent(true, "V", false, game);

      vim1:SendKeyEvent(false, "V", false, game);

    end

  elseif weapon == "Gun" then

    weaponSc("Gun")

    if skill == "Z" then

      vim1:SendKeyEvent(true, "Z", false, game);

      vim1:SendKeyEvent(false, "Z", false, game);

    elseif skill == "X" then

      vim1:SendKeyEvent(true, "X", false, game);

      vim1:SendKeyEvent(false, "X", false, game);

    end

  end

  if weapon == "nil" and skill == "Y" then

    vim1:SendKeyEvent(true, "Y", false, game);

    vim1:SendKeyEvent(false, "Y", false, game);

  end

end

local gg = getrawmetatable(game)

local old = gg.__namecall

setreadonly(gg, false)

gg.__namecall = newcclosure(function(...)

  local method = getnamecallmethod()

  local args = {...}    

    if tostring(method) == "FireServer" then

      if tostring(args[1]) == "RemoteEvent" then

        if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then

          if (_G.FarmMastery_G and not SoulGuitar) or (_G.FarmMastery_Dev) or (_G.FarmBlazeEM) or (_G.Prehis_Skills) or (_G.SeaBeast1 or _G.FishBoat or _G.PGB or _G.Leviathan1 or _G.Complete_Trials) or (_G.AimMethod and ABmethod == "AimBots Skill") or (_G.AimMethod and ABmethod == "Auto Aimbots") then

            args[2] = MousePos

            return old(unpack(args))

          end

        end

      end

    end

  return old(...)

end)

GetConnectionEnemies = function(a)

  for i,v in pairs(replicated:GetChildren()) do

    if v:IsA("Model") and  ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then

      return v

    end

  end

  for i,v in next,game.Workspace.Enemies:GetChildren() do

    if v:IsA("Model") and ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a)  and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then

      return v

    end

  end

end

LowCpu = function()

  local decalsyeeted = true

  local g = game

  local w = g.Workspace

  local l = g.Lighting

  local t = w.Terrain

  t.WaterWaveSize = 0

  t.WaterWaveSpeed = 0

  t.WaterReflectance = 0

  t.WaterTransparency = 0

  l.GlobalShadows = false

  l.FogEnd = 9e9

  l.Brightness = 0

  settings().Rendering.QualityLevel = "Level01"

  for i, v in pairs(g:GetDescendants()) do

    if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then

      v.Material = "Plastic"

      v.Reflectance = 0

    elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then

      v.Transparency = 1

    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then

      v.Lifetime = NumberRange.new(0)

    elseif v:IsA("Explosion") then

      v.BlastPressure = 1

      v.BlastRadius = 1

    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then

      v.Enabled = false

    elseif v:IsA("MeshPart") then

      v.Material = "Plastic"

      v.Reflectance = 0

      v.TextureID = 10385902758728957

    end

  end

  for i, e in pairs(l:GetChildren()) do

    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then

      e.Enabled = false

    end

  end

end

CheckF = function()

  if GetBP("Dragon-Dragon") or GetBP("Gas-Gas") or GetBP("Yeti-Yeti") or GetBP("Kitsune-Kitsune") or GetBP("T-Rex-T-Rex") then return true end

end

CheckBoat = function()

  for i, v in pairs(workspace.Boats:GetChildren()) do

    if tostring(v.Owner.Value) == tostring(plr.Name) then

      return v    

end;

  end;

  return false

end;

CheckEnemiesBoat = function()

  for _,v in pairs(workspace.Enemies:GetChildren()) do

    if (v.Name == "FishBoat") and v:FindFirstChild("Health").Value > 0 then

      return true    

end;

  end;

  return false

end;

CheckPirateGrandBrigade = function()

  for _,v in pairs(workspace.Enemies:GetChildren()) do

    if (v.Name == "PirateGrandBrigade" or v.Name == "PirateBrigade") and v:FindFirstChild("Health").Value > 0 then

      return true

    end

  end

  return false

end

CheckShark = function()

  for _,v in pairs(workspace.Enemies:GetChildren()) do

    if v.Name == "Shark" and Attack.Alive(v) then

      return true    

end;

  end;

  return false

end;

CheckTerrorShark = function()

  for _,v in pairs(workspace.Enemies:GetChildren()) do

    if v.Name == "Terrorshark" and Attack.Alive(v) then

      return true    

end;

  end;

  return false

end;

CheckPiranha = function()

  for _,v in pairs(workspace.Enemies:GetChildren()) do

    if v.Name == "Piranha" and Attack.Alive(v) then

      return true    

end;

  end;

  return false

end;

CheckFishCrew = function()

  for _,v in pairs(workspace.Enemies:GetChildren()) do

    if (v.Name == "Fish Crew Member" or v.Name == "Haunted Crew Member") and Attack.Alive(v) then

      return true    

end;

  end;

  return false

end;

CheckHauntedCrew = function()

  for _,v in pairs(workspace.Enemies:GetChildren()) do

    if (v.Name == "Haunted Crew Member") and Attack.Alive(v) then

      return true    

end;

  end;

  return false

end;

CheckSeaBeast = function()

  if workspace.SeaBeasts:FindFirstChild("SeaBeast1") then

    return true  

end;

  return false

end;

CheckLeviathan = function()

  if workspace.SeaBeasts:FindFirstChild("Leviathan") then

    return true  

end;

  return false

end;

UpdStFruit = function()

  for z,x in next, plr.Backpack:GetChildren() do

  StoreFruit = x:FindFirstChild("EatRemote", true)

    if StoreFruit then

      replicated.Remotes.CommF_:InvokeServer("StoreFruit",StoreFruit.Parent:GetAttribute("OriginalName"),

      plr.Backpack:FindFirstChild(x.Name))

    end

  end

end

collectFruits = function(Succes)

  if Succes then

    local Character = plr.Character

    for _,v1 in pairs(workspace:GetChildren()) do

    if string.find(v1.Name, "Fruit") then v1.Handle.CFrame = Character.HumanoidRootPart.CFrame end

    end

  end

end

Getmoon = function()

  if World1 then

    return Lighting.FantasySky.MoonTextureId

  elseif World2 then

    return Lighting.FantasySky.MoonTextureId

  elseif World3 then

    return Lighting.Sky.MoonTextureId

  end

end

DropFruits = function()

  for _,v3 in next, plr.Backpack:GetChildren() do

    if string.find(v3.Name, "Fruit") then

      EquipWeapon(v3.Name) wait(.1)

      if plr.PlayerGui.Main.Dialogue.Visible == true then plr.PlayerGui.Main.Dialogue.Visible = false end EquipWeapon(v3.Name) plr.Character:FindFirstChild(v3.Name).EatRemote:InvokeServer("Drop")

    end

  end

  for a,b2 in pairs(plr.Character:GetChildren()) do

    if string.find(b2.Name, "Fruit") then EquipWeapon(b2.Name) wait(.1)

    if plr.PlayerGui.Main.Dialogue.Visible == true then plr.PlayerGui.Main.Dialogue.Visible = false end EquipWeapon(b2.Name) plr.Character:FindFirstChild(b2.Name).EatRemote:InvokeServer("Drop")

    end

  end

end

GetBP = function(v)

  return plr.Backpack:FindFirstChild(v) or plr.Character:FindFirstChild(v)

end

GetIn = function(Name)

  for _ ,v1 in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do

    if type(v1) == "table" then

      if v1.Name == Name or plr.Character:FindFirstChild(Name) or plr.Backpack:FindFirstChild(Name) then

        return true

	 end

    end

  end

  return false

end

GetM = function(Name)

  for _,tab in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do

    if type(tab) == "table" then

	  if tab.Type == "Material" then

	    if tab.Name == Name then

		  return tab.Count

	    end

	  end

    end

  end

return 0

end

GetWP = function(nametool)

  for _,v4 in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do

    if type(v4) == "table" then

      if v4.Type == "Sword" then

        if v4.Name == nametool or plr.Character:FindFirstChild(nametool) or plr.Backpack:FindFirstChild(nametool) then

	     return true

	     end

	   end

      end

    end

  return false

end 

getInfinity_Ability = function(Method, Var)

  if not Root then return end

  if Method == "Soru" and Var then

    for _,gc in next, getgc() do

      if plr.Character.Soru then

        if ((typeof(gc) == "function") and (getfenv(gc).script == plr.Character.Soru)) then

          for _, v in next, getupvalues(gc) do

            if (typeof(v) == "table") then

              repeat wait(Sec) v.LastUse = 0 until not Var or (plr.Character.Humanoid.Health <= 0)

            end

          end

        end

      end

    end    

  elseif Method == "Energy" and Var then

    plr.Character.Energy.Changed:connect(function()

      if Var then plr.Character.Energy.Value = Energy end 

    end)

  elseif Method == "Observation" and Var then

    local VisionRadius = plr.VisionRadius

    VisionRadius.Value = math.huge

  end

end

Hop = function()

  pcall(function()

    for count = math.random(1, math.random(40, 75)), 100 do

      local remote = replicated.__ServerBrowser:InvokeServer(count)

	  for _, v in next, remote do

	  if tonumber(v['Count']) < 12 then TeleportService:TeleportToPlaceInstance(game.PlaceId, _) end

	  end    

    end

  end)

end

local block = Instance.new("Part", workspace)

block.Size = Vector3.new(1, 1, 1)

block.Name = "Rip_Indra"

block.Anchored = true

block.CanCollide = false

block.CanTouch = false

block.Transparency = 1

local blockfind = workspace:FindFirstChild(block.Name)

if blockfind and blockfind ~= block then blockfind:Destroy() end

task.spawn(function()while task.wait()do if block and block.Parent==workspace then if shouldTween then getgenv().OnFarm=true else getgenv().OnFarm=false end else getgenv().OnFarm=false end end end)

task.spawn(function()local a=game.Players.LocalPlayer;repeat task.wait()until a.Character and a.Character.PrimaryPart;block.CFrame=a.Character.PrimaryPart.CFrame;while task.wait()do pcall(function()if getgenv().OnFarm then if block and block.Parent==workspace then local b=a.Character and a.Character.PrimaryPart;if b and(b.Position-block.Position).Magnitude<=200 then b.CFrame=block.CFrame else block.CFrame=b.CFrame end end;local c=a.Character;if c then for d,e in pairs(c:GetChildren())do if e:IsA("BasePart")then e.CanCollide=false end end end else local c=a.Character;if c then for d,e in pairs(c:GetChildren())do if e:IsA("BasePart")then e.CanCollide=true end end end end end)end end)

task.spawn(function()local a=game.Players.LocalPlayer;repeat task.wait()until a.Character and a.Character.PrimaryPart;block.CFrame=a.Character.PrimaryPart.CFrame;while task.wait()do pcall(function()if getgenv().OnFarm then if block and block.Parent==workspace then local b=a.Character and a.Character.PrimaryPart;if b and(b.Position-block.Position).Magnitude<=200 then b.CFrame=block.CFrame else block.CFrame=b.CFrame end end;local c=a.Character;if c then for d,e in pairs(c:GetChildren())do if e:IsA("BasePart")then e.CanCollide=false end end end else local c=a.Character;if c then for d,e in pairs(c:GetChildren())do if e:IsA("BasePart")then e.CanCollide=true end end end end end)end end)
_G.TPSettings = _G.TPSettings or {}
_G.TPBypass = _G.TPBypass or false
_G.TPSpeed = _G.TPSpeed or 300
_G.TPUseTween = _G.TPUseTween == nil and true or _G.TPUseTween

local plr = game.Players.LocalPlayer
local replicated = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local World1 = game.PlaceId == 2753915549
local World2 = game.PlaceId == 4442272183
local World3 = game.PlaceId == 7449423635

local function Convert_CFrame(x)
    if not x then return nil end
    local t = typeof(x)
    if t == "Vector3" then return CFrame.new(x) end
    if t == "CFrame" then return x end
    if t == "Model" then return x:GetPivot() end
    if x.CFrame then return x.CFrame end
    return nil
end

local function GetDistance_bypass(POS_1, POS_2, NO_Y)
    if not POS_1 then return 9e9 end
    local char = plr.Character
    if not char then return 9e9 end
    local hum = char:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return 9e9 end
    local p1 = Convert_CFrame(POS_1)
    local p2 = POS_2 and Convert_CFrame(POS_2) or char:FindFirstChild("HumanoidRootPart")
    if not p1 or not p2 then return 9e9 end
    if NO_Y then
        return (Vector3.new(p1.X, 0, p1.Z) - Vector3.new(p2.X, 0, p2.Z)).Magnitude
    else
        return (p1.Position - p2.Position).Magnitude
    end
end

local function InArea(POS)
    local wo = Workspace:FindFirstChild("_WorldOrigin")
    if not wo then return {Name = ""} end
    local pos = Convert_CFrame(POS)
    if not pos then return {Name = ""} end
    for _, v in pairs(wo.Locations:GetChildren()) do
        if v:FindFirstChild("Mesh") and (pos.Position - v.Position).Magnitude <= v.Mesh.Scale.X then
            return v
        end
    end
    return {Name = ""}
end

local function GetSpawnPoint(x)
    local spawns = Workspace._WorldOrigin and Workspace._WorldOrigin.PlayerSpawns and Workspace._WorldOrigin.PlayerSpawns.Pirates
    if not spawns then return nil end
    for _, v in pairs(spawns:GetChildren()) do
        if v:FindFirstChild("Part") and (v.Part.Position - x.Position).Magnitude <= 2500 then
            return v
        end
    end
    return nil
end

local function CheckLegendaryItems()
    local function CheckItem(name)
        for _, v in pairs(plr.Backpack:GetChildren()) do
            if v:IsA("Tool") and (v.Name == name or string.find(v.Name, name)) then
                return v
            end
        end
        for _, v in pairs(plr.Character:GetChildren()) do
            if v:IsA("Tool") and (v.Name == name or string.find(v.Name, name)) then
                return v
            end
        end
        return nil
    end
    return CheckItem("God's Chalice") or CheckItem("Fist of Darkness") or CheckItem("Sweet Chalice") or CheckItem("Hallow Essence") or CheckItem("Flower1")
end

local function CanBypassTeleport(x)
    local area = InArea(x).Name
    if area == "" then return false end
    if not _G.TPBypass then return false end
    if area:find("Dimension") or area:find("Submerged") or area == "Sealed Cavern" or area:lower():find("under") then
        return false
    end
    if CheckLegendaryItems() then return false end
    if plr.Data and plr.Data.LastSpawnPoint and plr.Data.LastSpawnPoint.Value == "SubmergedIsland" then
        return false
    end
    if GetDistance_bypass(x.Position) <= 3500 then return false end
    return true
end

local function GetBypassCFrame(x)
    local maxDist = math.huge
    local best = nil
    local wo = Workspace:FindFirstChild("_WorldOrigin")
    if not wo then return nil end
    local spawns = wo:FindFirstChild("PlayerSpawns")
    if not spawns then return nil end
    local pirates = spawns:FindFirstChild("Pirates")
    if not pirates then return nil end
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    for _, v in pairs(pirates:GetChildren()) do
        if v:FindFirstChild("Part") then
            local distToTarget = (v.Part.Position - x.Position).Magnitude
            if distToTarget < maxDist and (v.Part.Position - hrp.Position).Magnitude <= 10000 and distToTarget >= 3000 then
                maxDist = distToTarget
                best = v
            end
        end
    end
    return best
end

local function BypassTP(Target)
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if not CanBypassTeleport(Target) then return false end
    local targetTP = GetBypassCFrame(Target)
    if not targetTP or not targetTP:FindFirstChild("Part") then return false end
    local lastSpawn = char:FindFirstChild("LastSpawnPoint")
    if not lastSpawn then return false end
    lastSpawn.Disabled = true
    local remote = replicated.Remotes.CommF_
    remote:InvokeServer("SetLastSpawnPoint", targetTP.Name)
    remote:InvokeServer("SetSpawnPoint")
    char:PivotTo(targetTP.Part.CFrame)
    hum:ChangeState(15)
    repeat task.wait(0.1) until plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0
    return true
end

local function requestentrance(pos)
    local tb = {}
    local targetPos
    if typeof(pos) == "CFrame" then
        targetPos = pos.Position
    elseif typeof(pos) == "Vector3" then
        targetPos = pos
    elseif pos and pos.Position then
        targetPos = pos.Position
    elseif pos and pos.CFrame then
        targetPos = pos.CFrame.Position
    else
        return false
    end
    if World1 then
        tb = {
            ["Sky3"] = Vector3.new(-7894,5547,-380),
            ["Sky3Exit"] = Vector3.new(-4607,874,-1667),
            ["UnderWater"] = Vector3.new(61163,11,1819),
            ["Underwater City"] = Vector3.new(61165.19140625,0.18704631924629211,1897.379150390625),
            ["Pirate Village"] = Vector3.new(-1242.4625244140625,4.787059783935547,3901.282958984375),
            ["UnderwaterExit"] = Vector3.new(4050,-1,-1814)
        }
    elseif World2 then
        tb = {
            ["Swan Mansion"] = Vector3.new(-390,332,673),
            ["Swan Room"] = Vector3.new(2285,15,905),
            ["Cursed Ship"] = Vector3.new(923,126,32852),
            ["Zombie Island"] = Vector3.new(-6509,83,-133)
        }
    else
        tb = {
            ["Hydra Island"] = Vector3.new(5657.88623046875,1013.0790405273438,-335.4996337890625),
            ["Mansion"] = Vector3.new(-12462,375,-7552),
            ["Castle"] = Vector3.new(-5036,315,-3179),
            ["Temple of Time"] = Vector3.new(28286,14897,103),
            ["Greate Tree"] = Vector3.new(3024.1709,2280.69434,-7325.12793)
        }
    end
    local near = nil
    local minDist = math.huge
    for _, v in pairs(tb) do
        local d = (v - targetPos).Magnitude
        if d < minDist then
            minDist = d
            near = v
        end
    end
    if not near then return false end
    if minDist >= GetDistance_bypass(pos) then return false end
    if near.X == 3024.1709 and near.Y == 2280.69434 and near.Z == -7325.12793 then
        local success, progress = pcall(function()
            return replicated.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
        end)
        if success and progress >= 2 then return false end
    end
    local success = pcall(function()
        replicated.Remotes.CommF_:InvokeServer("requestEntrance", near)
    end)
    if success then
        task.wait(1)
        return true
    end
    return false
end

shouldTween = true
_G.StopTween = false

if not _G.TeleBlock then
    _G.TeleBlock = Instance.new("Part", workspace)
    _G.TeleBlock.Size = Vector3.new(1, 1, 1)
    _G.TeleBlock.Name = "Rip_Indra"
    _G.TeleBlock.Anchored = true
    _G.TeleBlock.CanCollide = false
    _G.TeleBlock.CanTouch = false
    _G.TeleBlock.Transparency = 1
end
local block = _G.TeleBlock

function _tp(target)
    local gg = Convert_CFrame(target)
    if not gg then return end
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return end
    if hum.Sit then
        hrp.CFrame = gg
        return
    end
    local dist = (gg.Position - hrp.Position).Magnitude
    if dist < 50 then
        hrp.CFrame = gg
        return
    end
    if _G.TPBypass then
        local used = false
        pcall(function() used = requestentrance(gg) end)
        if used then return end
    end
    if _G.TPBypass then
        local used = false
        pcall(function() used = BypassTP(gg) end)
        if used then return end
    end
    if not _G.TPUseTween or _G.TPSpeed < 100 then
        hrp.CFrame = gg
        return
    end
    local speed = _G.TPSpeed or 300
    local duration = dist / speed
    duration = math.max(duration, 0.1)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    block.CFrame = hrp.CFrame
    local tween = TweenService:Create(block, tweenInfo, {CFrame = gg})
    local bp = Instance.new("BodyPosition", hrp)
    bp.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bp.P = 10000
    bp.D = 500
    bp.Position = block.Position
    local conn = RunService.Heartbeat:Connect(function()
        if hrp and block then
            bp.Position = block.Position
            hrp.CFrame = block.CFrame
        end
    end)
    tween:Play()
    local finished = false
    tween.Completed:Connect(function()
        finished = true
    end)
    local timeout = tick() + 30
    while not finished and tick() < timeout do
        if not shouldTween or _G.StopTween then
            tween:Cancel()
            break
        end
        task.wait(0.05)
    end
    conn:Disconnect()
    bp:Destroy()
    if not finished then
        hrp.CFrame = gg
    end
end

function BTP(p)
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    local target = Convert_CFrame(p)
    if not target then return end
    local maxRetries = 10
    local retry = 0
    repeat
        hum.Health = 0
        hrp.CFrame = target
        task.wait(0.3)
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.Health = plr.Character.Humanoid.MaxHealth
        end
        retry = retry + 1
        if (target.Position - hrp.Position).Magnitude <= 2000 then break end
        task.wait(0.2)
    until retry >= maxRetries
    if (target.Position - hrp.Position).Magnitude > 2000 then
        hrp.CFrame = target
    end
end
spawn(function()

  while task.wait() do

    pcall(function()

      if _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.DT_Uzoth or _G.AutoBerry or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoFarmChest or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago  or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Bartilo_Quest or _G.Level or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or getgenv().AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or _G.TPNpc or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.AutoPole or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.Auto_StartRaid or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Mink or _G.Auto_Human or _G.Auto_Skypiea or _G.Auto_Fish or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad or _G.AutoUnHaki or _G.Auto_DonAcces or _G.AutoRipIngay or _G.DragoV3 or _G.DragoV1 or _G.SailBoats or NextIs or _G.FarmGodChalice or _G.IceBossRen or senth or senth2 or _G.Lvthan or _G.beasthunter or _G.DangerLV or _G.Relic123 or _G.tweenKitsune or _G.Collect_Ember or _G.AutofindKitIs or _G.snaguine or _G.TwFruits or _G.tweenKitShrine or _G.Tp_LgS or _G.Tp_MasterA or _G.tweenShrine or _G.FarmMastery_G or _G.FarmMastery_S then

        shouldTween = true

        if not plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then

          local Noclip = Instance.new("BodyVelocity")

          Noclip.Name = "BodyClip"

          Noclip.Parent = plr.Character.HumanoidRootPart

          Noclip.MaxForce = Vector3.new(100000,100000,100000)

          Noclip.Velocity = Vector3.new(0,0,0)

        end        

        if not plr.Character:FindFirstChild('highlight') then

          local Test = Instance.new('Highlight')

          Test.Name = "highlight"

          Test.Enabled = true

          Test.FillColor = Color3.fromRGB(0,255,255)

          Test.OutlineColor = Color3.fromRGB(255,255,255)

          Test.FillTransparency = 0.5

          Test.OutlineTransparency = 1

          Test.Parent = plr.Character

        end

        for _, no in pairs(plr.Character:GetDescendants()) do if no:IsA("BasePart") then no.CanCollide = false end end

      else

        shouldTween = false

        if plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then plr.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy() end

        if plr.Character:FindFirstChild('highlight') then plr.Character:FindFirstChild('highlight'):Destroy() end	        

      end

    end)

  end

end)

QuestB=function()if World1 then if _G.FindBoss=="The Gorilla King"then bMon="The Gorilla King"Qname="JungleQuest"Qdata=3;PosQBoss=CFrame.new(-1601.6553955078,36.85213470459,153.38809204102)PosB=CFrame.new(-1088.75977,8.13463783,-488.559906,-0.707134247,0,0.707079291,0,1,0,-0.707079291,0,-0.707134247)elseif _G.FindBoss=="Bobby"then bMon="Bobby"Qname="BuggyQuest1"Qdata=3;PosQBoss=CFrame.new(-1140.1761474609,4.752049446106,3827.4057617188)PosB=CFrame.new(-1087.3760986328,46.949409484863,4040.1462402344)elseif _G.FindBoss=="The Saw"then bMon="The Saw"PosB=CFrame.new(-784.89715576172,72.427383422852,1603.5822753906)elseif _G.FindBoss=="Yeti"then bMon="Yeti"Qname="SnowQuest"Qdata=3;PosQBoss=CFrame.new(1386.8073730469,87.272789001465,-1298.3576660156)PosB=CFrame.new(1218.7956542969,138.01184082031,-1488.0262451172)elseif _G.FindBoss=="Mob Leader"then bMon="Mob Leader"PosB=CFrame.new(-2844.7307128906,7.4180502891541,5356.6723632813)elseif _G.FindBoss=="Vice Admiral"then bMon="Vice Admiral"Qname="MarineQuest2"Qdata=2;PosQBoss=CFrame.new(-5036.2465820313,28.677835464478,4324.56640625)PosB=CFrame.new(-5006.5454101563,88.032081604004,4353.162109375)elseif _G.FindBoss=="Saber Expert"then bMon="Saber Expert"PosB=CFrame.new(-1458.89502,29.8870335,-50.633564)elseif _G.FindBoss=="Warden"then bMon="Warden"Qname="ImpelQuest"Qdata=1;PosB=CFrame.new(5278.04932,2.15167475,944.101929,0.220546961,-4.49946401e-06,0.975376427,-1.95412576e-05,1,9.03162072e-06,-0.975376427,-2.10519756e-05,0.220546961)PosQBoss=CFrame.new(5191.86133,2.84020686,686.438721,-0.731384635,0,0.681965172,0,1,0,-0.681965172,0,-0.731384635)elseif _G.FindBoss=="Chief Warden"then bMon="Chief Warden"Qname="ImpelQuest"Qdata=2;PosB=CFrame.new(5206.92578,0.997753382,814.976746,0.342041343,-0.00062915677,0.939684749,0.00191645394,0.999998152,-2.80422337e-05,-0.939682961,0.00181045406,0.342041939)PosQBoss=CFrame.new(5191.86133,2.84020686,686.438721,-0.731384635,0,0.681965172,0,1,0,-0.681965172,0,-0.731384635)elseif _G.FindBoss=="Swan"then bMon="Swan"Qname="ImpelQuest"Qdata=3;PosB=CFrame.new(5325.09619,7.03906584,719.570679,-0.309060812,0,0.951042235,0,1,0,-0.951042235,0,-0.309060812)PosQBoss=CFrame.new(5191.86133,2.84020686,686.438721,-0.731384635,0,0.681965172,0,1,0,-0.681965172,0,-0.731384635)elseif _G.FindBoss=="Magma Admiral"then bMon="Magma Admiral"Qname="MagmaQuest"Qdata=3;PosQBoss=CFrame.new(-5314.6220703125,12.262420654297,8517.279296875)PosB=CFrame.new(-5765.8969726563,82.92064666748,8718.3046875)elseif _G.FindBoss=="Fishman Lord"then bMon="Fishman Lord"Qname="FishmanQuest"Qdata=3;PosQBoss=CFrame.new(61122.65234375,18.497442245483,1569.3997802734)PosB=CFrame.new(61260.15234375,30.950881958008,1193.4329833984)elseif _G.FindBoss=="Wysper"then bMon="Wysper"Qname="SkyExp1Quest"Qdata=3;PosQBoss=CFrame.new(-7861.947265625,5545.517578125,-379.85974121094)PosB=CFrame.new(-7866.1333007813,5576.4311523438,-546.74816894531)elseif _G.FindBoss=="Thunder God"then bMon="Thunder God"Qname="SkyExp2Quest"Qdata=3;PosQBoss=CFrame.new(-7903.3828125,5635.9897460938,-1410.923828125)PosB=CFrame.new(-7994.984375,5761.025390625,-2088.6479492188)elseif _G.FindBoss=="Cyborg"then bMon="Cyborg"Qname="FountainQuest"Qdata=3;PosQBoss=CFrame.new(5258.2788085938,38.526931762695,4050.044921875)PosB=CFrame.new(6094.0249023438,73.770050048828,3825.7348632813)elseif _G.FindBoss=="Ice Admiral"then bMon="Ice Admiral"Qdata=nil;PosQBoss=CFrame.new(1266.08948,26.1757946,-1399.57678,-0.573599219,0,-0.81913656,0,1,0,0.81913656,0,-0.573599219)PosB=CFrame.new(1266.08948,26.1757946,-1399.57678,-0.573599219,0,-0.81913656,0,1,0,0.81913656,0,-0.573599219)elseif _G.FindBoss=="Greybeard"then bMon="Greybeard"Qdata=nil;PosQBoss=CFrame.new(-5081.3452148438,85.221641540527,4257.3588867188)PosB=CFrame.new(-5081.3452148438,85.221641540527,4257.3588867188)end end;if World2 then if _G.FindBoss=="Diamond"then bMon="Diamond"Qname="Area1Quest"Qdata=3;PosQBoss=CFrame.new(-427.5666809082,73.313781738281,1835.4208984375)PosB=CFrame.new(-1576.7166748047,198.59265136719,13.724286079407)elseif _G.FindBoss=="Jeremy"then bMon="Jeremy"Qname="Area2Quest"Qdata=3;PosQBoss=CFrame.new(636.79943847656,73.413787841797,918.00415039063)PosB=CFrame.new(2006.9261474609,448.95666503906,853.98284912109)elseif _G.FindBoss=="Fajita"then bMon="Fajita"Qname="MarineQuest3"Qdata=3;PosQBoss=CFrame.new(-2441.986328125,73.359344482422,-3217.5324707031)PosB=CFrame.new(-2172.7399902344,103.32216644287,-4015.025390625)elseif _G.FindBoss=="Don Swan"then bMon="Don Swan"PosB=CFrame.new(2286.2004394531,15.177839279175,863.8388671875)elseif _G.FindBoss=="Smoke Admiral"then bMon="Smoke Admiral"Qname="IceSideQuest"Qdata=3;PosQBoss=CFrame.new(-5429.0473632813,15.977565765381,-5297.9614257813)PosB=CFrame.new(-5275.1987304688,20.757257461548,-5260.6669921875)elseif _G.FindBoss=="Awakened Ice Admiral"then bMon="Awakened Ice Admiral"Qname="FrostQuest"Qdata=3;PosQBoss=CFrame.new(5668.9780273438,28.519989013672,-6483.3520507813)PosB=CFrame.new(6403.5439453125,340.29766845703,-6894.5595703125)elseif _G.FindBoss=="Tide Keeper"then bMon="Tide Keeper"Qname="ForgottenQuest"Qdata=3;PosQBoss=CFrame.new(-3053.9814453125,237.18954467773,-10145.0390625)PosB=CFrame.new(-3795.6423339844,105.88877105713,-11421.307617188)elseif _G.FindBoss=="Darkbeard"then bMon="Darkbeard"Qdata=nil;PosQBoss=CFrame.new(3677.08203125,62.751937866211,-3144.8332519531)PosB=CFrame.new(3677.08203125,62.751937866211,-3144.8332519531)elseif _G.FindBoss=="Cursed Captaim"then bMon="Cursed Captain"Qdata=nil;PosQBoss=CFrame.new(916.928589,181.092773,33422)PosB=CFrame.new(916.928589,181.092773,33422)elseif _G.FindBoss=="Order"then bMon="Order"Qdata=nil;PosQBoss=CFrame.new(-6217.2021484375,28.047645568848,-5053.1357421875)PosB=CFrame.new(-6217.2021484375,28.047645568848,-5053.1357421875)end end;if World3 then if _G.FindBoss=="Stone"then bMon="Stone"Qname="PiratePortQuest"Qdata=3;PosQBoss=CFrame.new(-289.76705932617,43.819011688232,5579.9384765625)PosB=CFrame.new(-1027.6512451172,92.404174804688,6578.8530273438)elseif _G.FindBoss=="Hydra Leader"then bMon="Hydra Leader"Qname="AmazonQuest2"Qdata=3;PosQBoss=CFrame.new(5821.89794921875,1019.0950927734375,-73.71923065185547)PosB=CFrame.new(5821.89794921875,1019.0950927734375,-73.71923065185547)elseif _G.FindBoss=="Kilo Admiral"then bMon="Kilo Admiral"Qname="MarineTreeIsland"Qdata=3;PosQBoss=CFrame.new(2179.3010253906,28.731239318848,-6739.9741210938)PosB=CFrame.new(2764.2233886719,432.46154785156,-7144.4580078125)elseif _G.FindBoss=="Captain Elephant"then bMon="Captain Elephant"Qname="DeepForestIsland"Qdata=3;PosQBoss=CFrame.new(-13232.682617188,332.40396118164,-7626.01171875)PosB=CFrame.new(-13376.7578125,433.28689575195,-8071.392578125)elseif _G.FindBoss=="Beautiful Pirate"then bMon="Beautiful Pirate"Qname="DeepForestIsland2"Qdata=3;PosQBoss=CFrame.new(-12682.096679688,390.88653564453,-9902.1240234375)PosB=CFrame.new(5283.609375,22.56223487854,-110.78285217285)elseif _G.FindBoss=="Cake Queen"then bMon="Cake Queen"Qname="IceCreamIslandQuest"Qdata=3;PosQBoss=CFrame.new(-819.376709,64.9259796,-10967.2832,-0.766061664,0,0.642767608,0,1,0,-0.642767608,0,-0.766061664)PosB=CFrame.new(-678.648804,381.353943,-11114.2012,-0.908641815,0.00149294338,0.41757378,0.00837114919,0.999857843,0.0146408929,-0.417492568,0.0167988986,-0.90852499)elseif _G.FindBoss=="Longma"then bMon="Longma"Qdata=nil;PosQBoss=CFrame.new(-10238.875976563,389.7912902832,-9549.7939453125)PosB=CFrame.new(-10238.875976563,389.7912902832,-9549.7939453125)elseif _G.FindBoss=="Soul Reaper"then bMon="Soul Reaper"Qdata=nil;PosQBoss=CFrame.new(-9524.7890625,315.80429077148,6655.7192382813)PosB=CFrame.new(-9524.7890625,315.80429077148,6655.7192382813)end end end

QuestBeta = function()

  local Neta = QuestB()

  return {

    [0] = _G.FindBoss,

    [1] = bMon,

    [2] = Qdata,

    [3] = Qname,

    [4] = PosB

    }  

end

QuestCheck=function()local a=game.Players.LocalPlayer.Data.Level.Value;if World1 then if a==1 or a<=9 then if tostring(TeamSelf)=="Marines"then Mon="Trainee"Qname="MarineQuest"Qdata=1;NameMon="Trainee"PosM=CFrame.new(-2709.67944,24.5206585,2104.24585,-0.744724929,-3.97967455e-08,-0.667371571,4.32403588e-08,1,-1.07884304e-07,0.667371571,-1.09201515e-07,-0.744724929)PosQ=CFrame.new(-2709.67944,24.5206585,2104.24585,-0.744724929,-3.97967455e-08,-0.667371571,4.32403588e-08,1,-1.07884304e-07,0.667371571,-1.09201515e-07,-0.744724929)elseif tostring(TeamSelf)=="Pirates"then Mon="Bandit"Qdata=1;Qname="BanditQuest1"NameMon="Bandit"PosM=CFrame.new(1045.962646484375,27.00250816345215,1560.8203125)PosQ=CFrame.new(1045.962646484375,27.00250816345215,1560.8203125)end elseif a==10 or a<=14 then Mon="Monkey"Qdata=1;Qname="JungleQuest"NameMon="Monkey"PosQ=CFrame.new(-1598.08911,35.5501175,153.377838,0,0,1,0,1,-0,-1,0,0)PosM=CFrame.new(-1448.51806640625,67.85301208496094,11.46579647064209)elseif a==15 or a<=29 then Mon="Gorilla"Qdata=2;Qname="JungleQuest"NameMon="Gorilla"PosQ=CFrame.new(-1598.08911,35.5501175,153.377838,0,0,1,0,1,-0,-1,0,0)PosM=CFrame.new(-1129.8836669921875,40.46354675292969,-525.4237060546875)elseif a==30 or a<=39 then Mon="Pirate"Qdata=1;Qname="BuggyQuest1"NameMon="Pirate"PosQ=CFrame.new(-1141.07483,4.10001802,3831.5498,0.965929627,-0,-0.258804798,0,1,-0,0.258804798,0,0.965929627)PosM=CFrame.new(-1103.513427734375,13.752052307128906,3896.091064453125)elseif a==40 or a<=59 then Mon="Brute"Qdata=2;Qname="BuggyQuest1"NameMon="Brute"PosQ=CFrame.new(-1141.07483,4.10001802,3831.5498,0.965929627,-0,-0.258804798,0,1,-0,0.258804798,0,0.965929627)PosM=CFrame.new(-1140.083740234375,14.809885025024414,4322.92138671875)elseif a==60 or a<=74 then Mon="Desert Bandit"Qdata=1;Qname="DesertQuest"NameMon="Desert Bandit"PosQ=CFrame.new(894.488647,5.14000702,4392.43359,0.819155693,-0,-0.573571265,0,1,-0,0.573571265,0,0.819155693)PosM=CFrame.new(924.7998046875,6.44867467880249,4481.5859375)elseif a==75 or a<=89 then Mon="Desert Officer"Qdata=2;Qname="DesertQuest"NameMon="Desert Officer"PosQ=CFrame.new(894.488647,5.14000702,4392.43359,0.819155693,-0,-0.573571265,0,1,-0,0.573571265,0,0.819155693)PosM=CFrame.new(1608.2822265625,8.614224433898926,4371.00732421875)elseif a==90 or a<=99 then Mon="Snow Bandit"Qdata=1;Qname="SnowQuest"NameMon="Snow Bandit"PosQ=CFrame.new(1389.74451,88.1519318,-1298.90796,-0.342042685,0,0.939684391,0,1,0,-0.939684391,0,-0.342042685)PosM=CFrame.new(1354.347900390625,87.27277374267578,-1393.946533203125)elseif a==100 or a<=119 then Mon="Snowman"Qdata=2;Qname="SnowQuest"NameMon="Snowman"PosQ=CFrame.new(1389.74451,88.1519318,-1298.90796,-0.342042685,0,0.939684391,0,1,0,-0.939684391,0,-0.342042685)PosM=CFrame.new(6241.9951171875, 51.522083282471, -1243.9771728516)elseif a==120 or a<=149 then Mon="Chief Petty Officer"Qdata=1;Qname="MarineQuest2"NameMon="Chief Petty Officer"PosQ=CFrame.new(-5039.58643,27.3500385,4324.68018,0,0,-1,0,1,0,1,0,0)PosM=CFrame.new(-4881.23095703125,22.65204429626465,4273.75244140625)elseif a==150 or a<=174 then Mon="Sky Bandit"Qdata=1;Qname="SkyQuest"NameMon="Sky Bandit"PosQ=CFrame.new(-4839.53027,716.368591,-2619.44165,0.866007268,0,0.500031412,0,1,0,-0.500031412,0,0.866007268)PosM=CFrame.new(-4953.20703125,295.74420166015625,-2899.22900390625)elseif a==175 or a<=189 then Mon="Dark Master"Qdata=2;Qname="SkyQuest"NameMon="Dark Master"PosQ=CFrame.new(-4839.53027,716.368591,-2619.44165,0.866007268,0,0.500031412,0,1,0,-0.500031412,0,0.866007268)PosM=CFrame.new(-5259.8447265625,391.3976745605469,-2229.035400390625)elseif a==190 or a<=209 then Mon="Prisoner"Qdata=1;Qname="PrisonerQuest"NameMon="Prisoner"PosQ=CFrame.new(5308.93115,1.65517521,475.120514,-0.0894274712,-5.00292918e-09,-0.995993316,1.60817859e-09,1,-5.16744869e-09,0.995993316,-2.06384709e-09,-0.0894274712)PosM=CFrame.new(5098.9736328125,-0.3204058110713959,474.2373352050781)elseif a==210 or a<=249 then Mon="Dangerous Prisoner"Qdata=2;Qname="PrisonerQuest"NameMon="Dangerous Prisoner"PosQ=CFrame.new(5308.93115,1.65517521,475.120514,-0.0894274712,-5.00292918e-09,-0.995993316,1.60817859e-09,1,-5.16744869e-09,0.995993316,-2.06384709e-09,-0.0894274712)PosM=CFrame.new(5654.5634765625,15.633401870727539,866.2991943359375)elseif a==250 or a<=274 then Mon="Toga Warrior"Qdata=1;Qname="ColosseumQuest"NameMon="Toga Warrior"PosQ=CFrame.new(-1580.04663,6.35000277,-2986.47534,-0.515037298,0,-0.857167721,0,1,0,0.857167721,0,-0.515037298)PosM=CFrame.new(-1820.21484375,51.68385696411133,-2740.6650390625)elseif a==275 or a<=299 then Mon="Gladiator"Qdata=2;Qname="ColosseumQuest"NameMon="Gladiator"PosQ=CFrame.new(-1580.04663,6.35000277,-2986.47534,-0.515037298,0,-0.857167721,0,1,0,0.857167721,0,-0.515037298)PosM=CFrame.new(-1292.838134765625,56.380882263183594,-3339.031494140625)elseif a==300 or a<=324 then Boubty=false;Mon="Military Soldier"Qdata=1;Qname="MagmaQuest"NameMon="Military Soldier"PosQ=CFrame.new(-5313.37012,10.9500084,8515.29395,-0.499959469,0,0.866048813,0,1,0,-0.866048813,0,-0.499959469)PosM=CFrame.new(-5411.16455078125,11.081554412841797,8454.29296875)elseif a==325 or a<=374 then Mon="Military Spy"Qdata=2;Qname="MagmaQuest"NameMon="Military Spy"PosQ=CFrame.new(-5313.37012,10.9500084,8515.29395,-0.499959469,0,0.866048813,0,1,0,-0.866048813,0,-0.499959469)PosM=CFrame.new(-5802.8681640625,86.26241302490234,8828.859375)elseif a==375 or a<=399 then Mon="Fishman Warrior"Qdata=1;Qname="FishmanQuest"NameMon="Fishman Warrior"PosQ=CFrame.new(61122.65234375,18.497442245483,1569.3997802734)PosM=CFrame.new(60878.30078125,18.482830047607422,1543.7574462890625)if _G.Level and (PosQ.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>10000 then replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625,11.6796875,1819.7841796875))end elseif a==400 or a<=449 then Mon="Fishman Commando"Qdata=2;Qname="FishmanQuest"NameMon="Fishman Commando"PosQ=CFrame.new(61122.65234375,18.497442245483,1569.3997802734)PosM=CFrame.new(61922.6328125,18.482830047607422,1493.934326171875)if _G.Level and (PosQ.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>10000 then replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625,11.6796875,1819.7841796875))end elseif a==450 or a<=474 then Mon="God's Guard"Qdata=1;Qname="SkyExp1Quest"NameMon="God's Guard"PosQ=CFrame.new(-4721.88867,843.874695,-1949.96643,0.996191859,-0,-0.0871884301,0,1,-0,0.0871884301,0,0.996191859)PosM=CFrame.new(-4710.04296875,845.2769775390625,-1927.3079833984375)if _G.Level and (PosQ.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>10000 then replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275,872.54248,-1667.55688))end elseif a==475 or a<=524 then Mon="Shanda"Qdata=2;Qname="SkyExp1Quest"NameMon="Shanda"PosQ=CFrame.new(-7859.09814,5544.19043,-381.476196,-0.422592998,0,0.906319618,0,1,0,-0.906319618,0,-0.422592998)PosM=CFrame.new(-7678.48974609375,5566.40380859375,-497.2156066894531)if _G.Level and (PosQ.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>10000 then replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894.6176757813,5547.1416015625,-380.29119873047))end elseif a==525 or a<=549 then Mon="Royal Squad"Qdata=1;Qname="SkyExp2Quest"NameMon="Royal Squad"PosQ=CFrame.new(-7906.81592,5634.6626,-1411.99194,0,0,-1,0,1,0,1,0,0)PosM=CFrame.new(-7624.25244140625,5658.13330078125,-1467.354248046875)elseif a==550 or a<=624 then Mon="Royal Soldier"Qdata=2;Qname="SkyExp2Quest"NameMon="Royal Soldier"PosQ=CFrame.new(-7906.81592,5634.6626,-1411.99194,0,0,-1,0,1,0,1,0,0)PosM=CFrame.new(-7836.75341796875,5645.6640625,-1790.6236572265625)elseif a==625 or a<=649 then Mon="Galley Pirate"Qdata=1;Qname="FountainQuest"NameMon="Galley Pirate"PosQ=CFrame.new(5259.81982,37.3500175,4050.0293,0.087131381,0,0.996196866,0,1,0,-0.996196866,0,0.087131381)PosM=CFrame.new(5551.02197265625,78.90135192871094,3930.412841796875)elseif a>=650 then Mon="Galley Captain"Qdata=2;Qname="FountainQuest"NameMon="Galley Captain"PosQ=CFrame.new(5259.81982,37.3500175,4050.0293,0.087131381,0,0.996196866,0,1,0,-0.996196866,0,0.087131381)PosM=CFrame.new(5441.95166015625,42.50205993652344,4950.09375)end elseif World2 then if a==700 or a<=724 then Mon="Raider"Qdata=1;Qname="Area1Quest"NameMon="Raider"PosQ=CFrame.new(-429.543518,71.7699966,1836.18188,-0.22495985,0,-0.974368095,0,1,0,0.974368095,0,-0.22495985)PosM=CFrame.new(-728.3267211914062,52.779319763183594,2345.7705078125)elseif a==725 or a<=774 then Mon="Mercenary"Qdata=2;Qname="Area1Quest"NameMon="Mercenary"PosQ=CFrame.new(-429.543518,71.7699966,1836.18188,-0.22495985,0,-0.974368095,0,1,0,0.974368095,0,-0.22495985)PosM=CFrame.new(-1004.3244018554688,80.15886688232422,1424.619384765625)elseif a==775 or a<=799 then Mon="Swan Pirate"Qdata=1;Qname="Area2Quest"NameMon="Swan Pirate"PosQ=CFrame.new(638.43811,71.769989,918.282898,0.139203906,0,0.99026376,0,1,0,-0.99026376,0,0.139203906)PosM=CFrame.new(1068.664306640625,137.61428833007812,1322.1060791015625)elseif a==800 or a<=874 then Mon="Factory Staff"Qname="Area2Quest"Qdata=2;NameMon="Factory Staff"PosQ=CFrame.new(632.698608,73.1055908,918.666321,-0.0319722369,8.96074881e-10,-0.999488771,1.36326533e-10,1,8.92172336e-10,0.999488771,-1.07732087e-10,-0.0319722369)PosM=CFrame.new(73.07867431640625,81.86344146728516,-27.470672607421875)elseif a==875 or a<=899 then Mon="Marine Lieutenant"Qdata=1;Qname="MarineQuest3"NameMon="Marine Lieutenant"PosQ=CFrame.new(-2440.79639,71.7140732,-3216.06812,0.866007268,0,0.500031412,0,1,0,-0.500031412,0,0.866007268)PosM=CFrame.new(-2821.372314453125,75.89727783203125,-3070.089111328125)elseif a==900 or a<=949 then Mon="Marine Captain"Qdata=2;Qname="MarineQuest3"NameMon="Marine Captain"PosQ=CFrame.new(-2440.79639,71.7140732,-3216.06812,0.866007268,0,0.500031412,0,1,0,-0.500031412,0,0.866007268)PosM=CFrame.new(-1861.2310791015625,80.17658233642578,-3254.697509765625)elseif a==950 or a<=974 then Mon="Zombie"Qdata=1;Qname="ZombieQuest"NameMon="Zombie"PosQ=CFrame.new(-5497.06152,47.5923004,-795.237061,-0.29242146,0,-0.95628953,0,1,0,0.95628953,0,-0.29242146)PosM=CFrame.new(-5657.77685546875,78.96973419189453,-928.68701171875)elseif a==975 or a<=999 then Mon="Vampire"Qdata=2;Qname="ZombieQuest"NameMon="Vampire"PosQ=CFrame.new(-5497.06152,47.5923004,-795.237061,-0.29242146,0,-0.95628953,0,1,0,0.95628953,0,-0.29242146)PosM=CFrame.new(-6037.66796875,32.18463897705078,-1340.6597900390625)elseif a==1000 or a<=1049 then Mon="Snow Trooper"Qdata=1;Qname="SnowMountainQuest"NameMon="Snow Trooper"PosQ=CFrame.new(609.858826,400.119904,-5372.25928,-0.374604106,0,0.92718488,0,1,0,-0.92718488,0,-0.374604106)PosM=CFrame.new(549.1473388671875,427.3870544433594,-5563.69873046875)elseif a==1050 or a<=1099 then Mon="Winter Warrior"Qdata=2;Qname="SnowMountainQuest"NameMon="Winter Warrior"PosQ=CFrame.new(609.858826,400.119904,-5372.25928,-0.374604106,0,0.92718488,0,1,0,-0.92718488,0,-0.374604106)PosM=CFrame.new(1142.7451171875,475.6398010253906,-5199.41650390625)elseif a==1100 or a<=1124 then Mon="Lab Subordinate"Qdata=1;Qname="IceSideQuest"NameMon="Lab Subordinate"PosQ=CFrame.new(-6064.06885,15.2422857,-4902.97852,0.453972578,-0,-0.891015649,0,1,-0,0.891015649,0,0.453972578)PosM=CFrame.new(-5707.4716796875,15.951709747314453,-4513.39208984375)elseif a==1125 or a<=1174 then Mon="Horned Warrior"Qdata=2;Qname="IceSideQuest"NameMon="Horned Warrior"PosQ=CFrame.new(-6064.06885,15.2422857,-4902.97852,0.453972578,-0,-0.891015649,0,1,-0,0.891015649,0,0.453972578)PosM=CFrame.new(-6341.36669921875,15.951770782470703,-5723.162109375)elseif a==1175 or a<=1199 then Mon="Magma Ninja"Qdata=1;Qname="FireSideQuest"NameMon="Magma Ninja"PosQ=CFrame.new(-5428.03174,15.0622921,-5299.43457,-0.882952213,0,0.469463557,0,1,0,-0.469463557,0,-0.882952213)PosM=CFrame.new(-5449.6728515625,76.65874481201172,-5808.20068359375)elseif a==1200 or a<=1249 then Mon="Lava Pirate"Qdata=2;Qname="FireSideQuest"NameMon="Lava Pirate"PosQ=CFrame.new(-5428.03174,15.0622921,-5299.43457,-0.882952213,0,0.469463557,0,1,0,-0.469463557,0,-0.882952213)PosM=CFrame.new(-5213.33154296875,49.73788070678711,-4701.451171875)elseif a==1250 or a<=1274 then Mon="Ship Deckhand"Qdata=1;Qname="ShipQuest1"NameMon="Ship Deckhand"PosQ=CFrame.new(1037.80127,125.092171,32911.6016)PosM=CFrame.new(1212.0111083984375,150.79205322265625,33059.24609375)if _G.Level and (PosQ.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>500 then replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406,126.9760055542,32852.83203125))end elseif a==1275 or a<=1299 then Mon="Ship Engineer"Qdata=2;Qname="ShipQuest1"NameMon="Ship Engineer"PosQ=CFrame.new(1037.80127,125.092171,32911.6016)PosM=CFrame.new(919.4786376953125,43.54401397705078,32779.96875)if _G.Level and (PosQ.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>500 then replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406,126.9760055542,32852.83203125))end elseif a==1300 or a<=1324 then Mon="Ship Steward"Qdata=1;Qname="ShipQuest2"NameMon="Ship Steward"PosQ=CFrame.new(968.80957,125.092171,33244.125)PosM=CFrame.new(919.4385375976562,129.55599975585938,33436.03515625)if _G.Level and (PosQ.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>500 then replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406,126.9760055542,32852.83203125))end elseif a==1325 or a<=1349 then Mon="Ship Officer"Qdata=2;Qname="ShipQuest2"NameMon="Ship Officer"PosQ=CFrame.new(968.80957,125.092171,33244.125)PosM=CFrame.new(1036.0179443359375,181.4390411376953,33315.7265625)if _G.Level and (PosQ.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>500 then replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406,126.9760055542,32852.83203125))end elseif a==1350 or a<=1374 then Mon="Arctic Warrior"Qdata=1;Qname="FrostQuest"NameMon="Arctic Warrior"PosQ=CFrame.new(5667.6582,26.7997818,-6486.08984,-0.933587909,0,-0.358349502,0,1,0,0.358349502,0,-0.933587909)PosM=CFrame.new(5966.24609375,62.97002029418945,-6179.3828125)if _G.Level and (PosQ.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude>1000 then BTP(PosM) end elseif a==1375 or a<=1424 then Mon="Snow Lurker"Qdata=2;Qname="FrostQuest"NameMon="Snow Lurker"PosQ=CFrame.new(5667.6582,26.7997818,-6486.08984,-0.933587909,0,-0.358349502,0,1,0,0.358349502,0,-0.933587909)PosM=CFrame.new(5407.07373046875,69.19437408447266,-6880.88037109375)elseif a==1425 or a<=1449 then Mon="Sea Soldier"Qdata=1;Qname="ForgottenQuest"NameMon="Sea Soldier"PosQ=CFrame.new(-3054.44458,235.544281,-10142.8193,0.990270376,-0,-0.13915664,0,1,-0,0.13915664,0,0.990270376)PosM=CFrame.new(-3028.2236328125,64.67451477050781,-9775.4267578125)elseif a>=1450 then Mon="Water Fighter"Qdata=2;Qname="ForgottenQuest"NameMon="Water Fighter"PosQ=CFrame.new(-3054.44458,235.544281,-10142.8193,0.990270376,-0,-0.13915664,0,1,-0,0.13915664,0,0.990270376)PosM=CFrame.new(-3352.9013671875,285.01556396484375,-10534.841796875)end elseif World3 then if a==1500 or a<=1524 then Mon="Pirate Millionaire"Qdata=1;Qname="PiratePortQuest"NameMon="Pirate Millionaire"PosQ=CFrame.new(-712.8272705078125,98.5770492553711,5711.9541015625)PosM=CFrame.new(-712.8272705078125,98.5770492553711,5711.9541015625)elseif a==1525 or a<=1574 then Mon="Pistol Billionaire"Qdata=2;Qname="PiratePortQuest"NameMon="Pistol Billionaire"PosQ=CFrame.new(-723.4331665039062,147.42906188964844,5931.9931640625)PosM=CFrame.new(-723.4331665039062,147.42906188964844,5931.9931640625)elseif a==1575 or a<=1599 then Mon="Dragon Crew Warrior"Qdata=1;Qname="AmazonQuest"NameMon="Dragon Crew Warrior"PosQ=CFrame.new(6779.03271484375,111.16865539550781,-801.2130737304688)PosM=CFrame.new(6779.03271484375,111.16865539550781,-801.2130737304688)elseif a==1600 or a<=1624 then Mon="Dragon Crew Archer"Qname="AmazonQuest"Qdata=2;NameMon="Dragon Crew Archer"PosQ=CFrame.new(6955.8974609375,546.6658935546875,309.0401306152344)PosM=CFrame.new(6955.8974609375,546.6658935546875,309.0401306152344)elseif a==1625 or a<=1649 then Mon="Hydra Enforcer"Qname="VenomCrewQuest"Qdata=1;NameMon="Hydra Enforcer"PosQ=CFrame.new(4620.61572265625,1002.2954711914062,399.0868835449219)PosM=CFrame.new(4620.61572265625,1002.2954711914062,399.0868835449219)elseif a==1650 or a<=1699 then Mon="Venomous Assailant"Qname="VenomCrewQuest"Qdata=2;NameMon="Venomous Assailant"PosQ=CFrame.new(4697.5918,1100.65137,946.401978,0.579397917,-4.19689783e-10,0.81504482,-1.49287818e-10,1,6.21053986e-10,-0.81504482,-4.81513662e-10,0.579397917)PosM=CFrame.new(4697.5918,1100.65137,946.401978,0.579397917,-4.19689783e-10,0.81504482,-1.49287818e-10,1,6.21053986e-10,-0.81504482,-4.81513662e-10,0.579397917)elseif a==1700 or a<=1724 then Mon="Marine Commodore"Qdata=1;Qname="MarineTreeIsland"NameMon="Marine Commodore"PosQ=CFrame.new(2180.54126,27.8156815,-6741.5498,-0.965929747,0,0.258804798,0,1,0,-0.258804798,0,-0.965929747)PosM=CFrame.new(2286.0078125,73.13391876220703,-7159.80908203125)elseif a==1725 or a<=1774 then Mon="Marine Rear Admiral"NameMon="Marine Rear Admiral"Qname="MarineTreeIsland"Qdata=2;PosQ=CFrame.new(2179.98828125,28.731239318848,-6740.0551757813)PosM=CFrame.new(3656.773681640625,160.52406311035156,-7001.5986328125)elseif a==1775 or a<=1799 then Mon="Fishman Raider"Qdata=1;Qname="DeepForestIsland3"NameMon="Fishman Raider"PosQ=CFrame.new(-10581.6563,330.872955,-8761.18652,-0.882952213,0,0.469463557,0,1,0,-0.469463557,0,-0.882952213)PosM=CFrame.new(-10407.5263671875,331.76263427734375,-8368.5166015625)elseif a==1800 or a<=1824 then Mon="Fishman Captain"Qdata=2;Qname="DeepForestIsland3"NameMon="Fishman Captain"PosQ=CFrame.new(-10581.6563,330.872955,-8761.18652,-0.882952213,0,0.469463557,0,1,0,-0.469463557,0,-0.882952213)PosM=CFrame.new(-10994.701171875,352.38140869140625,-9002.1103515625)elseif a==1825 or a<=1849 then Mon="Forest Pirate"Qdata=1;Qname="DeepForestIsland"NameMon="Forest Pirate"PosQ=CFrame.new(-13234.04,331.488495,-7625.40137,0.707134247,-0,-0.707079291,0,1,-0,0.707079291,0,0.707134247)PosM=CFrame.new(-13274.478515625,332.3781433105469,-7769.58056640625)elseif a==1850 or a<=1899 then Mon="Mythological Pirate"Qdata=2;Qname="DeepForestIsland"NameMon="Mythological Pirate"PosQ=CFrame.new(-13234.04,331.488495,-7625.40137,0.707134247,-0,-0.707079291,0,1,-0,0.707079291,0,0.707134247)PosM=CFrame.new(-13680.607421875,501.08154296875,-6991.189453125)elseif a==1900 or a<=1924 then Mon="Jungle Pirate"Qdata=1;Qname="DeepForestIsland2"NameMon="Jungle Pirate"PosQ=CFrame.new(-12680.3818,389.971039,-9902.01953,-0.0871315002,0,0.996196866,0,1,0,-0.996196866,0,-0.0871315002)PosM=CFrame.new(-12256.16015625,331.73828125,-10485.8369140625)elseif a==1925 or a<=1974 then Mon="Musketeer Pirate"Qdata=2;Qname="DeepForestIsland2"NameMon="Musketeer Pirate"PosQ=CFrame.new(-12680.3818,389.971039,-9902.01953,-0.0871315002,0,0.996196866,0,1,0,-0.996196866,0,-0.0871315002)PosM=CFrame.new(-13457.904296875,391.545654296875,-9859.177734375)elseif a==1975 or a<=1999 then Mon="Reborn Skeleton"Qdata=1;Qname="HauntedQuest1"NameMon="Reborn Skeleton"PosQ=CFrame.new(-9479.2168,141.215088,5566.09277,0,0,1,0,1,-0,-1,0,0)PosM=CFrame.new(-8763.7236328125,165.72299194335938,6159.86181640625)elseif a==2000 or a<=2024 then Mon="Living Zombie"Qdata=2;Qname="HauntedQuest1"NameMon="Living Zombie"PosQ=CFrame.new(-9479.2168,141.215088,5566.09277,0,0,1,0,1,-0,-1,0,0)PosM=CFrame.new(-10144.1318359375,138.62667846679688,5838.0888671875)elseif a==2025 or a<=2049 then Mon="Demonic Soul"Qdata=1;Qname="HauntedQuest2"NameMon="Demonic Soul"PosQ=CFrame.new(-9516.99316,172.017181,6078.46533,0,0,-1,0,1,0,1,0,0)PosM=CFrame.new(-9505.8720703125,172.10482788085938,6158.9931640625)elseif a==2050 or a<=2074 then Mon="Posessed Mummy"Qdata=2;Qname="HauntedQuest2"NameMon="Posessed Mummy"PosQ=CFrame.new(-9516.99316,172.017181,6078.46533,0,0,-1,0,1,0,1,0,0)PosM=CFrame.new(-9582.0224609375,6.251527309417725,6205.478515625)elseif a==2075 or a<=2099 then Mon="Peanut Scout"Qdata=1;Qname="NutsIslandQuest"NameMon="Peanut Scout"PosQ=CFrame.new(-2104.3908691406,38.104167938232,-10194.21875,0,0,-1,0,1,0,1,0,0)PosM=CFrame.new(-2143.241943359375,47.72198486328125,-10029.9951171875)elseif a==2100 or a<=2124 then Mon="Peanut President"Qdata=2;Qname="NutsIslandQuest"NameMon="Peanut President"PosQ=CFrame.new(-2104.3908691406,38.104167938232,-10194.21875,0,0,-1,0,1,0,1,0,0)PosM=CFrame.new(-1859.35400390625,38.10316848754883,-10422.4296875)elseif a==2125 or a<=2149 then Mon="Ice Cream Chef"Qdata=1;Qname="IceCreamIslandQuest"NameMon="Ice Cream Chef"PosQ=CFrame.new(-820.64825439453,65.819526672363,-10965.795898438,0,0,-1,0,1,0,1,0,0)PosM=CFrame.new(-872.24658203125,65.81957244873047,-10919.95703125)elseif a==2150 or a<=2199 then Mon="Ice Cream Commander"Qdata=2;Qname="IceCreamIslandQuest"NameMon="Ice Cream Commander"PosQ=CFrame.new(-820.64825439453,65.819526672363,-10965.795898438,0,0,-1,0,1,0,1,0,0)PosM=CFrame.new(-558.06103515625,112.04895782470703,-11290.7744140625)elseif a==2200 or a<=2224 then Mon="Cookie Crafter"Qdata=1;Qname="CakeQuest1"NameMon="Cookie Crafter"PosQ=CFrame.new(-2021.32007,37.7982254,-12028.7295,0.957576931,-8.80302053e-08,0.288177818,6.9301187e-08,1,7.51931211e-08,-0.288177818,-5.2032135e-08,0.957576931)PosM=CFrame.new(-2374.13671875,37.79826354980469,-12125.30859375)elseif a==2225 or a<=2249 then Mon="Cake Guard"Qdata=2;Qname="CakeQuest1"NameMon="Cake Guard"PosQ=CFrame.new(-2021.32007,37.7982254,-12028.7295,0.957576931,-8.80302053e-08,0.288177818,6.9301187e-08,1,7.51931211e-08,-0.288177818,-5.2032135e-08,0.957576931)PosM=CFrame.new(-1598.3070068359375,43.773197174072266,-12244.5810546875)elseif a==2250 or a<=2274 then Mon="Baking Staff"Qdata=1;Qname="CakeQuest2"NameMon="Baking Staff"PosQ=CFrame.new(-1927.91602,37.7981339,-12842.5391,-0.96804446,4.22142143e-08,0.250778586,4.74911062e-08,1,1.49904711e-08,-0.250778586,2.64211941e-08,-0.96804446)PosM=CFrame.new(-1887.8099365234375,77.6185073852539,-12998.3505859375)elseif a==2275 or a<=2299 then Mon="Head Baker"Qdata=2;Qname="CakeQuest2"NameMon="Head Baker"PosQ=CFrame.new(-1927.91602,37.7981339,-12842.5391,-0.96804446,4.22142143e-08,0.250778586,4.74911062e-08,1,1.49904711e-08,-0.250778586,2.64211941e-08,-0.96804446)PosM=CFrame.new(-2216.188232421875,82.884521484375,-12869.2939453125)elseif a==2300 or a<=2324 then Mon="Cocoa Warrior"Qdata=1;Qname="ChocQuest1"NameMon="Cocoa Warrior"PosQ=CFrame.new(233.22836303710938,29.876001358032227,-12201.2333984375)PosM=CFrame.new(-21.55328369140625,80.57499694824219,-12352.3876953125)elseif a==2325 or a<=2349 then Mon="Chocolate Bar Battler"Qdata=2;Qname="ChocQuest1"NameMon="Chocolate Bar Battler"PosQ=CFrame.new(233.22836303710938,29.876001358032227,-12201.2333984375)PosM=CFrame.new(582.590576171875,77.18809509277344,-12463.162109375)elseif a==2350 or a<=2374 then Mon="Sweet Thief"Qdata=1;Qname="ChocQuest2"NameMon="Sweet Thief"PosQ=CFrame.new(150.5066375732422,30.693693161010742,-12774.5029296875)PosM=CFrame.new(165.1884765625,76.05885314941406,-12600.8369140625)elseif a==2375 or a<=2399 then Mon="Candy Rebel"Qdata=2;Qname="ChocQuest2"NameMon="Candy Rebel"PosQ=CFrame.new(150.5066375732422,30.693693161010742,-12774.5029296875)PosM=CFrame.new(134.86563110351562,77.2476806640625,-12876.5478515625)elseif a==2400 or a<=2449 then Mon="Candy Pirate"Qdata=1;Qname="CandyQuest1"NameMon="Candy Pirate"PosQ=CFrame.new(-1150.0400390625,20.378934860229492,-14446.3349609375)PosM=CFrame.new(-1310.5003662109375,26.016523361206055,-14562.404296875)elseif a==2450 or a<=2474 then Mon="Isle Outlaw"Qdata=1;Qname="TikiQuest1"NameMon="Isle Outlaw"PosQ=CFrame.new(-16548.8164,55.6059914,-172.8125,0.213092566,-0,-0.977032006,0,1,-0,0.977032006,0,0.213092566)PosM=CFrame.new(-16479.900390625,226.6117401123047,-300.3114318847656)elseif a==2475 or a<=2499 then Mon="Island Boy"Qdata=2;Qname="TikiQuest1"NameMon="Island Boy"PosQ=CFrame.new(-16548.8164,55.6059914,-172.8125,0.213092566,-0,-0.977032006,0,1,-0,0.977032006,0,0.213092566)PosM=CFrame.new(-16849.396484375,192.86505126953125,-150.7853240966797)elseif a==2500 or a<=2524 then Mon="Sun-kissed Warrior"Qdata=1;Qname="TikiQuest2"NameMon="kissed Warrior"PosM=CFrame.new(-16347,64,984)PosQ=CFrame.new(-16538,55,1049)elseif a==2525 or a<=2550 then Mon="Isle Champion"Qdata=2;Qname="TikiQuest2"NameMon="Isle Champion"PosQ=CFrame.new(-16541.0215,57.3082275,1051.46118,0.0410757065,-0,-0.999156058,0,1,-0,0.999156058,0,0.0410757065)PosM=CFrame.new(-16602.1015625,130.38734436035156,1087.24560546875)

elseif a >= 2551 and a <= 2574 then

				Mon = "Serpent Hunter"

				Qdata = 1;

				Qname = "TikiQuest3";

				NameMon = "Serpent Hunter"

				PosQ = CFrame.new(-16679.4785, 176.7473, 1474.3995)

				PosM = CFrame.new(-16679.4785, 176.7473, 1474.3995)

			elseif a >= 2575 and a <= 2599 then 

				Mon = "Skull Slayer"

				Qdata = 2;

				Qname = "TikiQuest3";

				NameMon = "Skull Slayer"

				PosQ = CFrame.new(-16759.5898, 71.2837, 1595.3399)

				PosM = CFrame.new(-16759.5898, 71.2837, 1595.3399)



	

			elseif a >= 2600 and a <= 2624 then

				Mon = "Reef Bandit"

				Qdata = 1;

				Qname = "SubmergedQuest1";

				NameMon = "Reef Bandit"

				PosQ = CFrame.new(10882.264, -2086.322, 10034.226) 

				PosM = CFrame.new(10736.6191, -2087.8439, 9338.4882)

			elseif a >= 2625 and a <= 2649 then

				Mon = "Coral Pirate"

				Qdata = 2;

				Qname = "SubmergedQuest1";

				NameMon = "Coral Pirate"

				PosQ = CFrame.new(10882.264, -2086.322, 10034.226)

				PosM = CFrame.new(10965.1025, -2158.8842, 9177.2597)

			elseif a >= 2650 and a <= 2674 then

				Mon = "Sea Chanter"

				Qdata = 1;

				Qname = "SubmergedQuest2";

				NameMon = "Sea Chanter"

				PosQ = CFrame.new(10882.264, -2086.322, 10034.226)

				PosM = CFrame.new(10621.0342, -2087.8440, 10102.0332)

			elseif a >= 2675 and a <= 2699 then

				Mon = "Ocean Prophet"

				Qdata = 2;

				Qname = "SubmergedQuest2";

				NameMon = "Ocean Prophet"

				PosQ = CFrame.new(10882.264, -2086.322, 10034.226)

				PosM = CFrame.new(11056.1445, -2001.6717, 10117.4493)

			elseif a >= 2700 and a <= 2724 then

				Mon = "High Disciple"

				Qdata = 1;

				Qname = "SubmergedQuest3";

				NameMon = "High Disciple"

				PosQ = CFrame.new(9636.52441, -1992.19507, 9609.52832)

				PosM = CFrame.new(9828.087890625, -1940.908935546875, 9693.0634765625)

			elseif a >= 2725 and a <= 2800 then

				Mon = "Grand Devotee"

				Qdata = 2;

				Qname = "SubmergedQuest3";

				NameMon = "Grand Devotee"

				PosQ = CFrame.new(9636.52441, -1992.19507, 9609.52832)

				PosM = CFrame.new(9557.5849609375, -1928.0404052734375, 9859.1826171875)

end end end

MaterialMon=function()local a=game.Players.LocalPlayer;local b=a.Character and a.Character:FindFirstChild("HumanoidRootPart")if not b then return end;shouldRequestEntrance=function(c,d)local e=(b.Position-c).Magnitude;if e>=d then replicated.Remotes.CommF_:InvokeServer("requestEntrance",c)end end;if World1 then if SelectMaterial=="Angel Wings"then MMon={"Shanda","Royal Squad","Royal Soldier","Wysper","Thunder God"}MPos=CFrame.new(-4698,845,-1912)SP="Default"local c=Vector3.new(-4607.82275,872.54248,-1667.55688)shouldRequestEntrance(c,10000)elseif SelectMaterial=="Leather + Scrap Metal"then MMon={"Brute","Pirate"}MPos=CFrame.new(-1145,15,4350)SP="Default"elseif SelectMaterial=="Magma Ore"then MMon={"Military Soldier","Military Spy","Magma Admiral"}MPos=CFrame.new(-5815,84,8820)SP="Default"elseif SelectMaterial=="Fish Tail"then MMon={"Fishman Warrior","Fishman Commando","Fishman Lord"}MPos=CFrame.new(61123,19,1569)SP="Default"local c=Vector3.new(61163.8515625,5.342342376708984,1819.7841796875)shouldRequestEntrance(c,17000)end elseif World2 then if SelectMaterial=="Leather + Scrap Metal"then MMon={"Marine Captain"}MPos=CFrame.new(-2010.5059814453125,73.00115966796875,-3326.620849609375)SP="Default"elseif SelectMaterial=="Magma Ore"then MMon={"Magma Ninja","Lava Pirate"}MPos=CFrame.new(-5428,78,-5959)SP="Default"elseif SelectMaterial=="Ectoplasm"then MMon={"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer"}MPos=CFrame.new(911.35827636719,125.95812988281,33159.5390625)SP="Default"local c=Vector3.new(61163.8515625,5.342342376708984,1819.7841796875)shouldRequestEntrance(c,18000)elseif SelectMaterial=="Mystic Droplet"then MMon={"Water Fighter"}MPos=CFrame.new(-3385,239,-10542)SP="Default"elseif SelectMaterial=="Radioactive Material"then MMon={"Factory Staff"}MPos=CFrame.new(295,73,-56)SP="Default"elseif SelectMaterial=="Vampire Fang"then MMon={"Vampire"}MPos=CFrame.new(-6033,7,-1317)SP="Default"end elseif World3 then if SelectMaterial=="Scrap Metal"then MMon={"Jungle Pirate","Forest Pirate"}MPos=CFrame.new(-11975.78515625,331.7734069824219,-10620.0302734375)SP="Default"elseif SelectMaterial=="Fish Tail"then MMon={"Fishman Raider","Fishman Captain"}MPos=CFrame.new(-10993,332,-8940)SP="Default"elseif SelectMaterial=="Conjured Cocoa"then MMon={"Chocolate Bar Battler","Cocoa Warrior"}MPos=CFrame.new(620.6344604492188,78.93644714355469,-12581.369140625)SP="Default"elseif SelectMaterial=="Dragon Scale"then MMon={"Dragon Crew Archer","Dragon Crew Warrior"}MPos=CFrame.new(6594,383,139)SP="Default"elseif SelectMaterial=="Gunpowder"then MMon={"Pistol Billionaire"}MPos=CFrame.new(-84.8556900024414, 85.62061309814453, 6132.0087890625)SP="Default"elseif SelectMaterial=="Mini Tusk"then MMon={"Mythological Pirate"}MPos=CFrame.new(-13545,470,-6917)SP="Default"elseif SelectMaterial=="Demonic Wisp"then MMon={"Demonic Soul"}MPos=CFrame.new(-9495.6806640625,453.58624267578125,5977.3486328125)SP="Default"end end end

QuestNeta = function()

  local Neta = QuestCheck()

  return {

    [1] = Mon,

    [2] = Qdata,

    [3] = Qname,

    [4] = PosM,

    [5] = NameMon,

    [6] = PosQ

  }

end

task.wait("1.5")

local Fluent = loadstring(game:HttpGet("https://pastefy.app/CqTq3rtS/raw"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local title = "Maru hub [ BETA ACCESS]"
local subtitle = "[ Blox Fruits ]"

local Window = Fluent:CreateWindow({
    Title = title,
    SubTitle = subtitle,
    Size = UDim2.fromOffset(475, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
    TabWidth = 120
})

local Tabs = {
    Status       = Window:AddTab({ Title = "Status",         Icon = "bar-chart" }),
    Settings     = Window:AddTab({ Title = "Farm Settings",  Icon = "wrench" }),
    Main         = Window:AddTab({ Title = "Main",           Icon = "home" }),
    MultiFarm    = Window:AddTab({ Title = "Multi Farm",     Icon = "component" }),
    Quest        = Window:AddTab({ Title = "Quests",          Icon = "scroll" }),
    Quests       = Window:AddTab({ Title = "Items",          Icon = "package" }),
    Mirage         = Window:AddTab({ Title = "Race",           Icon = "star" }),
    SeaEvent     = Window:AddTab({ Title = "Sea Events",     Icon = "waves" }),
    Raids        = Window:AddTab({ Title = "Raid",           Icon = "swords" }),
    Dungeons     = Window:AddTab({ Title = "Dungeon",        Icon = "door-open" }),
    Locations    = Window:AddTab({ Title = "Location",       Icon = "compass" }),
    Fruit        = Window:AddTab({ Title = "Fruits",         Icon = "apple" }),
    Shop         = Window:AddTab({ Title = "Shop",           Icon = "shopping-cart" }),
    Combat       = Window:AddTab({ Title = "PVP",            Icon = "users" }),
    Setting      = Window:AddTab({ Title = "Settings",       Icon = "settings" })
}

Tabs.Status:AddSection("Server Stats")

local StatServer = Tabs.Status:AddParagraph({Title = "Server Time", Content = ""})

Tabs.Status:AddSection("Local Stats")
local StatElite  = Tabs.Status:AddParagraph({Title = "Elite Progress", Content = ""})
local StatKen    = Tabs.Status:AddParagraph({Title = "Ken Level", Content = ""})
local StatCake   = Tabs.Status:AddParagraph({Title = "Cake Prince", Content = ""})

spawn(function()
    while wait(0.5) do
        pcall(function()

            -- Server Time
            local serverTime = math.floor(workspace.DistributedGameTime)
            local mins = math.floor(serverTime / 60)
            local secs = serverTime % 60
            StatServer:SetDesc(mins .. " Minute(s), " .. secs .. " Second(s)")

            -- Elite Progress
            if World3 then
                local eliteVal = replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress")
                StatElite:SetDesc("Elite Progress: " .. tostring(eliteVal))
            else
                StatElite:SetDesc("Elite Progress: N/A")
            end

            -- Ken Level
            local kenVal = plr:GetAttribute("KenDodgesLeft") or 0
            StatKen:SetDesc(tostring(kenVal) .. " / 5000")

            -- Cake Prince
            if World1 or World2 then
                StatCake:SetDesc("N/A")
            else
                local ok, result = pcall(function()
                    return replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner")
                end)
                if ok and result then
                    local killed = string.match(tostring(result), "%d+")
                    if killed then
                        StatCake:SetDesc((500 - tonumber(killed)) .. " / 500")
                    else
                        StatCake:SetDesc("✅ Spawned")
                    end
                else
                    StatCake:SetDesc("N/A")
                end
            end

        end)
    end
end)

 local StatFullMoon = Tabs.Status:AddParagraph({Title = "FullMoon Status", Content = ""})

spawn(function()
  while wait(.2) do
    pcall(function()
      moon8 = "http://www.roblox.com/asset/?id=9709150401"
      moon7 = "http://www.roblox.com/asset/?id=9709150086"
      moon6 = "http://www.roblox.com/asset/?id=9709149680"
      moon5 = "http://www.roblox.com/asset/?id=9709149431"
      moon4 = "http://www.roblox.com/asset/?id=9709149052"
      moon3 = "http://www.roblox.com/asset/?id=9709143733"
      moon2 = "http://www.roblox.com/asset/?id=9709139597"
      moon1 = "http://www.roblox.com/asset/?id=9709135895"
      moon = Getmoon()
      if moon == moon1 then StatFullMoon:SetDesc("Moon : 0 / 8")
      elseif moon == moon2 then StatFullMoon:SetDesc("Moon : 1 / 8")
      elseif moon == moon3 then StatFullMoon:SetDesc("Moon : 2 / 8")
      elseif moon == moon4 then StatFullMoon:SetDesc("Moon : 3 / 8 [ Next Night ]")
      elseif moon == moon5 then StatFullMoon:SetDesc("Moon : 4 / 8 [ Full Moon ]")
      elseif moon == moon6 then StatFullMoon:SetDesc("Moon : 5 / 8 [ Last Night ]")
      elseif moon == moon7 then StatFullMoon:SetDesc("Moon : 6 / 8")
      elseif moon == moon8 then StatFullMoon:SetDesc("Moon : 7 / 8")
      end
    end)
  end
end)

local StatMirage = Tabs.Status:AddParagraph({Title = "Mirage Island Status", Content = ""})

spawn(function()
  while wait(.2) do
    if workspace.Map:FindFirstChild("MysticIsland") or workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") then
      StatMirage:SetDesc("Mirage Island : True")
    else
      StatMirage:SetDesc("Mirage Island : False")
    end
  end
end)

local StatKitsune = Tabs.Status:AddParagraph({Title = "Kitsune Island", Content = ""})
local StatPrehistoric = Tabs.Status:AddParagraph({Title = "Prehistoric Island", Content = ""})
local StatFrozen = Tabs.Status:AddParagraph({Title = "Frozen Dimension", Content = ""})
local StatRip = Tabs.Status:AddParagraph({Title = "Rip_Indra", Content = ""})
local StatLegendarySword = Tabs.Status:AddParagraph({Title = "Legendary Sword", Content = ""})

spawn(function()
    while task.wait(1) do
        pcall(function()

            -- Kitsune Island
            local kitsune =
                workspace:FindFirstChild("Map")
                and workspace.Map:FindFirstChild("KitsuneIsland")

            StatKitsune:SetDesc(tostring(kitsune ~= nil))

            -- Prehistoric Island
            local prehistoric =
                workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island")

            StatPrehistoric:SetDesc(tostring(prehistoric ~= nil))

            -- Frozen Dimension
            local frozen =
                workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension")

            StatFrozen:SetDesc(tostring(frozen ~= nil))

            -- Rip Indra
            local rip =
                game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form")
                or workspace.Enemies:FindFirstChild("rip_indra")

            StatRip:SetDesc(tostring(rip ~= nil))

            -- Legendary Sword Dealer
            local sword = "False"

            if replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1") then
                sword = "Shisui"
            elseif replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2") then
                sword = "Wando"
            elseif replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "3") then
                sword = "Saddi"
            end

            StatLegendarySword:SetDesc(sword)

        end)
    end
end)


Tabs.Main:AddSection("Main")

local FarmLevel = Tabs.Main:AddToggle("FarmLevel", {Title = "Auto Farm Level", Description = "", Default = false})

FarmLevel:OnChanged(function(Value)

  _G.Level = Value

end)

task.spawn(function()
    while task.wait(0.1) do
        if not _G.Level then continue end
        pcall(function()
            local neta       = QuestNeta()
            if not neta then return end

            local mon        = neta[1]
            local questLv    = neta[2]
            local questName  = neta[3]
            local posMon     = neta[4]
            local nameMon    = neta[5]
            local posQuest   = neta[6]

            local questUI    = plr.PlayerGui.Main.Quest
            local questTitle = questUI.Container.QuestTitle.Title.Text

            if not string.find(questTitle, nameMon) then
                replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
            end

            if questUI.Visible == false then
                _tp(posQuest)
                task.wait(0.35)
                if (Root.Position - posQuest.Position).Magnitude <= 25 then
                    replicated.Remotes.CommF_:InvokeServer("StartQuest", questName, questLv)
                end

            elseif questUI.Visible == true then
                if workspace.Enemies:FindFirstChild(mon) then
                    for _, v in ipairs(workspace.Enemies:GetChildren()) do
                        if Attack.Alive(v) and v.Name == mon then
                            if string.find(questTitle, nameMon) then
                                repeat
                                    task.wait()
                                    Attack.Kill(v, _G.Level)
                                until not _G.Level
                                    or v.Humanoid.Health <= 0
                                    or not v.Parent
                                    or questUI.Visible == false
                            else
                                replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                            end
                            break
                        end
                    end
                else
                    _tp(posMon)
                    if replicated:FindFirstChild(mon) then
                        _tp(replicated:FindFirstChild(mon).HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                    end
                end
            end
        end)
    end
end)


Tabs.Main:AddSection("World Quest")
local AutoDressrosa = Tabs.Main:AddToggle("AutoDressrosa", {
    Title = "Auto Dressrosa Quest",
    Description = "",
    Default = false
})
AutoDressrosa:OnChanged(function(Value)
    _G.AutoDressrosa = Value
end)

task.spawn(function()
    while task.wait(0.3) do
        if not _G.AutoDressrosa then continue end
        local player = game.Players.LocalPlayer
        local CommF = game:GetService("ReplicatedStorage").Remotes.CommF_
        local char = player.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        pcall(function()
            if game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
    Fluent:Notify({
    Title = "Auto Sea 2",
    Content = "đã qua sea 2",
    Duration = 5 -- Thời gian hiển thị (giây), để nil là không tự tắt
})
                _G.AutoDressrosa = false
                return
            end
            if game.PlaceId ~= 2753915549 and game.PlaceId ~= 85211729168715 then
                return
            end
            if player.Data.Level.Value < 700 then
    Fluent:Notify({
    Title = "Auto Sea 2",
    Content = "Cần level 700 để làm nhiệm vụ",
    Duration = 5 -- Thời gian hiển thị (giây), để nil là không tự tắt
})
                _G.AutoDressrosa = false
                return
            end
            local iceDoor = workspace.Map:FindFirstChild("Ice") and workspace.Map.Ice:FindFirstChild("Door")
            if not iceDoor then return end
            if iceDoor.CanCollide == false and iceDoor.Transparency == 1 then
    Fluent:Notify({
    Title = "Auto Sea 2",
    Content = "nhiệm vụ đã xong đang qua...",
    Duration = 5 -- Thời gian hiển thị (giây), để nil là không tự tắt
})
                if _tp then _tp(CFrame.new(4849.29, 5.65, 719.61)) end
                task.wait(0.5)
                CommF:InvokeServer("TravelDressrosa")
                task.wait(2)
                return
            end
            if iceDoor.CanCollide == true and iceDoor.Transparency == 0 then
                CommF:InvokeServer("DressrosaQuestProgress", "Detective")
                task.wait(0.2)
                local hasKey = player.Backpack:FindFirstChild("Key") or (char and char:FindFirstChild("Key"))
                if hasKey then
    Fluent:Notify({
    Title = "Auto Sea 2",
    Content = "đã có chìa khóa đang hoàn thành..",
    Duration = 5 -- Thời gian hiển thị (giây), để nil là không tự tắt
})
                    if _tp then _tp(CFrame.new(5191.86, 2.84, 686.44)) end
                    task.wait(0.5)
                    CommF:InvokeServer("DressrosaQuestProgress", "Detective")
                    task.wait(1)
                    if EquipWeapon then EquipWeapon("Key") end
                    if _tp then _tp(CFrame.new(1347.71, 37.38, -1325.65)) end
                    task.wait(0.5)
                    iceDoor = workspace.Map.Ice and workspace.Map.Ice:FindFirstChild("Door")
                    if iceDoor and iceDoor.CanCollide == false then
    Fluent:Notify({
    Title = "Auto Sea 2",
    Content = "đã hoàn thành..",
    Duration = 5 -- Thời gian hiển thị (giây), để nil là không tự tắt
})
                        CommF:InvokeServer("TravelDressrosa")
                        task.wait(2)
                    end
                    return
                end
                local progress = CommF:InvokeServer("DressrosaQuestProgress", "Detective")
                if progress == nil or progress == 0 then
    Fluent:Notify({
    Title = "Auto Sea 2",
    Content = "đang làm...",
    Duration = 5 -- Thời gian hiển thị (giây), để nil là không tự tắt
})
                    if _tp then _tp(CFrame.new(5191.86, 2.84, 686.44)) end
                    task.wait(0.5)
                    CommF:InvokeServer("DressrosaQuestProgress", "Detective")
                    task.wait(1.5)
                    return
                end
                local boss = GetConnectionEnemies and GetConnectionEnemies("Ice Admiral")
                if boss and boss:FindFirstChild("HumanoidRootPart") then
                    local rootPart = boss.HumanoidRootPart
                    local hum = boss:FindFirstChild("Humanoid")
                    if (hrp.Position - rootPart.Position).Magnitude > 15 then
                        if _tp then _tp(rootPart.CFrame * CFrame.new(2, 10, 2)) end
                        task.wait(0.2)
                    end
                    if not char:FindFirstChild("HasBuso") then
                        CommF:InvokeServer("Buso")
                    end
                    if EquipWeapon then EquipWeapon(getgenv().SelectWeapon or "Melee") end
                    rootPart.CanCollide = false
                    if hum then hum.WalkSpeed = 0 end
                    if boss:FindFirstChild("Head") then boss.Head.CanCollide = false end
                    if type(Attack) == "table" and type(Attack.Kill) == "function" then
                        Attack.Kill(boss, _G.AutoDressrosa)
                    end
                    if player.Backpack:FindFirstChild("Key") or (char and char:FindFirstChild("Key")) then
    Fluent:Notify({
    Title = "Auto Sea 2",
    Content = "đã có key",
    Duration = 5 -- Thời gian hiển thị (giây), để nil là không tự tắt
})
                        CommF:InvokeServer("DressrosaQuestProgress", "Detective")
                        task.wait(0.5)
                    end
                else
    Fluent:Notify({
    Title = "Auto Sea 2",
    Content = "đang đợi boss",
    Duration = 5 -- Thời gian hiển thị (giây), để nil là không tự tắt
})
                    if _tp then _tp(CFrame.new(1347.71, 37.38, -1325.65)) end
                    task.wait(0.5)
                    CommF:InvokeServer("DressrosaQuestProgress", "Detective")
                    task.wait(1)
                end
            end
        end)
    end
end)

local AutoZou = Tabs.Main:AddToggle("AutoZou", {
    Title = "Auto Zou Quest",
    Description = "",
    Default = false
})
AutoZou:OnChanged(function(Value)
    _G.AutoZou = Value
end)

task.spawn(function()
    while task.wait(0.3) do
        if not _G.AutoZou then continue end
        local player = game.Players.LocalPlayer
        local CommF = game:GetService("ReplicatedStorage").Remotes.CommF_
        local char = player.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        pcall(function()
            if game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
                ThongBao("Bạn đã ở Sea 3 rồi", 2)
                _G.AutoZou = false
                return
            end
            if game.PlaceId ~= 4442272183 and game.PlaceId ~= 79091703265657 then
                return
            end
            if player.Data.Level.Value < 1500 then
                ThongBao("Cần level 1500+ để sang Sea 3", 3)
                _G.AutoZou = false
                return
            end
            local bartiloProgress = CommF:InvokeServer("BartiloQuestProgress", "Bartilo")
            if bartiloProgress == 0 then
                if player.PlayerGui.Main.Quest.Visible and string.find(player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") then
                    local v = GetConnectionEnemies and GetConnectionEnemies("Swan Pirate")
                    if v and v:FindFirstChild("HumanoidRootPart") then
                        if (hrp.Position - v.HumanoidRootPart.Position).Magnitude > 15 then
                            if _tp then _tp(v.HumanoidRootPart.CFrame * CFrame.new(2, 10, 2)) end
                            task.wait(0.2)
                        end
                        if EquipWeapon then EquipWeapon(getgenv().SelectWeapon or "Melee") end
                        if type(Attack) == "table" and type(Attack.Kill) == "function" then
                            Attack.Kill(v, _G.AutoZou)
                        end
                    else
                        if _tp then _tp(CFrame.new(1057.93, 137.61, 1242.08)) end
                    end
                else
                    if _tp then _tp(CFrame.new(-456.29, 73.02, 299.90)) end
                    task.wait(0.5)
                    CommF:InvokeServer("StartQuest", "BartiloQuest", 1)
                    task.wait(0.5)
                end
                return
            elseif bartiloProgress == 1 then
                local v = GetConnectionEnemies and GetConnectionEnemies("Jeremy")
                if v and v:FindFirstChild("HumanoidRootPart") then
                    if (hrp.Position - v.HumanoidRootPart.Position).Magnitude > 15 then
                        if _tp then _tp(v.HumanoidRootPart.CFrame * CFrame.new(2, 10, 2)) end
                        task.wait(0.2)
                    end
                    if EquipWeapon then EquipWeapon(getgenv().SelectWeapon or "Melee") end
                    if type(Attack) == "table" and type(Attack.Kill) == "function" then
                        Attack.Kill(v, _G.AutoZou)
                    end
                else
                    if _tp then _tp(CFrame.new(2099.88, 448.93, 648.00)) end
                end
                return
            elseif bartiloProgress == 2 then
                ThongBao("Đang chạy puzzle Bartilo", 3)
                local plates = {
                    CFrame.new(-1850.49, 13.18, 1750.90),
                    CFrame.new(-1858.87, 19.38, 1712.02),
                    CFrame.new(-1803.94, 16.58, 1750.90),
                    CFrame.new(-1858.56, 16.86, 1724.80),
                    CFrame.new(-1869.54, 15.99, 1681.01),
                    CFrame.new(-1800.10, 16.50, 1684.52),
                    CFrame.new(-1819.26, 14.80, 1717.91),
                    CFrame.new(-1813.52, 14.86, 1724.80)
                }
                for _, cf in ipairs(plates) do
                    if not _G.AutoZou then break end
                    if type(notween) == "function" then
                        notween(cf)
                    elseif hrp then
                        hrp.CFrame = cf
                    end
                    task.wait(0.1)
                end
                return
            elseif bartiloProgress == 3 then
                if CommF:InvokeServer("GetUnlockables").FlamingoAccess == nil then
                    ThongBao("Đang mở cửa Don Swan", 3)
                    local fruitStore = {}
                    local invFruits = CommF:InvokeServer("getInventoryFruits")
                    if invFruits then
                        for _, v in pairs(invFruits) do
                            if type(v) == "table" and v.Name then
                                table.insert(fruitStore, v.Name)
                            end
                        end
                    end
                    local fruitOpen = {}
                    local allFruits = CommF:InvokeServer("GetFruits")
                    if allFruits then
                        for _, v in pairs(allFruits) do
                            if v.Price and v.Price >= 1000000 then
                                table.insert(fruitOpen, v.Name)
                            end
                        end
                    end
                    for _, fruitDoor in pairs(fruitOpen) do
                        for _, fruitStored in pairs(fruitStore) do
                            if fruitDoor == fruitStored then
                                if not player.Backpack:FindFirstChild(fruitStored) then
                                    CommF:InvokeServer("LoadFruit", fruitStored)
                                else
                                    CommF:InvokeServer("TalkTrevor", "1")
                                    CommF:InvokeServer("TalkTrevor", "2")
                                    CommF:InvokeServer("TalkTrevor", "3")
                                end
                            end
                        end
                    end
                    CommF:InvokeServer("TalkTrevor", "1")
                    CommF:InvokeServer("TalkTrevor", "2")
                    CommF:InvokeServer("TalkTrevor", "3")
                    return
                end
                local zProgress = CommF:InvokeServer("ZQuestProgress", "Check")
                if zProgress == 0 then
                    ThongBao("Bắt đầu ZQuest", 3)
                    CommF:InvokeServer("ZQuestProgress", "Begin")
                    task.wait(1)
                    return
                elseif zProgress == 1 then
                    local v = GetConnectionEnemies and GetConnectionEnemies("rip_indra")
                    if v and v:FindFirstChild("HumanoidRootPart") then
                        if (hrp.Position - v.HumanoidRootPart.Position).Magnitude > 15 then
                            if _tp then _tp(v.HumanoidRootPart.CFrame * CFrame.new(2, 10, 2)) end
                            task.wait(0.2)
                        end
                        if EquipWeapon then EquipWeapon(getgenv().SelectWeapon or "Melee") end
                        if type(Attack) == "table" and type(Attack.Kill) == "function" then
                            Attack.Kill(v, _G.AutoZou)
                        end
                    else
                        if _tp then _tp(CFrame.new(-26880.93, 22.85, 473.19)) end
                    end
                    return
                elseif zProgress == 2 then
                    ThongBao("Đang sang Sea 3", 3)
                    CommF:InvokeServer("TravelZou")
                    task.wait(2)
                    return
                end
            end
        end)
    end
end)
Tabs.Main:AddSection("Miscellanea / Quest")

Test = Tabs.Main:AddDropdown("Test",{Title = "Choose Material",Values = MaterialList,Multi = false,Default = nil})

Test:OnChanged(function(Value)

  getgenv().SelectMaterial = Value

end)

Toggle = Tabs.Main:AddToggle("Toggle", {Title = "Auto Materials", Description = "", Default = false})

Toggle:OnChanged(function(Value)

    getgenv().AutoMaterial = Value

end)

spawn(function()

  local function processEnemy(v, EnemyName)

    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then

      if v.Name == EnemyName then repeat wait() Attack.Kill(v,getgenv().AutoMaterial) until not getgenv().AutoMaterial or not v.Parent or v.Humanoid.Health <= 0 end

    end

  end

  local function handleEnemySpawns()

    for _, v in pairs(game:GetService("Workspace")["_WorldOrigin"].EnemySpawns:GetChildren()) do

      for _, EnemyName in ipairs(MMon) do

        if string.find(v.Name, EnemyName) then

          if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude >= 10 then

            _tp(v.CFrame * Pos)

          end

        end

      end

    end

  end

  while wait() do

    if getgenv().AutoMaterial then

      pcall(function()

        if getgenv().SelectMaterial then MaterialMon(getgenv().SelectMaterial) _tp(MPos) end

        for _, EnemyName in ipairs(MMon) do

          for _, v in pairs(workspace.Enemies:GetChildren()) do processEnemy(v, EnemyName) end

        end

        handleEnemySpawns()

      end)

    end

  end

end)

local Q = Tabs.Main:AddToggle("Q", {Title = "Auto Farm Ectoplasm", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoEctoplasm = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.AutoEctoplasm then

        local EctoTable = {"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior"}    

        local v = GetConnectionEnemies(EctoTable)

		if Attack.Alive(v) then

		  repeat wait() Attack.Kill(v, _G.AutoEctoplasm)until not _G.AutoEctoplasm or not v.Parent or v.Humanoid.Health <= 0		        

	    else

	      replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))

	    end

      end

    end)

  end

end)

local Q = Tabs.Main:AddToggle("Q", {Title = "Auto Training Dummy", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.DummyMan = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.DummyMan then

      pcall(function()

        if plr.PlayerGui.Main.Quest.Visible == false then	

          local xxx = {[1] = "ArenaTrainer"}

	      replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(xxx))

        else

          local v = GetConnectionEnemies("Training Dummy")

          if v then

		    repeat wait() Attack.Kill(v,_G.DummyMan) until not _G.DummyMan or not v.Parent or v.Humanoid.Health <= 0

	      else

	        _tp(CFrame.new(3688.005126953125, 12.746943473815918, 170.20953369140625))

	      end

	    end

      end)

    end

  end

end)

local Berry = Tabs.Main:AddToggle("Berry", {Title = "Auto Collect Berry", Description = "", Default = false})

Berry:OnChanged(function(Value)

  _G.AutoBerry = Value

end)

spawn(function()
    while task.wait(Sec) do
        if _G.AutoBerry then
            local CollectionService = game:GetService("CollectionService")
            local BerryBush = CollectionService:GetTagged("BerryBush")

            for _, Bush in ipairs(BerryBush) do
                if Bush and Bush.Parent then
                    for _, BerryName in pairs(Bush:GetChildren()) do
                        if not BerryArray or table.find(BerryArray, BerryName.Name) then
                            local Prompt = BerryName:FindFirstChildOfClass("ProximityPrompt")

                            if Prompt then
                                _tp(BerryName:GetPivot())
                                fireproximityprompt(Prompt, math.huge)
                            end
                        end
                    end
                end
            end
        end
    end
end)

Tabs.Main:AddSection("Cake Prince")

local Q = Tabs.Main:AddToggle("Q", {Title = "Auto Farm Dough Boss", Description = "", Default = false})

Q:OnChanged(function(Value)
  _G.Auto_Cake_Prince = Value
end)

spawn(function()
  while wait() do
    if _G.Auto_Cake_Prince then
      pcall(function()
        local player = game.Players.LocalPlayer
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local questUI = player.PlayerGui.Main.Quest
        local enemies = workspace:FindFirstChild("Enemies")
        
        local mapCakeLoaf = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("CakeLoaf")
        local bigMirror = mapCakeLoaf and mapCakeLoaf:FindFirstChild("BigMirror")

        if not root then return end

        if not bigMirror then 
          _tp(CFrame.new(-2077, 252, -12373))
          return 
        end

        local otherPart = bigMirror:FindFirstChild("Other")

        if not otherPart then
          _tp(CFrame.new(-2077, 252, -12373))
          return
        end

        if otherPart.Transparency == 0 or (enemies and enemies:FindFirstChild("Cake Prince")) then
          local v = GetConnectionEnemies("Cake Prince")

          if v then
            repeat wait()
              Attack.Kill2(v, _G.Auto_Cake_Prince)
            until not _G.Auto_Cake_Prince 
            or not v.Parent 
            or v.Humanoid.Health <= 0
          else
            _tp(CFrame.new(-2151.82, 149.32, -12404.91))
          end

        else

          local CakePrince = {
            "Cookie Crafter",
            "Cake Guard",
            "Baking Staff",
            "Head Baker"
          }

          local v = GetConnectionEnemies(CakePrince)

          if v then

            if _G.AcceptQuestC and not questUI.Visible then

              local questPos = CFrame.new(-1927.92, 37.8, -12842.54)

              _tp(questPos)

              local timeout = 0

              while root and (questPos.Position - root.Position).Magnitude > 50 and timeout < 50 do
                wait(0.2)
                timeout = timeout + 1
              end

              local randomQuest = math.random(1, 4)

              local questData = {
                [1] = {"StartQuest", "CakeQuest2", 2},
                [2] = {"StartQuest", "CakeQuest2", 1},
                [3] = {"StartQuest", "CakeQuest1", 1},
                [4] = {"StartQuest", "CakeQuest1", 2}
              }

              pcall(function()
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(questData[randomQuest]))
              end)
            end

            repeat wait()
              Attack.Kill(v, _G.Auto_Cake_Prince)
            until not _G.Auto_Cake_Prince
            or not v.Parent
            or v.Humanoid.Health <= 0
            or otherPart.Transparency == 0
            or (_G.AcceptQuestC and not questUI.Visible)

          else

            local nearMob = false

            if enemies and root then
              for _,mob in pairs(enemies:GetChildren()) do
                local hum = mob:FindFirstChild("Humanoid")
                local mobRoot = mob:FindFirstChild("HumanoidRootPart")

                if hum and mobRoot and hum.Health > 0 then
                  if (mobRoot.Position - root.Position).Magnitude <= 50 then
                    nearMob = true
                    break
                  end
                end
              end
            end

            if not nearMob then
              _tp(CFrame.new(-2077, 252, -12373))
            end

          end
        end
      end)
    end
  end
end)

local Q = Tabs.Main:AddToggle("Q", {Title = "Farm Cake Quest", Description = "", Default = false})

Q:OnChanged(function(Value)
  _G.Auto_Cake_Prince = Value
end)

spawn(function()
  while wait() do
    if _G.Auto_Cake_Prince then
      pcall(function()
        local player = game.Players.LocalPlayer
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local questUI = player.PlayerGui.Main.Quest
        local enemies = workspace:FindFirstChild("Enemies")

        local mapCakeLoaf = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("CakeLoaf")
        local bigMirror = mapCakeLoaf and mapCakeLoaf:FindFirstChild("BigMirror")

        if not root then return end

        if not bigMirror then
          _tp(CFrame.new(-2077,252,-12373))
          return
        end

        local otherPart = bigMirror:FindFirstChild("Other")

        if not otherPart then
          _tp(CFrame.new(-2077,252,-12373))
          return
        end

        getgenv().BringMonster = true

        local CakePrince = {
          "Cookie Crafter",
          "Cake Guard",
          "Baking Staff",
          "Head Baker"
        }

        local v = GetConnectionEnemies(CakePrince)

        if v then

          if _G.AcceptQuestC and not questUI.Visible then

            local questPos = CFrame.new(-1927.92,37.8,-12842.54)

            _tp(questPos)

            local timeout = 0

            while root and (questPos.Position - root.Position).Magnitude > 50 and timeout < 50 do
              wait(0.2)
              timeout = timeout + 1
            end

            local randomQuest = math.random(1,4)

            local questData = {
              [1] = {"StartQuest","CakeQuest2",2},
              [2] = {"StartQuest","CakeQuest2",1},
              [3] = {"StartQuest","CakeQuest1",1},
              [4] = {"StartQuest","CakeQuest1",2}
            }

            pcall(function()
              game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(questData[randomQuest]))
            end)
          end

          repeat wait()
            Attack.Kill(v,_G.Auto_Cake_Prince)
          until not _G.Auto_Cake_Prince
          or not v.Parent
          or v.Humanoid.Health <= 0

        else

          local nearMob = false

          if enemies and root then
            for _,mob in pairs(enemies:GetChildren()) do
              local hum = mob:FindFirstChild("Humanoid")
              local mobRoot = mob:FindFirstChild("HumanoidRootPart")

              if hum and mobRoot and hum.Health > 0 then
                if (mobRoot.Position - root.Position).Magnitude <= 50 then
                  nearMob = true
                  break
                end
              end
            end
          end

          if not nearMob then
            _tp(CFrame.new(-2077,252,-12373))
          end

        end
      end)
    end
  end
end)
Tabs.Main:AddSection("Bone")

local Q = Tabs.Main:AddToggle("Q", {Title = "Auto Farm Bone", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoFarm_Bone = Value

end)

spawn(function()

  while wait(Sec) do 

    if _G.AutoFarm_Bone then

      pcall(function()        

        local player = game.Players.LocalPlayer

        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

        local questUI = player.PlayerGui.Main.Quest

        local BonesTable = {"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"}

        if not root then return end

        local bone = GetConnectionEnemies(BonesTable)

        if bone then

	      if _G.AcceptQuestC and not questUI.Visible then

            local questPos = CFrame.new(-9516.99316,172.017181,6078.46533,0,0,-1,0,1,0,1,0,0)

            _tp(questPos)

            while (questPos.Position - root.Position).Magnitude > 50 do

              wait(0.2)

            end

            local randomQuest = math.random(1, 4)

            local questData = {

              [1] = {"StartQuest", "HauntedQuest2", 2},

              [2] = {"StartQuest", "HauntedQuest2", 1},

              [3] = {"StartQuest", "HauntedQuest1", 1},

              [4] = {"StartQuest", "HauntedQuest1", 2}

            }                    

            local success, response = pcall(function()

              return game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(questData[randomQuest]))

            end)

          end

		  repeat task.wait()
            Attack.Kill(bone, _G.AutoFarm_Bone)
          until not _G.AutoFarm_Bone
          or bone.Humanoid.Health <= 0
          or not bone.Parent
          or (_G.AcceptQuestC and not questUI.Visible)

        else

          local nearMob = false

          local enemies = workspace:FindFirstChild("Enemies")

          if enemies and root then
            for _,mob in pairs(enemies:GetChildren()) do
              local hum = mob:FindFirstChild("Humanoid")
              local mobRoot = mob:FindFirstChild("HumanoidRootPart")

              if hum and mobRoot and hum.Health > 0 then
                if (mobRoot.Position - root.Position).Magnitude <= 50 then
                  nearMob = true
                  break
                end
              end
            end
          end

          if not nearMob then
            _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
          end

        end

      end)

    end

  end

end)
local Q = Tabs.Main:AddToggle("Q", {Title = "Farm Bone Quest", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AcceptQuestC = Value

end)          

Tabs.Main:AddSection("Mastery")

local posMastery = {"Cake","Bone"}

local Mastery_Config = Tabs.Main:AddDropdown("Mastery_Config",{Title = "Select Method",Values = posMastery,Multi = false,Default = 1})

Mastery_Config:OnChanged(function(Value)

  SelectIsland = Value

end)

local MasteryGun = Tabs.Main:AddToggle("MasteryGun", {Title = "Auto Farm Gun Mastery", Description = "", Default = false})

MasteryGun:OnChanged(function(Value)

  _G.FarmMastery_G = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.FarmMastery_G then

      pcall(function()

        if SelectIsland == "Cake" then

          local v = GetConnectionEnemies(mastery1)

		  if v then		      

		    HealthM = v.Humanoid.MaxHealth * 70 / 100

		    repeat wait()

		      MousePos = v.HumanoidRootPart.Position

		      Attack.Masgun(v,_G.FarmMastery_G)

		      local Modules = replicated:FindFirstChild("Modules")

              local Net = Modules:FindFirstChild("Net")

              local RE_ShootGunEvent = Net:FindFirstChild("RE/ShootGunEvent")    

              if plr.Character:FindFirstChildOfClass("Tool").ToolTip ~= "Gun" then return end

              if plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").Name == 'Skull Guitar' then

                SoulGuitar = true

		        plr.Character:FindFirstChildOfClass("Tool").RemoteEvent:FireServer("TAP", MousePos)

		        if _G.FarmMastery_G then

		          vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1);wait(0.05)

                  vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1);wait(0.05)

                end

		      elseif plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").Name ~= 'Skull Guitar' then

		        SoulGuitar = false

		        RE_ShootGunEvent:FireServer(MousePos, { v.HumanoidRootPart })

		        if _G.FarmMastery_G then

		          vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1);wait(0.05)

                  vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1);wait(0.05)

                end

		      end		            		

		    until _G.FarmMastery_G == false or v.Humanoid.Health <= 0 or not v.Parent    

		    SoulGuitar = false     		         		        

		  else

		    _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) 		    

	  	  end

		elseif SelectIsland == "Bone" then

          local v = GetConnectionEnemies(mastery2)

		  if v then		      

		    HealthM = v.Humanoid.MaxHealth * 70 / 100

		    repeat wait()

		      MousePos = v.HumanoidRootPart.Position

		      Attack.Masgun(v,_G.FarmMastery_G)

		      local Modules = replicated:FindFirstChild("Modules")

              local Net = Modules:FindFirstChild("Net")

              local RE_ShootGunEvent = Net:FindFirstChild("RE/ShootGunEvent")    

              if plr.Character:FindFirstChildOfClass("Tool").ToolTip ~= "Gun" then return end

              if plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").Name == 'Skull Guitar' then

                SoulGuitar = true

		        plr.Character:FindFirstChildOfClass("Tool").RemoteEvent:FireServer("TAP", MousePos)

		        if _G.FarmMastery_G then

		          vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1);wait(0.05)

                  vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1);wait(0.05)

                end

		      elseif plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").Name ~= 'Skull Guitar' then

		        SoulGuitar = false

		        RE_ShootGunEvent:FireServer(MousePos, { v.HumanoidRootPart })

		        if _G.FarmMastery_G then

		          vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1);wait(0.05)

                  vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1);wait(0.05)

                end

		      end		            		

		    until _G.FarmMastery_G == false or v.Humanoid.Health <= 0 or not v.Parent    

		    SoulGuitar = false     		         		        

		  else

		    _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) 

	  	  end

        end

      end)

    end

  end

end)

local MasteryFruits = Tabs.Main:AddToggle("MasteryFruits", {Title = "Auto Farm Fruit Mastery", Description = "", Default = false})

MasteryFruits:OnChanged(function(Value)

  _G.FarmMastery_Dev = Value

end)

spawn(function()RunSer.RenderStepped:Connect(function() pcall(function()if _G.FarmMastery_Dev or _G.FarmMastery_G or _G.FarmMastery_S then for a,b in pairs(plr.PlayerGui.Notifications:GetChildren())do if b.Name=="NotificationTemplate"then if string.find(b.Text,"Skill locked!")then b:Destroy()end end end end end)end) end)

spawn(function()

  while wait(Sec) do

    if _G.FarmMastery_Dev then

      pcall(function()

        if SelectIsland == "Cake" then         

          local v = GetConnectionEnemies(mastery1)

		  if v then		   

		    HealthM = v.Humanoid.MaxHealth * 70 / 100

		    repeat wait()

		      MousePos = v.HumanoidRootPart.Position

		      Attack.Mas(v,_G.FarmMastery_Dev)

		    until _G.FarmMastery_Dev == false or v.Humanoid.Health <= 0 or not v.Parent         		         		        

		  else

		    _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) 

		  end

		elseif SelectIsland == "Bone" then

          local v = GetConnectionEnemies(mastery2)

		  if v then		

		    HealthM = v.Humanoid.MaxHealth * 70 / 100

		    repeat wait()

		      MousePos = v.HumanoidRootPart.Position

		      Attack.Mas(v,_G.FarmMastery_Dev)

		    until _G.FarmMastery_Dev == false or v.Humanoid.Health <= 0 or not v.Parent		        

		  else

		    _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) 		    

		  end

        end

      end)

    end

  end

end)

Tabs.Main:AddSection("Chest") 

local Chest = Tabs.Main:AddToggle("Chest", {
    Title = "Hop Farm Chest",
    Description = "",
    Default = false
})

Chest:OnChanged(function(Value)
    _G.AutoFarmChest = Value
end)

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local function HopServer()
    local Success, Result = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
    end)

    if Success then
        local Data = HttpService:JSONDecode(Result)

        local Servers = {}
        for _, v in ipairs(Data.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(Servers, v.id)
            end
        end

        if #Servers > 0 then
            TeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                Servers[math.random(1, #Servers)],
                Players.LocalPlayer
            )
        end
    end
end

spawn(function()
    while task.wait(Sec) do
        if _G.AutoFarmChest then
            pcall(function()
                local Player = Players.LocalPlayer
                local Character = Player.Character or Player.CharacterAdded:Wait()
                if not Character then return end

                local Position = Character:GetPivot().Position
                local Chests = CollectionService:GetTagged("_ChestTagged")

                local Distance, Nearest = math.huge, nil

                for _, Chest in ipairs(Chests) do
                    local Magnitude = (Chest:GetPivot().Position - Position).Magnitude

                    if (not SelectedIsland or Chest:IsDescendantOf(SelectedIsland))
                        and not Chest:GetAttribute("IsDisabled")
                        and Magnitude < Distance then
                        Distance = Magnitude
                        Nearest = Chest
                    end
                end

                if Nearest then
                    _tp(Nearest:GetPivot())
                else
                    HopServer()
                end
            end)
        end
    end
end)

local Chest = Tabs.Main:AddToggle("Chest", {
    Title = "Auto Farm Chest",
    Description = "[ Beta ]",
    Default = false
})

Chest:OnChanged(function(Value)
    _G.AutoFarmChest = Value
end)

spawn(function()
    local CollectionService = game:GetService("CollectionService")
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")

    local Player = Players.LocalPlayer

    local TWEEN_SPEED = 300
    local HEIGHT_OFFSET = 3
    local CHECK_DELAY = 0.15

    local function GetRoot()
        local Character = Player.Character
        if not Character then
            return nil
        end

        return Character:FindFirstChild("HumanoidRootPart")
    end

    local function GetChestPosition(Chest)
        local Success, Result = pcall(function()
            return Chest:GetPivot()
        end)

        if Success and Result then
            return Result
        end

        if Chest:IsA("BasePart") then
            return Chest.CFrame
        end

        return nil
    end

    local function TweenTo(CFrame)
        local Root = GetRoot()
        if not Root then
            return false
        end

        local Target = CFrame + Vector3.new(0, HEIGHT_OFFSET, 0)
        local Distance = (Root.Position - Target.Position).Magnitude

        if Distance <= 5 then
            Root.CFrame = Target
            return true
        end

        local Time = math.max(Distance / TWEEN_SPEED, 0.05)

        local Tween = TweenService:Create(
            Root,
            TweenInfo.new(
                Time,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out
            ),
            {
                CFrame = Target
            }
        )

        Tween:Play()

        while Tween.PlaybackState == Enum.PlaybackState.Playing do
            if not _G.AutoFarmChest then
                Tween:Cancel()
                return false
            end

            if not GetRoot() then
                Tween:Cancel()
                return false
            end

            task.wait()
        end

        return true
    end

    local function GetNearestChest()
        local Root = GetRoot()
        if not Root then
            return nil
        end

        local Nearest = nil
        local NearestDistance = math.huge

        for _, Chest in ipairs(
            CollectionService:GetTagged("_ChestTagged")
        ) do
            if Chest
                and Chest.Parent
                and not Chest:GetAttribute("IsDisabled") then

                local ChestCFrame = GetChestPosition(Chest)

                if ChestCFrame then
                    local Distance =
                        (Root.Position - ChestCFrame.Position).Magnitude

                    if Distance < NearestDistance then
                        NearestDistance = Distance
                        Nearest = {
                            Object = Chest,
                            CFrame = ChestCFrame,
                            Distance = Distance
                        }
                    end
                end
            end
        end

        return Nearest
    end

    while task.wait(CHECK_DELAY) do
        if not _G.AutoFarmChest then
            continue
        end

        pcall(function()
            local Chest = GetNearestChest()

            if not Chest then
                return
            end

            if not _G.AutoFarmChest then
                return
            end

            TweenTo(Chest.CFrame)

            task.wait(0.1)

            -- Đánh dấu tạm để không chọn lại ngay
            if Chest.Object and Chest.Object.Parent then
                Chest.Object:SetAttribute(
                    "IsDisabled",
                    true
                )
            end
        end)
    end
end)

Tabs.Main:AddSection("Mob")

local ClosetMons = Tabs.Main:AddToggle("ClosetMons", {Title = "Mob Aura", Description = "", Default = false})

ClosetMons:OnChanged(function(Value)

  _G.AutoFarmNear = Value

end)

spawn(function()

  while wait() do

    pcall(function()

      if _G.AutoFarmNear then

        for i,v in pairs(workspace.Enemies:GetChildren()) do

          if v:FindFirstChild("Humanoid") or v:FindFirstChild("HumanoidRootPart") then

            if v.Humanoid.Health > 0 then

              repeat wait() Attack.Kill(v,_G.AutoFarmNear) until not _G.AutoFarmNear or not v.Parent or v.Humanoid.Health <= 0

            end

          end

        end

      end

    end)

  end

end)

Tabs.Quests:AddSection("Buso/Aura Colours")

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Teleport Barista Cousin", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Tp_MasterA = Value

end)

spawn(function()

  while wait() do

    if _G.Tp_MasterA then

	  pcall(function()

	    for _,v in pairs(replicated.NPCs:GetChildren()) do

	    if v.Name == "Barista Cousin" then _tp(v.HumanoidRootPart.CFrame) end

        end   	   

	 end)

    end

  end

end)

Tabs.Quests:AddButton({Title = "Buy Buso Colors", Description = "",

Callback = function()

  replicated.Remotes.CommF_:InvokeServer("ColorsDealer","2")

end})

Tabs.Mirage:AddSection("Upgrade Races V3")

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Upgrade Mink V3", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Auto_Mink = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.Auto_Mink then

        if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") ~= 2 then

          if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 0 then

            replicated.Remotes.CommF_:InvokeServer("Alchemist","2")

          elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 1 then

            if not plr.Backpack:FindFirstChild("Flower 1") and not plr.Character:FindFirstChild("Flower 1") then

              _tp(workspace.Flower1.CFrame)

            elseif not plr.Backpack:FindFirstChild("Flower 2") and not plr.Character:FindFirstChild("Flower 2") then

              _tp(workspace.Flower2.CFrame)

            elseif not plr.Backpack:FindFirstChild("Flower 3") and not plr.Character:FindFirstChild("Flower 3") then

              local v = GetConnectionEnemies("Swan Pirate")

              if v then repeat wait() Attack.Kill(v,_G.Auto_Mink) until GetBP("Flower 3") or not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_Mink == false

              else _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))end            

            end        

          elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 2 then

	        replicated.Remotes.CommF_:InvokeServer("Alchemist","3")

	      end

        elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 0 then

          replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","2")

        elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 1 then

		  _G.AutoFarmChest = true

	    else

	      _G.AutoFarmChest = false

        end

      end

    end)

  end

end)

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Upgrade Human V3", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Auto_Human = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.Auto_Human then

        if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") ~= -2 then

	     if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 0 then

		  replicated.Remotes.CommF_:InvokeServer("Alchemist","2")

		elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 1 then

		  if not plr.Backpack:FindFirstChild("Flower 1") and not plr.Character:FindFirstChild("Flower 1") then

		    _tp(workspace.Flower1.CFrame)

		  elseif not plr.Backpack:FindFirstChild("Flower 2") and not plr.Character:FindFirstChild("Flower 2") then

		    _tp(workspace.Flower2.CFrame)

		  elseif not plr.Backpack:FindFirstChild("Flower 3") and not plr.Character:FindFirstChild("Flower 3") then

		    local v = GetConnectionEnemies("Swan Pirate")

            if v then repeat wait() Attack.Kill(v,_G.Auto_Human) until plr.Backpack:FindFirstChild("Flower 3") or not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_Human == false

		    else _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))end

		  end

		  elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 2 then

		    replicated.Remotes.CommF_:InvokeServer("Alchemist","3")

		  end

		  elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 0 then

		    replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","2")

		  elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 1 then

		  local v = GetConnectionEnemies(Human_v3_Mob[1])

          if v then repeat wait()Attack.Kill(v,_G.Auto_Human)until v.Humanoid.Health <= 0 or not v.Parent or not _G.Auto_Human			           

	      else _tp(CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625))

		  end		      

		  local v = GetConnectionEnemies(Human_v3_Mob[2])

          if v then repeat wait()Attack.Kill(v,_G.Auto_Human)until v.Humanoid.Health <= 0 or not v.Parent or not _G.Auto_Human			           

	      else _tp(CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109))

		  end		      

		  local v = GetConnectionEnemies(Human_v3_Mob[3])

          if v then repeat wait()Attack.Kill(v,_G.Auto_Human)until v.Humanoid.Health <= 0 or not v.Parent or not _G.Auto_Human			           

          else _tp(CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407))

	      end		      		

        end

      end

    end)

  end

end)

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Upgrade Skypiea V3", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Auto_Skypiea = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.Auto_Skypiea then

        if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") ~= -2 then

	      if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 0 then

		    replicated.Remotes.CommF_:InvokeServer("Alchemist","2")

		  elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 1 then

		    if not plr.Backpack:FindFirstChild("Flower 1") and not plr.Character:FindFirstChild("Flower 1") then

		      _tp(workspace.Flower1.CFrame)

		    elseif not plr.Backpack:FindFirstChild("Flower 2") and not plr.Character:FindFirstChild("Flower 2") then

		      _tp(workspace.Flower2.CFrame)

		    elseif not plr.Backpack:FindFirstChild("Flower 3") and not plr.Character:FindFirstChild("Flower 3") then

		      local v = GetConnectionEnemies("Swan Pirate")

		      if v then

			    repeat wait()Attack.Kill(v,_G.Auto_Skypiea)until plr.Backpack:FindFirstChild("Flower 3") or not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_Skypiea == false

		      else

		        _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))

		      end

		    end

	      elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 2 then

            replicated.Remotes.CommF_:InvokeServer("Alchemist","3")

          end

		  elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 0 then

	        replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","2")

	    elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 1 then

	      for i,v in pairs(game.Players:GetChildren()) do

            if v.Name ~= plr.Name and tostring(v.Data.Race.Value) == "Skypiea" then

		      repeat task.wait() _tp(v.HumanoidRootPart.CFrame * CFrame.new(0,8,0) * CFrame.Angles(math.rad(-45),0,0))until v.Humanoid.Health <= 0 or _G.Auto_Skypiea == false

	        end

	      end

        end          

      end

    end)

  end

end)

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Upgrade FishMan V3", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Auto_Fish = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.Auto_Fish then

        if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") ~= -2 then

	      if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 0 then

		    replicated.Remotes.CommF_:InvokeServer("Alchemist","2")

		  elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 1 then

	        if not plr.Backpack:FindFirstChild("Flower 1") and not plr.Character:FindFirstChild("Flower 1") then

		      _tp(workspace.Flower1.CFrame)

	        elseif not plr.Backpack:FindFirstChild("Flower 2") and not plr.Character:FindFirstChild("Flower 2") then

	          _tp(workspace.Flower2.CFrame)

	        elseif not plr.Backpack:FindFirstChild("Flower 3") and not plr.Character:FindFirstChild("Flower 3") then

	          local v = GetConnectionEnemies("Swan Pirate")

		      if v then

			    repeat wait()Attack.Kill(v,_G.Auto_Fish)until plr.Backpack:FindFirstChild("Flower 3") or not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_Fish == false

	          else

		       _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))

	          end

            end

	      elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 2 then

            replicated.Remotes.CommF_:InvokeServer("Alchemist","3")

          end

        elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 0 then

	      replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","2")

	    elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 1 then

          warn("Sea Beast Soon")

        end

      end

    end)

  end

end)



Tabs.Quests:AddSection("Dark Dragger")

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Unlocked Puzzle", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoUnHaki = Value

end)

AuraSkin = function(HakiID)

  local args = {[1] = {["StorageName"] = HakiID,["Type"] = "AuraSkin",["Context"] = "Equip"}};

  replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/FruitCustomizerRF"):InvokeServer(unpack(args));

end;

VaildColor = function(Part)

  if Part and Part.BrickColor then return (tostring(Part.BrickColor) == "Lime green") end;

end;

HakiCalculate = function(Part)

  local ID = {["Really red"] = "Pure Red";["Oyster"] = "Snow White";["Hot pink"] = "Winter Sky";};

  if Part and Part.BrickColor then return (ID[tostring(Part.BrickColor)])end;

end;

spawn(function()

  while wait(Sec) do

    if _G.AutoUnHaki then

      pcall(function()

        local Summoner = workspace.Map["Boat Castle"]:FindFirstChild("Summoner");

        if Summoner and Summoner:FindFirstChild("Circle") then 

          for i,v in pairs(Summoner:FindFirstChild("Circle"):GetChildren()) do 

            if v.Name == "Part" then 

            local TogglesPart = v:FindFirstChild("Part");

              if VaildColor(TogglesPart) == false then 

                AuraSkin(HakiCalculate(v));

                repeat wait() _tp(v.CFrame) until VaildColor(TogglesPart) == true or not _G.AutoUnHaki;

              end

            end            

          end

        end        

      end)

    end

  end

end)

Tabs.MultiFarm:AddSection("Main World2")

local MF_FactoryRaid = Tabs.MultiFarm:AddToggle("MF_FactoryRaids", {Title = "Auto Factory Raid", Description = "", Default = false})
MF_FactoryRaid:OnChanged(function(Value)
  _G.AutoFactory = Value
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.AutoFactory then
        local v = GetConnectionEnemies("Core")
        if v then
          repeat wait()
            EquipWeapon(_G.SelectWeapon)
            _tp(CFrame.new(448.46756, 199.356781, -441.389252))
          until v.Humanoid.Health <= 0 or _G.AutoFactory == false
        else
          _tp(CFrame.new(448.46756, 199.356781, -441.389252))
        end
      end
    end)
  end
end)

Tabs.MultiFarm:AddSection("Darkbeard")

local MF_Darkbeard = Tabs.MultiFarm:AddToggle("MF_Darkbeard", {
    Title = "Auto Farm Darkbeard",
    Description = "",
    Default = false
})

MF_Darkbeard:OnChanged(function(Value)
    _G.Auto_Def_DarkCoat = Value
end)

spawn(function()
    while task.wait(0.1) do
        if _G.Auto_Def_DarkCoat then
            pcall(function()
                if GetBP("Fist of Darkness") and not workspace.Enemies:FindFirstChild("Darkbeard") then
                    _tp(CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531))
                elseif GetConnectionEnemies("Darkbeard") then
                    local v = GetConnectionEnemies("Darkbeard")
                    if v then
                        repeat
                            task.wait()
                            Attack.Kill(v, _G.Auto_Def_DarkCoat)
                        until not _G.Auto_Def_DarkCoat
                            or not v.Parent
                            or v.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end
end)

local MF_Darkbeard = Tabs.MultiFarm:AddToggle("MF_Darkbeard", {Title = "Find Chest Farm Darkbeard", Description = "", Default = false})
MF_Darkbeard:OnChanged(function(Value)
  _G.Auto_Def_DarkCoat = Value
end)

spawn(function()
  while wait(.1) do
    if _G.Auto_Def_DarkCoat then
      pcall(function()
        if GetBP("Fist of Darkness") and not workspace.Enemies:FindFirstChild("Darkbeard") then
          _tp(CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531))
        elseif GetConnectionEnemies("Darkbeard") then
          local v = GetConnectionEnemies("Darkbeard")
          if v then repeat wait() Attack.Kill(v,_G.Auto_Def_DarkCoat) until _G.Auto_Def_DarkCoat == false or not v.Parent or v.Humanoid.Health <= 0 end
        elseif not GetBP("Fist of Darkness") and not GetConnectionEnemies("Darkbeard") then
          repeat wait(.1) _G.AutoFarmChest = true until not _G.Auto_Def_DarkCoat or GetBP("Fist of Darkness") or GetConnectionEnemies("Darkbeard") _G.AutoFarmChest = false
        end
      end)
    end
  end
end)

local HopFarmDarkbeard = Tabs.MultiFarm:AddToggle("HopFarmDarkbeard", {
    Title = "Hop Farm Darkbeard",
    Description = "",
    Default = false
})

HopFarmDarkbeard:OnChanged(function(Value)
    _G.DarkbreadHop = Value
end)

spawn(function()
    while task.wait(0.1) do
        if _G.Auto_Def_DarkCoat and _G.DarkbreadHop then
            pcall(function()
                if not workspace.Enemies:FindFirstChild("Darkbeard") then
                    Hop()
                end
            end)
        end
    end
end)

Tabs.MultiFarm:AddSection("Main World3")

local MF_CastleRaid = Tabs.MultiFarm:AddToggle("MF_CastleRaids", {Title = "Auto Castle Raid", Description = "", Default = false})
MF_CastleRaid:OnChanged(function(Value)
  _G.AutoRaidCastle = Value
end)

spawn(function()
  while wait(Sec) do
    if _G.AutoRaidCastle then
      pcall(function()
        local CFrameCastleRaid = CFrame.new(-5496.17432, 313.768921, -2841.53027, 0.924894512, 7.37058015e-09, 0.380223751, 3.5881019e-08, 1, -1.06665446e-07, -0.380223751, 1.12297109e-07, 0.924894512)
        
        if (CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125).Position - Root.Position).Magnitude <= 500 then
          for i,v in pairs(workspace.Enemies:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
              if (v.HumanoidRootPart.Position - Root.Position).Magnitude <= 2000 then
                repeat wait() 
                  Attack.Kill(v, _G.AutoRaidCastle) 
                until not _G.AutoRaidCastle or not v.Parent or v.Humanoid.Health <= 0 or not workspace.Enemies:FindFirstChild(v.Name)
              end
            end
          end
        else
          -- Fix: teleport thẳng đến Castle không cần check mob
          _tp(CFrameCastleRaid)
        end
      end)
    end
  end
end)

Tabs.MultiFarm:AddSection("Elite Quest")

local MF_EliteHunt = Tabs.MultiFarm:AddToggle("MF_EliteHunt", {Title = "Auto Farm Elite Hunter", Description = "", Default = false})
MF_EliteHunt:OnChanged(function(Value)
  _G.FarmEliteHunt = Value
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.FarmEliteHunt then
        if plr.PlayerGui.Main.Quest.Visible == true then
          if string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Diablo") or string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Urban") or string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Deandre") then
            for i,v in pairs(replicated:GetChildren()) do
              if string.find(v.Name,"Diablo") or string.find(v.Name,"Urban") or string.find(v.Name,"Deandre") then
                _tp(v.HumanoidRootPart.CFrame)
              end
            end
            for i,v in pairs(Enemies:GetChildren()) do
              if (string.find(v.Name,"Diablo") or string.find(v.Name,"Urban") or string.find(v.Name,"Deandre")) and Attack.Alive(v) then
                repeat wait() Attack.Kill(v, _G.FarmEliteHunt) until not _G.FarmEliteHunt or plr.PlayerGui.Main.Quest.Visible == false or not v.Parent or v.Humanoid.Health <= 0
              end
            end
          end
        else
          replicated.Remotes.CommF_:InvokeServer("EliteHunter")
        end
      end
    end)
  end
end)

local HopFarmEliteHunter = Tabs.MultiFarm:AddToggle("HopFarmEliteHunter", {
    Title = "Hop Farm Elite Hunter",
    Description = "",
    Default = false
})

HopFarmEliteHunter:OnChanged(function(Value)
    _G.EliteHop = Value
end)

spawn(function()
    while task.wait(Sec) do
        pcall(function()
            if _G.FarmEliteHunt and _G.EliteHop then
                -- Có chalice hoặc Fist thì không hop
                if GetBP("God's Chalice") or GetBP("Sweet Chalice") or GetBP("Fist of Darkness") then
                    return
                end

                local questGUI = plr.PlayerGui.Main.Quest

                if questGUI.Visible then
                    local questText = questGUI.Container.QuestTitle.Title.Text

                    local hasEliteQuest =
                        string.find(questText, "Diablo") or
                        string.find(questText, "Urban") or
                        string.find(questText, "Deandre")

                    -- Chỉ hop khi có quest nhưng không phải quest Elite
                    if not hasEliteQuest then
                        Hop()
                    end
                end
            end
        end)
    end
end)

local MF_StopChalice = Tabs.MultiFarm:AddToggle("MF_StopChalice", {Title = "Stop Hop While Have God's Chalice", Description = "", Default = false})
MF_StopChalice:OnChanged(function(Value)
  _G.StopWhenChalice = Value
end)

spawn(function()
  while wait(.2) do
    if _G.StopWhenChalice and _G.FarmEliteHunt then
      pcall(function()
        if GetBP("God's Chalice") or GetBP("Sweet Chalice") or GetBP("Fist of Darkness") then
          _G.FarmEliteHunt = false
        end
      end)
    end
  end
end)

Tabs.MultiFarm:AddSection("Soul Reaper")

local MF_SoulReaper = Tabs.MultiFarm:AddToggle("MF_SoulReaper", {
    Title = "Auto Farm Soul Reaper",
    Description = "",
    Default = false
})

MF_SoulReaper:OnChanged(function(Value)
    _G.AutoHytHallow = Value
end)

spawn(function()
    while wait(Sec) do
        if _G.AutoHytHallow then
            pcall(function()
                local v = GetConnectionEnemies("Soul Reaper")
                if v then
                    repeat
                        task.wait()
                        Attack.Kill(v, _G.AutoHytHallow)
                    until v.Humanoid.Health <= 0 or not _G.AutoHytHallow
                end
            end)
        end
    end
end)

local AutoSpawnSoulReaper = Tabs.MultiFarm:AddToggle("AutoSpawnSoulReaper", {
    Title = "Auto Spawn Soul Reaper",
    Description = "",
    Default = false
})

AutoSpawnSoulReaper:OnChanged(function(Value)
    _G.AutoSpawnSoulReaper = Value
end)

_G.AutoSpawnSoulReaper = false

spawn(function()
    while task.wait(Sec) do
        if _G.AutoSpawnSoulReaper then
            pcall(function()
                if not GetConnectionEnemies("Soul Reaper") then
                    if not GetBP("Hallow Essence") then
                        repeat
                            task.wait(0.1)
                            replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                        until not _G.AutoSpawnSoulReaper or GetBP("Hallow Essence")
                    else
                        repeat
                            task.wait(0.1)
                            _tp(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))
                        until not _G.AutoSpawnSoulReaper
                            or (plr.Character.HumanoidRootPart.Position - Vector3.new(-8932.322265625, 146.83154296875, 6062.55078125)).Magnitude <= 8

                        EquipWeapon("Hallow Essence")

                        repeat
                            task.wait(0.2)
                        until not _G.AutoSpawnSoulReaper
                            or GetConnectionEnemies("Soul Reaper")
                    end
                end
            end)
        end
    end
end)

local HopFarmSoulReaper = Tabs.MultiFarm:AddToggle("HopFarmSoulReaper", {
    Title = "Hop Farm Soul Reaper",
    Description = "",
    Default = false
})

HopFarmSoulReaper:OnChanged(function(Value)
    _G.SoulHopR = Value
end)

spawn(function()
    while task.wait(Sec) do
        if _G.AutoHytHallow and _G.SoulHopR then
            pcall(function()
                if not GetConnectionEnemies("Soul Reaper") then
                    Hop()
                end
            end)
        end
    end
end)

Tabs.MultiFarm:AddSection("Fighting Styles")

local MF_SuperHuman = Tabs.MultiFarm:AddToggle("MF_SuperHuman", {Title = "Auto Superhuman", Description = "", Default = false})
MF_SuperHuman:OnChanged(function(Value) _G.Auto_SuperHuman = Value end)

spawn(function()
  while task.wait(_G.GlobalDelay or 0.5) do
    pcall(function()
      if _G.Auto_SuperHuman then
        local lp = game.Players.LocalPlayer
        local beli = lp.Data.Beli.Value
        local frag = lp.Data.Fragments.Value
        local cache = lp:FindFirstChild("WeaponAssetCache")
        if cache then
          if not cache:FindFirstChild("Superhuman") then
            if not cache:FindFirstChild("Black Leg") and beli >= 150000 then
              game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyBlackLeg")
            end
            if not cache:FindFirstChild("Electro") and beli >= 500000 then
              game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectro")
            end
            if not cache:FindFirstChild("Fishman Karate") and beli >= 750000 then
              game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyFishmanKarate")
            end
            if not cache:FindFirstChild("Dragon Claw") and frag >= 1500 then
              game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2")
            end
            local black = cache:FindFirstChild("Black Leg")
            local electro = cache:FindFirstChild("Electro")
            local fish = cache:FindFirstChild("Fishman Karate")
            local dragon = cache:FindFirstChild("Dragon Claw")
            if black and electro and fish and dragon then
              if black.Level.Value >= 300 and electro.Level.Value >= 300 and fish.Level.Value >= 300 and dragon.Level.Value >= 300 then
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySuperhuman")
              else
                _G.Level = true
              end
            end
          end
        end
      end
    end)
  end
end)

local MF_DeathStep = Tabs.MultiFarm:AddToggle("MF_DeathStep", {Title = "Auto DeathStep", Description = "", Default = false})
MF_DeathStep:OnChanged(function(Value) _G.AutoDeathStep = Value end)

spawn(function()
  while task.wait(_G.GlobalDelay or 0.5) do
    pcall(function()
      if _G.AutoDeathStep then
        local lp = game.Players.LocalPlayer
        local cache = lp:FindFirstChild("WeaponAssetCache")
        if cache then
          if not cache:FindFirstChild("Death Step") then
            if not cache:FindFirstChild("Black Leg") then
              game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyBlackLeg")
              return
            end
            local black = cache:FindFirstChild("Black Leg")
            if black.Level.Value < 400 then
              _G.Level = true
              return
            end
            local door = workspace.Map.IceCastle.Hall.LibraryDoor.PhoeyuDoor
            if door and door.Transparency == 0 then
              if cache:FindFirstChild("Library Key") then
                _tp(CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375))
                task.wait(0.5)
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDeathStep")
              else
                local boss = GetConnectionEnemies("Awakened Ice Admiral")
                if boss then
                  repeat
                    task.wait()
                    Attack.Kill(boss, _G.AutoDeathStep)
                  until not boss.Parent or boss.Humanoid.Health <= 0 or _G.AutoDeathStep == false or cache:FindFirstChild("Library Key") or cache:FindFirstChild("Death Step")
                else
                  _tp(CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813))
                end
              end
            else
              _tp(CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813))
            end
          end
        end
      end
    end)
  end
end)

local MF_SharkMan = Tabs.MultiFarm:AddToggle("MF_SharkMan", {Title = "Auto Sharkman Karate", Description = "", Default = false})
MF_SharkMan:OnChanged(function(Value) _G.Auto_SharkMan_Karate = Value end)

spawn(function()
  while task.wait(_G.GlobalDelay or 0.5) do
    pcall(function()
      if _G.Auto_SharkMan_Karate then
        local lp = game.Players.LocalPlayer
        local cache = lp:FindFirstChild("WeaponAssetCache")
        if cache then
          if not cache:FindFirstChild("Sharkman Karate") then
            if not cache:FindFirstChild("Fishman Karate") then
              game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyFishmanKarate")
              return
            end
            local fish = cache:FindFirstChild("Fishman Karate")
            if fish.Level.Value < 400 then
              _G.Level = true
              return
            end
            if cache:FindFirstChild("Water Key") then
              _tp(CFrame.new(-2604.6958, 239.432526, -10315.1982))
              task.wait(0.5)
              game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
            else
              local boss = GetConnectionEnemies("Tide Keeper")
              if boss then
                repeat
                  task.wait()
                  Attack.Kill(boss, _G.Auto_SharkMan_Karate)
                until not boss.Parent or boss.Humanoid.Health <= 0 or _G.Auto_SharkMan_Karate == false or cache:FindFirstChild("Water Key") or cache:FindFirstChild("Sharkman Karate")
              else
                _tp(CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625))
              end
            end
          end
        end
      end
    end)
  end
end)

local MF_ElectricClaw = Tabs.MultiFarm:AddToggle("MF_ElectricClaw", {Title = "Auto ElectricClaw", Description = "", Default = false})
MF_ElectricClaw:OnChanged(function(Value) _G.Auto_Electric_Claw = Value end)

spawn(function()
  while task.wait(_G.GlobalDelay or 0.5) do
    pcall(function()
      if _G.Auto_Electric_Claw then
        local lp = game.Players.LocalPlayer
        local cache = lp:FindFirstChild("WeaponAssetCache")
        if cache then
          if not cache:FindFirstChild("Electric Claw") then
            if not cache:FindFirstChild("Electro") then
              game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectro")
              return
            end
            local electro = cache:FindFirstChild("Electro")
            if electro.Level.Value < 400 then
              _G.Level = true
              return
            end
            _tp(CFrame.new(-12548, 337, -7481))
            task.wait(0.5)
            local remote = game.ReplicatedStorage.Remotes.CommF_
            remote:InvokeServer("BuyElectricClaw", "Start")
            remote:InvokeServer("BuyElectricClaw")
          end
        end
      end
    end)
  end
end)

local MF_DragonTalon = Tabs.MultiFarm:AddToggle("MF_DragonTalon", {Title = "Auto DragonTalon", Description = "", Default = false})
MF_DragonTalon:OnChanged(function(Value) _G.AutoDragonTalon = Value end)

spawn(function()
  while task.wait(_G.GlobalDelay or 0.5) do
    pcall(function()
      if _G.AutoDragonTalon then
        local lp = game.Players.LocalPlayer
        local cache = lp:FindFirstChild("WeaponAssetCache")
        if cache then
          if not cache:FindFirstChild("Dragon Talon") then
            if not cache:FindFirstChild("Dragon Claw") then
              game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2")
              return
            end
            local dragon = cache:FindFirstChild("Dragon Claw")
            if dragon.Level.Value < 400 then
              _G.Level = true
              return
            end
            local remote = game.ReplicatedStorage.Remotes.CommF_
            remote:InvokeServer("Bones","Buy",1,1)
            remote:InvokeServer("BuyDragonTalon")
          end
        end
      end
    end)
  end
end)

local MF_Godhuman = Tabs.MultiFarm:AddToggle("MF_Godhuman", {Title = "Auto Godhuman", Description = "", Default = false})
MF_Godhuman:OnChanged(function(Value) _G.Auto_God_Human = Value end)

spawn(function()
  while task.wait(_G.GlobalDelay or 0.5) do
    pcall(function()
      if _G.Auto_God_Human then
        local lp = game.Players.LocalPlayer
        local cache = lp:FindFirstChild("WeaponAssetCache")
        if cache then
          if not cache:FindFirstChild("Godhuman") then
            local remote = game.ReplicatedStorage.Remotes.CommF_
            local check = remote:InvokeServer("BuyGodhuman", true)
            if check == "Bring me 20 Fish Tails, 20 Magma Ore, 10 Dragon Scales and 10 Mystic Droplets." then
              if GetM("Dragon Scale") < 10 then
                if game.PlaceId == 7449423635 then _G.Level = true else remote:InvokeServer("TravelZou") end
              elseif GetM("Fish Tail") < 20 then
                if game.PlaceId == 7449423635 then _G.Level = true else remote:InvokeServer("TravelZou") end
              elseif GetM("Mystic Droplet") < 10 then
                if game.PlaceId == 4442272183 then _G.Level = true else remote:InvokeServer("TravelDressrosa") end
              elseif GetM("Magma Ore") < 20 then
                if game.PlaceId == 4442272183 then _G.Level = true else remote:InvokeServer("TravelDressrosa") end
              end
            else
              remote:InvokeServer("BuyGodhuman")
            end
          end
        end
      end
    end)
  end
end)

local MF_SanguineArt = Tabs.MultiFarm:AddToggle("MF_SanguineArt", {Title = "Auto SanguineArt", Description = "", Default = false})
MF_SanguineArt:OnChanged(function(Value) _G.snaguine = Value end)

spawn(function()
  while task.wait(_G.GlobalDelay or 0.5) do
    pcall(function()
      if _G.snaguine then
        local lp = game.Players.LocalPlayer
        local cache = lp:FindFirstChild("WeaponAssetCache")
        if cache then
          if not cache:FindFirstChild("Sanguine Art") then
            local remote = game.ReplicatedStorage.Remotes.CommF_
            if GetM("Leviathan Heart") >= 1 then
              remote:InvokeServer("Sanguine Art")
              remote:InvokeServer("BuySanguineArt")
            else
              if game.PlaceId == 7449423635 then
                _G.DangerSc = "Lv Infinite"
                _G.SailBoats = true
              else
                _G.SailBoats = false
              end
              if GetM("Vampire Fang") <= 19 then
                if game.PlaceId == 4442272183 then
                  local n = GetConnectionEnemies("Vampire")
                  if n then
                    repeat
                      task.wait()
                      Attack.Kill(n, _G.snaguine)
                    until not _G.snaguine or n.Humanoid.Health <= 0 or not n.Parent
                  else
                    _tp(CFrame.new(-6041.29248046875, 6.402710914611816, -1304.63330078125))
                  end
                else
                  remote:InvokeServer("TravelDressrosa")
                end
              elseif GetM("Vampire Fang") >= 20 and GetM("Demonic Wisp") <= 19 then
                if game.PlaceId == 7449423635 then
                  local n = GetConnectionEnemies("Demonic Soul")
                  if n then
                    repeat
                      task.wait()
                      Attack.Kill(n, _G.snaguine)
                    until not _G.snaguine or n.Humanoid.Health <= 0 or not n.Parent
                  else
                    _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
                  end
                else
                  remote:InvokeServer("TravelZou")
                end
              elseif GetM("Vampire Fang") >= 20 and GetM("Demonic Wisp") >= 20 and GetM("Dark Fragment") <= 1 then
                if game.PlaceId == 4442272183 then
                  local n = GetConnectionEnemies("Darkbeard")
                  if n then
                    repeat
                      task.wait()
                      Attack.Kill(n, _G.snaguine)
                    until not _G.snaguine or n.Humanoid.Health <= 0 or not n.Parent
                  else
                    _tp(CFrame.new(3798.4575195313, 13.826690673828, -3399.806640625))
                  end
                else
                  remote:InvokeServer("TravelDressrosa")
                end
              end
            end
          end
        end
      end
    end)
  end
end)


Tabs.Quest:AddSection("Bartilo Quest")

local Bartilo = Tabs.Quest:AddToggle("Bartilo", {Title = "Auto Bartilo Quest", Description = "", Default = false})

Bartilo:OnChanged(function(Value)

  _G.Bartilo_Quest = Value

end)

spawn(function()

  while wait(.1) do    

    pcall(function()

      if _G.Bartilo_Quest and Lv >= 850 then

      local Qbart = plr.PlayerGui.Main.Quest

        if replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 0 then

          _G.Level = false

          if Qbart.Visible == true then

            local v = GetConnectionEnemies("Swan Pirate")

            if v then

              local x = GetConnectionEnemies(BartMon)

              if x then

                repeat task.wait()

                  if not string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirate")then replicated.Remotes.CommF_:InvokeServer("AbandonQuest")

                  else Attack.Kill(x,_G.Bartilo_Quest)end

                until _G.Bartilo_Quest == false or not x.Parent or x.Humanoid.Health <= 0 or Qbart.Visible == false or not x:FindFirstChild("HumanoidRootPart")                  

              end

            else

              _tp(CFrame.nee(970.369446, 142.653198, 1217.3667, 0.162079468, -4.85452638e-08, -0.986777723, 1.03357589e-08, 1, -4.74980872e-08, 0.986777723, -2.50063148e-09, 0.162079468))

            end

          else

            repeat wait() 

              _tp(CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312))

            until (CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 20 or _G.Bartilo_Quest == false

            if (CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 1 then

              replicated.Remotes.CommF_:InvokeServer("StartQuest", "BartiloQuest",1)

            end

          end

          elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 1 then

            _G.Level = false

            local je = GetConnectionEnemies("Jeremy")

            if je then

              repeat task.wait() Attack.Kill(je,_G.Bartilo_Quest) until _G.Bartilo_Quest == false or not je.Parent or je.Humanoid.Health <= 0 or Qbart.Visible == false or not je:FindFirstChild("HumanoidRootPart")                  

            else

              _tp(CFrame.new(2158.97412, 449.056244, 705.411682, -0.754199564, -4.17389057e-09, -0.656645238, -4.47752875e-08, 1, 4.50709301e-08, 0.656645238, 6.3393955e-08, -0.754199564))

            end

          elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 2 then

          repeat wait() _tp(CFrame.new(-1830.83972, 10.5578213, 1680.60229, 0.979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, 0.199054286, -1.13962431e-08, 0.979988456))until (CFrame.new(-1830.83972, 10.5578213, 1680.60229, 0.979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, 0.199054286, -1.13962431e-08, 0.979988456).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 1 or _G.Bartilo_Quest == false

          wait(0.5)

          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate1.CFrame

          wait(0.5)

          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate2.CFrame

          wait(0.5)

          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate3.CFrame

          wait(0.5)

          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate4.CFrame

          wait(0.5)

          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate5.CFrame

          wait(0.5)

          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate6.CFrame

          wait(0.5)

          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate7.CFrame

          wait(0.5)

          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate8.CFrame

          wait(2.5)

        end

      end

    end)

  end

end)


Tabs.Quest:AddSection("Dragon Quest")

local DojoQ = Tabs.Quest:AddToggle("DojoQ", {Title = "Auto Dojo Quest", Description = "turn on for do dojo belt quest white to black", Default = false})

DojoQ:OnChanged(function(Value)

  _G.Dojoo = Value

end)

function printBeltName(data) if type(data) == "table" and data.Quest["BeltName"] then return data.Quest["BeltName"] end end

spawn(function()

  while wait(Sec) do

    if _G.Dojoo then

      pcall(function()

        local args = {[1] = {["NPC"] = "Dojo Trainer",["Command"] = "RequestQuest"}}        

        local progress = replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))

        local NameBelt = printBeltName(progress)

        if debug == false and not progress and not NameBelt then

          _tp(CFrame.new(5865.0234375, 1208.3154296875, 871.15185546875))

          debug = true

        elseif debug == true and (CFrame.new(5865.0234375, 1208.3154296875, 871.15185546875).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 50 then

          if NameBelt == "White" then

            local v = GetConnectionEnemies("Skull Slayer")

            if v then repeat task.wait() Attack.Kill(v, _G.Dojoo) until not progress or not _G.Dojoo or not Attack.Alive(v)

            else _tp(CFrame.new(-16759.58984375, 71.28376770019531, 1595.3399658203125))

            end

          elseif NameBelt == "Yellow" then

            repeat task.wait()

              _G.SeaBeast1 = true

              _G.TerrorShark = true

              _G.Shark = true

              _G.Piranha = true

              _G.MobCrew = true

              _G.FishBoat = true

              _G.SailBoats = true

            until not _G.Dojoo or not progress

            _G.SeaBeast1 = false

            _G.TerrorShark = false

            _G.Shark = false

            _G.Piranha = false

            _G.MobCrew = false

            _G.FishBoat = false

            _G.SailBoats = false               

          elseif NameBelt == "Green" then

            repeat task.wait()

              _G.SailBoats = true

            until not _G.Dojoo or not progress

            _G.SailBoats = false

          elseif NameBelt == "Purple" then

            repeat task.wait()

              _G.FarmEliteHunt = true

            until not _G.Dojoo or not progress

            _G.FarmEliteHunt = false

          elseif NameBelt == "Red" then

            repeat task.wait()

              _G.SailBoats = true

              _G.FishBoat = true

            until not _G.Dojoo or not progress

            _G.SailBoats = false

            _G.FishBoat = false                      

          elseif NameBelt == "Black" then

            repeat task.wait()              

              if workspace.Map:FindFirstChild("PrehistoricIsland") or workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") then    

                _G.Prehis_Find = true                   

                if workspace.Map.PrehistoricIsland.Core.ActivationPrompt:FindFirstChild("ProximityPrompt",true) then

                  _G.Prehis_Skills = false

                  _G.Prehis_Find = true

                else

                  _G.Prehis_Skills = true

                  _G.Prehis_Find = false

                end

              else

                _G.Prehis_Find = true

                _G.Prehis_Skills = false

              end

            until not _G.Dojoo or not progress

            _G.Prehis_Find = false

            _G.Prehis_Skills = false                        

          elseif NameBelt == "Orange" or NameBelt == "Blue" then

            return nil

          end

        end

        if not progress then

          debug = false

          local args = {[1] = {["NPC"] = "Dojo Trainer",["Command"] = "ClaimQuest"}}

          replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))

        end

      end)

    end

  end

end)


local BlazeEM = Tabs.Quest:AddToggle("BlazeEM", {Title = "Auto Dragon Hunter", Description = "turn on for farm blaze ember + auto collect blaze ember", Default = false})

BlazeEM:OnChanged(function(Value)

  _G.FarmBlazeEM = Value

end)

checkQuesta=function()local a={[1]={["Context"]="Check"}}local b=nil;pcall(function()local c={[1]={["Context"]="RequestQuest"}}game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack(c))end)local d,e=pcall(function()b=game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack(a))end)local f=false;local g;local h;local i;if b then if b.Text then f=true;local j=b.Text;if string.find(tostring(j),"Defeat")then i=1;g=string.sub(tostring(j),8,9)g=tonumber(g)local k={"Hydra Enforcer","Venomous Assailant"}for l,m in pairs(k)do if string.find(j,m)then h=m;break end end elseif string.find(tostring(j),"Destroy")then g=10;i=2;h=nil end end end;return f,h,g,i end

BackTODoJo=function()for a,b in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Notifications:GetChildren())do if b.Name=="NotificationTemplate"then if string.find(b.Text,"Head back to the Dojo to complete more tasks")then return true end end end;return false end

DragonMobClear=function(a,b,c)if workspace.Enemies:FindFirstChild(b)then for d,e in pairs(workspace.Enemies:GetChildren())do if e.Name==b and Attack.Alive(e)then if a then Attack.Kill(e,a)end end end else _tp(c)end end

spawn(function()

  while wait() do 

    if _G.FarmBlazeEM then

      pcall(function()              

        local a,v,h,x = checkQuesta()                  

        if a == true and not BackTODoJo() then

          if x == 1 then

            if v == "Hydra Enforcer" or v == "Venomous Assailant" then            

              repeat wait()

                DragonMobClear(true, v, CFrame.new(4620.61572265625, 1002.2954711914062, 399.0868835449219))

              until not _G.FarmBlazeEM or not a or BackTODoJo()                            

            end      

          elseif x == 2 then

            if workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true) then

              repeat wait()                

                spawn(function() _tp(workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true).CFrame * CFrame.new(4,0,0)) end)

                if (workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true).Position - Root.Position).Magnitude <= 200 then

                MousePos = workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true).Position

                Useskills("Melee","Z")

	            Useskills("Melee","X")

	            Useskills("Melee","C")

                wait(.5)

                Useskills("Sword","Z")

                Useskills("Sword","X")

                wait(.5)

                Useskills("Blox Fruit","Z")

                Useskills("Blox Fruit","X")

                Useskills("Blox Fruit","C")

                wait(.5)

                Useskills("Gun","Z")

                Useskills("Gun","X")

                end

              until not _G.FarmBlazeEM or not a or BackTODoJo()

            end

          end

        else

          _tp(CFrame.new(5813, 1208, 884))

          DragonMobClear(false, nil, nil) 

        end

      end)

    end

  end

end)

spawn(function()

  while wait(.1) do 

    if _G.FarmBlazeEM then

      pcall(function()              

        if workspace.EmberTemplate:FindFirstChild("Part") then

          game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.EmberTemplate.Part.CFrame        

        end

      end)

    end

  end

end)


local Section = Tabs.Quest:AddSection("Ken")

Section:AddToggle("UpgradeObserV2", {
    Title = "Auto Upgrade Ken V2",
    Default = false,
    Callback = function(Value)
        _G.AutoKenVTWO = Value
    end
})

spawn(function()
  while wait(Sec) do
    if _G.AutoKenVTWO then
      pcall(function()
      local Kv2Pos1 = CFrame.new(-12444.78515625, 332.40396118164, -7673.1806640625)
      local Kv2Pos2 = "Kuy"
      local Kv2Pos3 = CFrame.new(-10920.125, 624.20275878906, -10266.995117188)
      local Kv2Pos4 = CFrame.new(-13277.568359375, 370.34185791016, -7821.1572265625)
      local Kv2Pos5 = CFrame.new(-13493.12890625, 318.89553833008, -8373.7919921875)
	  if plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Defeat 50 Forest Pirates") then
	    local v = GetConnectionEnemies("Forest Pirate")
        if v then
	      repeat wait() Attack.Kill(v,_G.AutoKenVTWO) until not _G.AutoKenVTWO or v.Humanoid.Health <= 0 or plr.PlayerGui.Main.Quest.Visible == false
	    else
	      _tp(Kv2Pos4)
	    end
	  elseif plr.PlayerGui.Main.Quest.Visible == true then 
	    local v = GetConnectionEnemies("Captain Elephant")
	    if v then
          repeat wait() Attack.Kill(v,_G.AutoKenVTWO) until not _G.AutoKenVTWO or v.Humanoid.Health <= 0 or plr.PlayerGui.Main.Quest.Visible == false
	    else
	      _tp(Kv2Pos5)
	    end
	  elseif plr.PlayerGui.Main.Quest.Visible == false then
	    replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen") wait(.1)
	    replicated.Remotes.CommF_:InvokeServer("StartQuest","CitizenQuest",1)
	  end
	  if replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen") == 2 then
	    _tp(CFrame.new(-12513.51953125, 340.1137390136719, -9873.048828125))
	  end
	  if not plr.Backpack:FindFirstChild("Fruit Bowl") or not plr.Character:FindFirstChild("Fruit Bowl") then
	  if not GetBP("Fruit Bowl") then   	    
	    if not GetBP("Apple") then
	      replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
	      for i,v in pairs(workspace:GetDescendants()) do
	        if v.Name == "Apple" then
	          v.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,10) wait()
		      firetouchinterest(plr.Character.HumanoidRootPart,v.Handle,0) wait()		    
	        end
	      end
	    elseif not GetBP("Banana") then
	      _tp(CFrame.new(2286.0078125,73.13391876220703,-7159.80908203125))
	      for i,v in pairs(workspace:GetDescendants()) do
	        if v.Name == "Banana" then
	          v.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,10) wait()
		      firetouchinterest(plr.Character.HumanoidRootPart,v.Handle,0) wait()		    
	        end
	      end	    
	    elseif not GetBP("Pineapple") then
	      _tp(CFrame.new(-712.8272705078125,98.5770492553711,5711.9541015625))
	      for i,v in pairs(workspace:GetDescendants()) do
	        if v.Name == "Pineapple" then
	          v.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,10) wait()
		      firetouchinterest(plr.Character.HumanoidRootPart,v.Handle,0) wait()		    
	        end
	      end	    
	    end	  
	  end  	    	    
	    if plr.Backpack:FindFirstChild("Banana") and plr.Backpack:FindFirstChild("Apple") and plr.Backpack:FindFirstChild("Pineapple") or plr:FindFirstChild("Banana") and plr:FindFirstChild("Apple") and plr:FindFirstChild("Pineapple") then
	      repeat wait() _tp(Kv2Pos1) until _G.AutoKenVTWO or plr.Character.HumanoidRootPart.CFrame == Kv2Pos1
		  replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen")	    			 
	    end
	      if plr.Backpack:FindFirstChild("Fruit Bowl") or plr.Character:FindFirstChild("Fruit Bowl") then
	        if plr.Character.HumanoidRootPart.CFrame ~= Kv2Pos3 then _tp(Kv2Pos3)
		    elseif plr.Character.HumanoidRootPart.CFrame == Kv2Pos3 then
		      replicated.Remotes.CommF_:InvokeServer("KenTalk2","Start") wait(.1)
		      replicated.Remotes.CommF_:InvokeServer("KenTalk2","Buy")
	        end			 		    
	      end
	    end
      end)
    end
  end
end)

Section:AddToggle("ObservationNormal", {
    Title = "Auto Farm Ken",
    Default = false,
    Callback = function(Value)
        _G.obsFarm = Value
    end
})

spawn(function()
  while wait(.2) do
    pcall(function()
      if _G.obsFarm then        
        replicated.Remotes.CommE:FireServer("Ken",true)
        if plr:GetAttribute("KenDodgesLeft") == 0 then
          KenTest = false
        elseif plr:GetAttribute("KenDodgesLeft") > 0 then
          replicated.Remotes.CommE:FireServer("Ken",true)
          KenTest = true
        end        
      end
    end)
  end
end)    
spawn(function()      
  while wait(.2) do
    pcall(function()
      if _G.obsFarm then
        if World1 then
          if workspace.Enemies:FindFirstChild("Galley Captain") then
            if KenTest then
              repeat wait()
                plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Galley Captain").HumanoidRootPart.CFrame * CFrame.new(3,0,0)
              until _G.obsFarm == false or KenTest == false
            else
              repeat wait()
                plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Galley Captain").HumanoidRootPart.CFrame * CFrame.new(0,50,0)
              until _G.obsFarm == false or KenTest
            end
          else
            _tp(CFrame.new(5533.29785, 88.1079102, 4852.3916))
          end
        elseif World2 then
          if workspace.Enemies:FindFirstChild("Lava Pirate") then
            if KenTest then
              repeat wait()
                plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Lava Pirate").HumanoidRootPart.CFrame * CFrame.new(3,0,0)
              until _G.obsFarm == false or KenTest == false
            else
              repeat wait()
                plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Lava Pirate").HumanoidRootPart.CFrame * CFrame.new(0,50,0)
              until _G.obsFarm == false or KenTest
            end
          else
            _tp(CFrame.new(-5478.39209, 15.9775667, -5246.9126))
          end
        elseif World3 then
          if workspace.Enemies:FindFirstChild("Venomous Assailant") then
            if KenTest then
              repeat wait()
                _tp(workspace.Enemies:FindFirstChild("Venomous Assailant").HumanoidRootPart.CFrame * CFrame.new(3,0,0))
              until _G.obsFarm == false or KenTest == false
            else
              repeat wait()
                _tp(workspace.Enemies:FindFirstChild("Venomous Assailant").HumanoidRootPart.CFrame * CFrame.new(0,50,0))
              until _G.obsFarm == false or KenTest
            end
          else
            _tp(CFrame.new(4530.3540039063, 656.75695800781, -131.60952758789))
          end
        end        
      end
    end)
  end
end)

Section:AddToggle("ObservationRejoin", {
    Title = "Rejoin Farm Ken",
    Default = false,
    Callback = function(Value)
        _G.ObservationRejoin = Value
    end
})

spawn(function()
    while task.wait(2) do
        pcall(function()
            if _G.obsFarm and _G.ObservationRejoin then
                game:GetService("TeleportService"):TeleportToPlaceInstance(
                    game.PlaceId,
                    game.JobId,
                    game.Players.LocalPlayer
                )
            end
        end)
    end
end)


Tabs.Quest:AddSection("Rainbow Haki")

local Q = Tabs.Quest:AddToggle("Q", {
    Title = "Auto Rainbow Haki Quest",
    Description = "",
    Default = false
})

Q:OnChanged(function(Value)
    _G.Auto_Rainbow_Haki = Value
    _G.GetQFast = Value
end)

spawn(function()
    pcall(function()
        while wait(Sec) do
            if _G.Auto_Rainbow_Haki then
                if plr.PlayerGui.Main.Quest.Visible == false then
                    replicated.Remotes.CommF_:InvokeServer("HornedMan","Bet")

                elseif string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Stone") then
                    local v = GetConnectionEnemies("Stone")
                    if v then
                        repeat
                            wait()
                            Attack.Kill(v, _G.Auto_Rainbow_Haki)
                        until not _G.Auto_Rainbow_Haki or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
                    else
                        _tp(CFrame.new(-1086.11621, 38.8425903, 6768.71436, 0.0231462717, -0.592676699, 0.805107772, 2.03251839e-05, 0.805323839, 0.592835128, -0.999732077, -0.0137055516, 0.0186523199))
                    end

                elseif string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Hydra Leader") then
                    local v = GetConnectionEnemies("Hydra Leader")
                    if v then
                        repeat
                            task.wait()
                            Attack.Kill(v, _G.Auto_Rainbow_Haki)
                        until not _G.Auto_Rainbow_Haki or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
                    else
                        replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5643.45263671875,1013.0858154296875,-340.51025390625))
                        local framelong1 = Vector3.new(5643.45263671875,1013.0858154296875,-340.51025390625)
                        local framelong2 = CFrame.new(5821.89794921875,1019.0950927734375,-73.71923065185547)
                        if plr.Character.HumanoidRootPart.CFrame.Position == framelong1 then
                            _tp(framelong2)
                        end
                    end

                elseif string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Kilo Admiral") then
                    local v = GetConnectionEnemies("Kilo Admiral")
                    if v then
                        repeat
                            task.wait()
                            Attack.Kill(v, _G.Auto_Rainbow_Haki)
                        until not _G.Auto_Rainbow_Haki or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
                    else
                        _tp(CFrame.new(2877.61743,423.558685,-7207.31006,-0.989591599,0,-0.143904909,0,1,0,0.143904924,0,-0.989591479))
                    end

                elseif string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") then
                    local v = GetConnectionEnemies("Captain Elephant")
                    if v then
                        repeat
                            task.wait()
                            Attack.Kill(v, _G.Auto_Rainbow_Haki)
                        until not _G.Auto_Rainbow_Haki or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
                    else
                        local pos1 = Vector3.new(-12471.169921875,374.94024658203,-7551.677734375)
                        local pos2 = CFrame.new(-13376.7578125,433.28689575195,-8071.392578125)
                        if plr.Character.HumanoidRootPart.CFrame.Position ~= pos1 then
                            replicated.Remotes.CommF_:InvokeServer("requestEntrance", pos1)
                        else
                            _tp(pos2)
                        end
                    end

                elseif string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Beautiful Pirate") then
                    local v = GetConnectionEnemies("Beautiful Pirate")
                    if v then
                        repeat
                            task.wait()
                            Attack.Kill(v, _G.Auto_Rainbow_Haki)
                        until not _G.Auto_Rainbow_Haki or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
                    else
                        replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5314.54638671875,22.562219619750977,-127.06755065917969))
                    end
                end
            end
        end
    end)
end)

Tabs.Quest:AddSection("Citizen Quest")

local CitizenQ = Tabs.Quest:AddToggle("CitizenQ", {Title = "Auto Citizen Quest", Description = "", Default = false})

CitizenQ:OnChanged(function(Value)

  _G.CitizenQuest = Value

end)

spawn(function()	

  while wait(Sec) do

    pcall(function()

      if _G.CitizenQuest then

        if Lv >= 1800 and replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBandits == false then

          if string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Forest Pirate") and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and plr.PlayerGui.Main.Quest.Visible == true then

            local v = GetConnectionEnemies("Forest Pirate")

            if v then

              repeat task.wait() Attack.Kill(v,_G.CitizenQuest)until _G.CitizenQuest == false or not v.Parent or v.Humanoid.Health <= 0 or plr.PlayerGui.Main.Quest.Visible == false

            else

              _tp(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375))

            end

          else

            _tp(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))

            if (Vector3.new(-12443.8671875, 332.40396118164, -7675.4892578125) - plr.Character.HumanoidRootPart.Position).Magnitude <= 30 then

              wait(1.5) replicated.Remotes.CommF_:InvokeServer("StartQuest","CitizenQuest",1)

            end

          end

        elseif Lv >= 1800 and replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBoss == false then

          local v = GetConnectionEnemies("Captain Elephant")

          if plr.PlayerGui.Main.Quest.Visible and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") and plr.PlayerGui.Main.Quest.Visible == true then

            if v then

              repeat task.wait() Attack.Kill(v,_G.CitizenQuest) until _G.CitizenQuest == false or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false

            else

              _tp(CFrame.new(-13374.889648438, 421.27752685547, -8225.208984375))

            end

          else

            _tp(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))

            if (CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 4 then

              wait(1.5)

              replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen")

            end

          end

        elseif Lv >= 1800 and replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen") == 2 then

          _tp(CFrame.new(-12512.138671875, 340.39279174805, -9872.8203125))

        end

      end

    end)

  end

end)

Tabs.Settings:AddSection("Weapon Settings")

local _Weapon = {"Melee","Sword","Blox Fruit","Gun"}

local Weapon_Config = Tabs.Settings:AddDropdown("Weapon_Config",{Title = "Select Weapon",Values = _Weapon,Multi = false,Default = 1})

Weapon_Config:OnChanged(function(Value)

  _G.ChooseWP = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.ChooseWP == "Melee" then

        for _,v in pairs(plr.Backpack:GetChildren()) do

	      if v.ToolTip == "Melee" then

		    if plr.Backpack:FindFirstChild(tostring(v.Name)) then

	          _G.SelectWeapon = v.Name              

            end

          end

        end

   	  elseif _G.ChooseWP == "Sword" then     

	    for _,v in pairs(plr.Backpack:GetChildren()) do

	      if v.ToolTip == "Sword" then

		    if plr.Backpack:FindFirstChild(tostring(v.Name)) then

		      _G.SelectWeapon = v.Name              

            end

          end

        end

      elseif _G.ChooseWP == "Gun" then     

	     for _,v in pairs(plr.Backpack:GetChildren()) do

	       if v.ToolTip == "Gun" then

		    if plr.Backpack:FindFirstChild(tostring(v.Name)) then

		      _G.SelectWeapon = v.Name              

            end

          end

        end

      elseif _G.ChooseWP == "Blox Fruit" then     

	    for _,v in pairs(plr.Backpack:GetChildren()) do

	      if v.ToolTip == "Blox Fruit" then

		    if plr.Backpack:FindFirstChild(tostring(v.Name)) then

		      _G.SelectWeapon = v.Name		                    

            end

          end

        end        

      end

    end)

  end

end)


Tabs.Settings:AddSection("Character Settings")

local BusuAura = Tabs.Settings:AddToggle("BusuAura", {
    Title = "Auto Use Buso",
    Description = "",
    Default = true
})

Boud = true

BusuAura:OnChanged(function(Value)
    Boud = Value
end)

local ObservationTurnOn = Tabs.Settings:AddToggle("ObservationTurnOn", {
    Title = "Auto Use Ken",
    Description = "",
    Default = false
})

getgenv().Observation = false

ObservationTurnOn:OnChanged(function(Value)
    getgenv().Observation = Value
end)

spawn(function()
    while wait(Sec) do
        pcall(function()
            if Boud then
                local _HasBuso = {"HasBuso", "Buso"}
                if not plr.Character:FindFirstChild(_HasBuso[1]) then
                    replicated.Remotes.CommF_:InvokeServer(_HasBuso[2])
                end
            end

            if getgenv().Observation then
                replicated.Remotes.CommE:FireServer("Ken", true)
            end
        end)
    end
end)

Tabs.Settings:AddSection("Race Ability Settings")

local RaceV3Aura = Tabs.Settings:AddToggle("RaceV3Aura", {Title = "Auto Turn on Race V3", Description = "", Default = false})

RaceV3Aura:OnChanged(function(Value)

  _G.RaceClickAutov3 = Value

end)

spawn(function()

  while wait(.2) do

    pcall(function()

      if _G.RaceClickAutov3 then

        repeat

          replicated.Remotes.CommE:FireServer("ActivateAbility") 

          wait(30)

        until not _G.RaceClickAutov3   

      end 

    end)

  end

end)

local RaceV4Aura = Tabs.Settings:AddToggle("RaceV4Aura", {Title = "Auto Turn on Race V4", Description = "", Default = false})

RaceV4Aura:OnChanged(function(Value)

  _G.RaceClickAutov4 = Value

end)

spawn(function()

  while wait(.2) do

    pcall(function()

      if _G.RaceClickAutov4 then

  	    if plr.Character:FindFirstChild("RaceEnergy") then

        if plr.Character:FindFirstChild("RaceEnergy").Value == 1 then Useskills("nil","Y") end

        end        

      end 

    end)

  end

end)


Tabs.Settings:AddSection("Farm Settings")

local DisblesVFX = Tabs.Settings:AddToggle("DisblesVFX", {Title = "Remove Notify Text", Description = "", Default = false})

DisblesVFX:OnChanged(function(Value)

  RemoveDamage = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if RemoveDamage then

        replicated.Assets.GUI.DamageCounter.Enabled = false

        plr.PlayerGui.Notifications.Enabled = false

	  else

        replicated.Assets.GUI.DamageCounter.Enabled = true

        plr.PlayerGui.Notifications.Enabled = true

      end

    end)

  end

end)

local Bringmob = Tabs.Settings:AddToggle("Bringmob", {
    Title = "Bring Mob",
    Description = "",
    Default = true
})

Bringmob:OnChanged(function(Value)
    getgenv().BringMonster = Value
end)

local Initialize = Tabs.Settings:AddToggle("Initialize", {Title = "Allow Attack M1 Fruits", Description = "", Default = false})

Initialize:OnChanged(function(Value)

  _G.Seriality = Value

end)

Tabs.Settings:AddSection("Player")

_G.TPBypass = false

local TPBypassToggle = Tabs.Settings:AddToggle("TPBypass", {
    Title = "TP Bypass⚠️",
    Description = "[ Beta ]",
    Default = false
})

TPBypassToggle:OnChanged(function(Value)
    _G.TPBypass = Value
end)

local SafeModes = Tabs.Settings:AddToggle("SafeModes", {Title = "Panic Mode", Description = "turn on for safe ur health if low", Default = false})

SafeModes:OnChanged(function(Value)

  _G.Safemode = Value

end)

spawn(function()

  while task.wait(Sec) do

    pcall(function()

	  if _G.Safemode then

  	  local Calc_Health = plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth * 100

  	  if Calc_Health < Num_self then shouldTween=true _tp(Root.CFrame * CFrame.new(0,500,0)) else shouldTween=false end

      end

    end)

  end

end)

local UnDetectedAFK = Tabs.Settings:AddToggle("UnDetectedAFK", {Title = "Anti AFK", Description = "", Default = true})

UnDetectedAFK:OnChanged(function(Value)

  _G.AntiAFK = Value

end)

plr.Idled:connect(function()

  vim2:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)

  wait(1)

  vim2:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)

end)

local DisblesVFX = Tabs.Settings:AddToggle("DisblesVFX", {Title = "Remove Hit VFX", Description = "", Default = false})

DisblesVFX:OnChanged(function(Value)

  _G.DistroyHit = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.DistroyHit then

      pcall(function()

        local __Efeect = {"SlashHit","CurvedRing","SwordSlash","SlashTail"}

        for _,x in pairs(workspace["_WorldOrigin"]:GetChildren()) do

	      if table.find(__Effect, x.Name) then x:Destroy() end

        end

      end)

    end

  end

end)

local DisblesVFX = Tabs.Settings:AddToggle("DisblesVFX", {Title = "Remove Death & Respawned VFX", Description = "", Default = false})

DisblesVFX:OnChanged(function(Value)

  RDeath = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if RDeath then

	  if replicated.Effect.Container:FindFirstChild("Death") then replicated.Effect.Container.Death:Destroy() end

      if replicated.Effect.Container:FindFirstChild("Respawn") then replicated.Effect.Container.Respawn:Destroy() end

	  end

    end)

  end

end)	


Tabs.Quests:AddSection("Tushita & Yama")

local Process = Tabs.Quests:AddParagraph({Title = "Elites Process ",Content = ""})

spawn(function()
  while task.wait(0.2) do
    pcall(function()    
      Process:SetDesc("Elite Procress :  " .. replicated.Remotes.CommF_:InvokeServer("EliteHunter","Progress"))
    end)
  end
end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Tushita Sword", Description = "", Default = false})
Q:OnChanged(function(Value) _G.Auto_Tushita = Value end)

spawn(function()
  while task.wait(0.2) do
    pcall(function()
      if _G.Auto_Tushita then
        local char = plr.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        if workspace.Map.Turtle:FindFirstChild("TushitaGate") then
          if not GetBP("Holy Torch") then
            _tp(CFrame.new(5148.03613, 162.352493, 910.548218))
            task.wait(0.7)
          else
            EquipWeapon("Holy Torch")
            task.wait(1)
            local waypoints = {
              CFrame.new(-10752, 417, -9366),
              CFrame.new(-11672, 334, -9474),
              CFrame.new(-12132, 521, -10655),
              CFrame.new(-13336, 486, -6985),
              CFrame.new(-13489, 332, -7925)
            }
            for _, cf in ipairs(waypoints) do
              if not _G.Auto_Tushita then break end
              repeat
                task.wait()
                _tp(cf)
              until not _G.Auto_Tushita or (cf.Position - root.Position).Magnitude <= 10
              task.wait(0.7)
            end
          end
        else
          local v = GetConnectionEnemies("Longma")
          if v and v.Parent and v.Humanoid and v.Humanoid.Health > 0 then
            repeat
              task.wait()
              Attack.Kill(v, _G.Auto_Tushita)
            until v.Humanoid.Health <= 0 or not _G.Auto_Tushita or not v.Parent
          elseif replicated:FindFirstChild("Longma") then
            _tp(replicated:FindFirstChild("Longma").HumanoidRootPart.CFrame * CFrame.new(0,40,0))
          end
        end
      end
    end)
  end
end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Yama Sword", Description = "", Default = false})
Q:OnChanged(function(Value) _G.Auto_Yama = Value end)

spawn(function()
  while task.wait(0.2) do
    pcall(function()
      if _G.Auto_Yama then
        local char = plr.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local prog = replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress")
        if prog < 30 then
          _G.FarmEliteHunt = true
        else
          _G.FarmEliteHunt = false
          local sealed = workspace.Map and workspace.Map.Waterfall and workspace.Map.Waterfall.SealedKatana
          if sealed and sealed.Handle then
            if (sealed.Handle.Position - root.Position).Magnitude >= 20 then
              _tp(sealed.Handle.CFrame)
              local ghost = GetConnectionEnemies("Ghost")
              if ghost and ghost.Parent and ghost.Humanoid and ghost.Humanoid.Health > 0 then
                repeat
                  task.wait()
                  Attack.Kill(ghost, _G.Auto_Yama)
                until ghost.Humanoid.Health <= 0 or not ghost.Parent or not _G.Auto_Yama
              end
              if sealed.Handle:FindFirstChild("ClickDetector") then
                fireclickdetector(sealed.Handle.ClickDetector)
              end
            end
          end
        end
      end
    end)
  end
end)

Tabs.Quests:AddSection("Cursed Dual Katana")

local CheckCDK = Tabs.Quests:AddParagraph({Title = " Number Cursed dual katana quests ",Content = "Quest Numbers :"})

spawn(function()  
  while task.wait(0.2) do 
    local desc = "Quest Numbers :"
    if QuestYama_1 then desc = desc .. " yama quest 1"
    elseif QuestYama_2 then desc = desc .. " yama quest 2"
    elseif QuestYama_3 then desc = desc .. " yama quest 3"
    elseif QuestTushita_1 then desc = desc .. " tushita quest 1"
    elseif QuestTushita_2 then desc = desc .. " tushita quest 2"
    elseif GetWP("Cursed Dual Katana") then desc = desc .. " CDK done!!"
    end
    CheckCDK:SetDesc(desc)
  end
end) 

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Get CDK [ Last Quest ]", Description = "", Default = false})
Q:OnChanged(function(Value) _G.CDK = Value end)

spawn(function()    
  while task.wait(0.2) do
    pcall(function()
      if _G.CDK then
        replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
        replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
        replicated.Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Boss")
        local v = GetConnectionEnemies("Cursed Skeleton Boss")
        if v and v.Parent and v.Humanoid and v.Humanoid.Health > 0 then
          repeat
            task.wait()
            if plr.Character:FindFirstChild("Yama") or plr.Backpack:FindFirstChild("Yama") then 
              EquipWeapon("Yama")
            elseif plr.Character:FindFirstChild("Tushita") or plr.Backpack:FindFirstChild("Tushita") then 
              EquipWeapon("Tushita")                                    
            end 
            _tp(v.HumanoidRootPart.CFrame * CFrame.new(0,20,0))
            Attack.Kill(v, _G.CDK)
          until not _G.CDK or not v.Parent or v.Humanoid.Health <= 0                                
        else
          _tp(CFrame.new(-12318.193359375, 601.9518432617188, -6538.662109375)) 
          task.wait(0.5)
          local door = workspace.Map and workspace.Map.Turtle and workspace.Map.Turtle.Cursed and workspace.Map.Turtle.Cursed.BossDoor
          if door then _tp(door.CFrame) end
        end
      end
    end)
  end
end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Yama CDK", Description = "", Default = false})
Q:OnChanged(function(Value) _G.CDK_YM = Value end)

spawn(function()
  while task.wait(0.2) do
    pcall(function()
      if _G.CDK_YM then
        local open = replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")
        if tostring(open) ~= "opened" then                  
          replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")
          replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
        else
          local prog = replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")
          if prog["Finished"] == nil then
            replicated.Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
            replicated.Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
          elseif prog["Finished"] == false then                        
            local evil = tonumber(prog["Evil"])
            if evil == -3 then
              QuestYama_1 = true; QuestYama_2 = false; QuestYama_3 = false
              repeat
                task.wait()
                local enemy = GetConnectionEnemies("Forest Pirate")
                if enemy and enemy.Parent and enemy.Humanoid and enemy.Humanoid.Health > 0 then
                  _tp(enemy.HumanoidRootPart.CFrame)
                else
                  _tp(CFrame.new(-13223.521484375, 428.1938171386719, -7766.06787109375))
                end
              until tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 1 or not _G.CDK_YM
            elseif evil == -4 then
              QuestYama_1 = false; QuestYama_2 = true; QuestYama_3 = false
              for ix,HitMon in pairs(game:GetService("Players").LocalPlayer.QuestHaze:GetChildren()) do
                for NameMonHaze, CFramePos in pairs(PosMsList) do
                  if string.find(NameMonHaze,HitMon.Name) and HitMon.Value > 0 then
                    if (CFramePos.Position - Root.Position).Magnitude <= 1000 and workspace.Enemies:FindFirstChild(NameMonHaze) then
                      for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Humanoid").Health > 0 and v:FindFirstChild("HazeESP") then
                          repeat
                            task.wait()
                            Attack.Kill(v, _G.CDK_YM)
                          until not _G.CDK_YM or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 2 or not v:FindFirstChild("HazeESP") or v.Humanoid.Health <= 0
                        end
                      end
                    else   
                      _tp(CFramePos)                               
                    end
                  end
                end
              end
            elseif evil == -5 then
              QuestYama_1 = false; QuestYama_2 = false; QuestYama_3 = true
              if workspace.Map:FindFirstChild("HellDimension") then
                local spawnPos = workspace.Map.HellDimension.Spawn.Position
                if (Root.Position - spawnPos).Magnitude <= 1000 then
                  for gg,ez in pairs(workspace.Map.HellDimension.Exit:GetChildren()) do
                    if tonumber(gg) == 2 then
                      repeat
                        task.wait()
                        Root.CFrame = workspace.Map.HellDimension.Exit.CFrame
                      until not _G.CDK_YM or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 3
                    end
                  end
                  EquipWeapon(_G.SelectWeapon or "Melee")
                  if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) ~= 3 then
                    _G.T1Yama = false; _G.T2Yama = false; _G.T3Yama = false
                    repeat
                      task.wait()
                      repeat
                        task.wait() 
                        local t1 = workspace.Map.HellDimension.Torch1
                        if t1 and t1.Particles then _tp(t1.Particles.CFrame) end
                        for i, v in pairs(workspace.Map.HellDimension:GetDescendants()) do
                          if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                        end
                      until not t1 or (t1.Particles.Position - Root.Position).Magnitude < 5
                      task.wait(2)
                      _G.T1Yama = true
                    until not _G.CDK_YM or _G.T1Yama or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 3
                    repeat
                      task.wait()
                      repeat
                        task.wait()
                        local t2 = workspace.Map.HellDimension.Torch2
                        if t2 and t2.Particles then _tp(t2.Particles.CFrame) end
                        for i, v in pairs(workspace.Map.HellDimension:GetDescendants()) do
                          if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                        end
                      until not t2 or (t2.Particles.Position - Root.Position).Magnitude < 5
                      task.wait(2)
                      _G.T2Yama = true
                    until _G.T2Yama or _G.CDK_YM == false or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 3
                    repeat
                      task.wait()
                      repeat
                        task.wait() 
                        local t3 = workspace.Map.HellDimension.Torch3
                        if t3 and t3.Particles then _tp(t3.Particles.CFrame) end
                        for i, v in pairs(workspace.Map.HellDimension:GetDescendants()) do
                          if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                        end
                      until not t3 or (t3.Particles.Position - Root.Position).Magnitude < 5
                      task.wait(2)
                      _G.T3Yama = true
                    until _G.T3Yama or _G.CDK_YM == false or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 3
                  end
                  for i,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position - spawnPos).Magnitude <= 300 then
                      if v.Humanoid and v.Humanoid.Health > 0 then
                        repeat
                          task.wait()
                          Attack.Kill(v,_G.CDK_YM)
                        until not _G.CDK_YM or v.Humanoid.Health <= 0 or not v.Parent or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 3
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end)
  end
end)

spawn(function()
  while task.wait(0.2) do
    pcall(function()
      if _G.CDK_YM then
        if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == -5 then
          if not workspace.Map:FindFirstChild("HellDimension") or (Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude > 1000 then
            local v = GetConnectionEnemies("Soul Reaper")
            if v and v.Parent and v.Humanoid and v.Humanoid.Health > 0 then
              repeat
                task.wait()
                _tp(v.HumanoidRootPart.CFrame)
              until v.Humanoid.Health <= 0 or not _G.CDK_YM or not v.Parent or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 3 or (workspace.Map:FindFirstChild("HellDimension") and (Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 1000)
            elseif plr.Backpack:FindFirstChild("Hallow Essence") or plr.Character:FindFirstChild("Hallow Essence") then
              repeat
                _tp(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))
                task.wait()
              until (CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125).Position - Root.Position).Magnitude <= 8
              EquipWeapon("Hallow Essence")
            elseif replicated:FindFirstChild("Soul Reaper") and replicated:FindFirstChild("Soul Reaper").Humanoid.Health > 0 then
              _tp(replicated:FindFirstChild("Soul Reaper").HumanoidRootPart.CFrame)
            else
              if replicated.Remotes.CommF_:InvokeServer("Bones","Check") < 50 and not workspace.Enemies:FindFirstChild("Soul Reaper") and not replicated:FindFirstChild("Soul Reaper") and not workspace.Map:FindFirstChild("HellDimension") then
                local hasTarget = false
                for i,v in pairs(workspace.Enemies:GetChildren()) do
                  if v.Name == "Reborn Skeleton" or v.Name == "Living Zombie" or v.Name == "Demonic Soul" or v.Name == "Posessed Mummy" then
                    if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                      hasTarget = true
                      repeat
                        task.wait()
                        Attack.Kill(v,_G.CDK_YM)
                      until not _G.CDK_YM or v.Humanoid.Health <= 0 or not v.Parent
                    end
                  end
                end
                if not hasTarget then
                  _tp(CFrame.new(-9515.2255859375, 164.0062255859375, 5785.38330078125))
                end
              else
                replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
              end
            end
          end
        end
      end
    end)
  end
end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Tushita CDK", Description = "", Default = false})
Q:OnChanged(function(Value) _G.CDK_TS = Value end)

spawn(function()
  while task.wait(0.2) do
    pcall(function()
      if _G.CDK_TS then
        local open = tostring(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor"))
        if open ~= "opened" then
          task.wait(0.7)
          replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")
          task.wait(0.3)
          replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
        else
          local prog = replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")
          if prog["Finished"] == nil then
            replicated.Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Good")
          elseif prog["Finished"] == false then
            local good = tonumber(prog["Good"])
            if good == -3 then
              QuestTushita_1 = true; QuestTushita_2 = false; QuestTushita_3 = false
              repeat
                task.wait()
                _tp(CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875))
              until (CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.CDK_TS or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == 1
              if (CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                task.wait(0.7)
                replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"),"Check")
                task.wait(0.5)
                replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
              end
              task.wait(1)
              repeat
                task.wait()
                _tp(CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125))
              until (CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.CDK_TS or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == 1
              if (CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                task.wait(0.7)
                replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"),"Check")
                task.wait(0.5)
                replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
              end
              task.wait(1)
              repeat
                task.wait()
                _tp(CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625))
              until (CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.CDK_TS or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == 1
              if (CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                task.wait(0.7)
                replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"),"Check")
                task.wait(0.5)
                replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
              end
              task.wait(1)
            elseif good == -4 then
              QuestTushita_1 = false; QuestTushita_2 = true; QuestTushita_3 = false
              repeat
                task.wait()
                _G.AutoRaidCastle = true
              until not _G.CDK_TS or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == 2 
              _G.AutoRaidCastle = false         
            elseif good == -5 then
              QuestTushita_1 = false; QuestTushita_2 = false; QuestTushita_3 = true
              local cake = GetConnectionEnemies("Cake Queen")
              if cake and cake.Parent and cake.Humanoid and cake.Humanoid.Health > 0 then
                repeat
                  task.wait()
                  Attack.Kill(cake, _G.CDK_TS)
                until not _G.CDK_TS or not cake.Parent or cake.Humanoid.Health <= 0 or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == 3
              elseif replicated:FindFirstChild("Cake Queen") and replicated:FindFirstChild("Cake Queen").Humanoid.Health > 0 then
                _tp(replicated:FindFirstChild("Cake Queen").HumanoidRootPart.CFrame * CFrame.new(0,30,0))
              else
                if workspace.Map:FindFirstChild("HeavenlyDimension") and (plr.Character.HumanoidRootPart.Position - workspace.Map.HeavenlyDimension.Spawn.Position).Magnitude <= 1000 then
                  local Ex = nil
                  for i,v in pairs(workspace.Map.HeavenlyDimension.Exit:GetChildren()) do Ex = i end
                  if Ex == 2 then
                    repeat
                      task.wait()
                      plr.Character.HumanoidRootPart.CFrame = workspace.Map.HeavenlyDimension.Exit.CFrame
                    until not _G.CDK_TS or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == 3
                  end
                  _G.DoneT1 = false; _G.DoneT2 = false; _G.DoneT3 = false
                  repeat
                    task.wait()
                    repeat
                      task.wait() 
                      _tp(CFrame.new(-22529.6171875, 5275.77392578125, 3873.5712890625)) 
                      for i, v in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                      end
                    until (CFrame.new(-22529.6171875, 5275.77392578125, 3873.5712890625).Position - plr.Character.HumanoidRootPart.Position).Magnitude < 5
                    task.wait(2)
                    _G.DoneT1 = true
                  until not _G.CDK_TS or _G.DoneT1
                  repeat
                    task.wait()
                    repeat
                      task.wait()
                      _tp(CFrame.new(-22637.291015625, 5281.365234375, 3749.28857421875)) 
                      for i, v in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                      end
                    until (CFrame.new(-22637.291015625, 5281.365234375, 3749.28857421875).Position - plr.Character.HumanoidRootPart.Position).Magnitude < 5
                    task.wait(2)
                    _G.DoneT2 = true
                  until _G.DoneT2 or not _G.CDK_TS
                  repeat
                    task.wait()
                    repeat
                      task.wait() 
                      _tp(CFrame.new(-22791.14453125, 5277.16552734375, 3764.570068359375)) 
                      for i, v in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                      end
                    until (CFrame.new(-22791.14453125, 5277.16552734375, 3764.570068359375).Position - plr.Character.HumanoidRootPart.Position).Magnitude < 5
                    task.wait(2)
                    _G.DoneT3 = true
                  until _G.DoneT3 or not _G.CDK_TS
                  for i,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position - CFrame.new(-22695.7012, 5270.93652, 3814.42847, 0.11794927, 3.32185834e-08, 0.99301964, -8.73070718e-08, 1, -2.30819008e-08, -0.99301964, -8.3975138e-08, 0.11794927).Position).Magnitude <= 300 then
                      if v.Humanoid and v.Humanoid.Health > 0 then
                        repeat
                          task.wait()
                          Attack.Kill(v, _G.CDK_TS)
                        until not _G.CDK_TS or v.Humanoid.Health <= 0 or not v.Parent
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end)
  end
end)

Tabs.Quests:AddSection("Dragon Talon V3")

local UpTalon = Tabs.Quests:AddToggle("UpTalon", {Title = "Upgrade Dragon Talon With Uzoth", Description = "", Default = false})

UpTalon:OnChanged(function(Value)

  _G.DT_Uzoth = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.DT_Uzoth then

      local Uz_POS = CFrame.new(5661.89014, 1211.31909, 864.836731, 0.811413169, -1.36805838e-08, -0.584473014, 4.75227395e-08, 1, 4.25682458e-08, 0.584473014, -6.23161966e-08, 0.811413169)

      _tp(Uz_POS)

      if (Uz_POS.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 25 then

        local ohTable1 = {["NPC"] = "Uzoth",["Command"] = "Upgrade"}

        replicated.Modules.Net["RF/InteractDragonQuest"]:InvokeServer(ohTable1)

      end

    end

  end

end)

Tabs.Quests:AddSection("True Triple Katana Sword")

Tabs.Quests:AddButton({Title = "Buy Legendary Sword", Description = "",

Callback = function()

  replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer","1")

  replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer","2")

  replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer","3")

end})

Tabs.Quests:AddButton({Title = "Buy True Triple Katana Sword", Description = "",

Callback = function()

  replicated.Remotes.CommF_:InvokeServer("MysteriousMan","2")

end})

local Q = Tabs.Quests:AddToggle("Q", {Title = "Tween to Legendary Sword Dealer", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Tp_LgS = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.Tp_LgS then

	  pcall(function()

	    for _,v in pairs(replicated.NPCs:GetChildren()) do

	      if v.Name == "Legendary Sword Dealer " then _tp(v.HumanoidRootPart.CFrame) end

        end   	   

	  end)

    end

  end

end)



Tabs.Quests:AddSection("Pole / God Enal's")

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Pole V1", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoPole = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.AutoPole then

      pcall(function()

        local v = GetConnectionEnemies("Thunder God")

	    if v then

          repeat task.wait() Attack.Kill(v, _G.AutoPole) until not _G.AutoPole or not v.Parent or v.Humanoid.Health <= 0

        else

          _tp(CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188))

        end

      end)

    end

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Pole V2 [Patched]", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoPoleV2 = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.AutoPoleV2 then        

	   if not GetBP("Pole (1st Form)") then replicated.Remotes.CommF_:InvokeServer("LoadItem","Pole (1st Form)") end

	   if not GetBP("Pole (2nd Form)") then replicated.Remotes.CommF_:InvokeServer("LoadItem","Pole (2nd Form)") end      

	   if GetBP("Pole (1st Form)") and GetBP("Pole (1st Form)").Level.Value <= 179 then _G.Level = true elseif GetBP("Pole (1st Form)") and GetBP("Pole (1st Form)").Level.Value >= 180 then _G.Level = false end	   

	   if not GetBP("Rumble Fruit") then return end

	   if GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("Z") and GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("X") and GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("C") and GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("V") and GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("F") then

	     _G.SelectChip = nil

		 _G.Raiding = false

		 _G.Auto_Awakener = false

		if plr.Data.Fragments.Value >= 5000 then

          replicated.Remotes.CommF_:InvokeServer("Thunder God", "Talk") wait(Sec)

          replicated.Remotes.CommF_:InvokeServer("Thunder God", "Sure")

        end

        elseif replicated.Remotes.CommF_:InvokeServer("Awakener","Check") == nil or replicated.Remotes.CommF_:InvokeServer("Awakener","Check") == 0 then

          _G.SelectChip = "Rumble"

          local Buying = replicated.Remotes.CommF_:InvokeServer("RaidsNpc","Select",_G.SelectChip)

          if Buying then Buying:Stop() end

          _G.Raiding = true

          _G.Auto_Awakener = true

	    end	   

      end

    end)

  end

end)



Tabs.Quests:AddSection("Items Law/Order Sword")

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Law Sword", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoLawKak = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.AutoLawKak then

      pcall(function()

        local v = GetConnectionEnemies("Order")

        if v then repeat task.wait() Attack.Kill(v, _G.AutoLawKak) until _G.AutoLawKak == false or not v.Parent or v.Humanoid.Health <= 0

        else _tp(CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875))

        end

      end)

    end

  end

end)

Tabs.Quests:AddButton({Title = "Buy Microchip Law", Description = "",

Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Microchip","2")

end})

Tabs.Quests:AddButton({Title = "Start Law Raids", Description = "",

Callback = function()

  fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)

end})



Tabs.Quests:AddSection("East Blue Misc")

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Saw Sword", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoSaw = Value

end)

spawn(function()

  while wait(.2) do

    pcall(function()

      if _G.AutoSaw then

        local v = GetConnectionEnemies("The Saw")

        if v then repeat task.wait() Attack.Kill(v, _G.AutoSaw)until _G.AutoSaw == false or v.Humanoid.Health <= 0

        else _tp(CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906))

        end

      end

    end)

  end

end)

Tabs.Quests:AddSection("World 1")

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Get Saber", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoSaber = Value

end)

spawn(function()

  while wait(.2) do

    pcall(function()

      if _G.AutoSaber and plr.Data.Level.Value >= 200 and not plr.Backpack:FindFirstChild("Saber") and not plr.Character:FindFirstChild("Saber") then

        if workspace.Map.Jungle.Final.Part.Transparency == 0 then

	      if workspace.Map.Jungle.QuestPlates.Door.Transparency == 0 then

		    if (CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-09, -0.928667724, 3.97099491e-08, 1, 1.91679348e-08, 0.928667724, -4.39869794e-08, 0.37091279).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 100 then

		      _tp(plr.Character.HumanoidRootPart.CFrame)

		      wait(0.5)

		      plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate1.Button.CFrame

		      wait(0.5)

		      plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate2.Button.CFrame

		      wait(0.5)

		      plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate3.Button.CFrame

	    	  wait(0.5)

		      plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate4.Button.CFrame

		      wait(0.5)

		      plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate5.Button.CFrame

		      wait(0.5) 

		    else

		      _tp(CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-09, -0.928667724, 3.97099491e-08, 1, 1.91679348e-08, 0.928667724, -4.39869794e-08, 0.37091279))

		    end

	      else

		    if workspace.Map.Desert.Burn.Part.Transparency == 0 then

		      if plr.Backpack:FindFirstChild("Torch") or plr.Character:FindFirstChild("Torch") then

		        EquipWeapon("Torch")

		        firetouchinterest(plr.Character.Torch.Handle,workspace.Map.Desert.Burn.Fire,0)

			    firetouchinterest(plr.Character.Torch.Handle,workspace.Map.Desert.Burn.Fire,1)

		   	    _tp(CFrame.new(1114.61475, 5.04679728, 4350.22803, -0.648466587, -1.28799094e-09, 0.761243105, -5.70652914e-10, 1, 1.20584542e-09, -0.761243105, 3.47544882e-10, -0.648466587))

		      else

		        _tp(CFrame.new(-1610.00757, 11.5049858, 164.001587, 0.984807551, -0.167722285, -0.0449818149, 0.17364943, 0.951244235, 0.254912198, 3.42372805e-05, -0.258850515, 0.965917408))                    end

		      else

		        if replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","SickMan") ~= 0 then

		          replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","GetCup")

			      wait(0.5)

			      EquipWeapon("Cup")

			      wait(0.5)

			      replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","FillCup",plr.Character.Cup)

			      wait(Sec)

			      replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","SickMan") 

		        else

		 	      if replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == nil then

			        replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon")

		          elseif replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == 0 then

			        if workspace.Enemies:FindFirstChild("Mob Leader") or replicated:FindFirstChild("Mob Leader") then

			          _tp(CFrame.new(-2967.59521, -4.91089821, 5328.70703, 0.342208564, -0.0227849055, 0.939347804, 0.0251603816, 0.999569714, 0.0150796166, -0.939287126, 0.0184739735, 0.342634559))

			         for i,v in pairs(workspace.Enemies:GetChildren()) do

				       if v.Name == "Mob Leader" and Attack.Alive(v) then

				       repeat task.wait() Attack.Kill(v, _G.AutoSaber)until v.Humanoid.Health <= 0 or _G.AutoSaber == false

				       end

				     end

			       end

			     elseif replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == 1 then

			       replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon")

				   EquipWeapon("Relic")

				  _tp(CFrame.new(-1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877e-09, 0.481375456, 2.53851997e-08, 1, -5.79995607e-08, -0.481375456, 6.30572643e-08, 0.876514494))

				 end

			   end

			 end

		   end

		 else

	     if workspace.Enemies:FindFirstChild("Saber Expert") or replicated:FindFirstChild("Saber Expert") then

	       for _,v in pairs(workspace.Enemies:GetChildren()) do

		     if v.Name == "Saber Expert" and Attack.Alive(v) then

			   repeat task.wait() Attack.Kill(v, _G.AutoSaber) until v.Humanoid.Health <= 0 or _G.AutoSaber == false

		       if v.Humanoid.Health <= 0 then replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","PlaceRelic") end		      

		      end

		    end

		  else

		    _tp(CFrame.new(-1401.85046, 29.9773273, 8.81916237, 0.85820812, 8.76083845e-08, 0.513301849, -8.55007443e-08, 1, -2.77243419e-08, -0.513301849, -2.00944328e-08, 0.85820812))

	      end

	    end

      end

    end)

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Cybrog", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoColShad = Value

end)

spawn(function()

  while wait(.2) do

    if _G.AutoColShad then

      pcall(function()

        local v = GetConnectionEnemies("Cyborg")

	    if v then repeat task.wait()Attack.Kill(v, _G.AutoColShad)until _G.AutoColShad == false or not v.Parent or v.Humanoid.Health <= 0

        else _tp(CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813))

        end

      end)

    end

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Usoap's Hat", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoGetUsoap = Value

end)

spawn(function()

  while task.wait(Sec) do

    pcall(function()

      if _G.AutoGetUsoap then

	   for _, v in pairs(workspace.Characters:GetChildren()) do

          if v.Name ~= plr.Name then

            if v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and v.Parent and (Root.Position - v.HumanoidRootPart.Position).Magnitude <= 230 then

              repeat task.wait() EquipWeapon(_G.SelectWeapon) _tp(v.HumanoidRootPart.CFrame * CFrame.new(1, 1, 2)) until _G.AutoGetUsoap == false or v.Humanoid.Health <= 0 or not v.Parent or not v:FindFirstChild("HumanoidRootPart") or not v:FindFirstChild("Humanoid")

            end

          end

        end

      end

    end)

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Bisento V2", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Greybeard = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.Greybeard then

      pcall(function()

        if not GetWP("Bisento") then

          replicated.Remotes.CommF_:InvokeServer("BuyItem","Bisento")

        elseif GetWP("Bisento") then

          replicated.Remotes.CommF_:InvokeServer("LoadItem","Bisento")

          local v = GetConnectionEnemies("Greybeard")

          if v then repeat wait() Attack.Kill(v,_G.Greybeard)until _G.Greybeard == false or not v.Parent or v.Humanoid.Health <= 0

          else _tp(CFrame.new(-5023.38330078125, 28.65203285217285, 4332.3818359375))

          end

        end

      end)

    end

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Warden Sword", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.WardenBoss = Value

end)

spawn(function()

  while wait(.1) do

    if _G.WardenBoss then

      pcall(function()

        local v = GetConnectionEnemies("Chief Warden")

        if v then repeat wait() Attack.Kill(v,_G.WardenBoss) until _G.WardenBoss == false or not v.Parent or v.Humanoid.Health <= 0 

        else _tp(CFrame.new(5206.92578,0.997753382,814.976746,0.342041343,-0.00062915677,0.939684749,0.00191645394,0.999998152,-2.80422337e-05,-0.939682961,0.00181045406,0.342041939))

        end

      end)

    end

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Marine Coat", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.MarinesCoat = Value

end)

spawn(function()

  while wait(.1) do

    if _G.MarinesCoat then

      pcall(function()

        local v = GetConnectionEnemies("Vice Admiral")

        if v then repeat wait() Attack.Kill(v, _G.MarinesCoat) until _G.MarinesCoat == false or not v.Parent or v.Humanoid.Health <= 0

        else _tp(CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375))

        end

      end)

    end

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Swan Coat", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.SwanCoat = Value

end)

spawn(function()

  while wait(.1) do

    if _G.SwanCoat then

      pcall(function()

        local v = GetConnectionEnemies("Swan")

        if v then repeat wait()Attack.Kill(v, _G.SwanCoat)until _G.SwanCoat == false or not v.Parent or v.Humanoid.Health <= 0

        else _tp(CFrame.new(5325.09619, 7.03906584, 719.570679, -0.309060812, 0, 0.951042235, 0, 1, 0, -0.951042235, 0, -0.309060812))

        end

      end)

    end

  end

end)


Tabs.Quests:AddSection("World 2")

local Q = Tabs.Quests:AddToggle("Q", {
    Title = "Auto Rengoku",
    Description = "",
    Default = false
})

Q:OnChanged(function(Value)
    _G.IceBossRen = Value
end)

spawn(function()
    while wait(.1) do
        pcall(function()
            if _G.IceBossRen then

                -- Chưa có Hidden Key thì đi farm Key
                if not plr.Backpack:FindFirstChild(RenMon[3]) and not plr.Character:FindFirstChild(RenMon[3]) then
                    local v = GetConnectionEnemies(RenMon)

                    if v then
                        repeat
                            task.wait()
                            Attack.Kill(v, _G.IceBossRen)
                        until not _G.IceBossRen
                            or plr.Backpack:FindFirstChild(RenMon[3])
                            or not v.Parent
                            or v.Humanoid.Health <= 0
                    else
                        _tp(CFrame.new(5439.716796875, 84.420944213867, -6715.1635742188))
                    end

                -- Có Hidden Key thì đi mở Rengoku
                elseif plr.Backpack:FindFirstChild(RenMon[3]) or plr.Character:FindFirstChild(RenMon[3]) then
                    EquipWeapon(RenMon[3])
                    task.wait(.1)
                    _tp(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875))

                -- Sau đó farm Awakened Ice Admiral
                else
                    local v = GetConnectionEnemies("Awakened Ice Admiral")

                    if v then
                        repeat
                            task.wait()
                            Attack.Kill(v, _G.IceBossRen)
                        until not _G.IceBossRen
                            or not v.Parent
                            or v.Humanoid.Health <= 0
                    else
                        _tp(CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813))
                    end
                end

            end
        end)
    end
end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Midnight Blade", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoEcBoss = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.AutoEcBoss then

	    if GetM("Ectoplasm") >= 99 then

	      replicated.Remotes.CommF_:InvokeServer("Ectoplasm","Buy", 3)	   

	    elseif GetM("Ectoplasm") <= 99 then

	      local v = GetConnectionEnemies("Cursed Captain")

	      if v then repeat wait()Attack.Kill(v, _G.AutoEcBoss) until not _G.AutoEcBoss or not v.Parent or v.Humanoid.Health <= 0

	      else

	        replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125)) wait(.5)

	        _tp(CFrame.new(916.928589, 181.092773, 33422))

	      end

	    end	

      end

    end)

  end

end)

Tabs.Quests:AddSection("Indra Boss")

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Rip Indra", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoRipIngay = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.AutoRipIngay then

        local v = GetConnectionEnemies("rip_indra")

	    if not GetWP("Dark Dagger") or not GetIn("Valkyrie") and v then

	      repeat wait() Attack.Kill(v,_G.AutoRipIngay)until not _G.AutoRipIngay or not v.Parent or v.Humanoid.Health <= 0

        else

          replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5097.93164, 316.447021, -3142.66602, -0.405007899, -4.31682743e-08, 0.914313197, -1.90943332e-08, 1, 3.8755779e-08, -0.914313197, -1.76180437e-09, -0.405007899))

		  wait(.1)_tp(CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781))

	    end

      end

    end)

  end

end)


Tabs.Quests:AddSection("Pay")

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Random Bones", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Auto_Random_Bone = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.Auto_Random_Bone then    

  	    repeat task.wait() replicated.Remotes.CommF_:InvokeServer("Bones","Buy",1,1) until not _G.Auto_Random_Bone

      end

    end)

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Try Luck Gravestone", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.TryLucky = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.TryLucky then

    local try_bones_luck = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)

      if (plr.Character.HumanoidRootPart.CFrame ~= try_bones_luck) then

        _tp(CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813))

	 elseif (plr.Character.HumanoidRootPart.CFrame == try_bones_luck) then

	   replicated.Remotes.CommF_:InvokeServer("gravestoneEvent",1)

      end

    end

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Pray Gravestone", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Praying = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.Praying then

    local try_bones_luck = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)

      if (plr.Character.HumanoidRootPart.CFrame ~= try_bones_luck) then

	   _tp(CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813))

      elseif (plr.Character.HumanoidRootPart.CFrame == try_bones_luck) then

	   replicated.Remotes.CommF_:InvokeServer("gravestoneEvent",2)

      end

    end

  end

end)


Tabs.Quests:AddSection("Sword")

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Black Spikey", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.BlackSpikey = Value

end)

spawn(function()

  while wait(.1) do

    if _G.BlackSpikey then

      pcall(function()

        local v = GetConnectionEnemies("Jeremy")

        if v then repeat wait() Attack.Kill(v, _G.BlackSpikey)until _G.BlackSpikey == false or not v.Parent or v.Humanoid.Health <= 0

        else _tp(CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109))

        end

      end)

    end

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Dark Blade V3", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.DarkBladev3 = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.DarkBladev3 and World2 then

      if not GetBP("Dark Blade") then replicated.Remotes.CommF_:InvokeServer("LoadItem","Dark Blade") end

        if GetBP("Fist of Darkness") > 1 then

          if not workspace.Enemies:FindFirstChild("Darkbeard") then

            _tp(CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531))

          elseif GetConnectionEnemies("Darkbeard") and GetBP("Fist of Darkness") >= 1 then

            repeat wait() _tp(CFrame.new(-5719.36376953125, 48.50590515136719, -782.9759521484375)) until not _G.DarkBladev3 or (Root.Position == CFrame.new(-5719.36376953125, 48.50590515136719, -782.9759521484375).Position)

            fireclickdetector(workspace.Map.GraveIsland.Mountain.Rocks.Button.ClickDetector)

          end         

        else

          _G.AutoFarmChest = true;

        end        

      end

    end)

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Unlocked DonSwan", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Auto_DonAcces = Value

end)

spawn(function()

  while wait(.1) do

    if _G.Auto_DonAcces then

      pcall(function()

        if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil and plr.Data.Level.Value >= 1500 then

          FruitPrice = {}

	      FruitStore = {}

		  for i,v in next,replicated:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits") do

		    if v.Price >= 1000000 then  

		     table.insert(FruitPrice,v.Name)

		    end

		  end

		  for i,v in pairs(replicated.Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do

		    for _,x in pairs(v) do

		      if _ == "Name" then 

		        table.insert(FruitStore,x)

		      end

	        end

	          replicated.Remotes.CommF_:InvokeServer("Cousin","Buy")

	          for _,y in pairs(FruitPrice) do

		        for _,z in pairs(FruitStore) do

		          if y == z and replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then

		            _G.StoreF = false

			      if not plr.Backpack:FindFirstChild(FruitStore) then

			        replicated.Remotes.CommF_:InvokeServer("LoadFruit",tostring(y))

			      else

			        replicated.Remotes.CommF_:InvokeServer("TalkTrevor","1")

			        replicated.Remotes.CommF_:InvokeServer("TalkTrevor","2")

			        replicated.Remotes.CommF_:InvokeServer("TalkTrevor","3")

			      end

			    end

		      end 

		    end

		    if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess ~= nil then

		      _G.StoreF = true

		      _G.Auto_DonAcces = false

		    end

	      end

        end

      end)

    end

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Swan Glasses", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Auto_SwanGG = Value

end)

spawn(function()

  while wait(.2) do

    if _G.Auto_SwanGG then

      pcall(function()

        local v = GetConnectionEnemies("Don Swan")

        if v then repeat wait() Attack.Kill(v,_G.Auto_SwanGG)until _G.Auto_SwanGG == false or not v.Parent or v.Humanoid.Health <= 0

	    else _tp(CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875))

        end

      end)

    end

  end

end)



Tabs.Quests:AddSection("Cavender + Twin Hooks + Bigmom")

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Bigmom", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoBigmom = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.AutoBigmom then

      pcall(function()

        local bx = GetConnectionEnemies("Cake Queen")

        if bx then repeat task.wait() Attack.Kill(bx, _G.AutoBigmom) until not _G.AutoBigmom or not bx.Parent or bx.Humanoid.Health <= 0

        else _tp(CFrame.new(-709.3132934570312, 381.6005859375, -11011.396484375))

        end

      end)

    end

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Canvendish Sword", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Auto_Cavender = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.Auto_Cavender then

        local v = GetConnectionEnemies("Beautiful Pirate")

	    if v then repeat wait() Attack.Kill(v,_G.Auto_Cavender)until not _G.Auto_Cavender or v.Humanoid.Health <= 0

	    else _tp(CFrame.new(5283.609375,22.56223487854,-110.78285217285))

	    end

      end

    end)

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Twin Hooks", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.TwinHook = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.TwinHook then

        local v = GetConnectionEnemies("Captain Elephant")

	    if v then repeat wait()Attack.Kill(v,_G.TwinHook)until not _G.TwinHook or v.Humanoid.Health <= 0

	    else

          replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375)) wait(.2)

          _tp(CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125))

	    end

      end

    end)

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Serpent Bow", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoSerpentBow = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.AutoSerpentBow then

      local v = GetConnectionEnemies("Hydra Leader")

      if v then	repeat wait() Attack.Kill(v,_G.AutoSerpentBow)until not _G.AutoSerpentBow or not v.Parent or v.Humanoid.Health <= 0

	  else _tp(CFrame.new(5821.89794921875, 1019.0950927734375, -73.71923065185547))

      end

    end

  end

end)

local Q = Tabs.Quests:AddToggle("Q", {Title = "Auto Lei Accessory", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoKilo = Value

end)

spawn(function()

  while wait(.2) do

    if _G.AutoKilo then

      pcall(function()

        local v = GetConnectionEnemies("Kilo Admiral")

        if v then repeat task.wait()Attack.Kill(v,_G.AutoKilo)until not _G.AutoKilo or not v.Parent or v.Humanoid.Health <= 0

        else _tp(CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125))

        end

      end)

    end

  end

end)


Tabs.Mirage:AddSection("Drago Trial")

GetQuestDracoLevel = function()

  local v371 = {[1] = {NPC = "Dragon Wizard",Command = "Upgrade"}};

  return replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(v371))

end

Toggle = Tabs.Mirage:AddToggle("Toggle", {Title = "Tween To Upgrade Droco Trial", Description = "", Default = false})

Toggle:OnChanged(function(Value)

  _G.UPGDrago = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.UPGDrago then     

        if GetQuestDracoLevel() == false then

          return nil

        elseif GetQuestDracoLevel() == true then

          if (CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938).Position - Root.Position).Magnitude >= 300 then

            _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938));

          else

            _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938));

            local v371 = {[1] = {NPC = "Dragon Wizard",Command = "Upgrade"}};

            replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(v371));

          end

        end

      end

    end)

  end

end)

Toggle = Tabs.Mirage:AddToggle("Toggle", {Title = "Auto Drago (V1)", Description = "turn on for auto quest1 auto prehistoric event + collect dragon eggs", Default = false})

Toggle:OnChanged(function(Value)

  _G.DragoV1 = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.DragoV1 then     

        if GetM("Dragon Egg") <= 0 then

        repeat wait()

          _G.Prehis_Find = true

          _G.Prehis_Skills = true

          _G.Prehis_DE = true

        until not _G.DragoV1 or GetM("Dragon Egg") >= 1

          _G.Prehis_Find = false

          _G.Prehis_Skills = false

          _G.Prehis_DE = false

        end

      end

    end)

  end

end)

local fireflower = Tabs.Mirage:AddToggle("fireflower", {Title = "Auto Drago (V2)", Description = "turn on for auto kill Forest Pirate & Collect fireflower", Default = false})

fireflower:OnChanged(function(Value)

  _G.AutoFireFlowers = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.AutoFireFlowers then

      local FireFlower = workspace:FindFirstChild("FireFlowers")

      local v = GetConnectionEnemies("Forest Pirate")

      if v then repeat wait() Attack.Kill(v,_G.AutoFireFlowers) until not _G.AutoFireFlowers or not v.Parent or v.Humanoid.Health <= 0 or FireFlower

      else _tp(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375))

      end      

      if FireFlower then

        for i, v in pairs(FireFlower:GetChildren()) do

          if (v:IsA("Model") and v.PrimaryPart) then

            local FlowerPos = v.PrimaryPart.Position;

            local playerRoot = game.Players.LocalPlayer.Character.HumanoidRootPart.Position;

            local Magnited = (FlowerPos - playerRoot).Magnitude;

            if (Magnited <= 100) then

              vim1:SendKeyEvent(true, "E", false, game) wait(1.5) vim1:SendKeyEvent(false, "E", false, game)

            else

              _tp(CFrame.new(FlowerPos));

            end

          end

        end

      end

    end

  end

end)

Toggle = Tabs.Mirage:AddToggle("Toggle", {Title = "Auto Drago (V3)", Description = "turn on for sea event kill terror shark", Default = false})

Toggle:OnChanged(function(Value)

  _G.DragoV3 = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.DragoV3 then     

        repeat wait()

          _G.DangerSc = "Lv Infinite"

          _G.SailBoats = true

          _G.TerrorShark = true

        until not _G.DragoV3

        _G.DangerSc = "Lv 1"

        _G.SailBoats = false

        _G.TerrorShark = false

      end

    end)

  end

end)

Toggle = Tabs.Mirage:AddToggle("Toggle", {Title = "Auto Relic Drago Trial", Description = "turn on for auto trial v4 you have to COLLECT RELIC by your self", Default = false})

Toggle:OnChanged(function(Value)

  _G.Relic123 = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.Relic123 then

      pcall(function()

        if workspace.Map:FindFirstChild("DracoTrial") then

          replicated.Remotes.DracoTrial:InvokeServer()                  

          wait(.5)

          repeat wait() _tp(CFrame.new(-39934.9765625, 10685.359375, 22999.34375)) until not _G.Relic123 or (Root.Position == CFrame.new(-39934.9765625, 10685.359375, 22999.34375).Position)

          repeat wait() _tp(CFrame.new(-40511.25390625, 9376.4013671875, 23458.37890625)) until not _G.Relic123 or (Root.Position == CFrame.new(-40511.25390625, 9376.4013671875, 23458.37890625).Position)

          wait(2.5)

          repeat wait() _tp(CFrame.new(-39914.65625, 10685.384765625, 23000.177734375)) until not _G.Relic123 or (Root.Position == CFrame.new(-39914.65625, 10685.384765625, 23000.177734375).Position)

          repeat wait() _tp(CFrame.new(-40045.83203125, 9376.3984375, 22791.287109375)) until not _G.Relic123 or (Root.Position == CFrame.new(-40045.83203125, 9376.3984375, 22791.287109375).Position)

          wait(2.5)

          repeat wait() _tp(CFrame.new(-39908.5, 10685.4052734375, 22990.04296875)) until not _G.Relic123 or (Root.Position == CFrame.new(-39908.5, 10685.4052734375, 22990.04296875).Position)

          repeat wait() _tp(CFrame.new(-39609.5, 9376.400390625, 23472.94335975)) until not _G.Relic123 or (Root.Position == CFrame.new(-39609.5, 9376.400390625, 23472.94335975).Position) 

        else

          local drago = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")

          if drago and drago:IsA("Part") then _tp(CFrame.new(drago.Position)) end        

        end

      end)

    end

  end

end)

Toggle = Tabs.Mirage:AddToggle("Toggle", {Title = "Auto Train Drago v4", Description = "turn on for training Drago race v4 + auto upgrade tier", Default = false})

Toggle:OnChanged(function(Value)

  _G.TrainDrago = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.TrainDrago then

        local DragoM = {"Venomous Assailant","Hydra Enforcer"}

	    for i=1,#DragoM do

          if plr.Character:FindFirstChild("RaceEnergy").Value == 1 then

            vim1:SendKeyEvent(true, "Y", false, game)

            replicated.Remotes.CommF_:InvokeServer("UpgradeRace","Buy",2)

            _tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.0868835449219))

	      elseif plr.Character:FindFirstChild("RaceTransformed").Value == false then

	        local v = GetConnectionEnemies(DragoM)

	        if v then repeat wait() Attack.Kill(v, _G.TrainDrago) until _G.TrainDrago == false or v.Humanoid.Health <= 0 or not v.Parent                    		

		    else _tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.0868835449219))

		    end

	      end

        end

      end

    end)

  end

end)

local dragoTpVolcano = Tabs.Mirage:AddToggle("dragoTpVolcano", {Title = "Tween to Drago Trials", Description = "", Default = false})

dragoTpVolcano:OnChanged(function(Value)

  _G.TpDrago_Prehis = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.TpDrago_Prehis then

      local v748 = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport");

      if (v748 and v748:IsA("Part")) then _tp(CFrame.new(v748.Position)) end

    end

  end

end)

local bdrago = Tabs.Mirage:AddToggle("bdrago", {Title = "Swap Drago Race", Description = "", Default = false})

bdrago:OnChanged(function(Value)

  _G.BuyDrago = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.BuyDrago then

      pcall(function()

        if (CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938).Position - Root.Position).Magnitude >= 300 then

          _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938));

        else

          _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938));

          local v371 = {[1] = {NPC = "Dragon Wizard",Command = "DragonRace"}};

          replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(v371));

        end

      end)

    end

  end

end)

Tabs.Mirage:AddSection("Mystic Island")

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Find Mirage Island", Description = "turn on for finding & tween mirage island", Default = false})

Q:OnChanged(function(Value)

  _G.FindMirage = Value

end)

spawn(function()

  while wait() do

    if _G.FindMirage then 

      pcall(function()

        if not workspace["_WorldOrigin"].Locations:FindFirstChild("Mirage Island", true) then                

          local myBoat = CheckBoat()

          if not myBoat then

            local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)

            TeleportToTarget(buyBoatCFrame)

            if (buyBoatCFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat) end

          else

            if plr.Character.Humanoid.Sit == false then

              local boatSeatCFrame = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)

              _tp(boatSeatCFrame)

            else            

              repeat wait()

                local targetDestination = CFrame.new(-10000000, 31, 37016.25)

                if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then

                  _tp(CFrame.new(-10000000, 150, 37016.25))

                else

                  _tp(CFrame.new(-10000000, 31, 37016.25))

                end

              until not _G.FindMirage or (targetDestination.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 or workspace["_WorldOrigin"].Locations:FindFirstChild("Mirage Island") or plr.Character.Humanoid.Sit == false plr.Character.Humanoid.Sit = false

            end

          end

        else

          _tp(workspace.Map.MysticIsland.Center.CFrame*CFrame.new(0,300,0))

        end

      end)

    end

  end

end)

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Tween To Highest Point", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.HighestMirage = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.HighestMirage then 

      pcall(function()

      if workspace["_WorldOrigin"].Locations:FindFirstChild("Mirage Island",true) then _tp(workspace.Map.MysticIsland.Center.CFrame*CFrame.new(0,400,0))end

      end)

    end

  end

end)

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Collect Gear", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.TPGEAR = Value

end)

spawn(function()

  pcall(function()

    while wait(0.1) do

      if _G.TPGEAR then

        for i,v in pairs(workspace.Map:FindFirstChild('MysticIsland'):GetChildren()) do

          if v.Name == "Part" then

            if v.ClassName == "MeshPart" then _tp(v.CFrame) end

          end

        end

      end

    end

  end)

end)

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Change Transparency can see", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.can = Value

end)

spawn(function()

  pcall(function()

    while wait(Sec) do

      if _G.can then

        for i,v in pairs(workspace.Map:FindFirstChild('MysticIsland'):GetChildren()) do

          if v.Name == "Part" then

            if v.ClassName == "MeshPart" then

              v.Transparency = 0

            else 

              v.Transparency = 1

            end

          end

        end

      end

    end

  end)

end)

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Tween Advanced Fruit Dealer", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Addealer = Value

end)

spawn(function()

  while wait() do

    if _G.Addealer then

	  pcall(function()

	    for _,v in pairs(replicated.NPCs:GetChildren()) do

	    if v.Name == "Advanced Fruit Dealer" then _tp(v.HumanoidRootPart.CFrame) end

        end   	   

	 end)

    end

  end

end)

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Collect Mirage Chest", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.FarmChestM = Value

end)

spawn(function()

  while wait(.2) do

    if _G.FarmChestM then

      pcall(function()

        if workspace.Map.MysticIsland.Chests:FindFirstChild("DiamondChest") or workspace.Map.MysticIsland.Chests:FindFirstChild("FragChest") then

          local CollectionService = game:GetService("CollectionService")

          local Players = game:GetService("Players")

          local Player = Players.LocalPlayer

          local Character = Player.Character or Player.CharacterAdded:Wait()                

          if not Character then return end                

          local Position = Character:GetPivot().Position

          local Chests = CollectionService:GetTagged("_ChestTagged")      

          local Distance, Nearest = math.huge, nil  

          for i = 1, #Chests do

            local Chest = Chests[i]

            local Magnitude = (Chest:GetPivot().Position - Position).Magnitude        

            if not SelectedIsland or Chest:IsDescendantOf(SelectedIsland) then

              if not Chest:GetAttribute("IsDisabled") and Magnitude < Distance then

                Distance = Magnitude

                Nearest = Chest

              end

            end

          end

        if Nearest then _tp(Nearest:GetPivot()) end

        end

      end)

    end

  end

end)



Tabs.Mirage:AddSection("Skull Guitars / Misc")

local CheckSoul = Tabs.Mirage:AddParagraph({Title = " Skull Guitar Quests ",Content = ""})

spawn(function()
  while task.wait(0.2) do
    pcall(function()
      local desc = " Quest Number : "
      if Quest1 then desc = desc .. "Quest1"
      elseif Quest2 then desc = desc .. "Quest2"
      elseif Quest3 then desc = desc .. "Quest3"
      elseif Quest4 then desc = desc .. "Quest4"
      elseif GetWP("Skull Guitar") then desc = desc .. "Collect!!"
      else desc = desc .. "No Quest!!"
      end
      CheckSoul:SetDesc(desc)
    end)
  end
end)

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Skull Guitar", Description = "", Default = false})
Q:OnChanged(function(Value) _G.Auto_Soul_Guitar = Value end)

task.spawn(function()
  while task.wait(0.3) do
    if _G.Auto_Soul_Guitar then
      pcall(function()
        local zombie = GetConnectionEnemies("Living Zombie")
        if zombie and zombie:FindFirstChild("HumanoidRootPart") then
          local targetCF = CFrame.new(-10138.3974609375, 138.6524658203125, 5902.89208984375)
          zombie.HumanoidRootPart.CFrame = targetCF
          zombie.HumanoidRootPart.CanCollide = false
          zombie.HumanoidRootPart.Size = Vector3.new(2,2,2)
          zombie.Humanoid.JumpPower = 0
          zombie.Humanoid.WalkSpeed = 0
          if zombie:FindFirstChild("Head") then zombie.Head.CanCollide = false end
          if zombie.Humanoid:FindFirstChild("Animator") then zombie.Humanoid.Animator:Destroy() end
          sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
        end
      end)
    end
  end
end)

local function getT(num)
  local seg = workspace.Map["Haunted Castle"].Tablet["Segment"..num]
  if seg and seg:FindFirstChild("Line") then return seg.Line.Rotation.Z end
  return nil
end

local function getRT(num)
  local trophy = workspace.Map["Haunted Castle"].Trophies.Quest["Trophy"..num]
  if trophy and trophy:FindFirstChild("Handle") then return trophy.Handle.Rotation.Z end
  return nil
end

local function FirePlacard(num, side)
  local placard = workspace.Map["Haunted Castle"]["Placard"..num]
  if not placard then return end
  local sidePart = placard[side]
  if not sidePart then return end
  local indicator = sidePart:FindFirstChild("Indicator")
  if indicator and indicator.BrickColor.Name ~= "Pearl" then
    local click = sidePart:FindFirstChild("ClickDetector")
    if click then fireclickdetector(click) end
  end
end

task.spawn(function()
  local Remotes = game:GetService("ReplicatedStorage").Remotes.CommF_
  while task.wait(0.3) do
    pcall(function()
      if not _G.Auto_Soul_Guitar then return end
      if not World3 then return end
      Remotes:InvokeServer("gravestoneEvent", 2)
      Remotes:InvokeServer("gravestoneEvent", 2, true)
      local progress = Remotes:InvokeServer("GuitarPuzzleProgress", "Check")
      if not progress then
        _tp(CFrame.new(-8655.0166015625, 141.3166961669922, 6160.0224609375))
        Remotes:InvokeServer("gravestoneEvent", 2)
        Remotes:InvokeServer("gravestoneEvent", 2, true)
        return
      end
      if not progress.Swamp then
        Quest1 = true; Quest2 = false; Quest3 = false; Quest4 = false
        local zombie = GetConnectionEnemies("Living Zombie")
        if zombie and zombie.Parent and zombie.Humanoid and zombie.Humanoid.Health > 0 then
          repeat
            task.wait()
            _tp(zombie.HumanoidRootPart.CFrame * CFrame.new(0,20,0))
            zombie.HumanoidRootPart.CanCollide = false
            zombie.HumanoidRootPart.Size = Vector3.new(50,50,50)
            Attack.Kill(zombie, _G.Auto_Soul_Guitar)
          until not _G.Auto_Soul_Guitar or not zombie.Parent or zombie.Humanoid.Health <= 0 or workspace.Map["Haunted Castle"].SwampWater.Color ~= Color3.fromRGB(117,0,0)
        else
          _tp(CFrame.new(-10170.7275390625, 138.6524658203125, 5934.26513671875))
        end
        return
      end
      if not progress.Gravestones then
        Quest1 = false; Quest2 = true; Quest3 = false; Quest4 = false
        FirePlacard("7","Left")
        FirePlacard("6","Left")
        FirePlacard("5","Left")
        FirePlacard("4","Right")
        FirePlacard("3","Left")
        FirePlacard("2","Right")
        FirePlacard("1","Right")
        return
      end
      if not progress.Ghost then
        Remotes:InvokeServer("GuitarPuzzleProgress", "Ghost")
        Remotes:InvokeServer("GuitarPuzzleProgress", "Ghost", true)
        return
      end
      if not progress.Trophies then
        Quest1 = false; Quest2 = false; Quest3 = true; Quest4 = false
        _tp(CFrame.new(-9532.8232421875, 6.471667766571045, 6078.068359375))
        local function alignSegment(seg, trophy)
          repeat
            task.wait()
            local target = getRT(trophy)
            local current = getT(seg)
            if target and current then
              local segObj = workspace.Map["Haunted Castle"].Tablet["Segment"..seg]
              if segObj and segObj:FindFirstChild("ClickDetector") then
                fireclickdetector(segObj.ClickDetector)
              end
            end
          until target == current or not _G.Auto_Soul_Guitar
        end
        alignSegment(1,1)
        alignSegment(3,2)
        alignSegment(4,3)
        alignSegment(7,4)
        alignSegment(10,5)
        for _, segNum in ipairs({2,5,6,8,9}) do
          local seg = workspace.Map["Haunted Castle"].Tablet["Segment"..segNum]
          if seg and seg:FindFirstChild("ClickDetector") then
            repeat
              task.wait()
              fireclickdetector(seg.ClickDetector)
            until seg.Line.Rotation.Z == 0 or not _G.Auto_Soul_Guitar
          end
        end
        return
      end
      if not progress.Pipes then
        Quest1 = false; Quest2 = false; Quest3 = false; Quest4 = true
        local model = workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model
        local parts = {"Part3","Part4","Part6","Part8","Part10"}
        local clicks = {Part3=1, Part4=3, Part6=2, Part8=1, Part10=3}
        for _, name in ipairs(parts) do
          local part = model[name]
          if part and part:FindFirstChild("ClickDetector") then
            for _ = 1, (clicks[name] or 1) do
              _tp(part.CFrame)
              fireclickdetector(part.ClickDetector)
              task.wait(0.15)
            end
          end
        end
        return
      end
      Quest1 = false; Quest2 = false; Quest3 = false; Quest4 = false
    end)
  end
end)

local Q2 = Tabs.Mirage:AddToggle("Q", {Title = "Auto Farm Material Skull Guitar", Description = "", Default = false})
Q2:OnChanged(function(Value) _G.AutoMatSoul = Value end)

task.spawn(function()
  local Remotes = game:GetService("ReplicatedStorage").Remotes.CommF_
  while task.wait(0.3) do
    pcall(function()
      if not _G.AutoMatSoul then return end
      if GetWP("Skull Guitar") then return end
      local bones = GetM("Bones") or 0
      local ecto = GetM("Ectoplasm") or 0
      local dark = GetM("Dark Fragment") or 0
      if bones >= 500 and ecto >= 250 and dark >= 1 then
        Remotes:InvokeServer("soulGuitarBuy", true)
        return
      end
      if ecto < 250 then
        if World2 then
          local mob = GetConnectionEnemies({"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior"})
          if mob and mob.Parent and mob.Humanoid and mob.Humanoid.Health > 0 then
            repeat
              task.wait()
              _tp(mob.HumanoidRootPart.CFrame * CFrame.new(0,20,0))
              Attack.Kill(mob, _G.AutoMatSoul)
            until not _G.AutoMatSoul or not mob.Parent or mob.Humanoid.Health <= 0
          else
            Remotes:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
          end
        else
          Remotes:InvokeServer("TravelDressrosa")
        end
        return
      end
      if dark < 1 then
        if World2 then
          local darkbeard = GetConnectionEnemies("Darkbeard")
          if darkbeard and darkbeard.Parent and darkbeard.Humanoid and darkbeard.Humanoid.Health > 0 then
            repeat
              task.wait()
              _tp(darkbeard.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
              Attack.Kill(darkbeard, _G.AutoMatSoul)
            until not _G.AutoMatSoul or not darkbeard.Parent or darkbeard.Humanoid.Health <= 0
          else
            _tp(CFrame.new(3798.4575195313, 13.826690673828, -3399.806640625))
            if not GetConnectionEnemies("Darkbeard") then Hop() end
          end
        else
          Remotes:InvokeServer("TravelDressrosa")
        end
        return
      end
      if bones < 500 then
        if World3 then
          local mob = GetConnectionEnemies({"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"})
          if mob and mob.Parent and mob.Humanoid and mob.Humanoid.Health > 0 then
            repeat
              task.wait()
              _tp(mob.HumanoidRootPart.CFrame * CFrame.new(0,20,0))
              Attack.Kill(mob, _G.AutoMatSoul)
            until not _G.AutoMatSoul or not mob.Parent or mob.Humanoid.Health <= 0
          else
            _tp(CFrame.new(-9504.8564453125, 172.14292907714844, 6057.259765625))
          end
        else
          Remotes:InvokeServer("TravelZou")
        end
        return
      end
    end)
  end
end)

Tabs.Mirage:AddButton({Title = "Talk With Stone", Description = "",

Callback = function()

  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Begin")

  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Check")

  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Teleport")

  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Continue")

end})

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Look At Moon", Description = "", Default = false})

Q:OnChanged(function(Value)

  LookM = Value

end)

function MoveCamtoMoon()

workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position,Lighting:GetMoonDirection() + workspace.CurrentCamera.CFrame.Position)

plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position,Lighting:GetMoonDirection() + plr.Character.HumanoidRootPart.CFrame.Position)

end

task.spawn(function()

  while task.wait() do

    if LookM then

      MoveCamtoMoon()

      wait(.1)

      replicated.Remotes.CommE:FireServer("ActivateAbility")

    end

  end

end)



Tabs.Mirage:AddSection("Trials Quests / Misc V4")

local CheckTier = Tabs.Mirage:AddParagraph({Title = " Tiers V4 Status ",Content = ""})

spawn(function()

  pcall(function()

    while wait(.2) do

      CheckTier:SetDesc(" Tiers - V4  :" .." "..plr.Data.Race.C.Value)

    end

  end)

end)

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Pull Lever", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Lver = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.Lver then

      pcall(function()

        for x,c in pairs(workspace.Map["Temple of Time"]:GetDescendants()) do

        if c.Name == "ProximityPrompt" then fireproximityprompt(c,math.huge)end

        end

      end)

    end

  end

end)

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Train V4", Description = "turn on for farm tier + auto upgrade your tier level", Default = false})

Q:OnChanged(function(Value)

  _G.AcientOne = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.AcientOne then

        local BonesTable = {"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"}

	    for i=1,#BonesTable do

          if plr.Character:FindFirstChild("RaceEnergy").Value == 1 then

            vim1:SendKeyEvent(true, "Y", false, game)

            replicated.Remotes.CommF_:InvokeServer("UpgradeRace","Buy")

            _tp(CFrame.new(-8987.041015625, 215.862060546875, 5886.71044921875))

	      elseif plr.Character:FindFirstChild("RaceTransformed").Value == false then

	        local v = GetConnectionEnemies(BonesTable)

	        if v then repeat wait() Attack.Kill(v, _G.AcientOne) until _G.AcientOne == false or v.Humanoid.Health <= 0 or not v.Parent

		    else _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) 

		    end

	      end

        end

      end

    end)

  end

end)

Tabs.Mirage:AddButton({Title = "Teleport to Temple of Time", Description = "",

Callback = function()

  game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(28286.35546875, 14895.3017578125, 102.62469482421875))

end})

Tabs.Mirage:AddButton({Title = "Teleport to Ancient One", Description = "",

Callback = function()

  notween(CFrame.new(28981.552734375, 14888.4267578125, - 120.245849609375))

end})

Tabs.Mirage:AddButton({Title = "Teleport to Ancient Clock", Description = "",

Callback = function()

  notween(CFrame.new(29549, 15069, -88))

end})

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Teleport to Race Doors", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.TPDoor = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.TPDoor then

	    if tostring(plr.Data.Race.Value) == "Mink" then

          _tp(CFrame.new(29020.66015625, 14889.4267578125, -379.2682800292969))

	    elseif tostring(plr.Data.Race.Value) == "Fishman" then

          _tp(CFrame.new(28224.056640625, 14889.4267578125, -210.5872039794922))

	    elseif tostring(plr.Data.Race.Value) == "Cyborg" then

          _tp(CFrame.new(28492.4140625, 14894.4267578125, -422.1100158691406))

	    elseif tostring(plr.Data.Race.Value) == "Skypiea" then

          _tp(CFrame.new(28967.408203125, 14918.0751953125, 234.31198120117188))

	    elseif tostring(plr.Data.Race.Value) == "Ghoul" then

          _tp(CFrame.new(28672.720703125, 14889.1279296875, 454.5961608886719))

	    elseif tostring(plr.Data.Race.Value) == "Human" then

          _tp(CFrame.new(29237.294921875, 14889.4267578125, -206.94955444335938))

	    end

      end

    end)

  end

end)                   

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Complete Trial Race", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Complete_Trials = Value

end)

GetSeaBeastTrial = function()

  if not workspace.Map:FindFirstChild("FishmanTrial") then return nil end

  if workspace["_WorldOrigin"].Locations:FindFirstChild("Trial of Water") then FishmanTrial = workspace["_WorldOrigin"].Locations:FindFirstChild("Trial of Water") end

  if FishmanTrial then

    for _,v in next, workspace.SeaBeasts:GetChildren() do

      if v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position - FishmanTrial.Position).Magnitude <= 1500 then

      if v.Health.Value > 0 then return v end

      end

    end

  end

end

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.Complete_Trials then

        if tostring(plr.Data.Race.Value) == "Mink" then

          notween(workspace.Map.MinkTrial.Ceiling.CFrame * CFrame.new(0,-20,0))

	   end

      end

    end)

  end

end)

spawn(function()

  while wait(Sec) do

    pcall(function() 

      if _G.Complete_Trials then

	    if tostring(plr.Data.Race.Value) == "Fishman" then

	      if GetSeaBeastTrial() then            

            repeat task.wait()

              spawn(function()_tp(CFrame.new(GetSeaBeastTrial().HumanoidRootPart.Position.X,game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y + 300,GetSeaBeastTrial().HumanoidRootPart.Position.Z))end)

		      MousePos = GetSeaBeastTrial().HumanoidRootPart.Position

              Useskills("Melee","Z")

	          Useskills("Melee","X")

	          Useskills("Melee","C")

              wait(.1)

              Useskills("Sword","Z")

              Useskills("Sword","X")

              wait(.1)

              Useskills("Blox Fruit","Z")

              Useskills("Blox Fruit","X")

              Useskills("Blox Fruit","C")

              wait(.1)

              Useskills("Gun","Z")

              Useskills("Gun","X")

            until _G.Complete_Trials == false or not GetSeaBeastTrial()

          end          

	    end

      end

    end)

  end

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.Complete_Trials then

        if tostring(plr.Data.Race.Value) == "Cyborg" then

         _tp(workspace.Map.CyborgTrial.Floor.CFrame * CFrame.new(0,500,0))

   	   end

      end

    end)

  end

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.Complete_Trials then

        if tostring(plr.Data.Race.Value) == "Skypiea" then

          notween(workspace.Map.SkyTrial.Model.FinishPart.CFrame)

  	   end

      end

    end)

  end

end)

spawn(function()

  while wait(.1) do   

    pcall(function()

      if _G.Complete_Trials then

	    if tostring(plr.Data.Race.Value) == "Human" or tostring(plr.Data.Race.Value) == "Ghoul" then	      

	      local TrialsTables = {"Ancient Vampire","Ancient Zombie"}

	      local v = GetConnectionEnemies(TrialsTables)

          if v then repeat wait() Attack.Kill(v, _G.Complete_Trials)until _G.Complete_Trials == false or not v.Parent or v.Humanoid.Health <= 0 end		

        end

      end

    end)

  end

end)

local Q = Tabs.Mirage:AddToggle("Q", {Title = "Auto Kill Player After Trial", Description = "turn on for kill player after the race trials", Default = false})

Q:OnChanged(function(Value)

  _G.Defeating = Value

end)

spawn(function()

  while task.wait(Sec) do

    pcall(function()

      if _G.Defeating then

	    for _, v in pairs(workspace.Characters:GetChildren()) do

          if v.Name ~= plr.Name then

            if v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and v.Parent and (Root.Position - v.HumanoidRootPart.Position).Magnitude <= 250 then

              repeat task.wait() EquipWeapon(_G.SelectWeapon) _tp(v.HumanoidRootPart.CFrame * CFrame.new(0,0,15)) sethiddenproperty(plr, "SimulationRadius", math.huge)until _G.Defeating == false or v.Humanoid.Health <= 0 or not v.Parent or not v:FindFirstChild("HumanoidRootPart") or not v:FindFirstChild("Humanoid")

            end

          end

        end

      end

    end)

  end

end)


Tabs.SeaEvent:AddSection("Prehistoric")

Toggle = Tabs.SeaEvent:AddToggle("Toggle", {Title = "Auto Craft Volcanic Magnet", Description = "turn on for auto farm material and craft volcanic magnet & stop when you have 1 volcanic magnet", Default = false})

Toggle:OnChanged(function(Value)

  _G.CraftVM = Value

end)

Tabs.SeaEvent:AddButton({Title = "Craft Volcanic Magnet", Description = "",

Callback = function()

  replicated.Remotes.CommF_:InvokeServer("CraftItem","Craft","Volcanic Magnet")

end})

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.CraftVM then     

        if GetM("Volcanic Magnet") < 1 then

          if GetM("Scrap Metal") >= 10 and GetM("Blaze Ember") >= 15 then

            replicated.Remotes.CommF_:InvokeServer("CraftItem","Craft","Volcanic Magnet")

          elseif GetM("Scrap Metal") < 10 then

            local v = GetConnectionEnemies("Forest Pirate")

            if v then repeat wait() Attack.Kill(v,_G.CraftVM) until not _G.CraftVM or not v.Parent or v.Humanoid.Health <= 0 or GetM("Scrap Metal") >= 10

            else _tp(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375))

            end     

          elseif GetM("Blaze Ember") < 15 then

            repeat wait() _G.FarmBlazeEM = true until not _G.CraftVM or GetM("Blaze Ember") >= 15 _G.FarmBlazeEM = false

          end   

        end            

      end

    end)

  end

end)


Tabs.SeaEvent:AddSection("Prehistoric")

local Check_Volcano = Tabs.SeaEvent:AddParagraph({Title = " Prehistoric Island Status ",Content = ""})

spawn(function()

  while wait(.2) do

    if workspace.Map:FindFirstChild("PrehistoricIsland") or workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") then

      Check_Volcano:SetDesc(" Prehistoric Island : True")

    else

      Check_Volcano:SetDesc(" Prehistoric Island : False")

    end

  end

end)

Vocan = Tabs.SeaEvent:AddToggle("Vocan", {Title = "Auto Find Prehistoric Island", Description = "turn on for finding & tween & start prehistoric island", Default = false})

Vocan:OnChanged(function(Value)

  _G.Prehis_Find = Value

end)

local targetDestination = nil

spawn(function()

  while wait() do

    if _G.Prehis_Find then 

      pcall(function()

        if not workspace["_WorldOrigin"].Locations:FindFirstChild("Prehistoric Island", true) then                

          local myBoat = CheckBoat()

          if not myBoat then

            local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)

            TeleportToTarget(buyBoatCFrame)

            if (buyBoatCFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat) end

          else

            if plr.Character.Humanoid.Sit == false then

              local boatSeatCFrame = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)

              _tp(boatSeatCFrame)

            else                            

              repeat wait() 

                local targetDestination = CFrame.new(-10000000, 31, 37016.25)

                if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then

                  _tp(CFrame.new(-10000000, 150, 37016.25))

                else

                  _tp(CFrame.new(-10000000, 31, 37016.25))

                end

              until not _G.Prehis_Find or (targetDestination.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 or workspace["_WorldOrigin"].Locations:FindFirstChild("Prehistoric Island") or plr.Character.Humanoid.Sit == false plr.Character.Humanoid.Sit = false

            end

          end

        else

          if (workspace["_WorldOrigin"].Locations:FindFirstChild("Prehistoric Island").CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 2000 then _tp(workspace["_WorldOrigin"].Locations:FindFirstChild("Prehistoric Island").CFrame)end

          if workspace.Map:FindFirstChild("PrehistoricIsland", true) or workspace["_WorldOrigin"].Locations:FindFirstChild("Prehistoric Island", true) then            

            if workspace.Map.PrehistoricIsland.Core.ActivationPrompt:FindFirstChild("ProximityPrompt", true) then

              if plr:DistanceFromCharacter(workspace.Map.PrehistoricIsland.Core.ActivationPrompt.CFrame.Position) <= 150 then

                fireproximityprompt(workspace.Map.PrehistoricIsland.Core.ActivationPrompt.ProximityPrompt, math.huge)

                vim1:SendKeyEvent(true, "E", false, game) wait(1.5) vim1:SendKeyEvent(false, "E", false, game)

              end

              _tp(workspace.Map.PrehistoricIsland.Core.ActivationPrompt.CFrame)              

            end

          end

        end

      end)

    end

  end

end)

local Vocan = Tabs.SeaEvent:AddToggle("Vocan", {Title = "Auto Patch Prehistoric Event", Description = "turn on for auto patch volcano + kill aura lava golems + auto remove lava", Default = false})

Vocan:OnChanged(function(Value)

  _G.Prehis_Skills = Value

end)

spawn(function()

  while wait() do

    if _G.Prehis_Skills then

      local prehistoricIsland = game.Workspace.Map:FindFirstChild("PrehistoricIsland")

      if prehistoricIsland then

        for _, obj in pairs(prehistoricIsland:GetDescendants()) do

        if obj:IsA("Part") and obj.Name:lower():find("lava") then obj:Destroy() end

        if obj:IsA("MeshPart") and obj.Name:lower():find("lava") then obj:Destroy() end

        end

        local lavaModel = game.Workspace.Map.PrehistoricIsland.Core:FindFirstChild("InteriorLava")

        if lavaModel and lavaModel:IsA("Model") then lavaModel:Destroy() end

        local Island = workspace.Map:FindFirstChild("PrehistoricIsland")

        if Island then   

          local trialTeleport = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")   

          for _, v in pairs(Island:GetDescendants()) do

            if v.Name == "TouchInterest" then

              if not (trialTeleport and v:IsDescendantOf(trialTeleport)) then

                v.Parent:Destroy()

              end

            end

          end

        end  

      end

    end

  end

end)

spawn(function()

  while wait() do

    pcall(function()

      if _G.Prehis_Skills then

        if workspace.Enemies:FindFirstChild("Lava Golem") then

          local v = GetConnectionEnemies("Lava Golem")

          if v then repeat wait()Attack.Kill(v,_G.Prehis_Skills) v.Humanoid:ChangeState(15)until not _G.Prehis_Skills or not v.Parent or v.Humanoid.Health <= 0 end

        end

        for i,v in pairs(game.Workspace.Map.PrehistoricIsland.Core.VolcanoRocks:GetChildren()) do

          if v:FindFirstChild("VFXLayer") then

            if v:FindFirstChild("VFXLayer").At0.Glow.Enabled == true or v.VFXLayer.At0.Glow.Enabled == true then

              repeat wait()

                _tp(v.VFXLayer.CFrame)

                if v.VFXLayer.At0.Glow.Enabled == true and plr:DistanceFromCharacter(v.VFXLayer.CFrame.Position) <= 150 then

                  MousePos = v.VFXLayer.CFrame.Position

                  Useskills("Melee","Z") wait(.5)

          	      Useskills("Melee","X") wait(.5)

	              Useskills("Melee","C") wait(.5)

                  Useskills("Blox Fruit","Z") wait(.5)

                  Useskills("Blox Fruit","X") wait(.5)

                  Useskills("Blox Fruit","C")

                end   

              until not _G.Prehis_Skills or v:FindFirstChild("VFXLayer").At0.Glow.Enabled == false or v.VFXLayer.At0.Glow.Enabled == false            

            end

          end

        end

      end

    end)

  end

end)

local Vocan = Tabs.SeaEvent:AddToggle("Vocan", {Title = "Auto Collect Dino Bones", Description = "", Default = false})

Vocan:OnChanged(function(Value)

  _G.Prehis_DB = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.Prehis_DB then

        if workspace:FindFirstChild("DinoBone") then

          for i,v in pairs(workspace:GetChildren()) do

            if v.Name == "DinoBone" then _tp(v.CFrame) end

          end

        end

      end

    end)

  end

end)

local Vocan = Tabs.SeaEvent:AddToggle("Vocan", {Title = "Auto Collect Dragon Eggs", Description = "", Default = false})

Vocan:OnChanged(function(Value)

  _G.Prehis_DE = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.Prehis_DE then

      if workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:FindFirstChild("DragonEgg") then _tp(workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:FindFirstChild("DragonEgg").Molten.CFrame) fireproximityprompt(workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs.DragonEgg.Molten.ProximityPrompt, 30) end        

      end

    end)

  end

end)

Toggle = Tabs.SeaEvent:AddToggle("Toggle", {Title = "Auto Reset When Complete Volcano", Description = "Reset When Complete Volcano not collect dino bones and else..", Default = false})

Toggle:OnChanged(function(Value)

  _G.ResetPH = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.ResetPH then

        local v748 = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport");

        if (v748 and v748:FindFirstChild("TouchInterest")) then

          plr.Character.Humanoid.Health = 0 

        else

          if workspace:FindFirstChild("DinoBone") then

            for i,v in pairs(workspace:GetChildren()) do

              if v.Name == "DinoBone" then _tp(v.CFrame) end

            end

          end

        end

      end

    end)

  end

end)

Tabs.SeaEvent:AddSection("Sea Event / Setting Sail")

local ListSeaBoat={"Guardian","PirateGrandBrigade","MarineGrandBrigade","PirateBrigade","MarineBrigade","PirateSloop","MarineSloop","Beast Hunter"}

local ListSeaZone={"Lv 1","Lv 2","Lv 3","Lv 4","Lv 5","Lv 6","Lv Infinite"}

local SPYING = Tabs.SeaEvent:AddParagraph({Title = " Spy Status ",Content = ""})

spawn(function()

  while wait(.2) do

    pcall(function()

      local spycheck = string.match(replicated.Remotes.CommF_:InvokeServer("InfoLeviathan","1"),"%d+")

      if spycheck then SPYING:SetDesc(" Spy Leviathan  : "..tostring(spycheck))

        if tostring(spycheck) == 5 then

          SPYING:SetDesc(" Spy Leviathan : Already Done!!")

        end

      end

    end)

  end

end)

Tabs.SeaEvent:AddButton({Title = "Buy Fracments with Spy", Description = "Buy the spy for finding leviathan",

Callback = function()

  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("InfoLeviathan","2")

end})

local FloD = Tabs.SeaEvent:AddParagraph({Title = " FlozenDimension Status ",Content = ""})

spawn(function()

  pcall(function()

    while wait(.2) do

      if workspace._WorldOrigin.Locations:FindFirstChild('Frozen Dimension') then

        FloD:SetDesc(' Flozen Dimension : True')

      else

        FloD:SetDesc(' Flozen Dimension : False')

      end

    end

  end)

end)

local Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Teleport Frozen Dimension", Description = "turn on for teleport to frozen dimension and start the leviathan gate", Default = false})

Q:OnChanged(function(Value)

  _G.FrozenTP = Value

end)

spawn(function()

  while wait(.1) do

    if _G.FrozenTP then

      pcall(function()

      if workspace.Map:FindFirstChild("LeviathanGate") then _tp(workspace.Map.LeviathanGate.CFrame) replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("OpenLeviathanGate") end

      end)

    end

  end

end)

local Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Drive To Hydra Island", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.SailBoat_Hydra = Value

end)

spawn(function()

  while wait() do

    if _G.SailBoat_Hydra then 

      pcall(function()        

        local myBoat = CheckBoat()

        if not myBoat then

          local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)

          TeleportToTarget(buyBoatCFrame)

          if (buyBoatCFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat) end

        elseif myBoat then

          if plr.Character.Humanoid.Sit == false then

            local boatSeatCFrame = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)

            _tp(boatSeatCFrame)

          else                         

            repeat wait() 

              if CheckEnemiesBoat() or CheckPirateGrandBrigade() or CheckTerrorShark() then

                _tp(CFrame.new(5433, 150, 290))

              else

                _tp(CFrame.new(5433, 35, 290))

              end           

            until _G.SailBoat_Hydra==false or plr.Character:WaitForChild("Humanoid").Sit==false plr.Character.Humanoid.Sit = false

          end

        end

      end)

    end

  end

end)

local Q = Tabs.SeaEvent:AddDropdown("Q",{Title = "Choose Boats",Values = ListSeaBoat,Multi = false,Default = 1})

Q:OnChanged(function(Value)

  _G.SelectedBoat = Value

end)

Tabs.SeaEvent:AddButton({Title = "Buy Boats", Description = "Buy the select boats",

Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyBoat",_G.SelectedBoat)

end})

local Q = Tabs.SeaEvent:AddDropdown("Q",{Title = "Choose Sea Level",Values = ListSeaZone,Multi = false,Default = 1})

Q:OnChanged(function(Value)

  _G.DangerSc = Value

end)

local Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Sail Boat", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.SailBoats = Value

end)

spawn(function()

  while wait() do

    if _G.SailBoats then 

      pcall(function()        

        local myBoat = CheckBoat()

        if not myBoat and not(CheckShark()and _G.Shark or CheckTerrorShark()and _G.TerrorShark or CheckFishCrew()and _G.MobCrew or CheckPiranha()and _G.Piranha)and not(CheckEnemiesBoat()and _G.FishBoat)and not(CheckSeaBeast()and _G.SeaBeast1)and not(_G.PGB and CheckPirateGrandBrigade())and not(_G.HCM and CheckHauntedCrew())and not(_G.Leviathan1 and CheckLeviathan())then

          local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)

          TeleportToTarget(buyBoatCFrame)

          if (buyBoatCFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat) end

        elseif myBoat and not(CheckShark()and _G.Shark or CheckTerrorShark()and _G.TerrorShark or CheckFishCrew()and _G.MobCrew or CheckPiranha()and _G.Piranha)and not(CheckEnemiesBoat()and _G.FishBoat)and not(CheckSeaBeast()and _G.SeaBeast1)and not(_G.PGB and CheckPirateGrandBrigade())and not(_G.HCM and CheckHauntedCrew())and not(_G.Leviathan1 and CheckLeviathan())then

          if plr.Character.Humanoid.Sit == false then

            local boatSeatCFrame = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)

            _tp(boatSeatCFrame)

          else                         

            if _G.DangerSc == "Lv 1" then CFrameSelectedZone = CFrame.new(-21998.375, 30.0006084, -682.309143)

            elseif _G.DangerSc == "Lv 2" then CFrameSelectedZone = CFrame.new(-26779.5215, 30.0005474, -822.858032)

            elseif _G.DangerSc == "Lv 3" then CFrameSelectedZone = CFrame.new(-31171.957, 30.0001011, -2256.93774)

            elseif _G.DangerSc == "Lv 4" then CFrameSelectedZone = CFrame.new(-34054.6875, 30.2187767, -2560.12012)

            elseif _G.DangerSc == "Lv 5" then CFrameSelectedZone = CFrame.new(-38887.5547, 30.0004578, -2162.99023)

            elseif _G.DangerSc == "Lv 6" then CFrameSelectedZone = CFrame.new(-44541.7617, 30.0003204, -1244.8584)

            elseif _G.DangerSc == "Lv Infinite" then CFrameSelectedZone = CFrame.new(-10000000, 31, 37016.25)

            end           

            repeat wait() 

              if (not _G.FishBoat and CheckEnemiesBoat()) or (not _G.PGB and CheckPirateGrandBrigade()) or (not _G.TerrorShark and CheckTerrorShark()) then

                _tp(CFrameSelectedZone * CFrame.new(0,150,0))

              else

                _tp(CFrameSelectedZone)

              end           

            until _G.SailBoats==false or(CheckShark()and _G.Shark or CheckTerrorShark()and _G.TerrorShark or CheckFishCrew()and _G.MobCrew or CheckPiranha()and _G.Piranha)or CheckSeaBeast()and _G.SeaBeast1 or CheckEnemiesBoat()and _G.FishBoat or _G.Leviathan1 and CheckLeviathan() or _G.HCM and CheckHauntedCrew() or _G.PGB and CheckPirateGrandBrigade() or plr.Character:WaitForChild("Humanoid").Sit==false plr.Character.Humanoid.Sit = false

          end

        end

      end)

    end

  end

end)

spawn(function()while wait(Sec)do pcall(function()for a,b in pairs(workspace.Boats:GetChildren())do for c,d in pairs(workspace.Boats[b.Name]:GetDescendants())do if d:IsA("BasePart")then if _G.SailBoats or _G.Prehis_Find or _G.FindMirage or _G.SailBoat_Hydra or _G.AutofindKitIs then d.CanCollide=false else d.CanCollide=true end end end end end)end end)

Tabs.SeaEvent:AddSection("Entity Sea Event")

Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Shark", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Shark = Value

end)

Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Piranha", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Piranha = Value

end)

Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Terror Shark", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.TerrorShark = Value

end)

Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Fish Crew Member", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.MobCrew = Value

end)

Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Haunted Crew Member", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.HCM = Value

end)

Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Attack PirateGrandBrigade", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.PGB = Value

end)

Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Attack Fish Boat", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.FishBoat = Value

end)

Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Attack Sea Beast", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.SeaBeast1 = Value

end)

Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Attack Leviathan", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Leviathan1 = Value

end)

spawn(function()

  while wait() do

    pcall(function()	

      if _G.Shark then local a={"Shark"}if CheckShark()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.Kill(c,_G.Shark)until _G.Shark==false or not c.Parent or c.Humanoid.Health<=0 end end end end end

      if _G.TerrorShark then local a={"Terrorshark"}if CheckTerrorShark()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.KillSea(c,_G.TerrorShark)until _G.TerrorShark==false or not c.Parent or c.Humanoid.Health<=0 end end end end end

      if _G.Piranha then local a={"Piranha"}if CheckPiranha()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.Kill(c,_G.Piranha)until _G.Piranha==false or not c.Parent or c.Humanoid.Health<=0 end end end end end

      if _G.MobCrew then local a={"Fish Crew Member"}if CheckFishCrew()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.Kill(c,_G.MobCrew)until _G.MobCrew==false or not c.Parent or c.Humanoid.Health<=0 end end end end end                 

      if _G.HCM then local a={"Haunted Crew Member"}if CheckHauntedCrew()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.Kill(c,_G.HCM)until _G.HCM==false or not c.Parent or c.Humanoid.Health<=0 end end end end end

      if _G.SeaBeast1 then if workspace.SeaBeasts:FindFirstChild("SeaBeast1")then for a,b in pairs(workspace.SeaBeasts:GetChildren())do if b:FindFirstChild("HumanoidRootPart")and b:FindFirstChild("Health")and b.Health.Value>0 then repeat task.wait()spawn(function()_tp(CFrame.new(b.HumanoidRootPart.Position.X,game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y+200,b.HumanoidRootPart.Position.Z))end)if plr:DistanceFromCharacter(b.HumanoidRootPart.CFrame.Position)<=500 then AitSeaSkill_Custom=b.HumanoidRootPart.CFrame;MousePos=AitSeaSkill_Custom.Position;if CheckF()then weaponSc("Blox Fruit")Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")else Useskills("Melee","Z")Useskills("Melee","X")Useskills("Melee","C")wait(.1)Useskills("Sword","Z")Useskills("Sword","X")wait(.1)Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")wait(.1)Useskills("Gun","Z")Useskills("Gun","X")end end until _G.SeaBeast1==false or not b:FindFirstChild("HumanoidRootPart")or not b.Parent or b.Health.Value<=0 end end end end

      if _G.Leviathan1 then if workspace.SeaBeasts:FindFirstChild("Leviathan")then for a,b in pairs(workspace.SeaBeasts:GetChildren())do if b:FindFirstChild("HumanoidRootPart")and b:FindFirstChild("Leviathan Segment")and b:FindFirstChild("Health")and b.Health.Value>0 then repeat task.wait()spawn(function()_tp(CFrame.new(b.HumanoidRootPart.Position.X,game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y+200,b.HumanoidRootPart.Position.Z))end)if plr:DistanceFromCharacter(b.HumanoidRootPart.CFrame.Position)<=500 then MousePos=b:FindFirstChild("Leviathan Segment").Position;if CheckF()then weaponSc("Blox Fruit")Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")else Useskills("Melee","Z")Useskills("Melee","X")Useskills("Melee","C")wait(.1)Useskills("Sword","Z")Useskills("Sword","X")wait(.1)Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")wait(.1)Useskills("Gun","Z")Useskills("Gun","X")end end until _G.Leviathan1==false or not b:FindFirstChild("HumanoidRootPart")or not b.Parent or b.Health.Value<=0 end end end end

      if _G.FishBoat then if CheckEnemiesBoat()then for a,b in pairs(workspace.Enemies:GetChildren())do if b:FindFirstChild("Health")and b.Health.Value>0 and b:FindFirstChild("VehicleSeat")then repeat task.wait()spawn(function()if b.Name=="FishBoat"then _tp(b.Engine.CFrame*CFrame.new(0,-50,-25))end end)if plr:DistanceFromCharacter(b.Engine.CFrame.Position)<=150 then AitSeaSkill_Custom=b.Engine.CFrame;MousePos=AitSeaSkill_Custom.Position;if CheckF()then weaponSc("Blox Fruit")Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")else Useskills("Melee","Z")Useskills("Melee","X")Useskills("Melee","C")wait(.1)Useskills("Sword","Z")Useskills("Sword","X")wait(.1)Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")wait(.1)Useskills("Gun","Z")Useskills("Gun","X")end end until _G.FishBoat==false or not b:FindFirstChild("VehicleSeat")or b.Health.Value<=0 end end end end

      if _G.PGB then if CheckPirateGrandBrigade()then for a,b in pairs(workspace.Enemies:GetChildren())do if b:FindFirstChild("Health")and b.Health.Value>0 and b:FindFirstChild("VehicleSeat")then repeat task.wait()spawn(function()if b.Name=="PirateBrigade"then _tp(b.Engine.CFrame*CFrame.new(0,-30,-10))elseif b.Name=="PirateGrandBrigade"then _tp(b.Engine.CFrame*CFrame.new(0,-50,-50))end end)if plr:DistanceFromCharacter(b.Engine.CFrame.Position)<=150 then AitSeaSkill_Custom=b.Engine.CFrame;MousePos=AitSeaSkill_Custom.Position;if CheckF()then weaponSc("Blox Fruit")Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")else Useskills("Melee","Z")Useskills("Melee","X")Useskills("Melee","C")wait(.1)Useskills("Sword","Z")Useskills("Sword","X")wait(.1)Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")wait(.1)Useskills("Gun","Z")Useskills("Gun","X")end end until _G.PGB==false or not b:FindFirstChild("VehicleSeat")or b.Health.Value<=0 end end end end

    end)

  end

end)



Tabs.SeaEvent:AddSection("Kitsune Island / Event")

local Check_Kitsu = Tabs.SeaEvent:AddParagraph({Title = " Kitsune Island Status ",Content = ""})

spawn(function()

  while wait(.2) do

    if workspace.Map:FindFirstChild("KitsuneIsland") or workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island") then

      Check_Kitsu:SetDesc(" Kitsune Island : True")

    else

      Check_Kitsu:SetDesc(" Kitsune Island : False")

    end

  end

end)

local Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Find Kitsune Island", Description = "turn on for finding & tween kitsune island", Default = false})

Q:OnChanged(function(Value)

  _G.AutofindKitIs = Value

end)

spawn(function()

  while wait() do

    if _G.AutofindKitIs then 

      pcall(function()

        if not workspace["_WorldOrigin"].Locations:FindFirstChild("Kitsune Island", true) then                

          local myBoat = CheckBoat()

          if not myBoat then

            local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)

            TeleportToTarget(buyBoatCFrame)

            if (buyBoatCFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat) end

          else

            if plr.Character.Humanoid.Sit == false then

              local boatSeatCFrame = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)

              _tp(boatSeatCFrame)

            else

              local targetDestination = CFrame.new(-10000000, 31, 37016.25)              

              repeat wait() 

                if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then

                  _tp(CFrame.new(-10000000, 150, 37016.25))

                else

                  _tp(CFrame.new(-10000000, 31, 37016.25))

                end

              until not _G.AutofindKitIs or (targetDestination.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 or workspace["_WorldOrigin"].Locations:FindFirstChild("Kitsune Island") or plr.Character.Humanoid.Sit == false plr.Character.Humanoid.Sit = false

            end

          end

        else

          _tp(workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island").CFrame*CFrame.new(0,500,0))

        end

      end)

    end

  end

end)

local Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Teleport to Shrine Actived", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.tweenShrine = Value

end)

spawn(function()

  while wait(.1) do

    if _G.tweenShrine then

      pcall(function()

      local kit_is = workspace.Map:FindFirstChild("KitsuneIsland") or game.Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island")

      local shrineActive = kit_is:FindFirstChild("ShrineActive")

        if shrineActive then

          for _, v in next, shrineActive:GetDescendants() do

            if v:IsA("BasePart") and v.Name:find("NeonShrinePart") then

              replicated.Modules.Net:FindFirstChild("RE/TouchKitsuneStatue"):FireServer()

              repeat wait() _tp(v.CFrame * CFrame.new(0,2,0)) until _G.tweenShrine == false or not kit_is

            end

          end

        else

          _tp(workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island").CFrame * CFrame.new(0,500,0))        

        end

      end)

    end

  end

end)

local Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Collect Azure Ember", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Collect_Ember = Value

end)

spawn(function()

  while wait(.1) do

    if _G.Collect_Ember then

      pcall(function()

        if workspace:WaitForChild("AttachedAzureEmber") or workspace:WaitForChild("EmberTemplate") then

        notween(workspace:WaitForChild("EmberTemplate"):FindFirstChild("Part").CFrame)

        else

          _tp(workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island").CFrame * CFrame.new(0,500,0))        

          replicated.Modules.Net["RF/KitsuneStatuePray"]:InvokeServer()

        end

      end)

    end

  end

end)

local Q = Tabs.SeaEvent:AddToggle("Q", {Title = "Auto Trade Azure Ember", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Trade_Ember = Value

end)

spawn(function()

  while wait(.1) do

    if _G.Trade_Ember then

      pcall(function()

        if workspace["_WorldOrigin"].Locations:FindFirstChild("Kitsune Island",true) then

          replicated.Modules.Net:FindFirstChild("RF/KitsuneStatuePray"):InvokeServer()

        end

      end)

    end

  end

end)

Tabs.SeaEvent:AddButton({Title = "Trade Items Azure", Description = "",

Callback = function()

  replicated.Modules.Net:FindFirstChild("RF/KitsuneStatuePray"):InvokeServer()

end})

Tabs.SeaEvent:AddButton({Title = "Talk with kitsune statue", Description = "",

Callback = function()

  replicated.Modules.Net:FindFirstChild("RE/TouchKitsuneStatue"):FireServer()

end})



Tabs.Raids:AddSection("Raiding Menu")

local RaidS = Tabs.Raids:AddParagraph({Title = " Raiding Status ",Content = ""})

spawn(function()

  while wait(.2) do

    pcall(function()      

      if plr.PlayerGui.Main.Timer.Visible == true then

        RaidS:SetDesc(" Raiding Statud : True")

      else

        RaidS:SetDesc(" Raiding Statud : False")

      end      

    end)

  end

end)
   

local Q = Tabs.Raids:AddToggle("Q", {Title = "Teleport To Lab", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.TpLab = Value

  while _G.TpLab do wait(Sec)

   if _G.TpLab then

     if World2 and _G.TpLab then _tp( Vector3.new(-6545.703125, 310.320038, -4730.866699))

     elseif World3 and _G.TpLab then _tp(CFrame.new(-5017.40869, 314.844055, -2823.0127, -0.925743818, 4.48217499e-08, -0.378151238, 4.55503146e-09, 1, 1.07377559e-07, 0.378151238, 9.7681621e-08, -0.925743818)) end

   end

  end

end)

local StartRaidV2 = Tabs.Raids:AddToggle("Start Raid [V2.0]", {
    Title = "Start Raid [V2.0]",
    Description = "[Beta] Auto A - Z",
    Default = false
})

StartRaidV2:OnChanged(function(Value)
    _G.StartRaidV2 = Value
    if Value then
        _G.Raiding   = false
        _G.KillH     = false
        NextIs       = false
    end
end)

spawn(function()
    local ISLANDS = {"Island 1", "Island 2", "Island 3", "Island 4", "Island 5"}
    local KILL_RANGE    = 600
    local ISLAND_RADIUS = 800

    local function GetCurrentIsland(hrp)
        for i, name in ipairs(ISLANDS) do
            local loc = workspace["_WorldOrigin"].Locations:FindFirstChild(name)
            if loc and (hrp.Position - loc.Position).Magnitude <= ISLAND_RADIUS then
                return i, name
            end
        end
        return nil, nil
    end

    local function KillAura(hrp)
        for _, v in pairs(workspace.Enemies:GetChildren()) do
            if not _G.StartRaidV2 then return false end
            local vhrp = v:FindFirstChild("HumanoidRootPart")
            local vhum = v:FindFirstChild("Humanoid")
            if vhrp and vhum and vhum.Health > 0 then
                if (vhrp.Position - hrp.Position).Magnitude <= KILL_RANGE then
                    repeat
                        task.wait(0.1)
                        Attack.Kill(v, true)
                    until not _G.StartRaidV2 or not v.Parent or vhum.Health <= 0
                    return true
                end
            end
        end
        return false
    end

    while task.wait(0.3) do
        if not _G.StartRaidV2 then continue end
        pcall(function()
            local char = plr.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local raidVisible = plr.PlayerGui.Main.TopHUDList.RaidTimer.Visible

            if not raidVisible then
                if GetBP("Special Microchip") then
                    local btn
                    if World2 then
                        btn = workspace.Map.CircleIsland.RaidSummon2.Button.Main
                    elseif World3 then
                        btn = workspace.Map["Boat Castle"].RaidSummon2.Button.Main
                    end
                    if btn then
                        if btn:FindFirstChild("ProximityPrompt") then
                            fireproximityprompt(btn.ProximityPrompt)
                        elseif btn:FindFirstChild("ClickDetector") then
                            fireclickdetector(btn.ClickDetector)
                        end
                    end
                end
                return
            end

            local idx, islandName = GetCurrentIsland(hrp)

            if idx then
                local killed = KillAura(hrp)
                if not killed then
                    local nextIdx = idx + 1
                    if nextIdx <= #ISLANDS then
                        local nextLoc = workspace["_WorldOrigin"].Locations:FindFirstChild(ISLANDS[nextIdx])
                        if nextLoc then
                            _tp(nextLoc.CFrame * CFrame.new(0, 50, 0))
                        end
                    end
                end
            else
                local loc1 = workspace["_WorldOrigin"].Locations:FindFirstChild("Island 1")
                if loc1 then
                    _tp(loc1.CFrame * CFrame.new(0, 50, 0))
                end
            end
        end)
    end
end)

local Q = Tabs.Raids:AddToggle("Q", {Title = "Auto Awakening", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Auto_Awakener = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.Auto_Awakener then

        replicated.Remotes.CommF_:InvokeServer("Awakener","Check")

        replicated.Remotes.CommF_:InvokeServer("Awakener","Awaken")

      end

    end)

  end

end)	

Tabs.Combat:AddSection("Combat / Aimbot")

__indexPlayer = Tabs.Combat:AddParagraph({Title = "All Players On Server :",Content = ""})

spawn(function()

  while wait(Sec) do

    pcall(function()

      for i,v in pairs(game:GetService("Players"):GetPlayers()) do

        if i == 12 then

          __indexPlayer:SetDesc("All Players :".." "..i.." ".."/".." ".."12".." ".."[Max]")

        elseif i == 1 then

          __indexPlayer:SetDesc("All Players  :".." "..i.." ".."/".." ".."12")

        else

          __indexPlayer:SetDesc("All Players  :".." "..i.." ".."/".." ".."12")

        end

      end

    end)

  end

end)

__AimBotTurn = Tabs.Combat:AddParagraph({Title = "Aimbot Status :",Content = ""})

local AimbotMethod = {"AimBots Skill","Auto Aimbots"}

Checking_AimStatus = function()

  if _G.AimCam then

    return "Aimbot Camera"

  else

    return ""

  end 

  if _G.AimbotGun then

    return "Aimbot Guns"

  else

    return ""  

  end 

end

spawn(function() 

  while wait(.2) do 

    pcall(function()      

      if _G.AimMethod then 

	   __AimBotTurn:SetDesc("Aimbot - Skills : True") 

	 elseif (_G.AimCam or _G.AimbotGun) and _G.AimMethod then

	   __AimBotTurn:SetDesc("Aimbot - Skills |" ..Checking_AimStatus() .." :" .."True")

	 else

        __AimBotTurn:SetDesc("Aimbot - Skills : False") 

      end 

    end)

  end

end)

local PlrList = {}   

for _,v in pairs(game:GetService("Players"):GetChildren()) do table.insert(PlrList, v.Name) end

local SelectedPly = Tabs.Combat:AddDropdown("SelectedPly",{Title = "Choose Players",Values = PlrList,Multi = false,Default = 1})

SelectedPly:OnChanged(function(Value)

  _G.PlayersList = Value

end)

Q = Tabs.Combat:AddToggle("Q", {Title = "Teleport to choose players", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.TpPly = Value

  pcall(function()

    if _G.TpPly then

      repeat wait()

        _tp(game:GetService("Players")[_G.PlayersList].Character.HumanoidRootPart.CFrame) 

      until not _G.TpPly

    end

  end)

end)

Q = Tabs.Combat:AddToggle("Q", {Title = "Spectate Choose Players", Description = "", Default = false})

Q:OnChanged(function(Value)

  SpectatePlys = Value

  repeat task.wait(.1)

    workspace.Camera.CameraSubject = game:GetService("Players"):FindFirstChild(_G.PlayersList).Character.Humanoid

  until SpectatePlys == false 

    workspace.Camera.CameraSubject = plr.Character.Humanoid

end)



Q = Tabs.Combat:AddDropdown("Q",{Title = "Choose Aim Method",Values = AimbotMethod,Multi = false,Default = 1})

Q:OnChanged(function(Value)

  ABmethod = Value

end)



Q = Tabs.Combat:AddToggle("Q", {Title = "Aimbot Method Skills", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AimMethod = Value

end)

task.spawn(function()

  while task.wait() do

    pcall(function()

      if _G.AimMethod and ABmethod == "AimBots Skill" then

        for i,v in pairs(game:GetService("Players"):GetPlayers()) do

          if v.Name == _G.PlayersList and v.Team ~= game.Players.LocalPlayer.Team then

            MousePos = v.Character:FindFirstChild("HumanoidRootPart").Position       	  

          end

        end

      end

    end)

  end

end)

task.spawn(function()

  while task.wait() do

    pcall(function()

      if _G.AimMethod and ABmethod == "Auto Aimbots" then

        local MaxDistance = math.huge

        for i,v in pairs(game:GetService("Players"):GetPlayers()) do

          if v.Name ~= plr.Name and v.Team ~= game.Players.LocalPlayer.Team then

            local Distance = v:DistanceFromCharacter(plr.Character.HumanoidRootPart.Position)

            if Distance < MaxDistance then

              MaxDistance = Distance

              MousePos = v.Character:FindFirstChild("HumanoidRootPart").Position

       	    end

          end

        end

      end

    end)

  end

end)

Q = Tabs.Combat:AddToggle("Q", {Title = "Aimbot Camera Closet Players", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AimCam = Value

end)

task.spawn(function()

  while task.wait(Sec) do

    pcall(function()

      if _G.AimCam then

      local camera = workspace.CurrentCamera

	  closestplayer = function()

	  local dist = math.huge

	  local target = nil 

	    for _, v in next, ply:GetPlayers() do

	      if v ~= plr then

		    if v.Character and v.Character:FindFirstChild("Head") and _G.AimCam and v.Character.Humanoid.Health > 0 then

            local Mag = (v.Character.Head.Position - plr.Character.Head.Position).Magnitude

	          if Mag < dist then

		        dist = Mag

			    target = v

		      end

		    end

		  end

        end

        return target

      end

        repeat task.wait()

          camera.CFrame = CFrame.new(camera.CFrame.Position,closestplayer().Character.HumanoidRootPart.Position)

        until _G.AimCam == false or Mag > dist

      end

    end)

  end

end)



Tabs.Combat:AddSection("LocalPlayer Settings / Misc")

Q = Tabs.Combat:AddToggle("Q", {Title = "Instance Mink V3 [ INF ]", Description = "turn on for make mink v3 infinity", Default = false})

Q:OnChanged(function(Value)

  InfAblities = Value

end)

spawn(function()

  while wait(.2) do

    pcall(function()

      if InfAblities then

        if not plr.Character.HumanoidRootPart:FindFirstChild("Agility") then

          local agility = replicated.FX["Agility"]:Clone()

          agility.Name = "Agility"

          agility.Parent = plr.Character.HumanoidRootPart

        end

      else

        plr.Character.HumanoidRootPart["Agility"]:Destroy()

      end

    end)

  end

end)

Q = Tabs.Combat:AddToggle("Q", {Title = "Instance Energy [ INF ]", Description = "turn on for make energy infinity", Default = false})

Q:OnChanged(function(Value)

  infEnergy = Value

  if Value then getInfinity_Ability("Energy", infEnergy) end

end)

Q = Tabs.Combat:AddToggle("Q", {Title = "Instance Soru [ INF ]", Description = "turn on for make soru infinity", Default = false})

Q:OnChanged(function(Value)

  _G.InfSoru = Value

  if Value then getInfinity_Ability("Soru", _G.InfSoru) end

end)

Q = Tabs.Combat:AddToggle("Q", {Title = "Instance Observation Range [ INF ]", Description = "turn on for make observation range infinity", Default = false})

Q:OnChanged(function(Value)

  _G.InfiniteObRange = Value

  if Value then getInfinity_Ability("Observation", _G.InfiniteObRange) end

end)



Tabs.Combat:AddSection("Settings Combat / Aimbot Settings")



Q = Tabs.Combat:AddToggle("Q", {Title = "Ignore Same Teams", Description = "turn on for ignore not aimbot same team", Default = false})

Q:OnChanged(function(Value)

  _G.NoAimTeam = Value

end)

Q = Tabs.Combat:AddToggle("Q", {Title = "Accept Allies", Description = "turn on for auto accept ally", Default = false})

Q:OnChanged(function(Value)

  _G.AcceptAlly = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.AcceptAlly then

      pcall(function()

        for _, v in pairs(ply:GetChildren()) do 

          if v.Name ~= plr.Name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then

            replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("AcceptAlly", v.Name)

          end

        end

      end)

    end

  end

end)



Tabs.Combat:AddSection("Esp Items / Entity / Island")



function isnil(thing)

  return (thing == nil)

end

local function round(n)

  return math.floor(tonumber(n) + 0.5)

end

Number = math.random(1, 1000000)

EspPly = function()

  for _,v in next, game.Players:GetChildren() do

    pcall(function()

	  if not isnil(v.Character) then

	    if PlayerEsp then

		  if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp'..Number) then

		    local bill = Instance.new('BillboardGui',v.Character.Head)

			bill.Name = 'NameEsp'..Number

			bill.ExtentsOffset = Vector3.new(0, 1, 0)

			bill.Size = UDim2.new(1,200,1,30)

			bill.Adornee = v.Character.Head

			bill.AlwaysOnTop = true

			local name = Instance.new('TextLabel',bill)

    		     name.Font = Enum.Font.Code

			name.FontSize = "Size14"

			name.TextWrapped = true

			name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M')

			name.Size = UDim2.new(1,0,1,0)

			name.TextYAlignment = 'Top'

	        	name.BackgroundTransparency = 1

			name.TextStrokeTransparency = 0.5

			  if v.Team == TeamSelf then

			    name.TextColor3 = Color3.new(0,0,254)

			  else

			    name.TextColor3 = Color3.new(255,0,0)

		  	  end

			else

			v.Character.Head['NameEsp'..Number].TextLabel.Text = (v.Data.Level.Value ..' | '.. v.Name ..' | '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M\nHealth : ' .. round(v.Character.Humanoid.Health*100/v.Character.Humanoid.MaxHealth) .. '%')

		    end

		  else

		  if v.Character.Head:FindFirstChild('NameEsp'..Number) then

		    v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()

	  	  end

	    end

	  end

    end)

  end

end  

LocationEsp = function() 

  for _,v in next, workspace["_WorldOrigin"].Locations:GetChildren() do

    pcall(function()

      if IslandESP then 

        if (v.Name ~= "Sea") then

          if not v:FindFirstChild('NameEsp') then

            local bill = Instance.new('BillboardGui',v)

            bill.Name = 'NameEsp'

            bill.ExtentsOffset = Vector3.new(0, 1, 0)

            bill.Size = UDim2.new(1,200,1,30)

            bill.Adornee = v

            bill.AlwaysOnTop = true

            local name = Instance.new('TextLabel',bill)

            name.Font = Enum.Font.Code

            name.FontSize = "Size14"

            name.TextWrapped = true

            name.Size = UDim2.new(1,0,1,0)

            name.TextYAlignment = 'Top'

            name.BackgroundTransparency = 1

            name.TextStrokeTransparency = 0.5

            name.TextColor3 = Color3.fromRGB(98,252,252)

            else

            v['NameEsp'].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')

             end

           end

         else

        if v:FindFirstChild('NameEsp') then

          v:FindFirstChild('NameEsp'):Destroy()

        end

      end

    end)

  end

end

DevEsp = function()

  for i,v in next, workspace:GetChildren() do

    pcall(function()

      if DevilFruitESP then

        if string.find(v.Name, "Fruit") then   

          if not v.Handle:FindFirstChild('NameEsp'..Number) then

            local bill = Instance.new('BillboardGui',v.Handle)

            bill.Name = 'NameEsp'..Number

            bill.ExtentsOffset = Vector3.new(0, 1, 0)

            bill.Size = UDim2.new(1,200,1,30)

            bill.Adornee = v.Handle

            bill.AlwaysOnTop = true

            local name = Instance.new('TextLabel',bill)

            name.Font = Enum.Font.Code

            name.FontSize = "Size14"

            name.TextWrapped = true

            name.Size = UDim2.new(1,0,1,0)

            name.TextYAlignment = 'Top'

            name.BackgroundTransparency = 1

            name.TextStrokeTransparency = 0.5

            name.TextColor3 = Color3.fromRGB(255,255,255)

            name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' M')

              else

                v.Handle['NameEsp'..Number].TextLabel.Text = ('[' ..v.Name ..']' ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' M')

               end

             end

           else

         if v.Handle:FindFirstChild('NameEsp'..Number) then

          v.Handle:FindFirstChild('NameEsp'..Number):Destroy()

        end

      end

    end)

  end

end

flowerEsp = function()

  for i,v in pairs(workspace:GetChildren()) do

    pcall(function()

      if v.Name == "Flower2" or v.Name == "Flower1" then

        if FlowerESP then 

          if not v:FindFirstChild('NameEsp'..Number) then

            local bill = Instance.new('BillboardGui',v)

            bill.Name = 'NameEsp'..Number

            bill.ExtentsOffset = Vector3.new(0, 1, 0)

            bill.Size = UDim2.new(1,200,1,30)

            bill.Adornee = v

            bill.AlwaysOnTop = true

            local name = Instance.new('TextLabel',bill)

            name.Font = Enum.Font.Code

            name.FontSize = "Size14"

            name.TextWrapped = true

            name.Size = UDim2.new(1,0,1,0)

            name.TextYAlignment = 'Top'

            name.BackgroundTransparency = 1

            name.TextStrokeTransparency = 0.5

            name.TextColor3 = Color3.fromRGB(88, 214, 252)

            if v.Name == "Flower1" then 

              name.Text = ("Blue Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')

              name.TextColor3 = Color3.fromRGB(88, 214, 252)

            end

              if v.Name == "Flower2" then

                name.Text = ("Red Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')

                name.TextColor3 = Color3.fromRGB(88, 214, 252)

              end

          else

            v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')

          end

        else

          if v:FindFirstChild('NameEsp'..Number) then

            v:FindFirstChild('NameEsp'..Number):Destroy()

          end

        end

      end   

    end)

  end

end

EventIslandEsp = function()

  for i, v in pairs(workspace._WorldOrigin.Locations:GetChildren()) do

    pcall(function()

      if EspEventIsland then

	    if (v.Name == "Mirage Island" or v.Name =="Prehistoric Island" or v.Name =="Kitsune Island") then

	      if not v:FindFirstChild("NameEsp") then

		    local bill = Instance.new("BillboardGui", v);

	   	    bill.Name = "NameEsp";

		    bill.ExtentsOffset = Vector3.new(0, 1, 0);

		    bill.Size = UDim2.new(1, 200, 1, 30);

		    bill.Adornee = v;

		    bill.AlwaysOnTop = true;

		    local name = Instance.new("TextLabel", bill);

		    name.Font = "Code";

		    name.FontSize = "Size14";

		    name.TextWrapped = true;

		    name.Size = UDim2.new(1, 0, 1, 0);

    	    name.TextYAlignment = "Top";

	        name.BackgroundTransparency = 1;

    	    name.TextStrokeTransparency = 0.5;

		    name.TextColor3 = Color3.fromRGB(80, 245, 245);

	     else

	 	    v.NameEsp.TextLabel.Text = v.Name .. "   \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3) .. " M";

		  end

        end

	  elseif v:FindFirstChild("NameEsp") then

	    v:FindFirstChild("NameEsp"):Destroy()

      end

    end)

  end

end

gearEsp = function()

  for _,v in pairs(workspace.Map.MysticIsland:GetDescendants()) do

    pcall(function()

      if ESPGear then

        if v.Name == "Part" and v.Material == Enum.Material.Neon then

          if not v:FindFirstChild("NameEsp") then

          local bill = Instance.new("BillboardGui", v)

          bill.Name = "NameEsp"

          bill.ExtentsOffset = Vector3.new(0, 1, 0)

          bill.Size = UDim2.new(1, 200, 1, 30)

          bill.Adornee = v

          bill.AlwaysOnTop = true

          local name = Instance.new("TextLabel", bill)

          name.Font = "Code"

          name.FontSize = "Size14"

          name.TextWrapped = true

          name.Size = UDim2.new(1, 0, 1, 0)

          name.TextYAlignment = "Top"

          name.BackgroundTransparency = 1

          name.TextStrokeTransparency = 0.5

          name.TextColor3 = Color3.fromRGB(80, 245, 245)

            else

            v["NameEsp"].TextLabel.Text =("Gear" .."   \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3).. " M")

                end

              end

            else

          if v:FindFirstChild("NameEsp") then

            v:FindFirstChild("NameEsp"):Destroy()

          end

      end

    end)

  end

end

AdvanFruitEsp = function()

if advanEsp == true then     

for _,v in pairs(replicated.NPCs:GetChildren()) do

  if v.Name == "Advanced Fruit Dealer" then

    if not workspace:FindFirstChild("Adv") then

     Adv = Instance.new("Part")

     Adv.Name = "Adv"

     Adv.Transparency = 1

     Adv.Size = Vector3.new(1,1,1)

     Adv.Anchored = true

     Adv.CanCollide = false

     Adv.Parent = workspace

     Adv.CFrame = v.HumanoidRootPart.CFrame    

     elseif workspace:FindFirstChild("Adv") then

      if not Adv:FindFirstChild("NameEsp") then

        local bill = Instance.new("BillboardGui", Adv)

        bill.Name = "NameEsp"

        bill.ExtentsOffset = Vector3.new(0, 1, 0)

        bill.Size = UDim2.new(1, 200, 1, 30)

        bill.Adornee = Adv

        bill.AlwaysOnTop = true

        local name = Instance.new("TextLabel", bill)

        name.Font = "Code"

        name.FontSize = "Size14"

        name.TextWrapped = true

        name.Size = UDim2.new(1, 0, 1, 0)

        name.TextYAlignment = "Top"

        name.BackgroundTransparency = 1

        name.TextStrokeTransparency = 0.5

        name.TextColor3 = Color3.fromRGB(80, 245, 245)        

        else

          Adv["NameEsp"].TextLabel.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")    

          end                              

        end

      end

    end

    else

      if workspace:FindFirstChild("Adv") then

        workspace:FindFirstChild("Adv"):Destroy()

    end    

  end

end

HakiClorEsp = function()

if ColorEsp == true then     

for _,v in pairs(replicated.NPCs:GetChildren()) do

  if v.Name == "Barista Cousin" then

    if not workspace:FindFirstChild("Gay") then

     Gay = Instance.new("Part")

     Gay.Name = "Gay"

     Gay.Transparency = 1

     Gay.Size = Vector3.new(1,1,1)

     Gay.Anchored = true

     Gay.CanCollide = false

     Gay.Parent = workspace

     Gay.CFrame = v.HumanoidRootPart.CFrame    

     elseif workspace:FindFirstChild("Gay") then

      if not Gay:FindFirstChild("NameEsp") then

        local bill = Instance.new("BillboardGui", Gay)

        bill.Name = "NameEsp"

        bill.ExtentsOffset = Vector3.new(0, 1, 0)

        bill.Size = UDim2.new(1, 200, 1, 30)

        bill.Adornee = Gay

        bill.AlwaysOnTop = true

        local name = Instance.new("TextLabel", bill)

        name.Font = "Code"

        name.FontSize = "Size14"

        name.TextWrapped = true

        name.Size = UDim2.new(1, 0, 1, 0)

        name.TextYAlignment = "Top"

        name.BackgroundTransparency = 1

        name.TextStrokeTransparency = 0.5

        name.TextColor3 = Color3.fromRGB(80, 245, 245)        

        else

          Gay["NameEsp"].TextLabel.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")    

          end                              

        end

      end

    end

    else

      if workspace:FindFirstChild("Gay") then

        workspace:FindFirstChild("Gay"):Destroy()

    end    

  end

end

LegenSword = function()

if LegenS == true then     

for _,v in pairs(replicated.NPCs:GetChildren()) do

  if v.Name == "Legendary Sword Dealer " then

    if not workspace:FindFirstChild("Lgd") then

     Lgd = Instance.new("Part")

     Lgd.Name = "Lgd"

     Lgd.Transparency = 1

     Lgd.Size = Vector3.new(1,1,1)

     Lgd.Anchored = true

     Lgd.CanCollide = false

     Lgd.Parent = workspace

     Lgd.CFrame = v.HumanoidRootPart.CFrame    

     elseif workspace:FindFirstChild("Lgd") then

      if not Lgd:FindFirstChild("NameEsp") then

        local bill = Instance.new("BillboardGui", Lgd)

        bill.Name = "NameEsp"

        bill.ExtentsOffset = Vector3.new(0, 1, 0)

        bill.Size = UDim2.new(1, 200, 1, 30)

        bill.Adornee = Lgd

        bill.AlwaysOnTop = true

        local name = Instance.new("TextLabel", bill)

        name.Font = "Code"

        name.FontSize = "Size14"

        name.TextWrapped = true

        name.Size = UDim2.new(1, 0, 1, 0)

        name.TextYAlignment = "Top"

        name.BackgroundTransparency = 1

        name.TextStrokeTransparency = 0.5

        name.TextColor3 = Color3.fromRGB(80, 245, 245)        

        else

          Lgd["NameEsp"].TextLabel.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")    

          end                              

        end

      end

    end

    else

      if workspace:FindFirstChild("Lgd") then

        workspace:FindFirstChild("Lgd"):Destroy()

    end    

  end

end

ChestEsp = function()

    if ChestESP then

        local CollectionService = game:GetService("CollectionService")

        local Players = game:GetService("Players")

        local Player = Players.LocalPlayer

        local Character = Player.Character or Player.CharacterAdded:Wait()

        local playerPos = Character:GetPivot().Position

        local Chests = CollectionService:GetTagged("_ChestTagged")        

        for _, Chest in ipairs(Chests) do

local __DARKLUA_CONTINUE_507=false repeat            if not SelectedIsland or Chest:IsDescendantOf(SelectedIsland) then

                if not Chest:GetAttribute("IsDisabled") then

                    local chestPos

                    local success, result = pcall(function() return Chest:GetPivot().Position end)

                    if success then

                        chestPos = result

                    elseif Chest:IsA("BasePart") then

                        chestPos = Chest.Position

                    else

__DARKLUA_CONTINUE_507=true                        break  

                    end                  

                    local distanceMagnitude = (chestPos - playerPos).Magnitude

                    local sanitizedFullName = Chest:GetFullName():gsub("[^%w_]", "_")

                    local existingEsp = Chest:FindFirstChild("ChestEspAttachment")                    

                    if not existingEsp then

                        local attachment = Instance.new("Attachment")

                        attachment.Name = "ChestEspAttachment"

                        attachment.Parent = Chest

                        attachment.Position = Vector3.new(0, 3, 0)                     

                        local nameEsp = Instance.new("BillboardGui")

                        nameEsp.Name = "NameEsp"

                        nameEsp.Size = UDim2.new(0, 200, 0, 30)

                        nameEsp.Adornee = attachment

                        nameEsp.ExtentsOffset = Vector3.new(0, 1, 0)

                        nameEsp.AlwaysOnTop = true

                        nameEsp.Parent = attachment                        

                        local nameLabel = Instance.new("TextLabel")

                        nameLabel.Font = Enum.Font.Code

                        nameLabel.TextSize = 14

                        nameLabel.TextWrapped = true

                        nameLabel.Size = UDim2.new(1, 0, 1, 0)

                        nameLabel.TextYAlignment = Enum.TextYAlignment.Top

                        nameLabel.BackgroundTransparency = 1

                        nameLabel.TextStrokeTransparency = 0.5

                        nameLabel.TextColor3 = Color3.fromRGB(80, 245, 245)

                        nameLabel.Parent = nameEsp

                    end

                    local nameEsp = existingEsp and existingEsp:FindFirstChild("NameEsp")

                    if nameEsp then

                        local displayDistance = math.floor(distanceMagnitude / 3)

                        local chestName = Chest.Name:gsub("Label", "")

                        nameEsp.TextLabel.Text = string.format("[%s] %d M", chestName, displayDistance)

                    end

                    if _G_AutoFarmChest and distanceMagnitude <= 20 then

                        if existingEsp then

                            existingEsp:Destroy()

                        end

                    end

                end

            end

__DARKLUA_CONTINUE_507=true until true if not __DARKLUA_CONTINUE_507 then break end        end

    else

        for _, Chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do

            local espAttachment = Chest:FindFirstChild("ChestEspAttachment")

            if espAttachment then

                espAttachment:Destroy()

            end

        end

    end

end

berriesEsp = function()

    if BerryEsp then

        local CollectionService = game:GetService("CollectionService")

        local Players = game:GetService("Players")

        local Player = Players.LocalPlayer

        local BerryBushes = CollectionService:GetTagged("BerryBush")

        for _, Bush in ipairs(BerryBushes) do

            local bushPosition = Bush.Parent:GetPivot().Position

            for _, BerryName in pairs(Bush:GetAttributes()) do

                if BerryName and (not BerryArray or table.find(BerryArray, BerryName)) then

                    local espPartName = "BerryEspPart_" .. BerryName .. "_" .. tostring(bushPosition)

                    local existingEsp = workspace:FindFirstChild(espPartName)

                    if not existingEsp then

                        existingEsp = Instance.new("Part")

                        existingEsp.Name = espPartName

                        existingEsp.Transparency = 1

                        existingEsp.Size = Vector3.new(1, 1, 1)

                        existingEsp.Anchored = true

                        existingEsp.CanCollide = false

                        existingEsp.Parent = workspace

                        existingEsp.CFrame = CFrame.new(bushPosition)

                    end

                    if not existingEsp:FindFirstChild("NameEsp") then

                        local nameEsp = Instance.new("BillboardGui", existingEsp)

                        nameEsp.Name = "NameEsp"

                        nameEsp.ExtentsOffset = Vector3.new(0, 1, 0)

                        nameEsp.Size = UDim2.new(0, 200, 0, 30)

                        nameEsp.Adornee = existingEsp

                        nameEsp.AlwaysOnTop = true

                        local nameLabel = Instance.new("TextLabel", nameEsp)

                        nameLabel.Font = Enum.Font.Code

                        nameLabel.TextSize = 14

                        nameLabel.TextWrapped = true

                        nameLabel.Size = UDim2.new(1, 0, 1, 0)

                        nameLabel.TextYAlignment = Enum.TextYAlignment.Top

                        nameLabel.BackgroundTransparency = 1

                        nameLabel.TextStrokeTransparency = 0.5

                        nameLabel.TextColor3 = Color3.fromRGB(80, 245, 245)

                        nameLabel.Parent = nameEsp

                    end

                    local nameEsp = existingEsp:FindFirstChild("NameEsp")

                    local distance = (Player.Character.Head.Position - bushPosition).Magnitude / 3

                    nameEsp.TextLabel.Text = ('[' .. BerryName .. ']' .. " " .. math.round(distance) .. " M")

                    if _G.AutoBerry and math.round(distance) <= 20 then

                        existingEsp:Destroy()

                    end

                end

            end

        end

    else

        for _, v in ipairs(workspace:GetChildren()) do

            if v:IsA("Part") and v.Name:match("BerryEspPart_.*") then

                v:Destroy()

            end

        end

    end

end



Q = Tabs.Combat:AddToggle("Q", {Title = "Esp Berries", Description = "", Default = false})

Q:OnChanged(function(Value)

  BerryEsp = Value

  while BerryEsp do wait()

    berriesEsp() 

  end

end)



Q = Tabs.Combat:AddToggle("Q", {Title = "Esp Players", Description = "", Default = false})

Q:OnChanged(function(Value)

  PlayerEsp = Value

  while PlayerEsp do wait()

    EspPly()

  end

end)



Q = Tabs.Combat:AddToggle("Q", {Title = "Esp Chests", Description = "", Default = false})

Q:OnChanged(function(Value)

  ChestESP = Value

  while ChestESP do wait()

    ChestEsp() 

  end

end)



Q = Tabs.Combat:AddToggle("Q", {Title = "Esp Fruits", Description = "", Default = false})

Q:OnChanged(function(Value)

  DevilFruitESP = Value

  while DevilFruitESP do wait()

    DevEsp() 

  end

end)



Q = Tabs.Combat:AddToggle("Q", {Title = "Esp Island Location", Description = "", Default = false})

Q:OnChanged(function(Value)

  IslandESP = Value

  while IslandESP do wait()

    LocationEsp() 

  end

end)



if World2 then

Q = Tabs.Combat:AddToggle("Q", {Title = "Esp Flower", Description = "", Default = false})

Q:OnChanged(function(Value)

  FlowerESP = Value

  while FlowerESP do wait()

    flowerEsp() 

  end

end)

Q = Tabs.Combat:AddToggle("Q", {Title = "Esp Legendary Sword", Description = "", Default = false})

Q:OnChanged(function(Value)

  LegenS = Value

  while LegenS do wait()

    LegenSword()

  end

end)

end



if World2 or World3 then

Q = Tabs.Combat:AddToggle("Q", {Title = "Esp Aura Colour Dealers", Description = "", Default = false})

Q:OnChanged(function(Value)

  ColorEsp = Value

  while ColorEsp do wait()

    HakiClorEsp()

  end

end)

end



if World3 then

Q = Tabs.Combat:AddToggle("Q", {Title = "Esp Gears", Description = "", Default = false})

Q:OnChanged(function(Value)

  ESPGear = Value

  while ESPGear do wait()

    gearEsp()

  end

end)

Q = Tabs.Combat:AddToggle("Q", {Title = "Esp SeaEvent Island", Description = "", Default = false})

Q:OnChanged(function(Value)

  EspEventIsland = Value

  while EspEventIsland do wait()

    EventIslandEsp()

  end

end)

Q = Tabs.Combat:AddToggle("Q", {Title = "Esp Advanced Fruits Dealer", Description = "", Default = false})

Q:OnChanged(function(Value)

  advanEsp = Value

  while advanEsp do wait()

    AdvanFruitEsp()

  end

end)

end



Tabs.Locations:AddSection("Sea Teleport")

Tabs.Locations:AddButton({Title = "Teleport To Sea 1", Description = "",

Callback = function()

  replicated.Remotes.CommF_:InvokeServer("TravelMain")

end})

Tabs.Locations:AddButton({Title = "Teleport To Sea 2", Description = "",

Callback = function()

  replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")

end})

Tabs.Locations:AddButton({Title = "Teleport To Sea 3", Description = "",

Callback = function()

  replicated.Remotes.CommF_:InvokeServer("TravelZou")

end})

Tabs.Locations:AddSection("Island Teleport")

Location = {}

for i,v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do  

  table.insert(Location ,v.Name)

end

Travelllll = Tabs.Locations:AddDropdown("Travelllll",{Title = "Select Travelling",Values = Location,Multi = false,Default = 1})

Travelllll:OnChanged(function(Value)

  _G.Island = Value

end)

GoIsland = Tabs.Locations:AddToggle("GoIsland", {Title = "Auto Travel", Description = "Automatic teleport to pos island", Default = false})

GoIsland:OnChanged(function(Value)

  _G.Teleport = Value

  if Value then

    for i,v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do

      if v.Name == _G.Island then

        repeat wait()

	     _tp(v.CFrame * CFrame.new(0, 30, 0)) 

        until not _G.Teleport or Root.CFrame == v.CFrame

      end

    end

  end

end)



Tabs.Locations:AddSection("Travel - Portal")

if World1 then

  Location_Portal = {

    "Sky",

    "UnderWater"

  }

elseif World2 then

  Location_Portal = {

    "SwanRoom",

    "Cursed Ship"

  }

elseif World3 then

  Location_Portal = {

    "Castle On The Sea",

    "Mansion Cafe",

    "Hydra Teleport",

    "Canvendish Room",

    "Temple of Time"

  }

end



PortalTP = Tabs.Locations:AddDropdown("PortalTP",{Title = "Select Portal",Values = Location_Portal,Multi = false,Default = 1})

PortalTP:OnChanged(function(Value)

  _G.Island_PT = Value

end)

Tabs.Locations:AddButton({Title = "requestEntrance", Description = "",Callback = function()

  if _G.Island_PT == "Sky" then

    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894, 5547, -380))

  elseif _G.Island_PT == "UnderWater" then

    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163, 11, 1819))

  elseif _G.Island_PT == "SwanRoom" then

    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(2285, 15, 905))

  elseif _G.Island_PT == "Cursed Ship" then

    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923, 126, 32852))

  elseif _G.Island_PT == "Castle On The Sea" then

    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5097.93164, 316.447021, -3142.66602, -0.405007899, -4.31682743e-08, 0.914313197, -1.90943332e-08, 1, 3.8755779e-08, -0.914313197, -1.76180437e-09, -0.405007899))

  elseif _G.Island_PT == "Mansion Cafe" then

    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))

  elseif _G.Island_PT == "Hydra Teleport" then

    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625))

  elseif _G.Island_PT == "Canvendish Room" then

    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5314.54638671875, 22.562219619750977, -127.06755065917969))

  elseif _G.Island_PT == "Temple of Time" then

    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(28310.0234, 14895.1123, 109.456741, -0.469690144, -2.85620132e-08, -0.882831335, -3.23509219e-08, 1, -1.51411736e-08, 0.882831335, 2.14487486e-08, -0.469690144))

  end

end})



Tabs.Locations:AddSection("Travel - NPCs")

for _, v in pairs(replicated.NPCs:GetChildren()) do table.insert(NPCList, v.Name)end

NPCsPos = Tabs.Locations:AddDropdown("NPCsPos",{Title = "Select NPCs",Values = NPCList,Multi = false,Default = 1})

NPCsPos:OnChanged(function(Value)

  NPClist = Value

end)

GoNPCs = Tabs.Locations:AddToggle("GoNPCs", {Title = "Auto Tween to NPCs", Description = "Automatic teleport to pos Npcs", Default = false})

GoNPCs:OnChanged(function(Value)

  _G.TPNpc = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.TPNpc then

	 pcall(function()

       for __, v in pairs(replicated.NPCs:GetChildren()) do

       if v.Name == NPClist then _tp(v.HumanoidRootPart.CFrame) end

       end                	   	   

	 end)

    end

  end

end)



Tabs.Fruit:AddSection("Fruits Options")

local fruitsOnSale = {}

local function addCommas(number)

    local formatted = tostring(number)

    while true do  

        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1,%2')

        if k == 0 then break end

    end

    return formatted

end

for _, fruitData in pairs(replicated.Remotes.CommF_:InvokeServer("GetFruits",true)) do

    if fruitData["OnSale"] == true then

        local priceWithCommas = addCommas(fruitData["Price"])

        local fruitInfo = fruitData["Name"]

        table.insert(fruitsOnSale, fruitInfo)

    end

end

local Nms = {}

for _, fruitData in pairs(replicated.Remotes.CommF_:InvokeServer("GetFruits",false)) do

    if fruitData["OnSale"] == true then

        local price = addCommas(fruitData["Price"])

        local NormalInFO = fruitData["Name"]

        table.insert(Nms, NormalInFO)

    end

end

Sel_NFruit = Tabs.Fruit:AddDropdown("Sel_NFruit",{Title = "Select Fruit Stock",Values = Nms,Multi = false,Default = 1})

Sel_NFruit:OnChanged(function(Value)

  _G.SelectFruit = Value

end)

Tabs.Fruit:AddButton({Title = "Buy Basic Stock", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("PurchaseRawFruit",_G.SelectFruit)

end})

Sel_MFruit = Tabs.Fruit:AddDropdown("Sel_MFruit",{Title = "Select Mirage Fruit",Values = fruitsOnSale,Multi = false,Default = 1})

Sel_MFruit:OnChanged(function(Value)

  SelectF_Adv = Value

end)

local Nms = {}

for _, fruitData in pairs(replicated.Remotes.CommF_:InvokeServer("GetFruits",false)) do

    if fruitData["OnSale"] == true then

        local price = addCommas(fruitData["Price"])

        local NormalInFO = fruitData["Name"]

        table.insert(Nms, NormalInFO)

    end

end

Tabs.Fruit:AddButton({Title = "Buy Mirage Stock", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("PurchaseRawFruit",SelectF_Adv)

end})

RandomFF = Tabs.Fruit:AddToggle("RandomFF", {Title = "Auto Random Fruit", Description = "Automatic random devil fruit", Default = false})

RandomFF:OnChanged(function(Value)

  _G.Random_Auto = Value

end)

spawn(function()

  while wait(Sec) do

   	pcall(function()

      if _G.Random_Auto then replicated.Remotes.CommF_:InvokeServer("Cousin","Buy") end 

    end)

  end

end)

DropF = Tabs.Fruit:AddToggle("DropF", {Title = "Auto Drop Fruit", Description = "Automatic drop devil fruit", Default = false})

DropF:OnChanged(function(Value)

  _G.DropFruit = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.DropFruit then

      pcall(function() DropFruits() end)

    end

  end

end)

StoredF = Tabs.Fruit:AddToggle("StoredF", {Title = "Auto Store Fruit", Description = "Automatic store devil fruit", Default = false})

StoredF:OnChanged(function(Value)

  _G.StoreF = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.StoreF then

      pcall(function() UpdStFruit() end)

    end

  end

end)

TwF = Tabs.Fruit:AddToggle("TwF", {Title = "Auto Tween to Fruit", Description = "Automatic tween to get devil fruit", Default = false})

TwF:OnChanged(function(Value)

  _G.TwFruits = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.TwFruits then

      pcall(function()

        for _,x1 in pairs(workspace:GetChildren()) do

	    if string.find(x1.Name, "Fruit") then _tp(x1.Handle.CFrame) end

	    end

      end)

    end

  end

end)

BringF = Tabs.Fruit:AddToggle("BringF", {Title = "Auto Collect Fruit", Description = "Automatic bring devil fruit", Default = false})

BringF:OnChanged(function(Value)

  _G.InstanceF = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.InstanceF then

      pcall(function() collectFruits(_G.InstanceF) end)

    end

  end

end)

Tabs.Shop:AddSection("Shop Options")

Tabs.Shop:AddButton({Title = "Buy Buso", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyHaki","Buso")

end})

Tabs.Shop:AddButton({Title = "Buy Geppo", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyHaki","Geppo")

end})

Tabs.Shop:AddButton({Title = "Buy Soru", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyHaki","Soru")

end})

Tabs.Shop:AddButton({Title = "Buy Ken", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("KenTalk","Buy")

end})

Tabs.Shop:AddButton({Title = "Buy Black Cape", Description = "",Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Black Cape")
end})

Tabs.Shop:AddButton({Title = "Buy Swordsman Hat", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Swordsman Hat")

end})

Tabs.Shop:AddButton({Title = "Buy Bizarre Rifle", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("Ectoplasm","Buy", 1)

end})

Tabs.Shop:AddButton({Title = "Buy Ghoul Mask", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("Ectoplasm","Buy", 2)

end})



Tabs.Shop:AddSection("Accessory SeaEvent")

Tabs.Shop:AddButton({Title = "Craft Dragonheart", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("CraftItem","Craft","Dragonheart");

end})

Tabs.Shop:AddButton({Title = "Craft Dragonstorm", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("CraftItem","Craft","Dragonstorm");

end})

Tabs.Shop:AddButton({Title = "Craft DinoHood", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("CraftItem","Craft","DinoHood");

end})   

Tabs.Shop:AddButton({Title = "Craft SharkTooth", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("CraftItem","Craft","SharkTooth");

end})   

Tabs.Shop:AddButton({Title = "Craft TerrorJaw", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("CraftItem","Craft","TerrorJaw");

end})   

Tabs.Shop:AddButton({Title = "Craft SharkAnchor", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("CraftItem","Craft","SharkAnchor");

end})   

Tabs.Shop:AddButton({Title = "Craft LeviathanCrown", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("CraftItem","Craft","LeviathanCrown");

end})   

Tabs.Shop:AddButton({Title = "Craft LeviathanShield", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("CraftItem","Craft","LeviathanShield");

end})   

Tabs.Shop:AddButton({Title = "Craft LeviathanBoat", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("CraftItem","Craft","LeviathanBoat");

end})   

Tabs.Shop:AddButton({Title = "Craft LegendaryScroll", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("CraftItem","Craft","LegendaryScroll");

end})   

Tabs.Shop:AddButton({Title = "Craft MythicalScroll", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("CraftItem","Craft","MythicalScroll");

end})   



Tabs.Shop:AddSection("Weapon World1")

Tabs.Shop:AddButton({Title = "Buy Cutlass", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Cutlass")

end})

Tabs.Shop:AddButton({Title = "Buy Katana", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Katana")

end})

Tabs.Shop:AddButton({Title = "Buy Iron Mace", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Iron Mace")

end})   

Tabs.Shop:AddButton({Title = "Buy Duel Katana", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Duel Katana")

end})   

Tabs.Shop:AddButton({Title = "Buy Triple Katana", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Triple Katana")

end})  

Tabs.Shop:AddButton({Title = "Buy Pipe", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Pipe")

end})  

Tabs.Shop:AddButton({Title = "Buy Dual-Headed Blade", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Dual-Headed Blade")

end})   

Tabs.Shop:AddButton({Title = "Buy Bisento", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Bisento")

end})  

Tabs.Shop:AddButton({Title = "Buy Soul Cane", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Soul Cane")

end})

Tabs.Shop:AddButton({Title = "Buy Slingshot", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Slingshot")

end})

Tabs.Shop:AddButton({Title = "Buy Musket", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Musket")

end})    

Tabs.Shop:AddButton({Title = "Buy Dual Flintlock", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Dual Flintlock")

end})   

Tabs.Shop:AddButton({Title = "Buy Flintlock", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Flintlock")

end})   

Tabs.Shop:AddButton({Title = "Buy Refined Flintlock", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Refined Flintlock")

end})   

Tabs.Shop:AddButton({Title = "Buy Cannon", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BuyItem","Cannon")

end}) 

Tabs.Shop:AddButton({Title = "Buy Kabucha", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Slingshot","2")

end})



Tabs.Shop:AddSection("Fragments shop")

Tabs.Shop:AddButton({Title = "Buy Refund Stats", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","2")

end})

Tabs.Shop:AddButton({Title = "Buy Reroll Race", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","2")

end})   

Tabs.Shop:AddButton({Title = "Buy Ghoul Race (2.5k)", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("Ectoplasm"," Change", 4)

end})	

Tabs.Shop:AddButton({Title = "Buy Cyborg Race (2.5k)", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("CyborgTrainer"," Buy")

end})


Tabs.Locations:AddSection("Player Gui / Others")

Tabs.Locations:AddButton({Title = "Open Awakenings Expert", Description = "",Callback = function()

  plr.PlayerGui.Main.AwakeningToggler.Visible = true

end})

Tabs.Locations:AddButton({Title = "Open Title Selection", Description = "",Callback = function()

  replicated.Remotes.CommF_:InvokeServer("getTitles",true)

  plr.PlayerGui.Main.Titles.Visible = true

end})

DisbleChat = Tabs.Locations:AddToggle("DisbleChat", {Title = "Disable Chat GUI", Description = "", Default = false})

DisbleChat:OnChanged(function(Value)

  _G.Rechat = Value

  if  _G.Rechat == true then

    local StarterGui = game:GetService('StarterGui')

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)    

  elseif _G.chat == false then

    local StarterGui = game:GetService('StarterGui')

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)    

  end

end)

DisbleLeaderB = Tabs.Locations:AddToggle("DisbleLeaderB", {Title = "Disable Leader Board GUI", Description = "", Default = false})

DisbleLeaderB:OnChanged(function(Value)

  ReLeader = Value

  if ReLeader == true then

    local StarterGui = game:GetService('StarterGui')

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)   

  elseif ReLeader == false then

    local StarterGui = game:GetService('StarterGui')

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)   

  end

end)

Tabs.Locations:AddButton({Title = "Set Pirate Team", Description = "",Callback = function()

  Pirates()

end})  

Tabs.Locations:AddButton({Title = "Set Marine Team", Description = "",Callback = function()

  Marines()

end})

UnPortal = Tabs.Locations:AddToggle("UnPortal", {Title = "Unlock All Portals", Description = "unlocked portal for who doesn't defeat rip_indra", Default = false})

UnPortal:OnChanged(function(Value)

  _G.PortalUnLock = Value

end)

spawn(function()

  while wait(Sec) do

    pcall(function()

      if _G.PortalUnLock then        

         if Attack.Pos(CstlePos_Miti,8) then

           replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))

         elseif Attack.Pos(Man3Pos_Miti,8) then

           replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5072.08984375, 314.5412902832, -3151.1098632812))

         elseif Attack.Pos(HydraPos_Miti,8) then                    

           replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5748.7587890625, 610.44982910156, -267.81704711914))

         elseif Attack.Pos(HydratoCastle,8) then                   

           replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5072.08984375, 314.5412902832, -3151.1098632812))

        end

      end

    end)

  end

end)



Tabs.Locations:AddSection("Graphics / Haki Stats")



HakiSt = {"State 0","State 1","State 2","State 3","State 4","State 5"}

HakiStat = Tabs.Locations:AddDropdown("HakiStat",{Title = "Select Haki States",Values = HakiSt,Multi = false,Default = 1})

HakiStat:OnChanged(function(Value)

  _G.SelectStateHaki = Value

end)

Tabs.Locations:AddButton({Title = "ChangeBusoStage", Description = "",Callback = function()

  if _G.SelectStateHaki == "State 0" then

    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",0)

  elseif _G.SelectStateHaki == "State 1" then

    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",1)

  elseif _G.SelectStateHaki == "State 2" then

    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",2)

  elseif _G.SelectStateHaki == "State 3" then

    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",3)

  elseif _G.SelectStateHaki == "State 4" then

    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",4)

  elseif _G.SelectStateHaki == "State 5" then

    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",5)

  end

end})

rtxM = Tabs.Locations:AddToggle("rtxM", {Title = "Turn on RTX Mode", Description = "", Default = false})

rtxM:OnChanged(function(Value)

  _G.RTXMode = Value

  local a = game.Lighting

  local c = Instance.new("ColorCorrectionEffect", a)

  local e = Instance.new("ColorCorrectionEffect", a)

  OldAmbient = a.Ambient

  OldBrightness = a.Brightness

  OldColorShift_Top = a.ColorShift_Top

  OldBrightnessc = c.Brightness

  OldContrastc = c.Contrast

  OldTintColorc = c.TintColor

  OldTintColore = e.TintColor    

  if not _G.RTXMode then return end

  while _G.RTXMode do wait()

    a.Ambient = Color3.fromRGB(33, 33, 33)

    a.Brightness = 0.3

    c.Brightness = 0.176

    c.Contrast = 0.39

    c.TintColor = Color3.fromRGB(217, 145, 57)

    game.Lighting.FogEnd = 999

    if not plr.Character.HumanoidRootPart:FindFirstChild("PointLight") then

      local a2 = Instance.new("PointLight")

      a2.Parent = plr.Character.HumanoidRootPart

      a2.Range = 15

      a2.Color = Color3.fromRGB(217, 145, 57)

    end

    if not _G.RTXMode then

      a.Ambient = OldAmbient

      a.Brightness = OldBrightness

      a.ColorShift_Top = OldColorShift_Top

      c.Contrast = OldContrastc

      c.Brightness = OldBrightnessc

      c.TintColor = OldTintColorc

      e.TintColor = OldTintColore

      game.Lighting.FogEnd = 2500

      plr.Character.HumanoidRootPart:FindFirstChild("PointLight"):Destroy()

    end

  end

end)

Tabs.Locations:AddButton({Title = "Turn on Fast Mode", Description = "",Callback = function()

  for _,zx in next, workspace:GetDescendants() do

  if table.find(Past, zx.ClassName) then  zx.Material = "Plastic" end

  end

end})

Tabs.Locations:AddButton({Title = "Turn on Low CPU", Description = "",Callback = function()

  LowCpu()

end})

Tabs.Locations:AddButton({Title = "Turn on increase Boats", Description = "",Callback = function()

  for _, v in pairs(workspace.Boats:GetDescendants()) do

    if table.find(ListSeaBoat, v.Name) and tostring(v.Owner.Value) == tostring(plr.Name) then              

      v.VehicleSeat.MaxSpeed = 350

      v.VehicleSeat.Torque = 0.2

      v.VehicleSeat.TurnSpeed = 5

      v.VehicleSeat.HeadsUpDisplay = true

    end

  end

end})

Tabs.Locations:AddButton({Title = "Remove Sky Fog", Description = "",Callback = function()

  if Lighting:FindFirstChild("LightingLayers") then Lighting.LightingLayers:Destroy() end

  if Lighting:FindFirstChild("SeaTerrorCC") then Lighting.SeaTerrorCC:Destroy() end

  if Lighting:FindFirstChild("FantasySky") then Lighting.FantasySky:Destroy() end

end})



Tabs.Setting:AddSection("Interface")

local ThemeDropdown = Tabs.Setting:AddDropdown("Theme_1", {
    Title = "Theme",
    Description = "Change UI theme",
    Values = Fluent.Themes,
    Default = "Dark",
    Callback = function(value)
        Fluent:SetTheme(value)
    end
})

Tabs.Setting:AddSection("Server")

Tabs.Locations:AddButton({Title = "Rejoin Server", Description = "",Callback = function()

  game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)

end})

Tabs.Locations:AddButton({Title = "Hop Server", Description = "",Callback = function()

  Hop()

end})

Tabs.Setting:AddButton({Title = "Hop to Lowest Players", Description = "",Callback = function()

  local Http = game:GetService("HttpService")

  local TPS = game:GetService("TeleportService")

  local Api = "https://games.roblox.com/v1/games/"

  local _place = game.PlaceId

  local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"

   function ListServers(cursor)

     local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))

     return Http:JSONDecode(Raw)

   end

   local Server, Next; repeat

   local Servers = ListServers(Next)

   Server = Servers.data[1]

   Next = Servers.nextPageCursor

  until Server

  TPS:TeleportToPlaceInstance(_place,Server.id,plr)

end})



Tabs.Setting:AddButton({Title = "Hop to Lowest Pings Server", Description = "",Callback = function()

local HTTPService = game:GetService("HttpService")

local TeleportService = game:GetService("TeleportService")

local StatsService = game:GetService("Stats")

local function fetchServersData(placeId, limit)

    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?limit=%d", placeId, limit)

    local success, response = pcall(function()

        return HTTPService:JSONDecode(game:HttpGet(url))

    end)

  if success and response and response.data then

	return response.data

  end

    return nil

  end

  local placeId = game.PlaceId

  local serverLimit = 100

  local servers = fetchServersData(placeId, serverLimit)

  if not servers then return end

  local lowestPingServer = servers[1]

  for _, server in pairs(servers) do

    if server["ping"] < lowestPingServer["ping"] and server.maxPlayers > server.playing then

      lowestPingServer = server

    end

  end

  local commonLoadTime = 0.5

  task.wait(commonLoadTime)

  local pingThreshold = 100

  local serverStats = StatsService.Network.ServerStatsItem

  local dataPing = serverStats["Data Ping"]:GetValueString()

  local pingValue = tonumber(dataPing:match("(%d+)"))

  if pingValue >= pingThreshold then

    TeleportService:TeleportToPlaceInstance(placeId, lowestPingServer.id)

  else

    --pings

  end

end})



local JobID = Tabs.Setting:AddInput("JobID", {Title = "JobID",Default = "",Placeholder = "",

Numeric = false, -- Only allows numbers

Finished = false, -- Only calls callback when you press enter

Callback = function(Value)

  _G.JobId = Value

end})

spawn(function()

  while wait(Sec) do

    if _G.JobId then

      pcall(function()

        local Connection

        Connection = plr.OnTeleport:Connect(function(br)

          if br == Enum.TeleportState.Failed then

          Connection:Disconnect()

          if workspace:FindFirstChild("Message") then workspace.Message:Destroy() end

          end

        end)

      end)

    end

  end

end)


Tabs.Setting:AddButton({Title = "Teleport [Job ID]", Description = "",Callback = function()

  replicated['__ServerBrowser']:InvokeServer("teleport",_G.JobId)

end})

Tabs.Setting:AddButton({Title = "Copy JobID", Description = "",Callback = function()

  setclipboard(tostring(game.JobId))

end})

Tabs.Locations:AddButton({Title = "Rain Fruits (Client)", Description = "",Callback = function()

  for i, v in pairs(game:GetObjects("rbxassetid://14759368201")[1]:GetChildren()) do

    v.Parent = game.Workspace.Map

    v:MoveTo(plr.Character.PrimaryPart.Position + Vector3.new(math.random(-50, 50), 100, math.random(-50, 50)))

    if v.Fruit:FindFirstChild("AnimationController") then

      v.Fruit:FindFirstChild("AnimationController"):LoadAnimation(v.Fruit:FindFirstChild("Idle")):Play()

    end

    v.Handle.Touched:Connect(function(otherPart)

      if otherPart.Parent == plr.Character then

        v.Parent = plr.Backpack

        plr.Character.Humanoid:EquipTool(v)

      end

    end)

  end

end})

briggt1 = Tabs.Locations:AddToggle("briggt1", {Title = "Turn on Full Bright", Description = "", Default = false})

briggt1:OnChanged(function(Value)

  bright = Value

  if Value == true then

    Lighting.Ambient = Color3.new(1, 1, 1)

    Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)

    Lighting.ColorShift_Top = Color3.new(1, 1, 1)

  else

    Lighting.Ambient = Color3.new(0, 0, 0)

    Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)

    Lighting.ColorShift_Top = Color3.new(0, 0, 0)

  end  

end)



Cheat_DayNight = {"Day", "Night"}

DayN = Tabs.Locations:AddDropdown("DayN",{Title = "Select Time",Values = Cheat_DayNight,Multi = false,Default = 1})

DayN:OnChanged(function(Value)

  _G.SelectDN = Value

end)

dayornight = Tabs.Locations:AddToggle("dayornight", {Title = "Turn on Time", Description = "", Default = false})

dayornight:OnChanged(function(Value)

  _G.daylightN = Value

end)

task.spawn(function()

  while task.wait() do

    if _G.daylightN then

      if _G.SelectDN == "Day" then

        Lighting.ClockTime = 12

      elseif _G.SelectDN == "Night" then

        Lighting.ClockTime = 0

      end

    end

  end

end)

walkWater = Tabs.Locations:AddToggle("walkWater", {Title = "Turn on Walk on Water", Description = "walk on water", Default = true})

walkWater:OnChanged(function(Value)

  _G.WalkWater_Part = Value

  if _G.WalkWater_Part then

    game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)

  else

    game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 80, 1000)

  end

end)

iceWalk = Tabs.Locations:AddToggle("iceWalk", {Title = "Turn on Ice Walk", Description = "Ice walk just like walk on water but have ice effect", Default = false})

iceWalk:OnChanged(function(Value)

  _G.WalkWater = Value

end)

spawn(function()

  while task.wait() do

    if _G.WalkWater then

      pcall(function()

	   if plr.Character and plr.Character:FindFirstChild("LeftFoot") then

	   local upval0 = replicated.Assets.Models.IceSpikes4:Clone()

        upval0.Parent = workspace

        upval0.Size = Vector3.new(3+math.random(10,12),1.7,3+math.random(10,12))

        upval0.Color = Color3.fromRGB(128,187,219)

        upval0.CFrame = CFrame.new(plr.Character.Head.Position.X,-3.8,plr.Character.Head.Position.Z)*CFrame.Angles((math.random()-0.5)*0.06, math.random()*7,(math.random()-0.5)*0.07)

        local var85={};

        var85.Size=Vector3.new(0,0.3,0)

        local var3=TW:Create(upval0,TweenInfo.new(2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),var85)

        var3.Completed:Connect(function()

          upval0:Destroy()

        end)

          var3:Play()

	    end	

      end)

    end

  end

end)

local player = game.Players.LocalPlayer

local function IsEntityAlive(entity)

    if not entity then return false end

    local humanoid = entity:FindFirstChild("Humanoid")

    return humanoid and humanoid.Health > 0

end

local function GetEnemiesInRange(character, range)

    local enemies = game:GetService("Workspace").Enemies:GetChildren()

    local players = game:GetService("Players"):GetPlayers()

    local targets = {}

    local playerPos = character:GetPivot().Position

    for _, enemy in ipairs(enemies) do

        local rootPart = enemy:FindFirstChild("HumanoidRootPart")

        if rootPart and IsEntityAlive(enemy) then

            local distance = (rootPart.Position - playerPos).Magnitude

            if distance <= range then

                table.insert(targets, enemy)

            end

        end

    end

    for _, otherPlayer in ipairs(players) do

        if otherPlayer ~= player and otherPlayer.Character then

            local rootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")

            if rootPart and IsEntityAlive(otherPlayer.Character) then

                local distance = (rootPart.Position - playerPos).Magnitude

                if distance <= range then

                    table.insert(targets, otherPlayer.Character)

                end

            end

        end

    end

    return targets

end


function AttackNoCoolDown()

    local player = game:GetService("Players").LocalPlayer

    local character = player.Character

    if not character then return end

    local equippedWeapon = nil

    for _, item in ipairs(character:GetChildren()) do

        if item:IsA("Tool") then

            equippedWeapon = item

            break

        end

    end

    if not equippedWeapon then return end

    local enemiesInRange = GetEnemiesInRange(character, 60)

    if #enemiesInRange == 0 then return end

    local storage = game:GetService("ReplicatedStorage")

    local modules = storage:FindFirstChild("Modules")

    if not modules then return end

    local attackEvent = storage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack")

    local hitEvent = storage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit")

    if not attackEvent or not hitEvent then return end

    local targets, mainTarget = {}, nil

    for _, enemy in ipairs(enemiesInRange) do

        if not enemy:GetAttribute("IsBoat") then

            local HitboxLimbs = {"RightLowerArm", "RightUpperArm", "LeftLowerArm", "LeftUpperArm", "RightHand", "LeftHand"}

            local head = enemy:FindFirstChild(HitboxLimbs[math.random(#HitboxLimbs)]) or enemy.PrimaryPart

            if head then

                table.insert(targets, { enemy, head })

                mainTarget = head

            end

        end

    end

    if not mainTarget then return end

    attackEvent:FireServer(0)

    local playerScripts = player:FindFirstChild("PlayerScripts")

    if not playerScripts then return end

    local localScript = playerScripts:FindFirstChildOfClass("LocalScript")

    while not localScript do

        playerScripts.ChildAdded:Wait()

        localScript = playerScripts:FindFirstChildOfClass("LocalScript")

    end

    local hitFunction

    if getsenv then

        local success, scriptEnv = pcall(getsenv, localScript)

        if success and scriptEnv then

            hitFunction = scriptEnv._G.SendHitsToServer

        end

    end

    local successFlags, combatRemoteThread = pcall(function()

        return require(modules.Flags).COMBAT_REMOTE_THREAD or false

    end)

    if successFlags and combatRemoteThread and hitFunction then

        hitFunction(mainTarget, targets)

    elseif successFlags and not combatRemoteThread then

        hitEvent:FireServer(mainTarget, targets)

    end

end

CameraShakerR = require(game.ReplicatedStorage.Util.CameraShaker)

CameraShakerR:Stop()

get_Monster=function()for a,b in pairs(workspace.Enemies:GetChildren())do local c=b:FindFirstChild("UpperTorso")or b:FindFirstChild("Head")if b:FindFirstChild("HumanoidRootPart",true)and c then if(b.Head.Position-plr.Character.HumanoidRootPart.Position).Magnitude<=50 then return true,c.Position end end end;for a,d in pairs(workspace.SeaBeasts:GetChildren())do if d:FindFirstChild("HumanoidRootPart")and d:FindFirstChild("Health")and d.Health.Value>0 then return true,d.HumanoidRootPart.Position end end;for a,d in pairs(workspace.Enemies:GetChildren())do if d:FindFirstChild("Health")and d.Health.Value>0 and d:FindFirstChild("VehicleSeat")then return true,d.Engine.Position end end end

Actived=function()local a=game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")for b,c in next,getconnections(a.Activated)do if typeof(c.Function)=='function'then getupvalues(c.Function)end end end

task.spawn(function()

  RunSer.Heartbeat:Connect(function()

    pcall(function()      

      if not _G.Seriality then return end      

      AttackNoCoolDown() 

      local Pretool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")

      local ToolTip = Pretool.ToolTip

      local MobAura, Mon = get_Monster()      

      if ToolTip == "Blox Fruit" then

        if MobAura then           

          local LeftClickRemote = Pretool:FindFirstChild('LeftClickRemote');

          if LeftClickRemote then Actived() LeftClickRemote:FireServer(Vector3.new(0.01,-500,0.01),1,true);LeftClickRemote:FireServer(false)end

        end     		                         

      end      

    end)

  end)

end)


Tabs.Dungeons:AddSection("Farm")

local Q = Tabs.Dungeons:AddToggle("Q", {Title = "Auto Unlock Dough dungeon", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.Doughv2 = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.Doughv2 then

      pcall(function()

	    if not workspace.Map.CakeLoaf:FindFirstChild("RedDoor") then

	      if GetBP("Red Key") then

	        replicated.Remotes.CommF_:InvokeServer("CakeScientist","Check")

	        replicated.Remotes.CommF_:InvokeServer("RaidsNpc","Check")

		  end

	    elseif workspace.Map.CakeLoaf:FindFirstChild("RedDoor") then

          if GetBP("Red Key") then

		    repeat wait() _tp(CFrame.new(-2681.97998, 64.3921585, -12853.7363, 0.149007782, -1.87902192e-08, 0.98883605, 3.60619588e-08, 1, 1.35681812e-08, -0.98883605, 3.36376011e-08, 0.149007782)) until not _G.Doughv2 or (plr.Character.HumanoidRootPart.CFrame - CFrame.new(-2681.97998, 64.3921585, -12853.7363, 0.149007782, -1.87902192e-08, 0.98883605, 3.60619588e-08, 1, 1.35681812e-08, -0.98883605, 3.36376011e-08, 0.149007782)).Magnitude <= 5

		    EquipWeapon("Red Key")

		  end

		  elseif GetConnectionEnemies("Dough King") then

		    local v = GetConnectionEnemies("Dough King")

            if v then

              repeat wait() Attack.Kill(v,_G.Doughv2) until not _G.Doughv2 or not v.Parent or v.Humanoid.Health <= 0

            else

              _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) 

            end

	      end

		  if GetBP("Sweet Chalice") then

		    replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)

		    _G.AutoMiror = true

	      else

	        _G.AutoMiror = false

          end

	      if GetBP("God's Chalice") and GetM("Conjured Cocoa") >= 10 then

		    replicated.Remotes.CommF_:InvokeServer("SweetChaliceNpc")

		  end

	      if not plr.Backpack:FindFirstChild("God's Chalice") or plr.Character:FindFirstChild("God's Chalice") then

	        _G.FarmEliteHunt = true

		  else

		    _G.FarmEliteHunt = false

		  end

	      if GetM("Conjured Cocoa") <= 10 then	        

		  local cocoa3 = {"Cocoa Warrior","Chocolate Bar Battler"}

		  local v = GetConnectionEnemies(cocoa3)

            if v then

            repeat wait() Attack.Kill(v,_G.Doughv2) until _G.Doughv2 == false or not v.Parent or v.Humanoid.Health <= 0

          else

            _tp(CFrame.new(402.7189025878906, 81.06050109863281, -12259.54296875))

          end	      

        end

      end)

    end

  end

end)

local Q = Tabs.Dungeons:AddToggle("Q", {Title = "Auto Unlock Phoenix dungeon", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoPhoenixF = Value

end)

spawn(function()

  while wait(.1) do

    if _G.AutoPhoenixF then

      pcall(function()

        if GetBP("Bird-Bird: Phoenix") then

          if plr.Backpack:FindFirstChild(plr.Data.DevilFruit.Value) then

            if plr.Backpack:FindFirstChild(plr.Data.DevilFruit.Value).Level.Value >= 400 then

               _tp(CFrame.new(-2812.76708984375, 254.803466796875, -12595.560546875))

               if (CFrame.new(-2812.76708984375, 254.803466796875, -12595.560546875).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then

                 replicated.Remotes.CommF_:InvokeServer("SickScientist","Check")

                 replicated.Remotes.CommF_:InvokeServer("SickScientist","Heal")

               end

             end

             elseif plr.Character:FindFirstChild(plr.Data.DevilFruit.Value) then

             if plr.Character:FindFirstChild(plr.Data.DevilFruit.Value).Level.Value >= 400 then

               _tp(CFrame.new(-2812.76708984375, 254.803466796875, -12595.560546875))

              if (CFrame.new(-2812.76708984375, 254.803466796875, -12595.560546875).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then

                replicated.Remotes.CommF_:InvokeServer("SickScientist","Check")

                replicated.Remotes.CommF_:InvokeServer("SickScientist","Heal")

              end

            end

          end

        end

      end)

    end 

  end

end)


DungeonTables = {"Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Human: Buddha","Sand","Bird: Phoenix","Dough"}

local Q = Tabs.Dungeons:AddDropdown("Q",{Title = "Select Chip",Values = DungeonTables,Multi = false,Default = 1})

Q:OnChanged(function(Value)

  _G.SelectChip = Value

end)

local Q = Tabs.Dungeons:AddToggle("Q", {Title = "Auto Select Dungeon Chip", Description = "", Default = false})

Q:OnChanged(function(Value)

  _G.AutoSelectDungeon = Value

end)

spawn(function()

  while wait(Sec) do

    if _G.AutoSelectDungeon then

      pcall(function()

        if GetBP("Flame-Flame") then

          _G.SelectChip = "Flame"

        elseif GetBP("Ice-Ice") then

          _G.SelectChip = "Ice"

        elseif GetBP("Quake-Quake") then

          _G.SelectChip = "Quake"

        elseif GetBP("Light-Light") then

          _G.SelectChip = "Light"

        elseif GetBP("Dark-Dark") then

          _G.SelectChip = "Dark"

        elseif GetBP("String-String") then

          _G.SelectChip = "String"

        elseif GetBP("Rumble-Rumble") then

          _G.SelectChip = "Rumble"

         elseif GetBP("Magma-Magma") then

          _G.SelectChip = "Magma"

         elseif GetBP("Human-Human: Buddha Fruit") then

          _G.SelectChip = "Human: Buddha"

        elseif GetBP("Dough-Dough") then

          _G.SelectChip = "Dough"

        elseif GetBP("Sand-Sand") then

          _G.SelectChip = "Sand"

        elseif GetBP("Bird-Bird: Phoenix") then

          _G.SelectChip = "Bird: Phoenix"

        else

          _G.SelectChip = "Ice"

        end

      end)

    end

  end

end)

Tabs.Dungeons:AddButton({Title = "Buy Dungeon Chips [Beli]", Description = "",

Callback = function()

  if not GetBP("Special Microchip") then replicated.Remotes.CommF_:InvokeServer("RaidsNpc","Select",_G.SelectChip) end

end})

Tabs.Dungeons:AddButton({Title = "Buy Dungeon Chips [Devil Fruit]", Description = "Use your lowest fruit in your bag",

Callback = function()

  if GetBP("Special Microchip") then return end

  local FruitPrice = {}

  local FruitStore = {}

  for i,v in next,replicated:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits") do

    if v.Price <= 490000 then table.insert(FruitPrice,v.Name) end 

  end    

  for _,y in pairs(FruitPrice) do    

    for i,v in pairs(DungeonTables) do 

      if not GetBP("Special Microchip") then     

        replicated.Remotes.CommF_:InvokeServer("LoadFruit",tostring(y))	      

	    replicated.Remotes.CommF_:InvokeServer("RaidsNpc","Select",_G.SelectChip)	

	  end            

    end    

  end

end})

Window:SelectTab(1)
