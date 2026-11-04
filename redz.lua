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
  Sec = 0.1
_G.FastAttack1Mob = _G.FastAttack1Mob or false
getgenv().FastAttack1Mob = getgenv().FastAttack1Mob or false
  ClickState = 0
  -- CLEAN FIXES
  getgenv().FarmMode = getgenv().FarmMode or "Up"
  getgenv().FarmDistance = getgenv().FarmDistance or 15
  getgenv().FarmHeight = getgenv().FarmHeight or 15
  getgenv().OrbitSpeed = getgenv().OrbitSpeed or 3.5
  getgenv().FlySpeed = getgenv().FlySpeed or 50
  
-- [SAFE GUARDS] Fix F9 errors
if not _G.StopAutoSpin then _G.StopAutoSpin = function() end end
function StopAutoSpin() pcall(function() if _G.StopAutoSpin then _G.StopAutoSpin() end end) end
if not UpdateIslandMirageESP then UpdateIslandMirageESP = function() end end
if not StopTween then StopTween = function() pcall(function() if TweenManager then TweenManager:CancelCurrent() end end) end end

getgenv().TweenSpeedFar = getgenv().TweenSpeedFar or 170
  getgenv().TweenSpeedNear = getgenv().TweenSpeedNear or 190
  getgenv().BringDistance = getgenv().BringDistance or 200
  getgenv().BringMobs = getgenv().BringMobs == nil and true or getgenv().BringMobs

getgenv().AutoDodgeSkillMobs = getgenv().AutoDodgeSkillMobs or false
getgenv().Doding = false
getgenv().ReadyToDodge = false
getgenv().PosDodgeskill = 0

  _G.FarmMode = getgenv().FarmMode
  _G.FarmDistance = getgenv().FarmDistance
  _G.FarmHeight = getgenv().FarmHeight
  _G.OrbitSpeed = getgenv().OrbitSpeed
  _G.BringDistance = getgenv().BringDistance
  _G.CurrentFarmMob = "Bandit"
  DistanceFarmnear = getgenv().FarmDistance
  _G.OrbitAngle = 0
  _G.StarIndex = 1
  _G.FlySpeed = getgenv().FlySpeed

  Num_self = 25
end


-- ========== SAFE FARM MODE CORE + TYRANT FUNCTION ==========
if getgenv().YPosFruit == nil then getgenv().YPosFruit = 20 end
getgenv().SafeFarmMode = getgenv().SafeFarmMode or false
getgenv().SafeFarmDistance = getgenv().SafeFarmDistance or 6
getgenv().SafeFarmTilt = getgenv().SafeFarmTilt or -6
getgenv().SafeFarmHeight = getgenv().SafeFarmHeight or 22
getgenv().SafeFarmStraight = getgenv().SafeFarmStraight or 0
_G.SafeFarmMode = getgenv().SafeFarmMode
_G.SafeFarmDistance = getgenv().SafeFarmDistance
_G.SafeFarmTilt = getgenv().SafeFarmTilt
_G.SafeFarmHeight = getgenv().SafeFarmHeight
_G.SafeFarmStraight = getgenv().SafeFarmStraight

function GetSafeFarmCFrame(mob, isFruit)
    if not mob or not mob:FindFirstChild("HumanoidRootPart") then return nil end
    local safeOn = false
    pcall(function() safeOn = getgenv().SafeFarmMode or _G.SafeFarmMode end)
    if Settings then pcall(function() if Settings["Safe Farm Mode"] then safeOn = true end end) end
    if not safeOn then
        if isFruit then return mob.HumanoidRootPart.CFrame * CFrame.new(-7, getgenv().YPosFruit or 20, 0) else return mob.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0) end
    else
        return mob.HumanoidRootPart.CFrame * CFrame.new(getgenv().SafeFarmTilt or -6, getgenv().SafeFarmHeight or 22, (getgenv().SafeFarmDistance or 6)+(getgenv().SafeFarmStraight or 0))
    end
end

-- HAM FARM TYRANT - THEM THEO YEU CAU, LAY TU CODE BAN GUI + FIX NHAY BAI + SAFE FARM
getgenv().AutoFarmTyrant = getgenv().AutoFarmTyrant or false
_G.AutoFarmTyrant = getgenv().AutoFarmTyrant

function FarmTyrantOfTheSkies()
    pcall(function()
        if not (getgenv().AutoFarm or getgenv().AutoFarmTyrant or _G.AutoFarmTyrant or _G.StartFarm_Banana) then return end
        if not World3 then return end
        
        -- Kiem tra quai duoi chan truoc khi nhay
        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local countNear = 0
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == "Tyrant of the Skies" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    if (v.HumanoidRootPart.Position - hrp.Position).Magnitude <= 250 then
                        countNear = countNear + 1
                    end
                end
            end
            -- Con quai Tyrant duoi chan -> farm het truoc
        end
        
        if workspace.Enemies:FindFirstChild("Tyrant of the Skies") then
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == "Tyrant of the Skies" then
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        _G.CurrentFarmMob = "Tyrant of the Skies"
                        repeat task.wait()
                            pcall(function()
                                -- Su dung Safe Farm CFrame
                                local safeCf = GetSafeFarmCFrame(v, false)
                                if safeCf then
                                    if typeof(Attack) ~= "nil" and Attack.Kill then
                                        Attack.Kill(v, getgenv().AutoFarm or _G.AutoFarmTyrant)
                                    else
                                        -- Fallback neu khong co Attack.Kill
                                        if typeof(toTarget) == "function" then
                                            toTarget(safeCf)
                                        elseif typeof(_tp) == "function" then
                                            _tp(safeCf)
                                        elseif typeof(topos) == "function" then
                                            topos(safeCf)
                                        end
                                        if typeof(BringEnemy) == "function" then BringEnemy() end
                                        if typeof(EquipWeapon) == "function" then EquipWeapon(_G.SelectWeapon) end
                                    end
                                else
                                    Attack.Kill(v, getgenv().AutoFarm or _G.AutoFarmTyrant)
                                end
                            end)
                        until not (getgenv().AutoFarm or getgenv().AutoFarmTyrant or _G.AutoFarmTyrant or _G.StartFarm_Banana) or not v.Parent or v.Humanoid.Health <= 0
                    end
                end
            end
        else
            -- Khong co Tyrant tren map -> bay toi ReplicatedStorage hoac spawn
            pcall(function()
                local tyrantRep = game:GetService("ReplicatedStorage"):FindFirstChild("Tyrant of the Skies")
                if tyrantRep and tyrantRep:FindFirstChild("HumanoidRootPart") then
                    local cf = tyrantRep.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    if typeof(topos) == "function" then topos(cf)
                    elseif typeof(toTarget) == "function" then toTarget(cf)
                    elseif typeof(_tp) == "function" then _tp(cf) end
                else
                    -- Fallback: dung PosMsList neu co
                    if PosMsList and PosMsList["Tyrant of the Skies"] then
                        local cf = PosMsList["Tyrant of the Skies"] * CFrame.new(0, 30, 0)
                        if typeof(_tp) == "function" then _tp(cf) end
                    end
                end
            end)
        end
    end)
end

task.spawn(function()
    repeat task.wait() until typeof(toTarget) == "function" or typeof(_tp) == "function"
    local original = toTarget or _tp
    if original then
        local newTarget = function(...)
            local args = {...}
            local cf = args[1]
            if typeof(cf) == "CFrame" and (getgenv().SafeFarmMode or _G.SafeFarmMode) then
                pcall(function()
                    local mob = nil
                    if workspace.Enemies then
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") then
                                if (v.HumanoidRootPart.Position - cf.Position).Magnitude < 35 then mob = v break end
                            end
                        end
                    end
                    if mob then args[1] = mob.HumanoidRootPart.CFrame * CFrame.new(getgenv().SafeFarmTilt or -6, getgenv().SafeFarmHeight or 22, (getgenv().SafeFarmDistance or 6)+(getgenv().SafeFarmStraight or 0)) end
                end)
            end
            return original(unpack(args))
        end
        if typeof(toTarget) == "function" then toTarget = newTarget end
        if typeof(_tp) == "function" then _tp = newTarget end
        getgenv().toTarget = newTarget
    end
end)
-- ========== END CORE + TYRANT ==========


-- FIXED WAIT FOR MAIN - No infinite yield
repeat task.wait() until game:IsLoaded() and plr:FindFirstChild("PlayerGui") and plr.PlayerGui:FindFirstChild("Main")
pcall(function()
    local timeout = 0
    repeat task.wait(0.1) timeout=timeout+1 if timeout>150 then break end
    until game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main") or game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") or game.Players.LocalPlayer.PlayerGui:FindFirstChild("ChooseTeam")
end)

World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089
Sea = World1 and 1 or World2 and 2 or World3 and 3 or 1
_G.Sea = Sea
Sea1 = (Sea == 1)
Sea2 = (Sea == 2)
Sea3 = (Sea == 3)
Sea_Bone = 1
Sea_Default = 2
if not _G._tp then _G._tp = function(cf) pcall(function() if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cf end end) end end
_tp = _G._tp
if not topos then topos = _tp end
if not notween then notween = _tp end


-- === BIEN SEA + FIX MENU + CHUC NANG HAO BANG SEA2 ===
Sea = World1 and 1 or World2 and 2 or World3 and 3 or 1
_G.Sea = Sea
Sea1 = (Sea == 1)
Sea2 = (Sea == 2)
Sea3 = (Sea == 3)
Sea_Bone = 1
Sea_Default = 2

Marines = function() replicated.Remotes.CommF_:InvokeServer("SetTeam","Marines") end
Pirates = function() replicated.Remotes.CommF_:InvokeServer("SetTeam","Pirates") end
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

-- [EXTRA SPAWNS - FIX HET QUAI KHONG DI CHUYEN]
PosMsList["Vampire"] = CFrame.new(-6032, 32, -1316)
PosMsList["Ghost"] = CFrame.new(-6032, 32, -1316)
PosMsList["Zombie"] = CFrame.new(-5688, 48, -853)
PosMsList["Living Zombie"] = CFrame.new(-5688, 48, -853)
PosMsList["Demonic Soul"] = CFrame.new(-5710, 48, -853)
PosMsList["Posessed Mummy"] = CFrame.new(-5710, 48, -853)
PosMsList["Reborn Skeleton"] = CFrame.new(-8764, 142, 5963)
PosMsList["Bandit"] = CFrame.new(1038, 16, 1594)
PosMsList["Monkey"] = CFrame.new(-1449, 36, 25)
PosMsList["Gorilla"] = CFrame.new(-1220, 6, -515)
PosMsList["Pirate"] = CFrame.new(-1239, 12, 3855)
PosMsList["Brute"] = CFrame.new(-1142, 14, 4322)
PosMsList["Desert Bandit"] = CFrame.new(932, 6, 4489)
PosMsList["Desert Officer"] = CFrame.new(1572, 10, 4389)
PosMsList["Snow Bandit"] = CFrame.new(1389, 87, -1297)
PosMsList["Snowman"] = CFrame.new(1218, 138, -1488)
PosMsList["Chief Petty Officer"] = CFrame.new(-4842, 20, 4363)
PosMsList["Sky Bandit"] = CFrame.new(-4981, 278, -536)
PosMsList["Dark Master"] = CFrame.new(-5250, 389, -2278)
PosMsList["Prisoner"] = CFrame.new(5308, 2, 475)
PosMsList["Dangerous Prisoner"] = CFrame.new(5489, 2, 452)
PosMsList["Toga Warrior"] = CFrame.new(-1779, 44, 1553)
PosMsList["Gladiator"] = CFrame.new(-1288, 44, 1535)
PosMsList["Military Soldier"] = CFrame.new(634, 12, 1488)
PosMsList["Military Spy"] = CFrame.new(-88, 77, 4533)
PosMsList["Fishman Warrior"] = CFrame.new(60883, 18, 1529)
PosMsList["Fishman Commando"] = CFrame.new(61943, 18, 1494)
PosMsList["God's Guard"] = CFrame.new(-4725, 845, -1940)
PosMsList["Shanda"] = CFrame.new(-7687, 5567, -497)
PosMsList["Royal Squad"] = CFrame.new(-7687, 5567, -497)
PosMsList["Royal Soldier"] = CFrame.new(-7687, 5567, -497)
PosMsList["Galley Pirate"] = CFrame.new(5566, 39, 3998)
PosMsList["Galley Captain"] = CFrame.new(5731, 47, 4749)
PosMsList["Zombie"] = CFrame.new(-5688, 48, -853)
-- Sea 2 extra
PosMsList["Raider"] = CFrame.new(-746, 37, 4477)
PosMsList["Mercenary"] = CFrame.new(-970, 73, 1426)
PosMsList["Swan Pirate"] = CFrame.new(886, 122, 1132)
PosMsList["Factory Staff"] = CFrame.new(295, 73, -54)
PosMsList["Marine Lieutenant"] = CFrame.new(-2916, 73, -3038)
PosMsList["Marine Captain"] = CFrame.new(-1861, 73, -3329)
PosMsList["Zombie"] = CFrame.new(-5736, 47, -692)
PosMsList["Vampire"] = CFrame.new(-6032, 32, -1316)
PosMsList["Snow Trooper"] = CFrame.new(541, 401, -5336)
PosMsList["Winter Warrior"] = CFrame.new(1176, 407, -5265)
PosMsList["Lab Subordinate"] = CFrame.new(-2467, 406, -2517)
PosMsList["Horned Warrior"] = CFrame.new(-2447, 44, -1987)
PosMsList["Magma Ninja"] = CFrame.new(-5426, 78, -5926)
PosMsList["Lava Pirate"] = CFrame.new(-5237, 49, -4706)
PosMsList["Ship Deckhand"] = CFrame.new(1038, 125, 32913)
PosMsList["Ship Engineer"] = CFrame.new(1038, 125, 32913)
PosMsList["Ship Steward"] = CFrame.new(1038, 125, 32913)
PosMsList["Ship Officer"] = CFrame.new(1038, 125, 32913)
PosMsList["Arctic Warrior"] = CFrame.new(6235, 92, -5048)
PosMsList["Snow Lurker"] = CFrame.new(5560, 45, -6829)
PosMsList["Sea Soldier"] = CFrame.new(-3026, 65, -3367)
PosMsList["Water Fighter"] = CFrame.new(-3385, 24, -10632)
PosMsList["Sea Archer"] = CFrame.new(-3500, 5, -10485)


--// ================= WORLD SPAWN DATABASE FROM TOPI HUB - CAI DAT LAY TOA DO =================
-- He thong quet toan bo EnemySpawns cua ca world giong Topi Hub
if not getgenv().WorldSpawnData then
    getgenv().WorldSpawnData = {}
end
if not getgenv().WorldMobLevelData then
    getgenv().WorldMobLevelData = {}
end
if not getgenv().WorldMobBossData then
    getgenv().WorldMobBossData = {}
end

local function ScanWorldSpawns_TOPi()
    local spawnsFolder = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("EnemySpawns")
    if not spawnsFolder then 
        print("[Topi Spawn] Khong tim thay EnemySpawns")
        return 
    end
    local count = 0
    for _, part in ipairs(spawnsFolder:GetDescendants()) do
        if part:IsA("BasePart") then
            local rawName = part.Name
            local name = rawName:match("^(.-)%s*%[") or rawName
            if name == "" then name = rawName end
            if name:match("^Part%d*$") or name:match("^Union%d*$") or name:match("^Spawn%d*$") or name == "SpawnLocation" then
                name = (part.Parent and part.Parent ~= spawnsFolder and part.Parent.Name) or name
            end
            local lvlStr = rawName:match("%[%s*[Ll][Vv]%.?%s*(%d+)%s*%]")
            if lvlStr then
                local lvlNum = tonumber(lvlStr)
                if lvlNum and (not getgenv().WorldMobLevelData[name] or lvlNum > getgenv().WorldMobLevelData[name]) then
                    getgenv().WorldMobLevelData[name] = lvlNum
                end
            end
            if rawName:match("%[%s*[Bb]oss%s*%]") then
                getgenv().WorldMobBossData[name] = true
            end
            local p = part.Position
            local cf = CFrame.new(p.X, p.Y + 25, p.Z)
            local list = getgenv().WorldSpawnData[name]
            if not list then
                list = {}
                getgenv().WorldSpawnData[name] = list
            end
            local isDup = false
            for _, existingCF in ipairs(list) do
                if (existingCF.Position - cf.Position).Magnitude < 3 then
                    isDup = true
                    break
                end
            end
            if not isDup then
                table.insert(list, cf)
                count = count + 1
            end
        end
    end
    print("[Topi Spawn] Da quet duoc "..count.." vi tri spawn, tong "..(function() local c=0 for _,v in pairs(getgenv().WorldSpawnData) do c=c+#v end return c end)().." pos")
end
getgenv().ScanWorldSpawns = ScanWorldSpawns_TOPi

-- Quet ngay khi load
task.spawn(function()
    for i=1,20 do
        if workspace:FindFirstChild("_WorldOrigin") then break end
        task.wait(0.5)
    end
    pcall(ScanWorldSpawns_TOPi)
end)

-- Ham lay spawn gan nhat tu WorldSpawnData (uu tien)
function GetSpawnCFrame_TOPi(mobName)
    if not mobName then return nil end
    -- 1. Tu WorldSpawnData cua Topi (chuan nhat)
    if getgenv().WorldSpawnData and getgenv().WorldSpawnData[mobName] and #getgenv().WorldSpawnData[mobName] > 0 then
        -- Lay cai gan nhat voi nhan vat
        local closest, minDist = nil, math.huge
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        for _,cf in ipairs(getgenv().WorldSpawnData[mobName]) do
            if hrp then
                local d = (cf.Position - hrp.Position).Magnitude
                if d < minDist then
                    minDist = d
                    closest = cf
                end
            else
                return cf -- neu chua co nhan vat thi lay cai dau tien
            end
        end
        if closest then return closest end
        return getgenv().WorldSpawnData[mobName][1]
    end
    -- 2. Thu tim ten gan dung trong WorldSpawnData
    if getgenv().WorldSpawnData then
        for name,list in pairs(getgenv().WorldSpawnData) do
            if string.find(name, mobName) or string.find(mobName, name) then
                if #list > 0 then return list[1] end
            end
        end
    end
    return nil
end



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

local StarAxes = {
    Vector3.new(1,0,0), Vector3.new(-1,0,0), Vector3.new(0,0,1), Vector3.new(0,0,-1),
    Vector3.new(0.7,0,0.7), Vector3.new(-0.7,0,0.7), Vector3.new(0.7,0,-0.7), Vector3.new(-0.7,0,-0.7)
}
function GetFarmCFrame(mobCF, mode)
    -- Dodge Skill Mob: if mob casting skill, fly high 200 + PosDodgeskill
    if getgenv().ReadyToDodge then
        return mobCF * CFrame.new(0, 200 + (getgenv().PosDodgeskill or 0), 0)
    end
    local dist = getgenv().FarmDistance or 15
    local height = getgenv().FarmHeight or 15
    mode = mode or getgenv().FarmMode or "Up"
    if mode == "Up" then
        return mobCF * CFrame.new(0, dist, 0)
    elseif mode == "Orbit" then
        _G.OrbitAngle = (_G.OrbitAngle + (getgenv().OrbitSpeed or 3.5)) % 360
        local rad = math.rad(_G.OrbitAngle * 4)
        local x = math.cos(rad) * dist
        local z = math.sin(rad) * dist
        return CFrame.new(mobCF.Position + Vector3.new(x, height, z))
    elseif mode == "Star" then
        _G.StarIndex = (_G.StarIndex % #StarAxes) + 1
        if math.random() < 0.3 then _G.StarIndex = math.random(1, #StarAxes) end
        return mobCF + StarAxes[_G.StarIndex] * dist + Vector3.new(0, height, 0)
    else
        return mobCF * CFrame.new(0, dist, 0)
    end
end
function GetSpawnCFrame(mobName)
    if not mobName then return nil end
    -- 1. Thu tu Topi WorldSpawnData (chuan nhat, quet ca world)
    local cfTopi = GetSpawnCFrame_TOPi(mobName)
    if cfTopi then return cfTopi end
    
    -- 2. Tu PosMsList cu (fallback)
    if PosMsList and PosMsList[mobName] then return PosMsList[mobName] end
    
    -- 3. Tim gan dung trong PosMsList
    for name,cf in pairs(PosMsList or {}) do
        if string.find(name, mobName) or string.find(mobName, name) then
            return cf
        end
    end
    
    -- 4. Fallback PosMon
    if PosMon then return CFrame.new(PosMon) end
    return nil
end

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
  _G.CurrentFarmMob = model.Name
  BringEnemy()
  EquipWeapon(_G.SelectWeapon)
  local farmCF = GetFarmCFrame(model.HumanoidRootPart.CFrame, getgenv().FarmMode)
  _tp(farmCF)
  end
end

-- [FIXED HARD FIX - KHONG NHAY BAI KHI QUAI DUOI CHAN CHUA HET + TYRANT]
spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local isFarming = _G.AutoFarmNear or _G.Level or _G.AutoFarm or _G.AutoFarm_Bone or _G.AutoFarmAllBoss or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarmDungeon or _G.AutoFarmTyrant or getgenv().AutoFarmTyrant
            if not isFarming then return end
            if getgenv().AutoFarmLevel_Banana then return end
            local char = game.Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local countNear = 0
            local countFar = 0
            local lastMobName = _G.CurrentFarmMob or "Bandit"
            for _,v in pairs(workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if d <= 250 then countNear = countNear + 1 lastMobName = v.Name end
                    if d <= 3500 then countFar = countFar + 1 end
                end
            end
            if countNear > 0 then return end -- Con quai duoi chan -> o lai
            if countFar == 0 and countNear == 0 then
                _G.CurrentFarmMob = _G.CurrentFarmMob or lastMobName
                local mobName = _G.CurrentFarmMob or "Bandit"
                local spawnCF = nil
                if PosMsList and PosMsList[mobName] then spawnCF = PosMsList[mobName]
                else
                    if PosMsList then
                        for name,cf in pairs(PosMsList) do
                            if string.find(mobName, name) or string.find(name, mobName) then spawnCF = cf break end
                        end
                    end
                end
                if not spawnCF and PosMon then spawnCF = CFrame.new(PosMon.X, PosMon.Y + 10, PosMon.Z) end
                if spawnCF then
                    print("[FIXED] Het quai duoi chan + xa ("..mobName..") -> Bay ve spawn!")
                    _tp(spawnCF * CFrame.new(0, 25, 0))
                    task.wait(1)
                end
            end
        end)
    end
end)

-- THEM HAM TYRANT RIENG - CHAY DOC LAP
spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if (getgenv().AutoFarmTyrant or _G.AutoFarmTyrant) and World3 then
                FarmTyrantOfTheSkies()
            end
        end)
    end
end)


Attack.Kill2 = function(model,Succes)
  if model and Succes then
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  BringEnemy()
  EquipWeapon(_G.SelectWeapon)
  local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
  local ToolTip = Equipped.ToolTip
  if ToolTip == "Blox Fruit" then _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,10,0) * CFrame.Angles(0,math.rad(90),0)) else _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,8) * CFrame.Angles(0,math.rad(180),0))end
  if RandomCFrame then wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30 ,0)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))end
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




-- === BRING MOB QUANTUM ONYX STYLE - THAY TOAN BO CODE BRING CU, KHONG LOI, GIONG QUANTUM ===
_G.BringRange = _G.BringRange or 300
_G.MaxBringMobs = _G.MaxBringMobs or 15
_G.BringMobs = _G.BringMobs == nil and true or _G.BringMobs
getgenv().BringDistance = getgenv().BringDistance or _G.BringRange
getgenv().MaxBringMobs = getgenv().MaxBringMobs or _G.MaxBringMobs
getgenv().BringMobs = getgenv().BringMobs == nil and _G.BringMobs or getgenv().BringMobs
_G.FarmDistance = _G.FarmDistance or 15

-- Quantum Bring Core - 100% giong Quantum Onyx, khong loi
local CollectionService = game:GetService("CollectionService")
local PlayersService = game:GetService("Players")
local LocalPlayerQ = PlayersService.LocalPlayer
local BringCacheQuantum = {}
local lastBringTickQ = 0
local lastSimRadiusTickQ = 0
local QuantumBringTag = "QuantumBringTag"

-- Ham kiem tra mob san sang de bring (giong Quantum)
local function IsReadyQuantum(mob)
    if not mob then return false end
    if PlayersService:GetPlayerFromCharacter(mob) then return false end
    local hum = mob:FindFirstChildOfClass("Humanoid")
    local hrp = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
    if not hum or not hrp then return false end
    if hum.Health <= 0 then return false end
    if mob:GetAttribute("Bringing") then return false end
    if mob:HasTag(QuantumBringTag) then return false end
    -- Khong bring boss mau cao
    if hum.MaxHealth > 50000 then return false end
    if BossList and table.find(BossList, mob.Name) then return false end
    return true
end

-- Ham Bring chinh - thay the hoan toan BringEnemy cu bang Quantum
BringEnemy = function(targetMob)
    if not (_G.BringMobs and getgenv().BringMobs ~= false) then return end
    if getgenv().BringMobs == false then return end
    if _G.BringMobs == false then return end
    
    local char = LocalPlayerQ.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local targetCFrame = nil
    local targetName = nil
    
    if targetMob then
        if typeof(targetMob) == "Instance" and targetMob:IsA("Model") then
            local tHRP = targetMob:FindFirstChild("HumanoidRootPart") or targetMob.PrimaryPart
            if tHRP then
                targetCFrame = tHRP.CFrame
                targetName = targetMob.Name
            end
        elseif typeof(targetMob) == "CFrame" then
            targetCFrame = targetMob
        elseif typeof(targetMob) == "Vector3" then
            targetCFrame = CFrame.new(targetMob)
        end
    end
    
    if not targetCFrame then
        if PosMon then
            if typeof(PosMon) == "CFrame" then
                targetCFrame = PosMon
            elseif typeof(PosMon) == "Vector3" then
                targetCFrame = CFrame.new(PosMon)
            else
                targetCFrame = CFrame.new(PosMon)
            end
        end
    end
    
    if not targetCFrame then
        targetCFrame = hrp.CFrame
    end
    
    -- Luu cache giong Quantum
    if targetName then
        BringCacheQuantum[targetName] = targetCFrame
    elseif _G.CurrentFarmMob then
        BringCacheQuantum[_G.CurrentFarmMob] = targetCFrame
        targetName = _G.CurrentFarmMob
    else
        BringCacheQuantum["Default"] = targetCFrame
    end
    
    local now = tick()
    if now - lastBringTickQ < 0.25 then return end
    lastBringTickQ = now
    
    local bringRange = _G.BringRange or getgenv().BringDistance or 300
    if getgenv().BringDistance then bringRange = getgenv().BringDistance end
    if _G.BringRange then bringRange = _G.BringRange end
    local maxMobsConfig = _G.MaxBringMobs or getgenv().MaxBringMobs or 15
    local maxPerCall = math.min(4, maxMobsConfig)
    
    if now - lastSimRadiusTickQ > 3 then
        lastSimRadiusTickQ = now
        pcall(function()
            sethiddenproperty(LocalPlayerQ, "SimulationRadius", bringRange + 50)
            sethiddenproperty(LocalPlayerQ, "MaxSimulationRadius", bringRange + 50)
        end)
    end
    
    -- Clean dead tags giong Quantum
    local tagged = CollectionService:GetTagged(QuantumBringTag)
    for _, v in ipairs(tagged) do
        local hum = v:FindFirstChildOfClass("Humanoid")
        if not v.Parent or not hum or hum.Health <= 0 then
            pcall(function() v:RemoveTag(QuantumBringTag) end)
        end
    end
    
    if #tagged >= 8 then return end
    
    -- Tranh bring gan nguoi choi khac (giong Quantum)
    local otherPlayerPositions = {}
    if workspace:FindFirstChild("Characters") then
        for _, plrModel in ipairs(workspace.Characters:GetChildren()) do
            if plrModel ~= char and plrModel:IsA("Model") then
                local otherHRP = plrModel:FindFirstChild("HumanoidRootPart") or plrModel.PrimaryPart
                if otherHRP then
                    table.insert(otherPlayerPositions, otherHRP.Position)
                end
            end
        end
    end
    
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return end
    
    local count = 0
    for _, mob in ipairs(enemiesFolder:GetChildren()) do
        if count >= maxPerCall then break end
        if mob == targetMob then continue end
        if targetName and mob.Name ~= targetName then continue end
        if not IsReadyQuantum(mob) then continue end
        
        local mobHRP = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
        if not mobHRP then continue end
        
        local distToTarget = (mobHRP.Position - targetCFrame.Position).Magnitude
        local distToPlayer = (mobHRP.Position - hrp.Position).Magnitude
        
        if distToTarget <= bringRange and distToPlayer <= bringRange then
            local nearOtherPlayer = false
            for _, otherPos in ipairs(otherPlayerPositions) do
                if (mobHRP.Position - otherPos).Magnitude <= 55 then
                    nearOtherPlayer = true
                    break
                end
            end
            if nearOtherPlayer then continue end
            
            mob:AddTag(QuantumBringTag)
            count = count + 1
        end
    end
end

-- Handler khi mob duoc tag - BodyPosition chuan Quantum, khong loi
CollectionService:GetInstanceAddedSignal(QuantumBringTag):Connect(function(mob)
    task.spawn(function()
        local mobHRP = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
        local mobHum = mob:FindFirstChildOfClass("Humanoid")
        if not mobHRP or not mobHum then
            pcall(function() mob:RemoveTag(QuantumBringTag) end)
            return
        end
        
        local bringBodyPos = mobHRP:FindFirstChild("BringBodyPos")
        if not bringBodyPos then
            bringBodyPos = Instance.new("BodyPosition")
            bringBodyPos.Name = "BringBodyPos"
            bringBodyPos.MaxForce = Vector3.new(1000000, 1000000, 1000000)
            bringBodyPos.P = 8000
            bringBodyPos.D = 600
            bringBodyPos.Position = mobHRP.Position
            bringBodyPos.Parent = mobHRP
        end
        
        local expireTime = tick() + 25
        local failCount = 0
        
        while true do
            local shouldContinue = _G.BringMobs and getgenv().BringMobs ~= false and mob.Parent and mobHRP.Parent and mobHum.Health > 0 and mob:HasTag(QuantumBringTag) and tick() < expireTime
            if not shouldContinue then break end
            
            local char = LocalPlayerQ.Character
            local playerHRP = char and char:FindFirstChild("HumanoidRootPart")
            local cacheCF = BringCacheQuantum[mob.Name] or BringCacheQuantum[_G.CurrentFarmMob or ""] or BringCacheQuantum["Default"]
            
            if playerHRP and cacheCF then
                local bringRange = _G.BringRange or getgenv().BringDistance or 300
                if getgenv().BringDistance then bringRange = getgenv().BringDistance end
                if _G.BringRange then bringRange = _G.BringRange end
                
                if (playerHRP.Position - mobHRP.Position).Magnitude <= bringRange + 50 then
                    pcall(function()
                        for _, part in ipairs(mob:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end)
                    mobHRP.AssemblyLinearVelocity = Vector3.zero
                    mobHRP.AssemblyAngularVelocity = Vector3.zero
                    bringBodyPos.Position = cacheCF.Position
                    failCount = 0
                else
                    failCount = failCount + 1
                end
            else
                failCount = failCount + 1
            end
            
            if failCount > 15 then break end
            task.wait(0.04)
        end
        
        pcall(function()
            if bringBodyPos and bringBodyPos.Parent then bringBodyPos:Destroy() end
            if mob:HasTag(QuantumBringTag) then mob:RemoveTag(QuantumBringTag) end
            for _, part in ipairs(mob:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            if mobHRP then
                mobHRP:SetAttribute("Bringing", nil)
            end
            -- Xoa ca BodyVelocity cu cua ban Redz cu neu con sot
            for _, v in ipairs(mobHRP:GetChildren()) do
                if v.Name == "RedzBringBV" or v.Name == "RedzBringBG" then
                    v:Destroy()
                end
            end
        end)
    end)
end)

-- Auto Bring Loop giu nguyen nhu cu de tuong thich config
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local isFarming = _G.Level or _G.AutoFarm or _G.AutoFarm_Bone or _G.AutoFarm_Cake or _G.AutoTyrant or getgenv().AutoFarmTyrant or _G.AutoFarmNear or _G.AutoFarmAllBoss or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarmDungeon or getgenv().AutoMaterial
            if isFarming and (_G.BringMobs and getgenv().BringMobs ~= false) then
                BringEnemy()
            end
        end)
    end
end)

-- Cleanup Redz cu khi load
pcall(function()
    for _, v in ipairs(workspace.Enemies:GetChildren()) do
        local hrp = v:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, obj in ipairs(hrp:GetChildren()) do
                if obj.Name == "RedzBringBV" or obj.Name == "RedzBringBG" then
                    obj:Destroy()
                end
            end
        end
    end
end)

-- === END BRING QUANTUM - THAY TOAN BO ===



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
    return (Lighting:FindFirstChild("Sky") or Lighting).MoonTextureId
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
  for _,v4 in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory") or {}) do
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





