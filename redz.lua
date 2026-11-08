-- Recovered Luau source by ZeroVector
local v, tbl

do
    if not Core or not Core.Halloween then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptpastebin/Blox-Fruits/refs/heads/main/core.luau"))()
    end

    v = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Redz/ui.luau"))():MakeWindow({
        Title = "Winex Hub",
        SubTitle = "by @realducz99 And Trần Duy Khánh",
        SaveFolder = "oknaiget.json",
    })

    local v2 = v:NewMinimizer({KeyCode = Enum.KeyCode.LeftControl})

    v2:CreateMobileMinimizer({
        Image = "rbxassetid://81975913774040",
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
    })

    tbl = {
        Info = v:MakeTab({Title = "Tổng quan", Icon = "Scroll"}),
        Main = v:MakeTab({Title = "Cày tự động", Icon = "rbxassetid://7733960981"}),
        Settings = v:MakeTab({Title = "Cấu hình", Icon = "Settings"}),
        Halloween = v:MakeTab({Title = "Sự kiện Halloween", Icon = "ghost"}),
        Fish = v:MakeTab({
            Title = "Trung tâm câu cá",
            Icon = "rbxassetid://127664059821666",
        }),
        Quests = v:MakeTab({
            Title = "Nhiệm vụ và vật phẩm",
            Icon = "Swords",
        }),
        SeaEvent = v:MakeTab({Title = "Sự kiện biển", Icon = "waves"}),
        Race = v:MakeTab({
            Title = "Khám phá đảo Mirage",
            Icon = "rbxassetid://11162889532",
        }),
        RaceV4 = v:MakeTab({Title = "Thức tỉnh tộc V4", Icon = "Moon"}),
        Hop = v:MakeTab({Title = "Chuyển máy chủ", Icon = "Gem"}),
        Prehistoric = v:MakeTab({Title = "Sự kiện tiền sử", Icon = "palmtree"}),
        Esp = v:MakeTab({
            Title = "Chỉ số và ESP",
            Icon = "Signal",
        }),
        Raids = v:MakeTab({
            Title = "Trái ác quỷ & Đột kích",
            Icon = "cherry",
        }),
        Combat = v:MakeTab({
            Title = "Công cụ chiến đấu",
            Icon = "user",
        }),
        Travel = v:MakeTab({Title = "Trung tâm di chuyển", Icon = "locate"}),
        Shop = v:MakeTab({Title = "Cửa hàng vật phẩm", Icon = "Shoppingcart"}),
        Misc = v:MakeTab({
            Title = "Tính năng khác",
            Icon = "rbxassetid://10709783577",
        }),
    }

    tbl.Halloween:AddSection("Sự kiện Halloween")
    local v3 = tbl.Halloween:AddParagraph("Trạng thái Halloween", "Đang chờ lõi sự kiện")

    for i, v4 in ipairs({
        {
            "TrickOrTreat",
            "Auto Trick Or Treat",
            "Ready doors, rewards, matching cards and your door's enemies.",
        },
        {
            "Pumpkins",
            "Auto Farm Pumpkins",
            "Break nearby pumpkins for Candy Corn and Pumpkin Bits.",
        },
        {
            "Jack",
            "Auto Kill Event Enemy",
            "Fight randomly spawned Jack o' Lantern enemies.",
        },
        {
            "Bosses",
            "Auto Halloween Bosses",
            "Fight spawned Hellfire and Great Pumpkin bosses.",
        },
        {
            "Summon",
            "Auto Summon Great Pumpkin",
            "Use 3 Cursed Pumpkin Seeds and 200 Pumpkin Bits at the Witch.",
        },
        {
            "Gacha",
            "Auto Spooky Gacha",
            "Check Candy Corn Before Rolling.",
        },
    }) do
        local v5 = v4[1]

        tbl.Halloween:AddToggle({
            Name = v4[2],
            Description = v4[3],
            Default = false,
            Callback = function(arg)
                if Core and Core.Halloween then
                    Core.Halloween:SetEnabled(v5, arg)
                elseif arg then
                    v:Notify({
                        Title = "Halloween",
                        Content = "Hãy tải lõi phiên bản mới trước khi bật Halloween.",
                        Duration = 5,
                    })
                end
            end,
        })
    end

    task.spawn(function()
        while task.wait(1) do
            if Core and Core.Halloween then
                v3:SetDesc(Core.Halloween.Status)
            end
        end
    end)

    tbl.Info:AddSection("Status Server")
    local v4 = tbl.Info:AddParagraph("Time Zone", "")
    local v5 = tbl.Info:AddParagraph("Game Time", "")

    UpdateOS = function()
        local v6 = os.date("*t")
        local n = v6.hour % 24
        local str = n < 12 and "AM" or "PM"
        local str2 = string.format("%02i:%02i:%02i %s", (n - 1) % 12 + 1, v6.min, v6.sec, str)
        local str3 = string.format("%02d/%02d/%04d", v6.day, v6.month, v6.year)
        local LocalizationService = game:GetService("LocalizationService")
        local localPlayer = game:GetService("Players").LocalPlayer
        local countryRegionCode

        if getgenv().countryRegionCode then
            countryRegionCode = getgenv().countryRegionCode
        else
            local ok, countryRegionCode2 = pcall(function()
                return LocalizationService:GetCountryRegionForPlayerAsync(localPlayer)
            end)

            countryRegionCode = countryRegionCode2

            if ok then
                getgenv().countryRegionCode = countryRegionCode2
            else
                getgenv().countryRegionCode = "Unknown"
            end
        end

        v4:SetDesc(str3 .. " - " .. str2 .. " [ " .. countryRegionCode .. " ]")
    end

    spawn(function()
        while true do
            UpdateOS()
            wait(1)
        end
    end)

    UpdateGameTime = function()
        local n = math.floor(workspace.DistributedGameTime + 0.5)
        local n2 = math.floor(n / 3600) % 24
        local n3 = math.floor(n / 60) % 60
        local n4 = math.floor(n / 1) % 60
        v5:SetDesc(n2 .. " Hour (h) " .. n3 .. " Minute (m) " .. n4 .. " Second (s)")
    end

    spawn(function()
        while true do
            UpdateGameTime()
            wait(1)
        end
    end)

    local v6 = tbl.Info:AddParagraph("Mirage Island", "Status: ")
    local str = ""

    spawn(function()
        pcall(function()
            while true do
                wait(1)
                local flag = game.Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") ~= nil
                local status = flag and "✅" or "❌"

                if status ~= str then
                    v6:SetDesc("Status: " .. status)
                    str = status
                end
            end
        end)
    end)

    local v7 = tbl.Info:AddParagraph("Kitsune Island", "Status: ")
    local str2 = ""

    spawn(function()
        while task.wait(1) do
            pcall(function()
                local kitsuneIsland = game:GetService("Workspace").Map:FindFirstChild("KitsuneIsland")
                local status = kitsuneIsland and "✅" or "❌"

                if status ~= str2 then
                    v7:SetDesc("Status: " .. status)
                    str2 = status
                end
            end)
        end
    end)

    local v8 = tbl.Info:AddParagraph("Prehistoric Island", "Status: ")
    local str3 = ""

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                local prehistoricIsland = game.Workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island")
                local status = prehistoricIsland and "✅" or "❌"

                if status ~= str3 then
                    v8:SetDesc("Status: " .. status)
                    str3 = status
                end
            end)
        end
    end)

    local v9 = tbl.Info:AddParagraph("Frozen Dimension", "Status: ")
    local str4 = ""

    spawn(function()
        while wait(1) do
            pcall(function()
                local frozenDimension = game.Workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension")
                local status = frozenDimension and "✅" or "❌"

                if status ~= str4 then
                    v9:SetDesc("Status: " .. status)
                    str4 = status
                end
            end)
        end
    end)

    local v10 = tbl.Info:AddParagraph("Cake Prince", "")

    spawn(function()
        while wait(1) do
            local ok, result = pcall(function()
                return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
            end)

            local str5 = "Cake Prince: ✅"

            if ok and type(result) == "string" and string.len(result) >= 86 then
                str5 = "Killed: " .. string.sub(result, 39, 41)
            end

            v10:SetDesc(str5)
        end
    end)

    local v11 = tbl.Info:AddParagraph("Rip Indra", "Status: ")
    local str5 = ""

    spawn(function()
        while wait(1) do
            pcall(function()
                local ripIndraTrueForm = game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form")
                local status = (ripIndraTrueForm or game:GetService("Workspace").Enemies:FindFirstChild("rip_indra")) and "✅" or "❌"

                if status ~= str5 then
                    v11:SetDesc("Status: " .. status)
                    str5 = status
                end
            end)
        end
    end)

    local v12 = tbl.Info:AddParagraph("Dough King", "Status: ")
    local str6 = ""

    spawn(function()
        while wait(1) do
            pcall(function()
                local doughKing = game:GetService("ReplicatedStorage"):FindFirstChild("Dough King")
                local status = (doughKing or game:GetService("Workspace").Enemies:FindFirstChild("Dough King")) and "✅" or "❌"

                if status ~= str6 then
                    v12:SetDesc("Status: " .. status)
                    str6 = status
                end
            end)
        end
    end)

    local v13 = tbl.Info:AddParagraph("Full Moon", "")

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                local moonTextureId = game:GetService("Lighting").Sky.MoonTextureId
                local str7 = "Moon: 0/5"

                if moonTextureId == "http://www.roblox.com/asset/?id=9709149431" then
                    str7 = "Moon: 5/5 (Full Moon) ✅"
                elseif moonTextureId == "http://www.roblox.com/asset/?id=9709149052" then
                    str7 = "Moon: 4/5"
                elseif moonTextureId == "http://www.roblox.com/asset/?id=9709143733" then
                    str7 = "Moon: 3/5"
                elseif moonTextureId == "http://www.roblox.com/asset/?id=9709150401" then
                    str7 = "Moon: 2/5"
                elseif moonTextureId == "http://www.roblox.com/asset/?id=9709149680" then
                    str7 = "Moon: 1/5"
                end

                v13:SetDesc(str7)
            end)
        end
    end)

    local v14 = tbl.Info:AddParagraph("Legendary Sword", "Status: ")

    spawn(function()
        while wait(5) do
            pcall(function()
                local tbl2 = {}

                for i, v15 in ipairs({"Shizu", "Saishi", "Oroshi"}) do
                    if GetWP(v15) then
                        table.insert(tbl2, v15 .. " ✅")
                    end
                end

                local setDesc = v14.SetDesc
                local str7 = #tbl2 > 0 and table.concat(tbl2, ", ") or "Not Found"
                setDesc(v14, str7)
            end)
        end
    end)

    local Bone_ = tbl.Info:AddParagraph("Bone", "")

    spawn(function()
        while wait(1) do
            pcall(function()
                local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check")
                Bone_:SetDesc("You Have: " .. tostring(response) .. " Bones")
            end)
        end
    end)

    local rfSubmarineWorkerSpeak = replicated.Modules.Net["RF/SubmarineWorkerSpeak"]

    local v15 = tbl.Main:AddDropdown({
        Name = "Chọn vũ khí",
        Options = {"Melee", "Sword", "Blox Fruit", "Gun"},
        Default = "Melee",
        Callback = function(chooseWP)
            _G.ChooseWP = chooseWP
        end,
    })

    WeaponDropdown = v15

    tbl.Main:AddDropdown({
        Name = "Kích thước giao diện",
        Options = {"Small", "Normal", "Big"},
        Default = "Normal",
        Callback = function(arg)
            v:SetUIScale(({Small = 0.8, Normal = 1, Big = 1.2})[arg])
        end,
    })

    tbl.Main:AddSection("Cày tự động")

    local v16 = tbl.Main:AddToggle({
        Name = "Cày tự động cấp độ",
        Description = "",
        Default = false,
        Callback = function(level)
            _G.Level = level

            if not level then
                alreadyTeleported = false
                teleporting = false
            end
        end,
    })

    FarmLevel = v16

    local v17 = tbl.Main:AddToggle({
        Name = "Cày tự động gần nhất",
        Description = "",
        Default = false,
        Callback = function(autoFarmNear)
            _G.AutoFarmNear = autoFarmNear
        end,
    })

    ClosetMons = v17

    local v18 = tbl.Main:AddToggle({
        Name = "Tự động Nhà máy Đột kích",
        Description = "",
        Default = false,
        Callback = function(autoFactory)
            _G.AutoFactory = autoFactory
        end,
    })

    FactoryRaids = v18

    local v19 = tbl.Main:AddToggle({
        Name = "Tự động Hải tặc Đột kích",
        Description = "",
        Default = false,
        Callback = function(autoRaidCastle)
            _G.AutoRaidCastle = autoRaidCastle
        end,
    })

    CastleRaids = v19

    local v20 = tbl.Main:AddToggle({
        Name = "Cày tự động Ectoplasm",
        Description = "",
        Default = false,
        Callback = function(autoEctoplasm)
            _G.AutoEctoplasm = autoEctoplasm
        end,
    })

    Ecto = v20
    tbl.Main:AddSection("Chest")

    local v21 = tbl.Main:AddToggle({
        Name = "Cày tự động rương",
        Description = "",
        Default = false,
        Callback = function(autoFarmChest)
            _G.AutoFarmChest = autoFarmChest
        end,
    })

    ChestTW = v21

    local v22 = tbl.Main:AddToggle({
        Name = "Tự động rương Bypass",
        Description = "",
        Default = false,
        Callback = function(autoChestBP)
            _G.AutoChestBP = autoChestBP

            if autoChestBP then
                local localPlayer = game:GetService("Players").LocalPlayer
                local flag = false
                local tbl2 = {}
                local flag2 = true

                local function fn()
                    if not localPlayer.Character then
                        localPlayer.CharacterAdded:Wait()
                    end

                    localPlayer.Character:WaitForChild("HumanoidRootPart")
                    return localPlayer.Character
                end

                local function fn2()
                    if flag2 then
                        flag2 = false

                        for k, descendant in pairs(game:GetDescendants()) do
                            if descendant.Name:find("Chest") and descendant.ClassName == "Part" then
                                table.insert(tbl2, descendant)
                            end
                        end
                    end

                    local tbl3 = {}

                    for k, v22 in pairs(tbl2) do
                        if v22:FindFirstChild("TouchInterest") then
                            table.insert(tbl3, v22)
                        end
                    end

                    local lowerTorso = fn().LowerTorso

                    table.sort(tbl3, function(arg, arg2)
                        local flag3 = (lowerTorso.Position - arg.Position).Magnitude < (lowerTorso.Position - arg2.Position).Magnitude
                        return flag3
                    end)

                    return tbl3
                end

                local function fn3()
                    if flag then
                        return
                    end
                    flag = true

                    task.spawn(function()
                        while _G.AutoChestBP and localPlayer.Character and localPlayer.Character.Parent do
                            local v22 = fn2()

                            if #v22 > 0 then
                                fn().HumanoidRootPart.CFrame = v22[1].CFrame
                            end

                            task.wait(0.1)
                        end

                        flag = false
                    end)
                end

                localPlayer.CharacterAdded:Connect(function()
                    fn()
                    task.wait(0.5)

                    if _G.AutoChestBP then
                        fn3()
                    end
                end)

                fn3()
            end
        end,
    })

    ChestBP = v22

    local v23 = tbl.Main:AddToggle({
        Name = "Dừng vật phẩm",
        Description = "",
        Default = true,
        Callback = function(stopWhenChalice)
            _G.StopWhenChalice = stopWhenChalice
        end,
    })

    StopI = v23
    tbl.Main:AddSection("Collect Berry")

    local v24 = tbl.Main:AddToggle({
        Name = "Cày tự động quả mọng",
        Description = "",
        Default = false,
        Callback = function(autoBerry)
            _G.AutoBerry = autoBerry
        end,
    })

    Berry = v24

    local v25 = tbl.Main:AddToggle({
        Name = "Cày tự động quả mọng + chuyển máy chủ",
        Description = "",
        Default = false,
        Callback = function(autoBerryH)
            _G.AutoBerryH = autoBerryH
        end,
    })

    BerryH = v25
    tbl.Main:AddSection("Farm Mob")

    if World1 then
        tbl.Main:AddDropdown({
            Name = "Chọn quái",
            Default = Bandit,
            Options = {
                "Bandit",
                "Monkey",
                "Gorilla",
                "Pirate",
                "Brute",
                "Desert Bandit",
                "Desert Officer",
                "Snow Bandit",
                "Snowman",
                "Chief Petty Officer",
                "Sky Bandit",
                "Dark Master",
                "Toga Warrior",
                "Gladiator",
                "Military Soldier",
                "Military Spy",
                "Fishman Warrior",
                "Fishman Commando",
                "God's Guard",
                "Shanda",
                "Royal Squad",
                "Royal Soldier",
                "Galley Pirate",
                "Galley Captain",
            },
            Callback = function(selectMob)
                getgenv().SelectMob = selectMob
            end,
        })
    end

    if World2 then
        tbl.Main:AddDropdown({
            Name = "Chọn quái",
            Default = Raider,
            Options = {
                "Raider",
                "Mercenary",
                "Swan Pirate",
                "Factory Staff",
                "Marine Lieutenant",
                "Marine Captain",
                "Zombie",
                "Vampire",
                "Snow Trooper",
                "Winter Warrior",
                "Lab Subordinate",
                "Horned Warrior",
                "Magma Ninja",
                "Lava Pirate",
                "Ship Deckhand",
                "Ship Engineer",
                "Ship Steward",
                "Ship Officer",
                "Arctic Warrior",
                "Snow Lurker",
                "Sea Soldier",
                "Water Fighter",
            },
            Callback = function(selectMob)
                getgenv().SelectMob = selectMob
            end,
        })
    end

    if World3 then
        tbl.Main:AddDropdown({
            Name = "Chọn quái",
            Options = {
                "Pirate Millionaire",
                "Dragon Crew Warrior",
                "Dragon Crew Archer",
                "Female Islander",
                "Giant Islander",
                "Marine Commodore",
                "Marine Rear Admiral",
                "Fishman Raider",
                "Fishman Captain",
                "Forest Pirate",
                "Mythological Pirate",
                "Jungle Pirate",
                "Musketeer Pirate",
                "Reborn Skeleton",
                "Living Zombie",
                "Demonic Soul",
                "Posessed Mummy",
                "Peanut Scout",
                "Peanut President",
                "Ice Cream Chef",
                "Ice Cream Commander",
                "Cookie Crafter",
                "Cake Guard",
                "Baking Staff",
                "Head Baker",
                "Cocoa Warrior",
                "Chocolate Bar Battler",
                "Sweet Thief",
                "Candy Rebel",
                "Candy Pirate",
                "Snow Demon",
                "Isle Outlaw",
                "Island Boy",
                "Sun-kissed Warrior",
                "Isle Champion",
            },
            Callback = function(selectMob)
                getgenv().SelectMob = selectMob
            end,
        })
    end

    tbl.Main:AddToggle({
        Name = "Tự động Tiêu diệt quái",
        Default = false,
        Callback = function(autoKillMob)
            _G.AutoKillMob = autoKillMob
        end,
    })

    tbl.Main:AddSection("Farm All Island")

    tbl.Main:AddDropdown({
        Name = "Chọn đảo",
        Options = (function()
            local tbl2 = {}
            local v26 = pairs
            local island = Core.Island
            local tbl3 = island or {}

            for k in v26(tbl3) do
                table.insert(tbl2, k)
            end

            table.sort(tbl2)
            return tbl2
        end)(),
        Callback = function(selectIsland)
            _G.SelectIsland = selectIsland
        end,
    })

    rfSubmarineWorkerSpeak = Core.Island

    tbl.Main:AddToggle({
        Name = "Cày tự động Tất cả đảo",
        Default = false,
        Callback = function(autoFarmIsland)
            _G.AutoFarmIsland = autoFarmIsland
        end,
    })

    tbl.Main:AddSection("Farm Elite Hunter")
    local v26 = tbl.Main:AddParagraph("Elites Process", "")

    spawn(function()
        while wait(Sec) do
            pcall(function()
                local response = replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress")
                local setDesc = v26.SetDesc
                local v27 = tostring
                local n = response or 0
                setDesc(v26, "Elite Progress : " .. v27(n))
            end)
        end
    end)

    local v27 = tbl.Main:AddParagraph("Elite Spawn", "Status: ")

    spawn(function()
        local str7 = ""

        while wait(1) do
            local diablo = game:GetService("ReplicatedStorage"):FindFirstChild("Diablo")
            local str8 = (diablo or game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") or game:GetService("ReplicatedStorage"):FindFirstChild("Urban") or game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban")) and "✅" or "❌"

            local ok, result = pcall(function()
                return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter", "Progress")
            end)

            local v28 = tostring
            local n = ok and result or 0
            local v29 = v28(n)

            if str8 ~= str7 then
                v27:SetDesc("Status: " .. str8 .. " | Killed: " .. v29)
                str7 = str8
            end
        end
    end)

    local v28 = tbl.Main:AddToggle({
        Name = "Cày tự động tinh anh",
        Description = "",
        Default = false,
        Callback = function(farmEliteHunt)
            _G.FarmEliteHunt = farmEliteHunt
        end,
    })

    EliteQ = v28

    local v29 = tbl.Main:AddToggle({
        Name = "Cày tự động tinh anh + chuyển máy chủ",
        Description = "",
        Default = false,
        Callback = function(farmEliteH)
            _G.FarmEliteH = farmEliteH
        end,
    })

    EliteH = v29
    tbl.Main:AddSection("Farm Rip Indra")

    tbl.Main:AddToggle({
        Name = "Tự động Tấn công Rip Indra",
        Description = "",
        Default = false,
        Callback = function(autoRipIngay)
            _G.AutoRipIngay = autoRipIngay
        end,
    })

    tbl.Main:AddToggle({
        Name = "Tự động mở khóa Haki",
        Description = "",
        Default = false,
        Callback = function(autoUnHaki)
            _G.AutoUnHaki = autoUnHaki
        end,
    })

    tbl.Main:AddSection("Farming Cake")
    local v30 = tbl.Main:AddParagraph("Cake Princes", "")

    spawn(function()
        while wait(0.2) do
            pcall(function()
                local v31 = string.match(replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner"), "%d+")

                if v31 then
                    local setDesc = v30.SetDesc
                    local n = 500 - tonumber(v31)
                    local killed = n or 0
                    setDesc(v30, "Killed : " .. killed)
                end
            end)
        end
    end)

    local v31 = tbl.Main:AddToggle({
        Name = "Cày tự động Cake Prince",
        Description = "",
        Default = false,
        Callback = function(autoCakePrince)
            _G.Auto_Cake_Prince = autoCakePrince
        end,
    })

    Cake = v31

    local v32 = tbl.Main:AddToggle({
        Name = "Nhận Nhiệm vụ",
        Description = "",
        Default = false,
        Callback = function(acceptQuestC)
            _G.AcceptQuestC = acceptQuestC
        end,
    })

    CakeQ = v32

    local v33 = tbl.Main:AddToggle({
        Name = "Tự động Triệu hồi Cake Prince",
        Description = "",
        Default = false,
        Callback = function(autoSpawnCP)
            _G.AutoSpawnCP = autoSpawnCP
        end,
    })

    CakeSM = v33

    tbl.Main:AddToggle({
        Name = "Tự động Dough King [Fully]",
        Default = false,
        Callback = function(autoDoughKing)
            _G.AutoDoughKing = autoDoughKing
        end,
    })

    tbl.Main:AddToggle({
        Name = "Cày tự động Dough King",
        Default = false,
        Callback = function(autoAttackDoughKing)
            _G.AutoAttackDoughKing = autoAttackDoughKing
        end,
    })

    tbl.Main:AddToggle({
        Name = "Cày tự động Dough King + chuyển máy chủ",
        Default = false,
        Callback = function(autoHopDough)
            _G.AutoHop_Dough = autoHopDough
        end,
    })

    tbl.Main:AddSection("Farming Bone")
    local Bones = tbl.Main:AddParagraph("Bones", "")

    spawn(function()
        while wait(1) do
            pcall(function()
                local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check")
                Bones:SetDesc("Bones : " .. tostring(response))
            end)
        end
    end)

    tbl.Main:AddToggle({
        Name = "Cày tự động xương",
        Description = "",
        Default = false,
        Callback = function(autoFarmBone)
            _G.AutoFarm_Bone = autoFarmBone
        end,
    })

    local v34 = tbl.Main:AddToggle({
        Name = "Nhận Nhiệm vụ",
        Description = "",
        Default = false,
        Callback = function(acceptQuestB)
            _G.AcceptQuestB = acceptQuestB
        end,
    })

    BoneQ = v34

    tbl.Main:AddToggle({
        Name = "Tự động linh hồn tử thần",
        Description = "",
        Default = false,
        Callback = function(autoHytHallow)
            _G.AutoHytHallow = autoHytHallow
        end,
    })

    local v35 = tbl.Main:AddToggle({
        Name = "Tự động ngẫu nhiên Bones",
        Description = "",
        Default = false,
        Callback = function(autoRandomBone)
            _G.Auto_Random_Bone = autoRandomBone
        end,
    })

    RanBone = v35

    local v36 = tbl.Main:AddToggle({
        Name = "Tự động Thử may mắn bia mộ",
        Description = "",
        Default = false,
        Callback = function(tryLucky)
            _G.TryLucky = tryLucky
        end,
    })

    Lucky = v36

    local v37 = tbl.Main:AddToggle({
        Name = "Tự động Cầu nguyện bia mộ",
        Description = "",
        Default = false,
        Callback = function(praying)
            _G.Praying = praying
        end,
    })

    Pray = v37
    tbl.Main:AddSection("Tyrant of the Skies")
    local v38 = tbl.Main:AddParagraph("Boss Spawn", "")

    spawn(function()
        pcall(function()
            while wait(1) do
                if workspace.Enemies:FindFirstChild("Tyrant of the Skies") then
                    v38:SetDesc("✅")
                else
                    v38:SetDesc("❌")
                end
            end
        end)
    end)

    local v39 = tbl.Main:AddParagraph("Check Status Eyes", "")

    task.spawn(function()
        local flag = false

        while task.wait(1) do
            local ok, result, result2 = pcall(Check_Eye)

            if ok then
                v39:SetDesc("Eyes: " .. result .. "/4")

                if result2 and not flag then
                    flag = true
                elseif not result2 then
                    flag = false
                end
            end
        end
    end)

    local v40 = tbl.Main:AddToggle({
        Name = "Cày tự động trùm TOTS",
        Description = "",
        Default = false,
        Callback = function(farmTyrant)
            _G.FarmTyrant = farmTyrant
        end,
    })

    FarmTyrant = v40

    local v41 = tbl.Main:AddToggle({
        Name = "Tự động Triệu hồi trùm",
        Description = "",
        Default = false,
        Callback = function(farmPhaBinh)
            _G.FarmPhaBinh = farmPhaBinh
        end,
    })

    FarmPhaBinh = v41
    tbl.Main:AddSection("Farm Material")

    local v42 = tbl.Main:AddDropdown({
        Name = "Chọn nguyên liệu",
        Description = "",
        Options = MaterialList,
        Callback = function(selectMaterial)
            getgenv().SelectMaterial = selectMaterial
        end,
    })

    Test = v42

    local v43 = tbl.Main:AddToggle({
        Name = "Cày tự động nguyên liệu",
        Description = "",
        Default = false,
        Callback = function(autoMaterial)
            getgenv().AutoMaterial = autoMaterial
        end,
    })

    Toggle = v43
    tbl.Main:AddSection("Farm Boss")

    local v44 = tbl.Main:AddDropdown({
        Name = "Chọn trùm",
        Description = "",
        Options = BossList,
        Callback = function(findBoss)
            _G.FindBoss = findBoss
        end,
    })

    BossDropdown = v44

    local v45 = tbl.Main:AddToggle({
        Name = "Cày tự động trùm",
        Description = "",
        Default = false,
        Callback = function(farmBoss)
            _G.FarmBoss = farmBoss
        end,
    })

    FarmBoss = v45

    local v46 = tbl.Main:AddToggle({
        Name = "Nhận Nhiệm vụ",
        Description = "",
        Default = true,
        Callback = function(acceptQuestBoss)
            _G.AcceptQuestBoss = acceptQuestBoss
        end,
    })

    BossQ = v46

    local v47 = tbl.Main:AddToggle({
        Name = "Cày tự động Tất cả trùm",
        Default = false,
        Callback = function(autoFarmAllBoss)
            _G.AutoFarmAllBoss = autoFarmAllBoss
        end,
    })

    FarmAllBoss = v47
    tbl.Main:AddSection("Farming Mastery")

    tbl.Main:AddDropdown({
        Name = "Chọn đảo",
        Description = "",
        Options = {"Cake", "Bone"},
        Default = Bone,
        Callback = function(arg)
            SelectIsland = arg
        end,
    })

    tbl.Main:AddSlider({
        Title = "NPC Health % Chuyển đến vũ khí",
        Description = "Chuyển sang chiêu thức của vũ khí cần nâng thông thạo khi máu NPC thấp hơn tỷ lệ này",
        Min = 10,
        Max = 95,
        Default = 70,
        Callback = function(masteryHealthPct)
            _G.MasteryHealthPct = masteryHealthPct
        end,
    })

    tbl.Main:AddDropdown({
        Name = "Chọn kỹ năng đến Dùng",
        Description = "Chọn kỹ năng muốn dùng liên tục (kỹ năng chưa mở sẽ tự động bỏ qua)",
        Options = {"Z", "X", "C", "V", "F", "Y"},
        Default = {"Z", "X", "C", "V", "F"},
        MultiSelect = true,
        Callback = function(selectedMasterySkills)
            _G.SelectedMasterySkills = selectedMasterySkills
        end,
    })

    tbl.Main:AddToggle({
        Name = "Tự động thông thạo Trái ác quỷ",
        Description = "",
        Default = false,
        Callback = function(farmMasteryDev)
            _G.FarmMastery_Dev = farmMasteryDev
        end,
    })

    tbl.Main:AddToggle({
        Name = "Tự động thông thạo súng",
        Description = "",
        Default = false,
        Callback = function(farmMasteryG)
            _G.FarmMastery_G = farmMasteryG
        end,
    })

    tbl.Main:AddToggle({
        Name = "Tự động thông thạo Tất cả kiếm",
        Description = "",
        Default = false,
        Callback = function(farmMasteryS)
            _G.FarmMastery_S = farmMasteryS
        end,
    })

    require(game.ReplicatedStorage.EventConfig.MagnetEvent26)
    tbl.Main:AddSection("Update 30 / Magnet Token")
    local v48 = tbl.Main:AddParagraph("Magnet Event Status", "Loading...")
    local Status = tbl.Main:AddParagraph("Status", "Status : Idle")

    SetMagnetStatus = function(status)
        if Status and Status.SetDesc then
            pcall(function()
                Status:SetDesc("Status : " .. status)
            end)
        end
    end

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                local now = os.time()
                local v49 = os.date("*t", now)
                local min = v49.min
                local sec = v49.sec
                local flag = min >= 0 and min < 10
                local flag2 = false

                for k, child in pairs(workspace.Enemies:GetChildren()) do
                    if child:IsA("Model") and (child:GetAttribute("MagnetEnemy") == true or string.find(string.lower(child.Name), "magnetized")) then
                        flag2 = true
                        break
                    end
                end

                local str7

                if flag2 then
                    local n = (10 - min) * 60 - sec
                    local n2 = n

                    if n < 0 then
                        n2 = 0
                    end

                    local n3 = math.floor(n2 / 60)
                    str7 = string.format("%s ACTIVE - Time Left: %02d:%02d (✅ Enemies Found)", "🟢", n3, n2 % 60)
                elseif flag then
                    local n = (10 - min) * 60 - sec
                    local n2 = n

                    if n < 0 then
                        n2 = 0
                    end

                    local n3 = math.floor(n2 / 60)
                    str7 = string.format("%s ACTIVE - Time Left: %02d:%02d", "🟢", n3, n2 % 60)
                else
                    local n = (60 - min) * 60 - sec
                    local n2 = n

                    if n <= 0 then
                        n2 = 0
                    end

                    local n3 = math.floor(n2 / 60)
                    str7 = string.format("%s INACTIVE - Next Event: %02d:%02d", "🔴", n3, n2 % 60)
                end

                v48:SetDesc(str7)
            end)
        end
    end)

    local v49 = _G
    local magnetEventSpawnIndex = _G.MagnetEventSpawnIndex
    local magnetEventSpawnIndex2 = magnetEventSpawnIndex or 1
    v49.MagnetEventSpawnIndex = magnetEventSpawnIndex2

    tbl.Main:AddToggle({
        Name = "Cày tự động nam châm xu",
        Default = false,
        Callback = function(autoMagnetToken)
            _G.AutoMagnetToken = autoMagnetToken
            local v50 = SetMagnetStatus
            local str7 = autoMagnetToken and "Starting..." or "Idle"
            v50(str7)

            if not autoMagnetToken then
                _G.MagnetEventSpawnIndex = 1
            end
        end,
    })

    tbl.Settings:AddSection("Cài đặt / Tùy chỉnh")

    local v50 = tbl.Settings:AddToggle({
        Name = "Nhanh Tấn công",
        Description = "",
        Default = true,
        Callback = function(seriality)
            _G.Seriality = seriality
        end,
    })

    Initialize = v50

    local v51 = tbl.Settings:AddToggle({
        Name = "Kéo quái",
        Description = "",
        Default = true,
        Callback = function(arg)
            _B = arg
        end,
    })

    Bringmob = v51

    tbl.Settings:AddToggle({
        Name = "Tự động chuyển máy chủ máy chủ với thời gian",
        Default = false,
        Callback = function(autoHopServer)
            _G.AutoHopServer = autoHopServer

            if not autoHopServer then
                _G.HopTimer = nil
            end
        end,
    })

    tbl.Settings:AddSlider({
        Name = "chuyển máy chủ Độ trễ (phút)",
        Min = 5,
        Max = 120,
        Default = 30,
        Increment = 1,
        Callback = function(arg)
            _G.HopDelay = arg * 60
        end,
    })

    tbl.Settings:AddToggle({
        Name = "Tự động Đặt xuất hiện điểm",
        Default = false,
        Callback = function(set)
            getgenv().Set = set

            if set then
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                end)
            end
        end,
    })

    local v52 = tbl.Settings:AddToggle({
        Name = "Tự động Bật on Buso",
        Description = "",
        Default = true,
        Callback = function(arg)
            Boud = arg
        end,
    })

    BusuAura = v52

    tbl.Settings:AddToggle({
        Name = "Tự động Haki Observation",
        Default = false,
        Callback = function(observation)
            getgenv().Observation = observation
        end,
    })

    local v53 = tbl.Settings:AddToggle({
        Name = "Tự động Bật on Tộc V3",
        Description = "",
        Default = false,
        Flag = "AutoTurnonRaceV3",
        Callback = function(raceClickAutov3)
            _G.RaceClickAutov3 = raceClickAutov3
        end,
    })

    RaceV3Aura = v53

    local v54 = tbl.Settings:AddToggle({
        Name = "Tự động Bật on Tộc V4",
        Description = "",
        Default = false,
        Callback = function(raceClickAutov4)
            _G.RaceClickAutov4 = raceClickAutov4
        end,
    })

    RaceV4Aura = v54

    local v55 = tbl.Settings:AddToggle({
        Name = "Tự động Bật on Spin  xyz",
        Description = "",
        Default = false,
        Callback = function(arg)
            RandomCFrame = arg
        end,
    })

    RandomAround = v55

    local v56 = tbl.Settings:AddToggle({
        Name = "an toàn chế độ",
        Description = "",
        Default = false,
        Callback = function(safemode)
            _G.Safemode = safemode
        end,
    })

    SafeModes = v56

    local v57 = tbl.Settings:AddToggle({
        Name = "Xóa Hit VFX",
        Description = "Tắt hiệu ứng chém và hiệu ứng kiếm để nhìn rõ hơn",
        Default = false,
        Callback = function(destroyHit)
            _G.DestroyHit = destroyHit
        end,
    })

    DisableHitVFX = v57
    rfSubmarineWorkerSpeak = {"SlashHit", "CurvedRing", "SwordSlash", "SlashTail"}

    local v58 = tbl.Settings:AddToggle({
        Name = "Xóa tử vong & hồi sinh VFX",
        Description = "",
        Default = false,
        Callback = function(arg)
            RDeath = arg
        end,
    })

    RmvVFX = v58

    local v59 = tbl.Settings:AddToggle({
        Name = "Tắt thông báo",
        Description = "",
        Default = false,
        Callback = function(arg)
            RemoveDamage = arg
        end,
    })

    DisblesNotify = v59

    tbl.Settings:AddToggle({
        Name = "Chống AFK",
        Default = true,
        Callback = function(arg)
            if arg then
                local VirtualUser = game:GetService("VirtualUser")

                repeat
                    wait()
                until game:IsLoaded()

                game:GetService("Players").LocalPlayer.Idled:Connect(function()
                    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    wait(1)
                    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)
            end
        end,
    })

    tbl.Settings:AddToggle({
        Name = "Tự động Chống - Admin Join máy chủ",
        Description = "",
        Default = true,
        Callback = function(hopServerAdmin)
            getgenv().HopServerAdmin = hopServerAdmin
        end,
    })

    tbl.Settings:AddToggle({
        Name = "Không va chạm",
        Default = false,
        Callback = function(noClip)
            getgenv().NoClip = noClip
        end,
    })

    tbl.Esp:AddSection("Stats Upgrade")

    local v60 = tbl.Esp:AddSlider({
        Name = "Chỉ số giá trị",
        Description = "",
        Default = 10,
        Min = 0,
        Max = 1000,
        Rounding = 1,
        Callback = function(arg)
            pSats = arg
        end,
    })

    StatusSelect = v60

    local v61 = tbl.Esp:AddToggle({
        Name = "Tự động cận chiến",
        Description = "",
        Default = false,
        Callback = function(autoMelee)
            _G.Auto_Melee = autoMelee
        end,
    })

    StatsUpg = v61

    local v62 = tbl.Esp:AddToggle({
        Name = "Tự động Swords",
        Description = "",
        Default = false,
        Callback = function(autoSword)
            _G.Auto_Sword = autoSword
        end,
    })

    StatsUpg = v62

    local v63 = tbl.Esp:AddToggle({
        Name = "Tự động súng",
        Description = "",
        Default = false,
        Callback = function(autoGun)
            _G.Auto_Gun = autoGun
        end,
    })

    StatsUpg = v63

    local v64 = tbl.Esp:AddToggle({
        Name = "Tự động Blox Trái ác quỷ",
        Description = "",
        Default = false,
        Callback = function(autoDevilFruit)
            _G.Auto_DevilFruit = autoDevilFruit
        end,
    })

    StatsUpg = v64

    local v65 = tbl.Esp:AddToggle({
        Name = "Tự động phòng thủ",
        Description = "",
        Default = false,
        Callback = function(autoDefense)
            _G.Auto_Defense = autoDefense
        end,
    })

    StatsUpg = v65
    tbl.Fish:AddSection("Câu cá")

    tbl.Fish:AddDropdown({
        Name = "Chọn Câu cá cần câu",
        Description = "",
        Options = {
            "Fishing Rod",
            "Gold Rod",
            "Shark Rod",
            "Shell Rod",
            "Treasure Rod",
        },
        Default = "Fishing Rod",
        Callback = function(selectedRod)
            _G.SelectedRod = selectedRod
        end,
    })

    local v66 = tbl.Fish:AddDropdown({
        Name = "Chọn mồi câu",
        Description = "",
        Options = {
            "Basic Bait",
            "Kelp Bait",
            "Good Bait",
            "Abyssal Bait",
            "Frozen Bait",
            "Epic Bait",
            "Carnivore Bait",
        },
        Default = "Basic Bait",
        Callback = function(selectedBait)
            _G.SelectedBait = selectedBait

            if _G.AutoBuyBait then
                pcall(function()
                    Remotes.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
                end)
            end
        end,
    })

    BaitDropdown = v66

    local v67 = tbl.Fish:AddToggle({
        Name = "Tự động Mua mồi câu",
        Description = "",
        Default = false,
        Callback = function(autoBuyBait)
            _G.AutoBuyBait = autoBuyBait

            if autoBuyBait then
                pcall(function()
                    Remotes.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
                end)
            end
        end,
    })

    BuyBaitToggle = v67

    local v68 = tbl.Fish:AddToggle({
        Name = "Tự động Câu cá",
        Description = "",
        Default = false,
        Callback = function(autoFishing)
            _G.AutoFishing = autoFishing
        end,
    })

    FishingToggle = v68

    local v69 = tbl.Fish:AddToggle({
        Name = "Tự động Nhiệm vụ Câu cá",
        Description = "",
        Default = false,
        Callback = function(autoFishingQuest)
            _G.AutoFishingQuest = autoFishingQuest
        end,
    })

    FishingQ = v69

    local v70 = tbl.Fish:AddToggle({
        Name = "Tự động Hoàn thành Nhiệm vụ",
        Description = "",
        Default = false,
        Callback = function(autoQuestComplete)
            _G.AutoQuestComplete = autoQuestComplete

            if autoQuestComplete then
                pcall(function()
                    Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "FinishQuest")
                end)
            end
        end,
    })

    QuestToggle = v70

    local v71 = tbl.Fish:AddToggle({
        Name = "Tự động Bán cá",
        Description = "",
        Default = false,
        Callback = function(autoSellFish)
            _G.AutoSellFish = autoSellFish

            if autoSellFish then
                pcall(function()
                    Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "SellFish")
                end)
            end
        end,
    })

    SellFishToggle = v71

    local v72 = tbl.Fish:AddToggle({
        Name = "Tự động Spam kỹ năng Z",
        Description = "",
        Default = false,
        Callback = function(autoSkillZ)
            _G.AutoSkillZ = autoSkillZ
        end,
    })

    SpamSkillZ = v72

    local v73 = tbl.Quests:AddToggle({
        Name = "Tự động Nhiệm vụ Biển 2",
        Description = "",
        Default = false,
        Callback = function(travelDres)
            _G.TravelDres = travelDres
        end,
    })

    TravelDress = v73

    local v74 = tbl.Quests:AddToggle({
        Name = "Tự động Nhiệm vụ Biển 3",
        Description = "",
        Default = false,
        Callback = function(autoZou)
            _G.AutoZou = autoZou
        end,
    })

    Zou = v74
    tbl.Quests:AddSection("Tushita + Yama")

    local v75 = tbl.Quests:AddToggle({
        Name = "Tự động Tushita kiếm",
        Description = "",
        Default = false,
        Callback = function(autoTushita)
            _G.Auto_Tushita = autoTushita
        end,
    })

    Q = v75

    local v76 = tbl.Quests:AddToggle({
        Name = "Tự động Yama kiếm",
        Description = "",
        Default = false,
        Callback = function(autoYama)
            _G.Auto_Yama = autoYama
        end,
    })

    Q = v76
    tbl.Quests:AddSection("Đàn Guitar Đầu Lâu / Khác")
    local v77 = tbl.Quests:AddParagraph("Skull Guitar Quests", "")

    spawn(function()
        while wait(0.2) do
            pcall(function()
                if Quest1 == true then
                    v77:SetDesc("Quest Number : Quest1")
                elseif Quest2 == true then
                    v77:SetDesc("Quest Number : Quest2")
                elseif Quest3 == true then
                    v77:SetDesc("Quest Number : Quest3")
                elseif Quest4 == true then
                    v77:SetDesc("Quest Number : Quest4")
                elseif GetWP("Skull Guitar") then
                    v77:SetDesc("Quest Number : Collect!!")
                else
                    v77:SetDesc("Quest Number : No Quest!!")
                end
            end)
        end
    end)

    tbl.Quests:AddToggle({
        Name = "Tự động Skull Guitar",
        Description = "",
        Default = false,
        Callback = function(autoSoulGuitar)
            _G.Auto_Soul_Guitar = autoSoulGuitar
        end,
    })

    tbl.Quests:AddToggle({
        Name = "Cày tự động nguyên liệu Skull Guitar",
        Description = "",
        Default = false,
        Callback = function(autoMatSoul)
            _G.AutoMatSoul = autoMatSoul
        end,
    })

    tbl.Quests:AddSection("Cursed Dual Katana")
    local v78 = tbl.Quests:AddParagraph("Number Cursed dual katana quests", "Quest Numbers :")

    spawn(function()
        while wait(0.2) do
            if QuestYama_1 == true then
                v78:SetDesc("Quest Numbers : yama quest 1")
            elseif QuestYama_2 == true then
                v78:SetDesc("Quest Numbers : yama quest 2")
            elseif QuestYama_3 == true then
                v78:SetDesc("Quest Numbers : yama quest 3")
            elseif QuestTushita_1 == true then
                v78:SetDesc("Quest Numbers : tushita quest 1")
            elseif QuestTushita_2 == true then
                v78:SetDesc("Quest Numbers : tushita quest 2")
            elseif GetWP("Cursed Dual Katana") then
                v78:SetDesc("Quest Numbers : CDK done!!")
            end
        end
    end)

    local v79 = tbl.Quests:AddToggle({
        Name = "Tự động Nhận CDK [ cuối Nhiệm vụ ]",
        Description = "",
        Default = false,
        Callback = function(cdk)
            _G.CDK = cdk
        end,
    })

    Q = v79

    local v80 = tbl.Quests:AddToggle({
        Name = "Tự động Yama CDK",
        Description = "",
        Default = false,
        Callback = function(cdkYm)
            _G.CDK_YM = cdkYm
        end,
    })

    Q = v80

    local v81 = tbl.Quests:AddToggle({
        Name = "Tự động Tushita CDK",
        Description = "",
        Default = false,
        Callback = function(cdkTs)
            _G.CDK_TS = cdkTs
        end,
    })

    Q = v81
    tbl.Quests:AddSection("True Triple Katana Sword")

    tbl.Quests:AddButton({
        Name = "Mua Legendary kiếm",
        Description = "",
        Callback = function()
            replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1")
            replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2")
            replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "3")
        end,
    })

    tbl.Quests:AddButton({
        Name = "Mua True Triple Katana kiếm",
        Description = "",
        Callback = function()
            replicated.Remotes.CommF_:InvokeServer("MysteriousMan", "2")
        end,
    })

    local v82 = tbl.Quests:AddToggle({
        Name = "Tween đến Legendary kiếm người bán",
        Description = "",
        Default = false,
        Callback = function(tpLgS)
            _G.Tp_LgS = tpLgS
        end,
    })

    Q = v82
    tbl.Quests:AddSection("Pole / God Enal's")

    local v83 = tbl.Quests:AddToggle({
        Name = "Tự động Pole V1",
        Description = "",
        Default = false,
        Callback = function(autoPole)
            _G.AutoPole = autoPole
        end,
    })

    Q = v83

    local v84 = tbl.Quests:AddToggle({
        Name = "Tự động Pole V2 [Beta]",
        Description = "",
        Default = false,
        Callback = function(autoPoleV2)
            _G.AutoPoleV2 = autoPoleV2
        end,
    })

    Q = v84

    tbl.Quests:AddToggle({
        Name = "Tự động Saw kiếm",
        Description = "",
        Default = false,
        Callback = function(autoSaw)
            _G.AutoSaw = autoSaw
        end,
    })

    local v85 = tbl.Quests:AddToggle({
        Name = "Tự động Saber kiếm",
        Description = "",
        Default = false,
        Callback = function(autoSaber)
            _G.AutoSaber = autoSaber
        end,
    })

    Q = v85

    local v86 = tbl.Quests:AddToggle({
        Name = "Tự động Cybrog",
        Description = "",
        Default = false,
        Callback = function(autoColShad)
            _G.AutoColShad = autoColShad
        end,
    })

    Q = v86

    local v87 = tbl.Quests:AddToggle({
        Name = "Tự động Usoap's mũ",
        Description = "",
        Default = false,
        Callback = function(autoGetUsoap)
            _G.AutoGetUsoap = autoGetUsoap
        end,
    })

    Q = v87

    local v88 = tbl.Quests:AddToggle({
        Name = "Tự động Bisento V2",
        Description = "",
        Default = false,
        Callback = function(greybeard)
            _G.Greybeard = greybeard
        end,
    })

    Q = v88

    local v89 = tbl.Quests:AddToggle({
        Name = "Tự động Warden kiếm",
        Description = "",
        Default = false,
        Callback = function(wardenBoss)
            _G.WardenBoss = wardenBoss
        end,
    })

    Q = v89

    local v90 = tbl.Quests:AddToggle({
        Name = "Tự động Thủy quân Coat",
        Description = "",
        Default = false,
        Callback = function(marinesCoat)
            _G.MarinesCoat = marinesCoat
        end,
    })

    Q = v90

    local v91 = tbl.Quests:AddToggle({
        Name = "Tự động Swan Coat",
        Description = "",
        Default = false,
        Callback = function(swanCoat)
            _G.SwanCoat = swanCoat
        end,
    })

    Q = v91
    tbl.Quests:AddSection("Rengoku Sword")

    local v92 = tbl.Quests:AddToggle({
        Name = "Tự động Rengoku kiếm",
        Description = "",
        Default = false,
        Callback = function(iceBossRen)
            _G.IceBossRen = iceBossRen
        end,
    })

    Q = v92

    local v93 = tbl.Quests:AddToggle({
        Name = "Tự động Key Rengoku",
        Description = "",
        Default = false,
        Callback = function(keysRen)
            _G.KeysRen = keysRen
        end,
    })

    Q = v93

    local v94 = tbl.Quests:AddToggle({
        Name = "Tự động Dragon Trident",
        Description = "",
        Default = false,
        Callback = function(autoTridentW2)
            _G.AutoTridentW2 = autoTridentW2
        end,
    })

    Q = v94

    local v95 = tbl.Quests:AddToggle({
        Name = "Tự động Long kiếm",
        Description = "",
        Default = false,
        Callback = function(longsWord)
            _G.LongsWord = longsWord
        end,
    })

    Q = v95

    local v96 = tbl.Quests:AddToggle({
        Name = "Tự động Black Spikey",
        Description = "",
        Default = false,
        Callback = function(blackSpikey)
            _G.BlackSpikey = blackSpikey
        end,
    })

    Q = v96

    local v97 = tbl.Quests:AddToggle({
        Name = "Tự động Dark Blade V3",
        Description = "",
        Default = false,
        Callback = function(darkBladev3)
            _G.DarkBladev3 = darkBladev3
        end,
    })

    Q = v97

    local v98 = tbl.Quests:AddToggle({
        Name = "Tự động Midnight Blade",
        Description = "",
        Default = false,
        Callback = function(autoEcBoss)
            _G.AutoEcBoss = autoEcBoss
        end,
    })

    Q = v98

    local v99 = tbl.Quests:AddToggle({
        Name = "Tự động Darkbeard",
        Description = "",
        Default = false,
        Callback = function(autoDefDarkCoat)
            _G.Auto_Def_DarkCoat = autoDefDarkCoat
        end,
    })

    Q = v99

    local v100 = tbl.Quests:AddToggle({
        Name = "Tự động mở khóa DonSwan",
        Description = "",
        Default = false,
        Callback = function(autoDonAcces)
            _G.Auto_DonAcces = autoDonAcces
        end,
    })

    Q = v100

    local v101 = tbl.Quests:AddToggle({
        Name = "Tự động Swan Glasses",
        Description = "",
        Default = false,
        Callback = function(autoSwanGG)
            _G.Auto_SwanGG = autoSwanGG
        end,
    })

    Q = v101
    tbl.Quests:AddSection("Cavender + Twin Hooks + Bigmom")

    local v102 = tbl.Quests:AddToggle({
        Name = "Tự động Bigmom",
        Description = "",
        Default = false,
        Callback = function(autoBigmom)
            _G.AutoBigmom = autoBigmom
        end,
    })

    Q = v102

    local v103 = tbl.Quests:AddToggle({
        Name = "Tự động Canvendish kiếm",
        Description = "",
        Default = false,
        Callback = function(autoCavender)
            _G.Auto_Cavender = autoCavender
        end,
    })

    Q = v103

    local v104 = tbl.Quests:AddToggle({
        Name = "Tự động Twin Hooks",
        Description = "",
        Default = false,
        Callback = function(twinHook)
            _G.TwinHook = twinHook
        end,
    })

    Q = v104

    local v105 = tbl.Quests:AddToggle({
        Name = "Tự động Serpent Bow",
        Description = "",
        Default = false,
        Callback = function(autoSerpentBow)
            _G.AutoSerpentBow = autoSerpentBow
        end,
    })

    Q = v105

    local v106 = tbl.Quests:AddToggle({
        Name = "Tự động Lei phụ kiện",
        Description = "",
        Default = false,
        Callback = function(autoKilo)
            _G.AutoKilo = autoKilo
        end,
    })

    Q = v106
    tbl.Quests:AddSection("Buso/Aura Colours")

    local v107 = tbl.Quests:AddToggle({
        Name = "Tự động Dịch chuyển Barista Cousin",
        Description = "",
        Default = false,
        Callback = function(tpMasterA)
            _G.Tp_MasterA = tpMasterA
        end,
    })

    Q = v107

    tbl.Quests:AddButton({
        Name = "Mua Buso Colors",
        Description = "",
        Callback = function()
            replicated.Remotes.CommF_:InvokeServer("ColorsDealer", "2")
        end,
    })

    local v108 = tbl.Quests:AddToggle({
        Name = "Tự động Rainbow Colors",
        Description = "",
        Default = false,
        Callback = function(autoRainbowHaki)
            _G.Auto_Rainbow_Haki = autoRainbowHaki
        end,
    })

    Q = v108

    local v109 = tbl.Quests:AddToggle({
        Name = "Nhận Rainbow Nhiệm vụ Faster",
        Description = "",
        Default = false,
        Callback = function(getQFast)
            _G.GetQFast = getQFast
        end,
    })

    Q = v109
    tbl.Quests:AddSection("Instinct / Observation")

    local v110 = tbl.Quests:AddToggle({
        Name = "Cày tự động Observation",
        Description = "",
        Default = false,
        Callback = function(obsFarm)
            _G.obsFarm = obsFarm
        end,
    })

    Q = v110

    local v111 = tbl.Quests:AddToggle({
        Name = "Tự động Observation V2",
        Description = "",
        Default = false,
        Callback = function(autoKenVTWO)
            _G.AutoKenVTWO = autoKenVTWO
        end,
    })

    Q = v111

    local v112 = tbl.Quests:AddToggle({
        Name = "Tự động xong Bartilo Nhiệm vụ",
        Description = "",
        Default = false,
        Callback = function(bartiloQuest)
            _G.Bartilo_Quest = bartiloQuest
        end,
    })

    Bartilo = v112

    local v113 = tbl.Quests:AddToggle({
        Name = "Tự động xong Citizen Nhiệm vụ",
        Description = "",
        Default = false,
        Callback = function(citizenQuest)
            _G.CitizenQuest = citizenQuest
        end,
    })

    CitizenQ = v113

    local v114 = tbl.Quests:AddToggle({
        Name = "Tự động Training Dummy",
        Description = "",
        Default = false,
        Callback = function(dummyMan)
            _G.DummyMan = dummyMan
        end,
    })

    Q = v114
    tbl.Quests:AddSection("Fighting Melee Styles")

    local v115 = tbl.Quests:AddToggle({
        Name = "Tự động Superhuman",
        Description = "",
        Default = false,
        Callback = function(autoSuperHuman)
            _G.Auto_SuperHuman = autoSuperHuman
        end,
    })

    SuperHuman = v115

    local v116 = tbl.Quests:AddToggle({
        Name = "Tự động DeathStep",
        Description = "",
        Default = false,
        Callback = function(autoDeathStep)
            _G.AutoDeathStep = autoDeathStep
        end,
    })

    DeathStep = v116

    local v117 = tbl.Quests:AddToggle({
        Name = "Tự động Sharkman Karate",
        Description = "",
        Default = false,
        Callback = function(autoSharkManKarate)
            _G.Auto_SharkMan_Karate = autoSharkManKarate
        end,
    })

    SharkManV2 = v117

    local v118 = tbl.Quests:AddToggle({
        Name = "Tự động ElectricClaw",
        Description = "",
        Default = false,
        Callback = function(autoElectricClaw)
            _G.Auto_Electric_Claw = autoElectricClaw
        end,
    })

    ElectricClaw = v118

    local v119 = tbl.Quests:AddToggle({
        Name = "Tự động DragonTalon",
        Description = "",
        Default = false,
        Callback = function(autoDragonTalon)
            _G.AutoDragonTalon = autoDragonTalon
        end,
    })

    DragonTalon = v119

    local v120 = tbl.Quests:AddToggle({
        Name = "Tự động Godhuman",
        Description = "",
        Default = false,
        Callback = function(autoGodHuman)
            _G.Auto_God_Human = autoGodHuman
        end,
    })

    Godhuman = v120

    local v121 = tbl.Quests:AddToggle({
        Name = "Tự động SanguineArt",
        Description = "",
        Default = false,
        Callback = function(snaguine)
            _G.Snaguine = snaguine
        end,
    })

    SanguineArt = v121
    tbl.Race:AddSection("Mystic Island / Full Moon")
    local v122 = tbl.Race:AddParagraph("FullMoon Status", "")
    local v123 = tbl.Race:AddParagraph("Mirage Island Status", "")

    spawn(function()
        while wait(0.2) do
            if not workspace.Map:FindFirstChild("MysticIsland") and not workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") then
                v123:SetDesc("Mirage Island : False")
            else
                v123:SetDesc("Mirage Island : True")
            end
        end
    end)

    spawn(function()
        while wait(0.2) do
            pcall(function()
                local v124 = Getmoon()

                if v124 == "http://www.roblox.com/asset/?id=9709135895" then
                    v122:SetDesc("Moon : 0 / 8")
                elseif v124 == "http://www.roblox.com/asset/?id=9709139597" then
                    v122:SetDesc("Moon : 1 / 8")
                elseif v124 == "http://www.roblox.com/asset/?id=9709143733" then
                    v122:SetDesc("Moon : 2 / 8")
                elseif v124 == "http://www.roblox.com/asset/?id=9709149052" then
                    v122:SetDesc("Moon : 3 / 8 [ Next Night ]")
                elseif v124 == "http://www.roblox.com/asset/?id=9709149431" then
                    v122:SetDesc("Moon : 4 / 8 [ Full Moon ]")
                elseif v124 == "http://www.roblox.com/asset/?id=9709149680" then
                    v122:SetDesc("Moon : 5 / 8 [ Last Night ]")
                elseif v124 == "http://www.roblox.com/asset/?id=9709150086" then
                    v122:SetDesc("Moon : 6 / 8")
                elseif v124 == "http://www.roblox.com/asset/?id=9709150401" then
                    v122:SetDesc("Moon : 7 / 8")
                end
            end)
        end
    end)

    tbl.Race:AddToggle({
        Name = "Tự động Tìm Ảo ảnh đảo",
        Description = "",
        Default = false,
        Callback = function(findMirage)
            _G.FindMirage = findMirage
        end,
    })

    tbl.Race:AddToggle({
        Name = "Esp Ảo ảnh đảo",
        Description = "",
        Value = false,
        Callback = function(arg)
            MirageIslandESP = arg

            if MirageIslandESP then
                task.spawn(function()
                    while MirageIslandESP do
                        if UpdateIslandMirageESP then
                            UpdateIslandMirageESP()
                        end

                        task.wait(1)
                    end
                end)
            elseif UpdateIslandMirageESP then
                UpdateIslandMirageESP()
            end
        end,
    })

    tbl.Race:AddToggle({
        Name = "Tự động Tween To Ảo ảnh đảo",
        Description = "",
        Default = false,
        Callback = function(autoMysticIsland)
            _G.AutoMysticIsland = autoMysticIsland
        end,
    })

    tbl.Race:AddToggle({
        Name = "Tự động Tween To Highest điểm",
        Description = "",
        Default = false,
        Callback = function(highestMirage)
            _G.HighestMirage = highestMirage
        end,
    })

    tbl.Race:AddToggle({
        Name = "Tự động Thu thập bánh răng",
        Description = "",
        Default = false,
        Callback = function(tpgear)
            _G.TPGEAR = tpgear
        end,
    })

    tbl.Race:AddToggle({
        Name = "Thay đổi Transparency can see",
        Description = "",
        Default = false,
        Callback = function(can)
            _G.can = can
        end,
    })

    tbl.Race:AddToggle({
        Name = "Tự động Tween nâng cao Trái ác quỷ người bán",
        Description = "",
        Default = false,
        Callback = function(addealer)
            _G.Addealer = addealer
        end,
    })

    tbl.Race:AddToggle({
        Name = "Tự động Thu thập Ảo ảnh rương",
        Description = "",
        Default = false,
        Callback = function(farmChestM)
            _G.FarmChestM = farmChestM
        end,
    })

    tbl.Race:AddButton({
        Name = "Talk With Stone",
        Description = "",
        Callback = function()
            replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress", "Begin")
            replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress", "Check")
            replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress", "Teleport")
            replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress", "Continue")
        end,
    })

    tbl.Race:AddToggle({
        Name = "Tự động Look At Moon",
        Description = "",
        Default = false,
        Callback = function(arg)
            LookM = arg
        end,
    })

    tbl.Race:AddToggle({
        Name = "Look Moon + Tự động V3",
        Description = "",
        Default = false,
        Callback = function(arg)
            LookMV3 = arg
        end,
    })

    tbl.Race:AddSection("Upgrade Races V2 And V3")

    local v124 = tbl.Race:AddToggle({
        Name = "Tự động Nâng cấp Mink",
        Description = "",
        Default = false,
        Callback = function(autoMink)
            _G.Auto_Mink = autoMink
        end,
    })

    RaceMink = v124

    local v125 = tbl.Race:AddToggle({
        Name = "Tự động Nâng cấp người",
        Description = "",
        Default = false,
        Callback = function(autoHuman)
            _G.Auto_Human = autoHuman
        end,
    })

    RaceHuman = v125

    local v126 = tbl.Race:AddToggle({
        Name = "Tự động Nâng cấp Angel",
        Description = "",
        Default = false,
        Callback = function(autoSkypiea)
            _G.Auto_Skypiea = autoSkypiea
        end,
    })

    RaceSky = v126

    local v127 = tbl.Race:AddToggle({
        Name = "Tự động Nâng cấp FishMan",
        Description = "",
        Default = false,
        Callback = function(autoFish)
            _G.Auto_Fish = autoFish
        end,
    })

    RaceFish = v127
    tbl.Race:AddSection("Trials Quest V4")
    local v128 = tbl.Race:AddParagraph("Tiers V4 Status", "")

    spawn(function()
        pcall(function()
            while wait(0.2) do
                v128:SetDesc("Tiers - V4 :  " .. plr.Data.Race.C.Value)
            end
        end)
    end)

    local v129 = tbl.Race:AddToggle({
        Name = "Tự động Kéo cần gạt",
        Description = "",
        Default = false,
        Callback = function(lver)
            _G.Lver = lver
        end,
    })

    PullLv = v129

    local v130 = tbl.Race:AddToggle({
        Name = "Tự động huấn luyện V4",
        Description = "",
        Default = false,
        Callback = function(acientOne)
            _G.AcientOne = acientOne
        end,
    })

    Train = v130

    tbl.Race:AddButton({
        Name = "Dịch chuyển đến Temple of thời gian",
        Description = "",
        Callback = function()
            local localPlayer = game:GetService("Players").LocalPlayer
            local character = localPlayer.Character
            local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
            end

            if not game:GetService("Workspace").Map:FindFirstChild("Temple of Time") and World3 then
                local mapStash = game:GetService("ReplicatedStorage"):FindFirstChild("MapStash")

                if mapStash and mapStash:FindFirstChild("Temple of Time") then
                    mapStash["Temple of Time"].Parent = workspace.Map
                end
            end
        end,
    })

    tbl.Race:AddButton({
        Name = "Dịch chuyển đến cổ đại One",
        Description = "",
        Callback = function()
            local localPlayer = game:GetService("Players").LocalPlayer
            local character = localPlayer.Character
            local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
            end

            if not game:GetService("Workspace").Map:FindFirstChild("Temple of Time") and World3 then
                local mapStash = game:GetService("ReplicatedStorage"):FindFirstChild("MapStash")

                if mapStash and mapStash:FindFirstChild("Temple of Time") then
                    mapStash["Temple of Time"].Parent = workspace.Map
                end
            end

            task.wait(2)
            tween(CFrame.new(28981.552734375, 14888.4267578125, -120.245849609375))
        end,
    })

    tbl.Race:AddButton({
        Name = "Dịch chuyển đến cổ đại đồng hồ",
        Description = "",
        Callback = function()
            local localPlayer = game:GetService("Players").LocalPlayer
            local character = localPlayer.Character
            local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
            local cframe = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
            local cframe2 = CFrame.new(29549, 15069, -88)

            if humanoidRootPart then
                humanoidRootPart.CFrame = cframe
            end

            task.delay(2, function()
                _tp(cframe2)
            end)

            if not workspace.Map:FindFirstChild("Temple of Time") and World3 then
                local mapStash = game:GetService("ReplicatedStorage"):FindFirstChild("MapStash")

                if mapStash and mapStash:FindFirstChild("Temple of Time") then
                    mapStash["Temple of Time"].Parent = workspace.Map
                end
            end
        end,
    })

    local v131 = tbl.Race:AddToggle({
        Name = "Tự động Dịch chuyển đến Tộc Doors",
        Description = "",
        Default = false,
        Callback = function(tpDoor)
            _G.TPDoor = tpDoor
        end,
    })

    Doors = v131

    local v132 = tbl.Race:AddToggle({
        Name = "Tự động Hoàn thành thử thách Tộc",
        Description = "",
        Default = false,
        Callback = function(completeTrials)
            _G.Complete_Trials = completeTrials
        end,
    })

    Trials = v132

    local v133 = tbl.Race:AddToggle({
        Name = "Tự động Tiêu diệt người chơi After thử thách",
        Description = "",
        Default = false,
        Callback = function(defeating)
            _G.Defeating = defeating
        end,
    })

    AutoKill = v133
    tbl.Prehistoric:AddSection("Dojo Quest")

    tbl.Prehistoric:AddButton({
        Title = "Dịch chuyển To Dragon Dojo",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773438, -334.9649963378906))
            _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
        end,
    })

    local v134 = tbl.Prehistoric:AddToggle({
        Name = "Tự động Dojo Trainer",
        Description = "",
        Default = false,
        Callback = function(dojoo)
            _G.Dojoo = dojoo
        end,
    })

    DojoQ = v134

    local v135 = tbl.Prehistoric:AddToggle({
        Name = "Tự động Dragon Hunter",
        Description = "",
        Default = false,
        Callback = function(farmBlazeEM)
            _G.FarmBlazeEM = farmBlazeEM
        end,
    })

    BlazeEM = v135
    tbl.Prehistoric:AddSection("Drago Trial")

    local v136 = tbl.Prehistoric:AddToggle({
        Name = "Tween To Nâng cấp Droco thử thách",
        Description = "",
        Default = false,
        Callback = function(upgDrago)
            _G.UPGDrago = upgDrago
        end,
    })

    Toggle = v136

    local v137 = tbl.Prehistoric:AddToggle({
        Name = "Tự động Drago (V1)",
        Description = "",
        Default = false,
        Callback = function(dragoV1)
            _G.DragoV1 = dragoV1
        end,
    })

    Toggle = v137

    local v138 = tbl.Prehistoric:AddToggle({
        Name = "Tự động Drago (V2)",
        Description = "",
        Default = false,
        Callback = function(autoFireFlowers)
            _G.AutoFireFlowers = autoFireFlowers
        end,
    })

    fireflower = v138

    local v139 = tbl.Prehistoric:AddToggle({
        Name = "Tự động Drago (V3)",
        Description = "",
        Default = false,
        Callback = function(dragoV3)
            _G.DragoV3 = dragoV3
        end,
    })

    Toggle = v139

    local v140 = tbl.Prehistoric:AddToggle({
        Name = "Tự động Relic Drago thử thách [Beta]",
        Description = "",
        Default = false,
        Callback = function(relic123)
            _G.Relic123 = relic123
        end,
    })

    Toggle = v140

    local v141 = tbl.Prehistoric:AddToggle({
        Name = "Tự động huấn luyện Drago v4",
        Description = "",
        Default = false,
        Callback = function(trainDrago)
            _G.TrainDrago = trainDrago
        end,
    })

    Toggle = v141

    local v142 = tbl.Prehistoric:AddToggle({
        Name = "Tween đến Drago Trials",
        Description = "",
        Default = false,
        Callback = function(tpDragoPrehis)
            _G.TpDrago_Prehis = tpDragoPrehis
        end,
    })

    dragoTpVolcano = v142

    local v143 = tbl.Prehistoric:AddToggle({
        Name = "Đổi Drago Tộc",
        Description = "",
        Default = false,
        Callback = function(buyDrago)
            _G.BuyDrago = buyDrago
        end,
    })

    bdrago = v143

    local v144 = tbl.Prehistoric:AddToggle({
        Name = "Nâng cấp Dragon Talon With Uzoth",
        Description = "",
        Default = false,
        Callback = function(dtUzoth)
            _G.DT_Uzoth = dtUzoth
        end,
    })

    UpTalon = v144
    tbl.Prehistoric:AddSection("Chế tạo vật phẩm núi lửa")

    tbl.Prehistoric:AddButton({
        Name = "Chế tạo Dragonheart",
        Description = "",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({"CraftItem", "Craft", "Dragonheart"}))
        end,
    })

    tbl.Prehistoric:AddButton({
        Name = "Chế tạo Dragonstorm",
        Description = "",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({"CraftItem", "Craft", "Dragonstorm"}))
        end,
    })

    tbl.Prehistoric:AddButton({
        Name = "Chế tạo Dino Hood",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({"CraftItem", "Craft", "DinoHood"}))
        end,
    })

    tbl.Prehistoric:AddButton({
        Name = "Chế tạo T-Rex Skull",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({"CraftItem", "Craft", "TRexSkull"}))
        end,
    })

    tbl.Prehistoric:AddSection("Prehistoric Island")
    local v145 = tbl.Prehistoric:AddParagraph("Prehistoric Island Status", "")

    spawn(function()
        while wait(0.2) do
            if not workspace.Map:FindFirstChild("PrehistoricIsland") and not workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") then
                v145:SetDesc("Prehistoric Island : False")
            else
                v145:SetDesc("Prehistoric Island : True")
            end
        end
    end)

    tbl.Prehistoric:AddButton({
        Name = "Chế tạo núi lửa nam châm",
        Callback = function()
            game:GetService("ReplicatedStorage").Modules.Net["RF/Craft"]:InvokeServer("PossibleHardcode", "Volcanic Magnet")
        end,
    })

    tbl.Prehistoric:AddToggle({
        Name = "Chế tạo núi lửa nam châm",
        Default = false,
        Callback = function(autoCraftVolcanic)
            getgenv().AutoCraftVolcanic = autoCraftVolcanic
        end,
    })

    tbl.Prehistoric:AddToggle({
        Name = "Tự động Tìm Tiền sử đảo",
        Description = "",
        Default = false,
        Callback = function(prehisFind)
            _G.Prehis_Find = prehisFind
            PrehisUser.Find = prehisFind
        end,
    })

    tbl.Prehistoric:AddToggle({
        Name = "Tự động Bắt đầu Sự kiện tiền sử",
        Default = false,
        Callback = function(autoStartPrehistoric)
            _G.AutoStartPrehistoric = autoStartPrehistoric
        end,
    })

    tbl.Prehistoric:AddToggle({
        Name = "Tự động Sửa Sự kiện tiền sử",
        Description = "",
        Default = false,
        Callback = function(prehisSkills)
            _G.Prehis_Skills = prehisSkills
            PrehisUser.Skills = prehisSkills
        end,
    })

    local v146 = tbl.Prehistoric:AddToggle({
        Name = "Tiêu diệt hào quang",
        Description = "",
        Default = false,
        Callback = function(killAuraFull)
            _G.KillAuraFull = killAuraFull
        end,
    })

    Kaura = v146

    local v147 = tbl.Prehistoric:AddToggle({
        Name = "Tự động Thu thập Dino Bones",
        Description = "",
        Default = false,
        Callback = function(prehisDb)
            _G.Prehis_DB = prehisDb
        end,
    })

    Vocan = v147

    local v148 = tbl.Prehistoric:AddToggle({
        Name = "Tự động Thu thập Dragon Eggs",
        Description = "",
        Default = false,
        Callback = function(prehisDe)
            _G.Prehis_DE = prehisDe
            PrehisUser.DE = prehisDe
        end,
    })

    Vocan = v148

    local v149 = tbl.Prehistoric:AddToggle({
        Name = "Tự động Đặt lại When Hoàn thành Volcano",
        Description = "",
        Default = false,
        Callback = function(resetPH)
            _G.ResetPH = resetPH
        end,
    })

    Toggle = v149
    tbl.SeaEvent:AddSection("Sự kiện biển / Khởi hành")

    tbl.SeaEvent:AddButton({
        Name = "Xóa Lighting Effect",
        Callback = function()
            game:GetService("Lighting").BaseAtmosphere:Destroy()
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "tàu tốc độ điều chỉnh",
        Default = false,
        Callback = function(speedBoat)
            getgenv().SpeedBoat = speedBoat
        end,
    })

    game:GetService("RunService").RenderStepped:Connect(function()
        if getgenv().SpeedBoat then
            local localPlayer = game:GetService("Players").LocalPlayer

            if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") and localPlayer.Character.Humanoid.Sit then
                for k, child in pairs(game:GetService("Workspace").Boats:GetChildren()) do
                    local vehicleSeat = child:FindFirstChildWhichIsA("VehicleSeat")

                    if vehicleSeat then
                        vehicleSeat.MaxSpeed = SetSpeedBoat
                    end
                end
            end
        end
    end)

    tbl.SeaEvent:AddSlider({
        Name = "tàu tốc độ",
        Min = 0,
        Max = 1000,
        Increment = 1,
        Default = 300,
        Callback = function(arg)
            SetSpeedBoat = arg
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Tự động Nhấn W",
        Default = false,
        Callback = function(autoPressW)
            getgenv().AutoPressW = autoPressW
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Không va chạm tàu",
        Default = false,
        Callback = function(noClipShip)
            getgenv().NoClipShip = noClipShip
        end,
    })

    tbl.SeaEvent:AddSection("Crafting Items")

    tbl.SeaEvent:AddButton({
        Name = "Chế tạo SharkTooth",
        Description = "",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({"CraftItem", "Craft", "SharkTooth"}))
        end,
    })

    tbl.SeaEvent:AddButton({
        Name = "Chế tạo TerrorJaw",
        Description = "",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({"CraftItem", "Craft", "TerrorJaw"}))
        end,
    })

    tbl.SeaEvent:AddButton({
        Name = "Chế tạo SharkAnchor",
        Description = "",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({"CraftItem", "Craft", "SharkAnchor"}))
        end,
    })

    tbl.SeaEvent:AddButton({
        Name = "Chế tạo LeviathanCrown",
        Description = "",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({"CraftItem", "Craft", "LeviathanCrown"}))
        end,
    })

    tbl.SeaEvent:AddButton({
        Name = "Chế tạo LeviathanShield",
        Description = "",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({"CraftItem", "Craft", "LeviathanShield"}))
        end,
    })

    tbl.SeaEvent:AddButton({
        Name = "Chế tạo LeviathanBoat",
        Description = "",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({"CraftItem", "Craft", "LeviathanBoat"}))
        end,
    })

    tbl.SeaEvent:AddButton({
        Name = "Chế tạo LegendaryScroll",
        Description = "",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({"CraftItem", "Craft", "LegendaryScroll"}))
        end,
    })

    tbl.SeaEvent:AddButton({
        Name = "Chế tạo MythicalScroll",
        Description = "",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({"CraftItem", "Craft", "MythicalScroll"}))
        end,
    })

    tbl.SeaEvent:AddSection("Choose Sea Event")

    local v150 = tbl.SeaEvent:AddDropdown({
        Name = "Chọn thuyền",
        Options = ListSeaBoat,
        Callback = function(selectedBoat)
            _G.SelectedBoat = selectedBoat
        end,
    })

    Q = v150

    tbl.SeaEvent:AddButton({
        Name = "Mua thuyền",
        Description = "",
        Callback = function()
            replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat)
        end,
    })

    local v151 = tbl.SeaEvent:AddDropdown({
        Name = "Chọn Biển cấp độ",
        Options = ListSeaZone,
        Callback = function(dangerSc)
            _G.DangerSc = dangerSc
        end,
    })

    Q = v151

    local v152 = tbl.SeaEvent:AddToggle({
        Name = "Tự động Lái thuyền Boat",
        Description = "",
        Default = false,
        Callback = function(sailBoats)
            _G.SailBoats = sailBoats
        end,
    })

    Q = v152
    tbl.SeaEvent:AddSection("Entity Sea Event")

    tbl.SeaEvent:AddToggle({
        Name = "Tự động cá mập",
        Description = "",
        Default = false,
        Callback = function(shark)
            _G.Shark = shark
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Tự động Piranha",
        Description = "",
        Default = false,
        Callback = function(piranha)
            _G.Piranha = piranha
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Tự động Terror cá mập",
        Description = "",
        Default = false,
        Callback = function(terrorShark)
            _G.TerrorShark = terrorShark
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Tự động cá Crew Member",
        Description = "",
        Default = false,
        Callback = function(mobCrew)
            _G.MobCrew = mobCrew
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Tự động Haunted Crew Member",
        Description = "",
        Default = false,
        Callback = function(hcm)
            _G.HCM = hcm
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Tự động Tấn công PirateGrandBrigade",
        Description = "",
        Default = false,
        Callback = function(pgb)
            _G.PGB = pgb
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Tự động Tấn công cá Boat",
        Description = "",
        Default = false,
        Callback = function(fishBoat)
            _G.FishBoat = fishBoat
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Tự động Tấn công Biển Beast",
        Description = "",
        Default = false,
        Callback = function(seaBeast1)
            _G.SeaBeast1 = seaBeast1
        end,
    })

    tbl.SeaEvent:AddSection("Đảo Kitsune / Sự kiện")
    local v153 = tbl.SeaEvent:AddParagraph("Kitsune Island Status", "")

    spawn(function()
        while wait(0.2) do
            if not workspace.Map:FindFirstChild("KitsuneIsland") and not workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island") then
                v153:SetDesc("Kitsune Island : False")
            else
                v153:SetDesc("Kitsune Island : True")
            end
        end
    end)

    tbl.SeaEvent:AddToggle({
        Name = "Tự động Tìm Kitsune đảo",
        Description = "",
        Default = false,
        Callback = function(autofindKitIs)
            _G.AutofindKitIs = autofindKitIs
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Tự động Dịch chuyển đến Shrine Actived",
        Description = "",
        Default = false,
        Callback = function(tweenShrine)
            _G.tweenShrine = tweenShrine
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Tự động Thu thập Azure Ember",
        Description = "",
        Default = false,
        Callback = function(collectEmber)
            _G.Collect_Ember = collectEmber
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Tự động Trade Azure Ember",
        Description = "",
        Default = false,
        Callback = function(tradeEmber)
            _G.Trade_Ember = tradeEmber
        end,
    })

    tbl.SeaEvent:AddButton({
        Name = "Trade vật phẩm Azure",
        Description = "",
        Callback = function()
            replicated.Modules.Net:FindFirstChild("RF/KitsuneStatuePray"):InvokeServer()
        end,
    })

    tbl.SeaEvent:AddButton({
        Name = "Talk với kitsune statue",
        Description = "",
        Callback = function()
            replicated.Modules.Net:FindFirstChild("RE/TouchKitsuneStatue"):FireServer()
        end,
    })

    tbl.SeaEvent:AddSection("Frozen Dimension Event")
    local v154 = tbl.SeaEvent:AddParagraph("FrozenDimension Status", "")

    spawn(function()
        pcall(function()
            while wait(0.2) do
                if workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension") then
                    v154:SetDesc("Frozen Dimension : True")
                else
                    v154:SetDesc("Frozen Dimension : False")
                end
            end
        end)
    end)

    local v155 = tbl.SeaEvent:AddParagraph("Spy Status", "")

    spawn(function()
        while wait(0.2) do
            pcall(function()
                local v156 = string.match(replicated.Remotes.CommF_:InvokeServer("InfoLeviathan", "1"), "%d+")

                if v156 then
                    v155:SetDesc("Spy Leviathan : " .. tostring(v156))

                    if tonumber(v156) == 5 then
                        v155:SetDesc("Spy Leviathan : Already Done!!")
                    end
                end
            end)
        end
    end)

    tbl.SeaEvent:AddButton({
        Name = "Mua Theo dõi",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("InfoLeviathan", "2")
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Tự động Dịch chuyển đóng băng Dimension",
        Description = "",
        Default = false,
        Callback = function(frozenTP)
            _G.FrozenTP = frozenTP
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Tự động Drive To Hydra đảo",
        Description = "",
        Default = false,
        Callback = function(sailBoatHydra)
            _G.SailBoat_Hydra = sailBoatHydra
        end,
    })

    tbl.SeaEvent:AddToggle({
        Name = "Tự động Tấn công Leviathan",
        Description = "",
        Default = false,
        Callback = function(leviathan1)
            _G.Leviathan1 = leviathan1
        end,
    })

    tbl.Esp:AddSection("Esp")

    tbl.Esp:AddToggle({
        Name = "Esp quả mọng",
        Description = "",
        Default = false,
        Callback = function(arg)
            BerryEsp = arg

            if arg then
                task.spawn(function()
                    while BerryEsp do
                        berriesEsp()
                        task.wait()
                    end
                end)
            else
                for i, child in ipairs(workspace:GetChildren()) do
                    if child:IsA("Part") and child.Name:match("BerryEspPart_.*") then
                        child:Destroy()
                    end
                end
            end
        end,
    })

    tbl.Esp:AddToggle({
        Name = "Esp người chơi",
        Description = "",
        Default = false,
        Callback = function(arg)
            PlayerEsp = arg

            if arg then
                task.spawn(function()
                    while PlayerEsp do
                        EspPly()
                        task.wait()
                    end
                end)
            else
                local v156 = next
                local children, v157 = game.Players:GetChildren()

                for k, v158 in v156, children, v157 do
                    pcall(function()
                        if not isnil(v158.Character) and not isnil(v158.Character.Head) and v158.Character.Head:FindFirstChild("NameEsp" .. Number) then
                            v158.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy()
                        end
                    end)
                end
            end
        end,
    })

    tbl.Esp:AddToggle({
        Name = "Esp rương",
        Description = "",
        Default = false,
        Callback = function(arg)
            ChestESP = arg

            if arg then
                task.spawn(function()
                    while ChestESP do
                        ChestEsp()
                        task.wait()
                    end
                end)
            else
                for i, v156 in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
                    local chestEspAttachment = v156:FindFirstChild("ChestEspAttachment")

                    if chestEspAttachment then
                        chestEspAttachment:Destroy()
                    end
                end
            end
        end,
    })

    tbl.Esp:AddToggle({
        Name = "Esp Trái ác quỷ",
        Description = "",
        Default = false,
        Callback = function(arg)
            DevilFruitESP = arg

            if arg then
                task.spawn(function()
                    while DevilFruitESP do
                        DevEsp()
                        task.wait()
                    end
                end)
            else
                local v156 = next
                local children, v157 = workspace:GetChildren()

                for k, v158 in v156, children, v157 do
                    pcall(function()
                        if v158:FindFirstChild("Handle") and v158.Handle:FindFirstChild("NameEsp" .. Number) then
                            v158.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
                        end
                    end)
                end
            end
        end,
    })

    tbl.Esp:AddToggle({
        Name = "Esp đảo",
        Description = "",
        Default = false,
        Callback = function(arg)
            IslandESP = arg

            if arg then
                task.spawn(function()
                    while IslandESP do
                        LocationEsp()
                        task.wait()
                    end
                end)
            else
                local v156 = next
                local children, v157 = workspace._WorldOrigin.Locations:GetChildren()

                for k, v158 in v156, children, v157 do
                    pcall(function()
                        if v158:FindFirstChild("NameEsp") then
                            v158:FindFirstChild("NameEsp"):Destroy()
                        end
                    end)
                end
            end
        end,
    })

    tbl.Esp:AddToggle({
        Name = "Esp hoa",
        Description = "",
        Default = false,
        Callback = function(arg)
            FlowerESP = arg

            if arg then
                task.spawn(function()
                    while FlowerESP do
                        flowerEsp()
                        task.wait()
                    end
                end)
            else
                for k, child in pairs(workspace:GetChildren()) do
                    pcall(function()
                        if (child.Name == "Flower2" or child.Name == "Flower1") and child:FindFirstChild("NameEsp" .. Number) then
                            child:FindFirstChild("NameEsp" .. Number):Destroy()
                        end
                    end)
                end
            end
        end,
    })

    tbl.Esp:AddToggle({
        Name = "Esp Legendary kiếm",
        Description = "",
        Default = false,
        Callback = function(arg)
            LegenS = arg

            if arg then
                task.spawn(function()
                    while LegenS do
                        LegenSword()
                        task.wait()
                    end
                end)
            elseif workspace:FindFirstChild("Lgd") then
                workspace:FindFirstChild("Lgd"):Destroy()
            end
        end,
    })

    tbl.Esp:AddToggle({
        Name = "Esp Haki Color",
        Description = "",
        Default = false,
        Callback = function(arg)
            ColorEsp = arg

            if arg then
                task.spawn(function()
                    while ColorEsp do
                        HakiClorEsp()
                        task.wait()
                    end
                end)
            elseif workspace:FindFirstChild("Gay") then
                workspace:FindFirstChild("Gay"):Destroy()
            end
        end,
    })

    tbl.Esp:AddToggle({
        Name = "Esp bánh răng",
        Description = "",
        Default = false,
        Callback = function(arg)
            ESPGear = arg

            if arg then
                task.spawn(function()
                    while ESPGear do
                        gearEsp()
                        task.wait()
                    end
                end)
            else
                local mysticIsland = workspace.Map:FindFirstChild("MysticIsland")
                local v156 = pairs
                local descendants = mysticIsland and mysticIsland:GetDescendants() or {}

                for k, descendant in v156(descendants) do
                    pcall(function()
                        if descendant:FindFirstChild("NameEsp") then
                            descendant:FindFirstChild("NameEsp"):Destroy()
                        end
                    end)
                end
            end
        end,
    })

    tbl.Esp:AddToggle({
        Name = "Esp SeaEvent đảo",
        Description = "",
        Default = false,
        Callback = function(arg)
            EspEventIsland = arg

            if arg then
                task.spawn(function()
                    while EspEventIsland do
                        EventIslandEsp()
                        task.wait()
                    end
                end)
            else
                for k, child in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
                    pcall(function()
                        if child:FindFirstChild("NameEsp") then
                            child:FindFirstChild("NameEsp"):Destroy()
                        end
                    end)
                end
            end
        end,
    })

    tbl.Esp:AddToggle({
        Name = "Esp nâng cao người bán",
        Description = "",
        Default = false,
        Callback = function(arg)
            advanEsp = arg

            if arg then
                task.spawn(function()
                    while advanEsp do
                        AdvanFruitEsp()
                        task.wait()
                    end
                end)
            elseif workspace:FindFirstChild("Adv") then
                workspace:FindFirstChild("Adv"):Destroy()
            end
        end,
    })

    tbl.Raids:AddSection("Fruits Options")
    local v156 = tbl.Raids:AddParagraph("Stock Fruit", "Loading...")

    task.spawn(function()
        while task.wait(60) do
            pcall(function()
                v156:SetDesc(getFruitStock())
            end)
        end
    end)

    pcall(function()
        v156:SetDesc(getFruitStock())
    end)

    local v157 = tbl.Raids:AddToggle({
        Name = "Tự động ngẫu nhiên Trái ác quỷ",
        Description = "",
        Default = false,
        Callback = function(randomAuto)
            _G.Random_Auto = randomAuto
            _G.RandomFruitCooldown = nil
        end,
    })

    RandomFF = v157

    local v158 = tbl.Raids:AddToggle({
        Name = "Tự động Thả Trái ác quỷ",
        Description = "",
        Default = false,
        Callback = function(dropFruit)
            _G.DropFruit = dropFruit
        end,
    })

    DropF = v158

    local v159 = tbl.Raids:AddToggle({
        Name = "Tự động Lưu trữ Trái ác quỷ",
        Description = "",
        Default = false,
        Callback = function(storeF)
            _G.StoreF = storeF
        end,
    })

    StoredF = v159

    local v160 = tbl.Raids:AddToggle({
        Name = "Tự động Tween đến Trái ác quỷ",
        Description = "",
        Default = false,
        Callback = function(twFruits)
            _G.TwFruits = twFruits
        end,
    })

    TwF = v160

    local v161 = tbl.Raids:AddToggle({
        Name = "Tự động Thu thập Trái ác quỷ",
        Description = "",
        Default = false,
        Callback = function(instanceF)
            _G.InstanceF = instanceF
        end,
    })

    BringF = v161

    tbl.Raids:AddDropdown({
        Name = "Chọn Trái ác quỷ Cửa hàng",
        Options = {
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
            "T-Rex-T-Rex",
            "Mammoth-Mammoth",
            "Dough-Dough",
            "Shadow-Shadow",
            "Venom-Venom",
            "Gas-Gas",
            "Control-Control",
            "Spirit-Spirit",
            "Leopard-Leopard",
            "Yeti-Yeti",
            "Kitsune-Kitsune",
            "Dragon-Dragon",
        },
        Callback = function(selectFruit)
            getgenv().SelectFruit = selectFruit
        end,
    })

    tbl.Raids:AddToggle({
        Name = "Tự động Mua Trái ác quỷ Cửa hàng",
        Default = false,
        Callback = function(autoBuyFruitSniper)
            getgenv().AutoBuyFruitSniper = autoBuyFruitSniper
        end,
    })

    tbl.Raids:AddSection("Sự kiện hầm ngục / Đột kích")

    DungeonTables = {
        "Flame",
        "Ice",
        "Quake",
        "Light",
        "Dark",
        "String",
        "Rumble",
        "Magma",
        "Human: Buddha",
        "Sand",
        "Bird: Phoenix",
        "Dough",
    }

    local v162 = tbl.Raids:AddDropdown({
        Name = "Chọn chip",
        Description = "",
        Options = DungeonTables,
        Callback = function(selectChip)
            _G.SelectChip = selectChip
        end,
    })

    Q = v162

    local v163 = tbl.Raids:AddToggle({
        Name = "Tự động Chọn hầm ngục chip",
        Description = "",
        Default = false,
        Callback = function(autoSelectDungeon)
            _G.AutoSelectDungeon = autoSelectDungeon
        end,
    })

    Q = v163

    tbl.Raids:AddToggle({
        Name = "Nhận Trái ác quỷ In túi đồ dưới 1M",
        Default = false,
        Callback = function(autoGetFruit)
            getgenv().AutoGetFruit = autoGetFruit
        end,
    })

    tbl.Raids:AddButton({
        Name = "Mua hầm ngục Chips [Beli]",
        Description = "",
        Callback = function()
            if not GetBP("Special Microchip") then
                replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
            end
        end,
    })

    tbl.Raids:AddButton({
        Name = "Mua hầm ngục Chips [Devil Trái ác quỷ]",
        Description = "",
        Callback = function()
            if GetBP("Special Microchip") then
                return
            end
            local tbl2 = {}
            local v164 = next
            local response, v165 = replicated:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits")

            for k, v166 in v164, response, v165 do
                if v166.Price <= 490000 then
                    table.insert(tbl2, v166.Name)
                end
            end

            local v166, v167, v168 = pairs(tbl2)
            local v169 = v168
            local v170 = v166
            local v171 = v167

            while true do
                local v172, v173 = v170(v171, v169)
                if v172 == nil then
                    break
                end

                for k in pairs(DungeonTables) do
                    if not GetBP("Special Microchip") then
                        replicated.Remotes.CommF_:InvokeServer("LoadFruit", tostring(v173))
                        replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
                    end
                end

                v169 = v172
            end
        end,
    })

    local v164 = tbl.Raids:AddToggle({
        Name = "Tự động Mua chip [Beli]",
        Description = "",
        Default = false,
        Callback = function(autoChipBeli)
            _G.AutoChipBeli = autoChipBeli
        end,
    })

    AutoChipBeli = v164

    local v165 = tbl.Raids:AddToggle({
        Name = "Tự động Mua chip [Devil Trái ác quỷ]",
        Description = "",
        Default = false,
        Callback = function(autoChipFruit)
            _G.AutoChipFruit = autoChipFruit
        end,
    })

    AutoChipFruit = v165

    local v166 = tbl.Raids:AddToggle({
        Name = "Tự động Bắt đầu Đột kích",
        Description = "",
        Default = false,
        Callback = function(autoStartRaid)
            _G.Auto_StartRaid = autoStartRaid
        end,
    })

    StartR = v166

    local v167 = tbl.Raids:AddToggle({
        Name = "Tự động Đột kích + tiếp theo đảo",
        Description = "",
        Default = false,
        Callback = function(raiding)
            _G.Raiding = raiding
        end,
    })

    Raiding = v167
