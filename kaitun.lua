Config = {
    Team = "Pirates",
    Configuration = {
        HopWhenIdle = true,
        AutoHop = true,
        AutoHopDelay = 60 * 60,
        FpsBoost = false,
        blackscreen = false,
        LowGraphics = true
    },
    Items = {
        AutoFullyMelees = true,
        Saber = true,
        CursedDualKatana = true,
        SoulGuitar = true,
        RaceV2 = true,
        AutoRaceV3 = true,
        AutoRandomFruit = false,
    },
    Sword = {
        ["Shark Saw"]        = true,
        ["Wardens Sword"]    = true,
        ["Pole (1st Form)"]  = true,
        ["Gravity Blade"]    = true,
        ["Longsword"]        = true,
        ["Rengoku"]          = true,
        ["Flail"]            = true,
        ["Twin Hooks"]       = true,
    },
    BossWeapons = {
        ["Awakened Ice Admiral"] = true,
        ["Tide Keeper"]          = true,
        ["Deandre"]              = true,
        ["Urban"]                = true,
        ["Diablo"]               = true,
        ["Soul Reaper"]          = true,
        ["Cake Prince"]          = true,
        ["Core"]                 = true,
        ["Darkbeard"]            = true,
        ["Katakuri"]             = true,
        ["Beautiful Pirates"]    = true,
    },
    Melee = {
        AutoBuy              = true,
        CheckMasteryAfterBuy = true,
        RaidAtV1Mastery      = 500,
        GodhumanAtV2Mastery  = 400,
    },
    AutoKen = true,
    BringMobs = true,
    PanicMode = {
        Enabled          = true,
        LowHealthPercent = 20,
        SafeHealthPercent = 75,
        EscapeHeight     = 2000,
        CheckInterval    = 1,
    },
    Settings = {
        StayInSea2UntilHaveDarkFragments = true
    },
    AutoSea2 = true,
    AutoSea3 = true,
    AutoRaidIce_TargetFragments = 5000,
}
print("[Tiro] Script da duoc nap, dang cho game load...")
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer

print("[Main] Bắt đầu Tiro Kaitun Modulo v2.2...")
timeee = os.time()
local W_angle = 30
local lastChange = tick()

-- ============================================================
-- [ADDED] CHỌN VŨ KHÍ (TỪ T-REX HUB)
-- ============================================================
_G.ChooseWP = "Melee"  -- Mặc định Melee (có thể đổi thành Sword, Gun, Blox Fruit)
_G.SelectWeapon = nil

-- Luồng tự động cập nhật vũ khí
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if not bp then return end
            if _G.ChooseWP == "Melee" then
                for _, v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Melee" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            elseif _G.ChooseWP == "Sword" then
                for _, v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Sword" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            elseif _G.ChooseWP == "Gun" then
                for _, v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Gun" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            elseif _G.ChooseWP == "Blox Fruit" then
                for _, v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- [ADDED] GAME DATA (từ data_lua.txt) — bảng tham chiếu thuần
-- KHÔNG wire vào đâu trực tiếp; dùng khi cần tra level→mob/quest
-- ============================================================
local GameData = {
	QUESTS = {
		Sea_1 = {
			{1, 9, "Team-dependent", "Team-dependent", 1},
			{10, 14, "Monkey", "JungleQuest", 1},
			{15, 29, "Gorilla", "JungleQuest", 2, "The Gorilla King", 20},
			{30, 39, "Pirate", "BuggyQuest1", 1},
			{40, 59, "Brute", "BuggyQuest1", 2, "Chief", 55},
			{60, 74, "Desert Bandit", "DesertQuest", 1},
			{75, 89, "Desert Officer", "DesertQuest", 2},
			{90, 99, "Snow Bandit", "SnowQuest", 1},
			{100, 119, "Snowman", "SnowQuest", 2, "Yeti", 105},
			{120, 149, "Chief Petty Officer", "MarineQuest2", 1, "Vice Admiral", 130},
			{150, 174, "Sky Bandit", "SkyQuest", 1},
			{175, 189, "Dark Master", "SkyQuest", 2},
			{190, 209, "Prisoner", "PrisonerQuest", 1},
			{210, 249, "Dangerous Prisoner", "PrisonerQuest", 2, {"Warden", 220, "ImpelQuest", 1}, {"Chief Warden", 230, "ImpelQuest", 2}, {"Swan", 240, "ImpelQuest", 3}},
			{250, 274, "Toga Warrior", "ColosseumQuest", 1},
			{275, 299, "Gladiator", "ColosseumQuest", 2},
			{300, 324, "Military Soldier", "MagmaQuest", 1},
			{325, 374, "Military Spy", "MagmaQuest", 2, "Magma Admiral", 350},
			{375, 399, "Fishman Warrior", "FishmanQuest", 1},
			{400, 449, "Fishman Commando", "FishmanQuest", 2, "Fishman Lord", 425},
			{450, 474, "God's Guard", "SkyExp1Quest", 1},
			{475, 524, "Shanda", "SkyExp1Quest", 2, "Wysper", 500},
			{525, 549, "Royal Squad", "SkyExp2Quest", 1},
			{550, 624, "Royal Soldier", "SkyExp2Quest", 2, "Thunder God", 575},
			{625, 649, "Galley Pirate", "FountainQuest", 1},
			{650, 9999, "Galley Captain", "FountainQuest", 2, "Cyborg", 675},
		},
		Sea_2 = {
			{700, 724, "Raider", "Area1Quest", 1},
			{725, 774, "Mercenary", "Area1Quest", 2, "Diamond", 750},
			{775, 799, "Swan Pirate", "Area2Quest", 1},
			{800, 874, "Factory Staff", "Area2Quest", 2, "Jeremy", 850},
			{875, 899, "Marine Lieutenant", "MarineQuest3", 1},
			{900, 949, "Marine Captain", "MarineQuest3", 2, "Orbitus", 925},
			{950, 974, "Zombie", "ZombieQuest", 1},
			{975, 999, "Vampire", "ZombieQuest", 2},
			{1000, 1049, "Snow Trooper", "SnowMountainQuest", 1},
			{1050, 1099, "Winter Warrior", "SnowMountainQuest", 2},
			{1100, 1124, "Lab Subordinate", "IceSideQuest", 1},
			{1125, 1174, "Horned Warrior", "IceSideQuest", 2, "Smoke Admiral", 1150},
			{1175, 1199, "Magma Ninja", "FireSideQuest", 1},
			{1200, 1249, "Lava Pirate", "FireSideQuest", 2},
			{1250, 1274, "Ship Deckhand", "ShipQuest1", 1},
			{1275, 1299, "Ship Engineer", "ShipQuest1", 2},
			{1300, 1324, "Ship Steward", "ShipQuest2", 1},
			{1325, 1349, "Ship Officer", "ShipQuest2", 2},
			{1350, 1374, "Arctic Warrior", "FrostQuest", 1},
			{1375, 1424, "Snow Lurker", "FrostQuest", 2, "Awakened Ice Admiral", 1400},
			{1425, 1449, "Sea Soldier", "ForgottenQuest", 1},
			{1450, 9999, "Water Fighter", "ForgottenQuest", 2, "Tide Keeper", 1475},
		},
		Sea_3 = {
			{1500, 1524, "Pirate Millionaire", "PiratePortQuest", 1},
			{1525, 1574, "Pistol Billionaire", "PiratePortQuest", 2},
			{1575, 1599, "Dragon Crew Warrior", "DragonCrewQuest", 1},
			{1600, 1624, "Dragon Crew Archer", "DragonCrewQuest", 2},
			{1625, 1649, "Hydra Enforcer", "VenomCrewQuest", 1},
			{1650, 1699, "Venomous Assailant", "VenomCrewQuest", 2},
			{1700, 1724, "Marine Commodore", "MarineTreeIsland", 1},
			{1725, 1774, "Marine Rear Admiral", "MarineTreeIsland", 2},
			{1775, 1799, "Fishman Raider", "DeepForestIsland3", 1},
			{1800, 1824, "Fishman Captain", "DeepForestIsland3", 2},
			{1825, 1849, "Forest Pirate", "DeepForestIsland", 1},
			{1850, 1899, "Mythological Pirate", "DeepForestIsland", 2},
			{1900, 1924, "Jungle Pirate", "DeepForestIsland2", 1},
			{1925, 1974, "Musketeer Pirate", "DeepForestIsland2", 2},
			{1975, 1999, "Reborn Skeleton", "HauntedQuest1", 1},
			{2000, 2024, "Living Zombie", "HauntedQuest1", 2},
			{2025, 2049, "Demonic Soul", "HauntedQuest2", 1},
			{2050, 2074, "Posessed Mummy", "HauntedQuest2", 2},
			{2075, 2099, "Peanut Scout", "NutsIslandQuest", 1},
			{2100, 2124, "Peanut President", "NutsIslandQuest", 2},
			{2125, 2149, "Ice Cream Chef", "IceCreamIslandQuest", 1},
			{2150, 2199, "Ice Cream Commander", "IceCreamIslandQuest", 2},
			{2200, 2224, "Cookie Crafter", "CakeQuest1", 1},
			{2225, 2249, "Cake Guard", "CakeQuest1", 2},
			{2250, 2274, "Baking Staff", "CakeQuest2", 1},
			{2275, 2299, "Head Baker", "CakeQuest2", 2},
			{2300, 2324, "Cocoa Warrior", "ChocQuest1", 1},
			{2325, 2349, "Chocolate Bar Battler", "ChocQuest1", 2},
			{2350, 2374, "Sweet Thief", "ChocQuest2", 1},
			{2375, 2399, "Candy Rebel", "ChocQuest2", 2},
			{2400, 2424, "Candy Pirate", "CandyQuest1", 1},
			{2425, 2449, "Snow Demon", "CandyQuest1", 2},
			{2450, 2474, "Isle Outlaw", "TikiQuest1", 1},
			{2475, 2499, "Island Boy", "TikiQuest1", 2},
			{2500, 2524, "Sun-kissed Warrior", "TikiQuest2", 1},
			{2525, 2549, "Isle Champion", "TikiQuest2", 2},
			{2550, 2574, "Serpent Hunter", "TikiQuest3", 1},
			{2575, 2599, "Skull Slayer", "TikiQuest3", 2},
			{2600, 2624, "Reef Bandit", "SubmergedQuest1", 1},
			{2625, 2649, "Coral Pirate", "SubmergedQuest1", 2},
			{2650, 2674, "Sea Chanter", "SubmergedQuest2", 1},
			{2675, 2699, "High Disciple", "SubmergedQuest3", 1},
			{2700, 9999, "Grand Devotee", "SubmergedQuest3", 2},
		}
	},
	BossList = {
		Sea_1 = {
			{20, "The Gorilla King", "JungleQuest", 3, CFrame.new(-1602, 37, 153)},
			{55, "Chief", "BuggyQuest1", 2, CFrame.new(-1140, 5, 3827)},
			{105, "Yeti", "SnowQuest", 3, CFrame.new(1387, 87, -1298)},
			{130, "Vice Admiral", "MarineQuest2", 2, CFrame.new(-5036, 29, 4325)},
			{220, "Warden", "ImpelQuest", 1, CFrame.new(5192, 3, 686)},
			{230, "Chief Warden", "ImpelQuest", 2, CFrame.new(5192, 3, 686)},
			{240, "Swan", "ImpelQuest", 3, CFrame.new(5192, 3, 686)},
			{350, "Magma Admiral", "MagmaQuest", 3, CFrame.new(-5315, 12, 8517)},
			{425, "Fishman Lord", "FishmanQuest", 3, CFrame.new(61123, 18, 1569)},
			{500, "Wysper", "SkyExp1Quest", 3, CFrame.new(-7862, 5546, -380)},
			{575, "Thunder God", "SkyExp2Quest", 3, CFrame.new(-7903, 5636, -1411)},
			{675, "Cyborg", "FountainQuest", 3, CFrame.new(5258, 39, 4050)},
		},
		Sea_2 = {
			{750, "Diamond", "Area1Quest", 3, CFrame.new(-428, 73, 1835)},
			{850, "Jeremy", "Area2Quest", 3, CFrame.new(637, 73, 918)},
			{925, "Orbitus", "MarineQuest3", 3, CFrame.new(-2442, 73, -3218)},
			{1150, "Smoke Admiral", "IceSideQuest", 3, CFrame.new(-5429, 16, -5298)},
			{1400, "Awakened Ice Admiral", "FrostQuest", 3, CFrame.new(5669, 29, -6483)},
			{1475, "Tide Keeper", "ForgottenQuest", 3, CFrame.new(-3054, 237, -10145)},
		},
		Sea_3 = {
			{1575, "Stone", "PiratePortQuest", 3, CFrame.new(-290, 44, 5580)},
			{1775, "Kilo Admiral", "MarineTreeIsland", 3, CFrame.new(2179, 29, -6740)},
			{1875, "Captain Elephant", "DeepForestIsland", 3, CFrame.new(-13233, 332, -7626)},
			{1950, "Beautiful Pirate", "DeepForestIsland2", 3, CFrame.new(-12682, 391, -9902)},
			{2175, "Cake Queen", "IceCreamIslandQuest", 3, CFrame.new(-819, 65, -10967)},
		}
	},
	MaterialEnemies = {
		Sea_1 = {
			["Angel Wings"] = { "Shanda", "Royal Squad", "Royal Soldier", "Wysper", "Thunder God" },
			["Leather + Scrap Metal"] = { "Brute", "Pirate" },
			["Magma Ore"] = { "Military Soldier", "Military Spy", "Magma Admiral" },
			["Fish Tail"] = { "Fishman Warrior", "Fishman Commando", "Fishman Lord" },
		},
		Sea_2 = {
			["Leather + Scrap Metal"] = { "Marine Captain" },
			["Magma Ore"] = { "Magma Ninja", "Lava Pirate" },
			["Ectoplasm"] = { "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer" },
			["Mystic Droplet"] = { "Water Fighter" },
			["Radioactive Material"] = { "Factory Staff" },
			["Vampire Fang"] = { "Vampire" },
		},
		Sea_3 = {
			["Leather + Scrap Metal"] = { "Jungle Pirate" },
			["Demonic Wisp"] = { "Demonic Soul" },
			["Fish Tail"] = { "Fishman Raider", "Fishman Captain" },
			["Conjured Cocoa"] = { "Chocolate Bar Battler", "Cocoa Warrior" },
			["Dragon Scale"] = { "Dragon Crew Archer", "Dragon Crew Warrior" },
			["Gunpowder"] = { "Pistol Billionaire" },
			["Mini Tusk"] = { "Mythological Pirate" },
			["Nightmare Catcher"] = { "Reborn Skeleton", "Living Zombie" },
		}
	},
	Materials = {
		Sea_1 = { "Leather + Scrap Metal", "Angel Wings", "Magma Ore", "Fish Tail" },
		Sea_2 = { "Leather + Scrap Metal", "Radioactive Material", "Ectoplasm", "Mystic Droplet", "Magma Ore", "Vampire Fang" },
		Sea_3 = { "Leather + Scrap Metal", "Demonic Wisp", "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Fish Tail", "Mini Tusk", "Nightmare Catcher" }
	},
	BossNames = {
		Sea_1 = { "The Gorilla King", "Chief", "Yeti", "Vice Admiral", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Saw" },
		Sea_2 = { "Diamond", "Jeremy", "Orbitus", "Smoke Admiral", "Awakened Ice Admiral", "Tide Keeper", "Don Swan" },
		Sea_3 = { "Stone", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Cake Queen" }
	},
	MeleeNames = {
		Sea_1 = { "Black Leg", "Electro", "Fishman Karate" },
		Sea_2 = { "Death Step", "Dragon Claw", "Sharkman Karate", "Superhuman" },
		Sea_3 = { "Dragon Talon", "Electric Claw", "Godhuman", "Sanguine Art" }
	},
	Melees = {
		["Black Leg"] = {
			Model = "Dark Step Teacher",
			Npc = "Dark Step Teacher",
			npc = "Dark Step Teacher",
			CFrame = CFrame.new(-1147.284, 4.752, 3816.326),
			cframe = CFrame.new(-1147.284, 4.752, 3816.326),
			Remote = { "BuyBlackLeg" },
			remote = { "BuyBlackLeg" },
			Sea = 1
		},
		["Electro"] = {
			Model = "Mad Scientist",
			Npc = "Mad Scientist",
			npc = "Mad Scientist",
			CFrame = CFrame.new(-4842.112, 717.670, -2623.149),
			cframe = CFrame.new(-4842.112, 717.670, -2623.149),
			Remote = { "BuyElectro" },
			remote = { "BuyElectro" },
			Sea = 1
		},
		["Fishman Karate"] = {
			Model = "Water Kung-fu Teacher",
			Npc = "Water Kung-fu Teacher",
			npc = "Water Kung-fu Teacher",
			CFrame = CFrame.new(61122.652, 18.497, 1568.351),
			cframe = CFrame.new(61122.652, 18.497, 1568.351),
			Remote = { "BuyFishmanKarate" },
			remote = { "BuyFishmanKarate" },
			Sea = 1
		},
		["Dragon Claw"] = {
			Model = "Sabi",
			Npc = "Sabi",
			npc = "Sabi",
			CFrame = CFrame.new(699.029, 185.661, 654.895),
			cframe = CFrame.new(699.029, 185.661, 654.895),
			CFrames = {
				Sea_2 = CFrame.new(699.029, 185.661, 654.895),
			},
			cframes = {
				Sea_2 = CFrame.new(699.029, 185.661, 654.895),
			},
			Remote = { { "BlackbeardReward", "DragonClaw", "1" }, { "BlackbeardReward", "DragonClaw", "2" } },
			remote = { { "BlackbeardReward", "DragonClaw", "1" }, { "BlackbeardReward", "DragonClaw", "2" } },
			Sea = 2
		},
		["Superhuman"] = {
			Model = "Martial Arts Master",
			Npc = "Martial Arts Master",
			npc = "Martial Arts Master",
			CFrame = CFrame.new(1377.125, 246.542, -5189.951),
			cframe = CFrame.new(1377.125, 246.542, -5189.951),
			CFrames = {
				Sea_2 = CFrame.new(1377.125, 246.542, -5189.951),
			},
			cframes = {
				Sea_2 = CFrame.new(1377.125, 246.542, -5189.951),
			},
			Remote = { "BuySuperhuman" },
			remote = { "BuySuperhuman" },
			Sea = 2
		},
		["Death Step"] = {
			Model = "Phoeyu, the Reformed",
			Npc = "Phoeyu, the Reformed",
			npc = "Phoeyu, the Reformed",
			CFrame = CFrame.new(6356.472, 296.100, -6762.771),
			cframe = CFrame.new(6356.472, 296.100, -6762.771),
			CFrames = {
				Sea_2 = CFrame.new(6356.472, 296.100, -6762.771),
			},
			cframes = {
				Sea_2 = CFrame.new(6356.472, 296.100, -6762.771),
			},
			Remote = { "BuyDeathStep" },
			remote = { "BuyDeathStep" },
			Sea = 2
		},
		["Sharkman Karate"] = {
			Model = "Sharkman Teacher",
			Npc = "Sharkman Teacher",
			npc = "Sharkman Teacher",
			CFrame = CFrame.new(-2599.622, 238.198, -10315.998),
			cframe = CFrame.new(-2599.622, 238.198, -10315.998),
			CFrames = {
				Sea_2 = CFrame.new(-2599.622, 238.198, -10315.998),
			},
			cframes = {
				Sea_2 = CFrame.new(-2599.622, 238.198, -10315.998),
			},
			Remote = { "BuySharkmanKarate" },
			remote = { "BuySharkmanKarate" },
			Sea = 2
		},
		["Electric Claw"] = {
			Model = "Previous Hero",
			Npc = "Previous Hero",
			npc = "Previous Hero",
			CFrame = CFrame.new(-10368.514, 331.788, -10134.120),
			cframe = CFrame.new(-10368.514, 331.788, -10134.120),
			CFrames = {
				Sea_3 = CFrame.new(-10368.514, 331.788, -10134.120),
			},
			cframes = {
				Sea_3 = CFrame.new(-10368.514, 331.788, -10134.120),
			},
			Remote = { "BuyElectricClaw" },
			remote = { "BuyElectricClaw" },
			Sea = 3
		},
		["Dragon Talon"] = {
			Model = "Uzoth",
			Npc = "Uzoth",
			npc = "Uzoth",
			CFrame = CFrame.new(-9515.372, 142.130, 5535.089),
			cframe = CFrame.new(-9515.372, 142.130, 5535.089),
			CFrames = {
				Sea_3 = CFrame.new(-9515.372, 142.130, 5535.089),
			},
			cframes = {
				Sea_3 = CFrame.new(-9515.372, 142.130, 5535.089),
			},
			Remote = { "BuyDragonTalon" },
			remote = { "BuyDragonTalon" },
			Sea = 3
		},
		["Godhuman"] = {
			Model = "Ancient Monk",
			Npc = "Ancient Monk",
			npc = "Ancient Monk",
			CFrame = CFrame.new(-12463.870, 374.910, -7523.770),
			cframe = CFrame.new(-12463.870, 374.910, -7523.770),
			CFrames = {
				Sea_3 = CFrame.new(-12463.870, 374.910, -7523.770),
			},
			cframes = {
				Sea_3 = CFrame.new(-12463.870, 374.910, -7523.770),
			},
			Remote = { "BuyGodhuman" },
			remote = { "BuyGodhuman" },
			Sea = 3
		},
		["Sanguine Art"] = {
			Model = "Shafi",
			Npc = "Shafi",
			npc = "Shafi",
			CFrame = CFrame.new(-16548.800, 12.000, 412.300),
			cframe = CFrame.new(-16548.800, 12.000, 412.300),
			CFrames = {
				Sea_3 = CFrame.new(-16548.800, 12.000, 412.300),
			},
			cframes = {
				Sea_3 = CFrame.new(-16548.800, 12.000, 412.300),
			},
			Remote = { { "BuySanguineArt", true }, { "BuySanguineArt" } },
			remote = { { "BuySanguineArt", true }, { "BuySanguineArt" } },
			Sea = 3
		},
	},
	ItemsToBuy = {
		["Frags"] = {
			["Race Rerol"] = { "BlackbeardReward", "Reroll", "2" },
			["Reset Stats"] = { "BlackbeardReward", "Refund", "2" }
		},
		["Ability"] = {
			["Geppo"] = { "BuyHaki", "Geppo" },
			["Buso Haki"] = { "BuyHaki", "Buso" },
			["Soru"] = { "BuyHaki", "Soru" },
			["Observation Haki"] = { "KenTalk", "Buy" }
		},
		["Gun"] = {
			["Slingshot"] = { "BuyItem", "Slingshot" },
			["Musket"] = { "BuyItem", "Musket" },
			["Flintlock"] = { "BuyItem", "Flintlock" },
			["Refined Slingshot"] = { "BuyItem", "Refined Flintlock" },
			["Refined Flintlock"] = { "BuyItem", "Refined Flintlock" },
			["Cannon"] = { "BuyItem", "Cannon" },
			["Kabucha"] = { "BlackbeardReward", "Slingshot", "1" },
			["Bizarre Rifle"] = { "Ectoplasm", "Buy", 1 }
		},
		["Accessory"] = {
			["Black Cape"] = { "Black Cape" },
			["Swordsman Hat"] = { "Swordsman Hat" },
			["Tomoe Ring"] = { "Tomoe Ring" }
		},
		["Sword"] = {
			["Cutlass"] = { "Cutlass" },
			["Katana"] = { "Katana" },
			["Iron Mace"] = { "Iron Mace" },
			["Dual Katana"] = { "Duel Katana" },
			["Triple Katana"] = { "Triple Katana" },
			["Pipe"] = { "Pipe" },
			["Dual-Headed Blade"] = { "Dual-Headed Blade" },
			["Bisento"] = { "Bisento" },
			["Soul Cane"] = { "Soul Cane" },
			["Pole v.2"] = { "ThunderGodTalk" }
		}
	},
	Islands = {
		["Sea 1"] = {
			["Pirate Starter"] = CFrame.new(1047, 15, 1506),
			["Marine Starter"] = CFrame.new(-2728, 25, 2056),
			["Middle Town"] = CFrame.new(-688, 15, 1585),
			["Jungle"] = CFrame.new(-1614, 37, 146),
			["Pirate Village"] = CFrame.new(-1173, 45, 3837),
			["Desert"] = CFrame.new(944, 21, 4373),
			["Frozen Village"] = CFrame.new(1298, 87, -1344),
			["Marine Fortress"] = CFrame.new(-4810, 21, 4359),
			["Colosseum"] = CFrame.new(-1535, 7, -3014),
			["Lower Skylands"] = CFrame.new(-4814, 718, -2551),
			["Skylands"] = CFrame.new(-4652, 873, -1754),
			["Upper Skylands"] = CFrame.new(-7895, 5547, -380),
			["Prison"] = CFrame.new(4870, 6, 736),
			["Magma Village"] = CFrame.new(-5290, 9, 8349),
			["Underwater City"] = CFrame.new(61164, 5, 1820),
			["Fountain City"] = CFrame.new(5757, 91, 4017),
			["Jean-Luc Island"] = CFrame.new(-2850, 7, 5355),
		},
		["Sea 2"] = {
			["The Cafe"] = CFrame.new(-382, 73, 290),
			["First Spot"] = CFrame.new(-11, 29, 2771),
			["Dark Arena"] = CFrame.new(3494, 13, -3259),
			["Don Swan Mansion"] = CFrame.new(-317, 331, 597),
			["Don Swan Room"] = CFrame.new(2285, 15, 905),
			["Green Zone"] = CFrame.new(-2258, 73, -2696),
			["Graveyard"] = CFrame.new(-5552, 194, -776),
			["Snow Mountain"] = CFrame.new(752, 408, -5277),
			["Hot and Cold"] = CFrame.new(-6008, 29, -5018),
			["Cursed Ship"] = CFrame.new(919, 125, 32869),
			["Ice Castle"] = CFrame.new(5505, 40, -6178),
			["Forgotten Island"] = CFrame.new(-3050, 240, -10178),
			["Remote Island"] = CFrame.new(4816, 8, 2863),
		},
		["Sea 3"] = {
			["Mansion"] = CFrame.new(-12471, 374, -7551),
			["Port Town"] = CFrame.new(-340, 21, 5524),
			["Great Tree"] = CFrame.new(2205, 22, -6766),
			["Castle On The Sea"] = CFrame.new(-4980, 314, -3018),
			["Hydra Island"] = CFrame.new(5294, 1005, 391),
			["Floating Turtle"] = CFrame.new(-12528, 332, -8658),
			["Haunted Castle"] = CFrame.new(-9517, 142, 5528),
			["Ice Cream Land"] = CFrame.new(-843, 66, -10944),
			["Peanut Land"] = CFrame.new(-2082, 38, -10190),
			["Cake Land"] = CFrame.new(-1897, 14, -11576),
			["Candy Cane Land"] = CFrame.new(-1094, 64, -14519),
			["Chocolate Land"] = CFrame.new(219, 127, -12604),
			["Tiki Outpost"] = CFrame.new(-16224, 9, 439),
		}
	},
	PortalLocations = {
		Sea_1 = {
			Vector3.new(-7894.62, 5545.49, -380.25),
			Vector3.new(-4607.82, 872.54, -1667.56),
			Vector3.new(61163.85, 11.76, 1819.78),
			Vector3.new(3876.28, 35.11, -1939.32)
		},
		Sea_2 = {
			Vector3.new(-288.46, 306.13, 598),
			Vector3.new(2284.91, 15.15, 905.48),
			Vector3.new(923.21, 126.98, 32852.83),
			Vector3.new(-6508.56, 89.03, -132.84)
		},
		Sea_3 = {
			Vector3.new(-5058.77, 314.52, -3155.88),
			Vector3.new(-12463.87, 374.91, -7523.77),
			Vector3.new(28282.57, 14896.85, 105.1),
			Vector3.new(5661.53, 1013.09, -334.96),
			Vector3.new(5319, 23, -93),
			Vector3.new(5651, 1018, -350),
			Vector3.new(28286, 14897, 103)
		}
	},
	SwordData = {
		["Dark Blade"] = { Rarity = "Mythical", Order = 1 },
		["True Triple Katana"] = { Rarity = "Mythical", Order = 1 },
		["Cursed Dual Katana"] = { Rarity = "Mythical", Order = 1 },
		["Hallow Scythe"] = { Rarity = "Mythical", Order = 1 },
		["Triple Dark Blade"] = { Rarity = "Mythical", Order = 1 },
		["Dog Blade"] = { Rarity = "Mythical", Order = 1 },

		["Rengoku"] = { Rarity = "Legendary", Order = 2 },
		["Yama"] = { Rarity = "Legendary", Order = 2 },
		["Tushita"] = { Rarity = "Legendary", Order = 2 },
		["Buddy Sword"] = { Rarity = "Legendary", Order = 2 },
		["Shark Anchor"] = { Rarity = "Legendary", Order = 2 },
		["Fox Lamp"] = { Rarity = "Legendary", Order = 2 },
		["Dragon Trident"] = { Rarity = "Legendary", Order = 2 },
		["Saber"] = { Rarity = "Legendary", Order = 2 },
		["Canvander"] = { Rarity = "Legendary", Order = 2 },
		["Dark Dagger"] = { Rarity = "Legendary", Order = 2 },
		["Dragonheart"] = { Rarity = "Legendary", Order = 2 },
		["Koko"] = { Rarity = "Legendary", Order = 2 },
		["Midnight Blade"] = { Rarity = "Legendary", Order = 2 },
		["Oroshi"] = { Rarity = "Legendary", Order = 2 },
		["Pole (1st Form)"] = { Rarity = "Legendary", Order = 2 },
		["Pole (2nd Form)"] = { Rarity = "Legendary", Order = 2 },
		["Saishi"] = { Rarity = "Legendary", Order = 2 },
		["Shizu"] = { Rarity = "Legendary", Order = 2 },
		["Longsword"] = { Rarity = "Legendary", Order = 2 },
		["Pipe"] = { Rarity = "Legendary", Order = 2 },
		["Soul Cane"] = { Rarity = "Legendary", Order = 2 },
		["Trident"] = { Rarity = "Legendary", Order = 2 },
		["Wardens Sword"] = { Rarity = "Legendary", Order = 2 },
		["Bisento"] = { Rarity = "Legendary", Order = 2 },
		["Triple Katana"] = { Rarity = "Legendary", Order = 2 },
		["Twin Hooks"] = { Rarity = "Legendary", Order = 2 },
		["Dual-Headed Blade"] = { Rarity = "Legendary", Order = 2 },
		["Flail"] = { Rarity = "Legendary", Order = 2 },
		["Gravity Blade"] = { Rarity = "Legendary", Order = 2 },

		["Spikey Trident"] = { Rarity = "Rare", Order = 3 },
		["Fishing Trophy"] = { Rarity = "Rare", Order = 3 },
		["Shark Saw"] = { Rarity = "Rare", Order = 3 },

		["Iron Mace"] = { Rarity = "Uncommon", Order = 4 },

		["Cutlass"] = { Rarity = "Common", Order = 5 },
		["Katana"] = { Rarity = "Common", Order = 5 },
		["Dual Katana"] = { Rarity = "Common", Order = 5 },
	},
	BoatsList = {
		'Dinghy',
		'PirateSloop',
		'PirateBrigade',
		'PirateGrandBrigade',
		'MarineSloop',
		'MarineBrigade',
		'MarineGrandBrigade',
		'Beast Hunter',
		'Lantern',
		'Guardian',
		'Grand Brigade',
		'Sloop',
		'The Sentinel'
	},
	ZoneList = {
		'Level 1',
		'Level 2',
		'Level 3',
		'Level 4',
		'Level 5',
		'Level 6',
		'Infinite'
	},
	SeaEventTargets = {
		"Terror Shark",
		"Sea Beast",
		"Shark",
		"Piranha",
		"Fish Crew Member",
		"Pirate Brigade",
		"Pirate Grand Brigade",
		"Ghost Ship"
	},
	RodsList = {
		"Fishing Rod",
		"Gold Rod",
		"Shark Rod",
		"Shell Rod",
		"Treasure Rod",
		"Shark (Corrupted)",
		"Shell (Celestial)"
	},
	BaitsList = {
		"Basic Bait",
		"Kelp Bait",
		"Good Bait",
		"Abyssal Bait",
		"Frozen Bait",
		"Epic Bait",
		"Carnivore Bait"
	},
	DungeonCards = {
		"Hyper",
		"Overflow",
		"Fortress",
		"Shadow",
		"Sniper",
		"Lifesteal",
		"Unbreakable",
		"Health",
		"Defense",
		"Armor",
		"Melee",
		"Sword",
		"Fruit",
		"Gun"
	},
	TrainMethods = {
		"Bones",
		"Cakes"
	},
	LegendarySwordNames = {
		"Shizu",
		"Oroshi",
		"Saishi"
	},
	BossHopNames = {
		"Greybeard",
		"Darkbeard",
		"Cursed Captain",
		"rip_indra True Form",
		"Soul Reaper",
		"Cake Prince",
		"Dough King",
		"Tyrant of the Skies"
	},
	BossMap = {
		["Greybeard"] = "Greybeard",
		["Darkbeard"] = "Darkbeard",
		["Cursed Captain"] = "CursedCaptain",
		["rip_indra True Form"] = "Ripindra",
		["Soul Reaper"] = "SoulReaper",
		["Cake Prince"] = "CakePrince",
		["Dough King"] = "DoughKing",
		["Tyrant of the Skies"] = "Tyrant"
	},
	ScrollList = {
		"Common Scroll",
		"Rare Scroll",
		"Legendary Scroll",
		"Mythical Scroll"
	},
	ChestTiers = {
		"Diamond",
		"Gold",
		"Silver"
	},
	IgnoreNPC = {
		"Quest",
		"Boat",
		"Home"
	},
	DracoSequence = {
		"Relic1",
		"EndRelic1",
		"Relic2",
		"EndRelic2",
		"Relic3",
		"EndRelic3"
	},
	SwordList = {
		"Shizu",
		"Saishi",
		"Oroshi"
	},
	DealerFruitList = {
		"Rocket-Rocket",
		"Spin-Spin",
		"Blade-Blade",
		"Spring-Spring",
		"Bomb-Bomb",
		"Smoke-Smoke",
		"Spike-Spike",
		"Flame-Flame",
		"Ice-Ice",
		"Sand-Sand",
		"Dark-Dark",
		"Eagle-Eagle",
		"Diamond-Diamond",
		"Light-Light",
		"Rubber-Rubber",
		"Ghost-Ghost",
		"Magma-Magma",
		"Quake-Quake",
		"Buddha-Buddha",
		"Love-Love",
		"Creation-Creation",
		"Spider-Spider",
		"Sound-Sound",
		"Phoenix-Phoenix",
		"Portal-Portal",
		"Lightning-Lightning",
		"Pain-Pain",
		"Blizzard-Blizzard",
		"Gravity-Gravity",
		"Mammoth-Mammoth",
		"T-Rex-T-Rex",
		"Dough-Dough",
		"Shadow-Shadow",
		"Venom-Venom",
		"Gas-Gas",
		"Spirit-Spirit",
		"Tiger-Tiger",
		"Yeti-Yeti",
		"Kitsune-Kitsune",
		"Control-Control",
		"Dragon-Dragon"
	}
}

--============================================================
-- LIVE PLAYER STATUS CARD • ENHANCED MOBILE EDITION
-- ปรับปรุง: Card ใหญ่ขึ้น / ปุ่มเปิด-ปิด / Glow Aura / Animation
-- รูปภาพเดิมยังฝังอยู่ในสคริปต์และมี fallback เป็น Avatar จริง
--============================================================
task.spawn(function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer
    if not LP then return end

    local PlayerGui = LP:WaitForChild("PlayerGui", 15)
    if not PlayerGui then return end

    pcall(function()
        local old = PlayerGui:FindFirstChild("BloxFruitsLiveStatus")
        if old then old:Destroy() end
    end)

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "BloxFruitsLiveStatus"
    Gui.ResetOnSpawn = false
    Gui.IgnoreGuiInset = true
    Gui.DisplayOrder = 100
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.Parent = PlayerGui

    -- Screen-edge glow removed: no frame is drawn around the screen.

    --========================================================
    -- STATUS TOGGLE • กดเพื่อเปิด/ปิด Card
    --========================================================
    local Toggle = Instance.new("TextButton")
    Toggle.Name = "StatusToggle"
    Toggle.AnchorPoint = Vector2.new(1, 0)
    Toggle.Position = UDim2.new(1, -18, 0, 62)
    Toggle.Size = UDim2.new(0, 54, 0, 54)
    Toggle.BackgroundColor3 = Color3.fromRGB(4, 12, 34)
    Toggle.BackgroundTransparency = 0.06
    Toggle.BorderSizePixel = 0
    Toggle.AutoButtonColor = false
    Toggle.Text = "A"
    Toggle.TextColor3 = Color3.fromRGB(225, 245, 255)
    Toggle.TextSize = 22
    Toggle.Font = Enum.Font.GothamBold
    Toggle.ZIndex = 30
    Toggle.Parent = Gui

    -- ตั้งรูปโลโก้ได้ที่บรรทัดนี้: ใส่ "rbxassetid://เลขไอดีรูป"
    -- เว้นเป็นค่าว่างเพื่อใช้ตัวอักษร A เป็นโลโก้สำรอง
    local LOGO_IMAGE_ID = ""
    local LogoImage = Instance.new("ImageLabel")
    LogoImage.Name = "LogoImage"
    LogoImage.BackgroundTransparency = 1
    LogoImage.Size = UDim2.new(1, -8, 1, -8)
    LogoImage.Position = UDim2.new(0, 4, 0, 4)
    LogoImage.Image = LOGO_IMAGE_ID
    LogoImage.ScaleType = Enum.ScaleType.Crop
    LogoImage.Visible = LOGO_IMAGE_ID ~= ""
    LogoImage.ZIndex = 32
    LogoImage.Parent = Toggle
    local LogoImageCorner = Instance.new("UICorner")
    LogoImageCorner.CornerRadius = UDim.new(0, 14)
    LogoImageCorner.Parent = LogoImage

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 18)
    ToggleCorner.Parent = Toggle

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Thickness = 1.4
    ToggleStroke.Transparency = 0.05
    ToggleStroke.Color = Color3.fromRGB(70, 190, 255)
    ToggleStroke.Parent = Toggle

    local ToggleGradient = Instance.new("UIGradient")
    ToggleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 55, 125)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(3, 15, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 105, 220))
    })
    ToggleGradient.Rotation = 20
    ToggleGradient.Parent = Toggle

    --========================================================
    -- CARD SHADOW / AURA
    --========================================================
    local Aura1 = Instance.new("Frame")
    Aura1.Name = "AuraOuter"
    Aura1.AnchorPoint = Vector2.new(0.5, 0)
    Aura1.Position = UDim2.new(0.5, 0, 0, 55)
    Aura1.Size = UDim2.new(0, 700, 0, 280)
    Aura1.BackgroundColor3 = Color3.fromRGB(55, 180, 255)
    Aura1.BackgroundTransparency = 0.86
    Aura1.BorderSizePixel = 0
    Aura1.ZIndex = 1
    Aura1.Parent = Gui

    local Aura1Corner = Instance.new("UICorner")
    Aura1Corner.CornerRadius = UDim.new(0, 30)
    Aura1Corner.Parent = Aura1

    local Aura2 = Instance.new("Frame")
    Aura2.Name = "AuraInner"
    Aura2.AnchorPoint = Vector2.new(0.5, 0)
    Aura2.Position = UDim2.new(0.5, 0, 0, 59)
    Aura2.Size = UDim2.new(0, 680, 0, 270)
    Aura2.BackgroundColor3 = Color3.fromRGB(125, 125, 130)
    Aura2.BackgroundTransparency = 0.90
    Aura2.BorderSizePixel = 0
    Aura2.ZIndex = 1
    Aura2.Parent = Gui

    local Aura2Corner = Instance.new("UICorner")
    Aura2Corner.CornerRadius = UDim.new(0, 28)
    Aura2Corner.Parent = Aura2

    --========================================================
    -- MAIN CARD
    --========================================================
    local Card = Instance.new("Frame")
    Card.Name = "StatusCard"
    Card.AnchorPoint = Vector2.new(0.5, 0)
    Card.Position = UDim2.new(0.5, 0, 0, 62)
    Card.Size = UDim2.new(0, 650, 0, 260)
    Card.BackgroundColor3 = Color3.fromRGB(4, 12, 34)
    Card.BackgroundTransparency = 0.03
    Card.BorderSizePixel = 0
    Card.ClipsDescendants = true
    Card.ZIndex = 5
    Card.Parent = Gui

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 26)
    CardCorner.Parent = Card

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2.2
    Stroke.Transparency = 0.02
    Stroke.Color = Color3.fromRGB(225, 245, 255)
    Stroke.Parent = Card

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 30, 80)),
        ColorSequenceKeypoint.new(0.42, Color3.fromRGB(4, 14, 38)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(5, 24, 62)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 90, 190))
    })
    Gradient.Rotation = 16
    Gradient.Parent = Card

    local Shine = Instance.new("Frame")
    Shine.Name = "TopShine"
    Shine.BackgroundColor3 = Color3.fromRGB(30, 160, 255)
    Shine.BackgroundTransparency = 0.88
    Shine.BorderSizePixel = 0
    Shine.Position = UDim2.new(0, 3, 0, 3)
    Shine.Size = UDim2.new(1, -6, 0, 4)
    Shine.ZIndex = 7
    Shine.Parent = Card

    local ShineCorner = Instance.new("UICorner")
    ShineCorner.CornerRadius = UDim.new(1, 0)
    ShineCorner.Parent = Shine

    local Overlay = Instance.new("Frame")
    Overlay.Name = "Overlay"
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.28
    Overlay.BorderSizePixel = 0
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.ZIndex = 6
    Overlay.Parent = Card

    --========================================================
    -- AVATAR / CUSTOM IMAGE
    --========================================================
    local AvatarHolder = Instance.new("Frame")
    AvatarHolder.Name = "AvatarHolder"
    AvatarHolder.BackgroundColor3 = Color3.fromRGB(5, 18, 45)
    AvatarHolder.BackgroundTransparency = 0.08
    AvatarHolder.BorderSizePixel = 0
    AvatarHolder.Position = UDim2.new(0, 15, 0, 15)
    AvatarHolder.Size = UDim2.new(0, 150, 0, 185)
    AvatarHolder.ZIndex = 8
    AvatarHolder.Parent = Card

    local AvatarHolderCorner = Instance.new("UICorner")
    AvatarHolderCorner.CornerRadius = UDim.new(0, 17)
    AvatarHolderCorner.Parent = AvatarHolder

    local Avatar = Instance.new("ImageLabel")
    Avatar.Name = "Avatar"
    Avatar.BackgroundTransparency = 1
    Avatar.Position = UDim2.new(0, 7, 0, 7)
    Avatar.Size = UDim2.new(1, -14, 1, -14)
    Avatar.ScaleType = Enum.ScaleType.Crop
    Avatar.ZIndex = 9
    Avatar.Parent = AvatarHolder

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(0, 13)
    AvatarCorner.Parent = Avatar

    local AvatarStroke = Instance.new("UIStroke")
    AvatarStroke.Thickness = 2
    AvatarStroke.Color = Color3.fromRGB(40, 170, 255)
    AvatarStroke.Transparency = 0.08
    AvatarStroke.Parent = Avatar

    -- รูป Status แบบกำหนดเอง: ใช้รูปเดิมที่ฝังไว้ในสคริปต์
    local CUSTOM_STATUS_IMAGE = true
    local CUSTOM_STATUS_FILE = "BloxFruits_Status_Image.jpg"
    local CUSTOM_STATUS_B64 = [[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]]

    local function decodeBase64(data)
        local ok, decoded
        pcall(function()
            if crypt and crypt.base64decode then
                decoded = crypt.base64decode(data)
                ok = decoded ~= nil
            end
        end)
        if ok then return decoded end

        local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        data = data:gsub("[^" .. alphabet .. "=]", "")
        local bits = data:gsub(".", function(x)
            if x == "=" then return "" end
            local r, f = "", alphabet:find(x, 1, true) - 1
            for i = 6, 1, -1 do
                r = r .. (f % 2^i - f % 2^(i-1) > 0 and "1" or "0")
            end
            return r
        end)
        return (bits:gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
            if #x ~= 8 then return "" end
            local c = 0
            for i = 1, 8 do
                if x:sub(i,i) == "1" then c = c + 2^(8-i) end
            end
            return string.char(c)
        end))
    end

    local loadedCustomImage = false
    if CUSTOM_STATUS_IMAGE and writefile and getcustomasset then
        pcall(function()
            local bytes = decodeBase64(CUSTOM_STATUS_B64)
            if bytes and #bytes > 0 then
                writefile(CUSTOM_STATUS_FILE, bytes)
                Avatar.Image = getcustomasset(CUSTOM_STATUS_FILE)
                loadedCustomImage = true
            end
        end)
    end

    if not loadedCustomImage then
        pcall(function()
            local content = Players:GetUserThumbnailAsync(
                LP.UserId,
                Enum.ThumbnailType.AvatarBust,
                Enum.ThumbnailSize.Size420x420
            )
            Avatar.Image = content
        end)
    end

    local function label(name, txt, pos, size, color, fontSize, align)
        local L = Instance.new("TextLabel")
        L.Name = name
        L.BackgroundTransparency = 1
        L.Position = pos
        L.Size = size
        L.Text = txt
        L.TextColor3 = color or Color3.new(1,1,1)
        L.Font = Enum.Font.GothamBold
        L.TextSize = fontSize or 16
        L.TextXAlignment = align or Enum.TextXAlignment.Left
        L.TextYAlignment = Enum.TextYAlignment.Center
        L.TextTruncate = Enum.TextTruncate.AtEnd
        L.ZIndex = 9
        L.Parent = Card
        return L
    end

    local Title = label(
        "Title",
        "MARU HUB  |  ACCOUNT STATS",
        UDim2.new(0, 180, 0, 14),
        UDim2.new(1, -195, 0, 28),
        Color3.fromRGB(225, 245, 255),
        20
    )

    local Username = label(
        "Username",
        "@" .. tostring(LP.Name),
        UDim2.new(0, 180, 0, 43),
        UDim2.new(1, -195, 0, 21),
        Color3.fromRGB(150, 200, 235),
        13
    )

    local Status = label(
        "Status",
        "●  STATUS: LIVE",
        UDim2.new(0, 180, 0, 65),
        UDim2.new(1, -195, 0, 22),
        Color3.fromRGB(55, 180, 255),
        14
    )

    local Divider = Instance.new("Frame")
    Divider.BackgroundColor3 = Color3.fromRGB(30, 105, 190)
    Divider.BackgroundTransparency = 0.52
    Divider.BorderSizePixel = 0
    Divider.Position = UDim2.new(0, 180, 0, 92)
    Divider.Size = UDim2.new(1, -200, 0, 1)
    Divider.ZIndex = 9
    Divider.Parent = Card

    local Level = label(
        "Level",
        "Lv. 0",
        UDim2.new(0, 180, 0, 101),
        UDim2.new(0, 150, 0, 31),
        Color3.fromRGB(70, 190, 255),
        20
    )

    local Beli = label(
        "Beli",
        "$0",
        UDim2.new(0, 340, 0, 101),
        UDim2.new(0, 190, 0, 31),
        Color3.fromRGB(90, 220, 255),
        20
    )

    local Fragments = label(
        "Fragments",
        "♦ 0",
        UDim2.new(0, 180, 0, 139),
        UDim2.new(0, 210, 0, 31),
        Color3.fromRGB(120, 205, 255),
        19
    )

    local Race = label(
        "Race",
        "RACE: Unknown",
        UDim2.new(0, 340, 0, 139),
        UDim2.new(0, 160, 0, 27),
        Color3.fromRGB(90, 200, 255),
        15
    )

    local Items = label(
        "Items",
        "ITEMS  •  Loading...",
        UDim2.new(0, 180, 0, 176),
        UDim2.new(1, -200, 0, 20),
        Color3.fromRGB(130, 190, 240),
        10
    )

    local Uptime = label(
        "Uptime",
        "UPTIME: 00:00:00",
        UDim2.new(0, 355, 0, 205),
        UDim2.new(1, -375, 0, 25),
        Color3.fromRGB(120, 175, 220),
        12,
        Enum.TextXAlignment.Right
    )

    local Hint = label(
        "Hint",
        "LIVE DATA  •  AUTO UPDATE",
        UDim2.new(0, 180, 0, 235),
        UDim2.new(1, -200, 0, 18),
        Color3.fromRGB(100, 160, 215),
        10,
        Enum.TextXAlignment.Left
    )

    local function comma(n)
        n = tonumber(n) or 0
        local s = tostring(math.floor(n))
        local sign = ""
        if s:sub(1,1) == "-" then
            sign = "-"
            s = s:sub(2)
        end
        while true do
            local ns, count = s:gsub("^(%d+)(%d%d%d)", "%1,%2")
            s = ns
            if count == 0 then break end
        end
        return sign .. s
    end

    local function readValue(name)
        local data = LP:FindFirstChild("Data")
        local obj = data and data:FindFirstChild(name)
        if obj then
            local ok, value = pcall(function() return obj.Value end)
            if ok then return value end
        end

        local stats = LP:FindFirstChild("leaderstats")
        local obj2 = stats and stats:FindFirstChild(name)
        if obj2 then
            local ok, value = pcall(function() return obj2.Value end)
            if ok then return value end
        end

        return 0
    end

    local function refresh()
        local lv = readValue("Level")
        local beli = readValue("Beli")
        local frags = readValue("Fragments")

        Level.Text = "Lv. " .. comma(lv)
        Beli.Text = "$" .. comma(beli)
        Fragments.Text = "♦ " .. comma(frags)
        Username.Text = "@" .. tostring(LP.Name)

        local data = LP:FindFirstChild("Data")
        local raceObj = data and (data:FindFirstChild("Race") or data:FindFirstChild("RaceName"))
        Race.Text = "RACE: " .. (raceObj and tostring(raceObj.Value) or "Unknown")

        local found, seen = {}, {}
        local function scanTools(container)
            if not container then return end
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") and not seen[tool.Name] then
                    seen[tool.Name] = true
                    table.insert(found, tool.Name)
                end
            end
        end
        scanTools(LP:FindFirstChild("Backpack"))
        scanTools(LP.Character)
        table.sort(found)
        local shown = {}
        for i = 1, math.min(5, #found) do shown[i] = found[i] end
        Items.Text = "ITEMS  •  " .. (#shown > 0 and table.concat(shown, "  /  ") or "None detected")
    end

    local function connectValue(name)
        pcall(function()
            local data = LP:FindFirstChild("Data")
            local obj = data and data:FindFirstChild(name)
            if obj then
                obj:GetPropertyChangedSignal("Value"):Connect(refresh)
            end
        end)
    end

    connectValue("Level")
    connectValue("Beli")
    connectValue("Fragments")

    local startTime = os.clock()

    task.spawn(function()
        while Gui.Parent do
            refresh()

            local elapsed = math.max(0, math.floor(os.clock() - startTime))
            local h = math.floor(elapsed / 3600)
            local m = math.floor((elapsed % 3600) / 60)
            local s = elapsed % 60
            Uptime.Text = string.format("UPTIME: %02d:%02d:%02d", h, m, s)

            task.wait(0.25)
        end
    end)

    LP.ChildAdded:Connect(function(child)
        if child.Name == "Data" then
            task.wait(0.2)
            connectValue("Level")
            connectValue("Beli")
            connectValue("Fragments")
            refresh()
        end
    end)

    --========================================================
    -- RESPONSIVE MOBILE
    --========================================================
    local function fit()
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1280,720)

        if vp.X < 700 then
            local w = math.max(350, math.floor(vp.X * 0.91))
            local h = 198

            Card.Size = UDim2.new(0, w, 0, h)
            Aura1.Size = UDim2.new(0, w + 28, 0, h + 18)
            Aura2.Size = UDim2.new(0, w + 14, 0, h + 10)

            AvatarHolder.Position = UDim2.new(0, 11, 0, 12)
            AvatarHolder.Size = UDim2.new(0, 122, 0, 174)

            Title.Position = UDim2.new(0, 147, 0, 11)
            Title.Size = UDim2.new(1, -160, 0, 25)
            Title.TextSize = 16

            Username.Position = UDim2.new(0, 147, 0, 36)
            Username.Size = UDim2.new(1, -160, 0, 19)
            Username.TextSize = 12

            Status.Position = UDim2.new(0, 147, 0, 57)
            Status.Size = UDim2.new(1, -160, 0, 20)
            Status.TextSize = 12

            Divider.Position = UDim2.new(0, 147, 0, 79)
            Divider.Size = UDim2.new(1, -160, 0, 1)

            Level.Position = UDim2.new(0, 147, 0, 86)
            Level.Size = UDim2.new(0, 105, 0, 29)
            Level.TextSize = 16

            Beli.Position = UDim2.new(0, 250, 0, 86)
            Beli.Size = UDim2.new(0, 145, 0, 29)
            Beli.TextSize = 16

            Fragments.Position = UDim2.new(0, 147, 0, 120)
            Fragments.Size = UDim2.new(0, 145, 0, 29)
            Fragments.TextSize = 15

            Race.Position = UDim2.new(0, 147, 0, 146)
            Race.Size = UDim2.new(0, 150, 0, 22)
            Race.TextSize = 11

            Items.Position = UDim2.new(0, 147, 0, 166)
            Items.Size = UDim2.new(1, -160, 0, 17)
            Items.TextSize = 8

            Uptime.Position = UDim2.new(0, 275, 0, 120)
            Uptime.Size = UDim2.new(1, -290, 0, 29)
            Uptime.TextSize = 10

            Hint.Position = UDim2.new(0, 147, 0, 158)
            Hint.Size = UDim2.new(1, -160, 0, 18)
            Hint.TextSize = 8

            Toggle.Size = UDim2.new(0, 105, 0, 37)
            Toggle.Position = UDim2.new(1, -12, 0, 55)
            Toggle.TextSize = 11

            Aura1.Position = UDim2.new(0.5, 0, 0, 55)
            Aura2.Position = UDim2.new(0.5, 0, 0, 59)
        else
            Card.Size = UDim2.new(0, 650, 0, 260)
            Aura1.Size = UDim2.new(0, 700, 0, 280)
            Aura2.Size = UDim2.new(0, 680, 0, 270)
        end
    end

    fit()
    pcall(function()
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
    end)

    --========================================================
    -- OPEN / CLOSE ANIMATION
    --========================================================
    local CardOpenPos = UDim2.new(0.5, 0, 0, 62)
    local CardClosedPos = UDim2.new(0.5, 0, 0, -245)
    local AuraOpenPos = UDim2.new(0.5, 0, 0, 55)
    local AuraClosedPos = UDim2.new(0.5, 0, 0, -252)
    local CardVisible = true
    local Busy = false

    local function setVisible(show)
        if Busy or CardVisible == show then return end
        Busy = true
        CardVisible = show

        if show then
            Card.Visible = true
            Aura1.Visible = true
            Aura2.Visible = true

            Card.Position = CardClosedPos
            Aura1.Position = AuraClosedPos
            Aura2.Position = UDim2.new(0.5, 0, 0, -248)

            Toggle.Text = "A"
            TweenService:Create(Card, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = CardOpenPos
            }):Play()
            TweenService:Create(Aura1, TweenInfo.new(0.48, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = AuraOpenPos
            }):Play()
            TweenService:Create(Aura2, TweenInfo.new(0.46, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0, 59)
            }):Play()

            task.delay(0.5, function() Busy = false end)
        else
            Toggle.Text = "A"

            local t1 = TweenService:Create(Card, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Position = CardClosedPos
            })
            local t2 = TweenService:Create(Aura1, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Position = AuraClosedPos
            })
            local t3 = TweenService:Create(Aura2, TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, 0, -248)
            })

            t1:Play(); t2:Play(); t3:Play()
            task.delay(0.38, function()
                Card.Visible = false
                Aura1.Visible = false
                Aura2.Visible = false
                Busy = false
            end)
        end
    end

    Toggle.MouseButton1Click:Connect(function()
        setVisible(not CardVisible)
    end)

    Toggle.MouseEnter:Connect(function()
        TweenService:Create(Toggle, TweenInfo.new(0.15), {
            BackgroundTransparency = 0
        }):Play()
    end)

    Toggle.MouseLeave:Connect(function()
        TweenService:Create(Toggle, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.06
        }):Play()
    end)

    --========================================================
    -- AURA ANIMATION
    --========================================================
    local auraClock = 0
    RunService.RenderStepped:Connect(function(dt)
        if not Gui.Parent then return end
        auraClock = auraClock + dt

        local pulse = (math.sin(auraClock * 2.4) + 1) * 0.5
        local glow = 0.86 - pulse * 0.12
        local softGlow = 0.96 - pulse * 0.055

        Stroke.Color = Color3.fromRGB(248, 248, 248)
        ToggleStroke.Color = Color3.fromRGB(225 + math.floor(pulse * 30), 225 + math.floor(pulse * 30), 225 + math.floor(pulse * 30))
        AvatarStroke.Color = Color3.fromRGB(250, 250, 250)
        Aura1.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
        Aura2.BackgroundColor3 = Color3.fromRGB(105, 105, 110)
        Aura1.BackgroundTransparency = 0.90 - pulse * 0.065
        Aura2.BackgroundTransparency = 0.94 - pulse * 0.045

        EdgeTop.BackgroundTransparency = glow
        EdgeBottom.BackgroundTransparency = glow
        EdgeLeft.BackgroundTransparency = glow
        EdgeRight.BackgroundTransparency = glow

        EdgeTopSoft.BackgroundTransparency = softGlow
        EdgeBottomSoft.BackgroundTransparency = softGlow
        EdgeLeftSoft.BackgroundTransparency = softGlow
        EdgeRightSoft.BackgroundTransparency = softGlow
    end)

    refresh()
end)

function hoangtuveu()
    local W = {Instances = {}}
    repeat task.wait() until game.CoreGui

    -- ============================================================
    -- UI TỪ DYNAMICISLAND_AXIOM-1.LUA (CÓ DISCORD + CONTAINER)
    -- ============================================================
    local gui = Instance.new('ScreenGui')
    gui.Name = "KaitunUI"
    gui.Parent = game:GetService('CoreGui')
    gui.Enabled = false
    gui.ResetOnSpawn = true
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = false

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Parent = gui
    container.AnchorPoint = Vector2.new(0.5, 0)
    container.Position = UDim2.new(0.5, 0, 0.01, 0)
    container.AutomaticSize = Enum.AutomaticSize.XY
    container.Size = UDim2.new(0, 0, 0, 0)
    container.BackgroundTransparency = 1

    local containerLayout = Instance.new("UIListLayout", container)
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 4)
    containerLayout.FillDirection = Enum.FillDirection.Vertical
    containerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local discordLabel = Instance.new("TextLabel")
    discordLabel.Name = "DiscordLabel"
    discordLabel.Parent = container
    discordLabel.LayoutOrder = 1
    discordLabel.AutomaticSize = Enum.AutomaticSize.XY
    discordLabel.Size = UDim2.new(0, 0, 0, 0)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "https://discord.gg/KrEPeAtjn"
    discordLabel.TextSize = 13
    discordLabel.Font = Enum.Font.Highway
    discordLabel.TextColor3 = Color3.fromRGB(255, 45, 155)
    discordLabel.TextXAlignment = Enum.TextXAlignment.Center

    local frame = Instance.new("Frame")
    frame.Name = "Frame"
    frame.Parent = container
    frame.LayoutOrder = 2
    frame.AutomaticSize = Enum.AutomaticSize.XY
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(38, 5, 25)
    frame.BackgroundTransparency = 0.25
    frame.BorderSizePixel = 0

    local padding = Instance.new("UIPadding", frame)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255, 45, 155)
    stroke.Thickness = 1.5
    stroke.Transparency = 0

    local layout = Instance.new("UIListLayout", frame)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.FillDirection = Enum.FillDirection.Vertical

    local features = Instance.new("Frame")
    features.Name = "Features"
    features.Parent = frame
    features.LayoutOrder = 1
    features.AutomaticSize = Enum.AutomaticSize.XY
    features.Size = UDim2.new(0, 0, 0, 0)
    features.BackgroundTransparency = 1

    local featLayout = Instance.new("UIListLayout", features)
    featLayout.SortOrder = Enum.SortOrder.LayoutOrder
    featLayout.Padding = UDim.new(0, 2)
    featLayout.FillDirection = Enum.FillDirection.Vertical

    local taskLabel = Instance.new("TextLabel")
    taskLabel.Name = "Task"
    taskLabel.Parent = features
    taskLabel.LayoutOrder = 1
    taskLabel.AutomaticSize = Enum.AutomaticSize.XY
    taskLabel.Size = UDim2.new(0, 0, 0, 0)
    taskLabel.BackgroundTransparency = 1
    taskLabel.Text = "Status :"
    taskLabel.TextSize = 14
    taskLabel.Font = Enum.Font.Ubuntu
    taskLabel.TextColor3 = Color3.fromRGB(255, 170, 220)
    taskLabel.TextXAlignment = Enum.TextXAlignment.Left

    local subTaskLabel = Instance.new("TextLabel")
    subTaskLabel.Name = "SubTask"
    subTaskLabel.Parent = features
    subTaskLabel.LayoutOrder = 2
    subTaskLabel.AutomaticSize = Enum.AutomaticSize.XY
    subTaskLabel.Size = UDim2.new(0, 0, 0, 0)
    subTaskLabel.BackgroundTransparency = 1
    subTaskLabel.Text = "Sub Task :"
    subTaskLabel.TextSize = 13
    subTaskLabel.Font = Enum.Font.Ubuntu
    subTaskLabel.TextColor3 = Color3.fromRGB(255, 170, 220)
    subTaskLabel.TextTransparency = 0
    subTaskLabel.TextXAlignment = Enum.TextXAlignment.Left

    W.Instances['Task1'] = taskLabel
    W.Instances['Task2'] = subTaskLabel
    W.Instances['MainTextLabel'] = taskLabel

    function SetText(key, text)
        task.spawn(function()
            local label = W.Instances[key]
            if not label then return end
            if label.Text == text then return end
            local ts = game:GetService("TweenService")
            local fadeOut = ts:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1, TextStrokeTransparency = 1})
            fadeOut:Play()
            fadeOut.Completed:Wait()
            label.Text = text
            local t = 0
            local fadeIn = ts:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = t, TextStrokeTransparency = t})
            fadeIn:Play()
        end)
    end
    getgenv().alert = function() end
    W.SetText = SetText
    W.ToggleUI = function() end
    W.ToggleInterface = function() end
    W.RegisterForBlur = function() end

    -- ============================================================
    -- LOGIC TỪ TEST.TXT (GIỮ NGUYÊN, BAO GỒM FAST ATTACK VÀ EQUIP)
    -- ============================================================
    if false then
        spawn(function()
            pcall(loadstring(game:HttpGet("https://raw.githubusercontent.com/sucvatthieunang/Trackstat/refs/heads/main/cac")))
        end)
    end
    alert("cac", "Endpoint reached")
    OldSessionTime = isfile and readfile and isfile('.tdif-' .. game.Players.LocalPlayer.Name) and tonumber(readfile(".tdif-" .. game.Players.LocalPlayer.Name)) or 0
    repeat
        task.wait()
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", Config.Team)
    until game.Players.LocalPlayer.Character
    alert("team assembled")
    repeat wait() until game.Players.LocalPlayer.Character
    spawn(function()
        game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild('NewIslandLOD', 9999):Destroy()
        game:GetService("Players")
        LocalPlayer.PlayerScripts:WaitForChild('IslandLOD', 9999):Destroy()
    end)
    alert('wait 1', 'ok')
    local J = {'RawConstants', "Utilly", "QuestManager", 'SpawnRegionLoader', 'TweenController', "AttackController", 'CombatController', 'FunctionsHandler', "Hooks", "Debug", "Hop", "Storage"}
    StartTick = tick()
    repeat
        task.wait()
    until SetText
    alert('load 2')
    SetText('MainTextLabel', 'Initalizing Script..')
    local J = "Rua_Hub/Blox_Fruit/Assets/"
    ScriptStorage = {IsInitalized = false, PlayerData = {}, Melees = {}, CurrentMeleeData = {}, Enemies = {}, Tools = {}, Backpack = {}, IgnoreStoreFruits = {}, Connections = {LocalPlayer = {}}, Task = {}, Tracebacks = {}, TaskController = {}, TracebackUpdater = {}, Interface = W, NPCs = {}, Map = {}}
    Players = game.Players
    LocalPlayer = Players.LocalPlayer
    Character = Players.LocalPlayer.Character
    Humanoid = Character:WaitForChild('Humanoid')
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    PlayerGui = LocalPlayer:WaitForChild('PlayerGui', 10)
    Lighting = game:GetService('Lighting')
    Services = {}
    setmetatable(Services, {__index = function(J, J) return game:GetService(J) end})
    setmetatable(ScriptStorage.Enemies, {__index = function(J, J) return Services.Workspace.Enemies:FindFirstChild(J) or Services.ReplicatedStorage:FindFirstChild(J) end})
    setmetatable(ScriptStorage.Map, {__index = function(J, J) return Services.Workspace.Map:FindFirstChild(J) or Services.Workspace:FindFirstChild(J) end})
    setmetatable(ScriptStorage.Tools, {__index = function(J, J) return LocalPlayer.Character:FindFirstChild(J) or (LocalPlayer:FindFirstChild('Backpack') and LocalPlayer.Backpack:FindFirstChild(J)) end})
    setmetatable(ScriptStorage.NPCs, {__index = function(J, J) if not J then return end; return workspace.NPCs:FindFirstChild(J) or game.ReplicatedStorage.NPCs:FindFirstChild(J) end})

    -- ============================================================
    -- [NEW] PANIC MODE + AUTO KEN — đặt sớm ngay đầu, chạy độc lập qua
    -- task.spawn riêng (không qua TasksOrder) để phản ứng máu thấp NGAY
    -- LẬP TỨC, không phải chờ tới lượt dispatch. Gộp chung Auto-Ken vào
    -- đây theo đúng yêu cầu boss man.
    -- ============================================================
    _G.PanicModeActive = false

    task.spawn(function()
        local escapeY = nil
        while task.wait(Config.PanicMode.CheckInterval) do
            pcall(function()
                if not Config.PanicMode.Enabled then return end
                local char = LocalPlayer.Character
                local hum  = char and char:FindFirstChildOfClass("Humanoid")
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")

                -- [FIXED] Nhân vật chết lúc đang trốn trên cao (_G.PanicModeActive
                -- = true) mà không reset state → lúc hồi sinh, nhân vật MỚI (máu
                -- đầy, đứng dưới đất) bị code tưởng "đang trốn, cần giữ độ cao cũ"
                -- → kéo lên trời vô lý ngay sau khi respawn. Reset ngay khi phát
                -- hiện chết, không chỉ return im lặng.
                if not hum or not hrp or hum.Health <= 0 then
                    if _G.PanicModeActive then
                        _G.PanicModeActive = false
                        escapeY = nil
                    end
                    return
                end

                local pct = (hum.Health / hum.MaxHealth) * 100

                if not _G.PanicModeActive and pct < Config.PanicMode.LowHealthPercent then
                    -- [FIXED] Huỷ tween đang chạy (nếu có) trước khi ép CFrame —
                    -- không thì TweenController đang chạy dở (VD: LevelFarm đang
                    -- tween tới quest) sẽ tiếp tục update CFrame theo hướng CŨ ở
                    -- frame sau, kéo nhân vật xuống lại gần như ngay lập tức,
                    -- vô hiệu hoá panic mode.
                    pcall(function() if TweenInstance then TweenInstance:Cancel() end end)
                    _G.PanicModeActive = true
                    escapeY = hrp.Position.Y + Config.PanicMode.EscapeHeight
                    SetTask("MainTask", "⚠️ PANIC MODE | Máu " .. math.floor(pct) .. "% — bay lên trốn")
                    hrp.CFrame = CFrame.new(hrp.Position.X, escapeY, hrp.Position.Z)

                elseif _G.PanicModeActive then
                    -- Đang trốn trên cao — giữ nguyên độ cao, chờ hồi máu
                    if hrp.Position.Y < (escapeY or 0) - 50 then
                        pcall(function() if TweenInstance then TweenInstance:Cancel() end end)
                        hrp.CFrame = CFrame.new(hrp.Position.X, escapeY, hrp.Position.Z)
                    end
                    if pct >= Config.PanicMode.SafeHealthPercent then
                        -- [NEW] Hồi đủ máu → bay xuống lại, tắt panic mode
                        SetTask("MainTask", "✅ Máu hồi " .. math.floor(pct) .. "% — bay xuống tiếp tục farm")
                        _G.PanicModeActive = false
                        escapeY = nil
                    else
                        SetTask("SubTask", "PANIC MODE | Đang trốn trên cao — máu " .. math.floor(pct) .. "%/" .. Config.PanicMode.SafeHealthPercent .. "%")
                    end
                end
            end)
        end
    end)

    -- [NEW] Auto Ken (Haki Quan Sát / Observation Haki) — spam liên tục
    -- tới khi mở được thì ngưng, không spam nữa
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                if not Config.AutoKen then return end
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HasKen") then
                    return -- đã mở rồi, không spam nữa
                end
                Services.ReplicatedStorage.Remotes.CommE:FireServer("Ken", true)
            end)
        end
    end)


    function CreateTraceback(J, W) table.insert(ScriptStorage.Tracebacks, (GetCurrentDateTime() .. ' ( ' .. DispTime(os.time() - os.time(), true) .. ' ) after execution | ' .. J .. " | " .. W)) end
    function Report(message)
        pcall(function()
            print("[Kaitun Report]", tostring(message))
            CreateTraceback("Report", tostring(message))
        end)
    end
    function SetTask(J, W)
        if ScriptStorage.Task[J] == W then return end
        local a = {MainTask = "Task1", SubTask = 'Task2'}
        if a[J] then if SetText then SetText(a[J], J .. ' : ' .. W) end end
        ScriptStorage.Task[J] = W
        ScriptStorage.Task[J .. '-d'] = os.time()
    end
    Remotes = {}
    BindedMeleeNPCNames = {BlackLeg = 'Dark Step Teacher', Electro = "Mad Scientist", FishmanKarate = "Water Kung-fu Teacher", DeathStep = "Phoeyu, the Reformed", SharkmanKarate = 'Sharkman Teacher', DragonTalon = "Uzoth", ElectricClaw = 'Previous Hero', Godhuman = "Ancient Monk"}
    local J = {}
    setmetatable(Remotes, {__index = function(W, W)
        if W ~= 'CommF_' then
            print('captured unregistered signal', key)
            return Services.ReplicatedStorage.Remotes[W]
        end
        local W = {InvokeServer = function(a, ...)
            print('remote fired', ...)
            local a, h = ...
            if string.find(a, "Buy") == 1 and not h then
                local h = string.gsub(a, 'Buy', "")
                if BindedMeleeNPCNames then
                    if table.find(J, h) then
                        local a = ScriptStorage.NPCs[BindedMeleeNPCNames[h]]
                        if a then
                            local h = a.WorldPivot
                            if CaculateDistance(h) > 10 then
                                repeat
                                    wait(1)
                                    TweenController.Create(h.Position)
                                until CaculateDistance(h) < 10
                                task.wait(3)
                                Services.ReplicatedStorage.Remotes.CommF_:InvokeServer(...)
                            end
                        end
                    end
                end
            end
            return Services.ReplicatedStorage.Remotes.CommF_:InvokeServer(...)
        end}
        return W
    end})
    Tasks = {}
    function AwaitUntilPlayerLoaded(W, a)
        repeat task.wait() until W.Character and W.Character:FindFirstChild('Humanoid')
        local hum = W.Character.Humanoid
        repeat task.wait() until hum.Health > 0
    end
    function AddPoint()
        local W = {}
        local a
        for h, h in LocalPlayer.Data.Stats:GetChildren() do
            if h and h:FindFirstChild('Level') then W[h.Name] = h.Level.Value end
        end
        if W.Defense < MaxLevel and (W.Defense < (ScriptStorage.PlayerData.Level / 80) or MaxLevel - W.Melee < 100) then
            a = 'Defense'
        elseif W.Melee < MaxLevel then
            a = "Melee"
        else
            a = 'Sword'
        end
        Remotes.CommF_:InvokeServer("AddPoint", a, 999)
    end
    local W = {Currencies = {Level = "#00BFFF", Beli = "#00BFFF", Fragments = "#00BFFF"}, Races = {}}
function RefreshPlayerData()
    pcall(function()
        for a, a in LocalPlayer.Data:GetChildren() do 
            pcall(function() ScriptStorage.PlayerData[a.Name] = a.Value end) 
        end
    end)
    local a = ""
    for h, X in ScriptStorage.PlayerData do
        local w = W.Currencies[h]
        if w then a = a .. '<font color="' .. w .. '">' .. h .. "</font>: " .. X .. ' ' end
    end
    if ScriptStorage.Interface then SetText('Currencies', a) end
end
    function RefreshRace()
        local W, a = Remotes.CommF_:InvokeServer('Alchemist', "1"), Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
        ScriptStorage.PlayerData.RaceLevel = 1
        if LocalPlayer.Character:FindFirstChild("RaceTransformed") then
            ScriptStorage.PlayerData.RaceLevel = 4
        elseif a == -2.0 then
            ScriptStorage.PlayerData.RaceLevel = 3
        elseif W == -2.0 then
            ScriptStorage.PlayerData.RaceLevel = 2
        end
    end
    function RefreshInventory()
        ScriptStorage.Backpack = {}
        local LP = game.Players.LocalPlayer
        local ok, Items = pcall(function() return require(game.ReplicatedStorage.ItemReplicationService)._UserCache[LP.UserId] end)
        if not ok or not Items then
            for W, W in Remotes.CommF_:InvokeServer('getInventory') do ScriptStorage.Backpack[W.Name] = W end
            return
        end
        local Q = Items:GetItems("Quantity")
        local M = Items:GetItems("Mastery")
        local C = require(game.ReplicatedStorage.ItemConfig)
        local W = require(game.ReplicatedStorage.Modules.CombatUtil)
        local mas = {}
        if M then for _, v in pairs(M) do mas[v.ItemId] = v.Value end end
        local function clean(s) return s:gsub(" %[.-%]", "") end
        for _, v in pairs(Q) do
            local id, qt = v.ItemId, v.Value
            local ty, dn = "?", ""
            pcall(function()
                local c = C.match(id):unwrap()
                if c and c.Index then ty = c.Index.IdType; dn = c.Index.DebugLabel end
            end)
            local name = clean(dn)
            if name ~= "" then
                local entry = {Name = name, Count = qt, ItemId = id}
                ScriptStorage.Backpack[name] = entry
                if ty == "Moveset" or ty == "PhysicalMoveset" then
                    local md = mas[id]
                    if md then
                        local wd = W:GetWeaponData(name)
                        if wd then
                            if tostring(wd.WeaponType):find("Sword") then
                                entry.Type = "Sword"
                                entry.Mastery = md
                                entry.MasteryRequirements = {[1] = 350}
                            else
                                ScriptStorage.Melees[name] = md
                            end
                        end
                    end
                end
            end
        end
    end
    function ResearchMoves(W)
        if W and tostring(W) == 'V' then
            if ScriptStorage.Connections.BurstCheck then
                ScriptStorage.Connections.BurstCheck:Disconnect()
                task.wait(1)
            end
            print('[ Debug ] Registering burst', W)
            ScriptStorage.Connections.BurstCheck = W.Cooldown:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                if EnablingBurstDebounce and os.time() - EnablingBurstDebounce < 10 then return end
                local a = W.Cooldown.AbsoluteSize.X
                if a < 3 then
                    EnablingBurstDebounce = os.time()
                    task.wait(5)
                    SendKey('V', 0)
                end
            end)
        end
    end
    function CheckMeleeBurstMove(W)
        if W.Name == "Black Leg" or W.Name == "Death Step" then
            local a = PlayerGui.Main.Skills:WaitForChild(W.Name, 9)
            ResearchMoves(a:WaitForChild("V"))
        end
    end
    function RefreshMelees(W)
        local a = ''
        for h, X in ScriptStorage.Melees do a = a .. h .. ": " .. X .. " " end
        a = a == '' and '[0]' or a
        if W then return a end
        if ScriptStorage.Interface then SetText('Melees', a) end
    end
    function MeleeCheck(W)
        print('Melee check', W)
        if W and typeof(W) == "Instance" and W:IsA("Tool") then
            if W.ToolTip == "Melee" then
                if ScriptStorage.Connections.Melees then ScriptStorage.Connections.Melees:Disconnect() end
                ScriptStorage.CurrentMeleeData.Name = W.Name
                pcall(function() ScriptStorage.Connections.Melees:Destroy() end)
                local lv = W:FindFirstChild("Level")
                if lv then
                    ScriptStorage.Connections.Melees = lv.Changed:Connect(function(a)
                        ScriptStorage.Melees[W.Name] = a
                        RefreshMelees()
                    end)
                    ScriptStorage.Melees[W.Name] = lv.Value
                end
                RefreshMelees()
            elseif string.find(tostring(W), "Fruit") then
                task.spawn(function()
                    if table.find(ScriptStorage.IgnoreStoreFruits, W:GetAttribute('OriginalName')) then return end
                    local a = Remotes.CommF_:InvokeServer("StoreFruit", W:GetAttribute("OriginalName"), W)
                end)
            end
        end
    end
    SetText('MainTextLabel', 'Refreshing Player Data')
    MeleeCheck(LocalPlayer.Character:FindFirstChildOfClass('Tool'))
    RefreshPlayerData()
    function RegisterLocalPlayerEventsConnection()
        task.spawn(function()
            -- [FIXED - bớt delay theo yêu cầu boss man] 6s → 3s. Đủ để
            -- Character/Data ổn định sau spawn trước khi check HasBuso.
            task.wait(3)
            if LocalPlayer.Character:FindFirstChild('HasBuso') then return end
            Remotes.CommF_:InvokeServer("Buso")
        end)
        for W, W in ScriptStorage.Connections.LocalPlayer do pcall(function() W:Disconnect() end) end
        AwaitUntilPlayerLoaded(LocalPlayer)
        LocalPlayer:SetAttribute("IsAvailable", true)
        ScriptStorage.Connections.LocalPlayer["HealthCheck"] = LocalPlayer.Character:WaitForChild("Humanoid"):GetPropertyChangedSignal("Health"):Connect(function()
            local W = LocalPlayer.Character.Humanoid.Health
            LocalPlayer:SetAttribute("IsAvailable", W > 10)
            ScriptStorage.LocalPlayerHealth = W
        end)
        ScriptStorage.Connections.LocalPlayer['Melee'] = LocalPlayer.Character.ChildAdded:Connect(MeleeCheck)
        local bp = LocalPlayer:WaitForChild("Backpack")
        ScriptStorage.Connections.LocalPlayer['Fruit'] = bp.ChildAdded:Connect(MeleeCheck)
        for _, c in ipairs(bp:GetChildren()) do MeleeCheck(c) end
        LastIdleCheck = os.time()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        ScriptStorage.Connections.LocalPlayer.PositionChecker = hrp:GetPropertyChangedSignal('CFrame'):Connect(function()
            if os.time() == LastIdleCheck then return end
            LastIdleCheck = os.time()
            if oldPos then
                if (hrp.CFrame.p - oldPos).magnitude < 2 then return end
            end
            oldPos = (hrp.CFrame.p)
            LastIdling = os.time()
        end)
        local W = LocalPlayer.Data:WaitForChild('Points')
        ScriptStorage.Connections.LocalPlayer.PointConnection = W:GetPropertyChangedSignal('Value'):Connect(function()
            local W = LocalPlayer.Data:WaitForChild('Points')
            if OldPointValue == W then return end
            OldPointValue = W
            AddPoint()
        end)
    end
    RegisterLocalPlayerEventsConnection(LocalPlayer)
    game.Players.LocalPlayer.CharacterAdded:Connect(function(W)
        print('[ Debug ] re-registering events')
        RegisterLocalPlayerEventsConnection(LocalPlayer)
    end)
    task.spawn(function()
        task.wait(3)
        if LocalPlayer.Character:FindFirstChild("HasBuso") then return end
        Remotes.CommF_:InvokeServer("Buso")
    end)
    print(1)

    -- ============================================================
    -- BẢNG MELEE & DATA (GIỮ NGUYÊN)
    -- ============================================================
    MeleesTable = {"Black Leg", 'Electro', "Fishman Karate", "Dragon Claw", "Superhuman", 'Death Step', 'Electric Claw', 'Sharkman Karate', 'Dragon Talon', "Godhuman"}
    MeleesId = {'BlackLeg', "Electro", 'FishmanKarate', "DragonClaw", "Superhuman", 'DeathStep', "ElectricClaw", "SharkmanKarate", 'DragonTalon', 'Godhuman'}
    MeleePrices = {["Black Leg"] = {Price = {Beli = 150000}, Id = "BlackLeg", NextLevelRequirement = 300, position = CFrame.new(), Requirements = function() return true end, Buy = function(W) return BuyMelee("BlackLeg", W, 'Dark Step Teacher') end}, ['Electro'] = {Price = {Beli = 500000}, Id = 'Electro', NextLevelRequirement = 300, Requirements = function() return true end, Buy = function(W) return BuyMelee('Electro', W, "Mad Scientist") end}, ['Fishman Karate'] = {Price = {Beli = 750000}, NextLevelRequirement = 300, Requirements = function() return true end, Buy = function(W) return BuyMelee('FishmanKarate', W, 'Water Kung-fu Teacher') end}, ['Dragon Claw'] = {Price = {Fragments = 1500}, NextLevelRequirement = 300, Requirements = function() return true end, Buy = function(W) return BuyMelee("DragonClaw", W, "Sabi") end}, ["Superhuman"] = {Price = {Beli = 3000000}, NextLevelRequirement = nil, Requirements = function() return true end, Buy = function(W) return BuyMelee("Superhuman", W, "Martial Arts Master") end}, ["Death Step"] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("DeathStep", W, "Phoeyu, the Reformed") end}, ['Sharkman Karate'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee('SharkmanKarate', W, 'Sharkman Teacher') end}, ['Electric Claw'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("ElectricClaw", W, 'Previous Hero') end}, ['Dragon Talon'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("DragonTalon", W, 'Uzoth') end}, ["Godhuman"] = {Price = {Beli = 5000000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("Godhuman", W, 'Ancient Monk') end}}
    DropItemData = {['Buddy Sword'] = {Sea = 3, Level = 1500, Boss = "Cake Queen"}, ['Canvander'] = {Sea = 3, Level = 1500, Boss = "Beautiful Pirate"}, ['Twin Hooks'] = {Sea = 3, Level = 1500, Boss = 'Captain Elephant'}, ["Venom Bow"] = {Sea = 3, Level = 1500, Boss = "Hydra Leader"}}
    GodhumanMaterials = {['Fish Tail'] = {20, 3, {"Fishman Raider", "Fishman Captain"}, {'DeepForestIsland3', 1, 1775, 'Turtle Adventure Quest Giver'}}, ['Dragon Scale'] = {10, 3, {"Dragon Crew Warrior", "Dragon Crew Archer"}, {'DragonCrewQuest', 1, 1575, 'Dragon Crew Quest Giver'}}, ["Magma Ore"] = {20, 2, {'Magma Ninja'}, {"FireSideQuest", 1, 1100, "Fire Quest Giver"}}, ["Mystic Droplet"] = {10, 2, {'Sea Soldier', 'Water Fighter'}, {'ForgottenQuest', 2, 1425, 'Forgotten Quest Giver'}}}
    SeaIndexes = {"Main", "Dressrosa", "Zou"}

    -- [FIXED - QUAN TRỌNG] RefreshTasksData là first-match-wins: handler
    -- nào Refresh() trả về giá trị TRƯỚC trong mảng này thắng NGAY, dừng
    -- luôn (return ở dòng ~4051), không kiểm tra tiếp các handler sau.
    -- "LevelFarm" đứng đầu + Refresh gần như LUÔN trả về (1/2/4, hiếm khi
    -- nil) → nó thắng MỌI vòng, SpecialBossesTask/SwordBossTask/
    -- CakePrinceTask/BossesTask phía sau KHÔNG BAO GIỜ được chạy tới —
    -- đây mới là lý do thật "không thấy farm boss lấy item", không phải
    -- do boss hiếm/config sai. Đưa hết boss-farming lên TRƯỚC LevelFarm:
    -- boss nào đang farm được thì ưu tiên, hết boss mới rơi xuống LevelFarm.
    -- [FIXED - XUNG ĐỘT] Lúc reorder ưu tiên boss-farming (lượt trước), tao
    -- viết đè nguyên khối TasksOrder và LÀM MẤT 5 handler đã fix từ rất lâu
    -- ("Saber","CursedDualKatana","SoulGuitar","EvoRace","RaceAwakening") —
    -- y hệt bug gốc "registered nhưng không nằm trong TasksOrder = không
    -- bao giờ chạy" mà tao đã tốn nhiều lượt để tìm ra và fix trước đó.
    -- Khôi phục lại đầy đủ, vẫn giữ thứ tự ưu tiên boss-farming mới.
    -- [FIXED - theo spec 2e/2g] RaidController tự check "fr > 5000 then
    -- return nil" ĐÚNG rồi (dòng ~3005) — vấn đề là nó đứng SAU
    -- CakePrinceTask/MeleesController/CDK trong TasksOrder (first-match-
    -- wins), nên dù Fragments cạn, mấy handler "training" phía trước vẫn
    -- thắng dispatch trước, RaidController không bao giờ được chạy tới.
    -- Đưa RaidController/AutoRaidIce lên TRƯỚC các hoạt động "training"
    -- (không khẩn cấp như boss hiếm) — Fragments thấp thì tự nhường,
    -- Fragments đủ thì RaidController tự trả nil, rơi xuống training tiếp.
    -- [FIXED - theo spec 2g] "MeleesController" đứng CUỐI danh sách khiến
    -- LevelFarm (đứng rất trước, Refresh gần như luôn trả về giá trị) LUÔN
    -- thắng dispatch — "melee đủ mastery thì dừng LevelFarm chuyển bước
    -- tiếp theo" không bao giờ có cơ hội xảy ra vì MeleesController không
    -- bao giờ được chạy tới. Đưa lên ngang hàng ưu tiên với CakePrinceTask
    -- (trước LevelFarm) — mua melee/kiểm tra điều kiện tiên quyết giờ mới
    -- thật sự preempt được leveling thường.
    TasksOrder = {
        "SpecialBossesTask", "SwordBossTask", "BossesTask",
        "RaidController", "AutoRaidIce",
        "CakePrinceTask", "MeleesController",
        "LevelFarm", "Tushita", 'Yama',
        "Saber", "CursedDualKatana", "SoulGuitar", "EvoRace", "RaceAwakening",
        -- [FIXED - xung đột code phát hiện khi rà toàn bộ] Bỏ "Wenlocktoad"
        -- và "ExpRedeem" khỏi danh sách này — cả 2 CÓ gọi :Register() (tạo
        -- task slot rỗng) nhưng KHÔNG hề có RegisterMethod("Refresh"/"Start")
        -- ở bất kỳ đâu trong file. Dispatcher (RefreshTasksData, có "if k
        -- then" guard trước khi gọi) không crash vì việc này, nhưng mỗi tick
        -- vẫn tốn 1 lần lookup FunctionsHandler[name] + kiểm tra Initalized
        -- cho 2 task không bao giờ làm gì cả — dọn bỏ. Cũng bỏ luôn bản
        -- "ThirdSeaPuzzle" bị lặp 2 lần (1 lần double-quote, 1 lần single-
        -- quote) — hệ thống first-match-wins nên lần lặp lại chỉ tốn thêm
        -- 1 lần gọi Refresh() y hệt trong CÙNG 1 tick, không có tác dụng gì.
        'Trevor', "UtillyItemsActivitation", 'ColosseumPuzzle', "ThirdSeaPuzzle", "PirateRaid", "SecondSeaPuzzle", "CollectDrops"}
    MaxLevel = 2800
    placeId = game.PlaceId
    if placeId == 85211729168715 or placeId == 2753915549 then
        Sea = 'Main'
        SeaIndex = 1
    elseif placeId == 79091703265657 or placeId == 4442272183 then
        Sea = "Dressrosa"
        SeaIndex = 2
    elseif placeId == 100117331123089 or placeId == 7449423635 then
        Sea = "Zou"
        SeaIndex = 3
    end
    Portals = ({{Vector3.new(-7894.6201171875, 5545.49169921875, -380.246346191406), Vector3.new(-4607.82275390625, 872.5422973632812, -1667.556884765625), Vector3.new(61163.8515625, 11.759522438049316, 1819.7841796875), Vector3.new(3876.280517578125, 35.10614013671875, -1939.3201904296875)}, {Vector3.new(-288.46246337890625, 306.130615234375, 597.9988403320312), Vector3.new(2284.912109375, 15.152046203613281, 905.48291015625), Vector3.new(923.21252441406, 126.9760055542, 32852.83203125), Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422)}, {}})[SeaIndex]
    -- [FIXED] Bỏ 'Cake Prince' khỏi đây — giờ có CakePrinceTask riêng
    -- (chủ động farm quái mở khoá + tự trigger summon), tránh 2 hệ thống
    -- cùng đánh 1 boss gây xung đột combat
    BossesOrder = {"Awakened Ice Admiral", "Tide Keeper", 'Deandre', "Urban", "Diablo", 'Soul Reaper'}
    BossesOrderLevel = {['Awakened Ice Admiral'] = 700, ['Tide Keeper'] = 700, ['Deandre'] = 1500, ['Urban'] = 1500, ['Diablo'] = 1500, ['Soul Reaper'] = 1500}
    BossesOrderWL = {["Deandre"] = 1500, ["Urban"] = 1500, ["Diablo"] = 1500, ['Don Swan'] = 1100, ["Awakened Ice Admiral"] = 700, ['Tide Keeper'] = 700}
    -- [ADDED] Katakuri — KHÔNG tìm thấy trong file nat kaitun hay bất kỳ
    -- nguồn nào tao có, nên đây là giá trị đoán an toàn (level 2150, giống
    -- mức các boss cuối game khác). Nếu sai level thật, báo tao sửa lại.
    -- [FIXED] "Hải Tặc Đào Hoa" = "Beautiful Pirates" — trước đây tao đoán
    -- nhầm là Cake Prince, boss man đã sửa lại đúng tên. Toạ độ lấy từ
    -- file bypass-teleport verified (Vector3.new(5319, 23, -93)) — level
    -- chưa có nguồn xác nhận, tạm để 1500 giống tier Deandre/Urban/Diablo,
    -- báo tao nếu sai.
    SpecialBossesOrder = {["Core"] = 700, ['Darkbeard'] = 700, ["Katakuri"] = 2150, ["Beautiful Pirates"] = 1500}
    -- [NEW - theo spec] Toạ độ farm Bones ở Haunted Castle, dùng chung cho
    -- Fire Essence (Dragon Talon), Hallow Essence (CDK), và Yama/Tushita
    HAUNTED_CASTLE_BONES_CF = CFrame.new(-8817.880859375, 191.16761779785, 6298.6557617188)
    BeautifulPiratesCF = CFrame.new(5319, 23, -93)

    -- Config.Sword và Config.BossWeapons giờ nằm ở đầu file (khối Config = {...})
    -- theo đúng yêu cầu "để config lên trên cùng" — không định nghĩa lại ở đây nữa
    BlankTablets = {"Segment6", 'Segment2', 'Segment8', "Segment9", 'Segment5'}
    Trophy = {["Segment1"] = "Trophy1", ["Segment3"] = "Trophy2", ['Segment4'] = "Trophy3", ['Segment7'] = "Trophy4", ["Segment10"] = "Trophy5"}
    Pipes = {['Part1'] = 'Really black', ['Part2'] = 'Really black', ["Part3"] = "Dusty Rose", ['Part4'] = "Storm blue", ['Part5'] = 'Really black', ['Part6'] = "Parsley green", ["Part7"] = 'Really black', ["Part8"] = "Dusty Rose", ["Part9"] = 'Really black', ['Part10'] = 'Storm blue'}
    function GenerateUUID()
        local W = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
        return string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", '[xy]', function(W)
            local W = (Idx == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
            return string.format('%x', W)
        end)
    end
    function CheckIsPlayerAlive(W) W = W or LocalPlayer; return W and W.Character and W.Character.Humanoid and W.Character.HumanoidRootPart and W.Character.Head and W.Character.Humanoid.Health > 0 end
    function ConvertTo(W, a) return W.new(a.X, a.Y, a.Z) end
    function CaculateDistance(W, a)
        if not W then return 0 end
        a = a or game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        local h, X = ConvertTo(Vector3, W), ConvertTo(Vector3, a)
        return (h - X).magnitude
    end
    function DispTime(W, a)
        W = tonumber(W)
        if not W then return "[err]" end
        local h = math.floor(W / 86400)
        local X = math.floor(math.fmod(W, 86400) / 3600)
        local w = math.floor(math.fmod(W, 3600) / 60)
        local D = math.floor(math.fmod(W, 60))
        if a then return (h .. "day, " .. X .. "hrs, " .. w .. "min, " .. D .. 'sec.') end
        return (h .. 'day, ' .. X .. "hrs.")
    end
    function GetCurrentDateTime()
        local W = os.date("*t")
        local a = W.hour
        local h = W.min
        local X = W.day
        local w = W.month
        local D = W.year
        local y = W.wday
        local W = string.format('%02d:%02d ', a, h)
        local a = {'Sun', "Mon", 'Tue', "Wed", 'Thu', "Fri", 'Sat'}
        local h = a[y]
        local a = {"Jan", "Feb", "Mar", 'Apr', "May", 'Jun', "Jul", 'Aug', 'Sep', "Oct", 'Nov', "Dec"}
        local y = a[w]
        local a = string.format('%s, %s %d %d', h, y, X, D)
        return W .. a
    end
    function RandomArguments(...) local W = {...}; return W[math.random(0, #W)] end
    function RoundVector3Down(W) return Vector3.new(math.floor(W.X / 10) * 10, math.floor(W.Y / 10) * 10, math.floor(W.Z / 10) * 10) end

    -- ============================================================
    -- XOAY VÒNG TRÒN CŨ (DÙNG TICK)
    -- ============================================================
    -- [FIXED] W_angle/lastChange chưa từng được khởi tạo — gọi hàm này lần
    -- đầu sẽ crash ("attempt to compare nil with number") vì so sánh
    -- W_angle (nil) > 50000. Khởi tạo trước khi dùng.
    W_angle = W_angle or 0
    lastChange = lastChange or tick()

    -- [UPDATED] Đổi tốc độ theo bản boss man đưa: 0.01s / 20° (mượt hơn
    -- bản cũ 0.4s / 80°, xoay liên tục thay vì giật cục)
    CaculateCircreDirection = function(a)
        if W_angle > 50000 then W_angle = 60 end
        W_angle = W_angle + ((tick() - lastChange) > 0.01 and 20 or 0)
        if tick() - lastChange > 0.01 then lastChange = tick() end
        local h = a + Vector3.new(math.cos(math.rad(W_angle)) * 40, 0, math.sin(math.rad(W_angle)) * 40)
        return CFrame.new(RoundVector3Down(h.p))
    end

    function GetMonAsSortedRange()
        local W = {}
        table.foreach(Services.Workspace.Enemies:GetChildren(), function(a, a)
            if a and a:FindFirstChild('Humanoid') and a:FindFirstChild("HumanoidRootPart") and a.Humanoid.Health > 0 then
                table.insert(W, a)
            end
        end)
        table.foreach(game.ReplicatedStorage:GetChildren(), function(a, a)
            if a and a:FindFirstChild('Humanoid') and a:FindFirstChild("HumanoidRootPart") and a.Humanoid.Health > 0 then
                table.insert(W, a)
            end
        end)
        table.sort(W, function(a, h) return CaculateDistance(a.HumanoidRootPart.CFrame) < CaculateDistance(h.HumanoidRootPart.CFrame) end)
        return W
    end
    print(1.5)
    function GetMeleeIdByName(W) for a, h in MeleesTable do if h == W then return MeleesId[a] end end end
    function FindMeleeNPC(npcName)
        for _, npc in pairs(workspace.NPCs:GetChildren()) do
            if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
                return npc.HumanoidRootPart.Position
            end
        end
        return nil
    end
    function getpos(W)
        for a, a in game:GetService("ReplicatedStorage").NPCs:GetChildren() do if a.Name == W then return a.HumanoidRootPart.CFrame end end
        for a, a in workspace.NPCs:GetChildren() do if a.Name == W then return a.HumanoidRootPart.CFrame end end
    end

    -- ============================================================
    -- HÀM HỖ TRỢ AUTO FULL MELEE
    -- ============================================================
    function GetBP(meleeName)
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp and bp:FindFirstChild(meleeName) then return bp[meleeName] end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild(meleeName) then return char[meleeName] end
        return nil
    end

    function GetM(matName)
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if not bp then return 0 end
        for _, v in pairs(bp:GetChildren()) do
            if v.Name == matName and v:FindFirstChild("Count") then
                return v.Count.Value
            end
        end
        return 0
    end

    function GetConnectionEnemies(enemyName)
        local nearest, dist = nil, math.huge
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy.Name == enemyName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                local root = enemy:FindFirstChild("HumanoidRootPart")
                if root then
                    local d = (root.Position - hrp.Position).Magnitude
                    if d < dist then
                        dist = d
                        nearest = enemy
                    end
                end
            end
        end
        return nearest
    end

    function BuyMelee(W, a)
        if W == "DragonClaw" then
            if workspace.NPCs:FindFirstChild('Sabi') then
                if a then
                    if type(Remotes.CommF_:InvokeServer("BlackbeardReward", 'DragonClaw', '1') == 1) == "number" and Remotes.CommF_:InvokeServer('BlackbeardReward', 'DragonClaw', '1') == 1 == 1 and not table.find(J, W) then table.insert(J, W) end
                    return Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
                end
                return Remotes.CommF_:InvokeServer('BlackbeardReward', "DragonClaw", '2')
            end
        end
        if W == "Godhuman" then
            -- [FIXED - verified từ message_10] BuyGodhuman cần gọi 2 LẦN
            -- (true, rồi không tham số) — generic 1-lần bên dưới không đủ,
            -- y hệt pattern Dragon Talon đã verify trước đó.
            Remotes.CommF_:InvokeServer("BuyGodhuman", true)
            local result = Remotes.CommF_:InvokeServer("BuyGodhuman")
            if not table.find(J, W) then table.insert(J, W) end
            return result
        end
        if a then
            local a = Remotes.CommF_:InvokeServer('Buy' .. W, true)
            print("Response_", a == 1, typeof(a))
            if type(a) == 'number' and not table.find(J, W) then table.insert(J, W) end
            return a == 1
        end
        return Remotes.CommF_:InvokeServer("Buy" .. W)
    end

    function SendKey(J, W)
        (function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, J, false, game)
            task.wait(W)
            game:GetService('VirtualInputManager'):SendKeyEvent(false, J, false, game)
        end)()
    end

    function FruitIdToName(J)
        local W = string.match(J, "((%u)[^%-]+)$")
        return W .. ' Fruit'
    end
    function Split(J, W)
        if W == nil then W = "%s" end
        local a = {}
        for h in string.gmatch(J, '([^' .. W .. ']+)') do table.insert(a, h) end
        return a
    end
    function FruitNameToId(J)
        local W = Split(J)[1]
        return W .. '-' .. W
    end

    -- ============================================================
    -- J QUESTS
    -- ============================================================
    local J = {CurrentLevel = 2, DoubleQuest = true, CurrentQuests = {}, BlacklistedQuestIds = {BartiloQuest = 1, CitizenQuest = 1, Trainees = 1, MarineQuest = 1, ImpelQuest = 1}}
    local W = require(game.ReplicatedStorage.GuideModule).Data.NPCList
    repeat task.wait() until game.Players.LocalPlayer.DataLoaded and ScriptStorage
    J.Quests = require(game.ReplicatedStorage.Quests)
    function J.Set(W, a, h) W[a] = h end
    function J.RefreshQuest(W)
        local timeout = os.time()
        while not ScriptStorage.PlayerData.Level do
            task.wait(1)
            print('[ Debug ] Waiting for LocalPlayer datas.')
            if os.time() - timeout > 30 then
                print('[ Debug ] Timeout waiting for player data, skipping quest refresh')
                return
            end
        end
        local a = 0
        local h
        for X, w in J.Quests do
            if not J.BlacklistedQuestIds[X] then
                if (w[1].LevelReq >= a and w[1].LevelReq <= ScriptStorage.PlayerData.Level) then
                    a = w[1].LevelReq
                    h = w
                    W.CurrentQuestId = X
                    if ScriptStorage.PlayerData.Level >= 1500 and SeaIndex == 2 and X == 'ForgottenQuest' then break end
                end
            end
        end
        local a = h[#h]
        for X, X in a.Task do if X == 1 then table.remove(h, #h) end end
        for a, X in require(game.ReplicatedStorage.GuideModule).Data.NPCList do
            for w, w in X.Levels do if w == h[#h].LevelReq then W.CurrentNpc = a.CFrame end end
        end
        W.CurrentQuests = h
    end
    function J.GetCurrentQuest(W)
        local a = W.CurrentQuests[W.CurrentLevel] and W.CurrentQuests[W.CurrentLevel].LevelReq <= ScriptStorage.PlayerData.Level and W.CurrentLevel or 1
        for h in W.CurrentQuests[a].Task do return h, W.CurrentNpc, W.CurrentQuestId, a, W.CurrentQuests[a].Name end
    end
    function J.MarkAsCompleted(W) W.CurrentLevel = W.CurrentLevel == 2 and 1 or 2 end
    function J.AbandonQuest()
        print('Abandon Quest')
        Remotes.CommF_:InvokeServer("AbandonQuest")
    end
    function J.GetCurrentClaimQuest(W)
        local W = game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:gsub("%s*Defeat%s*(%d*)%s*(.-)%s*%b()", '%2')
        return (type(W) == "string" and string.gsub(W, "Military ", "Mil. ") or W), game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
    end
    function J.StartQuest(W, a)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer('ColorsDealer', "2")
        return Remotes.CommF_:InvokeServer("StartQuest", W, a)
    end

    -- ============================================================
    -- SCRIPTSTORAGE MOB REGIONS
    -- ============================================================
    ScriptStorage.MobRegions = {}
    for W, W in game:GetService("ReplicatedStorage").FortBuilderReplicatedSpawnPositionsFolder:GetChildren() do
        ScriptStorage.MobRegions[tostring(W)] = ScriptStorage.MobRegions[tostring(W)] or {}
        table.insert(ScriptStorage.MobRegions[tostring(W)], W.CFrame)
    end

    -- ============================================================
    -- TWEEN CONTROLLER
    -- ============================================================
    TweenController = {}

    -- [ADDED - theo yêu cầu boss man: "dùng tween của file red magic hub"]
    -- Port block-tween + sync loop từ main_red_magic_beta.txt — tween 1
    -- Part vô hình ("block") thay vì tween thẳng HumanoidRootPart, nhân
    -- vật tự "bám" theo block khi đang farm (getgenv().OnFarm), tránh anti-
    -- cheat detect việc set CFrame của HRP trực tiếp mỗi frame.
    local block = Instance.new("Part", workspace)
    block.Size = Vector3.new(1, 1, 1)
    block.Name = "Rip_Indra"
    block.Anchored = true
    block.CanCollide = false
    block.CanTouch = false
    block.Transparency = 1
    do
        local blockfind = workspace:FindFirstChild(block.Name)
        if blockfind and blockfind ~= block then blockfind:Destroy() end
    end
    task.spawn(function()
        while task.wait() do
            if block and block.Parent == workspace then
                getgenv().OnFarm = shouldTween and true or false
            else
                getgenv().OnFarm = false
            end
        end
    end)
    task.spawn(function()
        local a = game.Players.LocalPlayer
        repeat task.wait() until a.Character and a.Character.PrimaryPart
        block.CFrame = a.Character.PrimaryPart.CFrame
        while task.wait() do
            pcall(function()
                if getgenv().OnFarm then
                    if block and block.Parent == workspace then
                        local b = a.Character and a.Character.PrimaryPart
                        if b and (b.Position - block.Position).Magnitude <= 200 then
                            b.CFrame = block.CFrame
                        else
                            block.CFrame = b.CFrame
                        end
                    end
                    local c = a.Character
                    if c then
                        for _, e in pairs(c:GetChildren()) do
                            if e:IsA("BasePart") then e.CanCollide = false end
                        end
                    end
                else
                    local c = a.Character
                    if c then
                        for _, e in pairs(c:GetChildren()) do
                            if e:IsA("BasePart") then e.CanCollide = true end
                        end
                    end
                end
            end)
        end
    end)

    local W = 0
    local W = {}
    for a, a in game.ReplicatedStorage.NPCs:GetChildren() do if a.Name == 'Set Home Point' then table.insert(W, a:GetModelCFrame()) end end
    function TweenController.Update()
        local a = game.Players.LocalPlayer.Character.HumanoidRootPart
        HumanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        if CaculateDistance(a.CFrame) > 250 then
            pcall(function() TweenInstance:Cancel() end)
            TweenDebounce = true
            a.CFrame = HumanoidRootPart.CFrame
            TweenDebounce = false
        end
        HumanoidRootPart.CFrame = a.CFrame + Vector3.new(0, 3, 0)
    end
    function GetPortal(a)
        local h, X = 9e9, nil
        for w, w in Portals do
            local D = CaculateDistance(w, a)
            if D < (CaculateDistance(a) - 300) and D < h then
                h = D
                X = w
            end
        end
        if X then
            Remotes.CommF_:InvokeServer("requestEntrance", X)
            return task.wait()
        end
    end
    function GetEntries(a)
        local h, X = 9e9, nil
        for w, w in W do
            local W = CaculateDistance(w, a)
            if W < (CaculateDistance(a) - 700) and W < h then
                h = W
                X = w
            end
        end
        if X then if os.time() - 0 > 30 then for W = 1, 10, 1 do task.wait() end end end
    end
    function TweenController.Tween2(W, a)
        TweenInstance2 = Services.TweenService:Create(W, TweenInfo.new(CaculateDistance(W.CFrame, a) / 50, Enum.EasingStyle.Linear), {CFrame = ConvertTo(CFrame, a) - Vector3.new(0, 0, 0)})
        TweenInstance2:Play()
    end
    function CheckItem(itemName)
        local bp = game.Players.LocalPlayer:FindFirstChild('Backpack')
        for _, v in next, bp and bp:GetChildren() or {} do
            if v:IsA('Tool') and (v.Name == itemName or string.find(v.Name, itemName)) then return v end
        end
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in next, char:GetChildren() do
                if v:IsA('Tool') and (v.Name == itemName or string.find(v.Name, itemName)) then return v end
            end
        end
        return false
    end

    -- [FIXED - theo yêu cầu boss man: "bỏ bypass teleport"] Đã xoá hẳn toàn
    -- bộ cụm hàm bypass-teleport (CheckLegendaryItems/InArea/GetSpawnPoint/
    -- CanBypassTeleport/GetBypassCFrame/BypassTP) — kiểm tra kỹ trước khi
    -- xoá: không còn nơi nào khác trong file gọi các hàm này (cả 2 điểm
    -- gọi BypassTP() duy nhất, trong TweenController.Create và
    -- _SgCollectChest, đã được thay bằng tween thường ở trên).

    -- ============================================================
    -- [FIXED] TWEEN CONTROLLER - GIỮ NGUYÊN 200/190
    -- ============================================================
    function TweenController.Create(W)
        if not W or TweenDebounce then return end
        local a = typeof(W) ~= 'CFrame' and ConvertTo(CFrame, W) or W
        if TweenInstance then pcall(function() TweenInstance:Cancel() end) end
        local character = game.Players.LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- [FIXED - theo yêu cầu boss man: "bỏ bypass teleport"] Đã xoá hẳn
        -- nhánh BypassTP (dist>=4000 → đổi spawn point) — không còn dùng
        -- cơ chế bypass qua spawn point nữa, mọi khoảng cách đều tween bình
        -- thường qua block (từ main_red_magic_beta.txt).
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        local head = character:WaitForChild("Head")
        if not head:FindFirstChild("eltrul") then
            local bv = Instance.new('BodyVelocity')
            bv.Name = "eltrul"
            bv.MaxForce = Vector3.new(0, math.huge, 0)
            bv.Velocity = Vector3.zero
            bv.Parent = head
        end
        if CaculateDistance(a) > 500 then
            if SeaIndex == 3 and not ScriptStorage.Backpack['Valkyrie Helm'] then
            elseif SeaIndex ~= 3 then
                GetPortal(a)
            end
        end
        if CaculateDistance(Vector3.new(11256, -2138.0, 9888), a) < (CaculateDistance(a) - 700) and SeaIndex == 3 then
            local gatePos = CFrame.new(-16269.0, 23, 1371)
            if CaculateDistance(gatePos) > 60 then
                TweenController.Create(gatePos)
                task.wait(1)
                return
            end
            local net = require(game.ReplicatedStorage.Modules.Net)
            net:RemoteFunction('SubmarineWorkerSpeak'):InvokeServer('TravelToSubmergedIsland')
        end

        a = CFrame.new(a.Position)
        local dist = CaculateDistance(hrp.CFrame, a)

        if dist <= 5 then
            hrp.CFrame = a
            block.CFrame = a
            return
        end

        -- [FIXED - theo yêu cầu boss man: "chỉnh lên 160 cho nhanh ko vượt
        -- quá 160"] Bỏ hẳn bảng 110/100 cũ — dùng 1 mức tốc độ CỐ ĐỊNH 160
        -- (giống tween của main_red_magic_beta.txt, chỉ đổi số chia 300 →
        -- 160 để nhanh hơn), không có mức nào vượt quá con số này.
        local divisor = 160
        local duration = dist / divisor

        -- [FIXED - port tween từ main_red_magic_beta.txt] Tween "block"
        -- (Part vô hình) thay vì tween thẳng hrp — nhân vật tự bám theo
        -- block qua vòng lặp sync đã thêm ở trên (getgenv().OnFarm).
        shouldTween = true
        TweenInstance = Services.TweenService:Create(block, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = a})
        TweenInstance:Play()
        task.spawn(function()
            while TweenInstance and TweenInstance.PlaybackState == Enum.PlaybackState.Playing do
                if not shouldTween then
                    pcall(function() TweenInstance:Cancel() end)
                    break
                end
                task.wait(0.1)
            end
            shouldTween = false
        end)
    end

    -- ============================================================
    -- FAST ATTACK & EQUIP WEAPON (LẤY TỪ TEST.TXT - GIỮ NGUYÊN)
    -- ============================================================
    local W = {}
    local a = game:GetService('Players')
    local h = game:GetService("RunService")
    local h = game:GetService('ReplicatedStorage')
    local X = game:GetService("Workspace")
    local X = game:GetService("VirtualInputManager")
    local X = a.LocalPlayer
    local X = h:WaitForChild('Modules')
    local w = X:WaitForChild("Net")
    local X = w:WaitForChild("RE/RegisterAttack")
    local X = w:WaitForChild('RE/RegisterHit')
    local X = w:WaitForChild('RE/ShootGunEvent')
    local X = h:WaitForChild("Remotes"):WaitForChild('Validator2')
    local h = game.ReplicatedStorage.Modules
    local X = h.Net
    local h, h = X:WaitForChild("RE/RegisterHit"), X:WaitForChild('RE/RegisterAttack')
    local h = {}
    function GetAllBladeHits()
        bladehits = {}
        for X, X in pairs(workspace.Enemies:GetChildren()) do
            if X:FindFirstChild('Humanoid') and X:FindFirstChild('HumanoidRootPart') and X.Humanoid.Health > 0 and (X.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 65 then
                table.insert(bladehits, X)
            end
        end
        return bladehits
    end
    function Getplayerhit()
        bladehits = {}
        for X, X in pairs(workspace.Characters:GetChildren()) do
            if X.Name ~= game.Players.LocalPlayer.Name and X:FindFirstChild('Humanoid') and X:FindFirstChild('HumanoidRootPart') and X.Humanoid.Health > 0 and (X.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 65 then
                table.insert(bladehits, X)
            end
        end
        return bladehits
    end
    local X = (Services.ReplicatedStorage.Modules.Net)
    local w = require(X):RemoteEvent("RegisterAttack", true)
    local D = require(X):RemoteEvent("RegisterHit", true)
    function h:Attack()
        local X = {}
        for y, y in pairs(GetAllBladeHits()) do table.insert(X, y) end
        for y, y in pairs(Getplayerhit()) do table.insert(X, y) end
        if #X == 0 then return end
        local y = {[1] = nil, [2] = {}, [4] = "078da5141"}
        for L, L in pairs(X) do
            w:FireServer(0)
            if not y[1] then y[1] = L.Head end
            table.insert(y[2], {[1] = L, [2] = L.HumanoidRootPart})
            table.insert(y[2], L)
        end
        D:FireServer(unpack(y))
    end
    task.spawn(function()
        while task.wait(.06) do if _G.FastAttack == os.time() then pcall(function() h:Attack() end) end end
    end)
function W.Attack(target) pcall(function() _G.FastAttack = os.time() end) end

    CombatController = {GRAB = false, GRAB_DISTANCE = SeaIndex == 1 and 250 or 350, MAX_ATTACK_DURATION = 2, MAX_ATTACK_DURATION_2 = 60, LEVITATE_TIME = 0, CurrentIndex = 1}

    -- ============================================================
    -- [NEW] BRING MOBS — 2-3 ตัว / ตำแหน่งนิ่ง ลดอาการมอนสั่นและกล้องแกว่ง
    -- ============================================================
    getgenv().BringMonster = getgenv().BringMonster or false
    PosMon = PosMon or nil
    Mon = Mon or nil
    getgenv()._StableBringCF = getgenv()._StableBringCF or nil

    BringEnemy = function()
        pcall(function()
            if not Config.BringMobs or not getgenv().BringMonster then return end
            if not PosMon then return end

            local _char = LocalPlayer.Character
            if not _char then return end
            local _root = _char:FindFirstChild("HumanoidRootPart")
            if not _root then return end

            local rawTargetCF = typeof(PosMon) == "CFrame" and PosMon or CFrame.new(PosMon)

            -- ใช้จุดยึดเดิมค้างไว้ ไม่ให้จุดมอนขยับตาม PosMon ทุกเฟรม
            local stableCF = getgenv()._StableBringCF
            if not stableCF or (stableCF.Position - rawTargetCF.Position).Magnitude > 5 then
                stableCF = CFrame.new(rawTargetCF.Position)
                getgenv()._StableBringCF = stableCF
            end

            -- 3 ช่องคงที่รอบจุดตี: ซ้าย / ขวา / ด้านหน้า
            local slots = {
                stableCF * CFrame.new(-5, 3, 0),
                stableCF * CFrame.new(5, 3, 0),
                stableCF * CFrame.new(0, 3, 6)
            }

            local maxPull = 3
            local bringRange = 300
            local targetName = (Mon and Mon ~= "") and Mon or nil

            local function LockMob(v, hrp, hum, slotCF)
                if not v.Parent or hum.Health <= 0 then return end

                -- ล็อกเฉพาะ RootPart; ไม่ย้าย Head แยก เพราะ Motor6D จะตีกันและทำให้สั่น
                local fixedCF = CFrame.new(slotCF.Position)
                hrp.CFrame = fixedCF
                hrp.CanCollide = false

                local head = v:FindFirstChild("Head")
                if head then
                    head.CanCollide = false
                end

                hum.WalkSpeed = 0
                hum.JumpPower = 0
                hum.AutoRotate = false

                -- ใช้ BodyVelocity เป็นตัวคุมตำแหน่ง แต่ไม่บังคับความเร็วเกินจำเป็น
                local bv = hrp:FindFirstChild("_Lock")
                if not bv then
                    bv = Instance.new("BodyVelocity")
                    bv.Name = "_Lock"
                    bv.Parent = hrp
                end
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.Velocity = Vector3.zero

                pcall(function()
                    sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                end)

                pcall(function()
                    hum:ChangeState(11)
                end)
            end

            local enemyFolder = workspace:FindFirstChild("Enemies")
            if not enemyFolder then return end

            local candidates = {}
            for _, v in ipairs(enemyFolder:GetChildren()) do
                if targetName and v.Name ~= targetName then
                    continue
                end

                local hrp = v:FindFirstChild("HumanoidRootPart")
                local hum = v:FindFirstChild("Humanoid")

                if hrp and hum and hum.Health > 0 then
                    if (hrp.Position - _root.Position).Magnitude <= bringRange then
                        table.insert(candidates, v)
                    end
                end
            end

            table.sort(candidates, function(a, b)
                local ar = a:FindFirstChild("HumanoidRootPart")
                local br = b:FindFirstChild("HumanoidRootPart")
                if not ar or not br then return false end
                return (ar.Position - _root.Position).Magnitude <
                       (br.Position - _root.Position).Magnitude
            end)

            for i = 1, math.min(maxPull, #candidates) do
                local v = candidates[i]
                local hrp = v:FindFirstChild("HumanoidRootPart")
                local hum = v:FindFirstChild("Humanoid")

                if hrp and hum and hum.Health > 0 then
                    LockMob(v, hrp, hum, slots[i])
                end
            end
        end)
    end

    task.spawn(function()
        while task.wait(0.08) do
            BringEnemy()
        end
    end)


    LastFound = os.time()
    function CombatController.Grab(mobName)
        pcall(sethiddenproperty, game.Players.LocalPlayer, 'SimulationRadius', math.huge)
        if not CombatController.GRAB or GrabDebounce == os.time() then return end
        GrabDebounce = os.time()
        if not MonResult or not MonResult:FindFirstChild('HumanoidRootPart') then return end
        local targetPos = MonResult.HumanoidRootPart.Position
        local AreaMob = false
        for _, enemy in Services.Workspace.Enemies:GetChildren() do
            if enemy ~= MonResult and enemy.Name == mobName then
                local hum = enemy:FindFirstChildOfClass("Humanoid")
                local root = enemy:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.Health > 0 then
                    local dist = (root.Position - targetPos).Magnitude
                    if dist <= 3000 then
                        local bv = root:FindFirstChild('FarmingVelocity')
                        if not bv then
                            bv = Instance.new('BodyVelocity')
                            bv.Name = 'FarmingVelocity'
                            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                            bv.Velocity = Vector3.zero
                            bv.Parent = root
                        end
                        if dist <= 10 then
                            AreaMob = true
                        end
                        if not AreaMob and (not isnetworkowner or pcall(isnetworkowner, root)) then
                            root.CFrame = MonResult.HumanoidRootPart.CFrame
                        end
                        enemy:SetAttribute('IsGrabbed', true)
                    end
                end
            end
        end
    end
    function Sort1(entity) return entity and entity:FindFirstChild("HumanoidRootPart") and math.floor(CaculateDistance(entity.HumanoidRootPart.CFrame)) end
    function CombatController.Search(names)
        local candidates = {}
        local anyFound = false
        for _, entity in GetMonAsSortedRange() do
            if table.find(names, entity.Name) and entity:FindFirstChild("Humanoid") and entity.Humanoid.Health > 0 then
                if (entity:GetAttribute('FailureCount') or 0) < 3 then
                    anyFound = true
                    table.insert(candidates, entity)
                end
            end
        end
        table.sort(candidates, function(entity, other) return Sort1(entity) < Sort1(other) end)
        if anyFound then
            local best = candidates[1]
            return best
        end
        for _, npcName in names do
            local npc = game.ReplicatedStorage:FindFirstChild(npcName)
            if npc then return npc end
        end
    end
    function CombatController.Attack(h, X, w, D)
        if ScriptStorage.Tools["Sweet Chalice"] and getsenv(game.ReplicatedStorage.GuideModule)["_G"]['InCombat'] then
            pcall(function() if TweenInstance then TweenInstance:Cancel() end end) -- [FIXED] không tween về (0,0,0) khi Sweet Chalice InCombat
            return
        end
        sethiddenproperty(game.Players.LocalPlayer, 'SimulationRadius', math.huge)
        h = type(h) == "string" and {h} or (h or {})
        for y, L in (h) do
            local b = tostring(L)
            if b == 'Deandre' or b == "Urban" or b == "Diablo" and (os.time() - (LastFire12 or 0)) > 180 then
                LastFire12 = os.time()
                Remotes.CommF_:InvokeServer("EliteHunter")
            end
            if X then
                local b = GetMonAsSortedRange()[1]
                local C = b and b:FindFirstChild('HumanoidRootPart') and b.HumanoidRootPart.Position
                if C and CaculateDistance(C) < w then MonResult = b end
            else
                MonResult = CombatController.Search(h)
            end
            if MonResult then
                LastFound = os.time()
                local h, w = 0, os.time()
                SetTask('SubTask', '⚔️ Attacking ' .. tostring(MonResult.Name))
                local w, b = 0, os.time()
                while task.wait() do
                    if _G.Stop then return end
                    if ScriptStorage.Tools["Sweet Chalice"] and getsenv(game.ReplicatedStorage.GuideModule)["_G"]["InCombat"] then
                        pcall(function() if TweenInstance then TweenInstance:Cancel() end end) -- [FIXED] không tween về (0,0,0) khi Sweet Chalice InCombat
                        return
                    end
                    local C = MonResult:FindFirstChild('Humanoid')
                    local p = MonResult:FindFirstChild('HumanoidRootPart')
                    if not C or C.Health <= 0 then
                        if MonResult.Name == "Don Swan" then Storage:Set("SwanDefeated", true) end
                        break
                    end
                    TweenController.Create(CaculateCircreDirection(p.CFrame) + Vector3.new(0, 35, 0))
                    if CaculateDistance(p.Position + Vector3.new(0, 35, 0)) < 150 then
                        y = D and D()
                        CombatController.Grab(L or '')
                        if MonResult.Name ~= "Core" then
                            if ScriptStorage.PlayerData.Level > 100 and w >= CombatController.MAX_ATTACK_DURATION_2 and C.Health - C.MaxHealth == 0 then
                                SetTask('SubTask', 'Hop Server - Mob Health Unchanged ( ' .. C.Health .. ' / ' .. C.MaxHealth .. ')')
                                alert("stuck", "Mob health unchanged")
                                _G.Stop = true
                                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
                            end
                            if h >= CombatController.MAX_ATTACK_DURATION and C.Health - C.MaxHealth == 0 then
                                h = 0
                                local D = MonResult:GetAttribute('OldPosition')
                                if D then
                                    MonResult:SetPrimaryPartCFrame(CFrame.new(D))
                                    MonResult:SetAttribute('IgnoreGrab', true)
                                    MonResult:SetAttribute('FailureCount', (MonResult:GetAttribute("FailureCount") or 0) + 1)
                                    alert('Failed to attack', "Returning to the old posiiton ( #" .. MonResult:GetAttribute("FailureCount") .. " )")
                                    MonResult.HumanoidRootPart.CFrame = (CFrame.new(D))
                                    task.wait()
                                    return
                                end
                            end
                        end
                        if (FarmFruitMastery or math.huge) - os.time() < 3 and math.floor(MonResult.Humanoid.Health / MonResult.Humanoid.MaxHealth * 100) < 30 and not FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
                            TweenController.Create((p.CFrame) + Vector3.new(0, 25, 0))
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Blox Fruit')
                            LockAimPositionTo(MonResult.HumanoidRootPart.CFrame.p)
                            local D = {'Z', 'X', "C", 'V'}
                            local y = D[math.random(1, #D)]
                            SendKey(y, .31)
                        else
                            -- [FIXED] Ưu tiên dùng _G.SelectWeapon nếu có
                            if _G.SelectWeapon and CheckItem(_G.SelectWeapon) then
                                FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(_G.SelectWeapon)
                            else
                                FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(ScriptStorage.ForceToUseSword and 'Sword' or "Melee")
                            end
                        end
                        W:Attack(MonResult)
                        if os.time() ~= b then
                            b = os.time()
                            h = h + 1
                            w = w + 1
                        end
                        if h > 30 and MonResult.Name ~= "Core" then
                            alert("Take more than 30s to attack, canceling")
                            break
                        end
                    end
                end
            elseif not X then
                if (os.time() - LastFound) > 200 then
                    alert('MeyyHub', 'Error while farming, rejoin')
                    game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
                    return
                end
                local h = ScriptStorage.MobRegions[L]
                if not h then
                    local X = Services.Workspace.Enemies:FindFirstChild(L) or game.ReplicatedStorage:FindFirstChild(L)
                    h = X and {X:GetPrimaryPartCFrame().p}
                end
                if not h then
                    Report('[ Game data error ] Mob with name ' .. tostring(L) .. ' have no spawn region datas')
                    return
                end
                local X
                if not h[CombatController.CurrentIndex] then CombatController.CurrentIndex = 1 end
                X = h[CombatController.CurrentIndex]
                local h = os.time()
                TweenController.Create(X + Vector3.new(0, 35, 35))
                if CaculateDistance(X + Vector3.new(0, 35, 35)) < 15 then CombatController.CurrentIndex = CombatController.CurrentIndex + 1 end
            end
        end
    end
    LevelFarmTTL = 0
    LastTravel = os.time()
    FunctionsHandler = {Initalized = false}
    print(3000)
    setmetatable(FunctionsHandler, {__index = function(h, X)
        QueryResult = rawget(h, X)
        if not QueryResult then
            return {
                Register = function(w)
                    if w == false then return end
                    Result = {CacheListener = {}, RealCache = {}, Methods = {}, Constants = {}, Events = {}, Initalized = true}
                    function Result.RegisterMethod(w, D, y)
                        w.Methods[D] = {Name = D, Callback = y, Call = function(w, ...) return w.Callback(...) end, Events = {}}
                        return true
                    end
                    setmetatable(Result.Constants, {__newindex = function() assert(false, 'cannot change constant value!') end})
                    if h.Constants[Key] then
                        function Result.SaveConstant(w, w, w) return assert(false, 'constant name was used before!') end
                        rawset(h.Constants, Key, Value)
                    end
                    function Result.Set(h, w, D)
                        h.CacheListener[w] = D
                        return D
                    end
                    function Result.Get(h, w) return h.Constants[w] or h.RealCache[w] end
                    function Result.AddVariableChangeListener(h, w, D) h.Events[w] = D end
                    Result.CacheListener.__parent = Result
                    setmetatable(Result.CacheListener, {__newindex = function(h, w, D)
                        _ = h.__parent.Events[w] and h.__parent.Events[w](w, D)
                        h.__parent.RealCache[w] = D
                    end})
                    FunctionsHandler[X] = Result
                end, Initalized = false
            }
        end
        return QueryResult
    end})
    function FunctionsHandler.SynchorizeUntilModuleLoaded(h, X)
        local w = os.time()
        while not h.Initalized do
            task.wait()
            local h = os.time() - w
            assert(not (X and h > X), "timed out")
        end
    end
    function GetCurrentClaimQuest(h)
        local h = game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:gsub("%s*Defeat%s*(%d*)%s*(.-)%s*%b()", "%2")
        return (type(h) == "string" and string.gsub(h, "Military ", "Mil. ") or h), game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
    end
    FunctionsHandler.LocalPlayerController.Register()
    FunctionsHandler.ExpRedeem:Register()
    FunctionsHandler.LevelFarm:Register()
    FunctionsHandler.Saber:Register()
    FunctionsHandler.Rengoku:Register()
    FunctionsHandler.Yama:Register()
    FunctionsHandler.Tushita:Register()
    FunctionsHandler.SpikeyTrident:Register()
    FunctionsHandler.SharkAchor:Register()
    FunctionsHandler.Pole:Register()
    FunctionsHandler.FoxLamp:Register()
    FunctionsHandler.DarkDagger:Register()
    FunctionsHandler.Canvander:Register()
    FunctionsHandler.BuddySword:Register()
    FunctionsHandler.HallowScythe:Register()
    FunctionsHandler.CursedDualKatana:Register()
    FunctionsHandler.AcidumRifle:Register()
    FunctionsHandler.Kabucha:Register()
    FunctionsHandler.VenomBow:Register()
    FunctionsHandler.SoulGuitar:Register()
    FunctionsHandler.DragonStorm:Register()
    FunctionsHandler.InsictV2:Register()
    FunctionsHandler.RainbowSaviour:Register()
    FunctionsHandler.DarkBladeV2:Register()
    FunctionsHandler.SecondSeaPuzzle:Register()
    FunctionsHandler.ColosseumPuzzle:Register()
    FunctionsHandler.Trevor:Register()
    FunctionsHandler.EvoRace:Register()
    FunctionsHandler.Wenlocktoad:Register()
    FunctionsHandler.DarkBladeV3:Register()
    FunctionsHandler.ThirdSeaPuzzle:Register()
    FunctionsHandler.DojoQuest:Register()
    FunctionsHandler.RaceAwakening:Register()
    FunctionsHandler.PirateRaid:Register()
    FunctionsHandler.SwordBossTask:Register()
    FunctionsHandler.CakePrinceTask:Register()
    FunctionsHandler.RaidController:Register()
    FunctionsHandler.AutoRaidIce:Register()
    FunctionsHandler.MeleesController:Register()
    FunctionsHandler.Superhuman:Register()
    FunctionsHandler.DeathStep:Register()
    FunctionsHandler.SharkmanKarate:Register()
    FunctionsHandler.ElectricClaw:Register()
    FunctionsHandler.DragonTalon:Register()
    FunctionsHandler.Godhuman:Register()
    FunctionsHandler.BossesTask:Register()
    FunctionsHandler.SpecialBossesTask:Register()
    FunctionsHandler.CollectDrops:Register()
    FunctionsHandler.CollectBerries:Register()
    FunctionsHandler.UtillyItemsActivitation:Register()

    -- ============================================================
    -- AUTO FULL MELEE - TƯƠNG THÍCH VỚI LEVEL FARM
    -- ============================================================
    -- [NEW] V1 → V2 pairing — dùng để biết trái nào đang farm mastery là
    -- V1 của võ nào, và tên teacher/style tương ứng theo MeleePrices
    local V1ToV2 = {
        ["Black Leg"]      = "Death Step",       -- "Dark Step" (tên Teacher)
        ["Electro"]        = "Electric Claw",
        ["Fishman Karate"] = "Sharkman Karate",   -- "Water Kung Fu"
        ["Dragon Claw"]    = "Dragon Talon",
    }

    FunctionsHandler.MeleesController:RegisterMethod("Refresh", function()
        if not Config.Items.AutoFullyMelees or not Config.Melee.AutoBuy then return nil end
        if ScriptStorage.PlayerData.Level < 200 then return nil end
        -- [FIXED] Bỏ "if _G.Level then return nil end" — đây là khóa VĨNH VIỄN,
        -- một khi thiếu tiền 1 lần là MeleesController tắt luôn mãi mãi vì
        -- không có chỗ nào khác set lại _G.Level = false. Bỏ hẳn cờ này,
        -- để Refresh tự nhiên re-check mỗi vòng — rẻ, an toàn, tự phục hồi.

        local allMelees = {"Black Leg", "Electro", "Fishman Karate", "Dragon Claw", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman"}
        local hasAll = true
        for _, name in ipairs(allMelees) do
            if not CheckItem(name) then
                hasAll = false
                break
            end
        end
        if hasAll then
            SetTask('MainTask', 'Auto Full Melee | ✅ Đã có tất cả!')
            return nil
        end
        return true
    end)

    FunctionsHandler.MeleesController:RegisterMethod("Start", function()
        if not Config.Items.AutoFullyMelees or not Config.Melee.AutoBuy then return end
        if ScriptStorage.PlayerData.Level < 200 then return end

        local meleeList = {
            -- [FIXED - LỖI NỀN TẢNG] Trước đây key = "BuyBlackLeg" v.v. —
            -- nhưng BuyMelee() TỰ thêm "Buy" ở trong ('Buy' .. W), nên gọi
            -- ra remote "BuyBuyBlackLeg" — KHÔNG TỒN TẠI, mua không bao giờ
            -- thành công. Đồng thời special-case DragonClaw/Godhuman trong
            -- BuyMelee so sánh W=="DragonClaw"/"Godhuman" (không "Buy...")
            -- nên trước đây KHÔNG BAO GIỜ khớp, luôn rơi vào nhánh generic
            -- sai. Bỏ hẳn tiền tố "Buy" khỏi key — để BuyMelee tự thêm.
            {name = "Black Leg", key = "BlackLeg", price = {Beli = 150000}, levelReq = 300},
            {name = "Electro", key = "Electro", price = {Beli = 500000}, levelReq = 300},
            {name = "Fishman Karate", key = "FishmanKarate", price = {Beli = 750000}, levelReq = 300},
            {name = "Dragon Claw", key = "DragonClaw", price = {Fragments = 1500}, levelReq = 300},
            {name = "Superhuman", key = "Superhuman", price = {Beli = 3000000}, levelReq = nil, needMastery = {item = "Dragon Claw", value = 300}},
            {name = "Death Step", key = "DeathStep", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400, needKey = "Library Key"},
            {name = "Sharkman Karate", key = "SharkmanKarate", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400, needKey = "Water Key"},
            {name = "Electric Claw", key = "ElectricClaw", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400},
            {name = "Dragon Talon", key = "DragonTalon", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400, needFireEssence = true},
            {name = "Godhuman", key = "Godhuman", price = {Beli = 5000000, Fragments = 5000}, levelReq = 400, needMaterials = true},
        }

        -- [NEW] Cổng kiểm tra "mọi thứ đủ điều kiện chưa" — boss man yêu
        -- cầu: chỉ khi TẤT CẢ 9 melee (V1+V2, gồm cả Superhuman — spec mới
        -- yêu cầu Superhuman cũng phải đạt 500 trước Godhuman, KHÁC với
        -- thiết kế cũ của tao lúc trước loại trừ nó, đã sửa lại) đã MUA
        -- XONG và ĐẠT mastery mục tiêu (V1=500, V2=400) thì mới bắt đầu
        -- farm vật liệu/F/Beli cho Godhuman.
        local MASTERY_GATE_MELEES = {
            {name = "Black Leg",       target = Config.Melee.RaidAtV1Mastery},
            {name = "Electro",         target = Config.Melee.RaidAtV1Mastery},
            {name = "Fishman Karate",  target = Config.Melee.RaidAtV1Mastery},
            {name = "Dragon Claw",     target = Config.Melee.RaidAtV1Mastery},
            {name = "Superhuman",      target = Config.Melee.RaidAtV1Mastery},
            {name = "Death Step",      target = Config.Melee.GodhumanAtV2Mastery},
            {name = "Sharkman Karate", target = Config.Melee.GodhumanAtV2Mastery},
            {name = "Electric Claw",   target = Config.Melee.GodhumanAtV2Mastery},
            {name = "Dragon Talon",    target = Config.Melee.GodhumanAtV2Mastery},
        }

        local function AllMeleesReady()
            for _, m in ipairs(MASTERY_GATE_MELEES) do
                if not CheckItem(m.name) then return false, m.name .. " (chưa mua)" end
                local mst = ScriptStorage.Melees[m.name] or 0
                if mst < m.target then return false, m.name .. " (" .. mst .. "/" .. m.target .. ")" end
            end
            return true
        end


        -- Sea nào không có tên trong bảng = thầy đó không đứng ở Sea đó,
        -- phải qua Sea khác (Sea 3 có đủ cả 8 thầy nên dùng làm fallback)
        local TeacherLocations = {
            ["Water Kung-fu Teacher"] = {
                [1] = CFrame.new(61586.96, 19.58, 987.59),
                [2] = CFrame.new(-4957.68, 35.94, -4665.6),
                [3] = CFrame.new(-5023.91, 371.02, -3191.46),
            },
            ["Mad Scientist"] = {
                [1] = CFrame.new(-5382.79, 12.55, -2148.82),
                [2] = CFrame.new(-4866.16, 33.92, -4767.11),
                [3] = CFrame.new(-4996.06, 313.21, -3201.83),
            },
            ["Dark Step Teacher"] = {
                [1] = CFrame.new(-983.62, 12.44, 3990.46),
                [2] = CFrame.new(-4752.44, 33.92, -4848.04),
                [3] = CFrame.new(-5045.61, 370.01, -3182.31),
            },
            ["Phoeyu, the Reformed"] = {
                [2] = CFrame.new(6356.47, 296.1, -6762.78),
                [3] = CFrame.new(-4999.24, 314.01, -3221.58),
            },
            ["Sharkman Teacher"] = {
                [2] = CFrame.new(-2599.63, 238.19, -10316),
                [3] = CFrame.new(-4971.21, 313.88, -3223.08),
            },
            ["Previous Hero"] = {
                [3] = CFrame.new(-10371.48, 330.76, -10131.42),
            },
            ["Uzoth"] = {
                [3] = CFrame.new(5661.89, 1210.87, 863.17),
            },
            ["Ancient Monk"] = {
                [3] = CFrame.new(-13774.1, 333.73, -9879.91),
            },
        }
        -- [NEW] Melee nào → thầy nào (khớp với tên trong MeleePrices.Buy)
        -- Dragon Claw ("Sabi") và Superhuman ("Martial Arts Master") KHÔNG
        -- có trong data boss man cho — để trống, không bịa toạ độ
        local MeleeTeacher = {
            ["Fishman Karate"]   = "Water Kung-fu Teacher",
            ["Electro"]          = "Mad Scientist",
            ["Black Leg"]        = "Dark Step Teacher",
            ["Death Step"]       = "Phoeyu, the Reformed",
            ["Sharkman Karate"]  = "Sharkman Teacher",
            ["Electric Claw"]    = "Previous Hero",
            ["Dragon Talon"]     = "Uzoth",
            ["Godhuman"]         = "Ancient Monk",
        }

        -- [NEW] Tween tới đúng thầy trước khi mua — đây là phần BỊ THIẾU
        -- khiến "mua bị lỗi" (gọi remote mua nhưng nhân vật không đứng gần
        -- NPC nên server từ chối). Sea hiện tại có thầy → dùng luôn; không
        -- có → qua Sea 3 (thầy nào cũng có mặt ở đó).
        local function GoToTeacher(meleeName)
            local teacher = MeleeTeacher[meleeName]
            if not teacher then return true end -- không có data vị trí, bỏ qua bước này
            local locs = TeacherLocations[teacher]
            if not locs then return true end

            local cf = locs[SeaIndex]
            if not cf then
                if SeaIndex ~= 3 then
                    Remotes.CommF_:InvokeServer("TravelZou")
                    return false
                end
                return true -- đang ở Sea 3 mà bảng thiếu toạ độ Sea 3 (không nên xảy ra)
            end

            if CaculateDistance(cf) > 10 then
                TweenController.Create(cf)
                return false
            end
            return true
        end

        for _, melee in ipairs(meleeList) do
            if _G.Stop then return end

            local bp = CheckItem(melee.name)
            if not bp then
                -- [NEW] Dragon Claw V1 cần riêng 1500 Fragments — nếu chưa
                -- đủ thì đây chính là lý do phải farm raid (raid cho
                -- Fragments), không phải lỗi gì khác
                if melee.name == "Dragon Claw" and (ScriptStorage.PlayerData.Fragments or 0) < 1500 then
                    SetTask('MainTask', 'Auto Full Melee | Dragon Claw cần 1500 Fragments — đang farm Raid (' .. (ScriptStorage.PlayerData.Fragments or 0) .. '/1500)')
                    return
                end

                local canBuy = true
                for currency, amount in pairs(melee.price) do
                    local have = (currency == "Beli" and ScriptStorage.PlayerData.Beli) or
                                 (currency == "Fragments" and ScriptStorage.PlayerData.Fragments) or 0
                    if have < amount then canBuy = false end
                end
                -- [FIXED] needKey/needFireEssence/needMaterials trước đây
                -- nằm ở nhánh "ĐÃ SỞ HỮU" (else bên dưới) — vô nghĩa, vì đây
                -- là điều kiện TIÊN QUYẾT phải có TRƯỚC khi mua, không phải
                -- thứ cần check sau khi đã mua xong. Chuyển về đúng chỗ.

                if melee.needKey and not CheckItem(melee.needKey) then
                    SetTask('MainTask', 'Auto Full Melee | Lấy ' .. melee.needKey .. ' cho ' .. melee.name)
                    if melee.needKey == "Library Key" then
                        local admiral = GetConnectionEnemies("Awakened Ice Admiral")
                        if admiral then
                            -- [FIXED - giảm delay] Attack() đã tự block chờ
                            -- hạ xong rồi, wait(2) sau đó là dư thừa
                            CombatController.Attack("Awakened Ice Admiral")
                        else
                            TweenController.Create(CFrame.new(5668.978, 28.52, -6483.352))
                        end
                    elseif melee.needKey == "Water Key" then
                        local tide = GetConnectionEnemies("Tide Keeper")
                        if tide then
                            CombatController.Attack("Tide Keeper")
                        else
                            TweenController.Create(CFrame.new(-3053.981, 237.19, -10145.039))
                        end
                    end
                    return
                end

                -- [NEW] Điều kiện tiên quyết mastery — verified từ raw_6:
                -- Superhuman cần Dragon Claw đạt 300 mastery trước khi mua
                if melee.needMastery then
                    local preMastery = ScriptStorage.Melees[melee.needMastery.item] or 0
                    if not CheckItem(melee.needMastery.item) or preMastery < melee.needMastery.value then
                        SetTask('MainTask', 'Auto Full Melee | Cần ' .. melee.needMastery.item .. ' đạt ' .. melee.needMastery.value .. ' mastery trước (hiện ' .. preMastery .. ') để mua ' .. melee.name)
                        return
                    end
                end

                if melee.needFireEssence then
                    local hasFireEssence = CheckItem("Fire Essence")

                    if hasFireEssence then
                        -- [FIXED] Verified từ raw_6: equip Fire Essence rồi gọi
                        -- BuyDragonTalon HAI LẦN (true, rồi không tham số) —
                        -- trước đây tao chỉ farm bones, chưa từng thật sự dùng
                        -- Fire Essence để mua Dragon Talon.
                        SetTask('MainTask', 'Auto Full Melee | Dùng Fire Essence mua Dragon Talon')
                        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Fire Essence")
                        task.wait(0.5)
                        Remotes.CommF_:InvokeServer("BuyDragonTalon", true)
                        Remotes.CommF_:InvokeServer("BuyDragonTalon")
                        return
                    end

                    if not CheckItem(melee.name) then
                        -- [FIXED] Ngưỡng thật 500 Bones (giống CDK), burst-buy
                        -- tới khi hết, không nhỏ giọt buy(1,1) từng lần
                        local bonesCount = Remotes.CommF_:InvokeServer("Bones", "Check")
                        if bonesCount and bonesCount > 500 then
                            SetTask('MainTask', 'Auto Full Melee | Đổi Bones lấy Fire Essence (' .. bonesCount .. ')')
                            repeat
                                Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                                task.wait(0.2)
                                bonesCount = Remotes.CommF_:InvokeServer("Bones", "Check")
                            until not bonesCount or bonesCount <= 0
                            return
                        end
                        if not ScriptStorage.Enemies["Reborn Skeleton"] and not ScriptStorage.Enemies["Living Zombie"]
                            and not ScriptStorage.Enemies["Demonic Soul"] and not ScriptStorage.Enemies["Posessed Mummy"] then
                            -- [NEW] Chưa thấy quái gần đây → di chuyển tới đúng
                            -- điểm farm Haunted Castle thay vì đứng im chờ
                            SetTask('MainTask', 'Auto Full Melee | Di chuyển tới Haunted Castle farm Bones (' .. (bonesCount or 0) .. '/500)')
                            TweenController.Create(HAUNTED_CASTLE_BONES_CF)
                            return
                        end
                        SetTask('MainTask', 'Auto Full Melee | Farm Bones cho Fire Essence (' .. (bonesCount or 0) .. '/500)')
                        CombatController.Attack({'Reborn Skeleton', 'Living Zombie', 'Demonic Soul', 'Posessed Mummy'})
                        return
                    end
                end

                if melee.needMaterials then
                    -- [NEW] Cổng "mọi thứ đủ điều kiện chưa" — CHỈ farm vật
                    -- liệu Godhuman khi cả 8 melee kia đã mua + đủ mastery
                    local ready, reason = AllMeleesReady()
                    if not ready then
                        SetTask('MainTask', 'Auto Full Melee | Godhuman: chưa đủ điều kiện — ' .. (reason or "?"))
                        return
                    end

                    local materials = {
                        {name = "Dragon Scale", need = 10, sea = 3, mobs = {"Dragon Crew Warrior", "Dragon Crew Archer"}},
                        {name = "Fish Tail", need = 20, sea = 3, mobs = {"Fishman Raider", "Fishman Captain"}},
                        {name = "Mystic Droplet", need = 10, sea = 2, mobs = {"Sea Soldier", "Water Fighter"}},
                        {name = "Magma Ore", need = 20, sea = 2, mobs = {"Magma Ninja"}},
                    }
                    for _, mat in ipairs(materials) do
                        local count = ScriptStorage.Backpack[mat.name] and ScriptStorage.Backpack[mat.name].Count or 0
                        if count < mat.need then
                            if SeaIndex ~= mat.sea then
                                Remotes.CommF_:InvokeServer(mat.sea == 2 and "TravelDressrosa" or "TravelZou")
                                return
                            end
                            SetTask('MainTask', 'Auto Full Melee | Godhuman: farm ' .. mat.name .. ' (' .. count .. '/' .. mat.need .. ')')
                            CombatController.Attack(mat.mobs)
                            return
                        end
                    end
                    -- Đủ vật liệu rồi → rơi xuống check tiền/Fragments bên dưới để mua
                end

                if canBuy then
                    -- [FIXED - LỖI SÂU] GoToTeacher() của tao tự tween thủ
                    -- công là ĐÚNG (dùng toạ độ verified, phủ đủ cả
                    -- DragonClaw/Superhuman mà bảng gốc BindedMeleeNPCNames
                    -- KHÔNG có) — giữ nguyên bước này.
                    -- NHƯNG cách gọi remote SAI: trước giờ chỉ gọi
                    -- BuyMelee(key, true) — đây là proxy CHECK (2nd arg=true
                    -- khiến auto-navigate của proxy gốc dòng ~427 bị skip vì
                    -- nó yêu cầu "not h"), KHÔNG PHẢI lệnh mua thật. Phải gọi
                    -- THÊM lần 2 KHÔNG kèm true để proxy thật sự chạy nhánh
                    -- mua (dòng 446 luôn invoke thật, nhưng cần đủ 2 bước để
                    -- J ghi nhận hợp lệ trước khi bước 2 chạy).
                    if not GoToTeacher(melee.name) then
                        SetTask('MainTask', 'Auto Full Melee | Di chuyển tới ' .. (MeleeTeacher[melee.name] or "?") .. ' để mua ' .. melee.name)
                        return
                    end
                    SetTask('MainTask', 'Auto Full Melee | Mua ' .. melee.name)
                    local checkResult = BuyMelee(melee.key, true)  -- Bước 1: check (proxy ghi vào J nếu hợp lệ)
                    task.wait(0.3)
                    BuyMelee(melee.key)                            -- Bước 2: mua thật (kích hoạt proxy auto-navigate + invoke thật)
                    task.wait(0.5)
                    if CheckItem(melee.name) then
                        SetTask('MainTask', 'Auto Full Melee | ✅ Mua thành công ' .. melee.name)
                    else
                        SetTask('SubTask', 'Auto Full Melee | Đã gửi lệnh mua ' .. melee.name .. ' — kiểm tra lại vòng sau')
                    end
                else
                    -- [FIXED] Không còn set _G.Level=true (khóa vĩnh viễn) —
                    -- chỉ báo trạng thái rồi return, Refresh sẽ tự thử lại
                    -- vòng sau khi tiền/Fragments đủ (RaidController vẫn
                    -- chạy song song farm Fragments qua TasksOrder bình thường)
                    -- Đúng yêu cầu boss man: "chạy lại mua tới chừng nào mua được"
                    SetTask('MainTask', 'Auto Full Melee | Cần farm tiền cho ' .. melee.name)
                    return
                end
            else
                -- [FIXED] Mastery đọc từ ScriptStorage.Melees[name] — đây mới
                -- là nguồn thật (xem dòng ~403). "bp.Level.Value" cũ KHÔNG
                -- TỒN TẠI trên tool, khiến toàn bộ check mastery bị bỏ qua
                -- lặng lẽ (bp:FindFirstChild("Level") luôn nil → điều kiện
                -- luôn false) — đây là lý do auto melee tưởng đã "sẵn sàng"
                -- dù mastery còn thấp.
                local mastery = ScriptStorage.Melees[melee.name] or 0

                if melee.levelReq and ScriptStorage.PlayerData.Level < melee.levelReq then
                    SetTask('MainTask', 'Auto Full Melee | Cần Player Level ' .. melee.levelReq .. ' cho ' .. melee.name)
                    return
                end

                -- [NEW] V1 đạt 500 mastery + chưa có V2 tương ứng → ưu tiên
                -- Raid lấy Fragments (yêu cầu boss man: "nếu đc 500 mastery
                -- thì đi raid để có F mua võ v2"). Đạt rồi thì KHÔNG return
                -- cứng — để vòng lặp tiếp tục xử lý các melee còn lại ("kiểm
                -- tra nếu đủ điều kiện mastery thì mua melee khác").
                local v2Name = V1ToV2[melee.name]
                if Config.Melee.CheckMasteryAfterBuy and v2Name and not CheckItem(v2Name) then
                    if mastery < Config.Melee.RaidAtV1Mastery then
                        SetTask('SubTask', melee.name .. ' đang train mastery (' .. mastery .. '/' .. Config.Melee.RaidAtV1Mastery .. ')')
                    else
                        local v2Data = MeleePrices[v2Name]
                        local needFrags = (v2Data and v2Data.Price and v2Data.Price.Fragments) or 5000
                        local needBeli  = (v2Data and v2Data.Price and v2Data.Price.Beli) or 2500000
                        local haveFrags = ScriptStorage.PlayerData.Fragments or 0
                        local haveBeli  = ScriptStorage.PlayerData.Beli or 0
                        if haveFrags < needFrags or haveBeli < needBeli then
                            SetTask('MainTask', string.format(
                                'Auto Full Melee | %s đạt %d mastery — chờ Raid farm Fragments cho %s (F:%d/%d, Beli:%d/%d)',
                                melee.name, mastery, v2Name, haveFrags, needFrags, haveBeli, needBeli
                            ))
                        end
                    end
                end

                -- [NEW] V2 đạt 400 mastery → điều kiện Godhuman coi như đạt
                -- cho MELEE NÀY (còn đủ điều kiện TỔNG THỂ hay chưa thì
                -- AllMeleesReady() ở nhánh needMaterials phía trên quyết định)
                local V2_TO_GODHUMAN = {["Death Step"]=true, ["Sharkman Karate"]=true, ["Electric Claw"]=true, ["Dragon Talon"]=true}
                if Config.Melee.CheckMasteryAfterBuy and V2_TO_GODHUMAN[melee.name] and not CheckItem("Godhuman") then
                    if mastery < Config.Melee.GodhumanAtV2Mastery then
                        SetTask('SubTask', melee.name .. ' đang train mastery (' .. mastery .. '/' .. Config.Melee.GodhumanAtV2Mastery .. ')')
                    end
                end

                SetTask('SubTask', '✅ ' .. melee.name .. ' đã sẵn sàng')
            end
        end

        SetTask('MainTask', 'Auto Full Melee | 🎉 Hoàn thành tất cả!')
    end)

    -- ============================================================
    -- LEVEL FARM - HOÀN CHỈNH
    -- ============================================================
    -- [ADDED - theo yêu cầu boss man: "sửa hệ thống farm lv... từ file
    -- message 10"] QuestController — theo dõi quest bằng REMOTE EVENT thật
    -- (Remotes.QuestUpdate) thay vì GetCurrentClaimQuest() (đọc GUI text
    -- PlayerGui.Main.Quest.Container.QuestTitle.Title.Text). Đọc GUI text
    -- có độ trễ replication thật — bắn StartQuest xong, đọc lại GUI ngay
    -- frame kế có thể vẫn thấy tên quest CŨ, khiến so sánh "CurrentClaim
    -- Quest1 ~= Q.NameMon" sai và gọi AbandonQuest ngay quest vừa nhận.
    -- Remotes.QuestUpdate:OnClientEvent bắn THẲNG từ server mỗi khi quest
    -- state đổi — không polling, không trễ.
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
        QuestController.QuestConnection = Services.ReplicatedStorage.Remotes.QuestUpdate.OnClientEvent:Connect(function(a2, a3)
            if a2 and typeof(a2) == "table" then
                QuestController:Set(a2)
                return
            end
            QuestController:Reset()
        end)
    end)
    -- [FIXED] QuestController.CurrentQuestName là tên QUEST (vd
    -- "BanditQuest1"), KHÁC với GetCurrentClaimQuest() (tên MOB đọc từ GUI
    -- text) — 2 thứ không so sánh chéo được. HasActiveQuest()/GetActive
    -- QuestName() tách riêng, và nếu không kết nối được Remotes.QuestUpdate
    -- thì trả về nil để Start() tự rơi về GetCurrentClaimQuest() (so mob
    -- name như cũ) — không trộn lẫn 2 loại tên.
    function HasActiveQuestEvent()
        return questConnectOk and QuestController.QuestConnection ~= nil
    end
    function GetActiveQuestName()
        if not HasActiveQuestEvent() then return nil end
        if QuestController.CurrentQuest == "" then return false end
        return QuestController.CurrentQuestName
    end

    local function ManualLevelLookup()
        -- [ADDED - theo yêu cầu boss man] Bảng farm-lv THỦ CÔNG, KHÔNG phụ
        -- thuộc J.RefreshQuest/require(Quests) (chuỗi đang gãy — J.RefreshQuest
        -- match ScriptStorage.PlayerData.Level với LevelReq trong Quests module,
        -- lỡ không khớp thì "h" ở đó ra nil rồi crash ngay dòng kế — đúng kiểu
        -- "request data lv" mà farm theo không chạy nữa). Bảng này CHỈ đọc
        -- ScriptStorage.PlayerData.Level (property thường, không qua request/
        -- module-matching gì cả) rồi tra thẳng mob+CFrame, y hệt cách vantablack/
        -- Maru Premium làm — dữ liệu lấy nguyên từ file tham chiếu thật đã verify
        -- (toạ độ CFrame chính xác từng đảo, không đoán).
        local MyLevel = ScriptStorage.PlayerData.Level or 0
        local Mon, Qdata, Qname, NameMon = "", 0, "", ""
        local PosQ, PosM = nil, nil

        if SeaIndex == 1 then
            if MyLevel >= 1 and MyLevel <= 9 then
                Mon = "Bandit"; Qdata = 1; Qname = "BanditQuest1"; NameMon = "Bandit"
                PosQ = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, 0, -0.341998369, 0, 1, 0, 0.341998369, 0, 0.939700544)
                PosM = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)
            elseif MyLevel >= 10 and MyLevel <= 14 then
                Mon = "Monkey"; Qdata = 1; Qname = "JungleQuest"; NameMon = "Monkey"
                PosQ = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, 0, -1, 0, 0)
                PosM = CFrame.new(-1448.51806640625, 67.85301208496094, 11.46579647064209)
            elseif MyLevel >= 15 and MyLevel <= 29 then
                Mon = "Gorilla"; Qdata = 2; Qname = "JungleQuest"; NameMon = "Gorilla"
                PosQ = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, 0, -1, 0, 0)
                PosM = CFrame.new(-1129.8836669921875, 40.46354675296875, -525.4237060546875)
            elseif MyLevel >= 30 and MyLevel <= 39 then
                Mon = "Pirate"; Qdata = 1; Qname = "BuggyQuest1"; NameMon = "Pirate"
                PosQ = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, 0.965929627)
                PosM = CFrame.new(-1103.513427734375, 13.752052307128906, 3896.091064453125)
            elseif MyLevel >= 40 and MyLevel <= 59 then
                Mon = "Brute"; Qdata = 2; Qname = "BuggyQuest1"; NameMon = "Brute"
                PosQ = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, 0.965929627)
                PosM = CFrame.new(-1140.083740234375, 14.809885025024414, 4322.92138671875)
            elseif MyLevel >= 60 and MyLevel <= 74 then
                Mon = "Desert Bandit"; Qdata = 1; Qname = "DesertQuest"; NameMon = "Desert Bandit"
                PosQ = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, 0, -0.573571265, 0, 1, 0, 0.573571265, 0, 0.819155693)
                PosM = CFrame.new(924.7998046875, 6.44867467880249, 4481.5859375)
            elseif MyLevel >= 75 and MyLevel <= 89 then
                Mon = "Desert Officer"; Qdata = 2; Qname = "DesertQuest"; NameMon = "Desert Officer"
                PosQ = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, 0, -0.573571265, 0, 1, 0, 0.573571265, 0, 0.819155693)
                PosM = CFrame.new(1608.2822265625, 8.614224433898926, 4371.00732421875)
            elseif MyLevel >= 90 and MyLevel <= 99 then
                Mon = "Snow Bandit"; Qdata = 1; Qname = "SnowQuest"; NameMon = "Snow Bandit"
                PosQ = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
                PosM = CFrame.new(1354.347900390625, 87.27277374267578, -1393.946533203125)
            elseif MyLevel >= 100 and MyLevel <= 119 then
                Mon = "Snowman"; Qdata = 2; Qname = "SnowQuest"; NameMon = "Snowman"
                PosQ = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
                PosM = CFrame.new(1201.6412353515625, 144.57958984375, -1550.0670166015625)
            elseif MyLevel >= 120 and MyLevel <= 149 then
                Mon = "Chief Petty Officer"; Qdata = 1; Qname = "MarineQuest2"; NameMon = "Chief Petty Officer"
                PosQ = CFrame.new(-5039.58643, 27.3500385, 4324.68018, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-4881.23095703125, 22.65204429626465, 4273.75244140625)
            elseif MyLevel >= 150 and MyLevel <= 174 then
                Mon = "Sky Bandit"; Qdata = 1; Qname = "SkyQuest"; NameMon = "Sky Bandit"
                PosQ = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
                PosM = CFrame.new(-4953.20703125, 295.74420166015625, -2899.22900390625)
            elseif MyLevel >= 175 and MyLevel <= 189 then
                Mon = "Dark Master"; Qdata = 2; Qname = "SkyQuest"; NameMon = "Dark Master"
                PosQ = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
                PosM = CFrame.new(-5259.8447265625, 391.3976745605469, -2229.035400390625)
            elseif MyLevel >= 190 and MyLevel <= 209 then
                Mon = "Prisoner"; Qdata = 1; Qname = "PrisonerQuest"; NameMon = "Prisoner"
                PosQ = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, 0, -0.995993316, 0, 1, 0, 0.995993316, 0, -0.0894274712)
                PosM = CFrame.new(5098.9736328125, -0.3204058110713959, 474.2373352050781)
            elseif MyLevel >= 210 and MyLevel <= 249 then
                Mon = "Dangerous Prisoner"; Qdata = 2; Qname = "PrisonerQuest"; NameMon = "Dangerous Prisoner"
                PosQ = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, 0, -0.995993316, 0, 1, 0, 0.995993316, 0, -0.0894274712)
                PosM = CFrame.new(5654.5634765625, 15.633401870727539, 866.2991943359375)
            elseif MyLevel >= 250 and MyLevel <= 274 then
                Mon = "Toga Warrior"; Qdata = 1; Qname = "ColosseumQuest"; NameMon = "Toga Warrior"
                PosQ = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298)
                PosM = CFrame.new(-1820.21484375, 51.68385696411133, -2740.6650390625)
            elseif MyLevel >= 275 and MyLevel <= 299 then
                Mon = "Gladiator"; Qdata = 2; Qname = "ColosseumQuest"; NameMon = "Gladiator"
                PosQ = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298)
                PosM = CFrame.new(-1292.838134765625, 56.380882263183594, -3339.031494140625)
            elseif MyLevel >= 300 and MyLevel <= 324 then
                Mon = "Military Soldier"; Qdata = 1; Qname = "MagmaQuest"; NameMon = "Military Soldier"
                PosQ = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
                PosM = CFrame.new(-5411.16455078125, 11.081554412841797, 8454.29296875)
            elseif MyLevel >= 325 and MyLevel <= 374 then
                Mon = "Military Spy"; Qdata = 2; Qname = "MagmaQuest"; NameMon = "Military Spy"
                PosQ = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
                PosM = CFrame.new(-5802.8681640625, 86.26241302490234, 8828.859375)
            elseif MyLevel >= 375 and MyLevel <= 399 then
                Mon = "Fishman Warrior"; Qdata = 1; Qname = "FishmanQuest"; NameMon = "Fishman Warrior"
                PosQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
                PosM = CFrame.new(60878.30078125, 18.482830047607422, 1543.7574462890625)
            elseif MyLevel >= 400 and MyLevel <= 449 then
                Mon = "Fishman Commando"; Qdata = 2; Qname = "FishmanQuest"; NameMon = "Fishman Commando"
                PosQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
                PosM = CFrame.new(61922.6328125, 18.482830047607422, 1493.934326171875)
            elseif MyLevel >= 450 and MyLevel <= 474 then
                Mon = "God's Guard"; Qdata = 1; Qname = "SkyExp1Quest"; NameMon = "God's Guard"
                PosQ = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, 0, -0.0871884301, 0, 1, 0, 0.0871884301, 0, 0.996191859)
                PosM = CFrame.new(-4710.04296875, 845.2769775390625, -1927.3079833984375)
            elseif MyLevel >= 475 and MyLevel <= 524 then
                Mon = "Shanda"; Qdata = 2; Qname = "SkyExp1Quest"; NameMon = "Shanda"
                PosQ = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, -0.422592998)
                PosM = CFrame.new(-7678.48974609375, 5566.40380859375, -497.2156066894531)
            elseif MyLevel >= 525 and MyLevel <= 549 then
                Mon = "Royal Squad"; Qdata = 1; Qname = "SkyExp2Quest"; NameMon = "Royal Squad"
                PosQ = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-7624.25244140625, 5658.13330078125, -1467.354248046875)
            elseif MyLevel >= 550 and MyLevel <= 624 then
                Mon = "Royal Soldier"; Qdata = 2; Qname = "SkyExp2Quest"; NameMon = "Royal Soldier"
                PosQ = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-7836.75341796875, 5645.6640625, -1790.6236572265625)
            elseif MyLevel >= 625 and MyLevel <= 649 then
                Mon = "Galley Pirate"; Qdata = 1; Qname = "FountainQuest"; NameMon = "Galley Pirate"
                PosQ = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
                PosM = CFrame.new(5551.02197265625, 78.90135192871094, 3930.412841796875)
            elseif MyLevel >= 650 then
                Mon = "Galley Captain"; Qdata = 2; Qname = "FountainQuest"; NameMon = "Galley Captain"
                PosQ = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
                PosM = CFrame.new(5441.95166015625, 42.50205993652344, 4950.09375)
            end
        elseif SeaIndex == 2 then
            if MyLevel >= 700 and MyLevel <= 724 then
                Mon = "Raider"; Qdata = 1; Qname = "Area1Quest"; NameMon = "Raider"
                PosQ = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
                PosM = CFrame.new(-728.3267211914062, 52.779319763183594, 2345.7705078125)
            elseif MyLevel >= 725 and MyLevel <= 774 then
                Mon = "Mercenary"; Qdata = 2; Qname = "Area1Quest"; NameMon = "Mercenary"
                PosQ = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
                PosM = CFrame.new(-1004.3244018554688, 80.15886688232422, 1424.619384765625)
            elseif MyLevel >= 775 and MyLevel <= 799 then
                Mon = "Swan Pirate"; Qdata = 1; Qname = "Area2Quest"; NameMon = "Swan Pirate"
                PosQ = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0, -0.99026376, 0, 0.139203906)
                PosM = CFrame.new(1068.664306640625, 137.61428833007812, 1322.1060791015625)
            elseif MyLevel >= 800 and MyLevel <= 874 then
                Mon = "Factory Staff"; Qdata = 2; Qname = "Area2Quest"; NameMon = "Factory Staff"
                PosQ = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 0, -0.999488771, 0, 1, 0, 0.999488771, 0, -0.0319722369)
                PosM = CFrame.new(73.07867431640625, 81.86344146728516, -27.470672607421875)
            elseif MyLevel >= 875 and MyLevel <= 899 then
                Mon = "Marine Lieutenant"; Qdata = 1; Qname = "MarineQuest3"; NameMon = "Marine Lieutenant"
                PosQ = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
                PosM = CFrame.new(-2821.372314453125, 75.89727783203125, -3070.089111328125)
            elseif MyLevel >= 900 and MyLevel <= 949 then
                Mon = "Marine Captain"; Qdata = 2; Qname = "MarineQuest3"; NameMon = "Marine Captain"
                PosQ = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
                PosM = CFrame.new(-1861.2310791015625, 80.17658233642578, -3254.697509765625)
            elseif MyLevel >= 950 and MyLevel <= 974 then
                Mon = "Zombie"; Qdata = 1; Qname = "ZombieQuest"; NameMon = "Zombie"
                PosQ = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
                PosM = CFrame.new(-5657.77685546875, 78.96973419189453, -928.68701171875)
            elseif MyLevel >= 975 and MyLevel <= 999 then
                Mon = "Vampire"; Qdata = 2; Qname = "ZombieQuest"; NameMon = "Vampire"
                PosQ = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
                PosM = CFrame.new(-6037.66796875, 32.18463897705078, -1340.6597900390625)
            elseif MyLevel >= 1000 and MyLevel <= 1049 then
                Mon = "Snow Trooper"; Qdata = 1; Qname = "SnowMountainQuest"; NameMon = "Snow Trooper"
                PosQ = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
                PosM = CFrame.new(549.1473388671875, 427.3870544433594, -5563.69873046875)
            elseif MyLevel >= 1050 and MyLevel <= 1099 then
                Mon = "Winter Warrior"; Qdata = 2; Qname = "SnowMountainQuest"; NameMon = "Winter Warrior"
                PosQ = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
                PosM = CFrame.new(1142.7451171875, 475.6398010253906, -5199.41650390625)
            elseif MyLevel >= 1100 and MyLevel <= 1124 then
                Mon = "Lab Subordinate"; Qdata = 1; Qname = "IceSideQuest"; NameMon = "Lab Subordinate"
                PosQ = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, 0, -0.891015649, 0, 1, 0, 0.891015649, 0, 0.453972578)
                PosM = CFrame.new(-5707.4716796875, 15.951709747314453, -4513.39208984375)
            elseif MyLevel >= 1125 and MyLevel <= 1174 then
                Mon = "Horned Warrior"; Qdata = 2; Qname = "IceSideQuest"; NameMon = "Horned Warrior"
                PosQ = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, 0, -0.891015649, 0, 1, 0, 0.891015649, 0, 0.453972578)
                PosM = CFrame.new(-6341.36669921875, 15.951770782470703, -5723.162109375)
            elseif MyLevel >= 1175 and MyLevel <= 1199 then
                Mon = "Magma Ninja"; Qdata = 1; Qname = "FireSideQuest"; NameMon = "Magma Ninja"
                PosQ = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
                PosM = CFrame.new(-5449.6728515625, 76.65874481201172, -5808.20068359375)
            elseif MyLevel >= 1200 and MyLevel <= 1249 then
                Mon = "Lava Pirate"; Qdata = 2; Qname = "FireSideQuest"; NameMon = "Lava Pirate"
                PosQ = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
                PosM = CFrame.new(-5213.33154296875, 49.73788070678711, -4701.451171875)
            elseif MyLevel >= 1250 and MyLevel <= 1274 then
                Mon = "Ship Deckhand"; Qdata = 1; Qname = "ShipQuest1"; NameMon = "Ship Deckhand"
                PosQ = CFrame.new(1037.80127, 125.092171, 32911.6016)
                PosM = CFrame.new(1212.0111083984375, 150.79205322265625, 33059.24609375)
            elseif MyLevel >= 1275 and MyLevel <= 1299 then
                Mon = "Ship Engineer"; Qdata = 2; Qname = "ShipQuest1"; NameMon = "Ship Engineer"
                PosQ = CFrame.new(1037.80127, 125.092171, 32911.6016)
                PosM = CFrame.new(919.4786376953125, 43.54401397705078, 32779.96875)
            elseif MyLevel >= 1300 and MyLevel <= 1324 then
                Mon = "Ship Steward"; Qdata = 1; Qname = "ShipQuest2"; NameMon = "Ship Steward"
                PosQ = CFrame.new(968.80957, 125.092171, 33244.125)
                PosM = CFrame.new(919.4385375976562, 129.55599975585938, 33436.03515625)
            elseif MyLevel >= 1325 and MyLevel <= 1349 then
                Mon = "Ship Officer"; Qdata = 2; Qname = "ShipQuest2"; NameMon = "Ship Officer"
                PosQ = CFrame.new(968.80957, 125.092171, 33244.125)
                PosM = CFrame.new(1036.0179443359375, 181.4390411376953, 33315.7265625)
            elseif MyLevel >= 1350 and MyLevel <= 1374 then
                Mon = "Arctic Warrior"; Qdata = 1; Qname = "FrostQuest"; NameMon = "Arctic Warrior"
                PosQ = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
                PosM = CFrame.new(5966.24609375, 62.97002029418945, -6179.3828125)
            elseif MyLevel >= 1375 and MyLevel <= 1424 then
                Mon = "Snow Lurker"; Qdata = 2; Qname = "FrostQuest"; NameMon = "Snow Lurker"
                PosQ = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
                PosM = CFrame.new(5407.07373046875, 69.19437408447266, -6880.88037109375)
            elseif MyLevel >= 1425 and MyLevel <= 1449 then
                Mon = "Sea Soldier"; Qdata = 1; Qname = "ForgottenQuest"; NameMon = "Sea Soldier"
                PosQ = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, 0, -0.13915664, 0, 1, 0, 0.13915664, 0, 0.990270376)
                PosM = CFrame.new(-3028.2236328125, 64.67451477050781, -9775.4267578125)
            elseif MyLevel >= 1450 then
                Mon = "Water Fighter"; Qdata = 2; Qname = "ForgottenQuest"; NameMon = "Water Fighter"
                PosQ = CFrame.new(-3054, 240, -10146)
                PosM = CFrame.new(-3291, 252, -10501)
            end
        elseif SeaIndex == 3 then
            if MyLevel >= 1500 and MyLevel <= 1524 then
                Mon = "Pirate Millionaire"; Qdata = 1; Qname = "PiratePortQuest"; NameMon = "Pirate Millionaire"
                PosQ = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
                PosM = CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375)
            elseif MyLevel >= 1525 and MyLevel <= 1574 then
                Mon = "Pistol Billionaire"; Qdata = 2; Qname = "PiratePortQuest"; NameMon = "Pistol Billionaire"
                PosQ = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
                PosM = CFrame.new(-187.3301544189453, 86.23987579345703, 6013.513671875)
            elseif MyLevel >= 1575 and MyLevel <= 1599 then
                Mon = "Dragon Crew Warrior"; Qdata = 1; Qname = "DragonCrewQuest"; NameMon = "Dragon Crew Warrior"
                PosQ = CFrame.new(6738.96142578125, 127.81645965576172, -713.511474609375)
                PosM = CFrame.new(6920.71435546875, 56.15597152709961, -942.5044555664062)
            elseif MyLevel >= 1600 and MyLevel <= 1624 then
                Mon = "Dragon Crew Archer"; Qdata = 2; Qname = "DragonCrewQuest"; NameMon = "Dragon Crew Archer"
                PosQ = CFrame.new(6738.96142578125, 127.81645965576172, -713.511474609375)
                PosM = CFrame.new(6817.91259765625, 484.804443359375, 513.4141235351562)
            elseif MyLevel >= 1625 and MyLevel <= 1649 then
                Mon = "Hydra Enforcer"; Qdata = 1; Qname = "VenomCrewQuest"; NameMon = "Hydra Enforcer"
                PosQ = CFrame.new(5213.8740234375, 1004.5042724609375, 758.6944580078125)
                PosM = CFrame.new(4584.69287109375, 1002.6435546875, 705.7958984375)
            elseif MyLevel >= 1650 and MyLevel <= 1699 then
                Mon = "Venomous Assailant"; Qdata = 2; Qname = "VenomCrewQuest"; NameMon = "Venomous Assailant"
                PosQ = CFrame.new(5213.8740234375, 1004.5042724609375, 758.6944580078125)
                PosM = CFrame.new(4638.78564453125, 1078.94091796875, 881.8002319335938)
            elseif MyLevel >= 1700 and MyLevel <= 1724 then
                Mon = "Marine Commodore"; Qdata = 1; Qname = "MarineTreeIsland"; NameMon = "Marine Commodore"
                PosQ = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747)
                PosM = CFrame.new(2286.0078125, 73.13391876220703, -7159.80908203125)
            elseif MyLevel >= 1725 and MyLevel <= 1774 then
                Mon = "Marine Rear Admiral"; Qdata = 2; Qname = "MarineTreeIsland"; NameMon = "Marine Rear Admiral"
                PosQ = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813)
                PosM = CFrame.new(3656.773681640625, 160.52406311035156, -7001.5986328125)
            elseif MyLevel >= 1775 and MyLevel <= 1799 then
                Mon = "Fishman Raider"; Qdata = 2; Qname = "DeepForestIsland3"; NameMon = "Fishman Raider"
                PosQ = CFrame.new(3142.67822, 108.42981, 7482.37988, 0.34205412, 0, 0.939680243, 0, 1, 0, -0.939680243, 0, 0.34205412)
                PosM = CFrame.new(-10407.5263671875, 331.76263427734375, -8368.5166015625)
            elseif MyLevel >= 1800 and MyLevel <= 1824 then
                Mon = "Fishman Captain"; Qdata = 1; Qname = "DeepForestIsland3"; NameMon = "Fishman Captain"
                PosQ = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
                PosM = CFrame.new(-10994.701171875, 352.38140869140625, -9002.1103515625)
            elseif MyLevel >= 1825 and MyLevel <= 1849 then
                Mon = "Forest Pirate"; Qdata = 2; Qname = "DeepForestIsland"; NameMon = "Forest Pirate"
                PosQ = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)
                PosM = CFrame.new(-13274.478515625, 332.3781433105469, -7769.58056640625)
            elseif MyLevel >= 1850 and MyLevel <= 1899 then
                Mon = "Forest Pirate"; Qdata = 1; Qname = "DeepForestIsland"; NameMon = "Forest Pirate"
                PosQ = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)
                PosM = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125)
            elseif MyLevel >= 1900 and MyLevel <= 1924 then
                Mon = "Jungle Pirate"; Qdata = 2; Qname = "DeepForestIsland"; NameMon = "Jungle Pirate"
                PosQ = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
                PosM = CFrame.new(-12256.16015625, 331.73828125, -10485.8369140625)
            elseif MyLevel >= 1925 and MyLevel <= 1974 then
                Mon = "Musketeer Pirate"; Qdata = 2; Qname = "DeepForestIsland2"; NameMon = "Musketeer Pirate"
                PosQ = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
                PosM = CFrame.new(-13457.904296875, 391.545654296875, -9859.177734375)
            elseif MyLevel >= 1975 and MyLevel <= 1999 then
                Mon = "Reborn Skeleton"; Qdata = 1; Qname = "HauntedQuest1"; NameMon = "Reborn Skeleton"
                PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0)
                PosM = CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625)
            elseif MyLevel >= 2000 and MyLevel <= 2024 then
                Mon = "Living Zombie"; Qdata = 2; Qname = "HauntedQuest1"; NameMon = "Living Zombie"
                PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0)
                PosM = CFrame.new(-10144.1318359375, 138.62667846679688, 5838.0888671875)
            elseif MyLevel >= 2025 and MyLevel <= 2049 then
                Mon = "Demonic Soul"; Qdata = 1; Qname = "HauntedQuest2"; NameMon = "Demonic Soul"
                PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625)
            elseif MyLevel >= 2050 and MyLevel <= 2074 then
                Mon = "Posessed Mummy"; Qdata = 2; Qname = "HauntedQuest2"; NameMon = "Posessed Mummy"
                PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-9582.0224609375, 6.251527309417725, 6205.478515625)
            elseif MyLevel >= 2075 and MyLevel <= 2099 then
                Mon = "Peanut Scout"; Qdata = 1; Qname = "NutsIslandQuest"; NameMon = "Peanut Scout"
                PosQ = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-2143.241943359375, 47.72198486328125, -10029.9951171875)
            elseif MyLevel >= 2100 and MyLevel <= 2124 then
                Mon = "Peanut President"; Qdata = 1; Qname = "NutsIslandQuest"; NameMon = "Peanut President"
                PosQ = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-1859.35400390625, 38.10316848754883, -10422.4296875)
            elseif MyLevel >= 2125 and MyLevel <= 2149 then
                Mon = "Ice Cream Chef"; Qdata = 1; Qname = "IceCreamIslandQuest"; NameMon = "Ice Cream Chef"
                PosQ = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-872.24658203125, 65.81957244873047, -10919.95703125)
            elseif MyLevel >= 2150 and MyLevel <= 2199 then
                Mon = "Ice Cream Commander"; Qdata = 2; Qname = "IceCreamIslandQuest"; NameMon = "Ice Cream Commander"
                PosQ = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-558.06103515625, 112.04895782470703, -11290.7744140625)
            elseif MyLevel >= 2200 and MyLevel <= 2224 then
                Mon = "Cookie Crafter"; Qdata = 1; Qname = "CakeQuest1"; NameMon = "Cookie Crafter"
                PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931)
                PosM = CFrame.new(-2374.13671875, 37.79826354980469, -12125.30859375)
            elseif MyLevel >= 2225 and MyLevel <= 2249 then
                Mon = "Cake Guard"; Qdata = 2; Qname = "CakeQuest1"; NameMon = "Cake Guard"
                PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931)
                PosM = CFrame.new(-1598.3070068359375, 43.773197174072266, -12244.5810546875)
            elseif MyLevel >= 2250 and MyLevel <= 2274 then
                Mon = "Baking Staff"; Qdata = 1; Qname = "CakeQuest2"; NameMon = "Baking Staff"
                PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
                PosM = CFrame.new(-1887.8099365234375, 77.6185073852539, -12998.3505859375)
            elseif MyLevel >= 2275 and MyLevel <= 2299 then
                Mon = "Head Baker"; Qdata = 2; Qname = "CakeQuest2"; NameMon = "Head Baker"
                PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
                PosM = CFrame.new(-2216.188232421875, 82.884521484375, -12869.2939453125)
            elseif MyLevel >= 2300 and MyLevel <= 2324 then
                Mon = "Cocoa Warrior"; Qdata = 1; Qname = "ChocQuest1"; NameMon = "Cocoa Warrior"
                PosQ = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
                PosM = CFrame.new(-21.55328369140625, 80.57499694824219, -12352.3876953125)
            elseif MyLevel >= 2325 and MyLevel <= 2349 then
                Mon = "Chocolate Bar Battler"; Qdata = 2; Qname = "ChocQuest1"; NameMon = "Chocolate Bar Battler"
                PosQ = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
                PosM = CFrame.new(582.590576171875, 77.18809509277344, -12463.162109375)
            elseif MyLevel >= 2350 and MyLevel <= 2374 then
                Mon = "Sweet Thief"; Qdata = 1; Qname = "ChocQuest2"; NameMon = "Sweet Thief"
                PosQ = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
                PosM = CFrame.new(165.1884765625, 76.05885314941406, -12600.8369140625)
            elseif MyLevel >= 2375 and MyLevel <= 2399 then
                Mon = "Candy Rebel"; Qdata = 2; Qname = "ChocQuest2"; NameMon = "Candy Rebel"
                PosQ = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
                PosM = CFrame.new(134.86563110351562, 77.2476806640625, -12876.5478515625)
            elseif MyLevel >= 2400 and MyLevel <= 2424 then
                Mon = "Candy Pirate"; Qdata = 1; Qname = "CandyQuest1"; NameMon = "Candy Pirate"
                PosQ = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
                PosM = CFrame.new(-1310.5003662109375, 26.016523361206055, -14562.404296875)
            elseif MyLevel >= 2425 and MyLevel <= 2449 then
                Mon = "Snow Demon"; Qdata = 2; Qname = "CandyQuest1"; NameMon = "Snow Demon"
                PosQ = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
                PosM = CFrame.new(-880.2006225585938, 71.24776458740234, -14538.609375)
            elseif MyLevel >= 2450 and MyLevel <= 2474 then
                Mon = "Isle Outlaw"; Qdata = 1; Qname = "TikiQuest1"; NameMon = "Isle Outlaw"
                PosQ = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812)
                PosM = CFrame.new(-16442.814453125, 116.13899993896484, -264.4637756347656)
            elseif MyLevel >= 2475 and MyLevel <= 2524 then
                Mon = "Island Boy"; Qdata = 2; Qname = "TikiQuest1"; NameMon = "Island Boy"
                PosQ = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812)
                PosM = CFrame.new(-16901.26171875, 84.06756591796875, -192.88906860351562)
            elseif MyLevel >= 2525 and MyLevel <= 2574 then
                Mon = "Isle Champion"; Qdata = 1; Qname = "TikiQuest2"; NameMon = "Isle Champion"
                PosQ = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625)
                PosM = CFrame.new(-16641.6796875, 235.7825469970703, 1031.282958984375)
            elseif MyLevel >= 2575 and MyLevel <= 2599 then
                Mon = "Skull Slayer"; Qdata = 2; Qname = "TikiQuest3"; NameMon = "Skull Slayer"
                PosQ = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, 0, 1, -0, 0.308980465, 0, 0.951068401)
                PosM = CFrame.new(-16887.7305, 113.074638, 1629.97778, -0.559032857, 1.2313353e-08, -0.829145491, 1.05618814e-09, 1, 1.41385428e-08, 0.829145491, 7.02817626e-09, -0.559032857)
            elseif MyLevel >= 2600 and MyLevel <= 2624 then
                Mon = "Reef Bandit"; Qdata = 1; Qname = "SubmergedQuest1"; NameMon = "Reef Bandit"
                PosQ = CFrame.new(10778.875, -2087.72437, 9265.18359, 0.934615612, -9.33109447e-08, -0.355659455, 9.17655143e-08, 1, -2.12154276e-08, 0.355659455, -1.28090019e-08, 0.934615612)
                PosM = CFrame.new(11019.1318, -2146.06812, 9342.3916, -0.719955266, -1.74275385e-08, 0.69402045, 5.76556367e-08, 1, 8.49211546e-08, -0.69402045, 1.01153624e-07, -0.719955266)
            elseif MyLevel >= 2625 and MyLevel <= 2649 then
                Mon = "Coral Pirate"; Qdata = 2; Qname = "SubmergedQuest1"; NameMon = "Coral Pirate"
                PosQ = CFrame.new(10778.875, -2087.72437, 9265.18359, 0.934615612, -9.33109447e-08, -0.355659455, 9.17655143e-08, 1, -2.12154276e-08, 0.355659455, -1.28090019e-08, 0.934615612)
                PosM = CFrame.new(10808.6006, -2030.36145, 9364.2334, -0.775185347, -0.0359364748, 0.6307109, 0.0615428537, 0.989336014, 0.132010356, -0.628728986, 0.141148239, -0.764707148)
            elseif MyLevel >= 2650 and MyLevel <= 2674 then
                Mon = "Sea Chanter"; Qdata = 1; Qname = "SubmergedQuest2"; NameMon = "Sea Chanter"
                PosQ = CFrame.new(10880.6855, -2086.20044, 10032.624, -0.321384728, 9.87648434e-08, -0.946948707, 7.13271007e-08, 1, 8.00902953e-08, 0.946948707, -4.18033075e-08, -0.321384728)
                PosM = CFrame.new(10671.2715, -2057.59155, 10047.2588)
            elseif MyLevel >= 2675 and MyLevel <= 2699 then
                Mon = "Ocean Prophet"; Qdata = 2; Qname = "SubmergedQuest2"; NameMon = "Ocean Prophet"
                PosQ = CFrame.new(10880.6855, -2086.20044, 10032.624, -0.321384728, 9.87648434e-08, -0.946948707, 7.13271007e-08, 1, 8.00902953e-08, 0.946948707, -4.18033075e-08, -0.321384728)
                PosM = CFrame.new(11008.5195, -2007.72839, 10223.0791, -0.688615739, 2.33523378e-09, -0.725126445, 2.99292546e-09, 1, 3.78221315e-10, 0.725126445, -1.90980032e-09, -0.688615739)
            elseif MyLevel >= 2700 and MyLevel <= 2724 then
                Mon = "High Disciple"; Qdata = 1; Qname = "SubmergedQuest3"; NameMon = "High Disciple"
                PosQ = CFrame.new(9640.08789, -1992.44507, 9613.65234, -0.957327187, 4.11991223e-08, 0.289006323, 1.5775445e-08, 1, -9.02985846e-08, -0.289006323, -8.18860855e-08, -0.957327187)
                PosM = CFrame.new(9750.41602, -1966.93884, 9753.36035, -0.749824047, 5.57797613e-08, -0.661637306, 2.03500754e-08, 1, 6.1243199e-08, 0.661637306, 3.24572511e-08, -0.749824047)
            elseif MyLevel >= 2725 then
                Mon = "Grand Devotee"; Qdata = 2; Qname = "SubmergedQuest3"; NameMon = "Grand Devotee"
                PosQ = CFrame.new(9640.08789, -1992.44507, 9613.65234, -0.957327187, 4.11991223e-08, 0.289006323, 1.5775445e-08, 1, -9.02985846e-08, -0.289006323, -8.18860855e-08, -0.957327187)
                PosM = CFrame.new(9611.70508, -1993.47119, 9882.68848, -0.591375351, 4.14332426e-08, -0.806396425, 4.73774868e-08, 1, 1.66361875e-08, 0.806396425, -2.83668058e-08, -0.591375351)
            end
        end

        if Mon == "" or not PosM then return nil end
        return {Mon = Mon, Qdata = Qdata, Qname = Qname, NameMon = NameMon, PosQ = PosQ, PosM = PosM}
    end


    -- ══════════════════════════════════════════════════════════════════
    -- [ADDED từ message_10] AUTO STORE FRUIT — tự lưu trái cây từ
    -- Backpack/Character vào inventory (StoreFruit) mỗi 1s.
    -- Dùng ScriptStorage.IgnoreStoreFruits để tránh lưu trùng trái
    -- đang được dùng bởi AutoRandomFruit / AutoRaidIce.
    -- Không dùng checkItem() (message_10 only) → dùng table.find trực tiếp.
    -- ══════════════════════════════════════════════════════════════════
    task.spawn(function()
        while true do
            pcall(function()
                local gg = {}
                for _, container in next, {LocalPlayer.Backpack, LocalPlayer.Character} do
                    if container then
                        for _, v in next, container:GetChildren() do
                            if v.Name:find("Fruit") and v:IsA("Tool") then
                                local ori = v:GetAttribute("OriginalName") or v.Name
                                -- Bỏ qua nếu đang bị IgnoreStoreFruits hold
                                if not table.find(ScriptStorage.IgnoreStoreFruits, v.Name)
                                and not table.find(ScriptStorage.IgnoreStoreFruits, ori) then
                                    table.insert(gg, {tool = v, ori = ori})
                                end
                            end
                        end
                    end
                end
                if #gg > 0 then
                    local sf = {}
                    local ok, inv = pcall(function()
                        return Remotes.CommF_:InvokeServer("getInventoryFruits")
                    end)
                    if ok and type(inv) == "table" then
                        for _, _v in pairs(inv) do
                            if type(_v) == "table" and _v.Name then
                                sf[_v.Name] = true
                            end
                        end
                    end
                    for _, v in pairs(gg) do
                        if not sf[v.ori] then
                            pcall(function()
                                Remotes.CommF_:InvokeServer("StoreFruit", v.ori, v.tool)
                            end)
                            sf[v.ori] = true
                        end
                    end
                end
            end)
            -- Cousin DLCBoxData ping (từ message_10 — giữ như gốc)
            pcall(function()
                Remotes.CommF_:InvokeServer("Cousin", "DLCBoxData")
            end)
            task.wait(1)
        end
    end)

    -- [ADDED] AUTO RANDOM FRUIT — tự đổi ngẫu nhiên giữa các trái ÁC QUỶ
    -- đang sở hữu trong túi đồ. Dùng getInventoryFruits (lấy danh sách trái
    -- đang có) + LoadFruit (trang bị) — cả 2 remote này đã CÓ THẬT và được
    -- dùng sẵn ở AutoRaidIce.GetCheapestFruit/BuyChip trong chính file này,
    -- không phải tự chế. Đọc Config.Items.AutoRandomFruit (đúng convention
    -- của file — mọi feature khác đều đọc thẳng Config.Items.X, không qua
    -- _G mirror).
    task.spawn(function()
        while task.wait(30) do
            pcall(function()
                if not Config.Items.AutoRandomFruit then return end
                local ok, inventoryFruits = pcall(function()
                    return Remotes.CommF_:InvokeServer("getInventoryFruits")
                end)
                if not ok or type(inventoryFruits) ~= "table" then return end
                local names = {}
                for _, fruitData in pairs(inventoryFruits) do
                    if fruitData and fruitData.Name then
                        table.insert(names, fruitData.Name)
                    end
                end
                if #names == 0 then return end
                local picked = names[math.random(1, #names)]
                table.insert(ScriptStorage.IgnoreStoreFruits, picked)
                Remotes.CommF_:InvokeServer("LoadFruit", picked)
            end)
        end
    end)

    -- ══════════════════════════════════════════════════════════════════
    -- [REPLACED per promt_fix_kaitun — PATCH #1] CheckDataLevel từ message(10)
    -- ⚠️ CẢNH BÁO: kiến trúc ánh xạ CỨNG level→quái (lv<70→Shanda, lv<120→God's Guard)
    -- KHÔNG check vị trí thật trên map — rủi ro đơ nếu vị trí không khớp.
    -- Đây y chang kiểu đã được DynamicIsland gỡ trước đó. Port lại per boss man.
    -- Ánh xạ: plr.Data.Level.Value → ScriptStorage.PlayerData.Level
    -- ══════════════════════════════════════════════════════════════════
    FunctionsHandler.LevelFarm:RegisterMethod("Refresh", function()
        -- Guard chống xung đột AutoSea3/AutoSea2
        if _G.SeaTransitionActive then return nil end

        local lv = ScriptStorage.PlayerData.Level or 0
        -- Ánh xạ y hệt message(10) CheckDataLevel()
        if lv < 10 then
            return 1
        elseif lv < 70 then
            return 2   -- Shanda @ Upper Skylands
        elseif lv < 120 then
            return 3   -- God's Guard @ Skylands
        else
            return 4
        end
    end)
    -- ══════════════════════════════════════════════════════════════════
    -- [REPLACED per promt_fix_kaitun — PATCH #2] Chuyển thể FarmLevelLogic
    -- Ánh xạ Bước 2:
    --   plr.Data.Level.Value   → ScriptStorage.PlayerData.Level
    --   PLACE_ID.sea1/2/3()   → SeaIndex == 1/2/3
    --   bringMob+equipWeapon+FastAttack → CombatController.Attack(name)
    --   CheckMonster(name)    → không cần (đã có trong CombatController.Attack)
    --   Teleport("sky 3/2")   → TweenController.Create trực tiếp (không requestEntrance)
    --                           + TweenController.Create fallback
    -- Giải pháp HYBRID (Cách 1): thêm check vị trí thật (CurrentLocation)
    -- TRƯỚC khi TweenController.Create — vừa dùng logic message(10), vừa không đơ.
    -- ══════════════════════════════════════════════════════════════════
    FunctionsHandler.LevelFarm:RegisterMethod("Start", function(h)
        local currentLevel = ScriptStorage.PlayerData.Level or 0

        -- Guard: đã lên đủ level sang Sea 2 → không farm Sea 1 nữa
        if currentLevel >= 700 and SeaIndex == 1 then return end

        -- ── Sea 3: farm Bones nếu cần (giữ nguyên bản DynamicIsland gốc)
        if SeaIndex == 3 then
            if (ScriptStorage.Backpack.Bones or {Count = 0}).Count >= 50 then
                if os.time() > (BonesCooldown or 0) then
                    local X, X, X, w = Remotes.CommF_:InvokeServer("Bones", "Check")
                    if tonumber(X or 1) == 0 then
                        local X = Split(w, ":")
                        local w = ((tonumber(X[1]) * 60) + tonumber(X[2])) * 60
                        BonesCooldown = os.time() + w
                    else
                        Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                    end
                end
            end
        end

        -- ═══ h == 2: level 10–69 → farm Shanda @ Upper Skylands ═══════
        -- Tương đương nhánh `levelData == 2` của message(10).txt
        -- Teleport("sky 3") → TweenController.Create Upper Skylands
        if h == 2 then
            if SeaIndex == 1 then
                local loc = LocalPlayer:GetAttribute("CurrentLocation")
                if not loc or (loc ~= "Skylands" and loc ~= "Upper Skylands") then
                    -- [FIXED] Bỏ requestEntrance, chỉ dùng tween
                    TweenController.Create(CFrame.new(-7894, 5547, -380))
                    task.wait(1)
                    return
                end
            end
            SetTask("MainTask", "Level Farm | Shanda | Upper Skylands")

            local foundMob = false
            for _, folder in ipairs({workspace.Enemies, game.ReplicatedStorage}) do
                for _, v2 in ipairs(folder:GetChildren()) do
                    if v2.Name == "Shanda" and v2:IsA("Model") then
                        local hum = v2:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            foundMob = true
                            SetTask("SubTask", "⚔️ Attacking Shanda")
                            CombatController.Attack("Shanda")
                            break
                        end
                    end
                end
                if foundMob then break end
            end
            if not foundMob then
                local spawnFolder = game.ReplicatedStorage:FindFirstChild("FortBuilderReplicatedSpawnPositionsFolder")
                local n = spawnFolder and spawnFolder:FindFirstChild("Shanda")
                if n then
                    TweenController.Create(n:GetPivot() + Vector3.new(0, 25, 0))
                else
                    TweenController.Create(CFrame.new(-7783, 5576, -519))
                end
            end

        -- ═══ h == 3: level 70–119 → farm God's Guard @ Skylands ══════
        -- Tương đương nhánh `levelData == 3` của message(10).txt
        -- Teleport("sky 2") → TweenController.Create Skylands
        elseif h == 3 then
            if SeaIndex == 1 then
                local loc = LocalPlayer:GetAttribute("CurrentLocation")
                if not loc or (loc ~= "Skylands" and loc ~= "Upper Skylands") then
                    -- [FIXED] Bỏ requestEntrance, chỉ dùng tween
                    TweenController.Create(CFrame.new(-4650, 872, -1775))
                    task.wait(1.5)
                    return
                end
            end
            SetTask("MainTask", "Level Farm | God's Guard | Skylands")

            local foundMob = false
            for _, folder in ipairs({workspace.Enemies, game.ReplicatedStorage}) do
                for _, v2 in ipairs(folder:GetChildren()) do
                    if v2.Name == "God's Guard" and v2:IsA("Model") then
                        local hum = v2:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            foundMob = true
                            SetTask("SubTask", "⚔️ Attacking God's Guard")
                            CombatController.Attack("God's Guard")
                            break
                        end
                    end
                end
                if foundMob then break end
            end
            if not foundMob then
                local spawnFolder = game.ReplicatedStorage:FindFirstChild("FortBuilderReplicatedSpawnPositionsFolder")
                local n = spawnFolder and spawnFolder:FindFirstChild("God's Guard")
                if n then
                    TweenController.Create(n:GetPivot() + Vector3.new(0, 25, 0))
                end
            end

        -- ═══ h == 4 / h == 1: farm chung qua ManualLevelLookup ════════
        else
            local Q = ManualLevelLookup()
            if not Q then
                Report("LevelFarm: ManualLevelLookup không tìm được mốc (lv="
                    .. tostring(currentLevel) .. ", sea=" .. tostring(SeaIndex) .. ")")
                return
            end
            SetTask("SubTask", "📋 " .. Q.NameMon .. " | Quest: " .. Q.Mon)

            local activeQuestName = GetActiveQuestName()
            if activeQuestName ~= nil then
                if activeQuestName ~= false then
                    if activeQuestName ~= Q.Qname then return J.AbandonQuest() end
                else
                    if not Q.PosQ then return end
                    TweenController.Create(Q.PosQ + Vector3.new(0, 5, 3))
                    SetTask("MainTask", "Level Farm | " .. Q.Mon .. " | Nhận Quest")
                    if CaculateDistance(Q.PosQ) > 10 then return end
                    task.wait(0.5)
                    LevelFarmTTL = 0
                    J.StartQuest(Q.Qname, Q.Qdata)
                    task.wait(0.3)
                end
            else
                CurrentClaimQuest1 = GetCurrentClaimQuest()
                if CurrentClaimQuest1 then
                    if CurrentClaimQuest1 ~= Q.NameMon and CurrentClaimQuest1 ~= (Q.NameMon .. "s") then
                        return J.AbandonQuest()
                    end
                else
                    if not Q.PosQ then return end
                    TweenController.Create(Q.PosQ + Vector3.new(0, 5, 3))
                    SetTask("MainTask", "Level Farm | " .. Q.Mon .. " | Nhận Quest")
                    if CaculateDistance(Q.PosQ) > 10 then return end
                    task.wait(0.5)
                    LevelFarmTTL = 0
                    J.StartQuest(Q.Qname, Q.Qdata)
                    task.wait(0.3)
                end
            end
            -- CombatController.Attack tự làm: tìm quái + tween + đánh
            -- (thay thế bringMob + equipWeapon + FastAttack + CheckMonster)
            CombatController.Attack(Q.Mon)
        end
    end)

    -- ============================================================
    -- EQUIP WEAPON (TỪ TEST.TXT - ĐÃ CÓ SẴN TRONG CombatController.Attack)
    -- ============================================================
    FunctionsHandler.LocalPlayerController:RegisterMethod("EquipTool", function(h)
        if not Humanoid then return end
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if not bp then return end
        for X, X in bp:GetChildren() do
            if X:IsA('Tool') and X.Name ~= "Tool" and (X.Name == tostring(h) or X.ToolTip == h) then
                LocalPlayer.Character:WaitForChild('Humanoid'):EquipTool(X)
            end
        end
    end)
    FunctionsHandler.LocalPlayerController:RegisterMethod('ToggleAbilities', function(h, X)
        if h == 'Buso' then
            if LocalPlayer:HasTag('Buso') and not X or X then Remotes.CommF_:InvokeServer('Buso') end
        elseif h == "Observation" then
        end
    end)
    FunctionsHandler.LocalPlayerController:RegisterMethod('ConfigurationAbilitiesToggle', function()
        FunctionsHandler.LocalPlayerController.Methods.ToggleAbilities:Call('Buso', SCRIPT_CONFIG.BUSO)
        FunctionsHandler.LocalPlayerController.Methods.ToggleAbilities:Call('Observation', SCRIPT_CONFIG.OBSERVATION)
    end)
    print(3)

    -- ============================================================
    -- SABER QUEST - HOÀN CHỈNH
    -- ============================================================
    FunctionsHandler.Saber:RegisterMethod('Refresh', function()
        if not Config.Items.Saber then return end
        if ScriptStorage.Backpack.Saber then return end
        if ScriptStorage.PlayerData.Level < 200 then return end
        local X = Remotes.CommF_:InvokeServer('ProQuestProgress')
        local h
        for w, w in X.Plates do if w == false then h = 1 end end
        if not h then
            if not X.UsedTorch then h = 2
            elseif not X.UsedCup then h = 3
            elseif not X.TalkedSon then h = 4
            elseif not X.KilledMob then h = 5
            elseif not X.UsedRelic then h = 6
            elseif not X.KilledShanks and ScriptStorage.Enemies["Saber Expert"] then h = 7 end
        end
        FunctionsHandler.Saber:Set("CurrentProgressLevel", h)
        FunctionsHandler.Saber:Set('LastestRefreshSenque', os.time())
        return h
    end)

    FunctionsHandler.Saber:RegisterMethod('GetQuestplates', function()
        local h = FunctionsHandler.Saber:Get("QuestplatesCache")
        if h then return h end
        local h = Services.Workspace.Map.Jungle
        local X = {}
        table.foreach(h.QuestPlates:GetChildren(), function(h, w) h = w:FindFirstChild("Button") and table.insert(X, w) end)
        FunctionsHandler.Saber:Set('QuestplatesCache', X)
        return X
    end)

    FunctionsHandler.Saber:RegisterMethod('Start', function()
        local h, X = FunctionsHandler.Saber:Get("CurrentProgressLevel"), FunctionsHandler.Saber:Get('LastestRefreshSenque')
        if not h then
            FunctionsHandler.Saber.Methods.Refresh:Call()
            return FunctionsHandler.Saber.Methods.Start:Call()
        elseif h == 0 then
        elseif os.time() - X > 60 then
            FunctionsHandler.Saber.Methods.Refresh:Call()
            return FunctionsHandler.Saber.Methods.Start:Call()
        else
            if h == 1 then
                local X = FunctionsHandler.Saber.Methods.GetQuestplates:Call()
                for w, D in X do
                    SetTask('MainTask', "Saber Quest | Quest Plates | Touching " .. w .. "/5")
                    while CaculateDistance(D.Button.CFrame) > 20 do
                        task.wait()
                        TweenController.Create(D.Button.CFrame)
                    end
                    task.wait(1)
                end
            elseif h == 2 then
                SetTask('MainTask', 'Saber Quest | Torch Puzzle | Using Torch')
                Remotes.CommF_:InvokeServer("ProQuestProgress", 'GetTorch')
                task.wait(1)
                Remotes.CommF_:InvokeServer('ProQuestProgress', "DestroyTorch")
            elseif h == 3 then
                SetTask('MainTask', "Saber Quest | Sick Man | Helping with Cup")
                Remotes.CommF_:InvokeServer('ProQuestProgress', "GetCup")
                if ScriptStorage.Tools.Cup then
                    FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Cup')
                    task.wait(1)
                    Remotes.CommF_:InvokeServer("ProQuestProgress", 'FillCup', LocalPlayer.Character.Cup)
                end
                Remotes.CommF_:InvokeServer("ProQuestProgress", 'SickMan')
            elseif h == 4 then
                SetTask('MainTask', 'Saber Quest | Rich Son | Getting Information')
                Remotes.CommF_:InvokeServer('ProQuestProgress', 'RichSon')
            elseif h == 5 then
                SetTask("MainTask", "Saber Quest | Mob Leader | Defeating Boss")
                CombatController.Attack('Mob Leader')
            elseif h == 6 then
                SetTask("MainTask", 'Saber Quest | Relic | Placing at Location')
                Remotes.CommF_:InvokeServer('ProQuestProgress', 'RichSon')
                Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
            elseif h == 7 then
                SetTask('MainTask', "Saber Quest | Saber Expert | Final Battle")
                CombatController.Attack("Saber Expert")
            end
        end
    end)
    Remotes.RefreshQuestPro.OnClientEvent:Connect(FunctionsHandler.Saber.Methods.Refresh.Callback)

    -- ============================================================
    -- SECOND SEA PUZZLE (DRESSROSA)
    -- ============================================================
    FunctionsHandler.SecondSeaPuzzle:RegisterMethod('Refresh', function()
        if ScriptStorage.PlayerData.Level < 700 or SeaIndex ~= 1 then return end
        if FunctionsHandler.SecondSeaPuzzle:Get('IsCompleted') then return end
        local k = Remotes.CommF_:InvokeServer('DressrosaQuestProgress')
        if not k.TalkedDetective then Result = 1
        elseif not k.KilledIceBoss then Result = 2
        else FunctionsHandler.SecondSeaPuzzle:Set("IsCompleted", true) end
        FunctionsHandler.SecondSeaPuzzle:Set("CurrentProgressLevel", Result)
        FunctionsHandler.SecondSeaPuzzle:Set('LastestRefreshSenque', os.time())
        return Result
    end)

    FunctionsHandler.SecondSeaPuzzle:RegisterMethod("Start", function()
        local k, h = FunctionsHandler.SecondSeaPuzzle:Get('CurrentProgressLevel'), FunctionsHandler.SecondSeaPuzzle:Get('LastestRefreshSenque')
        FunctionsHandler.SecondSeaPuzzle:Set('CurrentProgressLevel', nil)
        if not k then
            FunctionsHandler.SecondSeaPuzzle.Methods.Refresh:Call()
            return FunctionsHandler.SecondSeaPuzzle.Methods.Start:Call()
        elseif k == 1 then
            SetTask('SubTask', '🧩 Sea2: Talk to Detective')
            SetTask('MainTask', "Auto Second Sea - Talk To Detective")
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'Detective')
            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
            task.wait(1)
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'UseKey')
        elseif k == 2 then
            SetTask('SubTask', '🧩 Sea2: Defeat Ice Admiral')
            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'Detective')
            task.wait(1)
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'UseKey')
            SetTask("MainTask", "Auto Second Sea - Defeating Ice Admiral")
            CombatController.Attack("Ice Admiral")
            Remotes.CommF_:InvokeServer('TravelDressrosa')
        end
    end)

    -- ============================================================
    -- COLOSSEUM PUZZLE (BARTILO)
    -- ============================================================
    FunctionsHandler.ColosseumPuzzle:RegisterMethod("Refresh", function()
        if SeaIndex ~= 2 then return end
        if ScriptStorage.PlayerData.Level < 850 or ScriptStorage.Backpack['Warrior Helmet'] then return end
        local k = Remotes.CommF_:InvokeServer("BartiloQuestProgress")
        if not k.KilledBandits then Result = 1
        elseif not k.KilledSpring then
            if ScriptStorage.Enemies.Jeremy then Result = 2 end
        elseif not k.DidPlates then Result = 3 end
        FunctionsHandler.ColosseumPuzzle:Set("CurrentProgressLevel", Result)
        FunctionsHandler.ColosseumPuzzle:Set("LastestRefreshSenque", os.time())
        return Result
    end)

    FunctionsHandler.ColosseumPuzzle:RegisterMethod('Start', function()
        local k, h = FunctionsHandler.ColosseumPuzzle:Get("CurrentProgressLevel"), FunctionsHandler.ColosseumPuzzle:Get("LastestRefreshSenque")
        FunctionsHandler.ColosseumPuzzle:Set("CurrentProgressLevel", nil)
        if not k then
            FunctionsHandler.ColosseumPuzzle.Methods.Refresh:Call()
            return FunctionsHandler.ColosseumPuzzle.Methods.Start:Call()
        elseif k == 1 then
            SetTask("MainTask", 'Auto Bartilo Quest - Defeating 50x Swan Pirate')
            local h, X = J:GetCurrentClaimQuest()
            if h then
                if not string.find(X, '50') then J.AbandonQuest()
                else CombatController.Attack("Swan Pirate") end
            else
                J.StartQuest('BartiloQuest', 1)
            end
        elseif k == 2 then
            SetTask('MainTask', "Auto Bartilo Quest - Defeating Jeremy")
            CombatController.Attack("Jeremy")
        elseif k == 3 then
            SetTask("MainTask", 'Auto Bartilo Quest - Doing Puzzle')
            if CaculateDistance(CFrame.new(-1837.46155, 44.2921753, 1656.1987, 0.999881566, -1.03885048e-22, -0.0153914848, 1.07805858e-22, 1, 2.53909284e-22, 0.0153914848, -2.55538502e-22, 0.999881566)) > 10 then
                alert("tween to")
                TweenController.Create(CFrame.new(-1837.46155, 44.2921753, 1656.1987, 0.999881566, -1.03885048e-22, -0.0153914848, 1.07805858e-22, 1, 2.53909284e-22, 0.0153914848, -2.55538502e-22, 0.999881566))
            else
                LocalPlayer = game.Players.LocalPlayer
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1836.0, 11, 1714)
                alert("1")
                task.wait(.5)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1850.49329, 13.1789551, 1750.89685)
                alert('2')
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1858.87305, 19.3777466, 1712.01807)
                alert("3")
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1803.94324, 16.5789185, 1750.89685)
                task.wait(1)
                alert("4")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1858.55835, 16.8604317, 1724.79541)
                task.wait(1)
                alert('5')
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1869.54224, 15.987854, 1681.00659)
                task.wait(1)
                alert("6")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1800.0979, 16.4978027, 1684.52368)
                task.wait(1)
                alert("7")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1819.26343, 14.795166, 1717.90625)
                task.wait(1)
                alert("8")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1813.51843, 14.8604736, 1724.79541)
            end
        end
    end)

    -- ============================================================
    -- EVOLUTION RACE (RACE V2)
    -- ============================================================
    FunctionsHandler.EvoRace:RegisterMethod("Refresh", function()
        if not Config.Items.RaceV2 then return end
        if SeaIndex ~= 2 then return end
        if getsenv(game.ReplicatedStorage.GuideModule)._G.ServerData.ExpBoost ~= 0 or ScriptStorage.PlayerData.Level < 900 or ScriptStorage.PlayerData.Beli < 1000000 or ScriptStorage.PlayerData.RaceLevel ~= 1 then return end
        return true
    end)

    FunctionsHandler.EvoRace:RegisterMethod('Start', function()
        Remotes.CommF_:InvokeServer('Alchemist', "1")
        Remotes.CommF_:InvokeServer('Alchemist', '2')
        for k = 1, 2, 1 do
            SetTask('SubTask', '🌈 Collecting Flower ' .. k .. ' for Race V2')
            local h = ScriptStorage.Tools["Flower " .. k]
            local X = Services.Workspace:FindFirstChild('Flower' .. k)
            if not h then
                if X and X.Transparency == 0 then
                    SetTask('MainTask', 'Auto Race V2 - Collecting Flower ' .. k)
                    while not ScriptStorage.Tools["Flower " .. k] do
                        task.wait()
                        TweenController.Create(X.CFrame + Vector3.new(0, math.random(-1.0, 2), 0))
                    end
                end
            end
        end
        if not ScriptStorage.Tools['Flower 3'] then
            SetTask('SubTask', '🌈 Farming Swan Pirate for Flower 3')
            SetTask('MainTask', 'Auto Race V2 - Collecting Flower ' .. 3)
            CombatController.Attack('Swan Pirate')
        else
            SetTask('SubTask', '🌈 Race V2 completed, idling...')
            SetTask("MainTask", 'Auto Race V2 - Idling')
            if LocalPlayer.Character.HumanoidRootPart.CFrame.Y < 50000 then
                TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 50, 0))
            end
            Remotes.CommF_:InvokeServer("Alchemist", "3")
            RefreshRace()
        end
    end)

    -- ============================================================
    -- [REBUILT] RACE AWAKENING (= "Race V3") — bị mất sạch RegisterMethod
    -- trong 1 lượt sửa lớn trước đó (chỉ còn :Register() trơ), audit lại
    -- toàn bộ file mới phát hiện. Xây lại từ data verified NatAov +
    -- raw_6.txt + message_10.txt (nguồn MỚI NHẤT, verified nhất).
    -- [FIXED - theo message_10] Thứ tự boss Human THẬT là Jeremy → Diamond
    -- → Orbitus — bản trước tao để SAI thành Orbitus→Jeremy→Diamond. Có cả
    -- toạ độ chờ thật cho từng bước. Dùng Wenlocktoad("1") LÀM STATE DRIVER
    -- (đọc từ server mỗi lần) thay vì cờ nội bộ `_raceAwakenState.started`
    -- dễ bị lệch nếu script restart giữa chừng.
    -- [NEW - theo message_10] Thêm race Mink ("Rabbit" trong Race.Value):
    -- farm 30 cái workspace.ChestModels rồi claim — hoàn toàn không có
    -- trước đây.
    -- Race Fishman: GIỮ NGUYÊN y hệt bản cũ theo đúng yêu cầu ("trừ tộc cá
    -- fishman") — không đụng vào đoạn Sea Beast/skill hotbar bên dưới.
    -- ============================================================
    local _raceAwakenState = {
        humanStage = 0,  -- 0=Jeremy, 1=Diamond, 2=Orbitus, 3=claim
        minkChestsDone = 0,
    }
    local HUMAN_V3_WAIT_CF = {
        [0] = CFrame.new(2333.209228515625, 449.2427062988281, 699.5128784179688),   -- chờ Jeremy
        [1] = CFrame.new(-1713.5589599609375, 198.99554443359375, -104.31584167480469), -- chờ Diamond
        [2] = CFrame.new(-2148.7568359375, 73.27831268310547, -4304.4130859375),     -- chờ Orbitus
    }
    local HUMAN_V3_BOSS_NAME = {[0] = "Jeremy", [1] = "Diamond", [2] = "Orbitus"}

    local function _fightWorldBossV3(bossName, waitCF)
        local live = ScriptStorage.Enemies[bossName]
        if not live then
            SetTask("SubTask", "Race Awakening | Chờ " .. bossName .. " — di chuyển tới điểm hẹn")
            if waitCF then TweenController.Create(waitCF) end
            return false
        end
        local hum = live:FindFirstChildOfClass("Humanoid")
        local hrp = live:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.Health > 0 then
            SetTask("MainTask", "Race Awakening | Fighting " .. bossName)
            TweenController.Create(hrp.CFrame + Vector3.new(0, 30, 0))
            if not LocalPlayer.Character:FindFirstChild("HasBuso") then
                pcall(function() Remotes.CommF_:InvokeServer("Buso") end)
            end
            CombatController.Attack(bossName)
            return false
        end
        return true -- dead
    end

    FunctionsHandler.RaceAwakening:RegisterMethod("Refresh", function()
        if not Config.Items.AutoRaceV3 then return nil end
        local data = LocalPlayer:FindFirstChild("Data")
        if not data or not data:FindFirstChild("Race") then return nil end
        if data.Race:FindFirstChild("Evolved") then return nil end -- đã Awaken rồi
        local raceVal = data.Race.Value
        if raceVal ~= "Human" and raceVal ~= "Fishman" and raceVal ~= "Rabbit" then return nil end
        if (ScriptStorage.PlayerData.Level or 0) < 1400 then return nil end
        if (ScriptStorage.PlayerData.Beli or 0) < 2000000 then return nil end
        local wOk = pcall(function() return Remotes.CommF_:InvokeServer("Wenlocktoad", "3") end)
        local wResult = wOk and Remotes.CommF_:InvokeServer("Wenlocktoad", "3") or nil
        if wResult == -2 then return nil end
        local tOk, tResult = pcall(function() return Remotes.CommF_:InvokeServer("TalkTrevor", "1") end)
        if not tOk or tResult ~= 0 then return nil end
        return true
    end)

    FunctionsHandler.RaceAwakening:RegisterMethod("Start", function()
        local data = LocalPlayer:FindFirstChild("Data")
        if not data or not data:FindFirstChild("Race") then return end
        local race = data.Race.Value

        -- [FIXED] Dùng Wenlocktoad("1") làm state driver thật, đọc lại mỗi
        -- lần thay vì tin cờ nội bộ — khớp state-machine verified message_10
        local check = Remotes.CommF_:InvokeServer("Wenlocktoad", "1")

        if check == 0 then
            SetTask("MainTask", "Race Awakening | Bắt đầu quest (Wenlocktoad)")
            Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
            return
        elseif check == 2 then
            SetTask("MainTask", "Race Awakening | Đủ điều kiện — claim!")
            Remotes.CommF_:InvokeServer("Wenlocktoad", "3")
            return
        elseif check ~= 1 then
            return -- giá trị lạ, chờ vòng sau
        end

        -- check == 1: đang trong giai đoạn đánh boss/farm theo race
        if race == "Human" then
            local stage = _raceAwakenState.humanStage
            if stage >= 3 then
                SetTask("MainTask", "Race Awakening | Hoàn thành 3 boss — claim!")
                Remotes.CommF_:InvokeServer("Wenlocktoad", "3")
                _raceAwakenState.humanStage = 0
                return
            end
            local bossName = HUMAN_V3_BOSS_NAME[stage]
            SetTask("SubTask", "Race Awakening | " .. (stage + 1) .. "/3 " .. bossName)
            if _fightWorldBossV3(bossName, HUMAN_V3_WAIT_CF[stage]) then
                _raceAwakenState.humanStage = stage + 1
            end

        elseif race == "Rabbit" then
            -- [NEW - Mink] Farm 30 ChestModels rồi claim
            local chestFolder = workspace:FindFirstChild("ChestModels")
            if not chestFolder then
                SetTask("SubTask", "Race Awakening | Mink: không tìm thấy ChestModels")
                return
            end
            if _raceAwakenState.minkChestsDone >= 30 then
                SetTask("MainTask", "Race Awakening | Mink: đủ 30 rương — claim!")
                Remotes.CommF_:InvokeServer("Wenlocktoad", "3")
                return
            end
            local chests = chestFolder:GetChildren()
            local idx = _raceAwakenState.minkChestsDone + 1
            local chest = chests[idx]
            if chest and chest:FindFirstChild("WorldPivot") then
                SetTask("MainTask", "Race Awakening | Mink: rương " .. idx .. "/30")
                TweenController.Create(chest.WorldPivot.Position)
                if CaculateDistance(chest.WorldPivot.Position) < 10 then
                    _raceAwakenState.minkChestsDone = _raceAwakenState.minkChestsDone + 1
                end
            else
                SetTask("SubTask", "Race Awakening | Mink: hết rương khả dụng (" .. #chests .. " tổng)")
            end

        elseif race == "Fishman" then
            -- (GIỮ NGUYÊN không đổi — theo đúng yêu cầu loại trừ Fishman)
            SetTask("MainTask", "Race Awakening | Fishman: farm Sea Beast")
            local seaBeasts = Services.Workspace:FindFirstChild("SeaBeasts")
            if not seaBeasts then
                SetTask("SubTask", "⚠️ Không tìm thấy workspace.SeaBeasts — hop thử")
                Hop()
                return
            end
            pcall(function() Remotes.CommF_:InvokeServer("BuyFishmanKarate") end)
            local target = nil
            for _, beast in pairs(seaBeasts:GetChildren()) do
                local h = beast:FindFirstChild("Health")
                local hrp = beast:FindFirstChild("HumanoidRootPart")
                if h and hrp and h.Value > 0 then target = beast break end
            end
            if not target then
                SetTask("SubTask", "Fishman | Chưa thấy Sea Beast, đợi spawn...")
                task.wait(3)
                return
            end
            TweenController.Create(target.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0))
            if CaculateDistance(target.HumanoidRootPart.CFrame) < 15 then
                pcall(function()
                    FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Fishman Karate")
                end)
                SetTask("SubTask", "Fishman | Đang đánh Sea Beast (skill Z/X/C)")
                pcall(function()
                    Services.VirtualInputManager:SendKeyEvent(true, "Z", false, game)
                    task.wait(0.3)
                    Services.VirtualInputManager:SendKeyEvent(false, "Z", false, game)
                end)
            end
        end
    end)

    -- ============================================================
    -- BOSSES TASK
    -- ============================================================
    -- ============================================================
    -- [FIXED] Xác nhận boss chết THẬT — tránh false-positive lúc chuyển
    -- phase (bug boss man báo: đánh "Hải Tặc Đào Hoa" [Cake Prince] qua
    -- phase 2, Parent/Humanoid tạm biến mất trong animation chuyển phase,
    -- code cũ tưởng chết → reset nhầm, bỏ dở boss đang đánh dở).
    -- Giờ: mất dấu / Health<=0 → CHỜ xác nhận liên tục 3 giây, nếu tên đó
    -- xuất hiện sống lại (phase mới) trong lúc chờ thì huỷ reset, đánh tiếp.
    -- ============================================================
    local function ConfirmBossDead(bossName)
        -- [FIXED - bớt delay theo yêu cầu boss man] 3×1s (3.0s tổng) →
        -- 6×0.3s (1.8s tổng). KHÔNG rút bằng cách giảm số lần check xuống —
        -- làm vậy sẽ yếu lại đúng cái bug false-positive từng fix. Thay vào
        -- đó tăng gấp đôi số lần poll (3→6) trong khi tổng thời gian NGẮN
        -- hơn 40% — vừa nhanh hơn vừa bắt "sống lại giữa chừng" nhạy hơn.
        for _ = 1, 6 do
            task.wait(0.3)
            local stillThere = ScriptStorage.Enemies[bossName]
            if stillThere and stillThere:FindFirstChild("Humanoid") and stillThere.Humanoid.Health > 0 then
                return false -- sống lại (chuyển phase) — KHÔNG phải chết thật
            end
        end
        return true -- 1.8s liên tục không thấy sống lại — chắc chắn chết
    end

    FunctionsHandler.BossesTask:RegisterMethod("Refresh", function()
        local k
        for h, h in BossesOrder do
            -- [FIXED] Thêm gate Config.BossWeapons — trước đây không có cách
            -- nào tắt farm 1 boss cụ thể, giờ set Config.BossWeapons[name]=false là bỏ qua
            if Config.BossWeapons[h] ~= false then
                local X = BossesOrderLevel[h]
                if ScriptStorage.PlayerData.Level >= X then
                    local X = ScriptStorage.Enemies[h]
                    if X and X:FindFirstChild("Humanoid") and X.Humanoid.Health > 0 then k = X end
                end
            end
        end
        if k and (CaculateDistance(k.HumanoidRootPart.CFrame) < (SeaIndex == 2 and 3000 or 5000) or BossesOrderWL[tostring(k)] or ScriptStorage.PlayerData.Level == MaxLevel) then
            return k
        end
    end)

    FunctionsHandler.BossesTask:RegisterMethod('Start', function(k)
        if k then
            SetTask("MainTask", "Auto Farm Boss - Defeating " .. k.Name)
            SetTask('SubTask', '👑 Boss: ' .. k.Name .. ' | HP: ' .. math.floor(k.Humanoid.Health / k.Humanoid.MaxHealth * 100) .. '%')
            CombatController.Attack(tostring(k), null, null, function() SpecialItems = nil end)
            SpecialItems = nil

            -- [ADDED] "Reset teleport về farm level tiếp" — boss man yêu cầu:
            -- sau khi hạ xong, reset nhân vật (respawn) để đảm bảo LevelFarm
            -- tiếp tục sạch sẽ thay vì có thể bị kẹt vị trí/trạng thái combat
            pcall(function()
                if k.Parent == nil or (k:FindFirstChild("Humanoid") and k.Humanoid.Health <= 0) then
                    -- [FIXED] Xác nhận chết thật trước khi reset (tránh false-positive lúc chuyển phase)
                    if ConfirmBossDead(k.Name) then
                        SetTask('SubTask', '✅ Đã hạ ' .. k.Name .. ' — reset về farm level')
                        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum.Health = 0
                            LocalPlayer.CharacterAdded:Wait()
                        end
                    else
                        SetTask('SubTask', k.Name .. ' đang chuyển phase — tiếp tục đánh')
                    end
                end
            end)
        end
    end)

    -- ============================================================
    -- SPECIAL BOSSES TASK
    -- ============================================================
    FunctionsHandler.SpecialBossesTask:RegisterMethod('Refresh', function()
        local k
        for h, X in SpecialBossesOrder do
            -- [FIXED] Cùng gate Config.BossWeapons như BossesTask
            if Config.BossWeapons[h] ~= false and ScriptStorage.PlayerData.Level >= X then
                local X = ScriptStorage.Enemies[h]
                if X and X:FindFirstChild('Humanoid') and X.Humanoid.Health > 0 then k = X end
            end
        end
        -- [ADDED] Không thấy boss nào lên → farm Bones nhẹ nhàng ở nền
        -- (fire-and-forget, KHÔNG return true nên LevelFarm vẫn chạy bình
        -- thường) — Bones là nguyên liệu Fire Essence (Dragon Talon) VÀ
        -- theo nat kaitun cũng liên quan tới tỉ lệ Soul Reaper xuất hiện
        if not k then
            pcall(function()
                local bonesCheck = Remotes.CommF_:InvokeServer("Bones", "Check")
                if bonesCheck and bonesCheck > 0 then
                    Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                end
            end)
        end
        return k
    end)

    FunctionsHandler.SpecialBossesTask:RegisterMethod('Start', function(k)
        if FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
            pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
        end
        if k then
            SetTask('MainTask', "Auto Farm Boss - Defeating " .. k.Name)
            SetTask('SubTask', '👾 Special Boss: ' .. k.Name)
            CombatController.Attack(tostring(k))

            -- [ADDED] Cùng logic reset như BossesTask — hạ xong Katakuri/
            -- Core/Darkbeard thì reset về farm level bình thường
            pcall(function()
                if k.Parent == nil or (k:FindFirstChild("Humanoid") and k.Humanoid.Health <= 0) then
                    -- [FIXED] Xác nhận chết thật trước khi reset (tránh false-positive lúc chuyển phase)
                    if ConfirmBossDead(k.Name) then
                        SetTask('SubTask', '✅ Đã hạ ' .. k.Name .. ' — reset về farm level')
                        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum.Health = 0
                            LocalPlayer.CharacterAdded:Wait()
                        end
                    else
                        SetTask('SubTask', k.Name .. ' đang chuyển phase — tiếp tục đánh')
                    end
                end
            end)
        end
    end)

    -- ============================================================
    -- RAID CONTROLLER
    -- ============================================================
    -- ============================================================
    -- [NEW] getInventoryFruits — đọc trực tiếp ItemConfig/FruitInfo,
    -- không qua remote round-trip, có sẵn Rarity để lọc
    -- ============================================================
    local function getInventoryFruits()
        local fruits = {}
        local inventory = require(ReplicatedStorage.ItemConfig):GetItems(ReplicatedStorage.ItemConfig.KEYS.QUANTITY)
        for _, item in pairs(inventory) do
            if item.Value and item.Value > 0 then
                local _, data = pcall(function()
                    return ReplicatedStorage.FruitInfo.List[item.ItemId]
                end)
                if data then
                    local name = data.Display.Name or item.ItemId
                    local rarity = data.Rarity and data.Rarity.Name or "Unknown"
                    local value = data.Price or 0
                    table.insert(fruits, {Name = name, Rarity = rarity, Value = value})
                end
            end
        end
        return fruits
    end

    -- [NEW] Chọn trái để bán/dùng mua chip: ưu tiên Common/Uncommon + giá
    -- thấp nhất; nếu không có trái Common/Uncommon nào thì lấy trái rẻ
    -- nhất trong kho bất kể rarity
    local function PickFruitToSpend()
        local ok, fruits = pcall(getInventoryFruits)
        if not ok or not fruits or #fruits == 0 then return nil end

        local commonUncommon = {}
        for _, f in ipairs(fruits) do
            if f.Rarity == "Common" or f.Rarity == "Uncommon" then
                table.insert(commonUncommon, f)
            end
        end

        local pool = #commonUncommon > 0 and commonUncommon or fruits
        table.sort(pool, function(a, b) return (a.Value or 0) < (b.Value or 0) end)
        return pool[1]
    end

    -- ============================================================
    -- ============================================================
    -- [NEW] SWORD BOSS TASK — farm boss lấy sword, 100% verified từ
    -- file_kaitun_dự_phòng.lua (Configs["Sword"] + CheckBoss + "gi" check)
    -- Có sẵn check inventory: đã có sword đó rồi thì bỏ qua, không đánh nữa
    -- ============================================================
    local SwordBossList = {
        {sword = "Shark Saw",       boss = "The Saw",              sea = 1, level = 100},
        {sword = "Wardens Sword",   boss = "Chief Warden",         sea = 1, level = 100},
        {sword = "Pole (1st Form)", boss = "Thunder God",          sea = 1, level = 100},
        {sword = "Gravity Blade",   boss = "Orbitus",               sea = 2, level = 800},
        {sword = "Longsword",       boss = "Diamond",               sea = 2, level = 800},
        {sword = "Rengoku",         boss = "Awakened Ice Admiral",  sea = 2, level = 800},
        {sword = "Flail",           boss = "Smoke Admiral",         sea = 2, level = 0},
        {sword = "Twin Hooks",      boss = "Captain Elephant",      sea = 3, level = 0},
    }
    -- Toạ độ dùng Hidden Key / Library Key mở khoá Rengoku (verified)
    local HIDDEN_KEY_CF  = CFrame.new(6572.29248, 295.712677, -6966.09961)
    local LIBRARY_KEY_CF = CFrame.new(6377.12549, 296.634735, -6843.76025)

    FunctionsHandler.SwordBossTask:RegisterMethod("Refresh", function()
        for _, sw in ipairs(SwordBossList) do
            -- [NEW] Check inventory liên tục — có sword rồi thì bỏ qua
            -- (đúng yêu cầu boss man: "check inventory ... nếu có ko đánh nữa")
            if Config.Sword[sw.sword] and not CheckItem(sw.sword)
                and SeaIndex == sw.sea and (ScriptStorage.PlayerData.Level or 0) >= sw.level then
                local boss = ScriptStorage.Enemies[sw.boss]
                if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    return sw
                end
            end
        end
        -- Riêng Rengoku: có thêm 2 đường phụ qua Hidden Key / Library Key
        -- (không cần boss đang sống, chỉ cần đang cầm chìa + ở Sea 2)
        if Config.Sword["Rengoku"] and not CheckItem("Rengoku") and SeaIndex == 2 then
            if CheckItem("Hidden Key") or CheckItem("Library Key") then
                return {sword = "Rengoku", useKey = true}
            end
        end
        return nil
    end)

    FunctionsHandler.SwordBossTask:RegisterMethod("Start", function(sw)
        if not sw then return end

        if sw.useKey then
            local keyName = CheckItem("Hidden Key") and "Hidden Key" or "Library Key"
            local cf = keyName == "Hidden Key" and HIDDEN_KEY_CF or LIBRARY_KEY_CF
            SetTask("MainTask", "Sword Boss | Dùng " .. keyName .. " mở Rengoku")
            TweenController.Create(cf)
            if CaculateDistance(cf) <= 5 then
                FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(keyName)
            end
            return
        end

        local boss = ScriptStorage.Enemies[sw.boss]
        if not boss then return end

        SetTask("MainTask", "Sword Boss | Đánh " .. sw.boss .. " lấy " .. sw.sword)
        if boss:FindFirstChild("HumanoidRootPart") then
            TweenController.Create(boss.HumanoidRootPart.CFrame + Vector3.new(0, 30, 0))
        end
        CombatController.Attack(sw.boss)

        -- [ADDED] Hạ xong → reset về farm level, giống pattern các boss khác
        pcall(function()
            if boss.Parent == nil or (boss:FindFirstChild("Humanoid") and boss.Humanoid.Health <= 0) then
                if ConfirmBossDead(sw.boss) then
                    SetTask('SubTask', '✅ Đã hạ ' .. sw.boss .. ' — reset về farm level')
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.Health = 0
                        LocalPlayer.CharacterAdded:Wait()
                    end
                else
                    SetTask('SubTask', sw.boss .. ' đang chuyển phase — tiếp tục đánh')
                end
            end
        end)
    end)


    -- Cake Prince [Lv. 2300] [Raid Boss] (Sea 3, đảo CakeLoaf)
    -- [FIXED - theo spec mới] TRƯỚC ĐÂY dùng để farm Fragment (gate bởi
    -- Fragments > 5000) — spec mới yêu cầu XOÁ HẲN mục đích đó, "chỉ dùng
    -- raid để lấy Fragment". Cake Prince giờ CHỈ dùng để farm MASTERY cho
    -- melee đang tập (V1 cần 500, V2 cần 400) — giết Cake Prince với vũ
    -- khí đang tập cho mastery tăng nhanh hơn quái thường.
    -- ============================================================
    local CAKE_AREA_CF   = CFrame.new(-2077, 252, -12373)        -- đảo CakeLoaf nói chung
    local CAKE_BOSS_CF   = CFrame.new(-2151.82, 149.32, -12404.91) -- chỗ Cake Prince xuất hiện
    local CAKE_UNLOCK_MOBS = {"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}

    -- [NEW] Xác định melee nào đang cần train mastery — dùng chung giữa
    -- CakePrinceTask và MeleesController để đồng bộ (train đúng cái đang
    -- thiếu, theo đúng thứ tự V1 → V2 spec yêu cầu)
    local MASTERY_TRAIN_ORDER = {
        {name = "Black Leg",       target = 500, tier = "V1"},
        {name = "Electro",         target = 500, tier = "V1"},
        {name = "Fishman Karate",  target = 500, tier = "V1"},
        {name = "Dragon Claw",     target = 500, tier = "V1"},
        {name = "Superhuman",      target = 500, tier = "V1"},
        {name = "Death Step",      target = 400, tier = "V2"},
        {name = "Sharkman Karate", target = 400, tier = "V2"},
        {name = "Electric Claw",   target = 400, tier = "V2"},
        {name = "Dragon Talon",    target = 400, tier = "V2"},
    }

    function GetCurrentTrainingMelee()
        for _, m in ipairs(MASTERY_TRAIN_ORDER) do
            if CheckItem(m.name) then
                local mastery = ScriptStorage.Melees[m.name] or 0
                if mastery < m.target then
                    return m.name, mastery, m.target
                end
            end
        end
        return nil
    end

    FunctionsHandler.CakePrinceTask:RegisterMethod("Refresh", function()
        if SeaIndex ~= 3 then return nil end
        if (ScriptStorage.PlayerData.Level or 0) < 1500 then return nil end
        -- [FIXED] Gate bằng "có melee nào đang cần train mastery không",
        -- KHÔNG còn gate bằng Fragments nữa
        local trainingName = GetCurrentTrainingMelee()
        if not trainingName then return nil end
        return trainingName
    end)

    FunctionsHandler.CakePrinceTask:RegisterMethod("Start", function(trainingName)
        if not trainingName then return end
        local mastery, target = ScriptStorage.Melees[trainingName] or 0, nil
        for _, m in ipairs(MASTERY_TRAIN_ORDER) do
            if m.name == trainingName then target = m.target break end
        end

        -- [NEW] Check mastery mỗi vòng — đạt ngưỡng thì dừng farm, để
        -- Refresh() vòng sau tự chuyển qua melee tiếp theo cần train
        if mastery >= (target or 500) then
            SetTask("SubTask", "✅ " .. trainingName .. " đạt " .. mastery .. " mastery — chuyển melee tiếp theo")
            return
        end

        -- [NEW] Trang bị đúng melee đang cần train trước khi đánh, để
        -- damage tính mastery cho ĐÚNG vũ khí
        pcall(function()
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(trainingName)
        end)

        local cakeLoaf  = workspace.Map:FindFirstChild("CakeLoaf")
        local bigMirror = cakeLoaf and cakeLoaf:FindFirstChild("BigMirror")
        local enemies   = workspace.Enemies

        -- Chưa tới đảo Cake → tp tới trước
        if not cakeLoaf then
            SetTask("MainTask", "Cake Mastery | " .. trainingName .. " (" .. mastery .. "/" .. (target or 500) .. ") — di chuyển tới đảo Cake")
            TweenController.Create(CAKE_AREA_CF)
            return
        end

        local mirrorOpen = bigMirror and bigMirror:FindFirstChild("Other") and bigMirror.Other.Transparency == 0
        local bossUp     = enemies:FindFirstChild("Cake Prince")

        if mirrorOpen or bossUp then
            -- Gương đã mở HOẶC boss đã lên → đánh (mastery tăng nhanh)
            local boss = enemies:FindFirstChild("Cake Prince")
            if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                SetTask("MainTask", "Cake Mastery | " .. trainingName .. " (" .. mastery .. "/" .. (target or 500) .. ") | Cake Prince HP " .. math.floor(boss.Humanoid.Health / boss.Humanoid.MaxHealth * 100) .. "%")
                TweenController.Create(boss.HumanoidRootPart.CFrame + Vector3.new(0, 30, 0))
                CombatController.Attack("Cake Prince")

                -- [ADDED] Hạ xong → reset về farm bình thường, giống pattern
                -- BossesTask/SpecialBossesTask đã làm trước đó
                pcall(function()
                    if boss.Parent == nil or boss.Humanoid.Health <= 0 then
                        -- [FIXED] Đây chính xác là case boss man báo — Cake Prince
                        -- ("Hải Tặc Đào Hoa") chuyển phase 2, code cũ tưởng chết
                        if ConfirmBossDead("Cake Prince") then
                            SetTask('SubTask', '✅ Đã hạ Cake Prince — reset về farm level')
                            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                            if hum then
                                hum.Health = 0
                                LocalPlayer.CharacterAdded:Wait()
                            end
                        else
                            SetTask('SubTask', 'Cake Prince đang chuyển phase — tiếp tục đánh')
                        end
                    end
                end)
            else
                TweenController.Create(CAKE_BOSS_CF)
            end
            return
        end

        -- Gương chưa mở, boss chưa lên → farm quái thường lấy mastery +
        -- check tiến độ mở khoá (đủ thì tự trigger spawn Cake Prince)
        SetTask("MainTask", "Cake Mastery | " .. trainingName .. " (" .. mastery .. "/" .. (target or 500) .. ") — farm quái thường")
        local killedStr = Remotes.CommF_:InvokeServer("CakePrinceSpawner")
        local killed = killedStr and tonumber(tostring(killedStr):match("%d+")) or 0
        local remaining = math.max(0, 500 - killed)

        if remaining <= 0 then
            SetTask("MainTask", "Cake Mastery | Đủ điều kiện — đang triệu hồi Cake Prince")
            Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
            task.wait(1)
            return
        end

        -- Chưa đủ → farm quái mở khoá
        SetTask("MainTask", "Cake Prince | Farm quái mở khoá — còn " .. remaining .. "/500")
        local mob = nil
        for _, mobName in ipairs(CAKE_UNLOCK_MOBS) do
            local m = enemies:FindFirstChild(mobName)
            if m and m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 then mob = m break end
        end
        if mob then
            TweenController.Create(mob.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))
            CombatController.Attack(CAKE_UNLOCK_MOBS)
        else
            TweenController.Create(CAKE_AREA_CF)
        end
    end)


    FunctionsHandler.RaidController:RegisterMethod("RefreshRaidType", function()
        for k, k in require(game.ReplicatedStorage.Raids).raids do
            if string.find(ScriptStorage.PlayerData.DevilFruit, k) then
                FunctionsHandler.RaidController:Set('CurrentChip', k)
                return
            end
        end
        FunctionsHandler.RaidController:Set('CurrentChip', 'Flame')
    end)

    FunctionsHandler.RaidController:RegisterMethod('GetRaidableFruit', function()
        -- [FIXED] Trước đây lấy trái ĐẦU TIÊN tìm thấy dưới 1tr Beli, không
        -- quan tâm rarity — dễ lỡ tay bán nhầm trái đắt/hiếm nếu nó đứng
        -- trước trong Backpack. Giờ dùng PickFruitToSpend(): ưu tiên
        -- Common/Uncommon + rẻ nhất, fallback rẻ nhất toàn kho nếu không có.
        local picked = PickFruitToSpend()
        if picked then
            for k, k in ScriptStorage.Backpack do
                if k.Name == picked.Name then return k end
            end
        end
        -- fallback về logic cũ nếu getInventoryFruits() lỗi vì lý do gì đó
        for k, k in ScriptStorage.Backpack do
            if string.find(FruitIdToName(k.Name), " Fruit") then
                if k.Value and k.Value < 1000000 then return k end
            end
        end
    end)

    FunctionsHandler.RaidController:RegisterMethod("GetCurrentRaidIsland", function()
        local IslandsList = {{}, {}, {}, {}, {}}
        for k, k in workspace['_WorldOrigin'].Locations:GetChildren() do
            if string.find(k.Name, 'Island ') and CaculateDistance(k.Position, Vector3.new(0, 0, 0)) > 7000 then
                local h = string.gsub(k.Name, "Island ", "")
                local X = tonumber(h)
                table.insert(IslandsList[X], k)
            end
        end
        for k = 5, 1, -1 do
            for h, h in IslandsList[k] do if CaculateDistance(h.Position) < 2000 then return h end end
        end
        return nil
    end)

    function CheckSpecialMicrochip()
        local bp = LocalPlayer:FindFirstChild("Backpack")
        for _, h in {LocalPlayer.Character:GetChildren(), bp and bp:GetChildren() or {}} do
            for _, X in h do if X.Name == "Special Microchip" then return X end end
        end
        return nil
    end

    FunctionsHandler.RaidController:RegisterMethod("Refresh", function()
        local lv = ScriptStorage.PlayerData.Level or 0
        if lv < 1300 then return nil end
        if CheckSpecialMicrochip() then return nil end
        local fr = ScriptStorage.PlayerData.Fragments or 0
        if lv < 1500 and fr > 2000 then return nil end
        if lv < MaxLevel and fr > 5000 then return nil end
        if lv >= MaxLevel and fr > 10000 then return nil end
        local fruit = FunctionsHandler.RaidController.Methods.GetRaidableFruit:Call()
        if fruit then FunctionsHandler.RaidController:Set("CurrentProgressLevel", fruit) end
        return fruit or FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() or CheckSpecialMicrochip()
    end)

    FunctionsHandler.RaidController:RegisterMethod("Start", function()
        if not FunctionsHandler.RaidController:Get('CurrentChip') then FunctionsHandler.RaidController.Methods.RefreshRaidType:Call() end
        local k = FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
        RefreshInventory()
        FunctionsHandler.RaidController:Set("CurrentProgressLevel", nil)
        if not k then
            SetTask('MainTask', 'Auto Raid - Buying Chip - ' .. FunctionsHandler.RaidController:Get("CurrentChip"))
            if not ScriptStorage.Tools['Special Microchip'] then
                local h = FunctionsHandler.RaidController.Methods.GetRaidableFruit:Call()
                table.insert(ScriptStorage.IgnoreStoreFruits, h.Name)
                alert('Load Fruit', h.Name)
                Remotes.CommF_:InvokeServer('LoadFruit', h.Name)
                Remotes.CommF_:InvokeServer("RaidsNpc", 'Select', FunctionsHandler.RaidController:Get('CurrentChip'))
                task.wait(2)
            end
            local h = ({nil, 'Circle Island', "Boat Castle"})[SeaIndex]
            if not ScriptStorage.Map[h] and not ScriptStorage.Map[h] then
                task.wait(1)
                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
            end
            if not ScriptStorage.Map[h]:FindFirstChild('RaidSummon2') then
                task.wait(1)
                TweenController.Create(ScriptStorage.Map[h]:GetModelCFrame() or ScriptStorage.Map[h]:GetModelCFrame())
            end
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Special Microchip')
            fireclickdetector((ScriptStorage.Map[h] or workspace.Map:FindFirstChild(h) or workspace:FindFirstChild(h)).RaidSummon2.Button.Main.ClickDetector)
            local h = os.time()
            SetTask("MainTask", "Auto Raid - Waiting Until Raid Is Started")
            repeat task.wait() until os.time() - (LastRaidAlert2 or 0) < 20 or os.time() - h > 30
            TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
            repeat task.wait() until os.time() - (LastRaidAlert or 0) < 20 or os.time() - h > 30
            alert('cac', "Tween Paused")
            task.wait(.5)
            if os.time() - h > 30 then
                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
                SetTask('MainTask', "Auto Raid - Raid Is Not Stared?")
                Report('[ Raid Error ] Time Limit Reached')
            end
            LastRaidAlert = 0
        else
            SetTask('MainTask', "Auto Raid - " .. k.Name .. " /5")
            SetTask('SubTask', 'Raid Island ' .. k.Name .. ' | Clearing wave...')
            local islandNum = tonumber(string.match(k.Name, "(%d+)"))
            if islandNum and islandNum >= 4 then
                TweenController.Create(k.Position + Vector3.new(0, 50, 0))
                task.wait(0.5)
                for _, v in workspace.Enemies:GetChildren() do
                    pcall(function()
                        if v:FindFirstChild("Humanoid") then v.Humanoid.Health = 0 end
                        if v:FindFirstChild("HumanoidRootPart") then v.HumanoidRootPart.CanCollide = false end
                        v:BreakJoints()
                    end)
                end
            else
                local h = false
                for X, X in GetMonAsSortedRange() do
                    local w = os.time()
                    while X and X:FindFirstChild("HumanoidRootPart") and X.Humanoid.Health > 0 and CaculateDistance(X.HumanoidRootPart.Position) < 1000 and os.time() - w < 60 and task.wait(.05) do
                        h = true
                        if string.find(X.Name, "Master") or true then
                            CombatController.Attack(X.Name)
                        else
                            pcall(sethiddenproperty, LocalPlayer, 'SimulationRadius', math.huge)
                            pcall(function()
                                X.HumanoidRootPart.CanCollide = false
                                X.Humanoid.Health = 0
                                X:BreakJoints()
                            end)
                        end
                    end
                end
                if not h then TweenController.Create(k.Position + Vector3.new(0, 100, 0)) end
            end
        end
    end)

    -- ============================================================
    -- AUTO RAID ICE
    -- ============================================================
    local RAID_ICE_CHIP_COOLDOWN = 2 * 60 * 60

    -- [NEW] 2 helper lấy từ Moonlight_New_Public_source.lua (chỉ lấy LOGIC,
    -- bỏ hết toggle/UI của nó) — dùng để làm AutoRaidIce đáng tin cậy hơn:
    -- 1. TriggerInteractive: bấm nút raid summon bằng CẢ ProximityPrompt
    --    LẪN ClickDetector (tìm đệ quy) — code cũ chỉ cứng path ClickDetector
    --    1 chỗ, nếu game đổi qua ProximityPrompt thì "Khong tim thay button"
    --    dù nút vẫn ở đó.
    -- 2. RaidTimerActive: check trực tiếp PlayerGui.Main.TopHUDList.RaidTimer
    --    .Visible — biết NGAY raid đã bắt đầu hay chưa, không cần đợi
    --    notification 'go!'/'raid' bắn ra (vẫn giữ 2 cái đó làm dự phòng).
    local function TriggerInteractive(object)
        if not object then return false end
        local prompt = object:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt and typeof(fireproximityprompt) == "function" then
            local ok = pcall(fireproximityprompt, prompt)
            if ok then return true end
        end
        local click = object:FindFirstChildWhichIsA("ClickDetector", true)
        if click and typeof(fireclickdetector) == "function" then
            local ok = pcall(fireclickdetector, click)
            if ok then return true end
        end
        return false
    end

    local function RaidTimerActive()
        local ok, result = pcall(function()
            local gui  = LocalPlayer:FindFirstChild("PlayerGui")
            local main = gui and gui:FindFirstChild("Main")
            local top  = main and main:FindFirstChild("TopHUDList")
            local timer = top and top:FindFirstChild("RaidTimer")
            return timer and timer.Visible or false
        end)
        return ok and result or false
    end


    FunctionsHandler.AutoRaidIce:RegisterMethod("GetCheapestFruit", function(maxPrice)
        maxPrice = maxPrice or 1000000
        local ok1, fruitPrices = pcall(function() return Remotes.CommF_:InvokeServer("GetFruits") end)
        local ok2, inventoryFruits = pcall(function() return Remotes.CommF_:InvokeServer("getInventoryFruits") end)
        if not ok1 or not ok2 then return nil end
        local priceMap = {}
        for _, v in pairs(fruitPrices) do
            if v.Price and v.Price <= maxPrice then
                priceMap[v.Name] = v.Price
            end
        end
        local cheapest, lowestPrice = nil, math.huge
        for _, fruitData in pairs(inventoryFruits) do
            local name = fruitData.Name
            if name and priceMap[name] and priceMap[name] < lowestPrice then
                lowestPrice = priceMap[name]
                cheapest = name
            end
        end
        return cheapest, lowestPrice
    end)

    FunctionsHandler.AutoRaidIce:RegisterMethod("KillAura", function()
        local currentIsland = FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
        pcall(sethiddenproperty, LocalPlayer, 'SimulationRadius', math.huge)
        for _, v in pairs(workspace.Enemies:GetChildren()) do
            pcall(function()
                if currentIsland then
                    local dist = CaculateDistance(v.HumanoidRootPart.Position, currentIsland.Position)
                    if dist > 1500 then return end
                end
                if v:FindFirstChild("Humanoid") then v.Humanoid.Health = 0 end
                if v:FindFirstChild("HumanoidRootPart") then v.HumanoidRootPart.CanCollide = false end
                v:BreakJoints()
            end)
        end
    end)

    FunctionsHandler.AutoRaidIce:RegisterMethod("BuyChip", function()
        local lastBuy = Storage:Get("RaidIceLastChipBuy") or 0
        if os.time() - lastBuy < RAID_ICE_CHIP_COOLDOWN then return false end
        local fruitName = FunctionsHandler.AutoRaidIce.Methods.GetCheapestFruit:Call(1000000)
        if fruitName then
            SetTask('MainTask', 'Auto Raid Ice | Mua chip bang trai ' .. fruitName)
            table.insert(ScriptStorage.IgnoreStoreFruits, fruitName)
            Remotes.CommF_:InvokeServer('LoadFruit', fruitName)
            task.wait(0.5)
            Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Ice")
            task.wait(1)
            RefreshInventory()
            if CheckSpecialMicrochip() then
                Storage:Set("RaidIceLastChipBuy", os.time())
                Storage:Save()
                return true
            else
                for i = 1, 2 do
                    task.wait(2)
                    Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Ice")
                    task.wait(1)
                    RefreshInventory()
                    if CheckSpecialMicrochip() then
                        Storage:Set("RaidIceLastChipBuy", os.time())
                        Storage:Save()
                        return true
                    end
                end
                SetTask('MainTask', 'Auto Raid Ice | Mua chip that bai')
                return false
            end
        elseif (ScriptStorage.PlayerData.Beli or 0) >= 100000 then
            SetTask('MainTask', 'Auto Raid Ice | Mua chip bang Beli')
            Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Ice")
            task.wait(1)
            RefreshInventory()
            if CheckSpecialMicrochip() then
                Storage:Set("RaidIceLastChipBuy", os.time())
                Storage:Save()
                return true
            end
            return false
        end
        SetTask('MainTask', 'Auto Raid Ice | Khong du tai nguyen mua chip')
        return false
    end)

    FunctionsHandler.AutoRaidIce:RegisterMethod("Refresh", function()
        local lv = ScriptStorage.PlayerData.Level or 0
        local fr = ScriptStorage.PlayerData.Fragments or 0
        local target = Config.AutoRaidIce_TargetFragments or 5000
        if lv < 1300 then return nil end
        if fr >= target then
            SetTask('MainTask', 'Raid Ice | Da dat target: ' .. fr .. '/' .. target)
            return nil
        end
        local hasChip = CheckSpecialMicrochip() ~= nil
        local onRaid = FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
        if onRaid then return true end
        if hasChip then return true end
        local lastBuy = Storage:Get("RaidIceLastChipBuy") or 0
        if os.time() - lastBuy >= RAID_ICE_CHIP_COOLDOWN then return true end
        return nil
    end)

    FunctionsHandler.AutoRaidIce:RegisterMethod("Start", function()
        local currentIsland = FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
        local target = Config.AutoRaidIce_TargetFragments or 5000
        local fr = ScriptStorage.PlayerData.Fragments or 0
        if fr >= target then
            SetTask('MainTask', 'Raid Ice | Da dat target fragments')
            return
        end
        if currentIsland then
            local islandNum = tonumber(string.match(currentIsland.Name, "(%d+)"))
            SetTask('MainTask', 'Raid Ice | Fragments: ' .. fr .. '/' .. target .. ' | Dao ' .. (islandNum or "?") .. '/5')
            SetTask('SubTask', 'Raid Ice | Clearing island ' .. (islandNum or "?"))
            if islandNum and islandNum >= 3 then
                SetTask('MainTask', 'Raid Ice | Dao ' .. islandNum .. ' | Kill Aura')
                FunctionsHandler.AutoRaidIce.Methods.KillAura:Call()
                TweenController.Create(currentIsland.Position + Vector3.new(0, 50, 0))
                task.wait(1)
            else
                local hasEnemy = false
                for _, v in GetMonAsSortedRange() do
                    if CaculateDistance(v.HumanoidRootPart.Position) < 1500 then
                        hasEnemy = true
                        CombatController.Attack(v.Name)
                        break
                    end
                end
                if not hasEnemy then
                    TweenController.Create(currentIsland.Position + Vector3.new(0, 100, 0))
                end
            end
            return
        end
        if not CheckSpecialMicrochip() then
            local bought = FunctionsHandler.AutoRaidIce.Methods.BuyChip:Call()
            if not bought then return end
            task.wait(2)
            RefreshInventory()
        end
        if not CheckSpecialMicrochip() then return end
        local mapName = ({nil, 'Circle Island', 'Boat Castle'})[SeaIndex]
        if not mapName then return end
        local mapObj = ScriptStorage.Map[mapName]
        if not mapObj then
            Report('[AutoRaidIce] Khong tim thay Map: ' .. mapName)
            return
        end
        local summonCFrame
        if SeaIndex == 2 then summonCFrame = CFrame.new(-6438.73, 250.64, -4501.50)
        elseif SeaIndex == 3 then summonCFrame = CFrame.new(-5097.93, 316.44, -3142.66) end
        if summonCFrame then
            SetTask('MainTask', 'Raid Ice | Di den summon button')
            TweenController.Create(summonCFrame)
            local t0 = tick()
            repeat task.wait(0.3) until CaculateDistance(summonCFrame) < 25 or tick()-t0 > 20
        end
        if not mapObj:FindFirstChild('RaidSummon2') then
            TweenController.Create(mapObj:GetModelCFrame())
            task.wait(1)
            return
        end
        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Special Microchip')
        local btn = (mapObj or workspace.Map:FindFirstChild(mapName) or workspace:FindFirstChild(mapName))
        local summonObj = btn and btn:FindFirstChild("RaidSummon2")
        local clickSuccess = false
        for retry = 1, 3 do
            if retry > 1 then task.wait(3) end
            pcall(function()
                -- [FIXED] Dùng TriggerInteractive thay vì chỉ fireclickdetector
                -- cứng 1 path — bắt được cả ProximityPrompt lẫn ClickDetector
                if summonObj and TriggerInteractive(summonObj) then
                    clickSuccess = true
                    SetTask('MainTask', 'Raid Ice | Da click start (lan ' .. retry .. ')')
                else
                    SetTask('MainTask', 'Raid Ice | Khong tim thay button (lan ' .. retry .. ')')
                end
            end)
            if clickSuccess then break end
        end
        if not clickSuccess then
            SetTask('MainTask', 'Raid Ice | Khong the click start')
            return
        end
        SetTask('MainTask', 'Raid Ice | Cho raid bat dau...')
        local raidStarted = false
        for attempt = 1, 3 do
            if attempt > 1 then
                SetTask('MainTask', 'Raid Ice | Thu lai lan ' .. attempt)
                pcall(function()
                    if summonObj then TriggerInteractive(summonObj) end
                end)
            end
            local h = os.time()
            repeat task.wait(0.5) until
                RaidTimerActive() or
                os.time() - (LastRaidAlert2 or 0) < 20 or
                os.time() - (LastRaidAlert or 0) < 20 or
                os.time() - h > 35
            if os.time() - h <= 35 then
                raidStarted = true
                break
            end
        end
        if raidStarted then
            LastRaidAlert = 0
            SetTask('MainTask', 'Raid Ice | Raid bat dau!')
        else
            Report('[AutoRaidIce] Raid khong bat dau')
            SetTask('MainTask', 'Raid Ice | Raid khong bat dau, thu lai sau...')
        end
    end)

    -- ============================================================
    -- COLLECT DROPS
    -- ============================================================
    FunctionsHandler.CollectDrops:RegisterMethod("Refresh", function()
        local k = {}
        for h in ScriptStorage.Backpack do k[FruitIdToName(h)] = h end
        for h, h in workspace:GetChildren() do
            if string.find(h.Name, 'Fruit') and not a:FindFirstChild(h.Name) and h:FindFirstChild("Handle") and not k[tostring(h)] and not ScriptStorage.Backpack[FruitNameToId(tostring(h))] then
                FunctionsHandler.CollectDrops:Set('CurrentProgressLevel', h)
                return h
            end
        end
    end)

    FunctionsHandler.CollectDrops:RegisterMethod('Start', function()
        local k = FunctionsHandler.CollectDrops:Get('CurrentProgressLevel')
        FunctionsHandler.CollectDrops:Set('CurrentProgressLevel', nil)
        if k then
            SetTask('SubTask', '📦 Collecting: ' .. tostring(k))
            SetTask("MainTask", "Auto Collect Drop Items - " .. tostring(k))
            TweenController.Create(k:GetModelCFrame())
        end
    end)

    -- ============================================================
    -- UTILLY ITEMS ACTIVATION
    -- ============================================================
    FunctionsHandler.UtillyItemsActivitation:RegisterMethod('Refresh', function()
        if os.time() - timeee < 20 then return end
        if not SpecialItems then
            SpecialItems = {}
            local k = {}
            IceAdmiralPassed = true
            if not ScriptStorage.Backpack.Rengoku then
                table.insert(SpecialItems, "Hidden Key")
                IceAdmiralPassed = false
            end
            if SeaIndex == 2 and Services.Workspace.Map.IceCastle.Hall.LibraryDoor:FindFirstChild("PhoeyuDoor") then
                table.insert(SpecialItems, 'Library Key')
                IceAdmiralPassed = false
            end
            if IceAdmiralPassed then table.insert(k, 'Awakened Ice Admiral') end
            local h = not ScriptStorage.Melees['Sharkman Karate'] and Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
            SharkmanPassed = typeof(h) == 'string'
            if typeof(h) == "string" then
                table.insert(SpecialItems, 'Water Key')
            else
                TidePassed = true
                table.insert(k, 'Tide Keeper')
            end
            if ScriptStorage.Backpack.Yama then
                table.insert(k, "Deandre")
                table.insert(k, 'Urban')
                table.insert(k, 'Diablo')
            end
            local function h()
                local X = {}
                for w, w in BossesOrder do
                    local D = true
                    for y, y in k do if y == w then D = false end end
                    if D then table.insert(X, w) end
                end
                local k = #X
                for w = 1, k - 1 do
                    for D = 1, k - w do
                        local k = key and tostring(X[D][key]):lower() or tostring(X[D]):lower()
                        local w = key and tostring(X[D + 1][key]):lower() or tostring(X[D + 1]):lower()
                        if k > w then X[D], X[D + 1] = X[D + 1], X[D] end
                    end
                end
                return X
            end
            BossesOrder = h()
            for k, h in DropItemData do
                if not ScriptStorage.Backpack[k] and SeaIndex == h.Sea then
                    if ScriptStorage.PlayerData.Level >= h.Level then
                        BossesOrderLevel[h.Boss] = h.Level
                        table.insert(BossesOrder, h.Boss)
                    end
                end
            end
            if FunctionsHandler.Trevor:Get("IsCompleted") and not Storage:Get('SwanDefeated') then
                BossesOrderLevel["Don Swan"] = 1100
                table.insert(BossesOrder, 'Don Swan')
                if SeaIndex == 2 and ScriptStorage.PlayerData.Level > 1500 and not ScriptStorage.Enemies['Don Swan'] then
                    alert("Don Swan", 'Hopping for Don Swan')
                    Hop()
                end
            end
        end
        for k, k in SpecialItems do
            if ScriptStorage.Tools[k] then
                FunctionsHandler.UtillyItemsActivitation:Set('CurrentProgressLevel', k)
                return k
            end
        end
        if SeaIndex == 3 and (ScriptStorage.Melees["Death Step"] or 0) >= 400 and (ScriptStorage.Melees["Black Leg"] or 0) >= 400 and ScriptStorage.PlayerData.Beli >= 2500000 and ScriptStorage.PlayerData.Fragments >= 5000 and not ScriptStorage.Melees['Electric Claw'] then
            FunctionsHandler.UtillyItemsActivitation:Set('CurrentProgressLevel', "Previous Hero")
            return 'Previous Hero'
        end
        if ScriptStorage.Tools["Red Key"] then
            FunctionsHandler.UtillyItemsActivitation:Set("CurrentProgressLevel", "Red Key")
            return 'Red Key'
        end
        if ScriptStorage.Tools['Hallow Essence'] then
            FunctionsHandler.UtillyItemsActivitation:Set("CurrentProgressLevel", 'Soul Reaper Spawner')
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Fire Essence")
            return "Soul Reaper Spawner"
        end
        if ScriptStorage.Tools['Fire Essence'] then
            FunctionsHandler.UtillyItemsActivitation:Set('CurrentProgressLevel', "Uzoth")
            return 'Uzoth'
        end
    end)

    FunctionsHandler.UtillyItemsActivitation:RegisterMethod('Start', function()
        local k = FunctionsHandler.UtillyItemsActivitation:Get("CurrentProgressLevel")
        if k == 'Hidden Key' then
            SetTask('SubTask', '🔑 Using Hidden Key for Rengoku')
            Remotes.CommF_:InvokeServer("OpenRengoku")
        elseif k == 'Water Key' then
            SetTask('SubTask', '🔑 Using Water Key for Sharkman Karate')
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Water Key")
            Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
            Remotes.CommF_:InvokeServer("BuySharkmanKarate")
        elseif k == "Library Key" then
            SetTask('SubTask', '🔑 Using Library Key')
            Remotes.CommF_:InvokeServer("OpenLibrary")
            Services.Workspace.Map.IceCastle.Hall.LibraryDoor:FindFirstChild("PhoeyuDoor"):Destroy()
        elseif k == "Red Key" then
            SetTask('SubTask', '🔑 Submitting Red Key to scientist')
            alert('Red Key', "Submitting red key to the scienctist.")
            Remotes.CommF_:InvokeServer('CakeScientist', "Check")
            ScriptStorage.Tools["Red Key"]:Destroy()
        elseif k == 'Previous Hero' then
            SetTask('SubTask', '⚡ Buying Electric Claw from Previous Hero')
            Remotes.CommF_:InvokeServer('BuyElectricClaw', "Start")
            task.wait(3)
            repeat
                task.wait()
                TweenController.Create(CFrame.new(-12548.0, 332.378 + math.random(-2.0, 2), -7617.0))
            until CaculateDistance(CFrame.new(-12548.0, 332.378, -7617.0)) < 30
            Data = MeleePrices["Electric Claw"]
            Data.Buy(1)
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Melee')
        elseif k == "Uzoth" then
            SetTask('SubTask', '🔥 Using Fire Essence for Dragon Talon')
            print('Use Fire Essence')
            Remotes.CommF_:InvokeServer("BuyDragonTalon", true)
            Remotes.CommF_:InvokeServer('BuyDragonTalon')
            IsFireEssenceGave = true
            Report("Fire Essence Used")
        elseif k == "Soul Reaper Spawner" then
            SetTask('SubTask', '💀 Using Hallow Essence to spawn Soul Reaper')
            print("Use Hallow Essence")
            if CaculateDistance(workspace.Map["Haunted Castle"].Summoner.Detection.CFrame) < 100 then SpecialItems = nil end
            TweenController.Create(workspace.Map["Haunted Castle"].Summoner.Detection.CFrame)
        end
    end)

    -- ============================================================
    -- TREVOR
    -- ============================================================
    FunctionsHandler.Trevor:RegisterMethod('GetFruit', function()
        for k, k in ScriptStorage.Backpack do
            if string.find(FruitIdToName(k.Name), " Fruit") then
                if k.Value and k.Value > 1000000 and k.Value < 2500000 then return k end
            end
        end
    end)

    FunctionsHandler.Trevor:RegisterMethod('Refresh', function()
        if FunctionsHandler.Trevor:Get('IsCompleted') or os.time() - timeee < 1 then return end
        if ScriptStorage.PlayerData.Level < 1100 then return end
        local k = FunctionsHandler.Trevor.Methods.GetFruit:Call()
        if k then FunctionsHandler.Trevor:Set('Fruit', k) end
        TrevorDebounce = os.time()
        if not FunctionsHandler.Trevor:Get('IsCompleted') then
            FunctionsHandler.Trevor:Set('IsCompleted', (Remotes.CommF_:InvokeServer("TalkTrevor", "1") == 0))
        end
        return not FunctionsHandler.Trevor:Get("IsCompleted") and k
    end)

    FunctionsHandler.Trevor:RegisterMethod("Start", function()
        alert('[ cac ]', "Pulling fruit for trevor...")
        local k = FunctionsHandler.Trevor:Get("Fruit")
        FunctionsHandler.Trevor:Set('Fruit', nil)
        table.insert(ScriptStorage.IgnoreStoreFruits, k.Name)
        Remotes.CommF_:InvokeServer('LoadFruit', k.Name)
        task.wait()
        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(FruitIdToName(k.Name))
        Remotes.CommF_:InvokeServer('TalkTrevor', '1')
        Remotes.CommF_:InvokeServer('TalkTrevor', "2")
        Remotes.CommF_:InvokeServer("TalkTrevor", "3")
        task.wait(1)
        FunctionsHandler.Trevor:Set('IsCompleted', true)
    end)

    -- ============================================================
    -- THIRD SEA PUZZLE (ZOU)
    -- ============================================================
    FunctionsHandler.ThirdSeaPuzzle:RegisterMethod("Refresh", function()
        if ScriptStorage.PlayerData.Level < 1500 or SeaIndex ~= 2 then return end
        if nil == FunctionsHandler.ThirdSeaPuzzle:Get('State') then
            ZQuestProgress = Remotes.CommF_:InvokeServer("ZQuestProgress", 'Check')
            print('ZQuestProgress', ZQuestProgress)
            FunctionsHandler.ThirdSeaPuzzle:Set("State", ZQuestProgress == 0)
        end
        return FunctionsHandler.ThirdSeaPuzzle:Get('State')
    end)

    FunctionsHandler.ThirdSeaPuzzle:RegisterMethod('Start', function()
        local k = FunctionsHandler.ThirdSeaPuzzle:Get("State")
        SetTask('SubTask', '🧩 Sea3: Starting ZQuest...')
        alert('1093', "start")
        if k then
            alert('1095', "case test")
            repeat
                task.wait(1)
                alert('1096', 'fire')
                print('StartResponse', Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin"))
            until CaculateDistance(Vector3.new(0, 0, 0)) > 20000
            task.spawn(function()
                alert("1098", "rejoin")
                -- [FIXED - bớt delay theo yêu cầu boss man] 30s → 15s. Vẫn
                -- giữ đủ thời gian cho server đăng ký state trước khi rejoin
                -- ép buộc, chỉ rút phân nửa thay vì bỏ hẳn (bỏ hẳn dễ rejoin
                -- lúc server chưa kịp lưu progress ZQuest).
                task.wait(15)
                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
            end)
            alert("attack")
            while task.wait() do CombatController.Attack("rip_indra") end
        end
    end)

    -- ============================================================
    -- YAMA
    -- ============================================================
    FunctionsHandler.Yama:RegisterMethod('Refresh', function()
        if SeaIndex ~= 3 then return end
        if ScriptStorage.Backpack.Yama then return end
        if not FunctionsHandler.Yama:Get("EliteCount") then
            FunctionsHandler.Yama:Set("EliteCount", Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
        end
        if FunctionsHandler.Yama:Get('EliteCount') >= 30 then return true end
    end)

    FunctionsHandler.Yama:RegisterMethod("Start", function()
        SetTask('SubTask', '🗡️ Getting Yama...')
        repeat
            task.wait()
            TweenController.Create(game:GetService("ReplicatedStorage").FakeIslands.Waterfall:GetModelCFrame())
        until workspace.Map:FindFirstChild("Waterfall") and workspace.Map.Waterfall:FindFirstChild("SealedKatana")
        fireclickdetector(workspace.Map.Waterfall.SealedKatana.Hitbox.ClickDetector)
    end)

    -- ============================================================
    -- PIRATE RAID
    -- ============================================================
    FunctionsHandler.PirateRaid:RegisterMethod("Refresh", function()
        local k = FunctionsHandler.PirateRaid:Get('Senque')
        return k and os.time() - k < 500
    end)

    FunctionsHandler.PirateRaid:RegisterMethod("Start", function()
        local k = GetMonAsSortedRange()
        local h = Vector3.new(-5543.5327148438, 313.80062866211, -2964.2585449219)
        if k[1] then
            local X, w = k[1]:FindFirstChild("Humanoid"), k[1]:FindFirstChild("HumanoidRootPart")
            if w and X and X.Health > 0 and CaculateDistance(w.CFrame, h) < 500 then
                CombatController.Attack(k[1].Name)
                return
            end
        end
        TweenController.Create(h)
    end)

    -- ============================================================
    -- SOUL GUITAR - SỬA LOGIC TỪ HI.LUA + AUTO CHEST (MỚI)
    -- ============================================================
    -- ========== HÀM HỖ TRỢ ==========
    local _SgSpecialItems = {
        "God's Chalice", "Fist of Darkness", "Sweet Chalice",
        "Hallow Essence", "Mirror Fractal"
    }

    local function _SgHasSpecialItem()
        local bp = LocalPlayer:FindFirstChild("Backpack")
        local char = LocalPlayer.Character
        for _, name in ipairs(_SgSpecialItems) do
            if bp and bp:FindFirstChild(name) then return true, name end
            if char and char:FindFirstChild(name) then return true, name end
        end
        return false, nil
    end

    local function _SgGetChests()
        local chests = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Parent
               and string.find(string.lower(obj.Name), "chest") then
                table.insert(chests, obj)
            end
        end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos = hrp.Position
            table.sort(chests, function(a, b)
                if a and b and a.Parent and b.Parent then
                    return (pos - a.Position).Magnitude < (pos - b.Position).Magnitude
                end
                return false
            end)
        end
        return chests
    end

    local function _SgCollectChest(chest)
        pcall(function()
            if not chest or not chest.Parent then return end
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            local targetCF = chest.CFrame + Vector3.new(0, 3, 0)
            -- [FIXED - theo yêu cầu boss man: "bỏ bypass teleport"] Bỏ nhánh
            -- BypassTP cho rương xa (>3000 stud) — luôn dùng
            -- TweenController.Create bình thường, không đổi spawn point nữa.
            TweenController.Create(targetCF)
            task.wait(0.35)
            if firetouchinterest then
                firetouchinterest(hrp, chest, 0)
                task.wait()
                firetouchinterest(hrp, chest, 1)
            end
        end)
    end

    local _SgChestPhaseDone = false
    local _SgVisited = {}

    local function _SgHopServer()
        SetTask("MainTask", "🎸 Soul Guitar | Hop: Đang tìm server...")
        local ok, servers = pcall(GetServers)
        if ok and servers then
            local list = {}
            for jobId, data in pairs(servers) do
                if jobId ~= game.JobId and not _SgVisited[jobId] then
                    table.insert(list, {id = jobId, players = data.Count or 0})
                end
            end
            table.sort(list, function(a, b) return a.players < b.players end)
            if list[1] then
                _SgVisited[list[1].id] = true
                SetTask("SubTask", "🎸 Hop → " .. list[1].id:sub(1,8) .. "... (" .. list[1].players .. " players)")
                pcall(function()
                    game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", list[1].id)
                end)
                -- [FIXED - bớt delay theo yêu cầu boss man] 8s → 4s. Teleport
                -- server thường tự cắt kết nối client trong vài giây, 4s vẫn
                -- đủ để không chạy tiếp code khi lệnh teleport chưa kịp ăn.
                task.wait(4)
                _SgChestPhaseDone = false
                return
            end
        end
        pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local resp = game:HttpGet(url)
            local data = game:GetService("HttpService"):JSONDecode(resp)
            if not data or not data.data then return end
            table.sort(data.data, function(a, b) return (a.playing or 0) < (b.playing or 0) end)
            for _, sv in ipairs(data.data) do
                local slots = (sv.maxPlayers or 0) - (sv.playing or 0)
                if slots >= 2 and sv.id ~= game.JobId and not _SgVisited[sv.id] then
                    _SgVisited[sv.id] = true
                    SetTask("SubTask", "🎸 Hop HTTP → " .. sv.id:sub(1,8) .. " (" .. (sv.playing or 0) .. "/" .. (sv.maxPlayers or 0) .. ")")
                    pcall(function()
                        game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", sv.id)
                    end)
                    -- [FIXED - bớt delay theo yêu cầu boss man] 8s → 4s (giống nhánh hop ở trên)
                    task.wait(4)
                    _SgChestPhaseDone = false
                    return
                end
            end
        end)
        SetTask("MainTask", "🎸 Soul Guitar | Hop: Không tìm được server, thử lại...")
        -- [FIXED - bớt delay theo yêu cầu boss man] retry backoff 5s → 2s
        task.wait(2)
    end

    local function _SgRunChestBatch()
        local hasItem, itemName = _SgHasSpecialItem()
        if hasItem then
            SetTask("MainTask", "🎸 Auto Chest: Found " .. itemName .. " — dừng")
            return false
        end
        if ScriptStorage.Backpack["Skull Guitar"] then
            return false
        end
        local chests = _SgGetChests()
        SetTask("SubTask", "🎸 Auto Chest: " .. #chests .. " rương còn lại")
        if #chests == 0 then
            return false
        end
        for _, chest in ipairs(chests) do
            if _G.Stop then return false end
            local hasMid, nameMid = _SgHasSpecialItem()
            if hasMid then
                SetTask("MainTask", "🎸 Auto Chest: Found " .. nameMid)
                return false
            end
            if chest and chest.Parent then
                SetTask("MainTask", "🎸 Collecting: " .. chest.Name)
                _SgCollectChest(chest)
                task.wait(0.2)
            end
        end
        return #_SgGetChests() > 0
    end

    -- ========== LOGIC CHÍNH ==========
    FunctionsHandler.SoulGuitar:RegisterMethod("Refresh", function()
        if not Config.Items.SoulGuitar then return end
        if ScriptStorage.Backpack['Skull Guitar'] then return end
        if ScriptStorage.PlayerData.Level < 2300 then return end

        local ectoCount = (ScriptStorage.Backpack['Ectoplasm'] or {Count = 0}).Count or 0
        local bonesCount = (ScriptStorage.Backpack['Bones'] or {Count = 0}).Count or 0
        local frags = ScriptStorage.PlayerData.Fragments or 0

        -- BƯỚC 1: Farm Ectoplasm đến 250 ở Sea 2
        if ectoCount < 250 then
            _SgChestPhaseDone = false
            return 1
        end

        -- BƯỚC 2: Nếu chưa có Dark Fragment → farm chest → summon Blackbeard → đánh
        if not ScriptStorage.Backpack['Dark Fragment'] then
            if ScriptStorage.Backpack['Fist of Darkness'] then
                return 10   -- summon & đánh Blackbeard
            end
            if not _SgChestPhaseDone then
                local chests = _SgGetChests()
                if #chests > 0 then
                    return 9   -- auto chest
                else
                    _SgChestPhaseDone = true
                    SetTask("MainTask", "🎸 Soul Guitar | Hết rương, hop server để tìm Fist of Darkness")
                    task.spawn(_SgHopServer)
                    return
                end
            else
                _SgChestPhaseDone = false
                return 9
            end
        end

        -- BƯỚC 3: Đã có Dark Fragment, chuyển sang puzzle ở Sea 3
        if SeaIndex ~= 3 then
            SetTask('MainTask', '🎸 Soul Guitar: Teleport to Sea 3')
            Remotes.CommF_:InvokeServer("TravelZou")
            return
        end

        SoulGuitarProcess = Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", 'Check')
        if not SoulGuitarProcess then
            Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
            if not CheckFullMoon() then
                SetTask('MainTask', 'Hopping for full moon (soul guitar)')
                _SgHopServer()
            end
            return 7
        end
        if not SoulGuitarProcess.Swamp      then return 2
        elseif not SoulGuitarProcess.Gravestones then return 3
        elseif not SoulGuitarProcess.Ghost  then return 4
        elseif not SoulGuitarProcess.Trophies   then return 5
        elseif not SoulGuitarProcess.Pipes  then return 6
        elseif bonesCount >= 500 and frags >= 5000 and not ScriptStorage.Backpack["Skull Guitar"] then
            return 8
        end
    end)

    FunctionsHandler.SoulGuitar:RegisterMethod('Start', function(k)
        if k == 9 then
            SetTask("MainTask", "🎸 Soul Guitar | Auto Chest: Nhặt rương...")
            local hasMore = _SgRunChestBatch()
            if not hasMore then
                _SgChestPhaseDone = true
            end

        elseif k == 10 then
            SetTask('SubTask', '🎸 Soul Guitar: Summon Blackbeard')
            local darkArenaPos = CFrame.new(-1742.0, 241.0, 1290.0)
            TweenController.Create(darkArenaPos)
            task.wait(1)
            pcall(function()
                Remotes.CommF_:InvokeServer("Blackbeard", "Spawn")
            end)
            task.wait(1)
            SetTask('MainTask', '🎸 Soul Guitar: Đánh Blackbeard để lấy Dark Fragment')
            CombatController.Attack("Blackbeard")

        elseif k == 7 then
            SetTask('SubTask', '🎸 Soul Guitar: Full moon gravestone')
            while CaculateDistance(CFrame.new(-8654.0, 140, 6167)) > 5 do
                task.wait()
                TweenController.Create(CFrame.new(-8654.0, 140, 6167))
            end
            SoulGuitarProcess = Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)

        elseif k == 1 then
            if SeaIndex ~= 2 then
                SetTask("SubTask", '🎸 Soul Guitar: Teleport Sea 2 để farm ectoplasm')
                SetTask("MainTask", 'Teleport to second sea to farm ectoplasm')
                Remotes.CommF_:InvokeServer("TravelDressrosa")
                return
            else
                local ecto = (ScriptStorage.Backpack['Ectoplasm'] or {Count = 0}).Count or 0
                SetTask("SubTask", '🎸 Soul Guitar: Farming Ectoplasm (' .. ecto .. '/250)')
                SetTask("MainTask", "Soul Guitar | Ectoplasm " .. ecto .. "/250")
                CombatController.Attack({"Ship Deckhand", "Ship Engineer", 'Ship Steward', "Ship Officer"})
                return
            end

        elseif k == 2 then
            SetTask('SubTask', '🎸 Soul Guitar: Kill Living Zombies (Swamp)')
            TTL9 = TTL9 or 0
            if os.time() ~= LastestTime1 then
                TTL9 = TTL9 + 1
                LastestTime1 = os.time()
            end
            if TTL9 > 60 then _SgHopServer() return end

            local zombies = {}
            for _, enemy in ipairs(Services.Workspace.Enemies:GetChildren()) do
                if enemy.Name == "Living Zombie" then
                    table.insert(zombies, enemy)
                end
            end

            if #zombies < 6 then
                SetTask('MainTask', 'Soul Guitar: Waiting Living Zombies (' .. #zombies .. '/6)')
                TweenController.Create(ScriptStorage.MobRegions["Living Zombie"][1] + Vector3.new(0, 30, 0))
            else
                local startT = os.time()
                for idx, zombie in ipairs(zombies) do
                    local hum  = zombie:FindFirstChild("Humanoid")
                    local root = zombie:FindFirstChild("HumanoidRootPart")
                    if not hum or not root then continue end
                    while task.wait() and hum.Health > 7000 do
                        SetTask('MainTask', 'Soul Guitar: Weakening zombie ' .. idx .. '/' .. #zombies)
                        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Melee')
                        if os.time() - startT > 60 then _SgHopServer() return end
                        TweenController.Create(root.CFrame + Vector3.new(0, 50, 0))
                        pcall(function() _G.FastAttack = os.time() end)
                    end
                end
                SetTask("MainTask", 'Soul Guitar: Finishing all Living Zombies')
                local killT = os.time()
                while workspace.Enemies:FindFirstChild("Living Zombie") and task.wait() do
                    if os.time() - killT > 60 then _SgHopServer() return end
                    CombatController.Attack('Living Zombie')
                end
                TTL9 = 0
            end

        elseif k == 3 then
            SetTask('SubTask', '🎸 Soul Guitar: Placard puzzle')
            local castle = workspace.Map["Haunted Castle"]
            while CaculateDistance(CFrame.new(-8800.0, 178, 6033)) > 10 do
                task.wait()
                SetTask("MainTask", "Soul Guitar: Completing placards...")
                TweenController.Create(CFrame.new(-8800.0, 178, 6033))
            end
            for placadName, dir in pairs({
                Placard1 = "Right", Placard2 = "Right", Placard3 = "Left",
                Placard4 = "Right", Placard5 = "Left", Placard6 = "Left", Placard7 = "Left"
            }) do
                pcall(function() fireclickdetector(castle[placadName][dir].ClickDetector) end)
            end

        elseif k == 4 then
            SetTask('SubTask', '🎸 Soul Guitar: Ghost task')
            Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost")

        elseif k == 5 then
            SetTask('SubTask', '🎸 Soul Guitar: Trophy puzzle')
            if CaculateDistance(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375)) > 30 then
                TweenController.Create(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375))
            else
                local tablet = workspace.Map['Haunted Castle'].Tablet
                for _, segName in pairs(BlankTablets) do
                    local seg = tablet[segName]
                    if seg and seg.Line.Rotation.Z ~= 0 then
                        repeat task.wait() fireclickdetector(seg.ClickDetector)
                        until seg.Line.Rotation.Z == 0
                    end
                end
                for segName, trophyName in pairs(Trophy) do
                    pcall(function()
                        local handle = workspace.Map["Haunted Castle"].Trophies.Quest[trophyName].Handle
                        local rotPart = tostring(handle.CFrame):split(", ")[4]
                        local targetRot = (rotPart == "1" or rotPart == "-1") and "90" or "180"
                        local seg = tablet[segName]
                        if seg and not string.find(tostring(seg.Line.Rotation.Z), targetRot) then
                            repeat task.wait() fireclickdetector(seg.ClickDetector)
                            until string.find(tostring(seg.Line.Rotation.Z), targetRot)
                        end
                    end)
                end
            end

        elseif k == 6 then
            SetTask('SubTask', '🎸 Soul Guitar: Pipe puzzle')
            for pipeName, colorName in pairs(Pipes) do
                pcall(function()
                    local pipe = workspace.Map['Haunted Castle']['Lab Puzzle'].ColorFloor.Model[pipeName]
                    if pipe and pipe.BrickColor.Name ~= colorName then
                        repeat task.wait() fireclickdetector(pipe.ClickDetector)
                        until pipe.BrickColor.Name == colorName
                    end
                end)
            end
            Remotes.CommF_:InvokeServer('soulGuitarBuy')

        elseif k == 8 then
            SetTask('SubTask', '🎸 Soul Guitar: Buying Skull Guitar')
            Remotes.CommF_:InvokeServer('soulGuitarBuy')
        end
    end)
    -- ============================================================
    -- KẾT THÚC PHẦN SOUL GUITAR
    -- ============================================================

    -- ============================================================
    -- TUSHITA
    -- ============================================================
    FunctionsHandler.Tushita:RegisterMethod("Refresh", function()
        if ScriptStorage.Backpack.Tushita then return end
        if ScriptStorage.PlayerData.Level < 2000 then return end
        if SeaIndex ~= 3 then return end
        TushitaProgress = TushitaProgress or Remotes.CommF_:InvokeServer("TushitaProgress")
        if not TushitaProgress.OpenedDoor then
            if ScriptStorage.Enemies["rip_indra True Form"] then
                TushitaProgress = nil
                return 1
            end
        else
            if ScriptStorage.Enemies['Longma'] then
                TushitaProgress = nil
                return 2
            end
        end
    end)

    FunctionsHandler.Tushita:RegisterMethod('Start', function(k)
        if k == 1 then
            SetTask('SubTask', '🗡️ Tushita: Placing torches (Step 1)')
            alert('Auto Tushita', 'Placing torches...')
            TweenController.Create(CFrame.new(5714, math.random(19, 21), 256))
            if ScriptStorage.Tools["Holy Torch"] then
                for W = 1, 5 do Remotes.CommF_:InvokeServer("TushitaProgress", "Torch", W) end
                return true
            end
        elseif k == 2 then
            SetTask('SubTask', '🗡️ Tushita: Defeating Longma (Step 2)')
            alert("Auto Tushita", "Defeating Longma")
            CombatController.Attack("Longma")
        end
    end)

    -- ============================================================
    -- CURSED DUAL KATANA (CDK)
    -- ============================================================
    FunctionsHandler.CursedDualKatana:RegisterMethod("Refresh", function()
        if not Config.Items.CursedDualKatana then return end
        local k = ScriptStorage.Backpack
        if ScriptStorage.PlayerData.Level < 2200 then return end
        -- [FIXED - theo spec] Trước đây thiếu mastery 350 thì chỉ `return`
        -- im lặng, không chủ động làm gì. Giờ trả tín hiệu "trainSwords" để
        -- Start() chuyển sang farm Bones tại Haunted Castle, check mastery
        -- mỗi giây, chỉ khi CẢ HAI Yama+Tushita >= 350 mới cho CDK bắt đầu.
        if k["Cursed Dual Katana"] then return end
        if not k.Tushita or (k.Tushita.Mastery or 0) < 350 or not k.Yama or (k.Yama.Mastery or 0) < 350 then
            return {"trainSwords"}
        end
        if SeaIndex ~= 3 then return end
        local k = CdkProgess or Remotes.CommF_:InvokeServer("CDKQuest", 'Progress') or 'uwu'
        if not k or k == 'uwu' then return end
        if workspace.Map.Turtle.Cursed:FindFirstChild("Breakable") then
            alert('Cursed Dual Katana', 'Open Door')
            return {"break"}
        end
        local W = {Good = 'Tushita', Evil = 'Yama'}
        if k.Good == 4 and k.Evil == 4 then
            print("burn 2")
            return {'burn 2'}
        end
        if k.Good == 3 or k.Evil == 3 then
            print('burn 1')
            return {"burn"}
        end
        if k.Opened then
            for h, X in k do
                if h ~= 'Opened' and h ~= "Finished" and X < 3 then
                    print(h, X)
                    ScriptStorage.CdkCache = {h, X + 1}
                    if not ScriptStorage.Tools[W[h]] then Remotes.CommF_:InvokeServer('LoadItem', W[h]) end
                    alert("Cursed Dual Katana", "Start " .. tostring(W[h]) .. ' ' .. tostring(h))
                    Remotes.CommF_:InvokeServer('CDKQuest', 'StartTrial', h)
                    SetTask("MainTask", "Cursed Dual Katana - " .. tostring(W[h]) .. ' ' .. tostring(h))
                    return false
                end
            end
        end
        local k = ScriptStorage.CdkCache
        if not k then return end
        local W, h = k[1], k[2]
        if W == "Evil" and h == 3 then
            -- [FIXED] Trước đây chỉ set ForceToRollBone=true rồi đứng im —
            -- biến đó không có handler nào đọc, nên bước này bị TREO VĨNH
            -- VIỄN. Thay bằng chuỗi thật: Bones → Hallow Essence → equip
            -- tại toạ độ triệu hồi → Soul Reaper xuất hiện → đánh.
            -- (verified từ main_red_magic_beta.txt + raw_6, khớp nhau)
            local HALLOW_SUMMON_CF = CFrame.new(-8932.86, 143.258, 6063.31)

            if ScriptStorage.Enemies['Soul Reaper'] then
                -- Đã lên rồi → đánh, không cần làm gì thêm ở nhánh này
                return k
            end

            local hasHallow = ScriptStorage.Backpack["Hallow Essence"]
                or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Hallow Essence"))

            if hasHallow then
                SetTask('SubTask', 'CDK Quest / Dùng Hallow Essence triệu hồi Soul Reaper')
                TweenController.Create(HALLOW_SUMMON_CF)
                if CaculateDistance(HALLOW_SUMMON_CF) <= 8 then
                    FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Hallow Essence")
                end
                return
            else
                -- [FIXED] Ngưỡng thật là 500 Bones, không phải 50 — verified
                -- từ raw_6.txt ("CheckItem(Bones) > 500"). Dưới 500 thì farm
                -- tiếp, KHÔNG bắn Buy (dư/thiếu bones lẻ tẻ không đủ đổi).
                local bonesCount = Remotes.CommF_:InvokeServer("Bones", "Check")
                SetTask('SubTask', 'CDK Quest / Farm Bones cho Hallow Essence (' .. tostring(bonesCount) .. '/500)')

                if bonesCount and bonesCount > 500 then
                    -- [FIXED] Đủ 500 → xả hết 1 lượt (verified: repeat Buy(1,1)
                    -- cho tới khi Check == 0), không nhỏ giọt từng lần 1 nữa
                    repeat
                        Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                        task.wait(0.2)
                        bonesCount = Remotes.CommF_:InvokeServer("Bones", "Check")
                    until not bonesCount or bonesCount <= 0
                    return
                end

                if not ScriptStorage.Enemies["Reborn Skeleton"] and not ScriptStorage.Enemies["Living Zombie"]
                    and not ScriptStorage.Enemies["Demonic Soul"] and not ScriptStorage.Enemies["Posessed Mummy"] then
                    -- [NEW] Chưa thấy xác gần đây → di chuyển tới đúng điểm
                    -- farm Haunted Castle thay vì đứng im chờ
                    SetTask('SubTask', 'CDK Quest / Di chuyển tới Haunted Castle farm Bones')
                    TweenController.Create(HAUNTED_CASTLE_BONES_CF)
                    return
                end
                CombatController.Attack({"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"})
                return
            end
        elseif W == 'Good' then
            if h == 2 then
                SetTask("SubTask", 'CDK Quest / Waiting until pirate raid started')
                return
            elseif h == 3 and not ScriptStorage.Enemies["Cake Queen"] then
                Hop()
                SetTask('SubTask', "CDK Quest / Waiting until Cake Queen boss spawned")
                return
            end
        end
        return k
    end)

    FunctionsHandler.CursedDualKatana:RegisterMethod("GetHazeMon", function()
        local k = {}
        for W, W in LocalPlayer.QuestHaze:GetChildren() do if W.Value > 0 then table.insert(k, W) end end
        table.sort(k, function(W, h) return CaculateDistance(W:GetAttribute('Position')) < CaculateDistance(h:GetAttribute('Position')) end)
        return tostring(k[1])
    end)

    FunctionsHandler.CursedDualKatana:RegisterMethod("DoDimension", function(k)
        local W = string.gsub(k, ' ', "")
        local k = os.time()
        repeat
            task.wait()
            TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
            if os.time() - k > 60 then return end
        until os.time() - TorchEnabledTime < 10
        repeat
            task.wait()
            local k = workspace.Map:WaitForChild(W, 10)
            if k then
                for h, h in k:GetChildren() do
                    if h and string.find(h.Name, "Torch") and h:FindFirstChild('ProximityPrompt') and h.ProximityPrompt.Enabled then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = h.CFrame
                        h.ProximityPrompt.HoldDuration = 0
                        task.wait(1)
                        local X = game:GetService("VirtualInputManager")
                        X:SendKeyEvent(true, "E", 0, game)
                        X:SendKeyEvent(false, "E", 0, game)
                        fireproximityprompt(workspace.Map:WaitForChild(W, 10):FindFirstChild(tostring(h)).ProximityPrompt)
                    end
                    for W, W in workspace.Enemies:GetChildren() do
                        local h = W:FindFirstChild("HumanoidRootPart")
                        local X = W:FindFirstChild("Humanoid")
                        if h and X and CaculateDistance(h.CFrame) < 1000 then CombatController.Attack(W.Name) end
                    end
                end
                ExitDoor = k:FindFirstChild("Exit")
                print("exit door", ExitDoor)
                if ExitDoor then
                    PortalBrick = tostring(ExitDoor.BrickColor)
                    print("Brick color", ExitDoor, ExitDoor.BrickColor, PortalBrick)
                end
            else
                print('no island idk wt-')
            end
            print('loop damn', PortalBrick)
        until PortalBrick == 'Olive' or PortalBrick == "Cloudy grey"
        print('leave')
        while os.time() - DoneCdkTick > 15 do
            TweenController.Create(ExitDoor.CFrame + Vector3.new(0, math.random(1, 5), 0))
            task.wait()
        end
        Hop()
    end)

    FunctionsHandler.CursedDualKatana:RegisterMethod("Start", function(k)
        local W = workspace.Map.Turtle.Cursed
        if k[1] == "trainSwords" then
            -- [NEW - theo spec] Yama/Tushita chưa đủ 350 mastery — farm
            -- Bones tại Haunted Castle, trang bị đúng kiếm đang thiếu để
            -- mastery tính đúng vũ khí. Bones thu được dùng chung cho Fire
            -- Essence (Dragon Talon) và Hallow Essence (CDK) sau này.
            local bp = ScriptStorage.Backpack
            local tushitaMastery = bp.Tushita and bp.Tushita.Mastery or 0
            local yamaMastery    = bp.Yama and bp.Yama.Mastery or 0

            local swordToTrain = nil
            if not bp.Tushita then
                swordToTrain = "buy_tushita"
            elseif tushitaMastery < 350 then
                swordToTrain = "Tushita"
            elseif not bp.Yama then
                swordToTrain = "buy_yama"
            elseif yamaMastery < 350 then
                swordToTrain = "Yama"
            end

            if swordToTrain == "buy_tushita" or swordToTrain == "buy_yama" then
                SetTask('MainTask', 'CDK Prep | Chưa có ' .. (swordToTrain == "buy_tushita" and "Tushita" or "Yama") .. ' — chờ Tushita/Yama handler mua')
                return
            end

            SetTask('MainTask', string.format('CDK Prep | Tushita %d/350, Yama %d/350', tushitaMastery, yamaMastery))

            if swordToTrain then
                pcall(function()
                    FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(swordToTrain)
                end)
            end

            if not ScriptStorage.Enemies["Reborn Skeleton"] and not ScriptStorage.Enemies["Living Zombie"]
                and not ScriptStorage.Enemies["Demonic Soul"] and not ScriptStorage.Enemies["Posessed Mummy"] then
                SetTask('SubTask', 'CDK Prep | Di chuyển tới Haunted Castle')
                TweenController.Create(HAUNTED_CASTLE_BONES_CF)
                return
            end
            CombatController.Attack({"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"})
            return
        end
        if k[1] == 'break' then
            SetTask('SubTask', '⚔️ CDK: Opening door')
            TweenController.Create(workspace.Map.Turtle.Cursed.Breakable.CFrame)
            Remotes.CommF_:InvokeServer('CDKQuest', "OpenDoor")
            Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
            workspace.Map.Turtle.Cursed.Breakable:Destroy()
            CdkProgess = nil
            return
        end
        if k[1] == "burn 2" then
            SetTask('SubTask', '⚔️ CDK: Burning pedestals (step 2)')
            if workspace.Map.Turtle.Cursed.Pedestal3.ProximityPrompt.Enabled then
                fireproximityprompt(workspace.Map.Turtle.Cursed.Pedestal3.ProximityPrompt)
                task.wait(1)
                pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                -- [FIXED - bớt delay theo yêu cầu boss man] 10s → 5s. Đây là
                -- chờ respawn sau self-kill, 5s vẫn đủ dư so với thời gian
                -- respawn thực tế (thường 2-3s) của Blox Fruits.
                task.wait(5)
            else
                CDKAttempts = (CDKAttempts or 0) + 1
                TweenController.Create(CFrame.new(-12341.66796875, 603.3455810546875, -6550.6064453125))
                -- [FIXED - bớt delay theo yêu cầu boss man] 5s/5s → 3s/3s
                task.wait(3)
                pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                task.wait(3)
                if CDKAttempts > 5 then Hop() end
                CdkProgess = nil
            end
        elseif k[1] == "burn" then
            SetTask('SubTask', '⚔️ CDK: Burning pedestals')
            for W = 1, 3, 1 do
                local h = workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. W)
                if workspace.Map.Turtle.Cursed:FindFirstChild('Pedestal' .. W).ProximityPrompt.Enabled then
                    repeat
                        task.wait()
                        TweenController.Create(workspace.Map.Turtle.Cursed:FindFirstChild('Pedestal' .. W).CFrame)
                    until CaculateDistance(workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. W).CFrame) < 5
                    fireproximityprompt(workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. W).ProximityPrompt)
                    task.wait(3)
                    pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                end
                CdkProgess = nil
            end
        elseif k[1] == 'Evil' then
            if k[2] == 1 then
                SetTask('SubTask', '⚔️ CDK: Evil trial - Forest Pirate')
                local W = ScriptStorage.Enemies["Forest Pirate"]
                TweenController.Create((W and W.HumanoidRootPart.CFrame) or ScriptStorage.MobRegions["Forest Pirate"][0])
                CdkProgess = nil
            elseif k[2] == 2 then
                SetTask('SubTask', '⚔️ CDK: Evil trial - Haze monster')
                CombatController.Attack(FunctionsHandler.CursedDualKatana.Methods.GetHazeMon:Call())
                CdkProgess = nil
            elseif k[2] == 3 then
                SetTask('SubTask', '⚔️ CDK: Evil trial - Soul Reaper')
                Report("found cdk yama 3")
                while not (os.time() - TorchEnabledTime < 100 or not ScriptStorage.Enemies["Soul Reaper"]) do
                    print("tweening to soul reaper")
                    task.wait()
                    if FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
                        pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                    end
                    TweenController.Create(ScriptStorage.Enemies["Soul Reaper"]:GetModelCFrame())
                end
                if not ScriptStorage.Enemies["Soul Reaper"] then return end
                FunctionsHandler.CursedDualKatana.Methods.DoDimension.Callback("Hell Dimension")
                CdkProgess = nil
            end
        else
            if k[2] == 1 then
                SetTask('SubTask', '⚔️ CDK: Good trial - Boat Dealer')
                for W, W in game.ReplicatedStorage.NPCs:GetChildren() do
                    if W.Name == "Luxury Boat Dealer" then
                        repeat
                            task.wait()
                            if os.time() - DoneCdkTick < 15 then return end
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = (W:GetModelCFrame())
                            RealNPC = nil
                            for h, h in workspace.NPCs:GetChildren() do
                                if CaculateDistance(h:GetModelCFrame(), W:GetModelCFrame()) < 20 then
                                    RealNPC = h
                                    break
                                end
                            end
                        until CaculateDistance(W:GetModelCFrame()) < 5 and RealNPC
                        Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", RealNPC)
                    end
                end
                CdkProgess = nil
            elseif k[2] == 3 then
                SetTask('SubTask', '⚔️ CDK: Good trial - Cake Queen')
                repeat
                    task.wait()
                    print('attacking cage queen')
                    CombatController.Attack("Cage Queen")
                until os.time() - TorchEnabledTime < 10 or not ScriptStorage.Enemies['Cake Queen']
                TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
                Report('Cake Queen')
                FunctionsHandler.CursedDualKatana.Methods.DoDimension.Callback("Heavenly Dimension")
                CdkProgess = nil
            end
        end
    end)

    -- ============================================================
    -- NOTIFICATION LISTENERS
    -- ============================================================
    local k = {Listeners = {}}
    TorchEnabledTime = 0
    DoneCdkTick = 0
    getgenv().NotificationCallBack = (function(W)
        for h, X in k.Listeners do
            if string.find(string.lower(W), string.lower(h)) then X(W) end
        end
    end)
    function k:RegisterNotifyListener(W, h) k.Listeners[W] = h end
    k:RegisterNotifyListener('go!', function() LastRaidAlert = os.time() end)
    k:RegisterNotifyListener('raid', function() LastRaidAlert2 = os.time() end)
    k:RegisterNotifyListener("been spotted approaching", function() FunctionsHandler.PirateRaid:Set('Senque', os.time()) end)
    k:RegisterNotifyListener('job', function() FunctionsHandler.PirateRaid:Set('Senque', 0) end)
    k:RegisterNotifyListener("level", function() AddPoint() end)
    k:RegisterNotifyListener("torch", function() TorchEnabledTime = os.time() end)
    k:RegisterNotifyListener("scroll reacts", function() DoneCdkTick = os.time() end)
    k:RegisterNotifyListener("elite", function()
        FunctionsHandler.Yama:Set('EliteCount', Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
        alert("[MeyyHub ] ", "Elite defeated: " .. tostring(FunctionsHandler.Yama:Get("EliteCount") or 'n/a'))
    end)
    k:RegisterNotifyListener('the raid with', function()
        if ScriptStorage.PlayerData.Level < MaxLevel then return end
        Remotes.CommF_:InvokeServer('Awakener', "Awaken")
    end)
    k:RegisterNotifyListener('quest completed', function()
        J:RefreshQuest()
        task.wait()
        if not J:GetCurrentClaimQuest() then J:MarkAsCompleted() end
    end)
    local k
    k = hookfunction(require(game.ReplicatedStorage.Notification).new, function(W, h)
        v21 = tostring(tostring(W or '') .. tostring(h or "")) or ""
        getgenv().NotificationCallBack(v21)
        return k(W, h)
    end)

    -- ============================================================
    -- SERVER MANAGEMENT
    -- ============================================================
    if SeaIndex ~= 1 then end
    function IfTableHaveIndex(k) for W in k do return true end end
    print(1)
    function GetServers()
        if LastServersDataPulled then
            if os.time() - LastServersDataPulled < 60 then return CachedServers end
        end
        for k = 1, 100, 1 do
            local W = game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer(k)
            if IfTableHaveIndex(W) then
                LastServersDataPulled = os.time()
                CachedServers = W
                return W
            end
        end
    end
    spawn(function()
        GetServers()
        -- [FIXED - bớt delay theo yêu cầu boss man] 180s → 90s. Không rút
        -- sâu hơn nữa để tránh spam API server-list của Roblox (public API
        -- có rate-limit thật), 90s vẫn đủ nhanh để danh sách hop không bị cũ.
        while task.wait(90) do GetServers() end
    end)
    function Hop(k, W)
        local h = GetServers()
        local X = {}
        for w, D in h do
            table.insert(X, {JobId = w, Players = D.Count, LastUpdate = D.__LastUpdate, Region = D.Region})
        end
        print(#X, "servers received")
        for h = 1, #X do
            while task.wait() do
                local h = math.random(1, #X)
                ServerData = X[h]
                if ServerData then
                    if not k or ServerData.Players < k then
                        if not W or ServerData.Regoin == W then
                            print("Found Server:", ServerData.JobId, "Player Count:", ServerData.Players, 'Region:', ServerData.Region)
                            break
                        end
                    end
                end
            end
        end
        print('Teleporting to', ServerData.JobId, "..")
        game:GetService("ReplicatedStorage"):WaitForChild('__ServerBrowser'):InvokeServer("teleport", ServerData.JobId)
    end
    LowHop = function(k, k)
        local k = {}
        local W = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true')
        local h = game:GetService("HttpService"):JSONDecode(W)
        if h and h.data then
            for W, W in next, h.data do
                if type(W) == "table" and tonumber(W.playing) and tonumber(W.maxPlayers) and W.playing < 5 and W.id ~= JobId then
                    table.insert(k, 1, W.id)
                end
            end
        end
        if #k > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, k[math.random(1, #k)], game.Players.LocalPlayer)
        else
            return alert('Serverhop', "Couldn't find a server.")
        end
    end

    -- ============================================================
    -- STORAGE
    -- ============================================================
    Storage = {WRITE_DELAY = .5, Data = {}}
    Services = {}
    setmetatable(Services, {__index = function(k, k) return game:GetService(k) end})
    LocalPlayer = game.Players.LocalPlayer
    local k = ".storage_u_" .. tostring(LocalPlayer)
    function Decode(W) return Services.HttpService:JSONDecode(W) end
    function Encode(W) return Services.HttpService:JSONEncode(W) end
    print(5)
    function Storage.Set(W, h, X) W.Data[h] = X end
    function Storage.Get(W, h) return W.Data[h] end
    function Storage.Save(W) pcall(function() if writefile then writefile(k, Encode(W.Data)) end end) end
    if isfile and readfile and not isfile(k) then
        pcall(writefile, k, "{}")
        task.wait(1)
    end
    Storage.Data = {}
    if readfile then pcall(function() Storage.Data = Decode(readfile(k) or '{}') end) end
    spawn(function() while task.wait(Storage.WRITE_DELAY) do Storage:Save() end end)
    CreateTraceback('Initalize', "Initalizing script..")
    local k = {}
    SetTask("MainTask", 'Level Farming')
    SetTask("SubTask", "Idle")
    ParsingTimes = 0
    function RefreshTasksData()
        if _G.Stop then return end
        for W, W in TasksOrder do
            local h = FunctionsHandler[W]
            if not h.Initalized then
                if not k[W] then
                    print("[ Debug ] Task", Name, "is not registered yet")
                    k[W] = true
                end
            else
                local k = h.Methods.Refresh
                local X = h.Methods.Start
                if k then
                    local h = k:Call(ParsingTimes < 100)
                    ParsingTimes = ParsingTimes + 1
                    if h and ParsingTimes > 100 then
                        CurrentTask = CurrentTask ~= W
                        CurrentTask = W
                        ScriptStorage.Interface.SetText('DebugLine', W)
                        X:Call(h)
                        return
                    end
                end
            end
        end
    end
    SetText('MainTextLabel', "Refreshing Player Items..")
    AddPoint()
    J:RefreshQuest()
    RefreshInventory()
    Remotes.CommE.OnClientEvent:Connect(function(...)
        local J = {...}
        if string.find(J[1], 'Item') then RefreshInventory() end
    end)
    RefreshRace()
    a.LocalPlayer.Idled:Connect(function()
        Services.VirtualUser:CaptureController()
        Services.VirtualUser:ClickButton2(Vector2.new())
    end)
    SetText("MainTextLabel", 'Loaded In ' .. tick() - StartTick .. 'ms!')
    -- ============================================================
    -- [REPLACED] FPS BOOSTER — hàm cũ EnableFpsBoost() có "if true then
    -- return end" ngay dòng đầu, khiến TOÀN BỘ ~100 dòng optimize không
    -- bao giờ chạy dù Config.Configuration.FpsBoost = true hay false.
    -- Thay bằng logic raw9jjs.txt (đơn giản, verified hoạt động): chuyển
    -- xám toàn bộ map + nhân vật, tắt particle/trail, hạ QualityLevel.
    -- Theo dõi DescendantAdded liên tục — object mới spawn ra (quái, boss,
    -- item) cũng tự động bị áp dụng, không cần chạy lại thủ công.
    -- ============================================================
    local function GrayAndOptimize(object)
        if object:IsA("BasePart") or object:IsA("MeshPart") or object:IsA("UnionOperation") then
            object.Material = Enum.Material.Plastic
            object.Reflectance = 0
            if not object.Name:find("Handle") and not object.Name:find("Attachment") then
                pcall(function() object.Color = Color3.fromRGB(128, 128, 128) end)
            end
        end
        if object:IsA("Decal") or object:IsA("Texture") then
            object.Transparency = 1
        end
        if object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Smoke") or object:IsA("Fire") then
            object.Enabled = false
        end
    end

    local function EnableFpsBoost()
        if not (Config.Configuration and Config.Configuration.FpsBoost) then return end
        task.spawn(function()
            pcall(function()
                Services.Lighting.GlobalShadows = false
                Services.Lighting.Brightness = 1
                Services.Lighting.Ambient = Color3.fromRGB(128, 128, 128)
                if settings and settings().Rendering then
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                end

                for _, descendant in ipairs(workspace:GetDescendants()) do
                    pcall(GrayAndOptimize, descendant)
                end

                local function onCharacterAdded(character)
                    if not character then return end
                    task.wait(0.5)
                    for _, descendant in ipairs(character:GetDescendants()) do
                        pcall(GrayAndOptimize, descendant)
                    end
                end
                if LocalPlayer and LocalPlayer.Character then onCharacterAdded(LocalPlayer.Character) end
                LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
                Services.Players.PlayerAdded:Connect(function(player)
                    player.CharacterAdded:Connect(onCharacterAdded)
                end)

                -- [FIXED - LAG] task.wait(0.1) TRONG event handler chạy cho
                -- MỌI object thêm vào workspace là nguồn lag rất lớn — lúc
                -- farm boss/raid/quest, hàng trăm object sinh ra mỗi giây
                -- (particle, projectile, xác quái, hiệu ứng đòn đánh...),
                -- MỖI CÁI đều tạo 1 lần yield 100ms → dồn ứ lịch chạy, đúng
                -- khớp mô tả "farm boss/lv/quest rất lag" của boss man.
                -- Bỏ hẳn wait, không cần thiết (set Color/Material ngay sau
                -- khi object được tạo là an toàn). Thêm lọc loại object
                -- SỚM để khỏi tốn pcall cho thứ chắc chắn không liên quan
                -- đồ hoạ (Script, Sound, Folder, Value...).
                local GRAYABLE_CLASSES = {
                    BasePart = true, MeshPart = true, UnionOperation = true,
                    Decal = true, Texture = true, ParticleEmitter = true,
                    Trail = true, Smoke = true, Fire = true,
                }
                workspace.DescendantAdded:Connect(function(descendant)
                    if not (Config.Configuration and Config.Configuration.FpsBoost) then return end
                    if not GRAYABLE_CLASSES[descendant.ClassName] then return end
                    pcall(GrayAndOptimize, descendant)
                end)

                print("[✅ FPS Boost] Đã bật gray mode + giảm đồ hoạ (raw9jjs)")
            end)
        end)
    end
    EnableFpsBoost()
    QueueList = {}
    function NearbyHopHandler()
        do return end
        if NearbyHopHandlerDebounce and os.time() - NearbyHopHandlerDebounce < 10 then return end
        NearbyHopHandlerDebounce = os.time()
        for J, J in a:GetPlayers() do
            local k = J and J.Character and J.Character:FindFirstChild("HumanoidRootPart") and J.Character.HumanoidRootPart.Position
            if k then
                local W = QueueList[J.Name]
                if not W then
                    QueueList[J.Name] = os.time()
                else
                    if os.time() - W > 30 then
                        if CaculateDistance(k) < 100 then
                            Hop('nearby plr')
                            -- [FIXED - bớt delay theo yêu cầu boss man] 5s → 2s
                            task.wait(2)
                        else
                            QueueList[J.Name] = nil
                        end
                    end
                end
            end
        end
    end
    task.spawn(function()
        while task.wait() do
            if not _G.Stop then
                NearbyHopHandler()
                if LocalPlayer.Character:FindFirstChild('Humanoid') and LocalPlayer.Character.Humanoid.Sit then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                pcall(RefreshPlayerData)
                local J = os.time() - timeee
                local r = J + OldSessionTime
                if writefile then pcall(writefile, ".tdif-" .. game.Players.LocalPlayer.Name, tostring(r)) end
                if ScriptStorage.Interface then
                    SetText('LiveTime', "Total Elapsed Time: " .. DispTime(r, true) .. ' Elapsed Time: ' .. DispTime(J, true))
                end
                RefreshDebounce = os.time()
            end
        end
    end)
    AddPoint()
    Remotes.CommF_:InvokeServer("Cousin", 'Buy')
    task.spawn(function()
        task.wait(Config.Configuration.AutoHopDelay)
        if not Config.Configuration.AutoHop then Hop('Autohop') end
    end)

    -- ============================================================
    -- AUTO SEA 2 & 3 (CÁC THREAD RIÊNG)
    -- ============================================================
    task.spawn(function()
        while task.wait(0.5) do
            if Config.AutoSea2 then
                pcall(function()
                    if ScriptStorage.PlayerData.Level >= 700 and SeaIndex ~= 2 then
                        _G.SeaTransitionActive = true  -- [ADDED] đồng bộ với AutoSea3, tránh LevelFarm giành tween
                        local iceDoor = workspace.Map.Ice.Door
                        if iceDoor and iceDoor.CanCollide == true and iceDoor.Transparency == 0 then
                            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Key")
                            TweenController.Create(CFrame.new(1347.71, 37.38, -1325.65))
                            repeat task.wait() until not Config.AutoSea2 or (HumanoidRootPart and (HumanoidRootPart.Position - Vector3.new(1347.71, 37.38, -1325.65)).Magnitude < 5)
                        elseif iceDoor and iceDoor.CanCollide == false and iceDoor.Transparency == 1 then
                            if workspace.Enemies:FindFirstChild("Ice Admiral") then
                                CombatController.Attack("Ice Admiral")
                                repeat task.wait() until not Config.AutoSea2 or not workspace.Enemies:FindFirstChild("Ice Admiral") or workspace.Enemies["Ice Admiral"].Humanoid.Health <= 0
                                Remotes.CommF_:InvokeServer("TravelDressrosa")
                            else
                                TweenController.Create(CFrame.new(1347.71, 37.38, -1325.65))
                            end
                        else
                            Remotes.CommF_:InvokeServer("TravelDressrosa")
                        end
                        -- [ADDED] Check PlaceId thật để xác nhận đã sang Sea 2, timeout 60s tránh treo vĩnh viễn
                        local waitStart = tick()
                        repeat
                            task.wait(1)
                        until game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
                           or SeaIndex == 2 or (tick() - waitStart) > 60
                        _G.SeaTransitionActive = false
                    end
                end)
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.5) do
            if not Config.AutoSea3 then _G.SeaTransitionActive = false end
            if SeaIndex == 3 then _G.RipIndraBegun = false end
            if Config.AutoSea3 then
                pcall(function()
                    -- [FIXED] Thiếu "SeaIndex ~= 3" — trước đây vòng lặp này
                    -- chạy MÃI MÃI kể cả sau khi đã ở Sea 3, tiếp tục gọi
                    -- BartiloQuestProgress/tween mỗi 0.5s dù đã xong quest,
                    -- có thể trả giá trị lạ và tween lung tung. AutoSea2 bên
                    -- trên đã có sẵn check này, AutoSea3 bị thiếu do sót.
                    if ScriptStorage.PlayerData.Level >= 1500 and SeaIndex ~= 3 then
                        -- [ADDED] Khóa LevelFarm lại — "bỏ mấy thứ làm dang dở
                        -- khác" trong lúc đang xử lý quest/di chuyển sang Sea 3
                        _G.SeaTransitionActive = true

                        local bartiloProgress = Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo")
                        if bartiloProgress == 0 then
                            local questText = game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                            if string.find(questText, "Swan Pirates") and string.find(questText, "50") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then
                                local swan = workspace.Enemies:FindFirstChild("Swan Pirate")
                                if swan and swan:FindFirstChild("Humanoid") and swan.Humanoid.Health > 0 then
                                    CombatController.Attack("Swan Pirate")
                                else
                                    TweenController.Create(CFrame.new(1057.93, 137.61, 1242.08))
                                end
                            else
                                TweenController.Create(CFrame.new(-456.29, 73.02, 299.90))
                            end
                        elseif bartiloProgress == 1 then
                            local jeremy = workspace.Enemies:FindFirstChild("Jeremy")
                            if jeremy and jeremy:FindFirstChild("Humanoid") and jeremy.Humanoid.Health > 0 then
                                CombatController.Attack("Jeremy")
                            else
                                TweenController.Create(CFrame.new(2099.88, 448.93, 648.00))
                            end
                        elseif bartiloProgress == 2 then
                            TweenController.Create(CFrame.new(-1836, 11, 1714))
                            if CaculateDistance(CFrame.new(-1836, 11, 1714)) < 5 then
                                local positions = {
                                    CFrame.new(-1850.49, 13.18, 1750.90),
                                    CFrame.new(-1858.87, 19.38, 1712.02),
                                    CFrame.new(-1803.94, 16.58, 1750.90),
                                    CFrame.new(-1858.56, 16.86, 1724.80),
                                    CFrame.new(-1869.54, 15.99, 1681.01),
                                    CFrame.new(-1800.10, 16.50, 1684.52),
                                    CFrame.new(-1819.26, 14.80, 1717.91),
                                    CFrame.new(-1813.52, 14.86, 1724.80)
                                }
                                for _, pos in ipairs(positions) do
                                    if not Config.AutoSea3 then break end
                                    HumanoidRootPart.CFrame = pos
                                    task.wait(0.1)
                                end
                            end
                        elseif bartiloProgress == 3 then
                            local unlockables = Remotes.CommF_:InvokeServer("GetUnlockables")
                            if unlockables.FlamingoAccess == nil then
                                local inventoryFruits = Remotes.CommF_:InvokeServer("getInventoryFruits")
                                local fruitStore = {}
                                for _, v in pairs(inventoryFruits) do
                                    for i1, v1 in pairs(v) do
                                        if i1 == "Name" then table.insert(fruitStore, v1) end
                                    end
                                end
                                local fruitPrices = Remotes.CommF_:InvokeServer("GetFruits")
                                local availableFruits = {}
                                for _, v in next, fruitPrices do
                                    if v.Price >= 1000000 then table.insert(availableFruits, v.Name) end
                                end
                                for _, fruitName in pairs(availableFruits) do
                                    for _, storeFruit in pairs(fruitStore) do
                                        if fruitName == storeFruit and unlockables.FlamingoAccess == nil then
                                            if not game.Players.LocalPlayer.Backpack:FindFirstChild(fruitName) then
                                                Remotes.CommF_:InvokeServer("LoadFruit", fruitName)
                                            else
                                                Remotes.CommF_:InvokeServer("TalkTrevor", "1")
                                                Remotes.CommF_:InvokeServer("TalkTrevor", "2")
                                                Remotes.CommF_:InvokeServer("TalkTrevor", "3")
                                            end
                                        end
                                    end
                                end
                                Remotes.CommF_:InvokeServer("TalkTrevor", "1")
                                Remotes.CommF_:InvokeServer("TalkTrevor", "2")
                                Remotes.CommF_:InvokeServer("TalkTrevor", "3")
                            else
                                local zCheck = Remotes.CommF_:InvokeServer("ZQuestProgress", "Check")
                                if zCheck == 0 then
                                    local rip_indra = workspace.Enemies:FindFirstChild("rip_indra")
                                    if rip_indra and rip_indra:FindFirstChild("Humanoid") and rip_indra.Humanoid.Health > 0 then
                                        -- [FIXED] Đánh XONG rồi CHỜ nó chết hẳn (giống pattern Ice
                                        -- Admiral ở AutoSea2 — đã chạy đúng từ trước), thay vì đánh
                                        -- 1 phát rồi thoát ra chờ vòng poll 0.5s sau mới biết kết quả
                                        CombatController.Attack("rip_indra")
                                        repeat
                                            task.wait()
                                            CombatController.Attack("rip_indra")
                                        until not Config.AutoSea3
                                           or not rip_indra.Parent
                                           or rip_indra.Humanoid.Health <= 0

                                        -- [ADDED] Vừa xác nhận chết xong → re-check + travel NGAY,
                                        -- không đợi vòng poll 0.5s tiếp theo (giữ nhất quán với cách
                                        -- AutoSea2 gọi TravelDressrosa ngay sau khi Ice Admiral chết)
                                        task.wait(1)
                                        local zAfterKill = Remotes.CommF_:InvokeServer("ZQuestProgress", "Check")
                                        if zAfterKill == 1 or zAfterKill == 2 then
                                            Remotes.CommF_:InvokeServer("TravelZou")
                                            local waitStart2 = tick()
                                            repeat
                                                task.wait(1)
                                            until game.PlaceId == 7449423635 or game.PlaceId == 100117331123089
                                               or SeaIndex == 3 or (tick() - waitStart2) > 60
                                        end

                                    elseif not rip_indra then
                                        -- [FIXED] CHỈ gọi "Begin" khi rip_indra CHƯA TỪNG spawn —
                                        -- trước đây branch else này bắt luôn cả trường hợp "vừa giết
                                        -- xong, xác còn đó Health=0", gọi lại Begin liên tục reset
                                        -- quest → zCheck không bao giờ lên 1 → không bao giờ travel.
                                        if not _G.RipIndraBegun then
                                            Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
                                            _G.RipIndraBegun = true
                                        end
                                        TweenController.Create(CFrame.new(2288.80, 15.19, 863.03))
                                    else
                                        -- rip_indra tồn tại nhưng Health<=0 (xác vừa chết, server
                                        -- chưa kịp dọn) → KHÔNG gọi Begin, chỉ đợi rồi để vòng poll
                                        -- 0.5s tiếp theo tự đọc lại zCheck (server cần chút thời gian)
                                        task.wait(1)
                                    end
                                elseif zCheck == 1 then
                                    -- [ADDED] Đây là bước TELEPORT SANG PLACE KHÁC thật sự
                                    -- (Sea 3 = PlaceId khác hẳn, không phải chỉ đổi map trong
                                    -- cùng server). Gọi xong PHẢI đợi xác nhận qua game.PlaceId
                                    -- rồi mới coi là xong — không thì code phía dưới (hoặc
                                    -- LevelFarm) vẫn tưởng đang ở Sea 2, dùng HumanoidRootPart/
                                    -- workspace CŨ đã bị hủy khi qua place mới → dịch tùm lum.
                                    Remotes.CommF_:InvokeServer("TravelZou")
                                    local waitStart = tick()
                                    repeat
                                        task.wait(1)
                                    until game.PlaceId == 7449423635 or game.PlaceId == 100117331123089
                                       or SeaIndex == 3 or (tick() - waitStart) > 60
                                else
                                    local donSwan = workspace.Enemies:FindFirstChild("Don Swan")
                                    if donSwan and donSwan:FindFirstChild("Humanoid") and donSwan.Humanoid.Health > 0 then
                                        CombatController.Attack("Don Swan")
                                    else
                                        TweenController.Create(CFrame.new(2288.80, 15.19, 863.03))
                                    end
                                end
                            end
                        end
                    else
                        -- [ADDED] Level chưa đủ HOẶC đã ở Sea 3 rồi → không có
                        -- lý do gì để khóa LevelFarm nữa, trả lại quyền farm bình thường
                        _G.SeaTransitionActive = false
                    end
                end)
            end
        end
    end)

    -- ============================================================
    -- ANTI LAG / LOW GRAPHICS
    -- ============================================================
    if Config.Configuration and Config.Configuration.LowGraphics ~= false then
        task.spawn(function()
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
                print("[✅ Anti Lag] Đã áp dụng tối ưu đồ họa!")
            end)
        end)
    end

    -- ============================================================
    -- VÒNG LẶP CHÍNH
    -- ============================================================
    while task.wait() do
        if Config.Configuration.HopWhenIdle and LastIdling and os.time() - LastIdling > 300.0 then
            SetTask('MainTask', "Rejoining due idle in 10 min!")
            task.wait(1)
            while task.wait() do game:GetService('TeleportService'):Teleport(game.PlaceId) end
        end
        if not AnimationDelay or os.time() - AnimationDelay > 60 then
            AnimationDelay = os.time()
        end
        if ScriptStorage.PlayerData.Level and ScriptStorage.PlayerData.Level > 0 then
            local J, r = xpcall(RefreshTasksData, debug.traceback)
            if not J then 
                print('[ Error ]', r)
                task.wait(1)
            end
        else
            task.wait(1)
            pcall(RefreshPlayerData)
        end
    end
end

hoangtuveu()
--============================================================
-- [EXTRAS] NO ANIMATION + AUTO REDEEM CODES + AUTO RANDOM FRUIT (GACHA)
-- Opções (pode editar/desligar):
Config.Extras = {
    NoAnimation      = true,   -- desliga as animações do personagem
    AutoRedeemCodes  = true,   -- resgata todos os códigos no início
    AutoGachaFruit   = true,   -- rola o Gacha (Random Fruit) automaticamente
    GachaInterval    = 5,      -- segundos entre cada checagem do gacha
}
--============================================================
task.spawn(function()
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    -- NO ANIMATION
    local function disableAnimations(character)
        if not Config.Extras.NoAnimation or not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                pcall(function() track:Stop(0) end)
            end
        end
        local animate = character:FindFirstChild("Animate")
        if animate then pcall(function() animate.Disabled = true end) end
    end
    if LP.Character then task.spawn(disableAnimations, LP.Character) end
    LP.CharacterAdded:Connect(function(char) task.wait(0.5); disableAnimations(char) end)
    task.spawn(function()
        while task.wait(5) do pcall(disableAnimations, LP.Character) end
    end)

    -- AUTO REDEEM CODES
    task.spawn(function()
        if not Config.Extras.AutoRedeemCodes then return end
        local REDEEM_CODES = {
            "fudd10", "fudd10_V2", "Chandler", "BIGNEWS", "KITT_RESET",
            "Sub2UncleKizaru", "SUB2GAMERROBOT_RESET1", "Sub2Fer999", "Enyu_is_Pro",
            "JCWK", "StarcodeHEO", "MagicBUS", "KittGaming", "Sub2CaptainMaui",
            "Sub2OfficialNoobie", "TheGreatAce", "Sub2NoobMaster123", "Sub2Daigrock",
            "Axiore", "StrawHatMaine", "TantaiGaming", "Bluxxy", "SUB2GAMERROBOT_EXP1",
        }
        local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
        local redeem = remotes:FindFirstChild("Redeem") or remotes:WaitForChild("Redeem", 10)
        local commF = remotes:FindFirstChild("CommF_")
        for _, code in ipairs(REDEEM_CODES) do
            pcall(function()
                if redeem then redeem:InvokeServer(code)
                elseif commF then commF:InvokeServer("Redeem", code) end
            end)
            task.wait(1)
        end
    end)

    -- AUTO RANDOM FRUIT (GACHA - Zioles)
    getgenv().AutoRandomFruit = Config.Extras.AutoGachaFruit

    local GachaRF
    local function getGachaRF()
        if GachaRF then return GachaRF end
        local ok = pcall(function()
            GachaRF = game:GetService("ReplicatedStorage").Modules.Net:WaitForChild("RF/GachaNetworkRF", 10)
        end)
        return ok and GachaRF or nil
    end

    local function GachaCall(ctx)
        local rf = getGachaRF()
        if not rf then return false, "GachaNetworkRF nao encontrado" end
        local ok, result = pcall(function()
            return rf:InvokeServer({
                SpokeNPC = "Blox Fruit Gacha",
                Context = ctx,
                BoxName = "ZiolesGacha",
            })
        end)
        if not ok then return false, tostring(result) end
        return true, result
    end

    task.spawn(function()
        while task.wait(Config.Extras.GachaInterval or 5) do
            if getgenv().AutoRandomFruit and Config.Extras.AutoGachaFruit then
                local ok, result = GachaCall("Check")
                if ok and typeof(result) == "table" and result.RequirementsMet then
                    local ok2, r2 = GachaCall("Purchase")
                    print(ok2 and "[Gacha] Rolado com sucesso!" or ("[Gacha] Falha: " .. tostring(r2)))
                end
            end
        end
    end)

    getgenv().HexHubOficial = {
        Start = function() getgenv().AutoRandomFruit = true; Config.Extras.AutoGachaFruit = true end,
        Stop  = function() getgenv().AutoRandomFruit = false; Config.Extras.AutoGachaFruit = false end,
        Spin  = function() return GachaCall("Purchase") end,
        Check = function() return GachaCall("Check") end,
    }
end)

--============================================================
-- [VOID ATTACK] ATAQUE ENVIADO PELO USUARIO
--============================================================
do
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RS_Remotes = ReplicatedStorage:WaitForChild("Remotes")

local RE_ShootGunEvent = Net:WaitForChild("RE/ShootGunEvent")
local RE_RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
local RE_RegisterHit = Net:WaitForChild("RE/RegisterHit")
local GunValidator = RS_Remotes:WaitForChild("Validator2")

local SUCCESS_SHOOT, SHOOT_FUNCTION = pcall(function()
    return getupvalue(require(ReplicatedStorage.Controllers.CombatController).Attack, 9)
end)

local capturedChild, RemoteId = nil, nil

local function tryCapture(parent)
    if not parent then return end
    for _, item in ipairs(parent:GetChildren()) do
        if item:IsA("RemoteEvent") then
            local attr = item:GetAttribute("Id")
            if attr then
                RemoteId, capturedChild = attr, item
                return true
            end
        end
    end
    return false
end

for _, name in ipairs({"Util","Common","Remotes","Assets","FX"}) do
    local c = ReplicatedStorage:FindFirstChild(name)
    if c then
        tryCapture(c)
        c.ChildAdded:Connect(function(ch)
            if ch:IsA("RemoteEvent") and ch:GetAttribute("Id") then
                RemoteId, capturedChild = ch:GetAttribute("Id"), ch
            end
        end)
    end
end

getgenv().VOidAttack = getgenv().VOidAttack or {}
local CFG = getgenv().VOidAttack

CFG.Enabled          = CFG.Enabled          ~= false
CFG.Range            = CFG.Range            or 90
CFG.AttackPlayers    = CFG.AttackPlayers    ~= false
CFG.AttackMobs       = CFG.AttackMobs       ~= false
CFG.MultiHitCount    = CFG.MultiHitCount    or 3
CFG.MultiHitDelay    = CFG.MultiHitDelay    or 0.02
CFG.LoopDelay        = CFG.LoopDelay        or 0.01
CFG.MeleeDelay       = CFG.MeleeDelay       or 0.12
CFG.UseObfuscated    = CFG.UseObfuscated    ~= false
CFG.VisualActivate   = CFG.VisualActivate   ~= false
CFG.Paralyze         = CFG.Paralyze         ~= false
CFG.ParalyzeTick     = CFG.ParalyzeTick     or 0.01
CFG.ResetCooldown    = CFG.ResetCooldown    ~= false

CFG.HitboxLimbs = CFG.HitboxLimbs or {
    "RightLowerArm","RightUpperArm","LeftLowerArm","LeftUpperArm",
    "RightHand","LeftHand","RightLowerLeg","LeftLowerLeg",
    "RightUpperLeg","LeftUpperLeg","RightFoot","LeftFoot",
    "Head","Torso","HumanoidRootPart"
}

local function GetValidator2()
    if not SUCCESS_SHOOT or not SHOOT_FUNCTION then
        return math.random(1, 99999999), 1
    end

    local v53 = getupvalue(SHOOT_FUNCTION, 13)
    local v54 = getupvalue(SHOOT_FUNCTION, 14)
    local v55 = getupvalue(SHOOT_FUNCTION, 15)
    local v56 = getupvalue(SHOOT_FUNCTION, 16)
    local v57 = getupvalue(SHOOT_FUNCTION, 17)
    local v58 = getupvalue(SHOOT_FUNCTION, 18)
    local v59 = getupvalue(SHOOT_FUNCTION, 19)

    local v93 = v53 * v54
    local v96 = (v55 * v54 + v53 * v56) % v57
    v96 = (v96 * v57 + v93) % v58
    v55 = math.floor(v96 / v57)
    v53 = v96 - v55 * v57
    v59 = v59 + 1

    setupvalue(SHOOT_FUNCTION, 13, v53)
    setupvalue(SHOOT_FUNCTION, 15, v55)
    setupvalue(SHOOT_FUNCTION, 19, v59)

    return math.floor(v96 / v58 * 16777215), v59
end

local function isAlive(m)
    local h = m and m:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function getHitbox(m)
    for _ = 1, 6 do
        local name = CFG.HitboxLimbs[math.random(#CFG.HitboxLimbs)]
        local part = m:FindFirstChild(name)
        if part and part:IsA("BasePart") then return part end
    end
    return m:FindFirstChild("HumanoidRootPart")
end

local function collectTargets(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return {} end
    local pos = root.Position
    local list = {}

    local function scan(folder)
        if not folder then return end
        for _, e in ipairs(folder:GetChildren()) do
            if e ~= char and isAlive(e) then
                local rp = e:FindFirstChild("HumanoidRootPart")
                if rp and (rp.Position - pos).Magnitude <= CFG.Range then
                    list[#list + 1] = e
                end
            end
        end
    end

    if CFG.AttackMobs    then scan(workspace:FindFirstChild("Enemies"))    end
    if CFG.AttackPlayers then scan(workspace:FindFirstChild("Characters")) end
    return list
end

local function buildConfig(targets)
    local cfg = {}
    for _, e in ipairs(targets) do
        local part = getHitbox(e)
        if part then cfg[#cfg + 1] = {e, part} end
    end
    return cfg
end

local function fireStandard(targets)
    local cfg = buildConfig(targets)
    if #cfg == 0 then return end

    local primary = cfg[1][1]:FindFirstChild("Head")
                    or cfg[1][1]:FindFirstChild("HumanoidRootPart")
    if not primary then return end

    RE_RegisterAttack:FireServer(0)
    RE_RegisterHit:FireServer(primary, cfg)
end

local function fireObfuscated(targets)
    if not (CFG.UseObfuscated and capturedChild and RemoteId) then return end
    local cfg = buildConfig(targets)
    if #cfg == 0 then return end

    local primary = cfg[1][1]:FindFirstChild("Head")
                    or cfg[1][1]:FindFirstChild("HumanoidRootPart")
    if not primary then return end

    pcall(function()
        RE_RegisterAttack:FireServer()
        local key1 = string.gsub("RE/RegisterHit", ".", function(ch)
            return string.char(bit32.bxor(string.byte(ch),
                math.floor(workspace:GetServerTimeNow() / 10 % 10) + 1))
        end)
        local seed = Net.seed:InvokeServer() * 2
        local key2 = bit32.bxor(RemoteId + 909090, seed)
        cloneref(capturedChild):FireServer(key1, key2, primary, cfg)
    end)
end

local function clearAllCooldowns(tool)
    if not (CFG.ResetCooldown and tool) then return end
    pcall(function()
        for _, v in ipairs(tool:GetDescendants()) do
            if v:IsA("NumberValue") then
                local n = v.Name:lower()
                if n:find("cooldown") or n:find("cd") or n:find("reload") then
                    v.Value = 0
                end
            end
        end
    end)
end

local paralyzedMobs = {}

local function paralyzeMob(mob)
    if not CFG.Paralyze or not mob or not mob.Parent then return end

    local hrp = mob:FindFirstChild("HumanoidRootPart")
    local hum = mob:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    local stored = paralyzedMobs[mob]
    local lockedPos = stored and stored.pos or hrp.Position
    if not stored then
        paralyzedMobs[mob] = { pos = lockedPos }
    end

    pcall(function()
        if setnetworkowner then setnetworkowner(mob, false) end
    end)

    pcall(function()
        hrp.Velocity = Vector3.zero
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(lockedPos, lockedPos + hrp.CFrame.LookVector)
    end)

    pcall(function()
        hum.WalkSpeed = 0
        hum.JumpPower = 0
        hum.JumpHeight = 0
        hum.AutoRotate = false
    end)

    pcall(function()
        local bp = hrp:FindFirstChild("VOidLock")
        if not bp then
            bp = Instance.new("BodyPosition")
            bp.Name = "VOidLock"
            bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bp.P = 200000
            bp.D = 1000
            bp.Position = lockedPos
            bp.Parent = hrp
        else
            bp.Position = lockedPos
        end

        local bg = hrp:FindFirstChild("VOidGyro")
        if not bg then
            bg = Instance.new("BodyGyro")
            bg.Name = "VOidGyro"
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.P = 200000
            bg.D = 1000
            bg.CFrame = CFrame.new(lockedPos, lockedPos + hrp.CFrame.LookVector)
            bg.Parent = hrp
        else
            bg.CFrame = CFrame.new(lockedPos, lockedPos + hrp.CFrame.LookVector)
        end
    end)
end

local function clearParalyze(mob)
    if not mob then return end
    local hrp = mob:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        if hrp:FindFirstChild("VOidLock") then hrp.VOidLock:Destroy() end
        if hrp:FindFirstChild("VOidGyro") then hrp.VOidGyro:Destroy() end
    end)
    paralyzedMobs[mob] = nil
end

local function attackMelee(char, tool, targets)
    for _, t in ipairs(targets) do paralyzeMob(t) end

    for i = 1, CFG.MultiHitCount do
        task.spawn(function()
            fireStandard(targets)
            fireObfuscated(targets)
        end)
        if i < CFG.MultiHitCount then task.wait(CFG.MultiHitDelay) end
    end

    if CFG.VisualActivate and tool then
        pcall(function() tool:Activate() end)
    end
end

local function attackFruit(char, tool, targets)
    for _, t in ipairs(targets) do paralyzeMob(t) end

    local remote = tool:FindFirstChild("LeftClickRemote")
    if not remote then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local trp  = targets[1]:FindFirstChild("HumanoidRootPart")
    if not (root and trp) then return end
    local dir = (trp.Position - root.Position).Unit
    pcall(function() remote:FireServer(dir, 1) end)
end

local function attackGun(char, tool, targets)
    for _, t in ipairs(targets) do paralyzeMob(t) end

    local hrp = targets[1]:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    clearAllCooldowns(tool)

    pcall(function()
        tool:SetAttribute("LocalTotalShots", (tool:GetAttribute("LocalTotalShots") or 0) + 1)
    end)

    pcall(function()
        GunValidator:FireServer(GetValidator2())
    end)

    pcall(function()
        RE_ShootGunEvent:FireServer(hrp.Position, { hrp })
    end)
end

local lastMelee = 0

task.spawn(function()
    while task.wait(CFG.LoopDelay) do
        if not CFG.Enabled then continue end

        local char = LocalPlayer.Character
        if not char or not isAlive(char) then continue end

        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then continue end

        local tip = tool.ToolTip
        local now = os.clock()

        if tip == "Melee" or tip == "Sword" then
            if now - lastMelee >= CFG.MeleeDelay then
                local targets = collectTargets(char)
                if #targets > 0 then
                    lastMelee = now
                    pcall(attackMelee, char, tool, targets)
                end
            end

        elseif tip == "Blox Fruit" then
            local targets = collectTargets(char)
            if #targets > 0 then pcall(attackFruit, char, tool, targets) end

        elseif tip == "Gun" then
            local targets = collectTargets(char)
            if #targets > 0 then pcall(attackGun, char, tool, targets) end
        end
    end
end)

task.spawn(function()
    while task.wait(CFG.ParalyzeTick) do
        if not CFG.Enabled or not CFG.Paralyze then continue end

        local char = LocalPlayer.Character
        if not char then continue end

        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then continue end

        local tip = tool.ToolTip
        if tip ~= "Melee" and tip ~= "Sword" and tip ~= "Gun" and tip ~= "Blox Fruit" then
            continue
        end

        local targets = collectTargets(char)
        for _, t in ipairs(targets) do paralyzeMob(t) end

        for mob in pairs(paralyzedMobs) do
            if not mob.Parent or not isAlive(mob) then
                clearParalyze(mob)
            end
        end
    end
end)

getgenv().VOidAttack = CFG

end

--============================================================
-- HEX HUB UI (extraída)
--============================================================
task.spawn(function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local LP = Players.LocalPlayer
    local RS = game:GetService("ReplicatedStorage")
    local PlayerGui = LP:WaitForChild("PlayerGui")
    local CommF
    pcall(function()
        local Remotes = RS:WaitForChild("Remotes", 5)
        if Remotes then CommF = Remotes:WaitForChild("CommF_", 5) end
    end)

    for _, container in ipairs({CoreGui, PlayerGui}) do
        for _, name in ipairs({"Noguchi Status", "Noguchi Ui", "Noguchi Toggle"}) do
            pcall(function()
                local old = container:FindFirstChild(name)
                if old then old:Destroy() end
            end)
        end
    end

    local UI = {}
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Noguchi Ui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 50
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = PlayerGui

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Size = UDim2.new(0, 600, 0, 400)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Active = false
    Frame.Visible = true

    local Frame2 = Instance.new("Frame", Frame)
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.Size = UDim2.new(1, -47, 1, -47)
    Frame2.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame2.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame2.BackgroundTransparency = 0.5
    Frame2.BorderSizePixel = 0
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 5)

    local UIStroke = Instance.new("UIStroke", Frame2)
    UIStroke.Color = Color3.new(255, 255, 255)
    UIStroke.Thickness = 4

    local UIGradient = Instance.new("UIGradient", UIStroke)
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(204, 52, 235)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(97, 0, 117))
    })

    local function makeLabel(text, pos, size)
        local lbl = Instance.new("TextLabel", Frame2)
        lbl.Size = size or UDim2.new(0, 200, 0, 18)
        lbl.Position = pos
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.new(1, 1, 1)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 16
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 2
        return lbl
    end

    local TextLabel = makeLabel("Hex Hub", UDim2.new(0.4, 0, 0.05, 0))
    local UIGradient2 = Instance.new("UIGradient", TextLabel)
    UIGradient2.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(204, 52, 235)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(97, 0, 117))
    })

    local TextLabel2 = makeLabel(" Account Stats ", UDim2.new(0.2, 0, 0.25, 0), UDim2.new(0, 150, 0, 18))
    TextLabel2.TextSize = 18
    local UIGradient3 = Instance.new("UIGradient", TextLabel2)
    UIGradient3.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(204, 52, 235)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(97, 0, 117))
    })

    local TextLabel3 = makeLabel(" Account Items ", UDim2.new(0.75, 0, 0.25, 0), UDim2.new(0, 150, 0, 18))
    TextLabel3.TextSize = 18
    local UIGradient4 = Instance.new("UIGradient", TextLabel3)
    UIGradient4.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(204, 52, 235)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(97, 0, 117))
    })

    UI.Level = makeLabel("Level: 0", UDim2.new(0.07, 0, 0.35, 0))
    UI.Race = makeLabel("Race: ?", UDim2.new(0.07, 0, 0.45, 0))
    UI.Beli = makeLabel("Beli: 0", UDim2.new(0.07, 0, 0.55, 0))
    UI.Frag = makeLabel("Frag: 0", UDim2.new(0.07, 0, 0.65, 0))
    UI.GodHuman = makeLabel("🔴 GodHuman", UDim2.new(0.07, 0, 0.80, 0))
    UI.CDK = makeLabel("🔴 Cursed Dual Katana", UDim2.new(0.4, 0, 0.80, 0))
    UI.SkullGuitar = makeLabel("🔴 Skull Guitar", UDim2.new(0.07, 0, 0.90, 0))
    UI.MirrorFractal = makeLabel("🔴 Mirror Fractal", UDim2.new(0.4, 0, 0.90, 0))
    UI.Valkyrie = makeLabel("🔴 Valkyrie Helm", UDim2.new(0.75, 0, 0.80, 0), UDim2.new(0, 150, 0, 18))
    UI.PullLever = makeLabel("🔴 Pull Lever", UDim2.new(0.75, 0, 0.90, 0), UDim2.new(0, 150, 0, 18))

    local CanvasGroup = Instance.new("CanvasGroup", Frame2)
    CanvasGroup.Size = UDim2.new(0.4, 0, 0.35, 0)
    CanvasGroup.Position = UDim2.new(0.55, 0, 0.35, 0)
    CanvasGroup.BackgroundTransparency = 1

    local ScrollingFrame = Instance.new("ScrollingFrame", CanvasGroup)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarImageTransparency = 1
    ScrollingFrame.ScrollBarThickness = 4
    ScrollingFrame.ZIndex = 2

    local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 2)

    UI.addItemLabel = function(text)
        local label = Instance.new("TextLabel", ScrollingFrame)
        label.Size = UDim2.new(1, 0, 0, 18)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 2
        return { Destroy = function() label:Destroy() end }
    end

    local godhumanUnlocked = false
    if CommF then
        task.spawn(function()
            while not (CommF:InvokeServer("BuyGodhuman") == 1 or CommF:InvokeServer("BuyGodhuman") == 2) do
                task.wait(3600)
            end
            godhumanUnlocked = true
        end)
    end
    UI.getGodHuman = function() return godhumanUnlocked end

    for _, grad in ipairs({UIGradient, UIGradient2, UIGradient3, UIGradient4}) do
        task.spawn(function()
            while true do
                local tween = TweenService:Create(grad, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false, 0), { Rotation = 360 })
                tween:Play()
                tween.Completed:Wait()
                grad.Rotation = 0
            end
        end)
    end

    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Name = "Noguchi Toggle"
    ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
    ToggleBtn.AnchorPoint = Vector2.new(0, 0.5)
    ToggleBtn.Position = UDim2.new(0, 15, 0.5, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    ToggleBtn.Image = "rbxthumb://type=Asset&id=100653737935048&w=420&h=420"
    ToggleBtn.ZIndex = 100
    ToggleBtn.Draggable = true
    ToggleBtn.Active = true
        ToggleBtn.Parent = ScreenGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    local BtnStroke = Instance.new("UIStroke", ToggleBtn)
    BtnStroke.Color = Color3.fromRGB(255, 255, 255)
    BtnStroke.Thickness = 2.5
    BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ToggleBtn.MouseButton1Click:Connect(function()
        Frame.Visible = not Frame.Visible
    end)
    -- stats (1s)
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                local data = LP:FindFirstChild("Data")
                if data then
                    UI.Level.Text = "Level: " .. tostring(data:FindFirstChild("Level") and data.Level.Value or 0)
                    UI.Race.Text = "Race: " .. tostring(data:FindFirstChild("Race") and data.Race.Value or "?")
                    UI.Beli.Text = "Beli: " .. tostring(data:FindFirstChild("Beli") and data.Beli.Value or 0)
                    local frags = data:FindFirstChild("Fragments")
                    UI.Frag.Text = "Frag: " .. (frags and tostring(frags.Value) or "Only Sea 2, 3")
                end
            end)
        end
    end)

    -- inventario (2s)
    local _inventoryLabels = {}
    task.spawn(function()
        while task.wait(2) do
            if not CommF then continue end
            pcall(function()
                for labelObj in pairs(_inventoryLabels) do pcall(function() labelObj:Destroy() end) end
                _inventoryLabels = {}
                local inventory = CommF:InvokeServer("getInventory")
                if type(inventory) == "table" then
                    for _, item in pairs(inventory) do
                        local itemName = item.Name or "?"
                        local labelObj = UI.addItemLabel(string.format("%s - %s", itemName, item.Count or item.Type or ""))
                        _inventoryLabels[labelObj] = true
                        if itemName == "Cursed Dual Katana" then UI.CDK.Text = "🟢 Cursed Dual Katana"
                        elseif itemName == "Skull Guitar" then UI.SkullGuitar.Text = "🟢 Skull Guitar"
                        elseif itemName == "Mirror Fractal" then UI.MirrorFractal.Text = "🟢 Mirror Fractal"
                        elseif itemName == "Valkyrie Helm" then UI.Valkyrie.Text = "🟢 Valkyrie Helm" end
                    end
                end
                UI.GodHuman.Text = UI.getGodHuman() and "🟢 GodHuman" or "🔴 GodHuman"
                local doorOpen = CommF:InvokeServer("CheckTempleDoor")
                UI.PullLever.Text = doorOpen and "🟢 Pull Lever" or "🔴 Pull Lever"
            end)
        end
    end)

    getgenv().HexUI = UI
end)