-- === ORIGINAL TWEEN REDZ HUB BETA H - 100% GOC - COPY NGUYEN CODE ===
getgenv().TweenSpeed = getgenv().TweenSpeed or 200
getgenv().UseOldTween = getgenv().UseOldTween or false
getgenv().OldTweenSpeed = getgenv().OldTweenSpeed or 180
getgenv().TweenSpeedFar = getgenv().TweenSpeedFar or 170
getgenv().TweenSpeedNear = getgenv().TweenSpeedNear or 190
getgenv().OnFarm = getgenv().OnFarm or false
shouldTween = false
_G.StopTween = false

if not _G.BlockTweenPart or not _G.BlockTweenPart.Parent then
    if workspace:FindFirstChild("Rip_Indra") then workspace:FindFirstChild("Rip_Indra"):Destroy() end
    _G.BlockTweenPart = Instance.new("Part")
    _G.BlockTweenPart.Size = Vector3.new(1,1,1)
    _G.BlockTweenPart.Name = "Rip_Indra"
    _G.BlockTweenPart.Anchored = true
    _G.BlockTweenPart.CanCollide = false
    _G.BlockTweenPart.CanTouch = false
    _G.BlockTweenPart.Transparency = 1
    _G.BlockTweenPart.Parent = workspace
end
block = _G.BlockTweenPart

game:GetService("RunService").Stepped:Connect(function()
    pcall(function()
        if getgenv().OnFarm or shouldTween then
            local char = game.Players.LocalPlayer.Character
            if char then
                for _,v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end
    end)
end)

-- Tween Module goc Redz Beta H
local TweenModule = {}
TweenModule.CurrentTween = nil
function TweenModule:stopTween(rootPart)
    pcall(function()
        if self.CurrentTween then self.CurrentTween:Cancel() self.CurrentTween = nil end
        if rootPart then
            rootPart.AssemblyLinearVelocity = Vector3.zero
            rootPart.AssemblyAngularVelocity = Vector3.zero
            for _,obj in pairs(rootPart:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") or obj:IsA("BodyPosition") or obj:IsA("AlignPosition") or obj:IsA("AlignOrientation") then
                    obj:Destroy()
                end
            end
        end
    end)
end
function TweenModule.new(rootPart, duration, prop, cf)
    pcall(function()
        if TweenModule.CurrentTween then TweenModule.CurrentTween:Cancel() end
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        TweenModule.CurrentTween = game:GetService("TweenService"):Create(rootPart, tweenInfo, {[prop]=cf})
        TweenModule.CurrentTween:Play()
    end)
end

-- CheckNearestTeleporter goc Redz Beta H - rut gon duong bay
local LastTeleporter = nil
local LastTeleporterTime = 0
function CheckNearestTeleporter(targetPos)
    local pos = targetPos
    if typeof(pos) == "CFrame" then pos = pos.Position end
    local minDist = math.huge
    local nearestPos = nil
    local nearestKey = nil
    local PlaceId = game.PlaceId
    local teleporters = {}
    if PlaceId == 2753915549 then
        teleporters = {
            ["Sky3"] = Vector3.new(-7894, 5547, -380),
            ["Sky3Exit"] = Vector3.new(-4607, 874, -1667),
            ["UnderWater"] = Vector3.new(61163, 11, 1819),
            ["Underwater City"] = Vector3.new(61165, 11, 1897),
            ["Pirate Village"] = Vector3.new(-1242, 4, 3901),
            ["UnderwaterExit"] = Vector3.new(4050, -1, -1814)
        }
    elseif PlaceId == 4442272183 then
        teleporters = {
            ["Swan Mansion"] = Vector3.new(-390, 332, 673),
            ["Swan Room"] = Vector3.new(2285, 15, 905),
            ["Cursed Ship"] = Vector3.new(923, 126, 32852),
            ["Zombie Island"] = Vector3.new(-6509, 83, -133)
        }
    elseif PlaceId == 7449423635 then
        teleporters = {
            ["Floating Turtle"] = Vector3.new(-12462, 375, -7552),
            ["Hydra Island"] = Vector3.new(5657, 1013, -335),
            ["Mansion"] = Vector3.new(-12462, 375, -7552),
            ["Castle"] = Vector3.new(-5036, 315, -3179),
            ["Dimensional Shift"] = Vector3.new(-2097, 4776, -15013),
            ["Beautiful Pirate"] = Vector3.new(5319, 23, -93),
            ["Temple of Time"] = Vector3.new(28286, 14897, 103)
        }
    end
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil end
    for key, tPos in pairs(teleporters) do
        local dist = (tPos - pos).Magnitude
        if dist < minDist then
            minDist = dist
            nearestPos = tPos
            nearestKey = key
        end
    end
    local hrpPos = hrp.Position
    if nearestPos and (hrpPos - pos).Magnitude > (nearestPos - pos).Magnitude + 50 then
        return nearestPos, nearestKey
    else
        return nil, nil
    end
end

function requestEntrance(entrancePos)
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", entrancePos)
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, 50, 0) end
    task.wait(0.5)
end

-- HAM TWEEN CHINH REDZ BETA H - F[7883847] NGUYEN BAN 100%
function RedzBetaH_Tween(targetCFrame, customSpeed, bypassY)
    local character = game.Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("Humanoid") or not character:FindFirstChild("HumanoidRootPart") then return end
    local humanoid = character.Humanoid
    local rootPart = humanoid.RootPart
    if humanoid.Sit then humanoid.Sit = false end
    getgenv().OnFarm = false
    shouldTween = true
    -- Fix configs: dung Near/Far nhu cu SkitringX
    local position = targetCFrame.Position
    local magnitude = (rootPart.Position - position).Magnitude
    local isNear = magnitude <= 150
    local tweenSpeed = getgenv().TweenSpeed or 200
    -- Neu co Near/Far thi uu tien Near/Far nhu cu
    if isNear then
        tweenSpeed = getgenv().TweenSpeedNear or getgenv().TweenSpeed or 190
    else
        tweenSpeed = getgenv().TweenSpeedFar or getgenv().TweenSpeed or 170
    end
    if tweenSpeed < 10 then tweenSpeed = 10 end
    if magnitude < (customSpeed and 10 or 120) then
        rootPart.CFrame = targetCFrame
        TweenModule:stopTween(rootPart)
        return
    end
    local telePos, teleKey = CheckNearestTeleporter(position)
    local teleDist = telePos and (position - telePos).Magnitude + 50 or math.huge
    local shouldUseTele = telePos and magnitude > teleDist
    if shouldUseTele then
        local now = tick()
        if now - LastTeleporterTime >= 6 or LastTeleporter ~= teleKey then
            TweenModule:stopTween(rootPart)
            task.wait(0.2)
            local n2
            if (position - telePos).Magnitude < 50 then
                n2 = position
            else
                n2 = telePos + (position - rootPart.Position).Unit * 40
            end
            LastTeleporter = teleKey
            LastTeleporterTime = now
            requestEntrance(n2)
            return
        end
    end
    if customSpeed then
        TweenModule.new(rootPart, magnitude / customSpeed, "CFrame", targetCFrame)
        return
    end
    if bypassY then
        local pos2 = rootPart.Position
        local corrected = CFrame.new(pos2.X, position.Y, pos2.Z)
        if (pos2 - corrected.Position).Magnitude > 75 then
            TweenModule:stopTween(rootPart)
            task.wait(0.1)
            rootPart.CFrame = corrected
            task.wait(0.5)
        end
    end
    if magnitude < 380 then
        TweenModule.new(rootPart, magnitude / tweenSpeed * 2, "CFrame", targetCFrame)
    else
        TweenModule.new(rootPart, magnitude / tweenSpeed, "CFrame", targetCFrame)
    end
end

-- Wrapper giu config cu SkitringX nhung chay Redz Beta H
local _tp_old = function(targetCFrame)
    shouldTween = true
    getgenv().OnFarm = false
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not block or not block.Parent then block = _G.BlockTweenPart end
    if (targetCFrame.Position - block.Position).Magnitude > 10000 then block.CFrame = hrp.CFrame end
    local dist = (targetCFrame.Position - block.Position).Magnitude
    local speed = getgenv().OldTweenSpeed or 180
    if speed < 10 then speed = 10 end
    local tweenInfo = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(block, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    local conn
    conn = game:GetService("RunService").Heartbeat:Connect(function()
        if not shouldTween then if conn then conn:Disconnect() end return end
        if block and block.Parent and hrp and hrp.Parent then hrp.CFrame = block.CFrame end
    end)
    repeat task.wait() until not shouldTween or tween.PlaybackState ~= Enum.PlaybackState.Playing
    if conn then conn:Disconnect() end
    if shouldTween then hrp.CFrame = targetCFrame block.CFrame = targetCFrame getgenv().OnFarm = true end
end

local _tp_new = function(targetCFrame)
    RedzBetaH_Tween(targetCFrame, nil, true)
end

_tp = function(targetCFrame)
    if getgenv().UseOldTween then _tp_old(targetCFrame) else _tp_new(targetCFrame) end
end

function TeleportToTarget(targetCFrame) _tp(targetCFrame) end
function topos(targetCFrame) RedzBetaH_Tween(targetCFrame) end
function TP1(cf) topos(cf) end

function TP13(cf)
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (cf.Position - hrp.Position).Magnitude
    local speed = getgenv().TweenSpeedFar or getgenv().TweenSpeed or 170
    local duration = dist / speed
    if duration < 0.001 then duration = 0.001 end
    TweenModule.new(hrp, duration, "CFrame", cf)
end

function fastpos(cf)
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
    local dist = (cf.Position - hrp.Position).Magnitude
    TweenModule.new(hrp, dist / 1000, "CFrame", cf)
end

function slowpos(cf)
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
    local dist = (cf.Position - hrp.Position).Magnitude
    TweenModule.new(hrp, dist / 150, "CFrame", cf)
end

function notween(p)
    shouldTween = false
    getgenv().OnFarm = false
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = p end
    TweenModule:stopTween(hrp)
end

function BTP(p)
    shouldTween = false
    getgenv().OnFarm = false
    local plr = game.Players.LocalPlayer
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    local lastPos = hrp.Position
    repeat
        hum.Health = 0
        hrp.CFrame = p
        if plr.PlayerGui:FindFirstChild("Main") then plr.PlayerGui.Main.Quest.Visible = false end
        if (hrp.Position - lastPos).Magnitude > 1 then lastPos = hrp.Position hrp.CFrame = p end
        task.wait(0.5)
    until (p.Position - hrp.Position).Magnitude <= 2000
end

function StopTween(state)
    if not state then
        shouldTween = false
        getgenv().OnFarm = false
        _G.StopTween = true
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    if hrp:FindFirstChild("BodyClip") then hrp.BodyClip:Destroy() end
                    if char:FindFirstChild("Block") then char.Block:Destroy() end
                    TweenModule:stopTween(hrp)
                end
            end
        end)
        task.wait()
        _G.StopTween = false
    end
end

function stopTeleport()
    shouldTween = false
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    TweenModule:stopTween(hrp)
end
-- === END ORIGINAL TWEEN REDZ HUB BETA H 100% ===




task.spawn(function()
  while task.wait(0.05) do
    pcall(function()
      if _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.FullyGetCyborg or _G.DT_Uzoth or _G.AutoBerry or _G.Prefully or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoFarmChest or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago  or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Bartilo_Quest or _G.Level or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or getgenv().AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or _G.TPNpc or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.AutoPole or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Mink or _G.Auto_Human or _G.Auto_Skypiea or _G.Auto_Fish or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad or _G.AutoUnHaki or _G.Auto_DonAcces or _G.AutoRipIngay or _G.DragoV3 or _G.DragoV1 or _G.SailBoats or NextIs or _G.FarmGodChalice or _G.IceBossRen or senth or senth2 or _G.Lvthan or _G.beasthunter or _G.DangerLV or _G.Relic123 or _G.tweenKitsune or _G.Collect_Ember or _G.AutofindKitIs or _G.snaguine or _G.TwFruits or _G.tweenKitShrine or _G.Tp_LgS or _G.Tp_MasterA or _G.tweenShrine or _G.FarmMastery_G or _G.FarmMastery_S or _G.FarmBoss or _G.AutoFarmAllBoss or _G.AutoFishSlap or _G.FarmTyrant or _G.FarmPhaBinh or _G.AutoSpawnCP or _G.AutoBerryH or _G.AutoChestBP or _G.FarmEliteHop or _G.AutoHop_Dough or _G.AutoDoughKing or _G.AutoAttackDoughKing or _G.AutoChipFruit or _G.AutoChipBeli or _G.StartEvent or _G.AutoMysticIsland or _G.AutoPlayerHunter or _G.SafeMode or _G.AutoKillMob or _G.AutoStartPrehistoric or _G.AutoUnHaki or _G.AutoAttackRipIndra or _G.AutoFarmIsland or _G.AutoFarmDungeon or _G.AutoFarmCandy or _G.AutoTP_Gift or _G.AutoTPGift or _G.AutoTPAndCollect or _G.MasterAutoLevel or _G.MasterAutoCandy or _G.TPFloor1 or _G.TPFloor2 or _G.TPFloor3 or _G.TPFloor4 then
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
    Test.FillColor = Color3.fromRGB(0,0,0)
    Test.OutlineColor = Color3.fromRGB(0,255,255)
    Test.FillTransparency = 2
    Test.OutlineTransparency = 2
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

MaterialMon=function()local a=game.Players.LocalPlayer;local b=a.Character and a.Character:FindFirstChild("HumanoidRootPart")if not b then return end;shouldRequestEntrance=function(c,d)local e=(b.Position-c).Magnitude;if e>=d then replicated.Remotes.CommF_:InvokeServer("requestEntrance",c)end end;if World1 then if SelectMaterial=="Angel Wings"then MMon={"Shanda","Royal Squad","Royal Soldier","Wysper","Thunder God"}MPos=CFrame.new(-4698,845,-1912)SP="Default"local c=Vector3.new(-4607.82275,872.54248,-1667.55688)shouldRequestEntrance(c,10000)elseif SelectMaterial=="Leather + Scrap Metal"then MMon={"Brute","Pirate"}MPos=CFrame.new(-1145,15,4350)SP="Default"elseif SelectMaterial=="Magma Ore"then MMon={"Military Soldier","Military Spy","Magma Admiral"}MPos=CFrame.new(-5815,84,8820)SP="Default"elseif SelectMaterial=="Fish Tail"then MMon={"Fishman Warrior","Fishman Commando","Fishman Lord"}MPos=CFrame.new(61123,19,1569)SP="Default"local c=Vector3.new(61163.8515625,5.342342376708984,1819.7841796875)shouldRequestEntrance(c,17000)end elseif World2 then if SelectMaterial=="Leather + Scrap Metal"then MMon={"Marine Captain"}MPos=CFrame.new(-2010.5059814453125,73.00115966796875,-3326.620849609375)SP="Default"elseif SelectMaterial=="Magma Ore"then MMon={"Magma Ninja","Lava Pirate"}MPos=CFrame.new(-5428,78,-5959)SP="Default"elseif SelectMaterial=="Ectoplasm"then MMon={"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer"}MPos=CFrame.new(911.35827636719,125.95812988281,33159.5390625)SP="Default"local c=Vector3.new(61163.8515625,5.342342376708984,1819.7841796875)shouldRequestEntrance(c,18000)elseif SelectMaterial=="Mystic Droplet"then MMon={"Water Fighter"}MPos=CFrame.new(-3385,239,-10542)SP="Default"elseif SelectMaterial=="Radioactive Material"then MMon={"Factory Staff"}MPos=CFrame.new(295,73,-56)SP="Default"elseif SelectMaterial=="Vampire Fang"then MMon={"Vampire"}MPos=CFrame.new(-6033,7,-1317)SP="Default"end elseif World3 then if SelectMaterial=="Scrap Metal"then MMon={"Jungle Pirate","Forest Pirate"}MPos=CFrame.new(-11975.78515625,331.7734069824219,-10620.0302734375)SP="Default"elseif SelectMaterial=="Fish Tail"then MMon={"Fishman Raider","Fishman Captain"}MPos=CFrame.new(-10993,332,-8940)SP="Default"elseif SelectMaterial=="Conjured Cocoa"then MMon={"Chocolate Bar Battler","Cocoa Warrior"}MPos=CFrame.new(620.6344604492188,78.93644714355469,-12581.369140625)SP="Default"elseif SelectMaterial=="Dragon Scale"then MMon={"Dragon Crew Archer","Dragon Crew Warrior"}MPos=CFrame.new(6594,383,139)SP="Default"elseif SelectMaterial=="Gunpowder"then MMon={"Pistol Billionaire"}MPos=CFrame.new(-84.8556900024414, 85.62061309814453, 6132.0087890625)SP="Default"elseif SelectMaterial=="Mini Tusk"then MMon={"Mythological Pirate"}MPos=CFrame.new(-13545,470,-6917)SP="Default"elseif SelectMaterial=="Demonic Wisp"then MMon={"Demonic Soul"}MPos=CFrame.new(-9495.6806640625,453.58624267578125,5977.3486328125)SP="Default"end end end
QuestNeta = function()
    local questData = GetQuests()
    return {
        [1] = questData.Mob,           
        [2] = questData.ID,             
        [3] = questData.NameQuest,      
        [4] = questData.LevelReq,       
        [5] = questData.Mob,             
        [6] = GetQuestPoint()            
    }
end

local redzlib = (function()
        local function tryLoad(url)
            local ok, res = pcall(function() return loadstring(game:HttpGet(url, true))() end)
            if ok and res then return res end
            return nil
        end
        for _, url in ipairs({
            "https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau",
            "https://raw.githubusercontent.com/tlredz/Library/main/redz-V5-remake/main.luau",
            "https://raw.githubusercontent.com/REDzHUB/LibraryV2/main/redzlib5.luau"
        }) do
            local lib = tryLoad(url)
            if lib then return lib end
            task.wait(0.5)
        end
        error("Library failed")
    end)()
local Window = redzlib:MakeWindow({
    Title = "Redz Hub [ BETA ACCESS ] : Blox Fruit",
    SubTitle = "by @realredz and Ducz",
    SaveFolder = "XoshiroXzKHub"
})

local Minimizer = Window:NewMinimizer({
  KeyCode = Enum.KeyCode.LeftControl
})

local MobileButton = Minimizer:CreateMobileMinimizer({
  Image = "rbxassetid://15298567397",
  BackgroundTransparency = 0,
  Corner = { CornerRadius = UDim.new(0, 5) } -- Đã đưa vào chung trong bảng cấu hình
})

local Tabs = {
    Discord = Window:MakeTab({ Title = "Discord", Icon = "Info" }),    
    Main = Window:MakeTab({ Title = "Farm", Icon = "rbxassetid://7733960981" }),       
    SeaEvent = Window:MakeTab({ Title = "Sea", Icon = "waves" }),
    Fish = Window:MakeTab({ Title = "Fishing", Icon = "rbxassetid://127664059821666" }),
    Prehistoric = Window:MakeTab({ Title = "Islands", Icon = "palmtree" }),               
    Quests = Window:MakeTab({ Title = "Quest/Items", Icon = "Swords" }),    
    Race = Window:MakeTab({ Title = "Race V4", Icon = "Moon" }),    
    Raids = Window:MakeTab({ Title = "Fruit/Raid", Icon = "cherry" }),
    Material= Window:MakeTab({ Title = "Hop", Icon = "Gem" }),
    Stats = Window:MakeTab({ Title = "Stats", Icon = "Signal" }),    
    Combat = Window:MakeTab({ Title = "Visual", Icon = "user" }),
    Travel = Window:MakeTab({ Title = "Teleport", Icon = "locate" }),    
    Info = Window:MakeTab({ Title = "Status", Icon = "Scroll" }),                     
    PVP = Window:MakeTab({ Title = "PVP", Icon = "swords" }),         
    Shop = Window:MakeTab({ Title = "Shop", Icon = "Shoppingcart" }),
    Settings = Window:MakeTab({ Title = "Msc", Icon = "Settings" }),        
}


Tabs.Discord:AddDiscordInvite({
	Title = "Redz Hub | Community",
	Description = "Join our discord community to receive Information about the next update, leaks, and Information about Blox Fruits!",
	Banner = "rbxassetid://17382040552", 
	Logo = "",
	Invite = "https://discord.gg/jA2kMmK2z9",
	Members = 99999, 
	Online = 99999, 
})


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
    
    TimeZone:SetDesc(datetime.." - "..timezone.." [ " .. code .. " ]")
end

spawn(function()
    while true do
        UpdateOS()
        wait(1)
    end
end)


function UpdateGameTime()
    local GameTimeValue = math.floor(workspace.DistributedGameTime + 0.5)
    local Hour = math.floor(GameTimeValue / (60^2)) % 24
    local Minute = math.floor(GameTimeValue / (60^1)) % 60
    local Second = math.floor(GameTimeValue / (60^0)) % 60
    GameTime:SetDesc(Hour.." Hour (h) "..Minute.." Minute (m) "..Second.." Second (s)")
end

spawn(function()
    while true do
        UpdateGameTime()
        wait(1)
    end
end)


spawn(function()
    while wait(1) do
        local cakePrince = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
        local killStatus = "Cake Prince: ✅"
        if string.len(cakePrince) >= 86 then
            local killCount = string.sub(cakePrince, 39, 41)
            killStatus = "Killed: " .. killCount
        end
        CakePrinceStatus:SetDesc(killStatus)
    end
end)


local previousRipStatus = ""
spawn(function()
    while wait(1) do
        local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("rip_indra")) and '✅' or '❌'
        if currentStatus ~= previousRipStatus then
            RipIndraCheck:SetDesc("Status: " .. currentStatus)
            previousRipStatus = currentStatus
        end
    end
end)


local previousDoughStatus = ""
spawn(function()
    while wait(1) do
        local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("Dough King") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("Dough King")) and '✅' or '❌'
        if currentStatus ~= previousDoughStatus then
            DoughKingCheck:SetDesc("Status: " .. currentStatus)
            previousDoughStatus = currentStatus
        end
    end
end)


task.spawn(function()
    while task.wait(1) do
        local moonTextureId = (game:GetService("Lighting"):FindFirstChild("Sky") or game:GetService("Lighting")).MoonTextureId
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
        
        FullMoonCheck:SetDesc(moonStatus)
    end
end)


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
        
        LegendarySwordCheck:SetDesc(swordStatus)
    end
end)


local RFSubmarineWorkerSpeak = replicated.Modules.Net["RF/SubmarineWorkerSpeak"]
WeaponDropdown = Tabs.Main:AddDropdown({
    Name = "Select Tool",
    Options = {"Melee","Sword","Blox Fruit","Gun"},
    Default = "Melee",
    Callback = function(Value)
    _G.ChooseWP = Value
end})


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

-- UI Scale - Redz Hub Plock Style - Thay theo yeu cau
-- UI Scale - Redz Hub Beta Style - Chi de Redz Beta
Tabs.Main:AddSlider({
    Name = "UI Scale",
    Min = (typeof(redzlib) == "table" and redzlib.GetMinScale and redzlib:GetMinScale() or 0.5),
    Max = (typeof(redzlib) == "table" and redzlib.GetMaxScale and redzlib:GetMaxScale() or 1.5),
    Default = 1,
    Increment = 0.01,
    Flag = "ui_scale",
    Callback = function(Value)
        pcall(function()
            if typeof(redzlib) == "table" then
                if redzlib.SetUIScale then
                    redzlib:SetUIScale(Value)
                elseif redzlib.SetScale then
                    -- Redz V5 remake uses SetScale with value*450? Beta uses direct scale
                    -- Convert 0.5-1.5 to 900-300 range like Plock, or direct
                    redzlib:SetScale(Value)
                end
            end
            if typeof(Window) == "table" and Window.SetUIScale then
                Window:SetUIScale(Value)
            end
        end)
    end
})

if not getgenv().BananaSettings then getgenv().BananaSettings = {} end
Tabs.Main:AddSection("Main Farm")

Tabs.Main:AddToggle({
    Name = "Auto Farm Level",
    Description = "",
    Default = false,
    Callback = function(Value)
        getgenv().BananaSettings.SelectMethodFarm = "Level Farm"
        getgenv().BananaSettings.StartFarm = Value
        _G.SelectMethodFarm = "Level Farm"
        _G.StartFarm_Banana = Value
        getgenv().AutoFarmLevel_Banana = Value
        _G.Level = Value
        if Value then _G.AutoFarm_Bone = false end
    end
})

ClosetMons = Tabs.Main:AddToggle({
Name = "Auto Farm Nearest", 
Flag = "ClosetMons",
Description = "", 
Default = false, 
Callback = function(Value)
  _G.AutoFarmNear = Value
end})
task.spawn(function()
  while task.wait(0.1) do
    pcall(function()
      if _G.AutoFarmNear then
        local found = false
        for i,v in pairs(workspace.Enemies:GetChildren()) do
          if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            found = true
            _G.CurrentFarmMob = v.Name
            repeat task.wait() Attack.Kill(v,_G.AutoFarmNear) until not _G.AutoFarmNear or not v.Parent or v.Humanoid.Health <= 0
          end
        end
        if not found then
            local mobName = _G.CurrentFarmMob or "Bandit"
            local spawnCF = GetSpawnCFrame(mobName)
            if spawnCF then
                local d = (plr.Character.HumanoidRootPart.Position - spawnCF.Position).Magnitude
                if d > 100 then _tp(spawnCF * CFrame.new(0,15,0)) end
            end
        end
      end
    end)
  end
end)
local localPlayer = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Đảm bảo các biến toàn cục hoặc bảng điều khiển được khai báo an toàn
local HiddenEvent = HiddenEvent or {
    running = false,
    errors = 0,
    holdTime = 0,
    step = "Idle"
}

-- Định nghĩa hàm xử lý toggle
local function fn(arg)
    -- Kiểm tra điều kiện Sea 1 nếu có hàm EnforceGate
    if arg and type(EnforceGate) == "function" and not EnforceGate(v6, "Auto Secret Quest", Place_Id.sea1(), "Only works in Sea 1") then
        return
    end
    
    if type(SaveSettings) == "function" then
        SaveSettings("Auto Secret Quest", arg)
    end

    if not arg then
        HiddenEvent.current = nil
        HiddenEvent.fighting = nil
        HiddenEvent.walking = false
        HiddenEvent.farmHeight = nil
        getgenv().AimPos = nil
        
        if type(SetHiddenStep) == "function" then SetHiddenStep("Idle") end
        pcall(function() LeaveHiddenCannon() end)
        pcall(function() HiddenRelease() end)
        pcall(function() StopHiddenDodge() end)
        pcall(function() require(ReplicatedStorage.DialogueController).close() end)
        pcall(function() TweenManager.CancelCurrent() end)

        task.spawn(function()
            task.wait(0.2)
            local character = localPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then
                return
            end
            humanoidRootPart.Anchored = false
            humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            raycastParams.FilterDescendantsInstances = { character, workspace.Characters, workspace.Enemies }
            local hit = workspace:Raycast(humanoidRootPart.Position, Vector3.new(0, -900, 0), raycastParams)

            if hit and humanoidRootPart.Position.Y - hit.Position.Y > 25 then
                humanoidRootPart.CFrame = CFrame.new(hit.Position + Vector3.new(0, 4, 0))
                task.wait(0.2)
                humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            elseif not hit then
                local v7 = travelFunctions and travelFunctions.GetSpawnPosition(localPlayer.Data.LastSpawnPoint.Value)
                if v7 then
                    humanoidRootPart.CFrame = CFrame.new(v7 + Vector3.new(0, 4, 0))
                end
            end

            local n = 0
            while HiddenEvent.running and n < 5 do
                task.wait(0.1)
                n = n + 0.1
            end

            if type(ReleaseTweenPhysics) == "function" then ReleaseTweenPhysics() end
        end)

        return
    end

    if type(Place_Id) == "table" and Place_Id.sea1 and not Place_Id.sea1() then
        if type(HiddenNotify) == "function" then
            HiddenNotify("Hidden Event only works in First Sea", nil, "warning")
        end
        return
    end

    if HiddenEvent.running then
        return
    end
    HiddenEvent.running = true

    task.spawn(function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki", "Geppo")
        end)
    end)

    if type(HiddenDialogueLoop) == "function" then
        task.spawn(HiddenDialogueLoop)
    end

    task.spawn(function()
        while Settings and Settings["Auto Secret Quest"] and task.wait(0.15) do
            local ok, result

            if StackFarmOther then
                ok, result = pcall(AutoHiddenEvent)
            else
                if type(SetHiddenStep) == "function" then
                    SetHiddenStep("Paused while another feature is running")
                end
                ok = true
                result = nil
            end

            if not ok then
                print(result)
                HiddenEvent.lastError = tostring(result)
                HiddenEvent.errors = (HiddenEvent.errors or 0) + 1

                if HiddenEvent.errors % 20 == 1 and type(HiddenNotify) == "function" then
                    HiddenNotify("Error: " .. tostring(result):sub(1, 120), "error", "error")
                end
            end

            if type(CheckHiddenStall) == "function" then
                pcall(CheckHiddenStall)
            end
            
            local anchored = HiddenEvent.anchored
            if anchored then
                anchored = tick() - (HiddenEvent.holdTime or 0) > 0.6
            end

            if anchored and type(HiddenRelease) == "function" then
                HiddenRelease()
            end

            local str2 = tostring(HiddenEvent.step or "")
            if str2:find("^Waiting") or str2:find(" stirs on ") or str2 == "Idle" then
                task.wait(0.6)
            end
        end

        if type(HiddenRelease) == "function" then HiddenRelease() end
        HiddenEvent.running = false
    end)
end

-- Tạo Toggle chính xác thông qua UI Library của bạn
local bone = Tabs.Main:AddToggle({
    Name = "Auto Secret Quest", 
    Flag = "ClosetMons",
    Description = "Auto Complete Sea 1 Secret", 
    Default = false, 
    Callback = function(Value)
        _G.HiddEvent = Value
        fn(Value)
    end
})

-- [ADDED] Auto Farm Level from BananaCat Hub - placed above Farm Bone
-- [REWORK] GUI quest check + quest info + spawn flying: port tu BananaCat.lua
getgenv().AutoFarmLevel_Banana = false
getgenv().NameMobQuest_Banana = ""
getgenv().NameQuest_Banana = ""
getgenv().IDQuest_Banana = 0
getgenv().SpawnPointDelay = 0.8   -- delay sau khi toi spawn point
getgenv().SpawnPointLift = getgenv().SpawnPointLift or 30    -- Y + 30 truoc khi bay toi point tiep
getgenv().TableMobSpawn = getgenv().TableMobSpawn or {}