end

local v2 = tbl.Raids:AddToggle({
    Name = "Tiêu diệt hào quang (đảo 4 & 5)",
    Description = "",
    Default = false,
    Callback = function(killAuraRaid)
        _G.KillAuraRaid = killAuraRaid
    end,
})

KillAuraRaid = v2

tbl.Raids:AddToggle({
    Name = "Tự động Thức tỉnh",
    Description = "",
    Default = false,
    Callback = function(autoAwakener)
        _G.Auto_Awakener = autoAwakener
    end,
})

tbl.Raids:AddToggle({
    Name = "Tự động Dịch chuyển To Lab",
    Default = false,
    Callback = function(tpLab)
        _G.TpLab = tpLab

        while _G.TpLab do
            wait()

            if _G.TpLab then
                if World2 and _G.TpLab then
                    _tp(CFrame.new(-6438.73535, 250.645355, -4501.50684))
                elseif World3 and _G.TpLab then
                    _tp(CFrame.new(-5046, 314, -2960))
                end
            end
        end
    end,
})

tbl.Raids:AddSection("Items Law/Order Sword")

tbl.Raids:AddButton({
    Name = "Mua Microchip Law",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "Microchip", "2")
    end,
})

tbl.Raids:AddButton({
    Name = "Bắt đầu Law Đột kích",
    Description = "",
    Callback = function()
        fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
    end,
})

