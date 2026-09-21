--[========================================================]
-- FILE: maru_evolution_v7_nousigi_ui_v2.lua
-- VERSION: v7-nousigi-ui-v2-tabs
-- UPDATED: 2026-09-16
-- v6: Added Auto CDK, Auto Soul Guitar, Auto Melee Styles
-- v7: Merged duplicate toggles, cleaned code
-- FIXES:
--   1. [Discord Button] Them button "📋 Copy Discord Link" vao tab Info
--      -> setclipboard copy link https://discord.gg/gk4EM7CVEp
--
--   2. [Tween System] Lay tu red magic beta - clean va nhanh
--      -> _tp: speed = Settings["Tween Speed"] (mac dinh 160)
--      -> Xoa Bypass Teleport, _tpFast
--
--   3. [Raid Kill Aura] Lay tu Moonlight + kill-aura.txt
--      -> Kill Aura tu dong khi den Island 4 va Island 5
--      -> sethiddenproperty + Health = 0 + BreakJoints
--      -> Tat tu dong khi raid xong (raidActive check)
--      -> Auto Start Raid, Auto Awakening, Auto Teleport Lab
--      -> Fix topos -> _tp, xoa StopTween
--
-- UPDATED: 2026-09-13 - Farm Bone + Status Info + Tyrant logic
--   4. [Select Farm] Them option "Farm Bone" -> dropdown co 5 lua chon:
--      None / Farm Level / Farm Cake Prince / Farm Tyrant of Skies / Farm Bone
--      Callback reset het cac farm + alreadyTeleported / teleporting
--   5. [Status Info] 3 khoi INFO (Cake Prince / Tyrant of the Skies /
--      Farm Bone) duoc dua len TREN dropdown "Select Farm"; xoa cac
--      paragraph status cu o duoi (Cake Princes / Bones / Check Status Eyes)
--      de khong bi duplicate. Khong xoa logic farm nao.
--   6. [Tyrant] Thay vong lap farm Tyrant bang ban moi: uu tien danh boss,
--      sau do moi tim 4 mob nho theo thu tu, khong co quai -> ve center.
--      KHONG dung bypass teleport (chi _tp).
--   7. [Toggle Auto Farm Bone] Callback khong con set _G.ActiveFarm
--      ("Bone" / nil) -> override doc lap, chi tat cac farm khac.
--   8. [Fix tran 200 local cua Luau] alreadyTeleported / teleporting chuyen
--      tu local -> global (callback dropdown reset dung bien farm dang doc);
--      3 khoi INFO boc trong do...end de giai phong register (file von sat
--      tran 200 local, khong boc la CompileError ngay).
--
-- UPDATED: 2026-09-13 - LIQUID GLASS UI (Dwac Hub Edition v9)
--   9. [UI] Do Fluent bi obfuscate (ToirxpFF, load that bai) sang
--      Liquid Glass DwacHub Edition v9 - xay tren dung Fluent dawid
--      v1.1.0 nen 100% API goc: moi toggle/dropdown/slider/button
--      (450+ elements), SaveManager + InterfaceManager deu giu nguyen
--      -> Theme mac dinh doi "Dark" -> "Liquid Glass" (vat lieu kinh)
--      -> Nut noi AssistiveTouch: CHAM = tat/mo UI + icon spin 360,
--         GIU 0.35s = menu kinh long, KEO = di chuyen + dinh mép
--      -> Animation iOS: mo/tat UI spring, moi nut nay nhe kieu iOS
--      -> 13 theme (Liquid Glass Extra/Ultra/Dark, Midnight Blue,...)
--         doi qua InterfaceManager trong tab Setting nhu binh thuong
--      -> Neu link v9 that bai: fallback dawid GitHub van con nguyen
--[========================================================]

do
  ply = game:GetService("Players")
  plr = ply.LocalPlayer
  replicated = game:GetService("ReplicatedStorage")
  Lv = plr:WaitForChild("Data"):WaitForChild("Level").Value
  TeleportService = game:GetService("TeleportService")
  TW = game:GetService("TweenService")
  Lighting = game:GetService("Lighting")
  Enemies = workspace:WaitForChild("Enemies")
  vim1 = game:GetService("VirtualInputManager")
  vim2 = game:GetService("VirtualUser")
  RunSer = game:GetService("RunService")
  Stats = game:GetService("Stats")
  
  repeat task.wait() until plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
  Root = plr.Character.HumanoidRootPart
  plr.CharacterAdded:Connect(function(char)
      Root = char:WaitForChild("HumanoidRootPart")
  end)
  
  TeamSelf = plr.Team
  Energy = 0
  pcall(function() Energy = plr.Character:WaitForChild("Energy").Value end)
  
  BringConnections = {}
  BossList = {}
  MaterialList = {}
  NPCList = {}
  shouldTween = false
  SoulGuitar = false
  KenTest = true
  debug = false
  Brazier1 = false
  Brazier2 = false
  Brazier3 = false
  Sec = 0.05
  ClickState = 0
  Num_self = 25
  RandomCFrame = false
  _B = true
  -- [FIXED] Tick-based orbit system (tu DynamicIsland) - toc do nhanh
  _G.SpinAngle = 0
  _G.SpinRadius = 40
  _G.SpinSpeed = 80
  _G.SpinHeightMelee = 14
  _G.SpinHeightFruit = 12
  _G.SpinEnabled = false
  _G.ActiveFarm = nil
  _G.LastFarmPos = nil
  _G.OrbitLastChange = tick()

end

repeat task.wait() until game:IsLoaded() and plr.PlayerGui:FindFirstChild("Main") and plr.PlayerGui.Main:FindFirstChild("Loading")

repeat local start = plr.PlayerGui:WaitForChild("Main"):WaitForChild("Loading") and game:IsLoaded() wait() until start
World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089
Marines = function() replicated.Remotes.CommF_:InvokeServer("SetTeam","Marines") end
Pirates = function() replicated.Remotes.CommF_:InvokeServer("SetTeam","Pirates") end

-- [NEW] Anti Low Graphics - tu dong chay khi moi mo script
pcall(function()
    local lighting = game:GetService("Lighting")
    lighting.GlobalShadows = false
    lighting.FogEnd = 9e9
    lighting.Brightness = 0
    for _, v in pairs(lighting:GetDescendants()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            v.Enabled = false
        end
    end
    local terrain = workspace.Terrain
    if terrain then
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 0
    end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Lifetime = NumberRange.new(0)
        elseif obj:IsA("Fire") or obj:IsA("SpotLight") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        end
    end
    if settings and settings().Rendering then
        settings().Rendering.QualityLevel = "Level01"
        settings().Rendering.GraphicsMode = "NoGraphics"
    end
    print("[Anti Lag] Da ap dung toi uu do hoa khi mo script!")
end)
if World1 then BossList = {"The Gorilla King","Bobby","The Saw","Yeti","Mob Leader","Vice Admiral","Saber Expert","Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg","Ice Admiral","Greybeard"}
elseif World2 then BossList = {"Diamond","Jeremy","Orbitus","Don Swan","Smoke Admiral","Awakened Ice Admiral","Tide Keeper","Darkbeard","Cursed Captain","Order"}
elseif World3 then BossList = {"Stone","Hydra Leader","Kilo Admiral","Captain Elephant","Beautiful Pirate","Cake Queen","Dough King","Longma","Soul Reaper","rip_indra True Form","Tyrant of the Skies"}
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
local Remotes = {
    RFJobsRemoteFunction = replicated.Modules.Net["RF/JobsRemoteFunction"], 
    RFCraft = replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/Craft")
}
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
local Attack = {}
Attack.__index = Attack
Attack.Alive = function(model) if not model then return end local Humanoid = model:FindFirstChild("Humanoid") return Humanoid and Humanoid.Health > 0 end
Attack.Pos = function(model,dist) return (Root.Position - mode.Position).Magnitude <= dist end
Attack.Dist = function(model,dist) return (Root.Position - model:FindFirstChild("HumanoidRootPart").Position).Magnitude <= dist end

Attack.DistH = function(model,dist) return (Root.Position - model:FindFirstChild("HumanoidRootPart").Position).Magnitude > dist end

-- [FIXED] Tick-based orbit system - xoay vong tu DynamicIsland
-- [UPGRADED - theo yêu cầu boss man] Gộp 4 kiểu vào _G.FarmPositionMode:
-- None/Spin/Orbit/Star. Nhánh Spin giữ NGUYÊN công thức cũ của Maru.
-- Orbit/Star lấy công thức từ Tab 2 (đã verify khớp: Orbit dùng delta-
-- time thật + orbitSpeed=3.5, Star nhảy trục X/Z random mỗi 0.4s).
_G.FarmPositionMode = _G.FarmPositionMode or "None"
_G.OrbitAngle2 = _G.OrbitAngle2 or 0
_G.OrbitLastTick2 = _G.OrbitLastTick2 or tick()
_G.StarAxis = _G.StarAxis or Vector3.new(0, 8, 15)
_G.StarDebounce = _G.StarDebounce or 0

-- [FIXED - "too many local variables (limit 200)"] Bọc do...end: local
-- function GetNextStarAxis + GetSpinCFrame (global) trong cùng khối —
-- GetSpinCFrame vẫn "chụp" được GetNextStarAxis làm upvalue lúc tạo
-- closure, sau đó slot local được giải phóng ngay khi khối đóng, trong
-- khi GetSpinCFrame vẫn là hàm GLOBAL truy cập được khắp file như cũ
-- (giống cách đã fix lỗi tương tự nhiều lần trước trong session này).
do
local function GetNextStarAxis()
    if tick() - _G.StarDebounce <= 0.4 then
        return _G.StarAxis
    end
    local dist = _G.SpinRadius or 15
    local axis
    if math.random() <= 0.5 then
        axis = Vector3.new((math.random() <= 0.5 and -1 or 1) * dist, 8, 0)
    else
        axis = Vector3.new(0, 8, (math.random() <= 0.5 and -1 or 1) * dist)
    end
    _G.StarAxis = axis
    _G.StarDebounce = tick()
    return axis
end

function GetSpinCFrame(targetPart, offset)
    if _G.FarmPositionMode == "Spin" then
        -- [GIỮ NGUYÊN Y HỆT] Tick-based orbit cũ của Maru
        local now = tick()
        if _G.SpinAngle > 50000 then _G.SpinAngle = 60 end
        local _dtOrbit = now - (_G.OrbitLastChange or now)
        if _G.SmoothFarmMode then _dtOrbit = math.min(_dtOrbit, 0.1) end
        _G.SpinAngle = _G.SpinAngle + (_dtOrbit > 0.005 and (_G.SpinSpeed or 80) or 0)
        if _dtOrbit > 0.005 then _G.OrbitLastChange = now end
        local radius = _G.SpinRadius or 40
        local rad = math.rad(_G.SpinAngle)
        local pos = targetPart.Position + Vector3.new(math.cos(rad)*radius, offset, math.sin(rad)*radius)
        return CFrame.new(pos, targetPart.Position)

    elseif _G.FarmPositionMode == "Orbit" then
        -- [MỚI - lấy công thức từ Tab 2, dùng delta-time thật]
        local now = tick()
        local dt = now - _G.OrbitLastTick2
        _G.OrbitLastTick2 = now
        if dt > 0.5 then dt = 0.05 end
        local orbitSpeed = 3.5
        if _G.SmoothFarmMode then
            _G.OrbitAngle2 = _G.OrbitAngle2 + orbitSpeed * math.min(dt, 0.1)
        else
            _G.OrbitAngle2 = _G.OrbitAngle2 + orbitSpeed * dt
        end
        local dist = _G.SpinRadius or 15
        local off = Vector3.new(math.cos(_G.OrbitAngle2) * dist, offset, math.sin(_G.OrbitAngle2) * dist)
        return CFrame.new(targetPart.Position + off, targetPart.Position)

    elseif _G.FarmPositionMode == "Star" then
        -- [MỚI - lấy công thức từ Tab 2, nhảy điểm mỗi 0.4s]
        return targetPart.CFrame + GetNextStarAxis()

    else
        -- "None" (mac dinh) - dung 1 cho co dinh, y het hanh vi cu khi RandomCFrame = false
        return targetPart.CFrame * CFrame.new(0, offset, 0) * CFrame.Angles(0, math.rad(180), 0)
    end
end
end

function GetFarmOffset()
    local offset = _G.SpinHeightMelee or 14
    local tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
    if tool and tool.ToolTip == "Blox Fruit" then
        offset = _G.SpinHeightFruit or 12
    end
    return offset
end

-- [FIXED] Ham Disable tranh xung dot
function DisableOtherFarms(except)
    if except ~= "Level" then _G.Level = false end
    if except ~= "Bone" then _G.AutoFarm_Bone = false end
    if except ~= "Near" then _G.AutoFarmNear = false end
    if except ~= "Island" then _G.AutoFarmIsland = false end
    _G.ActiveFarm = except
end

Attack.Kill = function(model, Succes)
    if not model then return end
    if not model.Parent then return end
    if not model:FindFirstChild("HumanoidRootPart") or not model:FindFirstChild("Humanoid") then return end
    if model.Humanoid.Health <= 0 then return end
    
    if not model:GetAttribute("Locked") then 
        model:SetAttribute("Locked", model.HumanoidRootPart.CFrame) 
    end
    local PosMon = model:GetAttribute("Locked").Position
    local targetName = model.Name
    local BoneMobs = {["Reborn Skeleton"]=true,["Living Zombie"]=true,["Demonic Soul"]=true,["Possessed Mummy"]=true,["Posessed Mummy"]=true}
    local isBone = BoneMobs[targetName] == true
    
    -- Luu lai trang thai ban dau de so sanh
    local startFarm = _G.ActiveFarm

    while _G.SelectWeapon and model.Parent and model:FindFirstChild("Humanoid") and model.Humanoid.Health > 0 do
        -- [FIX] Check chet / respawn -> dung ngay
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or not plr.Character:FindFirstChild("Humanoid") then
            task.wait(0.3)
            break
        end
        if plr.Character.Humanoid.Health <= 0 then
            task.wait(0.5)
            break
        end

        -- [FIX] Check xung dot farm - neu doi farm thi thoat ngay
        if isBone then
            if not _G.AutoFarm_Bone then break end
            if _G.ActiveFarm and _G.ActiveFarm ~= "Bone" then break end
        else
            -- Neu la farm level/near ma bone dang bat thi thoat bone
            if _G.ActiveFarm == "Bone" and not isBone then break end
            if _G.ActiveFarm and _G.ActiveFarm ~= "Bone" then
                -- Dang farm level ma bi tat
                if _G.ActiveFarm == "Level" and not _G.Level then break end
                if _G.ActiveFarm == "Near" and not _G.AutoFarmNear then break end
                if _G.ActiveFarm == "Island" and not _G.AutoFarmIsland then break end
            end
            -- Neu Succes truyen vao la boolean copy thi check live value
            if type(Succes) == "boolean" and not Succes then break end
            if Succes == true and isBone then
                -- Truong hop cu goi true cung phai check
                if not _G.AutoFarm_Bone then break end
            end
        end

        local current = nil
        local minDist = math.huge
        
        for _, e in ipairs(workspace.Enemies:GetChildren()) do
            if e.Name == targetName and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 and e:FindFirstChild("HumanoidRootPart") then
                local d = (e.HumanoidRootPart.Position - PosMon).Magnitude
                if d <= 450 and d < minDist then
                    minDist = d
                    current = e
                end
            end
        end
        
        if not current then break end
        
        pcall(function() BringEnemy(current) end)
        EquipWeapon(_G.SelectWeapon)
        
        local offset = GetFarmOffset()
        local isDoughKing = (targetName == "Dough King" or targetName == "Cake Prince")
        local isFastMob = isBone or isDoughKing
        
        pcall(function()
            if isFastMob then
                -- Farm Bone & Katakuri - dung tween binh thuong
                _tp(GetSpinCFrame(current.HumanoidRootPart, offset))
            else
                _tp(GetSpinCFrame(current.HumanoidRootPart, offset))
            end
        end)
        
        task.wait(0.01)
    end
end
Attack.Kill2 = Attack.Kill
Attack.KillSea = Attack.Kill
-- Ensure spin works for all aliases
Attack.Sword = function(model,Succes)
  if model and Succes then
    if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
    PosMon = model:GetAttribute("Locked").Position
    BringEnemy(model)
    weaponSc("Sword")
    pcall(function()
        local offset = _G.SpinHeightMelee or 30
        _tp(GetSpinCFrame(model.HumanoidRootPart, offset))
    end)
  end
end
Attack.Mas = function(model,Succes)
  if model and Succes then
    if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
    PosMon = model:GetAttribute("Locked").Position
    BringEnemy(model)
    if model.Humanoid.Health <= HealthM then
      pcall(function()
        local offset = _G.SpinHeightFruit or 20
        _tp(GetSpinCFrame(model.HumanoidRootPart, offset))
      end)
      Useskills("Blox Fruit","Z")
      Useskills("Blox Fruit","X")
      Useskills("Blox Fruit","C")
    else
      weaponSc("Melee")
      pcall(function()
        _tp(GetSpinCFrame(model.HumanoidRootPart, _G.SpinHeightMelee or 30))
      end)
    end
  end
end
Attack.Masgun = function(model,Succes)
  if model and Succes then
    if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
    PosMon = model:GetAttribute("Locked").Position
    BringEnemy(model)
    if model.Humanoid.Health <= HealthM then
      pcall(function()
        _tp(GetSpinCFrame(model.HumanoidRootPart, 35))
      end)
      Useskills("Gun","Z")
      Useskills("Gun","X")
    else
      weaponSc("Melee")
      pcall(function()
        _tp(GetSpinCFrame(model.HumanoidRootPart, _G.SpinHeightMelee or 30))
      end)
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
BringEnemy = function(Mon)
    if not _B then return end
    if not Mon then 
        -- Tự động tìm mob nếu không có Mon
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local closestDist = math.huge
        for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            local root = enemy:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    Mon = enemy
                end
            end
        end
        if not Mon then return end
    end
    
    local AreaMob = false
    
    local function Mobs(enemy)
        local hum = enemy:FindFirstChildOfClass("Humanoid")
        local root = enemy:FindFirstChild("HumanoidRootPart")
        return hum and root and hum.Health > 0, root, hum
    end

    local function Network(part)
        if isnetworkowner then
            return isnetworkowner(part)
        end
        return part.ReceiveAge == 0 and not part.Anchored and part.Velocity.Magnitude > 0
    end
    
    pcall(function()
        -- Tăng simulation radius
        if sethiddenproperty then 
            sethiddenproperty(plr, "SimulationRadius", math.huge)
        end
        
        local targetPos = Mon.HumanoidRootPart.Position
        
        for _, v in ipairs(workspace.Enemies:GetChildren()) do
            if v ~= Mon then
                local alive, root, hum = Mobs(v)
                if alive and v.Name == Mon.Name then
                    local distance = (root.Position - targetPos).Magnitude
                    if distance <= 3000 then
                        -- Tạo BodyVelocity để giữ mob
                        local bv = root:FindFirstChild("BodyVelocity")
                        if not bv then
                            bv = Instance.new("BodyVelocity")
                            bv.Name = "BodyVelocity"
                            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                            bv.Velocity = Vector3.zero
                            bv.Parent = root
                        end
                        
                        if distance <= 10 then
                            AreaMob = true
                        end
                        
                        -- Kéo mob lại nếu là network owner và chưa ở gần
                        if not AreaMob and Network(root) then
                            root.CFrame = CFrame.new(targetPos)
                        end
                        
                        -- Tắt va chạm và ngăn di chuyển
                        root.CanCollide = false
                        hum.WalkSpeed = 0
                        hum.JumpPower = 0
                    end
                end
            end
        end
        
        -- Xử lý mob chính
        if Mon and Mon:FindFirstChild("HumanoidRootPart") then
            Mon.HumanoidRootPart.CanCollide = false
            Mon.Humanoid.WalkSpeed = 0
            Mon.Humanoid.JumpPower = 0
        end
    end)
end
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
          if (_G.FarmMastery_G and not SoulGuitar) or (_G.FarmMastery_Dev) or (_G.FarmBlazeEM) or (_G.Prehis_Skills) or (_G.SeaBeast1 or _G.FishBoat or _G.PGB or _G.Leviathan1 or _G.Complete_Trials) or (_G.AimMethod and ABmethod == "Aim Player") or (_G.AimMethod and ABmethod == "Nearest Aim") then
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

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

sea1 = (game.PlaceId == 2753915549 or game.PlaceId == 85211729168715)
sea2 = (game.PlaceId == 4442272183 or game.PlaceId == 79091703265657)
sea3 = (game.PlaceId == 7449423635 or game.PlaceId == 100117331123089)

local Settings = {
    ["Tween Speed"] = 160,
    ["Up Y"] = false,
    ["Up Y When Low Health"] = false,
    ["Same Y"] = false
}

local newdao = CFrame.new(10641.0918, -1953.92981, 9825.07031, -0.652825892, -9.2805891e-08, -0.757508039, -2.73638356e-08, 1, -9.89323823e-08, 0.757508039, -4.38572947e-08, -0.652825892)
local cframenpc = CFrame.new(-16271.126, 25.5847301, 1371.98755, 0.999396622, -5.78875188e-08, -0.0347310975, 5.52972779e-08, 1, -8.7544322e-08, 0.034731105, 8.28877091e-08, 0.999396741)

function Convert_CFrame(x)
    if not x then return end
    if typeof(x) == "Vector3" then
        return CFrame.new(x)
    elseif typeof(x) == "CFrame" then
        return x
    elseif typeof(x) == "Model" then
        return x:GetPivot()
    elseif x.CFrame then
        return x.CFrame
    end
    return nil
end

function GetDistance(POS_1, POS_2, NO_Y)
    if POS_1 == nil then return 9e9 end
    
    local Character = LocalPlayer.Character
    if not Character then return 9e9 end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then
        return 9e9
    end
    
    if POS_2 == nil then
        POS_2 = Character:FindFirstChild("HumanoidRootPart")
        if not POS_2 then return 9e9 end
    end
    
    local pos1 = Convert_CFrame(POS_1)
    local pos2 = Convert_CFrame(POS_2)
    
    if NO_Y then
        return (Vector3.new(pos1.X, 0, pos1.Z) - Vector3.new(pos2.X, 0, pos2.Z)).Magnitude
    else
        return (pos1.Position - pos2.Position).Magnitude
    end
end

function InArea(POS)
    local WorldOrigin = workspace:FindFirstChild("_WorldOrigin")
    if not WorldOrigin then return {Name = ""} end
    
    local pos = Convert_CFrame(POS)
    for i,v in next, WorldOrigin.Locations:GetChildren() do
        if v:FindFirstChild("Mesh") and (pos.Position - v.Position).Magnitude <= v.Mesh.Scale.X then
            return v
        end
    end
    return {Name = ""}
end

function GetSpawnPoint(x)
    local Spawns = workspace:FindFirstChild("_WorldOrigin") 
        and workspace._WorldOrigin:FindFirstChild("PlayerSpawns") 
        and workspace._WorldOrigin.PlayerSpawns:FindFirstChild("Pirates")
    if not Spawns then return end
    
    for i,v in next, Spawns:GetChildren() do
        if v:FindFirstChild("Part") and (v.Part.Position - x.Position).Magnitude <= 2500 then
            return v
        end
    end
end


function totopofgreattree()
    if getdis(CFrame.new(28310.0234, 14895.1123, 109.456741)) > 1500 then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(28310.0234, 14895.1123, 109.456741))
        wait(0.3)
    end
    
    local targetCF = CFrame.new(28607.5352, 14896.5449, 106.011726)
    _tp(targetCF)
    
    repeat
        wait()
    until getdis(targetCF) <= 5
    
    wait(0.5)
    for i = 1, 4 do
        ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack")
    end
end

function requestentrance(pos)
    local tb = {}
    local targetPos = pos
    
    if typeof(pos) == "CFrame" then
        targetPos = pos.Position
    end
    
    if sea1 then
        tb = {
            ["Sky3"] = Vector3.new(-7894, 5547, -380),
            ["Sky3Exit"] = Vector3.new(-4607, 874, -1667),
            ["UnderWater"] = Vector3.new(61163, 11, 1819),
            ["Underwater City"] = Vector3.new(61165.19140625, 0.18704631924629211, 1897.379150390625),
            ["Pirate Village"] = Vector3.new(-1242.4625244140625, 4.787059783935547, 3901.282958984375),
            ["UnderwaterExit"] = Vector3.new(4050, -1, -1814)
        }
    elseif sea2 then
        tb = {
            ["Swan Mansion"] = Vector3.new(-390, 332, 673),
            ["Swan Room"] = Vector3.new(2285, 15, 905),
            ["Cursed Ship"] = Vector3.new(923, 126, 32852),
            ["Zombie Island"] = Vector3.new(-6509, 83, -133)
        }
    else
        tb = {
            ["Hydra Island"] = Vector3.new(5657.88623046875, 1013.0790405273438, -335.4996337890625),
            ["Mansion"] = Vector3.new(-12462, 375, -7552),
            ["Castle"] = Vector3.new(-5036, 315, -3179),
            ["Temple of Time"] = Vector3.new(28286, 14897, 103),
            ["Greate Tree"] = Vector3.new(3024.1709, 2280.69434, -7325.12793)
        }
        if not checkinventory("Valkyrie Helm") then
            return
        end
    end
    
    local x, y = nil, math.huge
    for i, v in pairs(tb) do
        local distance = (typeof(v) == "Vector3" and (v - targetPos).Magnitude) or (v.Position - targetPos).Magnitude
        if distance < y then
            y = distance
            x = v
        end
    end
    
    if x and y and y < getdis(pos) then
        pcall(function ()
            if _G.TweenCache then
                _G.TweenCache:Cancel()
            end
        end)
        
        if typeof(x) == "Vector3" 
            and x.X == 3024.1709 and x.Y == 2280.69434 and x.Z == -7325.12793
            and ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check") >= 2 then
            totopofgreattree()
            wait(1)
        elseif y < getdis(pos) then
            local requestPos = typeof(x) == "Vector3" and x or x.Position
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", requestPos)
            wait(1)
        end
    end
end

-- Tween system tu red magic beta - clean va nhanh
_tp = function(target)
  local character = plr.Character
  if not character or not character:FindFirstChild("HumanoidRootPart") then return end
  local rootPart = character.HumanoidRootPart
  local distance = (target.Position - rootPart.Position).Magnitude
  local tweenSpeed = Settings["Tween Speed"] or 160
  local tweenInfo = TweenInfo.new(distance / tweenSpeed, Enum.EasingStyle.Linear)
  local tween = game:GetService("TweenService"):Create(block, tweenInfo, {CFrame = target})
  if plr.Character.Humanoid.Sit == true then
    block.CFrame = CFrame.new(block.Position.X, target.Y, block.Position.Z)
  end
  tween:Play()
  task.spawn(function() while tween.PlaybackState == Enum.PlaybackState.Playing do if not shouldTween then tween:Cancel() break end task.wait(0.1) end end)
end
TeleportToTarget = function(targetCFrame) if (targetCFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude > 1000 then _tp(targetCFrame) else _tp(targetCFrame) end end
notween = function(p) plr.Character.HumanoidRootPart.CFrame = p end
function BTP(p)
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character.HumanoidRootPart
    local humanoid = player.Character.Humanoid
    local playerGui = player.PlayerGui.Main
    local targetPosition = p.Position
    local lastPosition = humanoidRootPart.Position
    repeat
        humanoid.Health = 0
        humanoidRootPart.CFrame = p
        playerGui.Quest.Visible = false
        if (humanoidRootPart.Position - lastPosition).Magnitude > 1 then
            lastPosition = humanoidRootPart.Position
            humanoidRootPart.CFrame = p
        end
        task.wait(0.5)
    until (p.Position - humanoidRootPart.Position).Magnitude <= 2000
end
old_tp = function(p)
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = p
    end
end
spawn(function()
  while task.wait() do
    pcall(function()
      if _G.AutoBuyMelee or _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.DT_Uzoth or _G.AutoBerry or _G.Prefully or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoFarmChest or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago  or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Bartilo_Quest or _G.Level or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or getgenv().AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or _G.TPNpc or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.AutoPole or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Mink or _G.Auto_Human or _G.Auto_Skypiea or _G.Auto_Fish or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad or _G.AutoUnHaki or _G.Auto_DonAcces or _G.AutoRipIngay or _G.DragoV3 or _G.DragoV1 or _G.SailBoats or NextIs or _G.FarmGodChalice or _G.IceBossRen or senth or senth2 or _G.Lvthan or _G.beasthunter or _G.DangerLV or _G.Relic123 or _G.tweenKitsune or _G.Collect_Ember or _G.AutofindKitIs or _G.snaguine or _G.TwFruits or _G.tweenKitShrine or _G.Tp_LgS or _G.Tp_MasterA or _G.tweenShrine or _G.FarmMastery_G or _G.FarmMastery_S or _G.FarmBoss or _G.AutoFarmAllBoss or _G.AutoFishSlap or _G.FarmTyrant or _G.FarmPhaBinh or _G.AutoSpawnCP or _G.AutoBerryH or _G.AutoChestBP or _G.FarmEliteHop or _G.AutoHop_Dough or _G.AutoDoughKing or _G.AutoAttackDoughKing or _G.AutoChipFruit or _G.AutoChipBeli or _G.StartEvent or _G.AutoMysticIsland or _G.AutoPlayerHunter or _G.SafeMode or _G.AutoKillMob or _G.AutoStartPrehistoric or _G.AutoUnHaki or _G.AutoAttackRipIndra or _G.AutoFarmIsland or _G.AutoFarmDungeon or _G.AutoFarmCandy or _G.AutoTP_Gift or _G.AutoTPGift or _G.AutoTPAndCollect or _G.MasterAutoLevel or _G.MasterAutoCandy or _G.TPFloor1 or _G.TPFloor2 or _G.TPFloor3 or _G.TPFloor4 then
        shouldTween = true
        if not plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
          local Noclip = Instance.new("BodyVelocity")
          Noclip.Name = "BodyClip"
          Noclip.Parent = plr.Character.HumanoidRootPart
          Noclip.MaxForce = Vector3.new(100000,100000,100000)
          Noclip.Velocity = Vector3.new(0,0,0)
        end        
      if not plr.Character:FindFirstChild("highlight") then
    local Test = Instance.new("Highlight")
    Test.Name = "highlight"
    Test.Enabled = true
    Test.FillColor = Color3.fromRGB(128,128,128)
    Test.OutlineColor = Color3.fromRGB(128,128,128)
    Test.FillTransparency = 0.5
    Test.OutlineTransparency = 0.2
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
QuestB = function()
				if World1 then
					if _G.FindBoss == "The Gorilla King" then
						bMon = "The Gorilla King"
						Qname = "JungleQuest"
						Qdata = 3;
						PosQBoss = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
						PosB = CFrame.new(-1088.75977, 8.13463783, -488.559906, -0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, -0.707134247)
					elseif _G.FindBoss == "Bobby" then
						bMon = "Bobby"
						Qname = "BuggyQuest1"
						Qdata = 3;
						PosQBoss = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
						PosB = CFrame.new(-1087.3760986328, 46.949409484863, 4040.1462402344)
					elseif _G.FindBoss == "The Saw" then
						bMon = "The Saw"
						PosB = CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906)
					elseif _G.FindBoss == "Yeti" then
						bMon = "Yeti"
						Qname = "SnowQuest"
						Qdata = 3;
						PosQBoss = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156)
						PosB = CFrame.new(1218.7956542969, 138.01184082031, -1488.0262451172)
					elseif _G.FindBoss == "Mob Leader" then
						bMon = "Mob Leader"
						PosB = CFrame.new(-2844.7307128906, 7.4180502891541, 5356.6723632813)
					elseif _G.FindBoss == "Vice Admiral" then
						bMon = "Vice Admiral"
						Qname = "MarineQuest2"
						Qdata = 2;
						PosQBoss = CFrame.new(-5036.2465820313, 28.677835464478, 4324.56640625)
						PosB = CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375)
					elseif _G.FindBoss == "Saber Expert" then
						bMon = "Saber Expert"
						PosB = CFrame.new(-1458.89502, 29.8870335, -50.633564)
					elseif _G.FindBoss == "Warden" then
						bMon = "Warden"
						Qname = "ImpelQuest"
						Qdata = 1;
						PosB = CFrame.new(5278.04932, 2.15167475, 944.101929, 0.220546961, -4.49946401e-06, 0.975376427, -1.95412576e-05, 1, 9.03162072e-06, -0.975376427, -2.10519756e-05, 0.220546961)
						PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
					elseif _G.FindBoss == "Chief Warden" then
						bMon = "Chief Warden"
						Qname = "ImpelQuest"
						Qdata = 2;
						PosB = CFrame.new(5206.92578, 0.997753382, 814.976746, 0.342041343, -0.00062915677, 0.939684749, 0.00191645394, 0.999998152, -2.80422337e-05, -0.939682961, 0.00181045406, 0.342041939)
						PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
					elseif _G.FindBoss == "Swan" then
						bMon = "Swan"
						Qname = "ImpelQuest"
						Qdata = 3;
						PosB = CFrame.new(5325.09619, 7.03906584, 719.570679, -0.309060812, 0, 0.951042235, 0, 1, 0, -0.951042235, 0, -0.309060812)
						PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
					elseif _G.FindBoss == "Magma Admiral" then
						bMon = "Magma Admiral"
						Qname = "MagmaQuest"
						Qdata = 3;
						PosQBoss = CFrame.new(-5314.6220703125, 12.262420654297, 8517.279296875)
						PosB = CFrame.new(-5765.8969726563, 82.92064666748, 8718.3046875)
					elseif _G.FindBoss == "Fishman Lord" then
						bMon = "Fishman Lord"
						Qname = "FishmanQuest"
						Qdata = 3;
						PosQBoss = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
						PosB = CFrame.new(61260.15234375, 30.950881958008, 1193.4329833984)
					elseif _G.FindBoss == "Wysper" then
						bMon = "Wysper"
						Qname = "SkyExp1Quest"
						Qdata = 3;
						PosQBoss = CFrame.new(-7861.947265625, 5545.517578125, -379.85974121094)
						PosB = CFrame.new(-7866.1333007813, 5576.4311523438, -546.74816894531)
					elseif _G.FindBoss == "Thunder God" then
						bMon = "Thunder God"
						Qname = "SkyExp2Quest"
						Qdata = 3;
						PosQBoss = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125)
						PosB = CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188)
					elseif _G.FindBoss == "Cyborg" then
						bMon = "Cyborg"
						Qname = "FountainQuest"
						Qdata = 3;
						PosQBoss = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
						PosB = CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813)
					elseif _G.FindBoss == "Ice Admiral" then
						bMon = "Ice Admiral"
						Qdata = nil;
						PosQBoss = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219)
						PosB = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219)
					elseif _G.FindBoss == "Greybeard" then
						bMon = "Greybeard"
						Qdata = nil;
						PosQBoss = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188)
						PosB = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188)
					end
				end;
				if World2 then
					if _G.FindBoss == "Diamond" then
						bMon = "Diamond"
						Qname = "Area1Quest"
						Qdata = 3;
						PosQBoss = CFrame.new(-427.5666809082, 73.313781738281, 1835.4208984375)
						PosB = CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407)
					elseif _G.FindBoss == "Jeremy" then
						bMon = "Jeremy"
						Qname = "Area2Quest"
						Qdata = 3;
						PosQBoss = CFrame.new(636.79943847656, 73.413787841797, 918.00415039063)
						PosB = CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109)
					elseif _G.FindBoss == "Orbitus" then
						bMon = "Orbitus"
						Qname = "MarineQuest3"
						Qdata = 3;
						PosQBoss = CFrame.new(-2441.986328125, 73.359344482422, -3217.5324707031)
						PosB = CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625)
					elseif _G.FindBoss == "Don Swan" then
						bMon = "Don Swan"
						PosB = CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875)
					elseif _G.FindBoss == "Smoke Admiral" then
						bMon = "Smoke Admiral"
						Qname = "IceSideQuest"
						Qdata = 3;
						PosQBoss = CFrame.new(-5429.0473632813, 15.977565765381, -5297.9614257813)
						PosB = CFrame.new(-5275.1987304688, 20.757257461548, -5260.6669921875)
					elseif _G.FindBoss == "Awakened Ice Admiral" then
						bMon = "Awakened Ice Admiral"
						Qname = "FrostQuest"
						Qdata = 3;
						PosQBoss = CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813)
						PosB = CFrame.new(6403.5439453125, 340.29766845703, -6894.5595703125)
					elseif _G.FindBoss == "Tide Keeper" then
						bMon = "Tide Keeper"
						Qname = "ForgottenQuest"
						Qdata = 3;
						PosQBoss = CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625)
						PosB = CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188)
					elseif _G.FindBoss == "Darkbeard" then
						bMon = "Darkbeard"
						Qdata = nil;
						PosQBoss = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531)
						PosB = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531)
					elseif _G.FindBoss == "Cursed Captaim" then
						bMon = "Cursed Captain"
						Qdata = nil;
						PosQBoss = CFrame.new(916.928589, 181.092773, 33422)
						PosB = CFrame.new(916.928589, 181.092773, 33422)
					elseif _G.FindBoss == "Order" then
						bMon = "Order"
						Qdata = nil;
						PosQBoss = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875)
						PosB = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875)
					end
				end;
				if World3 then
					if _G.FindBoss == "Stone" then
						bMon = "Stone"
						Qname = "PiratePortQuest"
						Qdata = 3;
						PosQBoss = CFrame.new(-289.76705932617, 43.819011688232, 5579.9384765625)
						PosB = CFrame.new(-1027.6512451172, 92.404174804688, 6578.8530273438)
					elseif _G.FindBoss == "Hydra Leader" then
						bMon = "Hydra Leader"
						Qname = "VenomCrewQuest"
						Qdata = 3;
						PosQBoss = CFrame.new(5211.021484375, 1004.35778859375, 758.1847534179688)
						PosB = CFrame.new(5821.89794921875, 1019.0950927734375, -73.71923065185547)
					elseif _G.FindBoss == "Kilo Admiral" then
						bMon = "Kilo Admiral"
						Qname = "MarineTreeIsland"
						Qdata = 3;
						PosQBoss = CFrame.new(2179.3010253906, 28.731239318848, -6739.9741210938)
						PosB = CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125)
					elseif _G.FindBoss == "Captain Elephant" then
						bMon = "Captain Elephant"
						Qname = "DeepForestIsland"
						Qdata = 3;
						PosQBoss = CFrame.new(-13232.682617188, 332.40396118164, -7626.01171875)
						PosB = CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125)
					elseif _G.FindBoss == "Beautiful Pirate" then
						bMon = "Beautiful Pirate"
						Qname = "DeepForestIsland2"
						Qdata = 3;
						PosQBoss = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375)
						PosB = CFrame.new(5283.609375, 22.56223487854, -110.78285217285)
					elseif _G.FindBoss == "Cake Queen" then
						bMon = "Cake Queen"
						Qname = "IceCreamIslandQuest"
						Qdata = 3;
						PosQBoss = CFrame.new(-819.376709, 64.9259796, -10967.2832, -0.766061664, 0, 0.642767608, 0, 1, 0, -0.642767608, 0, -0.766061664)
						PosB = CFrame.new(-678.648804, 381.353943, -11114.2012, -0.908641815, 0.00149294338, 0.41757378, 0.00837114919, 0.999857843, 0.0146408929, -0.417492568, 0.0167988986, -0.90852499)
					elseif _G.FindBoss == "Longma" then
						bMon = "Longma"
						Qdata = nil;
						PosQBoss = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125)
						PosB = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125)
					elseif _G.FindBoss == "Soul Reaper" then
						bMon = "Soul Reaper"
						Qdata = nil;
						PosQBoss = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813)
						PosB = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813)
					end
				end
			end
			QuestBeta = function()
				local Neta = QuestB()
				return {
					[0] = _G.FindBoss,
					[1] = bMon,
					[2] = Qdata,
					[3] = Qname,
					[4] = PosB,
					[5] = PosQBoss,
				}  
			end

local Quests = require(game:GetService("ReplicatedStorage"):WaitForChild("Quests"))
local GuideModule = require(game:GetService("ReplicatedStorage"):WaitForChild("GuideModule"))

local blacklistquest = {
    "MarineQuest",
    "BartiloQuest",
    "CitizenQuest",
    "Trainees"
}

CheckSea = function(b)
    if (game.PlaceId == 2753915549 or game.PlaceId == 85211729168715) and b == 1 then
        return true
    elseif (game.PlaceId == 4442272183 or game.PlaceId == 79091703265657) and b == 2 then
        return true
    elseif (game.PlaceId == 7449423635 or game.PlaceId == 100117331123089) and b == 3 then
        return true
    end
    return false
end

GetQuestPointFromNPC = function(npcName)
    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
            return npc.HumanoidRootPart.CFrame
        end
    end
    for _, npc in pairs(replicated.NPCs:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
            return npc.HumanoidRootPart.CFrame
        end
    end
    return nil
end

GetQuests = function()
    local lvl = plr.Data.Level.Value
    local LevelReq = 0
    local mmb = {}
    
    if lvl >= 700 and CheckSea(1) then
        mmb["Mob"] = "Galley Captain"
        mmb["NameQuest"] = "FountainQuest"
        mmb["ID"] = 2
        mmb["LevelReq"] = 700
    elseif lvl >= 1500 and CheckSea(2) then
        mmb["Mob"] = "Water Fighter"
        mmb["NameQuest"] = "ForgottenQuest"
        mmb["ID"] = 2
        mmb["LevelReq"] = 1450
    else
        for r, v in pairs(Quests) do
            for id, v1 in pairs(v) do
                local LvReq = v1.LevelReq
                for nguoi, tinh in pairs(v1.Task) do
                    if lvl >= LvReq and LevelReq <= LvReq and v1.Task[nguoi] > 1 and not table.find(blacklistquest, r) then
                        LevelReq = LvReq
                        mmb["Mob"] = nguoi
                        mmb["NameQuest"] = r
                        mmb["ID"] = id
                        mmb["LevelReq"] = LvReq
                    end
                end
            end
        end
    end
    
    return mmb
end

GetQuestPoint = function()
    if GuideModule and GuideModule.Data and GuideModule.Data.LastClosestNPC then
        return GetQuestPointFromNPC(GuideModule.Data.LastClosestNPC)
    end
    return nil
end

-- [ADDED - fix farm lv 'không tween lại mob sau khi nhận quest']
-- Bảng CFrame NPC-quest + vị trí mob THẬT, tra theo tên mob — thay thế
-- hẳn GetQuestPoint() (vốn dựa vào GuideModule.Data.LastClosestNPC,
-- hoàn toàn KHÔNG liên quan gì tới quest đang làm — đây chính là gốc
-- của bug 'nhận quest xong không tween lại mob': vị trí trả về sai/nil
-- vì nó chỉ là NPC gần nhất TỪNG đi ngang qua, không phải NPC của quest
-- hiện tại). Dữ liệu lấy từ bảng đã verify (longhihi Premium), tra theo
-- đúng tên mob nên luôn khớp với quest đang farm.
-- [FIXED - "too many local variables (limit 200)"] Bọc do...end: hai biến
-- local (MobQuestPositions, OldGetQuestPoint) chỉ cần sống đủ lâu để 2 hàm
-- global bên dưới "chụp" chúng làm upvalue lúc tạo closure — sau đó Lua tự
-- giữ giá trị sống qua closure, KHÔNG cần slot local ở function chính nữa,
-- nên bọc do...end giải phóng slot ngay sau khối này mà 2 hàm vẫn hoạt
-- động bình thường (giống fix "quá 200 local" đã áp dụng cho toàn bộ
-- widget trước đó).
do
local MobQuestPositions = {
    ["Bandit"] = {PosQ = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, 0, -0.341998369, 0, 1, 0, 0.341998369, 0, 0.939700544), PosM = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)},
    ["Monkey"] = {PosQ = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, 0, -1, 0, 0), PosM = CFrame.new(-1448.51806640625, 67.85301208496094, 11.46579647064209)},
    ["Gorilla"] = {PosQ = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, 0, -1, 0, 0), PosM = CFrame.new(-1129.8836669921875, 40.46354675296875, -525.4237060546875)},
    ["Pirate"] = {PosQ = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, 0.965929627), PosM = CFrame.new(-1103.513427734375, 13.752052307128906, 3896.091064453125)},
    ["Brute"] = {PosQ = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, 0.965929627), PosM = CFrame.new(-1140.083740234375, 14.809885025024414, 4322.92138671875)},
    ["Desert Bandit"] = {PosQ = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, 0, -0.573571265, 0, 1, 0, 0.573571265, 0, 0.819155693), PosM = CFrame.new(924.7998046875, 6.44867467880249, 4481.5859375)},
    ["Desert Officer"] = {PosQ = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, 0, -0.573571265, 0, 1, 0, 0.573571265, 0, 0.819155693), PosM = CFrame.new(1608.2822265625, 8.614224433898926, 4371.00732421875)},
    ["Snow Bandit"] = {PosQ = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685), PosM = CFrame.new(1354.347900390625, 87.27277374267578, -1393.946533203125)},
    ["Snowman"] = {PosQ = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685), PosM = CFrame.new(1201.6412353515625, 144.57958984375, -1550.0670166015625)},
    ["Chief Petty Officer"] = {PosQ = CFrame.new(-5039.58643, 27.3500385, 4324.68018, 0, 0, -1, 0, 1, 0, 1, 0, 0), PosM = CFrame.new(-4881.23095703125, 22.65204429626465, 4273.75244140625)},
    ["Sky Bandit"] = {PosQ = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268), PosM = CFrame.new(-4953.20703125, 295.74420166015625, -2899.22900390625)},
    ["Dark Master"] = {PosQ = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268), PosM = CFrame.new(-5259.8447265625, 391.3976745605469, -2229.035400390625)},
    ["Prisoner"] = {PosQ = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, 0, -0.995993316, 0, 1, 0, 0.995993316, 0, -0.0894274712), PosM = CFrame.new(5098.9736328125, -0.3204058110713959, 474.2373352050781)},
    ["Dangerous Prisoner"] = {PosQ = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, 0, -0.995993316, 0, 1, 0, 0.995993316, 0, -0.0894274712), PosM = CFrame.new(5654.5634765625, 15.633401870727539, 866.2991943359375)},
    ["Toga Warrior"] = {PosQ = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298), PosM = CFrame.new(-1820.21484375, 51.68385696411133, -2740.6650390625)},
    ["Gladiator"] = {PosQ = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298), PosM = CFrame.new(-1292.838134765625, 56.380882263183594, -3339.031494140625)},
    ["Military Soldier"] = {PosQ = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469), PosM = CFrame.new(-5411.16455078125, 11.081554412841797, 8454.29296875)},
    ["Military Spy"] = {PosQ = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469), PosM = CFrame.new(-5802.8681640625, 86.26241302490234, 8828.859375)},
    ["Fishman Warrior"] = {PosQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734), PosM = CFrame.new(60878.30078125, 18.482830047607422, 1543.7574462890625)},
    ["Fishman Commando"] = {PosQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734), PosM = CFrame.new(61922.6328125, 18.482830047607422, 1493.934326171875)},
    ["God's Guard"] = {PosQ = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, 0, -0.0871884301, 0, 1, 0, 0.0871884301, 0, 0.996191859), PosM = CFrame.new(-4710.04296875, 845.2769775390625, -1927.3079833984375)},
    ["Shanda"] = {PosQ = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, -0.422592998), PosM = CFrame.new(-7678.48974609375, 5566.40380859375, -497.2156066894531)},
    ["Royal Squad"] = {PosQ = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0), PosM = CFrame.new(-7624.25244140625, 5658.13330078125, -1467.354248046875)},
    ["Royal Soldier"] = {PosQ = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0), PosM = CFrame.new(-7836.75341796875, 5645.6640625, -1790.6236572265625)},
    ["Galley Pirate"] = {PosQ = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381), PosM = CFrame.new(5551.02197265625, 78.90135192871094, 3930.412841796875)},
    ["Galley Captain"] = {PosQ = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381), PosM = CFrame.new(5441.95166015625, 42.50205993652344, 4950.09375)},
    ["Raider"] = {PosQ = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985), PosM = CFrame.new(-728.3267211914062, 52.779319763183594, 2345.7705078125)},
    ["Mercenary"] = {PosQ = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985), PosM = CFrame.new(-1004.3244018554688, 80.15886688232422, 1424.619384765625)},
    ["Swan Pirate"] = {PosQ = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0, -0.99026376, 0, 0.139203906), PosM = CFrame.new(1068.664306640625, 137.61428833007812, 1322.1060791015625)},
    ["Factory Staff"] = {PosQ = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 0, -0.999488771, 0, 1, 0, 0.999488771, 0, -0.0319722369), PosM = CFrame.new(73.07867431640625, 81.86344146728516, -27.470672607421875)},
    ["Marine Lieutenant"] = {PosQ = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268), PosM = CFrame.new(-2821.372314453125, 75.89727783203125, -3070.089111328125)},
    ["Marine Captain"] = {PosQ = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268), PosM = CFrame.new(-1861.2310791015625, 80.17658233642578, -3254.697509765625)},
    ["Zombie"] = {PosQ = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146), PosM = CFrame.new(-5657.77685546875, 78.96973419189453, -928.68701171875)},
    ["Vampire"] = {PosQ = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146), PosM = CFrame.new(-6037.66796875, 32.18463897705078, -1340.6597900390625)},
    ["Snow Trooper"] = {PosQ = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106), PosM = CFrame.new(549.1473388671875, 427.3870544433594, -5563.69873046875)},
    ["Winter Warrior"] = {PosQ = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106), PosM = CFrame.new(1142.7451171875, 475.6398010253906, -5199.41650390625)},
    ["Lab Subordinate"] = {PosQ = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, 0, -0.891015649, 0, 1, 0, 0.891015649, 0, 0.453972578), PosM = CFrame.new(-5707.4716796875, 15.951709747314453, -4513.39208984375)},
    ["Horned Warrior"] = {PosQ = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, 0, -0.891015649, 0, 1, 0, 0.891015649, 0, 0.453972578), PosM = CFrame.new(-6341.36669921875, 15.951770782470703, -5723.162109375)},
    ["Magma Ninja"] = {PosQ = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213), PosM = CFrame.new(-5449.6728515625, 76.65874481201172, -5808.20068359375)},
    ["Lava Pirate"] = {PosQ = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213), PosM = CFrame.new(-5213.33154296875, 49.73788070678711, -4701.451171875)},
    ["Ship Deckhand"] = {PosQ = CFrame.new(1037.80127, 125.092171, 32911.6016), PosM = CFrame.new(1212.0111083984375, 150.79205322265625, 33059.24609375)},
    ["Ship Engineer"] = {PosQ = CFrame.new(1037.80127, 125.092171, 32911.6016), PosM = CFrame.new(919.4786376953125, 43.54401397705078, 32779.96875)},
    ["Ship Steward"] = {PosQ = CFrame.new(968.80957, 125.092171, 33244.125), PosM = CFrame.new(919.4385375976562, 129.55599975585938, 33436.03515625)},
    ["Ship Officer"] = {PosQ = CFrame.new(968.80957, 125.092171, 33244.125), PosM = CFrame.new(1036.0179443359375, 181.4390411376953, 33315.7265625)},
    ["Arctic Warrior"] = {PosQ = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909), PosM = CFrame.new(5966.24609375, 62.97002029418945, -6179.3828125)},
    ["Snow Lurker"] = {PosQ = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909), PosM = CFrame.new(5407.07373046875, 69.19437408447266, -6880.88037109375)},
    ["Sea Soldier"] = {PosQ = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, 0, -0.13915664, 0, 1, 0, 0.13915664, 0, 0.990270376), PosM = CFrame.new(-3028.2236328125, 64.67451477050781, -9775.4267578125)},
    ["Water Fighter"] = {PosQ = CFrame.new(-3054, 240, -10146), PosM = CFrame.new(-3291, 252, -10501)},
    ["Pirate Millionaire"] = {PosQ = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627), PosM = CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375)},
    ["Pistol Billionaire"] = {PosQ = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627), PosM = CFrame.new(-187.3301544189453, 86.23987579345703, 6013.513671875)},
    ["Dragon Crew Warrior"] = {PosQ = CFrame.new(6738.96142578125, 127.81645965576172, -713.511474609375), PosM = CFrame.new(6920.71435546875, 56.15597152709961, -942.5044555664062)},
    ["Dragon Crew Archer"] = {PosQ = CFrame.new(6738.96142578125, 127.81645965576172, -713.511474609375), PosM = CFrame.new(6817.91259765625, 484.804443359375, 513.4141235351562)},
    ["Hydra Enforcer"] = {PosQ = CFrame.new(5213.8740234375, 1004.5042724609375, 758.6944580078125), PosM = CFrame.new(4584.69287109375, 1002.6435546875, 705.7958984375)},
    ["Venomous Assailant"] = {PosQ = CFrame.new(5213.8740234375, 1004.5042724609375, 758.6944580078125), PosM = CFrame.new(4638.78564453125, 1078.94091796875, 881.8002319335938)},
    ["Marine Commodore"] = {PosQ = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747), PosM = CFrame.new(2286.0078125, 73.13391876220703, -7159.80908203125)},
    ["Marine Rear Admiral"] = {PosQ = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813), PosM = CFrame.new(3656.773681640625, 160.52406311035156, -7001.5986328125)},
    ["Fishman Raider"] = {PosQ = CFrame.new(3142.67822, 108.42981, 7482.37988, 0.34205412, 0, 0.939680243, 0, 1, 0, -0.939680243, 0, 0.34205412), PosM = CFrame.new(-10407.5263671875, 331.76263427734375, -8368.5166015625)},
    ["Fishman Captain"] = {PosQ = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213), PosM = CFrame.new(-10994.701171875, 352.38140869140625, -9002.1103515625)},
    ["Forest Pirate"] = {PosQ = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247), PosM = CFrame.new(-13274.478515625, 332.3781433105469, -7769.58056640625)},
    ["Jungle Pirate"] = {PosQ = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002), PosM = CFrame.new(-12256.16015625, 331.73828125, -10485.8369140625)},
    ["Musketeer Pirate"] = {PosQ = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002), PosM = CFrame.new(-13457.904296875, 391.545654296875, -9859.177734375)},
    ["Reborn Skeleton"] = {PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0), PosM = CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625)},
    ["Living Zombie"] = {PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0), PosM = CFrame.new(-10144.1318359375, 138.62667846679688, 5838.0888671875)},
    ["Demonic Soul"] = {PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0), PosM = CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625)},
    ["Posessed Mummy"] = {PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0), PosM = CFrame.new(-9582.0224609375, 6.251527309417725, 6205.478515625)},
    ["Peanut Scout"] = {PosQ = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0), PosM = CFrame.new(-2143.241943359375, 47.72198486328125, -10029.9951171875)},
    ["Peanut President"] = {PosQ = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0), PosM = CFrame.new(-1859.35400390625, 38.10316848754883, -10422.4296875)},
    ["Ice Cream Chef"] = {PosQ = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0), PosM = CFrame.new(-872.24658203125, 65.81957244873047, -10919.95703125)},
    ["Ice Cream Commander"] = {PosQ = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0), PosM = CFrame.new(-558.06103515625, 112.04895782470703, -11290.7744140625)},
    ["Cookie Crafter"] = {PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931), PosM = CFrame.new(-2374.13671875, 37.79826354980469, -12125.30859375)},
    ["Cake Guard"] = {PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931), PosM = CFrame.new(-1598.3070068359375, 43.773197174072266, -12244.5810546875)},
    ["Baking Staff"] = {PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446), PosM = CFrame.new(-1887.8099365234375, 77.6185073852539, -12998.3505859375)},
    ["Head Baker"] = {PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446), PosM = CFrame.new(-2216.188232421875, 82.884521484375, -12869.2939453125)},
    ["Cocoa Warrior"] = {PosQ = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375), PosM = CFrame.new(-21.55328369140625, 80.57499694824219, -12352.3876953125)},
    ["Chocolate Bar Battler"] = {PosQ = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375), PosM = CFrame.new(582.590576171875, 77.18809509277344, -12463.162109375)},
    ["Sweet Thief"] = {PosQ = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875), PosM = CFrame.new(165.1884765625, 76.05885314941406, -12600.8369140625)},
    ["Candy Rebel"] = {PosQ = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875), PosM = CFrame.new(134.86563110351562, 77.2476806640625, -12876.5478515625)},
    ["Candy Pirate"] = {PosQ = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375), PosM = CFrame.new(-1310.5003662109375, 26.016523361206055, -14562.404296875)},
    ["Snow Demon"] = {PosQ = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375), PosM = CFrame.new(-880.2006225585938, 71.24776458740234, -14538.609375)},
    ["Isle Outlaw"] = {PosQ = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812), PosM = CFrame.new(-16442.814453125, 116.13899993896484, -264.4637756347656)},
    ["Island Boy"] = {PosQ = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812), PosM = CFrame.new(-16901.26171875, 84.06756591796875, -192.88906860351562)},
    ["Isle Champion"] = {PosQ = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625), PosM = CFrame.new(-16641.6796875, 235.7825469970703, 1031.282958984375)},
    ["Skull Slayer"] = {PosQ = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, 0, 1, -0, 0.308980465, 0, 0.951068401), PosM = CFrame.new(-16887.7305, 113.074638, 1629.97778, -0.559032857, 1.2313353e-08, -0.829145491, 1.05618814e-09, 1, 1.41385428e-08, 0.829145491, 7.02817626e-09, -0.559032857)},
    ["Reef Bandit"] = {PosQ = CFrame.new(10778.875, -2087.72437, 9265.18359, 0.934615612, -9.33109447e-08, -0.355659455, 9.17655143e-08, 1, -2.12154276e-08, 0.355659455, -1.28090019e-08, 0.934615612), PosM = CFrame.new(11019.1318, -2146.06812, 9342.3916, -0.719955266, -1.74275385e-08, 0.69402045, 5.76556367e-08, 1, 8.49211546e-08, -0.69402045, 1.01153624e-07, -0.719955266)},
    ["Coral Pirate"] = {PosQ = CFrame.new(10778.875, -2087.72437, 9265.18359, 0.934615612, -9.33109447e-08, -0.355659455, 9.17655143e-08, 1, -2.12154276e-08, 0.355659455, -1.28090019e-08, 0.934615612), PosM = CFrame.new(10808.6006, -2030.36145, 9364.2334, -0.775185347, -0.0359364748, 0.6307109, 0.0615428537, 0.989336014, 0.132010356, -0.628728986, 0.141148239, -0.764707148)},
    ["Sea Chanter"] = {PosQ = CFrame.new(10880.6855, -2086.20044, 10032.624, -0.321384728, 9.87648434e-08, -0.946948707, 7.13271007e-08, 1, 8.00902953e-08, 0.946948707, -4.18033075e-08, -0.321384728), PosM = CFrame.new(10671.2715, -2057.59155, 10047.2588)},
    ["Ocean Prophet"] = {PosQ = CFrame.new(10880.6855, -2086.20044, 10032.624, -0.321384728, 9.87648434e-08, -0.946948707, 7.13271007e-08, 1, 8.00902953e-08, 0.946948707, -4.18033075e-08, -0.321384728), PosM = CFrame.new(11008.5195, -2007.72839, 10223.0791, -0.688615739, 2.33523378e-09, -0.725126445, 2.99292546e-09, 1, 3.78221315e-10, 0.725126445, -1.90980032e-09, -0.688615739)},
    ["High Disciple"] = {PosQ = CFrame.new(9640.08789, -1992.44507, 9613.65234, -0.957327187, 4.11991223e-08, 0.289006323, 1.5775445e-08, 1, -9.02985846e-08, -0.289006323, -8.18860855e-08, -0.957327187), PosM = CFrame.new(9750.41602, -1966.93884, 9753.36035, -0.749824047, 5.57797613e-08, -0.661637306, 2.03500754e-08, 1, 6.1243199e-08, 0.661637306, 3.24572511e-08, -0.749824047)},
    ["Grand Devotee"] = {PosQ = CFrame.new(9640.08789, -1992.44507, 9613.65234, -0.957327187, 4.11991223e-08, 0.289006323, 1.5775445e-08, 1, -9.02985846e-08, -0.289006323, -8.18860855e-08, -0.957327187), PosM = CFrame.new(9611.70508, -1993.47119, 9882.68848, -0.591375351, 4.14332426e-08, -0.806396425, 4.73774868e-08, 1, 1.66361875e-08, 0.806396425, -2.83668058e-08, -0.591375351)},
}

-- [FIXED] GetQuestPoint() gốc chỉ trả CFrame của NPC gần nhất bất kỳ,
-- không khớp với quest đang làm. Giờ nhận thẳng tên mob, tra bảng trên;
-- nếu không có trong bảng (quest hiếm/đặc biệt) mới rơi về cách cũ.
local OldGetQuestPoint = GetQuestPoint
GetQuestPoint = function(mobName)
    if mobName and MobQuestPositions[mobName] then
        return MobQuestPositions[mobName].PosQ
    end
    return OldGetQuestPoint()
end

-- [ADDED] Truy vị trí mob thật (PosM) theo tên — dùng làm fallback tween
-- khi mob chưa spawn trong workspace.Enemies (fix nốt phần 'không tween
-- lại mob' cho nhánh farm, không chỉ nhánh nhận quest).
GetMobFarmPosition = function(mobName)
    if mobName and MobQuestPositions[mobName] then
        return MobQuestPositions[mobName].PosM
    end
    return nil
end
end

MaterialMon=function()local a=game.Players.LocalPlayer;local b=a.Character and a.Character:FindFirstChild("HumanoidRootPart")if not b then return end;shouldRequestEntrance=function(c,d)local e=(b.Position-c).Magnitude;if e>=d then replicated.Remotes.CommF_:InvokeServer("requestEntrance",c)end end;if World1 then if SelectMaterial=="Angel Wings"then MMon={"Shanda","Royal Squad","Royal Soldier","Wysper","Thunder God"}MPos=CFrame.new(-4698,845,-1912)SP="Default"local c=Vector3.new(-4607.82275,872.54248,-1667.55688)shouldRequestEntrance(c,10000)elseif SelectMaterial=="Leather + Scrap Metal"then MMon={"Brute","Pirate"}MPos=CFrame.new(-1145,15,4350)SP="Default"elseif SelectMaterial=="Magma Ore"then MMon={"Military Soldier","Military Spy","Magma Admiral"}MPos=CFrame.new(-5815,84,8820)SP="Default"elseif SelectMaterial=="Fish Tail"then MMon={"Fishman Warrior","Fishman Commando","Fishman Lord"}MPos=CFrame.new(61123,19,1569)SP="Default"local c=Vector3.new(61163.8515625,5.342342376708984,1819.7841796875)shouldRequestEntrance(c,17000)end elseif World2 then if SelectMaterial=="Leather + Scrap Metal"then MMon={"Marine Captain"}MPos=CFrame.new(-2010.5059814453125,73.00115966796875,-3326.620849609375)SP="Default"elseif SelectMaterial=="Magma Ore"then MMon={"Magma Ninja","Lava Pirate"}MPos=CFrame.new(-5428,78,-5959)SP="Default"elseif SelectMaterial=="Ectoplasm"then MMon={"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer"}MPos=CFrame.new(911.35827636719,125.95812988281,33159.5390625)SP="Default"local c=Vector3.new(61163.8515625,5.342342376708984,1819.7841796875)shouldRequestEntrance(c,18000)elseif SelectMaterial=="Mystic Droplet"then MMon={"Water Fighter"}MPos=CFrame.new(-3385,239,-10542)SP="Default"elseif SelectMaterial=="Radioactive Material"then MMon={"Factory Staff"}MPos=CFrame.new(295,73,-56)SP="Default"elseif SelectMaterial=="Vampire Fang"then MMon={"Vampire"}MPos=CFrame.new(-6033,7,-1317)SP="Default"end elseif World3 then if SelectMaterial=="Scrap Metal"then MMon={"Jungle Pirate","Forest Pirate"}MPos=CFrame.new(-11975.78515625,331.7734069824219,-10620.0302734375)SP="Default"elseif SelectMaterial=="Fish Tail"then MMon={"Fishman Raider","Fishman Captain"}MPos=CFrame.new(-10993,332,-8940)SP="Default"elseif SelectMaterial=="Conjured Cocoa"then MMon={"Chocolate Bar Battler","Cocoa Warrior"}MPos=CFrame.new(620.6344604492188,78.93644714355469,-12581.369140625)SP="Default"elseif SelectMaterial=="Dragon Scale"then MMon={"Dragon Crew Archer","Dragon Crew Warrior"}MPos=CFrame.new(6594,383,139)SP="Default"elseif SelectMaterial=="Gunpowder"then MMon={"Pistol Billionaire"}MPos=CFrame.new(-84.8556900024414, 85.62061309814453, 6132.0087890625)SP="Default"elseif SelectMaterial=="Mini Tusk"then MMon={"Mythological Pirate"}MPos=CFrame.new(-13545,470,-6917)SP="Default"elseif SelectMaterial=="Demonic Wisp"then MMon={"Demonic Soul"}MPos=CFrame.new(-9495.6806640625,453.58624267578125,5977.3486328125)SP="Default"end end end
QuestNeta = function()
    local questData = GetQuests()
    return {
        [1] = questData.Mob,           
        [2] = questData.ID,             
        [3] = questData.NameQuest,      
        [4] = questData.LevelReq,       
        [5] = questData.Mob,             
        [6] = GetQuestPoint(questData.Mob)            
    }
end

-- [UI REPLACED] Nousigi UI from file 1, with a Fluent-compatible adapter.
-- The donor library runs in its own chunk so this large script stays below Luau's local limit.
local Fluent, Window, Tabs = loadstring([====[
return function(Library)
    local Compat = { Options = {} }

    local function registerOption(key, kind, defaultValue, handle, setter)
        local option = {
            Type = kind,
            Value = defaultValue,
            Handle = handle
        }
        function option:SetValue(value)
            self.Value = value
            setter(value)
        end
        if key then
            Compat.Options[key] = option
        end
        return option
    end

    local dummy = setmetatable({}, {
        __index = function(self, _k)
            return function() return self end
        end
    })

    local function makeTab(window, title)
        local page = window:AddTab(title)
        local section = nil
        local tab = {}

        local function newSection(name)
            local ok, result
            if page.AddSection then
                ok, result = pcall(page.AddSection, page, tostring(name), false)
            end
            if (not ok or type(result) ~= "table") and page.AddLeftGroupbox then
                ok, result = pcall(page.AddLeftGroupbox, page, tostring(name))
            end
            if ok and type(result) == "table" then
                return result
            end
            return dummy
        end

        local function getSection()
            if not section then
                section = newSection(title)
            end
            return section
        end

        function tab:AddSection(sectionTitle)
            section = newSection(tostring(sectionTitle or title))
            return section
        end

        local function copy(setting)
            local adapted = {}
            for k, v in pairs(setting or {}) do adapted[k] = v end
            return adapted
        end

        local function create(method, ...)
            local sec = getSection()
            if type(sec[method]) ~= "function" then return dummy end
            local ok, handle = pcall(sec[method], sec, ...)
            if ok and handle ~= nil then return handle end
            return dummy
        end

        function tab:AddToggle(key, setting)
            setting = setting or {}
            local original = setting.Callback
            local adapted = copy(setting)
            local option
            adapted.Callback = function(value)
                if option then option.Value = value end
                if original then pcall(original, value) end
            end
            local handle = create("AddToggle", key, adapted)
            option = registerOption(key, "Toggle", setting.Default == true, handle, function(value)
                pcall(function() handle.SetStage(value == true) end)
            end)
            return option
        end

        function tab:AddDropdown(key, setting)
            setting = setting or {}
            local original = setting.Callback
            local adapted = copy(setting)
            local option
            adapted.Callback = function(value, selected)
                if option then option.Value = value end
                if original then pcall(original, value, selected) end
            end
            local handle = create("AddDropdown", key, adapted)
            option = registerOption(key, "Dropdown", setting.Default, handle, function(value)
                pcall(function() handle:SetValue(value) end)
            end)
            function option:SetValues(values)
                pcall(function() handle:GetNewList(values) end)
            end
            return option
        end

        function tab:AddSlider(key, setting)
            setting = setting or {}
            local original = setting.Callback
            local adapted = copy(setting)
            if setting.Rounding and tonumber(setting.Rounding) and tonumber(setting.Rounding) > 0 then
                adapted.Precise = true
            end
            local option
            adapted.Callback = function(value)
                if option then option.Value = value end
                if original then pcall(original, value) end
            end
            local handle = create("AddSlider", adapted)
            option = registerOption(key, "Slider", setting.Default, handle, function(value)
                pcall(function() handle.SetValue(value) end)
            end)
            return option
        end

        function tab:AddInput(key, setting)
            setting = setting or {}
            local original = setting.Callback
            local adapted = copy(setting)
            local option
            adapted.Callback = function(value)
                if option then option.Value = value end
                if original then pcall(original, value) end
            end
            local handle = create("AddInput", key, adapted)
            option = registerOption(key, "Input", setting.Default, handle, function(value)
                pcall(function() handle.SetValue(value) end)
            end)
            return option
        end

        function tab:AddButton(setting)
            setting = setting or {}
            local callback = setting.Callback or setting.Func
            return create("AddButton", {
                Title = setting.Title or setting.Text or "",
                Text = setting.Text or setting.Title or "",
                Description = setting.Description or setting.Desc,
                Desc = setting.Desc or setting.Description,
                Callback = function(...)
                    if callback then pcall(callback, ...) end
                end
            })
        end

        function tab:AddParagraph(setting)
            setting = setting or {}
            local title = tostring(setting.Title or "")
            local content = tostring(setting.Content or setting.Description or "")
            local function compose(value)
                value = tostring(value or "")
                if title ~= "" and value ~= "" then
                    return title .. "\n" .. value
                end
                return title ~= "" and title or value
            end
            local label = create("AddLabel", compose(content))
            local paragraph = { Value = content, Type = "Paragraph" }
            local function apply(value)
                pcall(function() label:SetText(compose(value)) end)
            end
            function paragraph:SetContent(value)
                self.Value = value
                apply(value)
            end
            function paragraph:SetValue(value)
                self:SetContent(value)
            end
            function paragraph:SetTitle(value)
                title = tostring(value or "")
                apply(self.Value)
            end
            return paragraph
        end

        return tab
    end

    local nativeWindow = Library:CreateWindow({
        Title = "DUCZ HUB",
        Desc = "By DUCZ",
        Image = "rbxassetid://112175659522723"
    })

    local window = {}
    function window:AddTab(setting)
        local title = type(setting) == "table" and setting.Title or tostring(setting)
        return makeTab(nativeWindow, title)
    end
    function window:SelectTab(_index)
        -- Nousigi opens the first tab automatically.
    end

    function Compat:Notify(setting)
        Library:Notify(setting, true)
    end

    local tabs = {
        Info = window:AddTab({ Title = "Info And Status" }),
        Main = window:AddTab({ Title = "Farming" }),
        Hop = window:AddTab({ Title = "Hop Server [Beta]" }),
        Settings = window:AddTab({ Title = "Setting" }),
        Fish = window:AddTab({ Title = "Fishing" }),
        Quests = window:AddTab({ Title = "Quest And Item" }),
        SeaEvent = window:AddTab({ Title = "Sea Event" }),
        Race = window:AddTab({ Title = "Mirage And Race" }),
        Prehistoric = window:AddTab({ Title = "Volcano Event" }),
        Esp = window:AddTab({ Title = "Stats And Esp" }),
        Raids = window:AddTab({ Title = "Dungeon / Raiding" }),
        Combat = window:AddTab({ Title = "Local Player" }),
        Travel = window:AddTab({ Title = "Teleport" }),
        Shop = window:AddTab({ Title = "Shopping" }),
        Misc = window:AddTab({ Title = "Miscellaneous" }),
        Music = window:AddTab({ Title = "Music Player" })
    }

    return Compat, window, tabs
end
]====])()(loadstring([====[
if getgenv().Nousigi then 
	if game.CoreGui:FindFirstChild("Nousigi Hub GUI") then
		for i, v in ipairs(game.CoreGui:GetChildren()) do
			if string.find(v.Name,  "Nousigi Hub") then
				v:Destroy()
			end
		end
	end
end
getgenv().Nousigi = true

local DisableAnimation = game.Players.LocalPlayer.PlayerGui:FindFirstChild('TouchGui')
local T1UIColor = {
	["Border Color"] = Color3.fromRGB(255, 206, 27),
	["Click Effect Color"] = Color3.fromRGB(230, 230, 230),
	["Setting Icon Color"] = Color3.fromRGB(230, 230, 230),
	["Logo Image"] = "rbxassetid://112175659522723",
	["Search Icon Color"] = Color3.fromRGB(240, 240, 230),
	["Search Icon Highlight Color"] = Color3.fromRGB(255, 206, 27),
	["GUI Text Color"] = Color3.fromRGB(235, 235, 230),
	["Text Color"] = Color3.fromRGB(235, 235, 230),
	["Placeholder Text Color"] = Color3.fromRGB(170, 170, 160),
	["Title Text Color"] = Color3.fromRGB(255, 206, 27),
	["Background Main Color"] = Color3.fromRGB(18, 18, 22),
	["Background 1 Color"] = Color3.fromRGB(28, 28, 34),
	["Background 1 Transparency"] = 0.1,
	["Background 2 Color"] = Color3.fromRGB(38, 38, 46),
	["Background 3 Color"] = Color3.fromRGB(48, 48, 56),
	["Background Image"] = "",
	["Page Selected Color"] = Color3.fromRGB(255, 206, 27),
	["Section Text Color"] = Color3.fromRGB(220, 220, 210),
	["Section Underline Color"] = Color3.fromRGB(255, 206, 27),
	["Toggle Border Color"] = Color3.fromRGB(255, 206, 27),
	["Toggle Checked Color"] = Color3.fromRGB(230, 230, 230),
	["Toggle Desc Color"] = Color3.fromRGB(185, 185, 185),
	["Button Color"] = Color3.fromRGB(255, 206, 27),
	["Label Color"] = Color3.fromRGB(38, 38, 42),
	["Dropdown Icon Color"] = Color3.fromRGB(230, 230, 230),
	["Dropdown Selected Color"] = Color3.fromRGB(255, 206, 27),
	["Dropdown Selected Check Color"] = Color3.fromRGB(219, 177, 23),
	["Textbox Highlight Color"] = Color3.fromRGB(255, 206, 27),
	["Box Highlight Color"] = Color3.fromRGB(255, 206, 27),
	["Slider Line Color"] = Color3.fromRGB(255, 206, 27),
	["Slider Highlight Color"] = Color3.fromRGB(194, 156, 20),
	["Tween Animation 1 Speed"] = DisableAnimation and 0 or 0.25,
	["Tween Animation 2 Speed"] = DisableAnimation and 0 or 0.5,
	["Tween Animation 3 Speed"] = DisableAnimation and 0 or 0.1,
	["Text Stroke Transparency"] = 0.5
}

getgenv().UIColor = T1UIColor
getgenv().AllControls = {}
getgenv().UIToggled = false


local currcolor = {}
local Library = {};
local Library_Function = {}
local TweenService = game:GetService('TweenService')
local uis = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function makeDraggable(topBarObject, object)
	local dragging = nil
	local dragInput = nil
	local dragStart = nil
	local startPosition = nil
	topBarObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	topBarObject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	uis.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			if not djtmemay and cac then
				TweenService:Create(object, TweenInfo.new(DisableAnimation and 0 or 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
					Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
				}):Play()
			elseif not djtmemay and not cac then
				object.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
			end
		end
	end)
end

Library_Function.Gui = Instance.new('ScreenGui')
Library_Function.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Library_Function.Gui.Name = 'Nousigi Hub GUI'
Library_Function.Gui.Enabled = false

getgenv().ReadyForGuiLoaded = false
spawn(function()
	repeat
		task.wait()
	until getgenv().ReadyForGuiLoaded
	if getgenv().UIToggled then
		Library_Function.Gui.Enabled = true
	end
end)


Library_Function.NotiGui = Instance.new('ScreenGui')
Library_Function.NotiGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Library_Function.NotiGui.Name = 'Nousigi Hub Notification'

Library_Function.HideGui = Instance.new('ScreenGui')
Library_Function.HideGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Library_Function.HideGui.Name = 'Nousigi Hub Btn'


local btnHide = Instance.new('TextButton', Library_Function.HideGui) 
btnHide.BackgroundTransparency = 1
btnHide.Text = ""
btnHide.AnchorPoint = Vector2.new(0, 1)
btnHide.Size = UDim2.new(0, 50, 0, 50)
btnHide.Position = UDim2.new(0, 15, 1, -15)

local btnHideFrame = Instance.new('Frame', btnHide)
btnHideFrame.AnchorPoint = Vector2.new(0, 1)
btnHideFrame.Size = UDim2.new(0, 50, 0, 50)
btnHideFrame.Position = UDim2.new(0, 0, 1, 0)
btnHideFrame.Name = "dut dit"
btnHideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
btnHideFrame.BackgroundTransparency = getgenv().UIToggled and 0 or .25

local imgHide = Instance.new('ImageLabel', btnHide)
imgHide.AnchorPoint = Vector2.new(0, 0)
imgHide.Image = getgenv().UIColor["Logo Image"]
imgHide.BackgroundTransparency = 1
imgHide.Size = UDim2.new(0, getgenv().UIToggled and (getgenv().T1 and 30 or 40) or (getgenv().T1 and 25 or 30), 0, getgenv().UIToggled and (getgenv().T1 and 30 or 40) or (getgenv().T1 and 25 or 30))
imgHide.AnchorPoint = Vector2.new(.5, .5)
imgHide.Position = UDim2.new(.5, 0, .5, 0)

local UICornerBtnHide = Instance.new("UICorner")
UICornerBtnHide.Parent = btnHideFrame
UICornerBtnHide.CornerRadius = UDim.new(1, 0)

Library.ToggleUI = function()
	getgenv().UIToggled = not getgenv().UIToggled
	local sizeXY = getgenv().UIToggled and (getgenv().T1 and 30 or 40) or (getgenv().T1 and 25 or 30)
	TweenService:Create(imgHide, TweenInfo.new(DisableAnimation and 0 or .25), {
		Size = UDim2.new(0, sizeXY, 0, sizeXY)
	}):Play()
	TweenService:Create(btnHideFrame, TweenInfo.new(DisableAnimation and 0 or .25), {
		BackgroundTransparency = getgenv().UIToggled and 0 or .25
	}):Play()
	if game.CoreGui:FindFirstChild("Nousigi Hub GUI") then
		for a, b in ipairs(game.CoreGui:GetChildren()) do
			if b.Name == "Nousigi Hub GUI" then
				b.Enabled = getgenv().UIToggled
			end
		end
	end
end

Library.DestroyUI = function()
	if game.CoreGui:FindFirstChild("Nousigi Hub GUI") then
		for i, v in ipairs(game.CoreGui:GetChildren()) do
			if string.find(v.Name,  "Nousigi Hub") then
				v:Destroy()
			end
		end
	end
end

if true then
	local button = btnHide -- Assuming this is a TextButton or ImageButton
	local UIS = game:GetService("UserInputService")
	
	local dragging = false
	local dragInput, dragStart, startPos
	local holdTime = 0.1 -- Time to hold before dragging is enabled
	local holdStarted = 0
	
	-- Function to update the button's position
	local function update(input)
		local delta = input.Position - dragStart
		button.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
	
	-- Function to detect the start of dragging (for both mouse and touch)
	local function onInputBegan(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			holdStarted = tick() -- Record the time when holding starts
			dragStart = input.Position
			startPos = button.Position
	
			-- Listen for release to stop dragging
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					holdStarted = 0 -- Reset the hold timer
				end
			end)
		end
	end
	
	-- Function to detect when dragging stops
	local function onInputEnded(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			holdStarted = 0 -- Reset the hold timer
		end
	end
	
	-- Detect input movement (for both mouse and touch)
	local function onInputChanged(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end
	
	-- Connect the events
	button.InputBegan:Connect(onInputBegan)
	button.InputEnded:Connect(onInputEnded)
	button.InputChanged:Connect(onInputChanged)
	
	-- RenderStepped updates the position while dragging
	RunService.RenderStepped:Connect(function()
		if holdStarted > 0 and (tick() - holdStarted >= holdTime) and not dragging then
			dragging = true
		end
	
		if dragging and dragInput then
			update(dragInput)
		end
	end)
		
end

btnHide.MouseButton1Click:Connect(function() 
	Library.ToggleUI()
end)

local NotiContainer = Instance.new("Frame")
local NotiList = Instance.new("UIListLayout")

NotiContainer.Name = "NotiContainer"
NotiContainer.Parent = Library_Function.NotiGui
NotiContainer.AnchorPoint = Vector2.new(1, 1)
NotiContainer.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
NotiContainer.BackgroundTransparency = 1.000
NotiContainer.Position = UDim2.new(1, -5, 1, -5)
NotiContainer.Size = UDim2.new(0, 350, 1, -10)

NotiList.Name = "NotiList"
NotiList.Parent = NotiContainer
NotiList.SortOrder = Enum.SortOrder.LayoutOrder
NotiList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotiList.Padding = UDim.new(0, 5)


Library_Function.Gui.Parent = game:GetService('CoreGui')
Library_Function.NotiGui.Parent = game:GetService('CoreGui')
Library_Function.HideGui.Parent = game:GetService('CoreGui')

function Library_Function.Getcolor(color)
	return {
		math.floor(color.r * 255),
		math.floor(color.g * 255),
		math.floor(color.b * 255)
	}
end

local libCreateNoti = function(Setting)
	getgenv().TitleNameNoti = Setting.Title or ""; 
	local Description = Setting.Description or Setting.Desc or Setting.Content or ""; 
	local Duration = Setting.Duration or Setting.Timeshow or Setting.Delay or 10;

	local NotiFrame = Instance.new("Frame")
	local Noticontainer = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local Topnoti = Instance.new("Frame")
	local Ruafimg = Instance.new("ImageLabel")
	local RuafimgCorner = Instance.new("UICorner")
	local TextLabelNoti = Instance.new("TextLabel")
	local CloseContainer = Instance.new("Frame")
	local CloseImage = Instance.new("ImageLabel")
	local TextButton = Instance.new("TextButton")
	local TextLabelNoti2 = Instance.new("TextLabel")

	NotiFrame.Name = "NotiFrame"
	NotiFrame.Parent = NotiContainer
	NotiFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	NotiFrame.BackgroundTransparency = 1.000
	NotiFrame.ClipsDescendants = true
	NotiFrame.Position = UDim2.new(0, 0, 0, 0)
	NotiFrame.Size = UDim2.new(1, 0, 0, 0)
	NotiFrame.AutomaticSize = Enum.AutomaticSize.Y

	Noticontainer.Name = "Noticontainer"
	Noticontainer.Parent = NotiFrame
	Noticontainer.Position = UDim2.new(1, 0, 0, 0)
	Noticontainer.Size = UDim2.new(1, 0, 1, 6)
	Noticontainer.AutomaticSize = Enum.AutomaticSize.Y
	Noticontainer.BackgroundColor3 = getgenv().UIColor["Background 3 Color"]
	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = Noticontainer

	Topnoti.Name = "Topnoti"
	Topnoti.Parent = Noticontainer
	Topnoti.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	Topnoti.BackgroundTransparency = 1.000
	Topnoti.Position = UDim2.new(0, 0, 0, 5)
	Topnoti.Size = UDim2.new(1, 0, 0, 25)

	Ruafimg.Name = "Ruafimg"
	Ruafimg.Parent = Topnoti
	Ruafimg.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	Ruafimg.BackgroundTransparency = 1.000
	Ruafimg.Position = UDim2.new(0, 5, 0, getgenv().T1 and 5 or 0)
	Ruafimg.Size = UDim2.new(0, getgenv().T1 and 30 or 25, 0, getgenv().T1 and 15 or 25)
	Ruafimg.Image = getgenv().UIColor["Logo Image"]

	RuafimgCorner.CornerRadius = UDim.new(1, 0)
	RuafimgCorner.Name = "RuafimgCorner"
	RuafimgCorner.Parent = Ruafimg
	
	local colorR = tostring(Library_Function.Getcolor(getgenv().UIColor['Title Text Color'])[1])
	local colorG = tostring(Library_Function.Getcolor(getgenv().UIColor['Title Text Color'])[2])
	local colorB = tostring(Library_Function.Getcolor(getgenv().UIColor['Title Text Color'])[3])
	local color = colorR .. ',' .. colorG .. ',' .. colorB
    TextLabelNoti.Text = "<font color=\"rgb(" .. tostring(color or "255,206,27") .. ")\">" .. tostring("Banana Cat Hub") .. "</font> " .. tostring(getgenv().TitleNameNoti or "")
    
	TextLabelNoti.Name = "TextLabelNoti"
	TextLabelNoti.Parent = Topnoti
	TextLabelNoti.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	TextLabelNoti.BackgroundTransparency = 1.000
	TextLabelNoti.Position = UDim2.new(0, getgenv().T1 and 40 or 35, 0, 0)
	TextLabelNoti.Size = UDim2.new(1, getgenv().T1 and -40 or -35, 1, 0)
	TextLabelNoti.Font = Enum.Font.GothamBold
	TextLabelNoti.TextSize = 14.000
	TextLabelNoti.TextWrapped = true
	TextLabelNoti.TextXAlignment = Enum.TextXAlignment.Left
	TextLabelNoti.RichText = true
	TextLabelNoti.TextColor3 = getgenv().UIColor["GUI Text Color"]

	CloseContainer.Name = "CloseContainer"
	CloseContainer.Parent = Topnoti
	CloseContainer.AnchorPoint = Vector2.new(1, 0.5)
	CloseContainer.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	CloseContainer.BackgroundTransparency = 1.000
	CloseContainer.Position = UDim2.new(1, -4, 0.5, 0)
	CloseContainer.Size = UDim2.new(0, 22, 0, 22)

	CloseImage.Name = "CloseImage"
	CloseImage.Parent = CloseContainer
	CloseImage.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	CloseImage.BackgroundTransparency = 1.000
	CloseImage.Size = UDim2.new(1, 0, 1, 0)
	CloseImage.Image = "rbxassetid://112175659522723"
	CloseImage.ImageRectOffset = Vector2.new(284, 4)
	CloseImage.ImageRectSize = Vector2.new(24, 24)
	CloseImage.ImageColor3 = getgenv().UIColor["Search Icon Color"]

	TextButton.Parent = CloseContainer
	TextButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	TextButton.BackgroundTransparency = 1.000
	TextButton.Size = UDim2.new(1, 0, 1, 0)
	TextButton.Font = Enum.Font.SourceSans
	TextButton.Text = ""
	TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextButton.TextSize = 14.000

	if Description then
		TextLabelNoti2.Name = 'TextColor'
		TextLabelNoti2.Parent = Noticontainer
		TextLabelNoti2.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		TextLabelNoti2.BackgroundTransparency = 1.000
		TextLabelNoti2.Position = UDim2.new(0, 10, 0, 35)
		TextLabelNoti2.Size = UDim2.new(1, -15, 0, 0)
		TextLabelNoti2.Font = Enum.Font.GothamBold
		TextLabelNoti2.Text = Description
		TextLabelNoti2.TextSize = 14.000
		TextLabelNoti2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabelNoti2.RichText = true
		TextLabelNoti2.TextColor3 = getgenv().UIColor["Text Color"]
		TextLabelNoti2.AutomaticSize = Enum.AutomaticSize.Y
		TextLabelNoti2.TextWrapped = true
	end

	local function remove()
		TweenService:Create(Noticontainer, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
			Position = UDim2.new(1, 0, 0, 0)
		}):Play()
		wait(.25)
		NotiFrame:Destroy()
	end

	TweenService:Create(Noticontainer, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
		Position = UDim2.new(0, 0, 0, 0)
	}):Play()

	TextButton.MouseEnter:Connect(function()
		TweenService:Create(CloseImage, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
			ImageColor3 = getgenv().UIColor["Search Icon Highlight Color"]
		}):Play()
	end)

	TextButton.MouseLeave:Connect(function()
		TweenService:Create(CloseImage, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
			ImageColor3 = getgenv().UIColor["Search Icon Color"]
		}):Play()
	end)

	TextButton.MouseButton1Click:Connect(function()
		wait(.25)
		remove()
	end)

	spawn(function()
		wait(Duration)
		remove()
	end)

end

function Library:Notify(Setting, bypass)
	if not getgenv().Config or bypass then
		local s, e = pcall(function()
			libCreateNoti(Setting)
		end)
		if e then
			print(e)
		end
	end
end

function Library:CreateWindow(Setting)
    local TitleNameMain = Setting.Title or "Banana Cat Hub"
    getgenv().MainDesc = Setting.Desc or Setting.Subtitle or ""
    
    if Setting.Image then
        getgenv().UIColor["Logo Image"] = Setting.Image
    end
    
	local djtmemay = false
	cac = false

	local Main = Instance.new("Frame")
	local maingui = Instance.new("ImageLabel")
	local MainCorner = Instance.new("UICorner")
	local TopMain = Instance.new("Frame")
	local Ruafimg = Instance.new("ImageLabel")
	local TextLabelMain = Instance.new("TextLabel")
	local PageControl = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local ControlList = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local ControlTitle = Instance.new("TextLabel")
	local MainPage = Instance.new("Frame")
	local UIPage = Instance.new("UIPageLayout")
	local Concacontainer = Instance.new("Frame")
	local Concacmain = Instance.new("Frame")
	local MainContainer

	Main.Name = "Main"
	Main.Parent = Library_Function.Gui
	Main.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
	Main.BackgroundTransparency = 1.000
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Size = UDim2.new(0, 629, 0, 359)

	makeDraggable(Main, Main)

	maingui.Name = "maingui"
	maingui.Parent = Main
	maingui.AnchorPoint = Vector2.new(0.5, 0.5)
	maingui.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	maingui.BackgroundTransparency = 1.000
	maingui.Position = UDim2.new(0.5, 0, 0.5, 0)
	maingui.Selectable = true
	maingui.Size = UDim2.new(1, 30, 1, 30)
	maingui.Image = "rbxassetid:/112175659522723"
	maingui.ScaleType = Enum.ScaleType.Slice
	maingui.SliceCenter = Rect.new(15, 15, 175, 175)
	maingui.SliceScale = 1.300
	maingui.ImageColor3 = getgenv().UIColor["Border Color"]
	maingui.ImageTransparency = 1

	maingui.ImageColor3 = getgenv().UIColor['Title Text Color']

	MainContainer = Instance.new("ImageLabel")
	MainContainer.Name = "MainContainer"
	MainContainer.Parent = Main
	MainContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
	MainContainer.Size = UDim2.new(1, 0, 1, 0)

	local uistr = Instance.new("UIStroke", MainContainer);
	uistr.Thickness = 1;
	uistr.Color = Color3.fromRGB(90, 90, 70);

	local uigradient = Instance.new("UIGradient", MainContainer);
	uigradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
	}
	uigradient.Rotation = 90
	uigradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0.92),
		NumberSequenceKeypoint.new(1, 0.92)
	}

	getgenv().ReadyForGuiLoaded = true
	
	MainCorner.CornerRadius = UDim.new(0, 5)
	MainCorner.Name = "MainCorner"
	MainCorner.Parent = MainContainer

	Concacontainer.Name = "Concacontainer"
	Concacontainer.Parent = MainContainer
	Concacontainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Concacontainer.BackgroundTransparency = 1.000
	Concacontainer.ClipsDescendants = true
	Concacontainer.Position = UDim2.new(0, 0, 0, 30)
	Concacontainer.Size = UDim2.new(1, 0, 1, -30)
	
	Concacmain.Name = "Concacmain"
	Concacmain.Parent = Concacontainer
	Concacmain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Concacmain.BackgroundTransparency = 1.000
	Concacmain.Selectable = true
	Concacmain.Size = UDim2.new(1, 0, 1, 0)
	
	TopMain.Name = "TopMain"
	TopMain.Parent = MainContainer
	TopMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TopMain.BackgroundTransparency = 1.000
	TopMain.Size = UDim2.new(1, 0, 0, 25)
	
	local TopStroke = Instance.new("Frame", TopMain)
	TopStroke.Name = "TopStroke"
	TopStroke.BackgroundColor3 = Color3.fromRGB(90, 90, 70)
	TopStroke.BackgroundTransparency = 0.6
	TopStroke.BorderSizePixel = 0
	TopStroke.Position = UDim2.new(0, 0, 1, -1)
	TopStroke.Size = UDim2.new(1, 0, 0, 1)
	
	Ruafimg.Name = "Ruafimg"
	Ruafimg.Parent = TopMain
	Ruafimg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Ruafimg.BackgroundTransparency = 1.000
	Ruafimg.Position = UDim2.new(0, 5, 0, 0)
	Ruafimg.Size = UDim2.new(0, 25, 0, 25)
	Ruafimg.Image = getgenv().UIColor["Logo Image"]

	TextLabelMain.Name = "TextLabelMain"
	TextLabelMain.Parent = TopMain
	TextLabelMain.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	TextLabelMain.BackgroundTransparency = 1.000
	TextLabelMain.Position = UDim2.new(0, 220, 0, 0)
	TextLabelMain.Size = UDim2.new(1, -35, 1, 0)
	TextLabelMain.Font = Enum.Font.GothamBold
	TextLabelMain.RichText = true
	TextLabelMain.TextSize = 16.000
	TextLabelMain.TextWrapped = true
	TextLabelMain.TextXAlignment = Enum.TextXAlignment.Left
	TextLabelMain.TextColor3 = getgenv().UIColor["GUI Text Color"]

	local colorR = tostring(Library_Function.Getcolor(getgenv().UIColor['Title Text Color'])[1])
	local colorG = tostring(Library_Function.Getcolor(getgenv().UIColor['Title Text Color'])[2])
	local colorB = tostring(Library_Function.Getcolor(getgenv().UIColor['Title Text Color'])[3])
	local color = colorR .. ',' .. colorG .. ',' .. colorB
    TextLabelMain.Text = "<font color=\"rgb(" .. tostring(color or "255,206,27") .. ")\">" .. tostring(TitleNameMain or "Banana Cat Hub") .. "</font> " .. tostring(getgenv().MainDesc or "")

	PageControl.Name = "Background1"
	PageControl.Parent = Concacmain
	PageControl.Position = UDim2.new(0, 5, 0, 0)
	PageControl.Size = UDim2.new(0, 180, 0, 325)
	PageControl.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
	PageControl.BackgroundTransparency = 0.1

	local pageControlStroke = Instance.new("UIStroke", PageControl)
	pageControlStroke.Color = Color3.fromRGB(90, 90, 70)
	pageControlStroke.Thickness = 1

	local pageControlGradient = Instance.new("UIGradient", PageControl)
	pageControlGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 34)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(38, 38, 46))
	}
	pageControlGradient.Rotation = 90
	pageControlGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0.06),
		NumberSequenceKeypoint.new(1, 0.12)
	}

	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = PageControl

	ControlList.Name = "ControlList"
	ControlList.Parent = PageControl
	ControlList.Active = true
	ControlList.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	ControlList.BackgroundTransparency = 1.000
	ControlList.BorderColor3 = Color3.fromRGB(27, 42, 53)
	ControlList.BorderSizePixel = 0
	ControlList.Position = UDim2.new(0, 0, 0, 30)
	ControlList.Size = UDim2.new(1, -5, 1, -30)
	ControlList.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ControlList.CanvasSize = UDim2.new(0, 0, 0, 0)
	ControlList.ScrollBarThickness = 5
	ControlList.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

	UIListLayout.Parent = ControlList
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	ControlTitle.Name = "GUITextColor"
	ControlTitle.Parent = PageControl
	ControlTitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	ControlTitle.BackgroundTransparency = 1.000
	ControlTitle.Position = UDim2.new(0, 5, 0, 0)
	ControlTitle.Size = UDim2.new(1, 0, 0, 25)
	ControlTitle.Font = Enum.Font.GothamBold
	ControlTitle.Text = TitleNameMain
	ControlTitle.TextSize = 14.000
	ControlTitle.TextXAlignment = Enum.TextXAlignment.Left
	ControlTitle.TextColor3 = getgenv().UIColor["GUI Text Color"]

	local PageSearch = Instance.new("Frame")
	local PageSearchCorner = Instance.new("UICorner")
	local SearchFrame = Instance.new("Frame")
	local SearchIcon = Instance.new("ImageLabel")
	local SearchBox = Instance.new("TextBox")

	PageSearch.Name = "PageSearch"
	PageSearch.Parent = PageControl
	PageSearch.AnchorPoint = Vector2.new(1, 0)
	PageSearch.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
	PageSearch.Position = UDim2.new(1, -5, 0, 5)
	PageSearch.Size = UDim2.new(0, 170, 0, 25)
	PageSearch.ClipsDescendants = true

	PageSearchCorner.Parent = PageSearch
	PageSearchCorner.CornerRadius = UDim.new(0, 4)

	SearchFrame.Name = "SearchFrame"
	SearchFrame.Parent = PageSearch
	SearchFrame.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
	SearchFrame.BackgroundTransparency = 1
	SearchFrame.Size = UDim2.new(0, 25, 1, 0)

	SearchIcon.Name = "SearchIcon"
	SearchIcon.Parent = SearchFrame
	SearchIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	SearchIcon.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
	SearchIcon.BackgroundTransparency = 1
	SearchIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	SearchIcon.Size = UDim2.new(0, 16, 0, 16)
	SearchIcon.Image = "rbxassetid://112175659522723"
	SearchIcon.ImageColor3 = Color3.fromRGB(240, 240, 230)

    SearchBox.Name = "SearchBox"
    SearchBox.Parent = PageSearch
    SearchBox.Active = true
    SearchBox.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
    SearchBox.BackgroundTransparency = 1
    SearchBox.CursorPosition = -1
    SearchBox.Position = UDim2.new(0, 30, 0, 0)
    SearchBox.Size = UDim2.new(1, -30, 1, 0)
    SearchBox.Font = Enum.Font.GothamBold
    SearchBox.PlaceholderColor3 = Color3.fromRGB(170, 170, 160)
    SearchBox.PlaceholderText = "Search section or Function..."
    SearchBox.Text = ""
    SearchBox.TextColor3 = Color3.fromRGB(235, 235, 230)
    SearchBox.TextSize = 14
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left

	MainPage.Name = "MainPage"
	MainPage.Parent = Concacmain
	MainPage.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	MainPage.BackgroundTransparency = 1.000
	MainPage.ClipsDescendants = true
	MainPage.Position = UDim2.new(0, 190, 0, 0)
	MainPage.Size = UDim2.new(0, 435, 0, 325)

	UIPage.Name = "UIPage"
	UIPage.Parent = MainPage
	UIPage.FillDirection = Enum.FillDirection.Vertical
	UIPage.SortOrder = Enum.SortOrder.LayoutOrder
	UIPage.EasingDirection = Enum.EasingDirection.InOut
	UIPage.EasingStyle = Enum.EasingStyle.Quart
	UIPage.Padding = UDim.new(0, 10)
	UIPage.TweenTime = getgenv().UIColor["Tween Animation 1 Speed"]

	UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		ControlList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 5)
	end)

	local Shadow = Instance.new("ImageLabel", Main)
	Shadow.Name = "Shadow"
	Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	Shadow.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
	Shadow.BackgroundTransparency = 1
	Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	Shadow.Size = UDim2.new(1, 40, 1, 40)
	Shadow.ZIndex = 0
	Shadow.Image = "rbxassetid://112175659522723"
	Shadow.ImageTransparency = 0.35
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(24, 24, 276, 276)

    -- Thêm biến để lưu thông tin section
    local sectionInfo = {}
    
    -- Tạo hàm GlobalSearch nếu chưa tồn tại
    if not GlobalSearch then
        GlobalSearch = function(searchText)
            searchText = string.lower(searchText)
            
            if searchText == "" then
                -- Hiển thị tất cả như cũ
                for _, control in pairs(getgenv().AllControls) do
                    control.TabButton.Visible = true
                    control.Section.Visible = true
                    control.Element.Visible = true
                end
                -- Hiển thị tất cả tab
                for _, tab in pairs(ControlList:GetChildren()) do
                    if not tab:IsA('UIListLayout') then
                        tab.Visible = true
                    end
                end
                return
            end
            
            -- Ẩn tất cả trước
            for _, control in pairs(getgenv().AllControls) do
                control.Section.Visible = false
                control.Element.Visible = false
            end
            
            -- Ẩn tất cả tab
            for _, tab in pairs(ControlList:GetChildren()) do
                if not tab:IsA('UIListLayout') then
                    tab.Visible = false
                end
            end
            
            -- Tạo bản đồ section
            local sectionsWithElements = {}
            local elementsInSection = {}
            
            -- Phân tích từng control
            for _, control in pairs(getgenv().AllControls) do
                local elementName = string.lower(control.Name or "")
                local sectionName = string.lower(control.SectionName or "")
                
                -- Kiểm tra phần tử (sử dụng string.find thay vì string.match)
                local elementFound = string.find(elementName, searchText, 1, true) ~= nil
                -- Kiểm tra section
                local sectionFound = string.find(sectionName, searchText, 1, true) ~= nil
                
                -- Tạo bản đồ section
                if not elementsInSection[control.Section] then
                    elementsInSection[control.Section] = {}
                end
                table.insert(elementsInSection[control.Section], {
                    control = control,
                    elementFound = elementFound,
                    sectionFound = sectionFound
                })
                
                -- Đánh dấu section có phần tử khớp
                if elementFound then
                    sectionsWithElements[control.Section] = true
                end
            end
            
            -- Xử lý hiển thị
            local foundTabs = {}
            
            for section, elements in pairs(elementsInSection) do
                local shouldShowSection = false
                local hasElementMatch = false
                
                -- Kiểm tra section có khớp không
                for _, elementInfo in ipairs(elements) do
                    if elementInfo.sectionFound then
                        shouldShowSection = true
                    end
                    if elementInfo.elementFound then
                        hasElementMatch = true
                    end
                end
                
                -- Logic hiển thị
                for _, elementInfo in ipairs(elements) do
                    local control = elementInfo.control
                    
                    if elementInfo.elementFound then
                        -- Phần tử khớp: hiển thị phần tử
                        control.Element.Visible = true
                        
                        -- Nếu section cũng khớp hoặc có phần tử khớp: hiện section
                        if elementInfo.sectionFound or hasElementMatch then
                            control.Section.Visible = true
                        end
                        
                        foundTabs[control.TabName] = true
                        control.TabButton.Visible = true
                    elseif elementInfo.sectionFound and not hasElementMatch then
                        -- Section khớp nhưng không có phần tử khớp: chỉ hiện section
                        control.Section.Visible = true
                        control.Element.Visible = false
                        
                        foundTabs[control.TabName] = true
                        control.TabButton.Visible = true
                    end
                end
            end
            
            -- Hiển thị các tab có kết quả
            for tabName, _ in pairs(foundTabs) do
                for _, tab in pairs(ControlList:GetChildren()) do
                    if not tab:IsA('UIListLayout') and string.find(tab.Name, tabName, 1, true) then
                        tab.Visible = true
                    end
                end
            end
            
            -- Nếu không tìm thấy gì cả, hiển thị thông báo
            if not next(foundTabs) then
                -- Có thể thêm thông báo "Không tìm thấy kết quả" ở đây nếu muốn
            end
        end
    end
    
    -- Kết nối sự kiện search (giữ nguyên)
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        GlobalSearch(SearchBox.Text)
    end)

	local Main_Function = {}

	local LayoutOrderBut = -1
	local LayoutOrder = -1
	local PageCounter = 1

	function Main_Function:AddTab(PageName)

		local Page_Name = tostring(PageName)
		local Page_Title = Page_Name

		LayoutOrder = LayoutOrder + 1
		LayoutOrderBut = LayoutOrderBut + 1

		--Control 
		local PageName = Instance.new("Frame")
		local Frame = Instance.new("Frame")
		local TabNameCorner = Instance.new("UICorner")
		local Line = Instance.new("Frame")
		local InLine = Instance.new("Frame")
		local LineCorner = Instance.new("UICorner")
		local TabTitleContainer = Instance.new("Frame")
		local TabTitle = Instance.new("TextLabel")
		local PageButton = Instance.new("TextButton")


		PageName.Name = Page_Name .. "_Control"
		PageName.Parent = ControlList
		PageName.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		PageName.BackgroundTransparency = 1.000
		PageName.Size = UDim2.new(1, -10, 0, 25)
		PageName.LayoutOrder = LayoutOrderBut

		Frame.Parent = PageName
		Frame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		Frame.BackgroundTransparency = 1.000
		Frame.Position = UDim2.new(0, 5, 0, 0)
		Frame.Size = UDim2.new(1, -5, 1, 0)

		TabNameCorner.CornerRadius = UDim.new(0, 4)
		TabNameCorner.Name = "TabNameCorner"
		TabNameCorner.Parent = Frame

		Line.Name = "Line"
		Line.Parent = Frame
		Line.AnchorPoint = Vector2.new(0, 0.5)
		Line.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		Line.BackgroundTransparency = 1.000
		Line.Position = UDim2.new(0, 0, 0.5, 0)
		Line.Size = UDim2.new(0, 14, 1, 0)

		InLine.Name = "PageInLine"
		InLine.Parent = Line
		InLine.AnchorPoint = Vector2.new(0.5, 0.5)
		InLine.BorderSizePixel = 0
		InLine.Position = UDim2.new(0.5, 0, 0.5, 0)
		InLine.Size = UDim2.new(1, -10, 1, -10)
		InLine.BackgroundColor3 = getgenv().UIColor["Page Selected Color"]
		InLine.BackgroundTransparency = 1.000

		LineCorner.Name = "LineCorner"
		LineCorner.Parent = InLine

		TabTitleContainer.Name = "TabTitleContainer"
		TabTitleContainer.Parent = Frame
		TabTitleContainer.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		TabTitleContainer.BackgroundTransparency = 1.000
		TabTitleContainer.Position = UDim2.new(0, 15, 0, 0)
		TabTitleContainer.Size = UDim2.new(1, -15, 1, 0)

		TabTitle.Name = "GUITextColor"
		TabTitle.Parent = TabTitleContainer
		TabTitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		TabTitle.BackgroundTransparency = 1.000
		TabTitle.Size = UDim2.new(1, 0, 1, 0)
		TabTitle.Font = Enum.Font.GothamBold
		TabTitle.Text = Page_Name
		TabTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
		TabTitle.TextSize = 14.000
		TabTitle.TextXAlignment = Enum.TextXAlignment.Left
		TabTitle.TextColor3 = getgenv().UIColor["GUI Text Color"]

		PageButton.Name = "PageButton"
		PageButton.Parent = PageName
		PageButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		PageButton.BackgroundTransparency = 1.000
		PageButton.Size = UDim2.new(1, 0, 1, 0)
		PageButton.Font = Enum.Font.SourceSans
		PageButton.Text = ""
		PageButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		PageButton.TextSize = 14.000

		-- Container

		local PageContainer = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local PageTitle = Instance.new("TextLabel")
		local PageList = Instance.new("ScrollingFrame")
		local Pagelistlayout = Instance.new("UIListLayout")

		local CurrentPage = PageCounter
		PageCounter = PageCounter + 1
		PageContainer.Name = "Page" .. CurrentPage
		PageContainer.Parent = MainPage
		PageContainer.BackgroundColor3 = getgenv().UIColor["Background 1 Color"]
		PageContainer.Position = UDim2.new(0, 190, 0, 30)
		PageContainer.Size = UDim2.new(0, 435, 0, 325)
		PageContainer.LayoutOrder = LayoutOrder
		PageContainer.BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"]

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = PageContainer

		PageTitle.Name = "GUITextColor"
		PageTitle.Parent = PageContainer
		PageTitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		PageTitle.BackgroundTransparency = 1.000
		PageTitle.Position = UDim2.new(0, 5, 0, 0)
		PageTitle.Size = UDim2.new(1, 0, 0, 25)
		PageTitle.Font = Enum.Font.GothamBold
		PageTitle.Text = Page_Title
		PageTitle.TextSize = 16.000
		PageTitle.TextXAlignment = Enum.TextXAlignment.Left
		PageTitle.TextColor3 = getgenv().UIColor["GUI Text Color"]

		PageList.Name = "PageList"
		PageList.Parent = PageContainer
		PageList.Active = true
		PageList.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		PageList.BackgroundTransparency = 1.000
		PageList.BorderColor3 = Color3.fromRGB(27, 42, 53)
		PageList.BorderSizePixel = 0
		PageList.Position = UDim2.new(0, 5, 0, 30)
		PageList.Size = UDim2.new(1, -10, 1, -30)
		PageList.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
		PageList.ScrollBarThickness = 5
		PageList.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
		PageList.ScrollingEnabled = true
		PageList.VerticalScrollBarInset = Enum.ScrollBarInset.Always

		Pagelistlayout.Name = "Pagelistlayout"
		Pagelistlayout.Parent = PageList
		Pagelistlayout.SortOrder = Enum.SortOrder.LayoutOrder
		Pagelistlayout.Padding = UDim.new(0, 5)
		Pagelistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			PageList.CanvasSize = UDim2.new(0, 0, 0, Pagelistlayout.AbsoluteContentSize.Y)
		end)

		local PageSearch = Instance.new("Frame")
		local PageSearchCorner = Instance.new("UICorner")
		local SearchFrame = Instance.new("Frame")
		local SearchIcon = Instance.new("ImageLabel")
		local SearchButton = Instance.new("TextButton")
		local SearchBox = Instance.new("TextBox")

		PageSearch.Name = "Page Search"
		PageSearch.Parent = PageContainer
		PageSearch.AnchorPoint = Vector2.new(1, 0)
		PageSearch.BackgroundColor3 = getgenv().UIColor["Background 2 Color"]
		PageSearch.Position = UDim2.new(1, -5, 0, 5)
		PageSearch.Size = UDim2.new(0, 20, 0, 20)
		PageSearch.ClipsDescendants = true

		PageSearchCorner.CornerRadius = UDim.new(0, 2)
		PageSearchCorner.Name = "PageSearchCorner"
		PageSearchCorner.Parent = PageSearch

		SearchFrame.Name = "SearchFrame"
		SearchFrame.Parent = PageSearch
		SearchFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SearchFrame.BackgroundTransparency = 1.000
		SearchFrame.Size = UDim2.new(0, 20, 0, 20)

		SearchIcon.Name = "SearchIcon"
		SearchIcon.Parent = SearchFrame
		SearchIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SearchIcon.BackgroundTransparency = 1.000
		SearchIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
		SearchIcon.Size = UDim2.new(0, 16, 0, 16)
		SearchIcon.Image = "rbxassetid://112175659522723"
		SearchIcon.ImageColor3 = getgenv().UIColor["Search Icon Color"]

		SearchButton.Name = "Search Button"
		SearchButton.Parent = SearchFrame
		SearchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SearchButton.BackgroundTransparency = 1.000
		SearchButton.Size = UDim2.new(1, 0, 1, 0)
		SearchButton.Font = Enum.Font.SourceSans
		SearchButton.Text = ""
		SearchButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		SearchButton.TextSize = 14.000

		SearchBox.Name = "Search Box"
		SearchBox.Parent = PageSearch
		SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SearchBox.BackgroundTransparency = 1.000
		SearchBox.Position = UDim2.new(0, 30, 0, 0)
		SearchBox.Size = UDim2.new(1, -30, 1, 0)
		SearchBox.Font = Enum.Font.GothamBold
		SearchBox.Text = ""
		SearchBox.TextSize = 14.000
		SearchBox.TextXAlignment = Enum.TextXAlignment.Left
		SearchBox.PlaceholderText = "Search Section name"
		SearchBox.PlaceholderColor3 = getgenv().UIColor["Placeholder Text Color"]
		SearchBox.TextColor3 = getgenv().UIColor["Text Color"]
		
		local Openned = false 

		SearchButton.MouseEnter:Connect(function()
			TweenService:Create(SearchIcon, TweenInfo.new(getgenv().UIColor["Tween Animation 3 Speed"]), {
				ImageColor3 = getgenv().UIColor["Search Icon Highlight Color"]
			}):Play()
		end)

		SearchButton.MouseLeave:Connect(function()
			TweenService:Create(SearchIcon, TweenInfo.new(getgenv().UIColor["Tween Animation 3 Speed"]), {
				ImageColor3 = getgenv().UIColor["Search Icon Color"]
			}):Play()
		end)

		SearchButton.MouseButton1Click:Connect(function()
			Openned = not Openned
			local size = Openned and UDim2.new(0, 175, 0, 20) or  UDim2.new(0, 20, 0, 20)
			game.TweenService:Create(PageSearch, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
				Size = size
			}):Play()
		end)

		local function hideOtherFrame()
			for i, v in next, PageList:GetChildren() do 
				if not v:IsA('UIListLayout') then 
					v.Visible = false
				end
			end
		end
		
		local function showFrameName()
			for i, v in pairs(PageList:GetChildren()) do
				if not v:IsA('UIListLayout') then 
					if string.find(string.lower(v.Name), string.lower(SearchBox.Text)) then 
						v.Visible = true
					end
				end
			end
		end
		
		SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
			hideOtherFrame()
			showFrameName()
		end)

		for i, v in pairs(ControlList:GetChildren()) do
			if not (v:IsA('UIListLayout')) then
				if i == 2 then 
					v.Frame.Line.PageInLine.BackgroundTransparency = 0
				end
			end
		end

		PageButton.MouseButton1Click:Connect(function()
			if tostring(UIPage.CurrentPage) == PageContainer.Name then 
				return
			end

			for i, v in pairs(MainPage:GetChildren()) do
				if not (v:IsA('UIPageLayout')) and not (v:IsA('UICorner')) then
					v.Visible = false
				end
			end

			PageContainer.Visible = true 
			UIPage:JumpTo(PageContainer)

			for i, v in next, ControlList:GetChildren() do
				if not (v:IsA('UIListLayout')) then
					if v.Name == Page_Name .. "_Control" then 
						TweenService:Create(v.Frame.Line.PageInLine, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
							BackgroundTransparency = 0
						}):Play()
					else
						TweenService:Create(v.Frame.Line.PageInLine, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
							BackgroundTransparency = 1
						}):Play()
					end
				end
			end
		end)

		local pageFunction = {}

		function pageFunction:AddSection(Section_Name, Toggleable, SectionGap, SectionColor)
			local Toggleable = Toggleable or false
			local Section = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Topsec = Instance.new("Frame")
			local Sectiontitle = Instance.new("TextLabel")
			local Linesec = Instance.new("Frame")
			local UIGradient = Instance.new("UIGradient")
			local SectionList = Instance.new("UIListLayout")
			
			Section.Name = Section_Name .. "_Dot"
			Section.Parent = PageList
			Section.Size = UDim2.new(1, -5, 0, 30)
			Section.BackgroundColor3 = Color3.fromRGB(48, 48, 56)
			Section.BackgroundTransparency = 0.25
			Section.ClipsDescendants = true

			local sectionStroke = Instance.new("UIStroke", Section)
			sectionStroke.Color = Color3.fromRGB(90, 90, 70)
			sectionStroke.Thickness = 1

			local sectionGradient = Instance.new("UIGradient", Section)
			sectionGradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 38, 46)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 48, 56))
			}
			sectionGradient.Rotation = 90
			sectionGradient.Transparency = NumberSequence.new{
				NumberSequenceKeypoint.new(0, 0.05),
				NumberSequenceKeypoint.new(1, 0.15)
			}

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Section

			Topsec.Name = "Topsec"
			Topsec.Parent = Section
			Topsec.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
			Topsec.BackgroundTransparency = 1.000
			Topsec.Size = UDim2.new(0, 415, 0, 30)

			Sectiontitle.Name = "Sectiontitle"
			Sectiontitle.Parent = Topsec
			Sectiontitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
			Sectiontitle.BackgroundTransparency = 1.000
			Sectiontitle.Size = UDim2.new(1, 0, 1, 0)
			Sectiontitle.Font = Enum.Font.GothamBold
			Sectiontitle.Text = Section_Name
			Sectiontitle.TextSize = 14.000
			Sectiontitle.TextColor3 = getgenv().UIColor["Section Text Color"]

			Linesec.Name = "Linesec"
			Linesec.Parent = Topsec
			Linesec.AnchorPoint = Vector2.new(0.5, 1)
			Linesec.BorderSizePixel = 0
			Linesec.Position = UDim2.new(0.5, 0, 1, -2)
			Linesec.Size = UDim2.new(1, -10, 0, 2)
			Linesec.BackgroundColor3 = getgenv().UIColor["Section Underline Color"]

			local LineShadow = Instance.new("ImageLabel", Linesec)
			LineShadow.Name = "LineShadow"
			LineShadow.AnchorPoint = Vector2.new(0.5, 0.5)
			LineShadow.BackgroundColor3 = Color3.fromRGB(163,162,165)
			LineShadow.BackgroundTransparency = 1
			LineShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
			LineShadow.Size = UDim2.new(1, 8, 1, 8)
			LineShadow.ZIndex = 0
			LineShadow.Image = "rbxassetid://112175659522723"
			LineShadow.ImageTransparency = 0.6
			LineShadow.ScaleType = Enum.ScaleType.Slice
			LineShadow.SliceCenter = Rect.new(24, 24, 276, 276)

			UIGradient.Transparency = NumberSequence.new{
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 0),
				NumberSequenceKeypoint.new(0.51, 0.02),
				NumberSequenceKeypoint.new(1, 1)
			}
			UIGradient.Parent = Linesec

			SectionList.Name = "SectionList"
			SectionList.Parent = Section
			SectionList.SortOrder = Enum.SortOrder.LayoutOrder
			SectionList.Padding = UDim.new(0, 5)

			local SizeSectionY
			local sectionIsVisible = false
			if Toggleable then
				local VisibilitySectionFrame = Instance.new("Frame")
				local VisibilitySectionFrameCorner = Instance.new("UICorner")
				local visibility = Instance.new("ImageButton")
				local visibility_off = Instance.new("ImageButton")
				local VisibilityButton = Instance.new("TextButton")
				VisibilityButton.Name = "VisibilityButton"
				VisibilityButton.Parent = Topsec
				VisibilityButton.AnchorPoint = Vector2.new(1, 0.5)
				VisibilityButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				VisibilityButton.BackgroundTransparency = 1.000
				VisibilityButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				VisibilityButton.BorderSizePixel = 0
				VisibilityButton.Font = Enum.Font.SourceSans
				VisibilityButton.Text = ""
				VisibilityButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				VisibilityButton.TextSize = 14.000
				VisibilityButton.ZIndex = 2
				VisibilityButton.Position = UDim2.new(1, -5, 0.5, 0)
				VisibilityButton.Size = UDim2.new(0, 20, 0, 20)
				VisibilitySectionFrame.Name = "VisibilitySectionFrame"
				VisibilitySectionFrame.Parent = Topsec
				VisibilitySectionFrame.AnchorPoint = Vector2.new(1, 0.5)
				VisibilitySectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				VisibilitySectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				VisibilitySectionFrame.BorderSizePixel = 0
				VisibilitySectionFrame.Position = UDim2.new(1, -5, 0.5, 0)
				VisibilitySectionFrame.Size = UDim2.new(0, 20, 0, 20)
				VisibilitySectionFrameCorner.CornerRadius = UDim.new(0, 4)
				VisibilitySectionFrameCorner.Name = "VisibilitySectionFrameCorner"
				VisibilitySectionFrameCorner.Parent = VisibilitySectionFrame
				visibility.Name = "visibility"
				visibility.Parent = VisibilitySectionFrame
				visibility.AnchorPoint = Vector2.new(0.5, 0.5)
				visibility.BackgroundTransparency = 1.000
				visibility.LayoutOrder = 4
				visibility.Position = UDim2.new(0.5, 0, 0.5, 0)
				visibility.Size = UDim2.new(1, -4, 1, -4)
				visibility.ZIndex = 2
				visibility.Image = "rbxassetid://112175659522723"
				visibility.ImageRectOffset = Vector2.new(84, 44)
				visibility.ImageRectSize = Vector2.new(36, 36)
				visibility.ImageTransparency = 1
				visibility_off.Name = "visibility_off"
				visibility_off.Parent = VisibilitySectionFrame
				visibility_off.AnchorPoint = Vector2.new(0.5, 0.5)
				visibility_off.BackgroundTransparency = 1.000
				visibility_off.LayoutOrder = 4
				visibility_off.Position = UDim2.new(0.5, 0, 0.5, 0)
				visibility_off.Size = UDim2.new(1, -4, 1, -4)
				visibility_off.ZIndex = 2
				visibility_off.Image = "rbxassetid://112175659522723"
				visibility_off.ImageRectOffset = Vector2.new(564, 44)
				visibility_off.ImageRectSize = Vector2.new(36, 36)
				visibility_off.ImageTransparency = 0
				VisibilityButton.MouseButton1Down:Connect(function()
					sectionIsVisible = not sectionIsVisible
					TweenService:Create(visibility, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"] / 2), {
						ImageTransparency = sectionIsVisible and 0 or 1
					}):Play()
					wait(getgenv().UIColor["Tween Animation 1 Speed"] / 4)
					TweenService:Create(visibility_off, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"] / 2), {
						ImageTransparency = sectionIsVisible and 1 or 0
					}):Play()
					TweenService:Create(Section, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
						Size =  UDim2.new(1, -5, 0, (sectionIsVisible and SizeSectionY or 30))
					}):Play()
				end)
			end
			if SectionGap then
				local SectionGap = Instance.new("Frame")
				SectionGap.Name = "SectionGap"
				SectionGap.Parent = PageList
				SectionGap.Size = UDim2.new(1, -5, 0, 30)
				SectionGap.ClipsDescendants = true
				SectionGap.Transparency = 1
			end

			SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if (not Toggleable) then
					Section.Size = UDim2.new(1, -5, 0, SectionList.AbsoluteContentSize.Y + 5)
				end
				SizeSectionY = SectionList.AbsoluteContentSize.Y + 5
				if sectionIsVisible then
					TweenService:Create(Section, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
						Size =  UDim2.new(1, -5, 0, SizeSectionY)
					}):Play()
				end
			end)
			local sectionFunction = {}
			function sectionFunction:AddToggle(idk,Setting)
				local Title = tostring(Setting.Text or Setting.Title) or ""
				local Desc = Setting.Desc or Setting.Description
				local Default = Setting.Default
				if Default == nil then
					Default = false
				end
				local Callback = Setting.Callback
				local ToggleFrame = Instance.new("Frame")
				local TogFrame1 = Instance.new("Frame")
				local checkbox = Instance.new("ImageLabel")
				local check = Instance.new("Frame")
				local ToggleDesc = Instance.new("TextLabel")
				local ToggleTitle = Instance.new("TextLabel")
				local ToggleBg = Instance.new("Frame")
				local ToggleCorner = Instance.new("UICorner")
				local ToggleButton = Instance.new("TextButton")
				local ToggleList = Instance.new("UIListLayout")
				ToggleFrame.Name = "ToggleFrame"
				ToggleFrame.Parent = Section
				ToggleFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				ToggleFrame.BackgroundTransparency = 1.000
				ToggleFrame.Position = UDim2.new(0, 0, 0.300000012, 0)
				ToggleFrame.Size = UDim2.new(1, 0 , 0, 0)
				ToggleFrame.AutomaticSize = Enum.AutomaticSize.Y
				TogFrame1.Name = "TogFrame1"
				TogFrame1.Parent = ToggleFrame
				TogFrame1.AnchorPoint = Vector2.new(0.5, 0.5)
				TogFrame1.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				TogFrame1.BackgroundTransparency = 1.000
				TogFrame1.Position = UDim2.new(0.5, 0, 0.5, 0)
				TogFrame1.Size = UDim2.new(1, -10, 0, 0)
				TogFrame1.AutomaticSize = Enum.AutomaticSize.Y
				checkbox.Name = "checkbox"
				checkbox.Parent = TogFrame1
				checkbox.AnchorPoint = Vector2.new(1, 0.5)
				checkbox.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				checkbox.BackgroundTransparency = 1.000
				checkbox.Position = UDim2.new(1, -5, 0.5, 3)
				checkbox.Size = UDim2.new(0, 25, 0, 25)
				checkbox.Image = "rbxassetid://112175659522723"
				checkbox.ImageColor3 = getgenv().UIColor["Toggle Border Color"]
				check.Name = "check"
				check.Parent = checkbox
				check.AnchorPoint = Vector2.new(0.5, 0.5)
				check.BackgroundColor3 = Color3.fromRGB(255, 206, 27)
				check.Position = UDim2.new(0.5, 0, 0.5, 0)
				local cac = 5
				if Desc then
					cac = 0
					ToggleDesc.Name = "ToggleDesc"
					ToggleDesc.Parent = TogFrame1
					ToggleDesc.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
					ToggleDesc.BackgroundTransparency = 1.000
					ToggleDesc.Position = UDim2.new(0, 15, 0, 20)
					ToggleDesc.Size = UDim2.new(1, -50, 0, 0)
					ToggleDesc.Font = Enum.Font.GothamBlack
					ToggleDesc.Text = Desc
					ToggleDesc.TextSize = 13.000
					ToggleDesc.TextWrapped = true
					ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
					ToggleDesc.RichText = true
					ToggleDesc.AutomaticSize = Enum.AutomaticSize.Y
					ToggleDesc.TextColor3 = getgenv().UIColor["Toggle Desc Color"]
				else
					ToggleDesc.Text = ''
				end
				ToggleTitle.Name = "TextColor"
				ToggleTitle.Parent = TogFrame1
				ToggleTitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				ToggleTitle.BackgroundTransparency = 1.000
				ToggleTitle.Position = UDim2.new(0, 10, 0, cac)
				ToggleTitle.Size = UDim2.new(1, -10, 0, 20)
				ToggleTitle.Font = Enum.Font.GothamBlack
				ToggleTitle.Text = Title
				ToggleTitle.TextSize = 14.000
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
				ToggleTitle.TextYAlignment = Enum.TextYAlignment.Center
				ToggleTitle.RichText = true
				ToggleTitle.AutomaticSize = Enum.AutomaticSize.Y
				ToggleTitle.TextColor3 = getgenv().UIColor["Text Color"]
				ToggleBg.Name = "Background1"
				ToggleBg.Parent = TogFrame1
				ToggleBg.Size = UDim2.new(1, 0, 1, 6)
				ToggleBg.ZIndex = 0
				ToggleBg.BackgroundColor3 = getgenv().UIColor["Background 1 Color"]
				ToggleBg.BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"]
				ToggleCorner.CornerRadius = UDim.new(0, 4)
				ToggleCorner.Name = "ToggleCorner"
				ToggleCorner.Parent = ToggleBg
				ToggleButton.Name = "ToggleButton"
				ToggleButton.Parent = TogFrame1
				ToggleButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				ToggleButton.BackgroundTransparency = 1.000
				ToggleButton.AnchorPoint = Vector2.new(1, 0.5)
				ToggleButton.Size = UDim2.new(0, 25, 0, 25)
				ToggleButton.Position = UDim2.new(1, -5, 0.5, 3)
				ToggleButton.Font = Enum.Font.SourceSans
				ToggleButton.Text = ""
				ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.TextSize = 14.000
				ToggleList.Name = "ToggleList"
				ToggleList.Parent = ToggleFrame
				ToggleList.HorizontalAlignment = Enum.HorizontalAlignment.Center
				ToggleList.SortOrder = Enum.SortOrder.LayoutOrder
				ToggleList.VerticalAlignment = Enum.VerticalAlignment.Center
				ToggleList.Padding = UDim.new(0, 5)
				local function ChangeStage(val)
					local csize = val and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0, 0, 0, 0)
					local pos = val and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 0.5, 0)
					local apos = val and Vector2.new(0.5, 0.5) or Vector2.new(0.5, 0.5)
					game.TweenService:Create(check, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
						Size = csize,
						Position = pos,
						AnchorPoint = apos
					}):Play()
				end
				ChangeStage(Default)
				local function ButtonClick()
					Default = not Default
				    ChangeStage(Default)
				    if Callback then
				        pcall(Callback, Default)
				    end
				end
				ToggleButton.MouseButton1Down:Connect(function()
					ButtonClick()
				end)
				local toggleFunction = {}
				function toggleFunction.SetStage(value)
					if value ~= Default then
						ButtonClick()
					end
				end
				local controlData = {
                    Name = Title,
                    Section = Section,
                    Element = ToggleFrame,
                    SectionName = Section_Name,
                    TabName = Page_Name,
                    TabButton = PageName
                }
                table.insert(getgenv().AllControls, controlData)
                
				return toggleFunction
			end
        function sectionFunction:AddButton(Setting, Callback)
        	local Title = Setting.Title or Setting.Text or ""
        	local Callback = Setting.Callback or Setting.Func or function() end
            local Button = Instance.new("Frame")
            local RowBG_1 = Instance.new("Frame")
            local UICorner_1 = Instance.new("UICorner")
            local RowHover_1 = Instance.new("Frame")
            local UICorner_2 = Instance.new("UICorner")
            local TextColor_1 = Instance.new("TextLabel")
            local ClickArea_1 = Instance.new("Frame")
            local UICorner_3 = Instance.new("UICorner")
            local UIGradient_1 = Instance.new("UIGradient")
            local ImageLabel_1 = Instance.new("ImageLabel")
            local Frame_1 = Instance.new("Frame")
            local UICorner_4 = Instance.new("UICorner")
            local UIScale_1 = Instance.new("UIScale")
            local Button_1 = Instance.new("TextButton")
            
            Button.Name = "Button"
            Button.Parent = Section
            Button.BackgroundColor3 = Color3.fromRGB(163,162,165)
            Button.BackgroundTransparency = 1
            Button.Size = UDim2.new(1, 0,0, 40)
             
            RowBG_1.Name = "RowBG"
            RowBG_1.Parent = Button
            RowBG_1.AnchorPoint = Vector2.new(0.5, 0.5)
            RowBG_1.BackgroundColor3 = getgenv().UIColor["Background 1 Color"]
            RowBG_1.BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"]
            RowBG_1.Position = UDim2.new(0.5, 0,0.5, 0)
            RowBG_1.Size = UDim2.new(1, -10,1, 0)
             
            UICorner_1.Parent = RowBG_1
            UICorner_1.CornerRadius = UDim.new(0,10)
             
            RowHover_1.Name = "RowHover"
            RowHover_1.Parent = RowBG_1
            RowHover_1.BackgroundColor3 = getgenv().UIColor["Background 2 Color"]
            RowHover_1.BackgroundTransparency = 1
            RowHover_1.Size = UDim2.new(1, 0,1, 0)
            RowHover_1.ZIndex = 2
             
            UICorner_2.Parent = RowHover_1
            UICorner_2.CornerRadius = UDim.new(0,10)
             
            TextColor_1.Name = "TextColor"
            TextColor_1.Parent = RowBG_1
             TextColor_1.BackgroundColor3 = Color3.fromRGB(163,162,165)
             TextColor_1.BackgroundTransparency = 1
             TextColor_1.Position = UDim2.new(0, 12,0, 0)
             TextColor_1.Size = UDim2.new(1, -110,1, 0)
             TextColor_1.Font = Enum.Font.GothamBold
             TextColor_1.Text = Title
             TextColor_1.TextColor3 = getgenv().UIColor["GUI Text Color"]
             TextColor_1.TextSize = 14
             TextColor_1.TextStrokeTransparency = 0.8500000238418579
             TextColor_1.TextXAlignment = Enum.TextXAlignment.Left
             
             ClickArea_1.Name = "ClickArea"
             ClickArea_1.Parent = RowBG_1
             ClickArea_1.AnchorPoint = Vector2.new(1, 0.5)
             ClickArea_1.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
             ClickArea_1.Position = UDim2.new(1, -8,0.5, 0)
             ClickArea_1.Size = UDim2.new(0, 94,0, 30)
             ClickArea_1.ClipsDescendants = true  -- THÊM DÒNG NÀY: Ngăn ripple tràn ra
             
             UICorner_3.Parent = ClickArea_1
             UICorner_3.CornerRadius = UDim.new(0,12)
             
             UIGradient_1.Parent = ClickArea_1
             UIGradient_1.Color = ColorSequence.new{
                 ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 216, 77)), 
                 ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 206, 27)), 
                 ColorSequenceKeypoint.new(0.6, Color3.fromRGB(235, 186, 17)), 
                 ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 166, 7))
             }
             UIGradient_1.Rotation = 90
             
             ImageLabel_1.Parent = ClickArea_1
             ImageLabel_1.AnchorPoint = Vector2.new(0.5, 0.5)
             ImageLabel_1.BackgroundColor3 = Color3.fromRGB(163,162,165)
             ImageLabel_1.BackgroundTransparency = 1
             ImageLabel_1.Position = UDim2.new(0.5, 0,0.5, 0)
             ImageLabel_1.Size = UDim2.new(1, 14,1, 14)
             ImageLabel_1.ZIndex = 0
             ImageLabel_1.Image = "rbxassetid://112175659522723"
             ImageLabel_1.ImageTransparency = 0.7
             ImageLabel_1.ScaleType = Enum.ScaleType.Slice
             ImageLabel_1.SliceCenter = Rect.new(24, 24, 276, 276)
             
             Frame_1.Parent = ClickArea_1
             Frame_1.AnchorPoint = Vector2.new(0.5, 0)
             Frame_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
             Frame_1.BackgroundTransparency = 0.8
             Frame_1.Position = UDim2.new(0.5, 0,0, 2)
             Frame_1.Size = UDim2.new(1, -6,0, 10)
             Frame_1.ZIndex = 2
             
             UICorner_4.Parent = Frame_1
             UICorner_4.CornerRadius = UDim.new(0,10)
             
             UIScale_1.Parent = ClickArea_1
             
             Button_1.Name = "Button"
             Button_1.Parent = ClickArea_1
             Button_1.Active = true
             Button_1.AutoButtonColor = false
             Button_1.BackgroundColor3 = Color3.fromRGB(163,162,165)
             Button_1.BackgroundTransparency = 1
             Button_1.Size = UDim2.new(1, 0,1, 0)
             Button_1.Font = Enum.Font.GothamBold
             Button_1.Text = "Click"
             Button_1.TextColor3 = Color3.fromRGB(240, 240, 240)
             Button_1.TextSize = 13

             -- UIScale mặc định
             UIScale_1.Scale = 1
             
             -- HOVER (chỉ phóng to)
             local scaleHover = TweenService:Create(UIScale_1, TweenInfo.new(0.12, Enum.EasingStyle.Sine), { Scale = 1.05 })
             local scaleNormal = TweenService:Create(UIScale_1, TweenInfo.new(0.12, Enum.EasingStyle.Sine), { Scale = 1 })
             
             Button_1.MouseEnter:Connect(function()
             	scaleHover:Play()
             end)
             
             Button_1.MouseLeave:Connect(function()
             	scaleNormal:Play()
             end)
             
                Button_1.MouseButton1Down:Connect(function()
                    
                    -- Lấy kích thước thực tế của ClickArea
                    local w = ClickArea_1.AbsoluteSize.X
                    local h = ClickArea_1.AbsoluteSize.Y
                    
                    -- Tạo ripple với hình dạng bo góc giống button (chữ nhật bo góc)
                    local ripple = Instance.new("Frame")
                    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
                    ripple.Size = UDim2.new(0, 0, 0, 0)
                    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    ripple.BackgroundTransparency = 0.6
                    ripple.ZIndex = 20
                    ripple.Parent = ClickArea_1
                    
                    -- Tạo UICorner cho ripple với bo góc y hệt button
                    local rippleCorner = Instance.new("UICorner")
                    rippleCorner.CornerRadius = UICorner_3.CornerRadius -- Lấy góc bo từ button
                    rippleCorner.Parent = ripple
                    
                    -- Animation ripple mở rộng từ tâm ra đầy đủ button
                    local rippleTween = TweenService:Create(
                        ripple,
                        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0.5, 0, 0.5, 0)
                        }
                    )
                    
                    rippleTween:Play()
                    rippleTween.Completed:Connect(function()
                        ripple:Destroy()
                    end)
                    
                    Callback()
                end)
                local f = {}
                function f:SetTitle(vl)
                    TextColor_1.Text = vl
                end
                local controlData = {
                    Name = Title,
                    Section = Section,
                    Element = Button,
                    SectionName = Section_Name,
                    TabName = Page_Name,
                    TabButton = PageName
                }
                table.insert(getgenv().AllControls, controlData)
                
                return f
            end
        
			function sectionFunction:AddLabel(text)
				local Title = text
                local LabelFrame = Instance.new("Frame")
                local LabelBG = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local TextColor = Instance.new("TextLabel")
                
                LabelFrame.Name = "LabelFrame"
                LabelFrame.Parent = Section
                LabelFrame.AutomaticSize = Enum.AutomaticSize.Y
                LabelFrame.BackgroundColor3 = Color3.fromRGB(163,162,165)
                LabelFrame.BackgroundTransparency = 1
                LabelFrame.Size = UDim2.new(1, 0,0, 0)
                
                LabelBG.Name = "LabelBG"
                LabelBG.Parent = LabelFrame
                LabelBG.AnchorPoint = Vector2.new(0.5, 0)
                LabelBG.AutomaticSize = Enum.AutomaticSize.Y
                LabelBG.BackgroundColor3 = Color3.fromRGB(38,38,46)
                LabelBG.BackgroundTransparency = 0.25
                LabelBG.Position = UDim2.new(0.5, 0,0, 0)
                LabelBG.Size = UDim2.new(1, -10,0, -10)
                
                UICorner.Parent = LabelBG
                UICorner.CornerRadius = UDim.new(0,6)
                
                
                TextColor.Name = "TextColor"
                TextColor.Parent = LabelBG
                TextColor.AutomaticSize = Enum.AutomaticSize.Y
                TextColor.BackgroundColor3 = Color3.fromRGB(163,162,165)
                TextColor.BackgroundTransparency = 1
                TextColor.Position = UDim2.new(0, 12,0, 6)
                TextColor.Size = UDim2.new(1, -24,1, -12)
                TextColor.Font = Enum.Font.GothamMedium
                TextColor.Text = Title
                TextColor.TextColor3 = Color3.fromRGB(240,240,230)
                TextColor.TextSize = 14
                TextColor.TextStrokeTransparency = 0.8500000238418579
                TextColor.TextWrapped = true
                TextColor.TextXAlignment = Enum.TextXAlignment.Left
				local labelFunction = {}
				function labelFunction:SetText(text)
					TextColor.Text = text
				end
				function labelFunction.SetColor(color)
					TextColor.TextColor3 = color
				end
				local controlData = {
                    Name = Title,
                    Section = Section,
                    Element = LabelFrame,
                    SectionName = Section_Name,
                    TabName = Page_Name,
                    TabButton = PageName
                }
                table.insert(getgenv().AllControls, controlData)
                
				return labelFunction
			end
            function sectionFunction:AddDropdownSection(Setting)
                local Title = tostring(Setting.Text or Setting.Title or "")
                local Search = Setting.Search or false
              
                local DropdownFrame = Instance.new("Frame")
                local Dropdownbg = Instance.new("Frame")
                local Dropdowncorner = Instance.new("UICorner")
                local Topdrop = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local ImgDrop = Instance.new("ImageLabel")
                local DropdownButton = Instance.new("TextButton")
                local Dropdownlisttt = Instance.new("Frame")
                local DropdownScroll = Instance.new("ScrollingFrame")
                local ScrollContainer = Instance.new("Frame")
                local ScrollContainerList = Instance.new("UIListLayout")
                
                DropdownFrame.Name = Title .. "DropdownSectionFrame"
                DropdownFrame.Parent = Section
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                DropdownFrame.BackgroundTransparency = 1.000
                DropdownFrame.Position = UDim2.new(0, 0, 0.473684222, 0)
                DropdownFrame.Size = UDim2.new(1, 0, 0, 25)
                
                Dropdownbg.Name = "Background1"
                Dropdownbg.Parent = DropdownFrame
                Dropdownbg.AnchorPoint = Vector2.new(0.5, 0.5)
                Dropdownbg.Position = UDim2.new(0.5, 0, 0.5, 0)
                Dropdownbg.Size = UDim2.new(1, -10, 1, 0)
                Dropdownbg.ClipsDescendants = true
                Dropdownbg.BackgroundColor3 = getgenv().UIColor["Background 1 Color"]
                Dropdownbg.BackgroundTransparency = 0.25
                
                Dropdowncorner.CornerRadius = UDim.new(0, 4)
                Dropdowncorner.Name = "Dropdowncorner"
                Dropdowncorner.Parent = Dropdownbg
                
                Topdrop.Name = "Background2"
                Topdrop.Parent = Dropdownbg
                Topdrop.Size = UDim2.new(1, 0, 0, 25)
                Topdrop.BackgroundColor3 = getgenv().UIColor["Background 2 Color"]
                Topdrop.BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"]
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Topdrop
                
                local Dropdowntitle
                if Search then
                    Dropdowntitle = Instance.new("TextBox")
                    Dropdowntitle.PlaceholderText = Title
                    Dropdowntitle.PlaceholderColor3 = getgenv().UIColor["Placeholder Text Color"]
                else
                    Dropdowntitle = Instance.new("TextLabel")
                    Dropdowntitle.Text = Title
                end
                
                Dropdowntitle.Name = "TextColorPlaceholder"
                Dropdowntitle.Parent = Topdrop
                Dropdowntitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                Dropdowntitle.BackgroundTransparency = 1.000
                Dropdowntitle.Position = UDim2.new(0, 10, 0, 0)
                Dropdowntitle.Size = UDim2.new(1, -40, 1, 0)
                Dropdowntitle.Font = Enum.Font.GothamBlack
                Dropdowntitle.TextSize = 14.000
                Dropdowntitle.TextXAlignment = Enum.TextXAlignment.Left
                Dropdowntitle.ClipsDescendants = true
                Dropdowntitle.TextColor3 = getgenv().UIColor["Text Color"]
                
                ImgDrop.Name = "ImgDrop"
                ImgDrop.Parent = Topdrop
                ImgDrop.AnchorPoint = Vector2.new(1, 0.5)
                ImgDrop.BackgroundTransparency = 1.000
                ImgDrop.BorderColor3 = Color3.fromRGB(27, 42, 53)
                ImgDrop.Position = UDim2.new(1, -6, 0.5, 0)
                ImgDrop.Size = UDim2.new(0, 15, 0, 15)
                ImgDrop.Image = "rbxassetid://112175659522723"
                ImgDrop.ImageColor3 = getgenv().UIColor["Dropdown Icon Color"]
                
                DropdownButton.Name = "DropdownButton"
                DropdownButton.Parent = Topdrop
                DropdownButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                DropdownButton.BackgroundTransparency = 1.000
                DropdownButton.Size = Search and UDim2.new(0, 30, 0, 30) or UDim2.new(1, 0, 1 , 0)
                DropdownButton.Position = Search and UDim2.new(1, -35, 0, 0) or UDim2.new(0 , 0 , 0 , 0)
                DropdownButton.Font = Enum.Font.GothamBold
                DropdownButton.Text = ""
                DropdownButton.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropdownButton.TextSize = 14.000
                
                Dropdownlisttt.Name = "Dropdownlisttt"
                Dropdownlisttt.Parent = Dropdownbg
                Dropdownlisttt.BackgroundTransparency = 1.000
                Dropdownlisttt.BorderSizePixel = 0
                Dropdownlisttt.Position = UDim2.new(0, 0, 0, 25)
                Dropdownlisttt.Size = UDim2.new(1, 0, 0, 0)
                Dropdownlisttt.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                
                DropdownScroll.Name = "DropdownScroll"
                DropdownScroll.Parent = Dropdownlisttt
                DropdownScroll.Active = true
                DropdownScroll.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                DropdownScroll.BackgroundTransparency = 1.000
                DropdownScroll.BorderSizePixel = 0
                DropdownScroll.Size = UDim2.new(1, 0, 1, 0)
                DropdownScroll.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
                DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
                DropdownScroll.ScrollBarThickness = 5
                DropdownScroll.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
                DropdownScroll.ScrollingEnabled = true
                DropdownScroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
                
                ScrollContainer.Name = "ScrollContainer"
                ScrollContainer.Parent = DropdownScroll
                ScrollContainer.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                ScrollContainer.BackgroundTransparency = 1.000
                ScrollContainer.Position = UDim2.new(0, 5, 0, 5)
                ScrollContainer.Size = UDim2.new(1, -15, 1, -5)
                
                ScrollContainerList.Name = "ScrollContainerList"
                ScrollContainerList.Parent = ScrollContainer
                ScrollContainerList.SortOrder = Enum.SortOrder.LayoutOrder
                ScrollContainerList.Padding = UDim.new(0, 5)
                
                -- Tạo internal section để chứa các control
                local InternalSection = Instance.new("Frame")
                InternalSection.Name = "InternalSection"
                InternalSection.Parent = ScrollContainer
                InternalSection.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                InternalSection.BackgroundTransparency = 1.000
                InternalSection.Size = UDim2.new(1, 0, 0, 0)
                InternalSection.AutomaticSize = Enum.AutomaticSize.Y
                
                local InternalList = Instance.new("UIListLayout")
                InternalList.Name = "InternalList"
                InternalList.Parent = InternalSection
                InternalList.SortOrder = Enum.SortOrder.LayoutOrder
                InternalList.Padding = UDim.new(0, 5)
                
                local isOpen = false
                
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    
                    local listsize = isOpen and UDim2.new(1, 0, 0, 200) or UDim2.new(1, 0, 0, 0)
                    local mainsize = isOpen and UDim2.new(1, 0, 0, 230) or UDim2.new(1, 0, 0, 25)
                    local DropCRotation = isOpen and 90 or 0
                    
                    TweenService:Create(Dropdownlisttt, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
                        Size = listsize
                    }):Play()
                    TweenService:Create(DropdownFrame, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
                        Size = mainsize
                    }):Play()
                    TweenService:Create(ImgDrop, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
                        Rotation = DropCRotation
                    }):Play()
                end)
                
                ScrollContainerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 10 + ScrollContainerList.AbsoluteContentSize.Y + 5)
                end)
                
                InternalList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    local contentHeight = math.min(InternalList.AbsoluteContentSize.Y + 10, 300)
                    local listsize = isOpen and UDim2.new(1, 0, 0, contentHeight) or UDim2.new(1, 0, 0, 0)
                    local mainsize = isOpen and UDim2.new(1, 0, 0, contentHeight + 25) or UDim2.new(1, 0, 0, 25)
                    
                    if isOpen then
                        TweenService:Create(Dropdownlisttt, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
                            Size = listsize
                        }):Play()
                        TweenService:Create(DropdownFrame, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
                            Size = mainsize
                        }):Play()
                    end
                end)
                
                -- Tạo dropdown section functions (CHỈ CÓ SLIDER)
                local dropdownSectionFunction = {}
                
                -- HÀM TẠO SLIDER (RỘNG HƠN, SÁT VIỀN)
                function dropdownSectionFunction:AddSlider(Setting)
                    local TitleText = tostring(Setting.Text or Setting.Title) or ""
                    local minValue = tonumber(Setting.Min) or 0
                    local maxValue = tonumber(Setting.Max) or 100
                    local Precise = Setting.Precise or false
                    local DefaultValue = tonumber(Setting.Default) or 0
                    local Callback = Setting.Callback
                    local Rounding = Setting.Rouding or Setting.Rounding
                    
                    local SliderFrame = Instance.new("Frame")
                    local SliderCorner = Instance.new("UICorner")
                    local SliderBG = Instance.new("Frame")
                    local SliderBGCorner = Instance.new("UICorner")
                    local SliderTitle = Instance.new("TextLabel")
                    local SliderBar = Instance.new("Frame")
                    local SliderButton = Instance.new("TextButton")
                    local SliderBarCorner = Instance.new("UICorner")
                    local Bar = Instance.new("Frame")
                    local BarCorner = Instance.new("UICorner")
                    local Sliderboxframe = Instance.new("Frame")
                    local Sliderbox = Instance.new("UICorner")
                    local Sliderbox_2 = Instance.new("TextBox")
                    
                    SliderFrame.Name = TitleText
                    SliderFrame.Parent = InternalSection
                    SliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    SliderFrame.BackgroundTransparency = 1.000
                    SliderFrame.Size = UDim2.new(1, 0, 0, 50)  -- Chiếm toàn bộ chiều rộng
                    
                    SliderCorner.CornerRadius = UDim.new(0, 4)
                    SliderCorner.Name = "SliderCorner"
                    SliderCorner.Parent = SliderFrame
                    
                    SliderBG.Name = "Background1"
                    SliderBG.Parent = SliderFrame
                    SliderBG.AnchorPoint = Vector2.new(0.5, 0.5)
                    SliderBG.Position = UDim2.new(0.5, 0, 0.5, 0)
                    SliderBG.Size = UDim2.new(1, -5, 1, 0)  -- Chiếm gần toàn bộ (trừ 5 pixel)
                    SliderBG.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
                    SliderBG.BackgroundTransparency = 0.25
                    
                    SliderBGCorner.CornerRadius = UDim.new(0, 4)
                    SliderBGCorner.Name = "SliderBGCorner"
                    SliderBGCorner.Parent = SliderBG
                    
                    SliderTitle.Name = "TextColor"
                    SliderTitle.Parent = SliderBG
                    SliderTitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                    SliderTitle.BackgroundTransparency = 1.000
                    SliderTitle.Position = UDim2.new(0, 10, 0, 0)
                    SliderTitle.Size = UDim2.new(0.65, -10, 0, 25)  -- Title chiếm 65%
                    SliderTitle.Font = Enum.Font.GothamBlack
                    SliderTitle.Text = TitleText
                    SliderTitle.TextSize = 14.000
                    SliderTitle.RichText = true
                    SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                    SliderTitle.TextColor3 = getgenv().UIColor["Text Color"]
                    
                    SliderBar.Name = "SliderBar"
                    SliderBar.Parent = SliderFrame
                    SliderBar.AnchorPoint = Vector2.new(0.5, 0.5)
                    SliderBar.Position = UDim2.new(0.5, 0, 0.5, 14)
                    SliderBar.Size = UDim2.new(0.9, 0, 0, 6)  -- Thanh slider rộng 90%
                    SliderBar.BackgroundColor3 = getgenv().UIColor["Background 2 Color"]
                    
                    SliderButton.Name = "SliderButton"
                    SliderButton.Parent = SliderBar
                    SliderButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                    SliderButton.BackgroundTransparency = 1.000
                    SliderButton.Size = UDim2.new(1, 0, 1, 0)
                    SliderButton.Font = Enum.Font.GothamBold
                    SliderButton.Text = ""
                    SliderButton.TextColor3 = Color3.fromRGB(230, 230, 230)
                    SliderButton.TextSize = 14.000
                    
                    SliderBarCorner.CornerRadius = UDim.new(1, 0)
                    SliderBarCorner.Name = "SliderBarCorner"
                    SliderBarCorner.Parent = SliderBar
                    
                    Bar.Name = "Bar"
                    Bar.BorderSizePixel = 0
                    Bar.Parent = SliderBar
                    Bar.Size = UDim2.new(0, 0, 1, 0)
                    Bar.BackgroundColor3 = getgenv().UIColor["Slider Line Color"]
                    
                    BarCorner.CornerRadius = UDim.new(1, 0)
                    BarCorner.Name = "BarCorner"
                    BarCorner.Parent = Bar
                    
                    Sliderboxframe.Name = "Background2"
                    Sliderboxframe.Parent = SliderFrame
                    Sliderboxframe.AnchorPoint = Vector2.new(1, 0)
                    Sliderboxframe.Position = UDim2.new(1, -10, 0, 5)
                    Sliderboxframe.Size = UDim2.new(0.25, 0, 0, 25)  -- Textbox chiếm 25%
                    Sliderboxframe.BackgroundColor3 = getgenv().UIColor["Background 2 Color"]
                    
                    Sliderbox.CornerRadius = UDim.new(0, 4)
                    Sliderbox.Name = "Sliderbox"
                    Sliderbox.Parent = Sliderboxframe
                    
                    Sliderbox_2.Name = "TextColor"
                    Sliderbox_2.Parent = Sliderboxframe
                    Sliderbox_2.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                    Sliderbox_2.BackgroundTransparency = 1.000
                    Sliderbox_2.Size = UDim2.new(1, 0, 1, 0)
                    Sliderbox_2.Font = Enum.Font.GothamBold
                    Sliderbox_2.Text = ""
                    Sliderbox_2.TextSize = 14.000
                    Sliderbox_2.TextColor3 = getgenv().UIColor["Text Color"]
                    
                    SliderButton.MouseEnter:Connect(function()
                        TweenService:Create(Bar, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
                            BackgroundColor3 = getgenv().UIColor["Slider Highlight Color"]
                        }):Play()
                    end)
                    
                    SliderButton.MouseLeave:Connect(function()
                        TweenService:Create(Bar, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
                            BackgroundColor3 = getgenv().UIColor["Slider Line Color"]
                        }):Play()
                    end)
                    
                    local callBackAndSetText = function(val)
                        Sliderbox_2.Text = tostring(val)
                        Callback(tonumber(val))
                    end
                    if DefaultValue then
                        if DefaultValue <= minValue then
                            DefaultValue = minValue
                        elseif DefaultValue >= maxValue then
                            DefaultValue = maxValue
                        end
                        Bar.Size = UDim2.new(1 - ((maxValue - DefaultValue) / (maxValue - minValue)), 0, 0, 6)
                        Sliderbox_2.Text = tostring(DefaultValue)
                    end
                    
                    
                    local dragging = false
                    local dragInput
                    local holdTime = 0
                    local holdStarted = 0
                    
                    local function onInputBegan(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            holdStarted = tick()
                            
                            input.Changed:Connect(function()
                                if input.UserInputState == Enum.UserInputState.End then
                                    dragging = false
                                    holdStarted = 0
                                end
                            end)
                        end
                    end
                    
                    local function onInputEnded(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                            holdStarted = 0
                        end
                    end
                    
                    local function onInputChanged(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                            dragInput = input
                        end
                    end
                    
                    SliderButton.InputBegan:Connect(onInputBegan)
                    SliderButton.InputEnded:Connect(onInputEnded)
                    SliderButton.InputChanged:Connect(onInputChanged)
                    
                    RunService.RenderStepped:Connect(function()
                        if holdStarted > 0 and (tick() - holdStarted >= holdTime) and not dragging then
                            dragging = true
                        end
                        
                        if dragging and dragInput then
                            local barWidth = math.clamp(dragInput.Position.X - Bar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
                            local percentage = barWidth / SliderBar.AbsoluteSize.X
                            local value = minValue + (maxValue - minValue) * percentage
                            
                            if Rounding then
                                value = tonumber(string.format("%.".. Rounding .."f", value))
                            elseif not Precise then
                                value = math.floor(value)
                            end
                            
                            value = math.clamp(value, minValue, maxValue)
                            
                            pcall(function()
                                callBackAndSetText(value)
                            end)
                            Bar.Size = UDim2.new(percentage, 0, 1, 0)
                        end
                    end)
                    
                    local function GetSliderValue(Value)
                        Value = tonumber(Value) or minValue
                        Value = math.clamp(Value, minValue, maxValue)
                        
                        if Rounding then
                            Value = tonumber(string.format("%.".. Rounding .."f", Value))
                        elseif not Precise then
                            Value = math.floor(Value)
                        end
                        
                        local percentage = (Value - minValue) / (maxValue - minValue)
                        Bar.Size = UDim2.new(percentage, 0, 1, 0)
                        callBackAndSetText(Value)
                    end
                    
                    Sliderbox_2.FocusLost:Connect(function()
                        GetSliderValue(Sliderbox_2.Text)
                    end)
                    
                    local slider_function = {}
                    function slider_function.SetValue(Value)
                        GetSliderValue(Value)
                    end
                    
                    function slider_function.GetValue()
                        return tonumber(Sliderbox_2.Text) or minValue
                    end
                    
                    return slider_function
                end
                
                function dropdownSectionFunction:SetOpen(state)
                    if state ~= isOpen then
                        DropdownButton.MouseButton1Click:Fire()
                    end
                end
                
                function dropdownSectionFunction:GetOpen()
                    return isOpen
                end
                
                function dropdownSectionFunction:SetTitle(newTitle)
                    if Search then
                        Dropdowntitle.PlaceholderText = newTitle
                    else
                        Dropdowntitle.Text = newTitle
                    end
                end
                
                local controlData = {
                    Name = Title,
                    Section = Section,
                    Element = DropdownFrame,
                    SectionName = Section_Name,
                    TabName = Page_Name,
                    TabButton = PageName
                }
                table.insert(getgenv().AllControls, controlData)
                
                return dropdownSectionFunction
            end
            
			function sectionFunction:AddDropdown(idk, Setting)
				local Title = tostring(Setting.Text or Setting.Title) or ""
				local List = Setting.Values
				local Search = Setting.Search or false
				local Selected = Setting.Selected or Setting.Multi or false
				local Slider = Setting.Slider or false
				local SliderRelease = Setting.SliderRelease or false
				local Default = (function ()
                    if Setting.Default then
                        if type(Setting.Default) == "number" then
                            return List[Setting.Default]
                        elseif type(Setting.Default) == "string" then
                            return Setting.Default
                        end
                    end
                    return nil
                end)()
				local Callback = Setting.Callback
				local pairs = Setting.SortPairs or pairs
				local DropdownFrame = Instance.new("Frame")
				local Dropdownbg = Instance.new("Frame")
				local Dropdowncorner = Instance.new("UICorner")
				local Topdrop = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local ImgDrop = Instance.new("ImageLabel")
				local DropdownButton = Instance.new("TextButton")
				local Dropdownlisttt = Instance.new("Frame")
				local DropdownScroll = Instance.new("ScrollingFrame")
				local ScrollContainer = Instance.new("Frame")
				local ScrollContainerList = Instance.new("UIListLayout")
				local dropdownLeave = false
				local Dropdowntitle;
				if Search then
					Dropdowntitle = Instance.new("TextBox")
				else
					Dropdowntitle = Instance.new("TextLabel")
				end
				DropdownFrame.Name = Title .. "DropdownFrame"
				DropdownFrame.Parent = Section
				DropdownFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				DropdownFrame.BackgroundTransparency = 1.000
				DropdownFrame.Position = UDim2.new(0, 0, 0.473684222, 0)
				DropdownFrame.Size = UDim2.new(1, 0, 0, 25)
				Dropdownbg.Name = "Background1"
				Dropdownbg.Parent = DropdownFrame
				Dropdownbg.AnchorPoint = Vector2.new(0.5, 0.5)
				Dropdownbg.Position = UDim2.new(0.5, 0, 0.5, 0)
				Dropdownbg.Size = UDim2.new(1, -10, 1, 0)
				Dropdownbg.ClipsDescendants = true
				Dropdownbg.BackgroundColor3 = getgenv().UIColor["Background 1 Color"]
				Dropdownbg.BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"]
				Dropdowncorner.CornerRadius = UDim.new(0, 4)
				Dropdowncorner.Name = "Dropdowncorner"
				Dropdowncorner.Parent = Dropdownbg
				Topdrop.Name = "Background2"
				Topdrop.Parent = Dropdownbg
				Topdrop.Size = UDim2.new(1, 0, 0, 25)
				Topdrop.BackgroundColor3 = getgenv().UIColor["Background 2 Color"]
				Topdrop.BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"]
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = Topdrop
				Dropdowntitle.Name = "TextColorPlaceholder"
				Dropdowntitle.Parent = Topdrop
				Dropdowntitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				Dropdowntitle.BackgroundTransparency = 1.000
				Dropdowntitle.Position = UDim2.new(0, 10, 0, 0)
				Dropdowntitle.Size = UDim2.new(1, -40, 1, 0)
				Dropdowntitle.Font = Enum.Font.GothamBlack
				Dropdowntitle.Text = ''
				Dropdowntitle.TextSize = 14.000
				Dropdowntitle.TextXAlignment = Enum.TextXAlignment.Left
				Dropdowntitle.ClipsDescendants = true
				local Sel = Instance.new("StringValue", Dropdowntitle)
				Sel.Value = ""
				if Default and table.find(List, Default) then
					Sel.Value = Default
				end
				if not Selected then
					if Search then
						Dropdowntitle.PlaceholderColor3 = getgenv().UIColor["Placeholder Text Color"]
						Dropdowntitle.PlaceholderText = Title .. ': ' .. tostring(Default or "");
					else
						Dropdowntitle.Text = Title .. ': ' .. tostring(Default or "");
					end
				else
					if Search then
						Dropdowntitle.PlaceholderColor3 = getgenv().UIColor["Placeholder Text Color"]
						Dropdowntitle.PlaceholderText = Title .. ': ' .. tostring(Default or "");
					else
						Dropdowntitle.Text = Title .. ': ' .. tostring(Default or "");
					end
				end
				Dropdowntitle.TextColor3 = getgenv().UIColor["Text Color"]
				ImgDrop.Name = "ImgDrop"
				ImgDrop.Parent = Topdrop
				ImgDrop.AnchorPoint = Vector2.new(1, 0.5)
				ImgDrop.BackgroundTransparency = 1.000
				ImgDrop.BorderColor3 = Color3.fromRGB(27, 42, 53)
				ImgDrop.Position = UDim2.new(1, -6, 0.5, 0)
				ImgDrop.Size = UDim2.new(0, 15, 0, 15)
				ImgDrop.Image = "rbxassetid://112175659522723"
				ImgDrop.ImageColor3 = getgenv().UIColor["Dropdown Icon Color"]
				DropdownButton.Name = "DropdownButton"
				DropdownButton.Parent = Topdrop
				DropdownButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				DropdownButton.BackgroundTransparency = 1.000
				DropdownButton.Size = Search and UDim2.new(0, 30, 0, 30) or UDim2.new(1, 0, 1 , 0)
				DropdownButton.Position = Search and UDim2.new(1, -35, 0, 0) or UDim2.new(0 , 0 , 0 , 0)
				DropdownButton.Font = Enum.Font.GothamBold
				DropdownButton.Text = ""
				DropdownButton.TextColor3 = Color3.fromRGB(230, 230, 230)
				DropdownButton.TextSize = 14.000
				Dropdownlisttt.Name = "Dropdownlisttt"
				Dropdownlisttt.Parent = Dropdownbg
				Dropdownlisttt.BackgroundTransparency = 1.000
				Dropdownlisttt.BorderSizePixel = 0
				Dropdownlisttt.Position = UDim2.new(0, 0, 0, 25)
				Dropdownlisttt.Size = UDim2.new(1, 0, 0, 25)
				Dropdownlisttt.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				DropdownScroll.Name = "DropdownScroll"
				DropdownScroll.Parent = Dropdownlisttt
				DropdownScroll.Active = true
				DropdownScroll.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				DropdownScroll.BackgroundTransparency = 1.000
				DropdownScroll.BorderSizePixel = 0
				DropdownScroll.Size = UDim2.new(1, 0, 1, 0)
				DropdownScroll.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
				DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
				DropdownScroll.ScrollBarThickness = 5
				DropdownScroll.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
				DropdownScroll.ScrollingEnabled = true
				DropdownScroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
				ScrollContainer.Name = "ScrollContainer"
				ScrollContainer.Parent = DropdownScroll
				ScrollContainer.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				ScrollContainer.BackgroundTransparency = 1.000
				ScrollContainer.Position = UDim2.new(0, 5, 0, 5)
				ScrollContainer.Size = UDim2.new(1, -15, 1, -5)
				ScrollContainerList.Name = "ScrollContainerList"
				ScrollContainerList.Parent = ScrollContainer
				ScrollContainerList.SortOrder = Enum.SortOrder.LayoutOrder
				ScrollContainerList.Padding = UDim.new(0, 5)
				ScrollContainerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 10 + ScrollContainerList.AbsoluteContentSize.Y + 5)
				end)
				local isbusy = false
				local found = {}
				local searchtable = {}
				local function edit()
					for i in pairs(found) do
						found[i] = nil
					end
					for h, l in pairs(ScrollContainer:GetChildren()) do
						if not l:IsA("UIListLayout") and not l:IsA("UIPadding") and not l:IsA('UIGridLayout') then
							l.Visible = false
						end
					end
					Dropdowntitle.Text = string.lower(Dropdowntitle.Text)
				end
				local function SearchDropdown()
					local Results = {}
					for i, v in pairs(searchtable) do
						if string.find(v, Dropdowntitle.Text) then
							table.insert(found, v)
						end
					end
					for a, b in pairs(ScrollContainer:GetChildren()) do
						for c, d in pairs(found) do
							if d == b.Name then
								b.Visible = true
							end
						end
					end
				end
				local function clear_object_in_list()
					for i, v in next, ScrollContainer:GetChildren() do
						if v:IsA('Frame') then
							v:Destroy()
						end
					end
				end
				local ListNew
                local OrderedList = {} -- Thêm biến lưu thứ tự
                if Selected then
                    ListNew = {}
                    for _, value in ipairs(List) do
                        -- Kiểm tra nếu value trùng với Default thì set true
                        ListNew[value] = (value == Default)
                        table.insert(OrderedList, value) -- Lưu thứ tự
                    end
                else
                    ListNew = List
                end
				local function refreshlist(SortPairs)
					pairs = SortPairs or pairs
					clear_object_in_list()
					searchtable = {}
					for i, v in pairs(ListNew) do
						if Selected then
							table.insert(searchtable, string.lower(i))
						elseif Slider then
							table.insert(searchtable, string.lower(v['Title']))
						else
							table.insert(searchtable, string.lower(v))
						end
					end
					if Selected then
                        for _, i in ipairs(OrderedList) do
                            local v = ListNew[i]
							local SampleItem = Instance.new("Frame")
							local SampleItemCorner = Instance.new("UICorner")
							local SampleItemBG = Instance.new("Frame")
							local SampleItemBGCorner = Instance.new("UICorner")
							local SampleItemTitle = Instance.new("TextLabel")
							local SampleItemCheck = Instance.new("ImageButton")
							local SampleItemButton = Instance.new("TextButton")
							SampleItem.Name = string.lower(i)
							SampleItem.Parent = ScrollContainer
							SampleItem.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
							SampleItem.BackgroundTransparency = 1.000
							SampleItem.BorderColor3 = Color3.fromRGB(27, 42, 53)
							SampleItem.LayoutOrder = 1
							SampleItem.Position = UDim2.new(0, 0, 0.208333328, 0)
							SampleItem.Size = UDim2.new(1, 0, 0, 25)
							SampleItemCorner.CornerRadius = UDim.new(0, 4)
							SampleItemCorner.Name = "SampleItemCorner"
							SampleItemCorner.Parent = SampleItem
							SampleItemBG.Name = "SampleItemBG"
							SampleItemBG.Parent = SampleItem
							SampleItemBG.AnchorPoint = Vector2.new(0.5, 0.5)
							SampleItemBG.BackgroundColor3 = v and UIColor["Dropdown Selected Check Color"] or Color3.fromRGB(255, 255, 255)
							SampleItemBG.BackgroundTransparency = v and .5 or 1
							SampleItemBG.BorderColor3 = Color3.fromRGB(27, 42, 53)
							SampleItemBG.Position = UDim2.new(0.5, 0, 0.5, 0)
							SampleItemBG.Size = UDim2.new(1, 0, 1, 0)
							SampleItemBGCorner.CornerRadius = UDim.new(0, 4)
							SampleItemBGCorner.Name = "SampleItemBGCorner"
							SampleItemBGCorner.Parent = SampleItemBG
							SampleItemTitle.Name = "SampleItemTitle"
							SampleItemTitle.Parent = SampleItemBG
							SampleItemTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							SampleItemTitle.BackgroundTransparency = 1.000
							SampleItemTitle.BorderColor3 = Color3.fromRGB(27, 42, 53)
							SampleItemTitle.Position = UDim2.new(0, 10, 0, 0)
							SampleItemTitle.Size = UDim2.new(1, -40, 0, 25)
							SampleItemTitle.Font = Enum.Font.GothamBlack
							SampleItemTitle.Text = tostring(i)
							SampleItemTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
							SampleItemTitle.TextSize = 14.000
							SampleItemTitle.TextStrokeTransparency = 0.500
							SampleItemTitle.TextXAlignment = Enum.TextXAlignment.Left
							SampleItemCheck.Name = "SampleItemCheck"
							SampleItemCheck.Parent = SampleItemBG
							SampleItemCheck.AnchorPoint = Vector2.new(1, 0.5)
							SampleItemCheck.BackgroundTransparency = 1.000
							SampleItemCheck.Position = UDim2.new(1, 0, 0.5, 0)
							SampleItemCheck.Size = UDim2.new(0, 25, 0, 25)
							SampleItemCheck.ZIndex = 2
							SampleItemCheck.Image = "rbxassetid://112175659522723"
							SampleItemCheck.ImageColor3 = UIColor["Dropdown Selected Check Color"]
							SampleItemCheck.ImageRectOffset = Vector2.new(312, 4)
							SampleItemCheck.ImageRectSize = Vector2.new(24, 24)
							SampleItemCheck.ImageTransparency = v and 0 or 1
							SampleItemButton.Name = "SampleItemButton"
							SampleItemButton.Parent = SampleItem
							SampleItemButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							SampleItemButton.BackgroundTransparency = 1.000
							SampleItemButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
							SampleItemButton.BorderSizePixel = 0
							SampleItemButton.Size = UDim2.new(1, 0, 1, 0)
							SampleItemButton.Font = Enum.Font.SourceSans
							SampleItemButton.TextColor3 = getgenv().UIColor["Text Color"]
							SampleItemButton.TextSize = 14.000
							SampleItemButton.TextTransparency = 1.000
							SampleItemButton.MouseEnter:Connect(function()
								if v then
									return
								end
								TweenService:Create(
											SampleItemBG,
											TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
									BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								}
										):Play()
								TweenService:Create(
											SampleItemBG,
											TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
									BackgroundTransparency = .7
								}
										):Play()
							end)
							SampleItemButton.MouseLeave:Connect(function()
								if v then
									return
								end
								TweenService:Create(
											SampleItemBG,
											TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
									BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								}
										):Play()
								TweenService:Create(
											SampleItemBG,
											TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
									BackgroundTransparency = 1
								}
										):Play()
							end)
							SampleItemButton.MouseButton1Click:Connect(function()
								v = not v
								TweenService:Create(
											SampleItemCheck,
											TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
									ImageTransparency = v and 0 or 1
								}
										):Play()
								TweenService:Create(
											SampleItemBG,
											TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
									BackgroundColor3 = v and UIColor["Dropdown Selected Check Color"] or Color3.fromRGB(255, 255, 255)
								}
										):Play()
								TweenService:Create(
											SampleItemBG,
											TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
									BackgroundTransparency = v and .5 or 1
								}
										):Play()
								if Callback then
									Callback(i, v)
									ListNew[i] = v
								end
								if Search then
									Dropdowntitle.PlaceholderText = Title .. ': '
								else
									Dropdowntitle.Text = Title .. ': '
								end
							end)
						end
					elseif Slider then
						for i, v in pairs(ListNew) do
							local TitleText = tostring(v.Title) or ""
							local minValue = tonumber(v.Min) or 0
							local maxValue = tonumber(v.Max) or 100
							local Precise = v.Precise or false
							local DefaultValue = tonumber(v.Default) or minValue
							local SizeChia = 365;
							local SliderFrame = Instance.new("Frame")
							local SliderCorner = Instance.new("UICorner")
							local SliderBG = Instance.new("Frame")
							local SliderBGCorner = Instance.new("UICorner")
							local SliderTitle = Instance.new("TextLabel")
							local SliderBar = Instance.new("Frame")
							local SliderButton = Instance.new("TextButton")
							local SliderBarCorner = Instance.new("UICorner")
							local Bar = Instance.new("Frame")
							local BarCorner = Instance.new("UICorner")
							local Sliderboxframe = Instance.new("Frame")
							local Sliderbox = Instance.new("UICorner")
							local Sliderbox_2 = Instance.new("TextBox")
							SliderFrame.Name = string.lower(v['Title'])
							SliderFrame.Parent = ScrollContainer
							SliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
							SliderFrame.BackgroundTransparency = 1.000
							SliderFrame.Position = UDim2.new(0, 0, 0.208333328, 0)
							SliderFrame.Size = UDim2.new(1, 0, 0, 50)
							SliderCorner.CornerRadius = UDim.new(0, 4)
							SliderCorner.Name = "SliderCorner"
							SliderCorner.Parent = SliderFrame
							SliderBG.Name = "Background1"
							SliderBG.Parent = SliderFrame
							SliderBG.AnchorPoint = Vector2.new(0.5, 0.5)
							SliderBG.Position = UDim2.new(0.5, 0, 0.5, 0)
							SliderBG.Size = UDim2.new(1, -10, 1, 0)
							SliderBG.BackgroundColor3 = getgenv().UIColor["Background 1 Color"]
							SliderBG.BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"]
							SliderBGCorner.CornerRadius = UDim.new(0, 4)
							SliderBGCorner.Name = "SliderBGCorner"
							SliderBGCorner.Parent = SliderBG
							SliderTitle.Name = "TextColor"
							SliderTitle.Parent = SliderBG
							SliderTitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
							SliderTitle.BackgroundTransparency = 1.000
							SliderTitle.Position = UDim2.new(0, 10, 0, 0)
							SliderTitle.Size = UDim2.new(1, -10, 0, 25)
							SliderTitle.Font = Enum.Font.GothamBlack
							SliderTitle.Text = TitleText
							SliderTitle.TextSize = 14.000
							SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
							SliderTitle.TextColor3 = getgenv().UIColor["Text Color"]
							SliderBar.Name = "SliderBar"
							SliderBar.Parent = SliderFrame
							SliderBar.AnchorPoint = Vector2.new(.5, 0.5)
							SliderBar.Position = UDim2.new(.5, 0, 0.5, 14)
							SliderBar.Size = UDim2.new(1, -20, 0, 6)
							SliderBar.BackgroundColor3 = getgenv().UIColor["Background 2 Color"]
							SliderButton.Name = "SliderButton "
							SliderButton.Parent = SliderBar
							SliderButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
							SliderButton.BackgroundTransparency = 1.000
							SliderButton.Size = UDim2.new(1, 0, 1, 0)
							SliderButton.Font = Enum.Font.GothamBold
							SliderButton.Text = ""
							SliderButton.TextColor3 = Color3.fromRGB(230, 230, 230)
							SliderButton.TextSize = 14.000
							SliderBarCorner.CornerRadius = UDim.new(1, 0)
							SliderBarCorner.Name = "SliderBarCorner"
							SliderBarCorner.Parent = SliderBar
							Bar.Name = "Bar"
							Bar.BorderSizePixel = 0
							Bar.Parent = SliderBar
							Bar.Size = UDim2.new(0, 0, 1, 0)
							Bar.BackgroundColor3 = getgenv().UIColor["Slider Line Color"]
							BarCorner.CornerRadius = UDim.new(1, 0)
							BarCorner.Name = "BarCorner"
							BarCorner.Parent = Bar
							Sliderboxframe.Name = "Background2"
							Sliderboxframe.Parent = SliderFrame
							Sliderboxframe.AnchorPoint = Vector2.new(1, 0)
							Sliderboxframe.Position = UDim2.new(1, -10, 0, 5)
							Sliderboxframe.Size = UDim2.new(0, 150, 0, 25)
							Sliderboxframe.BackgroundColor3 = getgenv().UIColor["Background 2 Color"]
							Sliderbox.CornerRadius = UDim.new(0, 4)
							Sliderbox.Name = "Sliderbox"
							Sliderbox.Parent = Sliderboxframe
							Sliderbox_2.Name = "TextColor"
							Sliderbox_2.Parent = Sliderboxframe
							Sliderbox_2.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
							Sliderbox_2.BackgroundTransparency = 1.000
							Sliderbox_2.Size = UDim2.new(1, 0, 1, 0)
							Sliderbox_2.Font = Enum.Font.GothamBold
							Sliderbox_2.Text = ""
							Sliderbox_2.TextSize = 14.000
							Sliderbox_2.TextColor3 = getgenv().UIColor["Text Color"]
							SliderButton.MouseEnter:Connect(function()
								TweenService:Create(Bar, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
									BackgroundColor3 = getgenv().UIColor["Slider Highlight Color"]
								}):Play()
							end)
							SliderButton.MouseLeave:Connect(function()
								TweenService:Create(Bar, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
									BackgroundColor3 = getgenv().UIColor["Slider Line Color"]
								}):Play()
							end)
							local callBackAndSetText = function(val)
								Sliderbox_2.Text = val
								ListNew[i].Default = val
								Callback(i, v)
							end
							if DefaultValue then
								if DefaultValue <= minValue then
									DefaultValue = minValue
								elseif DefaultValue >= maxValue then
									DefaultValue = maxValue
								end
								Bar.Size = UDim2.new(1 - ((maxValue - DefaultValue) / (maxValue - minValue)), 0, 0, 6)
								callBackAndSetText(DefaultValue)
							end
							if SliderRelease then
								local dragging = false
								local dragInput
								local holdTime = 0
								local holdStarted = 0

										-- Function to detect the start of dragging (for both mouse and touch)
								local function onInputBegan(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										holdStarted = tick() -- Record the time when holding starts
										
												-- Listen for release to stop dragging
										input.Changed:Connect(function()
											if input.UserInputState == Enum.UserInputState.End then
												dragging = false
												holdStarted = 0 -- Reset the hold timer
											end
										end)
									end
								end
										
										-- Function to detect when dragging stops
								local function onInputEnded(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										dragging = false
										holdStarted = 0 -- Reset the hold timer
									end
								end

										-- Detect input movement (for both mouse and touch)
								local function onInputChanged(input)
									if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
										dragInput = input
									end
								end
										
										-- Connect the events
								SliderButton.InputBegan:Connect(onInputBegan)
								SliderButton.InputEnded:Connect(onInputEnded)
								SliderButton.InputChanged:Connect(onInputChanged)
										
										-- RenderStepped updates the position while dragging
								RunService.RenderStepped:Connect(function()
									if holdStarted > 0 and (tick() - holdStarted >= holdTime) and not dragging then
										dragging = true
									end
									if dragging and dragInput then
										local value = Precise and  tonumber(string.format("%.1f", (((tonumber(maxValue) - tonumber(minValue)) / SizeChia) * Bar.AbsoluteSize.X) + tonumber(minValue))) or math.floor((((tonumber(maxValue) - tonumber(minValue)) / SizeChia) * Bar.AbsoluteSize.X) + tonumber(minValue))
										pcall(function()
											callBackAndSetText(value)
										end)
										Bar.Size = UDim2.new(0, math.clamp(dragInput.Position.X - Bar.AbsolutePosition.X, 0, SizeChia), 0, 6)
									end
								end)
							else
								local dragging = false
								local dragInput
								local holdTime = 0 -- Time to hold before dragging is enabled
								local holdStarted = 0

										-- Function to detect the start of dragging (for both mouse and touch)
								local function onInputBegan(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										holdStarted = tick() -- Record the time when holding starts
										
												-- Listen for release to stop dragging
										input.Changed:Connect(function()
											if input.UserInputState == Enum.UserInputState.End then
												dragging = false
												holdStarted = 0 -- Reset the hold timer
											end
										end)
									end
								end
										
										-- Function to detect when dragging stops
								local function onInputEnded(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										dragging = false
										holdStarted = 0 -- Reset the hold timer
									end
								end

										-- Detect input movement (for both mouse and touch)
								local function onInputChanged(input)
									if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
										dragInput = input
									end
								end
										
										-- Connect the events
								SliderButton.InputBegan:Connect(onInputBegan)
								SliderButton.InputEnded:Connect(onInputEnded)
								SliderButton.InputChanged:Connect(onInputChanged)
										
										-- RenderStepped updates the position while dragging
								RunService.RenderStepped:Connect(function()
									if holdStarted > 0 and (tick() - holdStarted >= holdTime) and not dragging then
										dragging = true
									end
									if dragging and dragInput then
										local value = Precise and  tonumber(string.format("%.1f", (((tonumber(maxValue) - tonumber(minValue)) / SizeChia) * Bar.AbsoluteSize.X) + tonumber(minValue))) or math.floor((((tonumber(maxValue) - tonumber(minValue)) / SizeChia) * Bar.AbsoluteSize.X) + tonumber(minValue))
										pcall(function()
											callBackAndSetText(value)
										end)
										Bar.Size = UDim2.new(0, math.clamp(dragInput.Position.X - Bar.AbsolutePosition.X, 0, SizeChia), 0, 6)
									end
								end)
							end
							local function GetSliderValue(Value)
								if tonumber(Value) <= minValue then
									Bar.Size = UDim2.new(0, (0 * SizeChia), 0, 6)
									callBackAndSetText(minValue)
								elseif tonumber(Value) >= maxValue then
									Bar.Size = UDim2.new(0, (maxValue  /  maxValue * SizeChia), 0, 6)
									callBackAndSetText(maxValue)
								else
									Bar.Size = UDim2.new(1 - ((maxValue - Value) / (maxValue - minValue)), 0, 0, 6)
									callBackAndSetText(Value)
								end
							end
							Sliderbox_2.FocusLost:Connect(function()
								GetSliderValue(Sliderbox_2.Text)
							end)
						end
					else
						for i, v in pairs (ListNew) do
							if typeof(v) == "string" then
								local SampleItem = Instance.new("Frame")
								local SampleItemCorner = Instance.new("UICorner")
								local SampleItemBG = Instance.new("Frame")
								local SampleItemBGCorner = Instance.new("UICorner")
								local SampleItemTitle = Instance.new("TextLabel")
								local SampleItemCheck = Instance.new("ImageButton")
								local SampleItemButton = Instance.new("TextButton")
								SampleItem.Name = string.lower(v)
								SampleItem.Parent = ScrollContainer
								SampleItem.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
								SampleItem.BackgroundTransparency = 1.000
								SampleItem.BorderColor3 = Color3.fromRGB(27, 42, 53)
								SampleItem.LayoutOrder = 1
								SampleItem.Position = UDim2.new(0, 0, 0.208333328, 0)
								SampleItem.Size = UDim2.new(1, 0, 0, 25)
								SampleItemCorner.CornerRadius = UDim.new(0, 4)
								SampleItemCorner.Name = "SampleItemCorner"
								SampleItemCorner.Parent = SampleItem
								SampleItemBG.Name = "SampleItemBG"
								SampleItemBG.Parent = SampleItem
								SampleItemBG.AnchorPoint = Vector2.new(0.5, 0.5)
								SampleItemBG.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								SampleItemBG.BackgroundTransparency = 1
								SampleItemBG.BorderColor3 = Color3.fromRGB(27, 42, 53)
								SampleItemBG.Position = UDim2.new(0.5, 0, 0.5, 0)
								SampleItemBG.Size = UDim2.new(1, 0, 1, 0)
								SampleItemBGCorner.CornerRadius = UDim.new(0, 4)
								SampleItemBGCorner.Name = "SampleItemBGCorner"
								SampleItemBGCorner.Parent = SampleItemBG
								SampleItemTitle.Name = "SampleItemTitle"
								SampleItemTitle.Parent = SampleItemBG
								SampleItemTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								SampleItemTitle.BackgroundTransparency = 1.000
								SampleItemTitle.BorderColor3 = Color3.fromRGB(27, 42, 53)
								SampleItemTitle.Position = UDim2.new(0, 10, 0, 0)
								SampleItemTitle.Size = UDim2.new(1, -40, 0, 25)
								SampleItemTitle.Font = Enum.Font.GothamBlack
								SampleItemTitle.Text = v
								SampleItemTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
								SampleItemTitle.TextSize = 14.000
								SampleItemTitle.TextStrokeTransparency = 0.500
								SampleItemTitle.TextXAlignment = Enum.TextXAlignment.Left
								SampleItemCheck.Name = "SampleItemCheck"
								SampleItemCheck.Parent = SampleItemBG
								SampleItemCheck.AnchorPoint = Vector2.new(1, 0.5)
								SampleItemCheck.BackgroundTransparency = 1.000
								SampleItemCheck.Position = UDim2.new(1, 0, 0.5, 0)
								SampleItemCheck.Size = UDim2.new(0, 25, 0, 25)
								SampleItemCheck.ZIndex = 2
								SampleItemCheck.Image = "rbxassetid://112175659522723"
								SampleItemCheck.ImageColor3 = UIColor["Dropdown Selected Check Color"]
								SampleItemCheck.ImageRectOffset = Vector2.new(312, 4)
								SampleItemCheck.ImageRectSize = Vector2.new(24, 24)
								SampleItemCheck.ImageTransparency = 1
								SampleItemButton.Name = "SampleItemButton"
								SampleItemButton.Parent = SampleItem
								SampleItemButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								SampleItemButton.BackgroundTransparency = 1.000
								SampleItemButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
								SampleItemButton.BorderSizePixel = 0
								SampleItemButton.Size = UDim2.new(1, 0, 1, 0)
								SampleItemButton.Font = Enum.Font.SourceSans
								SampleItemButton.TextColor3 = getgenv().UIColor["Text Color"]
								SampleItemButton.TextSize = 14.000
								SampleItemButton.TextTransparency = 1.000
								SampleItemButton.MouseEnter:Connect(function()
									if Sel.Value == v then
										return
									end
									TweenService:Create(
												SampleItemBG,
												TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
										BackgroundColor3 = Color3.fromRGB(255, 255, 255)
									}
											):Play()
									TweenService:Create(
												SampleItemBG,
												TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
										BackgroundTransparency = .7
									}
											):Play()
								end)
								SampleItemButton.MouseLeave:Connect(function()
									if Sel.Value == v then
										return
									end
									TweenService:Create(
												SampleItemBG,
												TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
										BackgroundColor3 = Color3.fromRGB(255, 255, 255)
									}
											):Play()
									TweenService:Create(
												SampleItemBG,
												TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
										BackgroundTransparency = 1
									}
											):Play()
								end)
								SampleItemButton.MouseButton1Click:Connect(function()
									if Search then
										Dropdowntitle.PlaceholderText = Title .. ': ' .. v or ""
										Sel.Value = v
									else
										Dropdowntitle.Text = Title .. ': ' .. v or ""
										Sel.Value = v
									end
									TweenService:Create(
												SampleItemBG,
												TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
										BackgroundColor3 = UIColor["Dropdown Selected Check Color"]
									}
											):Play()
									TweenService:Create(
												SampleItemBG,
												TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
										BackgroundTransparency = .5
									}
											):Play()
									if Callback then
										Callback(v)
									end
									if Search then
										Dropdowntitle.Text = ""
									end
									refreshlist()
								end)
								if Sel.Value == v then
									SampleItemBG.BackgroundTransparency = .5;
									SampleItemBG.BackgroundColor3 = UIColor["Dropdown Selected Check Color"]
									SampleItem.LayoutOrder = 0
								end
							end
						end
					end
				end
				if Search then
					Dropdowntitle.Changed:Connect(function()
						edit()
						SearchDropdown()
					end)
				end
				if typeof(Default) ~= 'table' then
					if Search then
						Dropdowntitle.PlaceholderText = Title .. ': ' .. tostring(Default or "")
					else
						Dropdowntitle.Text = Title .. ': ' .. tostring(Default or "")
					end
				elseif Slider then
					Dropdowntitle.Text = ''
					Dropdowntitle.PlaceholderText = Title .. ': '
				elseif Selected then
					if Search then
						Dropdowntitle.PlaceholderText = Title .. ': '
					else
						Dropdowntitle.Text = Title .. ': '
					end
				end
				DropdownButton.MouseButton1Click:Connect(function()
					refreshlist()
					isbusy = not isbusy
					local listsize = isbusy and UDim2.new(1, 0, 0, 170) or UDim2.new(1, 0, 0, 0)
					local mainsize = isbusy and UDim2.new(1, 0, 0, 200) or UDim2.new(1, 0, 0, 25)
					local DropCRotation = isbusy and 90 or 0
					TweenService:Create(Dropdownlisttt, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						Size = listsize
					}):Play()
					TweenService:Create(DropdownFrame, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						Size = mainsize
					}):Play()
					TweenService:Create(ImgDrop, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						Rotation = DropCRotation
					}):Play()
				end)
				local dropdownFunction = {
					rf = refreshlist
				}
				function dropdownFunction:ClearText(v)
					if not Selected then
						if Search then
							Dropdowntitle.PlaceholderText = Title .. ': ' .. (v or "")
						else
							Dropdowntitle.Text = Title .. ': ' .. (v or "")
						end
					else
						Dropdowntitle.Text = Title .. ': ' .. (v or "")
					end
				end
				function dropdownFunction:GetNewList(List)
					Sel.Value = ""
							--refreshlist()
					isbusy = false
					local listsize = isbusy and UDim2.new(1, 0, 0, 170) or UDim2.new(1, 0, 0, 0)
					local mainsize = isbusy and UDim2.new(1, 0, 0, 200) or UDim2.new(1, 0, 0, 25)
					local DropCRotation = isbusy and 90 or 0
					TweenService:Create(Dropdownlisttt, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						Size = listsize
					}):Play()
					TweenService:Create(DropdownFrame, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						Size = mainsize
					}):Play()
					TweenService:Create(ImgDrop, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						Rotation = DropCRotation
					}):Play()
					ListNew = {}
					ListNew = List
					refreshlist()
					if Search then
						Dropdowntitle.PlaceholderText = Title .. ': '
					else
						Dropdowntitle.Text = Title .. ': '
					end
				end
				-- THÊM ĐOẠN NÀY
                function dropdownFunction:SetValue(value)
                    if not Selected then
                        -- Dropdown đơn lẻ (single)
                        if table.find(ListNew, value) then
                            Sel.Value = value
                            if Search then
                                Dropdowntitle.PlaceholderText = Title .. ': ' .. value
                            else
                                Dropdowntitle.Text = Title .. ': ' .. value
                            end
                            if Callback then
                                Callback(value)
                            end
                            refreshlist()
                        end
                    else
                        -- Dropdown multi-select
                        if ListNew[value] ~= nil then
                            ListNew[value] = true
                            if Search then
                                Dropdowntitle.PlaceholderText = Title .. ': '
                            else
                                Dropdowntitle.Text = Title .. ': '
                            end
                            if Callback then
                                Callback(value, true)
                            end
                            refreshlist()
                        end
                    end
                end
                
                function dropdownFunction:GetValue()
                    if not Selected then
                        return Sel.Value
                    else
                        local result = {}
                        for key, val in pairs(ListNew) do
                            if val == true then
                                table.insert(result, key)
                            end
                        end
                        return result
                    end
                end
				local controlData = {
                    Name = Title,
                    Section = Section,
                    Element = DropdownFrame,
                    SectionName = Section_Name,
                    TabName = Page_Name,
                    TabButton = PageName,
                    SetValue = dropdownFunction.SetValue,  -- THÊM DÒNG NÀY
                    GetValue = dropdownFunction.GetValue   -- THÊM DÒNG NÀY
                }
                table.insert(getgenv().AllControls, controlData)
                
                return dropdownFunction
			end

function sectionFunction:AddKeyBind(Setting, Callback)
    local TitleText = tostring(Setting.Title or Setting.Text) or ""
    local Default = Setting.Default or Setting.Key or "F"
    local Mode = Setting.Mode or "Toggle" -- Hold hoặc Toggle
    local Callback = Setting.Callback or Callback or function() end
    
    local function GetKeyString(key)
        local keyStr = tostring(key)
        keyStr = keyStr:gsub("Enum.UserInputType.", "")
        keyStr = keyStr:gsub("Enum.KeyCode.", "")
        return keyStr
    end
    
    local CurrentKey = GetKeyString(Default)
    local CurrentMode = Mode
    local Picking = false
    local ToggleState = false
    local HoldActive = false
    
    -- UI Elements (BỎ ModeButton)
    local BindFrame = Instance.new("Frame")
    local BindCorner = Instance.new("UICorner")
    local BindBG = Instance.new("Frame")
    local ButtonCorner = Instance.new("UICorner")
    local BindButtonTitle = Instance.new("TextLabel")
    local BindCor = Instance.new("Frame")
    local ButtonCorner_2 = Instance.new("UICorner")
    local Bindkey = Instance.new("TextButton")
    
    BindFrame.Name = TitleText .. "bguvl"
    BindFrame.Parent = Section
    BindFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    BindFrame.BackgroundTransparency = 1.000
    BindFrame.Position = UDim2.new(0, 0, 0.208333328, 0)
    BindFrame.Size = UDim2.new(1, 0, 0, 35)
    
    BindCorner.CornerRadius = UDim.new(0, 4)
    BindCorner.Name = "BindCorner"
    BindCorner.Parent = BindFrame
    
    BindBG.Name = "Background1"
    BindBG.Parent = BindFrame
    BindBG.AnchorPoint = Vector2.new(0.5, 0.5)
    BindBG.Position = UDim2.new(0.5, 0, 0.5, 0)
    BindBG.Size = UDim2.new(1, -10, 1, 0)
    BindBG.BackgroundColor3 = getgenv().UIColor["Background 1 Color"]
    BindBG.BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"]
    
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Name = "ButtonCorner"
    ButtonCorner.Parent = BindBG
    
    BindButtonTitle.Name = "TextColor"
    BindButtonTitle.Parent = BindBG
    BindButtonTitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    BindButtonTitle.BackgroundTransparency = 1.000
    BindButtonTitle.Position = UDim2.new(0, 10, 0, 0)
    BindButtonTitle.Size = UDim2.new(1, -10, 1, 0)
    BindButtonTitle.Font = Enum.Font.GothamBlack
    BindButtonTitle.Text = TitleText
    BindButtonTitle.TextSize = 14.000
    BindButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
    BindButtonTitle.TextColor3 = getgenv().UIColor["Text Color"]
    
    BindCor.Name = "Background2"
    BindCor.Parent = BindBG
    BindCor.AnchorPoint = Vector2.new(1, 0.5)
    BindCor.Position = UDim2.new(1, -5, 0.5, 0)
    BindCor.Size = UDim2.new(0, 150, 0, 25)
    BindCor.BackgroundColor3 = getgenv().UIColor["Background 2 Color"]
    
    ButtonCorner_2.CornerRadius = UDim.new(0, 4)
    ButtonCorner_2.Name = "ButtonCorner"
    ButtonCorner_2.Parent = BindCor
    
    Bindkey.Name = "Bindkey"
    Bindkey.Parent = BindCor
    Bindkey.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    Bindkey.BackgroundTransparency = 1.000
    Bindkey.Size = UDim2.new(1, 0, 1, 0)
    Bindkey.Font = Enum.Font.GothamBold
    Bindkey.Text = CurrentKey
    Bindkey.TextSize = 14.000
    Bindkey.TextColor3 = getgenv().UIColor["Text Color"]
    
    -- Change Key
    Bindkey.MouseButton1Click:Connect(function()
        if Picking then return end
        
        Picking = true
        Bindkey.Text = "..."
        
        task.wait(0.2)
        
        local Connection
        Connection = uis.InputBegan:Connect(function(input)
            if Picking then
                local Key
                
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    Key = input.KeyCode.Name
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Key = "MouseLeft"
                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Key = "MouseRight"
                end
                
                if Key then
                    Picking = false
                    CurrentKey = Key
                    Bindkey.Text = Key
                    Connection:Disconnect()
                end
            end
        end)
    end)
    
    -- Input Began (Press)
    uis.InputBegan:Connect(function(input, gpe)
        if gpe or Picking then return end
        if uis:GetFocusedTextBox() then return end
        
        local pressedKey
        if input.UserInputType == Enum.UserInputType.Keyboard then
            pressedKey = input.KeyCode.Name
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            pressedKey = "MouseLeft"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            pressedKey = "MouseRight"
        end
        
        if pressedKey == CurrentKey then
            if CurrentMode == "Toggle" then
                ToggleState = not ToggleState
                pcall(Callback, ToggleState)
            elseif CurrentMode == "Hold" then
                HoldActive = true
                pcall(Callback, true)
            end
        end
    end)
    
    -- Input Ended (Release) - Only for Hold mode
    uis.InputEnded:Connect(function(input)
        if Picking then return end
        if uis:GetFocusedTextBox() then return end
        
        local releasedKey
        if input.UserInputType == Enum.UserInputType.Keyboard then
            releasedKey = input.KeyCode.Name
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            releasedKey = "MouseLeft"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            releasedKey = "MouseRight"
        end
        
        if releasedKey == CurrentKey and CurrentMode == "Hold" and HoldActive then
            HoldActive = false
            pcall(Callback, false)
        end
    end)
    
    local controlData = {
        Name = TitleText,
        Section = Section,
        Element = BindFrame,
        SectionName = Section_Name,
        TabName = Page_Name,
        TabButton = PageName
    }
    table.insert(getgenv().AllControls, controlData)
    
    local keybindFunction = {}
    
    function keybindFunction:Set(newKey)
        CurrentKey = GetKeyString(newKey)
        Bindkey.Text = CurrentKey
    end
    
    function keybindFunction:Get()
        return CurrentKey
    end
    
    function keybindFunction:SetMode(mode)
        if mode == "Hold" or mode == "Toggle" then
            CurrentMode = mode
            ToggleState = false
            HoldActive = false
        end
    end
    
    function keybindFunction:GetMode()
        return CurrentMode
    end
    
    function keybindFunction:GetState()
        if CurrentMode == "Toggle" then
            return ToggleState
        elseif CurrentMode == "Hold" then
            return HoldActive
        end
        return false
    end
    
    return keybindFunction
end
			function sectionFunction:AddInput(idk, Setting)
				local TitleText = tostring(Setting.Text or Setting.Title) or ""
				local Placeholder = tostring(Setting.Placeholder) or ""
				local Default = Setting.Default or false
				local Number_Only = Setting.Numeric or false
				local Callback = Setting.Callback
				local BoxFrame = Instance.new("Frame")
				local BoxCorner = Instance.new("UICorner")
				local BoxBG = Instance.new("Frame")
				local ButtonCorner = Instance.new("UICorner")
				local Boxtitle = Instance.new("TextLabel")
				local BoxCor = Instance.new("Frame")
				local ButtonCorner_2 = Instance.new("UICorner")
				local Boxxx = Instance.new("TextBox")
				local Lineeeee = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				BoxFrame.Name = "BoxFrame"
				BoxFrame.Parent = Section
				BoxFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				BoxFrame.BackgroundTransparency = 1.000
				BoxFrame.Position = UDim2.new(0, 0, 0.208333328, 0)
				BoxFrame.Size = UDim2.new(1, 0, 0, 60)
				BoxCorner.CornerRadius = UDim.new(0, 4)
				BoxCorner.Name = "BoxCorner"
				BoxCorner.Parent = BoxFrame
				BoxBG.Name = "Background1"
				BoxBG.Parent = BoxFrame
				BoxBG.AnchorPoint = Vector2.new(0.5, 0.5)
				BoxBG.Position = UDim2.new(0.5, 0, 0.5, 0)
				BoxBG.Size = UDim2.new(1, -10, 1, 0)
				BoxBG.BackgroundColor3 = getgenv().UIColor["Background 1 Color"]
				BoxBG.BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"]
				ButtonCorner.CornerRadius = UDim.new(0, 4)
				ButtonCorner.Name = "ButtonCorner"
				ButtonCorner.Parent = BoxBG
				Boxtitle.Name = "TextColor"
				Boxtitle.Parent = BoxBG
				Boxtitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				Boxtitle.BackgroundTransparency = 1.000
				Boxtitle.Position = UDim2.new(0, 10, 0, 0)
				Boxtitle.Size = UDim2.new(1, -10, 0.5, 0)
				Boxtitle.Font = Enum.Font.GothamBlack
				Boxtitle.Text = TitleText
				Boxtitle.TextSize = 14.000
				Boxtitle.TextXAlignment = Enum.TextXAlignment.Left
				Boxtitle.TextColor3 = getgenv().UIColor["Text Color"]
				BoxCor.Name = "Background2"
				BoxCor.Parent = BoxBG
				BoxCor.AnchorPoint = Vector2.new(1, 0.5)
				BoxCor.ClipsDescendants = true
				BoxCor.Position = UDim2.new(1, -5, 0, 40)
				BoxCor.Size = UDim2.new(1, -10, 0, 25)
				BoxCor.BackgroundColor3 = getgenv().UIColor["Background 2 Color"]
				ButtonCorner_2.CornerRadius = UDim.new(0, 4)
				ButtonCorner_2.Name = "ButtonCorner"
				ButtonCorner_2.Parent = BoxCor
				Boxxx.Name = "TextColorPlaceholder"
				Boxxx.Parent = BoxCor
				Boxxx.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				Boxxx.BackgroundTransparency = 1.000
				Boxxx.Position = UDim2.new(0, 5, 0, 0)
				Boxxx.Size = UDim2.new(1, -5, 1, 0)
				Boxxx.Font = Enum.Font.GothamBold
				Boxxx.PlaceholderText = Placeholder
				Boxxx.Text = ""
				Boxxx.TextSize = 14.000
				Boxxx.TextXAlignment = Enum.TextXAlignment.Left
				Boxxx.PlaceholderColor3 = getgenv().UIColor["Placeholder Text Color"]
				Boxxx.TextColor3 = getgenv().UIColor["Text Color"]
				Lineeeee.Name = "TextNSBoxLineeeee"
				Lineeeee.Parent = BoxCor
				Lineeeee.BackgroundTransparency = 1.000
				Lineeeee.Position = UDim2.new(0, 0, 1, -2)
				Lineeeee.Size = UDim2.new(1, 0, 0, 6)
				Lineeeee.BackgroundColor3 = getgenv().UIColor["Box Highlight Color"]
				UICorner.CornerRadius = UDim.new(1, 0)
				UICorner.Parent = Lineeeee
				Boxxx.Focused:Connect(function()
					TweenService:Create(Lineeeee, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						BackgroundTransparency = 0
					}):Play()
				end)
				if Number_Only then
					Boxxx:GetPropertyChangedSignal("Text"):Connect(function()
						if tonumber(Boxxx.Text) then
						else
							Boxxx.PlaceholderText = Placeholder
							Boxxx.Text = ''
						end
					end)
				end
				Boxxx.FocusLost:Connect(function()
					TweenService:Create(Lineeeee, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						BackgroundTransparency = 1
					}):Play()
					if Boxxx.Text ~= '' then
						Callback(Boxxx.Text)
					end
				end)
				local textbox_function = {}
				if Default then
					Boxxx.Text = Default
				end
				function textbox_function.SetValue(Value)
					Boxxx.Text = Value
					Callback(Value)
				end
				local controlData = {
                    Name = TitleText,
                    Section = Section,
                    Element = BoxFrame,
                    SectionName = Section_Name,
                    TabName = Page_Name,
                    TabButton = PageName
                }
                table.insert(getgenv().AllControls, controlData)
                
				return textbox_function;
			end
			function sectionFunction:AddSlider(Setting)
				local TitleText = tostring(Setting.Text or Setting.Title) or ""
				local minValue = tonumber(Setting.Min) or 0
				local maxValue = tonumber(Setting.Max) or 100
				local Precise = Setting.Precise or false
				local DefaultValue = tonumber(Setting.Default) or 0
				local Callback = Setting.Callback
				local SizeChia = 400;
				local SliderFrame = Instance.new("Frame")
				local SliderCorner = Instance.new("UICorner")
				local SliderBG = Instance.new("Frame")
				local SliderBGCorner = Instance.new("UICorner")
				local SliderTitle = Instance.new("TextLabel")
				local SliderBar = Instance.new("Frame")
				local SliderButton = Instance.new("TextButton")
				local SliderBarCorner = Instance.new("UICorner")
				local Bar = Instance.new("Frame")
				local BarCorner = Instance.new("UICorner")
				local Sliderboxframe = Instance.new("Frame")
				local Sliderbox = Instance.new("UICorner")
				local Sliderbox_2 = Instance.new("TextBox")
				SliderFrame.Name = TitleText .. 'buda'
				SliderFrame.Parent = Section
				SliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				SliderFrame.BackgroundTransparency = 1.000
				SliderFrame.Position = UDim2.new(0, 0, 0.208333328, 0)
				SliderFrame.Size = UDim2.new(1, 0, 0, 50)
				SliderCorner.CornerRadius = UDim.new(0, 4)
				SliderCorner.Name = "SliderCorner"
				SliderCorner.Parent = SliderFrame
				SliderBG.Name = "Background1"
				SliderBG.Parent = SliderFrame
				SliderBG.AnchorPoint = Vector2.new(0.5, 0.5)
				SliderBG.Position = UDim2.new(0.5, 0, 0.5, 0)
				SliderBG.Size = UDim2.new(1, -10, 1, 0)
				SliderBG.BackgroundColor3 = getgenv().UIColor["Background 1 Color"]
				SliderBG.BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"]
				SliderBGCorner.CornerRadius = UDim.new(0, 4)
				SliderBGCorner.Name = "SliderBGCorner"
				SliderBGCorner.Parent = SliderBG
				SliderTitle.Name = "TextColor"
				SliderTitle.Parent = SliderBG
				SliderTitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				SliderTitle.BackgroundTransparency = 1.000
				SliderTitle.Position = UDim2.new(0, 10, 0, 0)
				SliderTitle.Size = UDim2.new(1, -10, 0, 25)
				SliderTitle.Font = Enum.Font.GothamBlack
				SliderTitle.Text = TitleText
				SliderTitle.TextSize = 14.000
				SliderTitle.RichText = true
				SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
				SliderTitle.TextColor3 = getgenv().UIColor["Text Color"]
				SliderBar.Name = "SliderBar"
				SliderBar.Parent = SliderFrame
				SliderBar.AnchorPoint = Vector2.new(.5, 0.5)
				SliderBar.Position = UDim2.new(.5, 0, 0.5, 14)
				SliderBar.Size = UDim2.new(0, 400, 0, 6)
				SliderBar.BackgroundColor3 = getgenv().UIColor["Background 2 Color"]
				SliderButton.Name = "SliderButton "
				SliderButton.Parent = SliderBar
				SliderButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				SliderButton.BackgroundTransparency = 1.000
				SliderButton.Size = UDim2.new(1, 0, 1, 0)
				SliderButton.Font = Enum.Font.GothamBold
				SliderButton.Text = ""
				SliderButton.TextColor3 = Color3.fromRGB(230, 230, 230)
				SliderButton.TextSize = 14.000
				SliderBarCorner.CornerRadius = UDim.new(1, 0)
				SliderBarCorner.Name = "SliderBarCorner"
				SliderBarCorner.Parent = SliderBar
				Bar.Name = "Bar"
				Bar.BorderSizePixel = 0
				Bar.Parent = SliderBar
				Bar.Size = UDim2.new(0, 0, 1, 0)
				Bar.BackgroundColor3 = getgenv().UIColor["Slider Line Color"]
				BarCorner.CornerRadius = UDim.new(1, 0)
				BarCorner.Name = "BarCorner"
				BarCorner.Parent = Bar
				Sliderboxframe.Name = "Background2"
				Sliderboxframe.Parent = SliderFrame
				Sliderboxframe.AnchorPoint = Vector2.new(1, 0)
				Sliderboxframe.Position = UDim2.new(1, -10, 0, 5)
				Sliderboxframe.Size = UDim2.new(0, 150, 0, 25)
				Sliderboxframe.BackgroundColor3 = getgenv().UIColor["Background 2 Color"]
				Sliderbox.CornerRadius = UDim.new(0, 4)
				Sliderbox.Name = "Sliderbox"
				Sliderbox.Parent = Sliderboxframe
				Sliderbox_2.Name = "TextColor"
				Sliderbox_2.Parent = Sliderboxframe
				Sliderbox_2.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				Sliderbox_2.BackgroundTransparency = 1.000
				Sliderbox_2.Size = UDim2.new(1, 0, 1, 0)
				Sliderbox_2.Font = Enum.Font.GothamBold
				Sliderbox_2.Text = ""
				Sliderbox_2.TextSize = 14.000
				Sliderbox_2.TextColor3 = getgenv().UIColor["Text Color"]
				SliderButton.MouseEnter:Connect(function()
					TweenService:Create(Bar, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						BackgroundColor3 = getgenv().UIColor["Slider Highlight Color"]
					}):Play()
				end)
				SliderButton.MouseLeave:Connect(function()
					TweenService:Create(Bar, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						BackgroundColor3 = getgenv().UIColor["Slider Line Color"]
					}):Play()
				end)
				local callBackAndSetText = function(val)
					Sliderbox_2.Text = val
					Callback(tonumber(val))
				end
				if DefaultValue then
					if DefaultValue <= minValue then
						DefaultValue = minValue
					elseif DefaultValue >= maxValue then
						DefaultValue = maxValue
					end
					Sliderbox_2.Text = tostring(DefaultValue)
					Bar.Size = UDim2.new(1 - ((maxValue - DefaultValue) / (maxValue - minValue)), 0, 0, 6)
				end
				local dragging = false
				local dragInput
				local holdTime = 0 -- Time to hold before dragging is enabled
				local holdStarted = 0

						-- Function to detect the start of dragging (for both mouse and touch)
				local function onInputBegan(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						holdStarted = tick() -- Record the time when holding starts
						
								-- Listen for release to stop dragging
						input.Changed:Connect(function()
							if input.UserInputState == Enum.UserInputState.End then
								dragging = false
								holdStarted = 0 -- Reset the hold timer
							end
						end)
					end
				end
						
						-- Function to detect when dragging stops
				local function onInputEnded(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
						holdStarted = 0 -- Reset the hold timer
					end
				end

						-- Detect input movement (for both mouse and touch)
				local function onInputChanged(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						dragInput = input
					end
				end
						
						-- Connect the events
				SliderButton.InputBegan:Connect(onInputBegan)
				SliderButton.InputEnded:Connect(onInputEnded)
				SliderButton.InputChanged:Connect(onInputChanged)
						
						-- RenderStepped updates the position while dragging
				RunService.RenderStepped:Connect(function()
					if holdStarted > 0 and (tick() - holdStarted >= holdTime) and not dragging then
						dragging = true
					end
					if dragging and dragInput then
						local value = Setting.Rouding and  tonumber(string.format("%.".. Setting.Rouding or 1 .."f", (((tonumber(maxValue) - tonumber(minValue)) / SizeChia) * Bar.AbsoluteSize.X) + tonumber(minValue))) or math.floor((((tonumber(maxValue) - tonumber(minValue)) / SizeChia) * Bar.AbsoluteSize.X) + tonumber(minValue))
						pcall(function()
							callBackAndSetText(value)
						end)
						Bar.Size = UDim2.new(0, math.clamp(dragInput.Position.X - Bar.AbsolutePosition.X, 0, SizeChia), 0, 6)
					end
				end)
				local function GetSliderValue(Value)
					if tonumber(Value) <= minValue then
						Bar.Size = UDim2.new(0, (0 * SizeChia), 0, 6)
						callBackAndSetText(minValue)
					elseif tonumber(Value) >= maxValue then
						Bar.Size = UDim2.new(0, (maxValue  /  maxValue * SizeChia), 0, 6)
						callBackAndSetText(maxValue)
					else
						Bar.Size = UDim2.new(1 - ((maxValue - Value) / (maxValue - minValue)), 0, 0, 6)
						callBackAndSetText(Value)
					end
				end
				Sliderbox_2.FocusLost:Connect(function()
					GetSliderValue(Sliderbox_2.Text)
				end)
				local slider_function = {}
				function slider_function.SetValue(Value)
					GetSliderValue(Value)
				end
				local controlData = {
                    Name = TitleText,
                    Section = Section,
                    Element = SliderFrame,
                    SectionName = Section_Name,
                    TabName = Page_Name,
                    TabButton = PageName
                }
                table.insert(getgenv().AllControls, controlData)
                
				return slider_function
			end
			return sectionFunction
		end
        local pagefunc = {}
        function pagefunc:AddLeftGroupbox(name)
            return pageFunction:AddSection(name)
        end
        function pagefunc:AddRightGroupbox(name)
            return pageFunction:AddSection(name)
        end
		return pagefunc
        end

	return Main_Function
end

return Library
]====])())

-- [FIXED - theo yêu cầu boss man] Bỏ hẳn hệ thống longhihiConfig/SaveConfig
-- + vòng lặp monkey-patch Tab.AddToggle/AddDropdown của redzlib — hệ thống
-- đó viết riêng cho chữ ký hàm 1-tham-số của redz (function(self, data)),
-- không tương thích với Fluent (function(self, key, data) — 2 tham số).
-- Fluent có sẵn SaveManager/InterfaceManager CHÍNH THỨC làm đúng việc này
-- (tự lưu/tải mọi Toggle/Dropdown/Slider theo key), an toàn hơn hẳn so với
-- monkey-patch tay — không mất tính năng lưu cấu hình, chỉ đổi cơ chế.

Tabs.Hop:AddSection("And Another longhihi hub Script")
do
    Tabs.Hop:AddButton({
    Title =  "Copy Full Farm Fruit Script",
    Description =  "Copy script farm trái đầy đủ",
    Callback =  function()
        local fullScript = [[
repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer
getgenv().Team = "Pirates" -- "Pirates" or "Marines"

pcall(function()
    if not game:GetService("Players").LocalPlayer.Team then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
    end
end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/tranduykhanh08428-web/VantablackHub/refs/heads/main/Vantablackfruit.lua.txt"))()
]]
        if setclipboard then
            setclipboard(fullScript)
        elseif toclipboard then
            toclipboard(fullScript)
        end
    end

})
end

do
    Tabs.Hop:AddButton({
    Title =  "Copy Full Farm Chest Script",
    Description =  "Copy script farm rương đầy đủ",
    Callback =  function()
        local fullScript = [[
repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer
getgenv().Team = "Pirates" -- "Pirates" or "Marines"

pcall(function()
    if not game:GetService("Players").LocalPlayer.Team then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
    end
end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/tranduykhanh08428-web/VantablackHub/refs/heads/main/Vantablackchest.lua.txt"))()
]]
        if setclipboard then
            setclipboard(fullScript)
        elseif toclipboard then
            toclipboard(fullScript)
        end
    end

})
end

Tabs.Info:AddSection("Information")
Tabs.Info:AddParagraph({Title = "DUCK Hub", Content = "Nhóm hóng upd và script kaitun!" .. "\nInvite: " .. "https://discord.gg/gk4EM7CVEp"})

-- [NEW] Discord Button - Copy link discord
Tabs.Info:AddButton({
    Title = "📋 Copy Discord Link",
    Description = "Sao chép link Discord vào clipboard",
    Callback = function()
        local discordLink = "https://discord.gg/gk4EM7CVEp"
        if setclipboard then
            setclipboard(discordLink)
            game.StarterGui:SetCore("SendNotification", {
                Title = "longhihi Hub",
                Text = "Đã copy link Discord!",
                Duration = 3
            })
        elseif toclipboard then
            toclipboard(discordLink)
            game.StarterGui:SetCore("SendNotification", {
                Title = "longhihi Hub",
                Text = "Đã copy link Discord!",
                Duration = 3
            })
        else
            game.StarterGui:SetCore("SendNotification", {
                Title = "longhihi Hub",
                Text = "Executor không hỗ trợ setclipboard!",
                Duration = 5
            })
        end
    end
})

Tabs.Info:AddSection("Status Server")
local TimeZone = Tabs.Info:AddParagraph({Title = "Time Zone", Content = ""})

function UpdateOS()
    local date = os.date("*t")
    local hour = (date.hour) % 24
    local ampm = hour < 12 and "AM" or "PM"
    local timezone = string.format("%02i:%02i:%02i %s", ((hour - 1) % 12) + 1, date.min, date.sec, ampm)
    local datetime = string.format("%02d/%02d/%04d", date.day, date.month, date.year)    
    
    local LocalizationService = game:GetService("LocalizationService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local result, code    
    
    if not getgenv().countryRegionCode then
        result, code = pcall(function()
            -- Sửa lỗi chính tả "LocaglizationService" thành "LocalizationService"
            return LocalizationService:GetCountryRegionForPlayerAsync(player)
        end)
        if result then
            getgenv().countryRegionCode = code
        else
            getgenv().countryRegionCode = "Unknown"
        end
    else
        code = getgenv().countryRegionCode
    end
    
    pcall(function() TimeZone:SetContent(datetime.." - "..timezone.." [ " .. code .. " ]") end)
end

task.spawn(function()
    while true do
        UpdateOS()
        task.wait(1)
    end
end)

local GameTime = Tabs.Info:AddParagraph({Title = "Game Time", Content = ""})

function UpdateGameTime()
    local GameTimeValue = math.floor(workspace.DistributedGameTime + 0.5)
    local Hour = math.floor(GameTimeValue / (60^2)) % 24
    local Minute = math.floor(GameTimeValue / (60^1)) % 60
    local Second = math.floor(GameTimeValue / (60^0)) % 60
    pcall(function() GameTime:SetContent(Hour.." Hour (h) "..Minute.." Minute (m) "..Second.." Second (s)") end)
end

task.spawn(function()
    while true do
        UpdateGameTime()
        task.wait(1)
    end
end)

local MirageCheck = Tabs.Info:AddParagraph({Title = "Mirage Island", Content = "Status: "})
local previousMirageStatus = ""
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local locations = game.Workspace:FindFirstChild("_WorldOrigin") and game.Workspace._WorldOrigin:FindFirstChild("Locations")
            local mirageIslandExists = locations and locations:FindFirstChild('Mirage Island') ~= nil
            local currentStatus = mirageIslandExists and '✅' or '❌'
            if currentStatus ~= previousMirageStatus then
                pcall(function() MirageCheck:SetContent('Status: ' .. currentStatus) end)
                previousMirageStatus = currentStatus
            end
        end)
    end
end)

local KitsuneCheck = Tabs.Info:AddParagraph({Title = "Kitsune Island", Content = "Status: "})
local previousKitsuneStatus = ""
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local mapFolder = game:GetService("Workspace"):FindFirstChild("Map")
            local currentStatus = (mapFolder and mapFolder:FindFirstChild("KitsuneIsland")) and '✅' or '❌'
            if currentStatus ~= previousKitsuneStatus then
                pcall(function() KitsuneCheck:SetContent('Status: ' .. currentStatus) end)
                previousKitsuneStatus = currentStatus
            end
        end)
    end
end)

local PrehistoricCheck = Tabs.Info:AddParagraph({Title = "Prehistoric Island", Content = "Status: "})
local previousPrehistoricStatus = ""
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local locations = game.Workspace:FindFirstChild("_WorldOrigin") and game.Workspace._WorldOrigin:FindFirstChild("Locations")
            local currentStatus = (locations and locations:FindFirstChild("Prehistoric Island")) and '✅' or '❌'
            if currentStatus ~= previousPrehistoricStatus then
                pcall(function() PrehistoricCheck:SetContent("Status: " .. currentStatus) end)
                previousPrehistoricStatus = currentStatus
            end
        end)
    end
end)

local FrozenCheck = Tabs.Info:AddParagraph({Title = "Frozen Dimension", Content = "Status: "})
local previousFrozenStatus = ""
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local locations = game.Workspace:FindFirstChild("_WorldOrigin") and game.Workspace._WorldOrigin:FindFirstChild("Locations")
            local currentStatus = (locations and locations:FindFirstChild('Frozen Dimension')) and '✅' or '❌'
            if currentStatus ~= previousFrozenStatus then
                pcall(function() FrozenCheck:SetContent('Status: ' .. currentStatus) end)
                previousFrozenStatus = currentStatus
            end
        end)
    end
end)

local CakePrinceStatus = Tabs.Info:AddParagraph({Title = "Cake Prince", Content = ""})
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local commF = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")
            if commF then
                local cakePrince = commF:InvokeServer("CakePrinceSpawner")
                local killStatus = "Cake Prince: ✅"
                -- Fix lỗi khi không ở Sea 3 / Remote trả về nil
                if type(cakePrince) == "string" and string.len(cakePrince) >= 86 then
                    local killCount = string.sub(cakePrince, 39, 41)
                    killStatus = "Killed: " .. killCount
                end
                pcall(function() CakePrinceStatus:SetContent(killStatus) end)
            end
        end)
    end
end)

local RipIndraCheck = Tabs.Info:AddParagraph({Title = "Rip Indra", Content = "Status: "})
local previousRipStatus = ""
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local enemiesFolder = game:GetService("Workspace"):FindFirstChild("Enemies")
            local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form") or 
                                   (enemiesFolder and enemiesFolder:FindFirstChild("rip_indra"))) and '✅' or '❌'
            if currentStatus ~= previousRipStatus then
                pcall(function() RipIndraCheck:SetContent("Status: " .. currentStatus) end)
                previousRipStatus = currentStatus
            end
        end)
    end
end)

-- [ADDED] PlaceId Status
Tabs.Info:AddParagraph({Title = "Place Id", Content = tostring(game.PlaceId)})

-- [ADDED] Server Time (uptime)
local StatServer = Tabs.Info:AddParagraph({Title = "Server Time", Content = ""})
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local serverTime = math.floor(workspace.DistributedGameTime)
            local mins = math.floor(serverTime / 60)
            local secs = serverTime % 60
            if serverTime < 60 then
                StatServer:SetContent(secs .. " Second(s)")
            else
                StatServer:SetContent(mins .. " Minute(s), " .. secs .. " Second(s)")
            end
        end)
    end
end)

-- [ADDED] Elite Progress
local StatElite = Tabs.Info:AddParagraph({Title = "Elite Progress", Content = ""})
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if World3 then
                local eliteVal = replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress")
                StatElite:SetContent("Elite Progress: " .. tostring(eliteVal))
            else
                StatElite:SetContent("Elite Progress: N/A")
            end
        end)
    end
end)

-- [ADDED] Ken (Observation) Level
local StatKen = Tabs.Info:AddParagraph({Title = "Ken Level", Content = ""})
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local kenValue = LocalPlayer:FindFirstChild("VisionRadius")
            if kenValue then
                StatKen:SetContent(tostring(math.floor(kenValue.Value)) .. " / 5000")
            else
                StatKen:SetContent("N/A")
            end
        end)
    end
end)

local DoughKingCheck = Tabs.Info:AddParagraph({Title = "Dough King", Content = "Status: "})
local previousDoughStatus = ""
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local enemiesFolder = game:GetService("Workspace"):FindFirstChild("Enemies")
            local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("Dough King") or 
                                   (enemiesFolder and enemiesFolder:FindFirstChild("Dough King"))) and '✅' or '❌'
            if currentStatus ~= previousDoughStatus then
                pcall(function() DoughKingCheck:SetContent("Status: " .. currentStatus) end)
                previousDoughStatus = currentStatus
            end
        end)
    end
end)

local FullMoonCheck = Tabs.Info:AddParagraph({Title = "Full Moon", Content = ""})

task.spawn(function()
    while task.wait(1) do
        local moonTextureId = game:GetService("Lighting").Sky.MoonTextureId
        local moonStatus = "Moon: 0/5"
        
        if moonTextureId == "http://www.roblox.com/asset/?id=9709149431" then
            moonStatus = "Moon: 5/5 (Full Moon) ✅"
        elseif moonTextureId == "http://www.roblox.com/asset/?id=9709149052" then
            moonStatus = "Moon: 4/5"
        elseif moonTextureId == "http://www.roblox.com/asset/?id=9709143733" then
            moonStatus = "Moon: 3/5"
        elseif moonTextureId == "http://www.roblox.com/asset/?id=9709150401" then
            moonStatus = "Moon: 2/5"
        elseif moonTextureId == "http://www.roblox.com/asset/?id=9709149680" then
            moonStatus = "Moon: 1/5"
        end
        
        pcall(function() FullMoonCheck:SetContent(moonStatus) end)
    end
end)

local LegendarySwordCheck = Tabs.Info:AddParagraph({Title = "Legendary Sword", Content = "Status: "})

spawn(function()
    while wait(1) do
        local swordStatus = "Not Found"
        
        if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1") then
            swordStatus = "Shisui ✅"
        elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2") then
            swordStatus = "Wando ✅"
        elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "3") then
            swordStatus = "Saddi ✅"
        end
        
        pcall(function() LegendarySwordCheck:SetContent(swordStatus) end)
    end
end)

local BoneCount = Tabs.Info:AddParagraph({Title = "Bone", Content = ""})

spawn(function()
    while wait(1) do
        local bones = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check")
        pcall(function() BoneCount:SetContent("You Have: " .. tostring(bones) .. " Bones") end)
    end
end)

-- ============================================================
-- CHECK STATS — logic đọc Level các chỉ số từ file bf, viết lại
-- bằng biến "plr" toàn cục sẵn có của Maru
-- ============================================================
local CheckStats = Tabs.Info:AddParagraph({Title = "Check Stats", Content = "Đang tải..."})

local function GetMaruStatsText()
    local Data = plr.Character and plr.Character:FindFirstChild("Data")
    if not Data then
        return "Không tìm thấy Data (thử lại sau khi hồi sinh)"
    end
    local Stats = Data:FindFirstChild("Stats")
    if not Stats then
        return "Không tìm thấy Stats"
    end
    local lines = {}
    for _, statName in ipairs({"Melee", "Defense", "Sword", "Gun", "Demon Fruit"}) do
        local statFolder = Stats:FindFirstChild(statName)
        if statFolder and statFolder:FindFirstChild("Level") then
            table.insert(lines, string.format("%s Level: %s", statName, tostring(statFolder.Level.Value)))
        else
            table.insert(lines, string.format("%s Level: ❌", statName))
        end
    end
    return table.concat(lines, "\n")
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            CheckStats:SetContent(GetMaruStatsText())
        end)
    end
end)

local RFSubmarineWorkerSpeak = replicated.Modules.Net["RF/SubmarineWorkerSpeak"]

-- [DIAGNOSTIC] Helper: wrap element additions in pcall + log errors
local _elErrs = {}
local function _safeAdd(name, fn)
    local ok, err = pcall(fn)
    if not ok then
        table.insert(_elErrs, name .. ": " .. tostring(err))
        pcall(function()
            Fluent:Notify({Title = "Element Error", Content = name .. ": " .. tostring(err):sub(1,100), Duration = 8})
        end)
    end
end

_safeAdd("Dropdown_SelectWeapon", function()
    Tabs.Main:AddDropdown("Main_SelectWeapon", {
    Title =  "Weapon",
    Values =  {"Melee","Sword","Blox Fruit","Gun"},
    Default =  "Melee",
    Callback =  function(Value)
    _G.ChooseWP = Value
end,
    Multi = false
    })
end)


spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.ChooseWP == "Melee" then
                for _,v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.ChooseWP == "Sword" then
                for _,v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.ChooseWP == "Gun" then
                for _,v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Gun" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.ChooseWP == "Blox Fruit" then
                for _,v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Blox Fruit" then
                        _G.SelectWeapon = v.Name
                    end
                end
            end
        end)
    end
end)
-- [REMOVED - theo yêu cầu boss man] Dropdown "UI Scale" đã xoá (không
-- dùng tới). Vị trí này giờ dùng cho "Select Farm Position" (Bước 2C).

_safeAdd("Dropdown_SelectFarmPosition", function()
    Tabs.Main:AddDropdown("Main_SelectFarmPosition", {
    Title = "Select Farm Position",
    Description = "None: đứng cố định | Spin: xoay vòng (gốc Maru) | Orbit: bay vòng (Tab2) | Star: nhảy trục X/Z (Tab2)",
    Values = {"None", "Spin", "Orbit", "Star"},
    Default = "None",
    Callback = function(Value)
        _G.FarmPositionMode = Value
        RandomCFrame = (Value ~= "None")
        if Value == "Spin" then
            _G.SpinAngle = 0
            _G.OrbitLastChange = tick()
        elseif Value == "Orbit" then
            _G.OrbitAngle2 = 0
            _G.OrbitLastTick2 = tick()
        elseif Value == "Star" then
            _G.StarDebounce = 0
        end
    end,
    Multi = false
    })
end)

Tabs.Main:AddSection("Farming")
-- [NEW] Select Farm Mode - gop 4 toggle (Farm Level / Cake Prince / Tyrant / Bone) thanh 1 dropdown
_G.SelectedFarmMode = "None"  -- Default = None (dung yen)
_G.Level = false
_G.Auto_Cake_Prince = false
_G.FarmTyrant = false
_G.ActiveFarm = nil

-- [TRẦN 200 LOCAL CỦA LUAU] Bọc 3 khối INFO bên dưới trong do...end.
-- Các local (_InfoCakeKilled / _InfoTyrantBoss / _InfoTyrantEye / _InfoBone) bị
-- các closure task.spawn giữ làm UPVALUE, nếu khai báo ở scope gốc thì chúng
-- chiếm register của main chunk tới hết file — file này vốn đã sát trần 200
-- local, thêm là tran ngay. do...end đóng scope -> register được giải phóng,
-- UI paragraph + vòng lặp bên trong hoạt động y như cũ.
do
-- ============================================================
-- INFO CAKE PRINCE — nằm trên Select Farm
-- ============================================================
Tabs.Main:AddSection("─── Status: Cake Prince ───")
local _InfoCakeKilled = Tabs.Main:AddParagraph({Title = "Cake Killed", Content = "Đang kiểm tra..."})
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local r = replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner")
            if type(r) == "string" then
                local n = string.match(r, "%d+")
                if n then
                    _InfoCakeKilled:SetContent("Killed: " .. tostring(500 - tonumber(n)) .. " / 500")
                end
            end
        end)
    end
end)

-- ============================================================
-- INFO TYRANT OF THE SKIES — nằm trên Select Farm
-- ============================================================
Tabs.Main:AddSection("─── Status: Tyrant of the Skies ───")
local _InfoTyrantBoss = Tabs.Main:AddParagraph({Title = "Boss Spawn",  Content = "Đang kiểm tra..."})
local _InfoTyrantEye  = Tabs.Main:AddParagraph({Title = "Eye Status",  Content = "Đang kiểm tra..."})
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if workspace.Enemies:FindFirstChild("Tyrant of the Skies") then
                _InfoTyrantBoss:SetContent("✅ Boss đang xuất hiện")
            else
                _InfoTyrantBoss:SetContent("❌ Boss chưa xuất hiện")
            end
        end)
        pcall(function()
            local e    = workspace.Map.TikiOutpost.IslandModel
            local eyes = {e.Eye1, e.Eye2, e.IslandChunks.E.Eye3, e.IslandChunks.E.Eye4}
            local cnt  = 0
            for _, eye in ipairs(eyes) do
                if eye and eye.Transparency ~= 1 then cnt = cnt + 1 end
            end
            _InfoTyrantEye:SetContent("Eyes: " .. cnt .. " / 4")
        end)
    end
end)

-- ============================================================
-- INFO FARM BONE — nằm trên Select Farm
-- ============================================================
Tabs.Main:AddSection("─── Status: Farm Bone ───")
local _InfoBone = Tabs.Main:AddParagraph({Title = "Bone Count", Content = "Đang kiểm tra..."})
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local b = replicated.Remotes.CommF_:InvokeServer("Bones", "Check")
            _InfoBone:SetContent("Bones hiện có: " .. tostring(b or 0))
        end)
    end
end)
end
-- [END do...end cho 3 khối INFO]

_G.AutoFarm_Bone = _G.AutoFarm_Bone or false
Tabs.Main:AddDropdown("Main_SelectFarmMode", {
    Title = "Select Farm",
    Description = "Chọn chế độ farm (None = đứng yên)",
    Values = {"None", "Farm Level", "Farm Cake Prince", "Farm Tyrant of Skies", "Farm Bone"},
    Default = "None",
    Callback = function(Value)
        _G.SelectedFarmMode = Value
        _G.Level            = false
        _G.Auto_Cake_Prince = false
        _G.FarmTyrant       = false
        _G.AutoFarm_Bone    = false
        _G.ActiveFarm       = nil
        alreadyTeleported   = false
        teleporting         = false
        if Value == "None" then
            return
        elseif Value == "Farm Level" then
            _G.Level      = true
            _G.ActiveFarm = "Level"
            _G.AcceptQuestC = false
            _G.AcceptQuestB = false
        elseif Value == "Farm Cake Prince" then
            _G.Auto_Cake_Prince = true
            _G.ActiveFarm       = "CakePrince"
        elseif Value == "Farm Tyrant of Skies" then
            _G.FarmTyrant = true
            _G.ActiveFarm = "Tyrant"
        elseif Value == "Farm Bone" then
            _G.AutoFarm_Bone = true
            _G.ActiveFarm    = "Bone"
        end
    end,
    Multi = false
})

-- [ADDED - theo yêu cầu boss man: "sửa hệ thống farm lv... và check gui
-- quest"] Port từ file tham chiếu (message 10): QuestController — theo
-- dõi quest bằng REMOTE EVENT thật (Remotes.QuestUpdate) thay vì đọc GUI
-- (PlayerGui.Main.Quest.Visible + Container.QuestTitle.Title.Text).
--
-- Đây là gốc rễ đúng nghĩa của bug "check gui quest": đọc GUI text là
-- polling một thứ do ANIMATION/replication client-side cập nhật — có độ
-- trễ thật (đã thấy qua bug AbandonQuest bắn ngay sau StartQuest ở bản
-- trước). Remotes.QuestUpdate:OnClientEvent bắn THẲNG từ server mỗi khi
-- quest state đổi — không polling, không trễ, không cần đoán qua text.
-- Global (không "local") để không tốn thêm slot local cho function chính
-- (đã sát trần 200 local của Lua/Luau).
QuestController = {
    CurrentQuest = "",
    CurrentQuestName = "",
    QuestConnection = nil,
}
QuestController.Set = function(self, data)
    self.CurrentQuest = (function()
        for i, _ in next, data.Progress do
            return i
        end
    end)()
    self.CurrentQuestName = data.InternalQuestName
end
QuestController.Reset = function(self)
    self.CurrentQuest = ""
    self.CurrentQuestName = ""
end
local questConnectOk = pcall(function()
    QuestController.QuestConnection = ReplicatedStorage.Remotes.QuestUpdate.OnClientEvent:Connect(function(a2, a3)
        if a2 and typeof(a2) == "table" then
            QuestController:Set(a2)
            return
        end
        QuestController:Reset()
    end)
end)

-- [ADDED] GetQuestData() == đang có quest active hay không (theo state
-- thật từ QuestController, không phải "Quest GUI đang Visible"). Nếu vì
-- lý do gì đó không kết nối được Remotes.QuestUpdate (đường dẫn remote
-- có thể đổi theo bản game), rơi về cách đọc GUI cũ làm fallback — không
-- để cả hệ thống nghĩ nhầm "không bao giờ có quest active" một cách âm
-- thầm nếu event không bắn.
function GetQuestData()
    if questConnectOk and QuestController.QuestConnection then
        return QuestController.CurrentQuest ~= ""
    end
    local ok, visible = pcall(function()
        return plr.PlayerGui.Main.Quest.Visible
    end)
    return ok and visible or false
end

-- [FIX] alreadyTeleported / teleporting doi tu "local" sang BIEN GLOBAL.
-- Ly do 1: chung nam o main chunk — file nay da sat tran 200 local cua Luau,
--   giu them 2 local nua la tran.
-- Ly do 2: callback cua dropdown "Select Farm" (khai bao PHIA TREN dong nay)
--   chi thay duoc bien global, nen truoc day "alreadyTeleported = false"
--   trong callback chi ghi vao mot bien global "mo coi", khong reset duoc co
--   THAT ma vong lap farm lv dang doc. Doi thanh global -> callback reset
--   dung cung bien vong lap dang dung.
alreadyTeleported = false
teleporting = false
-- [ADDED - fix farm lv "không tween lại mob sau khi nhận quest"] Debounce
-- sau khi vừa gọi StartQuest: quest UI (Visible + Title.Text) không cập
-- nhật CÙNG LÚC trên client — thường trễ vài chục ms tới cả giây sau khi
-- server xử lý xong. Vòng lặp bên dưới chạy mỗi frame (task.wait() không
-- đối số), nên NGAY LẦN LẶP KẾ TIẾP, Title có thể vẫn còn trống/cũ trong
-- lúc Visible đã true — check "title không khớp -> AbandonQuest" phía dưới
-- sẽ tưởng nhầm là sai quest rồi HỦY LUÔN quest vừa nhận, tạo vòng lặp
-- Start->Abandon->Start... không bao giờ tới được đoạn tween-tới-mob. Grace
-- period 1.5s sau lần StartQuest gần nhất để UI kịp cập nhật trước khi tin
-- vào title-check.
local lastStartQuestTime = 0

-- [FIX] Default weapon nếu Dropdown chưa fire callback
if not _G.ChooseWP then _G.ChooseWP = "Melee" end
if not _G.SelectWeapon then
    pcall(function()
        for _, v in pairs(plr.Backpack:GetChildren()) do
            if v:IsA("Tool") and v.ToolTip == "Melee" then
                _G.SelectWeapon = v.Name
                break
            end
        end
    end)
end

-- [REMOVED] Auto Farm Level toggle - da gop vao Select Farm Mode dropdown

local function IsInSubmergedIsland()
    local char = plr.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local islandXZ = Vector3.new(11520.8, 0, 9829.5)
    local playerXZ = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
    return (playerXZ - islandXZ).Magnitude < 2000
end

task.spawn(function()
    while task.wait() do
        if not _G.Level then continue end

        pcall(function()
            local char = plr.Character
            if not char then return end
            local Root = char:FindFirstChild("HumanoidRootPart")
            if not Root then return end

            local level = plr.Data.Level.Value
            local inSub = IsInSubmergedIsland()
            -- [FIXED - "check gui quest"] Bỏ hẳn việc đọc
            -- PlayerGui.Main.Quest.Visible + Container.QuestTitle.Title.Text
            -- (GUI text, có độ trễ replication thật, đây là gốc bug
            -- StartQuest->Abandon->StartQuest ở bản trước) — thay bằng
            -- QuestController (event-driven, Remotes.QuestUpdate) đã thêm
            -- ở trên. GetQuestData() = có quest active hay không, xác thực
            -- ngay khi server bắn event, không cần đợi GUI vẽ lại.
            local hasActiveQuest = GetQuestData()

            if level >= 2600 and not inSub and not teleporting and not alreadyTeleported then
                teleporting = true
                
                local npcPos = CFrame.new(-16269.7041, 25.2288, 1373.6595)
                local teleportAttempts = 0
                
                repeat 
                    task.wait(0.1)
                    if _tp then _tp(npcPos) end
                    teleportAttempts = teleportAttempts + 1
                until not _G.Level or (Root.Position - npcPos.Position).Magnitude <= 15 or teleportAttempts > 30

                if not _G.Level then 
                    teleporting = false
                    return 
                end
                
                pcall(function()
                    ReplicatedStorage.Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer("TravelToSubmergedIsland")
                end)

                local timeout = tick()
                repeat 
                    task.wait(0.1)
                until not _G.Level or IsInSubmergedIsland() or (tick() - timeout > 10)

                alreadyTeleported = true
                teleporting = false
                return
                
            elseif inSub or level < 2600 then
                alreadyTeleported = true
                teleporting = false

                local questData = typeof(QuestNeta) == "function" and QuestNeta() or nil
                if not questData or not questData[1] then return end
                
                -- [FIXED] So sánh THẲNG tên quest (QuestController.CurrentQuestName
                -- vs questData[3]/NameQuest) — quest-name với quest-name, không
                -- còn kiểu "tìm tên mob trong câu GUI text" dễ khớp sai/trễ nữa.
                if hasActiveQuest and QuestController.CurrentQuestName ~= "" and QuestController.CurrentQuestName ~= questData[3] and (tick() - lastStartQuestTime) > 1.5 then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                    return
                end

                if not hasActiveQuest then
                    local questPos = questData[6]
                    if questPos then
                        if (Root.Position - questPos.Position).Magnitude > 15 then
                            if _tp then _tp(questPos) end
                        else
                            lastStartQuestTime = tick()
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData[3], questData[2])
                        end
                    else
                        lastStartQuestTime = tick()
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData[3], questData[2])
                    end
                    return
                end

                local enemyName = questData[1]
                
                -- [FIX] Ensure weapon is selected
                if not _G.SelectWeapon then
                    pcall(function()
                        for _, v in pairs(plr.Backpack:GetChildren()) do
                            if v:IsA("Tool") and v.ToolTip == (_G.ChooseWP or "Melee") then
                                _G.SelectWeapon = v.Name
                                break
                            end
                        end
                    end)
                end
                
                local foundMob = false
                
                for _, v in ipairs(workspace.Enemies:GetChildren()) do
                    if v.Name == enemyName and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        foundMob = true
                        repeat
                            task.wait()
                            if _G.Level and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                                if _tp then _tp(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)) end
                                if Attack and Attack.Kill then Attack.Kill(v, _G.Level) end
                            end
                        until not _G.Level or not v.Parent or not v:FindFirstChild("Humanoid") or v.Humanoid.Health <= 0 or not GetQuestData()
                        break
                    end
                end
                
                if not foundMob then
                    -- Mob chưa spawn -> tween tới spawn point rồi chờ
                    local spawnPos = nil

                    -- [FIXED - fix farm lv "không tween lại mob"] Ưu tiên bảng
                    -- CFrame thật đã verify trước — đáng tin hơn hẳn 2 cách dò
                    -- bên dưới (EnemySpawns/ReplicatedStorage), vốn phụ thuộc
                    -- đúng cấu trúc folder hiện tại của game, dễ gãy khi map
                    -- đổi tên/cấu trúc. Chỉ rơi xuống 2 cách cũ nếu mob không
                    -- có trong bảng (trường hợp hiếm/quest đặc biệt).
                    spawnPos = GetMobFarmPosition and GetMobFarmPosition(enemyName) or nil

                    -- Tìm vị trí spawn
                    if not spawnPos and workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("EnemySpawns") then
                        for _, spawnPoint in ipairs(workspace._WorldOrigin.EnemySpawns:GetChildren()) do
                            if string.find(spawnPoint.Name, enemyName) then
                                spawnPos = spawnPoint.CFrame
                                break
                            end
                        end
                    end
                    
                    -- Fallback: tìm trong ReplicatedStorage
                    if not spawnPos then
                        for _, v in ipairs(ReplicatedStorage:GetChildren()) do
                            if v.Name == enemyName and v:FindFirstChild("HumanoidRootPart") then
                                spawnPos = v.HumanoidRootPart.CFrame
                                break
                            end
                        end
                    end
                    
                    -- Tween tới vị trí spawn
                    if spawnPos and _tp then
                        _tp(spawnPos * CFrame.new(0, 20, 0))
                    end
                    
                    -- Chờ mob spawn rồi farm
                    local waitTime = tick()
                    repeat
                        task.wait(0.5)
                        for _, v in ipairs(workspace.Enemies:GetChildren()) do
                            if v.Name == enemyName and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                foundMob = true
                                repeat
                                    task.wait()
                                    if _G.Level and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                                        if _tp then _tp(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)) end
                                        if Attack and Attack.Kill then Attack.Kill(v, _G.Level) end
                                    end
                                until not _G.Level or not v.Parent or not v:FindFirstChild("Humanoid") or v.Humanoid.Health <= 0 or not GetQuestData()
                                break
                            end
                        end
                        if foundMob then break end
                    until not _G.Level or foundMob or (tick() - waitTime > 15)
                end
            end
        end)
    end
end)

do
    Tabs.Main:AddToggle("Main_AutoFarmNearest", {
    Title =  "Auto Farm Nearest",
    Description =  "Tự động farm quái gần nhất",
    Default =  false,
    Callback =  function(Value)
  _G.AutoFarmNear = Value
  if Value then
      _G.Level = false
      _G.AutoFarm_Bone = false
      _G.AutoFarmIsland = false
      _G.FarmEliteHunt = false
      _G.FarmEliteH = false
      _G.ActiveFarm = "Nearest"
  else
      if _G.ActiveFarm == "Nearest" then
          _G.ActiveFarm = nil
      end
  end
end
})
end

task.spawn(function()
  while task.wait() do
    if not _G.AutoFarmNear then continue end
    
    pcall(function()
      local char = plr.Character
      if not char then return end
      local root = char:FindFirstChild("HumanoidRootPart")
      if not root then return end
      
      local closestMob = nil
      local shortestDistance = math.huge
      
      for _, v in ipairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
          if Attack and Attack.Alive and not Attack.Alive(v) then continue end
          
          local distance = (v.HumanoidRootPart.Position - root.Position).Magnitude
          if distance < shortestDistance then
            shortestDistance = distance
            closestMob = v
          end
        end
      end
      
      if closestMob then
        repeat
          task.wait()
          if _G.AutoFarmNear and closestMob:FindFirstChild("HumanoidRootPart") and closestMob:FindFirstChild("Humanoid") then
            if _tp then _tp(closestMob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)) end
            if Attack and Attack.Kill then Attack.Kill(closestMob, _G.AutoFarmNear) end
          end
        until not _G.AutoFarmNear or not closestMob.Parent or not closestMob:FindFirstChild("Humanoid") or closestMob.Humanoid.Health <= 0
      end
    end)
  end
end)
do
    Tabs.Main:AddToggle("Main_AutoFactoryRaid", {
    Title =  "Auto Factory Raid",
    Description =  "Tự động đi raid nhà máy",
    Default =  false,
    Callback =  function(Value)
        _G.AutoFactory = Value
    end

})
end

spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.AutoFactory then
                local v = GetConnectionEnemies("Core")
                if v then
                    repeat 
                        wait()
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

do
    Tabs.Main:AddToggle("Main_AutoPirateRaid", {
    Title =  "Auto Pirate Raid",
    Description =  "Tự động đi raid hải tặc",
    Default =  false,
    Callback =  function(Value)
        _G.AutoRaidCastle = Value
    end

})
end

spawn(function()
    while wait(Sec) do
        if _G.AutoRaidCastle then
            pcall(function()
                local CFrameCastleRaid = CFrame.new(-5496.17432, 313.768921, -2841.53027, 0.924894512, 7.37058015e-09, 0.380223751, 3.5881019e-08, 1, -1.06665446e-07, -0.380223751, 1.12297109e-07, 0.924894512)
                
                if (CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125).Position - Root.Position).Magnitude <= 500 then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            if v.Name then
                                if (v.HumanoidRootPart.Position - Root.Position).Magnitude <= 2000 then
                                    repeat 
                                        wait() 
                                        Attack.Kill(v, _G.AutoRaidCastle) 
                                    until not _G.AutoRaidCastle or not v.Parent or v.Humanoid.Health <= 0 or not workspace.Enemies:FindFirstChild(v.Name)
                                end
                            end
                        end
                    end
                else
                    local Castle_Mob = {
                        "Galley Pirate","Galley Captain","Raider","Mercenary",
                        "Vampire","Zombie","Snow Trooper","Winter Warrior",
                        "Lab Subordinate","Horned Warrior","Magma Ninja","Lava Pirate",
                        "Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer",
                        "Arctic Warrior","Snow Lurker","Sea Soldier","Water Fighter"
                    }
                    for i = 1, #Castle_Mob do
                        if replicated:FindFirstChild(Castle_Mob[i]) then
                            for _,v in pairs(replicated:GetChildren()) do
                                if table.find(Castle_Mob, v.Name) then 
                                    _tp(CFrameCastleRaid) 
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)
do
    Tabs.Main:AddToggle("Main_AutoFarmEctoplasm", {
    Title =  "Auto Farm Ectoplasm",
    Description =  "Tự động farm Ectoplasm",
    Default =  false,
    Callback =  function(Value)
  _G.AutoEctoplasm = Value
end
})
end
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
Tabs.Main:AddSection("Event Dog House [ BETA ]")
local DogHouseCheck = Tabs.Main:AddParagraph({Title = "Dog House Event", Content = "Status: "})
local previousDogHouseStatus = ""

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            -- Lấy đường dẫn tới PlayerGui và Main
            local player = game.Players.LocalPlayer
            local playerGui = player and player:FindFirstChild("PlayerGui")
            local mainGui = playerGui and playerGui:FindFirstChild("Main")
            
            -- Kiểm tra xem la bàn sự kiện có xuất hiện không
            local isEventActive = mainGui and (mainGui:FindFirstChild("DogHouseCompass") ~= nil)
            
            -- Gán icon Trạng thái
            local currentStatus = isEventActive and '✅' or '❌'
            
            -- Cập nhật giao diện (UI) nếu trạng thái thay đổi để tránh lag game
            if currentStatus ~= previousDogHouseStatus then
                pcall(function() DogHouseCheck:SetContent('Status: ' .. currentStatus) end)
                previousDogHouseStatus = currentStatus
            end
        end)
    end
end)

do
    Tabs.Main:AddToggle("Main_AutoEventDogHouse", {
    Title =  "Auto Event Dog House",
    Description =  "Tự động farm sự kiện Dog House",
    Default =  false,
    Callback =  function(Value)
        _G.AutoFarmNear = Value -- Chỉ giữ lại biến chính để chạy vòng lặp
    end

})
end

task.spawn(function()
    while task.wait() do
        if not _G.AutoFarmNear then continue end
        
        pcall(function()
            local char = plr.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local closestMob = nil
            local shortestDistance = 140 
            
            for _, v in ipairs(workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    if Attack and Attack.Alive and not Attack.Alive(v) then continue end
                    
                    local distance = (v.HumanoidRootPart.Position - root.Position).Magnitude
                    
                    -- Lọc quái: Chỉ lưu nếu quái nằm trong bán kính 155 và gần nhất
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestMob = v
                    end
                end
            end
            
            if closestMob then
                repeat
                    task.wait()
                    if _G.AutoFarmNear and closestMob:FindFirstChild("HumanoidRootPart") and closestMob:FindFirstChild("Humanoid") then
                        if _tp then _tp(closestMob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)) end
                        if Attack and Attack.Kill then Attack.Kill(closestMob, _G.AutoFarmNear) end
                    end
                until not _G.AutoFarmNear or not closestMob.Parent or not closestMob:FindFirstChild("Humanoid") or closestMob.Humanoid.Health <= 0
            end
        end)
    end
end)

Tabs.Main:AddSection("Chest")
do
    Tabs.Main:AddToggle("Main_AutoFarmChest", {
    Title =  "Auto Farm Chest",
    Description =  "Tự động farm rương",
    Default =  false,
    Callback =  function(Value)
  _G.AutoFarmChest = Value
end
})
end
spawn(function()
  while wait(Sec) do
    if _G.AutoFarmChest then
      pcall(function()
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
      end)
    end
  end
end)
do
    Tabs.Main:AddToggle("Main_StopItems", {
    Title =  "Stop Items",
    Description =  "Dừng nhặt vật phẩm rác",
    Default =  true,
    Callback =  function(Value)
    _G.StopWhenChalice = Value
end
})
end

spawn(function()
    while wait(0.2) do
        if _G.StopWhenChalice and (_G.AutoFarmChest or _G.AutoChestBP) then
            pcall(function()
                if GetBP("God's Chalice") or GetBP("Sweet Chalice") or GetBP("Fist of Darkness") then
                    _G.AutoFarmChest = false
                    _G.AutoChestBP = false
                end
            end)
        end
    end
end)

Tabs.Main:AddSection("Collect Berry")
do
    Tabs.Main:AddToggle("Main_AutoFarmBerry", {
    Title =  "Auto Farm Berry",
    Description =  "Tự động farm Berry",
    Default =  false,
    Callback =  function(Value)
  _G.AutoBerry = Value
end
})
end
spawn(function()
  while wait(Sec) do
    if _G.AutoBerry then
      local CollectionService= game:GetService("CollectionService")
      local Players= game:GetService("Players")
      local Player = Players.LocalPlayer
      local BerryBush = CollectionService:GetTagged("BerryBush")      
      local Distance, Nearest = math.huge      
      for i = 1, #BerryBush do
        local Bush = BerryBush[i]        
        for AttributeName, BerryName in pairs(Bush:GetAttributes()) do
          if not BerryArray or table.find(BerryArray, BerryName) then           
            _tp(Bush.Parent:GetPivot())
            for i = 1, #BerryBush do
            local Bush = BerryBush[i]        
              for AttributeName, BerryName in pairs(Bush:GetChildren()) do
                if not BerryArray or table.find(BerryArray, BerryName) then
                  _tp(BerryName.WorldPivot)
                  fireproximityprompt(BerryName.ProximityPrompt,math.huge)
                end
              end
            end      
          end
        end
      end      
    end
  end
end)



do
    Tabs.Main:AddToggle("Main_AutoFarmBerryHop", {
    Title =  "Auto Farm Berry + Hop",
    Description =  "Farm Berry + tự đổi server",
    Default =  false,
    Callback =  function(Value)
  _G.AutoBerryH = Value
end
})
end

spawn(function()
    while wait(Sec) do
        if _G.AutoBerryH then
            local CollectionService = game:GetService("CollectionService")
            local Players = game:GetService("Players")
            local Player = Players.LocalPlayer
            local BerryBush = CollectionService:GetTagged("BerryBush")

            if #BerryBush == 0 then
                local TeleportService = game:GetService("TeleportService")
                local ServerList = {}
                
                local Success, Error = pcall(function()
                    ServerList = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                end)
                
                if Success and ServerList.data then
                    for _, Server in pairs(ServerList.data) do
                        if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, Player)
                            break
                        end
                    end
                end
            else
                for i = 1, #BerryBush do
                    local Bush = BerryBush[i]
                    
                    for AttributeName, BerryName in pairs(Bush:GetAttributes()) do
                        if not BerryArray or table.find(BerryArray, BerryName) then
                            _tp(Bush.Parent:GetPivot())
                            
                            for j = 1, #BerryBush do
                                local Bush2 = BerryBush[j]
                                
                                for _, BerryChild in pairs(Bush2:GetChildren()) do
                                    if not BerryArray or table.find(BerryArray, BerryChild.Name) then
                                        _tp(BerryChild.WorldPivot)
                                        fireproximityprompt(BerryChild.ProximityPrompt, math.huge)
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

Tabs.Main:AddSection("Farm Mob")
if World1 then
    do
    Tabs.Main:AddDropdown("Main_SelectMob", {
    Title =  "Select Mob",
    Default =  Bandit,
    Values =  {
            "Bandit", "Monkey", "Gorilla", "Pirate", "Brute",
            "Desert Bandit", "Desert Officer", "Snow Bandit", "Snowman",
            "Chief Petty Officer", "Sky Bandit", "Dark Master", "Toga Warrior",
            "Gladiator", "Military Soldier", "Military Spy",
            "Fishman Warrior", "Fishman Commando",
            "God's Guard", "Shanda", "Royal Squad", "Royal Soldier",
            "Galley Pirate", "Galley Captain",
        },
    Callback =  function(Value)
            getgenv().SelectMob = Value
        end
    ,
    Multi = false
})
end
end
if World2 then
    do
    Tabs.Main:AddDropdown("Main_SelectMob2", {
    Title =  "Select Mob",
    Default =  Raider,
    Values =  {
            "Raider", "Mercenary", "Swan Pirate", "Factory Staff",
            "Marine Lieutenant", "Marine Captain", "Zombie", "Vampire",
            "Snow Trooper", "Winter Warrior", "Lab Subordinate",
            "Horned Warrior", "Magma Ninja", "Lava Pirate",
            "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer",
            "Arctic Warrior", "Snow Lurker", "Sea Soldier", "Water Fighter",
        },
    Callback =  function(Value)
            getgenv().SelectMob = Value
        end
    ,
    Multi = false
})
end
end
if World3 then
    do
    Tabs.Main:AddDropdown("Main_SelectMob3", {
    Title =  "Select Mob",
    Values =  {
            "Pirate Millionaire", "Dragon Crew Warrior", "Dragon Crew Archer",
            "Female Islander", "Giant Islander", "Marine Commodore",
            "Marine Rear Admiral", "Fishman Raider", "Fishman Captain",
            "Forest Pirate", "Mythological Pirate", "Jungle Pirate",
            "Musketeer Pirate", "Reborn Skeleton", "Living Zombie",
            "Demonic Soul", "Posessed Mummy", "Peanut Scout",
            "Peanut President", "Ice Cream Chef", "Ice Cream Commander",
            "Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker",
            "Cocoa Warrior", "Chocolate Bar Battler", "Sweet Thief",
            "Candy Rebel", "Candy Pirate", "Snow Demon", "Isle Outlaw",
            "Island Boy", "Sun-kissed Warrior", "Isle Champion",
        },
    Callback =  function(Value)
            getgenv().SelectMob = Value
        end
    ,
    Multi = false
})
end
end
do
    Tabs.Main:AddToggle("Main_AutoKillMob", {
    Title =  "Auto Kill Mob",
    Description =  "Tự động giết quái đã chọn",
    Default =  false,
    Callback =  function(Value)
        _G.AutoKillMob = Value
    end

})
end
spawn(function()
    while wait() do
        if _G.AutoKillMob then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild(getgenv().SelectMob) then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == getgenv().SelectMob then
                            if v:FindFirstChild("Humanoid")
                            and v:FindFirstChild("HumanoidRootPart")
                            and v.Humanoid.Health > 0 then                                
                                repeat
                                    game:GetService("RunService").Heartbeat:Wait()
                                    Attack.Kill(v,_G.AutoKillMob)
                                until not _G.AutoKillMob or not v.Parent or v.Humanoid.Health <= 0                                
                            end
                        end
                    end
                end
            end)
        end
    end
end)

Tabs.Main:AddSection("Farm All Island")
local Sea1_Islands = {
    ["Pirates"] = {
        CFrame = CFrame.new(-2709.67944, 24.5206585, 2104.24585, -0.744724929, -3.97967455e-08, -0.667371571, 4.32403588e-08, 1, -1.07884304e-07, 0.667371571, -1.09201515e-07, -0.744724929),
        Mobs = {"Bandit"}
    },

    ["Marine"] = {
        CFrame = CFrame.new(-2709.67944, 24.5206585, 2104.24585, -0.744724929, -3.97967455e-08, -0.667371571, 4.32403588e-08, 1, -1.07884304e-07, 0.667371571, -1.09201515e-07, -0.744724929),
        Mobs = {"Trainee"}
    },

    ["Jungle"] = {
        CFrame = CFrame.new(-1600, 36, 150),
        Mobs = {"Monkey", "Gorilla"}
    },

    ["Pirate Village"] = {
        CFrame = CFrame.new(-1100, 4, 3850),
        Mobs = {"Pirate", "Brute"}
    },

    ["Desert"] = {
        CFrame = CFrame.new(1090, 7, 4370),
        Mobs = {"Desert Bandit", "Desert Officer"}
    },

    ["Frozen Village"] = {
        CFrame = CFrame.new(1200, 28, -1500),
        Mobs = {"Snow Bandit", "Snowman"}
    },

    ["Marine Fortress"] = {
        CFrame = CFrame.new(-4500, 20, 4250),
        Mobs = {"Chief Petty Officer"}
    },

    ["Skylands Lower"] = {
        CFrame = CFrame.new(-5000, 700, -2500),
        Mobs = {"Sky Bandit", "Dark Master"}
    },

    ["Prison"] = {
        CFrame = CFrame.new(4875, 6, 735),
        Mobs = {"Prisoner", "Dangerous Prisoner"}
    },

    ["Colosseum"] = {
        CFrame = CFrame.new(-1500, 60, -290),
        Mobs = {"Toga Warrior", "Gladiator"}
    },

    ["Magma Village"] = {
        CFrame = CFrame.new(-5200, 8, 8400),
        Mobs = {"Military Soldier", "Military Spy"}
    },

    ["Underwater City"] = {
        CFrame = CFrame.new(61160, 5, 1819),
        Mobs = {"Fishman Warrior", "Fishman Commando"}
    },

    ["Skylands Upper"] = {
        CFrame = CFrame.new(-7880, 5545, -380),
        Mobs = {"Shanda", "Royal Squad", "Royal Soldier"}
    }
}


local Sea2_Islands = {

    ["Kingdom of Rose"] = {
        CFrame = CFrame.new(-321, 73, 297),
        Mobs = {
            "Raider",
            "Mercenary",
            "Swan Pirate",
            "Factory Staff"
        }
    },

    ["Green Zone"] = {
        CFrame = CFrame.new(-2447, 73, -3211),
        Mobs = {
            "Marine Lieutenant",
            "Marine Captain"
        }
    },

    ["Graveyard Island"] = {
        CFrame = CFrame.new(-9515, 142, 5536),
        Mobs = {
            "Zombie",
            "Vampire"
        }
    },

    ["Snow Mountain"] = {
        CFrame = CFrame.new(561, 401, -5306),
        Mobs = {
            "Snow Trooper",
            "Winter Warrior"
        }
    },

    ["Hot and Cold (Cold)"] = {
        CFrame = CFrame.new(-6026, 15, -5062),
        Mobs = {
            "Lab Subordinate",
            "Horned Warrior"
        }
    },

    ["Hot and Cold (Hot)"] = {
        CFrame = CFrame.new(-5478, 15, -5240),
        Mobs = {
            "Magma Ninja",
            "Lava Pirate"
        }
    },

    ["Cursed Ship"] = {
        CFrame = CFrame.new(902, 126, 33071),
        Mobs = {
            "Ship Deckhand",
            "Ship Engineer",
            "Ship Steward",
            "Ship Officer"
        }
    },

    ["Ice Castle"] = {
        CFrame = CFrame.new(6137, 294, -6747),
        Mobs = {
            "Arctic Warrior",
            "Snow Lurker"
        }
    },

    ["Forgotten Island"] = {
        CFrame = CFrame.new(-3043, 238, -10191),
        Mobs = {
            "Sea Soldier",
            "Water Fighter"
        }
    }
}


local Sea3_Islands = {

    ["Port Town"] = {
        CFrame = CFrame.new(-290, 44, 5450),
        Mobs = {
            "Pirate Millionaire",
            "Pistol Billionaire"
        }
    },

    ["Hydra Island"] = {
        CFrame = CFrame.new(5228, 604, 345),
        Mobs = {
            "Dragon Crew Warrior",
            "Dragon Crew Archer",
            "Female Islander",
            "Giant Islander",
            "Training Dummy"
        }
    },

    ["Great Tree"] = {
        CFrame = CFrame.new(2682, 1682, -7190),
        Mobs = {
            "Marine Commodore",
            "Marine Rear Admiral"
        }
    },

    ["Floating Turtle"] = {
        CFrame = CFrame.new(-12000, 331, -8500),
        Mobs = {
            "Forest Pirate",
            "Mythological Pirate",
            "Jungle Pirate",
            "Musketeer Pirate",
            "Fishman Raider",
            "Fishman Captain"
        }
    },

    ["Haunted Castle"] = {
        CFrame = CFrame.new(-9515, 142, 5536),
        Mobs = {
            "Reborn Skeleton",
            "Living Zombie",
            "Demonic Soul",
            "Posessed Mummy"
        }
    },

    ["Sea of Treats"] = {
        CFrame = CFrame.new(-1145, 13, -14450),
        Mobs = {
            "Peanut Scout",
            "Peanut President",
            "Ice Cream Commander",
            "Cookie Crafter",
            "Cake Guard",
            "Baking Staff",
            "Head Baker",
            "Cocoa Warrior",
            "Chocolate Bar Battler",
            "Sweet Thief",
            "Candy Rebel"
        }
    },

    ["Tiki Outpost"] = {
        CFrame = CFrame.new(-16200, 90, -17300),
        Mobs = {
            "Isle Outlaw",
            "Island Boy",
            "Sun-kissed Warrior",
            "Isle Champion"
        }
    },

    ["Submerged Island"] = {
        CFrame = CFrame.new(-3200, -10, -10000),
        Mobs = {
            "Reef Bandit",
            "Coral Pirate",
            "Sea Chanter",
            "Ocean Prophet",
            "High Disciple",
            "Grand Devotee"
        }
    }
}


if World1 then
    do
    Tabs.Main:AddDropdown("Main_SelectIsland", {
    Title =  "Select Island",
    Values =  {"Pirates", "Marine", "Jungle", "Pirate Village", "Desert", "Frozen Village", "Marine Fortress", "Skylands Lower", "Prison", "Colosseum", "Magma Village", "Underwater City", "Skylands Upper"},
    Callback =  function(Value)
            _G.SelectIsland = Value
        end
    ,
    Multi = false
})
end
end

if World2 then
    do
    Tabs.Main:AddDropdown("Main_SelectIsland2", {
    Title =  "Select Island",
    Values =  {"Kingdom of Rose", "Green Zone", "Graveyard Island", "Snow Mountain", "Hot and Cold (Cold)", "Hot and Cold (Hot)", "Cursed Ship", "Ice Castle", "Forgotten Island"},
    Callback =  function(Value)
            _G.SelectIsland = Value
        end
    ,
    Multi = false
})
end
end

if World3 then
    do
    Tabs.Main:AddDropdown("Main_SelectIsland3", {
    Title =  "Select Island",
    Values =  {"Port Town", "Hydra Island", "Great Tree", "Floating Turtle", "Haunted Castle", "Sea of Treats", "Tiki Outpost", "Submerged Island"},
    Callback =  function(Value)
            _G.SelectIsland = Value
        end
    ,
    Multi = false
})
end
end
local IslandData
if World1 then
    IslandData = Sea1_Islands
elseif World2 then
    IslandData = Sea2_Islands
elseif World3 then
    IslandData = Sea3_Islands
end
do
    Tabs.Main:AddToggle("Main_AutoFarmAllIsland", {
    Title =  "Auto Farm All Island",
    Description =  "Tự động farm cả đảo",
    Default =  false,
    Callback =  function(Value)
        _G.AutoFarmIsland = Value
    end

})
end


task.spawn(function()
    while task.wait(0.2) do
        if not _G.AutoFarmIsland then continue end
        if not _G.SelectIsland then continue end
        if not IslandData then continue end

        local island = IslandData[_G.SelectIsland]
        if not island then continue end

        local islandPos = island.CFrame
        local mobs = island.Mobs

        local MobMap = {}
        for _, name in ipairs(mobs) do
            MobMap[name] = true
        end

        local found = false

        for _, v in pairs(workspace.Enemies:GetChildren()) do
            if MobMap[v.Name]
            and v:FindFirstChild("Humanoid")
            and v:FindFirstChild("HumanoidRootPart")
            and v.Humanoid.Health > 0 then

                found = true
                repeat
                    task.wait()
                    _tp(v.HumanoidRootPart.CFrame * CFrame.new(0,10,0))
                    Attack.Kill(v, true)
                until not _G.AutoFarmIsland
                   or not v.Parent
                   or v.Humanoid.Health <= 0
            end
        end

        if not found then
            _tp(islandPos)
        end
    end
end)

Tabs.Main:AddSection("Farm Elite Hunter")
local Process = Tabs.Main:AddParagraph({Title = "Elites Process", Content = ""})
spawn(function()
    while wait(Sec) do
        pcall(function()    
            pcall(function() Process:SetContent("Elite Progress : " .. replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress")) end)
        end)
    end
end)

local EliteHunter = Tabs.Main:AddParagraph({Title = "Elite Spawn", Content = "Status: "})
spawn(function()
    local previousStatus = ""
    while wait(1) do
        local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") or 
                               game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") or 
                               game:GetService("ReplicatedStorage"):FindFirstChild("Urban") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("Urban")) and '✅' or '❌'
        local progress = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter", "Progress")
        if currentStatus ~= previousStatus then
            pcall(function() EliteHunter:SetContent("Status: " .. currentStatus .. " | Killed: " .. progress) end)
            previousStatus = currentStatus
        end
    end
end)

do
    Tabs.Main:AddToggle("Main_AutoFarmElite", {
    Title =  "Auto Farm Elite",
    Description =  "Tự động farm Tinh Anh",
    Default =  false,
    Callback =  function(Value)
    _G.FarmEliteHunt = Value
end
})
end

spawn(function()
    while wait(1) do
        pcall(function()
            if _G.FarmEliteHunt then
                local questGui = plr.PlayerGui.Main.Quest
                local questTitle = questGui.Container.QuestTitle.Title.Text

                if not questGui.Visible then
                    
                    local result = replicated.Remotes.CommF_:InvokeServer("EliteHunter")
                    if result == nil or string.find(result, "Cooldown") then
                      
                        wait(10)
                        return
                    end
                    task.wait(1)
                else
                    
                    local eliteName = nil
                    for _, name in pairs({"Diablo", "Urban", "Deandre"}) do
                        if string.find(questTitle, name) then
                            eliteName = name
                            break
                        end
                    end

                    if eliteName then
                        local boss = nil
                        
                        for _, v in pairs(replicated:GetChildren()) do
                            if v.Name == eliteName and v:FindFirstChild("HumanoidRootPart") then
                                boss = v
                                break
                            end
                        end
                        for _, v in pairs(Enemies:GetChildren()) do
                            if v.Name == eliteName and Attack.Alive(v) then
                                boss = v
                                break
                            end
                        end

                        if boss and boss:FindFirstChild("HumanoidRootPart") then
                            _tp(boss.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                            repeat
                                wait()
                                Attack.Kill(boss, _G.FarmEliteHunt)
                            until not _G.FarmEliteHunt or not boss.Parent or boss.Humanoid.Health <= 0 or not questGui.Visible
                        else
                           
                            wait(5)
                        end
                    else
                       
                        replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                end
            end
        end)
    end
end)

do
    Tabs.Main:AddToggle("Main_AutoFarmEliteHop", {
    Title =  "Auto Farm Elite + Hop",
    Description =  "Farm Tinh Anh + đổi server",
    Default =  false,
    Callback =  function(Value)
	_G.FarmEliteH = Value
end
})
end


local function HopServer()
	local Http = game:GetService("HttpService")
	local TPS = game:GetService("TeleportService")
	local Api = "https://games.roblox.com/v1/games/"
	local PlaceID = game.PlaceId
	local Servers = {}
	local Cursor = ""
	local foundServer = false

	repeat
		local success, result = pcall(function()
			return game:HttpGet(Api .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. Cursor)
		end)
		if success and result then
			local data = Http:JSONDecode(result)
			if data.data then
				for _, v in pairs(data.data) do
					if v.playing < v.maxPlayers and v.id ~= game.JobId then
						foundServer = true
						TPS:TeleportToPlaceInstance(PlaceID, v.id)
						break
					end
				end
				Cursor = data.nextPageCursor or ""
			end
		end
	until not Cursor or foundServer
end


spawn(function()
	while task.wait(1) do
		pcall(function()
			if _G.FarmEliteH then
				local questGui = plr.PlayerGui.Main.Quest
				local questTitle = questGui.Container.QuestTitle.Title.Text

				
				if not questGui.Visible then
					local result = replicated.Remotes.CommF_:InvokeServer("EliteHunter")
					if result == nil or string.find(result, "Cooldown") then
					
						HopServer()
						return
					end
					task.wait(1)

				else
				
					local eliteName = nil
					for _, name in pairs({"Diablo", "Urban", "Deandre"}) do
						if string.find(questTitle, name) then
							eliteName = name
							break
						end
					end

					if eliteName then
						local boss = nil
						for _, v in pairs(replicated:GetChildren()) do
							if v.Name == eliteName and v:FindFirstChild("HumanoidRootPart") then
								boss = v
								break
							end
						end
						for _, v in pairs(workspace.Enemies:GetChildren()) do
							if v.Name == eliteName and Attack.Alive(v) then
								boss = v
								break
							end
						end

						if boss and boss:FindFirstChild("HumanoidRootPart") then
							_tp(boss.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
							repeat
								wait()
								Attack.Kill(boss, _G.FarmEliteH)
							until not _G.FarmEliteH or not boss.Parent or boss.Humanoid.Health <= 0 or not questGui.Visible
						else
						
							task.wait(5)
							HopServer()
						end
					else
					
						replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
						task.wait(1)
						HopServer()
					end
				end
			end
		end)
	end
end)

Tabs.Main:AddSection("Farm Rip Indra")
do
    Tabs.Main:AddToggle("Main_AutoAttackRipIndra", {
    Title =  "Auto Attack Rip Indra",
    Description =  "Tự động đánh trùm Rip Indra",
    Default =  false,
    Callback =  function(Value)
  _G.AutoRipIngay = Value
end
})
end
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

do
    Tabs.Main:AddToggle("Main_AutoUnlockedHaki", {
    Title =  "Auto Unlocked Haki",
    Description =  "Tự động mở khóa Haki",
    Default =  false,
    Callback =  function(Value)
  _G.AutoUnHaki = Value
end
})
end
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

Tabs.Main:AddSection("Farming Cake")
-- [MOVED] Paragraph "Cake Princes" + vong lap SetContent cua no da duoc
-- chuyen len TREN dropdown "Select Farm" (khoi "INFO CAKE PRINCE") va doi
-- ten thanh "Cake Killed" -> xoa ban cu o day de khong bi duplicate.
-- Toan bo logic farm Cake Prince phia duoi GIU NGUYEN.

-- [REMOVED] Auto Farm Cake Prince toggle - da gop vao Select Farm Mode dropdown

spawn(function()
    while task.wait() do
        if _G.Auto_Cake_Prince and not _G.AutoRaidCastle then
            pcall(function()
                local player = game.Players.LocalPlayer
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                local questUI = player.PlayerGui.Main.Quest
                local enemies = workspace.Enemies
                local cakeMap = workspace.Map:FindFirstChild("CakeLoaf")
                local bigMirror = cakeMap and cakeMap:FindFirstChild("BigMirror")
                if not root then return end

                if _G.AcceptQuest and questUI and not questUI.Visible then
                    local questPos = CFrame.new(-1927.92, 37.8, -12842.54)
                    _tp(questPos)
                    while (questPos.Position - root.Position).Magnitude > 50 do
                        task.wait(0.2)
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

                if not cakeMap then
                    _tp(CFrame.new(-2077, 252, -12373))
                    task.wait(2)
                    return
                end

                if bigMirror and (bigMirror.Other.Transparency == 0 or enemies:FindFirstChild("Cake Prince")) then
                    local boss = GetConnectionEnemies("Cake Prince")
                    if boss then
                        repeat task.wait()
                            Attack.Kill2(boss, _G.Auto_Cake_Prince)
                        until not _G.Auto_Cake_Prince or not boss.Parent or boss.Humanoid.Health <= 0
                    else
                        _tp(CFrame.new(-2151.82, 149.32, -12404.91))
                    end
                else

                    local CakeMobs = {"Cookie Crafter","Cake Guard","Baking Staff","Head Baker"}
                    local mob = GetConnectionEnemies(CakeMobs)
                    if mob then
                        repeat task.wait()
                            Attack.Kill(mob, _G.Auto_Cake_Prince)
                        until not _G.Auto_Cake_Prince or not mob.Parent or mob.Humanoid.Health <= 0 or (bigMirror and bigMirror.Other.Transparency == 0)
                    else
                        _tp(CFrame.new(-2077, 252, -12373))
                    end
                end
            end)
        end
    end
end)

do
    -- [NEW] Accept Quest chung - dung cho Cake Prince va Tyrant
    -- Farm Level khong can vi co san quest
    Tabs.Main:AddToggle("Main_AcceptQuests", {
    Title =  "Accept Quests",
    Description =  "Tự động nhận nhiệm vụ (Farm Level tự động tắt)",
    Default =  false,
    Callback =  function(Value)
        -- Neu dang farm Level thi khong cho bat
        if _G.SelectedFarmMode == "Farm Level" then
            _G.AcceptQuest = false
            _G.AcceptQuestC = false
            _G.AcceptQuestB = false
            _G.AcceptQuestBoss = false
            return
        end
        _G.AcceptQuest = Value
        _G.AcceptQuestC = Value
        _G.AcceptQuestB = Value
        _G.AcceptQuestBoss = Value
    end
})
end


do
    Tabs.Main:AddToggle("Main_AutoSummonCakePrince", {
    Title =  "Auto Summon Cake Prince",
    Description =  "Tự động triệu hồi Hoàng tử Bánh",
    Default =  false,
    Callback =  function(Value)
    _G.AutoSpawnCP = Value
end
})
end

spawn(function()
    while task.wait(2) do
        if _G.AutoSpawnCP then
            pcall(function()
                local CommF = game.ReplicatedStorage.Remotes.CommF_
                local enemies = workspace.Enemies
                local bigMirror = workspace.Map.CakeLoaf:FindFirstChild("BigMirror")
                if not bigMirror then return end
                if enemies:FindFirstChild("Cake Prince") then return end
                if bigMirror.Other.Transparency == 0 then return end

                CommF:InvokeServer("CakePrinceSpawner", true)
            end)
        end
    end
end)


do
    Tabs.Main:AddToggle("Main_AutoDoughKingFully", {
    Title =  "Auto Dough King [Fully]",
    Description =  "Tự động farm Vua Bột full quy trình",
    Default =  false,
    Callback =  function(Value)
        _G.AutoDoughKing = Value
    end

})
end

spawn(function()
    while wait() do
        if _G.AutoDoughKing then
            pcall(function()
                if not workspace.Map.CakeLoaf:FindFirstChild("RedDoor") then
                    if GetBP("Red Key") then
                        replicated.Remotes.CommF_:InvokeServer("CakeScientist", "Check")
                        replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Check")
                    end
                elseif workspace.Map.CakeLoaf:FindFirstChild("RedDoor") then
                    if GetBP("Red Key") then
                        repeat
                            task.wait()
                            _tp(CFrame.new(-2681.97998, 64.3921585, -12853.7363,0.149007782, -1.87902192e-08, 0.98883605,3.60619588e-08, 1, 1.35681812e-08,-0.98883605, 3.36376011e-08, 0.149007782))
                        until not getgenv().AutoDoughKing or (plr.Character.HumanoidRootPart.CFrame - CFrame.new(-2681.97998, 64.3921585, -12853.7363,0.149007782, -1.87902192e-08, 0.98883605,3.60619588e-08, 1, 1.35681812e-08,-0.98883605, 3.36376011e-08, 0.149007782)).Magnitude <= 5
                        EquipWeapon("Red Key")
                    end
                elseif GetConnectionEnemies("Dough King") then
                    local v = GetConnectionEnemies("Dough King")
                    if v then
                        repeat
                            task.wait()
                            Attack.Kill(v, _G.AutoDoughKing)
                        until not _G.AutoDoughKing or not v.Parent or v.Humanoid.Health <= 0
                    else
                        _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375))
                    end
                end
                if GetBP("Sweet Chalice") then
                    replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
                    _G.AutoAttackDoughKing = true
                else
                    _G.AutoAttackDoughKing = false
                end
                if GetBP("God's Chalice") and GetM("Conjured Cocoa") >= 10 then
                    replicated.Remotes.CommF_:InvokeServer("SweetChaliceNpc")
                end
                if not plr.Backpack:FindFirstChild("God's Chalice")
                    or plr.Character:FindFirstChild("God's Chalice")
                then
                    _G.FarmEliteHunt = true
                else
                    _G.FarmEliteHunt = false
                end
                if GetM("Conjured Cocoa") <= 10 then
                    local v = GetConnectionEnemies{"Cocoa Warrior", "Chocolate Bar Battler"}
                    if v then
                        repeat
                            task.wait()
                            Attack.Kill(v, _G.AutoDoughKing)
                        until _G.AutoDoughKing == false or not v.Parent or v.Humanoid.Health <= 0
                    else
                        _tp(CFrame.new(402.7189025878906, 81.06050109863281, -12259.54296875))
                    end
                end
            end)
        end
    end
end)
do
    Tabs.Main:AddToggle("Main_AutoFarmDoughKing", {
    Title =  "Auto Farm Dough King",
    Description =  "Tự động farm Vua Bột",
    Default =  false,
    Callback =  function(Value)
        _G.AutoAttackDoughKing = Value
    end

})
end
spawn(function()
    while wait() do
        if _G.AutoAttackDoughKing then
            pcall(function()
                local v = GetConnectionEnemies("Dough King")
                if v then
                    repeat 
                        task.wait()
                        Attack.Kill(v,_G.AutoAttackDoughKing)
                    until not _G.AutoAttackDoughKing or not v.Parent or v.Humanoid.Health <= 0
                else
                    _tp(CFrame.new(-1943.6765, 251.5095, -12337.8809))
                end
            end)
        end
    end
end)

do
    Tabs.Main:AddToggle("Main_AutoFarmDoughKingHop", {
    Title =  "Auto Farm Dough King + Hop",
    Description =  "Farm Vua Bột + tự đổi server",
    Default =  false,
    Callback =  function(Value)
        _G.AutoHop_Dough = Value
    end

})
end


local function HopServer()
    pcall(function()
        local Http = game:GetService("HttpService")
        local Servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        local data = Http:JSONDecode(req)

        for i,v in pairs(data.data) do
            if v.playing < v.maxPlayers then
                table.insert(Servers, v.id)
            end
        end
        if #Servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Servers[math.random(1,#Servers)], game.Players.LocalPlayer)
        end
    end)
end


spawn(function()
    while task.wait() do
        if _G.AutoHop_Dough then
            pcall(function()
                local v = GetConnectionEnemies("Dough King")

                if v then
                 
                    repeat 
                        task.wait()
                        Attack.Kill(v, _G.AutoHop_Dough)
                    until not _G.AutoHop_Dough or not v.Parent or v.Humanoid.Health <= 0

                else
                  
                    _tp(CFrame.new(-1943.6765, 251.5095, -12337.8809))

                    task.wait(2)

                    
                    local checkAgain = GetConnectionEnemies("Dough King")

                    if not checkAgain and _G.AutoHop_Dough then
                        HopServer()
                    end
                end
            end)
        end
    end
end)

Tabs.Main:AddSection("Farming Bone")
-- [MOVED] Paragraph "Bones" + vong lap SetContent cua no da duoc chuyen len
-- TREN dropdown "Select Farm" (khoi "INFO FARM BONE") va doi ten thanh
-- "Bone Count" -> xoa ban cu o day de khong bi duplicate.
-- Toan bo toggle + logic farm Bone phia duoi GIU NGUYEN.

do
    -- [REMOVED - theo yêu cầu boss man] Toggle "Auto Farm Bone" đã xoá —
    -- Dropdown "Select Farm" (Main_SelectFarmMode) đã có lựa chọn
    -- "Farm Bone" tự set _G.AutoFarm_Bone = true, 2 công tắc cùng 1 tính
    -- năng là thừa. Logic farm Bone thật (spawn loop bên dưới) GIỮ NGUYÊN.
end

spawn(function()
    local player = game.Players.LocalPlayer
    local BonesTable = {
        "Reborn Skeleton",
        "Living Zombie",
        "Demonic Soul",
        "Possessed Mummy"
    }

    while wait(0.5) do
        if not _G.AutoFarm_Bone then continue end

        pcall(function()
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end

           
            local questUI =
                player.PlayerGui:FindFirstChild("Main")
                and player.PlayerGui.Main:FindFirstChild("Quest")

            local bone = GetConnectionEnemies(BonesTable)

            
            if _G.AcceptQuestB and questUI and not questUI.Visible then
                local questPos = CFrame.new(-9516.99316,172.01718,6078.46533)
                _tp(questPos)

                repeat wait(2)
                until not _G.AutoFarm_Bone
                   or (questPos.Position - root.Position).Magnitude <= 50

                if not _G.AutoFarm_Bone then return end

                local questData = {
                    {"StartQuest","HauntedQuest2",2},
                    {"StartQuest","HauntedQuest2",1},
                    {"StartQuest","HauntedQuest1",1},
                    {"StartQuest","HauntedQuest1",2}
                }

                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    unpack(questData[math.random(1,#questData)])
                )
            end

           
            if bone then
                -- [FIX] Truyen dung _G.AutoFarm_Bone thay vi true cung de check live
                repeat
                    wait()
                    if not _G.AutoFarm_Bone then break end
                    if _G.ActiveFarm and _G.ActiveFarm ~= "Bone" then break end
                    Attack.Kill(bone, _G.AutoFarm_Bone)
                until not _G.AutoFarm_Bone
                   or not bone.Parent
                   or bone.Humanoid.Health <= 0 or bone.Humanoid.Health <= 0
            else
            
                _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
            end
        end)
    end
end)

-- [REMOVED] Accept Quests2 - da gop vao Accept Quest chung



do
    Tabs.Main:AddToggle("Main_AutoSoulReaper", {
    Title =  "Auto Soul Reaper",
    Description =  "Tự động farm Thần Chết",
    Default =  false,
    Callback =  function(Value)
  _G.AutoHytHallow = Value
end
})
end
spawn(function()
  while wait(Sec) do
    if _G.AutoHytHallow then
      pcall(function()
        local v = GetConnectionEnemies("Soul Reaper")
	    if v then
          repeat task.wait() Attack.Kill(v,_G.AutoHytHallow) until v.Humanoid.Health <= 0 or _G.AutoHytHallow == false
        else
          if not GetBP("Hallow Essence") then
            repeat task.wait(.1)replicated.Remotes.CommF_:InvokeServer("Bones","Buy",1,1)until _G.AutoHytHallow == false or GetBP("Hallow Essence")
          else
            repeat wait(.1) _tp(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))until _G.AutoHytHallow == false or (plr.Character.HumanoidRootPart.CFrame == CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))
		    EquipWeapon("Hallow Essence")
          end
        end
      end)
    end
  end
end)
do
    Tabs.Main:AddToggle("Main_AutoRandomBones", {
    Title =  "Auto Random Bones",
    Description =  "Tự động quay xương ngẫu nhiên",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Random_Bone = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Random_Bone then    
  	    repeat task.wait() replicated.Remotes.CommF_:InvokeServer("Bones","Buy",1,1) until not _G.Auto_Random_Bone
      end
    end)
  end
end)
do
    Tabs.Main:AddToggle("Main_AutoTryLuckGravestone", {
    Title =  "Auto Try Luck Gravestone",
    Description =  "Tự động thử vận may bia mộ",
    Default =  false,
    Callback =  function(Value)
  _G.TryLucky = Value
end
})
end
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
do
    Tabs.Main:AddToggle("Main_AutoPrayGravestone", {
    Title =  "Auto Pray Gravestone",
    Description =  "Tự động cầu nguyện bia mộ",
    Default =  false,
    Callback =  function(Value)
  _G.Praying = Value
end
})
end
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


Tabs.Main:AddSection("Tyrant of the Skies")
-- [MOVED] Paragraph "Boss Spawn" / "Check Status Eyes", function Check_Eye()
-- va cac vong lap task.spawn cua chung da duoc chuyen len TREN dropdown
-- "Select Farm" (khoi "INFO TYRANT OF THE SKIES", ten moi "Boss Spawn" /
-- "Eye Status") -> xoa ban cu o day de khong bi duplicate.
-- Toan bo toggle + logic farm Tyrant phia duoi GIU NGUYEN.

-- [REMOVED] Auto Farm Tyrant toggle - da gop vao Select Farm Mode dropdown

    local _TyrantMobList = {
        "Serpent Hunter",
        "Skull Slayer",
        "Isle Champion",
        "Sun-kissed Warrior",
    }
    local _TyrantCenter = CFrame.new(-16268.287, 152.616, 1390.773)

    task.spawn(function()
        while task.wait() do
            if not _G.FarmTyrant then continue end
            pcall(function()
                if not plr.Character then return end
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                -- Nếu xa đảo quá 5000 studs thì về đảo trước
                if (hrp.Position - _TyrantCenter.Position).Magnitude > 5000 then
                    _tp(_TyrantCenter)
                    local t0 = tick()
                    repeat task.wait(0.1)
                    until not _G.FarmTyrant
                       or not plr.Character
                       or not plr.Character:FindFirstChild("HumanoidRootPart")
                       or (plr.Character.HumanoidRootPart.Position - _TyrantCenter.Position).Magnitude <= 200
                       or (tick() - t0 > 12)
                    if not _G.FarmTyrant then return end
                    hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                end

                -- ƯU TIÊN: Đánh boss trước
                local boss = workspace.Enemies:FindFirstChild("Tyrant of the Skies")
                if boss
                    and boss:FindFirstChild("Humanoid")
                    and boss:FindFirstChild("HumanoidRootPart")
                    and boss.Humanoid.Health > 0
                then
                    repeat
                        task.wait()
                        if not _G.FarmTyrant then break end
                        hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                        if not hrp then break end
                        if (hrp.Position - boss.HumanoidRootPart.Position).Magnitude > 30 then
                            _tp(boss.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                            local t0 = tick()
                            repeat task.wait()
                                hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                            until not _G.FarmTyrant or not hrp
                               or (hrp.Position - boss.HumanoidRootPart.Position).Magnitude <= 30
                               or (tick() - t0 > 8)
                        end
                        if _G.FarmTyrant and Attack and Attack.Kill then
                            Attack.Kill(boss, _G.FarmTyrant)
                        end
                    until not _G.FarmTyrant
                       or not boss.Parent
                       or not boss:FindFirstChild("Humanoid")
                       or boss.Humanoid.Health <= 0
                    return
                end

                -- KHÔNG CÓ BOSS: Tìm quái nhỏ theo thứ tự ưu tiên
                local foundMob = false
                for _, mobName in ipairs(_TyrantMobList) do
                    if not _G.FarmTyrant then break end
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if not _G.FarmTyrant then break end
                        if mob.Name == mobName
                            and mob:FindFirstChild("HumanoidRootPart")
                            and mob:FindFirstChild("Humanoid")
                            and mob.Humanoid.Health > 0
                        then
                            foundMob = true
                            hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                            if not hrp then break end
                            if (hrp.Position - mob.HumanoidRootPart.Position).Magnitude > 30 then
                                _tp(mob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                local t0 = tick()
                                repeat task.wait()
                                    hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                                until not _G.FarmTyrant or not hrp
                                   or (hrp.Position - mob.HumanoidRootPart.Position).Magnitude <= 30
                                   or (tick() - t0 > 8)
                            end
                            repeat
                                task.wait()
                                if not _G.FarmTyrant then break end
                                if Attack and Attack.Kill then
                                    Attack.Kill(mob, _G.FarmTyrant)
                                end
                            until not _G.FarmTyrant
                               or not mob.Parent
                               or not mob:FindFirstChild("Humanoid")
                               or mob.Humanoid.Health <= 0
                            break
                        end
                    end
                    if foundMob then break end
                end

                -- Không tìm thấy quái nào → về trung tâm đảo chờ
                if not foundMob then
                    _tp(_TyrantCenter)
                end
            end)
        end
    end)

do
    Tabs.Main:AddToggle("Main_AutoSummonBoss", {
    Title =  "Auto Summon Boss",
    Description =  "Tự động triệu hồi Boss",
    Default =  false,
    Callback =  function(Value)
    _G.FarmPhaBinh = Value
end
})
end

local function sendSkillKey(skillKey)
    local virtualInputManager = game:GetService("VirtualInputManager")
    virtualInputManager:SendKeyEvent(true, skillKey, false, game)
    wait(0.05)
    virtualInputManager:SendKeyEvent(false, skillKey, false, game)
end

local function equipAndUseSkill(toolType)
    local character = plr.Character
    local backpack = plr.Backpack
    if not (character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0) then return end

    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == toolType then
            item.Parent = character
            wait(0.12)
            for _, skill in ipairs({"Z", "X", "C", "V", "F"}) do
                if not _G.FarmPhaBinh then break end
                pcall(function() sendSkillKey(skill) end)
                wait(0.12)
            end
            item.Parent = backpack
            break
        end
    end
end

local PhaBinhPoints = {
    CFrame.new(-16332.5263671875, 158.07200622558594, 1440.324951171875),
    CFrame.new(-16288.609375, 158.16700744628906, 1470.3680419921875),
    CFrame.new(-16245.412109375, 158.43699645996094, 1463.365966796875),
    CFrame.new(-16212.46875, 158.16700744628906, 1466.343994140625),
    CFrame.new(-16211.9462890625, 158.07200622558594, 1322.39794921875),
    CFrame.new(-16260.921875, 154.92100524902344, 1323.615966796875),
    CFrame.new(-16297.0595703125, 159.322998046875, 1317.2239990234375),
    CFrame.new(-16335.0966796875, 159.33399963378906, 1324.885986328125),
}

spawn(function()
    while wait(Sec) do
        if _G.FarmPhaBinh then
            pcall(function()
                if not (plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0) then return end

                for _, point in ipairs(PhaBinhPoints) do
                    if not _G.FarmPhaBinh then break end

                    _tp(point)

                    local arrived = false
                    local start = tick()
                    while tick() - start < 12 and not arrived and _G.FarmPhaBinh do
                        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                        if not hrp then break end
                        local dist = (hrp.Position - point.Position).Magnitude
                        if dist <= 3 then
                            arrived = true
                            break
                        end
                        wait(0.1)
                    end

                    if _G.FarmPhaBinh and arrived then
                        equipAndUseSkill("Melee")
                        equipAndUseSkill("Sword")
                        equipAndUseSkill("Gun")
                    end
                end
            end)
        end
    end
end)


Tabs.Main:AddSection("Farm Material")
do
    Tabs.Main:AddDropdown("Main_ChooseMaterial", {
    Title =  "Choose Material",
    Description =  "Chọn nguyên liệu cần farm",
    Values =  MaterialList,
    Callback =  function(Value)
			getgenv().SelectMaterial = Value
		end
		,
    Multi = false
})
end
do
    Tabs.Main:AddToggle("Main_AutoFarmMaterials", {
    Title =  "Auto Farm Materials",
    Description =  "Tự động farm nguyên liệu",
    Default =  false,
    Callback =  function(Value)
    getgenv().AutoMaterial = Value
end
})
end
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


Tabs.Main:AddSection("Farm Boss")
		do
    Tabs.Main:AddDropdown("Main_SelectBoss", {
    Title =  "Select Boss",
    Description =  "Chọn Boss muốn farm",
    Values =  BossList,
    Callback =  function(value)
			_G.FindBoss = value
		end
		,
    Multi = false
})
end

do
    Tabs.Main:AddToggle("Main_AutoFarmBoss", {
    Title =  "Auto Farm Boss",
    Description =  "Tự động farm Boss đã chọn",
    Default =  false,
    Callback =  function(value)
        _G.FarmBoss = value
        spawn(function()
            while wait(Sec) do
                if _G.FarmBoss then
                    pcall(function()
                        local HasQuest = QuestBeta()[2] ~= nil and QuestBeta()[3] ~= nil
                        local QuestTitle = plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text

                       
                        if _G.AcceptQuestBoss and HasQuest then
                            if not string.find(QuestTitle, QuestBeta()[0]) then
                                replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                            end

                            if plr.PlayerGui.Main.Quest.Visible == false then
                                _tp(QuestBeta()[5])
                                if (Root.Position - QuestBeta()[5].Position).Magnitude <= 5 then
                                    replicated.Remotes.CommF_:InvokeServer("StartQuest", QuestBeta()[3], QuestBeta()[2])
                                end
                            elseif plr.PlayerGui.Main.Quest.Visible == true then
                                if workspace.Enemies:FindFirstChild(QuestBeta()[1]) then
                                    for i, v in pairs(workspace.Enemies:GetChildren()) do
                                        if Attack.Alive(v) and v.Name == QuestBeta()[1] then
                                            if string.find(QuestTitle, QuestBeta()[0]) then
                                                repeat
                                                    wait()
                                                    Attack.Kill(v, _G.FarmBoss)
                                                until not _G.FarmBoss or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
                                            else
                                                replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                                            end
                                        end
                                    end
                                else
                                    _tp(QuestBeta()[4])
                                    if replicated:FindFirstChild(QuestBeta()[1]) then
                                        _tp(replicated:FindFirstChild(QuestBeta()[1]).HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                    end
                                end
                            end
                        else
                           
                            if workspace.Enemies:FindFirstChild(QuestBeta()[1]) then
                                for i, v in pairs(workspace.Enemies:GetChildren()) do
                                    if Attack.Alive(v) and v.Name == QuestBeta()[1] then
                                        repeat
                                            wait()
                                            Attack.Kill(v, _G.FarmBoss)
                                        until not _G.FarmBoss or v.Humanoid.Health <= 0 or not v.Parent
                                    end
                                end
                            else
                                _tp(QuestBeta()[4])
                                if replicated:FindFirstChild(QuestBeta()[1]) then
                                    _tp(replicated:FindFirstChild(QuestBeta()[1]).HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                end
                            end
                        end
                    end)
                end
            end
        end)
    end

})
end

-- [REMOVED] Accept Quests3 - da gop vao Accept Quest chung


do
    Tabs.Main:AddToggle("Main_AutoFarmAllBoss", {
    Title =  "Auto Farm All Boss",
    Description =  "Tự động farm tất cả Boss",
    Default =  false,
    Callback =  function(Value)
    _G.AutoFarmAllBoss = Value
end
})
end

task.spawn(function()
    while task.wait(0.3) do
        if _G.AutoFarmAllBoss then
            pcall(function()
                local player = game.Players.LocalPlayer
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                local hrp = player.Character.HumanoidRootPart

                local nearestBoss, nearestDist = nil, math.huge

                for _, boss in pairs(workspace.Enemies:GetChildren()) do
                    if boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                        if table.find(BossList, boss.Name) then
                            local dist = (hrp.Position - boss.HumanoidRootPart.Position).Magnitude
                            if dist < nearestDist then
                                nearestBoss = boss
                                nearestDist = dist
                            end
                        end
                    end
                end

                if nearestBoss and nearestBoss:FindFirstChild("HumanoidRootPart") then
                    local bossHRP = nearestBoss.HumanoidRootPart
                    local humanoid = nearestBoss.Humanoid

                    repeat
                        task.wait(0.1)
                        if not _G.AutoFarmAllBoss then break end

                        local targetCFrame = bossHRP.CFrame * CFrame.new(0, 5, 0)
                        if (hrp.Position - targetCFrame.Position).Magnitude > 100 then
                            player.Character:PivotTo(targetCFrame)
                        else
                            _tp(targetCFrame)
                        end

                        if Attack and typeof(Attack.Kill) == "function" then
                            Attack.Kill(nearestBoss, true)
                        end
                    until not nearestBoss.Parent or humanoid.Health <= 0 or not _G.AutoFarmAllBoss
                end
            end)
        end
    end
end)

Tabs.Main:AddSection("Farming Mastery")
local posMastery = {"Cake","Bone"}
do
    Tabs.Main:AddDropdown("Main_ChooseIsland", {
    Title =  "Choose Island",
    Description =  "Chọn đảo để cày thông thạo",
    Values =  posMastery,
    Default =  Bone,
    Callback =  function(Value)
  SelectIsland = Value
end,
    Multi = false
})
end
do
    Tabs.Main:AddToggle("Main_AutoMasteryFruits", {
    Title =  "Auto Mastery Fruits",
    Description =  "Tự động cày thông thạo trái ác quỷ",
    Default =  false,
    Callback =  function(Value)
  _G.FarmMastery_Dev = Value
end
})
end
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
do
    Tabs.Main:AddToggle("Main_AutoMasteryGun", {
    Title =  "Auto Mastery Gun",
    Description =  "Tự động cày thông thạo súng",
    Default =  false,
    Callback =  function(Value)
  _G.FarmMastery_G = Value
end
})
end
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
do
    Tabs.Main:AddToggle("Main_AutoMasteryAllSword", {
    Title =  "Auto Mastery All Sword",
    Description =  "Tự động cày thông thạo tất cả kiếm",
    Default =  false,
    Callback =  function(Value)
  _G.FarmMastery_S = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.FarmMastery_S then
        if SelectIsland == "Cake" then
          for _, v in next, replicated.Remotes.CommF_:InvokeServer("getInventory") do          
            if type(v) == "table" then
              if v.Type == "Sword" then
                SwordName = v.Name
                if tonumber(v.Mastery) >= 1 or tonumber(v.Mastery) <= 599 then
                  local v = GetConnectionEnemies(mastery1)
                  if GetBP(SwordName) then                    
		            if v then
                      repeat wait() Attack.Sword(v,_G.FarmMastery_S) until _G.FarmMastery_S == false or not v.Parent or v.Humanoid.Health <= 0		                  
		            else
		              _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) 
		            end                    
                  else
                    replicated.Remotes.CommF_:InvokeServer("LoadItem",SwordName)   
                  end   
              elseif tonumber(v.Mastery) >= 600 then
                if GetBP(SwordName) then return nil else replicated.Remotes.CommF_:InvokeServer("LoadItem",SwordName) end       
              end
                break
              end
            end         
          end
        elseif SelectIsland == "Bone" then
          for _, v in next, replicated.Remotes.CommF_:InvokeServer("getInventory") do          
            if type(v) == "table" then
              if v.Type == "Sword" then
                SwordName = v.Name
                if tonumber(v.Mastery) >= 1 or tonumber(v.Mastery) <= 599 then
                  local v = GetConnectionEnemies(mastery2)
                  if GetBP(SwordName) then                    
		            if v then
                      repeat wait() Attack.Sword(v,_G.FarmMastery_S) until _G.FarmMastery_S == false or not v.Parent or v.Humanoid.Health <= 0		                  
		            else
		              _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) 
		            end                    
                  else
                    replicated.Remotes.CommF_:InvokeServer("LoadItem",SwordName)   
                  end   
                elseif tonumber(v.Mastery) >= 600 then
                  if GetBP(SwordName) then return nil else replicated.Remotes.CommF_:InvokeServer("LoadItem",SwordName) end       
                end
                break
              end
            end         
          end
        end
      end
    end)
  end
end)






Tabs.Settings:AddSection("Settings / Configure")
-- ============================================================
-- SMOOTH FARM MODE — mac dinh BAT SAN theo yeu cau boss man
-- ============================================================
_G.SmoothFarmMode = true
do
    Tabs.Settings:AddToggle("Settings_SmoothFarmMode", {
    Title = "Farm Smooth (Mượt)",
    Description = "Giảm tốc độ tính toán vòng xoay Spin/Orbit để mượt hơn, đỡ giật trên máy yếu",
    Default = true,
    Callback = function(Value)
        _G.SmoothFarmMode = Value
    end
    })
end

-- ============================================================
-- BUDDHA FARM — tu Tab 2, mac dinh TAT theo yeu cau boss man
-- [FIXED] Prompt gốc dùng plr.Data.DevilFruit.Value — KHÔNG có ở bất kỳ
-- đâu khác trong file này (đã grep). File này luôn xác định fruit hiện
-- có qua Tool.ToolTip == "Blox Fruit" (đã có sẵn hàm global GetFruitTool()
-- làm việc này) — dùng đúng hàm có sẵn đó, check theo TÊN Tool thay vì
-- 1 path Data không xác minh được.
-- ============================================================
_G.BuddhaFarmToggle = false
_G.BuddhaActive     = false
_G.BuddhaTransform  = false

function _IsBuddhaFruitMaru()
    local ok, tool = pcall(GetFruitTool)
    if ok and tool then
        return string.find(string.lower(tool.Name), "buddha") ~= nil
    end
    return false
end

function _ActivateBuddhaMaru()
    pcall(function()
        local char = plr.Character
        local backpack = plr.Backpack
        if not char or not backpack then return end
        _G.BuddhaTransform = true
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool then currentTool.Parent = backpack end
        task.wait(0.1)
        local buddhaItem
        for _, v in pairs(backpack:GetChildren()) do
            if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                buddhaItem = v
                break
            end
        end
        if buddhaItem then char.Humanoid:EquipTool(buddhaItem) end
        task.wait(0.3)
        local vim2 = game:GetService("VirtualInputManager")
        vim2:SendKeyEvent(true, "Z", false, game)
        task.wait(0.05)
        vim2:SendKeyEvent(false, "Z", false, game)
        task.wait(0.5)
        _G.BuddhaTransform = false
    end)
end

function _AnyMaruFarmActiveNow()
    return _G.Level or _G.Auto_Cake_Prince or _G.FarmTyrant
        or _G.AutoFarm_Bone or _G.FarmBoss or getgenv().AutoMaterial
        or _G.TwFruits
end

do
    Tabs.Settings:AddToggle("Settings_BuddhaFarm", {
    Title = "Farm Attack Buddha",
    Description = "Tự động kích hoạt trái Buddha khi đang farm (nếu đang cầm trái Buddha)",
    Default = false,
    Callback = function(Value)
        _G.BuddhaFarmToggle = Value
    end
    })
end

_buddhaRunningMaru = false
task.spawn(function()
    while task.wait(0.25) do
        if _G.BuddhaFarmToggle and _AnyMaruFarmActiveNow() and _IsBuddhaFruitMaru()
           and not _G.BuddhaActive and not _G.BuddhaTransform and not _buddhaRunningMaru then
            _buddhaRunningMaru = true
            task.spawn(function()
                pcall(function()
                    _G.BuddhaTransform = true
                    _ActivateBuddhaMaru()
                    _G.BuddhaActive = true
                    _G.BuddhaTransform = false
                end)
                _buddhaRunningMaru = false
            end)
        end
    end
end)

pcall(function()
    local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Died:Connect(function()
            if _G.BuddhaFarmToggle then
                _G.BuddhaActive = false
                _G.BuddhaTransform = false
            end
        end)
    end
end)

do
    Tabs.Settings:AddToggle("Settings_FastAttack", {
    Title =  "Fast Attack",
    Description =  "Đánh nhanh không delay",
    Default =  true,
    Callback =  function(Value)
  _G.Seriality = Value
end
})
end
do
    Tabs.Settings:AddToggle("Settings_BringMobs", {
    Title =  "Bring Mobs",
    Description =  "Gom quái lại một chỗ",
    Default =  true,
    Callback =  function(Value)
  _B = Value
end
})
end

do
    Tabs.Settings:AddToggle("Settings_AutoHopServerwithtime", {
    Title =  "Auto Hop Server with time",
    Description =  "Tự động đổi server theo thời gian",
    Default =  false,
    Callback =  function(Value)
        _G.AutoHopServer = Value
        if not Value then
            _G.HopTimer = nil
        end
    end

})
end

Spawn(function()
    while Wait(1) do
        if _G.AutoHopServer then
            pcall(function()
                if not _G.HopTimer then
                    _G.HopTimer = tick()
                end

                if tick() - _G.HopTimer >= _G.HopDelay then
                    _G.HopTimer = tick()

                    if syn and syn.queue_on_teleport then
                        syn.queue_on_teleport(
                            "loadstring(game:HttpGet('https://pastefy.app/6hROay1y/raw'))()"
                        )
                    end

                    game:GetService("TeleportService")
                        :Teleport(game.PlaceId, game.Players.LocalPlayer)
                end
            end)
        end
    end
end)
do
    Tabs.Settings:AddSlider("Settings_HopDelayMinutes", {
    Title =  "Hop Delay (Minutes)",
    Description =  "Thời gian chờ trước khi đổi server (phút)",
    Min =  5,
    Max =  120,
    Default =  30,
    Callback =  function(Value)
        _G.HopDelay = Value * 60
    end
,
    Rounding = 0
})
end
do
    Tabs.Settings:AddToggle("Settings_AutoSetSpawnPoint", {
    Title =  "Auto Set Spawn Point",
    Description =  "Tự động đặt điểm hồi sinh",
    Default =  false,
    Callback =  function(Value)
        getgenv().Set = Value
        if Value then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
            end)
        end
    end

})
end
do
    Tabs.Settings:AddToggle("Settings_AutoTurnonBuso", {
    Title =  "Auto Turn on Buso",
    Description =  "Tự động bật Haki vũ trang",
    Default =  true,
    Callback =  function(Value)
  Boud = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
      if Boud then
      local _HasBuso = {"HasBuso","Buso"}
  	  if not plr.Character:FindFirstChild(_HasBuso[1]) then replicated.Remotes.CommF_:InvokeServer(_HasBuso[2]) end
      end
    end)
  end
end)
do
    Tabs.Settings:AddToggle("Settings_AutoHakiObservation", {
    Title =  "Auto Haki Observation",
    Description =  "Tự động bật Haki quan sát",
    Default =  false,
    Callback =  function(Value)
        getgenv().Observation = Value
    end

})
end
spawn(function()
    while wait() do
        if getgenv().Observation then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", true)
            end)
        end
    end
end)
do
    Tabs.Settings:AddToggle("Settings_AutoTurnonRaceV3", {
    Title =  "Auto Turn on Race V3",
    Description =  "Tự động bật Tộc V3 khi đủ điều kiện",
    Default =  false,
    Flag =  "AutoTurnonRaceV3",
    Callback =  function(Value)
  _G.RaceClickAutov3 = Value
end
})
end
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
do
    Tabs.Settings:AddToggle("Settings_AutoTurnonRaceV4", {
    Title =  "Auto Turn on Race V4",
    Description =  "Tự động bật Tộc V4 khi đủ điều kiện",
    Default =  false,
    Callback =  function(Value)
  _G.RaceClickAutov4 = Value
end
})
end
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

-- [REMOVED - theo yêu cầu boss man] Toggle "Auto Turn on Spin" đã xoá —
-- logic spin gắn vào dropdown "Select Farm Position" mới (Bước 2C) thay
-- vì để riêng 1 toggle trong Settings.

do
    Tabs.Settings:AddSlider("Settings_TweenSpeed", {
    Title =  "Tween Speed",
    Description =  "Tốc độ bay / lướt tới quái",
    Min =  100,
    Max =  500,
    Default =  160,
    Callback =  function(Value)
        Settings["Tween Speed"] = Value
    end
,
    Rounding = 0
})
end
do
    Tabs.Settings:AddToggle("Settings_SafeMode", {
    Title =  "Safe Mode",
    Description =  "Chế độ an toàn không bị lỗi",
    Default =  false,
    Callback =  function(Value)
  _G.Safemode = Value
end
})
end
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
do
    Tabs.Settings:AddToggle("Settings_RemoveHitVFX", {
    Title =  "Remove Hit VFX",
    Description =  "Xóa hiệu ứng khi đánh cho mượt",
    Default =  false,
    Callback =  function(Value)
        _G.DestroyHit = Value
    end

})
end

local HitEffects = {"SlashHit", "CurvedRing", "SwordSlash", "SlashTail"}

task.spawn(function()
    while task.wait(Sec) do
        if _G.DestroyHit then
            pcall(function()
                for _, v in pairs(workspace["_WorldOrigin"]:GetChildren()) do
                    if table.find(HitEffects, v.Name) then
                        v:Destroy()
                    end
                end
            end)
        end
    end
end)
do
    Tabs.Settings:AddToggle("Settings_RemoveDeathRespawnedVFX", {
    Title =  "Remove Death & Respawned VFX",
    Description =  "Xóa hiệu ứng chết và hồi sinh",
    Default =  false,
    Callback =  function(Value)
  RDeath = Value
end
})
end
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
do
    Tabs.Settings:AddToggle("Settings_DisableNotify", {
    Title =  "Disable Notify",
    Description =  "Tắt thông báo phiền",
    Default =  false,
    Callback =  function(Value)
  RemoveDamage = Value
end
})
end
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

do
    Tabs.Settings:AddToggle("Settings_AntiAFK", {
    Title =  "Anti AFK",
    Description =  "Chống bị kick vì AFK",
    Default =  true,
    Callback =  function(Value)
        if Value then
            local vu = game:GetService("VirtualUser")
            repeat wait() until game:IsLoaded()
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end

})
end

do
    Tabs.Settings:AddToggle("Settings_AutoAntiAdminJoinServer", {
    Title =  "Auto Anti - Admin Join Server",
    Description =  "Tự động thoát khi Admin vào server",
    Default =  true,
    Callback =  function(Value)
        getgenv().HopServerAdmin = Value
    end

})
end
spawn(function()
    while wait() do
        pcall(function()
            if getgenv().HopServerAdmin then
                for _, v in pairs(game.Players:GetPlayers()) do
                    local blacklist = {
                        "red_game43", "rip_indra", "Axiore", "Polkster", "wenlocktoad",
                        "Daigrock", "toilamvidamme", "oofficialnoobie", "Uzoth", "Azarth",
                        "arlthmetic", "Death_King", "Lunoven", "TheGreateAced", "rip_fud",
                        "drip_mama", "layandikit12", "Hingoi"
                    }
                    if table.find(blacklist, v.Name) then
                        Hop()
                    end
                end
            end
        end)
    end
end)

do
    Tabs.Settings:AddToggle("Settings_NoClip", {
    Title =  "No Clip",
    Description =  "Đi xuyên tường, xuyên vật thể",
    Default =  false,
    Callback =  function(Value)
        getgenv().NoClip = Value
    end

})
end
spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if getgenv().NoClip then
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") or v:IsA("Part") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end)
end)

Tabs.Esp:AddSection("Stats Upgrade")
do
    Tabs.Esp:AddSlider("Esp_StatsValue", {
    Title =  "Stats Value",
    Description =  "Số điểm muốn cộng",
    Default =  10,
    Min =  0,
    Max =  1000,
    Rounding =  1,
    Callback =  function(Value)
  pSats = Value
end,
    Rounding = 0
})
end

do
    Tabs.Esp:AddToggle("Esp_AutoMelee", {
    Title =  "Auto Melee",
    Description =  "Tự động cộng điểm Võ",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Melee = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
    if _G.Auto_Melee then statsSetings("Melee",pSats) end
    end)
  end
end)

do
    Tabs.Esp:AddToggle("Esp_AutoSwords", {
    Title =  "Auto Swords",
    Description =  "Tự động cộng điểm Kiếm",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Sword = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
    if _G.Auto_Sword then statsSetings("Sword",pSats) end
    end)
  end
end)
do
    Tabs.Esp:AddToggle("Esp_AutoGun", {
    Title =  "Auto Gun",
    Description =  "Tự động cộng điểm Súng",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Gun = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
    if _G.Auto_Gun then statsSetings("Gun",pSats) end
    end)
  end
end)
do
    Tabs.Esp:AddToggle("Esp_AutoBloxFruit", {
    Title =  "Auto Blox Fruit",
    Description =  "Tự động cộng điểm Trái",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_DevilFruit = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
    if _G.Auto_DevilFruit then statsSetings("Devil",pSats) end
    end)
  end
end)
do
    Tabs.Esp:AddToggle("Esp_AutoDefense", {
    Title =  "Auto Defense",
    Description =  "Tự động cộng điểm Giáp",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Defense = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
    if _G.Auto_Defense then statsSetings("Defense",pSats) end
    end)
  end
end)

Tabs.Fish:AddSection("Fishing")
do
    Tabs.Fish:AddDropdown("Fish_SelectFishingRod", {
    Title =  "Select Fishing Rod",
    Description =  "Chọn cần câu",
    Values =  {"Fishing Rod", "Gold Rod", "Shark Rod", "Shell Rod", "Treasure Rod"},
    Default =  "Fishing Rod",
    Callback =  function(Value)
        _G.SelectedRod = Value
    end
,
    Multi = false
})
end

do
    Tabs.Fish:AddDropdown("Fish_SelectBait", {
    Title =  "Select Bait",
    Description =  "Chọn mồi câu",
    Values =  {"Basic Bait", "Kelp Bait", "Good Bait", "Abyssal Bait", "Frozen Bait", "Epic Bait", "Carnivore Bait"},
    Default =  "Basic Bait",
    Callback =  function(Value)
        _G.SelectedBait = Value
        if _G.AutoBuyBait then
            pcall(function()
                Remotes.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
            end)
        end
    end
,
    Multi = false
})
end

do
    Tabs.Fish:AddToggle("Fish_AutoBuyBait", {
    Title =  "Auto Buy Bait",
    Description =  "Tự động mua mồi câu",
    Default =  false,
    Callback =  function(Value)
        _G.AutoBuyBait = Value
        if Value then
            pcall(function()
                Remotes.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
            end)
        end
    end

})
end


task.spawn(function()
    while task.wait(2) do
        if _G.AutoBuyBait and _G.SelectedBait then
            pcall(function()
                Remotes.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
            end)
        end
    end
end)




do
    Tabs.Fish:AddToggle("Fish_AutoFishing", {
    Title =  "Auto Fishing",
    Description =  "Tự động câu cá",
    Default =  false,
    Callback =  function(Value)
        _G.AutoFishing = Value
    end

})
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishReplicated = ReplicatedStorage:WaitForChild("FishReplicated")
local FishingRequest = FishReplicated:WaitForChild("FishingRequest")
local Config = require(FishReplicated.FishingClient.Config)
local GetWaterHeight = require(ReplicatedStorage.Util.GetWaterHeightAtLocation)
local MaxDistance = Config.Rod.MaxLaunchDistance

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoFishing then
            pcall(function()
                local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local HRP = Char:FindFirstChild("HumanoidRootPart")
                if not HRP then return end

                local Tool = Char:FindFirstChildOfClass("Tool")

                
                if _G.SelectedRod and (not Tool or Tool.Name ~= _G.SelectedRod) then
                    local backpackTool = LocalPlayer.Backpack:FindFirstChild(_G.SelectedRod)
                    if backpackTool then
                        Char.Humanoid:EquipTool(backpackTool)
                        Tool = backpackTool
                    end
                end

                if Tool then
                    local waterHeight = GetWaterHeight(HRP.Position)
                    local _, hitPos = Workspace:FindPartOnRayWithIgnoreList(
                        Ray.new(Char.Head.Position, HRP.CFrame.LookVector * MaxDistance),
                        {Char, Workspace.Characters, Workspace.Enemies}
                    )
                    local TargetPos = hitPos and Vector3.new(hitPos.X, math.max(hitPos.Y, waterHeight), hitPos.Z)
                    local State = Tool:GetAttribute("State")
                    local ServerState = Tool:GetAttribute("ServerState")

                    if TargetPos and (State == "ReeledIn" or ServerState == "ReeledIn") then
                        FishingRequest:InvokeServer("StartCasting")
                        task.wait()
                        FishingRequest:InvokeServer("CastLineAtLocation", TargetPos, 100, true)
                    elseif ServerState == "Biting" then
                        FishingRequest:InvokeServer("Catching", true)
                        task.wait(0.1)
                        FishingRequest:InvokeServer("Catch", 1)
                    end
                end
            end)
        end
    end
end)


do
    Tabs.Fish:AddToggle("Fish_AutoQuestFishing", {
    Title =  "Auto Quest Fishing",
    Description =  "Tự động làm nhiệm vụ câu cá",
    Default =  false,
    Callback =  function(Value)
    _G.AutoFishingQuest = Value
end
})
end


local Players3 = game:GetService("Players")
local LocalPlayer3 = Players3.LocalPlayer
local ReplicatedStorage3 = game:GetService("ReplicatedStorage")
local RFJobsRemoteFunction3 = ReplicatedStorage3.Modules.Net:WaitForChild("RF/JobsRemoteFunction")

local function HasQuest3()
    local questGui = LocalPlayer3.PlayerGui:FindFirstChild("Quest") or LocalPlayer3.PlayerGui:FindFirstChild("QuestGui")
    if questGui and questGui:FindFirstChild("Container") and questGui.Container:FindFirstChild("QuestTitle") then
        return true
    end
    return false
end

task.spawn(function()
    while task.wait(1) do
        if _G.AutoFishingQuest then
            pcall(function()
                if not HasQuest3() then
                    RFJobsRemoteFunction3:InvokeServer("FishingNPC", "Angler", "AskQuest")
                end
            end)
        end
    end
end)


do
    Tabs.Fish:AddToggle("Fish_AutoCompleteQuest", {
    Title =  "Auto Complete Quest",
    Description =  "Tự động hoàn thành nhiệm vụ",
    Default =  false,
    Callback =  function(Value)
        _G.AutoQuestComplete = Value

        if Value then
            pcall(function()
                Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "FinishQuest")
            end)
        end
    end

})
end


task.spawn(function()
    while task.wait(5) do 
        if _G.AutoQuestComplete then
            pcall(function()
                Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "FinishQuest")
            end)
        end
    end
end)


do
    Tabs.Fish:AddToggle("Fish_AutoSellFish", {
    Title =  "Auto Sell Fish",
    Description =  "Tự động bán cá",
    Default =  false,
    Callback =  function(Value)
        _G.AutoSellFish = Value

        if Value then
            pcall(function()
                Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "SellFish")
            end)
        end
    end

})
end


task.spawn(function()
    while task.wait(5) do 
        if _G.AutoSellFish then
            pcall(function()
                Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "SellFish")
            end)
        end
    end
end)


do
    Tabs.Fish:AddToggle("Fish_AutoSpamSkillZ", {
    Title =  "Auto Spam Skill Z",
    Description =  "Tự động spam skill Z",
    Default =  false,
    Callback =  function(Value)
    _G.AutoSkillZ = Value
end
})
end


local ReplicatedStorage4 = game:GetService("ReplicatedStorage")
local RFJobToolAbilities4 = ReplicatedStorage4.Modules.Net:WaitForChild("RF/JobToolAbilities")

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoSkillZ then
            pcall(function()
                RFJobToolAbilities4:InvokeServer("Z", true)
            end)
        end
    end
end)

do
    Tabs.Quests:AddToggle("Quests_AutoQuestSea2", {
    Title =  "Auto Quest Sea 2",
    Description =  "Tự động làm nhiệm vụ Biển 2",
    Default =  false,
    Callback =  function(Value)
  _G.TravelDres = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.TravelDres then
        if plr.Data.Level.Value >= 700 then
          if workspace.Map.Ice.Door.CanCollide == true and workspace.Map.Ice.Door.Transparency == 0 then
            replicated.Remotes.CommF_:InvokeServer("DressrosaQuestProgress","Detective")
		    EquipWeapon("Key")
		    repeat wait() _tp(CFrame.new(1347.7124, 37.3751602, -1325.6488)) until not _G.TravelDres or (Root.Position == CFrame.new(1347.7124, 37.3751602, -1325.6488).Position)
	      elseif workspace.Map.Ice.Door.CanCollide == false and workspace.Map.Ice.Door.Transparency == 1 then
            if Enemies:FindFirstChild("Ice Admiral") then
              for _,xz in pairs(Enemies:GetChildren()) do
                if xz.Name == "Ice Admiral" and Attack.Alive(xz) then
              	  repeat task.wait() Attack.Kill(xz,_G.TravelDres) until _G.TravelDres == false or xz.Humanoid.Health <= 0
                  replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
                end
              end
            else
              _tp(CFrame.new(1347.7124, 37.3751602, -1325.6488))
            end
	      else
		    replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
	      end
        end
      end
    end)
  end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoQuestSea3", {
    Title =  "Auto Quest Sea 3",
    Description =  "Tự động làm nhiệm vụ Biển 3",
    Default =  false,
    Callback =  function(Value)
  _G.AutoZou = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.AutoZou then
   	    if plr.Data.Level.Value >= 1500 then
          if replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 3 then
            if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess ~= nil then
              replicated.Remotes.CommF_:InvokeServer("F_","TravelZou")
              if replicated.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 0 then
                local v = GetConnectionEnemies("rip_indra")
                if v then
                  repeat wait() Attack.Kill(v,_G.AutoZou) until not _G.AutoZou or not v.Parent or v.Humanoid.Health <= 0
                  Check = 2
                  repeat wait()replicated.Remotes.CommF_:InvokeServer("F_","TravelZou")until Check == 1                   
                else
                  replicated.Remotes.CommF_:InvokeServer("F_","ZQuestProgress","Check") wait(.1)
                  replicated.Remotes.CommF_:InvokeServer("F_","ZQuestProgress","Begin")
                end
              elseif replicated.Remotes["CommF_"]:InvokeServer("ZQuestProgress", "Check") == 1 then
                replicated.Remotes.CommF_:InvokeServer("F_","TravelZou")
              else
                local v = GetConnectionEnemies("Don Swan")
                if v then
                  repeat wait() Attack.Kill(v,_G.AutoZou)until not _G.AutoZou or not v.Parent or v.Humanoid.Health<=0                  
                else
                  repeat wait() _tp(CFrame.new(2288.802, 15.1870775, 863.034607)) until not _G.AutoZou or (Root.Position == CFrame.new(2288.802, 15.1870775, 863.034607).Position)
                  if (Root.CFrame == CFrame.new(2288.802, 15.1870775, 863.034607)) then notween(CFrame.new(2288.802, 15.1870775, 863.034607)) end
                end
              end
            else
            if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
              TabelDevilFruitStore = {}
              TabelDevilFruitOpen = {}
              for i,v in pairs(replicated.Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do
                for i1,v1 in pairs(v) do
                  if i1 == "Name" then table.insert(TabelDevilFruitStore,v1)end
                end
              end
              for i,v in next, game.ReplicatedStorage:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits") do
                if v.Price >= 1000000 then table.insert(TabelDevilFruitOpen,v.Name) end
              end
              for i,DevilFruitOpenDoor in pairs(TabelDevilFruitOpen) do
                for i1,DevilFruitStore in pairs(TabelDevilFruitStore) do
                  if DevilFruitOpenDoor == DevilFruitStore and replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
                    if not plr.Backpack:FindFirstChild(DevilFruitStore) then
                      replicated.Remotes.CommF_:InvokeServer("F_","LoadFruit",DevilFruitStore)
                    else
                      replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","1")
                      replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","2")
                      replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","3")
                    end
                  end
                end
              end
                replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","1")
                replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","2")
                replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","3")
              end
            end
          else
            if replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 0 then
              if string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and plr.PlayerGui.Main.Quest.Visible == true then                
                local v = GetConnectionEnemies("Swan Pirate")
                if v then
                  pcall(function() repeat wait() Attack.Kill(v,_G.AutoZou) until not v.Parent or v.Humanoid.Health <= 0 or _G.AutoZou == false or plr.PlayerGui.Main.Quest.Visible == false end)                    
                else
                  _tp(CFrame.new(1057.92761, 137.614319, 1242.08069))
                end
              else
                _tp(CFrame.new(-456.28952, 73.0200958, 299.895966))
              end
            elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 1 then
              local v = GetConnectionEnemies("Jeremy")
              if v then
                repeat wait() Attack.Kill(v,_G.AutoZou) until not v.Parent or v.Humanoid.Health <= 0 or _G.AutoZou == false
              else
                _tp(CFrame.new(2099.88159, 448.931, 648.997375))
              end
            elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 2 then
              repeat wait() _tp(CFrame.new(-1836, 11, 1714)) until not _G.AutoZou or (Root.Position == CFrame.new(-1836, 11, 1714).Position)
              if (Root.CFrame == CFrame.new(-1836, 11, 1714)) then notween(CFrame.new(-1836, 11, 1714))end
              notween(CFrame.new(-1850.49329, 13.1789551, 1750.89685))
              wait(.1)
              notween(CFrame.new(-1858.87305, 19.3777466, 1712.01807))
              wait(.1)
              notween(CFrame.new(-1803.94324, 16.5789185, 1750.89685))
              wait(.1)
              notween(CFrame.new(-1858.55835, 16.8604317, 1724.79541))
              wait(.1)
              notween(CFrame.new(-1869.54224, 15.987854, 1681.00659))
              wait(.1)
              notween(CFrame.new(-1800.0979, 16.4978027, 1684.52368))
              wait(.1)
              notween(CFrame.new(-1819.26343, 14.795166, 1717.90625))
              wait(.1)
              notween(CFrame.new(-1813.51843, 14.8604736, 1724.79541))
            end
          end
        end
      end
    end)
  end
end)




Tabs.Quests:AddSection("Tushita + Yama")
do
    Tabs.Quests:AddToggle("Quests_AutoTushitaSword", {
    Title =  "Auto Tushita Sword",
    Description =  "Tự động làm kiếm Tushita",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Tushita = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Tushita then
        if workspace.Map.Turtle:FindFirstChild("TushitaGate") then
          if not GetBP("Holy Torch") then
            _tp(CFrame.new(5148.03613, 162.352493, 910.548218))
            wait(0.7)
          else
            EquipWeapon("Holy Torch")
            task.wait(1)
            repeat task.wait() _tp(CFrame.new(-10752, 417, -9366)) until not _G.Auto_Tushita or (CFrame.new(-10752, 417, -9366).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
            wait(.7)
            repeat task.wait() _tp(CFrame.new(-11672, 334, -9474)) until not _G.Auto_Tushita or (CFrame.new(-11672, 334, -9474).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
            wait(.7)
            repeat task.wait() _tp(CFrame.new(-12132, 521, -10655)) until not _G.Auto_Tushita or (CFrame.new(-12132, 521, -10655).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
            wait(.7)
            repeat task.wait() _tp(CFrame.new(-13336, 486, -6985)) until not _G.Auto_Tushita or (CFrame.new(-13336, 486, -6985).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
            wait(.7)
            repeat task.wait() _tp(CFrame.new(-13489, 332, -7925)) until not _G.Auto_Tushita or (CFrame.new(-13489, 332, -7925).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
          end
        else
          local v = GetConnectionEnemies("Longma")
          if v then repeat task.wait() Attack.Kill(v,_G.Auto_Tushita) until v.Humanoid.Health <= 0 or not _G.Auto_Tushita or not v.Parent
          else 
          if replicated:FindFirstChild("Longma") then _tp(replicated:FindFirstChild("Longma").HumanoidRootPart.CFrame * CFrame.new(0,40,0)) end
          end                     
        end
      end
    end)
  end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoYamaSword", {
    Title =  "Auto Yama Sword",
    Description =  "Tự động làm kiếm Yama",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Yama = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Yama then
	    if replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress") < 30 then
	      _G.FarmEliteHunt = true
	    elseif replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress") > 30 then
	      _G.FarmEliteHunt = false
	      if (workspace.Map.Waterfall.SealedKatana.Handle.Position-plr.Character.HumanoidRootPart.Position).Magnitude >= 20 then
            _tp(workspace.Map.Waterfall.SealedKatana.Handle.CFrame)
            local zx = GetConnectionEnemies("Ghost")
            if zx then
              repeat wait() Attack.Kill(zx,_G.Auto_Yama) until zx.Humanoid.Health <= 0 or not zx.Parent or not _G.Auto_Yama               
			  fireclickdetector(workspace.Map.Waterfall.SealedKatana.Handle.ClickDetector)
            end
          end
	    end
      end
    end)
  end
end)

Tabs.Quests:AddSection("Skull Guitars / Misc")
local CheckSoul = Tabs.Quests:AddParagraph({Title = "Skull Guitar Quests", Content = ""})
spawn(function()
    while wait(0.2) do
        pcall(function()
            if Quest1 == true then 
                pcall(function() CheckSoul:SetContent("Quest Number : Quest1") end)
            elseif Quest2 == true then 
                pcall(function() CheckSoul:SetContent("Quest Number : Quest2") end)
            elseif Quest3 == true then 
                pcall(function() CheckSoul:SetContent("Quest Number : Quest3") end)
            elseif Quest4 == true then 
                pcall(function() CheckSoul:SetContent("Quest Number : Quest4") end)
            elseif GetWP("Skull Guitar") then 
                pcall(function() CheckSoul:SetContent("Quest Number : Collect!!") end)
            else 
                pcall(function() CheckSoul:SetContent("Quest Number : No Quest!!") end)
            end
        end)
    end
end)

-- Helper: Detect which material is needed for Soul Guitar
local function DetectRequestSoulGuitar()
    local Mob = {}
    local PlaceId
    local NameRemote
    if replicated.Remotes.CommF_:InvokeServer("CheckEctoplasm", "Amount") < 250 then
        Mob = {"Ship Deckhand [Lv. 1250]", "Ship Steward [Lv. 1300]", "Ship Officer [Lv. 1325]", "Ship Engineer [Lv. 1275]"}
        PlaceId = 4442272183
        NameRemote = "TravelDressrosa"
    elseif replicated.Remotes.CommF_:InvokeServer("Bones", "Check") < 500 then
        Mob = {"Reborn Skeleton [Lv. 1975]", "Demonic Soul [Lv. 2025]", "Living Zombie [Lv. 2000]", "Posessed Mummy [Lv. 2050]"}
        PlaceId = 7449423635
        NameRemote = "TravelZou"
    end
    return Mob, PlaceId, NameRemote
end

do
    Tabs.Quests:AddToggle("Quests_AutoSkullGuitar", {
    Title =  "Auto Skull Guitar",
    Description =  "Tự động làm đàn Skull Guitar",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Soul_Guitar = Value
end
})
end
task.spawn(function()
  while wait() do
    if _G.Auto_Soul_Guitar then 
      pcall(function() 
        local v = GetConnectionEnemies("Living Zombie")
        if v then 
          v.HumanoidRootPart.CFrame = CFrame.new(-10138.3974609375, 138.6524658203125, 5902.89208984375)
          v.Head.CanCollide = false
          v.Humanoid.Sit = false
          v.HumanoidRootPart.CanCollide = false
          v.Humanoid.JumpPower = 0
          v.Humanoid.WalkSpeed = 0
          if v.Humanoid:FindFirstChild('Animator') then v.Humanoid:FindFirstChild('Animator'):Destroy() end
        end    
      end)
    end
  end
end)
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Auto_Soul_Guitar then
                -- Check if already own Skull Guitar
                if plr.Backpack:FindFirstChild("Skull Guitar") or plr.Character:FindFirstChild("Skull Guitar") then
                    _G.Auto_Soul_Guitar = false
                    return
                end
                -- Check material requirements and auto-buy if ready
                local ecto = replicated.Remotes.CommF_:InvokeServer("CheckEctoplasm", "Amount")
                local bones = replicated.Remotes.CommF_:InvokeServer("Bones", "Check")
                local darkFrag = replicated.Remotes.CommF_:InvokeServer("CheckDarkFragment", "Amount")
                if ecto >= 250 and bones >= 500 and darkFrag >= 1 then
                    replicated.Remotes.CommF_:InvokeServer("soulGuitarBuy", true)
                    replicated.Remotes.CommF_:InvokeServer("soulGuitarBuy")
                elseif darkFrag < 1 then
                    if World2 then
                        local v = GetConnectionEnemies("Darkbeard")
                        if v then
                            repeat task.wait() Attack.Kill(v, _G.Auto_Soul_Guitar) until v.Humanoid.Health <= 0 or not v.Parent or not _G.Auto_Soul_Guitar
                        else
                            _tp(CFrame.new(3798.4575195313, 13.826690673828, -3399.806640625))
                        end
                    else
                        replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
                    end
                else
                    local Mob, PlaceId, NameRemote = DetectRequestSoulGuitar()
                    if #Mob > 0 then
                        if game.PlaceId == PlaceId then
                            local v = GetConnectionEnemies(Mob)
                            if v then
                                repeat task.wait() Attack.Kill(v, _G.Auto_Soul_Guitar) until not v or not v.Parent or v.Humanoid.Health <= 0 or not _G.Auto_Soul_Guitar
                            end
                        elseif NameRemote then
                            replicated.Remotes.CommF_:InvokeServer(NameRemote)
                        end
                    end
                end
            end
        end)
    end
end)
function getT(num)
    local rotation
    if num == 1 then
        rotation = workspace.Map["Haunted Castle"].Tablet.Segment1.Line.Rotation
    elseif num == 3 then
        rotation = workspace.Map["Haunted Castle"].Tablet.Segment3.Line.Rotation
    elseif num == 4 then
        rotation = workspace.Map["Haunted Castle"].Tablet.Segment4.Line.Rotation
    elseif num == 7 then
        rotation = workspace.Map["Haunted Castle"].Tablet.Segment7.Line.Rotation
    elseif num == 10 then
        rotation = workspace.Map["Haunted Castle"].Tablet.Segment10.Line.Rotation
    end
    if rotation then
        return rotation.Z
    end
end
function getRT(num)
    local Trophy_Q = workspace.Map["Haunted Castle"].Trophies.Quest
    local Trophy_Pos
    for _, v in pairs(Trophy_Q:GetChildren()) do
        if num == 1 and v.Name == "Trophy1" and v:FindFirstChild("Handle") then
            Trophy_Pos = v.Handle.Rotation
        elseif num == 2 and v.Name == "Trophy2" and v:FindFirstChild("Handle") then
            Trophy_Pos = v.Handle.Rotation         
        elseif num == 3 and v.Name == "Trophy3" and v:FindFirstChild("Handle") then
            Trophy_Pos = v.Handle.Rotation       
        elseif num == 4 and v.Name == "Trophy4" and v:FindFirstChild("Handle") then
            Trophy_Pos = v.Handle.Rotation  
        elseif num == 5 and v.Name == "Trophy5" and v:FindFirstChild("Handle") then
            Trophy_Pos = v.Handle.Rotation     
        end          
        if Trophy_Pos then
            return Trophy_Pos.Z   
        end
    end
end
GetFirePlacard = function(Number,Side)
  if tostring(workspace.Map["Haunted Castle"]["Placard"..Number][Side].Indicator.BrickColor) ~= "Pearl" then
    fireclickdetector(workspace.Map["Haunted Castle"]["Placard"..Number][Side].ClickDetector)
  end
end
spawn(function()
  repeat task.wait() until _G.Auto_Soul_Guitar
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Soul_Guitar then
        if World3 then
          replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
          replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)
          if replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress","Check") == nil then
            _tp(CFrame.new(-8655.0166015625, 141.3166961669922, 6160.0224609375))
            replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
            replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)
           elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress","Check").Swamp == false then
             Quest1 = true;
             Quest2 = false;
             Quest3 = false;
             Quest4 = false;
             local v = GetConnectionEnemies("Living Zombie")
             if v then repeat task.wait() Attack.Kill(v,_G.Auto_Soul_Guitar) until not _G.Auto_Soul_Guitar or v.Humanoid.Health <= 0 or not v.Parent or workspace.Map["Haunted Castle"].SwampWater.Color ~= Color3.fromRGB(117, 0, 0)
             else _tp(CFrame.new(-10170.7275390625, 138.6524658203125, 5934.26513671875))
             end
           elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress","Check").Gravestones == false then
             Quest1 = false;
             Quest2 = true;
             Quest3 = false;
             Quest4 = false;
             GetFirePlacard("7","Left")
             GetFirePlacard("6","Left")
             GetFirePlacard("5","Left")
             GetFirePlacard("4","Right")
             GetFirePlacard("3","Left")
             GetFirePlacard("2","Right")
             GetFirePlacard("1","Right")
           elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress","Check").Ghost == false then
             replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost")
             replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost", true)
           elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress","Check").Trophies == false then
             Quest1 = false;
             Quest2 = false;
             Quest3 = true;
             Quest4 = false;             
             _tp(CFrame.new(-9532.8232421875, 6.471667766571045, 6078.068359375))
             repeat wait()
               local z1 = getRT(1)
               local _z1 = getT(1)
               if z1 and _z1 then
                 fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment1:FindFirstChild("ClickDetector"))
               end
             until z1 == _z1
            repeat wait()
              local z2 = getRT(2)
              local _z2 = getT(3)
              if z2 and _z2 then
                fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment3:FindFirstChild("ClickDetector"))
              end
            until z2 == _z2
          repeat wait()
            local z3 = getRT(3)
            local _z3 = getT(4)
            if z3 and _z3 then
              fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment4:FindFirstChild("ClickDetector"))
            end
          until z3 == _z3
          repeat wait()
            local z4 = getRT(4)
            local _z4 = getT(7)
            if z4 and _z4 then
              fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment7:FindFirstChild("ClickDetector"))
            end
          until z4 == _z4
        repeat wait()
          local z5 = getRT(5)
          local _z5 = getT(10)
          if z5 and _z5 then
            fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment10:FindFirstChild("ClickDetector"))    
          end
        until z5 == _z5
        repeat wait()    
          fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment2:FindFirstChild("ClickDetector"))
          fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment5:FindFirstChild("ClickDetector"))
          fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment6:FindFirstChild("ClickDetector"))
          fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment8:FindFirstChild("ClickDetector"))
          fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment9:FindFirstChild("ClickDetector"))       
        until workspace.Map["Haunted Castle"].Tablet.Segment2.Line.Rotation.Z == 0 or workspace.Map["Haunted Castle"].Tablet.Segment5.Line.Rotation.Z == 0 or workspace.Map["Haunted Castle"].Tablet.Segment6.Line.Rotation.Z == 0 or workspace.Map["Haunted Castle"].Tablet.Segment8.Line.Rotation.Z == 0 or workspace.Map["Haunted Castle"].Tablet.Segment9.Line.Rotation.Z == 0
          elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress","Check").Pipes == false then
            Quest1 = false;
            Quest2 = false;
            Quest3 = false;
            Quest4 = true;
           _tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.CFrame)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.ClickDetector)
		   _tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.CFrame)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
		   _tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.CFrame)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
		   _tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.CFrame)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.ClickDetector)
	   	   _tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.CFrame)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
	       fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
	       fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
          end
        end
      end
    end)
  end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoFarmMaterialSkullGuitar", {
    Title =  "Auto Farm Material Skull Guitar",
    Description =  "Tự động farm nguyên liệu Skull Guitar",
    Default =  false,
    Callback =  function(Value)
  _G.AutoMatSoul = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.AutoMatSoul and GetWP("Skull Guitar") == false then
	    if GetM("Bones") >= 500 and GetM("Ectoplasm") >= 250 and GetM("Dark Fragment") >= 1 then
	      replicated.Remotes.CommF_:InvokeServer("soulGuitarBuy",true)
		else
		  if GetM("Ectoplasm") <= 250 then
		    if _G.AutoMatSoul and World2 then
		      local EctoTable = {"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior"}    
		      local xz = GetConnectionEnemies(EctoTable)
              if xz then repeat task.wait() Attack.Kill(xz, _G.AutoMatSoul)until not _G.AutoMatSoul or not xz.Parent or xz.Humanoid.Health <= 0
			  else replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
			  end
		    else replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
		    end
		  elseif GetM("Dark Fragment") < 1 then
		    if _G.AutoMatSoul and World2 then
		      local black = GetConnectionEnemies("Darkbeard")
		      if black then repeat task.wait()Attack.Kill(black, _G.AutoMatSoul)until _G.AutoMatSoul or black.Humanoid.Health <= 0
		      else _tp(CFrame.new(3798.4575195313, 13.826690673828, -3399.806640625))
		      end
		    else replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
			end
		     if not GetConnectionEnemies("Darkbeard") then Hop() end
	         elseif GetM("Bones") <= 500 then
		       if _G.AutoMatSoul and World3 then
			     local BonesTable = {"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"}
			     local zx = GetConnectionEnemies(BonesTable)			   
	             if zx then repeat task.wait()Attack.Kill(zx, _G.AutoMatSoul)until not _G.AutoMatSoul or zx.Humanoid.Health <= 0 or not zx.Parent or zx.Humanoid.Health <= 0
				 else _tp(CFrame.new(-9504.8564453125, 172.14292907714844, 6057.259765625))
			   end
		     else
		       replicated.Remotes.CommF_:InvokeServer("TravelZou")
		     end
		   end
	     end
	   end
    end)
  end
end)

Tabs.Quests:AddSection("Cursed Dual Katana")
local CheckCDK = Tabs.Quests:AddParagraph({Title = "Number Cursed dual katana quests", Content = "Quest Numbers :"})
spawn(function()  
    while wait(0.2) do 
        if QuestYama_1 == true then 
            pcall(function() CheckCDK:SetContent("Quest Numbers : yama quest 1") end) 
        elseif QuestYama_2 == true then
            pcall(function() CheckCDK:SetContent("Quest Numbers : yama quest 2") end) 
        elseif QuestYama_3 == true then
            pcall(function() CheckCDK:SetContent("Quest Numbers : yama quest 3") end) 
        elseif QuestTushita_1 == true then
            pcall(function() CheckCDK:SetContent("Quest Numbers : tushita quest 1") end) 
        elseif QuestTushita_2 == true then
            pcall(function() CheckCDK:SetContent("Quest Numbers : tushita quest 2") end) 
        elseif GetWP("Cursed Dual Katana") then
            pcall(function() CheckCDK:SetContent("Quest Numbers : CDK done!!") end)
        end 
    end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoGetCDKLastQuest", {
    Title =  "Auto Get CDK [ Last Quest ]",
    Description =  "Tự động lấy CDK (nhiệm vụ cuối)",
    Default =  false,
    Callback =  function(Value)
  _G.CDK = Value
end
})
end
spawn(function()    
  while wait(Sec) do
    pcall(function()
      if _G.CDK then
        replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
        replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
        replicated.Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Boss")
        local v = GetConnectionEnemies("Cursed Skeleton Boss")
        if v then
          repeat wait()
            if plr.Character:FindFirstChild("Yama") or plr.Backpack:FindFirstChild("Yama") then EquipWeapon("Yama")
            elseif plr.Character:FindFirstChild("Tushita") or plr.Backpack:FindFirstChild("Tushita") then EquipWeapon("Tushita")                                    
            end _tp(v.HumanoidRootPart.CFrame * CFrame.new(0,20,0))
          until not _G.CDK or not v.Parent or v.Humanoid.Health <= 0                                
        else
          _tp(CFrame.new(-12318.193359375, 601.9518432617188, -6538.662109375)) wait(.5)
          _tp(workspace.Map.Turtle.Cursed.BossDoor.CFrame)
        end
      end
    end)
  end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoYamaCDK", {
    Title =  "Auto Yama CDK",
    Description =  "Tự động làm Yama cho CDK",
    Default =  false,
    Callback =  function(Value)
  _G.CDK_YM = Value
end
})
end
spawn(function()
  while wait() do
    pcall(function()
      if _G.CDK_YM then
        if tostring(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")) ~= "opened" then                  
          replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")
          replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
        else
          if replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Finished"] == nil then
            replicated.Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
            replicated.Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
          elseif replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Finished"] == false then                        
            if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == -3 then
              QuestYama_1 = true QuestYama_2 = false QuestYama_3 = false
              repeat task.wait()
                if not workspace.Enemies:FindFirstChild("Forest Pirate") then
                  _tp(CFrame.new(-13223.521484375, 428.1938171386719, -7766.06787109375))
                else
                  local v = GetConnectionEnemies("Forest Pirate")
                  if v then _tp(workspace.Enemies:FindFirstChild("Forest Pirate").HumanoidRootPart.CFrame)end
                end
              until tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 1 or not _G.CDK_YM
            elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == -4 then
              QuestYama_1 = false QuestYama_2 = true QuestYama_3 = false
              for ix,HitMon in pairs(game:GetService("Players").LocalPlayer.QuestHaze:GetChildren()) do
                for NameMonHaze, CFramePos in pairs(PosMsList) do
                  if string.find(NameMonHaze,HitMon.Name) and HitMon.Value > 0 then
                    if (CFramePos.Position - Root.Position).Magnitude <= 1000 and workspace.Enemies:FindFirstChild(NameMonHaze) then
                      for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Humanoid").Health > 0 and v:FindFirstChild("HazeESP") then
                          repeat wait() Attack.Kill(v, _G.CDK_YM) until not _G.CDK_YM or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 2 or not v:FindFirstChild("HazeESP") or v.Humanoid.Health <= 0
                        end
                      end
                    else   
                      _tp(CFramePos)                               
                    end
                  end
                end
              end
            elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == -5 then
              QuestYama_1 = false QuestYama_2 = false QuestYama_3 = true
              if workspace.Map:FindFirstChild("HellDimension") then
                if (Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 1000 then
                  for gg,ez in pairs(workspace.Map.HellDimension.Exit:GetChildren()) do
                    if tonumber(gg) == 2 then
                      repeat task.wait() Root.CFrame = workspace.Map.HellDimension.Exit.CFrame until not _G.CDK_YM or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 3
                    end
                  end
                  EquipWeapon(_G.SelectWeapon)
                  if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) ~= 3 then
                  repeat task.wait()
                    repeat task.wait() 
                      _tp(workspace.Map.HellDimension.Torch1.Particles.CFrame) 
                      for i, v in pairs(workspace.Map.HellDimension:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                      end
                    until (workspace.Map.HellDimension.Torch1.Particles.Position - Root.Position).Magnitude < 5
                    wait(2) _G.T1Yama = true
                  until not _G.CDK_YM or _G.T1Yama or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 3
                  repeat task.wait()
                    repeat task.wait()
                      _tp(workspace.Map.HellDimension.Torch2.Particles.CFrame) 
                      for i, v in pairs(workspace.Map.HellDimension:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then fireproximityprompt(v)end
                      end
                    until (workspace.Map.HellDimension.Torch2.Particles.Position - Root.Position).Magnitude < 5
                    wait(2) _G.T2Yama = true
                  until _G.T2Yama or _G.CDK_YM == false or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 3
                    repeat wait()
                      repeat task.wait() 
                        _tp(workspace.Map.HellDimension.Torch3.Particles.CFrame) 
                        for i, v in pairs(workspace.Map.HellDimension:GetDescendants()) do
                          if v:IsA("ProximityPrompt") then fireproximityprompt(v)end
                        end
                      until (workspace.Map.HellDimension.Torch3.Particles.Position - Root.Position).Magnitude < 5 
                      wait(2) _G.T3Yama = true
                    until _G.T3Yama or _G.CDK_YM == false or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 3
                  end
                  for i,v in pairs(workspace.Enemies:GetChildren()) do
                    if (v:FindFirstChild("HumanoidRootPart").Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 300 then
                      if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Humanoid").Health > 0 then
                        repeat task.wait() Attack.Kill(v,_G.CDK_YM) until not _G.CDK_YM or v.Humanoid.Health <= 0 or not v.Parent or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 3
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
  while wait() do
    pcall(function()
      if _G.CDK_YM then
        if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == -5 then
          if not workspace.Map:FindFirstChild("HellDimension") or (Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude > 1000 then
            local v = GetConnectionEnemies("Soul Reaper")
            if v then repeat task.wait()_tp(v.HumanoidRootPart.CFrame) until v.Humanoid.Health <= 0 or not _G.CDK_YM or not v.Parent or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Evil"]) == 3 or (workspace.Map:FindFirstChild("HellDimension") and (Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 1000)
            elseif plr.Backpack:FindFirstChild("Hallow Essence") or plr.Character:FindFirstChild("Hallow Essence") then
            repeat _tp(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125)) task.wait() until (CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125).Position - Root.Position).Magnitude <= 8
            EquipWeapon("Hallow Essence")
            elseif replicated:FindFirstChild("Soul Reaper") and replicated:FindFirstChild("Soul Reaper").Humanoid.Health > 0 then
              _tp(replicated:FindFirstChild("Soul Reaper").HumanoidRootPart.CFrame)
            else
              if replicated.Remotes.CommF_:InvokeServer("Bones","Check") < 50 and not workspace.Enemies:FindFirstChild("Soul Reaper") and not replicated:FindFirstChild("Soul Reaper") and not workspace.Map:FindFirstChild("HellDimension") then
                if workspace.Enemies:FindFirstChild("Reborn Skeleton") or workspace.Enemies:FindFirstChild("Living Zombie") or workspace.Enemies:FindFirstChild("Domenic Soul") or workspace.Enemies:FindFirstChild("Posessed Mummy") then
                  for i,v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name == "Reborn Skeleton" or v.Name == "Living Zombie" or v.Name == "Demonic Soul" or v.Name == "Posessed Mummy" then
                      if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Humanoid").Health > 0 then
                        repeat task.wait() Attack.Kill(v,_G.CDK_YM)until not _G.CDK_YM or v.Humanoid.Health <= 0 or not v.Parent
                      end
                    end
                  end
                else
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

do
    Tabs.Quests:AddToggle("Quests_AutoTushitaCDK", {
    Title =  "Auto Tushita CDK",
    Description =  "Tự động làm Tushita cho CDK",
    Default =  false,
    Callback =  function(Value)
  _G.CDK_TS = Value
end
})
end
spawn(function()
  while wait() do
    pcall(function()
      if _G.CDK_TS then
        if tostring(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")) ~= "opened" then
          wait(.7) replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")
          wait(.3) replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
        else
          if replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Finished"] == nil then
            replicated.Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Good")
          elseif replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Finished"] == false then
            if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == -3 then
              QuestTushita_1 = true
              QuestTushita_2 = false
              QuestTushita_3 = false
              repeat wait() _tp(CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875)) until (CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.CDK_TS or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == 1
              if (CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                wait(.7) replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"),"Check")
                wait(.5) replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
              end
                wait(1) repeat wait() _tp(CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125)) until (CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.CDK_TS or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == 1
                if (CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                wait(.7) replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"),"Check")
                wait(.5) replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
                end
                  wait(1) repeat wait() _tp(CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625)) until (CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.CDK_TS or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == 1
                  if (CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                    wait(.7) replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"),"Check")
                    wait(.5) replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
                  end
                  wait(1)
                  elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == -4 then
                    QuestTushita_1 = false
                    QuestTushita_2 = true
                    QuestTushita_3 = false
                    repeat wait()
                      _G.AutoRaidCastle = true
                    until not _G.CDK_TS or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == 2 
                      _G.AutoRaidCastle = false         
                  elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == -5 then
                    QuestTushita_1 = false
                    QuestTushita_2 = false
                    QuestTushita_3 = true
                    if workspace.Enemies:FindFirstChild("Cake Queen") then
                      for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == "Cake Queen" then
                          if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat wait()
                              Attack.Kill(v, _G.CDK_TS)
                            until not _G.CDK_TS or not v.Parent or v.Humanoid.Health <= 0 or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == 3
                          end
                        end
                      end
                     elseif replicated:FindFirstChild("Cake Queen") and replicated:FindFirstChild("Cake Queen").Humanoid.Health > 0 then
                       _tp(replicated:FindFirstChild("Cake Queen").HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                     else
                   if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - workspace.Map.HeavenlyDimension.Spawn.Position).Magnitude <= 1000 then
                     for i,v in pairs(workspace.Map.HeavenlyDimension.Exit:GetChildren()) do
                       Ex = i
                     end
                     if Ex == 2 then
                       repeat wait()
                         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.HeavenlyDimension.Exit.CFrame
                       until not _G.CDK_TS or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress")["Good"]) == 3
                    end
                   repeat wait()
                     repeat wait() 
                       _tp(CFrame.new(-22529.6171875, 5275.77392578125, 3873.5712890625)) 
                       for i, v in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
                         if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                       end
                     until (CFrame.new(-22529.6171875, 5275.77392578125, 3873.5712890625).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 5
                     wait(2)
                    _G.DoneT1 = true
                  until not _G.CDK_TS or _G.DoneT1
                  repeat wait()
                    repeat wait()
                      _tp(CFrame.new(-22637.291015625, 5281.365234375, 3749.28857421875)) 
                       for i, v in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
                         if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                       end
                    until (CFrame.new(-22637.291015625, 5281.365234375, 3749.28857421875).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 5
                    wait(2) _G.DoneT2 = true
                  until _G.DoneT2 or _G.CDK_TS == false
                  repeat wait()
                    repeat task.wait() 
                      _tp(CFrame.new(-22791.14453125, 5277.16552734375, 3764.570068359375)) 
                      for i, v in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                      end
                    until (CFrame.new(-22791.14453125, 5277.16552734375, 3764.570068359375).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 5
                    wait(2) _G.DoneT3 = true
                  until _G.DoneT3 or _G.CDK_TS == false
                  for i,v in pairs(workspace.Enemies:GetChildren()) do
                    if (v:FindFirstChild("HumanoidRootPart").Position - CFrame.new(-22695.7012, 5270.93652, 3814.42847, 0.11794927, 3.32185834e-08, 0.99301964, -8.73070718e-08, 1, -2.30819008e-08, -0.99301964, -8.3975138e-08, 0.11794927).Position).Magnitude <= 300 then
                      if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Humanoid").Health > 0 then
                        repeat wait()
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
Tabs.Quests:AddSection("True Triple Katana Sword")
do
    Tabs.Quests:AddButton({
    Title =  "Buy Legendary Sword",
    Description =  "Mua kiếm huyền thoại",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer","1")
  replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer","2")
  replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer","3")
end
})
end
do
    Tabs.Quests:AddButton({
    Title =  "Buy True Triple Katana Sword",
    Description =  "Mua bộ 3 kiếm thật",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("MysteriousMan","2")
end
})
end
do
    Tabs.Quests:AddToggle("Quests_TweentoLegendarySwordDealer", {
    Title =  "Tween to Legendary Sword Dealer",
    Description =  "Bay tới NPC bán kiếm huyền thoại",
    Default =  false,
    Callback =  function(Value)
  _G.Tp_LgS = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoPoleV1", {
    Title =  "Auto Pole V1",
    Description =  "Tự động làm gậy Pole V1",
    Default =  false,
    Callback =  function(Value)
  _G.AutoPole = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoPoleV2Beta", {
    Title =  "Auto Pole V2 [Beta]",
    Description =  "Tự động làm gậy Pole V2",
    Default =  false,
    Callback =  function(Value)
  _G.AutoPoleV2 = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoSawSword", {
    Title =  "Auto Saw Sword",
    Description =  "Tự động làm kiếm Saw",
    Default =  false,
    Callback =  function(Value)
  _G.AutoSaw = Value
end
})
end
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

do
    Tabs.Quests:AddToggle("Quests_AutoSaberSword", {
    Title =  "Auto Saber Sword",
    Description =  "Tự động làm kiếm Saber",
    Default =  false,
    Callback =  function(Value)
  _G.AutoSaber = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoCybrog", {
    Title =  "Auto Cybrog",
    Description =  "Tự động làm Cyborg",
    Default =  false,
    Callback =  function(Value)
  _G.AutoColShad = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoUsoapsHat", {
    Title =  "Auto Usoap's Hat",
    Description =  "Tự động làm Usoap",
    Default =  false,
    Callback =  function(Value)
  _G.AutoGetUsoap = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoBisentoV2", {
    Title =  "Auto Bisento V2",
    Description =  "Tự động làm Bisento V2",
    Default =  false,
    Callback =  function(Value)
  _G.Greybeard = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoWardenSword", {
    Title =  "Auto Warden Sword",
    Description =  "Tự động làm kiếm Warden",
    Default =  false,
    Callback =  function(Value)
  _G.WardenBoss = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoMarineCoat", {
    Title =  "Auto Marine Coat",
    Description =  "Tự động lấy áo Marine",
    Default =  false,
    Callback =  function(Value)
  _G.MarinesCoat = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoSwanCoat", {
    Title =  "Auto Swan Coat",
    Description =  "Tự động lấy áo Swan",
    Default =  false,
    Callback =  function(Value)
  _G.SwanCoat = Value
end
})
end
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

Tabs.Quests:AddSection("Rengoku Sword")
do
    Tabs.Quests:AddToggle("Quests_AutoRengokuSword", {
    Title =  "Auto Rengoku Sword",
    Description =  "Tự động làm kiếm Rengoku",
    Default =  false,
    Callback =  function(Value)
  _G.IceBossRen = Value
end
})
end
spawn(function()
  pcall(function()
    while wait(.1) do
      if _G.IceBossRen then
        local v = GetConnectionEnemies("Awakened Ice Admiral")
        if v then repeat task.wait()Attack.Kill(v,_G.IceBossRen)until _G.IceBossRen == false or not v.Parent or v.Humanoid.Health <= 0
        else _tp(CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813))
        end
      end
    end
  end)
end)
do
    Tabs.Quests:AddToggle("Quests_AutoKeyRengoku", {
    Title =  "Auto Key Rengoku",
    Description =  "Tự động lấy chìa khóa Rengoku",
    Default =  false,
    Callback =  function(Value)
  _G.KeysRen = Value
end
})
end
spawn(function()
  while wait(.1) do
    pcall(function()
      if _G.KeysRen then
        if plr.Backpack:FindFirstChild(RenMon[3]) or plr.Character:FindFirstChild(RenMon[3]) then
          EquipWeapon(RenMon[3]) wait(.1)
          _tp(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875))
        else
          local v = GetConnectionEnemies(RenMon)
          if v then repeat task.wait() Attack.Kill(v,_G.KeysRen)until plr.Backpack:FindFirstChild(RenMon[3]) or _G.KeysRen == false or not v.Parent or v.Humanoid.Health <= 0
          else _tp(CFrame.new(5439.716796875, 84.420944213867, -6715.1635742188))
          end
        end
      end
    end)
  end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoDragonTrident", {
    Title =  "Auto Dragon Trident",
    Description =  "Tự động lấy Dragon Trident",
    Default =  false,
    Callback =  function(Value)
  _G.AutoTridentW2 = Value
end
})
end
spawn(function()
  while wait(.1) do
    pcall(function()
      if _G.AutoTridentW2 then
        local v = GetConnectionEnemies("Tide Keeper")
        if v then repeat task.wait() Attack.Kill(v,_G.AutoTridentW2)until _G.AutoTridentW2 == false or not v.Parent or v.Humanoid.Health <= 0
        else _tp(CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188))
        end
      end
    end)
  end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoLongSword", {
    Title =  "Auto Long Sword",
    Description =  "Tự động lấy Long Sword",
    Default =  false,
    Callback =  function(Value)
  _G.LongsWord = Value
end
})
end
spawn(function()
  while wait(.1) do
    pcall(function()
      if _G.LongsWord then
        local v = GetConnectionEnemies("Diamond")
        if v then repeat task.wait() Attack.Kill(v,_G.LongsWord)until _G.LongsWord == false or not v.Parent or v.Humanoid.Health <= 0
        else _tp(CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407))
        end
      end
    end)
  end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoBlackSpikey", {
    Title =  "Auto Black Spikey",
    Description =  "Tự động lấy Black Spikey",
    Default =  false,
    Callback =  function(Value)
  _G.BlackSpikey = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoDarkBladeV3", {
    Title =  "Auto Dark Blade V3",
    Description =  "Tự động lấy Dark Blade V3",
    Default =  false,
    Callback =  function(Value)
  _G.DarkBladev3 = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoMidnightBlade", {
    Title =  "Auto Midnight Blade",
    Description =  "Tự động lấy Midnight Blade",
    Default =  false,
    Callback =  function(Value)
  _G.AutoEcBoss = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoDarkbeard", {
    Title =  "Auto Darkbeard",
    Description =  "Tự động farm Darkbeard",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Def_DarkCoat = Value
end
})
end
spawn(function()
  while wait(.1) do
    if _G.Auto_Def_DarkCoat then
      pcall(function()
        if GetBP("Fist of Darkness") and not workspace.Enemies:FindFirstChild("Darkbeard") then          
          _tp(CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531))
        elseif GetConnectionEnemies("Darkbeard") then
          local v = GetConnectionEnemies("Darkbeard")          
		  if v then repeat wait()Attack.Kill(v,_G.Auto_Def_DarkCoat)until _G.Auto_Def_DarkCoat == false or not v.Parent or v.Humanoid.Helath <= 0 end
        elseif not GetBP("Fist of Darkness") and not GetConnectionEnemies("Darkbeard") then
          repeat wait(.1) _G.AutoFarmChest = true until not _G.Auto_Def_DarkCoat or GetBP("Fist of Darkness") or GetConnectionEnemies("Darkbeard") _G.AutoFarmChest = false
        end
      end)
    end
  end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoUnlockedDonSwan", {
    Title =  "Auto Unlocked DonSwan",
    Description =  "Tự động mở khóa Don Swan",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_DonAcces = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoSwanGlasses", {
    Title =  "Auto Swan Glasses",
    Description =  "Tự động lấy kính Swan",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_SwanGG = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoBigmom", {
    Title =  "Auto Bigmom",
    Description =  "Tự động farm Bigmom",
    Default =  false,
    Callback =  function(Value)
  _G.AutoBigmom = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoCanvendishSword", {
    Title =  "Auto Canvendish Sword",
    Description =  "Tự động lấy kiếm Cavendish",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Cavender = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoTwinHooks", {
    Title =  "Auto Twin Hooks",
    Description =  "Tự động lấy Twin Hooks",
    Default =  false,
    Callback =  function(Value)
  _G.TwinHook = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoSerpentBow", {
    Title =  "Auto Serpent Bow",
    Description =  "Tự động lấy Serpent Bow",
    Default =  false,
    Callback =  function(Value)
  _G.AutoSerpentBow = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoLeiAccessory", {
    Title =  "Auto Lei Accessory",
    Description =  "Tự động lấy vòng Lei",
    Default =  false,
    Callback =  function(Value)
  _G.AutoKilo = Value
end
})
end
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

Tabs.Quests:AddSection("Buso/Aura Colours")
do
    Tabs.Quests:AddToggle("Quests_AutoTeleportBaristaCousin", {
    Title =  "Auto Teleport Barista Cousin",
    Description =  "Tự động bay tới Barista Cousin",
    Default =  false,
    Callback =  function(Value)
  _G.Tp_MasterA = Value
end
})
end
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
do
    Tabs.Quests:AddButton({
    Title =  "Buy Buso Colors",
    Description =  "Mua màu Haki",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("ColorsDealer","2")
end
})
end
do
    Tabs.Quests:AddToggle("Quests_AutoRainbowColors", {
    Title =  "Auto Rainbow Colors",
    Description =  "Tự động lấy màu cầu vồng",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Rainbow_Haki = Value
end
})
end
spawn(function()
  pcall(function()
    while wait(Sec) do
      if _G.Auto_Rainbow_Haki then
        if plr.PlayerGui.Main.Quest.Visible == false then
          if _G.GetQFast then
            if plr.PlayerGui.Main.Quest.Visible == false then replicated.Remotes.CommF_:InvokeServer("HornedMan","Bet") end     
          else
            Rainbow1 = CFrame.new(-11892.0703125, 930.57672119141, -8760.1591796875)
            if (plr.Character.HumanoidRootPart.CFrame ~= Rainbow1) then
              _tp(Rainbow1)
            elseif (plr.Character.HumanoidRootPart.CFrame == Rainbow1) then
              wait(1)
              replicated.Remotes.CommF_:InvokeServer("HornedMan","Bet")
            end
          end
          elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Stone") then
            local v = GetConnectionEnemies("Stone")
            if v then
              repeat wait() Attack.Kill(v,_G.Auto_Rainbow_Haki) until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
            else
              _tp(CFrame.new(-1086.11621, 38.8425903, 6768.71436, 0.0231462717, -0.592676699, 0.805107772, 2.03251839e-05, 0.805323839, 0.592835128, -0.999732077, -0.0137055516, 0.0186523199))
            end
          elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Hydra Leader") then
            local v = GetConnectionEnemies("Hydra Leader")
            if v then
              repeat task.wait()Attack.Kill(v,_G.Auto_Rainbow_Haki) until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
            else
              replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625))
              local framelong1 = Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625)
              local framelong2 = CFrame.new(5821.89794921875, 1019.0950927734375, -73.71923065185547)
              if (plr.Character.HumanoidRootPart.CFrame.Position == framelong1) then _tp(framelong2)end
            end
          elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Kilo Admiral") then
            local v = GetConnectionEnemies("Kilo Admiral")
            if v then
              repeat task.wait()Attack.Kill(v,_G.Auto_Rainbow_Haki) until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
            else
              _tp(CFrame.new(2877.61743, 423.558685, -7207.31006, -0.989591599, -0, -0.143904909, -0, 1.00000012, -0, 0.143904924, 0, -0.989591479))
            end
            elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") then
              local v = GetConnectionEnemies("Captain Elephant")
              if v then
                repeat task.wait() Attack.Kill(v,_G.Auto_Rainbow_Haki)until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
              else
              local gamergayror1 = Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375)
              local gamergayror2 = CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125)
              if (plr.Character.HumanoidRootPart.CFrame.Position ~= gamergayror1) then
                replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
              elseif (plr.Character.HumanoidRootPart.CFrame.Position == gamergayror1) then
                _tp(gamergayror2)
              end
            end
        elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Beautiful Pirate") then
          local v = GetConnectionEnemies("Captain Elephant")
          if v then
            repeat task.wait() Attack.Kill(v,_G.Auto_Rainbow_Haki) until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
          else
            replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5314.54638671875, 22.562219619750977, -127.06755065917969))
          end
        end                  
      end
    end    
  end)
end)
do
    Tabs.Quests:AddToggle("Quests_AcceptRainbowQuestFaster", {
    Title =  "Accept Rainbow Quest Faster",
    Description =  "Nhận nhiệm vụ cầu vồng nhanh hơn",
    Default =  false,
    Callback =  function(Value)
  _G.GetQFast = Value
end
})
end

Tabs.Quests:AddSection("Instinct / Observation")
do
    Tabs.Quests:AddToggle("Quests_AutoFarmObservation", {
    Title =  "Auto Farm Observation",
    Description =  "Tự động farm Haki quan sát",
    Default =  false,
    Callback =  function(Value)
  _G.obsFarm = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoObservationV2", {
    Title =  "Auto Observation V2",
    Description =  "Tự động làm Haki quan sát V2",
    Default =  false,
    Callback =  function(Value)
  _G.AutoKenVTWO = Value
end
})
end
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



do
    Tabs.Quests:AddToggle("Quests_AutoDoneBartiloQuest", {
    Title =  "Auto Done Bartilo Quest",
    Description =  "Tự động làm xong nhiệm vụ Bartilo",
    Default =  false,
    Callback =  function(Value)
  _G.Bartilo_Quest = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoDoneCitizenQuest", {
    Title =  "Auto Done Citizen Quest",
    Description =  "Tự động làm xong nhiệm vụ Citizen",
    Default =  false,
    Callback =  function(Value)
  _G.CitizenQuest = Value
end
})
end
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
do
    Tabs.Quests:AddToggle("Quests_AutoTrainingDummy", {
    Title =  "Auto Training Dummy",
    Description =  "Tự động đánh hình nộm",
    Default =  false,
    Callback =  function(Value)
  _G.DummyMan = Value
end
})
end
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






Tabs.Quests:AddSection("Fighting Melee Styles")
do
    Tabs.Quests:AddToggle("Quests_AutoSuperhuman", {
    Title =  "Auto Superhuman",
    Description =  "Tự động học võ Superhuman",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_SuperHuman = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_SuperHuman then
      local M_Beli = plr.Data.Beli.Value
	  local M_Frag = plr.Data.Fragments.Value
        if plr:FindFirstChild("WeaponAssetCache") then
          if not GetBP("Superhuman") then                    
            if not GetBP("Black Leg") then
            if (M_Beli >= 150000) then replicated.Remotes.CommF_:InvokeServer("BuyBlackLeg") end
            elseif GetBP("Black Leg") and GetBP("Black Leg").Level.Value < 299 then _G.Level = true elseif GetBP("Black Leg") and GetBP("Black Leg").Level.Value >= 300 then _G.Level = false end                        
            if not GetBP("Electro") then
            if (M_Beli >= 500000) then replicated.Remotes.CommF_:InvokeServer("BuyElectro") end
            elseif GetBP("Electro") and GetBP("Electro").Level.Value < 299 then _G.Level = true elseif GetBP("Electro") and GetBP("Electro").Level.Value >= 300 then _G.Level = false end                        
            if not GetBP("Fishman Karate") then
            if (M_Beli >= 750000) then replicated.Remotes.CommF_:InvokeServer("BuyFishmanKarate") end
            elseif GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value < 299 then _G.Level = true elseif GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value >= 300 then _G.Level = false end                        
            if not GetBP("Dragon Claw") then
            if (M_Frag >= 1500) then replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2") end
            elseif GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value < 299 then _G.Level = true elseif GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value >= 300 then _G.Level = false end
            replicated.Remotes.CommF_:InvokeServer("BuySuperhuman")          
          end
        end        
      end
    end)
  end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoDeathStep", {
    Title =  "Auto DeathStep",
    Description =  "Tự động học võ DeathStep",
    Default =  false,
    Callback =  function(Value)
  _G.AutoDeathStep = Value
end
})
end
spawn(function()
  while wait(Sec) do
    if _G.AutoDeathStep then
      pcall(function()
        if plr:FindFirstChild("WeaponAssetCache") then  
          if not GetBP("Death Step") then          
            if not GetBP("Black Leg") then replicated.Remotes.CommF_:InvokeServer("BuyBlackLeg") end
            if GetBP("Black Leg") and GetBP("Black Leg").Level.Value >= 400 then replicated.Remotes.CommF_:InvokeServer("BuyDeathStep") _G.Level = false elseif GetBP("Black Leg") and GetBP("Black Leg").Level.Value < 399 then _G.Level = true end
            if GetBP("Black Leg") or GetBP("Black Leg").Level.Value >= 400 then
            if workspace.Map.IceCastle.Hall.LibraryDoor.PhoeyuDoor.Transparency == 0 then            
              if GetBP("Library Key") then repeat wait() _tp(CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375)) until not _G.AutoDeathStep or (Root.Position == CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375).Position)
		        if (Root.CFrame == CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375)) then replicated.Remotes.CommF_:InvokeServer("BuyDeathStep") end     
		        elseif not GetBP("Library Key") then
		          local v = GetConnectionEnemies("Awakened Ice Admiral")
		          if v then	repeat wait() Attack.Kill(v,_G.AutoDeathStep) until not v.Parent or v.Humanoid.Health <= 0 or _G.AutoDeathStep == false or GetBP("Library Key") or GetBP("Death Step")
	              else _tp(CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813))
	              end
		        end		    
              end
            end          
          end
        end
      end)
    end
  end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoSharkmanKarate", {
    Title =  "Auto Sharkman Karate",
    Description =  "Tự động học võ Sharkman Karate",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_SharkMan_Karate = Value
end
})
end
spawn(function() 
  while wait(Sec) do
    if _G.Auto_SharkMan_Karate then
      pcall(function()
        if plr:FindFirstChild("WeaponAssetCache") then  
          if not GetBP("Sharkman Karate") then          
            if not GetBP("Fishman Karate") then replicated.Remotes.CommF_:InvokeServer("BuyFishmanKarate") end
            if GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value >= 400 then replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate") _G.Level = false elseif GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value < 399 then _G.Level = true end
            if GetBP("Fishman Karate") or GetBP("Fishman Karate").Level.Value >= 400 then           
              if GetBP("Water Key") then
		        if string.find(replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate"), "keys") then  
			      if GetBP("Water Key") then
			        repeat wait() _tp(CFrame.new(-2604.6958, 239.432526, -10315.1982, 0.0425701365, 0, -0.999093413, 0, 1, 0, 0.999093413, 0, 0.0425701365)) until not _G.Auto_SharkMan_Karate or (Root.Position == CFrame.new(-2604.6958, 239.432526, -10315.1982, 0.0425701365, 0, -0.999093413, 0, 1, 0, 0.999093413, 0, 0.0425701365).Position)
	                replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
		          end
		        end
		      elseif not GetBP("Water Key") then
		        local v = GetConnectionEnemies("Tide Keeper")
		        if v then repeat wait() Attack.Kill(v,_G.Auto_SharkMan_Karate)until not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_SharkMan_Karate == false or GetBP("Water Key") or GetBP("Sharkman Karate")		
	            else _tp(CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625))
	            end
		      end		                  
            end          
          end
        end
      end)
    end
  end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoElectricClaw", {
    Title =  "Auto ElectricClaw",
    Description =  "Tự động học võ Electric Claw",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Electric_Claw = Value
end
})
end
spawn(function()
  while wait(Sec) do
    if _G.Auto_Electric_Claw then
      pcall(function()
        if plr:FindFirstChild("WeaponAssetCache") then 
        if not GetBP("Electro") then replicated.Remotes.CommF_:InvokeServer("BuyElectro") end        
          if GetBP("Electro") and GetBP("Electro").Level.Value >= 400 then
            if replicated.Remotes.CommF_:InvokeServer("BuyElectricClaw", "Start") == nil then notween(CFrame.new(-12548, 337, -7481)) end
            replicated.Remotes.CommF_:InvokeServer("BuyElectricClaw")
          elseif GetBP("Electro") and GetBP("Electro").Level.Value < 400 then
            repeat _G.AutoFarm_Bone = true wait() until not _G.Auto_Electric_Claw or GetBP("Electric Claw") _G.AutoFarm_Bone = false
          end
        end       
      end)
    end
  end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoDragonTalon", {
    Title =  "Auto DragonTalon",
    Description =  "Tự động học võ Dragon Talon",
    Default =  false,
    Callback =  function(Value)
  _G.AutoDragonTalon = Value
end
})
end
spawn(function()
  while wait(Sec) do
    if _G.AutoDragonTalon then
      pcall(function()
        if plr:FindFirstChild("WeaponAssetCache") then 
        if not GetBP("Dragon Claw") then replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2") end        
          if GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value >= 400 then replicated.Remotes.CommF_:InvokeServer("Bones","Buy",1,1) replicated.Remotes.CommF_:InvokeServer("BuyDragonTalon")
          elseif GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value < 400 then repeat _G.AutoFarm_Bone = true wait() until not _G.AutoDragonTalon or GetBP("Dragon Talon") _G.AutoFarm_Bone = false
          end         
        end
      end)
    end
  end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoGodhuman", {
    Title =  "Auto Godhuman",
    Description =  "Tự động học võ Godhuman",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_God_Human = Value
end
})
end
spawn(function()
  while wait() do
    pcall(function()
      if _G.Auto_God_Human then
        if replicated.Remotes.CommF_:InvokeServer("BuyGodhuman",true) == "Bring me 20 Fish Tails, 20 Magma Ore, 10 Dragon Scales and 10 Mystic Droplets." then
          if GetM("Dragon Scale") == false or GetM("Dragon Scale") < 10 then
            if World3 then
              Lv = 1575
              _G.Level = true
            else
              replicated.Remotes.CommF_:InvokeServer("TravelZou")
            end
          elseif GetM("Fish Tail") == false or GetM("Fish Tail") < 20 then
            if World3 then
              Lv = 1775
              _G.Level = true
            else
              replicated.Remotes.CommF_:InvokeServer("TravelZou")
            end
          elseif GetM("Mystic Droplet") == false or GetM("Mystic Droplet") < 10 then
            if World2 then
              Lv = 1425
              _G.Level = true
            else
              replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
            end
          elseif GetM("Magma Ore") == false or GetM("Magma Ore") < 20 then
            if World2 then
              Lv = 1175
              _G.Level = true
            else
              replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
            end  
          end
        elseif replicated.Remotes.CommF_:InvokeServer("BuyGodhuman",true) == 3 then
          return nil
        else
          replicated.Remotes.CommF_:InvokeServer("BuyGodhuman")
        end
      end
    end)
  end
end)
do
    Tabs.Quests:AddToggle("Quests_AutoSanguineArt", {
    Title =  "Auto SanguineArt",
    Description =  "Tự động học võ Sanguine Art",
    Default =  false,
    Callback =  function(Value)
  _G.Snaguine = Value
end
})
end
spawn(function()
  while wait(Sec) do
    if _G.Snaguine then
      pcall(function()
        if not GetBP("Sanguine Art") then replicated.Remotes.CommF_:InvokeServer("Sanguine Art") end
        if not GetBP("Sanguine Art") then
          if GetM("Leviathan Heart") >= 1 then print("Completed!!")
          else
          if World3 then _G.DangerSc = "Lv Infinite" _G.SailBoats = true; else _G.SailBoats = false; end end
          if GetM("Vampire Fang") <= 19 then
            if World2 then
              local n = GetConnectionEnemies("Vampire")
              if n then repeat task.wait() Attack.Kill(n,_G.Snaguine) until not _G.Snaguine or n.Humanoid.Health <= 0 or not n.Parent
              else _tp(CFrame.new(-6041.29248046875, 6.402710914611816, -1304.63330078125))
              end
            else
              replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
            end
          end                                      
          if GetM("Vampire Fang") >= 20 and GetM("Demonic Wisp") <= 19 then
            if World3 then
              local n = GetConnectionEnemies("Demonic Soul")
		      if n then repeat task.wait() Attack.Kill(n,_G.Snaguine) until not _G.Snaguine or n.Humanoid.Health <= 0 or not n.Parent
              else _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) 
              end
             else
               replicated.Remotes.CommF_:InvokeServer("TravelZou")
             end
           end
           if GetM("Vampire Fang") >= 20 and GetM("Demonic Wisp") >= 20 and GetM("Dark Fragment") <= 1 then
             if World2 then
               local n = GetConnectionEnemies("Darkbeard")
		       if n then repeat task.wait() Attack.Kill(black,_G.Snaguine) until _G.Snaguine or black.Humanoid.Health <= 0 or not black.Parent
		      else _tp(CFrame.new(3798.4575195313, 13.826690673828, -3399.806640625))
		      end
		    else replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
	        end
          end
        else replicated.Remotes.CommF_:InvokeServer("BuySanguineArt")
        end
      end)
    end
  end
end)



Tabs.Race:AddSection("Mystic Island / Full Moon")
local FullMOOn = Tabs.Race:AddParagraph({Title = "FullMoon Status", Content = ""})
local Ismirage = Tabs.Race:AddParagraph({Title = "Mirage Island Status", Content = ""})
spawn(function()
    while wait(0.2) do
        if workspace.Map:FindFirstChild("MysticIsland") or workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") then
            pcall(function() Ismirage:SetContent("Mirage Island : True") end)
        else
            pcall(function() Ismirage:SetContent("Mirage Island : False") end)
        end
    end
end)
spawn(function()
    while wait(0.2) do
        pcall(function()
            local moon8 = "http://www.roblox.com/asset/?id=9709150401"
            local moon7 = "http://www.roblox.com/asset/?id=9709150086"
            local moon6 = "http://www.roblox.com/asset/?id=9709149680"
            local moon5 = "http://www.roblox.com/asset/?id=9709149431"
            local moon4 = "http://www.roblox.com/asset/?id=9709149052"
            local moon3 = "http://www.roblox.com/asset/?id=9709143733"
            local moon2 = "http://www.roblox.com/asset/?id=9709139597"
            local moon1 = "http://www.roblox.com/asset/?id=9709135895"
            local moon = Getmoon()
            
            if moon == moon1 then
                pcall(function() FullMOOn:SetContent("Moon : 0 / 8") end)
            elseif moon == moon2 then
                pcall(function() FullMOOn:SetContent("Moon : 1 / 8") end)
            elseif moon == moon3 then
                pcall(function() FullMOOn:SetContent("Moon : 2 / 8") end)
            elseif moon == moon4 then
                pcall(function() FullMOOn:SetContent("Moon : 3 / 8 [ Next Night ]") end)
            elseif moon == moon5 then
                pcall(function() FullMOOn:SetContent("Moon : 4 / 8 [ Full Moon ]") end)
            elseif moon == moon6 then
                pcall(function() FullMOOn:SetContent("Moon : 5 / 8 [ Last Night ]") end)
            elseif moon == moon7 then
                pcall(function() FullMOOn:SetContent("Moon : 6 / 8") end)
            elseif moon == moon8 then
                pcall(function() FullMOOn:SetContent("Moon : 7 / 8") end)
            end
        end)
    end
end)
do
    Tabs.Race:AddToggle("Race_AutoFindMirageIsland", {
    Title =  "Auto Find Mirage Island",
    Description =  "Tự động tìm đảo Mirage",
    Default =  false,
    Callback =  function(Value)
  _G.FindMirage = Value
end
})
end
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
do
    Tabs.Race:AddToggle("Race_EspMirageIsland", {
    Title =  "Esp Mirage Island",
    Description =  "Hiện vị trí đảo Mirage",
    Value =  false,
    Callback =  function(Value)
        MirageIslandESP = Value
        if MirageIslandESP then
            task.spawn(function()
                while MirageIslandESP do
                    UpdateIslandMirageESP()
                    task.wait(1)
                end
            end)
        else
            UpdateIslandMirageESP()
        end
    end

})
end
do
    Tabs.Race:AddToggle("Race_AutoTweenToMirageIsland", {
    Title =  "Auto Tween To Mirage Island",
    Description =  "Tự động bay tới đảo Mirage",
    Default =  false,
    Callback =  function(Value)
        _G.AutoMysticIsland = Value
    end

})
end

spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if _G.AutoMysticIsland then
                for _, location in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
                    if location.Name == "Mirage Island" then
                        _tp(location.CFrame * CFrame.new(0, 333, 0))
                    end
                end
            end
        end)
    end
end)
do
    Tabs.Race:AddToggle("Race_AutoTweenToHighestPoint", {
    Title =  "Auto Tween To Highest Point",
    Description =  "Tự động bay lên điểm cao nhất",
    Default =  false,
    Callback =  function(Value)
  _G.HighestMirage = Value
end
})
end
spawn(function()
  while wait(Sec) do
    if _G.HighestMirage then 
      pcall(function()
      if workspace["_WorldOrigin"].Locations:FindFirstChild("Mirage Island",true) then _tp(workspace.Map.MysticIsland.Center.CFrame*CFrame.new(0,400,0))end
      end)
    end
  end
end)
do
    Tabs.Race:AddToggle("Race_AutoCollectGear", {
    Title =  "Auto Collect Gear",
    Description =  "Tự động nhặt bánh răng",
    Default =  false,
    Callback =  function(Value)
  _G.TPGEAR = Value
end
})
end
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
do
    Tabs.Race:AddToggle("Race_ChangeTransparencycansee", {
    Title =  "Change Transparency can see",
    Description =  "Đổi trong suốt để nhìn rõ hơn",
    Default =  false,
    Callback =  function(Value)
  _G.can = Value
end
})
end
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
do
    Tabs.Race:AddToggle("Race_AutoTweenAdvancedFruitDealer", {
    Title =  "Auto Tween Advanced Fruit Dealer",
    Description =  "Tự động bay tới NPC bán trái xịn",
    Default =  false,
    Callback =  function(Value)
  _G.Addealer = Value
end
})
end
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

-- ============================================================
-- AUTO TWEEN TO FRUIT (Trái Rơi Ngẫu Nhiên) — Y TUONG tu Tab 2,
-- viet lai bang _tp() cua Maru thay vi he fly/noclip cua Tab 2
-- ============================================================
_G.TwFruits = false
_G.FruitPickActive = false

function _FindNearestWildFruit()
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
    for _, obj in ipairs(workspace:GetChildren()) do
        if string.find(obj.Name, "Fruit") then
            local handle = obj:FindFirstChild("Handle")
            if handle then
                local dist = (handle.Position - hrp.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    best = handle
                end
            end
        end
    end
    return best
end

-- Nhớ lại đúng farm nào đang chạy trước khi tạm dừng, để tí
-- nữa restore đúng cái đó (không đoán mò farm nào để bật lại)
_pausedFarmSnapshot = nil

function _PauseFarmForFruitMaru()
    if _G.FruitPickActive then return end
    _G.FruitPickActive = true
    _pausedFarmSnapshot = {
        Level = _G.Level,
        Cake  = _G.Auto_Cake_Prince,
        Tyrant = _G.FarmTyrant,
        Bone  = _G.AutoFarm_Bone,
        Boss  = _G.FarmBoss,
    }
    _G.Level = false
    _G.Auto_Cake_Prince = false
    _G.FarmTyrant = false
    _G.AutoFarm_Bone = false
    _G.FarmBoss = false
end

function _ResumeFarmAfterFruitMaru()
    if not _G.FruitPickActive then return end
    _G.FruitPickActive = false
    if _pausedFarmSnapshot then
        _G.Level            = _pausedFarmSnapshot.Level
        _G.Auto_Cake_Prince = _pausedFarmSnapshot.Cake
        _G.FarmTyrant       = _pausedFarmSnapshot.Tyrant
        _G.AutoFarm_Bone    = _pausedFarmSnapshot.Bone
        _G.FarmBoss         = _pausedFarmSnapshot.Boss
    end
    _pausedFarmSnapshot = nil
end

do
    Tabs.Race:AddToggle("Race_AutoTweenToWildFruit", {
    Title = "Auto Tween to Fruit",
    Description = "Khi có trái cây rơi trên map: tạm dừng farm, bay tới nhặt, xong tự farm tiếp",
    Default = false,
    Callback = function(Value)
        _G.TwFruits = Value
        if not Value then
            _ResumeFarmAfterFruitMaru()
        end
    end
    })
end

task.spawn(function()
    while task.wait(0.2) do
        if not _G.TwFruits then continue end
        if _G.FruitPickActive then continue end
        pcall(function()
            local handle = _FindNearestWildFruit()
            if handle then
                _PauseFarmForFruitMaru()
                repeat
                    task.wait()
                    if not _G.TwFruits then break end
                    if handle and handle.Parent then
                        _tp(CFrame.new(handle.Position))
                    end
                until not _G.TwFruits or not handle.Parent
                _ResumeFarmAfterFruitMaru()
            end
        end)
    end
end)

do
    Tabs.Race:AddToggle("Race_AutoCollectMirageChest", {
    Title =  "Auto Collect Mirage Chest",
    Description =  "Tự động nhặt rương Mirage",
    Default =  false,
    Callback =  function(Value)
  _G.FarmChestM = Value
end
})
end
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


do
    Tabs.Race:AddButton({
    Title =  "Talk With Stone",
    Description =  "Nói chuyện với cục đá",
    Callback =  function()
  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Begin")
  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Check")
  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Teleport")
  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Continue")
end
})
end
do
    Tabs.Race:AddToggle("Race_AutoLookAtMoon", {
    Title =  "Auto Look At Moon",
    Description =  "Tự động nhìn lên mặt trăng",
    Default =  false,
    Callback =  function(Value)
  LookM = Value
end
})
end
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

do
    Tabs.Race:AddToggle("Race_LookMoonAutoV3", {
    Title =  "Look Moon + Auto V3",
    Description =  "Nhìn trăng + tự động lên Tộc V3",
    Default =  false,
    Callback =  function(Value)
        LookMV3 = Value
    end

})
end

function MoveCamtoMoon()
    local moonDir = Lighting:GetMoonDirection()
    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + moonDir)
    plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, plr.Character.HumanoidRootPart.Position + moonDir)
end

task.spawn(function()
    while task.wait(0.1) do
        if LookMV3 then
            MoveCamtoMoon()
            replicated.Remotes.CommE:FireServer("ActivateAbility")            
            UIS:SendKeyEvent(true, "T", false, game)
            wait(0.5)
            UIS:SendKeyEvent(false, "T", false, game)
        end
    end
end)

Tabs.Race:AddSection("Upgrade Races V2 And V3")
do
    Tabs.Race:AddToggle("Race_AutoUpgradeMink", {
    Title =  "Auto Upgrade Mink",
    Description =  "Tự động nâng cấp tộc Thỏ",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Mink = Value
end
})
end
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
do
    Tabs.Race:AddToggle("Race_AutoUpgradeHuman", {
    Title =  "Auto Upgrade Human",
    Description =  "Tự động nâng cấp tộc Người",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Human = Value
end
})
end
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
do
    Tabs.Race:AddToggle("Race_AutoUpgradeAngel", {
    Title =  "Auto Upgrade Angel",
    Description =  "Tự động nâng cấp tộc Thiên Thần",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Skypiea = Value
end
})
end
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
do
    Tabs.Race:AddToggle("Race_AutoUpgradeFishMan", {
    Title =  "Auto Upgrade FishMan",
    Description =  "Tự động nâng cấp tộc Người Cá",
    Default =  false,
    Callback =  function(Value)
  _G.Auto_Fish = Value
end
})
end
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


Tabs.Race:AddSection("Trials Quest V4")
local CheckTier = Tabs.Race:AddParagraph({Title = "Tiers V4 Status", Content = ""})
spawn(function()
    pcall(function()
        while wait(0.2) do
            pcall(function() CheckTier:SetContent("Tiers - V4 : " .. " " .. plr.Data.Race.C.Value) end)
        end
    end)
end)
do
    Tabs.Race:AddToggle("Race_AutoPullLever", {
    Title =  "Auto Pull Lever",
    Description =  "Tự động kéo cần gạt",
    Default =  false,
    Callback =  function(Value)
  _G.Lver = Value
end
})
end
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
do
    Tabs.Race:AddToggle("Race_AutoTrainV4", {
    Title =  "Auto Train V4",
    Description =  "Tự động luyện Tộc V4",
    Default =  false,
    Callback =  function(Value)
  _G.AcientOne = Value
end
})
end
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

do
    Tabs.Race:AddButton({
    Title =  "Teleport to Temple of Time",
    Description =  "Dịch chuyển tới Đền Thời Gian",
    Callback =  function()
        local plr = game:GetService("Players").LocalPlayer
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
        end

        if not game:GetService("Workspace").Map:FindFirstChild("Temple of Time") and World3 then
            local stash = game:GetService("ReplicatedStorage"):FindFirstChild("MapStash")
            if stash and stash:FindFirstChild("Temple of Time") then
                stash["Temple of Time"].Parent = workspace.Map
            end
        end
    end

})
end
do
    Tabs.Race:AddButton({
    Title =  "Teleport to Ancient One",
    Description =  "Dịch chuyển tới Ancient One",
    Callback =  function()
        local plr = game:GetService("Players").LocalPlayer
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

        if hrp then
            hrp.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
        end

        if not game:GetService("Workspace").Map:FindFirstChild("Temple of Time") and World3 then
            local stash = game:GetService("ReplicatedStorage"):FindFirstChild("MapStash")
            if stash and stash:FindFirstChild("Temple of Time") then
                stash["Temple of Time"].Parent = workspace.Map
            end
        end
        
        task.wait(2)

        tween(CFrame.new(28981.552734375, 14888.4267578125, - 120.245849609375))
    end

})
end
do
    Tabs.Race:AddButton({
    Title =  "Teleport to Ancient Clock",
    Description =  "Dịch chuyển tới Đồng Hồ Cổ",
    Callback =  function()
        local plr = game:GetService("Players").LocalPlayer
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

        local pos1 = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)

        local pos2 = CFrame.new(29549, 15069, -88)

        if hrp then
            hrp.CFrame = pos1
        end

        task.delay(2, function()
            _tp(pos2)
        end)

        if not workspace.Map:FindFirstChild("Temple of Time") and World3 then
            local stash = game:GetService("ReplicatedStorage"):FindFirstChild("MapStash")
            if stash and stash:FindFirstChild("Temple of Time") then
                stash["Temple of Time"].Parent = workspace.Map
            end
        end
    end

})
end
do
    Tabs.Race:AddToggle("Race_AutoTeleporttoRaceDoors", {
    Title =  "Auto Teleport to Race Doors",
    Description =  "Tự động bay tới cửa Tộc",
    Default =  false,
    Callback =  function(Value)
  _G.TPDoor = Value
end
})
end
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
do
    Tabs.Race:AddToggle("Race_AutoCompleteTrialRace", {
    Title =  "Auto Complete Trial Race",
    Description =  "Tự động hoàn thành thử thách Tộc",
    Default =  false,
    Callback =  function(Value)
  _G.Complete_Trials = Value
end
})
end
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
do
    Tabs.Race:AddToggle("Race_AutoKillPlayerAfterTrial", {
    Title =  "Auto Kill Player After Trial",
    Description =  "Tự động giết người chơi sau thử thách",
    Default =  false,
    Callback =  function(Value)
  _G.Defeating = Value
end
})
end
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

Tabs.Prehistoric:AddSection("Dojo Quest")
do
    Tabs.Prehistoric:AddButton({
    Title =  "Teleport To Dragon Dojo",
    Callback =  function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773438, - 334.9649963378906))
        _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
    end

})
end
do
    Tabs.Prehistoric:AddToggle("Prehistoric_AutoDojoTrainer", {
    Title =  "Auto Dojo Trainer",
    Description =  "Tự động luyện Dojo",
    Default =  false,
    Callback =  function(Value)
  _G.Dojoo = Value
end
})
end
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
do
    Tabs.Prehistoric:AddToggle("Prehistoric_AutoDragonHunter", {
    Title =  "Auto Dragon Hunter",
    Description =  "Tự động săn Rồng",
    Default =  false,
    Callback =  function(Value)
  _G.FarmBlazeEM = Value
end
})
end
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

Tabs.Prehistoric:AddSection("Drago Trial")
GetQuestDracoLevel = function()
  local v371 = {[1] = {NPC = "Dragon Wizard",Command = "Upgrade"}};
  return replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(v371))
end
do
    Tabs.Prehistoric:AddToggle("Prehistoric_TweenToUpgradeDrocoTrial", {
    Title =  "Tween To Upgrade Droco Trial",
    Description =  "Bay tới chỗ nâng cấp thử thách Draco",
    Default =  false,
    Callback =  function(Value)
  _G.UPGDrago = Value
end
})
end
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
do
    Tabs.Prehistoric:AddToggle("Prehistoric_AutoDragoV1", {
    Title =  "Auto Drago (V1)",
    Description =  "Tự động làm Draco V1",
    Default =  false,
    Callback =  function(Value)
  _G.DragoV1 = Value
end
})
end
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
do
    Tabs.Prehistoric:AddToggle("Prehistoric_AutoDragoV2", {
    Title =  "Auto Drago (V2)",
    Description =  "Tự động làm Draco V2",
    Default =  false,
    Callback =  function(Value)
  _G.AutoFireFlowers = Value
end
})
end
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
do
    Tabs.Prehistoric:AddToggle("Prehistoric_AutoDragoV3", {
    Title =  "Auto Drago (V3)",
    Description =  "Tự động làm Draco V3",
    Default =  false,
    Callback =  function(Value)
  _G.DragoV3 = Value
end
})
end
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
do
    Tabs.Prehistoric:AddToggle("Prehistoric_AutoRelicDragoTrialBeta", {
    Title =  "Auto Relic Drago Trial [Beta]",
    Description =  "Tự động làm cổ vật Draco",
    Default =  false,
    Callback =  function(Value)
  _G.Relic123 = Value
end
})
end
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
do
    Tabs.Prehistoric:AddToggle("Prehistoric_AutoTrainDragov4", {
    Title =  "Auto Train Drago v4",
    Description =  "Tự động luyện Draco V4",
    Default =  false,
    Callback =  function(Value)
  _G.TrainDrago = Value
end
})
end
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
do
    Tabs.Prehistoric:AddToggle("Prehistoric_TweentoDragoTrials", {
    Title =  "Tween to Drago Trials",
    Description =  "Bay tới thử thách Draco",
    Default =  false,
    Callback =  function(Value)
  _G.TpDrago_Prehis = Value
end
})
end
spawn(function()
  while wait(Sec) do
    if _G.TpDrago_Prehis then
      local v748 = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport");
      if (v748 and v748:IsA("Part")) then _tp(CFrame.new(v748.Position)) end
    end
  end
end)
do
    Tabs.Prehistoric:AddToggle("Prehistoric_SwapDragoRace", {
    Title =  "Swap Drago Race",
    Description =  "Đổi tộc Draco",
    Default =  false,
    Callback =  function(Value)
  _G.BuyDrago = Value
end
})
end
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
do
    Tabs.Prehistoric:AddToggle("Prehistoric_UpgradeDragonTalonWithUzoth", {
    Title =  "Upgrade Dragon Talon With Uzoth",
    Description =  "Nâng Dragon Talon với Uzoth",
    Default =  false,
    Callback =  function(Value)
  _G.DT_Uzoth = Value
end
})
end
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

Tabs.Prehistoric:AddSection("Volcanic Crafting")
do
    Tabs.Prehistoric:AddButton({
    Title =  "Craft Dragonheart",
    Description =  "Chế tạo Dragonheart",
    Callback =  function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "Dragonheart"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end

})
end

do
    Tabs.Prehistoric:AddButton({
    Title =  "Craft Dragonstorm",
    Description =  "Chế tạo Dragonstorm",
    Callback =  function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "Dragonstorm"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end

})
end

do
    Tabs.Prehistoric:AddButton({
    Title =  "Craft Dino Hood",
    Description =  "Chế tạo mũ Dino",
    Callback =  function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "DinoHood"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end

})
end

do
    Tabs.Prehistoric:AddButton({
    Title =  "Craft T-Rex Skull",
    Description =  "Chế tạo sọ T-Rex",
    Callback =  function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "TRexSkull"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end

})
end


Tabs.Prehistoric:AddSection("Prehistoric Island")
local Check_Volcano = Tabs.Prehistoric:AddParagraph({Title = "Prehistoric Island Status", Content = ""})
spawn(function()
    while wait(0.2) do
        if workspace.Map:FindFirstChild("PrehistoricIsland") or workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") then
            pcall(function() Check_Volcano:SetContent("Prehistoric Island : True") end)
        else
            pcall(function() Check_Volcano:SetContent("Prehistoric Island : False") end)
        end
    end
end)

do
    Tabs.Prehistoric:AddButton({
    Title =  "Craft Volcanic Magnet",
    Description =  "Chế tạo nam châm núi lửa",
    Callback =  function()
        local RF = game:GetService("ReplicatedStorage").Modules.Net["RF/Craft"]

        RF:InvokeServer(
            "PossibleHardcode",
            "Volcanic Magnet"
        )
    end

})
end

do
    Tabs.Prehistoric:AddToggle("Prehistoric_CraftVolcanicMagnet2", {
    Title =  "Craft Volcanic Magnet",
    Description =  "Chế tạo nam châm núi lửa",
    Default =  false,
    Callback =  function(Value)
        getgenv().AutoCraftVolcanic = Value
    end

})
end

task.spawn(function()
    local RF = game:GetService("ReplicatedStorage").Modules.Net["RF/Craft"]

    while task.wait(0.3) do
        if getgenv().AutoCraftVolcanic then
            pcall(function()
                RF:InvokeServer(
                    "PossibleHardcode",
                    "Volcanic Magnet"
                )
            end)

            getgenv().AutoCraftVolcanic = false
        end
    end
end)



do
    Tabs.Prehistoric:AddToggle("Prehistoric_AutoFindPrehistoricIsland", {
    Title =  "Auto Find Prehistoric Island",
    Description =  "Tự động tìm đảo tiền sử",
    Default =  false,
    Callback =  function(Value)
        _G.Prehis_Find = Value
    end

})
end

local targetDestination = nil

spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Prehis_Find then
                local char = plr.Character
                if not char then return end

                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChild("Humanoid")
                if not hrp or not hum or hum.Health <= 0 then return end

                local Locations = workspace["_WorldOrigin"].Locations
                local prehistoricLoc = Locations:FindFirstChild("Prehistoric Island", true)

              
                if not prehistoricLoc then
                    local myBoat = CheckBoat()

                    
                    if not myBoat then
                        local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)
                        TeleportToTarget(buyBoatCFrame)

                        if (buyBoatCFrame.Position - hrp.Position).Magnitude <= 10 then
                            replicated.Remotes.CommF_:InvokeServer(
                                "BuyBoat",
                                _G.SelectedBoat or "Guardian"
                            )
                        end
                        return
                    end

                  
                    if hum.Sit == false then
                        local seatCFrame = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)
                        _tp(seatCFrame)
                        return
                    end

                   
                    local seaCFrame = CFrame.new(-10000000, 31, 37016.25)
                    targetDestination = seaCFrame

                    if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then
                        _tp(CFrame.new(-10000000, 150, 37016.25))
                    else
                        _tp(seaCFrame)
                    end

               
                else
                    local stoneHead =
                        prehistoricLoc:FindFirstChild("HeadTeleport", true)
                        or prehistoricLoc:FindFirstChild("Teleport_Head", true)
                        or prehistoricLoc:FindFirstChild("Head", true)

                    if stoneHead then
                        local headCF = stoneHead.CFrame
                        local safePos =
                            headCF.Position
                            - headCF.LookVector * 40
                            + Vector3.new(0, 20, 0)

                        if (safePos - hrp.Position).Magnitude > 30 then
                            _tp(CFrame.new(safePos))
                        end
                    else
                        local islandPos = prehistoricLoc.CFrame.Position
                        local dir = (islandPos - hrp.Position).Unit
                        local safePos = islandPos - dir * 250 + Vector3.new(0, 60, 0)
                        _tp(CFrame.new(safePos))
                    end
                end
            end
        end)
    end
end)

do
    Tabs.Prehistoric:AddToggle("Prehistoric_AutoStartPrehistoricEvent", {
    Title =  "Auto Start Prehistoric Event",
    Description =  "Tự động bắt đầu sự kiện tiền sử",
    Default =  false,
    Callback =  function(Value)
        _G.AutoStartPrehistoric = Value
    end

})
end
spawn(function()
    while wait() do
        if _G.AutoStartPrehistoric then
            pcall(function()
                local prehistoricIsland = workspace["_WorldOrigin"].Locations:FindFirstChild("Prehistoric Island", true)
                if prehistoricIsland then
                    if workspace.Map:FindFirstChild("PrehistoricIsland", true) then
                        local promptPart = workspace.Map.PrehistoricIsland.Core:FindFirstChild("ActivationPrompt", true)
                        if promptPart and promptPart:FindFirstChild("ProximityPrompt") then
                            if plr:DistanceFromCharacter(promptPart.CFrame.Position) <= 150 then
                                fireproximityprompt(promptPart.ProximityPrompt, math.huge)
                                vim1:SendKeyEvent(true, "E", false, game)
                                wait(1.5)
                                vim1:SendKeyEvent(false, "E", false, game)
                            end
                            _tp(promptPart.CFrame)
                        end
                    end
                end
            end)
        end
    end
end)




do
    Tabs.Prehistoric:AddToggle("Prehistoric_AutoPatchPrehistoricEvent", {
    Title =  "Auto Patch Prehistoric Event",
    Description =  "Tự động vá lỗi sự kiện tiền sử",
    Default =  false,
    Callback =  function(Value)
        _G.Prehis_Skills = Value
    end

})
end



spawn(function()
    while wait(0.3) do
        if _G.Prehis_Skills then
            pcall(function()
                local island = workspace.Map:FindFirstChild("PrehistoricIsland")
                if not island then return end

                for _, obj in pairs(island:GetDescendants()) do
                    if (obj:IsA("BasePart") or obj:IsA("MeshPart"))
                        and obj.Name:lower():find("lava") then
                        obj:Destroy()
                    end
                end

                local core = island:FindFirstChild("Core")
                if core then
                    local lavaModel = core:FindFirstChild("InteriorLava")
                    if lavaModel then lavaModel:Destroy() end
                end

                local trialTeleport = island:FindFirstChild("TrialTeleport")
                for _, v in pairs(island:GetDescendants()) do
                    if v.Name == "TouchInterest"
                    and not (trialTeleport and v:IsDescendantOf(trialTeleport)) then
                        v.Parent:Destroy()
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait(Sec) do
        if _G.Prehis_Skills then
            pcall(function()
                local golem = GetConnectionEnemies("Lava Golem")
                if golem and golem:FindFirstChild("Humanoid") then
                    repeat
                        wait(0.1)
                        Attack.Kill(golem, true)
                        golem.Humanoid:ChangeState(15)
                    until not _G.Prehis_Skills
                        or not golem.Parent
                        or golem.Humanoid.Health <= 0
                end
            end)
        end
    end
end)


spawn(function()
    while wait(Sec) do
        if _G.Prehis_Skills then
            pcall(function()
                local island = workspace.Map:FindFirstChild("PrehistoricIsland")
                if not island then return end

                local core = island:FindFirstChild("Core")
                if not core then return end

                local rocks = core:FindFirstChild("VolcanoRocks")
                if not rocks then return end

                for _, rock in pairs(rocks:GetChildren()) do
                    local layer = rock:FindFirstChild("VFXLayer")
                    local at0 = layer and layer:FindFirstChild("At0")
                    local glow = at0 and at0:FindFirstChild("Glow")

                    if glow and glow.Enabled then
                        repeat
                            wait(0.1)
                            _tp(layer.CFrame)

                            if plr:DistanceFromCharacter(layer.CFrame.Position) <= 150 then
                                MousePos = layer.CFrame.Position
                                Useskills("Melee","Z") wait(.4)
                                Useskills("Melee","X") wait(.4)
                                Useskills("Melee","C") wait(.4)
                                Useskills("Blox Fruit","Z") wait(.4)
                                Useskills("Blox Fruit","X") wait(.4)
                                Useskills("Blox Fruit","C")
                            end
                        until not _G.Prehis_Skills or not glow.Enabled
                    end
                end
            end)
        end
    end
end)

do
    Tabs.Prehistoric:AddToggle("Prehistoric_KillAura", {
    Title =  "Kill Aura",
    Description =  "Đánh lan xung quanh",
    Default =  false,
    Callback =  function(Value)
    _G.KillAuraFull = Value
end
})
end

local Range = 500
local Delay = 2   

spawn(function()
    while task.wait(Delay) do
        if _G.KillAuraFull then
            pcall(function()
                local plr = game.Players.LocalPlayer
                local char = plr.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                sethiddenproperty(plr, "SimulationRadius", math.huge)

                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                        local dist = (enemy.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist <= Range and enemy.Humanoid.Health > 0 then
                            enemy.Humanoid.Health = 0
                            enemy.HumanoidRootPart.CanCollide = false
                            enemy:BreakJoints()
                        end
                    end
                end
            end)
        end
    end
end)
do
    Tabs.Prehistoric:AddToggle("Prehistoric_AutoCollectDinoBones", {
    Title =  "Auto Collect Dino Bones",
    Description =  "Tự động nhặt xương khủng long",
    Default =  false,
    Callback =  function(Value)
  _G.Prehis_DB = Value
end
})
end
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
do
    Tabs.Prehistoric:AddToggle("Prehistoric_AutoCollectDragonEggs", {
    Title =  "Auto Collect Dragon Eggs",
    Description =  "Tự động nhặt trứng rồng",
    Default =  false,
    Callback =  function(Value)
  _G.Prehis_DE = Value
end
})
end
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Prehis_DE then
      if workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:FindFirstChild("DragonEgg") then _tp(workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:FindFirstChild("DragonEgg").Molten.CFrame) fireproximityprompt(workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs.DragonEgg.Molten.ProximityPrompt, 30) end        
      end
    end)
  end
end)
do
    Tabs.Prehistoric:AddToggle("Prehistoric_AutoResetWhenCompleteVolcano", {
    Title =  "Auto Reset When Complete Volcano",
    Description =  "Tự động reset khi xong núi lửa",
    Default =  false,
    Callback =  function(Value)
  _G.ResetPH = Value
end
})
end
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


do
    Tabs.SeaEvent:AddButton({
    Title =  "Remove Lighting Effect",
    Description =  "Xóa hiệu ứng ánh sáng cho dễ nhìn",
    Callback =  function()
        game:GetService("Lighting").BaseAtmosphere:Destroy()
    end

})
end

do
    Tabs.SeaEvent:AddToggle("SeaEvent_ShipSpeedModifier", {
    Title =  "Ship Speed Modifier",
    Description =  "Bật chỉnh tốc độ tàu",
    Default =  false,
    Callback =  function(Value)
        getgenv().SpeedBoat = Value
    end

})
end
game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().SpeedBoat then
        local plr = game:GetService("Players").LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            if plr.Character.Humanoid.Sit then
                for _, boat in pairs(game:GetService("Workspace").Boats:GetChildren()) do
                    local seat = boat:FindFirstChildWhichIsA("VehicleSeat")
                    if seat then
                        seat.MaxSpeed = SetSpeedBoat
                    end
                end
            end
        end
    end
end)
do
    Tabs.SeaEvent:AddSlider("SeaEvent_ShipSpeed", {
    Title =  "Ship Speed",
    Description =  "Tốc độ tàu",
    Min =  0,
    Max =  1000,
    Default =  300,
    Callback =  function(Value)
        SetSpeedBoat = Value
    end
,
    Rounding = 0
})
end
do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoPressW", {
    Title =  "Auto Press W",
    Description =  "Tự động nhấn W để chạy tàu",
    Default =  false,
    Callback =  function(Value)
        getgenv().AutoPressW = Value
    end

})
end
spawn(function()
    while wait() do
        pcall(function()
            if getgenv().AutoPressW then
                local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
                if humanoid.Sit == true then
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game)
                end
            end
        end)
    end
end)
do
    Tabs.SeaEvent:AddToggle("SeaEvent_NoClipShip", {
    Title =  "No Clip Ship",
    Description =  "Tàu đi xuyên vật thể",
    Default =  false,
    Callback =  function(Value)
        getgenv().NoClipShip = Value
    end

})
end
spawn(function()
    while wait() do
        pcall(function()
            for i, boat in pairs(game:GetService("Workspace").Boats:GetChildren()) do
                for _, v in pairs(boat:GetDescendants()) do
                    if v:IsA("BasePart") then
                        if getgenv().NoClipShip or getgenv().FindPrehistoric then
                            v.CanCollide = false
                        else
                            v.CanCollide = true
                        end
                    end
                end
            end
        end)
    end
end)

Tabs.SeaEvent:AddSection("Crafting Items")
do
    Tabs.SeaEvent:AddButton({
    Title =  "Craft SharkTooth",
    Description =  "Chế tạo răng cá mập",
    Callback =  function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "SharkTooth"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end

})
end

do
    Tabs.SeaEvent:AddButton({
    Title =  "Craft TerrorJaw",
    Description =  "Chế tạo hàm Terror",
    Callback =  function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "TerrorJaw"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end

})
end

do
    Tabs.SeaEvent:AddButton({
    Title =  "Craft SharkAnchor",
    Description =  "Chế tạo mỏ neo cá mập",
    Callback =  function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "SharkAnchor"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end

})
end

do
    Tabs.SeaEvent:AddButton({
    Title =  "Craft LeviathanCrown",
    Description =  "Chế tạo vương miện Leviathan",
    Callback =  function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "LeviathanCrown"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end

})
end
 
do
    Tabs.SeaEvent:AddButton({
    Title =  "Craft LeviathanShield",
    Description =  "Chế tạo khiên Leviathan",
    Callback =  function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "LeviathanShield"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end

})
end

do
    Tabs.SeaEvent:AddButton({
    Title =  "Craft LeviathanBoat",
    Description =  "Chế tạo tàu Leviathan",
    Callback =  function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "LeviathanBoat"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end

})
end

do
    Tabs.SeaEvent:AddButton({
    Title =  "Craft LegendaryScroll",
    Description =  "Chế tạo cuộn huyền thoại",
    Callback =  function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "LegendaryScroll"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end

})
end

do
    Tabs.SeaEvent:AddButton({
    Title =  "Craft MythicalScroll",
    Description =  "Chế tạo cuộn thần thoại",
    Callback =  function()
        local args = {
            [1] = "CraftItem",
            [2] = "Craft",
            [3] = "MythicalScroll"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end

})
end
Tabs.SeaEvent:AddSection("Choose Sea Event")
do
    Tabs.SeaEvent:AddDropdown("SeaEvent_SelectBoats", {
    Title =  "Select Boats",
    Description =  "Chọn loại tàu",
    Values =  ListSeaBoat,
    Callback =  function(Value)
        _G.SelectedBoat = Value
    end
,
    Multi = false
})
end
do
    Tabs.SeaEvent:AddButton({
    Title =  "Buy Boats",
    Description =  "Mua tàu",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyBoat",_G.SelectedBoat)
end
})
end
do
    Tabs.SeaEvent:AddDropdown("SeaEvent_SelectSeaLevel", {
    Title =  "Select Sea Level",
    Description =  "Chọn cấp độ biển",
    Values =  ListSeaZone,
    Callback =  function(Value)
  _G.DangerSc = Value
end,
    Multi = false
})
end
do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoSailBoat", {
    Title =  "Auto Sail Boat",
    Description =  "Tự động lái tàu ra biển",
    Default =  false,
    Callback =  function(Value)
  _G.SailBoats = Value
end
})
end
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
do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoShark", {
    Title =  "Auto Shark",
    Description =  "Tự động farm cá mập",
    Default =  false,
    Callback =  function(Value)
  _G.Shark = Value
end
})
end

do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoPiranha", {
    Title =  "Auto Piranha",
    Description =  "Tự động farm cá Piranha",
    Default =  false,
    Callback =  function(Value)
  _G.Piranha = Value
end
})
end

do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoTerrorShark", {
    Title =  "Auto Terror Shark",
    Description =  "Tự động farm Terror Shark",
    Default =  false,
    Callback =  function(Value)
  _G.TerrorShark = Value
end
})
end

do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoFishCrewMember", {
    Title =  "Auto Fish Crew Member",
    Description =  "Tự động farm lính cá",
    Default =  false,
    Callback =  function(Value)
  _G.MobCrew = Value
end
})
end

do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoHauntedCrewMember", {
    Title =  "Auto Haunted Crew Member",
    Description =  "Tự động farm lính ma",
    Default =  false,
    Callback =  function(Value)
  _G.HCM = Value
end
})
end

do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoAttackPirateGrandBrigade", {
    Title =  "Auto Attack PirateGrandBrigade",
    Description =  "Tự động đánh tàu hải tặc lớn",
    Default =  false,
    Callback =  function(Value)
  _G.PGB = Value
end
})
end

do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoAttackFishBoat", {
    Title =  "Auto Attack Fish Boat",
    Description =  "Tự động đánh tàu cá",
    Default =  false,
    Callback =  function(Value)
  _G.FishBoat = Value
end
})
end

do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoAttackSeaBeast", {
    Title =  "Auto Attack Sea Beast",
    Description =  "Tự động đánh quái biển",
    Default =  false,
    Callback =  function(Value)
  _G.SeaBeast1 = Value
end
})
end

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
local Check_Kitsu = Tabs.SeaEvent:AddParagraph({Title = "Kitsune Island Status", Content = ""})
spawn(function()
    while wait(0.2) do
        if workspace.Map:FindFirstChild("KitsuneIsland") or workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island") then
            pcall(function() Check_Kitsu:SetContent("Kitsune Island : True") end)
        else
            pcall(function() Check_Kitsu:SetContent("Kitsune Island : False") end)
        end
    end
end)

do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoFindKitsuneIsland", {
    Title =  "Auto Find Kitsune Island",
    Description =  "Tự động tìm đảo Cáo 9 đuôi",
    Default =  false,
    Callback =  function(Value)
  _G.AutofindKitIs = Value
end
})
end
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

do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoTeleporttoShrineActived", {
    Title =  "Auto Teleport to Shrine Actived",
    Description =  "Tự động bay tới đền đã kích hoạt",
    Default =  false,
    Callback =  function(Value)
  _G.tweenShrine = Value
end
})
end
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

do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoCollectAzureEmber", {
    Title =  "Auto Collect Azure Ember",
    Description =  "Tự động nhặt Ember xanh",
    Default =  false,
    Callback =  function(Value)
  _G.Collect_Ember = Value
end
})
end
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

do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoTradeAzureEmber", {
    Title =  "Auto Trade Azure Ember",
    Description =  "Tự động đổi Ember xanh",
    Default =  false,
    Callback =  function(Value)
  _G.Trade_Ember = Value
end
})
end
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

do
    Tabs.SeaEvent:AddButton({
    Title =  "Trade Items Azure",
    Description =  "Đổi vật phẩm Azure",
    Callback =  function()
  replicated.Modules.Net:FindFirstChild("RF/KitsuneStatuePray"):InvokeServer()
end
})
end

do
    Tabs.SeaEvent:AddButton({
    Title =  "Talk with kitsune statue",
    Description =  "Nói chuyện với tượng cáo",
    Callback =  function()
  replicated.Modules.Net:FindFirstChild("RE/TouchKitsuneStatue"):FireServer()
end
})
end

Tabs.SeaEvent:AddSection("Frozen Dimension Event")
local FloD = Tabs.SeaEvent:AddParagraph({Title = "FrozenDimension Status", Content = ""})
spawn(function()
    pcall(function()
        while wait(0.2) do
            if workspace._WorldOrigin.Locations:FindFirstChild('Frozen Dimension') then
                pcall(function() FloD:SetContent('Frozen Dimension : True') end)
            else
                pcall(function() FloD:SetContent('Frozen Dimension : False') end)
            end
        end
    end)
end)

local SPYING = Tabs.SeaEvent:AddParagraph({Title = "Spy Status", Content = ""})
spawn(function()
    while wait(0.2) do
        pcall(function()
            local spycheck = string.match(replicated.Remotes.CommF_:InvokeServer("InfoLeviathan", "1"), "%d+")
            if spycheck then 
                pcall(function() SPYING:SetContent("Spy Leviathan : " .. tostring(spycheck)) end)
                if tonumber(spycheck) == 5 then
                    pcall(function() SPYING:SetContent("Spy Leviathan : Already Done!!") end)
                end
            end
        end)
    end
end)

do
    Tabs.SeaEvent:AddButton({
    Title =  "Buy Spy",
    Description =  "Mua ống nhòm Spy",
    Callback =  function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("InfoLeviathan", "2")
    end

})
end


do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoTeleportFrozenDimension", {
    Title =  "Auto Teleport Frozen Dimension",
    Description =  "Tự động bay tới chiều không gian băng",
    Default =  false,
    Callback =  function(Value)
  _G.FrozenTP = Value
end
})
end
spawn(function()
  while wait(.1) do
    if _G.FrozenTP then
      pcall(function()
      if workspace.Map:FindFirstChild("LeviathanGate") then _tp(workspace.Map.LeviathanGate.CFrame) replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("OpenLeviathanGate") end
      end)
    end
  end
end)

do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoDriveToHydraIsland", {
    Title =  "Auto Drive To Hydra Island",
    Description =  "Tự động lái tới đảo Hydra",
    Default =  false,
    Callback =  function(Value)
  _G.SailBoat_Hydra = Value
end
})
end
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

do
    Tabs.SeaEvent:AddToggle("SeaEvent_AutoAttackLeviathan", {
    Title =  "Auto Attack Leviathan",
    Description =  "Tự động đánh Leviathan",
    Default =  false,
    Callback =  function(Value)
  _G.Leviathan1 = Value
end
})
end


Tabs.Esp:AddSection("Esp")
function isnil(thing)
    return (thing == nil)
end
local function round(n)
    return math.floor(tonumber(n) + 0.5)
end
Number = math.random(1, 1000000)


local plr = game:GetService('Players').LocalPlayer
local replicated = game:GetService("ReplicatedStorage")
local TeamSelf = plr.Team


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
                        name.Text = (v.Name ..' \n'.. round((plr.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M')
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        if v.Team == TeamSelf then
                            name.TextColor3 = Color3.new(0.5,0.5,0.5)
                        else
                            name.TextColor3 = Color3.new(255,0,0)
                        end
                    else
                        if v.Character.Head:FindFirstChild('NameEsp'..Number) then
                            v.Character.Head['NameEsp'..Number].TextLabel.Text = (v.Name ..' | '.. round((plr.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M\nHealth : ' .. round(v.Character.Humanoid.Health*100/v.Character.Humanoid.MaxHealth) .. '%')
                        end
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
                        name.Text = (v.Name ..'   \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                    else
                        v['NameEsp'].TextLabel.Text = (v.Name ..'   \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
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
                        name.Text = (v.Name ..' \n'.. round((plr.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' M')
                    else
                        v.Handle['NameEsp'..Number].TextLabel.Text = ('[' ..v.Name ..']' ..'   \n'.. round((plr.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' M')
                    end
                end
            else
                if v:FindFirstChild('Handle') and v.Handle:FindFirstChild('NameEsp'..Number) then
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
                        name.TextColor3 = Color3.fromRGB(128,128,128)
                        if v.Name == "Flower1" then 
                            name.Text = ("Blue Flower" ..' \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                        elseif v.Name == "Flower2" then
                            name.Text = ("Red Flower" ..' \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                        end
                    else
                        v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
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
                        name.TextColor3 = Color3.fromRGB(128,128,128)
                        name.Text = (v.Name .. "   \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3) .. " M")
                    else
                        v.NameEsp.TextLabel.Text = v.Name .. "   \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3) .. " M"
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
                        name.TextColor3 = Color3.fromRGB(128,128,128)
                        name.Text = ("Gear" .."   \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3).. " M")
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
    if advanEsp then     
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
                        name.TextColor3 = Color3.fromRGB(128,128,128)
                        name.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")
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
    if ColorEsp then     
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
                        name.TextColor3 = Color3.fromRGB(128,128,128)
                        name.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")
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
    if LegenS then     
        for _,v in pairs(replicated.NPCs:GetChildren()) do
            if v.Name == "Legendary Sword Dealer" then
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
                        name.TextColor3 = Color3.fromRGB(128,128,128)
                        name.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")
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
        local Chests = CollectionService:GetTagged("_ChestTagged")        
        for _, Chest in ipairs(Chests) do
            pcall(function()
                local chestPos = Chest:GetPivot().Position
                local distanceMagnitude = (chestPos - plr.Character.Head.Position).Magnitude
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
                    nameLabel.TextColor3 = Color3.fromRGB(128,128,128)
                    nameLabel.Parent = nameEsp
                end
                
                local nameEsp = existingEsp and existingEsp:FindFirstChild("NameEsp")
                if nameEsp then
                    local displayDistance = math.floor(distanceMagnitude / 3)
                    local chestName = Chest.Name:gsub("Label", "")
                    nameEsp.TextLabel.Text = string.format("[%s] %d M", chestName, displayDistance)
                end
            end)
        end
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
        local BerryBushes = CollectionService:GetTagged("BerryBush")
        for _, Bush in ipairs(BerryBushes) do
            pcall(function()
                local bushPosition = Bush.Parent:GetPivot().Position
                for _, BerryName in pairs(Bush:GetAttributes()) do
                    if BerryName then
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
                            nameLabel.TextColor3 = Color3.fromRGB(128,128,128)
                        end
                        
                        local nameEsp = existingEsp:FindFirstChild("NameEsp")
                        local distance = (plr.Character.Head.Position - bushPosition).Magnitude / 3
                        if nameEsp then
                            nameEsp.TextLabel.Text = ('[' .. BerryName .. ']' .. " " .. math.round(distance) .. " M")
                        end
                    end
                end
            end)
        end
    else
        for _, v in ipairs(workspace:GetChildren()) do
            if v:IsA("Part") and v.Name:match("BerryEspPart_.*") then
                v:Destroy()
            end
        end
    end
end


do
    Tabs.Esp:AddToggle("Esp_EspBerry", {
    Title =  "Esp Berry",
    Description =  "Hiện Berry",
    Default =  false,
    Callback =  function(Value)
        BerryEsp = Value
        if not Value then
            for _, v in ipairs(workspace:GetChildren()) do
                if v:IsA("Part") and v.Name:match("BerryEspPart_.*") then
                    v:Destroy()
                end
            end
        else
            task.spawn(function()
                while BerryEsp do
                    berriesEsp()
                    task.wait()
                end
            end)
        end
    end

})
end

do
    Tabs.Esp:AddToggle("Esp_EspPlayer", {
    Title =  "Esp Player",
    Description =  "Hiện người chơi",
    Default =  false,
    Callback =  function(Value)
        PlayerEsp = Value
        if not Value then
            for _,v in next, game.Players:GetChildren() do
                pcall(function()
                    if not isnil(v.Character) and not isnil(v.Character.Head) then
                        if v.Character.Head:FindFirstChild('NameEsp'..Number) then
                            v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()
                        end
                    end
                end)
            end
        else
            task.spawn(function()
                while PlayerEsp do
                    EspPly()
                    task.wait()
                end
            end)
        end
    end

})
end

do
    Tabs.Esp:AddToggle("Esp_EspChest", {
    Title =  "Esp Chest",
    Description =  "Hiện rương",
    Default =  false,
    Callback =  function(Value)
        ChestESP = Value
        if not Value then
            for _, Chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
                local espAttachment = Chest:FindFirstChild("ChestEspAttachment")
                if espAttachment then
                    espAttachment:Destroy()
                end
            end
        else
            task.spawn(function()
                while ChestESP do
                    ChestEsp()
                    task.wait()
                end
            end)
        end
    end

})
end

do
    Tabs.Esp:AddToggle("Esp_EspFruit", {
    Title =  "Esp Fruit",
    Description =  "Hiện trái ác quỷ",
    Default =  false,
    Callback =  function(Value)
        DevilFruitESP = Value
        if not Value then
            for i,v in next, workspace:GetChildren() do
                pcall(function()
                    if v:FindFirstChild('Handle') and v.Handle:FindFirstChild('NameEsp'..Number) then
                        v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while DevilFruitESP do
                    DevEsp()
                    task.wait()
                end
            end)
        end
    end

})
end

do
    Tabs.Esp:AddToggle("Esp_EspIsland", {
    Title =  "Esp Island",
    Description =  "Hiện đảo",
    Default =  false,
    Callback =  function(Value)
        IslandESP = Value
        if not Value then
            for _,v in next, workspace["_WorldOrigin"].Locations:GetChildren() do
                pcall(function()
                    if v:FindFirstChild('NameEsp') then
                        v:FindFirstChild('NameEsp'):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while IslandESP do
                    LocationEsp()
                    task.wait()
                end
            end)
        end
    end

})
end

do
    Tabs.Esp:AddToggle("Esp_EspFlower", {
    Title =  "Esp Flower",
    Description =  "Hiện hoa",
    Default =  false,
    Callback =  function(Value)
        FlowerESP = Value
        if not Value then
            for i,v in pairs(workspace:GetChildren()) do
                pcall(function()
                    if (v.Name == "Flower2" or v.Name == "Flower1") and v:FindFirstChild('NameEsp'..Number) then
                        v:FindFirstChild('NameEsp'..Number):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while FlowerESP do
                    flowerEsp()
                    task.wait()
                end
            end)
        end
    end

})
end

do
    Tabs.Esp:AddToggle("Esp_EspLegendarySword", {
    Title =  "Esp Legendary Sword",
    Description =  "Hiện kiếm huyền thoại",
    Default =  false,
    Callback =  function(Value)
        LegenS = Value
        if not Value then
            if workspace:FindFirstChild("Lgd") then
                workspace:FindFirstChild("Lgd"):Destroy()
            end
        else
            task.spawn(function()
                while LegenS do
                    LegenSword()
                    task.wait()
                end
            end)
        end
    end

})
end

do
    Tabs.Esp:AddToggle("Esp_EspHakiColor", {
    Title =  "Esp Haki Color",
    Description =  "Hiện màu Haki",
    Default =  false,
    Callback =  function(Value)
        ColorEsp = Value
        if not Value then
            if workspace:FindFirstChild("Gay") then
                workspace:FindFirstChild("Gay"):Destroy()
            end
        else
            task.spawn(function()
                while ColorEsp do
                    HakiClorEsp()
                    task.wait()
                end
            end)
        end
    end

})
end

do
    Tabs.Esp:AddToggle("Esp_EspGear", {
    Title =  "Esp Gear",
    Description =  "Hiện bánh răng",
    Default =  false,
    Callback =  function(Value)
        ESPGear = Value
        if not Value then
            for _,v in pairs(workspace.Map.MysticIsland:GetDescendants()) do
                pcall(function()
                    if v:FindFirstChild("NameEsp") then
                        v:FindFirstChild("NameEsp"):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while ESPGear do
                    gearEsp()
                    task.wait()
                end
            end)
        end
    end

})
end

do
    Tabs.Esp:AddToggle("Esp_EspSeaEventIsland", {
    Title =  "Esp SeaEvent Island",
    Description =  "Hiện đảo sự kiện biển",
    Default =  false,
    Callback =  function(Value)
        EspEventIsland = Value
        if not Value then
            for i, v in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
                pcall(function()
                    if v:FindFirstChild("NameEsp") then
                        v:FindFirstChild("NameEsp"):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while EspEventIsland do
                    EventIslandEsp()
                    task.wait()
                end
            end)
        end
    end

})
end

do
    Tabs.Esp:AddToggle("Esp_EspAdvancedDealer", {
    Title =  "Esp Advanced Dealer",
    Description =  "Hiện NPC bán trái xịn",
    Default =  false,
    Callback =  function(Value)
        advanEsp = Value
        if not Value then
            if workspace:FindFirstChild("Adv") then
                workspace:FindFirstChild("Adv"):Destroy()
            end
        else
            task.spawn(function()
                while advanEsp do
                    AdvanFruitEsp()
                    task.wait()
                end
            end)
        end
    end

})
end

-- CHECK STATS DISPLAY (từ bf.lua)
do
    local StatsParagraph = Tabs.Esp:AddParagraph({
        Title = "📊 Character Stats",
        Content = "Loading..."
    })
    
    task.spawn(function()
        while true do
            pcall(function()
                local Data = plr:FindFirstChild("Data")
                if not Data then StatsParagraph:Set("Data not found") task.wait(1) return end
                
                local Stats = Data:FindFirstChild("Stats")
                if not Stats then StatsParagraph:Set("Stats not found") task.wait(1) return end
                
                local lines = {}
                for _, statName in ipairs({"Melee", "Defense", "Sword", "Gun", "Demon Fruit"}) do
                    local statFolder = Stats:FindFirstChild(statName)
                    if statFolder and statFolder:FindFirstChild("Level") then
                        lines[#lines + 1] = string.format("%s: %s", statName, tostring(statFolder.Level.Value))
                    else
                        lines[#lines + 1] = statName .. ": ❌"
                    end
                end
                
                local Data2 = plr:FindFirstChild("Data")
                local bounty = "?"
                local gold = "?"
                local exp = "?"
                local fruit = "N/A"
                
                if Data2 then
                    local b = Data2:FindFirstChild("Bounty")
                    if b then bounty = tostring(b.Value):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "") end
                    local g = Data2:FindFirstChild("Beli")
                    if g then gold = tostring(g.Value):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "") end
                    local e = Data2:FindFirstChild("Exp")
                    if e then exp = tostring(e.Value):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "") end
                    local f = Data2:FindFirstChild("DevilFruit")
                    if f then fruit = tostring(f.Value) end
                end
                
                local content = table.concat(lines, "\n") 
                    .. "\n\n💰 Bounty: " .. bounty 
                    .. "\n🪙 Gold: " .. gold 
                    .. "\n✨ EXP: " .. exp 
                    .. "\n🍎 Fruit: " .. fruit
                
                StatsParagraph:Set(content)
            end)
            task.wait(1)
        end
    end)
end

Tabs.Raids:AddSection("Fruits Options")
local function formatNumber(number)
    local str = tostring(number)
    repeat
        local replaced, count = str:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        str = replaced
    until count == 0
    return str
end

local function getFruitStock()
    local resultStr = "Advance Fruit Stock\n"
    local success, advanceFruits = pcall(function()
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits", true)
    end)

    if not success or not advanceFruits then
        resultStr = resultStr .. "- Error while retrieving data.\n"
    else
        local hasFruit = false
        for _, fruit in pairs(advanceFruits) do
            if fruit.OnSale then
                hasFruit = true
                resultStr = resultStr .. fruit.Name .. " - $" .. formatNumber(fruit.Price) .. "\n"
            end
        end
        if not hasFruit then
            resultStr = resultStr .. "- No fruit.\n"
        end
    end

    resultStr = resultStr .. "\nNormal Fruit Stock\n"
    local success2, normalFruits = pcall(function()
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
    end)

    if success2 and normalFruits then
        local hasFruit = false
        for _, fruit in pairs(normalFruits) do
            if fruit.OnSale then
                hasFruit = true
                resultStr = resultStr .. fruit.Name .. " - $" .. formatNumber(fruit.Price) .. "\n"
            end
        end
        if not hasFruit then
            resultStr = resultStr .. "- No fruit.\n"
        end
    else
        resultStr = resultStr .. "- Error while retrieving data.\n"
    end

    return resultStr
end

local stockParagraph = Tabs.Raids:AddParagraph({Title = "Stock Fruit", Content = "Loading..."})

task.spawn(function()
    while task.wait(60) do
        pcall(function()
            pcall(function() stockParagraph:SetContent(getFruitStock()) end)
        end)
    end
end)

pcall(function()
    pcall(function() stockParagraph:SetContent(getFruitStock()) end)
end)


do
    Tabs.Raids:AddToggle("Raids_AutoRandomFruit", {
    Title =  "Auto Random Fruit",
    Description =  "Tự động mua trái ngẫu nhiên",
    Default =  false,
    Callback =  function(Value)
  _G.Random_Auto = Value
end
})
end
spawn(function()
  while wait(Sec) do
   	pcall(function()
      if _G.Random_Auto then replicated.Remotes.CommF_:InvokeServer("Cousin","Buy") end 
    end)
  end
end)
do
    Tabs.Raids:AddToggle("Raids_AutoDropFruit", {
    Title =  "Auto Drop Fruit",
    Description =  "Tự động thả trái",
    Default =  false,
    Callback =  function(Value)
  _G.DropFruit = Value
end
})
end
spawn(function()
  while wait(Sec) do
    if _G.DropFruit then
      pcall(function() DropFruits() end)
    end
  end
end)
do
    Tabs.Raids:AddToggle("Raids_AutoStoreFruit", {
    Title =  "Auto Store Fruit",
    Description =  "Tự động cất trái vào kho",
    Default =  false,
    Callback =  function(Value)
  _G.StoreF = Value
end
})
end
spawn(function()
  while wait(Sec) do
    if _G.StoreF then
      pcall(function() UpdStFruit() end)
    end
  end
end)
-- [ĐÃ XOÁ] Toggle "Raids_AutoTweentoFruit" (bản cũ, đơn giản) — trùng
-- Title "Auto Tween to Fruit" và trùng biến _G.TwFruits với toggle
-- "Race_AutoTweenToWildFruit" (Tabs.Race) đang giữ lại, vốn có tạm
-- dừng farm + snapshot/khôi phục + dùng _FindNearestWildFruit()
-- chính xác hơn string.find(Name, "Fruit"). Giữ 1 bản duy nhất để
-- 2 vòng lặp nền không còn tranh chấp lệnh tp trên cùng 1 biến.
do
    Tabs.Raids:AddToggle("Raids_AutoCollectFruit", {
    Title =  "Auto Collect Fruit",
    Description =  "Tự động nhặt trái",
    Default =  false,
    Callback =  function(Value)
  _G.InstanceF = Value
end
})
end
spawn(function()
  while wait(Sec) do
    if _G.InstanceF then
      pcall(function() collectFruits(_G.InstanceF) end)
    end
  end
end)

do
    Tabs.Raids:AddDropdown("Raids_SelectFruitShop", {
    Title =  "Select Fruit Shop",
    Description =  "Chọn trái trong shop",
    Values =  {
        "Rocket-Rocket", "Spin-Spin", "Blade-Blade", "Spring-Spring",
        "Bomb-Bomb", "Smoke-Smoke", "Spike-Spike", "Flame-Flame",
        "Ice-Ice", "Sand-Sand", "Dark-Dark", "Eagle-Eagle",
        "Diamond-Diamond", "Light-Light", "Rubber-Rubber", "Ghost-Ghost",
        "Magma-Magma", "Quake-Quake", "Buddha-Buddha", "Love-Love",
        "Creation-Creation", "Spider-Spider", "Sound-Sound", "Phoenix-Phoenix",
        "Portal-Portal", "Lightning-Lightning", "Pain-Pain", "Blizzard-Blizzard",
        "Gravity-Gravity", "T-Rex-T-Rex", "Mammoth-Mammoth", "Dough-Dough",
        "Shadow-Shadow", "Venom-Venom", "Gas-Gas", "Control-Control",
        "Spirit-Spirit", "Leopard-Leopard", "Yeti-Yeti", "Kitsune-Kitsune",
        "Dragon-Dragon"
    },
    Callback =  function(Value)
        getgenv().SelectFruit = Value
    end
,
    Multi = false
})
end
do
    Tabs.Raids:AddToggle("Raids_AutoBuyFruitShop", {
    Title =  "Auto Buy Fruit Shop",
    Description =  "Tự động mua trái trong shop",
    Default =  false,
    Callback =  function(Value)
        getgenv().AutoBuyFruitSniper = Value
    end

})
end
spawn(function()
    pcall(function()
        while wait() do
            if getgenv().AutoBuyFruitSniper then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PurchaseRawFruit", getgenv().SelectFruit)
            end
        end
    end)
end)

-- ============================================================
-- GET LOW BELI FRUIT (BUTTON, không phải toggle) — logic + danh
-- sách trái từ file bf, bấm 1 lần chạy 1 lượt rồi dừng
-- ============================================================
do
    Tabs.Raids:AddButton({
        Title = "Get Low Beli Fruit",
        Description = "Bấm 1 lần: thử lấy tất cả các trái giá rẻ (chạy 1 lượt rồi dừng)",
        Callback = function()
            task.spawn(function()
                local lowBeliFruits = {
                    "Rocket-Rocket", "Spin-Spin", "Chop-Chop", "Spring-Spring",
                    "Bomb-Bomb", "Smoke-Smoke", "Spike-Spike", "Flame-Flame",
                    "Falcon-Falcon", "Ice-Ice", "Sand-Sand", "Dark-Dark",
                    "Ghost-Ghost", "Diamond-Diamond", "Light-Light",
                    "Rubber-Rubber", "Creation-Creation"
                }
                for _, fruitName in ipairs(lowBeliFruits) do
                    pcall(function()
                        replicated.Remotes.CommF_:InvokeServer("LoadFruit", fruitName)
                    end)
                    task.wait(0.15)
                end
                pcall(function()
                    Fluent:Notify({Title = "Get Low Beli Fruit", Content = "Đã chạy xong 1 lượt danh sách trái giá rẻ.", Duration = 3})
                end)
            end)
        end
    })
end

-- ============================================================
-- DUNGEON SYSTEM (Moonlight + T-Rex Hub style)
-- ============================================================
local DUNGEON_PLACE_ID = 73902483975735
local DungeonIgnoreMobs = {
    "DungeonAlly", "AllyMob", "SupportMob", "FriendlyMob",
    "GuardianMob", "ProtectorMob", "HelperMob", "EscortMob",
    "DefenderMob", "AssistMob", "Little_Boy's", "Friendo", "Shadow",
}
local DUNGEON_CARDS = {
    "Lifesteal", "All Cooldowns", "HYPER!", "Fruit M1 Speed",
    "Armor", "Sniper", "Overflow", "Gun",
    "Melee", "Fruit", "Defense", "Fortress",
}
_G.SelectedCards = _G.SelectedCards or {}
_G.WeaponType_Dungeon = _G.WeaponType_Dungeon or "Melee"

local dungeonTweenObj
local dungeonWaitingForSpawn = false
local dungeonMustTouchTeleport = true
local dungeonCombatActive = false

local function inDungeonPlace()
    return game.PlaceId == DUNGEON_PLACE_ID
end

local function getDungeonEnemyFolder()
    return workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("Characters")
end

local function isDungeonIgnored(target)
    local name = target and target.Name:lower() or ""
    local hum = target and target:FindFirstChildOfClass("Humanoid")
    local dn = hum and tostring(hum.DisplayName):lower() or ""
    for _, ig in ipairs(DungeonIgnoreMobs) do
        local l = ig:lower()
        if name:find(l, 1, true) or dn:find(l, 1, true) then return true end
    end
    return false
end

local function getDungeonNearestMob()
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local folder = getDungeonEnemyFolder()
    if not (root and folder) then return nil end
    local target, shortest
    for _, enemy in ipairs(folder:GetChildren()) do
        local h = enemy:FindFirstChildOfClass("Humanoid")
        local er = enemy:FindFirstChild("HumanoidRootPart")
        if enemy ~= char and h and h.Health > 0 and er and not isDungeonIgnored(enemy) then
            local d = (root.Position - er.Position).Magnitude
            if not shortest or d < shortest then target, shortest = enemy, d end
        end
    end
    return target
end

local function getDungeonExitTeleporter()
    local map = workspace:FindFirstChild("Map")
    local dungeon = map and map:FindFirstChild("Dungeon")
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (dungeon and root) then return nil end
    local nearest, shortest
    for _, room in ipairs(dungeon:GetChildren()) do
        local exit = room:FindFirstChild("ExitTeleporter")
        local er = exit and exit:FindFirstChild("Root")
        if er and er:IsA("BasePart") then
            local d = (root.Position - er.Position).Magnitude
            if not shortest or d < shortest then nearest, shortest = er.CFrame * CFrame.new(0, 5, 0), d end
        end
    end
    return nearest
end

local function moveDungeonTo(cf)
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local d = (root.Position - cf.Position).Magnitude
    if d <= 5 then
        if dungeonTweenObj then pcall(function() dungeonTweenObj:Cancel() end) end
        root.CFrame = cf; return
    end
    if dungeonTweenObj and dungeonTweenObj.PlaybackState == Enum.PlaybackState.Playing then return end
    if dungeonTweenObj then pcall(function() dungeonTweenObj:Cancel() end) end
    dungeonTweenObj = TW:Create(root, TweenInfo.new(d / 300, Enum.EasingStyle.Linear), {CFrame = cf})
    dungeonTweenObj:Play()
end

local function equipDungeonWeapon()
    local char = plr.Character
    local h = char and char:FindFirstChildOfClass("Humanoid")
    if not (char and h and h.Health > 0) then return end
    local eq = char:FindFirstChildOfClass("Tool")
    if eq and eq.ToolTip == _G.WeaponType_Dungeon then return end
    for _, tool in ipairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == _G.WeaponType_Dungeon then h:EquipTool(tool); return end
    end
end

-- DUNGEON UI
Tabs.Raids:AddParagraph({Title = "Dungeon Farm", Content = "Moonlight System"})
local DungeonStatusP = Tabs.Raids:AddParagraph({Title = "Dungeon Status", Content = inDungeonPlace() and "Detected" or "Need PlaceId " .. DUNGEON_PLACE_ID})

Tabs.Raids:AddToggle("Dungeon_AutoFarm", {
    Title = "Auto Farm Dungeon",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm_DungeonFix = Value
        _G.AutoFarmDungeon = Value
        dungeonWaitingForSpawn = false
        dungeonMustTouchTeleport = true
        if not Value then dungeonCombatActive = false; if dungeonTweenObj then pcall(function() dungeonTweenObj:Cancel() end) end end
    end
})

Tabs.Raids:AddToggle("Dungeon_AutoSelectCard", {
    Title = "Auto Select Card",
    Default = false,
    Callback = function(Value) _G.AutoSelectCard = Value end
})

Tabs.Raids:AddParagraph({Title = "Card Priority", Content = "Chon card muon pick"})
for _, cardName in ipairs(DUNGEON_CARDS) do
    _G.SelectedCards[cardName] = _G.SelectedCards[cardName] or false
    Tabs.Raids:AddToggle("DungeonCard_" .. cardName, {
        Title = cardName,
        Default = false,
        Callback = function(Value) _G.SelectedCards[cardName] = Value end
    })
end

Tabs.Raids:AddSection("Dungeon Settings")
Tabs.Raids:AddDropdown("Dungeon_WeaponType", {
    Title = "Select Weapon",
    Values = {"Melee", "Sword", "Blox Fruit", "Gun"},
    Default = "Melee",
    Callback = function(Value) _G.WeaponType_Dungeon = Value end
})
Tabs.Raids:AddToggle("Dungeon_FastAttack", {
    Title = "Auto Attack",
    Default = false,
    Callback = function(Value) _G.FastAttack_Dungeon = Value end
})
Tabs.Raids:AddToggle("Dungeon_AutoBuso", {
    Title = "Auto Buso",
    Default = false,
    Callback = function(Value) _G.AutoBuso_Dungeon = Value end
})

-- Dungeon Movement Loop
RunSer.Stepped:Connect(function()
    if not _G.AutoFarm_DungeonFix or not inDungeonPlace() then dungeonCombatActive = false; return end
    local char = plr.Character
    local h = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (char and h and h.Health > 0 and root) then dungeonCombatActive = false; return end
    for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    root.AssemblyLinearVelocity = Vector3.zero
    local target = getDungeonNearestMob()
    local exitFrame = getDungeonExitTeleporter()
    if dungeonMustTouchTeleport and exitFrame then
        dungeonCombatActive = false; moveDungeonTo(exitFrame)
        if (root.Position - exitFrame.Position).Magnitude < 8 then
            if dungeonTweenObj then pcall(function() dungeonTweenObj:Cancel() end) end
            root.CFrame = exitFrame; dungeonMustTouchTeleport = false
        end; return
    end
    if target then
        dungeonWaitingForSpawn = false; dungeonCombatActive = true; equipDungeonWeapon()
        local tr = target:FindFirstChild("HumanoidRootPart")
        if tr then
            local tp = tr.CFrame * CFrame.new(0, 15, 0)
            if (root.Position - tp.Position).Magnitude > 10 then moveDungeonTo(tp)
            else
                if dungeonTweenObj then pcall(function() dungeonTweenObj:Cancel() end) end
                root.CFrame = CFrame.new(tp.Position, tr.Position)
            end
        end
    else
        dungeonCombatActive = false
        if not dungeonWaitingForSpawn and exitFrame then
            moveDungeonTo(exitFrame)
            if (root.Position - exitFrame.Position).Magnitude < 8 then
                if dungeonTweenObj then pcall(function() dungeonTweenObj:Cancel() end) end
                root.CFrame = exitFrame; dungeonWaitingForSpawn = true
            end
        elseif not exitFrame then
            if dungeonTweenObj then pcall(function() dungeonTweenObj:Cancel() end) end
        end
    end
end)

-- Dungeon Status Loop
task.spawn(function()
    while task.wait(0.5) do
        if not inDungeonPlace() then DungeonStatusP:SetContent("Need PlaceId " .. DUNGEON_PLACE_ID); continue end
        local state = _G.AutoFarm_DungeonFix and (dungeonMustTouchTeleport and "Moving to Exit" or dungeonWaitingForSpawn and "Waiting spawn" or dungeonCombatActive and "Farming" or "Active") or "Detected"
        DungeonStatusP:SetContent(state)
        pcall(function()
            local char = plr.Character
            if _G.AutoBuso_Dungeon and char and not char:FindFirstChild("HasBuso") then replicated.Remotes.CommF_:InvokeServer("Buso") end
        end)
    end
end)

-- ============================================================
-- TRADITIONAL RAID (from T-Rex Hub style)
-- ============================================================
Tabs.Raids:AddSection("Raid Settings")
DungeonTables = {"Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Human: Buddha","Sand","Bird: Phoenix","Dough"}
Tabs.Raids:AddDropdown("Raids_SelectChip", {
    Title = "Select Chip",
    Values = DungeonTables,
    Multi = false,
    Default = 2,
    Callback = function(Value) _G.SelectChip = Value end
})
Tabs.Raids:AddToggle("Raids_AutoSelectDungeonChip", {
    Title = "Auto Select Dungeon Chip",
    Default = false,
    Callback = function(Value) _G.AutoSelectDungeon = Value end
})
Tabs.Raids:AddButton({
    Title = "Buy Dungeon Chips [Beli]",
    Callback = function()
        if not GetBP("Special Microchip") then replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip) end
    end
})
Tabs.Raids:AddButton({
    Title = "Buy Dungeon Chips [Devil Fruit]",
    Callback = function()
        if GetBP("Special Microchip") then return end
        for i, v in next, replicated:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits") do
            if v.Price <= 490000 then
                for _, dv in pairs(DungeonTables) do
                    if not GetBP("Special Microchip") then
                        replicated.Remotes.CommF_:InvokeServer("LoadFruit", tostring(v.Name))
                        replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
                    end
                end
            end
        end
    end
})
Tabs.Raids:AddToggle("Raids_AutoStartRaid", {
    Title = "Auto Start Raid",
    Default = false,
    Callback = function(Value) _G.Auto_StartRaid = Value end
})
task.spawn(function()
    while task.wait(Sec) do
        if not _G.Auto_StartRaid then continue end
        pcall(function()
            local gui = plr:FindFirstChild("PlayerGui")
            local main = gui and gui:FindFirstChild("Main")
            local top = main and main:FindFirstChild("TopHUDList")
            if not top or top.RaidTimer.Visible then return end
            if not GetBP("Special Microchip") then return end
            if World2 then
                local btn = workspace.Map.CircleIsland.RaidSummon2.Button.Main
                if btn and btn:FindFirstChild("ClickDetector") then fireclickdetector(btn.ClickDetector) end
            elseif World3 then
                local btn = workspace.Map["Boat Castle"].RaidSummon2.Button.Main
                if btn and btn:FindFirstChild("ClickDetector") then fireclickdetector(btn.ClickDetector) end
            end
        end)
    end
end)

-- Auto Raid + Next Island (Moonlight logic)
Tabs.Raids:AddToggle("Raids_AutoRaidNextIsland", {
    Title = "Auto Raid + Next Island",
    Default = false,
    Callback = function(Value) _G.Raiding = Value end
})
task.spawn(function()
    local islands = {"Island 1", "Island 2", "Island 3", "Island 4", "Island 5"}
    local currentIsland
    while task.wait(0.2) do
        if not _G.Raiding then continue end
        pcall(function()
            local gui = plr:FindFirstChild("PlayerGui")
            local main = gui and gui:FindFirstChild("Main")
            local top = main and main:FindFirstChild("TopHUDList")
            if not top or not top.RaidTimer.Visible then return end
            local char = plr.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local locs = workspace["_WorldOrigin"].Locations
            local closestDist = math.huge
            for _, name in ipairs(islands) do
                local loc = locs:FindFirstChild(name)
                if loc and loc:IsA("BasePart") then
                    local d = (root.Position - loc.Position).Magnitude
                    if d < closestDist then closestDist = d; currentIsland = name end
                end
            end
            local islandPos = currentIsland and locs:FindFirstChild(currentIsland)
            if not islandPos then return end
            local target, targetDist
            for _, mob in ipairs(workspace.Enemies:GetChildren()) do
                local mh = mob:FindFirstChildOfClass("Humanoid")
                local mr = mob:FindFirstChild("HumanoidRootPart")
                if mh and mr and mh.Health > 0 and (mr.Position - islandPos.Position).Magnitude < 450 then
                    local d = (mr.Position - root.Position).Magnitude
                    if not targetDist or d < targetDist then target, targetDist = mob, d end
                end
            end
            if target then
                Attack.Kill(target, true)
            else
                local idx = table.find(islands, currentIsland)
                local nxt = idx and islands[idx + 1] and locs:FindFirstChild(islands[idx + 1])
                if nxt and _tp then _tp(nxt.CFrame * CFrame.new(0, 45, 120)) end
            end
        end)
    end
end)

-- Kill Aura (standalone toggle from T-Rex Hub)
Tabs.Raids:AddToggle("Raids_KillAura", {
    Title = "Kill Aura",
    Default = false,
    Callback = function(Value) _G.KillH = Value end
})
task.spawn(function()
    while task.wait(0.1) do
        if _G.KillH then
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    pcall(function()
                        repeat task.wait(0.1)
                            sethiddenproperty(plr, "SimulationRadius", math.huge)
                            v:BreakJoints()
                            v.Humanoid.Health = 0
                            v.HumanoidRootPart.CanCollide = false
                        until not _G.KillH or not v.Parent or v.Humanoid.Health <= 0
                    end)
                end
            end
        end
    end
end)

Tabs.Raids:AddToggle("Raids_AutoAwakening", {
    Title = "Auto Awakening",
    Default = false,
    Callback = function(Value) _G.Auto_Awakener = Value end
})
task.spawn(function()
    while task.wait(Sec) do
        if not _G.Auto_Awakener then continue end
        pcall(function()
            replicated.Remotes.CommF_:InvokeServer("Awakener","Check")
            replicated.Remotes.CommF_:InvokeServer("Awakener","Awaken")
        end)
    end
end)

Tabs.Raids:AddToggle("Raids_AutoTeleportToLab", {
    Title = "Auto Teleport To Lab",
    Default = false,
    Callback = function(Value) _G.TpLab = Value end
})
task.spawn(function()
    while task.wait(0.5) do
        if _G.TpLab then
            pcall(function()
                if World2 then _tp(CFrame.new(-6438.73535, 250.645355, -4501.50684))
                elseif World3 then _tp(CFrame.new(-5017.40869, 314.844055, -2823.0127)) end
            end)
        end
    end
end)

-- Items Law/Order Sword
Tabs.Raids:AddSection("Items Law/Order Sword")
Tabs.Combat:AddSection("Combat / AimBot")
local __indexPlayer = Tabs.Combat:AddParagraph({Title = "All Players On Server", Content = ""})

spawn(function()
    while wait(Sec) do
        pcall(function()
            local playerCount = #game:GetService("Players"):GetPlayers()
            if playerCount == 12 then
                pcall(function() __indexPlayer:SetContent("All Players : " .. playerCount .. " / 12 [Max]") end)
            else
                pcall(function() __indexPlayer:SetContent("All Players : " .. playerCount .. " / 12") end)
            end
        end)
    end
end)

local __AimBotTurn = Tabs.Combat:AddParagraph({Title = "Aimbot Status", Content = ""})

Checking_AimStatus = function()
    if _G.AimCam then
        return "Aimbot Camera"
    elseif _G.AimbotGun then
        return "Aimbot Guns"
    else
        return ""
    end
end

spawn(function()
    while wait(0.2) do
        pcall(function()
            if _G.AimMethod then
                if (_G.AimCam or _G.AimbotGun) then
                    pcall(function() __AimBotTurn:SetContent("Aimbot - " .. Checking_AimStatus() .. " : True") end)
                else
                    pcall(function() __AimBotTurn:SetContent("Aimbot - Skills : True") end)
                end
            else
                pcall(function() __AimBotTurn:SetContent("Aimbot - Skills : False") end)
            end
        end)
    end
end)


local PlrList = {}   
for _, v in pairs(game:GetService("Players"):GetChildren()) do
    table.insert(PlrList, v.Name)
end

do
    Tabs.Combat:AddDropdown("Combat_SelectPlayers", {
    Title =  "Select Players",
    Description =  "Chọn người chơi",
    Values =  PlrList,
    Callback =  function(Value)
        _G.PlayersList = Value
    end
,
    Multi = false
})
end

do
    Tabs.Combat:AddToggle("Combat_TeleportToSelectPlayers", {
    Title =  "Teleport To Select Players",
    Description =  "Dịch chuyển tới người chơi đã chọn",
    Default =  false,
    Callback =  function(Value)
        _G.TpPly = Value
        spawn(function()
            pcall(function()
                while _G.TpPly do
                    wait()
                    _tp(game:GetService("Players")[_G.PlayersList].Character.HumanoidRootPart.CFrame)
                end
            end)
        end)
    end

})
end

do
    Tabs.Combat:AddToggle("Combat_SpectateSelectPlayers", {
    Title =  "Spectate Select Players",
    Description =  "Xem người chơi đã chọn",
    Default =  false,
    Callback =  function(Value)
        SpectatePlys = Value
        spawn(function()
            repeat
                task.wait(0.1)
                if game:GetService("Players"):FindFirstChild(_G.PlayersList) then
                    workspace.Camera.CameraSubject = game:GetService("Players"):FindFirstChild(_G.PlayersList).Character.Humanoid
                end
            until not SpectatePlys
            workspace.Camera.CameraSubject = plr.Character.Humanoid
        end)
    end

})
end

do
    Tabs.Combat:AddDropdown("Combat_SelectAimMethod", {
    Title =  "Select Aim Method",
    Description =  "Chọn kiểu ngắm",
    Values =  {"Aim Player","Nearest Aim"},
    Callback =  function(Value)
        ABmethod = Value
    end
,
    Multi = false
})
end

do
    Tabs.Combat:AddToggle("Combat_AimbotMethodSkills", {
    Title =  "Aimbot Method Skills",
    Description =  "Ngắm bằng skill",
    Default =  false,
    Callback =  function(Value)
        _G.AimMethod = Value
    end

})
end

spawn(function()
    while wait() do
        pcall(function()
            if _G.AimMethod and ABmethod == "Aim Player" then
                local target = Players:FindFirstChild(getgenv().PlayersList)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    if target.Team ~= plr.Team then
                        MousePos = target.Character.HumanoidRootPart.Position
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            if _G.AimMethod and ABmethod == "Nearest Aim" then
                local MaxDistance = math.huge
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= plr and v.Team ~= plr.Team and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local Distance = (v.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if Distance < MaxDistance then
                            MaxDistance = Distance
                            MousePos = v.Character.HumanoidRootPart.Position
                        end
                    end
                end
            end
        end)
    end
end)

do
    Tabs.Combat:AddToggle("Combat_AimbotCameraClosetPlayers", {
    Title =  "Aimbot Camera Closet Players",
    Description =  "Camera ngắm người gần nhất",
    Default =  false,
    Callback =  function(Value)
        _G.AimCam = Value
    end

})
end

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
                repeat
                    task.wait()
                    camera.CFrame = CFrame.new(camera.CFrame.Position, closestplayer().Character.HumanoidRootPart.Position)
                until _G.AimCam == false or Mag > dist
            end
        end)
    end
end)

Tabs.Combat:AddSection("Quests Players")
do
    Tabs.Combat:AddButton({
    Title =  "Get player quests",
    Description =  "Lấy nhiệm vụ người chơi",
    Callback =  function()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
        end)
    end

})
end

do
    Tabs.Combat:AddToggle("Combat_AutoGetPlayerQuest", {
    Title =  "Auto Get PlayerQuest",
    Description =  "Tự động nhận nhiệm vụ người chơi",
    Default =  false,
    Callback =  function(Value)
        _G.AutoReceivePlayerQuest = Value
    end

})
end


spawn(function()
    while task.wait(1) do
        if _G.AutoReceivePlayerQuest then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
            end)
        end
    end
end)


do
    Tabs.Combat:AddToggle("Combat_AutoKillPlayerQuest", {
    Title =  "Auto Kill Player Quest",
    Description =  "Tự động giết người làm nhiệm vụ",
    Default =  false,
    Callback =  function(Value)
        _G.AutoPlayerHunter = Value
    end

})
end

spawn(function()
    while task.wait() do
        if _G.AutoPlayerHunter then
            if game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                task.wait(0.5)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
            else
                for _, target in pairs(game:GetService("Workspace").Characters:GetChildren()) do
                    if string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, target.Name) then
                        repeat
                            task.wait()
                            if AutoHaki then AutoHaki() end
                            if EquipWeapon then EquipWeapon(_G.SelectWeapon) end
                            Useskill = true
                            
                            _tp(target.HumanoidRootPart.CFrame * CFrame.new(1, 7, 3))
                            
                            target.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                            
                        until _G.AutoPlayerHunter == false or target.Humanoid.Health <= 0
                        
                        Useskill = false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                end
            end
        end
    end
end)





do
    Tabs.Combat:AddToggle("Combat_AutoEnablePvP", {
    Title =  "Auto Enable PvP",
    Description =  "Tự động bật PVP",
    Default =  false,
    Callback =  function(Value)
        _G.AutoPvP = Value
    end

})
end


spawn(function()
    while task.wait(0.5) do
        if _G.AutoPvP then
            local playerGui = game.Players.LocalPlayer.PlayerGui
            if playerGui and playerGui.Main and playerGui.Main:FindFirstChild("PvpDisabled") then
                if playerGui.Main.PvpDisabled.Visible then
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
                    end)
                end
            end
        end
    end
end)

do
    Tabs.Combat:AddToggle("Combat_AutoSafeMode", {
    Title =  "Auto Safe Mode",
    Description =  "Tự động bật chế độ an toàn",
    Default =  false,
    Callback =  function(Value)
        _G.SafeMode = Value
    end

})
end

spawn(function()
    while task.wait(0.1) do
        if _G.SafeMode then
            local char = game.Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                local targetPos = hrp.CFrame * CFrame.new(0, 1000, 0)
                _tp(targetPos) 
            end
        end
    end
end)

Tabs.Combat:AddSection("LocalPlayer Settings")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local flying = false
local flySpeed = 50
local flyConnection
local bv, bg

local function toggleFly(value)
    flying = value
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    
    if not humanoid or not rootPart then return end

    if flying then
        -- 1. CƠ CHẾ CHỐNG RƠI: Bật BodyVelocity ép tốc độ rơi về 0 tuyệt đối (Anti-Gravity)
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = rootPart

        -- 2. ĐỊNH HƯỚNG CAMERA: Luôn giữ nhân vật hướng mặt theo Camera
        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 9e5
        bg.CFrame = rootPart.CFrame
        bg.Parent = rootPart

        -- 3. XUYÊN TƯỜNG: Tắt va chạm như code cũ của ông
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end

        -- 4. BÊ NGUYÊN LÕI "TRANSLATEBY" GỐC CỦA ÔNG VÀO (TÍCH HỢP 3D)
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flying or not player.Character then return end
            
            local cam = workspace.CurrentCamera
            bg.CFrame = cam.CFrame
            
            local moveDir = humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                -- Ép hướng Joystick ngang (2D) thành hướng 3D của Camera
                local flatLook = cam.CFrame.LookVector * Vector3.new(1, 0, 1)
                flatLook = flatLook.Magnitude > 0 and flatLook.Unit or Vector3.new(0, 0, -1)
                
                local flatRight = cam.CFrame.RightVector * Vector3.new(1, 0, 1)
                flatRight = flatRight.Magnitude > 0 and flatRight.Unit or Vector3.new(1, 0, 0)

                local forwardInput = flatLook:Dot(moveDir)
                local rightInput = flatRight:Dot(moveDir)

                -- Tọa độ bay tổng hợp (Nhìn lên bay lên, nhìn xuống bay xuống)
                local flyDir = (cam.CFrame.LookVector * forwardInput) + (cam.CFrame.RightVector * rightInput)
                
                if flyDir.Magnitude > 0 then
                    -- SỬ DỤNG LÕI TRANSLATEBY SIÊU TỐC
                    -- (Chia 10 để tốc độ trượt bằng với mức speeds = 1, 2, 3... trong code gốc của ông)
                    character:TranslateBy(flyDir.Unit * (flySpeed / 10))
                end
            end
        end)
    else
        -- TẮT BAY VÀ XÓA RÁC
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
        
        -- Phục hồi va chạm bình thường
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function updateFlySpeed(value)
    flySpeed = value
end

-- Vá lỗi thi reset nhân vật
player.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    if flying then
        toggleFly(false)
        task.wait(0.1)
        toggleFly(true)
    end
end)

-- UI MENU CỦA ÔNG
do
    Tabs.Combat:AddToggle("Combat_EnableFly", {
    Title =  "Enable Fly",
    Description =  "Bật bay",
    Default =  false,
    Callback =  function(Value)
        toggleFly(Value)
    end

})
end

do
    Tabs.Combat:AddSlider("Combat_SpeedFlyMode", {
    Title =  "Speed Fly Mode",
    Description =  "Tốc độ bay",
    Min =  10,
    Max =  200,
    Default =  50,
    Callback =  function(Value)
        updateFlySpeed(Value)
    end
,
    Rounding = 0
})
end

do
    Tabs.Combat:AddToggle("Combat_DashNoCooldown", {
    Title =  "Dash No Cooldown",
    Description =  "Dash không hồi chiêu",
    Default =  false,
    Callback =  function(Value)
        getgenv().DodgeNoCD = Value
    end

})
end
local function NoCooldown()
    local dodgeScript = game.Players.LocalPlayer.Character:WaitForChild("Dodge")
    for i, v in next, getgc() do
        if typeof(v) == "function" then
            local funcEnv = getfenv(v)
            if funcEnv.script == dodgeScript then
                for i2, v2 in next, getupvalues(v) do
                    if tostring(v2) == "0.4" then
                        setupvalue(v, i2, 0)
                    end
                end
            end
        end
    end
end

do
    Tabs.Combat:AddToggle("Combat_MinkV3Infinity", {
    Title =  "Instance Mink V3 [ INF ]",
    Description =  "Bật để Mink V3 vô hạn",
    Default =  false,
    Callback =  function(Value)
        _G.InfMinkV3 = Value
        task.spawn(function()
            while task.wait(0.2) do
                pcall(function()
                    if _G.InfMinkV3 then
                        if not plr.Character.HumanoidRootPart:FindFirstChild("Agility") then
                            local agility = replicated.FX["Agility"]:Clone()
                            agility.Name = "Agility"
                            agility.Parent = plr.Character.HumanoidRootPart
                        end
                    else
                        local ag = plr.Character.HumanoidRootPart:FindFirstChild("Agility")
                        if ag then ag:Destroy() end
                    end
                end)
            end
        end)
    end
})
end

do
    Tabs.Combat:AddToggle("Combat_EnergyInfinity", {
    Title =  "Instance Energy [ INF ]",
    Description =  "Bật để năng lượng vô hạn",
    Default =  false,
    Callback =  function(Value)
        _G.InfEnergy = Value
        if Value then getInfinity_Ability("Energy", _G.InfEnergy) end
    end
})
end

do
    Tabs.Combat:AddToggle("Combat_SoruInfinity", {
    Title =  "Instance Soru [ INF ]",
    Description =  "Bật để Soru vô hạn",
    Default =  false,
    Callback =  function(Value)
        _G.InfSoru = Value
        if Value then getInfinity_Ability("Soru", _G.InfSoru) end
    end
})
end

do
    Tabs.Combat:AddToggle("Combat_ObservationRangeInfinity", {
    Title =  "Instance Observation Range [ INF ]",
    Description =  "Bật để phạm vi quan sát vô hạn",
    Default =  false,
    Callback =  function(Value)
        _G.InfiniteObRange = Value
        if Value then getInfinity_Ability("Observation", _G.InfiniteObRange) end
    end
})
end

do
    Tabs.Combat:AddToggle("Combat_IgnoreSameTeams", {
    Title =  "Ignore Same Teams",
    Description =  "Bỏ qua cùng team",
    Default =  false,
    Callback =  function(Value)
        _G.NoAimTeam = Value
    end

})
end

do
    Tabs.Combat:AddToggle("Combat_AcceptAllies", {
    Title =  "Accept Allies",
    Description =  "Chấp nhận đồng minh",
    Default =  false,
    Callback =  function(Value)
        _G.AcceptAlly = Value
    end

})
end

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


Tabs.Travel:AddSection("Travel - Worlds")
do
    Tabs.Travel:AddButton({
    Title =  "Travel East Blue (World 1)",
    Description =  "Đi tới East Blue (Thế giới 1)",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("TravelMain")
end
})
end
do
    Tabs.Travel:AddButton({
    Title =  "Travel Dressrosa (World 2)",
    Description =  "Đi tới Dressrosa (Thế giới 2)",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
end
})
end
do
    Tabs.Travel:AddButton({
    Title =  "Travel Zou (World 3)",
    Description =  "Đi tới Zou (Thế giới 3)",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("TravelZou")
end
})
end
Tabs.Travel:AddSection("Travel - Island")
Location = {}
for i,v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do  
  table.insert(Location ,v.Name)
end
do
    Tabs.Travel:AddDropdown("Travel_SelectTravelling", {
    Title =  "Select Travelling",
    Description =  "Chọn chỗ muốn đi",
    Values =  Location,
    Callback =  function(Value)
  _G.Island = Value
end,
    Multi = false
})
end
do
    Tabs.Travel:AddToggle("Travel_AutoTravel", {
    Title =  "Auto Travel",
    Description =  "Tự động đi tới chỗ đã chọn",
    Default =  false,
    Callback =  function(Value)
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
end

})
end

Tabs.Travel:AddSection("Travel - Portal")
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

do
    Tabs.Travel:AddDropdown("Travel_SelectPortal", {
    Title =  "Select Portal",
    Description =  "Chọn cổng muốn đi",
    Values =  Location_Portal,
    Callback =  function(Value)
  _G.Island_PT = Value
end,
    Multi = false
})
end
do
    Tabs.Travel:AddButton({
    Title =  "requestEntrance",
    Description =  "Yêu cầu vào cổng",
    Callback =  function()
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
end
})
end

Tabs.Travel:AddSection("Travel - NPCs")
for _, v in pairs(replicated.NPCs:GetChildren()) do table.insert(NPCList, v.Name)end
do
    Tabs.Travel:AddDropdown("Travel_SelectNPCs", {
    Title =  "Select NPCs",
    Description =  "Chọn NPC muốn tới",
    Values =  NPCList,
    Callback =  function(Value)
  NPClist = Value
end,
    Multi = false
})
end
do
    Tabs.Travel:AddToggle("Travel_AutoTweentoNPC", {
    Title =  "Auto Tween to NPC",
    Description =  "Tự động bay tới NPC đã chọn",
    Default =  false,
    Callback =  function(Value)
  _G.TPNpc = Value
end
})
end
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

Tabs.Shop:AddSection("Shop Options")
do
    Tabs.Shop:AddButton({
    Title =  "Buy Buso",
    Description =  "Mua Haki vũ trang",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyHaki","Buso")
end
})
end
do
    Tabs.Shop:AddButton({
    Title =  "Buy Geppo",
    Description =  "Mua Geppo (nhảy đôi)",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyHaki","Geppo")
end
})
end
do
    Tabs.Shop:AddButton({
    Title =  "Buy Soru",
    Description =  "Mua Soru (lướt)",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyHaki","Soru")
end
})
end
do
    Tabs.Shop:AddButton({
    Title =  "Buy Ken",
    Description =  "Mua Ken (Haki quan sát)",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("KenTalk","Buy")
end
})
end
Tabs.Shop:AddSection("Fighting - Styler")
local MeleeCoords = {
    ["Black Leg"] = {
        Key = "BuyBlackLeg",
        Pos = World1 and CFrame.new(-985, 13, 3988) or World2 and CFrame.new(-4753, 35, -4850) or World3 and CFrame.new(-5045, 371, -3181) or nil
    },
    ["Electro"] = {
        Key = "BuyElectro",
        Pos = World1 and CFrame.new(-5384, 13, -2148) or World2 and CFrame.new(-4867, 35, -4766) or World3 and CFrame.new(-4995, 314, -3203) or nil
    },
    ["Fishman Karate"] = {
        Key = "BuyFishmanKarate",
        Pos = World1 and CFrame.new(61585, 18, 987) or World2 and CFrame.new(-4958, 35, -4668) or World3 and CFrame.new(-5023, 371, -3190) or nil
    },
    ["Dragon Claw"] = {
        Key = "BuyDragonClaw",
        Pos = World2 and CFrame.new(701, 187, 655) or World3 and CFrame.new(-4981, 371, -3207) or nil
    },
    ["Superhuman"] = {
        Key = "BuySuperhuman",
        Pos = World2 and CFrame.new(1374, 247, -5192) or World3 and CFrame.new(-5004, 371, -3198) or nil
    },
    ["Death Step"] = {
        Key = "BuyDeathStep",
        Pos = World2 and CFrame.new(6357, 296, -6762) or World3 and CFrame.new(-4999, 314, -3221) or nil
    },
    ["Sharkman Karate"] = {
        Key = "BuySharkmanKarate",
        Pos = World2 and CFrame.new(-2602, 238, -10316) or World3 and CFrame.new(-4972, 314, -3222) or nil
    },
    ["Dragon Talon"] = {
        Key = "BuyDragonTalon",
        Pos = World3 and CFrame.new(5661, 1211, 865) or nil
    },
    ["Electric Claw"] = {
        Key = "BuyElectricClaw",
        Pos = World3 and CFrame.new(-10371, 331, -10131) or nil
    },
    ["Godhuman"] = {
        Key = "BuyGodhuman",
        Pos = World3 and CFrame.new(-13776, 334, -9879) or nil
    },
    ["Sanguine Art"] = {
        Key = "BuySanguineArt",
        Pos = World3 and CFrame.new(-16353, 160, 99) or nil
    }
}

local SelectedMelee = "Black Leg"
_G.AutoBuyMelee = _G.AutoBuyMelee or false

local function GetAvailableMeleeOptions()
    local list = {}
    for name, data in pairs(MeleeCoords) do
        if data.Pos ~= nil then
            table.insert(list, name)
        end
    end
    table.sort(list)
    if #list == 0 then return {"Không có võ ở Sea này"} end
    return list
end

do
    Tabs.Shop:AddDropdown("Shop_SelecttheMeleeyouwanttobuy", {
    Title =  "Select the Melee you want to buy.",
    Description =  "Chọn loại võ muốn mua",
    Values =  GetAvailableMeleeOptions(),
    Default =  SelectedMelee,
    Callback =  function(Value)
        if Value ~= "Không có võ ở Sea này" then
            SelectedMelee = Value
        end
    end
,
    Multi = false
})
end

do
    Tabs.Shop:AddToggle("Shop_AutoBuyMelee", {
    Title =  "Auto Buy Melee",
    Description =  "Tự động mua võ đã chọn",
    Default =  _G.AutoBuyMelee,
    Callback =  function(Value)
        _G.AutoBuyMelee = Value
        
        task.spawn(function()
            local tweenActive = false
            local currentTarget = nil
            
            while _G.AutoBuyMelee do
                task.wait(0.1)
                local ok = pcall(function()
                    if not _G.AutoBuyMelee then return end
                    
                    local data = MeleeCoords[SelectedMelee]
                    if not data or not data.Pos then
                        _G.AutoBuyMelee = false
                        return
                    end

                    local char = plr.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                    local hrp = char.HumanoidRootPart
                    local targetCF = data.Pos * CFrame.new(0, 2, 2)
                    local dist = (hrp.Position - targetCF.Position).Magnitude

                    -- NẾU Ở XA -> BAY ĐẾN
                    if dist > 10 then
                        if not tweenActive or currentTarget ~= targetCF then
                            tweenActive = true
                            currentTarget = targetCF
                            shouldTween = true
                            getgenv().OnFarm = true
                            _tp(targetCF)
                        end
                        
                        repeat
                            task.wait(0.1)
                            if not _G.AutoBuyMelee then break end
                            if not char or not char:FindFirstChild("HumanoidRootPart") then break end
                            hrp = char.HumanoidRootPart
                            dist = (hrp.Position - targetCF.Position).Magnitude
                        until dist <= 10 or not _G.AutoBuyMelee or not shouldTween
                        tweenActive = false
                    else
                        -- ĐÃ ĐẾN NƠI -> DỪNG LẠI ĐỂ MUA
                        tweenActive = false
                        currentTarget = nil
                        shouldTween = false
                        getgenv().OnFarm = false
                        task.wait(0.5) -- Đợi nhân vật đứng vững
                        
                        pcall(function()
                            if hrp then
                                hrp.Velocity = Vector3.new(0,0,0)
                                hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                            end
                        end)
                        task.wait(0.3)

                        -- GỌI LỆNH MUA VÀ BẮT LỖI (PCALL)
                        pcall(function()
                            replicated.Remotes.CommF_:InvokeServer(data.Key)
                            task.wait(0.25)
                            replicated.Remotes.CommF_:InvokeServer("BuyItem", data.Key)
                            if data.Key == "BuyDragonClaw" then
                                task.wait(0.25)
                                replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
                            end
                        end)
                        
                        -- Dừng vòng lặp sau khi đã tương tác xong
                        _G.AutoBuyMelee = false 
                    end
                end)
                if not ok then task.wait(0.5) end
            end
            
            -- Cleanup khi tắt
            tweenActive = false
            currentTarget = nil
            shouldTween = false
            getgenv().OnFarm = false
        end)
    end

})
end
Tabs.Shop:AddSection("Accessory")
do
    Tabs.Shop:AddButton({
    Title =  "Buy Tomoe Ring",
    Description =  "Mua vòng Tomoe",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Tomoe Ring")
end
})
end
do
    Tabs.Shop:AddButton({
    Title =  "Buy Black Cape",
    Description =  "Mua áo choàng đen",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Black Cape")
end
})
end
do
    Tabs.Shop:AddButton({
    Title =  "Buy Swordsman Hat",
    Description =  "Mua mũ kiếm sĩ",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Swordsman Hat")
end
})
end
do
    Tabs.Shop:AddButton({
    Title =  "Buy Bizarre Rifle",
    Description =  "Mua súng Bizarre",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("Ectoplasm","Buy", 1)
end
})
end
do
    Tabs.Shop:AddButton({
    Title =  "Buy Ghoul Mask",
    Description =  "Mua mặt nạ Ghoul",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("Ectoplasm","Buy", 2)
end
})
end



Tabs.Shop:AddSection("Weapon World1")
do
    Tabs.Shop:AddButton({
    Title =  "Buy Cutlass",
    Description =  "Mua kiếm Cutlass",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Cutlass")
end
})
end
do
    Tabs.Shop:AddButton({
    Title =  "Buy Katana",
    Description =  "Mua kiếm Katana",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Katana")
end
})
end
do
    Tabs.Shop:AddButton({
    Title =  "Buy Iron Mace",
    Description =  "Mua chùy sắt",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Iron Mace")
end
})
end   
do
    Tabs.Shop:AddButton({
    Title =  "Buy Duel Katana",
    Description =  "Mua song kiếm Katana",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Duel Katana")
end
})
end   
do
    Tabs.Shop:AddButton({
    Title =  "Buy Triple Katana",
    Description =  "Mua 3 kiếm Katana",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Triple Katana")
end
})
end  
do
    Tabs.Shop:AddButton({
    Title =  "Buy Pipe",
    Description =  "Mua gậy Pipe",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Pipe")
end
})
end  
do
    Tabs.Shop:AddButton({
    Title =  "Buy Dual-Headed Blade",
    Description =  "Mua kiếm 2 đầu",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Dual-Headed Blade")
end
})
end   
do
    Tabs.Shop:AddButton({
    Title =  "Buy Bisento",
    Description =  "Mua Bisento",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Bisento")
end
})
end  
do
    Tabs.Shop:AddButton({
    Title =  "Buy Soul Cane",
    Description =  "Mua gậy Soul Cane",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Soul Cane")
end
})
end
do
    Tabs.Shop:AddButton({
    Title =  "Buy Slingshot",
    Description =  "Mua súng cao su",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Slingshot")
end
})
end
do
    Tabs.Shop:AddButton({
    Title =  "Buy Musket",
    Description =  "Mua súng Musket",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Musket")
end
})
end    
do
    Tabs.Shop:AddButton({
    Title =  "Buy Dual Flintlock",
    Description =  "Mua 2 súng Flintlock",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Dual Flintlock")
end
})
end   
do
    Tabs.Shop:AddButton({
    Title =  "Buy Flintlock",
    Description =  "Mua súng Flintlock",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Flintlock")
end
})
end   
do
    Tabs.Shop:AddButton({
    Title =  "Buy Refined Flintlock",
    Description =  "Mua súng Flintlock xịn",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Refined Flintlock")
end
})
end   
do
    Tabs.Shop:AddButton({
    Title =  "Buy Cannon",
    Description =  "Mua đại bác",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Cannon")
end
})
end 
do
    Tabs.Shop:AddButton({
    Title =  "Buy Kabucha",
    Description =  "Mua súng Kabucha",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Slingshot","2")
end
})
end

Tabs.Shop:AddSection("Fragments shop")
do
    Tabs.Shop:AddButton({
    Title =  "Buy Refund Stats",
    Description =  "Mua hoàn lại chỉ số",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","2")
end
})
end
do
    Tabs.Shop:AddButton({
    Title =  "Buy Reroll Race",
    Description =  "Mua đổi Tộc",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","2")
end
})
end   
do
    Tabs.Shop:AddButton({
    Title =  "Buy Ghoul Race",
    Description =  "Mua Tộc Ghoul",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("Ectoplasm"," Change", 4)
end
})
end	
do
    Tabs.Shop:AddButton({
    Title =  "Buy Cyborg Race (2.5k)",
    Description =  "Mua Tộc Cyborg (2.5k mảnh)",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("CyborgTrainer"," Buy")
end
})
end

do
    Tabs.Shop:AddButton({
    Title =  "Buy Draco Race",
    Description =  "Mua Tộc Draco",
    Callback =  function()
        _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
        local targetPosition = Vector3.new(5814.42724609375, 1208.3267822265625, 884.5785522460938)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        repeat wait()
        until (character.HumanoidRootPart.Position - targetPosition).Magnitude < 1
        local args = {
            [1] = {
                ["NPC"] = "Dragon Wizard",
                ["Command"] = "DragonRace"
            }
        }
        game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
    end

})
end

Tabs.Misc:AddSection("Server - Function")
do
    Tabs.Misc:AddButton({
    Title =  "Redeem All Codes",
    Description =  "Nhập tất cả code quà tặng",
    Callback =  function()
        local codes = {
            -- [ CÁC CODE ADMIN & EVENT ] --
            "LIGHTNINGABUSE", "1LOSTADMIN", "ADMINFIGHT", "GIFTING_HOURS", "NOMOREHACK",
            "BANEXPLOIT", "WildDares", "BossBuild", "GetPranked", "EARN_FRUITS",
            "ADMINHACKED", "SEATROLLING", "24NOADMIN", "ADMIN_TROLL", "NEWTROLL", 
            "SECRET_ADMIN", "staffbattle", "NOEXPLOIT", "NOOB2ADMIN", "CODESLIDE", 
            "fruitconcepts", "krazydares", "ADMINGIVEAWAY", "ADMIN_STRENGTH", "NOOB_ADMIN",
            
            -- [ CÁC CODE YOUTUBER & CREATOR ] --
            "Bignews", "CHANDLER", "Fudd10", "fudd10_v2", "FUDD10_V3", "Sub2UncleKizaru",
            "kittgaming", "KITT_RESET", "KITT_EXP", "Sub2CaptainMaui", "Sub2Fer999", 
            "Enyu_is_Pro", "Magicbus", "MAGICBUS_V2", "JCWK", "JCWK_V2", "Starcodeheo", 
            "STARCODEHEO_V2", "Bluxxy", "BLUXXY_V2", "Sub2NoobMaster123", "SUB2NOOBMASTER", 
            "Sub2Daigrock", "SUB2DAIGROCK", "Axiore", "AXIORE_V2", "TantaiGaming", 
            "TANTAIGAMING_V2", "StrawHatMaine", "STRAWHATMAINE_V2", "Sub2OfficialNoobie", 
            "SUB2OFFICIALNOOBIE_V2", "TheGreatAce", "THEGREATACE_V2", "GAMERROBOT_YT",
            "ZIOLES",
            
            -- [ CÁC CODE MỐC VISITS & LIKES ] --
            "1MLIKES_RESET", "2BILLION", "3BVISITS", "1MVISITS", "EXP_5B", "RESET_5B", 
            "GAMER_ROBOT_1M", "1BILLION", "15B_BESTBROTHERS", "100M", "100k", "500M",
            "TY_FOR_WATCHING",
            
            -- [ CÁC CODE UPDATE TỪ CŨ TỚI MỚI & RESET CHỈ SỐ ] --
            "SUB2GAMERROBOT_RESET1", "SUB2GAMERROBOT_EXP1", "SUB2GAMERROBOT_RESET", "SUB2GAMERROBOT_EXP",
            "JULYUPDATE_RESET", "DRAGONABUSE", "TRIPLEABUSE", "FIGHT4FRUIT", "UPD16", "UPD15", "UPD14", 
            "UPDATE17", "UPDATE16", "UPDATE15", "UPDATE14", "UPDATE13", "UPDATE12", "UPDATE11", 
            "UPDATE10", "UPDATE9", "UPDATE8", "UPDATE7", "UPDATE6", "UPDATE5", "UPDATE4", "UPDATE3", 
            "UPDATE2", "UPDATE1", "UPD1", "UPD2", "UPD3", "CONTROL", "POINTSRESET", "THIRDSEA", 
            "NOOB_REFUND", "ShutDownFix2", "REWARDS", "NOOB2PRO", "CODES", "24NOOB", 
            "ALONEV2", "DEVSCOOKING", "SECRETCODE",
            
            -- [ CÁC CODE LỄ HỘI & SỰ KIỆN THEO MÙA ] --
            "XMASEXP", "NEWYEAR24", "MERRYXMAS", "CINCODEMAYO_BOOST", "XMASRESET", 
            "WINTERCODE_2024", "FALL_WIND", "VALENTINES_2023", "HALLOWEEN_2023", 
            "THANKSGIVING", "NEWYEAR2023", "NEWYEAR2022", "CHRISTMAS2022", "CHRISTMAS2021",
            "HALLOWEEN2022", "HALLOWEEN2021", "VALENTINES2022", "VALENTINES2021"
        }

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes")
        local RedeemRemote = RemotesFolder:FindFirstChild("Redeem")

        if not RedeemRemote then
            return
        end

        for _, code in ipairs(codes) do
            task.wait(0)
            pcall(function()
                if RedeemRemote.InvokeServer then
                    RedeemRemote:InvokeServer(code)
                else
                    RedeemRemote:FireServer(code)
                end
            end)
        end
    end

})
end
local HttpService = game:GetService("HttpService")

-- Hàm dùng chung để dịch chuyển bằng __ServerBrowser
local function TeleportViaBrowser(targetId)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local serverBrowser = ReplicatedStorage:FindFirstChild("__ServerBrowser")
    
    if serverBrowser and serverBrowser:IsA("RemoteFunction") then
        pcall(function()
            serverBrowser:InvokeServer("teleport", targetId)
        end)
    end
end

-- [ĐÃ THÊM LÊN ĐẦU] - Tham gia lại máy chủ hiện tại bằng __ServerBrowser
do
    Tabs.Misc:AddButton({
    Title =  "Rejoin the server",
    Description =  "Vào lại server hiện tại",
    Callback =  function()
        TeleportViaBrowser(game.JobId)
    end

})
end

do
    Tabs.Misc:AddButton({
    Title =  "Hop server",
    Description =  "Đổi sang server khác",
    Callback =  function()
        task.spawn(function()
            local PlaceId = game.PlaceId
            local success, servers = pcall(function()
                local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
                local response = game:HttpGet(url)
                return HttpService:JSONDecode(response).data
            end)

            if success and servers then
                local targetServer
                for _, s in pairs(servers) do
                    -- Tìm server chưa đầy và bỏ qua server hiện tại
                    if s.playing < s.maxPlayers and s.id ~= game.JobId then
                        targetServer = s.id
                        break
                    end
                end

                if targetServer then
                    TeleportViaBrowser(targetServer)
                end
            end
        end)
    end

})
end

do
    Tabs.Misc:AddButton({
    Title =  "Move to the player with the lowest score.",
    Description =  "Đi tới người có điểm thấp nhất",
    Callback =  function()
        task.spawn(function()
            local Api = "https://games.roblox.com/v1/games/"
            local _place = game.PlaceId
            local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
            
            local success, Raw = pcall(function()
                return game:HttpGet(_servers)
            end)
            
            if success then
                local data = HttpService:JSONDecode(Raw)
                if data and data.data then
                    for _, s in ipairs(data.data) do
                        if s.playing < s.maxPlayers and s.id ~= game.JobId then
                            TeleportViaBrowser(s.id)
                            return
                        end
                    end
                end
            end
        end)
    end

})
end

do
    Tabs.Misc:AddButton({
    Title =  "Switch to the server with the lowest latency.",
    Description =  "Đổi sang server mượt nhất ít lag",
    Callback =  function()
        task.spawn(function()
            local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?limit=100", game.PlaceId)
            
            local success, response = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(url))
            end)
            
            if success and response and response.data then
                local lowestPingServer = nil
                for _, server in pairs(response.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        if not lowestPingServer or server.ping < lowestPingServer.ping then
                            lowestPingServer = server
                        end
                    end
                end
                
                if lowestPingServer then
                    TeleportViaBrowser(lowestPingServer.id)
                end
            end
        end)
    end

})
end

do
    Tabs.Misc:AddInput("Misc_EnterjobID", {
    Title =  "Enter job ID",
    Placeholder =  "Job ID",
    Callback =  function(Value)
        getgenv().Job = Value:match("^%s*(.-)%s*$")
    end
,
    Default = "",
    Numeric = false,
    Finished = true
})
end

do
    Tabs.Misc:AddButton({
    Title =  "Tele [Job ID]",
    Description =  "Dịch chuyển theo Job ID",
    Callback =  function()
        if getgenv().Job and getgenv().Job ~= "" then
            TeleportViaBrowser(getgenv().Job)
        end
    end

})
end

do
    Tabs.Misc:AddButton({
    Title =  "Copy JobID",
    Description =  "Copy Job ID của server",
    Callback =  function()
        setclipboard(tostring(game.JobId))
    end

})
end
Tabs.Misc:AddSection("Player Gui / Others")
do
    Tabs.Misc:AddButton({
    Title =  "Open Awakenings Expert",
    Description =  "Mở NPC chuyên gia thức tỉnh",
    Callback =  function()
  plr.PlayerGui.Main.AwakeningToggler.Visible = true
end
})
end
do
    Tabs.Misc:AddButton({
    Title =  "Open Title Selection",
    Description =  "Mở chọn danh hiệu",
    Callback =  function()
  replicated.Remotes.CommF_:InvokeServer("getTitles",true)
  plr.PlayerGui.Main.Titles.Visible = true
end
})
end
do
    Tabs.Misc:AddToggle("Misc_DisableChatGUI", {
    Title =  "Disable Chat GUI",
    Description =  "Tắt khung chat",
    Default =  false,
    Callback =  function(Value)
  _G.Rechat = Value
  if  _G.Rechat == true then
    local StarterGui = game:GetService('StarterGui')
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)    
  elseif _G.chat == false then
    local StarterGui = game:GetService('StarterGui')
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)    
  end
end

})
end
do
    Tabs.Misc:AddToggle("Misc_DisableLeaderBoardGUI", {
    Title =  "Disable Leader Board GUI",
    Description =  "Tắt bảng xếp hạng",
    Default =  false,
    Callback =  function(Value)
  ReLeader = Value
  if ReLeader == true then
    local StarterGui = game:GetService('StarterGui')
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)   
  elseif ReLeader == false then
    local StarterGui = game:GetService('StarterGui')
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)   
  end
end

})
end
do
    Tabs.Misc:AddButton({
    Title =  "Set Pirate Team",
    Description =  "Chọn team Hải Tặc",
    Callback =  function()
  Pirates()
end
})
end  
do
    Tabs.Misc:AddButton({
    Title =  "Set Marine Team",
    Description =  "Chọn team Hải Quân",
    Callback =  function()
  Marines()
end
})
end
do
    Tabs.Misc:AddToggle("Misc_UnlockAllPortals", {
    Title =  "Unlock All Portals",
    Description =  "Mở khóa tất cả cổng dịch chuyển",
    Default =  false,
    Callback =  function(Value)
  _G.PortalUnLock = Value
end
})
end
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

Tabs.Misc:AddSection("Graphics / Haki Stats")
HakiSt = {"State 0","State 1","State 2","State 3","State 4","State 5"}
do
    Tabs.Misc:AddDropdown("Misc_SelectHakiStates", {
    Title =  "Select Haki States",
    Description =  "Chọn cấp độ Haki",
    Values =  HakiSt,
    Callback =  function(Value)
  _G.SelectStateHaki = Value
end,
    Multi = false
})
end
do
    Tabs.Misc:AddButton({
    Title =  "ChangeBusoStage",
    Description =  "Đổi cấp Haki vũ trang",
    Callback =  function()
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
end
})
end
do
    Tabs.Misc:AddToggle("Misc_TurnonRTXMode", {
    Title =  "Turn on RTX Mode",
    Description =  "Bật chế độ đồ họa RTX",
    Default =  false,
    Callback =  function(Value)
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
end

})
end
do
    Tabs.Misc:AddButton({
    Title =  "Turn on Fast Mode",
    Description =  "Bật chế độ nhanh cho mượt",
    Callback =  function()
  for _,zx in next, workspace:GetDescendants() do
  if table.find(Past, zx.ClassName) then  zx.Material = "Plastic" end
  end
end
})
end
do
    Tabs.Misc:AddButton({
    Title =  "Turn on Low CPU",
    Description =  "Bật chế độ tiết kiệm CPU",
    Callback =  function()
  LowCpu()
end
})
end
do
    Tabs.Misc:AddButton({
    Title =  "Turn on increase Boats",
    Description =  "Bật tăng tốc tàu thuyền",
    Callback =  function()
  for _, v in pairs(workspace.Boats:GetDescendants()) do
    if table.find(ListSeaBoat, v.Name) and tostring(v.Owner.Value) == tostring(plr.Name) then              
      v.VehicleSeat.MaxSpeed = 350
      v.VehicleSeat.Torque = 0.2
      v.VehicleSeat.TurnSpeed = 5
      v.VehicleSeat.HeadsUpDisplay = true
    end
  end
end
})
end
do
    Tabs.Misc:AddButton({
    Title =  "Remove Sky Fog",
    Description =  "Xóa sương mù trên trời",
    Callback =  function()
  if Lighting:FindFirstChild("LightingLayers") then Lighting.LightingLayers:Destroy() end
  if Lighting:FindFirstChild("SeaTerrorCC") then Lighting.SeaTerrorCC:Destroy() end
  if Lighting:FindFirstChild("FantasySky") then Lighting.FantasySky:Destroy() end
end
})
end

Tabs.Misc:AddSection("Configure - God")
do
    Tabs.Misc:AddButton({
    Title =  "Rain Fruits (Client)",
    Description =  "Mưa trái cây (chỉ mình thấy)",
    Callback =  function()
  for i, v in pairs(game:GetObjects("rbxassetid://112175659522723")[1]:GetChildren()) do
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
end
})
end
do
    Tabs.Misc:AddToggle("Misc_TurnonFullBright", {
    Title =  "Turn on Full Bright",
    Description =  "Bật sáng toàn bản đồ",
    Default =  false,
    Callback =  function(Value)
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
end

})
end


do
    Tabs.Misc:AddDropdown("Misc_SelectTime", {
    Title =  "Select Time",
    Description =  "Chọn thời gian ngày/đêm",
    Values =  {"Day", "Night"},
    Default =  Day,
    Callback =  function(Value)
  _G.SelectDN = Value
end,
    Multi = false
})
end
do
    Tabs.Misc:AddToggle("Misc_TurnonTime", {
    Title =  "Turn on Time",
    Description =  "Bật chỉnh thời gian",
    Default =  false,
    Callback =  function(Value)
  _G.daylightN = Value
end
})
end
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
do
    Tabs.Misc:AddToggle("Misc_TurnonWalkonWater", {
    Title =  "Turn on Walk on Water",
    Description =  "Bật đi bộ trên nước",
    Default =  true,
    Callback =  function(Value)
  _G.WalkWater_Part = Value
  if _G.WalkWater_Part then
    game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)
  else
    game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 80, 1000)
  end
end

})
end
do
    Tabs.Misc:AddToggle("Misc_TurnonIceWalk", {
    Title =  "Turn on Ice Walk",
    Description =  "Bật đi bộ trên băng",
    Default =  false,
    Callback =  function(Value)
  _G.WalkWater = Value
end
})
end
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
local FastAttackModule = {}
local HitRegistrationModule = {}
local MainController = {}

local GameService = game
local Players = GameService:GetService("Players")
local RunService = GameService:GetService("RunService")
local ReplicatedStorage = GameService:GetService("ReplicatedStorage")
local Workspace = GameService:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local function SafeWaitForChild(parent, childName)
    local success, result = pcall(function()
        return parent:WaitForChild(childName)
    end)
    return result
end

local Enemies = SafeWaitForChild(Workspace, "Enemies")
local Characters = SafeWaitForChild(Workspace, "Characters")
local Modules = SafeWaitForChild(ReplicatedStorage, "Modules")
local Net = SafeWaitForChild(Modules, "Net")

FastAttackModule.Rate = 0.000000002
FastAttackModule.Enabled = true

function FastAttackModule.IsAlive(target)
    local humanoid = target:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health > 0 then
        return true
    end
    return false
end

function FastAttackModule.GetNearbyTargets(character, folder)
    local characterPosition = character:GetPivot().Position
    local nearbyTargets = {}
    local children = folder:GetChildren()
    
    for i = 1, #children do
        local target = children[i]
        local humanoid = target:FindFirstChild("Humanoid")
        local rootPart = target:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart and humanoid.Health > 0 then
            local distance = (rootPart.Position - characterPosition).Magnitude
            if distance <= 60 then
                table.insert(nearbyTargets, target)
            end
        end
    end
    return nearbyTargets
end

function FastAttackModule.GetTargetParts(targetList)
    local result = {}
    local count = #targetList
    
    for i = 1, count do
        local target = targetList[i]
        local head = target:FindFirstChild("Head") or target.PrimaryPart
        if head then
            table.insert(result, {target, head})
        end
    end
    return result
end

function FastAttackModule.GetAllTargets(character)
    local enemies = FastAttackModule.GetNearbyTargets(character, Enemies)
    local otherCharacters = FastAttackModule.GetNearbyTargets(character, Characters)
    
    local allTargets = {}
    for i = 1, #enemies do
        table.insert(allTargets, enemies[i])
    end
    for i = 1, #otherCharacters do
        table.insert(allTargets, otherCharacters[i])
    end
    return allTargets
end

function FastAttackModule.ExecuteFastAttack()
    local character = LocalPlayer.Character
    if not character then return end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    local targets = FastAttackModule.GetAllTargets(character)
    if #targets < 1 then return end
    
    local targetParts = FastAttackModule.GetTargetParts(targets)
    if #targetParts < 1 then return end
    
    local attackRemote = Net["RE/RegisterAttack"]
    local hitRemote = Net["RE/RegisterHit"]
    
    attackRemote:FireServer(FastAttackModule.Rate)
    local targetHead = targetParts[1][2]
    hitRemote:FireServer(targetHead, targetParts)
end
 
local AttackRemoteTarget
local AttackRemoteId

local function InitializeHitRegistration()
    local foldersToCheck = {
        ReplicatedStorage.Util,
        ReplicatedStorage.Common,
        ReplicatedStorage.Remotes,
        ReplicatedStorage.Assets,
        ReplicatedStorage.FX
    }

    for _, folder in ipairs(foldersToCheck) do
        local children = folder:GetChildren()
        
        for _, child in ipairs(children) do
            if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
                AttackRemoteTarget = child
                AttackRemoteId = child:GetAttribute("Id")
            end
        end

        folder.ChildAdded:Connect(function(child)
            if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
                AttackRemoteTarget = child
                AttackRemoteId = child:GetAttribute("Id")
            end
        end)
    end
end

InitializeHitRegistration()

function HitRegistrationModule.Execute()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local hitTargets = {}

    local function ScanFolder(folder)
        local children = folder:GetChildren()
        for i = 1, #children do
            local target = children[i]
            local humanoid = target:FindFirstChild("Humanoid")
            local rootPart = target:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 and target ~= character then
                local distance = (rootPart.Position - humanoidRootPart.Position).Magnitude
                if distance <= 60 then
                    local targetChildren = target:GetChildren()
                    for _, child in ipairs(targetChildren) do
                        if child:IsA("BasePart") then
                            table.insert(hitTargets, {target, child})
                        end
                    end
                end
            end
        end
    end

    ScanFolder(Enemies)
    ScanFolder(Characters)

    local tool = character:FindFirstChildOfClass("Tool")
    
    if #hitTargets > 0 and tool and (tool:GetAttribute("WeaponType") == "Melee" or tool:GetAttribute("WeaponType") == "Sword") then
        local seed = Modules.Net.seed:InvokeServer()
        
        local attackRemote = Net["RE/RegisterAttack"]
        local hitRemote = Net["RE/RegisterHit"]
        
        attackRemote:FireServer()
        
        local targetHead = hitTargets[1][1]:FindFirstChild("Head")
        if not targetHead then return end

        hitRemote:FireServer(targetHead, hitTargets, {})
        
        if AttackRemoteTarget then
            local remoteCode = "RE/RegisterHit"
            local encryptionKey = math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1
            
            local encodedString = string.gsub(remoteCode, ".", function(char)
                return string.char(bit32.bxor(string.byte(char), encryptionKey))
            end)

            local finalId = bit32.bxor(AttackRemoteId + 909090, seed * 2)
            
            cloneref(AttackRemoteTarget):FireServer(
                encodedString,
                finalId,
                targetHead,
                hitTargets
            )
        end
    end
end

local function DisableCameraShake()
    local cameraModule = require(ReplicatedStorage.Util.CameraShaker)
    cameraModule:Stop()
end


-- Helpers for Fake Fruit (không sửa code gốc bên dưới)
local RunService = RunSer
local lastAttack = 0
CONFIG = CONFIG or {}
CONFIG.ATTACK_INTERVAL = 0.1

function GetFruitTool()
    local char = plr.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and t.ToolTip == "Blox Fruit" then return t end
        end
    end
    for _, t in ipairs(plr.Backpack:GetChildren()) do
        if t:IsA("Tool") and t.ToolTip == "Blox Fruit" then return t end
    end
    return nil
end

function GetTargets()
    if not plr.Character then return {} end
    local targets = {}
    for _, v in ipairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            if (v.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 60 then
                table.insert(targets, v)
            end
        end
    end
    return targets
end

--// FAKE FRUIT ATTACK (NO EQUIP)
local function AttackFruit(targets)

    if #targets == 0 then return end

    local fruit = GetFruitTool()
    if not fruit then return end

    local remote = fruit:FindFirstChild("LeftClickRemote")
    if not remote then return end

    remote:FireServer(Vector3.new(.01, -500, .01), 1, true)
    task.wait()
    remote:FireServer(false)

end

--// MAIN LOOP
RunService.Heartbeat:Connect(function()

    local now = tick()
    if (now - lastAttack) < CONFIG.ATTACK_INTERVAL then return end
    lastAttack = now

    local targets = GetTargets()
    if #targets == 0 then return end

    AttackFruit(targets)

end)

print("✅ FAKE FRUIT AURA (NO EQUIP) ENABLED")


local function StartMainLoops()
    task.spawn(function()
        while task.wait(FastAttackModule.Rate) do
            FastAttackModule.ExecuteFastAttack()
        end
    end)

    RunService.Heartbeat:Connect(function()
        pcall(HitRegistrationModule.Execute)
    end)
end
StartMainLoops()

-- ============================================================
-- [ADDED - theo yêu cầu boss man] MUSIC PLAYER TAB
-- Tính năng riêng của longhihi Hub — KHÔNG đụng đến bất kỳ biến,
-- function, hay logic nào của vantablack ở trên. Toàn bộ biến
-- local ở đây có tiền tố "longhihi" để chắc chắn không trùng tên với
-- bất kỳ thứ gì trong ~12,500 dòng vantablack phía trên.
-- ============================================================
local MaruSoundService = game:GetService("SoundService")
math.randomseed(os.time())

local MaruPlaylist      = {}
local MaruTrackIdx      = 0
local MaruCurSound      = nil
local MaruEndConn       = nil
local MaruLoading       = false
local MaruAutoNext      = true
local MaruShuffle       = false
local MaruVol           = 1
local MaruSearchTerm    = ""
local MaruFiltered      = {}
local MaruMuted         = false
local MaruOrigVolumes   = {}
local MARU_PLAYLIST_URL = "https://pastefy.app/0QU2aU7c/raw"
local MARU_MUSIC_FOLDER = "MaruMusicPlayer"

local function MaruTrim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
local function MaruDecode(s)
    return (s:gsub('\\"', '"'):gsub('\\/', '/'):gsub('\\\\', '\\'))
end

local function MaruParsePlaylist(raw)
    local out = {}
    for obj in raw:gmatch("%b{}") do
        local name   = obj:match('"name"%s*:%s*"(.-)"')
        local artist = obj:match('"artist"%s*:%s*"(.-)"')
        local url    = obj:match('"download_url"%s*:%s*"(.-)"')
        if name and url then
            name   = MaruDecode(name)
            artist = MaruDecode(artist or "Unknown")
            url    = MaruDecode(url)
            local genre = MaruDecode(obj:match('"genre"%s*:%s*"(.-)"') or "?")
            table.insert(out, {
                name   = MaruTrim(name),
                artist = MaruTrim(artist),
                url    = url,
                genre  = MaruTrim(genre),
                label  = MaruTrim(name) .. " — " .. MaruTrim(artist) .. " [" .. MaruTrim(genre) .. "]"
            })
        end
    end
    return out
end

local function MaruIsMySound(s)
    return s == MaruCurSound or s.Name == "MaruMusicSound"
end

local function MaruSetGameMuted(on)
    MaruMuted = on
    for _, item in ipairs(game:GetDescendants()) do
        if item:IsA("Sound") and not MaruIsMySound(item) then
            if on then
                if MaruOrigVolumes[item] == nil then MaruOrigVolumes[item] = item.Volume end
                item.Volume = 0
            elseif MaruOrigVolumes[item] ~= nil then
                item.Volume = MaruOrigVolumes[item]
                MaruOrigVolumes[item] = nil
            end
        end
    end
end

local function MaruStopMusic()
    if MaruEndConn then MaruEndConn:Disconnect(); MaruEndConn = nil end
    if MaruCurSound then
        pcall(function() MaruCurSound:Stop(); MaruCurSound:Destroy() end)
        MaruCurSound = nil
    end
end

local function MaruRandIdx(exclude)
    if #MaruPlaylist == 0 then return nil end
    if #MaruPlaylist == 1 then return 1 end
    local idx
    repeat idx = math.random(1, #MaruPlaylist) until idx ~= exclude
    return idx
end

local MaruPlayTrack
MaruPlayTrack = function(idx)
    if #MaruPlaylist == 0 then
        pcall(function() Fluent:Notify({Title = "Music", Content = "Playlist trống.", Duration = 4}) end)
        return
    end
    if idx < 1 or idx > #MaruPlaylist then idx = 1 end
    local track = MaruPlaylist[idx]
    MaruTrackIdx = idx
    if not writefile or not (getcustomasset or getsynasset) then
        pcall(function() Fluent:Notify({Title = "Music", Content = "Executor không hỗ trợ writefile.", Duration = 5}) end)
        return
    end
    MaruStopMusic()
    pcall(function() Fluent:Notify({Title = "Music ♪", Content = "Đang tải: " .. track.label, Duration = 4}) end)
    task.spawn(function()
        local fname = MARU_MUSIC_FOLDER .. "/track_" .. idx .. ".mp3"
        if not (isfile and isfile(fname)) then
            local ok, data = pcall(function() return game:HttpGet(track.url) end)
            if not ok or not data or #data == 0 then
                pcall(function() Fluent:Notify({Title = "Music", Content = "Lỗi tải: " .. track.name, Duration = 6}) end)
                return
            end
            pcall(function() writefile(fname, data) end)
        end
        if MaruTrackIdx ~= idx then return end
        local getAsset = getcustomasset or getsynasset
        local ok, assetId = pcall(function() return getAsset(fname) end)
        if not ok or not assetId then
            pcall(function() Fluent:Notify({Title = "Music", Content = "Lỗi asset.", Duration = 4}) end)
            return
        end
        if MaruTrackIdx ~= idx then return end
        local snd = Instance.new("Sound")
        snd.Name = "MaruMusicSound"
        snd.SoundId = assetId
        snd.Volume = MaruVol
        snd.Looped = false
        snd.Parent = MaruSoundService
        MaruCurSound = snd
        MaruEndConn = snd.Ended:Connect(function()
            if MaruCurSound ~= snd then return end
            MaruCurSound = nil
            if MaruEndConn then MaruEndConn:Disconnect(); MaruEndConn = nil end
            snd:Destroy()
            if MaruAutoNext then
                task.wait(0.25)
                if MaruShuffle then MaruPlayTrack(MaruRandIdx(idx))
                else MaruPlayTrack((idx % #MaruPlaylist) + 1) end
            end
        end)
        snd:Play()
        pcall(function() Fluent:Notify({Title = "Music ♪", Content = "Đang phát: " .. track.label, Duration = 4}) end)
    end)
end

local function MaruLoadPlaylist()
    if MaruLoading then return end
    MaruLoading = true
    local ok, raw = pcall(function() return game:HttpGet(MARU_PLAYLIST_URL) end)
    if not ok or not raw or #raw == 0 then
        MaruLoading = false
        pcall(function() Fluent:Notify({Title = "Music", Content = "Lỗi tải playlist!", Duration = 7}) end)
        return
    end
    local parsed = MaruParsePlaylist(raw)
    if #parsed == 0 then
        MaruLoading = false
        pcall(function() Fluent:Notify({Title = "Music", Content = "Không tìm thấy bài hát!", Duration = 7}) end)
        return
    end
    MaruPlaylist = parsed
    MaruLoading = false
    MaruFiltered = {}
    for i, t in ipairs(MaruPlaylist) do
        table.insert(MaruFiltered, {index = i, track = t})
    end
    pcall(function() Fluent:Notify({Title = "Music", Content = "Đã tải " .. #MaruPlaylist .. " bài hát.", Duration = 5}) end)
end

game.DescendantAdded:Connect(function(item)
    if item:IsA("Sound") and MaruMuted and not MaruIsMySound(item) then
        MaruOrigVolumes[item] = item.Volume
        item.Volume = 0
    end
end)

-- ── UI: Music tab ──────────────────────────────
Tabs.Music:AddSection("🎵Music Player")
-- [FIXED thiết kế] redzlib không có API refresh Options cho Dropdown sau
-- khi tạo (vantablack tự nó cũng không dùng pattern này ở đâu cả trong
-- toàn bộ ~12,500 dòng — kiểm tra kỹ rồi mới quyết định không dùng Dropdown
-- ở đây), nên KHÔNG dùng Dropdown cho danh sách bài hát (danh sách chỉ có
-- SAU KHI tải playlist xong, nếu dùng Dropdown sẽ bị kẹt ở placeholder
-- vĩnh viễn — rủi ro thật, không phải suy đoán). Thay bằng TextBox + Button
-- (2 loại widget đã CONFIRM hoạt động, y hệt pattern "Enter job ID" ở tab
-- Misc của vantablack) — gõ tên bài / nghệ sĩ / số thứ tự rồi bấm Phát.
do
    Tabs.Music:AddInput("Music_TmChnBiHt", {
    Title =  " Chọn Bài Hát",
    Placeholder =  "Gõ tên bài, nghệ sĩ, hoặc số thứ tự (1, 2, 3...)",
    Callback =  function(Value)
        local raw = tostring(Value or "")
        MaruSearchTerm = MaruTrim(raw)
        local asNum = tonumber(MaruSearchTerm)
        if asNum and MaruPlaylist[math.floor(asNum)] then
            MaruTrackIdx = math.floor(asNum)
            return
        end
        local lowerTerm = string.lower(MaruSearchTerm)
        MaruFiltered = {}
        for i, t in ipairs(MaruPlaylist) do
            local s = string.lower(t.name .. " " .. t.artist .. " " .. t.genre)
            if lowerTerm == "" or s:find(lowerTerm, 1, true) then
                table.insert(MaruFiltered, {index = i, track = t})
            end
        end
        if MaruFiltered[1] then MaruTrackIdx = MaruFiltered[1].index end
    end
,
    Default = "",
    Numeric = false,
    Finished = true
})
end

do
    Tabs.Music:AddButton({
    Title =  "▶ Phát Bài Đã Tìm/Chọn",
    Description =  "Phát bài khớp với ô tìm kiếm ở trên (hoặc bài đầu tiên nếu tìm nhiều kết quả)",
    Callback =  function()
        if MaruTrackIdx > 0 then MaruPlayTrack(MaruTrackIdx) end
    end

})
end

do
    Tabs.Music:AddButton({
    Title =  "⏮ Bài Trước",
    Callback =  function()
        if #MaruPlaylist > 0 then MaruPlayTrack(((MaruTrackIdx - 2) % #MaruPlaylist) + 1) end
    end

})
end

do
    Tabs.Music:AddButton({
    Title =  "⏭ Bài Tiếp Theo",
    Callback =  function()
        if #MaruPlaylist > 0 then MaruPlayTrack((MaruTrackIdx % #MaruPlaylist) + 1) end
    end

})
end

do
    Tabs.Music:AddButton({
    Title =  "🔀 Phát Ngẫu Nhiên",
    Callback =  function()
        local i = MaruRandIdx(MaruTrackIdx)
        if i then MaruPlayTrack(i) end
    end

})
end

do
    Tabs.Music:AddButton({
    Title =  "⏹ Dừng Nhạc",
    Callback =  function()
        MaruStopMusic()
        pcall(function() Fluent:Notify({Title = "Music", Content = "Đã dừng.", Duration = 3}) end)
    end

})
end

do
    Tabs.Music:AddSlider("Music_mLng", {
    Title =  "Âm Lượng",
    Description =  "Chỉnh âm lượng nhạc đang phát",
    Min =  0,
    Max =  100,
    Default =  100,
    Callback =  function(Value)
        MaruVol = Value / 100
        if MaruCurSound then MaruCurSound.Volume = MaruVol end
    end
,
    Rounding = 0
})
end

do
    Tabs.Music:AddToggle("Music_TPhtBiTip", {
    Title =  "Tự Phát Bài Tiếp",
    Default =  true,
    Callback =  function(Value) MaruAutoNext = Value end

})
end

do
    Tabs.Music:AddToggle("Music_PhtNguNhinShuffle", {
    Title =  "Phát Ngẫu Nhiên (Shuffle)",
    Default =  false,
    Callback =  function(Value) MaruShuffle = Value end

})
end

do
    Tabs.Music:AddToggle("Music_TtmThanhGame", {
    Title =  "Tắt Âm Thanh Game",
    Description =  "Chỉ giữ lại nhạc từ Music Player, tắt hết SFX/nhạc nền game",
    Default =  false,
    Callback =  function(Value) MaruSetGameMuted(Value) end

})
end

do
    Tabs.Music:AddButton({
    Title =  "🔄 Tải Lại Playlist",
    Description =  "Tải danh sách bài hát mới nhất từ server",
    Callback =  MaruLoadPlaylist

})
end

task.spawn(function()
    task.wait(3)
    MaruLoadPlaylist()
end)

-- Save/Load config kiểu Tab #2: GLOBAL, 1 file JSON, auto-save 5s
HttpServiceSV = game:GetService("HttpService")
_SV_FOLDER = "MaruUltimateHub"
_SV_FILE   = _SV_FOLDER .. "/" .. plr.Name .. "-config.json"
if not isfolder(_SV_FOLDER) then makefolder(_SV_FOLDER) end
_SV_IGNORE = {InterfaceTheme = true, InterfaceTransparency = true, MinimizeKeybind = true}

function MaruSaveConfig()
    pcall(function()
        local data = {}
        for id, opt in pairs(Fluent.Options) do
            if not _SV_IGNORE[id] and opt.Value ~= nil then
                local v = opt.Value
                if typeof(v) == "Color3" then
                    v = {__color = true, R = v.R, G = v.G, B = v.B}
                elseif typeof(v) == "EnumItem" then
                    v = tostring(v)
                end
                data[id] = v
            end
        end
        writefile(_SV_FILE, HttpServiceSV:JSONEncode(data))
    end)
end

function MaruLoadConfig()
    task.spawn(function()
        task.wait(0.6)
        _G.UILowEffects = true
        local loaded = false
        pcall(function()
            if not isfile(_SV_FILE) then return end
            local data = HttpServiceSV:JSONDecode(readfile(_SV_FILE))
            for id, value in pairs(data) do
                local opt = Fluent.Options[id]
                if opt and opt.Type ~= "Toggle" then
                    local resolvedValue = value
                    if type(value) == "table" and value.__color then
                        resolvedValue = Color3.new(value.R, value.G, value.B)
                    end
                    task.spawn(function()
                        pcall(function() opt:SetValue(resolvedValue) end)
                    end)
                end
            end
            task.wait(0.35)
            for id, value in pairs(data) do
                local opt = Fluent.Options[id]
                if opt and opt.Type == "Toggle" then
                    task.spawn(function()
                        pcall(function() opt:SetValue(value) end)
                    end)
                end
            end
            loaded = true
        end)
        _G.UILowEffects = false
        if loaded then
            pcall(function()
                Fluent:Notify({Title = "✅ Settings Loaded", Content = "Đã khôi phục cài đặt từ lần chạy trước.", Duration = 4})
            end)
        end
    end)
end

task.spawn(function()
    while task.wait(5) do
        MaruSaveConfig()
    end
end)

MaruLoadConfig()

-- v6: Section D - Melee NPC Positions
-- Water Kung-fu Teacher | 61586.96,19.58,987.59 | Sea 1
-- Mad Scientist | -5382.79,12.55,-2148.82 | Sea 1
-- Dark Step Teacher | -983.62,12.44,3990.46 | Sea 1
-- Dark Step Teacher | -4752.44,33.92,-4848.04 | Sea 2
-- Phoeyu, the Reformed | 6356.47,296.1,-6762.78 | Sea 2
-- Water Kung-fu Teacher | -4957.68,35.94,-4665.6 | Sea 2
-- Sharkman Teacher | -2599.63,238.19,-10316 | Sea 2
-- Mad Scientist | -4866.16,33.92,-4767.11 | Sea 2
-- Previous Hero | -10371.48,330.76,-10131.42 | Sea 3
-- Mad Scientist | -4996.06,313.21,-3201.83 | Sea 3
-- Dark Step Teacher | -5045.61,370.01,-3182.31 | Sea 3
-- Uzoth | 5661.89,1210.87,863.17 | Sea 3
-- Sharkman Teacher | -4971.21,313.88,-3223.08 | Sea 3
-- Ancient Monk | -13774.1,333.73,-9879.91 | Sea 3
-- Water Kung-fu Teacher | -5023.91,371.02,-3191.46 | Sea 3
-- Phoeyu, the Reformed | -4999.24,314.01,-3221.58 | Sea 3

-- v6: Section C - DirectBuyMelee Function (noclip + distance check)
local function DirectBuyMelee(meleeName)
    local data = MeleeCoords[meleeName]
    if not data or not data.Pos then
        return false
    end
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return false
    end
    local hrp = char.HumanoidRootPart
    local noclip = game:GetService("RunService").Stepped:Connect(function()
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)
    shouldTween = true
    local t0 = tick()
    local dist = (hrp.Position - data.Pos.Position).Magnitude
    while dist > 15 and tick() - t0 < 30 do
        task.wait(0.1)
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            break
        end
        _tp(data.Pos)
        dist = (hrp.Position - data.Pos.Position).Magnitude
    end
    shouldTween = false
    if noclip then
        noclip:Disconnect()
    end
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
    if dist <= 15 then
        hrp.CFrame = data.Pos
        task.wait(0.3)
        replicated.Remotes.CommF_:InvokeServer(data.Key)
        replicated.Remotes.CommF_:InvokeServer("BuyItem", data.Key)
        return true
    end
    return false
end

Window:SelectTab(1)

Fluent:Notify({
  Title = "longhihi system",
  Content = "System override complete. Interface deployed.",
  Image = "rbxassetid://112175659522723",
  Duration = 3
})