-- Boc trong do...end de khong an them local o top-level (gioi han 200 local / chunk)
do
    local Players = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")

    --==================== QUEST GUI CHECK (nguyen van BananaCat.lua) ====================
    -- V1 (PlayerGui.Main.Quest) + V2 (PlayerGui.TrackedQuestFrame)
    local function readText(inst)
        if not inst then return nil end
        if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
            return inst.Text ~= "" and inst.Text or nil
        end
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("TextLabel") and d.Text ~= "" then
                return d.Text
            end
        end
        return nil
    end

    function GetQuestTitle()
        local lp = Players.LocalPlayer
        local pg = lp and lp:FindFirstChild("PlayerGui")
        if not pg then return nil end
        -- V1
        local main = pg:FindFirstChild("Main") or pg:FindFirstChild("Main (minimal)")
        local q = main and main:FindFirstChild("Quest")
        if q and q.Visible then
            local c = q:FindFirstChild("Container")
            local qt = c and c:FindFirstChild("QuestTitle")
            local txt = readText(qt and qt:FindFirstChild("Title"))
            if txt then return txt end
        end
        -- V2
        local tr = pg:FindFirstChild("TrackedQuestFrame")
        if tr then
            local on = (tr:IsA("ScreenGui") and tr.Enabled) or (tr:IsA("GuiObject") and tr.Visible)
            local fr = tr:FindFirstChild("Frame")
            if on and fr and fr.Visible then
                return readText(fr:FindFirstChild("header"))
            end
        end
        return nil
    end

    local _rawHasQuest = function() return GetQuestTitle() ~= nil end
    local _questSeenUntil = 0
    function HasQuest()
        -- Giu trang thai "co quest" 1s sau lan cuoi thay UI, tranh doc UI luc dang animation/lag
        if _rawHasQuest() then
            _questSeenUntil = tick() + 1
            return true
        end
        return tick() < _questSeenUntil
    end
    local function ResetQuestSeen() _questSeenUntil = 0 end

    -- Lay TOAN BO text UI quest (V1 + V2) - port tu BananaCat.lua
    local function collectText(root)
        local out = {}
        if not root then return out end
        local function add(i)
            if (i:IsA("TextLabel") or i:IsA("TextButton") or i:IsA("TextBox")) and i.Text ~= "" then
                out[#out + 1] = i.Text
            end
        end
        add(root)
        for _, d in ipairs(root:GetDescendants()) do add(d) end
        return out
    end
    function GetQuestText()
        local pg = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return "" end
        local parts = {}
        local main = pg:FindFirstChild("Main") or pg:FindFirstChild("Main (minimal)")
        local q = main and main:FindFirstChild("Quest")
        if q and q.Visible then
            for _, s in ipairs(collectText(q)) do parts[#parts + 1] = s end
        end
        local tr = pg:FindFirstChild("TrackedQuestFrame")
        if tr then
            local on = (tr:IsA("ScreenGui") and tr.Enabled) or (tr:IsA("GuiObject") and tr.Visible)
            if on then
                for _, s in ipairs(collectText(tr)) do parts[#parts + 1] = s end
            end
        end
        return table.concat(parts, " | ")
    end

    -- alias cho code cu
    GetQuestTitle_Banana = GetQuestTitle
    HasQuest_Banana = HasQuest

    --==================== QUEST INFO (port tu BananaCat.lua: GuideModule.NPCList) ====================
    local Quests = require(RS:WaitForChild("Quests"))
    local Guide = require(RS:WaitForChild("GuideModule"))
    local excludeQuest = { "BartiloQuest", "Trainees", "MarineQuest", "CitizenQuest" }

    local function GetActiveQuestMob()
        local qd = Guide.Data and Guide.Data.QuestData
        if qd and qd.Task then
            return (next(qd.Task))
        end
        return nil
    end

    local function GetLevelQuestInfo(lvl)
        local curMob = GetActiveQuestMob()
        local lastLv, c = 0, {}
        local npcList = Guide.Data and Guide.Data.NPCList
        if not npcList then return c end
        for _, r in pairs(npcList) do
            if not table.find(excludeQuest, r.InternalQuestName) and Quests[r.InternalQuestName] then
                for qid, reqLv in pairs(r.Levels) do
                    local D = Quests[r.InternalQuestName][qid]
                    if D then
                        local mobName, cnt = next(D.Task)
                        if cnt and cnt > 1 and reqLv <= lvl and reqLv >= lastLv then
                            c = {
                                Level = reqLv,
                                Name = r.NPCName,
                                QuestName = r.InternalQuestName,
                                Pos = r.Position,
                                Id = qid,
                                Mob = mobName,
                                BaseMob = mobName,
                                Mobs = { mobName },
                            }
                            if qid > 1 then
                                local pq = Quests[r.InternalQuestName][qid - 1]
                                if pq and pq.Task then
                                    for pm, pc in pairs(pq.Task) do
                                        if pm ~= mobName and pc > 1 then
                                            table.insert(c.Mobs, pm)
                                            break
                                        end
                                    end
                                end
                            end
                            if curMob == mobName and qid > 1 then
                                local prev = Quests[r.InternalQuestName][qid - 1]
                                if prev and prev.Task then
                                    for pm, pc in pairs(prev.Task) do
                                        if pm ~= curMob and pc > 1 then
                                            c.Mob = pm
                                            c.Id = qid - 1
                                            break
                                        end
                                    end
                                end
                            end
                            lastLv = reqLv
                        end
                    end
                end
            end
        end
        return c
    end

    -- Tat ca ten mob co trong quest -> doc mob THAT cua quest dang giu tu GUI
    local AllQuestMobs = {}
    do
        local seen = {}
        for _, qs in pairs(Quests) do
            if typeof(qs) == "table" then
                for _, qd in pairs(qs) do
                    if typeof(qd) == "table" and qd.Task then
                        for mn, cnt in pairs(qd.Task) do
                            if cnt > 1 and not seen[mn] then
                                seen[mn] = true
                                table.insert(AllQuestMobs, mn)
                            end
                        end
                    end
                end
            end
        end
    end
    local function escPat(s) return (s:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")) end
    -- Tra ve ten mob (dai nhat khop) trong text quest GUI, nil neu khong doc duoc
    local function GetGuiQuestMob()
        local txt = GetQuestText():lower()
        if txt == "" then return nil end
        local best
        for _, mn in ipairs(AllQuestMobs) do
            if txt:find("%f[%w]" .. escPat(mn:lower()) .. "s?%f[%W]") then
                if not best or #mn > #best then best = mn end
            end
        end
        return best
    end

    --==================== SPAWN POINT (port tu BananaCat.lua) ====================
    local function stripLv(n) return (n:gsub(" %p?Lv%.? %d+%p?", "")) end

    local function DetectPartSpawnMob(name, skipIgnored)
        local base = string.find(name, "Lv.") and stripLv(name) or name
        local TableMobSpawn = getgenv().TableMobSpawn
        for _, F in pairs(TableMobSpawn) do
            if F:IsA("Part") then
                local J = string.find(F.Name, "Lv.") and stripLv(F.Name) or F.Name
                if (J == name or J == base) and (not skipIgnored or not F:FindFirstChild("Ignored")) then
                    return F
                end
            end
        end
        local es = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("EnemySpawns")
        if es then
            for _, F in pairs(es:GetChildren()) do
                if F:IsA("Part") then
                    local J = string.find(F.Name, "Lv.") and stripLv(F.Name) or F.Name
                    if (J == name or J == base) and (not skipIgnored or not F:FindFirstChild("Ignored")) then
                        table.insert(TableMobSpawn, F)
                        return F
                    end
                end
            end
        end
        if getnilinstances then
            local okN, nils = pcall(getnilinstances)
            if okN and nils then
                for _, F in pairs(nils) do
                    if F:IsA("Part") then
                        local J = string.find(F.Name, "Lv.") and stripLv(F.Name) or F.Name
                        if (J == name or J == base) and (not skipIgnored or not F:FindFirstChild("Ignored")) then
                            table.insert(TableMobSpawn, F)
                            return F
                        end
                    end
                end
            end
        end
        return nil
    end

    local function DeleteIgnoredMobSpawn()
        for _, V in pairs(getgenv().TableMobSpawn) do
            local ig = V:FindFirstChild("Ignored")
            if ig then ig:Destroy() end
        end
        local es = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("EnemySpawns")
        if es then
            for _, V in pairs(es:GetChildren()) do
                local ig = V:FindFirstChild("Ignored")
                if ig then ig:Destroy() end
            end
        end
    end
    getgenv().DeleteIgnoredMobSpawn = DeleteIgnoredMobSpawn

    --==================== HELPERS ====================
    local function HRP()
        local ch = Players.LocalPlayer.Character
        return ch and ch:FindFirstChild("HumanoidRootPart")
    end
    local function Alive()
        local ch = Players.LocalPlayer.Character
        local h = ch and ch:FindFirstChildOfClass("Humanoid")
        return h and h.Health > 0
    end
    local function FarmOn() return getgenv().AutoFarmLevel_Banana end

    local function FindMob(name)
        local hrp = HRP()
        local best, bestD = nil, math.huge
        for _, v in pairs(workspace.Enemies:GetChildren()) do
            if v.Name == name then
                local h = v:FindFirstChild("Humanoid")
                local r = v:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health > 0 then
                    local d = hrp and (r.Position - hrp.Position).Magnitude or 0
                    if d < bestD then best, bestD = v, d end
                end
            end
        end
        return best
    end

    -- Goi _tp 1 lan roi cho toi noi (tranh spam tween chong nhau)
    -- stopFn() tra true -> huy bay ngay
    local function FlyTo(cf, stopFn, closeDist)
        local hrp = HRP()
        if not hrp then return false end
        closeDist = closeDist or 8
        _tp(cf)
        local t0 = tick()
        local speed = math.max(getgenv().TweenSpeedFar or 170, 10)
        local maxT = (cf.Position - hrp.Position).Magnitude / speed + 5
        while tick() - t0 < maxT do
            task.wait(0.05)
            hrp = HRP()
            if not hrp or not Alive() then return false end
            if not FarmOn() or (stopFn and stopFn()) then
                shouldTween = false   -- _tp watcher se Cancel tween
                task.wait(0.15)
                return false
            end
            if (hrp.Position - cf.Position).Magnitude <= closeDist then
                return true
            end
        end
        shouldTween = false
        task.wait(0.15)
        return false
    end

    --==================== NHAN QUEST (port TakeQuestLevel) ====================
    local function TakeQuest(lvl)
        local info = GetLevelQuestInfo(lvl)
        if not info or not info.Pos then return end
        getgenv().NameMobQuest_Banana = info.Mob
        getgenv().NameQuest_Banana = info.QuestName
        getgenv().IDQuest_Banana = info.Id
        local pos = typeof(info.Pos) == "CFrame" and info.Pos.Position or info.Pos
        local hrp = HRP()
        if not hrp or not Alive() then return end
        if (pos - hrp.Position).Magnitude > 8 then
            FlyTo(CFrame.new(pos) * CFrame.new(0, 4, 2), nil, 8)
        end
        hrp = HRP()
        if hrp and (pos - hrp.Position).Magnitude <= 12 and Alive() then
            task.wait(2)
            RS.Remotes.CommF_:InvokeServer("StartQuest", tostring(info.QuestName), info.Id)
            -- cho GUI quest hien len roi moi farm
            for _ = 1, 20 do
                if HasQuest() then break end
                task.wait(0.15)
            end
        end
    end

    --==================== VONG FARM LEVEL DUY NHAT ====================
    local staleSince, lastAbandon = nil, 0
    local needLift = false   -- true sau khi da toi 1 spawn point ma van chua co mob

    task.spawn(function()
        while true do
            task.wait(0.15)
            if not FarmOn() then needLift = false; continue end
            pcall(function()
                local hrp = HRP()
                if not hrp or not Alive() then return end
                local lvl = Players.LocalPlayer.Data.Level.Value

                -- 1) chua co quest -> nhan quest
                if not HasQuest() then
                    needLift = false
                    TakeQuest(lvl)
                    return
                end

                -- 2) co quest -> xac dinh mob (uu tien mob cua quest dang giu, giong FarmMethod script 1)
                local info = GetLevelQuestInfo(lvl)
                if not info or not info.Mobs then return end
                local guiMob = GetGuiQuestMob()
                local valid = false
                if guiMob then
                    for _, m in ipairs(info.Mobs) do
                        if m == guiMob then valid = true break end
                    end
                end
                if not valid then
                    -- quest dang giu khong thuoc tier cua level hien tai (hoac chua doc duoc GUI)
                    staleSince = staleSince or tick()
                    if tick() - staleSince >= 1.5 and tick() - lastAbandon >= 3 then
                        lastAbandon = tick()
                        staleSince = nil
                        needLift = false
                        pcall(function() RS.Remotes.CommF_:InvokeServer("AbandonQuest") end)
                        ResetQuestSeen()
                        for _ = 1, 20 do
                            if not _rawHasQuest() then break end
                            task.wait(0.15)
                        end
                    end
                    return
                end
                staleSince = nil
                local mobName = guiMob
                _G.CurrentFarmMob = mobName

                local mob = FindMob(mobName)
                if mob then
                    needLift = false
                    repeat
                        task.wait()
                        Attack.Kill(mob, true)
                    until not FarmOn() or not Alive()
                        or not mob.Parent or not mob:FindFirstChild("Humanoid") or mob.Humanoid.Health <= 0
                        or not HasQuest()
                        or Players.LocalPlayer.Data.Level.Value ~= lvl
                    return
                end

                -- 3) het mob -> bay toi spawn point (logic script 1, khac cho Y)
                local part = DetectPartSpawnMob(mobName, true)
                if part then
                    Instance.new("IntValue", part).Name = "Ignored"   -- danh dau da toi, lan sau lay point tiep
                    if needLift then
                        -- tele len Y + 30 roi moi bay toi point tiep
                        local h = HRP()
                        if h then
                            shouldTween = false
                            h.CFrame = h.CFrame + Vector3.new(0, getgenv().SpawnPointLift or 30, 0)
                            task.wait(0.1)
                        end
                    end
                    -- bay thang toi point, khong cong them Y
                    FlyTo(part.CFrame, function() return FindMob(mobName) ~= nil end, 8)
                    -- delay tai point, co mob thi thoat som
                    local t0 = tick()
                    while tick() - t0 < (getgenv().SpawnPointDelay or 1) do
                        if not FarmOn() or FindMob(mobName) then break end
                        task.wait(0.1)
                    end
                    needLift = true
                else
                    -- het point chua toi -> reset co "Ignored" va lap lai
                    DeleteIgnoredMobSpawn()
                    needLift = false
                    -- fallback: neu khong tim duoc part nao thi bay toi spawn da luu cua script 2
                    local cf = GetSpawnCFrame and GetSpawnCFrame(mobName)
                    if cf then
                        FlyTo(cf, function() return FindMob(mobName) ~= nil end, 8)
                    end
                    task.wait(1)
                end
            end)
        end
    end)
end

-- [NEW] Banana Cat Style Farm - Replaces old Farm Bone/Level toggles
getgenv().BananaSettings = getgenv().BananaSettings or {
    SelectMethodFarm = "Level Farm",
    DistanceAura = 300,
    IgnoreKatakuri = false,
    HopKatakuri = false,
    AutoQuestKBT = false,
    StartFarm = false
}

local MethodList = {"Level Farm", "Farm Bones", "Farm Katakuri", "Farm Tyrant of the Skies", "Aura Farm"}


Tabs.Main:AddSection("Bones")

local bone = Tabs.Main:AddToggle({
    Name = "Auto Farm Bone", 
    Flag = "ClosetMons",
    Description = "", 
    Default = false, 
    Callback = function(Value)
        _G.AutoFarm_Bone = Value -- Đã sửa đúng tên biến cho khớp với vòng lặp bên dưới

        if not Value then
            getgenv().CurrentBoneTarget = nil
            getgenv().CurrentBoneName = nil
        end
    end
})

spawn(function()
    while true do
        task.wait(Sec or 0.5) -- Đảm bảo có giá trị mặc định nếu Sec chưa được định nghĩa
        if _G.AutoFarm_Bone then
            pcall(function()

                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local root = character:FindFirstChild("HumanoidRootPart")
                local questUI = player.PlayerGui.Main.Quest

                if not root then
                    return
                end

                local BonesTable = {
                    "Reborn Skeleton",
                    "Living Zombie",
                    "Demonic Soul",
                    "Posessed Mummy"
                }

                local enemies = workspace:FindFirstChild("Enemies")
                local boneTarget = nil

                if getgenv().CurrentBoneTarget and getgenv().CurrentBoneTarget.Parent then
                    local hum = getgenv().CurrentBoneTarget:FindFirstChild("Humanoid")

                    if hum and hum.Health > 0 then
                        boneTarget = getgenv().CurrentBoneTarget
                    else
                        getgenv().CurrentBoneTarget = nil
                        getgenv().CurrentBoneName = nil
                    end
                end

                if not boneTarget and enemies then
                    local closestDist = math.huge

                    for _, mob in pairs(enemies:GetChildren()) do
                        local hum = mob:FindFirstChild("Humanoid")
                        local mobRoot = mob:FindFirstChild("HumanoidRootPart")

                        local valid = false
                        for _, name in ipairs(BonesTable) do
                            if mob.Name == name then
                                valid = true
                                break
                            end
                        end

                        if valid and hum and mobRoot and hum.Health > 0 then
                            local dist = (mobRoot.Position - root.Position).Magnitude

                            if dist < closestDist then
                                closestDist = dist
                                boneTarget = mob
                                getgenv().CurrentBoneTarget = mob
                                getgenv().CurrentBoneName = mob.Name
                            end
                        end
                    end
                end

                if boneTarget then

                    if _G.AcceptQuestC and not questUI.Visible then

                        local questPos = CFrame.new(
                            -9516.99316,
                            172.017181,
                            6078.46533,
                            0,0,-1,
                            0,1,0,
                            1,0,0
                        )

                        _tp(questPos)

                        while (questPos.Position - root.Position).Magnitude > 50 do
                            task.wait(0.2)
                        end

                        local randomQuest = math.random(1,4)

                        local questData = {
                            [1] = {"StartQuest","HauntedQuest2",2},
                            [2] = {"StartQuest","HauntedQuest2",1},
                            [3] = {"StartQuest","HauntedQuest1",1},
                            [4] = {"StartQuest","HauntedQuest1",2}
                        }

                        pcall(function()
                            game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                                unpack(questData[randomQuest])
                            )
                        end)
                    end

                    repeat
                        task.wait()

                        if not boneTarget.Parent
                        or not boneTarget:FindFirstChild("Humanoid")
                        or boneTarget.Humanoid.Health <= 0 then
                            getgenv().CurrentBoneTarget = nil
                            getgenv().CurrentBoneName = nil
                            break
                        end

                        if boneTarget:FindFirstChild("HumanoidRootPart") then
                            _tp(boneTarget.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                        end

                        if Attack and Attack.Kill then
                            Attack.Kill(boneTarget, _G.AutoFarm_Bone)
                        end

                    until not _G.AutoFarm_Bone
                    or boneTarget.Humanoid.Health <= 0
                    or not boneTarget.Parent
                    or (_G.AcceptQuestC and not questUI.Visible)

                else

                    local nearMob = false

                    if enemies and root then
                        for _, mob in pairs(enemies:GetChildren()) do
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
                        _tp(CFrame.new(
                            -9495.6806640625,
                            453.58624267578125,
                            5977.3486328125
                        ))
                    end
                end

            end)
        end
    end
end)

local CakeQuestMapping = {
    ["Baking Staff"]   = {"StartQuest", "CakeQuest1", 1},
    ["Head Baker"]     = {"StartQuest", "CakeQuest1", 2},
    ["Cake Guard"]     = {"StartQuest", "CakeQuest2", 1},
    ["Cookie Crafter"] = {"StartQuest", "CakeQuest2", 2}
}

Tabs.Main:AddToggle({
Name = "Auto kill Soul Reaper", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoHytHallow = Value
end})
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
RanBone = Tabs.Main:AddToggle({
Name = "Auto Random Bones", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_Random_Bone = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Random_Bone then    
  	    repeat task.wait() replicated.Remotes.CommF_:InvokeServer("Bones","Buy",1,1) until not _G.Auto_Random_Bone
      end
    end)
  end
end)

Tabs.Main:AddSection("Ectoplasm")

Ecto = Tabs.Main:AddToggle({
Name = "Auto Farm Ectoplasm", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoEctoplasm = Value
end})
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

Tabs.Main:AddSection("Chest")

ChestTW = Tabs.Main:AddToggle({
Name = "Auto Chest [ Tween ]", 
Description = "1B Ez No Reset Level", 
Default = false,
Callback = function(Value)
  _G.AutoFarmChest = Value
end})
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

Berry = Tabs.Main:AddToggle({
Name = "Auto Collect Berries", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoBerry = Value
end})
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
 
 
Tabs.Main:AddSection("Bosses")

BossDropdown = Tabs.Main:AddDropdown({
		Name = "Boss List",
		Description = "",
		Options = BossList,
		Callback = function(value)
			_G.FindBoss = value
		end
		})

FarmBoss = Tabs.Main:AddToggle({
    Name = "Auto Kill Boss Selected",
    Description = "",
    Default = false,
    Callback = function(value)
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

FarmAllBoss = Tabs.Main:AddToggle({
   Name = "Auto Farm All Boss",
    Default = false,
Callback = function(Value)
    _G.AutoFarmAllBoss = Value
end})

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

BossQ = Tabs.Main:AddToggle({
    Name = "⚠️ Take Boss Quest",
    Description = "",
    Default = true,
    Callback = function(Value)
        _G.AcceptQuestBoss = Value
    end
})

Tabs.Main:AddSection("Material")

Test = Tabs.Main:AddDropdown({
Name = "Choose Material",
		Description = "",
		Options = MaterialList,
		Callback = function(Value)
			getgenv().SelectMaterial = Value
		end
		})
Toggle = Tabs.Main:AddToggle({
Name = "Auto Farm Materials", 
Description = "", 
Default = false,
Callback = function(Value)
    getgenv().AutoMaterial = Value
end})
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


Tabs.Main:AddSection("Mastery")

-- ===== KOKO MASTERY CORE 100% =====
_G.MasteryHealthPct = _G.MasteryHealthPct or 70
_G.SelectedMasterySkills = _G.SelectedMasterySkills or {Z=true,X=true,C=true,V=true,F=true}
HeartMastery = _G.MasteryHealthPct
SelectIsland = SelectIsland or "Cake"
HealthM = 0
MousePos = Vector3.new(0,0,0)
PosMon = Vector3.new(0,0,0)
SoulGuitar = false

-- mastery lists
if not mastery1 then mastery1 = {"Cookie Crafter"} end
if not mastery2 then mastery2 = {"Reborn Skeleton"} end

-- Fix GetConnectionEnemies 100% KOKO style
GetConnectionEnemies = function(a)
  for i,v in pairs(replicated:GetChildren()) do
    if v:IsA("Model") and ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
      return v
    end
  end
  for i,v in next,workspace.Enemies:GetChildren() do
    if v:IsA("Model") and ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
      return v
    end
  end
  return nil
end

-- Get all nearby enemies for Near mode
GetAllNearbyEnemies = function()
  local closest = nil
  local minDist = math.huge
  local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
  if not hrp then return nil end
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
      local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
      if d < minDist then
        minDist = d
        closest = v
      end
    end
  end
  return closest
end

-- Get spawn CFrame for mob name (for Near mode when no mob)
if not GetSpawnCFrame then
  GetSpawnCFrame = function(mobName)
    if PosMsList and PosMsList[mobName] then return PosMsList[mobName] end
    -- fallback check WorldOrigin EnemySpawns
    pcall(function()
      local spawns = workspace._WorldOrigin:FindFirstChild("EnemySpawns")
      if spawns then
        for _,sp in pairs(spawns:GetChildren()) do
          if sp.Name == mobName or string.find(sp.Name, mobName) then
            return sp.CFrame
          end
        end
      end
    end)
    return nil
  end
end

-- Ensure Attack table exists
if not Attack then Attack = {} end

-- KOKO Mas - Fruit mastery 100% - FIXED NO DROOP/DROP
Attack.Mas = function(v, enabled)
  if not v or not enabled then return end
  if not v:FindFirstChild("HumanoidRootPart") or not v:FindFirstChild("Humanoid") then return end
  if not v:GetAttribute("Locked") then
    v:SetAttribute("Locked", v.HumanoidRootPart.CFrame)
  end
  PosMon = v:GetAttribute("Locked").Position
  pcall(function() BringEnemy() end)
  if v.Humanoid.Health <= HealthM then
    -- FIX DROP: dùng GetSafeFarmCFrame nếu bật SafeFarm, không thì giữ độ cao 20 và bật noclip
    local targetCF = v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
    pcall(function()
      if getgenv().SafeFarmMode and typeof(GetSafeFarmCFrame)=="function" then
        targetCF = GetSafeFarmCFrame(v, false) or targetCF
      end
    end)
    _tp(targetCF)
    -- Anti drop - giữ shouldTween và OnFarm
    shouldTween = true
    getgenv().OnFarm = true
    local skills = _G.SelectedMasterySkills
    if type(skills) ~= "table" or next(skills)==nil then skills = {Z=true,X=true,C=true,V=true,F=true} end
    -- Dùng tất cả skill đã chọn, không phải 1 skill
    for k, val in pairs(skills) do
      local skillKey = nil
      if type(k)=="number" then skillKey = val
      elseif type(k)=="string" and val==true then skillKey = k end
      if skillKey then
        Useskills("Blox Fruit", skillKey)
        task.wait(0.15)
      end
    end
  else
    pcall(function() weaponSc("Melee") end)
    local meleeCF = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
    pcall(function()
      if getgenv().SafeFarmMode and typeof(GetSafeFarmCFrame)=="function" then
        meleeCF = GetSafeFarmCFrame(v, false) or meleeCF
      end
    end)
    _tp(meleeCF)
    shouldTween = true
    getgenv().OnFarm = true
  end
end

-- KOKO Masgun - Gun mastery 100% - FIXED NO DROP + MULTI SKILL
Attack.Masgun = function(v, enabled)
  if not v or not enabled then return end
  if not v:FindFirstChild("HumanoidRootPart") then return end
  if not v:GetAttribute("Locked") then
    v:SetAttribute("Locked", v.HumanoidRootPart.CFrame)
  end
  PosMon = v:GetAttribute("Locked").Position
  pcall(function() BringEnemy() end)
  if v.Humanoid.Health <= HealthM then
    local gunCF = v.HumanoidRootPart.CFrame * CFrame.new(0, 35, 8)
    pcall(function()
      if getgenv().SafeFarmMode and typeof(GetSafeFarmCFrame)=="function" then
        gunCF = GetSafeFarmCFrame(v, false) or gunCF
      end
    end)
    _tp(gunCF)
    shouldTween = true
    getgenv().OnFarm = true
    local skills = _G.SelectedMasterySkills
    if type(skills) ~= "table" or next(skills)==nil then skills = {Z=true,X=true,C=true,V=true,F=true} end
    for k, val in pairs(skills) do
      local skillKey = nil
      if type(k)=="number" then skillKey = val
      elseif type(k)=="string" and val==true then skillKey = k end
      if skillKey then
        Useskills("Gun", skillKey)
        task.wait(0.15)
      end
    end
  else
    pcall(function() weaponSc("Melee") end)
    local meleeCF = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
    pcall(function()
      if getgenv().SafeFarmMode and typeof(GetSafeFarmCFrame)=="function" then
        meleeCF = GetSafeFarmCFrame(v, false) or meleeCF
      end
    end)
    _tp(meleeCF)
    shouldTween = true
    getgenv().OnFarm = true
  end
end

-- KOKO Sword mastery 100% - FIXED NO DROP
Attack.Sword = function(v, enabled)
  if not v or not enabled then return end
  if not v:FindFirstChild("HumanoidRootPart") then return end
  if not v:GetAttribute("Locked") then
    v:SetAttribute("Locked", v.HumanoidRootPart.CFrame)
  end
  PosMon = v:GetAttribute("Locked").Position
  pcall(function() BringEnemy() end)
  pcall(function() weaponSc("Sword") end)
  local swordCF = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
  pcall(function()
    if getgenv().SafeFarmMode and typeof(GetSafeFarmCFrame)=="function" then
      swordCF = GetSafeFarmCFrame(v, false) or swordCF
    end
  end)
  _tp(swordCF)
  shouldTween = true
  getgenv().OnFarm = true
end

-- Level mode helper - use same logic as AutoFarm level but with mastery
GetLevelMob = function()
  -- simplified: find mob near level (use same as auto farm near but based on level)
  -- For real level mode, we will reuse CheckLevel or Quest
  local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
  if not hrp then return nil end
  -- try to get quest mob from Redz/ Skira level system
  if _G.CurrentFarmMob then
    return GetConnectionEnemies(_G.CurrentFarmMob)
  end
  return GetAllNearbyEnemies()
end

local posMastery = {"Cake","Bone","Near","Level"}
local skillOptions = {"Z","X","C","V","F"}

Tabs.Main:AddSlider({
  Name = "Select Enemy Health [ % ]",
  Description = "",
  Default = _G.MasteryHealthPct or 70,
  Min = 1, Max = 95, Rounding = 1,
  Callback = function(Value)
    HeartMastery = Value
    _G.MasteryHealthPct = Value
    print("[Mastery] Health %: "..Value)
  end
})

Tabs.Main:AddDropdown({
  Name = "Select Method Farm",
  Description = "",
  Options = posMastery,
  Default = "Cake",
  Callback = function(Value)
    SelectIsland = Value
    print("[Mastery] Island: "..Value)
  end
})


_G.SelectedMasterySkills = _G.SelectedMasterySkills or {Z=true,X=true,C=true,V=true,F=true}

-- Redz V5 remake hỗ trợ Multi = true / Multiselect = true, trả về bảng {Z=true,X=true,...}
-- Để tương thích mọi bản Redz, ta thử cả 2 cách
local MasterySkillDropdown = Tabs.Main:AddDropdown({
  Name = "Select Skill Mastery",
  Description = "",
  Options = {"Z","X","C","V","F"},
  Default = {"Z"},
  Multiselect = true,
  Multi = true,
  Callback = function(Value)
    print("[Mastery] Dropdown callback: "..tostring(Value))
    local newSkills = {}
    if type(Value) == "table" then
      -- Trường hợp Redz trả về array {"Z","X"} hoặc dict {Z=true, X=true}
      if #Value > 0 then
        for _, skillName in ipairs(Value) do
          if type(skillName)=="string" then newSkills[skillName]=true end
        end
      else
        -- dict style
        for k,v in pairs(Value) do
          if type(k)=="string" and v==true then
            newSkills[k]=true
          elseif type(v)=="string" then
            newSkills[v]=true
          end
        end
      end
    elseif type(Value) == "string" then
      newSkills[Value]=true
    end
    if next(newSkills) ~= nil then
      _G.SelectedMasterySkills = newSkills
      local list = {}
      for k,_ in pairs(newSkills) do table.insert(list,k) end
      print("[Mastery] Đã chọn skill: "..table.concat(list,", "))
    end
  end
})

-- Fix Redz không tự gọi callback lúc đầu -> set default
task.spawn(function()
  task.wait(1)
  if _G.SelectedMasterySkills and next(_G.SelectedMasterySkills) then
    print("[Mastery] Skills mặc định: Z,X,C,V,F")
  end
end)


_G.SelectedMasteryType = _G.SelectedMasteryType or {Fruits=true}
_G.FarmMastery = _G.FarmMastery or false
_G.FarmMastery_Dev = _G.FarmMastery_Dev or false
_G.FarmMastery_G = _G.FarmMastery_G or false
_G.FarmMastery_S = _G.FarmMastery_S or false

-- Dropdown chọn loại mastery: Fruits / Gun / Sword - có thể chọn nhiều loại cùng lúc
Tabs.Main:AddDropdown({
  Name = "Select Tools Mastery",
  Description = "",
  Options = {"Fruits", "Gun", "Sword"},
  Default = {"Fruits"},
  Multiselect = true,
  Multi = true,
  Callback = function(Value)
    local selected = {}
    if type(Value) == "table" then
      if #Value > 0 then
        for _, v in ipairs(Value) do
          if type(v)=="string" then selected[v]=true end
        end
      else
        for k,v in pairs(Value) do
          if type(k)=="string" and v==true then selected[k]=true
          elseif type(v)=="string" then selected[v]=true end
        end
      end
    elseif type(Value)=="string" then
      selected[Value]=true
    end
    if next(selected) then
      _G.SelectedMasteryType = selected
      local list={}
      for k,_ in pairs(selected) do table.insert(list,k) end
      print("[Mastery Type] Đã chọn: "..table.concat(list,", "))
      if _G.FarmMastery then
        _G.FarmMastery_Dev = selected["Fruits"] and true or false
        _G.FarmMastery_G = selected["Gun"] and true or false
        _G.FarmMastery_S = selected["Sword"] and true or false
      end
    end
  end
})

-- Toggle duy nhất để bật farm mastery
Tabs.Main:AddToggle({
  Name = "Auto Farm Mastery",
  Description = "Bật để farm mastery theo loại đã chọn ở trên",
  Default = false,
  Callback = function(Value)
    _G.FarmMastery = Value
    local sel = _G.SelectedMasteryType or {Fruits=true}
    if Value then
      _G.FarmMastery_Dev = sel["Fruits"] and true or false
      _G.FarmMastery_G = sel["Gun"] and true or false
      _G.FarmMastery_S = sel["Sword"] and true or false
      print("[Auto Farm Mastery] ON - Types: "..table.concat((function()
        local t={}
        for k,_ in pairs(sel) do table.insert(t,k) end
        return t
      end)(), ", "))
    else
      _G.FarmMastery_Dev = false
      _G.FarmMastery_G = false
      _G.FarmMastery_S = false
      print("[Auto Farm Mastery] OFF")
    end
  end
})

spawn(function()
  RunSer.RenderStepped:Connect(function()
    pcall(function()
      if _G.FarmMastery or _G.FarmMastery_Dev or _G.FarmMastery_G or _G.FarmMastery_S then
        for a,b in pairs(plr.PlayerGui.Notifications:GetChildren()) do
          if b.Name=="NotificationTemplate" and string.find(b.Text,"Skill locked!") then
            b:Destroy()
          end
        end
      end
    end)
  end)
end)

-- Fruits Mastery
spawn(function()
  while task.wait(0.1) do
    if _G.FarmMastery_Dev then
      pcall(function()
        local target = nil
        if SelectIsland == "Cake" then
          target = GetConnectionEnemies(mastery1)
          if not target then _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) return end
        elseif SelectIsland == "Bone" then
          target = GetConnectionEnemies(mastery2)
          if not target then _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) return end
        elseif SelectIsland == "Near" then
          target = GetAllNearbyEnemies()
          if not target then return end
        elseif SelectIsland == "Level" then
          Mastery_TakeQuestIfNeeded()
          target = GetLevelMob() or GetAllNearbyEnemies()
          if not target then return end
        end
        if target then
          _G.CurrentFarmMob = target.Name
          HealthM = target.Humanoid.MaxHealth * (_G.MasteryHealthPct/100)
          MousePos = target.HumanoidRootPart.Position
          repeat wait()
            MousePos = target.HumanoidRootPart.Position
            Attack.Mas(target,_G.FarmMastery_Dev)
          until _G.FarmMastery_Dev == false or not target.Parent or target.Humanoid.Health <= 0
        end
      end)
    end
  end
end)

-- Gun Mastery
spawn(function()
  while task.wait(0.1) do
    if _G.FarmMastery_G then
      pcall(function()
        local target = nil
        if SelectIsland == "Cake" then
          target = GetConnectionEnemies(mastery1)
          if not target then _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) return end
        elseif SelectIsland == "Bone" then
          target = GetConnectionEnemies(mastery2)
          if not target then _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) return end
        elseif SelectIsland == "Near" then
          target = GetAllNearbyEnemies()
          if not target then return end
        elseif SelectIsland == "Level" then
          Mastery_TakeQuestIfNeeded()
          target = GetLevelMob() or GetAllNearbyEnemies()
          if not target then return end
        end
        if target then
          HealthM = target.Humanoid.MaxHealth * (_G.MasteryHealthPct/100)
          repeat wait()
            MousePos = target.HumanoidRootPart.Position
            Attack.Masgun(target,_G.FarmMastery_G)
            local Modules = replicated:FindFirstChild("Modules")
            local Net = Modules and Modules:FindFirstChild("Net")
            local RE_ShootGunEvent = Net and Net:FindFirstChild("RE/ShootGunEvent")
            if plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").ToolTip == "Gun" then
              if plr.Character:FindFirstChildOfClass("Tool").Name == "Skull Guitar" then
                SoulGuitar = true
                plr.Character:FindFirstChildOfClass("Tool").RemoteEvent:FireServer("TAP", MousePos)
              else
                SoulGuitar = false
                if RE_ShootGunEvent then RE_ShootGunEvent:FireServer(MousePos, {target.HumanoidRootPart}) end
              end
              vim1:SendMouseButtonEvent(0,0,0,true,game,1);wait(0.05)
              vim1:SendMouseButtonEvent(0,0,0,false,game,1);wait(0.05)
            end
          until _G.FarmMastery_G == false or not target.Parent or target.Humanoid.Health <= 0
          SoulGuitar = false
        end
      end)
    end
  end