tbl.Raids:AddToggle({
    Name = "Tự động Mua Microchip Law",
    Description = "",
    Default = false,
    Callback = function(autoBuyMicrochipLaw)
        getgenv().AutoBuyMicrochipLaw = autoBuyMicrochipLaw
    end,
})

tbl.Raids:AddToggle({
    Name = "Tự động Bắt đầu Law Đột kích",
    Description = "",
    Default = false,
    Callback = function(autoStartLawRaids)
        getgenv().AutoStartLawRaids = autoStartLawRaids
    end,
})

tbl.Raids:AddToggle({
    Name = "Tự động Tiêu diệt Law",
    Description = "",
    Default = false,
    Callback = function(autoLawKak)
        _G.AutoLawKak = autoLawKak
    end,
})

tbl.Raids:AddSection("Raids Dungeons")

tbl.Raids:AddToggle({
    Name = "Cày tự động hầm ngục",
    Description = "",
    Default = false,
    Callback = function(autoFarmDungeon)
        _G.AutoFarmDungeon = autoFarmDungeon
    end,
})

tbl.Raids:AddToggle({
    Name = "TP Thoát (1)",
    Default = false,
    Callback = function(tpFloor1)
        _G.TPFloor1 = tpFloor1
    end,
})

tbl.Raids:AddToggle({
    Name = "TP Thoát (2)",
    Default = false,
    Callback = function(tpFloor2)
        _G.TPFloor2 = tpFloor2
    end,
})

tbl.Raids:AddToggle({
    Name = "TP Thoát (3)",
    Default = false,
    Callback = function(tpFloor3)
        _G.TPFloor3 = tpFloor3
    end,
})

tbl.Raids:AddToggle({
    Name = "TP Thoát (4)",
    Default = false,
    Callback = function(tpFloor4)
        _G.TPFloor4 = tpFloor4
    end,
})

tbl.Combat:AddSection("Chiến đấu / Ngắm tự động")
local v3 = tbl.Combat:AddParagraph("All Players On Server", "")

spawn(function()
    while wait(Sec) do
        pcall(function()
            local n = #game:GetService("Players"):GetPlayers()

            if n == 12 then
                v3:SetDesc("All Players : " .. n .. " / 12 [Max]")
            else
                v3:SetDesc("All Players : " .. n .. " / 12")
            end
        end)
    end
end)

local v4 = tbl.Combat:AddParagraph("Aimbot Status", "")

Checking_AimStatus = function()
    if _G.AimCam then
        return "Aimbot Camera"
    end

    if not _G.AimbotGun then
        return ""
    end
    return "Aimbot Guns"
end

spawn(function()
    while wait(0.2) do
        pcall(function()
            if _G.AimMethod then
                if not _G.AimCam and not _G.AimbotGun then
                    v4:SetDesc("Aimbot - Skills : True")
                else
                    v4:SetDesc("Aimbot - " .. Checking_AimStatus() .. " : True")
                end
            else
                v4:SetDesc("Aimbot - Skills : False")
            end
        end)
    end
end)