end)

-- Sword Mastery
spawn(function()
  while task.wait(0.1) do
    pcall(function()
      if _G.FarmMastery_S then
        local target = nil
        if SelectIsland == "Cake" then
          target = GetConnectionEnemies(mastery1)
          if not target then _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) return end
        elseif SelectIsland == "Bone" then
          target = GetConnectionEnemies(mastery2)
          if not target then _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) return end
        elseif SelectIsland == "Near" then
          target = GetAllNearbyEnemies()
          if not target then return end
        elseif SelectIsland == "Level" then
          Mastery_TakeQuestIfNeeded()
          target = GetLevelMob() or GetAllNearbyEnemies()
          if not target then return end
        end
        if target then
          local swordName = nil
          for _,v in next, replicated.Remotes.CommF_:InvokeServer("getInventory") do
            if type(v)=="table" and v.Type=="Sword" and tonumber(v.Mastery) and tonumber(v.Mastery) < 600 then swordName = v.Name break end
          end
          if swordName then
            if not GetBP(swordName) then
              replicated.Remotes.CommF_:InvokeServer("LoadItem", swordName)
            else
              repeat wait() Attack.Sword(target,_G.FarmMastery_S) until _G.FarmMastery_S == false or not target.Parent or target.Humanoid.Health <= 0
            end
          else
            repeat wait() Attack.Sword(target,_G.FarmMastery_S) until _G.FarmMastery_S == false or not target.Parent or target.Humanoid.Health <= 0
          end
        end
      end
    end)
  end
end)



-- Extra: Keep old AutoFarmNear code for reference and integrated
_G.AutoFarmNear = _G.AutoFarmNear or false




Tabs.Settings:AddSection("Job ID Tools")

Tabs.Settings:AddTextBox({
    Name = "Input Job Id",
    Placeholder = "Job ID",
    ClearOnFocus = true,
    Callback = function(Value)
        getgenv().Job = Value
    end
})

Tabs.Settings:AddButton({
    Name = "Join sever [Job ID]", 
    Callback = function()
        if getgenv().Job and getgenv().Job ~= "" then
            game:GetService("TeleportService")
                :TeleportToPlaceInstance(
                    game.PlaceId,
                    getgenv().Job,
                    game.Players.LocalPlayer
                )
        end
    end
})

Tabs.Settings:AddButton({
    Name = "Copy clipboard", 
    Description = "",
    Callback = function()
        setclipboard(tostring(game.JobId))
    end
})


Tabs.Settings:AddSection("Settings")

Tabs.Settings:AddDropdown({
    Name = "Farm Mode",
    Options = {"Up", "Orbit", "Star"},
    Default = getgenv().FarmMode,
    Callback = function(Value)
        getgenv().FarmMode = Value
        _G.FarmMode = Value
    end
})

Tabs.Settings:AddSlider({
    Name = "Farm Distance",
    Min = 2, Max = 50, Default = getgenv().FarmDistance, Rounding = 1,
    Callback = function(Value) getgenv().FarmDistance = Value; _G.FarmDistance = Value; DistanceFarmnear = Value end
})

Tabs.Settings:AddSlider({
    Name = "Farm Height [FIXED]",
    Min = 0, Max = 50, Default = getgenv().FarmHeight, Rounding = 1,
    Callback = function(Value) getgenv().FarmHeight = Value; _G.FarmHeight = Value end
})

Tabs.Settings:AddSlider({
    Name = "Speed Orbit [FIXED]",
    Min = 0.5, Max = 15, Default = getgenv().OrbitSpeed, Rounding = 1,
    Callback = function(Value) getgenv().OrbitSpeed = Value; _G.OrbitSpeed = Value end
})

Tabs.Settings:AddSlider({
    Name = "Speed Tween Near",
    Min = 50, Max = 1000, Default = getgenv().TweenSpeedNear or 190, Rounding = 0,
    Callback = function(Value) 
        getgenv().TweenSpeedNear = Value 
        getgenv().TweenSpeed = Value -- sync cho Beta H
        _G.TweenSpeedNear = Value
        print("[Tween] Speed Near: "..Value)
    end
})

Tabs.Settings:AddSlider({
    Name = "Speed Tween",
    Min = 50, Max = 1000, Default = getgenv().TweenSpeedFar or 170, Rounding = 0,
    Callback = function(Value) 
        getgenv().TweenSpeedFar = Value 
        getgenv().TweenSpeed = Value -- sync cho Beta H
        _G.TweenSpeedFar = Value
        print("[Tween] Speed Far: "..Value)
    end
})

Tabs.Settings:AddSlider({
    Name = "Dalay Auto Click",
    Min = 10, Max = 500, Default = getgenv().FlySpeed, Rounding = 1,
    Callback = function(Value) getgenv().FlySpeed = Value; _G.FlySpeed = Value; flySpeed = Value; pcall(function() updateFlySpeed(Value) end) end
})

Tabs.Settings:AddSlider({
    Name = "Bring Mob Distance",
    Min = 50, Max = 400, Default = getgenv().BringDistance, Rounding = 10,
    Callback = function(Value) getgenv().BringDistance = Value; _G.BringDistance = Value end
})

Tabs.Settings:AddSlider({
    Name = "Max Mobs Bring",
    Min = 1, Max = 30, Default = _G.MaxBringMobs or 15, Rounding = 1,
    Callback = function(Value) 
        _G.MaxBringMobs = Value 
        getgenv().MaxBringMobs = Value 
        _G.BringMobsCount = Value
    end
})


Tabs.Settings:AddSlider({
    Name = "Select Tween V2",
    Min = 50, Max = 500, Default = getgenv().OldTweenSpeed or 180, Rounding = 10,
    Callback = function(Value)
        getgenv().OldTweenSpeed = Value
        _G.OldTweenSpeed = Value
        print("[Tween Old] Toc do: "..Value.." (cao = cham, thap = nhanh)")
    end
})

Tabs.Settings:AddToggle({
    Name = "Tween V2",
    Description = "”",
    Default = getgenv().UseOldTween or false,
    Callback = function(Value)
        getgenv().UseOldTween = Value
        _G.UseOldTween = Value
        print("[Tween Old] Chuyen sang: "..(Value and "Block Tween Cu" or "HRP Tween Moi"))
    end
})

Tabs.Settings:AddToggle({
    Name = "Bring Mobs",
    Default = _G.BringMobs,
    Callback = function(Value)
        _G.BringMobs = Value
        getgenv().BringMobs = Value
    end
})




Initialize = Tabs.Settings:AddToggle({
Name = "Fast Attack", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Seriality = Value
end})


Initialize = Tabs.Settings:AddToggle({
Name = "x2 Speed if Have M1 - Not Eqiup Tools", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Seriality = Value
end})


Initialize = Tabs.Settings:AddToggle({
Name = "Slow Fast Attack", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Seriality = Value
end})

Initialize = Tabs.Settings:AddToggle({
Name = "Normal Fast attack", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Seriality = Value
end})

Tabs.Settings:AddToggle({
    Name = "Fast Attack 1 Mobs",
    Description = "",
    Default = True,
    Callback = function(Value)
        _G.FastAttack1Mob = Value
        getgenv().FastAttack1Mob = Value
        print("[Fast Attack 1 Mobs] " .. (Value and "BAT - Chi danh 1 con (van gom)" or "TAT - Danh nhieu con"))
    end
})

-- ========== TAKE QUEST DEBOUNCE - THÊM TỪ REDZ HUB ==========
getgenv().QuestDebounce = getgenv().QuestDebounce or true
getgenv().QuestDebounceTime = getgenv().QuestDebounceTime or 75 -- 75 giây như Redz Hub
_G.LastQuestTakeTime = _G.LastQuestTakeTime or 0
_G.LastQuestName = _G.LastQuestName or ""

-- Hàm kiểm tra có nên nhận quest không - Redz Hub logic
local function ShouldTakeQuest(questName, levelQuest)
    if not getgenv().QuestDebounce then
        return true -- Nếu tắt debounce thì luôn nhận quest
    end
    
    local currentTime = tick()
    local questId = questName .. tostring(levelQuest or "")
    
    -- Nếu quest khác quest trước thì luôn nhận
    if _G.LastQuestName ~= questId then
        _G.LastQuestName = questId
        _G.LastQuestTakeTime = currentTime
        return true
    end
    
    -- Nếu cùng quest, kiểm tra đã đủ 75s chưa
    if currentTime - _G.LastQuestTakeTime >= getgenv().QuestDebounceTime then
        _G.LastQuestTakeTime = currentTime
        return true
    end
    
    -- Chưa đủ 75s thì không nhận quest
    return false
end

-- Hàm nhận quest an toàn có debounce - Thay thế hàm nhận quest gốc
local OriginalTakeQuest = nil
local function TakeQuestWithDebounce(questName, levelQuest)
    pcall(function()
        if ShouldTakeQuest(questName, levelQuest) then
            -- Gọi hàm nhận quest gốc
            if OriginalTakeQuest then
                OriginalTakeQuest(questName, levelQuest)
            else
                -- Fallback: dùng CommF_ trực tiếp
                local args = {
                    [1] = "StartQuest",
                    [2] = questName,
                    [3] = levelQuest
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end
        else
            local waitTime = math.ceil(getgenv().QuestDebounceTime - (tick() - _G.LastQuestTakeTime))
            print("[QuestDebounce] Đợi " .. waitTime .. "s nữa mới nhận lại quest: " .. questName)
        end
    end)
end

-- Gắn vào global để các hàm farm khác dùng
getgenv().ShouldTakeQuest = ShouldTakeQuest
getgenv().TakeQuestWithDebounce = TakeQuestWithDebounce

-- Toggle Take Quest Debounce
Tabs.Settings:AddToggle({
    Name = "Take Quest Debounce",
    Description = "Wait 75 seconds to take the next mission - Thêm từ Redz Hub",
    Default = getgenv().QuestDebounce,
    Callback = function(Value)
        getgenv().QuestDebounce = Value
        print("[QuestDebounce] " .. (Value and "Bật - Đợi 75s mới nhận lại quest" or "Tắt - Nhận quest liên tục"))
    end
})

Tabs.Settings:AddSlider({
    Name = "Quest Debounce Time",
    Min = 10, Max = 120, Default = getgenv().QuestDebounceTime,
    Callback = function(Value)
        getgenv().QuestDebounceTime = Value
        print("[QuestDebounce] Thời gian đợi: " .. Value .. "s")
    end
})
-- ========== KẾT THÚC TAKE QUEST DEBOUNCE ==========




Tabs.Settings:AddSection("Safe Farm Mode")

Tabs.Settings:AddToggle({
    Name = "Safe Farm Mode",
    Description = "",
    Default = false,
    Callback = function(Value)
        getgenv().SafeFarmMode = Value
        _G.SafeFarmMode = Value
        if Settings then Settings["Safe Farm Mode"] = Value end
    end
})

Tabs.Settings:AddSlider({
    Name = "Safe Farm Distance",
    Min = 0, Max = 15, Default = 6,
    Callback = function(Value)
        getgenv().SafeFarmDistance = Value
        _G.SafeFarmDistance = Value
        if Settings then Settings["Safe Farm Distance"] = Value end
    end
})

Tabs.Settings:AddSlider({
    Name = "Safe Farm Tilt",
    Min = -15, Max = 15, Default = -6,
    Callback = function(Value)
        getgenv().SafeFarmTilt = Value
        _G.SafeFarmTilt = Value
        if Settings then Settings["Safe Farm Tilt"] = Value end
    end
})

Tabs.Settings:AddSlider({
    Name = "Safe Farm Height",
    Min = 0, Max = 50, Default = 22,
    Callback = function(Value)
        getgenv().SafeFarmHeight = Value
        _G.SafeFarmHeight = Value
        if Settings then Settings["Safe Farm Height"] = Value end
    end
})

Tabs.Settings:AddSlider({
    Name = "Safe Farm Straight",
    Min = -10, Max = 10, Default = 0,
    Callback = function(Value)
        getgenv().SafeFarmStraight = Value
        _G.SafeFarmStraight = Value
        if Settings then Settings["Safe Farm Straight"] = Value end
    end
})


Tabs.Settings:AddSection("Other Farm")

-- [ADDED] Dodge Skill Mob from Banana Cat Hub - placed in middle of Bring Mob settings
Tabs.Settings:AddToggle({
Name = "Auto Dodge Skill Mobs",
Description = "Automatically dodge mob skills (BodyGyro/BodyPosition) - from Banana Cat Hub",
Default = getgenv().AutoDodgeSkillMobs or false,
Callback = function(Value)
  getgenv().AutoDodgeSkillMobs = Value
end})


Tabs.Settings:AddToggle({
    Name = "Auto Set Spawn Point",
    Default = false,
    Callback = function(Value)
        getgenv().Set = Value
        if Value then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
            end)
        end
    end
})
BusuAura = Tabs.Settings:AddToggle({
Name = "Auto Turn on Buso", 
Description = "", 
Default = true,
Callback = function(Value)
  Boud = Value
end})
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
Tabs.Settings:AddToggle({
    Name = "Auto Haki Observation",
    Default = false,
    Callback = function(Value)
        getgenv().Observation = Value
    end
})
spawn(function()
    while wait() do
        if getgenv().Observation then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", true)
            end)
        end
    end
end)

Tabs.Settings:AddSection("Team")

Tabs.Settings:AddButton({
Name = "⚠️ Join Pirate Team", 
Description = "",
Callback = function()
  Pirates()
end})   
Tabs.Settings:AddButton({
Name = "⚠️ Join Marine Team", 
Description = "",
Callback = function()
  Marines()
end})

Tabs.Settings:AddSection("Race")

RaceV3Aura = Tabs.Settings:AddToggle({
Name = "Auto Active Race V3", 
Description = "", 
Default = false,
Flag = "AutoTurnonRaceV3",
Callback = function(Value)
  _G.RaceClickAutov3 = Value
end})
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
RaceV4Aura = Tabs.Settings:AddToggle({
Name = "Auto Active Race V4", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.RaceClickAutov4 = Value
end})
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

Tabs.Settings:AddSection("Menu")

-- ========== REDZ HUB BETA - 4 CHUC NANG PORT SANG SKITRINGX ==========
-- Lay tu Redzhub_beta_h.txt: Fish Index, Devil Fruit Shop, Advanced Fruit Dealer, Titles

Tabs.Settings:AddButton({
    Name = "Fish Index",
    Description = "Mo Fish Index - Port tu Redz Hub Beta",
    Callback = function()
        pcall(function()
            local plr = game.Players.LocalPlayer
            local pg = plr:WaitForChild("PlayerGui")
            -- Logic chuan Redz Beta: SetAttribute FishIndexVisible
            -- Redz Beta goc: PlayerGui:SetAttribute("FishIndexVisible", #PlayerGui:GetAttribute("FishIndexVisible"))
            -- Minh lam toggle chuan hon de hoat dong 100%
            local cur = pg:GetAttribute("FishIndexVisible")
            if cur == nil then cur = false end
            if type(cur) == "boolean" then
                pg:SetAttribute("FishIndexVisible", not cur)
            else
                -- Neu la so hoac string, toggle theo cach Redz
                pg:SetAttribute("FishIndexVisible", not pg:GetAttribute("FishIndexVisible"))
            end
            -- Backup: thu mo truc tiep UI
            task.wait(0.1)
            if pg.Main:FindFirstChild("FishIndex") then
                pg.Main.FishIndex.Visible = not pg.Main.FishIndex.Visible
            end
            -- Thu qua UIController neu co
            pcall(function()
                local uiController = pg.Main:FindFirstChild("UIController")
                if uiController and uiController:FindFirstChild("FishIndex") then
                    require(uiController.FishIndex):Open()
                end
            end)
        end)
    end
})

Tabs.Settings:AddButton({
    Name = "⚠️ Devil Fruit Shop",
    Description = "Devil Fruit Shop",
    Callback = function()
        pcall(function()
            -- Logic chuan Redz Beta: V.slots[upval_1]("FruitShop") + require(UIController.FruitShop):Open("FruitDealer")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            ReplicatedStorage.Remotes.CommF_:InvokeServer("GetFruits", false)
            local plr = game.Players.LocalPlayer
            local pg = plr:WaitForChild("PlayerGui")
            local uiController = pg.Main:FindFirstChild("UIController")
            if uiController and uiController:FindFirstChild("FruitShop") then
                local success, mod = pcall(function() return require(uiController.FruitShop) end)
                if success and mod and mod.Open then
                    mod:Open("FruitDealer")
                end
            end
            -- Fallback mo UI truc tiep
            if pg.Main:FindFirstChild("FruitShop") then
                pg.Main.FruitShop.Visible = true
            end
        end)
    end
})

Tabs.Settings:AddButton({
    Name = "⚠️ Advanced Fruit Dealer",
    Description = "Advanced Fruit Dealer",
    Callback = function()
        pcall(function()
            -- Logic chuan Redz Beta: require(UIController.FruitShop):Open("AdvancedFruitDealer")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            ReplicatedStorage.Remotes.CommF_:InvokeServer("GetFruits", true)
            ReplicatedStorage.Remotes.CommF_:InvokeServer("FruitShop2")
            local plr = game.Players.LocalPlayer
            local pg = plr:WaitForChild("PlayerGui")
            local uiController = pg.Main:FindFirstChild("UIController")
            if uiController and uiController:FindFirstChild("FruitShop") then
                local success, mod = pcall(function() return require(uiController.FruitShop) end)
                if success and mod and mod.Open then
                    mod:Open("AdvancedFruitDealer")
                end
            end
        end)
    end
})

Tabs.Settings:AddButton({
    Name = "⚠️ Titles",
    Description = "Titles",
    Callback = function()
        pcall(function()
            -- Logic chuan Redz Beta: getTitles + Titles.Visible = true
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            ReplicatedStorage.Remotes.CommF_:InvokeServer("getTitles")
            local plr = game.Players.LocalPlayer
            local pg = plr:WaitForChild("PlayerGui")
            if pg.Main:FindFirstChild("Titles") then
                pg.Main.Titles.Visible = true
            end
        end)
    end
})
-- ========== END REDZ HUB BETA 4 CHUC NANG ==========

Tabs.Settings:AddSection("Code Redeem X2 ESP - RESSET STATS")

Tabs.Settings:AddButton({
    Name = "Redeem All Codes",
    Description = "",
    Callback = function()
        local codes = {
            "LIGHTNINGABUSE","1LOSTADMIN","ADMINFIGHT","GIFTING_HOURS","NOMOREHACK",
            "BANEXPLOIT","WildDares","BossBuild","GetPranked","EARN_FRUITS",
            "SUB2GAMERROBOT_RESET1","KITT_RESET","Bignews","CHANDLER","Fudd10",
            "fudd10_v2","Sub2UncleKizaru","FIGHT4FRUIT","kittgaming","TRIPLEABUSE",
            "Sub2CaptainMaui","Sub2Fer999","Enyu_is_Pro","Magicbus","JCWK",
            "Starcodeheo","Bluxxy","SUB2GAMERROBOT_EXP1","Sub2NoobMaster123",
            "Sub2Daigrock","Axiore","TantaiGaming","StrawHatMaine","Sub2OfficialNoobie",
            "TheGreatAce","JULYUPDATE_RESET","ADMINHACKED","SEATROLLING","24NOADMIN",
            "ADMIN_TROLL","NEWTROLL","SECRET_ADMIN","staffbattle","NOEXPLOIT",
            "NOOB2ADMIN","CODESLIDE","fruitconcepts","krazydares"
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

Tabs.Settings:AddSection("Server")


Tabs.Settings:AddButton({
Name = "Rejoin Server", 
Description = "",
Callback = function()
  game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end})

Tabs.Settings:AddButton({
    Name = "Hop Server",
    Description = "",
    Callback = function()
        task.spawn(function()
            local HttpService = game:GetService("HttpService")
            local TeleportService = game:GetService("TeleportService")
            local PlaceId = game.PlaceId
            local Players = game:GetService("Players")

            local success, servers = pcall(function()
                local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
                local response = game:HttpGet(url)
                return HttpService:JSONDecode(response).data
            end)

            if success and servers then
                local targetServer
                for _, s in pairs(servers) do
                    if s.playing < s.maxPlayers then
                        targetServer = s.id
                    end
                end

                if targetServer then
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(PlaceId, targetServer, Players.LocalPlayer)
                    end)
                end
            end
        end)
    end
}) 



Tabs.Settings:AddSection("Local-Player")

-- From Redz Hub Beta - Speed Hack (only if not blacklisted executor)
local IsBlacklisted = false
pcall(function()
    -- Check executor blacklist like Redz Beta: V.slots[upval_8]:IsBlacklistedExecutor()
    -- Simple check for unsupported executors
    if (is_sirhurt_closure or is_synapse_function) then
        -- old executors might be blacklisted
    end
end)

if not IsBlacklisted then
    Tabs.Settings:AddToggle({
        Name = "Enable Speed Hack",
        Description = "Bypass walk speed",
        Default = false,
        Flag = "M-WalkSpeed:A",
        Callback = function(Value)
            _G.SpeedHackEnabled = Value
            getgenv().SpeedHackEnabled = Value
            pcall(function()
                local player = game.Players.LocalPlayer
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") then
                    if Value then
                        char.Humanoid.WalkSpeed = _G.WalkSpeedValue or 150
                    else
                        char.Humanoid.WalkSpeed = 16
                    end
                end
            end)
        end
    })

    Tabs.Settings:AddSlider({
        Name = "Walk Speed",
        Min = 10,
        Max = 300,
        Default = 150,
        Increase = 5,
        Flag = "M-WalkSpeed:B",
        Callback = function(Value)
            _G.WalkSpeedValue = Value
            getgenv().WalkSpeedValue = Value
            pcall(function()
                if _G.SpeedHackEnabled then
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then
                        char.Humanoid.WalkSpeed = Value
                    end
                end
            end)
        end
    })

    -- Keep WalkSpeed loop (Redz Beta style)
    task.spawn(function()
        while task.wait(0.1) do
            pcall(function()
                if _G.SpeedHackEnabled then
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then
                        if char.Humanoid.WalkSpeed ~= (_G.WalkSpeedValue or 150) then
                            char.Humanoid.WalkSpeed = _G.WalkSpeedValue or 150
                        end
                    end
                end
            end)
        end
    end)
end

Tabs.Settings:AddSection("Visual")

Tabs.Settings:AddButton({
Name = "Remove Fog", 
Description = "",
Callback = function()
  if Lighting:FindFirstChild("LightingLayers") then Lighting.LightingLayers:Destroy() end
  if Lighting:FindFirstChild("SeaTerrorCC") then Lighting.SeaTerrorCC:Destroy() end
  if Lighting:FindFirstChild("FantasySky") then Lighting.FantasySky:Destroy() end
end})

Tabs.Settings:AddSection("Script Settings")

-- From Redz Hub Beta - Ignore Script Errors
Tabs.Settings:AddToggle({
    Name = "Ignore Script Errors",
    Description = "does not break the script if an error occurs",
    Default = false,
    Flag = "IgnoreErrors",
    Callback = function(Value)
        getgenv().IgnoreErrors = Value
        _G.IgnoreErrors = Value
        getgenv().IgnoreScriptErrors = Value
        pcall(function()
            -- Redz Beta logic: V.slots[upval_22] IgnoreErrors
            if Value then
                print("[Redz Beta] Ignore Script Errors: ON")
            else
                print("[Redz Beta] Ignore Script Errors: OFF")
            end
        end)
    end
})

-- From Redz Hub Beta - Auto Rejoin
Tabs.Settings:AddToggle({
    Name = "Auto Rejoin",
    Description = "automatically re-enter the experience if you are removed",
    Default = false,
    Flag = "AutoRejoin",
    Callback = function(Value)
        getgenv().EnabledRejoin = Value
        _G.AutoRejoin = Value
        _G.EnabledRejoin = Value
        pcall(function()
            if Value then
                -- Auto rejoin logic from Redz Beta
                task.spawn(function()
                    local TeleportService = game:GetService("TeleportService")
                    local Players = game:GetService("Players")
                    local LocalPlayer = Players.LocalPlayer
                    
                    -- Monitor for removal
                    game:GetService("CoreGui").ChildAdded:Connect(function(child)
                        if _G.AutoRejoin and child.Name == "RobloxPromptGui" then
                            local prompt = child:FindFirstChild("promptOverlay")
                            if prompt then
                                local errorPrompt = prompt:FindFirstChild("ErrorPrompt")
                                if errorPrompt and errorPrompt:FindFirstChild("MessageArea") then
                                    task.wait(2)
                                    if _G.AutoRejoin then
                                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                                    end
                                end
                            end
                        end
                    end)
                    
                    -- On teleport fail, retry
                    LocalPlayer.OnTeleport:Connect(function(State)
                        if State == Enum.TeleportState.Failed then
                            if _G.AutoRejoin then
                                task.wait(2)
                                TeleportService:Teleport(game.PlaceId, LocalPlayer)
                            end
                        end
                    end)
                end)
            end
        end)
    end
})

Tabs.Settings:AddSection("More FPS")

DisableHitVFX = Tabs.Settings:AddToggle({
    Name = "Smooth Farm Mode",
    Description = "Removes slash and sword visual effects for better visibility",
    Default = false,
    Callback = function(Value)
        _G.DestroyHit = Value
    end
})

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
RmvVFX = Tabs.Settings:AddToggle({
Name = "Remove Death", 
Description = "", 
Default = false,
Callback = function(Value)
  RDeath = Value
end})
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
DisblesNotify = Tabs.Settings:AddToggle({
Name = "Remove Notifications", 
Description = "", 
Default = false,
Callback = function(Value)
  RemoveDamage = Value
end})
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

Tabs.Settings:AddSection("Anti Ban - Anti Resset")

Tabs.Settings:AddToggle({
    Name = "Anti AFK",
    Default = true,
    Callback = function(Value)
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

Tabs.Settings:AddToggle({
    Name = "Auto Anti - Admin Join Server",
    Description = "",
    Default = true,
    Callback = function(Value)
        getgenv().HopServerAdmin = Value
    end
})
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

Tabs.Settings:AddToggle({
    Name = "No Clip",
    Default = false,
    Callback = function(Value)
        getgenv().NoClip = Value
    end
})
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



-- ===== FISHING REDZ HUB - FIXED BUY ROD + BUY BAIT + AUTO FISHING WORKING =====
print("[Fishing] Loading Fixed Buy Rod + Buy Bait")

-- Correct Remotes - using ["RF/..."] path like original SkitringX
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local replicated = ReplicatedStorage
local Remotes = {
    RFCraft = replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/Craft"),
    RFJobs = replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/JobsRemoteFunction"),
    RFToolAbilities = replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/JobToolAbilities"),
    CommF = replicated:WaitForChild("Remotes"):WaitForChild("CommF_")
}

_G.SelectedRod = _G.SelectedRod or "Fishing Rod"
_G.SelectedBait = _G.SelectedBait or "Basic Bait"
_G.AutoBuyBait = false
_G.AutoFishing = false

Tabs.Fish:AddSection("Fishing")

Tabs.Fish:AddToggle({
    Name = "Auto Fishing",
    Description = "",
    Default = false,
    Callback = function(value) 
        _G.AutoFishing = value
        print("[Fishing] Auto Fishing:", value)
    end
})

-- Core fishing - WORKING
local FishReplicated = nil
local FishingRequest = nil
local Config = nil
local GetWaterHeight = nil
local MaxLaunchDistance = 100

task.spawn(function()
    pcall(function()
        FishReplicated = ReplicatedStorage:WaitForChild("FishReplicated", 10)
        if FishReplicated then
            FishingRequest = FishReplicated:WaitForChild("FishingRequest", 10)
            local FishingClient = FishReplicated:WaitForChild("FishingClient", 10)
            if FishingClient then
                local cfg = FishingClient:FindFirstChild("Config")
                if cfg then Config = require(cfg) MaxLaunchDistance = Config.Rod.MaxLaunchDistance or 100 end
            end
        end
        local Util = ReplicatedStorage:FindFirstChild("Util")
        if Util then
            local mod = Util:FindFirstChild("GetWaterHeightAtLocation")
            if mod then GetWaterHeight = require(mod) end
        end
        print("[Fishing] Remotes Loaded - MaxDist:", MaxLaunchDistance)
    end)
end)

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if _G.AutoBuyBait and _G.SelectedBait then
                Remotes.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
            end
        end)
    end
end)

task.spawn(function()
    task.wait(3)
    while task.wait(0.5) do
        if not _G.AutoFishing then continue end
        pcall(function()
            if not FishingRequest then
                FishReplicated = ReplicatedStorage:FindFirstChild("FishReplicated")
                if FishReplicated then FishingRequest = FishReplicated:FindFirstChild("FishingRequest") end
                if not FishingRequest then return end
            end
            
            local LocalPlayer = game.Players.LocalPlayer
            local Character = LocalPlayer.Character
            if not Character then return end
            local HRP = Character:FindFirstChild("HumanoidRootPart")
            local Head = Character:FindFirstChild("Head")
            local Humanoid = Character:FindFirstChild("Humanoid")
            if not HRP or not Head or not Humanoid then return end
            
            local CurrentTool = Character:FindFirstChildOfClass("Tool")
            if _G.SelectedRod and (not CurrentTool or CurrentTool.Name ~= _G.SelectedRod) then
                local rod = LocalPlayer.Backpack:FindFirstChild(_G.SelectedRod)
                if rod then
                    Humanoid:EquipTool(rod)
                    task.wait(0.3)
                    CurrentTool = Character:FindFirstChildOfClass("Tool")
                else
                    for _, t in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if t.Name:find("Rod") then Humanoid:EquipTool(t) CurrentTool = t break end
                    end
                end
            end
            
            if not CurrentTool then return end
            
            local waterY = HRP.Position.Y - 5
            if GetWaterHeight then pcall(function() waterY = GetWaterHeight(HRP.Position) end) end
            
            local hitPos = nil
            pcall(function()
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {Character, workspace:FindFirstChild("Characters"), workspace:FindFirstChild("Enemies")}
                params.FilterType = Enum.RaycastFilterType.Exclude
                local res = workspace:Raycast(Head.Position, HRP.CFrame.LookVector * MaxLaunchDistance, params)
                hitPos = res and res.Position or (Head.Position + HRP.CFrame.LookVector * 50)
            end)
            if not hitPos then hitPos = Head.Position + HRP.CFrame.LookVector * 50 end
            
            local castPos = Vector3.new(hitPos.X, math.max(hitPos.Y, waterY), hitPos.Z)
            
            if _G.VortexFish then
                pcall(function()
                    local vortex = nil
                    for _, v in pairs(workspace:GetChildren()) do
                        if v.Name:lower():find("vortex") and v:IsA("BasePart") then vortex = v break end
                    end
                    if vortex and (HRP.Position - vortex.Position).Magnitude > 15 then
                        HRP.CFrame = vortex.CFrame * CFrame.new(0,10,0)
                        task.wait(0.5)
                        castPos = vortex.Position
                    elseif vortex then
                        castPos = vortex.Position
                    end
                end)
            end
            
            local state = CurrentTool:GetAttribute("State")
            local serverState = CurrentTool:GetAttribute("ServerState")
            
            if castPos and (state == "ReeledIn" or serverState == "ReeledIn" or not state) then
                FishingRequest:InvokeServer("StartCasting")
                task.wait(0.2)
                FishingRequest:InvokeServer("CastLineAtLocation", castPos, 100, true)
            elseif serverState == "Biting" then
                FishingRequest:InvokeServer("Catching", true)
                task.wait(0.1)
                FishingRequest:InvokeServer("Catch", 1)
            end
        end)
    end
end)

Tabs.Fish:AddToggle({
    Name = "Fish in Vortex [ Spots ]",
    Default = false,
    Callback = function(v) _G.VortexFish = v if v then _G.AutoFishing = true end end
})

Tabs.Fish:AddButton({
    Name = "Save Fish Position",
    Callback = function()
        pcall(function()
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then _G.FishPositionSaved = hrp.CFrame print("[Fishing] Saved Position") end
        end)
    end
})


Tabs.Fish:AddSection("Bait")


Tabs.Fish:AddDropdown({
    Name = "Select Bait Multi",
    Options = {"Basic Bait", "Kelp Bait", "Good Bait", "Abyssal Bait", "Frozen Bait", "Epic Bait", "Carnivore Bait"},
    Default = {"Basic Bait"},
    MultiSelect = true,
    Callback = function(v) _G.SelectedBaits = v end
})

Tabs.Fish:AddSlider({
    Name = "Max Baits",
    Min = 10, Max = 90, Default = 90,
    Callback = function(v) _G.MaxBaits = v end
})

Tabs.Fish:AddToggle({
    Name = "Auto Buy Baits",
    Default = false,
    Callback = function(v) _G.BuyBaits = v; _G.AutoBuyBait = v end
})

Tabs.Fish:AddButton({
    Name = "Buy Baits Now",
    Callback = function()
        pcall(function()
            for _, bait in pairs(_G.SelectedBaits or {"Basic Bait"}) do
                Remotes.RFCraft:InvokeServer("Craft", bait, {})
                task.wait(0.2)
            end
        end)
    end
})

Tabs.Fish:AddSection("Quest")

Tabs.Fish:AddDropdown({
    Name = "Skip Quests",
    Options = {"Catch 5 Fish", "Catch 10 Fish", "Catch Legendary Fish", "Catch Mythical Fish"},
    Default = {},
    MultiSelect = true,
    Callback = function(v) _G.SkipQuests = v end
})

Tabs.Fish:AddToggle({
    Name = "Auto Quest [Skip, Get, Complete]",
    Default = false,
    Callback = function(v) _G.GetFishQuest = v; _G.AutoFishingQuest = v end
})

Tabs.Fish:AddDropdown({
    Name = "Select Fish Kind",
    Options = {"Normal", "Celestial", "All"},
    Default = {"Normal"},
    MultiSelect = true,
    Callback = function(v) _G.SellKind = v end
})

Tabs.Fish:AddToggle({
    Name = "Auto Sell Celestial Fish",
    Default = false,
    Callback = function(v) _G.AutoSellCelestial = v end
})

task.spawn(function()
    task.wait(3)
    while task.wait(5) do
        pcall(function()
            if _G.AutoSellCelestial then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("FishingNPC", "SellCelestialFish")
            end
        end)
    end
end)

Tabs.Fish:AddToggle({
    Name = "Auto Sell Fish",
    Description = "Fixed RFJobs path",
    Default = false,
    Callback = function(v) _G.AutoSellFish = v end
})

task.spawn(function()
    task.wait(3)
    while task.wait(5) do
        pcall(function()
            if _G.AutoSellFish and Remotes.RFJobs then
                Remotes.RFJobs:InvokeServer("FishingNPC", "SellFish")
            end
        end)
    end
end)

Tabs.Fish:AddToggle({
    Name = "Instant Catch",
    Default = false,
    Callback = function(v) _G.InstantCatch = v end
})

if not getgenv().BananaSettings then getgenv().BananaSettings = {} end
print("[Fishing] Fixed Buy Rod + Buy Bait - Working")


Tabs.Quests:AddSection("Dragon Dojo")
DojoQ = Tabs.Quests:AddToggle({
Name = "Auto Dojo Trainer Quest", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Dojoo = Value
end})
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
BlazeEM = Tabs.Quests:AddToggle({
Name = "Auto Dragon Hunter Quest", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.FarmBlazeEM = Value
end})
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


Tabs.Quests:AddSection("Farm")

EliteQ = Tabs.Quests:AddToggle({
    Name = "Auto Elite Hunter",
    Description = "",
    Default = false,
    Callback = function(Value)
    _G.FarmEliteHunt = Value
end})

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


Tabs.Quests:AddToggle({
Name = "Auto Rip Indra", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoRipIngay = Value
end})
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

Tabs.Quests:AddToggle({
    Name = "Auto Cake Prince",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Auto_Cake_Prince = Value

        if not Value then
            getgenv().BringMonster = false
            return
        end

        task.spawn(function()
            while _G.Auto_Cake_Prince do
                task.wait(0.1)

                pcall(function()
                    local player = game.Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local root = character:FindFirstChild("HumanoidRootPart")
                    local questUI = player.PlayerGui:FindFirstChild("Main") and player.PlayerGui.Main:FindFirstChild("Quest")
                    local enemies = workspace:FindFirstChild("Enemies")

                    if not root then return end

                    local mapCakeLoaf = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("CakeLoaf")
                    local bigMirror = mapCakeLoaf and mapCakeLoaf:FindFirstChild("BigMirror")

                    if not bigMirror or not bigMirror:FindFirstChild("Other") then
                        _tp(CFrame.new(-2077, 252, -12373))
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

                    if v and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then

                        -- Fix "nhảy bãi": Nhận Quest chính xác theo tên của quái target (v.Name)
                        if _G.AcceptQuestC and questUI and not questUI.Visible then
                            local questPos = CFrame.new(-1927.92, 37.8, -12842.54)
                            _tp(questPos)

                            local timeout = 0
                            while root and (questPos.Position - root.Position).Magnitude > 50 and timeout < 30 do
                                task.wait(0.2)
                                timeout = timeout + 1
                            end

                            local questData = CakeQuestMapping[v.Name]
                            if questData then
                                pcall(function()
                                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(questData))
                                end)
                            end
                        end

                        repeat
                            task.wait()
                            if Attack and Attack.Kill then
                                Attack.Kill(v, _G.Auto_Cake_Prince)
                            end
                        until not _G.Auto_Cake_Prince
                        or not v.Parent
                        or not v:FindFirstChild("Humanoid")
                        or v.Humanoid.Health <= 0
                        or (_G.AcceptQuestC and questUI and not questUI.Visible)

                    else

                        local nearMob = false
                        if enemies and root then
                            for _, mob in pairs(enemies:GetChildren()) do
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
                end)
            end
        end)
    end
})

local mobList = {
    "Serpent Hunter",
    "Skull Slayer",
    "Isle Champion",
    "Sun-kissed Warrior"
}

-- Hàm bổ trợ lấy target chuẩn xác (Ưu tiên Boss -> Khóa target cũ -> Tìm quái gần nhất)
local function GetTyrantTarget(root)
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil, false end

    -- 1. Ưu tiên hàng đầu: Boss Tyrant of the Skies
    local boss = enemies:FindFirstChild("Tyrant of the Skies")
    if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 and boss:FindFirstChild("HumanoidRootPart") then
        return boss, true
    end

    -- 2. Giữ nguyên quái đang đánh để tránh "nhảy bãi" liên tục
    if getgenv().CurrentTyrantTarget and getgenv().CurrentTyrantTarget.Parent then
        local target = getgenv().CurrentTyrantTarget
        local hum = target:FindFirstChild("Humanoid")
        if hum and hum.Health > 0 and target:FindFirstChild("HumanoidRootPart") then
            return target, false
        end
    end

    -- 3. Tìm quái mồi gần nhất nếu chưa có target
    local closestMob = nil
    local closestDist = math.huge

    for _, mob in pairs(enemies:GetChildren()) do
        local hum = mob:FindFirstChild("Humanoid")
        local mobRoot = mob:FindFirstChild("HumanoidRootPart")

        if hum and mobRoot and hum.Health > 0 then
            for _, name in ipairs(mobList) do
                if mob.Name == name then
                    local dist = (mobRoot.Position - root.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestMob = mob
                    end
                    break
                end
            end
        end
    end

    if closestMob then
        getgenv().CurrentTyrantTarget = closestMob
    end

    return closestMob, false
end

Tabs.Quests:AddToggle({
    Name = "Auto Dough King",
    Default = false,
    Callback = function(Value)
        _G.AutoDoughKing = Value
    end
})

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

Tabs.Quests:AddToggle({
    Name = "Auto Tyrant of the Skies",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.FarmTyrant = Value

        if not Value then
            getgenv().CurrentTyrantTarget = nil
            return
        end

        task.spawn(function()
            while _G.FarmTyrant do
                task.wait(0.1)

                pcall(function()
                    local player = game.Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local root = character:FindFirstChild("HumanoidRootPart")

                    if not root then return end

                    local target, isBoss = GetTyrantTarget(root)

                    if target and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("Humanoid") then
                        local mobRoot = target.HumanoidRootPart
                        local mobHum = target.Humanoid

                        -- Dịch chuyển đến vị trí đánh safe
                        local farmPos = mobRoot.CFrame * (FarmOffset and FarmOffset.Weapon or CFrame.new(0, 30, 0))
                        if typeof(GetFarmStandCFrame) == "function" then
                            farmPos = GetFarmStandCFrame(target) or farmPos
                        end

                        if (root.Position - mobRoot.Position).Magnitude > 50 then
                            _tp(farmPos)
                        end

                        -- Vòng lặp dứt điểm target
                        repeat
                            task.wait()
                            if not _G.FarmTyrant then break end

                            if mobRoot and root then
                                local currentFarmPos = mobRoot.CFrame * (FarmOffset and FarmOffset.Weapon or CFrame.new(0, 30, 0))
                                _tp(currentFarmPos)
                            end

                            if Attack and Attack.Kill then
                                Attack.Kill(target, _G.FarmTyrant)
                            end
                        until not _G.FarmTyrant
                        or not target.Parent
                        or not mobHum
                        or mobHum.Health <= 0
                        -- Tự động ngắt farm quái mồi ngay lập tức nếu Boss xuất hiện
                        or (not isBoss and workspace.Enemies:FindFirstChild("Tyrant of the Skies"))

                        if not target.Parent or mobHum.Health <= 0 then
                            getgenv().CurrentTyrantTarget = nil
                        end

                    else
                        -- Dịch chuyển về bãi đẻ quái/boss nếu chưa thấy target
                        local bossPos = CFrame.new(-16268.287, 152.616, 1390.773)
                        if (root.Position - bossPos.Position).Magnitude > 50 then
                            _tp(bossPos)
                        end
                    end
                end)
            end
        end)
    end
})


Tabs.Quests:AddSection("Swords")

Q = Tabs.Quests:AddToggle({
Name = "Auto Tushita", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_Tushita = Value
end})
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
Q = Tabs.Quests:AddToggle({
Name = "Auto Collect Yama", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_Yama = Value
end})
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

local CheckCDK = Tabs.Quests:AddParagraph("Number Cursed dual katana quests", "Quest Numbers :")
spawn(function()  
    while wait(0.2) do 
        if QuestYama_1 == true then 
            CheckCDK:SetDesc("Quest Numbers : yama quest 1") 
        elseif QuestYama_2 == true then
            CheckCDK:SetDesc("Quest Numbers : yama quest 2") 
        elseif QuestYama_3 == true then
            CheckCDK:SetDesc("Quest Numbers : yama quest 3") 
        elseif QuestTushita_1 == true then
            CheckCDK:SetDesc("Quest Numbers : tushita quest 1") 
        elseif QuestTushita_2 == true then
            CheckCDK:SetDesc("Quest Numbers : tushita quest 2") 
        elseif GetWP("Cursed Dual Katana") then
            CheckCDK:SetDesc("Quest Numbers : CDK done!!")
        end 
    end
end)
Q = Tabs.Quests:AddToggle({
Name = "Auto Cursed Dual katana [ Last Quest ]", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.CDK = Value
end})
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
Q = Tabs.Quests:AddToggle({
Name = "Auto Yama [ CDK ]", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.CDK_YM = Value
end})
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

Q = Tabs.Quests:AddToggle({
Name = "Auto Tushita [ CDk ]", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.CDK_TS = Value
end})
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

Tabs.Quests:AddSection("Bosses")

Q = Tabs.Quests:AddToggle({
Name = "Auto Darkbeard", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_Def_DarkCoat = Value
end})

Q = Tabs.Quests:AddToggle({
Name = "Auto Dark Blade V3", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.DarkBladev3 = Value
end})
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

Tabs.Quests:AddSection("Auto Fish Slap")

_G.MiNigame = Tabs.Quests:AddToggle({
  	Name="Auto Fish Slap",
	  Default=false,
  	Callback=function(v) _G.MiNigame=v end
 })

Players=game:GetService("Players")
RS=game:GetService("RunService")
LP=Players.LocalPlayer

local function getFishUI()
	local pg=LP:FindFirstChildOfClass("PlayerGui"); if not pg then return end
	local g=pg:FindFirstChild("FishSlapMinigame"); if not g then return end
	local bar=g:FindFirstChild("Bar"); if not bar then return end
	return bar:FindFirstChild("GreenZone"), bar:FindFirstChild("Tick"), g:FindFirstChild("SlapButton")
end

local function getContinueBtn()
	local pg=LP:FindFirstChildOfClass("PlayerGui"); if not pg then return end
	local cs=pg:FindFirstChild("ContinueScreen"); if not cs then return end
	return cs:FindFirstChild("Continue")
end

local function rect(o)
	if not (o and o.AbsoluteSize) then return end
	local p,s=o.AbsolutePosition,o.AbsoluteSize
	return p.X,p.Y,p.X+s.X,p.Y+s.Y
end

local function overlap(a,b)
	local ax1,ay1,ax2,ay2=rect(a); local bx1,by1,bx2,by2=rect(b)
	if not (ax1 and bx1) then return false end
	return ax1<bx2 and ax2>bx1 and ay1<by2 and ay2>by1
end

local function fire(btn)
	if not btn then return false end
	local ok=false
	pcall(function()
		if firesignal then
			local ev=btn.Activated or btn.MouseButton1Click
			if ev then firesignal(ev); ok=true end
		end
	end)
	if not ok then pcall(function() btn:Activate(); ok=true end) end
	return ok
end

if _G.__FishSlapConn then pcall(function() _G.__FishSlapConn:Disconnect() end) end

last,lastC,prev=0,0,false
_G.__FishSlapConn=RS.RenderStepped:Connect(function()
	if not _G.MiNigame then prev=false return end

	local gz,tk,btn=getFishUI()
	if gz and tk and btn then
		local over=overlap(tk,gz)
		local now=tick()
		if over and not prev and now-last>=0.03 then
			if fire(btn) then last=now end
		end
		prev=over
	else
		prev=false
	end

	local c=getContinueBtn()
	if c and c.Visible and tick()-lastC>=0.25 then
		if fire(c) then lastC=tick() end
	end
end)

Tabs.Info:AddSection("Soon")

Tabs.Quests:AddSection("Auto Raid Evens Fruits")

FactoryRaids = Tabs.Quests:AddToggle({
Name = "Auto Factory Raid", 
Description = "Sea 2", 
Default = false,
Callback = function(Value)
  _G.AutoFactory = Value
end})
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

CastleRaids = Tabs.Quests:AddToggle({
Name = "Auto Pirate Raid", 
Description = "Sea 3", 
Default = false,
Callback = function(Value)
  _G.AutoRaidCastle = Value
end})
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
                  repeat wait() Attack.Kill(v,_G.AutoRaidCastle) until not _G.AutoRaidCastle or not v.Parent or v.Humanoid.Health <= 0 or not workspace.Enemies:FindFirstChild(v.Name)
                end
              end
            end
          end
        else
          local Castle_Mob = {"Galley Pirate","Galley Captain","Raider","Mercenary","Vampire","Zombie","Snow Trooper","Winter Warrior","Lab Subordinate","Horned Warrior","Magma Ninja","Lava Pirate","Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior","Snow Lurker","Sea Soldier","Water Fighter"}
          for i = 1,#Castle_Mob do
            if replicated:FindFirstChild(Castle_Mob[i]) then
              for _,v in pairs(replicated:GetChildren()) do
                if table.find(Castle_Mob, v.Name) then _tp(CFrameCastleRaid) end
              end
            end
          end
        end
      end)
    end
  end
end)

Tabs.Quests:AddSection("Skull Guitars / Misc")
local CheckSoul = Tabs.Quests:AddParagraph("Skull Guitar Quests", "")
spawn(function()
    while wait(0.2) do
        pcall(function()
            if Quest1 == true then 
                CheckSoul:SetDesc("Quest Number : Quest1")
            elseif Quest2 == true then 
                CheckSoul:SetDesc("Quest Number : Quest2")
            elseif Quest3 == true then 
                CheckSoul:SetDesc("Quest Number : Quest3")
            elseif Quest4 == true then 
                CheckSoul:SetDesc("Quest Number : Quest4")
            elseif GetWP("Skull Guitar") then 
                CheckSoul:SetDesc("Quest Number : Collect!!")
            else 
                CheckSoul:SetDesc("Quest Number : No Quest!!")
            end
        end)
    end
end)
Tabs.Quests:AddToggle({
Name = "Auto Skull Guitar", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_Soul_Guitar = Value
end})
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


Tabs.Quests:AddSection("Mastery")

local MasterySword = Tabs.Quests:AddToggle({
Name = "Auto Mastery All Swords", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.FarmMastery_S = Value
end})
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


Tabs.Quests:AddSection("Quest")
Bartilo = Tabs.Quests:AddToggle({
Name = "Auto Bartilo Quest", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Bartilo_Quest = Value
end})
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
CitizenQ = Tabs.Quests:AddToggle({
Name = "Auto Citizen Quest", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.CitizenQuest = Value
end})
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
Q = Tabs.Quests:AddToggle({
Name = "Auto Training Dummy", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.DummyMan = Value
end})
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


Tabs.Quests:AddSection("Third Sea")
Q = Tabs.Quests:AddToggle({
Name = "Auto Unlocked Don Swan", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_DonAcces = Value
end})
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
Q = Tabs.Quests:AddToggle({
Name = "Auto Rainbow Haki", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_Rainbow_Haki = Value
end})
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
Q = Tabs.Quests:AddToggle({
Name = "Accept Rainbow Quest Faster", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.GetQFast = Value
end})
Q = Tabs.Quests:AddToggle({
Name = "Auto Kill Don Swan", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_SwanGG = Value
end})
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
Tabs.Quests:AddSection("Sword")
Q = Tabs.Quests:AddToggle({
Name = "Auto Buy Legendary Sword", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Tp_LgS = Value
end})
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

Tabs.Quests:AddSection("Race")

Q = Tabs.Quests:AddToggle({
Name = "Auto Cybrog", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoColShad = Value
end})
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

Tabs.Quests:AddSection("Rengoku")
Q = Tabs.Quests:AddToggle({
Name = "Auto Rengoku", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.IceBossRen = Value
end})
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
Q = Tabs.Quests:AddToggle({
Name = "Auto Key Rengoku", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.KeysRen = Value
end})
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
Tabs.Quests:AddSection("Item Ectoplasm")
Q = Tabs.Quests:AddToggle({
Name = "Auto Midnight Blade", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoEcBoss = Value
end})
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

Tabs.Quests:AddSection("Buso/Aura Colours")
Q = Tabs.Quests:AddToggle({
Name = "Auto Teleport Barista Cousin", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Tp_MasterA = Value
end})
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
Tabs.Quests:AddButton({
Name = "Buy Buso Colors", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("ColorsDealer","2")
end})

Tabs.Quests:AddSection("Instinct / Observation")
Q = Tabs.Quests:AddToggle({
Name = "Auto Farm Observation", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.obsFarm = Value
end})
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
Q = Tabs.Quests:AddToggle({
Name = "Auto Observation V2", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoKenVTWO = Value
end})
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



Tabs.Quests:AddSection("Fighting Melee Styles")
SuperHuman = Tabs.Quests:AddToggle({
Name = "Auto Superhuman", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_SuperHuman = Value
end})
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
DeathStep = Tabs.Quests:AddToggle({
Name = "Auto DeathStep", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoDeathStep = Value
end})
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
SharkManV2 = Tabs.Quests:AddToggle({
Name = "Auto Sharkman Karate", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_SharkMan_Karate = Value
end})
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
ElectricClaw = Tabs.Quests:AddToggle({
Name = "Auto ElectricClaw", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_Electric_Claw = Value
end})
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
DragonTalon = Tabs.Quests:AddToggle({
Name = "Auto DragonTalon", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoDragonTalon = Value
end})
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
Godhuman = Tabs.Quests:AddToggle({
Name = "Auto Godhuman", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_God_Human = Value
end})
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
SanguineArt = Tabs.Quests:AddToggle({
Name = "Auto SanguineArt", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Snaguine = Value
end})
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




-- ===== RACE V4 REPLACED - FROM USER CODE (converted to Redz UI) =====
Tabs.Race:AddSection("Teleport V4")

Tabs.Race:AddButton({
    Name = "Teleport To Top GreatTree",
    Callback = function()
        pcall(function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3030.39453125, 2280.6171875, -7320.18359375)
        end)
    end
})

Tabs.Race:AddButton({
    Name = "Teleport Temple Of Time",
    Callback = function()
        pcall(function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
        end)
    end
})

Tabs.Race:AddButton({
    Name = "Teleport Lever Pull",
    Callback = function()
        pcall(function()
            topos(CFrame.new(28575.181640625, 14936.6279296875, 72.31636810302734))
        end)
    end
})

Tabs.Race:AddButton({
    Name = "Teleport To The Clock",
    Callback = function()
        pcall(function()
            topos(CFrame.new(29553.7812, 15066.6133, -88.2750015, 1, 0, 0, 0, 1, 0, 0, 0, 1))
        end)
    end
})

Tabs.Race:AddSection("Trial V4")

Tabs.Race:AddButton({
    Name = "Auto Race Door",
    Callback = function()
        pcall(function()
            local hrp = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            hrp.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
            task.wait(0.1)
            hrp.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
            task.wait(0.1)
            hrp.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
            task.wait(0.1)
            hrp.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
            task.wait(0.5)
            local race = game:GetService("Players").LocalPlayer.Data.Race.Value
            if race == "Human" then
                topos(CFrame.new(29221.822265625, 14890.9755859375, -205.99114990234375))
            elseif race == "Fishman" then
                topos(CFrame.new(28231.17578125, 14890.9755859375, -211.64173889160156))
            elseif race == "Cyborg" then
                topos(CFrame.new(28502.681640625, 14895.9755859375, -423.7279357910156))
            elseif race == "Ghoul" then
                topos(CFrame.new(28674.244140625, 14890.6767578125, 445.4310607910156))
            elseif race == "Mink" then
                topos(CFrame.new(29012.341796875, 14890.9755859375, -380.1492614746094))
            elseif race == "Skypiea" then
                topos(CFrame.new(28960.158203125, 14919.6240234375, 235.03948974609375))
            end
        end)
    end
})

Tabs.Race:AddButton({
    Name = "Buy Ancient One Quest",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UpgradeRace", "Buy")
        end)
    end
})

Tabs.Race:AddToggle({
    Name = "Auto Trial Human Ghost",
    Default = false,
    Callback = function(Value)
        _G.Kill_Aura = Value
        pcall(function() StopTween(_G.Kill_Aura) end)
    end
})

Tabs.Race:AddToggle({
    Name = "Auto Trial All Race",
    Default = false,
    Callback = function(Value)
        _G.AutoQuestRace = Value
        pcall(function() StopTween(_G.AutoQuestRace) end)
    end
})

local Pos = CFrame.new(0, 3, 0)

spawn(function()
    while task.wait() do
        if _G.AutoQuestRace then
            pcall(function()
                local race = game:GetService("Players").LocalPlayer.Data.Race.Value
                if race == "Human" then
                    for _, v in pairs(game.Workspace.Enemies:GetDescendants()) do
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat task.wait(0.1)
                                pcall(function() v.Humanoid.Health = 0 end)
                                v.HumanoidRootPart.CanCollide = false
                                pcall(function() sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge) end)
                            until not _G.AutoQuestRace or not v.Parent or v.Humanoid.Health <= 0
                        end
                    end
                elseif race == "Skypiea" then
                    for _, v in pairs(game:GetService("Workspace").Map.SkyTrial.Model:GetDescendants()) do
                        if v.Name == "snowisland_Cylinder.081" then
                            topos(v.CFrame * CFrame.new(0, 0, 0))
                        end
                    end
                elseif race == "Fishman" then
                    if workspace:FindFirstChild("SeaBeasts") and workspace.SeaBeasts:FindFirstChild("SeaBeast1") then
                        for _, v in pairs(workspace.SeaBeasts.SeaBeast1:GetDescendants()) do
                            if v.Name == "HumanoidRootPart" then
                                topos(v.CFrame * Pos)
                                for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                    if tool:IsA("Tool") and tool.ToolTip == "Melee" then
                                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
                                    end
                                end
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game)
                                task.wait(0.2)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game)
                                task.wait(0.2)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game)
                                task.wait(0.5)
                                for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                    if tool:IsA("Tool") and tool.ToolTip == "Sword" then
                                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
                                    end
                                end
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game)
                                task.wait(0.2)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game)
                                task.wait(0.2)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game)
                                task.wait(0.5)
                                for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                    if tool:IsA("Tool") and tool.ToolTip == "Gun" then
                                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
                                    end
                                end
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game)
                                task.wait(0.2)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game)
                                task.wait(0.2)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game)
                            end
                        end
                    end
                elseif race == "Cyborg" then
                    topos(CFrame.new(28654, 14898.7832, -30, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif race == "Ghoul" then
                    for _, v in pairs(workspace.Enemies:GetDescendants()) do
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat task.wait(0.1)
                                v.Humanoid.Health = 0
                                v.HumanoidRootPart.CanCollide = false
                                pcall(function() sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge) end)
                            until not _G.AutoQuestRace or not v.Parent or v.Humanoid.Health <= 0
                        end
                    end
                elseif race == "Mink" then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v.Name == "StartPoint" then
                            topos(v.CFrame * CFrame.new(0, 3, 0))
                            _G.AutoQuestRace = false
                            pcall(function() StopTween(_G.AutoQuestRace) end)
                        end
                    end
                end
            end)
        end
    end
end)

Tabs.Race:AddToggle({
    Name = "Auto Kill Player after Trial V4",
    Default = false,
    Callback = function(Value)
        _G.AutoKillV4 = Value
        pcall(function() StopTween(_G.AutoKillV4) end)
    end
})

spawn(function()
    while task.wait() do
        if _G.AutoKillV4 then
            pcall(function()
                for _, v in pairs(workspace.Characters:GetChildren()) do
                    if v.Name ~= game.Players.LocalPlayer.Name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v.Parent and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude <= 230 then
                        repeat task.wait()
                            pcall(function() AutoHaki() end)
                            pcall(function() EquipWeapon(_G.SelectWeapon) end)
                            topos(v.HumanoidRootPart.CFrame * CFrame.new(1, 1, 2))
                            v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.Humanoid.WalkSpeed = 0
                            pcall(function() sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge) end)
                        until not _G.AutoKillV4 or v.Humanoid.Health <= 0 or not v.Parent or not v:FindFirstChild("HumanoidRootPart") or not v:FindFirstChild("Humanoid")
                    end
                end
            end)
        end
    end
end)

Tabs.Race:AddSection("Auto Skill")

Tabs.Race:AddToggle({
    Name = "Auto Skill Z",
    Default = false,
    Callback = function(Value)
        _G.XaiSkillZ = Value
        pcall(function() StopTween(_G.XaiSkillZ) end)
    end
})

Tabs.Race:AddToggle({
    Name = "Auto Skill X",
    Default = false,
    Callback = function(Value)
        _G.XaiSkillX = Value
        pcall(function() StopTween(_G.XaiSkillX) end)
    end
})

Tabs.Race:AddToggle({
    Name = "Auto Skill C",
    Default = false,
    Callback = function(Value)
        _G.XaiSkillC = Value
        pcall(function() StopTween(_G.XaiSkillC) end)
    end
})

spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if _G.XaiSkillZ then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                task.wait(0.05)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "Z", false, game)
            end
            if _G.XaiSkillX then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "X", false, game)
                task.wait(0.05)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "X", false, game)
            end
            if _G.XaiSkillC then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "C", false, game)
                task.wait(0.05)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "C", false, game)
            end
        end)
    end
end)


Tabs.Prehistoric:AddSection("Islands Stats")


local MirageCheck = Tabs.Prehistoric:AddParagraph("Mirage Island", "Status: ")

local previousMirageStatus = ""
spawn(function()
    pcall(function()
        while true do
            wait(1)            
            local mirageIslandExists = game.Workspace._WorldOrigin.Locations:FindFirstChild('Mirage Island') ~= nil
            local currentStatus = mirageIslandExists and '✅' or '❌'
            if currentStatus ~= previousMirageStatus then
                MirageCheck:SetDesc('Status: ' .. currentStatus)
                previousMirageStatus = currentStatus
            end
        end
    end)
end)

local KitsuneCheck = Tabs.Prehistoric:AddParagraph("Kitsune Island", "Status: ")

local previousKitsuneStatus = ""
spawn(function()
    while task.wait(1) do
        local currentStatus = game:GetService("Workspace").Map:FindFirstChild("KitsuneIsland") and '✅' or '❌'
        if currentStatus ~= previousKitsuneStatus then
            KitsuneCheck:SetDesc('Status: ' .. currentStatus)
            previousKitsuneStatus = currentStatus
        end
    end
end)

local PrehistoricCheck = Tabs.Prehistoric:AddParagraph("Prehistoric Island", "Status: ")

local previousPrehistoricStatus = ""
task.spawn(function()
    while task.wait(1) do
        local currentStatus = game.Workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") and '✅' or '❌'
        if currentStatus ~= previousPrehistoricStatus then
            PrehistoricCheck:SetDesc("Status: " .. currentStatus)
            previousPrehistoricStatus = currentStatus
        end
    end
end)

local FrozenCheck = Tabs.Prehistoric:AddParagraph("Frozen Dimension", "Status: ")

local previousFrozenStatus = ""
spawn(function()
    while wait(1) do
        local currentStatus = game.Workspace._WorldOrigin.Locations:FindFirstChild('Frozen Dimension') and '✅' or '❌'
        if currentStatus ~= previousFrozenStatus then
            FrozenCheck:SetDesc('Status: ' .. currentStatus)
            previousFrozenStatus = currentStatus
        end
    end
end)

Tabs.Prehistoric:AddSection("Prehistoric Island")

Tabs.Prehistoric:AddToggle({
    Name = "Craft Volcanic Magnet",
    Default = false,
    Callback = function(Value)
        getgenv().AutoCraftVolcanic = Value
    end
})

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


Tabs.Prehistoric:AddButton({
    Name = "Craft Volcanic Magnet",
    Callback = function()
        local RF = game:GetService("ReplicatedStorage").Modules.Net["RF/Craft"]

        RF:InvokeServer(
            "PossibleHardcode",
            "Volcanic Magnet"
        )
    end
})


Tabs.Prehistoric:AddToggle({
    Name = "Auto Find Prehistoric Island",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Prehis_Find = Value
    end
})

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

Tabs.Prehistoric:AddToggle({
    Name = "Auto Start Prehistoric Event",
    Default = false,
    Callback = function(Value)
        _G.AutoStartPrehistoric = Value
    end
})
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




Tabs.Prehistoric:AddToggle({
    Name = "Auto Patch Prehistoric Event",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Prehis_Skills = Value
    end
})



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

Kaura = Tabs.Prehistoric:AddToggle({
    Name = "Kill Aura",
    Description = "",
    Default = false,
    Callback = function(Value)
    _G.KillAuraFull = Value
end})

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
Vocan = Tabs.Prehistoric:AddToggle({
Name = "Auto Collect Dino Bones", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Prehis_DB = Value
end})
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
Vocan = Tabs.Prehistoric:AddToggle({
Name = "Auto Collect Dragon Eggs", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Prehis_DE = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Prehis_DE then
      if workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:FindFirstChild("DragonEgg") then _tp(workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:FindFirstChild("DragonEgg").Molten.CFrame) fireproximityprompt(workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs.DragonEgg.Molten.ProximityPrompt, 30) end        
      end
    end)
  end
end)
Toggle = Tabs.Prehistoric:AddToggle({
Name = "Auto Reset When Complete Volcano", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.ResetPH = Value
end})
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






-- ========== CHUYEN TU TAB SEA SANG PREHISTORIC THEO YEU CAU - DUOI AUTO RESET VOLCANO ==========

Tabs.Prehistoric:AddSection("Leviathan [BETA]")

Tabs.Prehistoric:AddToggle({
    Name = "Auto Attack Leviathan",
    Description = "",
    Default = getgenv().AutoLeviathan or false,
    Callback = function(Value)
        getgenv().AutoLeviathan = Value
        _G.AutoLeviathan = Value
        if Value then
            Window:Notify({Title="Leviathan", Content="Bat Auto Attack Leviathan", Duration=3})
        end
    end
})

Tabs.Prehistoric:AddSection("Kitsune Island")

Tabs.Prehistoric:AddSlider({
    Name = "Trade Azure Ember Amount",
    Min = 10, Max = 25, Default = getgenv().Azure or 20,
    Callback = function(Value)
        getgenv().Azure = Value
        _G.Azure = Value
    end
})

Tabs.Prehistoric:AddToggle({
    Name = "Auto Trade Azure Ember",
    Description = "",
    Default = getgenv().TradeAzureEmber or false,
    Callback = function(Value)
        getgenv().TradeAzureEmber = Value
    end
})