tbl.Combat:AddDropdown({
    Name = "Chọn người chơi",
    Description = "",
    Options = PlrList,
    Callback = function(playersList)
        _G.PlayersList = playersList
    end,
})

tbl.Combat:AddToggle({
    Name = "Dịch chuyển To Chọn người chơi",
    Description = "",
    Default = false,
    Callback = function(tpPly)
        _G.TpPly = tpPly
    end,
})

tbl.Combat:AddToggle({
    Name = "Theo dõi Chọn người chơi",
    Description = "",
    Default = false,
    Callback = function(arg)
        SpectatePlys = arg
    end,
})

tbl.Combat:AddDropdown({
    Name = "Chọn Aim phương pháp",
    Description = "",
    Options = {"Aim Player", "Nearest Aim"},
    Callback = function(arg)
        ABmethod = arg
    end,
})

tbl.Combat:AddToggle({
    Name = "Ngắm tự động phương pháp kỹ năng",
    Description = "",
    Default = false,
    Callback = function(aimMethod)
        _G.AimMethod = aimMethod
    end,
})

tbl.Combat:AddToggle({
    Name = "Ngắm tự động Camera Closet người chơi",
    Description = "",
    Default = false,
    Callback = function(aimCam)
        _G.AimCam = aimCam
    end,
})