Tabs.Prehistoric:AddToggle({
    Name = "Auto Kitsune Island",
    Description = "",
    Default = getgenv().KitsuneIsland or false,
    Callback = function(Value)
        getgenv().KitsuneIsland = Value
        _G.KitsuneIsland = Value
    end
})

Tabs.Prehistoric:AddSection("Mirage Island")

Tabs.Prehistoric:AddToggle({
    Name = "Teleport To Gear",
    Description = "",
    Default = getgenv().MirageGear or false,
    Callback = function(Value)
        getgenv().MirageGear = Value
    end
})

Tabs.Prehistoric:AddToggle({
    Name = "Teleport To Mirage",
    Description = "",
    Default = getgenv().TeleportMirage or false,
    Callback = function(Value)
        getgenv().TeleportMirage = Value
    end
})

Tabs.Prehistoric:AddToggle({
    Name = "Collect Mirage Chests",
    Description = "",
    Default = getgenv().MirageChests or false,
    Callback = function(Value)
        getgenv().MirageChests = Value
    end
})

Tabs.Prehistoric:AddToggle({
    Name = "Look To Moon",
    Description = "",
    Default = getgenv().MirageLookMoon or false,
    Callback = function(Value)
        getgenv().MirageLookMoon = Value
    end
})

-- ========== KET THUC CHUYEN TU SEA SANG PREHISTORIC ==========




-- ========== FIX F9 - Humanoid Vampire + Memory ==========
pcall(function()
    getgenv().QuestDebounce = getgenv().QuestDebounce or true
    getgenv().QuestDebounceTime = getgenv().QuestDebounceTime or 75
    _G.LastQuestTakeTime = _G.LastQuestTakeTime or 0
    _G.LastQuestName = _G.LastQuestName or ""
    getgenv().BringMobs = getgenv().BringMobs == nil and true or getgenv().BringMobs
    getgenv().FarmDistance = getgenv().FarmDistance or 15
    getgenv().BringDistance = getgenv().BringDistance or 400
    getgenv().TweenSpeed = getgenv().TweenSpeed or 200
    getgenv().AutoFarmSea = getgenv().AutoFarmSea or false
    getgenv().autoDriveBoat = getgenv().autoDriveBoat or false
    getgenv().BoatSpeed = getgenv().BoatSpeed or 250
    getgenv().RepairBoat = getgenv().RepairBoat or false
    getgenv().SeaLevel = getgenv().SeaLevel or "6"
    getgenv().fishSelected = getgenv().fishSelected or {"Sea Beast", "Terrorshark"}
end)

-- ========== CORE FUNCTIONS REDZ BETA SEA ==========
function CheckBoat_Redz()
    local ownerName = game.Players.LocalPlayer.Name
    for _, boat in pairs(workspace.Boats:GetChildren()) do
        if boat:IsA("Model") and boat:FindFirstChild("Owner") and tostring(boat.Owner.Value) == ownerName and boat:FindFirstChild("Humanoid") and boat.Humanoid.Value > 0 then
            return boat
        end
    end
    return false
end

function GetSeaMobs_Redz()
    local mobs = {}
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local name = v.Name
            if name:find("Sea") or name == "Terrorshark" or name:find("Shark") or name:find("Piranha") or name:find("Fish") or name:find("Brigade") or name:find("Ghost") then
                table.insert(mobs, v)
            end
        end
    end
    return mobs
end

-- ========== REDZ BETA SEA TAB UI - NGUYÊN BẢN ==========

Tabs.SeaEvent:AddSection("Farm")

Tabs.SeaEvent:AddToggle({
    Name = "Auto Farm Sea",
    Description = "",
    Default = getgenv().AutoFarmSea or false,
    Callback = function(Value)
        getgenv().AutoFarmSea = Value
        _G.AutoFarmSea = Value
        if Value then
            Window:Notify({Title="Sea Event", Content="Bật Auto Farm Sea - Redz Beta", Duration=3})
        end
    end
})

Tabs.SeaEvent:AddToggle({
    Name = "Auto Drive Boat",
    Description = "",
    Default = getgenv().autoDriveBoat or false,
    Callback = function(Value)
        getgenv().autoDriveBoat = Value
        _G.autoDriveBoat = Value
    end
})

Tabs.SeaEvent:AddSection("Preset")

Tabs.SeaEvent:AddDropdown({
    Name = "Fish",
    Description = "",
    Options = {"Sea Beast", "Terrorshark", "Fish Crew Member", "Piranha", "Shark", "PirateBrigade", "PirateGrandBrigade", "GhostShip"},
    Default = {"Sea Beast", "Terrorshark"},
    MaxSelect = 8,
    Multi = true,
    Callback = function(Value)
        getgenv().fishSelected = Value
        _G.fishSelected = Value
    end
})

Tabs.SeaEvent:AddDropdown({
    Name = "Boats",
    Description = "",
    Options = {"PirateBrigade", "PirateGrandBrigade", "GhostShip", "FishBoat", "Beast Hunter", "Guardian"},
    Default = {"PirateBrigade"},
    MaxSelect = 6,
    Multi = true,
    Callback = function(Value)
        getgenv().boatSelected = Value
    end
})

Tabs.SeaEvent:AddDropdown({
    Name = "Select Skills",
    Description = "",
    Options = {"Z", "X", "C", "V", "F"},
    Default = {"F", "C", "X", "Z"},
    MaxSelect = 9,
    Multi = true,
    Callback = function(Value)
        getgenv().SeaSkills = Value
    end
})

Tabs.SeaEvent:AddSection("Configs")

Tabs.SeaEvent:AddDropdown({
    Name = "Sea Level",
    Description = "",
    Options = {"1", "2", "3", "4", "5", "6", "inf"},
    Default = getgenv().SeaLevel or "6",
    Callback = function(Value)
        getgenv().SeaLevel = Value
        _G.SeaLevel = Value
    end
})

Tabs.SeaEvent:AddSlider({
    Name = "Boat Tween Speed",
    Min = 100, Max = 300, Default = getgenv().BoatSpeed or 250,
    Callback = function(Value)
        getgenv().BoatSpeed = Value
        _G.BoatSpeed = Value
    end
})

Tabs.SeaEvent:AddToggle({
    Name = "Auto Repair Boat",
    Description = "",
    Default = getgenv().RepairBoat or false,
    Callback = function(Value)
        getgenv().RepairBoat = Value
        _G.RepairBoat = Value
    end
})

Tabs.SeaEvent:AddToggle({
    Name = "Use Dragonstorm [Boats, SeaBeasts]",
    Description = "",
    Default = getgenv().UseDragonstormSea or false,
    Callback = function(Value)
        getgenv().UseDragonstormSea = Value
        _G.UseDragonstormSea = Value
    end
})

Tabs.SeaEvent:AddSection("Quests/Items")

Tabs.SeaEvent:AddToggle({
    Name = "Auto Unlock Shipwright Subclass",
    Description = "",
    Default = getgenv().AutoShipwright or false,
    Callback = function(Value)
        getgenv().AutoShipwright = Value
        if Value then
            task.spawn(function()
                while getgenv().AutoShipwright do
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Shipwright", "Check")
                    end)
                    task.wait(2)
                end
            end)
        end
    end
})

Tabs.SeaEvent:AddToggle({
    Name = "Auto Shark Anchor",
    Description = "Farm Shark Anchor",
    Default = getgenv().AutoSharkAnchor or false,
    Callback = function(Value)
        getgenv().AutoSharkAnchor = Value
    end
})


Tabs.SeaEvent:AddButton({
    Name = "Server Hop - Find Sea Event",
    Callback = function()
        pcall(function()
            local HttpService = game:GetService("HttpService")
            local TeleportService = game:GetService("TeleportService")
            local PlaceId = game.PlaceId
            local success, servers = pcall(function()
                local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
                return HttpService:JSONDecode(game:HttpGet(url))
            end)
            if success and servers and servers.data then
                for _, server in pairs(servers.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(PlaceId, server.id)
                        break
                    end
                end
            end
        end)
    end
})


StoredF = Tabs.Raids:AddToggle({
Name = "Auto Store Fruit", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.StoreF = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.StoreF then
      pcall(function() UpdStFruit() end)
    end
  end
end)
TwF = Tabs.Raids:AddToggle({
Name = "Auto Teleport Fruit", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.TwFruits = Value
end})
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


Tabs.Raids:AddSection("Gacha")


RandomFF = Tabs.Raids:AddToggle({
Name = "Auto Random Fruit", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Random_Auto = Value
end})
spawn(function()
  while wait(Sec) do
   	pcall(function()
      if _G.Random_Auto then replicated.Remotes.CommF_:InvokeServer("Cousin","Buy") end 
    end)
  end
end)


Tabs.Raids:AddSection("Main Raid")

-- Variables for Quantum Raid
_G.QuantumSelectRaid = _G.QuantumSelectRaid or "Flame"
_G.QuantumAutoRaidFull = _G.QuantumAutoRaidFull or false
_G.QuantumInstantKill45 = _G.QuantumInstantKill45 or false
_G.QuantumAutoBuyChip = _G.QuantumAutoBuyChip or false
_G.QuantumAutoUnstoreFruit = _G.QuantumAutoUnstoreFruit or false
_G.QuantumAutoAwaken = _G.QuantumAutoAwaken or false
_G.QuantumFragsCap = _G.QuantumFragsCap or 100000
_G.QuantumAutoStopRaid = _G.QuantumAutoStopRaid or false

Tabs.Raids:AddParagraph("Raid Info", "Beta Testing")

Tabs.Raids:AddDropdown({
    Name = "Select Raid Chip",
    Description = "",
    Options = {"Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Human: Buddha","Sand","Bird: Phoenix","Dough"},
    Default = _G.QuantumSelectRaid,
    Callback = function(Value)
        _G.QuantumSelectRaid = Value
        _G.SelectChip = Value
        getgenv().QuantumSelectRaid = Value
        print("[Raid] Selected Chip: " .. Value)
    end
})

Tabs.Raids:AddToggle({
    Name = "Auto Buy Chip [Beli/Fruit]",
    Description = "",
    Default = _G.QuantumAutoBuyChip,
    Callback = function(Value)
        _G.QuantumAutoBuyChip = Value
        getgenv().QuantumAutoBuyChip = Value
        _G.AutoChipBeli = Value
        _G.AutoChipFruit = Value
        print("[Raid] Auto Buy Chip: " .. (Value and "ON" or "OFF"))
    end
})

Tabs.Raids:AddToggle({
    Name = "Kill Islands 4-5 [Kill Aura]",
    Description = "",
    Default = _G.QuantumInstantKill45,
    Callback = function(Value)
        _G.QuantumInstantKill45 = Value
        getgenv().QuantumInstantKill45 = Value
        print("[Raid] Instant Kill 4-5: " .. (Value and "ON" or "OFF"))
    end
})

Tabs.Raids:AddToggle({
    Name = "Auto Unstore Below 1M Fruit",
    Description = "",
    Default = _G.QuantumAutoUnstoreFruit,
    Callback = function(Value)
        _G.QuantumAutoUnstoreFruit = Value
        getgenv().QuantumAutoUnstoreFruit = Value
    end
})

Tabs.Raids:AddToggle({
    Name = "Auto Awaken",
    Description = "",
    Default = _G.QuantumAutoAwaken,
    Callback = function(Value)
        _G.QuantumAutoAwaken = Value
        getgenv().QuantumAutoAwaken = Value
    end
})

Tabs.Raids:AddSlider({
    Name = "Frags Cap",
    Description = "",
    Min = 1000,
    Max = 1000000,
    Increase = 1000,
    Default = _G.QuantumFragsCap,
    Callback = function(Value)
        _G.QuantumFragsCap = Value
        getgenv().QuantumFragsCap = Value
    end
})

Tabs.Raids:AddToggle({
    Name = "Auto Stop Raid When Frags Cap",
    Description = "",
    Default = _G.QuantumAutoStopRaid,
    Callback = function(Value)
        _G.QuantumAutoStopRaid = Value
        getgenv().QuantumAutoStopRaid = Value
    end
})

Tabs.Raids:AddToggle({
    Name = "Auto Complete Raid",
    Description = "",
    Default = _G.QuantumAutoRaidFull,
    Callback = function(Value)
        _G.QuantumAutoRaidFull = Value
        getgenv().QuantumAutoRaidFull = Value
        _G.Raiding = Value
        getgenv().Raiding = Value
        print("[Raid] Auto Complete Raid: " .. (Value and "ON" or "OFF"))
    end
})

-- ===== QUANTUM RAID FUNCTIONS - CHUAN GOC KHONG LOI =====
local QuantumRaid = {}

function QuantumRaid.GetRaidIslands()
    local success, result = pcall(function()
        local locations = workspace["_WorldOrigin"].Locations
        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        for i = 5, 1, -1 do
            local islandName = "Island " .. i
            for _, child in ipairs(locations:GetChildren()) do
                if child.Name == islandName and child:IsA("Part") then
                    if (char.PrimaryPart and (char.PrimaryPart.Position - child.Position).Magnitude < 3500) or (hrp and (hrp.Position - child.Position).Magnitude < 3500) then
                        return child
                    end
                end
            end
        end
        return nil
    end)
    if success then return result else return nil end
end

function QuantumRaid.GetCurrentRaidIslandIndex()
    local island = QuantumRaid.GetRaidIslands()
    if island and island.Name:match("Island (%d+)") then
        return tonumber(island.Name:match("Island (%d+)"))
    end
    return nil
end

function QuantumRaid.InstantKillAura(enemies)
    -- Chuan Quantum Onyx fn19 - Instant Kill Islands 4-5
    pcall(function()
        for _, enemy in ipairs(enemies) do
            pcall(function()
                if sethiddenproperty then
                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                end
            end)
            pcall(function()
                if enemy:FindFirstChild("Humanoid") then
                    enemy.Humanoid.Health = 0
                end
            end)
            pcall(function()
                if enemy:FindFirstChild("HumanoidRootPart") then
                    enemy.HumanoidRootPart.CanCollide = false
                end
            end)
        end
    end)
end

function QuantumRaid.GetLowestFruit()
    local success, fruits = pcall(function()
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
    end)
    if not success or not fruits then return nil end
    local lowestPrice = math.huge
    local lowestFruit = nil
    for _, fruitData in pairs(fruits) do
        if fruitData.Price and fruitData.Price < lowestPrice and fruitData.Price <= 1000000 then
            if fruitData.Name then
                lowestPrice = fruitData.Price
                lowestFruit = fruitData.Name
            end
        end
    end
    return lowestFruit
end

function QuantumRaid.CheckHasChip()
    local backpack = game.Players.LocalPlayer.Backpack
    local char = game.Players.LocalPlayer.Character
    if backpack:FindFirstChild("Special Microchip") then return true end
    if char and char:FindFirstChild("Special Microchip") then return true end
    return false
end

function QuantumRaid.CheckFruitInInventory()
    local backpack = game.Players.LocalPlayer.Backpack
    local char = game.Players.LocalPlayer.Character
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip and string.find(item.ToolTip, "Blox Fruit") then
            return true, item.Name
        end
    end
    if char then
        for _, item in pairs(char:GetChildren()) do
            if item:IsA("Tool") and item.ToolTip and string.find(item.ToolTip, "Blox Fruit") then
                return true, item.Name
            end
        end
    end
    return false, nil
end

-- MAIN LOOP - AUTO RAID + KILL AURA ISLAND 4-5
task.spawn(function()
    while task.wait(0.3) do
        if not (_G.QuantumAutoRaidFull or getgenv().QuantumAutoRaidFull) then continue end
        pcall(function()
            local plr = game.Players.LocalPlayer
            local char = plr.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end
            
            -- Check Frags Cap
            if _G.QuantumAutoStopRaid or getgenv().QuantumAutoStopRaid then
                local data = plr:FindFirstChild("Data")
                local frags = data and data:FindFirstChild("Fragments")
                if frags and frags.Value >= (_G.QuantumFragsCap or getgenv().QuantumFragsCap or 100000) then
                    _G.QuantumAutoRaidFull = false
                    getgenv().QuantumAutoRaidFull = false
                    _G.Raiding = false
                    print("[Quantum Raid] Dat Frags Cap - Da dung raid")
                    return
                end
            end
            
            local gui = plr:FindFirstChild("PlayerGui")
            local main = gui and gui:FindFirstChild("Main")
            local topHUD = main and main:FindFirstChild("TopHUDList")
            local raidTimer = topHUD and topHUD:FindFirstChild("RaidTimer")
            local isRaidTimerVisible = raidTimer and raidTimer.Visible
            local isIslandRaiding = plr:GetAttribute("IslandRaiding")
            
            -- TRONG RAID - DI CHUYEN VA KILL
            if isRaidTimerVisible and isIslandRaiding then
                local enemiesInRange = {}
                for _, mob in ipairs(workspace.Enemies:GetChildren()) do
                    local mobHum = mob:FindFirstChild("Humanoid")
                    local mobHrp = mob:FindFirstChild("HumanoidRootPart")
                    if mobHum and mobHrp and mobHum.Health > 0 then
                        if plr:DistanceFromCharacter(mobHrp.Position) < 500 then
                            table.insert(enemiesInRange, mob)
                        end
                    end
                end
                
                if #enemiesInRange > 0 then
                    local currentIndex = QuantumRaid.GetCurrentRaidIslandIndex()
                    if (_G.QuantumInstantKill45 or getgenv().QuantumInstantKill45) and currentIndex and (currentIndex == 4 or currentIndex == 5) then
                        -- KILL AURA ISLAND 4-5 - INSTANT KILL NHU QUANTUM
                        QuantumRaid.InstantKillAura(enemiesInRange)
                        task.wait(0.2)
                    else
                        -- KILL THUONG
                        local target = enemiesInRange[1]
                        if target then
                            pcall(function()
                                if Attack and Attack.Kill then
                                    Attack.Kill(target, _G.QuantumAutoRaidFull)
                                else
                                    -- Fallback kill
                                    if target:FindFirstChild("HumanoidRootPart") then
                                        hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                                    end
                                end
                            end)
                        end
                    end
                else
                    -- KHONG CO ENEMY - DI DEN DAO TIEP THEO
                    local raidIsland = QuantumRaid.GetRaidIslands()
                    if raidIsland then
                        pcall(function()
                            local targetPos = CFrame.new(raidIsland.Position + Vector3.new(0, 80, 0))
                            if topos then
                                topos(targetPos)
                            elseif _tp then
                                _tp(targetPos)
                            else
                                hrp.CFrame = targetPos
                            end
                        end)
                    end
                end
                return
            end
            
            -- NGOAI RAID - MUA CHIP VA SUMMON
            if QuantumRaid.CheckHasChip() and not isRaidTimerVisible and not QuantumRaid.GetRaidIslands() and not isIslandRaiding then
                -- CO CHIP ROI - DI SUMMON RAID
                pcall(function()
                    if World2 then
                        local btn = workspace.Map.CircleIsland.RaidSummon2.Button.Main
                        if btn then
                            if (hrp.Position - btn.Position).Magnitude > 10 then
                                if topos then topos(btn.CFrame) else hrp.CFrame = btn.CFrame end
                                task.wait(0.5)
                            end
                            if btn:FindFirstChild("ClickDetector") then
                                fireclickdetector(btn.ClickDetector)
                            end
                            if btn:FindFirstChild("ProximityPrompt") then
                                fireproximityprompt(btn.ProximityPrompt)
                            end
                        end
                    elseif World3 then
                        local boatCastle = workspace.Map["Boat Castle"]
                        local summonBtn = boatCastle and boatCastle:FindFirstChild("RaidSummon2") and boatCastle.RaidSummon2.Button.Main
                        if summonBtn then
                            if (hrp.Position - summonBtn.Position).Magnitude > 10 then
                                if topos then topos(summonBtn.CFrame) else hrp.CFrame = summonBtn.CFrame end
                                task.wait(0.5)
                            end
                            if summonBtn:FindFirstChild("ClickDetector") then
                                fireclickdetector(summonBtn.ClickDetector)
                            end
                            if summonBtn:FindFirstChild("ProximityPrompt") then
                                fireproximityprompt(summonBtn.ProximityPrompt)
                            end
                        end
                    end
                end)
            elseif not QuantumRaid.CheckHasChip() and (_G.QuantumAutoBuyChip or getgenv().QuantumAutoBuyChip) then
                -- CHUA CO CHIP - TU DONG MUA
                pcall(function()
                    if (_G.QuantumAutoUnstoreFruit or getgenv().QuantumAutoUnstoreFruit) then
                        local hasFruit, fruitName = QuantumRaid.CheckFruitInInventory()
                        if not hasFruit then
                            local lowestFruit = QuantumRaid.GetLowestFruit()
                            if lowestFruit then
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadFruit", lowestFruit)
                                task.wait(0.5)
                                local backpack = plr.Backpack
                                local fruitTool = backpack:FindFirstChild(lowestFruit)
                                if fruitTool and char:FindFirstChildOfClass("Humanoid") then
                                    char.Humanoid:EquipTool(fruitTool)
                                end
                            end
                        end
                    end
                    local chipName = _G.QuantumSelectRaid or getgenv().QuantumSelectRaid or "Flame"
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc", "Select", chipName)
                    task.wait(1)
                end)
            end
            
            -- AUTO AWAKEN
            if (_G.QuantumAutoAwaken or getgenv().QuantumAutoAwaken) and not isIslandRaiding then
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Awakener", "Check")
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Awakener", "Awaken")
                end)
            end
        end)
    end
end)

print("[Quantum Raid] Loaded - Auto Raid + Kill Aura Island 4-5 Ready - Khong loi")


Tabs.Raids:AddToggle({
Name = "Auto Awakening", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_Awakener = Value
end})
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

Tabs.Raids:AddToggle({
    Name = "Auto Teleport To Lab",
    Default = false,
    Callback = function(Value)
        _G.TpLab = Value
        StopTween(_G.TpLab)
        while _G.TpLab do
            wait()
            if _G.TpLab then
                if World2 and _G.TpLab then
                    topos(CFrame.new(-6438.73535, 250.645355, -4501.50684))
                elseif World3 and _G.TpLab then
                    topos(CFrame.new(-5017.40869, 314.844055, -2823.0127,-0.925743818, 4.48217499e-08, -0.378151238,4.55503146e-09, 1, 1.07377559e-07,0.378151238, 9.7681621e-08, -0.925743818))
                end
            end
        end
    end
})

_G.AutoNotifyRaidPlates = _G.AutoNotifyRaidPlates or false
_G.RaidPlatesNotified = false
local RaidPlatesTouchDetector = nil

Tabs.Raids:AddToggle({
    Name = "Auto Notify Raid Plates Hot Cold Sea2",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoNotifyRaidPlates = Value
        _G.RaidPlatesNotified = false
        if Value then
            Window:Notify({Title="Raid Plates", Content="Da bat thong bao Raid Plates", Time=5})
        end
    end
})

function NotifyRaidPlates(platesContent)
    pcall(function()
        Window:Notify({Title="Raid Plates", Content=platesContent or "🔴 🔵 🟢 🔵", Time=15})
    end)
end

spawn(function()
    while task.wait(1) do
        pcall(function()
            if not _G.AutoNotifyRaidPlates then return end
            if not World2 then return end
            if _G.RaidPlatesNotified then return end
            local char = game.Players.LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local hrp = char.HumanoidRootPart
            local pos = hrp.Position
            local coldPos = Vector3.new(-6066, 15, -4902)
            local hotPos = Vector3.new(-5478, 15, -5246)
            local distCold = (pos - coldPos).Magnitude
            local distHot = (pos - hotPos).Magnitude
            if distCold < 2000 or distHot < 2000 then
                if not _G.RaidPlatesNotified then
                    _G.RaidPlatesNotified = true
                    local colors = {"🔴", "🔵", "🟢", "🔵"}
                    local pattern = ""
                    for i = 1, 4 do pattern = pattern .. colors[math.random(1, #colors)] .. " " end
                    NotifyRaidPlates(pattern)
                    RaidPlatesTouchDetector = Instance.new("Part")
                    RaidPlatesTouchDetector.Name = "raid_touch_detector"
                    RaidPlatesTouchDetector.Parent = workspace
                    RaidPlatesTouchDetector.Anchored = true
                    RaidPlatesTouchDetector.CanCollide = false
                    RaidPlatesTouchDetector.Transparency = 1
                    RaidPlatesTouchDetector.CFrame = CFrame.new(pos)
                    task.spawn(function()
                        task.wait(15)
                        pcall(function()
                            if RaidPlatesTouchDetector then RaidPlatesTouchDetector:Destroy() RaidPlatesTouchDetector = nil end
                        end)
                        _G.RaidPlatesNotified = false
                    end)
                end
            else
                if _G.RaidPlatesNotified and distCold > 2500 and distHot > 2500 then
                    _G.RaidPlatesNotified = false
                end
            end
        end)
    end
end)

Window:Notify({
  Title = "Redz Hub",
  Content = "The script owner is talking to you",
  Content = "Thanks for using my script! I’d appreciate it if you could support the owner’s YouTube and TikTok channels. Owner’s TikTok: Realskira Owner’s YouTube: JuroFuzHumi20",
  Image = "rbxassetid://15298567397",
  Duration = 30
})

-- ========== KẾT THÚC REDZ BETA SEA TAB ==========


Tabs.Raids:AddSection("Items Law/Order Sword")

Tabs.Raids:AddButton({
Name = "Buy Microchip Law", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Microchip","2")
end})
Tabs.Raids:AddButton({
Name = "Start Law Raids", 
Description = "",
Callback = function()
  fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
end})

Tabs.Raids:AddToggle({
    Name = "Auto Buy Microchip Law", 
    Description = "",
    Default = false,
    Callback = function(Value)
        getgenv().AutoBuyMicrochipLaw = Value
    end
})

spawn(function()
    while task.wait(1) do  
        if getgenv().AutoBuyMicrochipLaw then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Microchip","2")
            end)
        end
    end
end)

Tabs.Raids:AddToggle({
    Name = "Auto Start Law Raids", 
    Description = "",
    Default = false,
    Callback = function(Value)
        getgenv().AutoStartLawRaids = Value
    end
})

spawn(function()
    while task.wait(1) do  
        if getgenv().AutoStartLawRaids then
            pcall(function()
                fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
            end)
        end
    end
end)

Tabs.Raids:AddToggle({
Name = "Auto Kill Law", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoLawKak = Value
end})
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

Tabs.Raids:AddSection("Raids Dungeons")

local plr = game.Players.LocalPlayer

local function GetHRP()
    local char = plr.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

Tabs.Raids:AddToggle({
    Name = "Auto Farm Dungeon",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoFarmDungeon = Value
    end
})

local FARM_RANGE = 5000

spawn(function()
    while task.wait(0.15) do
        if not _G.AutoFarmDungeon then continue end

        pcall(function()
            local plr = game.Players.LocalPlayer
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end

            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if not _G.AutoFarmDungeon then break end

                local mh = mob:FindFirstChild("Humanoid")
                local mhrp = mob:FindFirstChild("HumanoidRootPart")

                if mh and mhrp and mh.Health > 0 then
                    local dist = (mhrp.Position - hrp.Position).Magnitude
                    if dist <= FARM_RANGE then
                        repeat
                            task.wait()
                            Attack.Kill(mob, true)
                        until not _G.AutoFarmDungeon
                            or not mob.Parent
                            or mh.Health <= 0
                    end
                end
            end
        end)
    end
end)


Tabs.Raids:AddToggle({
    Name = "TP Exit (1)",
    Default = false,
    Callback = function(v)
        _G.TPFloor1 = v
    end
})


local tp1Done = false

local function GetCurrentFloor()
    local hrp = GetHRP()
    if not hrp then return end

    for _, floor in pairs(workspace.Map.Dungeon:GetChildren()) do
        local exit = floor:FindFirstChild("ExitTeleporter")
        if exit and exit:FindFirstChild("Root") then
            if (hrp.Position - exit.Root.Position).Magnitude < 200 then
                return exit.Root
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.3) do
        if not _G.TPFloor1 then
            tp1Done = false
            continue
        end

        if not tp1Done then
            local root = GetCurrentFloor()
            if root then
                root = root.CFrame * CFrame.new(0,3,0)
                GetHRP().CFrame = root
                tp1Done = true
            end
        end
    end
end)

Tabs.Raids:AddToggle({
    Name = "TP Exit (2)",
    Default = false,
    Callback = function(v)
        _G.TPFloor2 = v
    end
})

local tp2Done = false

task.spawn(function()
    while task.wait(0.3) do
        if not _G.TPFloor2 then
            tp2Done = false
            continue
        end

        if tp2Done then continue end

        local hrp = GetHRP()
        if not hrp then continue end

        for _, floor in pairs(workspace.Map.Dungeon:GetChildren()) do
            local ent = floor:FindFirstChild("EntranceTeleporter")
            local ext = floor:FindFirstChild("ExitTeleporter")

            if ent and ext and ent:FindFirstChild("Root") and ext:FindFirstChild("Root") then
                if (hrp.Position - ent.Root.Position).Magnitude < 100 then
                    hrp.CFrame = ext.Root.CFrame * CFrame.new(0,3,0)
                    tp2Done = true
                    break
                end
            end
        end
    end
end)

Tabs.Raids:AddToggle({
    Name = "TP Exit (3)",
    Default = false,
    Callback = function(v)
        _G.TPFloor3 = v
    end
})

local tp3Done = false

local function GetHighestFloor()
    local max
    for _, floor in pairs(workspace.Map.Dungeon:GetChildren()) do
        local n = tonumber(floor.Name)
        if n and (not max or n > tonumber(max.Name)) then
            max = floor
        end
    end
    return max
end

task.spawn(function()
    while task.wait(0.3) do
        if not _G.TPFloor3 then
            tp3Done = false
            continue
        end

        if not tp3Done then
            local floor = GetHighestFloor()
            if floor and floor:FindFirstChild("ExitTeleporter")
            and floor.ExitTeleporter:FindFirstChild("Root") then

                GetHRP().CFrame =
                    floor.ExitTeleporter.Root.CFrame * CFrame.new(0,3,0)
                tp3Done = true
            end
        end
    end
end)

Tabs.Raids:AddToggle({
    Name = "TP Exit (4)",
    Default = false,
    Callback = function(v)
        _G.TPFloor4 = v
    end
})

local tp4Done = false

local function GetNearestExit()
    local hrp = GetHRP()
    if not hrp then return end

    local nearest, dist = nil, math.huge

    for _, floor in pairs(workspace.Map.Dungeon:GetChildren()) do
        local exit = floor:FindFirstChild("ExitTeleporter")
        if exit and exit:FindFirstChild("Root") then
            local d = (hrp.Position - exit.Root.Position).Magnitude
            if d < dist then
                dist = d
                nearest = exit.Root
            end
        end
    end
    return nearest
end

task.spawn(function()
    while task.wait(0.3) do
        if not _G.TPFloor4 then
            tp4Done = false
            continue
        end

        if not tp4Done then
            local root = GetNearestExit()
            if root then
                GetHRP().CFrame = root.CFrame * CFrame.new(0,3,0)
                tp4Done = true
            end
        end
    end
end)







-- ========== PVP TAB MERGED - BONE HUB + VAN THANH HITBOX - NEW PROJECT ==========
-- Tab PVP cua SkitringX - them chuc nang tu Bone Hub va Hitbox Van Thanh

Tabs.PVP:AddSection("PVP")

-- ===== AIMBOT SETTINGS (Bone Hub) =====
Tabs.PVP:AddSection("Aimbot Settings")

-- Player list dropdown
local PlayerList = {}
for _, player in pairs(game:GetService("Players"):GetChildren()) do
    if player.Name ~= game.Players.LocalPlayer.Name then
        table.insert(PlayerList, player.Name)
    end
end

_G.SelectedPVPPlayer = _G.SelectedPVPPlayer or nil
_G.AimbotPVP = _G.AimbotPVP or false
_G.AimbotSkill = _G.AimbotSkill or false
_G.AutoAimClosest = _G.AutoAimClosest or false

local DropdownPlayer = Tabs.PVP:AddDropdown({
    Name = "Select Player",
    Options = PlayerList,
    Callback = function(Value)
        _G.SelectedPVPPlayer = Value
    end
})

Tabs.PVP:AddButton({
    Name = "Refresh Player List",
    Callback = function()
        PlayerList = {}
        for _, player in pairs(game:GetService("Players"):GetChildren()) do
            if player.Name ~= game.Players.LocalPlayer.Name then
                table.insert(PlayerList, player.Name)
            end
        end
        -- Update dropdown if possible
        pcall(function()
            DropdownPlayer:SetOptions(PlayerList)
        end)
    end
})

Tabs.PVP:AddToggle({
    Name = "⚠️ Aimbot Player",
    Default = _G.AimbotPVP,
    Callback = function(Value)
        _G.AimbotPVP = Value
        if Value then
            spawn(function()
                while _G.AimbotPVP do
                    pcall(function()
                        local target = nil
                        if _G.SelectedPVPPlayer then
                            target = game.Players:FindFirstChild(_G.SelectedPVPPlayer)
                        else
                            -- Auto closest
                            local closestDist = math.huge
                            for _, plr in pairs(game.Players:GetPlayers()) do
                                if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                                    local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                                    if dist < closestDist then
                                        closestDist = dist
                                        target = plr
                                    end
                                end
                            end
                        end
                        
                        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            local aimPos = target.Character.HumanoidRootPart.Position
                            -- Set mouse pos for skill aimbot
                            getgenv().AimPosition = aimPos
                            -- For gun aimbot - move camera
                            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, aimPos)
                        end
                    end)
                    task.wait(0.05)
                end
            end)
        end
    end
})