tbl.Combat:AddSection("Quests Players")

tbl.Combat:AddButton({
    Name = "Nhận người chơi Nhiệm vụ",
    Description = "",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
        end)
    end,
})

tbl.Combat:AddToggle({
    Name = "Tự động Nhận PlayerQuest",
    Description = "",
    Default = false,
    Callback = function(autoReceivePlayerQuest)
        _G.AutoReceivePlayerQuest = autoReceivePlayerQuest
    end,
})

tbl.Combat:AddToggle({
    Name = "Tự động Tiêu diệt người chơi Nhiệm vụ",
    Default = false,
    Callback = function(autoPlayerHunter)
        _G.AutoPlayerHunter = autoPlayerHunter

        if not autoPlayerHunter then
            Useskill = false
        end
    end,
})

tbl.Combat:AddToggle({
    Name = "Tự động Bật PvP",
    Description = "",
    Default = false,
    Callback = function(autoPvP)
        _G.AutoPvP = autoPvP
    end,
})

tbl.Combat:AddToggle({
    Name = "Tự động an toàn chế độ",
    Default = false,
    Callback = function(safeMode)
        _G.SafeMode = safeMode
    end,
})

tbl.Combat:AddSection("LocalPlayer Settings")

tbl.Combat:AddToggle({
    Name = "Bật Bay",
    Default = false,
    Callback = function(arg)
        toggleFly(arg)
    end,
})

tbl.Combat:AddSlider({
    Name = "tốc độ Bay chế độ",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(arg)
        updateFlySpeed(arg)
    end,
})

tbl.Combat:AddToggle({
    Name = "Lướt Không hồi chiêu",
    Default = false,
    Callback = function(dodgeNoCD)
        getgenv().DodgeNoCD = dodgeNoCD
    end,
})

tbl.Combat:AddToggle({
    Name = "Instance Mink V3 [ INF ]",
    Description = "",
    Default = false,
    Callback = function(arg)
        InfAblities = arg
    end,
})

tbl.Combat:AddToggle({
    Name = "Instance Energy [ INF ]",
    Description = "",
    Default = false,
    Callback = function(arg)
        infEnergy = arg

        if arg then
            getInfinity_Ability("Energy", infEnergy)
        end
    end,
})

tbl.Combat:AddToggle({
    Name = "Instance Soru [ INF ]",
    Description = "",
    Default = false,
    Callback = function(infSoru)
        _G.InfSoru = infSoru

        if infSoru then
            getInfinity_Ability("Soru", _G.InfSoru)
        end
    end,
})

tbl.Combat:AddToggle({
    Name = "Instance Observation Range [ INF ]",
    Description = "",
    Default = false,
    Callback = function(infiniteObRange)
        _G.InfiniteObRange = infiniteObRange

        if infiniteObRange then
            getInfinity_Ability("Observation", _G.InfiniteObRange)
        end
    end,
})

tbl.Combat:AddToggle({
    Name = "Ignore Same đội",
    Description = "",
    Default = false,
    Callback = function(noAimTeam)
        _G.NoAimTeam = noAimTeam
    end,
})

tbl.Combat:AddToggle({
    Name = "Nhận đồng minh",
    Description = "",
    Default = false,
    Callback = function(acceptAlly)
        _G.AcceptAlly = acceptAlly
    end,
})

tbl.Travel:AddSection("Di chuyển - Thế giới")

tbl.Travel:AddButton({
    Name = "Di chuyển East Blue (thế giới 1)",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("TravelMain")
    end,
})

tbl.Travel:AddButton({
    Name = "Di chuyển Dressrosa (thế giới 2)",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
    end,
})

tbl.Travel:AddButton({
    Name = "Di chuyển Zou (thế giới 3)",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("TravelZou")
    end,
})

tbl.Travel:AddSection("Di chuyển - Đảo")
Location = {}

for k, child in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
    table.insert(Location, child.Name)
end

local v5 = tbl.Travel:AddDropdown({
    Name = "Chọn Travelling",
    Description = "",
    Options = Location,
    Callback = function(island)
        _G.Island = island
    end,
})

Travelllll = v5

local v6 = tbl.Travel:AddToggle({
    Name = "Tự động Di chuyển",
    Description = "",
    Default = false,
    Callback = function(teleport)
        local v6, v7, v8, v9, v10, v11, n
        n = 1

        while true do
            if n == 1 then
                _G.Teleport = teleport

                if teleport then
                    n = 2
                else
                    n = 6
                end
            elseif n == 2 then
                v6, v7, v8 = pairs(workspace._WorldOrigin.Locations:GetChildren())
                v9 = v8
                n = 3
            elseif n == 3 then
                v10, v11 = v6(v7, v9)

                if v10 == nil then
                    n = 6
                else
                    n = 4
                end
            elseif n == 4 then
                v9 = v10

                if v11.Name == _G.Island then
                    n = 5
                else
                    n = 3
                end
            elseif n == 5 then
                wait()
                _tp(v11.CFrame * CFrame.new(0, 30, 0))

                if _G.Teleport and Root.CFrame ~= v11.CFrame then
                    n = 5
                else
                    n = 3
                end
            elseif n == 6 then
                return
            end
        end
    end,
})

GoIsland = v6
tbl.Travel:AddSection("Di chuyển - Cổng dịch chuyển")

if World1 then
    Location_Portal = {"Sky", "UnderWater"}
elseif World2 then
    Location_Portal = {"SwanRoom", "Cursed Ship"}
elseif World3 then
    Location_Portal = {
        "Castle On The Sea",
        "Mansion Cafe",
        "Hydra Teleport",
        "Canvendish Room",
        "Temple of Time",
    }
end

local v7 = tbl.Travel:AddDropdown({
    Name = "Chọn cổng dịch chuyển",
    Options = Location_Portal,
    Callback = function(islandPt)
        _G.Island_PT = islandPt
    end,
})

PortalTP = v7

tbl.Travel:AddButton({
    Name = "requestEntrance",
    Description = "",
    Callback = function()
        if _G.Island_PT == "Sky" then
            replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-7894, 5547, -380))
        elseif _G.Island_PT == "UnderWater" then
            replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163, 11, 1819))
        elseif _G.Island_PT == "SwanRoom" then
            replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(2285, 15, 905))
        elseif _G.Island_PT == "Cursed Ship" then
            replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923, 126, 32852))
        elseif _G.Island_PT == "Castle On The Sea" then
            replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5097.93164, 316.447021, -3142.66602, -0.405007899, -4.31682743e-08, 0.914313197, -1.90943332e-08, 1, 3.8755779e-08, -0.914313197, -1.76180437e-09, -0.405007899))
        elseif _G.Island_PT == "Mansion Cafe" then
            replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
        elseif _G.Island_PT == "Hydra Teleport" then
            replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625))
        elseif _G.Island_PT == "Canvendish Room" then
            replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5314.54638671875, 22.562219619750977, -127.06755065917969))
        elseif _G.Island_PT == "Temple of Time" then
            replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(28310.0234, 14895.1123, 109.456741, -0.469690144, -2.85620132e-08, -0.882831335, -3.23509219e-08, 1, -1.51411736e-08, 0.882831335, 2.14487486e-08, -0.469690144))
        end
    end,
})

tbl.Travel:AddSection("Di chuyển - NPC")

for k, child in pairs(replicated.NPCs:GetChildren()) do
    table.insert(NPCList, child.Name)
end

local v8 = tbl.Travel:AddDropdown({
    Name = "Chọn NPC",
    Options = NPCList,
    Callback = function(arg)
        NPClist = arg
    end,
})

NPCsPos = v8

local v9 = tbl.Travel:AddToggle({
    Name = "Tự động Tween đến NPC",
    Description = "",
    Default = false,
    Callback = function(tpNpc)
        _G.TPNpc = tpNpc
    end,
})

GoNPCs = v9
tbl.Shop:AddSection("Tùy chọn cửa hàng")

tbl.Shop:AddButton({
    Name = "Mua Buso",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Geppo",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyHaki", "Geppo")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Soru",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyHaki", "Soru")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Ken",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("KenTalk", "Buy")
    end,
})

tbl.Shop:AddSection("Fighting - Style")

tbl.Shop:AddButton({
    Name = "Mua Black Leg",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyBlackLeg")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Electro",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyElectro")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Fishman Karate",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyFishmanKarate")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua DragonClaw",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Superhuman",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuySuperhuman")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua tử vong Step",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyDeathStep")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Sharkman Karate",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua ElectricClaw",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyElectricClaw")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua DragonTalon",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyDragonTalon")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Godhuman",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyGodhuman")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua SanguineArt",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuySanguineArt")
    end,
})

tbl.Shop:AddSection("Accessory")

tbl.Shop:AddButton({
    Name = "Mua Tomoe Ring",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Tomoe Ring")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Black Cape",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Black Cape")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua kiếm sĩ mũ",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Swordsman Hat")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Bizarre Rifle",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 1)
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Ghoul Mask",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 2)
    end,
})

tbl.Shop:AddSection("Weapon World1")

tbl.Shop:AddButton({
    Name = "Mua Cutlass",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Cutlass")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Katana",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Katana")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Iron Mace",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Iron Mace")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Duel Katana",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Duel Katana")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Triple Katana",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Triple Katana")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Pipe",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Pipe")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Dual-Headed Blade",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Dual-Headed Blade")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Bisento",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Bisento")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua linh hồn Cane",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Soul Cane")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Slingshot",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Slingshot")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Musket",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Musket")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Dual Flintlock",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Dual Flintlock")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Flintlock",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Flintlock")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Refined Flintlock",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Refined Flintlock")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Cannon",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BuyItem", "Cannon")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Kabucha",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "2")
    end,
})

tbl.Shop:AddSection("Fragments shop")

tbl.Shop:AddButton({
    Name = "Mua Hoàn lại Chỉ số",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "2")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Đổi lại Tộc",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Ghoul Tộc",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("Ectoplasm", " Change", 4)
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Cyborg Tộc (2.5k)",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("CyborgTrainer", " Buy")
    end,
})

tbl.Shop:AddButton({
    Name = "Mua Draco Tộc",
    Callback = function()
        _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
        local vector = Vector3.new(5814.42724609375, 1208.3267822265625, 884.5785522460938)
        local character = player.Character
        local result = character or player.CharacterAdded:Wait()

        repeat
            wait()
        until (result.HumanoidRootPart.Position - vector).Magnitude < 1

        game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({{NPC = "Dragon Wizard", Command = "DragonRace"}}))
    end,
})

tbl.Misc:AddSection("Máy chủ - Chức năng")

tbl.Misc:AddButton({
    Name = "Đổi Tất cả mã",
    Description = "",
    Callback = function()
        local tbl2 = {
            "LIGHTNINGABUSE",
            "1LOSTADMIN",
            "ADMINFIGHT",
            "GIFTING_HOURS",
            "NOMOREHACK",
            "BANEXPLOIT",
            "WildDares",
            "BossBuild",
            "GetPranked",
            "EARN_FRUITS",
            "SUB2GAMERROBOT_RESET1",
            "KITT_RESET",
            "Bignews",
            "CHANDLER",
            "Fudd10",
            "fudd10_v2",
            "Sub2UncleKizaru",
            "FIGHT4FRUIT",
            "kittgaming",
            "TRIPLEABUSE",
            "Sub2CaptainMaui",
            "Sub2Fer999",
            "Enyu_is_Pro",
            "Magicbus",
            "JCWK",
            "Starcodeheo",
            "Bluxxy",
            "SUB2GAMERROBOT_EXP1",
            "Sub2NoobMaster123",
            "Sub2Daigrock",
            "Axiore",
            "TantaiGaming",
            "StrawHatMaine",
            "Sub2OfficialNoobie",
            "TheGreatAce",
            "JULYUPDATE_RESET",
            "ADMINHACKED",
            "SEATROLLING",
            "24NOADMIN",
            "ADMIN_TROLL",
            "NEWTROLL",
            "SECRET_ADMIN",
            "staffbattle",
            "NOEXPLOIT",
            "NOOB2ADMIN",
            "CODESLIDE",
            "fruitconcepts",
            "krazydares",
        }

        local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
        local redeem = remotes:FindFirstChild("Redeem")
        if not redeem then
            return
        end

        for i, v10 in ipairs(tbl2) do
            task.wait(0)

            pcall(function()
                if redeem.InvokeServer then
                    redeem:InvokeServer(v10)
                else
                    redeem:FireServer(v10)
                end
            end)
        end
    end,
})

tbl.Misc:AddButton({
    Name = "Vào lại máy chủ",
    Description = "",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
})

tbl.Misc:AddButton({
    Name = "chuyển máy chủ máy chủ",
    Description = "",
    Callback = function()
        task.spawn(function()
            local HttpService = game:GetService("HttpService")
            local TeleportService = game:GetService("TeleportService")
            local placeId = game.PlaceId
            local Players = game:GetService("Players")

            local ok, result = pcall(function()
                local response = game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")
                return HttpService:JSONDecode(response).data
            end)

            if ok and result then
                local id = nil

                for k, v10 in pairs(result) do
                    if v10.playing < v10.maxPlayers then
                        id = v10.id
                    end
                end

                if id then
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(placeId, id, Players.LocalPlayer)
                    end)
                end
            end
        end)
    end,
})

tbl.Misc:AddButton({
    Name = "chuyển máy chủ đến Lowest người chơi",
    Description = "",
    Callback = function()
        game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local placeId = game.PlaceId
        local str = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        local nextPageCursor = nil
        local v10, v11

        repeat
            v10 = ListServers(nextPageCursor)
            v11 = v10.data[1]
            nextPageCursor = v10.nextPageCursor
        until v11

        TeleportService:TeleportToPlaceInstance(placeId, v11.id, plr)
    end,
})

tbl.Misc:AddButton({
    Name = "chuyển máy chủ đến Lowest Pings máy chủ",
    Description = "",
    Callback = function()
        game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local Stats = game:GetService("Stats")
        local placeId = game.PlaceId
        local v10 = fetchServersData(placeId, 100)
        if not v10 then
            return
        end
        local v11 = v10[1]

        for k, v12 in pairs(v10) do
            if v12.ping < v11.ping and v12.playing < v12.maxPlayers then
                v11 = v12
            end
        end

        task.wait(0.5)
        local valueString = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()

        if tonumber(valueString:match("(%d+)")) >= 100 then
            TeleportService:TeleportToPlaceInstance(placeId, v11.id)
        end
    end,
})

tbl.Misc:AddTextBox({
    Name = "Nhập máy chủ ID",
    Placeholder = "máy chủ ID",
    ClearOnFocus = true,
    Callback = function(job)
        getgenv().Job = job
    end,
})

tbl.Misc:AddButton({
    Name = "Dịch chuyển [máy chủ ID]",
    Callback = function()
        if getgenv().Job and getgenv().Job ~= "" then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, getgenv().Job, game.Players.LocalPlayer)
        end
    end,
})

tbl.Misc:AddButton({
    Name = "Sao chép JobID",
    Description = "",
    Callback = function()
        setclipboard(tostring(game.JobId))
    end,
})

tbl.Misc:AddSection("Giao diện người chơi / Khác")

tbl.Misc:AddButton({
    Name = "Mở Awakenings Expert",
    Description = "",
    Callback = function()
        plr.PlayerGui.Main.AwakeningToggler.Visible = true
    end,
})

tbl.Misc:AddButton({
    Name = "Mở danh hiệu lựa chọn",
    Description = "",
    Callback = function()
        replicated.Remotes.CommF_:InvokeServer("getTitles", true)
        plr.PlayerGui.Main.Titles.Visible = true
    end,
})

local v10 = tbl.Misc:AddToggle({
    Name = "Tắt trò chuyện giao diện",
    Description = "",
    Default = false,
    Callback = function(rechat)
        _G.Rechat = rechat

        if _G.Rechat == true then
            game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
        elseif _G.chat == false then
            game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
        end
    end,
})

DisbleChat = v10

local v11 = tbl.Misc:AddToggle({
    Name = "Tắt bảng xếp hạng giao diện",
    Description = "",
    Default = false,
    Callback = function(arg)
        ReLeader = arg

        if ReLeader == true then
            game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
        elseif ReLeader == false then
            game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
        end
    end,
})

DisbleLeaderB = v11

tbl.Misc:AddButton({
    Name = "Đặt Hải tặc đội",
    Description = "",
    Callback = function()
        Pirates()
    end,
})