Tabs.PVP:AddToggle({
    Name = "⚠️ Aimbot Skill",
    Default = _G.AimbotSkill,
    Callback = function(Value)
        _G.AimbotSkill = Value
        if Value then
            -- Hook RemoteEvent for skill aim
            spawn(function()
                local mt = getrawmetatable(game)
                local old = mt.__namecall
                setreadonly(mt, false)
                mt.__namecall = newcclosure(function(...)
                    local method = getnamecallmethod()
                    local args = {...}
                    if tostring(method) == "FireServer" then
                        if tostring(args[1]) == "RemoteEvent" then
                            if _G.AimbotSkill and _G.SelectedPVPPlayer then
                                local target = game.Players:FindFirstChild(_G.SelectedPVPPlayer)
                                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                                    args[2] = target.Character.HumanoidRootPart.Position
                                    return old(unpack(args))
                                end
                            end
                        end
                    end
                    return old(...)
                end)
            end)
        end
    end
})

Tabs.PVP:AddToggle({
    Name = "Auto Aim Closest Player",
    Default = _G.AutoAimClosest,
    Callback = function(Value)
        _G.AutoAimClosest = Value
        _G.SelectedPVPPlayer = nil
    end
})

-- ===== PVP SETTINGS (Bone Hub) =====
Tabs.PVP:AddSection("PVP Settings")

_G.TeleportToPlayer = _G.TeleportToPlayer or false
_G.AutoEnablePVP = _G.AutoEnablePVP or false
_G.AutoAttackPVP = _G.AutoAttackPVP or false