tbl.Misc:AddButton({
    Name = "Đặt Thủy quân đội",
    Description = "",
    Callback = function()
        Marines()
    end,
})

local v12 = tbl.Misc:AddToggle({
    Name = "Unlock Tất cả Portals",
    Description = "",
    Default = false,
    Callback = function(portalUnLock)
        _G.PortalUnLock = portalUnLock
    end,
})

UnPortal = v12
tbl.Misc:AddSection("Đồ họa / Chỉ số Haki")

HakiSt = {
    "State 0",
    "State 1",
    "State 2",
    "State 3",
    "State 4",
    "State 5",
}

local v13 = tbl.Misc:AddDropdown({
    Name = "Chọn Haki trạng thái",
    Options = HakiSt,
    Callback = function(selectStateHaki)
        _G.SelectStateHaki = selectStateHaki
    end,
})

HakiStat = v13

tbl.Misc:AddButton({
    Name = "ChangeBusoStage",
    Description = "",
    Callback = function()
        if _G.SelectStateHaki == "State 0" then
            replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage", 0)
        elseif _G.SelectStateHaki == "State 1" then
            replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage", 1)
        elseif _G.SelectStateHaki == "State 2" then
            replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage", 2)
        elseif _G.SelectStateHaki == "State 3" then
            replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage", 3)
        elseif _G.SelectStateHaki == "State 4" then
            replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage", 4)
        elseif _G.SelectStateHaki == "State 5" then
            replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage", 5)
        end
    end,
})

local v14 = tbl.Misc:AddToggle({
    Name = "Bật on RTX chế độ",
    Description = "",
    Default = false,
    Callback = function(rtxMode)
        _G.RTXMode = rtxMode
        local lighting = game.Lighting
        local colorCorrectionEffect = Instance.new("ColorCorrectionEffect", lighting)
        local colorCorrectionEffect2 = Instance.new("ColorCorrectionEffect", lighting)
        OldAmbient = lighting.Ambient
        OldBrightness = lighting.Brightness
        OldColorShift_Top = lighting.ColorShift_Top
        OldBrightnessc = colorCorrectionEffect.Brightness
        OldContrastc = colorCorrectionEffect.Contrast
        OldTintColorc = colorCorrectionEffect.TintColor
        OldTintColore = colorCorrectionEffect2.TintColor
        if not _G.RTXMode then
            return
        end

        while _G.RTXMode do
            wait()
            lighting.Ambient = Color3.fromRGB(33, 33, 33)
            lighting.Brightness = 0.3
            colorCorrectionEffect.Brightness = 0.176
            colorCorrectionEffect.Contrast = 0.39
            colorCorrectionEffect.TintColor = Color3.fromRGB(217, 145, 57)
            game.Lighting.FogEnd = 999

            if not plr.Character.HumanoidRootPart:FindFirstChild("PointLight") then
                local pointLight = Instance.new("PointLight")
                pointLight.Parent = plr.Character.HumanoidRootPart
                pointLight.Range = 15
                pointLight.Color = Color3.fromRGB(217, 145, 57)
            end

            if not _G.RTXMode then
                lighting.Ambient = OldAmbient
                lighting.Brightness = OldBrightness
                lighting.ColorShift_Top = OldColorShift_Top
                colorCorrectionEffect.Contrast = OldContrastc
                colorCorrectionEffect.Brightness = OldBrightnessc
                colorCorrectionEffect.TintColor = OldTintColorc
                colorCorrectionEffect2.TintColor = OldTintColore
                game.Lighting.FogEnd = 2500
                plr.Character.HumanoidRootPart:FindFirstChild("PointLight"):Destroy()
            end
        end
    end,
})

rtxM = v14

tbl.Misc:AddButton({
    Name = "Bật on Nhanh chế độ",
    Description = "",
    Callback = function()
        local v15 = next
        local descendants, v16 = workspace:GetDescendants()

        for k, v17 in v15, descendants, v16 do
            if table.find(Past, v17.ClassName) then
                v17.Material = "Plastic"
            end
        end
    end,
})

tbl.Misc:AddButton({
    Name = "Bật on thấp CPU",
    Description = "",
    Callback = function()
        LowCpu()
    end,
})

tbl.Misc:AddButton({
    Name = "Bật on Tăng thuyền",
    Description = "",
    Callback = function()
        for k, descendant in pairs(workspace.Boats:GetDescendants()) do
            if table.find(ListSeaBoat, descendant.Name) and tostring(descendant.Owner.Value) == tostring(plr.Name) then
                descendant.VehicleSeat.MaxSpeed = 350
                descendant.VehicleSeat.Torque = 0.2
                descendant.VehicleSeat.TurnSpeed = 5
                descendant.VehicleSeat.HeadsUpDisplay = true
            end
        end
    end,
})

tbl.Misc:AddButton({
    Name = "Xóa Sky sương mù",
    Description = "",
    Callback = function()
        if Lighting:FindFirstChild("LightingLayers") then
            Lighting.LightingLayers:Destroy()
        end

        if Lighting:FindFirstChild("SeaTerrorCC") then
            Lighting.SeaTerrorCC:Destroy()
        end

        if Lighting:FindFirstChild("FantasySky") then
            Lighting.FantasySky:Destroy()
        end
    end,
})

tbl.Misc:AddSection("Cấu hình - Thần")

tbl.Misc:AddButton({
    Name = "Mưa Trái ác quỷ (máy khách)",
    Description = "",
    Callback = function()
        for k, child in pairs(game:GetObjects("rbxassetid://14759368201")[1]:GetChildren()) do
            child.Parent = game.Workspace.Map
            child:MoveTo(plr.Character.PrimaryPart.Position + Vector3.new(math.random(-50, 50), 100, math.random(-50, 50)))

            if child.Fruit:FindFirstChild("AnimationController") then
                child.Fruit:FindFirstChild("AnimationController"):LoadAnimation(child.Fruit:FindFirstChild("Idle")):Play()
            end

            child.Handle.Touched:Connect(function(hit)
                if hit.Parent == plr.Character then
                    child.Parent = plr.Backpack
                    plr.Character.Humanoid:EquipTool(child)
                end
            end)
        end
    end,
})

local v15 = tbl.Misc:AddToggle({
    Name = "Bật on đầy sáng",
    Description = "",
    Default = false,
    Callback = function(arg)
        bright = arg

        if arg == true then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
            Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        else
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
        end
    end,
})

briggt1 = v15

local v16 = tbl.Misc:AddDropdown({
    Name = "Chọn thời gian",
    Description = "",
    Options = {"Day", "Night"},
    Default = Day,
    Callback = function(selectDN)
        _G.SelectDN = selectDN
    end,
})

DayN = v16

local v17 = tbl.Misc:AddToggle({
    Name = "Bật on thời gian",
    Description = "",
    Default = false,
    Callback = function(daylightN)
        _G.daylightN = daylightN
    end,
})

dayornight = v17

local v18 = tbl.Misc:AddToggle({
    Name = "Bật on Đi bộ on nước",
    Description = "",
    Default = true,
    Callback = function(walkWaterPart)
        _G.WalkWater_Part = walkWaterPart

        if _G.WalkWater_Part then
            game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)
        else
            game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 80, 1000)
        end
    end,
})

walkWater = v18

local v19 = tbl.Misc:AddToggle({
    Name = "Bật on băng Đi bộ",
    Description = "",
    Default = false,
    Callback = function(walkWater_)
        _G.WalkWater = walkWater_
    end,
})

iceWalk = v19

v:Notify({
    Title = "Winex Hub",
    Content = "Winex Hub Loading !",
    Image = "rbxassetid://81975913774040",
    Duration = 5,
})

-- [Duck Hub] Gom quai manh: keo tat ca quai cung loai quanh ban ve cho quai dang danh
task.spawn(function()
    local Players = game:GetService("Players")
    local RS = game:GetService("RunService")
    local lp = Players.LocalPlayer
    getgenv().BringRange = getgenv().BringRange or 450
    getgenv().BringMax = getgenv().BringMax or 25
    if _B == nil then _B = true end
    pcall(function()
        if sethiddenproperty then sethiddenproperty(lp, "SimulationRadius", math.huge) end
        lp.MaximumSimulationRadius = math.huge
    end)
    local acc = 0
    RS.Heartbeat:Connect(function(dt)
        acc += dt
        if acc < 0.08 then return end
        acc = 0
        if not _B then return end
        local ok = pcall(function()
            local char = lp.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local enemies = workspace:FindFirstChild("Enemies")
            if not hrp or not enemies then return end
            -- quai dang danh = quai gan nhat trong 70 studs
            local target, best = nil, 70
            for _, m in ipairs(enemies:GetChildren()) do
                local h, r = m:FindFirstChild("Humanoid"), m:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health > 0 then
                    local d = (r.Position - hrp.Position).Magnitude
                    if d < best then best, target = d, m end
                end
            end
            if not target then return end
            local tp = target.HumanoidRootPart.Position
            local n = 0
            for _, m in ipairs(enemies:GetChildren()) do
                if m ~= target and m.Name == target.Name then
                    local h, r = m:FindFirstChild("Humanoid"), m:FindFirstChild("HumanoidRootPart")
                    if h and r and h.Health > 0 and (r.Position - tp).Magnitude > 3
                        and (r.Position - hrp.Position).Magnitude <= getgenv().BringRange then
                        r.CFrame = CFrame.new(tp)
                        r.CanCollide = false
                        r.Velocity = Vector3.zero
                        if h then h.WalkSpeed = 0 end
                        pcall(function() r.Size = Vector3.new(50, 50, 50) end)
                        n += 1
                        if n >= getgenv().BringMax then break end
                    end
                end
            end
        end)
    end)
end)

-- [Duck Hub] Tab Race V4 + Hop (ghep tu ban cu)
do
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local replicated = game:GetService("ReplicatedStorage")
local Enemies = workspace:WaitForChild("Enemies")
local Sec = 0.5
World1 = World1 or (game.PlaceId == 2753915549 or game.PlaceId == 85211729168715)
World2 = World2 or (game.PlaceId == 4442272183 or game.PlaceId == 79091703265657)
World3 = World3 or (game.PlaceId == 7449423635 or game.PlaceId == 100117331123089)
if not HopDelay then HopDelay = _G.HopDelay or 5 end
if not topos then topos = function(cf) return _tp(cf) end end
if not StopTween then StopTween = function(state)
    if not state then
        _G.StopTween = true
        pcall(function() local c = plr.Character; if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.Anchored = false end end)
        task.wait(0.1)
        _G.StopTween = false
    end
end end
if not EquipWeapon then EquipWeapon = function(name)
    if not name then return end
    local t = plr.Backpack:FindFirstChild(name)
    if t and plr.Character and plr.Character:FindFirstChild("Humanoid") then plr.Character.Humanoid:EquipTool(t) end
end end
if not Alive then Alive = function(m) local h = m and m:FindFirstChild("Humanoid"); return h and h.Health > 0 end end
if not GetConnectionEnemies then GetConnectionEnemies = function(a)
    local function ok(v) return v:IsA("Model") and ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 end
    for _, v in pairs(replicated:GetChildren()) do if ok(v) then return v end end
    for _, v in pairs(Enemies:GetChildren()) do if ok(v) then return v end end
end end
if not HopServer then HopServer = function()
    local Http, TPS, cursor, found = game:GetService("HttpService"), game:GetService("TeleportService"), "", false
    repeat
        local ok, res = pcall(function() return game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100&cursor="..cursor) end)
        if ok and res then
            local d = Http:JSONDecode(res)
            for _, v in pairs(d.data or {}) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then found = true; TPS:TeleportToPlaceInstance(game.PlaceId, v.id); break end
            end
            cursor = d.nextPageCursor or ""
        else break end
    until cursor == "" or found
end end
-- ===== RACE V4 REPLACED - FROM USER CODE (converted to Redz UI) =====
tbl.RaceV4:AddSection("Teleport V4")

tbl.RaceV4:AddButton({
    Name = "Dịch chuyển To Top GreatTree",
    Callback = function()
        pcall(function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3030.39453125, 2280.6171875, -7320.18359375)
        end)
    end
})

tbl.RaceV4:AddButton({
    Name = "Dịch chuyển Temple Of thời gian",
    Callback = function()
        pcall(function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
        end)
    end
})

tbl.RaceV4:AddButton({
    Name = "Dịch chuyển cần gạt Kéo",
    Callback = function()
        pcall(function()
            topos(CFrame.new(28575.181640625, 14936.6279296875, 72.31636810302734))
        end)
    end
})

tbl.RaceV4:AddButton({
    Name = "Dịch chuyển To The đồng hồ",
    Callback = function()
        pcall(function()
            topos(CFrame.new(29553.7812, 15066.6133, -88.2750015, 1, 0, 0, 0, 1, 0, 0, 0, 1))
        end)
    end
})

tbl.RaceV4:AddSection("Trial V4")

tbl.RaceV4:AddButton({
    Name = "Tự động Tộc Door",
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

tbl.RaceV4:AddButton({
    Name = "Mua cổ đại One Nhiệm vụ",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UpgradeRace", "Buy")
        end)
    end
})

tbl.RaceV4:AddToggle({
    Name = "Tự động thử thách người ma",
    Default = false,
    Callback = function(Value)
        _G.Kill_Aura = Value
        pcall(function() StopTween(_G.Kill_Aura) end)
    end
})

tbl.RaceV4:AddToggle({
    Name = "Tự động thử thách Tất cả Tộc",
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

tbl.RaceV4:AddToggle({
    Name = "Tự động Tiêu diệt người chơi after thử thách V4",
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

tbl.RaceV4:AddSection("Auto Skill")

tbl.RaceV4:AddToggle({
    Name = "Tự động kỹ năng Z",
    Default = false,
    Callback = function(Value)
        _G.XaiSkillZ = Value
        pcall(function() StopTween(_G.XaiSkillZ) end)
    end
})

tbl.RaceV4:AddToggle({
    Name = "Tự động kỹ năng X",
    Default = false,
    Callback = function(Value)
        _G.XaiSkillX = Value
        pcall(function() StopTween(_G.XaiSkillX) end)
    end
})

tbl.RaceV4:AddToggle({
    Name = "Tự động kỹ năng C",
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



-- ===== tbl.Hop = Hop Tab =====
tbl.Hop:AddSection("Boss Tyrant Hop")

tbl.Hop:AddToggle({
    Name = "Tự động Tấn công hoặc chuyển máy chủ máy chủ Tyrant",
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

tbl.Hop:AddSection("Boss Rip Indra Hop")

tbl.Hop:AddToggle({
    Name = "Tự động Tấn công hoặc chuyển máy chủ máy chủ Rip Indra",
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

tbl.Hop:AddSection("Boss Darkbeard Hop")

tbl.Hop:AddToggle({
    Name = "Tự động Tấn công hoặc chuyển máy chủ máy chủ Darkbeard",
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

tbl.Hop:AddSection("Boss Elite Hunter Hop")

tbl.Hop:AddToggle({
    Name = "Tự động Tấn công hoặc chuyển máy chủ máy chủ Elites",
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

tbl.Hop:AddSection("Boss Dough King V2 Hop")

tbl.Hop:AddToggle({
    Name = "Tự động Tấn công hoặc chuyển máy chủ máy chủ Dough King",
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

tbl.Hop:AddSection("Boss Hallow Reaper Hop")

tbl.Hop:AddToggle({
    Name = "Tự động Tấn công hoặc chuyển máy chủ máy chủ Hallow tử thần",
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

tbl.Hop:AddSection("Observation Hop Server")

tbl.Hop:AddToggle({
    Name = "Tự động Cày hoặc chuyển máy chủ máy chủ Observation [BETA]",
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

tbl.Hop:AddSection("Fruits Hop Server")

tbl.Hop:AddToggle({
    Name = "Tự động Cày hoặc chuyển máy chủ máy chủ Trái ác quỷ",
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

tbl.Hop:AddSection("Chest Hop Server")

tbl.Hop:AddToggle({
    Name = "Tự động chuyển máy chủ máy chủ rương",
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

tbl.Hop:AddSection("Server Hop Utilities")

tbl.Hop:AddButton({
    Name = "chuyển máy chủ máy chủ (Normal)",
    Callback = function()
        Hop()
    end
})

tbl.Hop:AddButton({
    Name = "chuyển máy chủ máy chủ thấp người chơi",
    Callback = function()
        HopServer()
    end
})

tbl.Hop:AddButton({
    Name = "Vào lại Same máy chủ",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

-- Kết thúc phần gộp chức năng chuyển máy chủ

end

-- Kịch bản