Tabs.PVP:AddToggle({
    Name = "Auto Enable PVP",
    Default = _G.AutoEnablePVP,
    Callback = function(Value)
        _G.AutoEnablePVP = Value
        if Value then
            spawn(function()
                while _G.AutoEnablePVP do
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

Tabs.PVP:AddToggle({
    Name = "Auto Attack PVP Player",
    Default = _G.AutoAttackPVP,
    Callback = function(Value)
        _G.AutoAttackPVP = Value
        if Value then
            spawn(function()
                while _G.AutoAttackPVP do
                    pcall(function()
                        local target = nil
                        if _G.SelectedPVPPlayer then
                            target = game.Players:FindFirstChild(_G.SelectedPVPPlayer)
                        end
                        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            local char = game.Players.LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                local dist = (char.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                                if dist < 100 then
                                    -- Attack
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "X", false, game)
                                    task.wait(0.05)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, "X", false, game)
                                end
                            end
                        end
                    end)
                    task.wait(0.2)
                end
            end)
        end
    end
})

-- Anti Gravity + Height variables - chi hoat dong khi bat Teleport to Selected Player
_G.AntiGravityPVP = _G.AntiGravityPVP or nil
_G.AntiGravityConnection = _G.AntiGravityConnection or nil
_G.TeleportHeight = _G.TeleportHeight or 5 -- Do cao mac dinh 5 studs
_G.TeleportDistance = _G.TeleportDistance or 5 -- Khoang cach mac dinh

local function EnableAntiGravity()
    pcall(function()
        local char = game.Players.LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        
        -- Xoa cai cu neu co
        if hrp:FindFirstChild("AntiGravityPVP") then
            hrp:FindFirstChild("AntiGravityPVP"):Destroy()
        end
        
        -- Tao BodyVelocity chong roi
        local bv = Instance.new("BodyVelocity")
        bv.Name = "AntiGravityPVP"
        bv.Parent = hrp
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        -- Tao BodyGyro giu thang bang
        if hrp:FindFirstChild("AntiGyroPVP") then
            hrp:FindFirstChild("AntiGyroPVP"):Destroy()
        end
        local bg = Instance.new("BodyGyro")
        bg.Name = "AntiGyroPVP"
        bg.Parent = hrp
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 90000
        bg.CFrame = hrp.CFrame
        
        -- Tat va cham de khong bi vuong
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        _G.AntiGravityPVP = bv
        
        -- Loop giu anti gravity
        _G.AntiGravityConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if _G.TeleportToPlayer and hrp and hrp.Parent then
                -- Giu velocity = 0 de khong roi, nhung van cho phep di chuyen qua CFrame
                if bv and bv.Parent then
                    bv.Velocity = Vector3.new(0, 0, 0)
                end
                if bg and bg.Parent then
                    bg.CFrame = hrp.CFrame
                end
                -- Dam bao khong roi
                hum:ChangeState(Enum.HumanoidStateType.Physics)
            end
        end)
    end)
end

local function DisableAntiGravity()
    pcall(function()
        local char = game.Players.LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if hrp:FindFirstChild("AntiGravityPVP") then
                    hrp:FindFirstChild("AntiGravityPVP"):Destroy()
                end
                if hrp:FindFirstChild("AntiGyroPVP") then
                    hrp:FindFirstChild("AntiGyroPVP"):Destroy()
                end
            end
            -- Bat lai va cham
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
        
        if _G.AntiGravityConnection then
            _G.AntiGravityConnection:Disconnect()
            _G.AntiGravityConnection = nil
        end
        _G.AntiGravityPVP = nil
    end)
end

Tabs.PVP:AddToggle({
    Name = "Teleport to Selected Player",
    Default = _G.TeleportToPlayer or false,
    Callback = function(Value)
        _G.TeleportToPlayer = Value
        if Value then
            -- Bat Anti Gravity chi khi bat teleport
            EnableAntiGravity()
            
            spawn(function()
                while _G.TeleportToPlayer do
                    pcall(function()
                        if _G.SelectedPVPPlayer then
                            local target = game.Players:FindFirstChild(_G.SelectedPVPPlayer)
                            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local targetCFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, _G.TeleportHeight or 5, _G.TeleportDistance or 5)
                                -- Dung ham _tp co san cua SkitringX de khong bi giat - ket hop anti gravity
                                if typeof(_tp) == "function" then
                                    _tp(targetCFrame)
                                elseif typeof(toTarget) == "function" then
                                    toTarget(targetCFrame)
                                else
                                    -- Truc tiep set CFrame voi anti gravity nen khong roi
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
                                    -- Giu velocity 0
                                    if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("AntiGravityPVP") then
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.AntiGravityPVP.Velocity = Vector3.new(0,0,0)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        else
            -- Tat Anti Gravity khi tat teleport
            DisableAntiGravity()
        end
    end
})

Tabs.PVP:AddSlider({
    Name = "Height Teleport Y",
    Min = 0,
    Max = 100,
    Default = _G.TeleportHeight or 5,
    Callback = function(Value)
        _G.TeleportHeight = Value
        if _G.TeleportToPlayer then
            Window:Notify({Title="Height", Content="Do cao: "..Value.." studs", Duration=1})
        end
    end
})

_G.TeleportDistance = _G.TeleportDistance or 5

Tabs.PVP:AddSlider({
    Name = "Distance Teleport",
    Min = 0,
    Max = 30,
    Default = _G.TeleportDistance or 5,
    Callback = function(Value)
        _G.TeleportDistance = Value
    end
})

-- ===== MOVE SETTINGS (Bone Hub - Fly) =====
Tabs.PVP:AddSection("Move Settings")

_G.FlyPVP = _G.FlyPVP or false
_G.FlySpeedPVP = _G.FlySpeedPVP or 50
local FlyEnabled = false
local FlySpeed = 50
local BodyGyro = nil
local BodyVelocity = nil
local HeartbeatConn = nil

local function ToggleFlyPVP(state)
    FlyEnabled = state
    _G.FlyPVP = state
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not torso then return end
    
    if FlyEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        BodyGyro = Instance.new("BodyGyro", torso)
        BodyGyro.P = 90000
        BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.cframe = torso.CFrame
        
        BodyVelocity = Instance.new("BodyVelocity", torso)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        humanoid.PlatformStand = true
        
        HeartbeatConn = game:GetService("RunService").Heartbeat:Connect(function()
            if not FlyEnabled or not player.Character then return end
            local moveDir = humanoid.MoveDirection
            local cam = workspace.CurrentCamera
            local vel = Vector3.new(0,0,0)
            if moveDir.Magnitude > 0 then
                vel = cam.CFrame.LookVector * 0
                -- WASD
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    vel = vel + cam.CFrame.LookVector * FlySpeed
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    vel = vel - cam.CFrame.LookVector * FlySpeed
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    vel = vel - cam.CFrame.RightVector * FlySpeed
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    vel = vel + cam.CFrame.RightVector * FlySpeed
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                    vel = vel + Vector3.new(0, FlySpeed, 0)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                    vel = vel - Vector3.new(0, FlySpeed, 0)
                end
            end
            BodyVelocity.Velocity = vel
            BodyGyro.cframe = cam.CFrame
        end)
    else
        if HeartbeatConn then HeartbeatConn:Disconnect() HeartbeatConn = nil end
        if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
        if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
        if humanoid then humanoid.PlatformStand = false end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

Tabs.PVP:AddToggle({
    Name = "Fly PVP",
    Default = _G.FlyPVP,
    Callback = function(Value)
        ToggleFlyPVP(Value)
    end
})

Tabs.PVP:AddSlider({
    Name = "Fly Speed",
    Min = 10, Max = 200, Default = _G.FlySpeedPVP,
    Callback = function(Value)
        _G.FlySpeedPVP = Value
        FlySpeed = Value
    end
})

-- ===== HITBOX VAN THANH - GEP VAO PVP TAB SKITRINGX =====
Tabs.PVP:AddSection("Hitbox")

_G.HeadSize = _G.HeadSize or 20
_G.HitboxDisabled = _G.HitboxDisabled or false
_G.HitboxMode = _G.HitboxMode or "KhongHien" -- Hien / KhongHien
_G.HitboxConnection = _G.HitboxConnection or nil

local function StartHitbox(mode)
    _G.HitboxDisabled = true
    _G.HitboxMode = mode
    
    -- Huy connection cu neu co
    if _G.HitboxConnection then
        pcall(function() _G.HitboxConnection:Disconnect() end)
    end
    
    _G.HitboxConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if _G.HitboxDisabled then
            pcall(function()
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player.Name ~= game.Players.LocalPlayer.Name then
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                            local hrp = player.Character.HumanoidRootPart
                            hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                            hrp.CanCollide = false
                            
                            if mode == "Hien" then
                                -- Hitbox Hien - mau xanh bien neon
                                hrp.Transparency = 0.7
                                hrp.BrickColor = BrickColor.new("Really blue")
                                hrp.Material = Enum.Material.Neon
                            else
                                -- Hitbox Khong Hien - trong suot
                                hrp.Transparency = 1
                                hrp.BrickColor = BrickColor.new("Really black")
                                hrp.Material = Enum.Material.Neon
                            end
                        end
                    end
                end
            end)
        end
    end)
end

local function StopHitbox()
    _G.HitboxDisabled = false
    if _G.HitboxConnection then
        pcall(function() _G.HitboxConnection:Disconnect() end)
        _G.HitboxConnection = nil
    end
    -- Reset hitbox ve binh thuong
    pcall(function()
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
                hrp.BrickColor = BrickColor.new("Medium stone grey")
                hrp.Material = Enum.Material.Plastic
            end
        end
    end)
end

Tabs.PVP:AddToggle({
    Name = "Hitbox Presently ",
    Description = "",
    Default = false,
    Callback = function(Value)
        if Value then
            -- Tat cai kia
            _G.HitboxKhongHien = false
            StartHitbox("Hien")
            Window:Notify({Title="Hitbox Van Thanh", Content="Bat Hitbox Hien - Size: ".._G.HeadSize, Duration=2})
        else
            StopHitbox()
        end
    end
})

Tabs.PVP:AddToggle({
    Name = "Hitbox Not Displayed",
    Description = "",
    Default = false,
    Callback = function(Value)
        if Value then
            _G.HitboxHien = false
            StartHitbox("KhongHien")
            Window:Notify({Title="Hitbox Van Thanh", Content="Bat Hitbox Khong Hien - Size: ".._G.HeadSize, Duration=2})
        else
            StopHitbox()
        end
    end
})

Tabs.PVP:AddSlider({
    Name = "Buff Hitbox Size [ BETA ]",
    Min = 5, Max = 100, Default = _G.HeadSize,
    Callback = function(Value)
        _G.HeadSize = Value
        -- Cap nhat ngay lap tuc neu dang bat
        if _G.HitboxDisabled then
            Window:Notify({Title="Hitbox", Content="Size: "..Value, Duration=1})
        end
    end
})

Tabs.PVP:AddButton({
    Name = "Reset Hitbox Black To Normal",
    Callback = function()
        StopHitbox()
        _G.HeadSize = 20
        Window:Notify({Title="Hitbox", Content="Da reset hitbox", Duration=2})
    end
})

Tabs.PVP:AddSection("PVP Utility")

Tabs.PVP:AddButton({
    Name = "Anti Lag + FPS Boost",
    Callback = function()
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
            elseif v:IsA("Decal") or v:IsA("Texture") then
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
            end
        end
        Window:Notify({Title="PVP", Content="Anti Lag Done", Duration=2})
    end
})

-- ========== KET THUC PVP MERGED ==========



-- === PVP REPLACED WITH VISUAL PLOCK GOC 100% ===

Tabs.Combat:AddSection("Aimbot")
getgenv().AimbotEnabled = getgenv().AimbotEnabled or false
getgenv().AimPlayers = getgenv().AimPlayers or false
getgenv().AimMobs = getgenv().AimMobs or false
getgenv().IgnoreMobs = getgenv().IgnoreMobs == nil and true or getgenv().IgnoreMobs
local AimbotModule = nil
pcall(function() AimbotModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/Aimbot-skill-config/refs/heads/main/Aimbot.lua"))() end)
local function UpdateAimbotPlock()
    if not AimbotModule then return end
    if not getgenv().AimbotEnabled then pcall(function() AimbotModule:SetPlayerSilentAim(false) AimbotModule:SetNPCSilentAim(false) end) return end
    if getgenv().AimPlayers then pcall(function() AimbotModule:SetPlayerSilentAim(true) AimbotModule:SetNPCSilentAim(false) end) return end
    if getgenv().AimMobs then
        if getgenv().IgnoreMobs then pcall(function() AimbotModule:SetNPCSilentAim(false) end) else pcall(function() AimbotModule:SetNPCSilentAim(true) end) end
        pcall(function() AimbotModule:SetPlayerSilentAim(false) end) return
    end
    pcall(function() AimbotModule:SetPlayerSilentAim(false) AimbotModule:SetNPCSilentAim(false) end)
end
Tabs.Combat:AddToggle({ Name = "Aimbot Gun", Default = getgenv().AimbotEnabled, Callback = function(v) getgenv().AimbotEnabled = v if AimbotModule then if not v then pcall(function() AimbotModule:Pause() end) else pcall(function() AimbotModule:Restore() end) end end UpdateAimbotPlock() end })
Tabs.Combat:AddToggle({ Name = "Aimbot Tap (Players)", Default = getgenv().AimPlayers, Callback = function(v) getgenv().AimPlayers = v if v then getgenv().AimMobs = false end UpdateAimbotPlock() end })
Tabs.Combat:AddToggle({ Name = "Aimbot Skills (Mobs)", Default = getgenv().AimMobs, Callback = function(v) getgenv().AimMobs = v if v then getgenv().AimPlayers = false end UpdateAimbotPlock() end })
Tabs.Combat:AddToggle({ Name = "Ignore Mobs", Default = getgenv().IgnoreMobs, Callback = function(v) getgenv().IgnoreMobs = v UpdateAimbotPlock() end })

Tabs.Combat:AddSection("ESP")
getgenv().ESPSize = getgenv().ESPSize or 24
getgenv().ESPPlayer = getgenv().ESPPlayer or false
_G.ChestESP = _G.ChestESP or false
getgenv().DevilFruitESP = getgenv().DevilFruitESP or false
getgenv().BerryESP = getgenv().BerryESP or false
getgenv().ESPConnections = getgenv().ESPConnections or {}
local function RemoveESP(player)
    if player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then local esp = hrp:FindFirstChild("PlayerESP") if esp then esp:Destroy() end end
    end
    if getgenv().ESPConnections[player] then getgenv().ESPConnections[player]:Disconnect() getgenv().ESPConnections[player] = nil end
end
local function CreateESP(player)
    if player == game.Players.LocalPlayer then return end
    if not getgenv().ESPPlayer then return end
    if not player.Character then return end
    local char = player.Character
    local hrp = char:WaitForChild("HumanoidRootPart", 3)
    local hum = char:WaitForChild("Humanoid", 3)
    if not hrp or not hum then return end
    RemoveESP(player)
    local gui = Instance.new("BillboardGui")
    gui.Name = "PlayerESP"
    gui.Adornee = hrp
    gui.Size = UDim2.new(0, 220, 0, 40)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.AlwaysOnTop = true
    gui.MaxDistance = 999999
    gui.LightInfluence = 0
    gui.Parent = hrp
    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.RichText = true
    nameLabel.TextColor3 = Color3.fromRGB(210,210,210)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = getgenv().ESPSize or 24
    nameLabel.Font = Enum.Font.SourceSans
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center
    nameLabel.Parent = gui
    local hpLabel = Instance.new("TextLabel")
    hpLabel.BackgroundTransparency = 1
    hpLabel.Size = UDim2.new(1, 0, 0.5, 0)
    hpLabel.Position = UDim2.new(0, 0, 0.5, 0)
    hpLabel.TextColor3 = Color3.fromRGB(0,255,0)
    hpLabel.TextStrokeTransparency = 0
    hpLabel.TextSize = getgenv().ESPSize or 24
    hpLabel.Font = Enum.Font.SourceSans
    hpLabel.TextXAlignment = Enum.TextXAlignment.Center
    hpLabel.TextYAlignment = Enum.TextYAlignment.Center
    hpLabel.Parent = gui
    getgenv().ESPConnections[player] = game:GetService("RunService").RenderStepped:Connect(function()
        if not getgenv().ESPPlayer then RemoveESP(player) return end
        if not player.Character or hum.Health <= 0 then RemoveESP(player) return end
        local myChar = game.Players.LocalPlayer.Character
        if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local distance = math.floor((myHRP.Position - hrp.Position).Magnitude)
        pcall(function()
            nameLabel.Text = "<font color='rgb(235,235,235)'>" .. player.Name .. "</font> [ " .. distance .. "m ]"
            hpLabel.Text = "[" .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth) .. "]"
            nameLabel.TextSize = getgenv().ESPSize or 24
            hpLabel.TextSize = getgenv().ESPSize or 24
        end)
    end)
end
local function SetupPlayer(player)
    if player == game.Players.LocalPlayer then return end
    player.CharacterAdded:Connect(function() if getgenv().ESPPlayer then task.wait(0.2) CreateESP(player) end end)
    if player.Character then task.wait(0.2) CreateESP(player) end
end
for _, player in ipairs(game:GetService("Players"):GetPlayers()) do SetupPlayer(player) end
game.Players.PlayerAdded:Connect(function(player) SetupPlayer(player) end)
game.Players.PlayerRemoving:Connect(function(player) RemoveESP(player) end)
Tabs.Combat:AddSlider({ Name = "ESP Size", Min = 10, Max = 40, Default = getgenv().ESPSize, Callback = function(Value) getgenv().ESPSize = Value end })
Tabs.Combat:AddToggle({ Name = "ESP Players", Default = getgenv().ESPPlayer, Callback = function(v) getgenv().ESPPlayer = v for _, player in pairs(game:GetService("Players"):GetPlayers()) do if player ~= game.Players.LocalPlayer then if v then CreateESP(player) else RemoveESP(player) end end end end })
Tabs.Combat:AddToggle({ Name = "Esp Chest", Default = _G.ChestESP, Callback = function(v) _G.ChestESP = v if not v then for _, chest in pairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do if chest:FindFirstChild("ChestEsp") then chest:FindFirstChild("ChestEsp"):Destroy() end end else task.spawn(function() while _G.ChestESP do pcall(function() for _, chest in pairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do if not chest:GetAttribute("IsDisabled") then if not chest:FindFirstChild("ChestEsp") then local bill = Instance.new("BillboardGui") bill.Name = "ChestEsp" bill.ExtentsOffset = Vector3.new(0,1,0) bill.Size = UDim2.new(1,200,1,30) bill.Adornee = chest bill.AlwaysOnTop = true bill.Parent = chest local label = Instance.new("TextLabel", bill) label.Size = UDim2.new(1,0,1,0) label.BackgroundTransparency = 1 label.TextStrokeTransparency = 0.5 label.Font = Enum.Font.GothamSemibold label.TextSize = 14 label.TextColor3 = Color3.fromRGB(255,255,0) label.Text = chest.Name end end end end) task.wait(1) end end) end end })
Tabs.Combat:AddToggle({ Name = "ESP Fruits", Default = getgenv().DevilFruitESP, Callback = function(state) getgenv().DevilFruitESP = state if state then task.spawn(function() while getgenv().DevilFruitESP do pcall(function() local char = game.Players.LocalPlayer.Character if not char or not char:FindFirstChild("HumanoidRootPart") then task.wait(1) return end local rootPos = char.HumanoidRootPart.Position for _, obj in pairs(workspace:GetChildren()) do if obj:IsA("Tool") and string.find(obj.Name,"Fruit") and obj.Parent ~= char then local handle = obj:FindFirstChild("Handle") if handle then if not handle:FindFirstChild("FruitESP") then local bill = Instance.new("BillboardGui") bill.Name = "FruitESP" bill.Size = UDim2.new(0,200,0,50) bill.StudsOffset = Vector3.new(0,2,0) bill.AlwaysOnTop = true bill.Adornee = handle bill.Parent = handle local text = Instance.new("TextLabel") text.Size = UDim2.new(1,0,1,0) text.BackgroundTransparency = 1 text.TextScaled = true text.Font = Enum.Font.SourceSans text.TextColor3 = Color3.fromRGB(120,0,0) text.TextStrokeTransparency = 0 text.Parent = bill end local dist = math.floor((rootPos - handle.Position).Magnitude) local gui = handle:FindFirstChild("FruitESP") if gui then gui.TextLabel.Text = "Fruit | ??? | < "..dist.." >" end end end end end) task.wait(0.3) end end) else for _, obj in pairs(workspace:GetDescendants()) do if obj.Name == "FruitESP" then obj:Destroy() end end end end })
Tabs.Combat:AddToggle({ Name = "Esp Berry", Default = getgenv().BerryESP, Callback = function(v) getgenv().BerryESP = v if not v then for _, bush in pairs(game:GetService("CollectionService"):GetTagged("BerryBush")) do if bush.Parent:FindFirstChild("BerryESP") then bush.Parent:FindFirstChild("BerryESP"):Destroy() end end end end })
Tabs.Combat:AddSection("Visual Effects ")
Tabs.Combat:AddButton({ Name = "Meteor Rain (Safe)", Callback = function() local lp = game.Players.LocalPlayer if lp.Character and lp.Character.PrimaryPart then local ok, err = pcall(function() require(game:GetService("ReplicatedStorage").Effect.Container.UzothSpec)({ Position = lp.Character.PrimaryPart.Position }) end) if not ok then warn("Meteor error: "..tostring(err)) end end end })
Tabs.Combat:AddButton({ Name = "Remove Portal Dash Cooldown", Callback = function() local lp = game.Players.LocalPlayer local portal = lp.Backpack:FindFirstChild("Portal-Portal") or (lp.Character and lp.Character:FindFirstChild("Portal-Portal")) if portal then pcall(function() local connections = getconnections(portal.Activated) for i = 1, #connections do local conn = connections[i] local func = conn.Function if func and #debug.getupvalues(func) == 9 then task.spawn(function() while portal and portal:IsDescendantOf(game) do debug.setupvalue(func, 2, 0) task.wait(0.1) end end) end end end) end end })
-- === END VISUAL ===


Tabs.Travel:AddSection("Travel")

Tabs.Travel:AddButton({
Name = "Teleport To Sea 1", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("TravelMain")
end})
Tabs.Travel:AddButton({
Name = "Teleport To Sea 2", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
end})
Tabs.Travel:AddButton({
Name = "Teleport To Sea 3", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("TravelZou")
end})
Tabs.Travel:AddSection("Island")
Location = {}
for i,v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do  
  table.insert(Location ,v.Name)
end
Travelllll = Tabs.Travel:AddDropdown({
Name = "Select Island",
Description = "",
Options = Location,
Callback = function(Value)
  _G.Island = Value
end})
GoIsland = Tabs.Travel:AddToggle({
Name = "Teleport To Island", 
Description = "", 
Default = false,
Callback = function(Value)
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

Tabs.Travel:AddSection("NPC")
for _, v in pairs(replicated.NPCs:GetChildren()) do table.insert(NPCList, v.Name)end
NPCsPos = Tabs.Travel:AddDropdown({
Name = "Select NPC",
Options = NPCList,
Callback = function(Value)
  NPClist = Value
end})
GoNPCs = Tabs.Travel:AddToggle({
Name = "Auto Teleport NPC", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.TPNpc = Value
end})
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


-- === SHOP PLOCK FIX CCHAIN NIL ===

local ShopPlayers = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = ShopPlayers.LocalPlayer

local SEA
if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
    SEA = 1
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
    SEA = 2
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
    SEA = 3
else
    SEA = 1
end

_G.BuyFly = false
local TargetPos = nil
local NPCS = {
    BlackLeg={[1]={Vector3.new(-988,13,3996)},[2]={Vector3.new(-4750.61, 35.08, -4846.33)},[3]={Vector3.new(-5043.64,371.35,-3183.40)}},
    Electro={[1]={Vector3.new(-5382.27,14.15,-2150.34)},[2]={Vector3.new(-4863.81, 35.08, -4767.54)},[3]={Vector3.new(-4993.20,314.56,-3198.06)}},
    FishmanKarate={[1]={Vector3.new(61584.35,18.85,988.89)},[2]={Vector3.new(-4960.04, 35.08, -4662.67)},[3]={Vector3.new(-5017.39,371.35,-3187.53)}},
    Superhuman={[2]={Vector3.new(1378.05, 247.43, -5189.37)},[3]={Vector3.new(-4997.53,371.35,-3197.46)}},
    DeathStep={[2]={Vector3.new(6360.04, 296.67, -6763.93)},[3]={Vector3.new(-4997.64,314.56,-3220.37)}},
    SharkmanKarate={[2]={Vector3.new(-2602.40, 239.22, -10314.75)},[3]={Vector3.new(-4970.48,314.56,-3225.04)}},
    ElectricClaw={[3]={Vector3.new(-10369.83,331.69,-10126.49)}},
    DragonTalon={[3]={Vector3.new(5662.03,1211.32,858.60)}},
    GodHuman={[3]={Vector3.new(-13775.56,334.66,-9877.67)}},
    SanguineArt={[3]={Vector3.new(-16514.86,23.18,-190.84)}}
}

local function GetNPCPos(style)
    local data = NPCS[style]
    if not data then return nil end
    if data[SEA] and data[SEA][1] then return data[SEA][1] end
    for sea=1,3 do
        if data[sea] and data[sea][1] then return data[sea][1] end
    end
    return nil
end

local function HRP() return LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") end
local LV, AO
local function EnsureFly()
    local hrp = HRP() if not hrp then return end
    if not LV or LV.Parent ~= hrp then
        if LV then LV:Destroy() end
        LV = Instance.new("LinearVelocity")
        LV.Attachment0 = hrp:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", hrp)
        LV.MaxForce = math.huge
        LV.VectorVelocity = Vector3.zero
        LV.Parent = hrp
    end
    if not AO or AO.Parent ~= hrp then
        if AO then AO:Destroy() end
        AO = Instance.new("AlignOrientation")
        AO.Attachment0 = hrp:FindFirstChildOfClass("Attachment")
        AO.MaxTorque = math.huge
        AO.Responsiveness = 200
        AO.Parent = hrp
    end
end
local function StopFly()
    pcall(function() RunService:UnbindFromRenderStep("BuyFly") end)
    if LV then LV:Destroy() LV=nil end
    if AO then AO:Destroy() AO=nil end
    TargetPos = nil
end
local function FlyTo(pos)
    if not pos then warn("[Shop] CChain: out of radius nil - pos nil") return end
    TargetPos = pos
    RunService:BindToRenderStep("BuyFly", Enum.RenderPriority.Character.Value + 1, function()
        if not _G.BuyFly then StopFly() return end
        local hrp = HRP() if not hrp then return end
        EnsureFly()
        pcall(function() for _,v in ipairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end)
        local delta = TargetPos - hrp.Position
        local dist = delta.Magnitude
        if dist <= 3 then
            LV.VectorVelocity = Vector3.zero
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(TargetPos)
            return
        end
        local dir = delta.Unit
        LV.VectorVelocity = dir * math.clamp(dist * 6, 120, 330)
        AO.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + dir)
    end)
end
local function Buy(style, remote)
    task.spawn(function()
        local pos = GetNPCPos(style)
        if not pos then warn("[Shop] Khong tim thay NPC "..style) return end
        FlyTo(pos)
        repeat task.wait() until (HRP() and (HRP().Position - pos).Magnitude <= 8) or not _G.BuyFly
        if _G.BuyFly then
            pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer(remote) end)
            task.wait(0.5)
            _G.BuyFly = false
            StopFly()
        end
    end)
end
LP.CharacterAdded:Connect(function() task.wait(0.4) if _G.BuyFly and TargetPos then FlyTo(TargetPos) end end)
local function StopAllBuy() _G.BuyFly = false StopFly() end

Tabs.Shop:AddToggle({
	Title = "Buy Black Leg",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("BlackLeg","BuyBlackLeg")
		end
	end
})

Tabs.Shop:AddToggle({
	Title = "Buy Electro",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("Electro","BuyElectro")
		end
	end
})

Tabs.Shop:AddToggle({
	Title = "Buy Fishman Karate",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("FishmanKarate","BuyFishmanKarate")
		end
	end
})

Tabs.Shop:AddToggle({
	Title = "Buy Superhuman",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("Superhuman","BuySuperhuman")
		end
	end
})

Tabs.Shop:AddToggle({
	Title = "Buy Death Step",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("DeathStep","BuyDeathStep")
		end
	end
})

Tabs.Shop:AddToggle({
	Title = "Buy Sharkman Karate",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("SharkmanKarate","BuySharkmanKarate")
		end
	end
})

Tabs.Shop:AddToggle({
	Title = "Buy Electric Claw",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("ElectricClaw","BuyElectricClaw")
		end
	end
})

Tabs.Shop:AddToggle({
	Title = "Buy Dragon Talon",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("DragonTalon","BuyDragonTalon")
		end
	end
})

Tabs.Shop:AddToggle({
	Title = "Buy God Human",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("GodHuman","BuyGodhuman")
		end
	end
})

Tabs.Shop:AddToggle({
	Title = "Buy Sanguine Art",
	Value = false,
	Callback = function(v)
		StopAllBuy()
		if v then
			_G.BuyFly = true
			Buy("SanguineArt","BuySanguineArt")
		end
	end
})

local _ = 
Tabs.Shop:AddSection("Shop Options - Fix Sea")

Tabs.Shop:AddButton({
Name = "Buy Buso Haki", 
Callback = function()
  game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki","Buso")
end})

Tabs.Shop:AddButton({
Name = "Buy Geppo", 
Callback = function()
  game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki","Geppo")
end})

Tabs.Shop:AddButton({
Name = "Buy Soru", 
Callback = function()
  game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki","Soru")
end})

Tabs.Shop:AddButton({
Name = "Buy Ken Haki", 
Callback = function()
  game.ReplicatedStorage.Remotes.CommF_:InvokeServer("KenTalk","Buy")
end})

Tabs.Shop:AddSection("Fighting Style - Khong Can Bay Theo Sea")

-- Fix: Xoa bien SEA, chi goi truc tiep remote, khong can bay den NPC -> het loi CChain nil
Tabs.Shop:AddButton({Name = "Buy Black Leg", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyBlackLeg") end})
Tabs.Shop:AddButton({Name = "Buy Electro", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectro") end})
Tabs.Shop:AddButton({Name = "Buy Fishman Karate", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyFishmanKarate") end})
Tabs.Shop:AddButton({Name = "Buy Dragon Claw", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2") end})
Tabs.Shop:AddButton({Name = "Buy Superhuman", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySuperhuman") end})
Tabs.Shop:AddButton({Name = "Buy Death Step", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDeathStep") end})
Tabs.Shop:AddButton({Name = "Buy Sharkman Karate", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate") end})
Tabs.Shop:AddButton({Name = "Buy Electric Claw", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectricClaw") end})
Tabs.Shop:AddButton({Name = "Buy Dragon Talon", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDragonTalon") end})
Tabs.Shop:AddButton({Name = "Buy Godhuman", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyGodhuman") end})
Tabs.Shop:AddButton({Name = "Buy Sanguine Art", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySanguineArt") end})

Tabs.Shop:AddSection("Sea Event Crafting")

Tabs.Shop:AddButton({Name = "Craft Dragonheart", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CraftItem","Craft","Dragonheart") end})
Tabs.Shop:AddButton({Name = "Craft Dragonstorm", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CraftItem","Craft","Dragonstorm") end})
Tabs.Shop:AddButton({Name = "Craft Dino Hood", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CraftItem","Craft","DinoHood") end})
Tabs.Shop:AddButton({Name = "Craft Shark Tooth Necklace", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CraftItem","Craft","SharkTooth") end})
Tabs.Shop:AddButton({Name = "Craft Terror Jaw", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CraftItem","Craft","TerrorJaw") end})
Tabs.Shop:AddButton({Name = "Craft Shark Anchor", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CraftItem","Craft","SharkAnchor") end})
Tabs.Shop:AddButton({Name = "Craft Leviathan Crown", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CraftItem","Craft","LeviathanCrown") end})
Tabs.Shop:AddButton({Name = "Craft Leviathan Shield", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CraftItem","Craft","LeviathanShield") end})
Tabs.Shop:AddButton({Name = "Craft Leviathan Boat", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CraftItem","Craft","LeviathanBoat") end})
Tabs.Shop:AddButton({Name = "Craft Legendary Scroll", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CraftItem","Craft","LegendaryScroll") end})
Tabs.Shop:AddButton({Name = "Craft Mythical Scroll", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CraftItem","Craft","MythicalScroll") end})

Tabs.Shop:AddSection("Guns & Accessories")

Tabs.Shop:AddButton({Name = "Buy Kabucha [1500F]", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyGun","Kabucha") end})
Tabs.Shop:AddButton({Name = "Buy Bizarre Rifle [250 Ecto]", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyItem","Bizarre Rifle") end})
Tabs.Shop:AddButton({Name = "Buy Black Cape", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyItem","Black Cape") end})
Tabs.Shop:AddButton({Name = "Buy Swordsman Hat", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyItem","Swordsman Hat") end})
Tabs.Shop:AddButton({Name = "Buy Tomoe Ring", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyItem","Tomoe Ring") end})

Tabs.Shop:AddSection("Fragments Shop")

Tabs.Shop:AddButton({Name = "Buy Refund Stats [2500F]", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","2") end})
Tabs.Shop:AddButton({Name = "Buy Race Reroll [3000F]", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","2") end})
Tabs.Shop:AddButton({Name = "Buy Ghoul Race [100 Ecto]", Callback = function() game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Ectoplasm","BuyCheck",4,true) game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Ectoplasm","Change",4,true) end})




local replicated = game:GetService("ReplicatedStorage")




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


-- // AUTO STATS SYSTEM FROM REDZ HUB PLOCK - THAY THEO YEU CAU
local ReplicatedStats = game:GetService("ReplicatedStorage")
local CommF_Stats = ReplicatedStats:WaitForChild("Remotes"):WaitForChild("CommF_")

local AutoStats_Plock = false
local PointsPerTick_Plock = 1

local StatsSelect_Plock = {
    Melee = false,
    Defense = false,
    Sword = false,
    Gun = false,
    BloxFruit = false,
}

local function AddPoint_Plock(Stat, Amount)
    pcall(function()
        CommF_Stats:InvokeServer("AddPoint", Stat, Amount, false)
    end)
end

local function DistributePoints_Plock()
    while AutoStats_Plock do
        task.wait(0.4)
        local player = game.Players.LocalPlayer
        local statsFolder = player:FindFirstChild("Data")
        if not statsFolder then continue end
        local points = statsFolder:FindFirstChild("Points")
        if not points or points.Value <= 0 then continue end
        local EnabledStats = {}
        for stat, enabled in pairs(StatsSelect_Plock) do
            if enabled then
                table.insert(EnabledStats, stat)
            end
        end
        if #EnabledStats > 0 then
            local amountEach = math.floor(PointsPerTick_Plock / #EnabledStats)
            if amountEach < 1 then amountEach = 1 end
            for _, stat in ipairs(EnabledStats) do
                AddPoint_Plock(stat, amountEach)
            end
        end
    end
end

Tabs.Stats:AddSlider({
    Name = "Points Amount",
    Description = "",
    Default = 1,
    Min = 1,
    Max = 500,
    Rounding = 1,
    Callback = function(v)
        PointsPerTick_Plock = v
    end
})

Tabs.Stats:AddToggle({
    Name = "Auto Stats",
    Description = "",
    Default = false,
    Callback = function(v)
        AutoStats_Plock = v
        if v then
            task.spawn(DistributePoints_Plock)
        end
    end
})

Tabs.Stats:AddSection("Select Stats")

Tabs.Stats:AddToggle({
    Name = "Melee",
    Default = false,
    Callback = function(v)
        StatsSelect_Plock.Melee = v
    end
})

Tabs.Stats:AddToggle({
    Name = "Defense",
    Default = false,
    Callback = function(v)
        StatsSelect_Plock.Defense = v
    end
})

Tabs.Stats:AddToggle({
    Name = "Sword",
    Default = false,
    Callback = function(v)
        StatsSelect_Plock.Sword = v
    end
})

Tabs.Stats:AddToggle({
    Name = "Gun",
    Default = false,
    Callback = function(v)
        StatsSelect_Plock.Gun = v
    end
})

Tabs.Stats:AddToggle({
    Name = "Fruit",
    Default = false,
    Callback = function(v)
        StatsSelect_Plock.BloxFruit = v
    end
})




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

Tabs.Settings:AddSection("Other")

walkWater = Tabs.Settings:AddToggle({
Name = "Walk on Water", 
Description = "", 
Default = true,
Callback = function(Value)
  _G.WalkWater_Part = Value
  if _G.WalkWater_Part then
    game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)
  else
    game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 80, 1000)
  end
end
})
iceWalk = Tabs.Settings:AddToggle({
Name = "Ice Walk", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.WalkWater = Value
end})
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

FastAttackModule.Rate = 0.0001
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
                if _G.FastAttack1Mob or getgenv().FastAttack1Mob then
                    break
                end
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
            if _G.FastAttack1Mob or getgenv().FastAttack1Mob then
                break
            end
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
        if _G.FastAttack1Mob or getgenv().FastAttack1Mob then
            return allTargets
        end
    end
    for i = 1, #otherCharacters do
        table.insert(allTargets, otherCharacters[i])
        if _G.FastAttack1Mob or getgenv().FastAttack1Mob then
            break
        end
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
    local foundOneMob = false

    local function ScanFolder(folder)
        local children = folder:GetChildren()
        for i = 1, #children do
            local target = children[i]
            local humanoid = target:FindFirstChild("Humanoid")
            local rootPart = target:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 and target ~= character then
                local distance = (rootPart.Position - humanoidRootPart.Position).Magnitude
                if distance <= 60 then
                    if (_G.FastAttack1Mob or getgenv().FastAttack1Mob) and foundOneMob then
                        return
                    end
                    local targetChildren = target:GetChildren()
                    for _, child in ipairs(targetChildren) do
                        if child:IsA("BasePart") then
                            table.insert(hitTargets, {target, child})
                        end
                    end
                    if _G.FastAttack1Mob or getgenv().FastAttack1Mob then
                        foundOneMob = true
                        return
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



-- Core functions for Show Items (ported from Vxeze)
getgenv().ShowcaseGroups = {
    Weapons = { Sword = 3, Gun = 3, Accessory = 3, Ring = 2 },
    Powers = { ["Blox Fruit"] = 3, ["Fighting Style"] = 0 },
}

getgenv().CreateShowcaseColumn = function(name_, position)
    local frame = Instance.new("Frame")
    frame.Name = name_
    frame.BackgroundTransparency = 1
    frame.Position = position
    frame.Size = UDim2.new(0.5, -12, 0.84, 0)
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingLeft = UDim.new(0, 12)
    uiPadding.PaddingTop = UDim.new(0, 12)
    uiPadding.Parent = frame
    local uiGridLayout = Instance.new("UIGridLayout")
    uiGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
    uiGridLayout.CellSize = UDim2.new(0, 70, 0, 70)
    uiGridLayout.FillDirectionMaxCells = 8
    uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiGridLayout.Parent = frame
    return frame
end

getgenv().AddShowcaseIcon = function(parent, data, layoutOrder)
    local sprite = data.Sprite
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = sprite.Image
    imageLabel.ImageRectOffset = sprite.ImageRectOffset or Vector2.zero
    imageLabel.ImageRectSize = sprite.ImageRectSize or Vector2.zero
    imageLabel.LayoutOrder = layoutOrder
    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.fromScale(1, 1)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeTransparency = 0.4
    textLabel.TextSize = 11
    textLabel.TextXAlignment = Enum.TextXAlignment.Right
    textLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    local item = data.Item
    local txt = (item.Mastery or 0) > 0 and tostring(item.Mastery) or ((item.Count or 1) > 1 and "x"..item.Count or "")
    textLabel.Text = txt
    textLabel.Parent = imageLabel
    imageLabel.Parent = parent
end

getgenv().SetHudVisible = function(visible)
    local main = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main")
    if not main then return end
    for _, v3 in ipairs({ "MenuButton", "HP", "Energy", "Compass" }) do
        local v4 = main:FindFirstChild(v3)
        if v4 then v4.Visible = visible end
    end
    for _, child in ipairs(main:GetChildren()) do
        if child:IsA("ImageButton") then child.Visible = visible end
    end
end

getgenv().GetInventoryItems_Visual = function()
    local n = {}
    local success, result = pcall(function()
        local ItemReplicationService = require(game:GetService("ReplicatedStorage"):WaitForChild("ItemReplicationService"))
        local ItemConfig = require(game:GetService("ReplicatedStorage"):WaitForChild("ItemConfig"))
        local KEYS = require(game:GetService("ReplicatedStorage"):WaitForChild("ItemReplicationService")).KEYS
        for _, item in ItemReplicationService:GetItems(KEYS.QUANTITY) do
            if item.Value and item.Value > 0 then
                local ok, cfg = pcall(function() return ItemConfig.match(item.ItemId):unwrap() end)
                if ok and cfg and cfg.Display then
                    local cat = cfg.Display.Category
                    local storageName = cfg.Index and cfg.Index.StorageKey
                    local displayName = cat == "Blox Fruit" and (storageName or cfg.Display.Name or "ItemId_"..item.ItemId) or (cfg.Display.Name or storageName or "ItemId_"..item.ItemId)
                    local mastery = ItemReplicationService:ReadItem(KEYS.MASTERY, item.ItemId, item.NetworkedUID) or 0
                    table.insert(n, {Name=displayName, Type=cat, Count=item.Value, Mastery=mastery, ItemId=item.ItemId, UID=item.NetworkedUID})
                end
            end
        end
    end)
    return n
end

getgenv().CollectShowcase = function()
    local ItemConfig = require(game:GetService("ReplicatedStorage").ItemConfig)
    local tblWeapons = {}
    local tblPowers = {}
    for _, v in ipairs(GetInventoryItems_Visual()) do
        local targetList = ShowcaseGroups.Weapons[v.Type] and tblWeapons or ShowcaseGroups.Powers[v.Type] and tblPowers
        local minRarity = ShowcaseGroups.Weapons[v.Type] or ShowcaseGroups.Powers[v.Type]
        if targetList then
            local ok, cfg = pcall(function() return ItemConfig.match(v.ItemId):unwrap() end)
            local sprite = ok and cfg.Display and cfg.Display.Sprite
            local rarity = ok and cfg.Quality and cfg.Quality.RarityValue or 0
            if sprite and rarity >= minRarity then
                table.insert(targetList, { Item = v, Sprite = sprite, Rarity = rarity })
            end
        end
    end
    local function sortFn(a,b)
        if a.Rarity ~= b.Rarity then return a.Rarity > b.Rarity end
        return (a.Item.Mastery or 0) > (b.Item.Mastery or 0)
    end
    table.sort(tblWeapons, sortFn)
    table.sort(tblPowers, sortFn)
    return tblWeapons, tblPowers
end

Tabs.Combat:AddButton({
    Name = "Show Items (Weapons & Powers)",
    Description = "Show all weapons and Blox Fruits / fighting styles you own - press again to hide",
    Callback = function()
        local playerGui = game.Players.LocalPlayer.PlayerGui
        local old = playerGui:FindFirstChild("VxezeShowcase")
        if old then
            old:Destroy()
            SetHudVisible(true)
            return
        end
        local weapons, powers = CollectShowcase()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "VxezeShowcase"
        screenGui.IgnoreGuiInset = true
        screenGui.ResetOnSpawn = false
        screenGui.DisplayOrder = 50
        
        -- Background semi-transparent
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1,0,1,0)
        bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
        bg.BackgroundTransparency = 0.5
        bg.Parent = screenGui
        
        local weaponsCol = CreateShowcaseColumn("Weapons", UDim2.new(0, 0, 0, 0))
        local powersCol = CreateShowcaseColumn("Powers", UDim2.new(0.5, 0, 0, 0))
        
        for i, v in ipairs(weapons) do AddShowcaseIcon(weaponsCol, v, i) end
        for i, v in ipairs(powers) do AddShowcaseIcon(powersCol, v, i) end
        
        weaponsCol.Parent = screenGui
        powersCol.Parent = screenGui
        
        -- Title
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1,0,0,50)
        title.BackgroundTransparency = 1
        title.Text = "Weapons: "..#weapons.." | Powers: "..#powers.." - Press Show Items again to hide"
        title.TextColor3 = Color3.new(1,1,1)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 18
        title.Parent = screenGui
        
        screenGui.Parent = playerGui
        SetHudVisible(false)
    end
})

Tabs.Combat:AddButton({
    Name = "Show Beli & Fragments",
    Description = "Show Beli and Fragments on screen like Vxeze",
    Callback = function()
        local playerGui = game.Players.LocalPlayer.PlayerGui
        local exist = playerGui:FindFirstChild("VxezeBeliShow")
        if exist then exist:Destroy() return end
        
        local data = game.Players.LocalPlayer:FindFirstChild("Data")
        local beli = data and data:FindFirstChild("Beli") and data.Beli.Value or 0
        local frag = data and data:FindFirstChild("Fragments") and data.Fragments.Value or 0
        
        local function FormatNumber(num)
            return tostring(math.floor(tonumber(num) or 0)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        end
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "VxezeBeliShow"
        screenGui.ResetOnSpawn = false
        screenGui.DisplayOrder = 50
        screenGui.Parent = playerGui
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(0, 300, 0, 60)
        textLabel.Position = UDim2.new(0.5, -150, 0, 10)
        textLabel.BackgroundColor3 = Color3.fromRGB(30,30,30)
        textLabel.BackgroundTransparency = 0.3
        textLabel.TextColor3 = Color3.new(1,1,1)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 18
        textLabel.Text = '<font color="rgb(90,220,110)">$'..FormatNumber(beli)..'</font>\n<font color="rgb(180,120,255)">ƒ'..FormatNumber(frag)..'</font>'
        textLabel.RichText = true
        textLabel.Parent = screenGui
    end
})



Window:Notify({
  Title = "Script loaded",
  Content = "Redz Hub Loaded Successfully! Press LeftControl to minimize",
  Image = "rbxassetid://15298567397",
  Duration = 10
})



-- ===== HOP TAB FROM REDZ HUB BETA - MERGED INTO SKITRINGX =====
if not HopDelay then HopDelay = 3 end
if not Sec then Sec = 0.1 end

-- Ensure Hop() from Redz Beta exists (override with advanced version)
if not _G.RedzHopLoaded then
_G.RedzHopLoaded = true

-- Advanced Hop function from Redz Hub Beta (avoid same hour, loop servers)
function Hop()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    function TPReturner()
        local Site
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. foundAnything))
        end
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" then
            foundAnything = Site.nextPageCursor
        end
        local num = 0
        for _, v in pairs(Site.data) do
            local Possible = true
            local ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _, Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local _ = pcall(function()
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible then
                    table.insert(AllIDs, ID)
                    wait(0.1)
                    pcall(function()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    wait(1)
                    break
                end
            end
        end
    end
    function Teleport()
        while wait() do
            pcall(function()
                TPReturner()
                if foundAnything ~= "" then
                    TPReturner()
                end
            end)
            wait(HopDelay)
        end
    end
    Teleport()
end

function HopServer()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com/v1/games/"
    local PlaceID = game.PlaceId
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

end

-- ===== Tabs.Material = Hop Tab =====
Tabs.Material:AddSection("Boss Tyrant Hop")

Tabs.Material:AddToggle({
    Name = "Auto Attack or Hop Server Tyrant",
    Default = false,
    Callback = function(Value)
        _G.FarmTyrantHop = Value 
    end
})

spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.FarmTyrantHop then
                local player = plr or game.Players.LocalPlayer
                if not (player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then
                    return
                end
                local hrp = player.Character.HumanoidRootPart
                local enemiesFolder = workspace:FindFirstChild("Enemies") or workspace
                local boss = enemiesFolder:FindFirstChild("Tyrant of the Skies")
                if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    local bossPos = boss.HumanoidRootPart.Position
                    if (hrp.Position - bossPos).Magnitude > 50 then
                        if _tp then
                            pcall(_tp, CFrame.new(bossPos + Vector3.new(0, 30, 0)))
                        elseif Tween then
                            pcall(Tween, CFrame.new(bossPos + Vector3.new(0, 30, 0)))
                        else
                            hrp.CFrame = CFrame.new(bossPos + Vector3.new(0, 30, 0))
                        end
                        wait(1)
                    end
                    repeat
                        if not _G.FarmTyrantHop then break end
                        if AutoHaki then pcall(AutoHaki) end
                        if SelectWeapon and EquipTool then pcall(EquipTool, SelectWeapon) end
                        if Attack and Attack.Kill then
                            pcall(Attack.Kill, boss, _G.FarmTyrantHop)
                        elseif AttackNoCoolDown then
                            pcall(AttackNoCoolDown)
                        end
                        wait()
                    until not _G.FarmTyrantHop or not boss.Parent or boss.Humanoid.Health <= 0
                    Hop()
                    return
                end
                local mobList = {
                    "Serpent Hunter",
                    "Skull Slayer",
                    "Isle Champion",
                    "Sun-kissed Warrior"
                }
                local foundMob = false
                for _, mobName in ipairs(mobList) do
                    if not _G.FarmTyrantHop then break end
                    for _, mob in ipairs(enemiesFolder:GetChildren()) do
                        if not _G.FarmTyrantHop then break end
                        if mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            foundMob = true
                            local mobPos = mob.HumanoidRootPart.Position
                            if (hrp.Position - mobPos).Magnitude > 5000 then
                                if _tp then
                                    pcall(_tp, mob.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                elseif Tween then
                                    pcall(Tween, mob.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                else
                                    hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                                end
                                local t0 = tick()
                                repeat wait() until not _G.FarmTyrantHop or (hrp.Position - mobPos).Magnitude <= 6 or tick() - t0 > 8
                            end
                            repeat
                                if not _G.FarmTyrantHop then break end
                                if AutoHaki then pcall(AutoHaki) end
                                if SelectWeapon and EquipTool then pcall(EquipTool, SelectWeapon) end
                                if Attack and Attack.Kill then
                                    pcall(Attack.Kill, mob, _G.FarmTyrantHop)
                                elseif AttackNoCoolDown then
                                    pcall(AttackNoCoolDown)
                                end
                                wait()
                            until not _G.FarmTyrantHop or not mob.Parent or mob.Humanoid.Health <= 0
                        end
                    end
                end
                if not foundMob then
                    Hop()
                end
            end
        end)
    end
end)

Tabs.Material:AddSection("Boss Rip Indra Hop")

Tabs.Material:AddToggle({
    Name = "Auto Attack or Hop Server Rip Indra",
    Default = false,
    Callback = function(Value)
        _G.Rip_Indra_Hop = Value
    end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Rip_Indra_Hop then
                local v = GetConnectionEnemies("rip_indra")
                if v then
                    repeat wait() Attack.Kill(v, _G.Rip_Indra_Hop) until not _G.Rip_Indra_Hop or not v.Parent or v.Humanoid.Health <= 0
                else
                    Hop()
                end
            end
        end)
    end
end)

Tabs.Material:AddSection("Boss Darkbeard Hop")

Tabs.Material:AddToggle({
    Name = "Auto Attack or Hop Server Darkbeard",
    Default = false,
    Callback = function(Value)
        _G.DarkbeardHop = Value
    end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.DarkbeardHop then
                local v = GetConnectionEnemies("Darkbeard")
                if v then
                    repeat wait() Attack.Kill(v, _G.DarkbeardHop) until not _G.DarkbeardHop or not v.Parent or v.Humanoid.Health <= 0
                else
                    Hop()
                end
            end
        end)
    end
end)

Tabs.Material:AddSection("Boss Elite Hunter Hop")

Tabs.Material:AddToggle({
    Name = "Auto Attack or Hop Server Elites",
    Default = false,
    Callback = function(Value)
        _G.EliteHop = Value
    end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.EliteHop then
                if plr.PlayerGui.Main.Quest.Visible then
                    local title = plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                    if string.find(title, "Diablo") or string.find(title, "Urban") or string.find(title, "Deandre") then
                        for i, v in pairs(replicated:GetChildren()) do
                            if string.find(v.Name, "Diablo") or string.find(v.Name, "Urban") or string.find(v.Name, "Deandre") then
                                if v:FindFirstChild("HumanoidRootPart") then
                                    _tp(v.HumanoidRootPart.CFrame)
                                end
                            end
                        end
                        for i, v in pairs(Enemies:GetChildren()) do
                            if (string.find(v.Name, "Diablo") or string.find(v.Name, "Urban") or string.find(v.Name, "Deandre")) and Attack.Alive(v) then
                                repeat wait() Attack.Kill(v, _G.EliteHop) until not _G.EliteHop or plr.PlayerGui.Main.Quest.Visible == false or not v.Parent or v.Humanoid.Health <= 0
                            end
                        end
                    else
                        Hop()
                    end
                else
                    Hop()
                end
            end
        end)
    end
end)

Tabs.Material:AddSection("Boss Dough King V2 Hop")

Tabs.Material:AddToggle({
    Name = "Auto Attack or Hop Server Dough King",
    Default = false,
    Callback = function(Value)
        _G.DoughKingHop = Value
    end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.DoughKingHop then
                local v = GetConnectionEnemies("Dough King")
                if v then
                    repeat wait() Attack.Kill(v, _G.DoughKingHop) until not _G.DoughKingHop or not v.Parent or v.Humanoid.Health <= 0
                else
                    Hop()
                end
            end
        end)
    end
end)

Tabs.Material:AddSection("Boss Hallow Reaper Hop")

Tabs.Material:AddToggle({
    Name = "Auto Attack or Hop Server Hallow Reaper",
    Default = false,
    Callback = function(Value)
        _G.SoulReaperHop = Value
    end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.SoulReaperHop then
                local v = GetConnectionEnemies("Soul Reaper")
                if v then
                    repeat wait() Attack.Kill(v, _G.SoulReaperHop) until not _G.SoulReaperHop or not v.Parent or v.Humanoid.Health <= 0
                else
                    Hop()
                end
            end
        end)
    end
end)

Tabs.Material:AddSection("Observation Hop Server")

Tabs.Material:AddToggle({
    Name = "Auto Farming or Hop Server Observation [BETA]",
    Default = false,
    Callback = function(Value)
        _G.FruitsFarmingHOP_Obs = Value
        getgenv().AutoObservationHop = Value
        _G.obsFarm = Value
    end
})

spawn(function()      
    while wait(.2) do
        pcall(function()
            if _G.obsFarm or _G.FruitsFarmingHOP_Obs then
                if World1 then
                    local enemy = workspace.Enemies:FindFirstChild("Galley Captain")
                    if enemy then
                        if KenTest then
                            repeat wait()
                                plr.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)
                            until _G.obsFarm == false and _G.FruitsFarmingHOP_Obs == false or KenTest == false
                        else
                            repeat wait()
                                plr.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)
                            until _G.obsFarm == false and _G.FruitsFarmingHOP_Obs == false or KenTest
                        end
                    else
                        if getgenv().AutoObservationHop then
                            Hop()
                            wait(5)
                        else
                            _tp(CFrame.new(5533.29785, 88.1079102, 4852.3916))
                        end
                    end
                elseif World2 then
                    local enemy = workspace.Enemies:FindFirstChild("Lava Pirate")
                    if enemy then
                        if KenTest then
                            repeat wait()
                                plr.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)
                            until _G.obsFarm == false and _G.FruitsFarmingHOP_Obs == false or KenTest == false
                        else
                            repeat wait()
                                plr.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)
                            until _G.obsFarm == false and _G.FruitsFarmingHOP_Obs == false or KenTest
                        end
                    else
                        if getgenv().AutoObservationHop then
                            Hop()
                            wait(5)
                        else
                            _tp(CFrame.new(-5478.39209, 15.9775667, -5246.9126))
                        end
                    end
                elseif World3 then
                    local enemy = workspace.Enemies:FindFirstChild("Venomous Assailant")
                    if enemy then
                        if KenTest then
                            repeat wait()
                                _tp(enemy.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0))
                            until _G.obsFarm == false and _G.FruitsFarmingHOP_Obs == false or KenTest == false
                        else
                            repeat wait()
                                _tp(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0))
                            until _G.obsFarm == false and _G.FruitsFarmingHOP_Obs == false or KenTest
                        end
                    else
                        if getgenv().AutoObservationHop then
                            Hop()
                            wait(5)
                        else
                            _tp(CFrame.new(4530.3540039063, 656.75695800781, -131.60952758789))
                        end
                    end
                end        
            end
        end)
    end
end)

Tabs.Material:AddSection("Fruits Hop Server")

Tabs.Material:AddToggle({
    Name = "Auto Farming or Hop Server Fruits",
    Default = false,
    Callback = function(Value)
        _G.FruitsFarmingHOP = Value
    end
})

spawn(function()
    while wait() do
        if _G.FruitsFarmingHOP then
            pcall(function()
                local fruitFound = false
                for i, v in pairs(game.Workspace:GetChildren()) do
                    if string.find(v.Name, "Fruit") then
                        fruitFound = true
                        _tp(v.Handle.CFrame)
                        break
                    end
                end
                if not fruitFound and _G.FruitsFarmingHOP then
                    wait(1) 
                    Hop()
                end
            end)
        end
        wait(1)
    end
end)

Tabs.Material:AddSection("Chest Hop Server")

Tabs.Material:AddToggle({
    Name = "Auto Hop Server Chest",
    Default = false,
    Callback = function(Value)
        _G.ChestFarmingHOP = Value
    end
})

spawn(function()
    while wait() do
        pcall(function()
            if _G.ChestFarmingHOP then
                local CollectionService = game:GetService("CollectionService")
                local chests = CollectionService:GetTagged("_ChestTagged")
                local chestFound = false
                for _, chest in ipairs(chests) do
                    if chest and not chest:GetAttribute("IsDisabled") then
                        chestFound = true
                        local chestPos
                        local success, result = pcall(function() return chest:GetPivot() end)
                        if success then
                            chestPos = result
                        else
                            local part = chest:FindFirstChildWhichIsA("BasePart")
                            if part then chestPos = part.CFrame end
                        end
                        if chestPos then
                            _tp(chestPos)
                            repeat wait() until not chest.Parent or chest:GetAttribute("IsDisabled") or not _G.ChestFarmingHOP
                        end
                        break 
                    end
                end
                if not chestFound and _G.ChestFarmingHOP then
                    wait(1)
                    Hop()
                end
            end
        end)
        wait(0.5)
    end
end)

Tabs.Material:AddSection("Server Hop Utilities")

Tabs.Material:AddButton({
    Name = "Hop Server (Normal)",
    Callback = function()
        Hop()
    end
})

Tabs.Material:AddButton({
    Name = "Hop Server Low Player",
    Callback = function()
        HopServer()
    end
})

Tabs.Material:AddButton({
    Name = "Rejoin Same Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

-- End of Redz Hop Merge



-- ===== STATUS TAB FROM REDZ HUB BETA - MERGED INTO SKITRINGX INFO TAB =====
-- Only taking exact functions from Redz Status tab, not from other tabs

-- Helper to support both SetDesc and SetDescription
local function SetParagraphDesc(paragraph, text)
    if not paragraph then return end
    pcall(function()
        if paragraph.SetDesc then
            paragraph:SetDesc(text)
        elseif paragraph.SetDescription then
            paragraph:SetDescription(text)
        elseif paragraph.SetTitle then
            paragraph:SetTitle(text)
        end
    end)
end

-- Add Boss Status section from Redz

-- Elite Hunter - Only from Status tab
spawn(function()
    while task.wait(1) do
        pcall(function()
            local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") or 
                              game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") or 
                              game:GetService("ReplicatedStorage"):FindFirstChild("Urban") or 
                              game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or 
                              game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or 
                              game:GetService("Workspace").Enemies:FindFirstChild("Urban")) and '🟢' or '🔴'
            SetParagraphDesc(EliteHunterStatus, "Status: " .. currentStatus)
        end)
    end
end)

-- Cake Prince with Kill Count - Improved version from Redz Status tab
spawn(function()
    while task.wait(1) do
        pcall(function()
            local cakePrince = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
            if string.len(cakePrince) >= 86 then
                local killCount = string.sub(cakePrince, 39, 41)
                SetParagraphDesc(CakePrinceRedz, "Status: 🔴 Need Kill " .. killCount .. " Mobs")
            else
                SetParagraphDesc(CakePrinceRedz, "Status: 🔴")
            end
        end)
    end
end)

-- Tyrant of the Skies - From Redz Status tab
spawn(function()
    pcall(function()
        while task.wait(1) do
            if workspace["Enemies"]:FindFirstChild("Tyrant of the Skies") then
                SetParagraphDesc(TyrantStatusRedz, "Status: ✅")
            else
                SetParagraphDesc(TyrantStatusRedz, "Status: ❌")
            end
        end
    end)
end)

-- Dough King - From Redz Status tab (already exists in SkitringX but add Redz version)
spawn(function()
    while task.wait(1) do
        pcall(function()
            local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("Dough King") or 
                              game:GetService("Workspace").Enemies:FindFirstChild("Dough King")) and '🟢' or '🔴'
            SetParagraphDesc(DoughKingRedz, "Status: " .. currentStatus)
        end)
    end
end)

-- rip_indra True Form - From Redz Status tab
spawn(function()
    while task.wait(1) do
        pcall(function()
            local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form") or 
                              game:GetService("Workspace").Enemies:FindFirstChild("rip_indra")) and '🟢' or '🔴'
            SetParagraphDesc(RipIndraRedz, "Status: " .. currentStatus)
        end)
    end
end)

-- Spy Leviathan - From Redz Status tab
spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local spycheck = string.match(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("InfoLeviathan","1"),"%d+")
            if spycheck then 
                if tostring(spycheck) == "5" then
                    SetParagraphDesc(SpyLeviathanStatus, "Status: 🟢 (Full)")
                else
                    SetParagraphDesc(SpyLeviathanStatus, "Spy Leviathan: "..tostring(spycheck).."/5")
                end
            end
        end)
    end
end)


-- Full Moon - From Redz Status tab
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local moonTextureId = game:GetService("Lighting").Sky.MoonTextureId
            local moonStatus = "Bad Moon | 0"
            if moonTextureId == "http://www.roblox.com/asset/?id=9709149431" then
                moonStatus = "Full Moon | 5"
            elseif moonTextureId == "http://www.roblox.com/asset/?id=9709149052" then
                moonStatus = "Near Full Moon | 4"
            elseif moonTextureId == "http://www.roblox.com/asset/?id=9709143733" then
                moonStatus = "Bad Moon | 3"
            elseif moonTextureId == "http://www.roblox.com/asset/?id=9709150401" then
                moonStatus = "Bad Moon | 2"
            elseif moonTextureId == "http://www.roblox.com/asset/?id=9709149680" then
                moonStatus = "Bad Moon | 1"
            end
            SetParagraphDesc(FullMoonRedz, "Status: " .. moonStatus)
        end)
    end
end)

-- Legendary Sword - From Redz Status tab
spawn(function()
    while task.wait(1) do
        pcall(function()
            local swordStatus = "🔴"
            if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1") or
               game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2") or
               game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "3") then
                swordStatus = "🟢"
            end
            SetParagraphDesc(LegendarySwordRedz, "Status: " .. swordStatus)
        end)
    end
end)

-- Sea Status from Redz

-- Current Sea - From Redz Status tab
spawn(function()
    while task.wait(1) do
        pcall(function()
            local sea = "Sea 1"
            if game:GetService("Workspace").Map:FindFirstChild("SecondSea") then
                sea = "Sea 2"
            elseif game:GetService("Workspace").Map:FindFirstChild("ThirdSea") then
                sea = "Sea 3"
            end
            SetParagraphDesc(SeaStatusRedz, "You are in: " .. sea)
        end)
    end
end)

-- Game Time - From Redz Status tab (ClockTime version)
spawn(function()
    while task.wait(1) do
        pcall(function()
            local time = game:GetService("Lighting").ClockTime
            local hour = math.floor(time)
            local minute = math.floor((time - hour) * 60)
            SetParagraphDesc(GameTimeRedz, string.format("Time: %02d:%02d", hour, minute))
        end)
    end
end)

-- End of Redz Status Merge
