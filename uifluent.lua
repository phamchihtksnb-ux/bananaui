-- discord.gg/syncrypt

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local RegisterHit = require(ReplicatedStorage.Modules.Net):RemoteEvent("RegisterHit", true)
local reRegisterAttack = ReplicatedStorage.Modules.Net["RE/RegisterAttack"]

_G.BringMob = true
_G.BringRadius = 235
_G.FlyHeight = 12
_G.OrbitRadius = 8
task.spawn(function()
	while task.wait() do
		local Character = LocalPlayer.Character
		local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart and Character:FindFirstChildOfClass("Tool") then
			local t1 = {}
			local v8
			local n1 = 50

			for _, child in pairs(workspace.Enemies:GetChildren()) do
				local HumanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")
				local Humanoid = child:FindFirstChild("Humanoid")

				if HumanoidRootPart2 then
					if Humanoid then
						if Humanoid.Health > 0 then
							local Magnitude = (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude

							if Magnitude < n1 then
								n1 = Magnitude
								v8 = HumanoidRootPart2
							end

							table.insert(t1, {
								child,
								HumanoidRootPart2,
								Humanoid
							})
						end
					end
				end
			end

			if v8 and _G.BringMob then
				local Position = v8.Position

				if sethiddenproperty then
					sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
				end

				local v16 = tick() * 4

				HumanoidRootPart.CFrame = CFrame.new(Position + Vector3.new(math.cos(v16) * _G.OrbitRadius, _G.FlyHeight, math.sin(v16) * _G.OrbitRadius), Position)
				reRegisterAttack:FireServer()

				for _, v in pairs(t1) do
					local v19 = v[1]
					local v20 = v[2]
					local v21 = v[3]

					if (v20.Position - Position).Magnitude <= _G.BringRadius then
						v20.CanCollide = false
						v20.AssemblyLinearVelocity = Vector3.zero
						v20.AssemblyAngularVelocity = Vector3.zero
						v20.CFrame = CFrame.new(Position)

						local Animator = v21:FindFirstChildOfClass("Animator")

						if Animator then
							Animator:Destroy()
						end

						if v21.Health > 0 then
							RegisterHit:FireServer(v20, { {
								v19,
								v20
							} }, nil, nil, tostring(LocalPlayer.UserId):sub(2, 4) .. tostring(math.random(100, 999)))
						end
					end
				end
			end
		end
	end
end)

local handlers = {
	[3] = table.concat
}

if not game:IsLoaded() then
	repeat
		game.Loaded:Wait()
	until game:IsLoaded()
end

getgenv().Config = {
	["Auto Farming"] = true,
	Settings = {
		["FPS Booster"] = false
	},
	Melee = {
		["All Melee V1"] = true,
		["Super Huamn"] = true,
		["Dragon Talon"] = true,
		["Sharkman Karate"] = true,
		["Elechic Claw"] = true,
		GodHuman = true
	},
	Sword = {
		["All Sword"] = true,
		Saber = true,
		Pole = true,
		Rengoku = true,
		["Midnight Blade"] = true,
		["Soul Cane"] = true,
		["Gravity Cane"] = true,
		["Dragon Trident"] = true,
		["Legendary Sword"] = true,
		["True Triple Katana"] = true,
		["Twin Hooks"] = true,
		Canvander = true,
		["Buddy Sword"] = true,
		["Hallow Scythe"] = true,
		Yama = true,
		Tushita = true,
		["Cursed Dual Katana"] = true
	},
	Gun = {
		["All Gun"] = true,
		["Acidum Rifle"] = true,
		Kabucha = true,
		["Serpent Bow"] = true,
		["Soul Guitar"] = true
	},
	Race = {
		["Auto V2"] = true,
		["Auto V3"] = true
	}
}

if not getgenv().Configs then
	if getgenv().Config then
		local Config = getgenv().Config

		getgenv().Configs = {
			Quest = {
				["Evo Race V1"] = Config.Race and Config.Race["Auto V2"] or false,
				["Evo Race V2"] = Config.Race and Config.Race["Auto V3"] or false,
				["RGB Haki"] = true,
				["Pull Lerver"] = true
			},
			Sword = {},
			Gun = {},
			["FPS Booster"] = Config.Settings and Config.Settings["FPS Booster"] or false
		}

		if Config.Sword then
			if Config.Sword["All Sword"] then
				getgenv().Configs.Sword = {
					"Saber",
					"Pole (1st Form)",
					"Rengoku",
					"Midnight Blade",
					"Soul Cane",
					"Gravity Blade",
					"Yama",
					"Tushita",
					"Cursed Dual Katana"
				}
			else
				local sword = {}

				if Config.Sword.Saber then
					table.insert(sword, "Saber")
				end

				if Config.Sword.Pole then
					table.insert(sword, "Pole (1st Form)")
				end

				if Config.Sword.Rengoku then
					table.insert(sword, "Rengoku")
				end

				if Config.Sword["Midnight Blade"] then
					table.insert(sword, "Midnight Blade")
				end

				if Config.Sword["Soul Cane"] then
					table.insert(sword, "Soul Cane")
				end

				if Config.Sword.Yama then
					table.insert(sword, "Yama")
				end

				if Config.Sword.Tushita then
					table.insert(sword, "Tushita")
				end

				if Config.Sword["Cursed Dual Katana"] then
					table.insert(sword, "Cursed Dual Katana")
				end

				getgenv().Configs.Sword = sword
			end
		end

		if Config.Gun then
			if Config.Gun["All Gun"] then
				getgenv().Configs.Gun = {
					"Soul Guitar",
					"Kabucha",
					"Venom Bow"
				}
			else
				local gun = {}

				if Config.Gun["Soul Guitar"] then
					table.insert(gun, "Soul Guitar")
				end

				if Config.Gun.Kabucha then
					table.insert(gun, "Kabucha")
				end

				if Config.Gun["Serpent Bow"] then
					table.insert(gun, "Venom Bow")
				end

				getgenv().Configs.Gun = gun
			end
		end
	else
		getgenv().Configs = {
			Quest = {
				["Evo Race V1"] = true,
				["Evo Race V2"] = true,
				["RGB Haki"] = true,
				["Pull Lerver"] = true
			},
			Sword = {},
			Gun = {},
			["FPS Booster"] = false
		}
	end
end

if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") then
	if game.Players.LocalPlayer.PlayerGui["Main (minimal)"]:FindFirstChild("ChooseTeam") then
		while true do
			wait()

			if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)").ChooseTeam.Visible then
				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", "Pirates")
			end

			if game.Players.LocalPlayer.Team == nil then
				continue
			end

			if game:IsLoaded() then
				break
			end
		end
	end
end

wait(5)

if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") then
	if game.Players.LocalPlayer.PlayerGui["Main (minimal)"]:FindFirstChild("ChooseTeam") then
		while true do
			wait()

			if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)").ChooseTeam.Visible then
				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", "Pirates")
			end

			if game.Players.LocalPlayer.Team == nil then
				continue
			end

			if game:IsLoaded() then
				break
			end
		end
	end
end

handlers[29] = game:GetService("Players")
handlers[5] = handlers[29].LocalPlayer
handlers[30] = game.PlaceId
handlers[19] = game:GetService("Workspace")
handlers[40] = handlers[19]:WaitForChild("Enemies")
handlers[10] = game:GetService("TeleportService")
handlers[7] = game:GetService("ReplicatedStorage")
handlers[24] = handlers[5]:WaitForChild("Data"):WaitForChild("Level")
handlers[17] = handlers[5]:WaitForChild("Data"):WaitForChild("Fragments")
handlers[1] = handlers[5]:WaitForChild("Data"):WaitForChild("Beli")
handlers[48] = require(handlers[7].Modules.Net)
handlers[16] = game:GetService("Lighting")
handlers[2] = game:service("VirtualInputManager")
handlers[33] = game:service("VirtualUser")
handlers[4] = game:GetService("CoreGui")
handlers[45] = {}
task.spawn(function()
end)
wait(2)
task.spawn(function()
	if _G.FPSBoosterActive and getgenv().Configs["FPS Booster"] then
		local t2 = {
			[3] = handlers[19]:WaitForChild("Enemies")
		}

		t2[2] = handlers[19]:WaitForChild("Map"):GetDescendants()

		for i, v in ipairs(t2[2]) do
			local t3 = {
				[2] = i,
				v
			}

			if t3[1]:IsA("BasePart") then
				local t4 = {
					[2] = false
				}

				for i2 = 1, 5 do
					local t5 = {
						[3] = i2
					}

					t5[1] = handlers[19].Map.Jungle.QuestPlates:FindFirstChild("Plate" .. t5[3])

					if t5[1] and t3[1].Name == "Button" then
						if t3[1]:IsDescendantOf(t5[1]) then
							t4[2] = true

							break
						end
					end
				end

				if not t4[2] then
					if t3[1].Name == "Door" then
						if t3[1]:IsDescendantOf(handlers[19].Map.Ice) then
							continue
						end
					end

					if not t3[1]:IsDescendantOf(handlers[19].Map.Jungle:FindFirstChild("Final")) then
						if handlers[19].Map:FindFirstChild("IceCastle") then
							if t3[1]:IsDescendantOf(handlers[19].Map:FindFirstChild("IceCastle")) then
								continue
							end
						end

						t4[1] = true

						for i2, child in ipairs(t2[3]:GetChildren()) do
							local t6 = {
								[3] = i2,
								child
							}

							t6[2] = t6[1]:FindFirstChild("HumanoidRootPart")

							if t6[2] and (t6[2].Position - t3[1].Position).Magnitude < 10 then
								t4[1] = false

								break
							end
						end

						if t4[1] then
							t3[1]:Destroy()
						end
					end
				end
			end
		end

		if handlers[5].PlayerGui:FindFirstChild("Notifications") then
			handlers[5].PlayerGui.Notifications.Enabled = false
		end

		shared = shared or {}

		if shared.BC_1 == nil then
			shared.BC_1 = true
		end

		if _G.FPSBoosterActive and shared.BC_1 and shared.BC_2 == nil then
			local t7 = {
				[6] = workspace,
				[4] = handlers[16]
			}

			t7[3] = t7[6].Terrain
			t7[2] = handlers[29]
			t7[1] = handlers[5].Character
			t7[3].WaterWaveSize = 0
			t7[3].WaterWaveSpeed = 0
			t7[3].WaterReflectance = 0
			t7[3].WaterTransparency = 0
			t7[4].GlobalShadows = false
			t7[4].FogEnd = 9e9
			t7[4].Brightness = 0

			if settings and settings().Rendering then
				settings().Rendering.QualityLevel = "Level01"
				settings().Rendering.GraphicsMode = "NoGraphics"
			end

			for k, descendant in pairs(t7[6]:GetDescendants()) do
				local t8 = {
					[2] = k,
					[3] = descendant
				}

				if not t8[3]:IsA("BasePart") then
					if not t8[3]:IsA("SpawnLocation") then
						if not t8[3]:IsA("WedgePart") then
							if not t8[3]:IsA("Terrain") then
								if not t8[3]:IsA("MeshPart") then
									if not t8[3]:IsA("Decal") then
										if not t8[3]:IsA("Texture") then
											if not t8[3]:IsA("ParticleEmitter") then
												if not t8[3]:IsA("Trail") then
													if t8[3]:IsA("Explosion") then
														t8[3].BlastPressure = 0
														t8[3].BlastRadius = 0
													else
														if not t8[3]:IsA("Fire") then
															if not t8[3]:IsA("SpotLight") then
																if not t8[3]:IsA("Smoke") then
																	if not t8[3]:IsA("Sparkles") then
																		if t8[3]:IsA("MeshPart") then
																			t8[3].Material = Enum.Material.Plastic
																			t8[3].Reflectance = 0
																			t8[3].TextureID = ""
																			t8[3].CastShadow = false
																			t8[3].RenderFidelity = Enum.RenderFidelity.Performance
																		elseif t8[3]:IsA("SpecialMesh") then
																			t8[3].TextureId = ""
																		else
																			if not t8[3]:IsA("Shirt") then
																				if not t8[3]:IsA("Pants") then
																					if not t8[3]:IsA("Accessory") then
																						continue
																					end
																				end
																			end

																			t8[3]:Destroy()
																		end

																		continue
																	end
																end
															end
														end

														t8[3].Enabled = false
													end

													continue
												end
											end

											t8[3].LightInfluence = 0
											t8[3].Texture = ""
											t8[3].Lifetime = NumberRange.new(0)

											continue
										end
									end

									t8[3].Texture = ""
									t8[3].Transparency = 1

									continue
								end
							end
						end
					end
				end

				t8[3].Material = Enum.Material.Plastic
				t8[3].Reflectance = 0
				t8[3].CastShadow = false
			end

			for k, descendant in pairs(t7[4]:GetDescendants()) do
				local t9 = {
					k,
					descendant
				}

				if not t9[2]:IsA("BlurEffect") then
					if not t9[2]:IsA("SunRaysEffect") then
						if not t9[2]:IsA(handlers[3]({
							"ColorCorrectionEffec",
							"t"
						})) then
							if not t9[2]:IsA("BloomEffect") then
								if not t9[2]:IsA("DepthOfFieldEffect") then
									continue
								end
							end
						end
					end
				end

				t9[2].Enabled = false
			end

			if t7[1] then
				for k, descendant in pairs(t7[1]:GetDescendants()) do
					local t10 = {
						[3] = k,
						[2] = descendant
					}

					if not t10[2]:IsA("Shirt") then
						if not t10[2]:IsA("Pants") then
							if not t10[2]:IsA("Accessory") then
								continue
							end
						end
					end

					t10[2]:Destroy()
				end
			end

			if handlers[30] == 2753915549 or handlers[30] == 4442272183 or handlers[30] == 7449423635 then
				local t11 = { handlers[7]:FindFirstChild("Effect") and handlers[7].Effect:FindFirstChild("Container") }

				if t11[1] then
					local t12 = {
						t11[1]:FindFirstChild("Shared"),
						[3] = t11[1]:FindFirstChild("Misc")
					}

					if t12[1] then
						if t12[1]:FindFirstChild("AirDash") then
							t12[1].AirDash:Destroy()
						end

						if t12[1]:FindFirstChild("LightningTP") then
							t12[1].LightningTP:Destroy()
						end
					end

					if t12[3] then
						if t12[3]:FindFirstChild("Damage") then
							t12[3].Damage:Destroy()
						end

						if t12[3]:FindFirstChild("Confetti") then
							t12[3].Confetti:Destroy()
						end
					end

					if t11[1]:FindFirstChild("LevelUp") then
						t11[1].LevelUp:Destroy()
					end
				end
			end
		end

		shared.BC_2 = true
	end
end)
handlers[43] = game:GetService("CoreGui")
handlers[6] = game:GetService("TweenService")
handlers[5] = game:GetService("Players").LocalPlayer

if handlers[43]:FindFirstChild("Status_UI") then
	handlers[43].Status_UI:Destroy()
end

local function v49(p1)
	return string.format("%02d:%02d:%02d", math.floor(p1 / 3600) % 24, math.floor(p1 / 60) % 60, p1 % 60)
end

handlers[5] = game:GetService("Players").LocalPlayer
handlers[43] = game:GetService("CoreGui")
handlers[6] = game:GetService("TweenService")

if handlers[43]:FindFirstChild("Status_UI") then
	handlers[43].Status_UI:Destroy()
end

handlers[11] = Instance.new("ScreenGui")
handlers[11].Name = "Status_UI"
handlers[11].ResetOnSpawn = false
handlers[11].Parent = handlers[43]
handlers[42] = Instance.new("Frame")
handlers[42].Size = UDim2.new(0, 150, 0, 50)
handlers[42].Position = UDim2.new(1, -10, 0.5, 0)
handlers[42].AnchorPoint = Vector2.new(1, 0.5)
handlers[42].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
handlers[42].BackgroundTransparency = 0.25
handlers[42].BorderSizePixel = 2
handlers[42].BorderColor3 = Color3.fromRGB(0, 200, 80)
handlers[42].Parent = handlers[11]
handlers[41] = Instance.new("UICorner")
handlers[41].CornerRadius = UDim.new(0, 6)
handlers[41].Parent = handlers[42]
handlers[12] = Instance.new("UIStroke")
handlers[12].Thickness = 2
handlers[12].Color = Color3.fromRGB(0, 200, 80)
handlers[12].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
handlers[12].Parent = handlers[42]
handlers[15] = Instance.new("TextLabel")
handlers[15].Size = UDim2.new(1, -10, 0.5, 0)
handlers[15].Position = UDim2.new(0.5, 0, 0, 2)
handlers[15].AnchorPoint = Vector2.new(0.5, 0)
handlers[15].BackgroundTransparency = 1
handlers[15].Text = "TÃ€Y Slayer Hub - Kaitun"
handlers[15].TextColor3 = Color3.fromRGB(0, 200, 80)
handlers[15].TextSize = 13
handlers[15].Font = Enum.Font.GothamBold
handlers[15].TextXAlignment = Enum.TextXAlignment.Center
handlers[15].TextYAlignment = Enum.TextYAlignment.Center
handlers[15].Parent = handlers[42]
handlers[26] = Instance.new("TextLabel")
handlers[26].Size = UDim2.new(1, -10, 0.4, 0)
handlers[26].Position = UDim2.new(0.5, 0, 0.5, 0)
handlers[26].AnchorPoint = Vector2.new(0.5, 0)
handlers[26].BackgroundTransparency = 1
handlers[26].Text = "Status : N/A"
handlers[26].TextColor3 = Color3.fromRGB(0, 200, 80)
handlers[26].TextSize = 12
handlers[26].Font = Enum.Font.Gotham
handlers[26].TextXAlignment = Enum.TextXAlignment.Center
handlers[26].TextYAlignment = Enum.TextYAlignment.Center
handlers[26].Parent = handlers[42]
L_NEW_FRAME = Instance.new("Frame")
L_NEW_FRAME.Size = UDim2.new(0, 250, 0, 60)
L_NEW_FRAME.Position = UDim2.new(0.5, 0, 0.13, 0)
L_NEW_FRAME.AnchorPoint = Vector2.new(0.5, 0.5)
L_NEW_FRAME.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
L_NEW_FRAME.BackgroundTransparency = 0.25
L_NEW_FRAME.Parent = handlers[11]
L_NEW_CORNER = Instance.new("UICorner")
L_NEW_CORNER.CornerRadius = UDim.new(0, 6)
L_NEW_CORNER.Parent = L_NEW_FRAME
L_NEW_STROKE = Instance.new("UIStroke")
L_NEW_STROKE.Thickness = 2
L_NEW_STROKE.Color = Color3.fromRGB(0, 200, 80)
L_NEW_STROKE.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
L_NEW_STROKE.Parent = L_NEW_FRAME
L_NEW_TEXT = Instance.new("TextLabel")
L_NEW_TEXT.Size = UDim2.new(1, 0, 1, 0)
L_NEW_TEXT.BackgroundTransparency = 1
L_NEW_TEXT.Text = "TÃ y Slayer Hub"
L_NEW_TEXT.TextColor3 = Color3.fromRGB(0, 200, 80)
L_NEW_TEXT.TextSize = 14
L_NEW_TEXT.Font = Enum.Font.GothamBold
L_NEW_TEXT.Parent = L_NEW_FRAME
task.spawn(function()
	while task.wait() do
		local t13 = {
			[4] = handlers[6]:Create(handlers[12], TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Color = Color3.fromRGB(0, 200, 80)
			}),
			[5] = handlers[6]:Create(handlers[12], TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Color = Color3.fromRGB(0, 200, 80)
			}),
			[2] = handlers[6]:Create(handlers[15], TweenInfo.new(1.2), {
				TextColor3 = Color3.fromRGB(0, 200, 80)
			}),
			[3] = handlers[6]:Create(handlers[15], TweenInfo.new(1.2), {
				TextColor3 = Color3.fromRGB(0, 200, 80)
			}),
			handlers[6]:Create(handlers[26], TweenInfo.new(1.2), {
				TextColor3 = Color3.fromRGB(0, 200, 80)
			}),
			[7] = handlers[6]:Create(handlers[26], TweenInfo.new(1.2), {
				TextColor3 = Color3.fromRGB(0, 200, 80)
			})
		}
		local tween = handlers[6]:Create(L_NEW_STROKE, TweenInfo.new(1.2), {
			Color = Color3.fromRGB(0, 200, 80)
		})
		local tween2 = handlers[6]:Create(L_NEW_TEXT, TweenInfo.new(1.2), {
			TextColor3 = Color3.fromRGB(0, 200, 80)
		})

		t13[4]:Play()
		t13[2]:Play()
		t13[1]:Play()
		tween:Play()
		tween2:Play()
		t13[4].Completed:Wait()
		t13[5]:Play()
		t13[3]:Play()
		t13[7]:Play()
		t13[5].Completed:Wait()
	end
end)
handlers[45].Status = function(p2)
	pcall(function()
		if handlers[26] then
			handlers[26].Text = "Status : " .. tostring(p2)
		end
	end)
end

local TextButton = Instance.new("TextButton")

TextButton.Size = UDim2.new(0, 140, 0, 26)
TextButton.Position = UDim2.new(1, -155, 0.5, 20)
TextButton.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
TextButton.Text = "Bat FPS Boost"
TextButton.Font = Enum.Font.GothamBold
TextButton.TextSize = 13
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.Parent = handlers[42]
Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)
TextButton.MouseButton1Click:Connect(function()
	_G.FPSBoosterActive = true
	getgenv().Configs["FPS Booster"] = true
	pcall(function()
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local Workspace = game:GetService("Workspace")
		local Lighting = game:GetService("Lighting")

		if ReplicatedStorage2:FindFirstChild("Effect") then
			pcall(function()
				ReplicatedStorage2.Effect:Destroy()
			end)
		end

		local Terrain = Workspace.Terrain

		Terrain.WaterWaveSize = 0
		Terrain.WaterWaveSpeed = 0
		Terrain.WaterReflectance = 0
		Terrain.WaterTransparency = 0
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		Lighting.Brightness = 0
		pcall(function()
			settings().Rendering.QualityLevel = "Level01"
			settings().Rendering.GraphicsMode = "NoGraphics"
		end)

		for _, descendant in ipairs(Workspace:GetDescendants()) do
			pcall(function()
				if descendant:IsA("ParticleEmitter") then
					descendant.Lifetime = NumberRange.new(0)

					return
				end

				if descendant:IsA("Trail") then
					descendant.Lifetime = NumberRange.new(0)
				elseif descendant:IsA("Fire") or descendant:IsA("SpotLight") or descendant:IsA("Smoke") or descendant:IsA("Sparkles") then
					descendant.Enabled = false
				elseif descendant:IsA("Explosion") then
					descendant.BlastPressure = 0
					descendant.BlastRadius = 0
				elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
					descendant.Transparency = 1
				end
			end)
		end

		for _, descendant in ipairs(Lighting:GetDescendants()) do
			pcall(function()
				if descendant:IsA("BlurEffect") or descendant:IsA("SunRaysEffect") or descendant:IsA("ColorCorrectionEffect") or descendant:IsA("BloomEffect") or descendant:IsA("DepthOfFieldEffect") then
					descendant.Enabled = false
				end
			end)
		end

		pcall(function()
			local Container = ReplicatedStorage2.Effect.Container

			for _, v in ipairs({
				"Shared",
				"Misc"
			}) do
				local v65 = Container:FindFirstChild(v)

				if v65 then
					for _, v2 in ipairs({
						"AirDash",
						"LightningTP",
						"Damage",
						"Confetti"
					}) do
						if v65:FindFirstChild(v2) then
							v65[v2]:Destroy()
						end
					end
				end
			end

			if Container:FindFirstChild("LevelUp") then
				Container.LevelUp:Destroy()
			end
		end)

		if handlers[26] then
			handlers[26].Text = "Status : FPS Boost Bat!"
		end
	end)
end)

local LocalPlayer2 = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer2.PlayerGui
local ReplicatedStorage2 = game:GetService("ReplicatedStorage")

game:GetService("RunService")

local TweenService = game:GetService("TweenService")

if PlayerGui:FindFirstChild("KaitunPanel") then
	PlayerGui.KaitunPanel:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "KaitunPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local TextButton2 = Instance.new("TextButton")

TextButton2.Size = UDim2.new(0, 36, 0, 36)
TextButton2.Position = UDim2.new(1, -195, 0.5, -18)
TextButton2.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
TextButton2.Text = "â˜°"
TextButton2.Font = Enum.Font.GothamBold
TextButton2.TextSize = 18
TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.ZIndex = 10
TextButton2.Parent = ScreenGui
Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 6)

local UIStroke = Instance.new("UIStroke", TextButton2)

UIStroke.Color = Color3.fromRGB(0, 200, 80)
UIStroke.Thickness = 2

local Frame = Instance.new("Frame")

Frame.Name = "MainPanel"
Frame.Size = UDim2.new(0, 220, 0, 420)
Frame.Position = UDim2.new(1, -230, 0.5, -190)
Frame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Frame.BackgroundTransparency = 0.05
Frame.BorderSizePixel = 0
Frame.Visible = false
Frame.ZIndex = 9
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local UIStroke2 = Instance.new("UIStroke", Frame)

UIStroke2.Color = Color3.fromRGB(0, 200, 80)
UIStroke2.Thickness = 2

local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, 0, 0, 32)
TextLabel.BackgroundColor3 = Color3.fromRGB(0, 140, 60)
TextLabel.BackgroundTransparency = 0.2
TextLabel.BorderSizePixel = 0
TextLabel.Text = "âš™ Tay Hub - Kaitun"
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 14
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.ZIndex = 10
TextLabel.Parent = Frame
Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 10)

local function createFrame(p3, p4, p5, p6, p7)
	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, -16, 0, 32)
	Frame2.Position = UDim2.new(0, 8, 0, p4)
	Frame2.BackgroundTransparency = 1
	Frame2.ZIndex = 10
	Frame2.Parent = p3

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, -50, 1, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = p5
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextSize = 12
	TextLabel2.TextColor3 = Color3.fromRGB(210, 210, 210)
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.ZIndex = 10
	TextLabel2.Parent = Frame2

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(0, 40, 0, 20)
	Frame3.Position = UDim2.new(1, -44, 0.5, -10)
	Frame3.BackgroundColor3 = p6 and Color3.fromRGB(0, 180, 70) or Color3.fromRGB(60, 60, 60)
	Frame3.BorderSizePixel = 0
	Frame3.ZIndex = 10
	Frame3.Parent = Frame2
	Instance.new("UICorner", Frame3).CornerRadius = UDim.new(1, 0)

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(0, 16, 0, 16)

	local uDim2 = p6 and UDim2.new(1, -18, 0.5, -8)

	Frame4.Position = uDim2 or UDim2.new(0, 2, 0.5, -8)
	Frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame4.BorderSizePixel = 0
	Frame4.ZIndex = 11
	Frame4.Parent = Frame3
	Instance.new("UICorner", Frame4).CornerRadius = UDim.new(1, 0)

	local u84 = p6

	Frame3.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			u84 = not u84
			Frame3.BackgroundColor3 = u84 and Color3.fromRGB(0, 180, 70) or Color3.fromRGB(60, 60, 60)
			TweenService:Create(Frame4, TweenInfo.new(0.15), {
				Position = u84 and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
			}):Play()
			pcall(function()
				p7(u84)
			end)
		end
	end)

	return Frame3
end
local function createTextButton(p8, p9, p10, p11, p12)
	local TextButton3 = Instance.new("TextButton")

	TextButton3.Size = UDim2.new(1, -16, 0, 30)
	TextButton3.Position = UDim2.new(0, 8, 0, p9)
	TextButton3.BackgroundColor3 = p11 or Color3.fromRGB(0, 140, 60)
	TextButton3.Text = p10
	TextButton3.Font = Enum.Font.GothamBold
	TextButton3.TextSize = 12
	TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton3.BorderSizePixel = 0
	TextButton3.ZIndex = 10
	TextButton3.Parent = p8
	Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6)
	TextButton3.MouseButton1Click:Connect(function()
		pcall(p12)
	end)

	return TextButton3
end
local function v87(p13, p14, p15)
	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, -16, 0, 20)
	TextLabel2.Position = UDim2.new(0, 8, 0, p14)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "â€” " .. p15 .. " â€”"
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextSize = 11
	TextLabel2.TextColor3 = Color3.fromRGB(0, 200, 80)
	TextLabel2.ZIndex = 10
	TextLabel2.Parent = p13
end

v87(Frame, 36, "AUTO FARM")

local n2 = 58

createFrame(Frame, n2, "Auto Farm", getgenv().Configs and getgenv().Configs["Auto Farming"] or true, function(p16)
	pcall(function()
		if getgenv().Configs then
			getgenv().Configs["Auto Farming"] = p16
		end

		getgenv().AutoFarm = p16
	end)
end)

local v90 = n2 + 36

createFrame(Frame, v90, "Auto Quest", true, function(p17)
	pcall(function()
		if getgenv().Configs then
			getgenv().Configs["Accept Quests"] = p17
		end
	end)
end)

local v91 = v90 + 36

createFrame(Frame, v91, "Bring Mob", true, function(p18)
	pcall(function()
		if getgenv().Configs then
			getgenv().Configs["Bring Mob"] = p18
		end

		_G.BringMob = p18
	end)
end)

local v92 = v91 + 36

createFrame(Frame, v92, "Fast Attack", false, function(p19)
	pcall(function()
		if getgenv().Configs then
			getgenv().Configs["Fast Attack"] = p19
		end
	end)
end)

local v93 = v92 + 36

v87(Frame, v93, "TRAI AC QUY")

local v94 = v93 + 22
local u95 = true

createFrame(Frame, v94, "Auto Luu Trai vao Kho", true, function(p20)
	u95 = p20
end)

local v96 = v94 + 36

createFrame(Frame, v96, "Tu dong lay trai random", false, function(p21)
	pcall(function()
		if getgenv().Configs then
			getgenv().Configs["Auto Random Fruit"] = p21
		end
	end)
end)

local v97 = v96 + 36

v87(Frame, v97, "CAI DAT")

local v98 = v97 + 22

createTextButton(Frame, v98, "ðŸ’¬ Discord Ho Tro", Color3.fromRGB(40, 80, 180), function()
	pcall(function()
		game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/6udCyRdh6B")
	end)
	pcall(function()
		setclipboard("https://discord.gg/6udCyRdh6B")
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Tay Hub",
			Text = "Da copy link Discord! discord.gg/6udCyRdh6B",
			Duration = 5
		})
	end)
end)
createTextButton(Frame, v98 + 36, "ðŸš€ Bat FPS Boost", Color3.fromRGB(30, 100, 50), function()
	_G.FPSBoosterActive = true

	if getgenv().Configs then
		getgenv().Configs["FPS Booster"] = true
	end

	pcall(function()
		local Lighting = game:GetService("Lighting")

		workspace.Terrain.WaterWaveSize = 0
		workspace.Terrain.WaterWaveSpeed = 0
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9

		for _, descendant in ipairs(workspace:GetDescendants()) do
			pcall(function()
				if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
					descendant.Lifetime = NumberRange.new(0)
				elseif descendant:IsA("Fire") or descendant:IsA("Smoke") or descendant:IsA("SpotLight") or descendant:IsA("Sparkles") then
					descendant.Enabled = false
				elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
					descendant.Transparency = 1
				end
			end)
		end

		if handlers[26] then
			handlers[26].Text = "Status : FPS ON"
		end
	end)
end)

local visible = false

TextButton2.MouseButton1Click:Connect(function()
	visible = not visible
	Frame.Visible = visible
end)
task.spawn(function()
	while UIStroke2 and UIStroke2.Parent do
		local v103 = math.abs(math.sin(tick() * 2.5))

		UIStroke2.Color = Color3.fromRGB(math.floor(0 * (1 - v103) + 40 * v103), math.floor(200 * (1 - v103) + 170 * v103), math.floor(80 * (1 - v103) + 255 * v103))
		UIStroke2.Transparency = 0.05 + v103 * 0.35
		UIStroke.Color = UIStroke2.Color
		task.wait(0.04)
	end
end)
task.spawn(function()
	while task.wait(0.5) do
		if u95 then
			pcall(function()
				local Character = LocalPlayer2.Character
				local Backpack = LocalPlayer2.Backpack
				local CommF_ = ReplicatedStorage2:WaitForChild("Remotes"):WaitForChild("CommF_")

				local function v107(p22)
					for _, child in ipairs(p22:GetChildren()) do
						if child:IsA("Tool") then
							local attribute = child:GetAttribute("OriginalName") or child.Name

							if not child.Name:find("Fruit") then
								if not child.Name:find("fruit") and (not child:GetAttribute("Type") or child:GetAttribute("Type") ~= "Blox Fruit") then
									continue
								end
							end

							for i = 1, 3 do
								pcall(function()
									CommF_:InvokeServer("StoreFruit", {
										FruitName = attribute,
										Tool = child
									})
								end)
								pcall(function()
									CommF_:InvokeServer("StoreFruit", attribute)
								end)
								task.wait(0.1)
							end

							pcall(function()
								CommF_:InvokeServer("GetFruits", false)
							end)

							if handlers[26] then
								handlers[26].Text = "Status : Da luu " .. child.Name
							end
						end
					end
				end

				if Backpack then
					v107(Backpack)
				end

				if Character then
					v107(Character)
				end
			end)
		end
	end
end)
task.spawn(function()
	task.wait(1)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Tay Hub",
			Text = "Script san sang! Bam nut â˜° de mo menu.",
			Duration = 4
		})
	end)
end)

if handlers[30] == 2753915549 or handlers[30] == 85211729168715 then
	Old_World = true
elseif handlers[30] == 4442272183 or handlers[30] == 79091703265657 then
	New_World = true
elseif handlers[30] == 7449423635 or handlers[30] == 100117331123089 then
	Three_World = true
end

handlers[22] = handlers[5]:WaitForChild("Data"):WaitForChild("Level")
CheckLevel2 = function()
	local t14 = {
		[2] = game:GetService("Players").LocalPlayer.Data.Level.Value
	}

	if Old_World then
		if game.Players.LocalPlayer.Data.Level.Value == 1 or game.Players.LocalPlayer.Data.Level.Value <= 9 or SelectMonster == "" then
			Ms = "Bandit"
			NameQuest = "BanditQuest1"
			QuestLv = 1
			NameMon = "Bandit"
			CFrameQ = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, 0, -0.341998369, 0, 1, 0, 0.341998369, 0, 0.939700544)
			CFrameMon = CFrame.new(1353.44885, 3.40935516, 1376.92029, 0.776053488, -6.97791975e-08, 0.630666852, 6.99138596e-08, 1, 2.4612488e-08, -0.630666852, 2.49917598e-08, 0.776053488)
			Next_Level_X = 10
		elseif game.Players.LocalPlayer.Data.Level.Value == 10 or game.Players.LocalPlayer.Data.Level.Value <= 100 then
			Ms = "Shanda"
			NameQuest = "SkyExp1Quest"
			QuestLv = 2
			NameMon = "Shanda"
			CFrameQ = CFrame.new(-7859.09814, 5544.19043, -381.476196)
			CFrameMon = CFrame.new(-7904.57373, 5584.37646, -459.62973)
			Next_Level_X = 75
		elseif game.Players.LocalPlayer.Data.Level.Value >= 60 and game.Players.LocalPlayer.Data.Level.Value <= 74 or SelectMonster == "Desert Bandit" then
			Ms = "Desert Bandit"
			NameQuest = "DesertQuest"
			QuestLv = 1
			NameMon = "Desert Bandit"
			CFrameQ = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, 0, -0.573571265, 0, 1, 0, 0.573571265, 0, 0.819155693)
			CFrameMon = CFrame.new(932.788818, 6.8503746, 4488.24609, -0.998625934, 3.08948351e-08, 0.0524050146, 2.79967303e-08, 1, -5.60361286e-08, -0.0524050146, -5.44919629e-08, -0.998625934)
		elseif game.Players.LocalPlayer.Data.Level.Value >= 75 and game.Players.LocalPlayer.Data.Level.Value <= 89 or SelectMonster == "Desert Officer" then
			Ms = "Desert Officer"
			NameQuest = "DesertQuest"
			QuestLv = 2
			NameMon = "Desert Officer"
			CFrameQ = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, 0, -0.573571265, 0, 1, 0, 0.573571265, 0, 0.819155693)
			CFrameMon = CFrame.new(1617.07886, 1.5542295, 4295.54932, -0.997540116, -2.26287735e-08, -0.070099175, -1.69377223e-08, 1, -8.17798806e-08, 0.070099175, -8.03913949e-08, -0.997540116)
			SelectMonster = "Desert Bandit"
			Next_Level_X = 90
		elseif game.Players.LocalPlayer.Data.Level.Value >= 90 and game.Players.LocalPlayer.Data.Level.Value <= 99 or SelectMonster == "Snow Bandit" then
			Ms = "Snow Bandit"
			NameQuest = "SnowQuest"
			QuestLv = 1
			NameMon = "Snow Bandit"
			CFrameQ = CFrame.new(1389.74451, 86.6520844, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
			CFrameMon = CFrame.new(1412.92346, 55.3503647, -1260.62036, -0.246266365, -0.0169920288, -0.969053388, 0.000432241941, 0.999844253, -0.0176417865, 0.969202161, -0.00476344163, -0.246220857)

			if SelectMonster ~= "Snow Bandit" then
				Next_Level_X = 100
			end

			if game.Players.LocalPlayer.Data.Level.Value >= 110 then
				SelectBoss_P = "Yeti"
			end
		elseif game.Players.LocalPlayer.Data.Level.Value == 100 or game.Players.LocalPlayer.Data.Level.Value <= 119 or SelectMonster == "Snowman" then
			Next_Level_X = 120
			Ms = "Snowman"
			NameQuest = "SnowQuest"
			QuestLv = 2
			NameMon = "Snowman"
			CFrameQ = CFrame.new(1389.74451, 86.6520844, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
			CFrameMon = CFrame.new(1376.86401, 97.2779999, -1396.93115, -0.986755967, 7.71178321e-08, -0.162211925, 7.71531674e-08, 1, 6.08143536e-09, 0.162211925, -6.51427134e-09, -0.986755967)

			if game.Players.LocalPlayer.Data.Level.Value >= 110 then
				SelectBoss_P = "Yeti"
			end

			SelectMonster = "Snow Bandit"
		elseif game.Players.LocalPlayer.Data.Level.Value == 120 or game.Players.LocalPlayer.Data.Level.Value <= 174 or SelectMonster == "Chief Petty Officer" then
			Ms = "Chief Petty Officer"
			NameQuest = "MarineQuest2"
			QuestLv = 1
			NameMon = "Chief Petty Officer"
			CFrameQ = CFrame.new(-5039.58643, 27.3500385, 4324.68018, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			CFrameMon = CFrame.new(-4882.8623, 22.6520386, 4255.53516, 0.273695946, -5.40380647e-08, -0.96181643, 4.37720793e-08, 1, -4.37274998e-08, 0.96181643, -3.01326679e-08, 0.273695946)

			if game.Players.LocalPlayer.Data.Level.Value >= 130 then
				SelectBoss_P = "Vice Admiral"
			end

			if SelectMonster ~= "Chief Petty Officer" then
				Next_Level_X = 175
			end
		elseif SelectMonster == "Sky Bandit" then
			Ms = "Sky Bandit"
			NameQuest = "SkyQuest"
			QuestLv = 1
			NameMon = "Sky Bandit"
			CFrameQ = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
			CFrameMon = CFrame.new(-4959.51367, 365.39267, -2974.56812, 0.964867651, 7.74418396e-08, 0.262737453, -6.95931988e-08, 1, -3.91783708e-08, -0.262737453, 1.95171506e-08, 0.964867651)
		elseif game.Players.LocalPlayer.Data.Level.Value == 175 or game.Players.LocalPlayer.Data.Level.Value <= 189 or SelectMonster == "Dark Master" then
			Ms = "Dark Master"
			NameQuest = "SkyQuest"
			QuestLv = 2
			NameMon = "Dark Master"
			CFrameQ = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
			CFrameMon = CFrame.new(-5079.98096, 376.477356, -2194.17139, 0.465965867, -3.69776352e-08, 0.884802461, 3.40249851e-09, 1, 4.00000886e-08, -0.884802461, -1.56281423e-08, 0.465965867)
			SelectMonster = "Sky Bandit"

			if SelectMonster ~= "Dark Master" then
				Next_Level_X = 190
			end
		elseif game.Players.LocalPlayer.Data.Level.Value == 190 or game.Players.LocalPlayer.Data.Level.Value <= 209 or SelectMonster == "Prisoner" then
			Ms = "Prisoner"
			QuestLv = 1
			NameQuest = "PrisonerQuest"
			NameMon = "Prisoner"
			CFrameQ = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)
			CFrameMon = CFrame.new(5433.39307, 88.678093, 514.986877, 0.879988372, 0, -0.474995494, 0, 1, 0, 0.474995494, 0, 0.879988372)

			if game.Players.LocalPlayer.Data.Level.Value >= 220 then
				SelectBoss_P = "Warden"
			end

			if game.Players.LocalPlayer.Data.Level.Value >= 232 then
				SelectBoss_P = "Chief Warden"
			end

			if game.Players.LocalPlayer.Data.Level.Value >= 242 then
				SelectBoss_P = "Thunder God"
			end

			if SelectMonster ~= "Prisoner" then
				Next_Level_X = 210
			end

			Bypass_TP_Dis = true
		elseif game.Players.LocalPlayer.Data.Level.Value == 210 or game.Players.LocalPlayer.Data.Level.Value <= 249 or SelectMonster == "Dangerous Prisoner" then
			if game.Players.LocalPlayer.Data.Level.Value >= 220 then
				SelectBoss_P = "Warden"
			end

			if game.Players.LocalPlayer.Data.Level.Value >= 232 then
				SelectBoss_P = "Chief Warden"
			end

			if game.Players.LocalPlayer.Data.Level.Value >= 242 then
				SelectBoss_P = "Thunder God"
			end

			Ms = "Dangerous Prisoner"
			QuestLv = 2
			NameQuest = "PrisonerQuest"
			NameMon = "Dangerous Prisoner"
			CFrameQ = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)
			CFrameMon = CFrame.new(5433.39307, 88.678093, 514.986877, 0.879988372, 0, -0.474995494, 0, 1, 0, 0.474995494, 0, 0.879988372)
			SelectMonster = "Prisoner"
			Next_Level_X = 250
			Bypass_TP_Dis = true
		elseif game.Players.LocalPlayer.Data.Level.Value == 250 or game.Players.LocalPlayer.Data.Level.Value <= 274 or SelectMonster == "Toga Warrior" then
			Ms = "Toga Warrior"
			NameQuest = "ColosseumQuest"
			QuestLv = 1
			NameMon = "Toga Warrior"
			CFrameQ = CFrame.new(-1576.11743, 7.38933945, -2983.30762, 0.576966345, 1.22114863e-09, 0.816767931, -3.58496594e-10, 1, -1.24185606e-09, -0.816767931, 4.2370063e-10, 0.576966345)
			CFrameMon = CFrame.new(-1779.97583, 44.6077499, -2736.35474, 0.984437346, 4.10396339e-08, 0.175734788, -3.62286876e-08, 1, -3.05844168e-08, -0.175734788, 2.3741821e-08, 0.984437346)

			if SelectMonster ~= "Toga Warrior" then
				Next_Level_X = 275
			end
		elseif game.Players.LocalPlayer.Data.Level.Value == 275 or game.Players.LocalPlayer.Data.Level.Value <= 299 or SelectMonster == "Gladiator" then
			Ms = "Gladiator"
			NameQuest = "ColosseumQuest"
			QuestLv = 2
			NameMon = "Gladiator"
			CFrameQ = CFrame.new(-1576.11743, 7.38933945, -2983.30762, 0.576966345, 1.22114863e-09, 0.816767931, -3.58496594e-10, 1, -1.24185606e-09, -0.816767931, 4.2370063e-10, 0.576966345)
			CFrameMon = CFrame.new(-1274.75903, 58.1895943, -3188.16309, 0.464524001, 6.21005611e-08, 0.885560572, -4.80449414e-09, 1, -6.76054768e-08, -0.885560572, 2.71497012e-08, 0.464524001)
			SelectMonster = "Toga Warrior"
			Next_Level_X = 300
		elseif game.Players.LocalPlayer.Data.Level.Value == 300 or game.Players.LocalPlayer.Data.Level.Value <= 324 or SelectMonster == "Military Soldier" then
			if game.Players.LocalPlayer.Data.Level.Value >= 350 then
				SelectBoss_P = "Magma Admiral"
			end

			Ms = "Military Soldier"
			NameQuest = "MagmaQuest"
			QuestLv = 1
			NameMon = "Military Soldier"
			CFrameQ = CFrame.new(-5316.55859, 12.2370615, 8517.2998, 0.588437557, -1.37880001e-08, -0.808542669, -2.10116209e-08, 1, -3.23446478e-08, 0.808542669, 3.60215964e-08, 0.588437557)
			CFrameMon = CFrame.new(-5363.01123, 41.5056877, 8548.47266, -0.578253984, -3.29503091e-10, 0.815856814, 9.11209668e-08, 1, 6.498761e-08, -0.815856814, 1.11920997e-07, -0.578253984)

			if SelectMonster ~= "Military Soldier" then
				Next_Level_X = 325
			end
		elseif game.Players.LocalPlayer.Data.Level.Value == 325 or game.Players.LocalPlayer.Data.Level.Value <= 374 or SelectMonster == "Military Spy" then
			if game.Players.LocalPlayer.Data.Level.Value >= 350 then
				SelectBoss_P = "Magma Admiral"
			end

			Ms = "Military Spy"
			NameQuest = "MagmaQuest"
			QuestLv = 2
			NameMon = "Military Spy"
			CFrameQ = CFrame.new(-5316.55859, 12.2370615, 8517.2998, 0.588437557, -1.37880001e-08, -0.808542669, -2.10116209e-08, 1, -3.23446478e-08, 0.808542669, 3.60215964e-08, 0.588437557)
			CFrameMon = CFrame.new(-5787.99023, 120.864456, 8762.25293, -0.188358366, -1.84706277e-08, 0.982100308, -1.23782129e-07, 1, -4.93306951e-09, -0.982100308, -1.22495649e-07, -0.188358366)
			SelectMonster = "Military Soldier"
			Next_Level_X = 375
		elseif game.Players.LocalPlayer.Data.Level.Value == 375 or game.Players.LocalPlayer.Data.Level.Value <= 399 or SelectMonster == "Fishman Warrior" then
			if game.Players.LocalPlayer.Data.Level.Value >= 425 then
				SelectBoss_P = "Fishman Lord"
			end

			Ms = "Fishman Warrior"
			NameQuest = "FishmanQuest"
			QuestLv = 1
			NameMon = "Fishman Warrior"
			CFrameQ = CFrame.new(61122.5625, 18.4716396, 1568.16504)
			CFrameMon = CFrame.new(60946.6094, 48.6735229, 1525.91687, -0.0817126185, 8.90751153e-08, 0.996655822, 2.00889794e-08, 1, -8.77269599e-08, -0.996655822, 1.28533992e-08, -0.0817126185)

			if SelectMonster ~= "Fishman Warrior" then
				Next_Level_X = 400
			end
		elseif game.Players.LocalPlayer.Data.Level.Value == 400 or game.Players.LocalPlayer.Data.Level.Value <= 449 or SelectMonster == "Fishman Commando" then
			if game.Players.LocalPlayer.Data.Level.Value >= 425 then
				SelectBoss_P = "Fishman Lord"
			end

			Ms = "Fishman Commando"
			NameQuest = "FishmanQuest"
			QuestLv = 2
			NameMon = "Fishman Commando"
			CFrameQ = CFrame.new(61122.5625, 18.4716396, 1568.16504)
			CFrameMon = CFrame.new(61902.7383, 18.4828358, 1478.33936, -0.803795099, 0, -0.594906271, 0, 1, 0, 0.594906271, 0, -0.803795099)

			if SelectMonster ~= "Fishman Commando" then
				Next_Level_X = 450
			end

			SelectMonster = "Fishman Warrior"
		elseif game.Players.LocalPlayer.Data.Level.Value == 450 or game.Players.LocalPlayer.Data.Level.Value <= 474 or SelectMonster == "God's Guard" then
			Ms = "God's Guard"
			NameQuest = "SkyExp1Quest"
			QuestLv = 1
			NameMon = "God's Guards"
			CFrameQ = CFrame.new(-4721.71436, 845.277161, -1954.20105)
			CFrameMon = CFrame.new(-4716.95703, 853.089722, -1933.925427)

			if SelectMonster ~= "God's Guard" then
				Next_Level_X = 475
			end

			SelectMonster = "Fishman Commando"
		elseif game.Players.LocalPlayer.Data.Level.Value == 475 or game.Players.LocalPlayer.Data.Level.Value <= 524 or SelectMonster == "Shanda" then
			Ms = "Shanda"
			NameQuest = "SkyExp1Quest"
			QuestLv = 2
			NameMon = "Shandas"
			CFrameQ = CFrame.new(-7859.09814, 5544.19043, -381.476196)
			CFrameMon = CFrame.new(-7904.57373, 5584.37646, -459.62973)

			if game.Players.LocalPlayer.Data.Level.Value >= 500 then
				SelectBoss_P = "Wysper"
			end

			if SelectMonster ~= "Shanda" then
				Next_Level_X = 525
			end

			SelectMonster = "God's Guard"
		elseif game.Players.LocalPlayer.Data.Level.Value == 525 or game.Players.LocalPlayer.Data.Level.Value <= 549 or SelectMonster == "Royal Squad" then
			Ms = "Royal Squad"
			NameQuest = "SkyExp2Quest"
			QuestLv = 1
			NameMon = "Royal Squad"
			CFrameQ = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			CFrameMon = CFrame.new(-7555.04199, 5606.90479, -1303.24744, -0.896107852, -9.6057462e-10, -0.443836004, -4.24974544e-09, 1, 6.41599973e-09, 0.443836004, 7.63560326e-09, -0.896107852)

			if SelectMonster ~= "Royal Squad" then
				Next_Level_X = 550
			end

			SelectMonster = "Shanda"
		elseif game.Players.LocalPlayer.Data.Level.Value == 550 or game.Players.LocalPlayer.Data.Level.Value <= 624 then
			if game.Players.LocalPlayer.Data.Level.Value >= 575 then
				SelectBoss_P = "Thunder God"
			end

			Ms = "Royal Soldier"
			NameQuest = "SkyExp2Quest"
			QuestLv = 2
			NameMon = "Royal Soldier"
			CFrameQ = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			CFrameMon = CFrame.new(-7837.31152, 5649.65186, -1791.08582, -0.716008604, 0.0104285581, -0.698013008, 5.02521061e-06, 0.99988848, 0.0149335321, 0.69809103, 0.0106890313, -0.715928733)

			if SelectMonster ~= "Royal Soldier" then
				Next_Level_X = 625
			end

			SelectMonster = "Royal Squad"
		elseif SelectMonster == "Royal Soldier" then
			if game.Players.LocalPlayer.Data.Level.Value >= 575 then
				SelectBoss_P = "Thunder God"
			end

			Ms = "Royal Soldier"
			NameQuest = "SkyExp2Quest"
			QuestLv = 2
			NameMon = "Royal Soldier"
			CFrameQ = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			CFrameMon = CFrame.new(-7837.31152, 5649.65186, -1791.08582, -0.716008604, 0.0104285581, -0.698013008, 5.02521061e-06, 0.99988848, 0.0149335321, 0.69809103, 0.0106890313, -0.715928733)

			if SelectMonster ~= "Royal Soldier" then
				Next_Level_X = 625
			end

			SelectMonster = "Royal Squad"
		elseif game.Players.LocalPlayer.Data.Level.Value == 625 or game.Players.LocalPlayer.Data.Level.Value <= 649 or SelectMonster == "Galley Pirate" then
			Ms = "Galley Pirate"
			NameQuest = "FountainQuest"
			QuestLv = 1
			NameMon = "Galley Pirate"
			CFrameQ = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
			CFrameMon = CFrame.new(5569.80518, 38.5269432, 3849.01196, 0.896460414, 3.98027495e-08, 0.443124533, -1.34262139e-08, 1, -6.26611296e-08, -0.443124533, 5.02237434e-08, 0.896460414)

			if SelectMonster ~= "Galley Pirate" then
				Next_Level_X = 650
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 650 or SelectMonster == "Galley Captain" then
			if game.Players.LocalPlayer.Data.Level.Value >= 675 then
				SelectBoss_P = "Cyborg"
			end

			Ms = "Galley Captain"
			NameQuest = "FountainQuest"
			QuestLv = 2
			NameMon = "Galley Captain"
			CFrameQ = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
			CFrameMon = CFrame.new(5782.90186, 94.5326462, 4716.78174, 0.361808896, -1.24757526e-06, -0.932252586, 2.16989656e-06, 1, -4.96097414e-07, 0.932252586, -1.84339774e-06, 0.361808896)
			SelectMonster = "Galley Pirate"
			Next_Level_X = 9999
		end
	end

	if New_World then
		if game.Players.LocalPlayer.Data.Level.Value == 700 or game.Players.LocalPlayer.Data.Level.Value <= 724 or SelectMonster == "Raider" then
			Ms = "Raider"
			NameQuest = "Area1Quest"
			QuestLv = 1
			NameMon = "Raider"
			CFrameQ = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
			CFrameMon = CFrame.new(-737.026123, 10.1748352, 2392.57959, 0.272128761, 0, -0.962260842, 0, 1, 0, 0.962260842, 0, 0.272128761)

			if SelectMonster ~= "Raider" then
				Next_Level_X = 725
			end
		elseif game.Players.LocalPlayer.Data.Level.Value == 725 or game.Players.LocalPlayer.Data.Level.Value <= 774 or SelectMonster == "Mercenary" then
			if game.Players.LocalPlayer.Data.Level.Value >= 750 then
				SelectBoss_P = "Diamond"
			end

			Ms = "Mercenary"
			NameQuest = "Area1Quest"
			QuestLv = 2
			NameMon = "Mercenary"
			CFrameQ = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
			CFrameMon = CFrame.new(-1022.21271, 72.9855194, 1891.39148, -0.990782857, 0, -0.135460541, 0, 1, 0, 0.135460541, 0, -0.990782857)

			if SelectMonster ~= "Mercenary" then
				Next_Level_X = 775
			end

			SelectMonster = "Raider"
		elseif game.Players.LocalPlayer.Data.Level.Value == 775 or game.Players.LocalPlayer.Data.Level.Value <= 799 or SelectMonster == "Swan Pirate" then
			Ms = "Swan Pirate"
			NameQuest = "Area2Quest"
			QuestLv = 1
			NameMon = "Swan Pirate"
			CFrameQ = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0, -0.99026376, 0, 0.139203906)
			CFrameMon = CFrame.new(976.467651, 111.174057, 1229.1084, 0.00852567982, -4.73897828e-08, -0.999963999, 1.12251888e-08, 1, -4.7295778e-08, 0.999963999, -1.08215579e-08, 0.00852567982)

			if SelectMonster ~= "Swan Pirate" then
				Next_Level_X = 800
			end
		elseif game.Players.LocalPlayer.Data.Level.Value == 800 or game.Players.LocalPlayer.Data.Level.Value <= 874 or SelectMonster == "Factory Staff" then
			Ms = "Factory Staff"
			NameQuest = "Area2Quest"
			QuestLv = 2
			NameMon = "Factory Staff"
			CFrameQ = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0, -0.99026376, 0, 0.139203906)
			CFrameMon = CFrame.new(336.74585, 73.1620483, -224.129272, 0.993632793, 3.40154607e-08, 0.112668738, -3.87658332e-08, 1, 3.99718729e-08, -0.112668738, -4.40850592e-08, 0.993632793)

			if SelectMonster ~= "Factory Staff" then
				Next_Level_X = 875
			end

			if game.Players.LocalPlayer.Data.Level.Value >= 850 then
				SelectBoss_P = "Jeremy"
			end

			SelectMonster = "Swan Pirate"
		elseif game.Players.LocalPlayer.Data.Level.Value == 875 or game.Players.LocalPlayer.Data.Level.Value <= 899 or SelectMonster == "Marine Lieutenant" then
			Ms = "Marine Lieutenant"
			NameQuest = "MarineQuest3"
			QuestLv = 1
			NameMon = "Marine Lieutenant"
			CFrameQ = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
			CFrameMon = CFrame.new(-2842.69922, 72.9919434, -2901.90479, -0.762281299, 0, -0.64724648, 0, 1.00000012, 0, 0.64724648, 0, -0.762281299)

			if SelectMonster ~= "Marine Lieutenant" then
				Next_Level_X = 900
			end
		elseif game.Players.LocalPlayer.Data.Level.Value == 900 or game.Players.LocalPlayer.Data.Level.Value <= 949 or SelectMonster == "Marine Captain" then
			Ms = "Marine Captain"
			NameQuest = "MarineQuest3"
			QuestLv = 2
			NameMon = "Marine Captain"
			CFrameQ = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
			CFrameMon = CFrame.new(-1814.70313, 72.9919434, -3208.86621, -0.900422215, 7.93464423e-08, -0.435017526, 3.68856199e-08, 1, 1.06050372e-07, 0.435017526, 7.94441988e-08, -0.900422215)

			if game.Players.LocalPlayer.Data.Level.Value >= 925 then
				SelectBoss_P = "Fajita"
			end

			if SelectMonster ~= "Marine Captain" then
				Next_Level_X = 950
			end

			SelectMonster = "Marine Lieutenant"
		elseif game.Players.LocalPlayer.Data.Level.Value == 950 or game.Players.LocalPlayer.Data.Level.Value <= 974 or SelectMonster == "Zombie" then
			Ms = "Zombie"
			NameQuest = "ZombieQuest"
			QuestLv = 1
			NameMon = "Zombie"
			CFrameQ = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
			CFrameMon = CFrame.new(-5649.23438, 126.0578, -737.773743, 0.355238914, -8.10359282e-08, 0.934775114, 1.65461245e-08, 1, 8.04023372e-08, -0.934775114, -1.3095117e-08, 0.355238914)

			if SelectMonster ~= "Zombie" then
				Next_Level_X = 975
			end

			Bypass_TP_Dis = true
		elseif game.Players.LocalPlayer.Data.Level.Value == 975 or game.Players.LocalPlayer.Data.Level.Value <= 999 or SelectMonster == "Vampire" then
			Ms = "Vampire"
			NameQuest = "ZombieQuest"
			QuestLv = 2
			NameMon = "Vampire"
			CFrameQ = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
			CFrameMon = CFrame.new(-6030.32031, 0.4377408, -1313.5564, -0.856965423, 3.9138893e-08, -0.515373945, -1.12178942e-08, 1, 9.45958547e-08, 0.515373945, 8.68467822e-08, -0.856965423)

			if SelectMonster ~= "Vampire" then
				Next_Level_X = 1000
			end

			Bypass_TP_Dis = true
			SelectMonster = "Zombie"
		elseif game.Players.LocalPlayer.Data.Level.Value == 1000 or game.Players.LocalPlayer.Data.Level.Value <= 1049 or SelectMonster == "Snow Trooper" then
			Ms = "Snow Trooper"
			NameQuest = "SnowMountainQuest"
			QuestLv = 1
			NameMon = "Snow Trooper"
			CFrameQ = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
			CFrameMon = CFrame.new(621.003418, 391.361053, -5335.43604, 0.481644779, 0, 0.876366913, 0, 1, 0, -0.876366913, 0, 0.481644779)

			if SelectMonster ~= "Snow Trooper" then
				Next_Level_X = 1050
			end
		elseif game.Players.LocalPlayer.Data.Level.Value == 1050 or game.Players.LocalPlayer.Data.Level.Value <= 1099 or SelectMonster == "Winter Warrior" then
			Ms = "Winter Warrior"
			NameQuest = "SnowMountainQuest"
			QuestLv = 2
			NameMon = "Winter Warrior"
			CFrameQ = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
			CFrameMon = CFrame.new(1295.62683, 429.447784, -5087.04492, -0.698032081, -8.28980049e-08, -0.71606636, -1.98835952e-08, 1, -9.63858184e-08, 0.71606636, -5.30424877e-08, -0.698032081)

			if SelectMonster ~= "Winter Warrior" then
				Next_Level_X = 1100
			end

			SelectMonster = "Snow Trooper"
		elseif game.Players.LocalPlayer.Data.Level.Value == 1100 or game.Players.LocalPlayer.Data.Level.Value <= 1124 or SelectMonster == "Lab Subordinate" then
			Ms = "Lab Subordinate"
			NameQuest = "IceSideQuest"
			QuestLv = 1
			NameMon = "Lab Subordinate"
			CFrameQ = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, 0, -0.891015649, 0, 1, 0, 0.891015649, 0, 0.453972578)
			CFrameMon = CFrame.new(-5769.2041, 37.9288292, -4468.38721, -0.569419742, -2.49055017e-08, 0.822046936, -6.96206541e-08, 1, -1.79282633e-08, -0.822046936, -6.74401548e-08, -0.569419742)

			if SelectMonster ~= "Lab Subordinate" then
				Next_Level_X = 1125
			end
		elseif game.Players.LocalPlayer.Data.Level.Value == 1125 or game.Players.LocalPlayer.Data.Level.Value <= 1174 or SelectMonster == "Horned Warrior" then
			if game.Players.LocalPlayer.Data.Level.Value >= 1150 then
				SelectBoss_P = "Smoke Admiral"
			end

			Ms = "Horned Warrior"
			NameQuest = "IceSideQuest"
			QuestLv = 2
			NameMon = "Horned Warrior"
			CFrameQ = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, 0, -0.891015649, 0, 1, 0, 0.891015649, 0, 0.453972578)
			CFrameMon = CFrame.new(-6401.27979, 15.9775667, -5948.24316, 0.388303697, 0, -0.921531856, 0, 1, 0, 0.921531856, 0, 0.388303697)

			if SelectMonster ~= "Horned Warrior" then
				Next_Level_X = 1175
			end

			SelectMonster = "Lab Subordinate"
		elseif game.Players.LocalPlayer.Data.Level.Value == 1175 or game.Players.LocalPlayer.Data.Level.Value <= 1199 or SelectMonster == "Magma Ninja" then
			Ms = "Magma Ninja"
			NameQuest = "FireSideQuest"
			QuestLv = 1
			NameMon = "Magma Ninja"
			CFrameQ = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
			CFrameMon = CFrame.new(-5466.06445, 57.6952019, -5837.42822, -0.988835871, 0, -0.149006829, 0, 1, 0, 0.149006829, 0, -0.988835871)

			if SelectMonster ~= "Magma Ninja" then
				Next_Level_X = 1200
			end
		elseif game.Players.LocalPlayer.Data.Level.Value == 1200 or game.Players.LocalPlayer.Data.Level.Value <= 1249 or SelectMonster == "Lava Pirate" then
			Ms = "Lava Pirate"
			NameQuest = "FireSideQuest"
			QuestLv = 2
			NameMon = "Lava Pirate"
			CFrameQ = CFrame.new(-5431.09473, 15.9868021, -5296.53223, 0.831796765, 1.15322464e-07, -0.555080295, -1.10814341e-07, 1, 4.17010995e-08, 0.555080295, 2.68240168e-08, 0.831796765)
			CFrameMon = CFrame.new(-5169.71729, 34.1234779, -4669.73633, -0.196780294, 0, 0.98044765, 0, 1.00000012, 0, -0.98044765, 0, -0.196780294)

			if SelectMonster ~= "Lava Pirate" then
				Next_Level_X = 1250
			end

			SelectMonster = "Magma Ninja"
		elseif game.Players.LocalPlayer.Data.Level.Value == 1250 or game.Players.LocalPlayer.Data.Level.Value <= 1274 or SelectMonster == "Ship Deckhand" then
			Ms = "Ship Deckhand"
			NameQuest = "ShipQuest1"
			QuestLv = 1
			NameMon = "Ship Deckhand"
			CFrameQ = CFrame.new(1037.80127, 125.092171, 32911.6016, -0.244533166, 0, -0.969640911, 0, 1.00000012, 0, 0.96964103, 0, -0.244533136)
			CFrameMon = CFrame.new(1163.80872, 138.288452, 33058.4258, -0.998580813, 5.49076979e-08, -0.0532564968, 5.57436763e-08, 1, -1.42118655e-08, 0.0532564968, -1.71604082e-08, -0.998580813)

			if SelectMonster ~= "Ship Deckhand" then
				Next_Level_X = 1275
			end
		elseif game.Players.LocalPlayer.Data.Level.Value == 1275 or game.Players.LocalPlayer.Data.Level.Value <= 1299 or SelectMonster == "Ship Engineer" then
			Ms = "Ship Engineer"
			NameQuest = "ShipQuest1"
			QuestLv = 2
			NameMon = "Ship Engineer"
			CFrameQ = CFrame.new(1037.80127, 125.092171, 32911.6016, -0.244533166, 0, -0.969640911, 0, 1.00000012, 0, 0.96964103, 0, -0.244533136)
			CFrameMon = CFrame.new(921.30249023438, 125.400390625, 32937.34375)

			if SelectMonster ~= "Ship Engineer" then
				Next_Level_X = 1300
			end

			SelectMonster = "Ship Deckhand"
		elseif game.Players.LocalPlayer.Data.Level.Value == 1300 or game.Players.LocalPlayer.Data.Level.Value <= 1324 or SelectMonster == "Ship Steward" then
			Ms = "Ship Steward"
			NameQuest = "ShipQuest2"
			QuestLv = 1
			NameMon = "Ship Steward"
			CFrameQ = CFrame.new(968.80957, 125.092171, 33244.125, -0.869560242, 1.51905191e-08, -0.493826836, 1.44108379e-08, 1, 5.38534195e-09, 0.493826836, -2.43357912e-09, -0.869560242)
			CFrameMon = CFrame.new(917.96057128906, 136.89932250977, 33343.4140625)

			if SelectMonster ~= "Ship Steward" then
				Next_Level_X = 1325
			end

			SelectMonster = "Ship Deckhand"
		elseif game.Players.LocalPlayer.Data.Level.Value == 1325 or game.Players.LocalPlayer.Data.Level.Value <= 1349 or SelectMonster == "Ship Officer" then
			Ms = "Ship Officer"
			NameQuest = "ShipQuest2"
			QuestLv = 2
			NameMon = "Ship Officer"
			CFrameQ = CFrame.new(968.80957, 125.092171, 33244.125, -0.869560242, 1.51905191e-08, -0.493826836, 1.44108379e-08, 1, 5.38534195e-09, 0.493826836, -2.43357912e-09, -0.869560242)
			CFrameMon = CFrame.new(944.44964599609, 181.40081787109, 33278.9453125)

			if SelectMonster ~= "Ship Officer" then
				Next_Level_X = 1350
			end

			SelectMonster = "Ship Steward"
		elseif game.Players.LocalPlayer.Data.Level.Value == 1350 or game.Players.LocalPlayer.Data.Level.Value <= 1374 or SelectMonster == "Arctic Warrior" then
			Ms = "Arctic Warrior"
			NameQuest = "FrostQuest"
			QuestLv = 1
			NameMon = "Arctic Warrior"
			CFrameQ = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
			CFrameMon = CFrame.new(5878.23486, 81.3886948, -6136.35596, -0.451037169, 2.3908234e-07, 0.892505825, -1.08168464e-07, 1, -3.22542007e-07, -0.892505825, -2.4201924e-07, -0.451037169)

			if SelectMonster ~= "Arctic Warrior" then
				Next_Level_X = 1375
			end
		elseif game.Players.LocalPlayer.Data.Level.Value == 1375 or game.Players.LocalPlayer.Data.Level.Value <= 1424 or SelectMonster == "Snow Lurker" then
			if game.Players.LocalPlayer.Data.Level.Value >= 1400 then
				SelectBoss_P = "Awakened Ice Admiral"
			end

			Ms = "Snow Lurker"
			NameQuest = "FrostQuest"
			QuestLv = 2
			NameMon = "Snow Lurker"
			CFrameQ = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
			CFrameMon = CFrame.new(5513.36865, 60.546711, -6809.94971, -0.958693981, -1.65617333e-08, 0.284439981, -4.07668654e-09, 1, 4.44854642e-08, -0.284439981, 4.14883701e-08, -0.958693981)

			if SelectMonster ~= "Snow Lurker" then
				Next_Level_X = 1450
			end

			SelectMonster = "Arctic Warrior"
		elseif game.Players.LocalPlayer.Data.Level.Value == 1425 or game.Players.LocalPlayer.Data.Level.Value <= 1449 or SelectMonster == "Sea Soldier" then
			Ms = "Sea Soldier"
			NameQuest = "ForgottenQuest"
			QuestLv = 1
			NameMon = "Sea Soldier"
			CFrameQ = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, 0, -0.13915664, 0, 1, 0, 0.13915664, 0, 0.990270376)
			CFrameMon = CFrame.new(-3115.78223, 63.8785706, -9808.38574, -0.913427353, 3.11199457e-08, 0.407000452, 7.79564235e-09, 1, -5.89660658e-08, -0.407000452, -5.06883708e-08, -0.913427353)

			if SelectMonster ~= "Sea Soldier" then
				Next_Level_X = 1450
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 1450 or SelectMonster == "Water Fighter" then
			if game.Players.LocalPlayer.Data.Level.Value >= 1475 then
				SelectBoss_P = "Tide Keeper"
			end

			Ms = "Water Fighter"
			NameQuest = "ForgottenQuest"
			QuestLv = 2
			NameMon = "Water Fighter"
			CFrameQ = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, 0, -0.13915664, 0, 1, 0, 0.13915664, 0, 0.990270376)
			CFrameMon = CFrame.new(-3212.99683, 263.809296, -10551.8799, 0.742111444, -5.59139615e-08, -0.670276582, 1.69155214e-08, 1, -6.46908234e-08, 0.670276582, 3.66697037e-08, 0.742111444)

			if SelectMonster ~= "Water Fighter" then
				Next_Level_X = 9999
			end

			SelectMonster = "Sea Soldier"
		end
	end

	if Three_World then
		if game.Players.LocalPlayer.Data.Level.Value >= 1500 and game.Players.LocalPlayer.Data.Level.Value <= 1524 or SelectMonster == "Pirate Millionaire" then
			Ms = "Pirate Millionaire"
			NameQuest = "PiratePortQuest"
			QuestLv = 1
			NameMon = "Pirate Millionaire"
			CFrameQ = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, 0.965929627)
			CFrameMon = CFrame.new(81.164993286133, 43.755737304688, 5724.7021484375)

			if SelectMonster ~= "Pirate Millionaire" then
				Next_Level_X = 1525
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 1525 and game.Players.LocalPlayer.Data.Level.Value <= 1574 or SelectMonster == "Pistol Billionaire" then
			if game.Players.LocalPlayer.Data.Level.Value >= 1550 then
				SelectBoss_P = "Stone"
			end

			Ms = "Pistol Billionaire"
			NameQuest = "PiratePortQuest"
			QuestLv = 2
			NameMon = "Pistol Billionaire"
			CFrameQ = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, 0.965929627)
			CFrameMon = CFrame.new(81.164993286133, 43.755737304688, 5724.7021484375)

			if SelectMonster ~= "Pistol Billionaire" then
				Next_Level_X = 1575
			end

			SelectMonster = "Pirate Millionaire"
		elseif game.Players.LocalPlayer.Data.Level.Value >= 1575 and game.Players.LocalPlayer.Data.Level.Value <= 1599 or SelectMonster == "Dragon Crew Warrior" then
			Ms = "Dragon Crew Warrior"
			NameQuest = "AmazonQuest"
			QuestLv = 1
			NameMon = "Dragon Crew Warrior"
			CFrameQ = CFrame.new(5832.83594, 51.6806107, -1101.51563, 0.898790359, 0, -0.438378751, 0, 1, 0, 0.438378751, 0, 0.898790359)
			CFrameMon = CFrame.new(6241.9951171875, 51.522083282471, -1243.9771728516)

			if SelectMonster ~= "Dragon Crew Warrior" then
				Next_Level_X = 1600
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 1600 and game.Players.LocalPlayer.Data.Level.Value <= 1624 or SelectMonster == "Dragon Crew Archer" then
			Ms = "Dragon Crew Archer"
			NameQuest = "AmazonQuest"
			QuestLv = 2
			NameMon = "Dragon Crew Archer"
			CFrameQ = CFrame.new(5832.83594, 51.6806107, -1101.51563, 0.898790359, 0, -0.438378751, 0, 1, 0, 0.438378751, 0, 0.898790359)
			CFrameMon = CFrame.new(6488.9155273438, 383.38375854492, -110.66246032715)

			if SelectMonster ~= "Dragon Crew Archer" then
				Next_Level_X = 1625
			end

			SelectMonster = "Dragon Crew Warrior"
		elseif game.Players.LocalPlayer.Data.Level.Value >= 1625 and game.Players.LocalPlayer.Data.Level.Value <= 1649 or SelectMonster == "Female Islander" then
			Ms = "Female Islander"
			NameQuest = "AmazonQuest2"
			QuestLv = 1
			NameMon = "Female Islander"
			CFrameQ = CFrame.new(5448.86133, 601.516174, 751.130676, 0, 0, 1, 0, 1, 0, -1, 0, 0)
			CFrameMon = CFrame.new(4770.4990234375, 758.95520019531, 1069.8680419922)

			if SelectMonster ~= "Female Islander" then
				Next_Level_X = 1650
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 1650 and game.Players.LocalPlayer.Data.Level.Value <= 1699 or SelectMonster == "Giant Islander" then
			Ms = "Giant Islander"
			NameQuest = "AmazonQuest2"
			QuestLv = 2
			NameMon = "Giant Islander"
			CFrameQ = CFrame.new(5448.86133, 601.516174, 751.130676, 0, 0, 1, 0, 1, 0, -1, 0, 0)
			CFrameMon = CFrame.new(4530.3540039063, 656.75695800781, -131.60952758789)

			if game.Players.LocalPlayer.Data.Level.Value >= 1675 then
				SelectBoss_P = "Island Empress"
			end

			if SelectMonster ~= "Giant Islander" then
				Next_Level_X = 1700
			end

			SelectMonster = "Female Islander"
		elseif game.Players.LocalPlayer.Data.Level.Value >= 1700 and game.Players.LocalPlayer.Data.Level.Value <= 1774 or SelectMonster == "Marine Commodore" then
			Ms = "Marine Commodore"
			NameQuest = "MarineTreeIsland"
			QuestLv = 1
			NameMon = "Marine Commodore"
			CFrameQ = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747)
			CFrameMon = CFrame.new(2490.0844726563, 190.4232635498, -7160.0502929688)

			if game.Players.LocalPlayer.Data.Level.Value >= 1750 then
				SelectBoss_P = "Kilo Admiral"
			end

			if SelectMonster ~= "Marine Commodore" then
				Next_Level_X = 1775
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 1775 and game.Players.LocalPlayer.Data.Level.Value <= 1799 or SelectMonster == "Fishman Raider" then
			Ms = "Fishman Raider"
			NameQuest = "DeepForestIsland3"
			QuestLv = 1
			NameMon = "Fishman Raider"
			CFrameQ = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
			CFrameMon = CFrame.new(-10322.400390625, 390.94473266602, -8580.0908203125)

			if SelectMonster ~= "Fishman Raider" then
				Next_Level_X = 1800
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 1800 and game.Players.LocalPlayer.Data.Level.Value <= 1824 or SelectMonster == "Fishman Captain" then
			Ms = "Fishman Captain"
			NameQuest = "DeepForestIsland3"
			QuestLv = 2
			NameMon = "Fishman Captain"
			CFrameQ = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
			CFrameMon = CFrame.new(-11194.541992188, 442.02795410156, -8608.806640625)

			if SelectMonster ~= "Fishman Captain" then
				Next_Level_X = 1825
			end

			SelectMonster = "Fishman Raider"
		elseif game.Players.LocalPlayer.Data.Level.Value >= 1825 and game.Players.LocalPlayer.Data.Level.Value <= 1849 or SelectMonster == "Forest Pirate" then
			Ms = "Forest Pirate"
			NameQuest = "DeepForestIsland"
			QuestLv = 1
			NameMon = "Forest Pirate"
			CFrameQ = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, 0, -0.707079291, 0, 1, 0, 0.707079291, 0, 0.707134247)
			CFrameMon = CFrame.new(-13225.809570313, 428.19387817383, -7753.1245117188)

			if SelectMonster ~= "Forest Pirate" then
				Next_Level_X = 1850
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 1850 and game.Players.LocalPlayer.Data.Level.Value <= 1899 or SelectMonster == "Mythological Pirate" then
			Ms = "Mythological Pirate"
			NameQuest = "DeepForestIsland"
			QuestLv = 2
			NameMon = "Mythological Pirate"
			CFrameQ = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, 0, -0.707079291, 0, 1, 0, 0.707079291, 0, 0.707134247)
			CFrameMon = CFrame.new(-13869.172851563, 564.95251464844, -7084.4135742188)

			if game.Players.LocalPlayer.Data.Level.Value >= 1875 then
				SelectBoss_P = "Captain Elephant"
			end

			if SelectMonster ~= "Mythological Pirate" then
				Next_Level_X = 1900
			end

			SelectMonster = "Forest Pirate"
		elseif game.Players.LocalPlayer.Data.Level.Value >= 1900 and game.Players.LocalPlayer.Data.Level.Value <= 1924 or SelectMonster == "Jungle Pirate" then
			Ms = "Jungle Pirate"
			NameQuest = "DeepForestIsland2"
			QuestLv = 1
			NameMon = "Jungle Pirate"
			CFrameQ = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
			CFrameMon = CFrame.new(-11982.221679688, 376.32522583008, -10451.415039063)

			if SelectMonster ~= "Jungle Pirate" then
				Next_Level_X = 1925
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 1925 and game.Players.LocalPlayer.Data.Level.Value <= 1974 or SelectMonster == "Musketeer Pirate" then
			Ms = "Musketeer Pirate"
			NameQuest = "DeepForestIsland2"
			QuestLv = 2
			NameMon = "Musketeer Pirate"
			CFrameQ = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
			CFrameMon = CFrame.new(-13282.3046875, 496.23684692383, -9565.150390625)

			if SelectMonster ~= "Musketeer Pirate" then
				Next_Level_X = 1975
			end

			if game.Players.LocalPlayer.Data.Level.Value >= 1950 then
				SelectBoss_P = "Beautiful Pirate"
			end

			SelectMonster = "Jungle Pirate"
		elseif game.Players.LocalPlayer.Data.Level.Value >= 1975 and game.Players.LocalPlayer.Data.Level.Value <= 1999 or SelectMonster == "Reborn Skeleton" then
			Ms = "Reborn Skeleton"
			NameQuest = "HauntedQuest1"
			QuestLv = 1
			NameMon = "Reborn Skeleton"
			CFrameQ = CFrame.new(-9480.8271484375, 142.13066101074, 5566.0712890625)
			CFrameMon = CFrame.new(-8817.880859375, 191.16761779785, 6298.6557617188)

			if not (SelectMonster == "Reborn Skeleton" or LevelMax) then
				Next_Level_X = 2000
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2000 and game.Players.LocalPlayer.Data.Level.Value <= 2024 or SelectMonster == "Living Zombie" then
			Ms = "Living Zombie"
			NameQuest = "HauntedQuest1"
			QuestLv = 2
			NameMon = "Living Zombie"
			CFrameQ = CFrame.new(-9480.8271484375, 142.13066101074, 5566.0712890625)
			CFrameMon = CFrame.new(-10125.234375, 183.94705200195, 6242.013671875)

			if not (SelectMonster == "Living Zombie" or LevelMax) then
				Next_Level_X = 2025
			end

			SelectMonster = "Reborn Skeleton"
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2025 and game.Players.LocalPlayer.Data.Level.Value <= 2049 or SelectMonster == "Demonic Soul" then
			Ms = "Demonic Soul"
			NameQuest = "HauntedQuest2"
			QuestLv = 1
			NameMon = "Demonic"
			CFrameQ = CFrame.new(-9516.9931640625, 178.00651550293, 6078.4653320313)
			CFrameMon = CFrame.new(-9712.03125, 204.69589233398, 6193.322265625)

			if SelectMonster ~= "Demonic Soul" then
				Next_Level_X = 2050
			end

			SelectMonster = "Living Zombie"
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2050 and game.Players.LocalPlayer.Data.Level.Value <= 2074 or SelectMonster == "Posessed Mummy" then
			Ms = "Posessed Mummy"
			NameQuest = "HauntedQuest2"
			QuestLv = 2
			NameMon = "Posessed Mummy"
			CFrameQ = CFrame.new(-9516.9931640625, 178.00651550293, 6078.4653320313)
			CFrameMon = CFrame.new(-9545.7763671875, 69.619895935059, 6339.5615234375)

			if SelectMonster ~= "Posessed Mummy" then
				Next_Level_X = 2075
			end

			SelectMonster = "Demonic Soul"
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2075 and game.Players.LocalPlayer.Data.Level.Value <= 2099 or SelectMonster == "Peanut Scout" then
			Ms = "Peanut Scout"
			NameQuest = "NutsIslandQuest"
			QuestLv = 1
			NameMon = "Peanut Scout"
			CFrameQ = CFrame.new(-2104.17163, 38.1299706, -10194.418, 0.758814394, -1.38604395e-09, 0.651306927, 2.85280208e-08, 1, -3.1108879e-08, -0.651306927, 4.21863646e-08, 0.758814394)
			CFrameMon = CFrame.new(-2098.07544, 192.611862, -10248.8867, 0.983392298, -9.57031787e-08, 0.181492642, 8.7276355e-08, 1, 5.44169616e-08, -0.181492642, -3.76732068e-08, 0.983392298)

			if SelectMonster ~= "Peanut Scout" then
				Next_Level_X = 2100
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2100 and game.Players.LocalPlayer.Data.Level.Value <= 2124 or SelectMonster == "Peanut President" then
			Ms = "Peanut President"
			NameQuest = "NutsIslandQuest"
			QuestLv = 2
			NameMon = "Peanut President"
			CFrameQ = CFrame.new(-2104.17163, 38.1299706, -10194.418, 0.758814394, -1.38604395e-09, 0.651306927, 2.85280208e-08, 1, -3.1108879e-08, -0.651306927, 4.21863646e-08, 0.758814394)
			CFrameMon = CFrame.new(-1876.95959, 192.610947, -10542.2939, 0.0553516336, -2.83836812e-08, 0.998466909, -6.89634405e-10, 1, 2.84654931e-08, -0.998466909, -2.26418861e-09, 0.0553516336)
			SelectMonster = "Peanut Scout"

			if SelectMonster ~= "Peanut President" then
				Next_Level_X = 2125
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2125 and game.Players.LocalPlayer.Data.Level.Value <= 2149 or SelectMonster == "Ice Cream Chef" then
			Ms = "Ice Cream Chef"
			NameQuest = "IceCreamIslandQuest"
			QuestLv = 1
			NameMon = "Ice Cream Chef"
			CFrameQ = CFrame.new(-820.404358, 65.8453293, -10965.5654, 0.822534859, 5.24448502e-08, -0.568714678, -2.08336317e-08, 1, 6.20846663e-08, 0.568714678, -3.92184099e-08, 0.822534859)
			CFrameMon = CFrame.new(-821.614075, 208.39537, -10990.7617, -0.870096624, 3.18909272e-08, 0.492881238, -1.8357893e-08, 1, -9.71107568e-08, -0.492881238, -9.35439957e-08, -0.870096624)

			if SelectMonster ~= "Ice Cream Chef" then
				Next_Level_X = 2150
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2150 and game.Players.LocalPlayer.Data.Level.Value <= 2199 or SelectMonster == "Ice Cream Commander" then
			Ms = "Ice Cream Commander"
			NameQuest = "IceCreamIslandQuest"
			QuestLv = 2
			NameMon = "Ice Cream Commander"
			CFrameQ = CFrame.new(-819.376526, 67.4634171, -10967.2832)
			CFrameMon = CFrame.new(-610.11669921875, 208.26904296875, -11253.686523438)

			if SelectMonster ~= "Ice Cream Commander" then
				Next_Level_X = 2200
			end

			if game.Players.LocalPlayer.Data.Level.Value >= 2175 then
				SelectBoss_P = "Cake Queen"
			end

			SelectMonster = "Ice Cream Chef"
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2200 and game.Players.LocalPlayer.Data.Level.Value <= 2224 or SelectMonster == "Cookie Crafter" then
			Ms = "Cookie Crafter"
			NameQuest = "CakeQuest1"
			QuestLv = 1
			NameMon = "Cookie Crafter"
			CFrameQ = CFrame.new(-2020.6068115234, 37.82400894165, -12027.80859375)
			CFrameMon = CFrame.new(-2286.6843261719, 146.56562805176, -12226.881835938)

			if not (SelectMonster == "Cookie Crafter" or LevelMax) then
				Next_Level_X = 2225
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2225 and game.Players.LocalPlayer.Data.Level.Value <= 2249 or SelectMonster == "Cake Guard" then
			Ms = "Cake Guard"
			NameQuest = "CakeQuest1"
			QuestLv = 2
			NameMon = "Cake Guard"
			CFrameQ = CFrame.new(-2020.6068115234, 37.82400894165, -12027.80859375)
			CFrameMon = CFrame.new(-1817.9747314453, 209.56327819824, -12288.922851562)
			SelectMonster = "Cookie Crafter"

			if not (SelectMonster == "Cake Guard" or LevelMax) then
				Next_Level_X = 2250
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2250 and game.Players.LocalPlayer.Data.Level.Value < 2300 or SelectMonster == "Baking Staff" then
			Ms = "Baking Staff"
			NameQuest = "CakeQuest2"
			QuestLv = 1
			NameMon = "Baking Staff"
			CFrameQ = CFrame.new(-1928.31763, 37.7296638, -12840.626)
			CFrameMon = CFrame.new(-1818.3479003906, 93.412757873535, -12887.66015625)

			if not (SelectMonster == "Baking Staff" or LevelMax) then
				Next_Level_X = 2300
			end

			SelectMonster = "Cookie Crafter"
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2300 and game.Players.LocalPlayer.Data.Level.Value < 2325 or SelectMonster == "Cocoa Warrior" then
			Ms = "Cocoa Warrior"
			NameQuest = "ChocQuest1"
			QuestLv = 1
			NameMon = "Cocoa Warrior"
			CFrameQ = CFrame.new(230.19186401367, 24.734258651733, -12202.657226562)
			CFrameMon = CFrame.new(24.617475509644, 24.734342575073, -12227.267578125)

			if SelectMonster ~= "Cocoa Warrior" then
				Next_Level_X = 2325
			end
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2325 and game.Players.LocalPlayer.Data.Level.Value < 2350 or SelectMonster == handlers[3]({
					"Chocolate Bar Battle",
					"r"
				}) then
			Ms = handlers[3]({
				"Chocolate Bar Battle",
				"r"
			})
			NameQuest = "ChocQuest1"
			QuestLv = 2
			NameMon = handlers[3]({
				"Chocolate Bar Battle",
				"r"
			})
			CFrameQ = CFrame.new(230.19186401367, 24.734258651733, -12202.657226562)
			CFrameMon = CFrame.new(658.22302246094, 24.734258651733, -12541.991210938)

			if SelectMonster ~= handlers[3]({
				"Chocolate Bar Battle",
				"r"
			}) then
				Next_Level_X = 2350
			end

			SelectMonster = "Cocoa Warrior"
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2350 and game.Players.LocalPlayer.Data.Level.Value < 2375 or SelectMonster == "Sweet Thief" then
			Ms = "Sweet Thief"
			NameQuest = "ChocQuest2"
			QuestLv = 1
			NameMon = "Sweet Thief"
			CFrameQ = CFrame.new(149.14392089844, 24.793828964233, -12775.41015625)
			CFrameMon = CFrame.new(51.611843109131, 24.793809890747, -12574.873046875)

			if SelectMonster ~= "Sweet Thief" then
				Next_Level_X = 2375
			end

			SelectMonster = handlers[3]({
				"Chocolate Bar Battle",
				"r"
			})
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2375 and game.Players.LocalPlayer.Data.Level.Value < 2400 or SelectMonster == "Candy Rebel" then
			Ms = "Candy Rebel"
			NameQuest = "ChocQuest2"
			QuestLv = 2
			NameMon = "Candy Rebel"
			CFrameQ = CFrame.new(149.14392089844, 24.793828964233, -12775.41015625)
			CFrameMon = CFrame.new(28.34560585022, 24.793802261353, -12949.502929688)

			if SelectMonster ~= "Candy Rebel" then
				Next_Level_X = 2400
			end

			SelectMonster = "Sweet Thief"
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2400 and game.Players.LocalPlayer.Data.Level.Value < 2425 or SelectMonster == "Candy Pirate" then
			Ms = "Candy Pirate"
			NameQuest = "CandyQuest1"
			QuestLv = 1
			NameMon = "Candy Pirate"
			CFrameQ = CFrame.new(-1146.8081054688, 16.10725402832, -14444.353515625)
			CFrameMon = CFrame.new(-1333.9425048828, 16.907636642456, -14424.844726562)
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2425 and game.Players.LocalPlayer.Data.Level.Value < 2550 or SelectMonster == "Snow Demon" then
			Ms = "Snow Demon"
			NameQuest = "CandyQuest1"
			QuestLv = 2
			NameMon = "Snow Demon"
			CFrameQ = CFrame.new(-1146.8081054688, 16.10725402832, -14444.353515625)
			CFrameMon = CFrame.new(-963.02130126953, 16.107183456421, -14289.576171875)

			if SelectMonster ~= "Candy Pirate" then
				Next_Level_X = 2551
			end

			SelectMonster = "Candy Pirate"
		elseif game.Players.LocalPlayer.Data.Level.Value >= 2550 then
			Ms = "Baking Staff"
			NameQuest = "CakeQuest2"
			QuestLv = 1
			NameMon = "Baking Staff"
			CFrameQ = CFrame.new(-1928.31763, 37.7296638, -12840.626)
			CFrameMon = CFrame.new(-1818.3479003906, 93.412757873535, -12887.66015625)
			SelectMonster = "Cookie Crafter"

			local t15 = { tostring(string.match(tostring(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CakePrinceSpawner")), "%d+")) }

			if t15[1] == "nil" or t15[1] == nil then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
				Cake_Prince_S:Set(handlers[3]({
					" Cake Prince : Boss ",
					"Spawn"
				}))
			else
				Cake_Prince_S:Set(" Cake Prince : " .. t15[1])
			end
		end
	end
end
handlers[8] = function()
	if Old_World and handlers[22].Value >= 1 and handlers[22].Value <= 9 then
		Enemy = "Bandit"
		NameEnemy = "Bandit"
		QuestName = "BanditQuest1"
		QuestNumber = 1
		QuestPos = CFrame.new(1059.58728, 16.412075, 1549.54443, -0.963007867, 4.12775627e-08, 0.269473195, 2.39519959e-08, 1, -6.75822349e-08, -0.269473195, -5.86278048e-08, -0.963007867)
		EnemyPos = CFrame.new(1175.00793, 43.7162018, 1680.39185, 0.940636754, 1.67726082e-08, 0.339414984, -3.54472718e-08, 1, 4.88204712e-08, -0.339414984, -5.79536632e-08, 0.940636754)
	elseif Old_World and handlers[22].Value >= 10 and handlers[22].Value <= 14 then
		Enemy = "Monkey"
		NameEnemy = "Monkey"
		QuestName = "JungleQuest"
		QuestNumber = 1
		QuestPos = CFrame.new(-1598.92285, 36.9012909, 148.748718, -0.969585121, -1.11576668e-07, -0.244754329, -1.2733129e-07, 1, 4.8546088e-08, 0.244754329, 7.823445e-08, -0.969585121)
		EnemyPos = CFrame.new(-1660.75586, 40.1013031, 320.152313, 0.82476908, -4.88485696e-08, -0.565469682, 5.81200084e-08, 1, -1.61455704e-09, 0.565469682, -3.15334674e-08, 0.82476908)
	elseif Old_World and handlers[22].Value >= 15 and handlers[22].Value <= 29 then
		Enemy = "Gorilla"
		NameEnemy = "Gorilla"
		QuestName = "JungleQuest"
		QuestNumber = 2
		QuestPos = CFrame.new(-1598.92285, 36.9012909, 148.748718, -0.969585121, -1.11576668e-07, -0.244754329, -1.2733129e-07, 1, 4.8546088e-08, 0.244754329, 7.823445e-08, -0.969585121)
		EnemyPos = CFrame.new(-1196.64343, 7.74201918, -445.539734, -0.919930279, -4.16423696e-08, 0.392081946, -1.71233108e-08, 1, 6.60324133e-08, -0.392081946, 5.40314744e-08, -0.919930279)

		if Old_World and handlers[22].Value >= 20 and handlers[22].Value <= 29 then
			Name_Boss = "The Gorilla King"
			QuestName_Boss = "JungleQuest"
			QuestNumber_Boss = 3
		end
	elseif Old_World and handlers[22].Value >= 30 and handlers[22].Value <= 39 then
		Enemy = "Pirate"
		NameEnemy = "Pirate"
		QuestName = "BuggyQuest1"
		QuestNumber = 1
		QuestPos = CFrame.new(-1139.5631103516, 4.7520513534546, 3830.38671875)
		EnemyPos = CFrame.new(-1045.9431152344, 64.419502258301, 3930.3020019531)
	elseif Old_World and handlers[22].Value >= 40 and handlers[22].Value <= 59 then
		Enemy = "Brute"
		NameEnemy = "Brute"
		QuestName = "BuggyQuest1"
		QuestNumber = 2
		QuestPos = CFrame.new(-1139.5631103516, 4.7520513534546, 3830.38671875)
		EnemyPos = CFrame.new(-1150.2763671875, 130.60118103027, 4164.9345703125)

		if Old_World and handlers[22].Value >= 55 and handlers[22].Value <= 59 then
			Name_Boss = "Bobby"
			QuestName_Boss = "BuggyQuest1"
			QuestNumber_Boss = 3
		end
	elseif Old_World and handlers[22].Value >= 60 and handlers[22].Value <= 74 then
		Enemy = "Desert Bandit"
		NameEnemy = "Desert Bandit"
		QuestName = "DesertQuest"
		QuestNumber = 1
		QuestPos = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, 0, -0.573571265, 0, 1, 0, 0.573571265, 0, 0.819155693)
		EnemyPos = CFrame.new(935.8798046975, 6.4486746788025, 4481.5859375)
	elseif Old_World and handlers[22].Value >= 75 and handlers[22].Value <= 89 then
		Enemy = "Desert Officer"
		NameEnemy = "Desert Officer"
		QuestName = "DesertQuest"
		QuestNumber = 2
		QuestPos = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, 0, -0.573571265, 0, 1, 0, 0.573571265, 0, 0.819155693)
		EnemyPos = CFrame.new(1608.2822265625, 8.6142244338989, 4371.0073242188)
	elseif Old_World and handlers[22].Value >= 90 and handlers[22].Value <= 99 then
		Enemy = "Snow Bandit"
		NameEnemy = "Snow Bandit"
		QuestName = "SnowQuest"
		QuestNumber = 1
		QuestPos = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
		EnemyPos = CFrame.new(1354.3479003906, 87.272773742676, -1393.9465332031)
	elseif Old_World and handlers[22].Value >= 100 and handlers[22].Value <= 119 then
		Enemy = "Snowman"
		NameEnemy = "Snowman"
		QuestName = "SnowQuest"
		QuestNumber = 2
		QuestPos = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
		EnemyPos = CFrame.new(1201.6412353516, 144.57958984375, -1550.0670166016)

		if Old_World and handlers[22].Value >= 110 and handlers[22].Value <= 119 then
			Name_Boss = "Yeti"
			QuestName_Boss = "SnowQuest"
			QuestNumber_Boss = 3
		end
	elseif Old_World and handlers[22].Value >= 120 and handlers[22].Value <= 149 then
		Enemy = "Chief Petty Officer"
		NameEnemy = "Chief Petty Officer"
		QuestName = "MarineQuest2"
		QuestNumber = 1
		QuestPos = CFrame.new(-5039.58643, 27.3500385, 4324.68018, 0, 0, -1, 0, 1, 0, 1, 0, 0)
		EnemyPos = CFrame.new(-4710.3598632812, 112.02615356445, 4584.92578125)

		if Old_World and handlers[22].Value >= 130 and handlers[22].Value <= 149 then
			Name_Boss = "Vice Admiral"
			QuestName_Boss = "MarineQuest2"
			QuestNumber_Boss = 2
		end
	elseif Old_World and handlers[22].Value >= 150 and handlers[22].Value <= 174 then
		Enemy = "Sky Bandit"
		NameEnemy = "Sky Bandit"
		QuestName = "SkyQuest"
		QuestNumber = 1
		QuestPos = CFrame.new(-4838.701171875, 717.66931152344, -2617.8647460938)
		EnemyPos = CFrame.new(-4965.37890625, 357.37414550781, -2848.7023925781)
	else
		if Old_World and handlers[22].Value >= 175 and handlers[22].Value <= 189 then
			Enemy = "Dark Master"
			NameEnemy = "Dark Master"
			QuestName = "SkyQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(-4838.701171875, 717.66931152344, -2617.8647460938)
			EnemyPos = CFrame.new(-5224.05859375, 484.44784545898, -2275.9985351562)
		elseif Old_World and handlers[22].Value >= 190 and handlers[22].Value <= 209 then
			Enemy = "Prisoner"
			NameEnemy = "Prisoner"
			QuestName = "PrisonerQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(5309.6474609375, 1.6542626619339, 477.8815612793)
			EnemyPos = CFrame.new(5276.5576171875, 87.836639404297, 561.01007080078)
		elseif Old_World and handlers[22].Value >= 210 and handlers[22].Value <= 249 then
			Enemy = "Dangerous Prisoner"
			NameEnemy = "Dangerous Prisoner"
			QuestName = "PrisonerQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(5309.6474609375, 1.6542626619339, 477.8815612793)
			EnemyPos = CFrame.new(5276.5576171875, 87.836639404297, 561.01007080078)

			if Old_World and handlers[22].Value >= 240 and handlers[22].Value <= 249 then
				Name_Boss = "Swan"
				QuestName_Boss = "ImpelQuest"
				QuestNumber_Boss = 3
			end
		elseif Old_World and handlers[22].Value >= 250 and handlers[22].Value <= 299 then
			Enemy = "Toga Warrior"
			NameEnemy = "Toga Warrior"
			QuestName = "ColosseumQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298)
			EnemyPos = CFrame.new(-1820.21484375, 51.683856964111, -2740.6650390625)
		elseif Old_World and handlers[22].Value >= 300 and handlers[22].Value <= 324 then
			Enemy = "Military Soldier"
			NameEnemy = "Military Soldier"
			QuestName = "MagmaQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
			EnemyPos = CFrame.new(-5411.1645507812, 11.081554412842, 8454.29296875)
		elseif Old_World and handlers[22].Value >= 325 and handlers[22].Value <= 374 then
			Enemy = "Military Spy"
			NameEnemy = "Military Spy"
			QuestName = "MagmaQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
			EnemyPos = CFrame.new(-5802.8681640625, 86.262413024902, 8828.859375)

			if Old_World and handlers[22].Value >= 350 and handlers[22].Value <= 374 then
				Name_Boss = "Magma Admiral"
				QuestName_Boss = "MagmaQuest"
				QuestNumber_Boss = 3
			end
		elseif Old_World and handlers[22].Value >= 375 and handlers[22].Value <= 399 then
			Enemy = "Fishman Warrior"
			NameEnemy = "Fishman Warrior"
			QuestName = "FishmanQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
			EnemyPos = CFrame.new(60878.30078125, 18.482830047607, 1543.7574462891)

			if (CFrame.new(61164, 12, 1820).Position - handlers[5].Character.HumanoidRootPart.Position).Magnitude >= 2000 then
				handlers[5].Character.HumanoidRootPart.CFrame = CFrame.new(61164, 12, 1820)
			end
		elseif Old_World and handlers[22].Value >= 400 and handlers[22].Value <= 449 then
			Enemy = "Fishman Commando"
			NameEnemy = "Fishman Commando"
			QuestName = "FishmanQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
			EnemyPos = CFrame.new(61922.6328125, 18.482830047607, 1493.9343261719)

			if Old_World and handlers[22].Value >= 425 and handlers[22].Value <= 449 then
				Name_Boss = "Fishman Lord"
				QuestName_Boss = "FishmanQuest"
				QuestNumber_Boss = 3
			end

			if (CFrame.new(61164, 12, 1820).Position - handlers[5].Character.HumanoidRootPart.Position).Magnitude >= 2000 then
				handlers[5].Character.HumanoidRootPart.CFrame = CFrame.new(61164, 12, 1820)
			end
		elseif Old_World and handlers[22].Value >= 450 and handlers[22].Value <= 474 then
			Enemy = "God's Guard"
			NameEnemy = "God's Guard"
			QuestName = "SkyExp1Quest"
			QuestNumber = 1
			QuestPos = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, 0, -0.0871884301, 0, 1, 0, 0.0871884301, 0, 0.996191859)
			EnemyPos = CFrame.new(-4710.04296875, 845.27697753906, -1927.3079833984)

			if (CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, 0, -0.0871884301, 0, 1, 0, 0.0871884301, 0, 0.996191859).Position - handlers[5].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
				handlers[7].Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-4607.82275, 872.54248, -1667.55688))
			end
		elseif Old_World and handlers[22].Value >= 475 and handlers[22].Value <= 524 then
			Enemy = "Shanda"
			NameEnemy = "Shanda"
			QuestName = "SkyExp1Quest"
			QuestNumber = 2
			QuestPos = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, -0.422592998)
			EnemyPos = CFrame.new(-7678.4897460938, 5566.4038085938, -497.21560668945)
		elseif Old_World and handlers[22].Value >= 525 and handlers[22].Value <= 549 then
			Enemy = "Royal Squad"
			NameEnemy = "Royal Squad"
			QuestName = "SkyExp2Quest"
			QuestNumber = 1
			QuestPos = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			EnemyPos = CFrame.new(-7624.2524414062, 5658.1333007812, -1467.3542480469)
		elseif Old_World and handlers[22].Value >= 550 and handlers[22].Value <= 624 then
			Enemy = "Royal Soldier"
			NameEnemy = "Royal Soldier"
			QuestName = "SkyExp2Quest"
			QuestNumber = 2
			QuestPos = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			EnemyPos = CFrame.new(-7836.7534179688, 5645.6640625, -1790.6236572266)

			if Old_World and handlers[22].Value >= 575 and handlers[22].Value <= 624 then
				Name_Boss = "Thunder God"
				QuestName_Boss = "SkyExp2Quest"
				QuestNumber_Boss = 3
			end
		elseif Old_World and handlers[22].Value >= 625 and handlers[22].Value <= 649 then
			Enemy = "Galley Pirate"
			NameEnemy = "Galley Pirate"
			QuestName = "FountainQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
			EnemyPos = CFrame.new(5551.0219726562, 78.901351928711, 3930.4128417969)
		elseif Old_World and handlers[22].Value >= 650 and handlers[22].Value <= 99999 then
			Enemy = "Galley Captain"
			NameEnemy = "Galley Captain"
			QuestName = "FountainQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
			EnemyPos = CFrame.new(5441.9516601562, 42.502059936523, 4950.09375)

			if Old_World and handlers[22].Value >= 675 and handlers[22].Value <= 99999 then
				Name_Boss = "Cyborg"
				QuestName_Boss = "FountainQuest"
				QuestNumber_Boss = 3
			end
		elseif New_World and handlers[22].Value >= 700 and handlers[22].Value <= 724 then
			Enemy = "Raider"
			NameEnemy = "Raider"
			QuestName = "Area1Quest"
			QuestNumber = 1
			QuestPos = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
			EnemyPos = CFrame.new(-728.32672119141, 52.779319763184, 2345.7705078125)
		elseif New_World and handlers[22].Value >= 725 and handlers[22].Value <= 774 then
			Enemy = "Mercenary"
			NameEnemy = "Mercenary"
			QuestName = "Area1Quest"
			QuestNumber = 2
			QuestPos = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
			EnemyPos = CFrame.new(-1004.3244018555, 80.158866882324, 1424.6193847656)

			if New_World and handlers[22].Value >= 750 and handlers[22].Value <= 774 then
				Name_Boss = "Diamond"
				QuestName_Boss = "Area1Quest"
				QuestNumber_Boss = 3
			end
		elseif New_World and handlers[22].Value >= 775 and handlers[22].Value <= 799 then
			Enemy = "Swan Pirate"
			NameEnemy = "Swan Pirate"
			QuestName = "Area2Quest"
			QuestNumber = 1
			QuestPos = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0, -0.99026376, 0, 0.139203906)
			EnemyPos = CFrame.new(1068.6643066406, 137.61428833008, 1322.1060791016)
		elseif New_World and handlers[22].Value >= 800 and handlers[22].Value <= 874 then
			Enemy = "Factory Staff"
			NameEnemy = "Factory Staff"
			QuestName = "Area2Quest"
			QuestNumber = 2
			QuestPos = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.960749e-10, -0.999488771, 1.3632653e-10, 1, 8.9217234e-10, 0.999488771, -1.0773209e-10, -0.0319722369)
			EnemyPos = CFrame.new(73.078674316406, 81.863441467285, -27.470672607422)

			if New_World and handlers[22].Value >= 850 and handlers[22].Value <= 874 then
				Name_Boss = "Jeremy"
				QuestName_Boss = "Area2Quest"
				QuestNumber_Boss = 3
			end
		elseif New_World and handlers[22].Value >= 875 and handlers[22].Value <= 899 then
			Enemy = "Marine Lieutenant"
			NameEnemy = "Marine Lieutenant"
			QuestName = "MarineQuest3"
			QuestNumber = 1
			QuestPos = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
			EnemyPos = CFrame.new(-2821.3723144531, 75.897277832031, -3070.0891113281)
		elseif New_World and handlers[22].Value >= 900 and handlers[22].Value <= 949 then
			Enemy = "Marine Captain"
			NameEnemy = "Marine Captain"
			QuestName = "MarineQuest3"
			QuestNumber = 2
			QuestPos = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
			EnemyPos = CFrame.new(-1861.2310791016, 80.176582336426, -3254.6975097656)
		elseif New_World and handlers[22].Value >= 950 and handlers[22].Value <= 974 then
			Enemy = "Zombie"
			NameEnemy = "Zombie"
			QuestName = "ZombieQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
			EnemyPos = CFrame.new(-5657.7768554688, 78.969734191895, -928.68701171875)

			if New_World and handlers[22].Value >= 925 and handlers[22].Value <= 974 then
				Name_Boss = "Fajita"
				QuestName_Boss = "MarineQuest3"
				QuestNumber_Boss = 3
			end
		elseif New_World and handlers[22].Value >= 975 and handlers[22].Value <= 999 then
			Enemy = "Vampire"
			NameEnemy = "Vampire"
			QuestName = "ZombieQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
			EnemyPos = CFrame.new(-6037.66796875, 32.184638977051, -1340.6597900391)
		elseif New_World and handlers[22].Value >= 1000 and handlers[22].Value <= 1049 then
			Enemy = "Snow Trooper"
			NameEnemy = "Snow Trooper"
			QuestName = "SnowMountainQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
			EnemyPos = CFrame.new(549.14733886719, 427.38705444336, -5563.6987304688)
		elseif New_World and handlers[22].Value >= 1050 and handlers[22].Value <= 1099 then
			Enemy = "Winter Warrior"
			NameEnemy = "Winter Warrior"
			QuestName = "SnowMountainQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
			EnemyPos = CFrame.new(1142.7451171875, 475.63980102539, -5199.4165039062)
		elseif New_World and handlers[22].Value >= 1100 and handlers[22].Value <= 1124 then
			Enemy = "Lab Subordinate"
			NameEnemy = "Lab Subordinate"
			QuestName = "IceSideQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, 0, -0.891015649, 0, 1, 0, 0.891015649, 0, 0.453972578)
			EnemyPos = CFrame.new(-5707.4716796875, 15.951709747314, -4513.3920898438)
		elseif New_World and handlers[22].Value >= 1125 and handlers[22].Value <= 1174 then
			Enemy = "Horned Warrior"
			NameEnemy = "Horned Warrior"
			QuestName = "IceSideQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, 0, -0.891015649, 0, 1, 0, 0.891015649, 0, 0.453972578)
			EnemyPos = CFrame.new(-6341.3666992188, 15.951770782471, -5723.162109375)

			if New_World and handlers[22].Value >= 1150 and handlers[22].Value <= 1174 then
				Name_Boss = "Smoke Admiral"
				QuestName_Boss = "IceSideQuest"
				QuestNumber_Boss = 3
			end
		elseif New_World and handlers[22].Value >= 1175 and handlers[22].Value <= 1199 then
			Enemy = "Magma Ninja"
			NameEnemy = "Magma Ninja"
			QuestName = "FireSideQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
			EnemyPos = CFrame.new(-5449.6728515625, 76.658744812012, -5808.2006835938)
		elseif New_World and handlers[22].Value >= 1200 and handlers[22].Value <= 1249 then
			Enemy = "Lava Pirate"
			NameEnemy = "Lava Pirate"
			QuestName = "FireSideQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
			EnemyPos = CFrame.new(-5213.3315429688, 49.737880706787, -4701.451171875)
		elseif New_World and handlers[22].Value >= 1250 and handlers[22].Value <= 1274 then
			Enemy = "Ship Deckhand"
			NameEnemy = "Ship Deckhand"
			QuestName = "ShipQuest1"
			QuestNumber = 1
			QuestPos = CFrame.new(1037.80127, 125.092171, 32911.6016)
			EnemyPos = CFrame.new(1212.0111083984, 150.79205322266, 33059.24609375)

			if (CFrame.new(1212.0111083984, 150.79205322266, 33059.24609375).Position - handlers[5].Character.HumanoidRootPart.Position).Magnitude >= 5000 then
				handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", Vector3.new(923.21301269531, 126.9759979248, 32852.83203125))
			end
		elseif New_World and handlers[22].Value >= 1275 and handlers[22].Value <= 1299 then
			Enemy = "Ship Engineer"
			NameEnemy = "Ship Engineer"
			QuestName = "ShipQuest1"
			QuestNumber = 2
			QuestPos = CFrame.new(1037.80127, 125.092171, 32911.6016)
			EnemyPos = CFrame.new(919.47863769531, 43.544013977051, 32779.96875)

			if (CFrame.new(1212.0111083984, 150.79205322266, 33059.24609375).Position - handlers[5].Character.HumanoidRootPart.Position).Magnitude >= 5000 then
				handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", Vector3.new(923.21301269531, 126.9759979248, 32852.83203125))
			end
		elseif New_World and handlers[22].Value >= 1300 and handlers[22].Value <= 1324 then
			Enemy = "Ship Steward"
			NameEnemy = "Ship Steward"
			QuestName = "ShipQuest2"
			QuestNumber = 1
			QuestPos = CFrame.new(968.80957, 125.092171, 33244.125)
			EnemyPos = CFrame.new(919.43853759766, 129.55599975586, 33436.03515625)

			if (CFrame.new(1212.0111083984, 150.79205322266, 33059.24609375).Position - handlers[5].Character.HumanoidRootPart.Position).Magnitude >= 5000 then
				handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", Vector3.new(923.21301269531, 126.9759979248, 32852.83203125))
			end
		elseif New_World and handlers[22].Value >= 1325 and handlers[22].Value <= 1349 then
			Enemy = "Ship Officer"
			NameEnemy = "Ship Officer"
			QuestName = "ShipQuest2"
			QuestNumber = 2
			QuestPos = CFrame.new(968.80957, 125.092171, 33244.125)
			EnemyPos = CFrame.new(1036.0179443359, 181.4390411377, 33315.7265625)

			if (CFrame.new(1212.0111083984, 150.79205322266, 33059.24609375).Position - handlers[5].Character.HumanoidRootPart.Position).Magnitude >= 5000 then
				handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", Vector3.new(923.21301269531, 126.9759979248, 32852.83203125))
			end
		elseif New_World and handlers[22].Value >= 1350 and handlers[22].Value <= 1374 then
			Enemy = "Arctic Warrior"
			NameEnemy = "Arctic Warrior"
			QuestName = "FrostQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
			EnemyPos = CFrame.new(5966.24609375, 62.970020294189, -6179.3828125)
		elseif New_World and handlers[22].Value >= 1375 and handlers[22].Value <= 1424 then
			Enemy = "Snow Lurker"
			NameEnemy = "Snow Lurker"
			QuestName = "FrostQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
			EnemyPos = CFrame.new(5407.0737304688, 69.194374084473, -6880.8803710938)

			if New_World and handlers[22].Value >= 1400 and handlers[22].Value <= 1424 then
				Name_Boss = "Awakened Ice Admiral"
				QuestName_Boss = "FrostQuest"
				QuestNumber_Boss = 3
			end
		elseif New_World and handlers[22].Value >= 1425 and handlers[22].Value <= 1449 then
			Enemy = "Sea Soldier"
			NameEnemy = "Sea Soldier"
			QuestName = "ForgottenQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(-3055, 240, -10145)
			EnemyPos = CFrame.new(-3433, 26, -9784)
		elseif New_World and handlers[22].Value >= 1450 and handlers[22].Value <= 999999 then
			Enemy = "Water Fighter"
			NameEnemy = "Water Fighter"
			QuestName = "ForgottenQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(-3054.53, 239.96, -10144.42)
			EnemyPos = CFrame.new(-3360.23, 284.21, -10533.07)

			if New_World and handlers[22].Value >= 1475 and handlers[22].Value <= 1499 then
				Name_Boss = "Tide Keeper"
				QuestName_Boss = "ForgottenQuest"
				QuestNumber_Boss = 3
			end
		elseif Three_World and handlers[22].Value >= 1500 and handlers[22].Value <= 1524 then
			Enemy = "Pirate Millionaire"
			NameEnemy = "Pirate Millionaire"
			QuestName = "PiratePortQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(-449.15930175781, 108.61765289307, 5948.0014648438)
			EnemyPos = CFrame.new(-245.99638366699, 47.30615234375, 5584.1005859375)
		elseif Three_World and handlers[22].Value >= 1525 and handlers[22].Value <= 1574 then
			Enemy = "Pistol Billionaire"
			NameEnemy = "Pistol Billionaire"
			QuestName = "PiratePortQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(-449.15930175781, 108.61765289307, 5948.0014648438)
			EnemyPos = CFrame.new(-187.33015441895, 86.239875793457, 6013.513671875)

			if Three_World and handlers[22].Value >= 1550 and handlers[22].Value <= 1574 then
				Name_Boss = "Stone"
				QuestName_Boss = "PiratePortQuest"
				QuestNumber_Boss = 3
			end
		elseif Three_World and handlers[22].Value >= 1575 and handlers[22].Value <= 1599 then
			Enemy = "Dragon Crew Warrior"
			NameEnemy = "Dragon Crew Warrior"
			QuestName = "DragonCrewQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(6737.7768554688, 127.42920684814, -713.23126220703)
			EnemyPos = CFrame.new(6141.140625, 51.351364135742, -1340.7385253906)
		elseif Three_World and handlers[22].Value >= 1600 and handlers[22].Value <= 1624 then
			Enemy = "Dragon Crew Archer"
			NameEnemy = "Dragon Crew Archer"
			QuestName = "DragonCrewQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(6737.7768554688, 127.42920684814, -713.23126220703)
			EnemyPos = CFrame.new(6616.4174804688, 441.76705932617, 446.04699707031)
		elseif Three_World and handlers[22].Value >= 1625 and handlers[22].Value <= 1649 then
			Enemy = "Hydra Enforcer"
			NameEnemy = "Hydra Enforcer"
			QuestName = "VenomCrewQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(5212.94140625, 1004.1171875, 755.66571044922)
			EnemyPos = CFrame.new(4685.2583007812, 735.80780029297, 815.34259033203)
		elseif Three_World and handlers[22].Value >= 1650 and handlers[22].Value <= 1699 then
			Enemy = "Venomous Assailant"
			NameEnemy = "Venomous Assailant"
			QuestName = "VenomCrewQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(5212.94140625, 1004.1171875, 755.66571044922)
			EnemyPos = CFrame.new(4729.0942382812, 590.43676757812, -36.976276397705)

			if Three_World and handlers[22].Value >= 1675 and handlers[22].Value <= 1699 then
				Name_Boss = "Hydra Leader"
				QuestName_Boss = "VenomCrewQuest"
				QuestNumber_Boss = 3
			end
		elseif Three_World and handlers[22].Value >= 1700 and handlers[22].Value <= 1724 then
			Enemy = "Marine Commodore"
			NameEnemy = "Marine Commodore"
			QuestName = "MarineTreeIsland"
			QuestNumber = 1
			QuestPos = CFrame.new(2484.0673828125, 74.282150268555, -6786.64453125)
			EnemyPos = CFrame.new(2286.0078125, 73.133918762207, -7159.8090820312)
		elseif Three_World and handlers[22].Value >= 1725 and handlers[22].Value <= 1774 then
			Enemy = "Marine Rear Admiral"
			NameEnemy = "Marine Rear Admiral"
			QuestName = "MarineTreeIsland"
			QuestNumber = 2
			QuestPos = CFrame.new(2484.0673828125, 74.282150268555, -6786.64453125)
			EnemyPos = CFrame.new(3656.7736816406, 160.52406311035, -7001.5986328125)

			if Three_World and handlers[22].Value >= 1750 and handlers[22].Value <= 1774 then
				Name_Boss = "Kilo Admiral"
				QuestName_Boss = "MarineTreeIsland"
				QuestNumber_Boss = 3
			end
		elseif Three_World and handlers[22].Value >= 1775 and handlers[22].Value <= 1799 then
			Enemy = "Fishman Raider"
			NameEnemy = "Fishman Raider"
			QuestName = "DeepForestIsland3"
			QuestNumber = 1
			QuestPos = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
			EnemyPos = CFrame.new(-10407.526367188, 331.76263427734, -8368.5166015625)
		elseif Three_World and handlers[22].Value >= 1800 and handlers[22].Value <= 1824 then
			Enemy = "Fishman Captain"
			NameEnemy = "Fishman Captain"
			QuestName = "DeepForestIsland3"
			QuestNumber = 2
			QuestPos = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
			EnemyPos = CFrame.new(-10994.701171875, 352.38140869141, -9002.1103515625)
		elseif Three_World and handlers[22].Value >= 1825 and handlers[22].Value <= 1849 then
			Enemy = "Forest Pirate"
			NameEnemy = "Forest Pirate"
			QuestName = "DeepForestIsland"
			QuestNumber = 1
			QuestPos = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, 0, -0.707079291, 0, 1, 0, 0.707079291, 0, 0.707134247)
			EnemyPos = CFrame.new(-13274.478515625, 332.37814331055, -7769.5805664062)
		elseif Three_World and handlers[22].Value >= 1850 and handlers[22].Value <= 1899 then
			Enemy = "Mythological Pirate"
			NameEnemy = "Mythological Pirate"
			QuestName = "DeepForestIsland"
			QuestNumber = 2
			QuestPos = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, 0, -0.707079291, 0, 1, 0, 0.707079291, 0, 0.707134247)
			EnemyPos = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125)

			if Three_World and handlers[22].Value >= 1875 and handlers[22].Value <= 1899 then
				Name_Boss = "Captain Elephant"
				QuestName_Boss = "DeepForestIsland"
				QuestNumber_Boss = 3
			end
		elseif Three_World and handlers[22].Value >= 1900 and handlers[22].Value <= 1924 then
			Enemy = "Jungle Pirate"
			NameEnemy = "Jungle Pirate"
			QuestName = "DeepForestIsland2"
			QuestNumber = 1
			QuestPos = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
			EnemyPos = CFrame.new(-12256.16015625, 331.73828125, -10485.836914062)
		elseif Three_World and handlers[22].Value >= 1924 and handlers[22].Value <= 1974 then
			Enemy = "Musketeer Pirate"
			NameEnemy = "Musketeer Pirate"
			QuestName = "DeepForestIsland2"
			QuestNumber = 2
			QuestPos = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
			EnemyPos = CFrame.new(-13457.904296875, 391.54565429688, -9859.177734375)

			if Three_World and handlers[22].Value >= 1950 and handlers[22].Value <= 1974 then
				Name_Boss = "Beautiful Pirate"
				QuestName_Boss = "DeepForestIsland2"
				QuestNumber_Boss = 3
			end
		elseif Three_World and handlers[22].Value >= 1974 and handlers[22].Value <= 1999 then
			Enemy = "Reborn Skeleton"
			NameEnemy = "Reborn Skeleton"
			QuestName = "HauntedQuest1"
			QuestNumber = 1
			QuestPos = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, 0, -1, 0, 0)
			EnemyPos = CFrame.new(-8763.7236328125, 165.72299194336, 6159.8618164062)
		elseif Three_World and handlers[22].Value >= 2000 and handlers[22].Value <= 2024 then
			Enemy = "Living Zombie"
			NameEnemy = "Living Zombie"
			QuestName = "HauntedQuest1"
			QuestNumber = 2
			QuestPos = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, 0, -1, 0, 0)
			EnemyPos = CFrame.new(-10144.131835938, 138.6266784668, 5838.0888671875)
		elseif Three_World and handlers[22].Value >= 2025 and handlers[22].Value <= 2049 then
			Enemy = "Demonic Soul"
			NameEnemy = "Demonic Soul"
			QuestName = "HauntedQuest2"
			QuestNumber = 1
			QuestPos = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			EnemyPos = CFrame.new(-9505.8720703125, 172.10482788086, 6158.9931640625)
		elseif Three_World and handlers[22].Value >= 2050 and handlers[22].Value <= 2074 then
			Enemy = "Posessed Mummy"
			NameEnemy = "Posessed Mummy"
			QuestName = "HauntedQuest2"
			QuestNumber = 2
			QuestPos = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			EnemyPos = CFrame.new(-9582.0224609375, 6.2515273094177, 6205.478515625)
		elseif Three_World and handlers[22].Value >= 2075 and handlers[22].Value <= 2099 then
			Enemy = "Peanut Scout"
			NameEnemy = "Peanut Scout"
			QuestName = "NutsIslandQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			EnemyPos = CFrame.new(-2143.2419433594, 47.721984863281, -10029.995117188)
		elseif Three_World and handlers[22].Value >= 2100 and handlers[22].Value <= 2124 then
			Enemy = "Peanut President"
			NameEnemy = "Peanut President"
			QuestName = "NutsIslandQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			EnemyPos = CFrame.new(-1859.3540039062, 38.103168487549, -10422.4296875)
		elseif Three_World and handlers[22].Value >= 2125 and handlers[22].Value <= 2149 then
			Enemy = "Ice Cream Chef"
			NameEnemy = "Ice Cream Chef"
			QuestName = "IceCreamIslandQuest"
			QuestNumber = 1
			QuestPos = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			EnemyPos = CFrame.new(-872.24658203125, 65.81957244873, -10919.95703125)
		elseif Three_World and handlers[22].Value >= 2150 and handlers[22].Value <= 2199 then
			Enemy = "Ice Cream Commander"
			NameEnemy = "Ice Cream Commander"
			QuestName = "IceCreamIslandQuest"
			QuestNumber = 2
			QuestPos = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			EnemyPos = CFrame.new(-558.06103515625, 112.04895782471, -11290.774414063)

			if Three_World and handlers[22].Value >= 2175 and handlers[22].Value <= 2199 then
				Name_Boss = "Cake Queen"
				QuestName_Boss = "IceCreamIslandQuest"
				QuestNumber_Boss = 3
			end
		elseif Three_World and handlers[22].Value >= 2200 and handlers[22].Value <= 2224 then
			Enemy = "Cookie Crafter"
			NameEnemy = "Cookie Crafter"
			QuestName = "CakeQuest1"
			QuestNumber = 1
			QuestPos = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.8030205e-08, 0.288177818, 6.930119e-08, 1, 7.519312e-08, -0.288177818, -5.2032135e-08, 0.957576931)
			EnemyPos = CFrame.new(-2374.13671875, 37.798263549805, -12125.30859375)
		elseif Three_World and handlers[22].Value >= 2225 and handlers[22].Value <= 2249 then
			Enemy = "Cake Guard"
			NameEnemy = "Cake Guard"
			QuestName = "CakeQuest1"
			QuestNumber = 2
			QuestPos = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.8030205e-08, 0.288177818, 6.930119e-08, 1, 7.519312e-08, -0.288177818, -5.2032135e-08, 0.957576931)
			EnemyPos = CFrame.new(-1598.3070068359, 43.773197174072, -12244.581054688)
		elseif Three_World and handlers[22].Value >= 2250 and handlers[22].Value <= 2274 then
			Enemy = "Baking Staff"
			NameEnemy = "Baking Staff"
			QuestName = "CakeQuest2"
			QuestNumber = 1
			QuestPos = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.2214214e-08, 0.250778586, 4.7491106e-08, 1, 1.4990471e-08, -0.250778586, 2.6421194e-08, -0.96804446)
			EnemyPos = CFrame.new(-1887.8099365234, 77.618507385254, -12998.350585938)
		elseif Three_World and handlers[22].Value >= 2275 and handlers[22].Value <= 2299 then
			Enemy = "Head Baker"
			NameEnemy = "Head Baker"
			QuestName = "CakeQuest2"
			QuestNumber = 2
			QuestPos = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.2214214e-08, 0.250778586, 4.7491106e-08, 1, 1.4990471e-08, -0.250778586, 2.6421194e-08, -0.96804446)
			EnemyPos = CFrame.new(-2216.1882324219, 82.884521484375, -12869.293945312)
		elseif Three_World and handlers[22].Value >= 2300 and handlers[22].Value <= 2324 then
			Enemy = "Cocoa Warrior"
			NameEnemy = "Cocoa Warrior"
			QuestName = "ChocQuest1"
			QuestNumber = 1
			QuestPos = CFrame.new(233.22836303711, 29.876001358032, -12201.233398438)
			EnemyPos = CFrame.new(-21.553283691406, 80.574996948242, -12352.387695312)
		elseif Three_World and handlers[22].Value >= 2325 and handlers[22].Value <= 2349 then
			Enemy = handlers[3]({
				"Chocolate Bar Battle",
				"r"
			})
			NameEnemy = handlers[3]({
				"Chocolate Bar Battle",
				"r"
			})
			QuestName = "ChocQuest1"
			QuestNumber = 2
			QuestPos = CFrame.new(233.22836303711, 29.876001358032, -12201.233398438)
			EnemyPos = CFrame.new(582.59057617188, 77.188095092773, -12463.162109375)
		elseif Three_World and handlers[22].Value >= 2350 and handlers[22].Value <= 2374 then
			Enemy = "Sweet Thief"
			NameEnemy = "Sweet Thief"
			QuestName = "ChocQuest2"
			QuestNumber = 1
			QuestPos = CFrame.new(150.50663757324, 30.693693161011, -12774.502929688)
			EnemyPos = CFrame.new(165.1884765625, 76.058853149414, -12600.836914062)
		elseif Three_World and handlers[22].Value >= 2375 and handlers[22].Value <= 2399 then
			Enemy = "Candy Rebel"
			NameEnemy = "Candy Rebel"
			QuestName = "ChocQuest2"
			QuestNumber = 2
			QuestPos = CFrame.new(150.50663757324, 30.693693161011, -12774.502929688)
			EnemyPos = CFrame.new(134.86563110352, 77.247680664062, -12876.547851562)
		elseif Three_World and handlers[22].Value >= 2400 and handlers[22].Value <= 2424 then
			Enemy = "Candy Pirate"
			NameEnemy = "Candy Pirate"
			QuestName = "CandyQuest1"
			QuestNumber = 1
			QuestPos = CFrame.new(-1167, 60, -14491)
			EnemyPos = CFrame.new(-1310.5003662109, 26.016523361206, -14562.404296875)
		elseif Three_World and handlers[22].Value >= 2425 and handlers[22].Value <= 2449 then
			Enemy = "Snow Demon"
			NameEnemy = "Snow Demon"
			QuestName = "CandyQuest1"
			QuestNumber = 2
			QuestPos = CFrame.new(-1167, 60, -14491)
			EnemyPos = CFrame.new(-880.20062255859, 71.247764587402, -14538.609375)
		elseif Three_World and handlers[22].Value >= 2450 and handlers[22].Value <= 2474 then
			Enemy = "Isle Outlaw"
			NameEnemy = "Isle Outlaw"
			QuestName = "TikiQuest1"
			QuestNumber = 1
			QuestPos = CFrame.new(-16547.748046875, 61.135334014893, -173.41360473633)
			EnemyPos = CFrame.new(-16442.814453125, 116.13899993896, -264.46377563477)
		elseif Three_World and handlers[22].Value >= 2475 and handlers[22].Value <= 2499 then
			Enemy = "Island Boy"
			NameEnemy = "Island Boy"
			QuestName = "TikiQuest1"
			QuestNumber = 2
			QuestPos = CFrame.new(-16547.748046875, 61.135334014893, -173.41360473633)
			EnemyPos = CFrame.new(-16901.26171875, 84.067565917969, -192.88906860352)
		elseif Three_World and handlers[22].Value >= 2500 and handlers[22].Value <= 2524 then
			Enemy = "Sun-kissed Warrior"
			NameEnemy = "Sun"
			New = "Sun"
			QuestName = "TikiQuest2"
			QuestNumber = 1
			QuestPos = CFrame.new(-16539.078125, 55.686328887939, 1051.5738525391)
			EnemyPos = CFrame.new(-16051.969726562, 54.797149658203, 1084.67578125)
		elseif Three_World and handlers[22].Value >= 2525 and handlers[22].Value <= 2549 then
			Enemy = "Isle Champion"
			NameEnemy = "Isle Champion"
			QuestName = "TikiQuest2"
			QuestNumber = 2
			QuestPos = CFrame.new(-16539.078125, 55.686328887939, 1051.5738525391)
			EnemyPos = CFrame.new(-16619.37109375, 129.98481750488, 1071.2355957031)
		elseif Three_World and handlers[22].Value >= 2550 and handlers[22].Value <= 2574 then
			Enemy = "Serpent Hunter"
			NameEnemy = "Serpent Hunter"
			QuestName = "TikiQuest3"
			QuestNumber = 1
			QuestPos = CFrame.new(-16666.5703125, 105.29138183594, 1576.6925048828)
			EnemyPos = CFrame.new(-16474.5703125, 124.32273864746, 1619.248046875)
		elseif Three_World and handlers[22].Value >= 2575 and handlers[22].Value <= 2650 then
			Enemy = "Skull Slayer"
			NameEnemy = "Skull Slayer"
			QuestName = "TikiQuest3"
			QuestNumber = 2
			QuestPos = CFrame.new(-16666.5703125, 105.29138183594, 1576.6925048828)
			EnemyPos = CFrame.new(-16778.7852, 232.283752, 1442.08325, -0.992449045, -5.54140511e-10, -0.12265785, -2.84580609e-10, 1, -2.21517649e-09, 0.12265785, -2.16354379e-09, -0.992449045)
		end
	end
end
TPZ = function(p23)
	local t16 = {
		[2] = p23
	}

	t16[1] = (t16[2].Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

	if t16[1] < 100 then
		t16[4] = 50
	elseif t16[1] < 400 then
		t16[4] = 400
	elseif t16[1] < 1000 then
		t16[4] = 300
	elseif t16[1] < 1500 then
		t16[4] = 260
	elseif t16[1] >= 1500 then
		t16[4] = 300
	end

	handlers[23] = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(t16[1] / t16[4], Enum.EasingStyle.Linear), {
		CFrame = t16[2]
	})
	handlers[23]:Play()
end
handlers[13] = tick()
handlers[35] = game:GetService("Players").LocalPlayer
handlers[32] = function()
	if handlers[47] then
		handlers[47]:Cancel()
		handlers[47] = nil
	end
end
handlers[31] = function(p24, p25, p26)
	local t17 = {
		[10] = p24,
		[3] = p25,
		[4] = p26,
		[12] = 300
	}

	if t17[3] == 1.6 then
		t17[12] = 350
	end

	t17[11] = t17[4] or 130
	t17[9] = handlers[35].Character and handlers[35].Character:FindFirstChild("HumanoidRootPart")
	t17[7] = handlers[35].Character and handlers[35].Character:FindFirstChild("Humanoid")

	if not t17[9] or not t17[7] then
		return
	end

	t17[13] = (t17[10].Position - t17[9].Position).Magnitude

	if t17[13] > 3000 and t17[7].Health > 0 then
		local t19 = {
			{
				Vector3.new(61163.85, 11.67, 1819.78),
				"Old_World"
			},
			{
				Vector3.new(-4607.82, 872.54, -1667.55),
				"Old_World"
			},
			{
				Vector3.new(-7894.61, 5547.14, -380.29),
				"Old_World"
			},
			{
				Vector3.new(923.21, 126.97, 32852.83),
				"New_World"
			},
			{
				Vector3.new(-2953.31, 41.01, 2099.17),
				"Old_World"
			}
		}
		local t18 = { t19 }

		for k, v in pairs(t18[1]) do
			local t25 = {
				[3] = k,
				v
			}

			if _G[t25[1][2]] and (t25[1][1] - t17[10].Position).Magnitude <= 2300 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", t25[1][1])

				break
			end
		end
	end

	handlers[13] = tick()
	handlers[32]()
	t17[6] = (t17[10].Position - t17[9].Position).Magnitude
	t17[9].CFrame = CFrame.new(t17[9].Position.X, t17[10].Position.Y, t17[9].Position.Z)

	if t17[6] < 130 then
		pcall(function()
			t17[9].CFrame = t17[10]
		end)

		return
	end

	if t17[6] < t17[11] then
		t17[12] = 350
	end

	for k, descendant in pairs(handlers[35].Character:GetDescendants()) do
		local t26 = {
			[2] = k,
			[3] = descendant
		}

		if t26[3]:IsA("BasePart") and t26[3].CanCollide then
			t26[3].CanCollide = false
		end
	end

	t17[8] = t17[6] / t17[12]
	t17[2] = TweenInfo.new(t17[8], Enum.EasingStyle.Linear)
	t17[5] = {
		CFrame = t17[10]
	}
	handlers[47] = game:GetService("TweenService"):Create(t17[9], t17[2], t17[5])
	handlers[47]:Play()
end
handlers[14] = function()
	if God_Human_C_M then
		for k, v in pairs(({ (game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) })[1]) do
			local t27 = {
				k,
				[3] = v
			}

			if t27[3].Type == "Sword" then
				if t27[3].Name == "Tushita" and t27[3].Mastery >= 400 then
					Tushita_M = true
				elseif t27[3].Name == "Yama" and t27[3].Mastery >= 400 then
					Yama_M = true
				end
			end
		end

		if not Tushita_M then
			if not handlers[45].ffc(handlers[35].Backpack, "Tushita") and not handlers[45].ffc(handlers[35].Character, "Tushita") then
				handlers[7].Remotes.CommF_:InvokeServer("LoadItem", "Tushita")
			end
		elseif not Yama_M and not handlers[45].ffc(handlers[35].Backpack, "Yama") then
			if not handlers[45].ffc(handlers[35].Character, "Yama") then
				handlers[7].Remotes.CommF_:InvokeServer("LoadItem", "Yama")
			end
		end

		for k, child in pairs(handlers[35].Backpack:GetChildren()) do
			local t28 = {
				[2] = k,
				child
			}

			if t28[1]:IsA("Tool") and tostring(t28[1].ToolTip) == "Sword" then
				handlers[35].Character:WaitForChild("Humanoid"):EquipTool(t28[1])
			end
		end
	else
		for k, child in pairs(handlers[35].Backpack:GetChildren()) do
			local t29 = {
				[2] = k,
				child
			}

			if t29[1]:IsA("Tool") and tostring(t29[1].ToolTip) == "Melee" then
				handlers[35].Character:WaitForChild("Humanoid"):EquipTool(t29[1])
			end
		end
	end
end
TPBoat = function(p27, p28, p29, p30)
	local t30 = {
		[3] = p27,
		[5] = p28,
		[4] = p29,
		[6] = p30
	}

	if t30[6] == nil then
		t30[6] = false
	end

	t30[1] = (t30[3].Position - t30[5].Position).Magnitude
	Speed = t30[4]
	TweenP = game:GetService("TweenService"):Create(t30[5], TweenInfo.new(t30[1] / Speed, Enum.EasingStyle.Linear), {
		CFrame = t30[3]
	})

	if t30[6] == true then
		TweenP:Cancel()
	else
		TweenP:Play()
	end
end
setmetatable(handlers[45], {
	__index = function(p31, p32)
		local t31 = {
			[2] = p31,
			[3] = p32
		}

		if t31[3] == "wt" then
			return function(p33)
				return task.wait(({
					[2] = p33
				})[2])
			end
		end

		if t31[3] == "p" then
			return function(...)
				return pcall(...)
			end
		end

		if t31[3] == "sf" then
			return function(p34, p35)
				local t32 = {
					[2] = p34,
					[3] = p35
				}

				return string.find(t32[2], tostring(t32[3]))
			end
		end

		if t31[3] == "cf" then
			return function(...)
				handlers[35].Character.HumanoidRootPart.Remotes.CommF_:InvokeServer(...)
			end
		end

		if t31[3] == "ffc" then
			return function(p36, p37)
				local t33 = {
					[3] = p36,
					[2] = p37
				}
				local v142 = t33[3]

				return v142 and t33[3]:FindFirstChild(t33[2])
			end
		end

		if t31[3] == "Equip" then
			return function(p38)
				local t34 = {
					[2] = p38
				}

				if t34[2] then
					if type(t34[2]) == "string" then
						for k, child in pairs(handlers[35].Backpack:GetChildren()) do
							local t35 = {
								[3] = k,
								[2] = child
							}

							if t35[2]:IsA("Tool") and t35[2].Name == t34[2] then
								handlers[35].Character:WaitForChild("Humanoid"):EquipTool(t35[2])
							end
						end

						return
					end
				end
			end
		end

		if t31[3] == "gi" then
			return function(p39)
				local t36 = {
					[2] = p39
				}

				if not handlers[45].ffc(handlers[35].Backpack, t36[2]) then
					if not handlers[45].ffc(handlers[35].Character, t36[2]) then
						for k, v in pairs(handlers[7].Remotes.CommF_:InvokeServer("getInventoryWeapons")) do
							if ({
								[2] = k,
								v
							})[1].Name == t36[2] then
								return true
							end
						end

						return false
					end
				end

				return true
			end
		end

		if t31[3] == "tf" then
			return function(p40, p41)
				local t37 = {
					[3] = p40,
					p41
				}

				return table.find(t37[3], t37[1])
			end
		end

		if t31[3] == "CheckBoss" then
			return function(p42)
				local t38 = { p42 }

				if handlers[45].ffc(handlers[7], t38[1]) or handlers[45].ffc(handlers[40], t38[1]) then
					return true
				end

				return false
			end
		end

		if t31[3] == "IsHall" then
			return function()
				if handlers[45].ffc(handlers[19].Map, "IceCastle") and handlers[45].ffc(handlers[19].Map.IceCastle.Hall.LibraryDoor, "Keyhole") then
					return true
				end

				return false
			end
		end

		if t31[3] == "CheckBackpack" then
			return function(p43)
				local t39 = { p43 }

				if handlers[45].ffc(handlers[35].Backpack, t39[1]) or handlers[45].ffc(handlers[35].Character, t39[1]) then
					return true
				end

				return false
			end
		end

		if t31[3] == "GetMobRaid" then
			return function()
				local t40 = {
					[2] = {}
				}

				for k, child in pairs(handlers[40]:GetChildren()) do
					local t41 = {
						k,
						child
					}

					if t41[2]:FindFirstChild("HumanoidRootPart") then
						if t41[2]:FindFirstChild("Humanoid") and t41[2].Humanoid.Health > 0 and (handlers[35].Character.HumanoidRootPart.Position - t41[2].HumanoidRootPart.Position).Magnitude <= 5000 then
							table.insert(t40[2], t41[2])
						end
					end
				end

				return t40[2]
			end
		end

		if t31[3] == "GetFruits" then
			return function()
				local t42 = {
					[2] = {}
				}

				for k, v in pairs(handlers[7].Remotes.CommF_:InvokeServer("getInventory")) do
					local t43 = {
						[3] = k,
						v
					}

					if t43[1].Type == "Blox Fruit" and t43[1].Value <= 999999 then
						table.insert(t42[2], {
							Name = t43[1].Name,
							Value = t43[1].Value
						})
					end
				end

				return t42[2]
			end
		end

		if t31[3] == "GetRaid" then
			return function(p44, p45)
				local t44 = {
					[3] = p44,
					p45
				}

				for k, child in pairs(handlers[19]._WorldOrigin.Locations:GetChildren()) do
					local t45 = {
						k,
						child
					}

					if not t45[2]:IsA("Part") then
						if not t45[2]:IsA("BasePart") then
							continue
						end
					end

					if t45[2].Name == t44[3] and (t45[2].Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= t44[1] then
						return t45[2]
					end
				end

				return nil
			end
		end

		if t31[3] == "GetType" then
			return function()
				local t46 = { {} }

				for k, v in pairs(handlers[7].Remotes.CommF_:InvokeServer("getInventory")) do
					local t47 = {
						[2] = k,
						[3] = v
					}

					if t47[3].Type == "Blox Fruit" then
						table.insert(t46[1], t47[3].Name)
					end
				end

				return t46[1]
			end
		end

		if t31[3] == "IsInList" then
			return function(p46, p47)
				local t48 = {
					[3] = p46,
					[2] = p47
				}

				for k, v in pairs(t48[3]) do
					if ({
						[2] = k,
						[3] = v
					})[3] == t48[2] then
						return true
					end
				end

				return false
			end
		end

		if t31[3] == "IsHeavenly" then
			return function()
				for k, v in pairs(handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("getTitles")) do
					if ({
						k,
						[3] = v
					})[3].Name == "Heavenly Devil" then
						return true
					end
				end

				return false
			end
		end

		if t31[3] == "GetMonster" then
			return function(p48)
				local t49 = {
					[2] = p48
				}

				pcall(function()
					for k, child in pairs(handlers[40]:GetChildren()) do
						local t50 = {
							[3] = k,
							child
						}

						if not t50[1]:IsA("Model") then
							continue
						end

						if not t50[1]:FindFirstChild("Humanoid") or not (t50[1].Humanoid.Health > 0) or not ((t50[1].HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= t49[2]) then
							continue
						end

						Monster = t50[1]

						return
					end
				end)
			end
		end

		if t31[3] == "GetMon_Soul" then
			return function()
				local children, v179 = game:GetService("Workspace").Enemies:GetChildren()

				for k, v in next, children, v179 do
					local t51 = {
						[3] = k,
						[2] = v
					}

					if t51[2].Name == "Living Zombie" then
						table.insert(get_mon, t51[2].Name)
					end
				end
			end
		end

		if t31[3] == "click" then
			return function(p49)
				local t52 = { p49 }

				handlers[2]:SendMouseButtonEvent(t52[1].AbsolutePosition.X + t52[1].AbsoluteSize.X / 2, t52[1].AbsolutePosition.Y + 90, 0, true, t52[1], 1)
				handlers[2]:SendMouseButtonEvent(t52[1].AbsolutePosition.X + t52[1].AbsoluteSize.X / 2, t52[1].AbsolutePosition.Y + 90, 0, false, t52[1], 1)
			end
		end

		if t31[3] == "HopLowServer" then
			return function(p50)
				local t53 = { p50 }

				pcall(function()
					if not t53[1] then
						t53[1] = 10
					end

					ticklon = tick()

					repeat
						task.wait()
					until tick() - ticklon >= 1

					local handlers2 = {
						function()
							for i = 1, math.huge do
								local t54 = {
									[2] = i
								}

								if ChooseRegion == nil or ChooseRegion == "" then
									ChooseRegion = "Singapore"
								else
									game:GetService("Players").LocalPlayer.PlayerGui.ServerBrowser.Frame.Filters.SearchRegion.TextBox.Text = ChooseRegion
								end

								t54[1] = game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer(t54[2])

								for k, v in pairs(t54[1]) do
									local t55 = {
										[2] = k,
										[3] = v
									}

									if t55[2] ~= game.JobId and t55[3].Count < t53[1] then
										game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", t55[2])
									end
								end
							end

							return false
						end
					}

					if not getgenv().Loaded then
						local handlers3 = { function(p51)
							local t56 = { p51 }

							if t56[1].Name == "ErrorPrompt" then
								if t56[1].Visible and t56[1].TitleFrame.ErrorTitle.Text == "Teleport Failed" then
									HopLowServer()
									t56[1].Visible = false
								end

								t56[1]:GetPropertyChangedSignal("Visible"):Connect(function()
									if t56[1].Visible and t56[1].TitleFrame.ErrorTitle.Text == "Teleport Failed" then
										HopLowServer()
										t56[1].Visible = false
									end
								end)
							end
						end }

						for k, child in pairs(game.CoreGui.RobloxPromptGui.promptOverlay:GetChildren()) do
							handlers3[1](({
								[3] = k,
								child
							})[1])
						end

						game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(handlers3[1])
						getgenv().Loaded = true
					end

					while task.wait(0.1) do
						handlers2[1]()
					end
				end)
			end
		end

		if t31[3] == "CheckItem" then
			return function(p52)
				local t57 = {
					[2] = p52
				}

				for k, v in pairs(handlers[7].Remotes.CommF_:InvokeServer("getInventory")) do
					local t58 = {
						[2] = k,
						[3] = v
					}

					if type(t58[3]) == "table" and t58[3].Type == "Material" and t58[3].Name == t57[2] then
						return t58[3].Count
					end
				end

				return 0
			end
		end

		if t31[3] == "FarmBone" then
			return function(p53)
				if not ({ p53 })[1] then
					if handlers[45].ffc(handlers[40], "Demonic Soul") or handlers[45].ffc(handlers[40], "Posessed Mummy") or handlers[45].ffc(handlers[40], "Reborn Skeleton") or handlers[45].ffc(handlers[40], "Living Zombie") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t59 = {
								k,
								child
							}

							if t59[2].Name == "Reborn Skeleton" or t59[2].Name == "Living Zombie" or t59[2].Name == "Demonic Soul" or t59[2].Name == "Posessed Mummy" then
								if t59[2]:FindFirstChild("HumanoidRootPart") then
									if t59[2]:FindFirstChild("Humanoid") and t59[2].Humanoid.Health > 0 then
										repeat
											handlers[45].wt(0.1)

											if handlers[45].CheckItem("Bones") > 500 then
												if handlers[7].Remotes.CommF_:InvokeServer("Bones", "Check") > 0 then
													repeat
														handlers[45].wt(0.2)
														handlers[7].Remotes.CommF_:InvokeServer("Bones", "Check")
														handlers[7].Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
													until handlers[7].Remotes.CommF_:InvokeServer("Bones", "Check") == 0
												end
											end

											if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
												handlers[35].Character.HumanoidRootPart.Remotes.CommF_:InvokeServer("Buso")
											end

											handlers[31](t59[2].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5, 200)
											handlers[14]()
											handlers[45].BN(t59[2].Name)
										until not t59[2].Parent or t59[2].Humanoid.Health <= 0
									end
								end
							end
						end
					else
						handlers[31](CFrame.new(-9505.8720703125, 172.10482788086, 6158.9931640625), 1.5)
					end
				elseif handlers[45].ffc(handlers[35].Backpack, "Fire Essence") or handlers[45].ffc(handlers[35].Character, "Fire Essence") then
					while true do
						handlers[45].Status(handlers[3]({
							" Status : Use Fire E",
							"ssence"
						}))
						handlers[45].Equip("Fire Essence")
						handlers[45].wt(0.5)
						handlers[7].Remotes.CommF_:InvokeServer("BuyDragonTalon", true)
						handlers[7].Remotes.CommF_:InvokeServer("BuyDragonTalon")

						if handlers[45].ffc(handlers[35].Backpack, "Fire Essence") then
							continue
						end

						if not handlers[45].ffc(handlers[35].Character, "Fire Essence") then
							break
						end
					end

					handlers[7].Remotes.CommF_:InvokeServer("BuyDragonTalon")
					Dragon_Talon_C = true
				elseif handlers[45].ffc(handlers[40], "Demonic Soul") or handlers[45].ffc(handlers[40], "Posessed Mummy") or handlers[45].ffc(handlers[40], "Reborn Skeleton") or handlers[45].ffc(handlers[40], "Living Zombie") then
					for k, child in pairs(handlers[40]:GetChildren()) do
						local t60 = {
							[3] = k,
							child
						}

						if t60[1].Name == "Reborn Skeleton" or t60[1].Name == "Living Zombie" or t60[1].Name == "Demonic Soul" or t60[1].Name == "Posessed Mummy" then
							if t60[1]:FindFirstChild("HumanoidRootPart") then
								if t60[1]:FindFirstChild("Humanoid") and t60[1].Humanoid.Health > 0 then
									repeat
										handlers[45].wt(0.1)

										if handlers[45].CheckItem("Bones") > 500 then
											if handlers[7].Remotes.CommF_:InvokeServer("Bones", "Check") > 0 then
												repeat
													handlers[45].wt(0.2)
													handlers[7].Remotes.CommF_:InvokeServer("Bones", "Check")
													handlers[7].Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
												until handlers[7].Remotes.CommF_:InvokeServer("Bones", "Check") == 0
											end
										end

										if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
											handlers[35].Character.HumanoidRootPart.Remotes.CommF_:InvokeServer("Buso")
										end

										handlers[31](t60[1].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5, 200)
										handlers[14]()
										handlers[45].BN(t60[1].Name)
									until not t60[1].Parent or t60[1].Humanoid.Health <= 0
								end
							end
						end
					end
				else
					handlers[31](CFrame.new(-9505.8720703125, 172.10482788086, 6158.9931640625), 1.5)
				end
			end
		end

		if t31[3] == "Get_Item_Inventory" then
			return function(p54)
				local t61 = {
					[2] = p54
				}

				if not handlers[45].ffc(handlers[35].Backpack, t61[2]) and not handlers[45].ffc(handlers[35].Character, t61[2]) then
					handlers[7].Remotes.CommF_:InvokeServer("LoadItem", tostring(t61[2]))
				end
			end
		end

		if t31[3] == "BN" then
			return function(p55)
				local t62 = {
					[2] = p55
				}

				pcall(function()
					local t63 = {
						[3] = game.Players.LocalPlayer
					}

					t63[2] = t63[3].Character and t63[3].Character:FindFirstChild("HumanoidRootPart")

					if not t63[2] then
						return
					end

					for k, child in pairs(game.Workspace.Enemies:GetChildren()) do
						local t64 = {
							[2] = k,
							[3] = child
						}

						if t64[3]:IsA("Model") and t64[3].Name == t62[2] then
							if t64[3]:FindFirstChild("Humanoid") then
								if t64[3]:FindFirstChild("HumanoidRootPart") then
									local t65 = {
										[3] = t64[3].Humanoid,
										[2] = t64[3].HumanoidRootPart
									}

									if t65[3].Health > 0 and (t65[2].Position - t63[2].Position).Magnitude <= 350 then
										local t66 = {
											[2] = nil
										}

										for k2, child2 in pairs(game.Workspace.Enemies:GetChildren()) do
											local t67 = {
												k2,
												child2
											}

											if t67[2] ~= t64[3] then
												if t67[2]:IsA("Model") and t67[2].Name == t62[2] then
													if t67[2]:FindFirstChild("HumanoidRootPart") then
														t66[2] = t67[2].HumanoidRootPart

														break
													end
												end
											end
										end

										if t66[2] then
											local t68 = { (Instance.new("BodyPosition")) }

											t68[1].Position = t66[2].Position + Vector3.new(0, 0, 0)
											t68[1].MaxForce = Vector3.new(1000000, 1000000, 1000000)
											t68[1].P = 3000
											t68[1].D = 100
											t68[1].Name = "EnemyFlyPosition"
											t68[1].Parent = t65[2]
										end

										t65[2].CanCollide = false
										t65[3]:ChangeState(14)
										t65[3].WalkSpeed = 0

										if t65[3]:FindFirstChild("Animator") then
											t65[3].Animator:Destroy()
										end

										for k2, descendant in pairs(t64[3]:GetDescendants()) do
											local t69 = {
												[2] = k2,
												[3] = descendant
											}

											if t69[3]:IsA("BasePart") then
												t69[3].CanCollide = false
												t69[3].CanTouch = false
												t69[3].CanQuery = false
											end
										end

										if t64[3]:FindFirstChild("Head") then
											t64[3].Head.CanCollide = false
										end
									end
								end
							end
						end
					end

					sethiddenproperty(t63[3], "SimulationRadius", math.huge)
				end)
			end
		end

		if t31[3] == "Status" then
			return function(p56)
				handlers[26].Text = ({
					[2] = p56
				})[2]
			end
		end

		if t31[3] == "GetQuest" then
			return function(p57)
				local t70 = { p57 }

				if (Vector3.new(-12379.1406, 601.433167, -6543.60742) - handlers[35].Character.HumanoidRootPart.Position).Magnitude > 30 then
					handlers[31](CFrame.new(-12379.1406, 601.433167, -6543.60742), 1.5)
				elseif (Vector3.new(-12379.1406, 601.433167, -6543.60742) - handlers[35].Character.HumanoidRootPart.Position).Magnitude < 30 then
					if t70[1] == "Good" then
						repeat
							wait(0.1)
							handlers[31](CFrame.new(-12392.5068, 603.319763, -6596.00586), 1.5)
						until (Vector3.new(-12392.5068, 603.319763, -6596.00586) - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3

						wait(1)
						handlers[7].Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Good")
						wait(1)
						handlers[7].Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Good")
					elseif t70[1] == "Evil" then
						repeat
							wait(0.1)
							handlers[31](CFrame.new(-12392.2637, 603.319763, -6503.27832), 1.5)
						until (Vector3.new(-12392.2637, 603.319763, -6503.27832) - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3

						wait(1)
						handlers[7].Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Evil")
						wait(1)
						handlers[7].Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Evil")
					end
				end
			end
		end

		if t31[3] == "GetTorch" then
			return function(p58)
				local t71 = {
					[2] = p58
				}

				repeat
					wait()
					handlers[31](handlers[19].Map.HeavenlyDimension[t71[2]].CFrame, 1.5)
				until (handlers[19].Map.HeavenlyDimension[t71[2]].Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 7

				fireproximityprompt(workspace.Map.HeavenlyDimension[t71[2]].ProximityPrompt)
				wait(0.5)
			end
		end

		if t31[3] == "GetTorchX" then
			return function(p59)
				local t72 = { p59 }

				repeat
					wait()
					handlers[31](handlers[19].Map.HellDimension[t72[1]].CFrame, 1.5)
				until (handlers[19].Map.HellDimension[t72[1]].Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 7

				fireproximityprompt(workspace.Map.HellDimension[t72[1]].ProximityPrompt)
				wait(0.5)
			end
		end
	end
})
handlers[27] = game:GetService("Players")
handlers[46] = game:GetService("ReplicatedStorage")
handlers[25] = game:GetService("Workspace")
handlers[34] = {}
handlers[34].__index = handlers[34]
handlers[51] = handlers[27].LocalPlayer
task.spawn(function()
	while task.wait(0.5) do
		handlers[45].p(function()
			if handlers[35].Data.Points.Value > 0 and handlers[35].Data.Stats.Melee.Level.Value < 2650 then
				handlers[46].Remotes.CommF_:InvokeServer("AddPoint", "Melee", handlers[35].Data.Points.Value)
			end

			if handlers[35].Data.Stats.Melee.Level.Value >= 2650 and handlers[35].Data.Points.Value > 0 and handlers[35].Data.Stats.Defense.Level.Value < 2550 then
				handlers[46].Remotes.CommF_:InvokeServer("AddPoint", "Defense", handlers[35].Data.Points.Value)
			end

			if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
				handlers[46].Remotes.CommF_:InvokeServer("Buso")
			end
		end)
	end
end)
getgenv()["Fast Attack"] = true
handlers[20] = 0
task.spawn(function()
	while task.wait(handlers[20]) do
		if getgenv()["Fast Attack"] and not Stop_Fast_Attack then
			if handlers[45].sf(handlers[35].PlayerGui.Main.Version.Text, "v26.6.1") then
				xpcall(function()
					if (handlers[51].Character or handlers[51].CharacterAdded:Wait()):FindFirstChildOfClass("Tool") then
						if (handlers[51].Character or handlers[51].CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid") then
							if (handlers[51].Character or handlers[51].CharacterAdded:Wait()).Humanoid.Health > 0 then
								for k, child in pairs(handlers[25].Enemies:GetChildren()) do
									local t73 = {
										k,
										[3] = child
									}

									if t73[3]:FindFirstChildOfClass("Humanoid") and t73[3].Humanoid.Health > 0 then
										if t73[3]:FindFirstChild("HumanoidRootPart") and (t73[3].HumanoidRootPart.Position - handlers[51].Character.HumanoidRootPart.Position).Magnitude <= 60 then
											local t74 = {}

											if (handlers[51].Character or handlers[51].CharacterAdded:Wait()):FindFirstChild("Stun") then
												(handlers[51].Character or handlers[51].CharacterAdded:Wait()).Stun.Value = 0
											end

											if (handlers[51].Character or handlers[51].CharacterAdded:Wait()):FindFirstChild("Busy") then
												(handlers[51].Character or handlers[51].CharacterAdded:Wait()).Busy.Value = false
											end

											if t73[3]:FindFirstChild("Stun") then
												t73[3].Stun.Value = 0
											end

											if t73[3]:FindFirstChild("Busy") then
												t73[3].Busy.Value = false
											end

											if handlers[7].Modules.Net:FindFirstChild("RE") then
												if handlers[7].Modules.Net.RE:FindFirstChild("RegisterHit") then
													handlers[7].Modules.Net.RE.RegisterHit:SetAttribute("Virtual", not handlers[7].Modules.Net.RE.RegisterHit:GetAttribute("Virtual"))
												end
											end

											if handlers[51].Character then
												handlers[51].Character:SetAttribute("Clashable", not handlers[51].Character:GetAttribute("Clashable"))
											end

											t74[2] = 0

											for k2, child2 in pairs(handlers[25].Enemies:GetChildren()) do
												local t75 = {
													k2,
													[3] = child2
												}

												if t75[3]:FindFirstChildOfClass("Humanoid") and t75[3].Humanoid.Health > 0 then
													if t75[3]:FindFirstChild("HumanoidRootPart") and (t75[3].HumanoidRootPart.Position - handlers[51].Character.HumanoidRootPart.Position).Magnitude <= 60 then
														t74[2] += 1

														if t74[2] > 5 then
															handlers[20] = 0.1
														elseif t74[2] > 2 and t74[2] <= 5 then
															handlers[20] = 0.03
														else
															handlers[20] = 0
														end

														handlers[48]:RemoteEvent("RegisterAttack"):FireServer(math.huge)
														handlers[48]:RemoteEvent("RegisterHit", true):FireServer(t75[3].Head, {
															{
																t75[3],
																t75[3].Head
															},
															t75[3].Head
														}, nil, tostring(handlers[51].UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15))
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end, warn)
			else
				local handlers2 = {}

				assert(getrenv, handlers[3]({
					"Exploit not supporte",
					"d"
				}))
				handlers2[11] = game:GetService("CollectionService")
				handlers2[2] = game:GetService("ReplicatedStorage")
				handlers2[8] = game:GetService("Players")
				handlers2[6] = handlers2[8].LocalPlayer
				handlers2[3] = debug.getupvalue(getrenv()._G.SendHitsToServer, 1)
				handlers2[5] = handlers2[2].Modules.Net["RE/RegisterAttack"]

				local function v231()
					local t76 = {
						[3] = handlers2[11]:GetTagged("BasicMob")
					}

					if #t76[3] == 0 then
						return nil
					end

					t76[4] = {}
					t76[2] = handlers2[6].Character and handlers2[6].Character.PrimaryPart.Position

					if not t76[2] then
						return nil
					end

					for k, v in pairs(t76[3]) do
						local t77 = {
							k,
							[4] = v
						}

						t77[5] = t77[4]:FindFirstChildOfClass("Humanoid")
						t77[3] = t77[4].PrimaryPart

						if t77[5] and t77[5].Health > 0 and t77[3] then
							local t78 = { (t77[3].Position - t76[2]).Magnitude }

							if t78[1] <= 100 then
								t76[4][#t76[4] + 1] = {
									mob = t77[4],
									distance = t78[1]
								}
							end
						end
					end

					if #t76[4] == 0 then
						return nil
					end

					table.sort(t76[4], function(p60, p61)
						local t79 = {
							p60,
							p61
						}

						return t79[1].distance < t79[2].distance
					end)

					return #t76[4] > 2 and {
						t76[4][1],
						t76[4][2]
					} or t76[4]
				end

				handlers2[4] = v231
				handlers2[1] = function()
					local t80 = {
						[3] = handlers2[4]()
					}

					if not t80[3] then
						return
					end

					t80[2] = {}

					for k, v in pairs(t80[3]) do
						local t81 = {
							[4] = k,
							[2] = v
						}

						t81[1] = t81[2].mob:FindFirstChild("HumanoidRootPart")

						if t81[1] then
							t80[2][#t80[2] + 1] = {
								t81[2].mob,
								t81[1]
							}
						end
					end

					if #t80[2] > 0 then
						handlers2[5]:FireServer((0/0))
						coroutine.resume(handlers2[3], t80[2][1][2], { table.unpack(t80[2], 2) })
					end
				end

				local ok, result = pcall(function()
					handlers2[1]()
				end)

				handlers2[7] = ok
				handlers2[9] = result

				if not handlers2[7] then
					warn(handlers[3]({
						"Error in Combat scri",
						"pt: "
					}) .. tostring(handlers2[9]))
				end
			end
		end
	end
end)

for k, v in pairs(handlers[7].Remotes.CommF_:InvokeServer("getInventory")) do
	local t82 = {
		k,
		[3] = v
	}

	if t82[3].Type == "Material" and t82[3].Name == "Mirror Fractal" then
		Mirror_Fractal_H = true
	end
end

handlers[35].PlayerGui.Notifications.Enabled = false

if handlers[7]:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/FruitCustomizerRF"):InvokeServer({
	StorageName = "Pure Red",
	Type = "AuraSkin",
	Context = "Equip"
}) ~= false then
	Pure_Red_H = true
end

if handlers[7]:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/FruitCustomizerRF"):InvokeServer({
	StorageName = "Snow White",
	Type = "AuraSkin",
	Context = "Equip"
}) ~= false then
	Snow_White = true
end

if handlers[7]:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/FruitCustomizerRF"):InvokeServer({
	StorageName = "Snow White",
	Type = "AuraSkin",
	Context = "Equip"
}) ~= false then
	Winter_Sky = true
end

if handlers[7]:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/FruitCustomizerRF"):InvokeServer({
	StorageName = "Rainbow Saviour",
	Type = "AuraSkin",
	Context = "Equip"
}) ~= false then
	Rainbow_Saviour = true
end

if Three_World then
	if handlers[7].Remotes.CommF_:InvokeServer("TushitaProgress").OpenedDoor then
		Unlock_Tushita_Quest = true
	end
end

handlers[39] = function()
	local spilled = {}
	local _
	local state = 1
	local forIter, forState, forControl, forIter2, forState2, forControl2, forIter3, forState3, forControl3, forIter4
	local forState4, forControl4, forIter5, forState5, forControl5, forIter6, forState6, forControl6, forIter7, forState7
	local forControl7, forIter8, forState8, forControl8, forIter9, forState9, forControl9, forIndex, forLimit, forStep
	local forIndex2, forLimit2, forStep2, forIndex3, forLimit3, forStep3, forIter10, forState10, forControl10, forIter11
	local forState11, forControl11, forIter12, forState12, forControl12, forIter13, forState13, forControl13, v303, v304
	local forIndex4, forLimit4, forStep4, forIndex5, forLimit5, forStep5, forIndex6, forLimit6, forStep6, forIndex7
	local forLimit7, forStep7, forIter14, forState14, forControl14, forIter15, forState15, forControl15, forIter16, forState16
	local forControl16, forIter17, forState17, forControl17, forIter18, forState18, forControl18, forIter19, forState19, forControl19
	local forIter20, forState20, forControl20, forIter21, forState21, forControl21, forIter22, forState22, forControl22, forIter23
	local forState23, forControl23, forIter24, forState24, forControl24

	do
		local t83, v351, v352, t84, v354, v355, t85, v357, v358, t86, v360, v361, v362, v363, v364, v365, v366, v367, t87, v369, v370, t88, v372, v373, t89, t90, v376, v377, v378, v379, v380, t91, v382, v383, v384, v385, t92, v387, v388, t93, v390, v391, v392, v393, t94, v395, v396, v397, t95, v399, v400, t96, v402, v403, t97, v405, v406, t98, v408, v409, t99, v411, v412, t100, v414, v415, t101, v417, v418, t102, v420, v421, t103, v423, v424, t104

		while true do
			if state <= 6 then
				if state == 1 then
					t83 = {}

					if Three_World then
						state = 2
					else
						state = 5
					end
				elseif state == 2 then
					if tostring(string.match(tostring(handlers[7].Remotes.CommF_:InvokeServer("CakePrinceSpawner")), "%d+")) == "nil" then
						state = 4
					else
						state = 3
					end
				elseif state == 3 then
					if tostring(string.match(tostring(handlers[7].Remotes.CommF_:InvokeServer("CakePrinceSpawner")), "%d+")) == nil then
						state = 4
					else
						state = 5
					end
				elseif state == 4 then
					handlers[7].Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
					state = 5
				elseif state == 5 then
					if Three_World and (handlers[45].ffc(handlers[40], "Cake Prince") or handlers[45].ffc(handlers[7], "Cake Prince")) then
						state = 6
					else
						state = 24
					end
				elseif state == 6 then
					if handlers[45].ffc(handlers[40], "Cake Prince") then
						state = 7
					else
						state = 16
					end
				end
			elseif state <= 12 then
				if state == 7 then
					state = 8
				elseif state == 8 then
					forIter, forState, forControl = pairs(handlers[40]:GetChildren())

					if type(forIter) == 'table' then
						spilled.forMeta = getmetatable(forIter)

						if type(spilled.forMeta) == 'table' and spilled.forMeta['__iter'] then
							forIter, forState, forControl = (spilled.forMeta['__iter'](forIter))
						else
							forIter, forState, forControl = next, forIter, nil
						end
					end

					state = 9
				elseif state == 9 then
					v351, v352 = (forIter(forState, forControl))

					if v351 == nil then
						state = 24
					else
						forControl = v351
						state = 10
					end
				elseif state == 10 then
					t84 = {
						[2] = v351,
						[3] = v352
					}

					if t84[3].Name == "Cake Prince" then
						state = 11
					else
						state = 9
					end
				elseif state == 11 then
					if t84[3].Humanoid.Health > 0 then
						state = 12
					else
						state = 9
					end
				elseif state == 12 then
					handlers[45].wt()

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 14
					else
						state = 13
					end
				end
			elseif state <= 18 then
				if state == 13 then
					handlers[35].Character.HumanoidRootPart.Remotes.CommF_:InvokeServer("Buso")
					state = 14
				elseif state == 14 then
					handlers[31](t84[3].HumanoidRootPart.CFrame * CFrame.new(0, -30, 0), 1.5)
					handlers[14]()

					if t84[3].Parent then
						state = 15
					else
						state = 9
					end
				elseif state == 15 then
					if not (t84[3].Humanoid.Health <= 0) and getgenv().AutoFarm then
						state = 12
					else
						state = 9
					end
				elseif state == 16 then
					if handlers[45].ffc(handlers[7], "Cake Prince") then
						state = 17
					else
						state = 24
					end
				elseif state == 17 then
					state = 18
				elseif state == 18 then
					forIter2, forState2, forControl2 = pairs(handlers[7]:GetChildren())

					if type(forIter2) == 'table' then
						spilled.forMeta2 = getmetatable(forIter2)

						if type(spilled.forMeta2) == 'table' and spilled.forMeta2['__iter'] then
							forIter2, forState2, forControl2 = (spilled.forMeta2['__iter'](forIter2))
						else
							forIter2, forState2, forControl2 = next, forIter2, nil
						end
					end

					state = 19
				end
			elseif state <= 24 then
				if state == 19 then
					v354, v355 = (forIter2(forState2, forControl2))

					if v354 == nil then
						state = 24
					else
						forControl2 = v354
						state = 20
					end
				elseif state == 20 then
					t85 = {
						v354,
						[3] = v355
					}

					if t85[3].Name == "Cake Prince" and t85[3].Humanoid.Health > 0 then
						state = 21
					else
						state = 19
					end
				elseif state == 21 then
					handlers[45].wt()

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 23
					else
						state = 22
					end
				elseif state == 22 then
					handlers[35].Character.HumanoidRootPart.Remotes.CommF_:InvokeServer("Buso")
					state = 23
				elseif state == 23 then
					handlers[31](t85[3].HumanoidRootPart.CFrame * CFrame.new(0, -30, 0), 1.5)
					handlers[14]()

					if t85[3].Parent and not (t85[3].Humanoid.Health <= 0) and getgenv().AutoFarm then
						state = 21
					else
						state = 19
					end
				elseif state == 24 then
					if Three_World then
						state = 25
					else
						state = 132
					end
				end
			elseif state <= 30 then
				if state == 25 then
					if handlers[40]:FindFirstChild("rip_indra True Form") then
						state = 27
					else
						state = 26
					end
				elseif state == 26 then
					if handlers[7]:FindFirstChild("rip_indra True Form") then
						state = 27
					else
						state = 132
					end
				elseif state == 27 then
					if handlers[7].Remotes.CommF_:InvokeServer("TushitaProgress").OpenedDoor then
						state = 28
					else
						state = 102
					end
				elseif state == 28 then
					if handlers[40]:FindFirstChild("rip_indra True Form") then
						state = 30
					else
						state = 29
					end
				elseif state == 29 then
					if handlers[7]:FindFirstChild("rip_indra True Form") then
						state = 30
					else
						state = 40
					end
				elseif state == 30 then
					if handlers[40]:FindFirstChild("rip_indra True Form") then
						state = 31
					else
						state = 38
					end
				end
			elseif state <= 36 then
				if state == 31 then
					state = 32
				elseif state == 32 then
					forIter3, forState3, forControl3 = pairs(handlers[40]:GetChildren())

					if type(forIter3) == 'table' then
						spilled.forMeta3 = getmetatable(forIter3)

						if type(spilled.forMeta3) == 'table' and spilled.forMeta3['__iter'] then
							forIter3, forState3, forControl3 = (spilled.forMeta3['__iter'](forIter3))
						else
							forIter3, forState3, forControl3 = next, forIter3, nil
						end
					end

					state = 33
				elseif state == 33 then
					v357, v358 = (forIter3(forState3, forControl3))

					if v357 == nil then
						state = 132
					else
						forControl3 = v357
						state = 34
					end
				elseif state == 34 then
					t86 = {
						[3] = v357,
						v358
					}

					if t86[1].Name == "rip_indra True Form" and t86[1].Humanoid.Health > 0 then
						state = 35
					else
						state = 33
					end
				elseif state == 35 then
					handlers[45].wt(0.1)

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 37
					else
						state = 36
					end
				elseif state == 36 then
					handlers[35].Character.HumanoidRootPart.Remotes.CommF_:InvokeServer("Buso")
					state = 37
				end
			elseif state <= 42 then
				if state == 37 then
					handlers[31](t86[1].HumanoidRootPart.CFrame * CFrame.new(0, -30, 0), 1.5)
					handlers[14]()

					if not t86[1].Parent or t86[1].Humanoid.Health <= 0 then
						state = 33
					else
						state = 35
					end
				elseif state == 38 then
					if handlers[7]:FindFirstChild("rip_indra True Form") then
						state = 39
					else
						state = 132
					end
				elseif state == 39 then
					handlers[31](handlers[7]:FindFirstChild("rip_indra True Form").HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
					state = 132
				elseif state == 40 then
					if handlers[35].Backpack:FindFirstChild("God's Chalice") then
						state = 42
					else
						state = 41
					end
				elseif state == 41 then
					if handlers[35].Character:FindFirstChild("God's Chalice") then
						state = 42
					else
						state = 132
					end
				elseif state == 42 then
					handlers[45].wt(0.1)
					Oyster_H = false
					Hot_pink_H = false
					Really_red_H = false
					state = 43
				end
			elseif state <= 48 then
				if state == 43 then
					forIter4, forState4, forControl4 = pairs(handlers[19].Map["Boat Castle"].Summoner.Circle:GetChildren())

					if type(forIter4) == 'table' then
						spilled.forMeta4 = getmetatable(forIter4)

						if type(spilled.forMeta4) == 'table' and spilled.forMeta4['__iter'] then
							forIter4, forState4, forControl4 = (spilled.forMeta4['__iter'](forIter4))
						else
							forIter4, forState4, forControl4 = next, forIter4, nil
						end
					end

					state = 44
				elseif state == 44 then
					v360, v361 = (forIter4(forState4, forControl4))

					if v360 == nil then
						state = 45
					else
						forControl4 = v360
						state = 100
					end
				elseif state == 45 then
					state = 46
				elseif state == 46 then
					forIter5, forState5, forControl5 = pairs(handlers[19].Map["Boat Castle"].Summoner.Circle:GetChildren())

					if type(forIter5) == 'table' then
						spilled.forMeta5 = getmetatable(forIter5)

						if type(spilled.forMeta5) == 'table' and spilled.forMeta5['__iter'] then
							forIter5, forState5, forControl5 = (spilled.forMeta5['__iter'](forIter5))
						else
							forIter5, forState5, forControl5 = next, forIter5, nil
						end
					end

					state = 47
				elseif state == 47 then
					v362, v363 = (forIter5(forState5, forControl5))

					if v362 == nil then
						state = 48
					else
						forControl5 = v362
						state = 98
					end
				elseif state == 48 then
					state = 49
				end
			elseif state <= 54 then
				if state == 49 then
					forIter6, forState6, forControl6 = pairs(handlers[19].Map["Boat Castle"].Summoner.Circle:GetChildren())

					if type(forIter6) == 'table' then
						spilled.forMeta6 = getmetatable(forIter6)

						if type(spilled.forMeta6) == 'table' and spilled.forMeta6['__iter'] then
							forIter6, forState6, forControl6 = (spilled.forMeta6['__iter'](forIter6))
						else
							forIter6, forState6, forControl6 = next, forIter6, nil
						end
					end

					state = 50
				elseif state == 50 then
					v364, v365 = (forIter6(forState6, forControl6))

					if v364 == nil then
						state = 51
					else
						forControl6 = v364
						state = 96
					end
				elseif state == 51 then
					if Oyster_H and Hot_pink_H and Really_red_H then
						state = 52
					else
						state = 54
					end
				elseif state == 52 then
					handlers[45].wt(0.1)
					handlers[45].Equip("God's Chalice")
					handlers[31](CFrame.new(-5561.06738, 314.375793, -2663.88892, -0.304127187, -0.00254100002, 0.952628076, 0.000226983335, 0.999996245, 0.00273981248, -0.952631414, 0.00104948215, -0.304125458), 1.5)

					if (Vector3.new(-5561.06738, 314.375793, -2663.88892) - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 5 then
						state = 53
					else
						state = 52
					end
				elseif state == 53 then
					handlers[45].wt(1)
					state = 94
				elseif state == 54 then
					if handlers[35].Backpack:FindFirstChild("God's Chalice") then
						state = 56
					else
						state = 55
					end
				end
			elseif state <= 60 then
				if state == 55 then
					if handlers[35].Character:FindFirstChild("God's Chalice") then
						state = 56
					else
						state = 94
					end
				elseif state == 56 then
					handlers[45].wt(0.1)
					handlers[14]()
					handlers[31](CFrame.new(-5561.06738, 314.375793, -2663.88892, -0.304127187, -0.00254100002, 0.952628076, 0.000226983335, 0.999996245, 0.00273981248, -0.952631414, 0.00104948215, -0.304125458), 1.5)

					if (Vector3.new(-5561.06738, 314.375793, -2663.88892) - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 5 then
						state = 57
					else
						state = 56
					end
				elseif state == 57 then
					if not Snow_White or Oyster_H then
						state = 67
					else
						state = 58
					end
				elseif state == 58 then
					state = 59
				elseif state == 59 then
					forIter7, forState7, forControl7 = pairs(handlers[19].Map["Boat Castle"].Summoner.Circle:GetChildren())

					if type(forIter7) == 'table' then
						spilled.forMeta7 = getmetatable(forIter7)

						if type(spilled.forMeta7) == 'table' and spilled.forMeta7['__iter'] then
							forIter7, forState7, forControl7 = (spilled.forMeta7['__iter'](forIter7))
						else
							forIter7, forState7, forControl7 = next, forIter7, nil
						end
					end

					state = 60
				elseif state == 60 then
					v366, v367 = (forIter7(forState7, forControl7))

					if v366 == nil then
						state = 67
					else
						forControl7 = v366
						state = 61
					end
				end
			elseif state <= 66 then
				if state == 61 then
					t87 = {
						[3] = v366,
						[2] = v367
					}

					if t87[2].Name == "Part" and tostring(t87[2].BrickColor) == "Oyster" and tostring(t87[2].Part.BrickColor) ~= "Lime green" then
						state = 62
					else
						state = 60
					end
				elseif state == 62 then
					handlers[7].Remotes.CommF_:InvokeServer("activateColor", "Snow White")
					handlers[45].wt(1)
					state = 63
				elseif state == 63 then
					handlers[45].wt()

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 65
					else
						state = 64
					end
				elseif state == 64 then
					handlers[35].Character.HumanoidRootPart.Remotes.CommF_:InvokeServer("Buso")
					state = 65
				elseif state == 65 then
					handlers[31](t87[2].Part.CFrame, 1.5)

					if tostring(t87[2].Part.BrickColor) == "Lime green" then
						state = 66
					else
						state = 63
					end
				elseif state == 66 then
					Oyster_H = true
					state = 60
				end
			elseif state <= 72 then
				if state == 67 then
					if not Pure_Red_H or Really_red_H then
						state = 82
					else
						state = 68
					end
				elseif state == 68 then
					state = 69
				elseif state == 69 then
					forIter8, forState8, forControl8 = pairs(handlers[19].Map["Boat Castle"].Summoner.Circle:GetChildren())

					if type(forIter8) == 'table' then
						spilled.forMeta8 = getmetatable(forIter8)

						if type(spilled.forMeta8) == 'table' and spilled.forMeta8['__iter'] then
							forIter8, forState8, forControl8 = (spilled.forMeta8['__iter'](forIter8))
						else
							forIter8, forState8, forControl8 = next, forIter8, nil
						end
					end

					state = 70
				elseif state == 70 then
					v369, v370 = (forIter8(forState8, forControl8))

					if v369 == nil then
						state = 82
					else
						forControl8 = v369
						state = 71
					end
				elseif state == 71 then
					t88 = {
						v369,
						v370
					}

					if t88[2].Name == "Part" then
						state = 73
					else
						state = 72
					end
				elseif state == 72 then
					state = 70
				end
			elseif state <= 78 then
				if state == 73 then
					if tostring(t88[2].BrickColor) == "Really red" then
						state = 75
					else
						state = 74
					end
				elseif state == 74 then
					state = 70
				elseif state == 75 then
					if tostring(t88[2].Part.BrickColor) == "Lime green" then
						state = 81
					else
						state = 76
					end
				elseif state == 76 then
					handlers[7].Remotes.CommF_:InvokeServer("activateColor", "Pure Red")
					handlers[45].wt(1)
					state = 77
				elseif state == 77 then
					handlers[45].wt()

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 79
					else
						state = 78
					end
				elseif state == 78 then
					handlers[35].Character.HumanoidRootPart.Remotes.CommF_:InvokeServer("Buso")
					state = 79
				end
			elseif state <= 84 then
				if state == 79 then
					handlers[31](t88[2].Part.CFrame, 1.5)

					if tostring(t88[2].Part.BrickColor) == "Lime green" then
						state = 80
					else
						state = 77
					end
				elseif state == 80 then
					Really_red_H = true
					state = 70
				elseif state == 81 then
					state = 70
				elseif state == 82 then
					if not Winter_Sky or Hot_pink_H then
						state = 92
					else
						state = 83
					end
				elseif state == 83 then
					state = 84
				elseif state == 84 then
					forIter9, forState9, forControl9 = pairs(handlers[19].Map["Boat Castle"].Summoner.Circle:GetChildren())

					if type(forIter9) == 'table' then
						spilled.forMeta9 = getmetatable(forIter9)

						if type(spilled.forMeta9) == 'table' and spilled.forMeta9['__iter'] then
							forIter9, forState9, forControl9 = (spilled.forMeta9['__iter'](forIter9))
						else
							forIter9, forState9, forControl9 = next, forIter9, nil
						end
					end

					state = 85
				end
			elseif state <= 90 then
				if state == 85 then
					v372, v373 = (forIter9(forState9, forControl9))

					if v372 == nil then
						state = 92
					else
						forControl9 = v372
						state = 86
					end
				elseif state == 86 then
					t89 = {
						v372,
						v373
					}

					if t89[2].Name == "Part" and tostring(t89[2].BrickColor) == "Hot pink" and tostring(t89[2].Part.BrickColor) ~= "Lime green" then
						state = 87
					else
						state = 85
					end
				elseif state == 87 then
					handlers[7].Remotes.CommF_:InvokeServer("activateColor", "Winter Sky")
					handlers[45].wt(1)
					state = 88
				elseif state == 88 then
					handlers[45].wt()

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 90
					else
						state = 89
					end
				elseif state == 89 then
					handlers[35].Character.HumanoidRootPart.Remotes.CommF_:InvokeServer("Buso")
					state = 90
				elseif state == 90 then
					handlers[31](t89[2].Part.CFrame, 1.5)

					if tostring(t89[2].Part.BrickColor) == "Lime green" then
						state = 91
					else
						state = 88
					end
				end
			elseif state <= 96 then
				if state == 91 then
					Hot_pink_H = true
					state = 85
				elseif state == 92 then
					handlers[45].Equip("God's Chalice")
					handlers[31](CFrame.new(-5561.06738, 314.375793, -2663.88892, -0.304127187, -0.00254100002, 0.952628076, 0.000226983335, 0.999996245, 0.00273981248, -0.952631414, 0.00104948215, -0.304125458), 1.5)

					if TimeLoaderx == nil or tick() - TimeLoaderx > 10 then
						state = 93
					else
						state = 94
					end
				elseif state == 93 then
					TimeLoaderx = tick()
					handlers[7][handlers[3]({
						"DefaultChatSystemCha",
						"tEvents"
					})].SayMessageRequest:FireServer(handlers[3]({
						"I have God Chalice. ",
						"I Can't Spawn Boss A",
						"dmin"
					}), "All")
					state = 94
				elseif state == 94 then
					if handlers[35].Backpack:FindFirstChild("God's Chalice") then
						state = 42
					else
						state = 95
					end
				elseif state == 95 then
					if handlers[35].Character:FindFirstChild("God's Chalice") then
						state = 42
					else
						state = 132
					end
				elseif state == 96 then
					local t105 = {
						v364,
						[3] = v365
					}

					if t105[3].Name == "Part" and tostring(t105[3].BrickColor) == "Really red" and tostring(t105[3].Part.BrickColor) == "Lime green" then
						state = 97
					else
						state = 50
					end
				end
			elseif state <= 102 then
				if state == 97 then
					Really_red_H = true
					state = 50
				elseif state == 98 then
					local t106 = {
						[3] = v362,
						v363
					}

					if t106[1].Name == "Part" and tostring(t106[1].BrickColor) == "Hot pink" and tostring(t106[1].Part.BrickColor) == "Lime green" then
						state = 99
					else
						state = 47
					end
				elseif state == 99 then
					Hot_pink_H = true
					state = 47
				elseif state == 100 then
					local t107 = {
						v360,
						v361
					}

					if t107[2].Name == "Part" and tostring(t107[2].BrickColor) == "Oyster" and tostring(t107[2].Part.BrickColor) == "Lime green" then
						state = 101
					else
						state = 44
					end
				elseif state == 101 then
					Oyster_H = true
					state = 44
				elseif state == 102 then
					t90 = { (handlers[7].Remotes.CommF_:InvokeServer("TushitaProgress")) }

					if t90[1].OpenedDoor then
						state = 103
					else
						state = 105
					end
				end
			elseif state <= 108 then
				if state == 103 then
					if t90[1].OpenedDoor then
						state = 104
					else
						state = 132
					end
				else
					if state == 104 then
						Unlock_Tushita_Quest = true

						return
					end

					if state == 105 then
						if handlers[35].Backpack:FindFirstChild("Holy Torch") then
							state = 107
						else
							state = 106
						end
					elseif state == 106 then
						if handlers[35].Character:FindFirstChild("Holy Torch") then
							state = 107
						else
							state = 111
						end
					elseif state == 107 then
						handlers[45].Equip("Holy Torch")
						state = 108
					elseif state == 108 then
						forIndex, forLimit, forStep = 1, 5, 1

						if forStep > 0 and forIndex <= forLimit or forStep <= 0 and forIndex >= forLimit then
							v376 = forIndex
							state = 110
						else
							state = 132
						end
					end
				end
			elseif state <= 114 then
				if state == 109 then
					forIndex += forStep

					if forStep > 0 and forIndex <= forLimit or forStep <= 0 and forIndex >= forLimit then
						v376 = forIndex
						state = 110
					else
						state = 132
					end
				elseif state == 110 then
					handlers[7].Remotes.CommF_:InvokeServer("TushitaProgress", "Torch", ({ v376 })[1])
					state = 109
				elseif state == 111 then
					if handlers[7]:FindFirstChild("rip_indra True Form") then
						state = 113
					else
						state = 112
					end
				elseif state == 112 then
					if handlers[40]:FindFirstChild("rip_indra True Form") then
						state = 113
					else
						state = 132
					end
				elseif state == 113 then
					if handlers[35].Backpack:FindFirstChild("Holy Torch") then
						state = 115
					else
						state = 114
					end
				elseif state == 114 then
					if handlers[35].Character:FindFirstChild("Holy Torch") then
						state = 115
					else
						state = 119
					end
				end
			elseif state <= 120 then
				if state == 115 then
					handlers[45].Equip("Holy Torch")
					state = 116
				elseif state == 116 then
					forIndex2, forLimit2, forStep2 = 1, 5, 1

					if forStep2 > 0 and forIndex2 <= forLimit2 or forStep2 <= 0 and forIndex2 >= forLimit2 then
						v377 = forIndex2
						state = 118
					else
						state = 132
					end
				elseif state == 117 then
					forIndex2 += forStep2

					if forStep2 > 0 and forIndex2 <= forLimit2 or forStep2 <= 0 and forIndex2 >= forLimit2 then
						v377 = forIndex2
						state = 118
					else
						state = 132
					end
				elseif state == 118 then
					handlers[7].Remotes.CommF_:InvokeServer("TushitaProgress", "Torch", ({ v377 })[1])
					state = 117
				elseif state == 119 then
					if handlers[7]:FindFirstChild("rip_indra True Form") then
						state = 121
					else
						state = 120
					end
				elseif state == 120 then
					if handlers[40]:FindFirstChild("rip_indra True Form") then
						state = 121
					else
						state = 132
					end
				end
			elseif state <= 126 then
				if state == 121 then
					task.spawn(function()
						while true do
							handlers[45].wt()
							handlers[2]:SendKeyEvent(true, "Space", false, game)
							handlers[45].wt(0.3)
							handlers[2]:SendKeyEvent(false, "Space", false, game)

							if handlers[35].Backpack:FindFirstChild("Holy Torch") then
								break
							end

							if not handlers[35].Character:FindFirstChild("Holy Torch") then
								if handlers[7]:FindFirstChild("rip_indra True Form") then
									continue
								elseif handlers[40]:FindFirstChild("rip_indra True Form") then
									continue
								end
							end

							break
						end
					end)
					state = 122
				elseif state == 122 then
					handlers[45].wt()
					handlers[35].Character.HumanoidRootPart.CFrame = CFrame.new(5714, 19, 254)

					if handlers[35].Backpack:FindFirstChild("Holy Torch") then
						state = 126
					else
						state = 123
					end
				elseif state == 123 then
					if handlers[35].Character:FindFirstChild("Holy Torch") then
						state = 126
					else
						state = 124
					end
				elseif state == 124 then
					if handlers[7]:FindFirstChild("rip_indra True Form") then
						state = 122
					else
						state = 125
					end
				elseif state == 125 then
					if handlers[40]:FindFirstChild("rip_indra True Form") then
						state = 122
					else
						state = 126
					end
				elseif state == 126 then
					if handlers[35].Backpack:FindFirstChild("Holy Torch") then
						state = 128
					else
						state = 127
					end
				end
			elseif state <= 132 then
				if state == 127 then
					if handlers[35].Character:FindFirstChild("Holy Torch") then
						state = 128
					else
						state = 132
					end
				elseif state == 128 then
					handlers[45].Equip("Holy Torch")
					state = 129
				elseif state == 129 then
					forIndex3, forLimit3, forStep3 = 1, 5, 1

					if forStep3 > 0 and forIndex3 <= forLimit3 or forStep3 <= 0 and forIndex3 >= forLimit3 then
						v378 = forIndex3
						state = 131
					else
						state = 132
					end
				elseif state == 130 then
					forIndex3 += forStep3

					if forStep3 > 0 and forIndex3 <= forLimit3 or forStep3 <= 0 and forIndex3 >= forLimit3 then
						v378 = forIndex3
						state = 131
					else
						state = 132
					end
				elseif state == 131 then
					handlers[7].Remotes.CommF_:InvokeServer("TushitaProgress", "Torch", ({
						[2] = v378
					})[2])
					state = 130
				elseif state == 132 then
					if Three_World then
						state = 133
					else
						state = 145
					end
				end
			elseif state <= 138 then
				if state == 133 then
					if handlers[40]:FindFirstChild("rip_indra True Form") then
						state = 135
					else
						state = 134
					end
				elseif state == 134 then
					if handlers[7]:FindFirstChild("rip_indra True Form") then
						state = 135
					else
						state = 145
					end
				elseif state == 135 then
					if handlers[40]:FindFirstChild("rip_indra True Form") then
						state = 136
					else
						state = 143
					end
				elseif state == 136 then
					state = 137
				elseif state == 137 then
					forIter10, forState10, forControl10 = pairs(handlers[40]:GetChildren())

					if type(forIter10) == 'table' then
						spilled.forMeta10 = getmetatable(forIter10)

						if type(spilled.forMeta10) == 'table' and spilled.forMeta10['__iter'] then
							forIter10, forState10, forControl10 = (spilled.forMeta10['__iter'](forIter10))
						else
							forIter10, forState10, forControl10 = next, forIter10, nil
						end
					end

					state = 138
				elseif state == 138 then
					v379, v380 = (forIter10(forState10, forControl10))

					if v379 == nil then
						state = 145
					else
						forControl10 = v379
						state = 139
					end
				end
			elseif state <= 144 then
				if state == 139 then
					t91 = {
						v379,
						[3] = v380
					}

					if t91[3].Name == "rip_indra True Form" and t91[3].Humanoid.Health > 0 then
						state = 140
					else
						state = 138
					end
				elseif state == 140 then
					handlers[45].wt(0.1)

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 142
					else
						state = 141
					end
				elseif state == 141 then
					handlers[35].Character.HumanoidRootPart.Remotes.CommF_:InvokeServer("Buso")
					state = 142
				elseif state == 142 then
					handlers[31](t91[3].HumanoidRootPart.CFrame * CFrame.new(0, -30, 0), 1.5)
					handlers[14]()

					if not t91[3].Parent or t91[3].Humanoid.Health <= 0 then
						state = 138
					else
						state = 140
					end
				elseif state == 143 then
					if handlers[7]:FindFirstChild("rip_indra True Form") then
						state = 144
					else
						state = 145
					end
				elseif state == 144 then
					handlers[31](handlers[7]:FindFirstChild("rip_indra True Form").HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
					state = 145
				end
			elseif state <= 150 then
				if state == 145 then
					t83[2] = false

					if Three_World and not Mirror_Fractal_H and (handlers[45].ffc(handlers[35].Backpack, "Sweet Chalice") or handlers[45].ffc(handlers[35].Character, "Sweet Chalice") or handlers[45].ffc(handlers[35].Backpack, "God's Chalice") or handlers[45].ffc(handlers[35].Character, "God's Chalice") or handlers[45].ffc(handlers[40], "Dough King") or handlers[45].ffc(handlers[7], "Dough King")) then
						state = 146
					else
						state = 216
					end
				elseif state == 146 then
					wait()
					state = 147
				elseif state == 147 then
					forIter11, forState11, forControl11 = pairs(handlers[7].Remotes.CommF_:InvokeServer("getInventory"))

					if type(forIter11) == 'table' then
						spilled.forMeta11 = getmetatable(forIter11)

						if type(spilled.forMeta11) == 'table' and spilled.forMeta11['__iter'] then
							forIter11, forState11, forControl11 = (spilled.forMeta11['__iter'](forIter11))
						else
							forIter11, forState11, forControl11 = next, forIter11, nil
						end
					end

					state = 148
				elseif state == 148 then
					v382, v383 = (forIter11(forState11, forControl11))

					if v382 == nil then
						state = 149
					else
						forControl11 = v382
						state = 214
					end
				elseif state == 149 then
					if handlers[45].ffc(handlers[40], "Dough King") or handlers[45].ffc(handlers[7], "Dough King") then
						state = 150
					else
						state = 165
					end
				elseif state == 150 then
					if handlers[45].ffc(handlers[40], "Dough King") then
						state = 151
					else
						state = 163
					end
				end
			elseif state <= 156 then
				if state == 151 then
					state = 152
				elseif state == 152 then
					forIter12, forState12, forControl12 = pairs(handlers[40]:GetChildren())

					if type(forIter12) == 'table' then
						spilled.forMeta12 = getmetatable(forIter12)

						if type(spilled.forMeta12) == 'table' and spilled.forMeta12['__iter'] then
							forIter12, forState12, forControl12 = (spilled.forMeta12['__iter'](forIter12))
						else
							forIter12, forState12, forControl12 = next, forIter12, nil
						end
					end

					state = 153
				elseif state == 153 then
					v384, v385 = (forIter12(forState12, forControl12))

					if v384 == nil then
						state = 213
					else
						forControl12 = v384
						state = 154
					end
				elseif state == 154 then
					t92 = {
						[2] = v384,
						v385
					}

					if t92[1].Name == "Dough King" and t92[1].Humanoid.Health > 0 then
						state = 155
					else
						state = 153
					end
				elseif state == 155 then
					wait(0.1)
					handlers[31](t92[1].HumanoidRootPart.CFrame * CFrame.new(0, -30, 0), 1.5)
					handlers[14]()

					if t92[1].Parent then
						state = 156
					else
						state = 157
					end
				elseif state == 156 then
					if t92[1].Humanoid.Health <= 0 then
						state = 157
					else
						state = 155
					end
				end
			elseif state <= 162 then
				if state == 157 then
					state = 158
				elseif state == 158 then
					forIter13, forState13, forControl13 = pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory"))

					if type(forIter13) == 'table' then
						spilled.forMeta13 = getmetatable(forIter13)

						if type(spilled.forMeta13) == 'table' and spilled.forMeta13['__iter'] then
							forIter13, forState13, forControl13 = (spilled.forMeta13['__iter'](forIter13))
						else
							forIter13, forState13, forControl13 = next, forIter13, nil
						end
					end

					state = 159
				elseif state == 159 then
					v303, v304 = (forIter13(forState13, forControl13))

					if v303 == nil then
						state = 160
					else
						forControl13 = v303
						state = 161
					end
				else
					if state == 160 then
						return
					end

					if state == 161 then
						local t108 = {
							[3] = v303,
							v304
						}

						if t108[1].Type == "Material" and t108[1].Name == "Mirror Fractal" then
							state = 162
						else
							state = 159
						end
					elseif state == 162 then
						Mirror_Fractal_H = true
						state = 159
					end
				end
			elseif state <= 168 then
				if state == 163 then
					if handlers[45].ffc(handlers[7], "Dough King") then
						state = 164
					else
						state = 213
					end
				elseif state == 164 then
					handlers[31](game.ReplicatedStorage:FindFirstChild("Dough King").HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)
					state = 213
				elseif state == 165 then
					if handlers[45].ffc(handlers[35].Backpack, "Sweet Chalice") or handlers[45].ffc(handlers[35].Character, "Sweet Chalice") and not Mirror_Fractal_H then
						state = 166
					else
						state = 186
					end
				elseif state == 166 then
					if (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(-2286.6843261719, 146.56562805176, -12226.881835938)).Magnitude >= 1800 then
						state = 167
					else
						state = 168
					end
				elseif state == 167 then
					wait()
					handlers[31](CFrame.new(-2286.6843261719, 146.56562805176, -12226.881835938), 1.5)

					if (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(-2286.6843261719, 146.56562805176, -12226.881835938)).Magnitude <= 3 then
						state = 213
					else
						state = 167
					end
				elseif state == 168 then
					if (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(-2286.6843261719, 146.56562805176, -12226.881835938)).Magnitude < 1800 then
						state = 169
					else
						state = 213
					end
				end
			elseif state <= 174 then
				if state == 169 then
					Monster = nil
					state = 170
				elseif state == 170 then
					forIndex4, forLimit4, forStep4 = 1500, 0, -300

					if forStep4 > 0 and forIndex4 <= forLimit4 or forStep4 <= 0 and forIndex4 >= forLimit4 then
						v387 = forIndex4
						state = 185
					else
						state = 172
					end
				elseif state == 171 then
					forIndex4 += forStep4

					if forStep4 > 0 and forIndex4 <= forLimit4 or forStep4 <= 0 and forIndex4 >= forLimit4 then
						v387 = forIndex4
						state = 185
					else
						state = 172
					end
				elseif state == 172 then
					if Monster ~= nil and Monster.Humanoid.Health > 0 then
						state = 180
					else
						state = 173
					end
				elseif state == 173 then
					if Monster == nil then
						state = 174
					else
						state = 213
					end
				elseif state == 174 then
					state = 175
				end
			elseif state <= 180 then
				if state == 175 then
					forIndex5, forLimit5, forStep5 = 1500, 0, -300

					if forStep5 > 0 and forIndex5 <= forLimit5 or forStep5 <= 0 and forIndex5 >= forLimit5 then
						v388 = forIndex5
						state = 179
					else
						state = 177
					end
				elseif state == 176 then
					forIndex5 += forStep5

					if forStep5 > 0 and forIndex5 <= forLimit5 or forStep5 <= 0 and forIndex5 >= forLimit5 then
						v388 = forIndex5
						state = 179
					else
						state = 177
					end
				elseif state == 177 then
					if Monster == nil then
						state = 178
					else
						state = 213
					end
				elseif state == 178 then
					handlers[31](CFrame.new(-2286.6843261719, 146.56562805176, -12226.881835938), 1.5)
					state = 213
				elseif state == 179 then
					handlers[45].GetMonster(({
						[2] = v388
					})[2])
					state = 176
				elseif state == 180 then
					t93 = {}
					PosMon_X = Monster.HumanoidRootPart.CFrame
					StatrMagnet = true
					state = 181
				end
			elseif state <= 186 then
				if state == 181 then
					wait()
					handlers[31](Monster.HumanoidRootPart.CFrame * CFrame.new(0, -17, 0), 1.5)
					handlers[14]()

					if Monster.Parent then
						state = 182
					else
						state = 183
					end
				elseif state == 182 then
					if Monster.Humanoid.Health <= 0 then
						state = 183
					else
						state = 181
					end
				elseif state == 183 then
					StatrMagnet = false
					t93[1] = tostring(string.match(tostring(handlers[7].Remotes.CommF_:InvokeServer("CakePrinceSpawner")), "%d+"))

					if t93[1] == "nil" or t93[1] == nil then
						state = 184
					else
						state = 213
					end
				elseif state == 184 then
					handlers[7].Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
					state = 213
				elseif state == 185 then
					handlers[45].GetMonster(({ v387 })[1])
					state = 171
				elseif state == 186 then
					if handlers[45].ffc(handlers[35].Backpack, "God's Chalice") or handlers[45].ffc(handlers[35].Character, "God's Chalice") and not Mirror_Fractal_H then
						state = 187
					else
						state = 210
					end
				end
			elseif state <= 192 then
				if state == 187 then
					if handlers[45].CheckItem("Conjured Cocoa") >= 10 then
						state = 188
					else
						state = 189
					end
				elseif state == 188 then
					handlers[7].Remotes.CommF_:InvokeServer("SweetChaliceNpc")
					state = 213
				elseif state == 189 then
					if handlers[45].CheckItem("Conjured Cocoa") < 10 then
						state = 190
					else
						state = 213
					end
				elseif state == 190 then
					if (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(658.22302246094, 24.734258651733, -12541.991210938)).Magnitude >= 1800 then
						state = 191
					else
						state = 193
					end
				elseif state == 191 then
					wait()
					handlers[31](CFrame.new(658.22302246094, 24.734258651733, -12541.991210938), 1.5)

					if (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(658.22302246094, 24.734258651733, -12541.991210938)).Magnitude <= 3 then
						state = 213
					else
						state = 192
					end
				elseif state == 192 then
					if handlers[45].CheckItem("Conjured Cocoa") >= 10 then
						state = 213
					else
						state = 191
					end
				end
			elseif state <= 198 then
				if state == 193 then
					if (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(658.22302246094, 24.734258651733, -12541.991210938)).Magnitude < 1800 then
						state = 194
					else
						state = 213
					end
				elseif state == 194 then
					Monster = nil
					state = 195
				elseif state == 195 then
					forIndex6, forLimit6, forStep6 = 1500, 0, -300

					if forStep6 > 0 and forIndex6 <= forLimit6 or forStep6 <= 0 and forIndex6 >= forLimit6 then
						v390 = forIndex6
						state = 209
					else
						state = 197
					end
				elseif state == 196 then
					forIndex6 += forStep6

					if forStep6 > 0 and forIndex6 <= forLimit6 or forStep6 <= 0 and forIndex6 >= forLimit6 then
						v390 = forIndex6
						state = 209
					else
						state = 197
					end
				elseif state == 197 then
					if Monster ~= nil and Monster.Humanoid.Health > 0 then
						state = 205
					else
						state = 198
					end
				elseif state == 198 then
					if Monster == nil then
						state = 199
					else
						state = 213
					end
				end
			elseif state <= 204 then
				if state == 199 then
					state = 200
				elseif state == 200 then
					forIndex7, forLimit7, forStep7 = 1500, 0, -300

					if forStep7 > 0 and forIndex7 <= forLimit7 or forStep7 <= 0 and forIndex7 >= forLimit7 then
						v391 = forIndex7
						state = 204
					else
						state = 202
					end
				elseif state == 201 then
					forIndex7 += forStep7

					if forStep7 > 0 and forIndex7 <= forLimit7 or forStep7 <= 0 and forIndex7 >= forLimit7 then
						v391 = forIndex7
						state = 204
					else
						state = 202
					end
				elseif state == 202 then
					if Monster == nil then
						state = 203
					else
						state = 213
					end
				elseif state == 203 then
					handlers[31](CFrame.new(658.22302246094, 24.734258651733, -12541.991210938), 1.5)
					state = 213
				elseif state == 204 then
					handlers[45].GetMonster(({
						[2] = v391
					})[2])
					state = 201
				end
			elseif state <= 210 then
				if state == 205 then
					PosMon_X = Monster.HumanoidRootPart.CFrame
					StatrMagnet = true
					state = 206
				elseif state == 206 then
					wait()
					handlers[31](Monster.HumanoidRootPart.CFrame * CFrame.new(0, -17, 0), 1.5)
					handlers[14]()

					if Monster.Parent then
						state = 207
					else
						state = 208
					end
				elseif state == 207 then
					if Monster.Humanoid.Health <= 0 then
						state = 208
					else
						state = 206
					end
				elseif state == 208 then
					StatrMagnet = false
					state = 213
				elseif state == 209 then
					handlers[45].GetMonster(({ v390 })[1])
					state = 196
				elseif state == 210 then
					if handlers[40]:FindFirstChild("Dough King") then
						state = 213
					else
						state = 211
					end
				end
			elseif state <= 216 then
				if state == 211 then
					if handlers[7]:FindFirstChild("Dough King") then
						state = 213
					else
						state = 212
					end
				elseif state == 212 then
					t83[2] = true
					state = 213
				elseif state == 213 then
					if Mirror_Fractal_H or t83[2] then
						state = 216
					else
						state = 146
					end
				elseif state == 214 then
					local t109 = {
						[2] = v382,
						[3] = v383
					}

					if t109[3].Type == "Material" and t109[3].Name == "Mirror Fractal" then
						state = 215
					else
						state = 148
					end
				elseif state == 215 then
					Mirror_Fractal_H = true
					state = 148
				elseif state == 216 then
					if not Three_World or handlers[7].Remotes.CommF_:InvokeServer("EliteHunter") == handlers[3]({
						"I don't have anythin",
						"g for you right now.",
						" Come back later."
					}) then
						state = 228
					else
						state = 217
					end
				end
			elseif state <= 222 then
				if state == 217 then
					handlers[7].Remotes.CommF_:InvokeServer("EliteHunter")
					state = 218
				elseif state == 218 then
					forIter14, forState14, forControl14 = ipairs({
						"Diablo",
						"Deandre",
						"Urban"
					})

					if type(forIter14) == 'table' then
						spilled.forMeta14 = getmetatable(forIter14)

						if type(spilled.forMeta14) == 'table' and spilled.forMeta14['__iter'] then
							forIter14, forState14, forControl14 = (spilled.forMeta14['__iter'](forIter14))
						else
							forIter14, forState14, forControl14 = next, forIter14, nil
						end
					end

					state = 219
				elseif state == 219 then
					v392, v393 = (forIter14(forState14, forControl14))

					if v392 == nil then
						state = 228
					else
						forControl14 = v392
						state = 220
					end
				elseif state == 220 then
					t94 = {
						[2] = v392,
						v393
					}
					v395 = handlers[40]:FindFirstChild(t94[1])

					if v395 then
						state = 222
					else
						state = 221
					end
				elseif state == 221 then
					v395 = handlers[7]:FindFirstChild(t94[1])
					state = 222
				elseif state == 222 then
					t94[3] = v395

					if t94[3] then
						state = 223
					else
						state = 219
					end
				end
			elseif state <= 228 then
				if state == 223 then
					if t94[3]:FindFirstChild("HumanoidRootPart") then
						state = 224
					else
						state = 219
					end
				elseif state == 224 then
					if t94[3]:FindFirstChild("Humanoid") and t94[3].Humanoid.Health > 0 then
						state = 225
					else
						state = 219
					end
				elseif state == 225 then
					handlers[45].wt()
					handlers[7].Remotes.CommF_:InvokeServer("EliteHunter")
					handlers[31](t94[3].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 227
					else
						state = 226
					end
				elseif state == 226 then
					handlers[35].Character.HumanoidRootPart.Remotes.CommF_:InvokeServer("Buso")
					state = 227
				elseif state == 227 then
					handlers[14]()

					if not t94[3].Parent or t94[3].Humanoid.Health <= 0 then
						state = 219
					else
						state = 225
					end
				elseif state == 228 then
					if New_World and (handlers[45].ffc(handlers[40], "Darkbeard") or handlers[45].ffc(handlers[7], "Darkbeard")) then
						state = 229
					else
						state = 245
					end
				end
			elseif state <= 234 then
				if state == 229 then
					if handlers[45].ffc(handlers[40], "Darkbeard") then
						state = 230
					else
						state = 237
					end
				elseif state == 230 then
					state = 231
				elseif state == 231 then
					forIter15, forState15, forControl15 = pairs(handlers[40]:GetChildren())

					if type(forIter15) == 'table' then
						spilled.forMeta15 = getmetatable(forIter15)

						if type(spilled.forMeta15) == 'table' and spilled.forMeta15['__iter'] then
							forIter15, forState15, forControl15 = (spilled.forMeta15['__iter'](forIter15))
						else
							forIter15, forState15, forControl15 = next, forIter15, nil
						end
					end

					state = 232
				elseif state == 232 then
					v396, v397 = (forIter15(forState15, forControl15))

					if v396 == nil then
						state = 245
					else
						forControl15 = v396
						state = 233
					end
				elseif state == 233 then
					t95 = {
						[3] = v396,
						v397
					}

					if t95[1].Name == "Darkbeard" and t95[1].Humanoid.Health > 0 then
						state = 234
					else
						state = 232
					end
				elseif state == 234 then
					handlers[45].wt()

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 236
					else
						state = 235
					end
				end
			elseif state <= 240 then
				if state == 235 then
					handlers[35].Character.HumanoidRootPart.Remotes.CommF_:InvokeServer("Buso")
					state = 236
				elseif state == 236 then
					handlers[31](t95[1].HumanoidRootPart.CFrame * CFrame.new(0, -30, 0), 1.5)
					handlers[14]()

					if t95[1].Parent and not (t95[1].Humanoid.Health <= 0) and getgenv().AutoFarm then
						state = 234
					else
						state = 232
					end
				elseif state == 237 then
					if handlers[45].ffc(handlers[7], "Darkbeard") then
						state = 238
					else
						state = 245
					end
				elseif state == 238 then
					state = 239
				elseif state == 239 then
					forIter16, forState16, forControl16 = pairs(handlers[7]:GetChildren())

					if type(forIter16) == 'table' then
						spilled.forMeta16 = getmetatable(forIter16)

						if type(spilled.forMeta16) == 'table' and spilled.forMeta16['__iter'] then
							forIter16, forState16, forControl16 = (spilled.forMeta16['__iter'](forIter16))
						else
							forIter16, forState16, forControl16 = next, forIter16, nil
						end
					end

					state = 240
				elseif state == 240 then
					v399, v400 = (forIter16(forState16, forControl16))

					if v399 == nil then
						state = 245
					else
						forControl16 = v399
						state = 241
					end
				end
			elseif state <= 246 then
				if state == 241 then
					t96 = {
						[2] = v399,
						v400
					}

					if t96[1].Name == "Darkbeard" and t96[1].Humanoid.Health > 0 then
						state = 242
					else
						state = 240
					end
				elseif state == 242 then
					handlers[45].wt()

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 244
					else
						state = 243
					end
				elseif state == 243 then
					handlers[35].Character.HumanoidRootPart.Remotes.CommF_:InvokeServer("Buso")
					state = 244
				elseif state == 244 then
					handlers[31](t96[1].HumanoidRootPart.CFrame * CFrame.new(0, -30, 0), 1.5)
					handlers[14]()

					if t96[1].Parent and not (t96[1].Humanoid.Health <= 0) and getgenv().AutoFarm then
						state = 242
					else
						state = 240
					end
				elseif state == 245 then
					if New_World then
						state = 246
					else
						state = 264
					end
				elseif state == 246 then
					if handlers[45].ffc(handlers[40], "Core") or handlers[45].ffc(handlers[7], "Core") then
						state = 247
					else
						state = 264
					end
				end
			elseif state <= 252 then
				if state == 247 then
					if handlers[45].ffc(handlers[40], "Core") then
						state = 248
					else
						state = 256
					end
				elseif state == 248 then
					state = 249
				elseif state == 249 then
					forIter17, forState17, forControl17 = pairs(handlers[40]:GetChildren())

					if type(forIter17) == 'table' then
						spilled.forMeta17 = getmetatable(forIter17)

						if type(spilled.forMeta17) == 'table' and spilled.forMeta17['__iter'] then
							forIter17, forState17, forControl17 = (spilled.forMeta17['__iter'](forIter17))
						else
							forIter17, forState17, forControl17 = next, forIter17, nil
						end
					end

					state = 250
				elseif state == 250 then
					v402, v403 = (forIter17(forState17, forControl17))

					if v402 == nil then
						state = 264
					else
						forControl17 = v402
						state = 251
					end
				elseif state == 251 then
					t97 = {
						v402,
						v403
					}

					if t97[2].Name == "Core" and t97[2].Humanoid.Health > 0 then
						state = 252
					else
						state = 250
					end
				elseif state == 252 then
					state = 253
				end
			elseif state <= 258 then
				if state == 253 then
					handlers[45].wt()
					handlers[31](t97[2].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 255
					else
						state = 254
					end
				elseif state == 254 then
					handlers[7].Remotes.CommF_:InvokeServer("Buso")
					state = 255
				elseif state == 255 then
					handlers[14]()

					if t97[2].Parent and not (t97[2].Humanoid.Health <= 0) and getgenv().AutoFarm then
						state = 253
					else
						state = 250
					end
				elseif state == 256 then
					if handlers[45].ffc(handlers[7], "Core") then
						state = 257
					else
						state = 264
					end
				elseif state == 257 then
					state = 258
				elseif state == 258 then
					forIter18, forState18, forControl18 = pairs(handlers[7]:GetChildren())

					if type(forIter18) == 'table' then
						spilled.forMeta18 = getmetatable(forIter18)

						if type(spilled.forMeta18) == 'table' and spilled.forMeta18['__iter'] then
							forIter18, forState18, forControl18 = (spilled.forMeta18['__iter'](forIter18))
						else
							forIter18, forState18, forControl18 = next, forIter18, nil
						end
					end

					state = 259
				end
			elseif state <= 264 then
				if state == 259 then
					v405, v406 = (forIter18(forState18, forControl18))

					if v405 == nil then
						state = 264
					else
						forControl18 = v405
						state = 260
					end
				elseif state == 260 then
					t98 = {
						[3] = v405,
						[2] = v406
					}

					if t98[2].Name == "Core" and t98[2].Humanoid.Health > 0 then
						state = 261
					else
						state = 259
					end
				elseif state == 261 then
					handlers[45].wt()
					handlers[31](t98[2].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 263
					else
						state = 262
					end
				elseif state == 262 then
					handlers[7].Remotes.CommF_:InvokeServer("Buso")
					state = 263
				elseif state == 263 then
					handlers[14]()

					if t98[2].Parent and not (t98[2].Humanoid.Health <= 0) and getgenv().AutoFarm then
						state = 261
					else
						state = 259
					end
				elseif state == 264 then
					handlers[8]()

					if Quest == nil then
						state = 265
					else
						state = 368
					end
				end
			elseif state <= 270 then
				if state == 265 then
					if handlers[24].Value < 2650 or not Three_World then
						state = 303
					else
						state = 266
					end
				elseif state == 266 then
					if handlers[24].Value >= 2650 and Three_World then
						state = 267
					else
						state = 302
					end
				elseif state == 267 then
					SROP = false

					if handlers[45].ffc(handlers[7], "Cake Prince") then
						state = 268
					else
						state = 276
					end
				elseif state == 268 then
					state = 269
				elseif state == 269 then
					forIter19, forState19, forControl19 = pairs(handlers[7]:GetChildren())

					if type(forIter19) == 'table' then
						local forMeta19 = getmetatable(forIter19)

						if type(forMeta19) == 'table' and forMeta19['__iter'] then
							forIter19, forState19, forControl19 = (forMeta19['__iter'](forIter19))
						else
							forIter19, forState19, forControl19 = next, forIter19, nil
						end
					end

					state = 270
				elseif state == 270 then
					v408, v409 = (forIter19(forState19, forControl19))

					if v408 == nil then
						state = 271
					else
						forControl19 = v408
						state = 272
					end
				end
			elseif state <= 276 then
				if state == 271 then
					return
				end

				if state == 272 then
					t99 = {
						v408,
						v409
					}

					if t99[2].Name == "Cake Prince" then
						state = 273
					else
						state = 270
					end
				elseif state == 273 then
					if t99[2]:FindFirstChild("Humanoid") then
						state = 274
					else
						state = 270
					end
				elseif state == 274 then
					if t99[2]:FindFirstChild("Humanoid").Health > 0 then
						state = 275
					else
						state = 270
					end
				elseif state == 275 then
					handlers[31](t99[2].HumanoidRootPart.CFrame * CFrame.new(0, 42, 10), 1.5)
					state = 270
				elseif state == 276 then
					if handlers[45].ffc(handlers[40], "Cake Prince") then
						state = 277
					else
						state = 285
					end
				end
			elseif state <= 282 then
				if state == 277 then
					state = 278
				elseif state == 278 then
					forIter20, forState20, forControl20 = pairs(handlers[40]:GetChildren())

					if type(forIter20) == 'table' then
						local forMeta20 = getmetatable(forIter20)

						if type(forMeta20) == 'table' and forMeta20['__iter'] then
							forIter20, forState20, forControl20 = (forMeta20['__iter'](forIter20))
						else
							forIter20, forState20, forControl20 = next, forIter20, nil
						end
					end

					state = 279
				elseif state == 279 then
					v411, v412 = (forIter20(forState20, forControl20))

					if v411 == nil then
						state = 280
					else
						forControl20 = v411
						state = 281
					end
				else
					if state == 280 then
						return
					end

					if state == 281 then
						t100 = {
							v411,
							v412
						}

						if t100[2].Name == "Cake Prince" then
							state = 282
						else
							state = 279
						end
					elseif state == 282 then
						if t100[2]:FindFirstChild("Humanoid") then
							state = 283
						else
							state = 279
						end
					end
				end
			elseif state <= 288 then
				if state == 283 then
					if t100[2]:FindFirstChild("Humanoid").Health > 0 then
						state = 284
					else
						state = 279
					end
				elseif state == 284 then
					handlers[31](t100[2].HumanoidRootPart.CFrame * CFrame.new(0, 42, 10), 1.5)
					state = 279
				elseif state == 285 then
					if tostring(string.match(tostring(handlers[7].Remotes.CommF_:InvokeServer("CakePrinceSpawner")), "%d+")) == "nil" then
						state = 287
					else
						state = 286
					end
				elseif state == 286 then
					if tostring(string.match(tostring(handlers[7].Remotes.CommF_:InvokeServer("CakePrinceSpawner")), "%d+")) == nil then
						state = 287
					else
						state = 288
					end
				elseif state == 287 then
					handlers[7].Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
					state = 288
				elseif state == 288 then
					if handlers[45].ffc(handlers[40], "Cookie Crafter") or handlers[45].ffc(handlers[40], "Cake Guard") then
						state = 290
					else
						state = 289
					end
				end
			elseif state <= 294 then
				if state == 289 then
					if handlers[45].ffc(handlers[40], "Baking Staff") or handlers[45].ffc(handlers[40], "Head Baker") then
						state = 290
					else
						state = 300
					end
				elseif state == 290 then
					state = 291
				elseif state == 291 then
					forIter21, forState21, forControl21 = pairs(handlers[40]:GetChildren())

					if type(forIter21) == 'table' then
						local forMeta21 = getmetatable(forIter21)

						if type(forMeta21) == 'table' and forMeta21['__iter'] then
							forIter21, forState21, forControl21 = (forMeta21['__iter'](forIter21))
						else
							forIter21, forState21, forControl21 = next, forIter21, nil
						end
					end

					state = 292
				elseif state == 292 then
					v414, v415 = (forIter21(forState21, forControl21))

					if v414 == nil then
						state = 293
					else
						forControl21 = v414
						state = 294
					end
				else
					if state == 293 then
						return
					end

					if state == 294 then
						t101 = {
							v414,
							v415
						}

						if t101[2].Name == "Cookie Crafter" or t101[2].Name == "Cake Guard" or t101[2].Name == "Baking Staff" or t101[2].Name == "Head Baker" then
							state = 295
						else
							state = 292
						end
					end
				end
			elseif state <= 300 then
				if state == 295 then
					handlers[45].wt()
					handlers[31](t101[2].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 297
					else
						state = 296
					end
				elseif state == 296 then
					handlers[7].Remotes.CommF_:InvokeServer("Buso")
					state = 297
				elseif state == 297 then
					handlers[45].BN(t101[2].Name)
					handlers[14]()

					if t101[2].Humanoid.Health <= 0 then
						state = 292
					else
						state = 298
					end
				elseif state == 298 then
					if handlers[40]:FindFirstChild(Enemy) then
						state = 299
					else
						state = 292
					end
				elseif state == 299 then
					if handlers[35].PlayerGui.Main:FindFirstChild("Quest").Visible and Quest == nil then
						state = 295
					else
						state = 292
					end
				elseif state == 300 then
					handlers[31](CFrame.new(-2091.9118652344, 70.008842468262, -12142.8359375), 1.5)
					state = 301
				end
			elseif state <= 306 then
				if state == 301 then
					return
				end

				if state == 302 then
					return
				end

				if state == 303 then
					if not (handlers[24].Value <= 9) or New_World or Three_World then
						state = 327
					else
						state = 304
					end
				elseif state == 304 then
					if handlers[35].PlayerGui.Main.Quest.Visible then
						state = 305
					else
						state = 322
					end
				elseif state == 305 then
					if handlers[45].sf(handlers[35].PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, tostring(NameEnemy)) then
						state = 306
					else
						state = 320
					end
				elseif state == 306 then
					if handlers[45].ffc(handlers[40], Enemy) then
						state = 307
					else
						state = 318
					end
				end
			elseif state <= 312 then
				if state == 307 then
					state = 308
				elseif state == 308 then
					forIter22, forState22, forControl22 = pairs(handlers[40]:GetChildren())

					if type(forIter22) == 'table' then
						local forMeta22 = getmetatable(forIter22)

						if type(forMeta22) == 'table' and forMeta22['__iter'] then
							forIter22, forState22, forControl22 = (forMeta22['__iter'](forIter22))
						else
							forIter22, forState22, forControl22 = next, forIter22, nil
						end
					end

					state = 309
				elseif state == 309 then
					v417, v418 = (forIter22(forState22, forControl22))

					if v417 == nil then
						state = 310
					else
						forControl22 = v417
						state = 311
					end
				else
					if state == 310 then
						return
					end

					if state == 311 then
						t102 = {
							v417,
							v418
						}

						if t102[2].Name == Enemy and handlers[45].ffc(t102[2], "Humanoid") then
							state = 312
						else
							state = 309
						end
					elseif state == 312 then
						if t102[2].Humanoid.Health > 0 and handlers[45].ffc(t102[2], "HumanoidRootPart") then
							state = 313
						else
							state = 309
						end
					end
				end
			elseif state <= 318 then
				if state == 313 then
					handlers[45].wt()
					handlers[45].BN(t102[2].Name)
					handlers[31](t102[2].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 315
					else
						state = 314
					end
				elseif state == 314 then
					handlers[7].Remotes.CommF_:InvokeServer("Buso")
					state = 315
				elseif state == 315 then
					handlers[14]()

					if t102[2].Humanoid.Health <= 0 then
						state = 309
					else
						state = 316
					end
				elseif state == 316 then
					if handlers[40]:FindFirstChild(Enemy) then
						state = 317
					else
						state = 309
					end
				elseif state == 317 then
					if handlers[35].PlayerGui.Main:FindFirstChild("Quest").Visible and getgenv().AutoFarm and Quest == nil then
						state = 313
					else
						state = 309
					end
				elseif state == 318 then
					handlers[31](EnemyPos, 1.5)
					state = 319
				end
			elseif state <= 324 then
				if state == 319 then
					return
				end

				if state == 320 then
					handlers[7].Remotes.CommF_:InvokeServer("AbandonQuest")
					state = 321
				else
					if state == 321 then
						return
					end

					if state == 322 then
						handlers[45].wt()
						handlers[31](QuestPos, 1.5)

						if (QuestPos.Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 5 then
							state = 323
						else
							state = 325
						end
					elseif state == 323 then
						if handlers[35].Character:WaitForChild("Humanoid").Health > 0 then
							state = 324
						else
							state = 325
						end
					elseif state == 324 then
						handlers[45].wt()
						handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("StartQuest", QuestName, QuestNumber)
						state = 325
					end
				end
			elseif state <= 330 then
				if state == 325 then
					if not handlers[35].PlayerGui.Main:FindFirstChild("Quest").Visible and getgenv().AutoFarm and Quest == nil then
						state = 322
					else
						state = 326
					end
				else
					if state == 326 then
						return
					end

					if state == 327 then
						if not (handlers[24].Value >= 9) or not (handlers[24].Value <= 70) or New_World or Three_World then
							state = 342
						else
							state = 328
						end
					elseif state == 328 then
						if (CFrame.new(-7895, 5546, -380).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 1000 then
							state = 329
						else
							state = 340
						end
					elseif state == 329 then
						if handlers[45].ffc(handlers[40], "Shanda") then
							state = 330
						else
							state = 338
						end
					elseif state == 330 then
						state = 331
					end
				end
			elseif state <= 336 then
				if state == 331 then
					forIter23, forState23, forControl23 = pairs(handlers[40]:GetChildren())

					if type(forIter23) == 'table' then
						local forMeta23 = getmetatable(forIter23)

						if type(forMeta23) == 'table' and forMeta23['__iter'] then
							forIter23, forState23, forControl23 = (forMeta23['__iter'](forIter23))
						else
							forIter23, forState23, forControl23 = next, forIter23, nil
						end
					end

					state = 332
				elseif state == 332 then
					v420, v421 = (forIter23(forState23, forControl23))

					if v420 == nil then
						state = 333
					else
						forControl23 = v420
						state = 334
					end
				else
					if state == 333 then
						return
					end

					if state == 334 then
						t103 = {
							[2] = v420,
							v421
						}

						if t103[1].Name == "Shanda" then
							state = 335
						else
							state = 332
						end
					elseif state == 335 then
						if t103[1]:FindFirstChild("Humanoid") and t103[1].Humanoid.Health > 0 then
							state = 336
						else
							state = 332
						end
					elseif state == 336 then
						handlers[45].wt()
						SROP = true
						handlers[31](t103[1].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)
						handlers[14]()
						handlers[45].BN(t103[1].Name)

						if t103[1].Parent then
							state = 337
						else
							state = 332
						end
					end
				end
			elseif state <= 342 then
				if state == 337 then
					if not (t103[1].Humanoid.Health <= 0) and not (handlers[24].Value >= 91) and getgenv().AutoFarm and Quest == nil then
						state = 336
					else
						state = 332
					end
				elseif state == 338 then
					handlers[31](CFrame.new(-7757, 5582, -481), 1.5)
					state = 339
				else
					if state == 339 then
						return
					end

					if state == 340 then
						handlers[7].Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
						state = 341
					elseif state == 341 then
						return
					elseif state == 342 then
						if handlers[24].Value >= 71 then
							state = 343
						else
							state = 367
						end
					end
				end
			elseif state <= 348 then
				if state == 343 then
					if handlers[35].PlayerGui.Main.Quest.Visible then
						state = 344
					else
						state = 362
					end
				elseif state == 344 then
					if handlers[45].sf(handlers[35].PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, tostring(NameEnemy)) then
						state = 345
					else
						state = 360
					end
				elseif state == 345 then
					if handlers[45].ffc(handlers[40], Enemy) then
						state = 346
					else
						state = 358
					end
				elseif state == 346 then
					state = 347
				elseif state == 347 then
					forIter24, forState24, forControl24 = pairs(handlers[40]:GetChildren())

					if type(forIter24) == 'table' then
						local forMeta24 = getmetatable(forIter24)

						if type(forMeta24) == 'table' and forMeta24['__iter'] then
							forIter24, forState24, forControl24 = (forMeta24['__iter'](forIter24))
						else
							forIter24, forState24, forControl24 = next, forIter24, nil
						end
					end

					state = 348
				elseif state == 348 then
					v423, v424 = (forIter24(forState24, forControl24))

					if v423 == nil then
						state = 349
					else
						forControl24 = v423
						state = 350
					end
				end
			elseif state <= 354 then
				if state == 349 then
					return
				end

				if state == 350 then
					t104 = {
						v423,
						v424
					}

					if t104[2].Name == Enemy then
						state = 351
					else
						state = 348
					end
				elseif state == 351 then
					if t104[2]:FindFirstChild("Humanoid") and t104[2].Humanoid.Health > 0 then
						state = 352
					else
						state = 348
					end
				elseif state == 352 then
					if t104[2]:FindFirstChild("HumanoidRootPart") then
						state = 353
					else
						state = 348
					end
				elseif state == 353 then
					handlers[45].wt()
					SROP = false
					handlers[31](t104[2].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

					if handlers[45].ffc(handlers[35].Character, "HasBuso") then
						state = 355
					else
						state = 354
					end
				elseif state == 354 then
					handlers[7].Remotes.CommF_:InvokeServer("Buso")
					state = 355
				end
			elseif state <= 360 then
				if state == 355 then
					handlers[45].BN(t104[2].Name)
					handlers[14]()

					if t104[2].Humanoid.Health <= 0 then
						state = 348
					else
						state = 356
					end
				elseif state == 356 then
					if handlers[40]:FindFirstChild(Enemy) then
						state = 357
					else
						state = 348
					end
				elseif state == 357 then
					if handlers[35].PlayerGui.Main:FindFirstChild("Quest").Visible and Quest == nil then
						state = 353
					else
						state = 348
					end
				elseif state == 358 then
					handlers[31](EnemyPos, 1.5)
					state = 359
				elseif state == 359 then
					return
				elseif state == 360 then
					handlers[7].Remotes.CommF_:InvokeServer("AbandonQuest")
					state = 361
				end
			elseif state <= 366 then
				if state == 361 then
					return
				end

				if state == 362 then
					handlers[45].wt()
					handlers[31](QuestPos, 1.5)

					if (QuestPos.Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 5 then
						state = 363
					else
						state = 365
					end
				elseif state == 363 then
					if handlers[35].Character:WaitForChild("Humanoid").Health > 0 then
						state = 364
					else
						state = 365
					end
				elseif state == 364 then
					handlers[45].wt(0.5)
					handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("StartQuest", QuestName, QuestNumber)
					state = 365
				elseif state == 365 then
					if not handlers[35].PlayerGui.Main:FindFirstChild("Quest").Visible and getgenv().AutoFarm and Quest == nil then
						state = 362
					else
						state = 366
					end
				elseif state == 366 then
					return
				end
			elseif state == 367 then
				return
			elseif state == 368 then
				return
			end
		end
	end
end
handlers[38] = function()
	if not noFruit then
		for k, child in pairs(handlers[35].Backpack:GetChildren()) do
			local t110 = {
				[3] = k,
				[2] = child
			}

			if t110[2]:GetAttribute("OriginalName") ~= nil and handlers[45].sf(t110[2].Name, "Fruit") then
				if t110[2]:IsA("Tool") then
					if not handlers[45].IsInList(handlers[45].GetType(), t110[2]:GetAttribute("OriginalName")) then
						local t111 = { {
							"StoreFruit",
							t110[2]:GetAttribute("OriginalName"),
							t110[2]
						} }

						handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(t111[1]))
						handlers[7].Remotes.CommF_:InvokeServer("GetFruits", false)
					end
				end
			end
		end

		for k, child in pairs(handlers[35].Character:GetChildren()) do
			local t112 = {
				[3] = k,
				child
			}

			if t112[1]:GetAttribute("OriginalName") ~= nil and handlers[45].sf(t112[1].Name, "Fruit") then
				if t112[1]:IsA("Tool") then
					if not handlers[45].IsInList(handlers[45].GetType(), t112[1]:GetAttribute("OriginalName")) then
						local t113 = {}

						t113[2] = {
							"StoreFruit",
							t112[1]:GetAttribute("OriginalName"),
							t112[1]
						}
						handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(t113[2]))
						handlers[7].Remotes.CommF_:InvokeServer("GetFruits", false)
					end
				end
			end
		end
	end
end
_G.Ew = true
Ewx = true
task.spawn(function()
	while handlers[45].wt() do
		if _G.Ew then
			handlers[14]()
		else
			handlers[38]()

			if Ewx then
				handlers[21] = 0
			else
				handlers[21] = 0.2
			end
		end
	end
end)
task.spawn(function()
	while handlers[45].wt(1) do
		xpcall(function()
			if not Black_Leg_C then
				repeat
					handlers[45].wt(handlers[21])
					handlers[7].Remotes.CommF_:InvokeServer("BuyBlackLeg")
					handlers[14]()
					handlers[45].wt(0.05)

					if handlers[45].ffc(handlers[35].Character, "Black Leg") or handlers[45].ffc(handlers[35].Backpack, "Black Leg") and not Black_Leg_C then
						Black_Leg_C = true
						handlers[45].Equip("Black Leg")
					end
				until Black_Leg_C
			end

			if not Electro_C then
				repeat
					handlers[45].wt(handlers[21])
					handlers[14]()
					handlers[2]:SendKeyEvent(true, "V", false, game)
					wait(0.5)
					handlers[2]:SendKeyEvent(false, "V", false, game)

					if handlers[45].ffc(handlers[35].Character, "Black Leg") and handlers[35].Character["Black Leg"].Level.Value >= 300 and not Electro_C then
						if handlers[35].Character["Black Leg"].Level.Value >= 400 then
							Black_Leg_C_M = true
						end

						Electro_C = true
						handlers[45].wt(0.05)
						handlers[7].Remotes.CommF_:InvokeServer("BuyElectro")
					end
				until Electro_C
			end

			if not Fishman_Karate_C then
				repeat
					handlers[45].wt(handlers[21])
					handlers[14]()

					if handlers[45].ffc(handlers[35].Character, "Electro") then
						if handlers[35].Character.Electro.Level.Value >= 300 and not Fishman_Karate_C then
							if handlers[35].Character.Electro.Level.Value >= 400 then
								Electro_C_M = true
							end

							Fishman_Karate_C = true
							handlers[45].wt(0.05)
							handlers[7].Remotes.CommF_:InvokeServer("BuyFishmanKarate")
						end
					end
				until Fishman_Karate_C
			end

			if not Fishman_Karate_C_M then
				repeat
					local t114 = {}

					task.wait(handlers[21])
					handlers[14]()
					handlers[7].Remotes.CommF_:InvokeServer("BuyFishmanKarate")
					t114[2] = handlers[35].Character:FindFirstChild("Fishman Karate")

					if t114[2] then
						if t114[2]:FindFirstChild("Level") and t114[2].Level.Value >= 400 then
							Fishman_Karate_C_M = true
						end
					end
				until Fishman_Karate_C_M
			end

			handlers[45].wt(handlers[21])

			if not Dragon_Claw_C then
				local t115 = {
					[2] = handlers[7].Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
				}

				if t115[2] == 1 or t115[2] == 2 then
					pcall(function()
						if handlers[35].Character["Fishman Karate"].Level.Value >= 400 then
							Fishman_Karate_C_M = true
						end
					end)
					Dragon_Claw_C = true
				end
			end

			repeat
				task.wait(handlers[21])
				handlers[14]()

				if not Super_human and Dragon_Claw_C and handlers[45].ffc(handlers[35].Character, "Dragon Claw") then
					if handlers[35].Character["Dragon Claw"].Level.Value >= 300 then
						local t116 = {}

						if handlers[35].Character["Dragon Claw"].Level.Value >= 400 then
							Dragon_Claw_C_M = true
						end

						t116[2] = { "BuySuperhuman" }

						if handlers[7].Remotes.CommF_:InvokeServer(unpack(t116[2])) == 1 then
							Super_human = true

							if handlers[35].Character.Superhuman.Level.Value >= 400 then
								Super_humanw_C_M = true
							end
						elseif handlers[7].Remotes.CommF_:InvokeServer(unpack(t116[2])) == 2 then
							Super_human = true

							if handlers[35].Character.Superhuman.Level.Value >= 400 then
								Super_humanw_C_M = true
							end

							if Super_human then
								break
							end
						end
					end
				end
			until Super_human

			if not Death_Step then
				local ok = handlers[7].Remotes.CommF_:InvokeServer("BuyDeathStep") == 1

				if not ok then
					ok = handlers[7].Remotes.CommF_:InvokeServer("BuyDeathStep") == 2
				end

				if ok then
					Death_Step = true
				end
			end

			if Black_Leg_C_M then
				repeat
					task.wait(handlers[21])
					handlers[14]()

					local t117 = { handlers[35].Character:FindFirstChild("Death Step") }

					if t117[1] then
						if t117[1]:FindFirstChild("Level") and t117[1].Level.Value >= 400 then
							handlers[7].Remotes.CommF_:InvokeServer("BuyBlackLeg")

							local t118 = { handlers[35].Character:FindFirstChild("Black Leg") }

							if t118[1] then
								if t118[1]:FindFirstChild("Level") and t118[1].Level.Value >= 400 then
									Black_Leg_C_M = true
								end
							end
						end
					end
				until Black_Leg_C_M
			end

			if not Death_Step_C_M then
				repeat
					task.wait(handlers[21])
					handlers[14]()
					handlers[7].Remotes.CommF_:InvokeServer("BuyDeathStep")

					local t119 = { handlers[35].Character:FindFirstChild("Death Step") }

					if t119[1] then
						if t119[1]:FindFirstChild("Level") and t119[1].Level.Value >= 400 then
							Death_Step_C_M = true
						end
					end
				until Death_Step_C_M
			end

			if not Electro_C_M then
				repeat
					task.wait(handlers[21])
					handlers[14]()
					handlers[7].Remotes.CommF_:InvokeServer("BuyElectro")

					local t120 = { handlers[35].Character:FindFirstChild("Electro") }

					if t120[1] then
						if t120[1]:FindFirstChild("Level") and t120[1].Level.Value >= 400 then
							Electro_C_M = true
						end
					end
				until Electro_C_M
			end

			if not Fishman_Karate_C_M then
				repeat
					task.wait(handlers[21])
					handlers[7].Remotes.CommF_:InvokeServer("BuyFishmanKarate")
					warn()

					local t121 = { handlers[35].Character:FindFirstChild("Fishman Karate") }

					if t121[1] then
						if t121[1]:FindFirstChild("Level") and t121[1].Level.Value >= 400 then
							Fishman_Karate_C_M = true
						end
					end
				until Fishman_Karate_C_M
			end

			if not Dragon_Claw_C_M then
				repeat
					task.wait(handlers[21])
					handlers[14]()
					handlers[7].Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")

					local t122 = { handlers[35].Character:FindFirstChild("Dragon Claw") }

					if t122[1] then
						if t122[1]:FindFirstChild("Level") and t122[1].Level.Value >= 400 then
							Dragon_Claw_C_M = true
						end
					end
				until Dragon_Claw_C_M
			end

			if not Sharkman_Karate_C then
				repeat
					handlers[45].wt(handlers[21])
					handlers[14]()
					handlers[7].Remotes.CommF_:InvokeServer("BuySharkmanKarate")

					if handlers[45].ffc(handlers[35].Backpack, "Sharkman Karate") or handlers[45].ffc(handlers[35].Character, "Sharkman Karate") then
						Sharkman_Karate_C = true
					end
				until Sharkman_Karate_C
			end

			if not Sharkman_Karate_C_M then
				repeat
					task.wait(handlers[21])
					handlers[14]()
					handlers[7].Remotes.CommF_:InvokeServer("BuySharkmanKarate")

					local t123 = { handlers[35].Character:FindFirstChild("Sharkman Karate") }

					if t123[1] then
						if t123[1]:FindFirstChild("Level") and t123[1].Level.Value >= 400 then
							Sharkman_Karate_C_M = true
						end
					end
				until Sharkman_Karate_C_M
			end

			if not Electric_Claw_C then
				repeat
					task.wait(handlers[21])

					if handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw") == 1 then
						Electric_Claw_C = true
					elseif handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw") == 2 then
						Electric_Claw_C = true

						if Electric_Claw_C then
							break
						end
					end
				until Electric_Claw_C
			end

			if not Electric_Claw_C_M then
				repeat
					local t124 = {}

					task.wait(handlers[21])
					handlers[14]()
					handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw")
					t124[2] = handlers[35].Character:FindFirstChild("Electric Claw")

					if t124[2] then
						if t124[2]:FindFirstChild("Level") and t124[2].Level.Value >= 400 then
							Electric_Claw_C_M = true
						end
					end
				until Electric_Claw_C_M
			end

			if not Dragon_Talon_C then
				repeat
					task.wait(handlers[21])

					if handlers[7].Remotes.CommF_:InvokeServer("BuyDragonTalon") == 1 then
						Dragon_Talon_C = true
					elseif handlers[7].Remotes.CommF_:InvokeServer("BuyDragonTalon") == 2 then
						Dragon_Talon_C = true

						if Dragon_Talon_C then
							break
						end
					end
				until Dragon_Talon_C
			end

			if not Dragon_Talon_C_M then
				repeat
					task.wait(handlers[21])
					handlers[14]()
					handlers[7].Remotes.CommF_:InvokeServer("BuyDragonTalon")

					local t125 = { handlers[35].Character:FindFirstChild("Dragon Talon") }

					if t125[1] then
						if t125[1]:FindFirstChild("Level") and t125[1].Level.Value >= 400 then
							Dragon_Talon_C_M = true
						end
					end
				until Dragon_Talon_C_M
			end

			if not God_Human_C then
				repeat
					task.wait(handlers[21])

					if handlers[7].Remotes.CommF_:InvokeServer("BuyGodhuman") == 1 then
						God_Human_C = true
					elseif handlers[7].Remotes.CommF_:InvokeServer("BuyGodhuman") == 2 then
						God_Human_C = true

						if God_Human_C then
							break
						end
					end
				until God_Human_C
			end

			if not God_Human_C_M then
				repeat
					local t126 = {}

					task.wait(handlers[21])
					handlers[14]()
					handlers[7].Remotes.CommF_:InvokeServer("BuyGodhuman")
					t126[2] = handlers[35].Character:FindFirstChild("Godhuman")

					if t126[2] then
						if t126[2]:FindFirstChild("Level") and t126[2].Level.Value >= 400 then
							God_Human_C_M = true
						end
					end
				until God_Human_C_M
			end
		end, warn)
	end
end)
getgenv().AutoFarm = true

if handlers[7].Remotes.CommF_:InvokeServer("BuySharkmanKarate", true) ~= handlers[3]({
	"I lost my house keys",
	", could you help me ",
	"find them? Thanks."
}) then
	CheckFindWaterKey = true
end

if handlers[24].Value >= 2000 and getgenv().Configs.Quest["RGB Haki"] then
	if handlers[7].Remotes.CommF_:InvokeServer("HornedMan", "Bet") == 1 then
		RGB_Haki_H = true
	end
end

handlers[50] = function()
	if handlers[45].gi("Cursed Dual Katana") or not handlers[45].gi("Tushita") or not handlers[45].gi("Yama") then
		return false
	end

	for k, v in pairs(({ (game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) })[1]) do
		local t127 = {
			[3] = k,
			[2] = v
		}

		if t127[2].Type == "Sword" then
			if t127[2].Name == "Tushita" and t127[2].Mastery >= 400 then
				Tushita_M = true
			elseif t127[2].Name == "Yama" and t127[2].Mastery >= 400 then
				Yama_M = true
			end
		end
	end

	return Tushita_M and Yama_M
end
task.spawn(function()
	while handlers[45].wt() do
		xpcall(function()
			if getgenv().AutoFarm then
				Stop_Fast_Attack = false

				if handlers[24].Value >= 1500 or RainbowSaviour then
					if handlers[7]:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/FruitCustomizerRF"):InvokeServer({
						StorageName = "Rainbow Saviour",
						Type = "AuraSkin",
						Context = "Equip"
					}) ~= false then
						handlers[7]:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/FruitCustomizerRF"):InvokeServer({
							StorageName = "Rainbow Saviour",
							Type = "AuraSkin",
							Context = "Equip"
						})
					end
				end

				local t128 = { false }

				if handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("Cousin", "Buy") == 1 then
					handlers[45].wt(1)
					handlers[38]()
				else
					for k, child in pairs(handlers[19]:GetChildren()) do
						local t129 = {
							k,
							[3] = child
						}

						if t129[3]:GetAttribute("OriginalName") ~= nil then
							if handlers[45].sf(t129[3].Name, "Fruit") then
								if t129[3]:IsA("Tool") then
									if not handlers[45].IsInList(handlers[45].GetType(), t129[3]:GetAttribute("OriginalName")) then
										while true do
											handlers[45].wt(0.1)
											handlers[45].Status(" Status : TP To " .. t129[3].Name)
											TPZ(t129[3].Handle.CFrame)
											t128[1] = true
											handlers[38]()

											if not t129[3] then
												break
											end

											if not game.Players.LocalPlayer.Backpack:FindFirstChild(t129[3].Name) then
												if not handlers[45].IsInList(handlers[45].GetType(), t129[3]:GetAttribute("OriginalName")) and not ((t129[3].Handle.Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 10) and getgenv().AutoFarm then
													continue
												end
											end

											break
										end
									end
								end
							end
						end
					end

					if not t128[1] then
						if handlers[45].tf(Configs.Gun, "Magma Blaster") and handlers[24].Value >= 200 and not handlers[45].gi("Magma Blaster") and Old_World and handlers[45].CheckBoss("Magma Admiral") then
							Quest = "Magma Blaster"

							return
						end

						if handlers[45].tf(Configs.Gun, "Bazooka") and handlers[24].Value >= 200 and not handlers[45].gi("Bazooka") and Old_World and handlers[45].CheckBoss("Wysper") then
							Quest = "Bazooka"

							return
						end

						if handlers[45].tf(Configs.Sword, "Saber") and handlers[24].Value >= 200 then
							if not handlers[45].gi("Saber") then
								Quest = "Saber"

								return
							end
						end

						if handlers[45].tf(Configs.Sword, "Shark Saw") and handlers[24].Value >= 100 and not handlers[45].gi("Shark Saw") and Old_World and handlers[45].CheckBoss("The Saw") then
							Quest = "Shark Saw"

							return
						end

						if handlers[45].tf(Configs.Sword, "Wardens Sword") and handlers[24].Value >= 100 and not handlers[45].gi("Wardens Sword") and Old_World and handlers[45].CheckBoss("Chief Warden") then
							Quest = "Wardens Sword"

							return
						end

						if handlers[45].tf(Configs.Sword, "Pole (1st Form)") and handlers[24].Value >= 100 and not handlers[45].gi("Pole (1st Form)") and Old_World and handlers[45].CheckBoss("Thunder God") then
							Quest = "Pole (1st Form)"

							return
						end

						if handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("Alchemist", "1") ~= -2 and handlers[1].Value >= 2500000 and handlers[24].Value >= 850 then
							if handlers[7].Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 3 and not handlers[45].ffc(handlers[35].Data.Race, "Evolved") then
								Quest = "Evo Race V1"

								return
							end
						end

						if handlers[7].Remotes.CommF_:InvokeServer("Wenlocktoad", "3") ~= -2 then
							if handlers[7].Remotes.CommF_:InvokeServer("TalkTrevor", "1") == 0 and handlers[45].IsHeavenly() and handlers[22].Value >= 1400 and handlers[1].Value >= 2000000 then
								Quest = "Evo Race V2"

								return
							end
						end

						if handlers[45].tf(Configs.Sword, "Gravity Blade") and not handlers[45].gi("Gravity Blade") and New_World and handlers[45].CheckBoss("Orbitus") and handlers[24].Value >= 800 then
							Quest = "Gravity Blade"

							return
						end

						if handlers[45].tf(Configs.Sword, "Longsword") and not handlers[45].gi("Longsword") and New_World and handlers[45].CheckBoss("Diamond") and handlers[24].Value >= 800 then
							Quest = "Longsword"

							return
						end

						if handlers[45].tf(Configs.Sword, "Rengoku") and not handlers[45].gi("Rengoku") and New_World and handlers[45].CheckBoss("Awakened Ice Admiral") and handlers[24].Value >= 800 then
							Quest = "Rengoku"

							return
						end

						if handlers[45].IsHall() and New_World and handlers[45].CheckBoss("Awakened Ice Admiral") and handlers[24].Value >= 800 then
							Quest = "Rengoku"

							return
						end

						if not handlers[45].gi("Rengoku") and handlers[45].CheckBackpack("Hidden Key") and New_World then
							while true do
								handlers[45].wt(0.3)
								handlers[45].Status(handlers[3]({
									" Status : Use Hidden",
									" Key"
								}))
								handlers[45].Equip("Hidden Key")
								handlers[31](CFrame.new(6572.29248, 295.712677, -6966.09961, 0.803500533, -3.27515153e-08, 0.595304072, 3.97485422e-08, 1, 1.36659384e-09, -0.595304072, 2.25644108e-08, 0.803500533), 1.5)

								if (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(6572.29248, 295.712677, -6966.09961)).Magnitude <= 5 then
									break
								elseif not getgenv().AutoFarm then
									break
								end
							end

							handlers[45].wt(1)

							return
						end

						if New_World and handlers[45].IsHall() and handlers[45].CheckBackpack("Library Key") then
							while true do
								handlers[45].wt(0.1)
								handlers[45].Status(handlers[3]({
									" Status : Use Librar",
									"y Key"
								}))
								handlers[45].Equip("Library Key")
								handlers[31](CFrame.new(6377.12549, 296.634735, -6843.76025, -0.860993743, 1.17677516e-07, -0.508615494, 1.31121894e-07, 1, 9.40274347e-09, 0.508615494, -5.8594928e-08, -0.860993743), 1.5)

								if (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(6377.12549, 296.634735, -6843.76025)).Magnitude <= 1 then
									break
								elseif not handlers[45].IsHall() or not getgenv().AutoFarm then
									break
								end
							end

							handlers[45].wt(1)

							return
						end

						if handlers[45].tf(Configs.Sword, "Flail") and not handlers[45].gi("Flail") and New_World and handlers[45].CheckBoss("Smoke Admiral") then
							Quest = "Flail"

							return
						end

						if handlers[7].Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") ~= 3 and handlers[24].Value >= 850 then
							Quest = "BartiloQuest"

							return
						end

						if not CheckFindWaterKey and handlers[7].Remotes.CommF_:InvokeServer("BuySharkmanKarate", true) == handlers[3]({
							"I lost my house keys",
							", could you help me ",
							"find them? Thanks."
						}) and handlers[24].Value >= 850 then
							Quest = "Find Water Key"

							return
						end

						if New_World and not handlers[45].IsHeavenly() then
							if handlers[7].Remotes.CommF_:InvokeServer("TalkTrevor", "1") == 0 then
								Quest = "Don Swan"

								return
							end
						end

						if Three_World and handlers[45].tf(Configs.Sword, "Yama") then
							if handlers[7].Remotes.CommF_:InvokeServer("EliteHunter", "Progress") >= 30 and not handlers[45].gi("Yama") then
								Quest = "Yama"

								return
							end
						end

						if Three_World and handlers[45].tf(Configs.Sword, "Tushita") and not handlers[45].gi("Tushita") and Unlock_Tushita_Quest then
							Quest = "Longma"

							return
						end

						if handlers[45].tf(Configs.Gun, "Soul Guitar") and not handlers[45].gi("Soul Guitar") and handlers[24].Value >= 2000 and handlers[45].CheckItem("Dark Fragment") >= 1 then
							Quest = "Soul Guitar"

							return
						end

						if handlers[24].Value >= 2000 and getgenv().Configs.Quest["RGB Haki"] and not RGB_Haki_H then
							if handlers[7].Remotes.CommF_:InvokeServer("HornedMan", "Bet") == nil then
								Quest = "RGB"

								return
							end
						end

						if handlers[45].tf(Configs.Gun, "Venom Bow") and not handlers[45].gi("Venom Bow") and Three_World and handlers[45].CheckBoss("Hydra Leader") then
							Quest = "Venom Bow"

							return
						end

						if handlers[45].tf(Configs.Sword, "Twin Hooks") and not handlers[45].gi("Twin Hooks") and Three_World and handlers[45].CheckBoss("Captain Elephant") then
							Quest = "Twin Hooks"

							return
						end

						if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
							if not handlers[7].Remotes.CommF_:InvokeServer("CheckTempleDoor") then
								if handlers[7].Remotes.CommF_:InvokeServer("Wenlocktoad", "3") == -2 and Mirror_Fractal_H then
									Quest = "Pull Lerver"

									return
								end
							end
						end

						if handlers[50]() then
							Quest = "Cursed Dual Katana"

							return
						end

						if not Dragon_Talon_C and (handlers[45].ffc(handlers[35].Backpack, "Fire Essence") or handlers[45].ffc(handlers[35].Character, "Fire Essence")) then
							while true do
								handlers[45].Status(handlers[3]({
									" Status : Use Fire E",
									"ssence"
								}))
								handlers[45].Equip("Fire Essence")
								handlers[45].wt(0.5)
								handlers[7].Remotes.CommF_:InvokeServer("BuyDragonTalon", true)
								handlers[7].Remotes.CommF_:InvokeServer("BuyDragonTalon")

								if handlers[45].ffc(handlers[35].Backpack, "Fire Essence") then
									continue
								end

								if not handlers[45].ffc(handlers[35].Character, "Fire Essence") then
									break
								end
							end

							handlers[7].Remotes.CommF_:InvokeServer("BuyDragonTalon")
							Dragon_Talon_C = true

							return
						end

						if Fishman_Karate_C_M and not Dragon_Claw_C and handlers[24].Value >= 1100 then
							if Dragon_Claw_C then
								return
							end

							while true do
								handlers[45].wt()
								handlers[14]()

								if handlers[45].ffc(handlers[35].Backpack, "Dragon Claw") or handlers[45].ffc(handlers[35].Character, "Dragon Claw") then
									break
								end

								if not Dragon_Claw_C and handlers[24].Value >= 1100 then
									if handlers[17].Value >= 1500 then
										handlers[7].Remotes.CommF_:InvokeServer(unpack(({ {
											"BlackbeardReward",
											"DragonClaw",
											"2"
										} })[1]))
										Dragon_Claw_C = true

										return
									end

									if handlers[17].Value < 1500 then
										if handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible and handlers[17].Value < 1500 and not Dragon_Claw_C then
											handlers[45].Status(" Status : Farm Raid")

											if #handlers[45].GetMobRaid() == 0 then
												if Select_Map == "Magma" or Select_Map == "Flame" then
													for k, descendant in pairs(handlers[19]:GetDescendants()) do
														local t130 = {
															[3] = k,
															[2] = descendant
														}

														if t130[2].Name == "Lava" then
															t130[2]:Destroy()
														end
													end
												end

												if handlers[45].GetRaid("Island 5", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 5", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 4", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 4", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 3", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 3", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 2", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 2", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 1", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 1", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												end
											else
												for k, child in pairs(handlers[40]:GetChildren()) do
													local t131 = {
														[2] = k,
														child
													}

													if t131[1]:FindFirstChild("HumanoidRootPart") then
														if t131[1]:FindFirstChild("Humanoid") then
															if t131[1]:FindFirstChild("Humanoid").Health > 0 and (handlers[35].Character.HumanoidRootPart.CFrame.Position - t131[1].HumanoidRootPart.CFrame.Position).Magnitude <= 5000 then
																repeat
																	local t132 = {}

																	handlers[45].wt(0.1)

																	if Select_Map == "Magma" or Select_Map == "Flame" then
																		for k2, descendant in pairs(handlers[19]:GetDescendants()) do
																			local t133 = {
																				k2,
																				descendant
																			}

																			if t133[2].Name == "Lava" then
																				t133[2]:Destroy()
																			end
																		end
																	end

																	t132[2] = math.random(1, 5)

																	if t132[2] == 1 then
																		t132[3] = CFrame.new(0, 30, 1)
																	elseif t132[2] == 2 then
																		t132[3] = CFrame.new(0, 30, 15)
																	elseif t132[2] == 3 then
																		t132[3] = CFrame.new(1, 30, -15)
																	elseif t132[2] == 4 then
																		t132[3] = CFrame.new(15, 30, 0)
																	elseif t132[2] == 5 then
																		t132[3] = CFrame.new(-15, 30, 0)
																	end

																	handlers[31](t131[1].HumanoidRootPart.CFrame * t132[3], 1.5)

																	if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
																		handlers[7].Remotes.CommF_:InvokeServer("Buso")
																	end

																	handlers[14]()
																until not t131[1].Parent or t131[1].Humanoid.Health <= 0 or #handlers[45].GetMobRaid() == 0
															end
														end
													end
												end
											end
										else
											if handlers[35].Data.DevilFruit.Value == "Dark-Dark" then
												Select_Map = "Dark"
											elseif handlers[35].Data.DevilFruit.Value == "Sand-Sand" then
												Select_Map = "Sand"
											elseif handlers[35].Data.DevilFruit.Value == "Magma-Magma" then
												Select_Map = "Magma"
											elseif handlers[35].Data.DevilFruit.Value == "Rumble-Rumble" then
												Select_Map = "Rumble"
											elseif handlers[35].Data.DevilFruit.Value == "Flame-Flame" then
												Select_Map = "Flame"
											elseif handlers[35].Data.DevilFruit.Value == "Ice-Ice" then
												Select_Map = "Ice"
											elseif handlers[35].Data.DevilFruit.Value == "Light-Light" then
												Select_Map = "Light"
											elseif handlers[35].Data.DevilFruit.Value == "String-String" then
												Select_Map = "String"
											elseif handlers[35].Data.DevilFruit.Value == "Quake-Quake" then
												Select_Map = "Quake"
											elseif handlers[35].Data.DevilFruit.Value == "Buddha-Buddha" then
												Select_Map = "Buddha"
											else
												Select_Map = "Ice"
											end

											handlers[7].Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Select_Map)
											handlers[45].wt(0.2)

											local ok12 = handlers[35].Backpack:FindFirstChild("Special Microchip")

											if not ok12 then
												ok12 = not (not handlers[35].Character:FindFirstChild("Special Microchip") or not (handlers[35].Character.Humanoid.Health > 0))
											end

											if ok12 then
												if handlers[30] == 4442272183 and handlers[35].Character.Humanoid.Health > 0 then
													local t134 = {}

													fireclickdetector(handlers[19].Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector, 1)
													t134[2] = 0

													while true do
														t134[2] += 1
														handlers[45].wt(1)

														if t134[2] >= 20 then
															break
														elseif handlers[35].PlayerGui.Main.Timer.Visible == true then
															break
														end
													end
												elseif handlers[30] == 7449423635 then
													handlers[31](CFrame.new(-5034, 315, -2951), 1.5)

													if (CFrame.new(-5034, 315, -2951).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 and handlers[35].Character.Humanoid.Health > 0 then
														fireclickdetector(handlers[19].Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector, 1)

														local t135 = { 0 }

														while true do
															t135[1] += 1
															handlers[45].wt(1)

															if t135[1] >= 20 then
																break
															elseif handlers[35].PlayerGui.Main.Timer.Visible == true then
																break
															end
														end
													end
												end
											elseif not handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible then
												if handlers[1].Value >= 0 and handlers[35].Data.Fragments.Value >= 1500 then
													game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(({
														[2] = {
															"BlackbeardReward",
															"DragonClaw",
															"2"
														}
													})[2]))
													Dragon_Claw_C = true

													return
												end

												table.sort(handlers[45].GetFruits(), function(p62, p63)
													local t136 = {
														[2] = p62,
														p63
													}

													if t136[2].Value < 100000 then
														if t136[2].Value < 100000 then
															return t136[2].Value < t136[1].Value
														end
													end
												end)
												handlers[45].wt(1)

												if #handlers[45].GetFruits() > 0 and not Dragon_Claw_C then
													handlers[45].wt(2)

													if not handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible then
														if handlers[35].Character.Humanoid.Health > 0 and handlers[35].Data.Fragments.Value < 5000 then
															handlers[7].Remotes.CommF_:InvokeServer("LoadFruit", handlers[45].GetFruits()[1].Name)
														elseif handlers[17].Value < 5000 then
															return
														end

														if handlers[35].Data.DevilFruit.Value == "Dark-Dark" then
															Select_Map = "Dark"
														elseif handlers[35].Data.DevilFruit.Value == "Sand-Sand" then
															Select_Map = "Sand"
														elseif handlers[35].Data.DevilFruit.Value == "Magma-Magma" then
															Select_Map = "Magma"
														elseif handlers[35].Data.DevilFruit.Value == "Rumble-Rumble" then
															Select_Map = "Rumble"
														elseif handlers[35].Data.DevilFruit.Value == "Flame-Flame" then
															Select_Map = "Flame"
														elseif handlers[35].Data.DevilFruit.Value == "Ice-Ice" then
															Select_Map = "Ice"
														elseif handlers[35].Data.DevilFruit.Value == "Light-Light" then
															Select_Map = "Light"
														elseif handlers[35].Data.DevilFruit.Value == "String-String" then
															Select_Map = "String"
														elseif handlers[35].Data.DevilFruit.Value == "Quake-Quake" then
															Select_Map = "Quake"
														elseif handlers[35].Data.DevilFruit.Value == "Buddha-Buddha" then
															Select_Map = "Buddha"
														else
															Select_Map = "Ice"
														end

														handlers[7].Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Select_Map)

														if handlers[30] == 4442272183 and handlers[35].Character.Humanoid.Health > 0 then
															local t137 = {}

															fireclickdetector(handlers[19].Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector, 1)
															t137[2] = 0

															repeat
																t137[2] += 1
																handlers[45].wt(1)
															until t137[2] >= 20 or handlers[35].PlayerGui.Main.Timer.Visible
														elseif handlers[30] == 7449423635 then
															handlers[31](CFrame.new(-5034, 315, -2951), 1.5)

															if (CFrame.new(-5034, 315, -2951).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 and handlers[35].Character.Humanoid.Health > 0 then
																fireclickdetector(handlers[19].Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector, 1)

																local t138 = { 0 }

																while true do
																	t138[1] += 1
																	handlers[45].wt(1)

																	if t138[1] >= 20 then
																		break
																	elseif handlers[35].PlayerGui.Main.Timer.Visible then
																		break
																	end
																end
															end
														end
													end
												else
													Quest = nil
													handlers[45].Status(handlers[3]({
														" Status : Auto Farm ",
														"Level"
													}))
													handlers[39]()
												end
											end
										end
									end
								end

								if Dragon_Claw_C then
									return
								end
							end

							Dragon_Claw_C = true

							return
						end

						local handlers2 = {
							function()
								for k, v in pairs(handlers[7].Remotes.CommF_:InvokeServer("getInventory")) do
									local t139 = {
										[3] = k,
										v
									}

									if t139[1].Value and t139[1].Value >= 1000000 then
										return true
									end
								end

								return false
							end
						}

						if handlers[7].Remotes.CommF_:InvokeServer("TalkTrevor", "1") ~= 0 and game.Players.LocalPlayer.Data.Level.Value >= 900 and handlers2[1]() then
							repeat
								handlers[45].wt()
								noFruit = true

								for k, v in pairs(handlers[7].Remotes.CommF_:InvokeServer("getInventory")) do
									local t140 = {
										[2] = k,
										v
									}

									if not t140[1].Value or not (t140[1].Value >= 1000000) then
										continue
									end

									handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("LoadFruit", t140[1].Name)
									handlers[45].wt(1)

									for k2, child in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
										local t141 = {
											[3] = k2,
											child
										}

										if string.find(t141[1].Name, "Fruit") then
											handlers[45].Equip(t141[1])
										end
									end

									handlers[45].wt(0.2)
									handlers[7].Remotes.CommF_:InvokeServer("TalkTrevor", "1")
									handlers[7].Remotes.CommF_:InvokeServer("TalkTrevor", "2")
									handlers[7].Remotes.CommF_:InvokeServer("TalkTrevor", "3")

									return
								end
							until handlers[7].Remotes.CommF_:InvokeServer("TalkTrevor", "1") == 0 or not handlers2[1]()

							noFruit = false
						end

						if handlers[24].Value >= 1500 then
							if not (handlers[7].Remotes.CommF_:InvokeServer("TalkTrevor", "1") == 0 or handlers2[1]()) then
								handlers[45].HopLowServer(10)

								return
							end
						end

						if Super_human and not Death_Step and handlers[24].Value >= 1100 then
							if Death_Step then
								return
							end

							while true do
								handlers[45].wt()
								handlers[14]()

								if not Super_humanw_C_M then
									handlers[7].Remotes.CommF_:InvokeServer("BuySuperhuman")

									if handlers[35].Character.Superhuman.Level.Value < 400 then
										repeat
											handlers[45].wt()
											handlers[14]()
											Quest = nil
											handlers[45].Status(handlers[3]({
												" Status : Auto Farm ",
												"Level"
											}))
											handlers[39]()
										until handlers[35].Character.Superhuman.Level.Value >= 400

										Super_humanw_C_M = true
									end
								end

								if handlers[45].ffc(handlers[35].Backpack, "Death Step") or handlers[45].ffc(handlers[35].Character, "Death Step") then
									break
								end

								if not Death_Step and handlers[24].Value >= 1100 then
									if handlers[17].Value >= 5000 then
										if not Black_Leg_C_M then
											repeat
												handlers[45].wt()
												handlers[7].Remotes.CommF_:InvokeServer("BuyBlackLeg")
												handlers[14]()
												Quest = nil
												handlers[45].Status(handlers[3]({
													" Status : Auto Farm ",
													"Level"
												}))
												handlers[39]()
											until handlers[35].Character["Black Leg"].Level.Value >= 400

											Black_Leg_C_M = true

											if not Super_human then
												handlers[7].Remotes.CommF_:InvokeServer("BuySuperhuman")
											end

											return
										end

										if handlers[1].Value >= 2500000 then
											handlers[7].Remotes.CommF_:InvokeServer("BuyDeathStep")
											Death_Step = true

											return
										end

										handlers[14]()
										Quest = nil
										handlers[45].Status(handlers[3]({
											" Status : Auto Farm ",
											"Level"
										}))
										handlers[39]()
									elseif handlers[17].Value < 5000 then
										if handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible and handlers[17].Value < 5000 and not Death_Step then
											handlers[45].Status(" Status : Farm Raid")

											if #handlers[45].GetMobRaid() == 0 then
												if Select_Map == "Magma" or Select_Map == "Flame" then
													for k, descendant in pairs(handlers[19]:GetDescendants()) do
														local t142 = {
															[2] = k,
															descendant
														}

														if t142[1].Name == "Lava" then
															t142[1]:Destroy()
														end
													end
												end

												if handlers[45].GetRaid("Island 5", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 5", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 4", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 4", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 3", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 3", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 2", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 2", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 1", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 1", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												end
											else
												for k, child in pairs(handlers[40]:GetChildren()) do
													local t143 = {
														[2] = k,
														child
													}

													if t143[1]:FindFirstChild("HumanoidRootPart") then
														if t143[1]:FindFirstChild("Humanoid") then
															if t143[1]:FindFirstChild("Humanoid").Health > 0 and (handlers[35].Character.HumanoidRootPart.CFrame.Position - t143[1].HumanoidRootPart.CFrame.Position).Magnitude <= 5000 then
																repeat
																	local t144 = {}

																	handlers[45].wt(0.1)

																	if Select_Map == "Magma" or Select_Map == "Flame" then
																		for k2, descendant in pairs(handlers[19]:GetDescendants()) do
																			local t145 = {
																				k2,
																				[3] = descendant
																			}

																			if t145[3].Name == "Lava" then
																				t145[3]:Destroy()
																			end
																		end
																	end

																	t144[2] = math.random(1, 5)

																	if t144[2] == 1 then
																		t144[1] = CFrame.new(0, 30, 1)
																	elseif t144[2] == 2 then
																		t144[1] = CFrame.new(0, 30, 15)
																	elseif t144[2] == 3 then
																		t144[1] = CFrame.new(1, 30, -15)
																	elseif t144[2] == 4 then
																		t144[1] = CFrame.new(15, 30, 0)
																	elseif t144[2] == 5 then
																		t144[1] = CFrame.new(-15, 30, 0)
																	end

																	handlers[31](t143[1].HumanoidRootPart.CFrame * t144[1], 1.5)

																	if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
																		handlers[7].Remotes.CommF_:InvokeServer("Buso")
																	end

																	handlers[14]()
																until not t143[1].Parent or t143[1].Humanoid.Health <= 0 or #handlers[45].GetMobRaid() == 0
															end
														end
													end
												end
											end
										else
											if handlers[35].Data.DevilFruit.Value == "Dark-Dark" then
												Select_Map = "Dark"
											elseif handlers[35].Data.DevilFruit.Value == "Sand-Sand" then
												Select_Map = "Sand"
											elseif handlers[35].Data.DevilFruit.Value == "Magma-Magma" then
												Select_Map = "Magma"
											elseif handlers[35].Data.DevilFruit.Value == "Rumble-Rumble" then
												Select_Map = "Rumble"
											elseif handlers[35].Data.DevilFruit.Value == "Flame-Flame" then
												Select_Map = "Flame"
											elseif handlers[35].Data.DevilFruit.Value == "Ice-Ice" then
												Select_Map = "Ice"
											elseif handlers[35].Data.DevilFruit.Value == "Light-Light" then
												Select_Map = "Light"
											elseif handlers[35].Data.DevilFruit.Value == "String-String" then
												Select_Map = "String"
											elseif handlers[35].Data.DevilFruit.Value == "Quake-Quake" then
												Select_Map = "Quake"
											elseif handlers[35].Data.DevilFruit.Value == "Buddha-Buddha" then
												Select_Map = "Buddha"
											else
												Select_Map = "Ice"
											end

											handlers[7].Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Select_Map)
											handlers[45].wt(0.2)

											local ok10 = handlers[35].Backpack:FindFirstChild("Special Microchip")

											if not ok10 then
												ok10 = not (not handlers[35].Character:FindFirstChild("Special Microchip") or not (handlers[35].Character.Humanoid.Health > 0))
											end

											if ok10 then
												if handlers[30] == 4442272183 and handlers[35].Character.Humanoid.Health > 0 then
													fireclickdetector(handlers[19].Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector, 1)

													local t146 = { 0 }

													while true do
														t146[1] += 1
														handlers[45].wt(1)

														if t146[1] >= 20 then
															break
														elseif handlers[35].PlayerGui.Main.Timer.Visible == true then
															break
														end
													end
												elseif handlers[30] == 7449423635 then
													handlers[31](CFrame.new(-5034, 315, -2951), 1.5)

													if (CFrame.new(-5034, 315, -2951).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 and handlers[35].Character.Humanoid.Health > 0 then
														fireclickdetector(handlers[19].Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector, 1)

														local t147 = { 0 }

														while true do
															t147[1] += 1
															handlers[45].wt(1)

															if t147[1] >= 20 then
																break
															elseif handlers[35].PlayerGui.Main.Timer.Visible then
																break
															end
														end
													end
												end
											elseif not handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible then
												if handlers[35].Data.Fragments.Value >= 5000 then
													if not (handlers[35].Data.Beli.Value >= 2500000) then
														return
													end

													handlers[7].Remotes.CommF_:InvokeServer("BuyDeathStep")
													Death_Step = true

													return
												end

												table.sort(handlers[45].GetFruits(), function(p64, p65)
													local t148 = {
														[3] = p64,
														p65
													}

													if t148[3].Value < 100000 and t148[3].Value < 100000 then
														return t148[3].Value < t148[1].Value
													end
												end)
												handlers[45].wt(1)

												if #handlers[45].GetFruits() > 0 and not Death_Step then
													warn()
													handlers[45].wt(2)

													if not handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible then
														if handlers[35].Character.Humanoid.Health > 0 and handlers[35].Data.Fragments.Value < 5000 then
															handlers[7].Remotes.CommF_:InvokeServer("LoadFruit", handlers[45].GetFruits()[1].Name)
														elseif handlers[17].Value < 5000 then
															return
														end

														if handlers[35].Data.DevilFruit.Value == "Dark-Dark" then
															Select_Map = "Dark"
														elseif handlers[35].Data.DevilFruit.Value == "Sand-Sand" then
															Select_Map = "Sand"
														elseif handlers[35].Data.DevilFruit.Value == "Magma-Magma" then
															Select_Map = "Magma"
														elseif handlers[35].Data.DevilFruit.Value == "Rumble-Rumble" then
															Select_Map = "Rumble"
														elseif handlers[35].Data.DevilFruit.Value == "Flame-Flame" then
															Select_Map = "Flame"
														elseif handlers[35].Data.DevilFruit.Value == "Ice-Ice" then
															Select_Map = "Ice"
														elseif handlers[35].Data.DevilFruit.Value == "Light-Light" then
															Select_Map = "Light"
														elseif handlers[35].Data.DevilFruit.Value == "String-String" then
															Select_Map = "String"
														elseif handlers[35].Data.DevilFruit.Value == "Quake-Quake" then
															Select_Map = "Quake"
														elseif handlers[35].Data.DevilFruit.Value == "Buddha-Buddha" then
															Select_Map = "Buddha"
														else
															Select_Map = "Ice"
														end

														handlers[7].Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Select_Map)

														if handlers[30] == 4442272183 and handlers[35].Character.Humanoid.Health > 0 then
															local t149 = {}

															fireclickdetector(handlers[19].Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector, 1)
															t149[2] = 0

															repeat
																t149[2] += 1
																handlers[45].wt(1)
															until t149[2] >= 20 or handlers[35].PlayerGui.Main.Timer.Visible
														elseif handlers[30] == 7449423635 then
															handlers[31](CFrame.new(-5034, 315, -2951), 1.5)

															if (CFrame.new(-5034, 315, -2951).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 and handlers[35].Character.Humanoid.Health > 0 then
																fireclickdetector(handlers[19].Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector, 1)

																local t150 = { 0 }

																while true do
																	t150[1] += 1
																	handlers[45].wt(1)

																	if t150[1] >= 20 then
																		break
																	elseif handlers[35].PlayerGui.Main.Timer.Visible then
																		break
																	end
																end
															end
														end
													end
												else
													Quest = nil
													handlers[45].Status(handlers[3]({
														" Status : Auto Farm ",
														"Level"
													}))
													handlers[39]()
												end
											end
										end
									end
								end

								if Death_Step then
									return
								end
							end

							Death_Step = true

							return
						end

						if Dragon_Claw_C_M and not Sharkman_Karate_C and handlers[24].Value >= 1100 then
							if Sharkman_Karate_C then
								return
							end

							while true do
								handlers[45].wt()
								handlers[14]()

								if handlers[45].ffc(handlers[35].Backpack, "Sharkman Karate") or handlers[45].ffc(handlers[35].Character, "Sharkman Karate") then
									break
								end

								if not Sharkman_Karate_C and handlers[24].Value >= 1100 then
									if handlers[17].Value >= 5000 then
										if handlers[1].Value >= 2550000 and not Sharkman_Karate_C then
											handlers[7].Remotes.CommF_:InvokeServer("BuySharkmanKarate")
											Sharkman_Karate_C = true

											return
										end

										handlers[14]()
										Quest = nil
										handlers[45].Status(handlers[3]({
											" Status : Auto Farm ",
											"Level"
										}))
										handlers[39]()
									elseif handlers[17].Value < 5000 then
										if handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible and handlers[17].Value < 5000 and not Sharkman_Karate_C then
											handlers[45].Status(" Status : Farm Raid")

											if #handlers[45].GetMobRaid() == 0 then
												if Select_Map == "Magma" or Select_Map == "Flame" then
													for k, descendant in pairs(handlers[19]:GetDescendants()) do
														local t151 = {
															k,
															[3] = descendant
														}

														if t151[3].Name == "Lava" then
															t151[3]:Destroy()
														end
													end
												end

												if handlers[45].GetRaid("Island 5", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 5", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 4", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 4", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 3", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 3", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 2", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 2", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 1", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 1", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												end
											else
												for k, child in pairs(handlers[40]:GetChildren()) do
													local t152 = {
														[3] = k,
														child
													}

													if t152[1]:FindFirstChild("HumanoidRootPart") then
														if t152[1]:FindFirstChild("Humanoid") then
															if t152[1]:FindFirstChild("Humanoid").Health > 0 and (handlers[35].Character.HumanoidRootPart.CFrame.Position - t152[1].HumanoidRootPart.CFrame.Position).Magnitude <= 5000 then
																repeat
																	local t153 = {}

																	handlers[45].wt(0.1)

																	if Select_Map == "Magma" or Select_Map == "Flame" then
																		for k2, descendant in pairs(handlers[19]:GetDescendants()) do
																			local t154 = {
																				[2] = k2,
																				[3] = descendant
																			}

																			if t154[3].Name == "Lava" then
																				t154[3]:Destroy()
																			end
																		end
																	end

																	t153[2] = math.random(1, 5)

																	if t153[2] == 1 then
																		t153[3] = CFrame.new(0, 30, 1)
																	elseif t153[2] == 2 then
																		t153[3] = CFrame.new(0, 30, 15)
																	elseif t153[2] == 3 then
																		t153[3] = CFrame.new(1, 30, -15)
																	elseif t153[2] == 4 then
																		t153[3] = CFrame.new(15, 30, 0)
																	elseif t153[2] == 5 then
																		t153[3] = CFrame.new(-15, 30, 0)
																	end

																	handlers[31](t152[1].HumanoidRootPart.CFrame * t153[3], 1.5)

																	if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
																		handlers[7].Remotes.CommF_:InvokeServer("Buso")
																	end

																	handlers[14]()
																until not t152[1].Parent or t152[1].Humanoid.Health <= 0 or #handlers[45].GetMobRaid() == 0
															end
														end
													end
												end
											end
										else
											if handlers[35].Data.DevilFruit.Value == "Dark-Dark" then
												Select_Map = "Dark"
											elseif handlers[35].Data.DevilFruit.Value == "Sand-Sand" then
												Select_Map = "Sand"
											elseif handlers[35].Data.DevilFruit.Value == "Magma-Magma" then
												Select_Map = "Magma"
											elseif handlers[35].Data.DevilFruit.Value == "Rumble-Rumble" then
												Select_Map = "Rumble"
											elseif handlers[35].Data.DevilFruit.Value == "Flame-Flame" then
												Select_Map = "Flame"
											elseif handlers[35].Data.DevilFruit.Value == "Ice-Ice" then
												Select_Map = "Ice"
											elseif handlers[35].Data.DevilFruit.Value == "Light-Light" then
												Select_Map = "Light"
											elseif handlers[35].Data.DevilFruit.Value == "String-String" then
												Select_Map = "String"
											elseif handlers[35].Data.DevilFruit.Value == "Quake-Quake" then
												Select_Map = "Quake"
											elseif handlers[35].Data.DevilFruit.Value == "Buddha-Buddha" then
												Select_Map = "Buddha"
											else
												Select_Map = "Ice"
											end

											handlers[7].Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Select_Map)
											handlers[45].wt(0.2)

											local ok8 = handlers[35].Backpack:FindFirstChild("Special Microchip")

											if not ok8 then
												ok8 = not (not handlers[35].Character:FindFirstChild("Special Microchip") or not (handlers[35].Character.Humanoid.Health > 0))
											end

											if ok8 then
												if handlers[30] == 4442272183 and handlers[35].Character.Humanoid.Health > 0 then
													fireclickdetector(handlers[19].Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector, 1)

													local t155 = { 0 }

													while true do
														t155[1] += 1
														handlers[45].wt(1)

														if t155[1] >= 20 then
															break
														elseif handlers[35].PlayerGui.Main.Timer.Visible then
															break
														end
													end
												elseif handlers[30] == 7449423635 then
													handlers[31](CFrame.new(-5034, 315, -2951), 1.5)

													if (CFrame.new(-5034, 315, -2951).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 and handlers[35].Character.Humanoid.Health > 0 then
														local t156 = {}

														fireclickdetector(handlers[19].Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector, 1)
														t156[2] = 0

														while true do
															t156[2] += 1
															handlers[45].wt(1)

															if t156[2] >= 20 then
																break
															elseif handlers[35].PlayerGui.Main.Timer.Visible then
																break
															end
														end
													end
												end
											elseif not handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible then
												if handlers[1].Value >= 0 and handlers[35].Data.Fragments.Value >= 5000 then
													print("nan")
													handlers[7].Remotes.CommF_:InvokeServer("BuySharkmanKarate")
													Sharkman_Karate_C = true

													return
												end

												table.sort(handlers[45].GetFruits(), function(p66, p67)
													local t157 = {
														[3] = p66,
														p67
													}

													if t157[3].Value < 100000 and t157[3].Value < 100000 then
														return t157[3].Value < t157[1].Value
													end
												end)
												handlers[45].wt(1)

												if #handlers[45].GetFruits() > 0 and not Sharkman_Karate_C then
													handlers[45].wt(2)

													if not handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible then
														if handlers[35].Character.Humanoid.Health > 0 and handlers[35].Data.Fragments.Value < 5000 then
															handlers[7].Remotes.CommF_:InvokeServer("LoadFruit", handlers[45].GetFruits()[1].Name)
														elseif handlers[17].Value < 5000 then
															return
														end

														if handlers[35].Data.DevilFruit.Value == "Dark-Dark" then
															Select_Map = "Dark"
														elseif handlers[35].Data.DevilFruit.Value == "Sand-Sand" then
															Select_Map = "Sand"
														elseif handlers[35].Data.DevilFruit.Value == "Magma-Magma" then
															Select_Map = "Magma"
														elseif handlers[35].Data.DevilFruit.Value == "Rumble-Rumble" then
															Select_Map = "Rumble"
														elseif handlers[35].Data.DevilFruit.Value == "Flame-Flame" then
															Select_Map = "Flame"
														elseif handlers[35].Data.DevilFruit.Value == "Ice-Ice" then
															Select_Map = "Ice"
														elseif handlers[35].Data.DevilFruit.Value == "Light-Light" then
															Select_Map = "Light"
														elseif handlers[35].Data.DevilFruit.Value == "String-String" then
															Select_Map = "String"
														elseif handlers[35].Data.DevilFruit.Value == "Quake-Quake" then
															Select_Map = "Quake"
														elseif handlers[35].Data.DevilFruit.Value == "Buddha-Buddha" then
															Select_Map = "Buddha"
														else
															Select_Map = "Ice"
														end

														handlers[7].Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Select_Map)

														if handlers[30] == 4442272183 and handlers[35].Character.Humanoid.Health > 0 then
															fireclickdetector(handlers[19].Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector, 1)

															local t158 = { 0 }

															repeat
																t158[1] += 1
																handlers[45].wt(1)
															until t158[1] >= 20 or handlers[35].PlayerGui.Main.Timer.Visible
														elseif handlers[30] == 7449423635 then
															handlers[31](CFrame.new(-5034, 315, -2951), 1.5)

															if (CFrame.new(-5034, 315, -2951).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 and handlers[35].Character.Humanoid.Health > 0 then
																local t159 = {}

																fireclickdetector(handlers[19].Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector, 1)
																t159[2] = 0

																while true do
																	t159[2] += 1
																	handlers[45].wt(1)

																	if t159[2] >= 20 then
																		break
																	elseif handlers[35].PlayerGui.Main.Timer.Visible then
																		break
																	end
																end
															end
														end
													end
												else
													Quest = nil
													handlers[45].Status(handlers[3]({
														" Status : Auto Farm ",
														"Level"
													}))
													handlers[39]()
												end
											end
										end
									end
								end

								if Sharkman_Karate_C then
									return
								end
							end

							Sharkman_Karate_C = true

							return
						end

						if Sharkman_Karate_C_M and not Electric_Claw_C and handlers[24].Value >= 1100 then
							if Electric_Claw_C then
								return
							end

							while true do
								handlers[45].wt()
								handlers[14]()

								if handlers[45].ffc(handlers[35].Backpack, "Electric Claw") or handlers[45].ffc(handlers[35].Character, "Electric Claw") then
									break
								end

								if not Electric_Claw_C and handlers[24].Value >= 1100 then
									if handlers[17].Value >= 5000 then
										if handlers[1].Value >= 3000000 then
											pcall(function()
												handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw")

												if handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw") == 1 then
													Electric_Claw_C = true
												elseif handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw") == 2 then
													Electric_Claw_C = true

													return
												end
											end)

											if not Electric_Claw_C then
												handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw")

												local ok6 = handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw") == 1

												if not ok6 then
													ok6 = handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw") == 2
												end

												if ok6 then
													Electric_Claw_C = true
												end
											end

											if Three_World and not Electric_Claw_C then
												Quest = "Quest Electric Claw"
											end

											return
										end

										handlers[14]()
										Quest = nil
										handlers[45].Status(handlers[3]({
											" Status : Auto Farm ",
											"Level"
										}))
										handlers[39]()
									elseif handlers[17].Value < 5000 then
										if handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible and handlers[17].Value < 5000 and not Electric_Claw_C then
											handlers[45].Status(" Status : Farm Raid")

											if #handlers[45].GetMobRaid() == 0 then
												if Select_Map == "Magma" or Select_Map == "Flame" then
													for k, descendant in pairs(handlers[19]:GetDescendants()) do
														local t160 = {
															[2] = k,
															descendant
														}

														if t160[1].Name == "Lava" then
															t160[1]:Destroy()
														end
													end
												end

												if handlers[45].GetRaid("Island 5", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 5", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 4", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 4", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 3", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 3", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 2", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 2", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												elseif handlers[45].GetRaid("Island 1", 2500) ~= nil then
													handlers[31](handlers[45].GetRaid("Island 1", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
												end
											else
												for k, child in pairs(handlers[40]:GetChildren()) do
													local t161 = {
														k,
														child
													}

													if t161[2]:FindFirstChild("HumanoidRootPart") then
														if t161[2]:FindFirstChild("Humanoid") then
															if t161[2]:FindFirstChild("Humanoid").Health > 0 and (handlers[35].Character.HumanoidRootPart.CFrame.Position - t161[2].HumanoidRootPart.CFrame.Position).Magnitude <= 5000 then
																repeat
																	local t162 = {}

																	handlers[45].wt(0.1)

																	if Select_Map == "Magma" or Select_Map == "Flame" then
																		for k2, descendant in pairs(handlers[19]:GetDescendants()) do
																			local t163 = {
																				[3] = k2,
																				[2] = descendant
																			}

																			if t163[2].Name == "Lava" then
																				t163[2]:Destroy()
																			end
																		end
																	end

																	t162[2] = math.random(1, 5)

																	if t162[2] == 1 then
																		t162[1] = CFrame.new(0, 30, 1)
																	elseif t162[2] == 2 then
																		t162[1] = CFrame.new(0, 30, 15)
																	elseif t162[2] == 3 then
																		t162[1] = CFrame.new(1, 30, -15)
																	elseif t162[2] == 4 then
																		t162[1] = CFrame.new(15, 30, 0)
																	elseif t162[2] == 5 then
																		t162[1] = CFrame.new(-15, 30, 0)
																	end

																	handlers[31](t161[2].HumanoidRootPart.CFrame * t162[1], 1.5)

																	if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
																		handlers[7].Remotes.CommF_:InvokeServer("Buso")
																	end

																	handlers[14]()
																until not t161[2].Parent or t161[2].Humanoid.Health <= 0 or #handlers[45].GetMobRaid() == 0
															end
														end
													end
												end
											end
										else
											if handlers[35].Data.DevilFruit.Value == "Dark-Dark" then
												Select_Map = "Dark"
											elseif handlers[35].Data.DevilFruit.Value == "Sand-Sand" then
												Select_Map = "Sand"
											elseif handlers[35].Data.DevilFruit.Value == "Magma-Magma" then
												Select_Map = "Magma"
											elseif handlers[35].Data.DevilFruit.Value == "Rumble-Rumble" then
												Select_Map = "Rumble"
											elseif handlers[35].Data.DevilFruit.Value == "Flame-Flame" then
												Select_Map = "Flame"
											elseif handlers[35].Data.DevilFruit.Value == "Ice-Ice" then
												Select_Map = "Ice"
											elseif handlers[35].Data.DevilFruit.Value == "Light-Light" then
												Select_Map = "Light"
											elseif handlers[35].Data.DevilFruit.Value == "String-String" then
												Select_Map = "String"
											elseif handlers[35].Data.DevilFruit.Value == "Quake-Quake" then
												Select_Map = "Quake"
											elseif handlers[35].Data.DevilFruit.Value == "Buddha-Buddha" then
												Select_Map = "Buddha"
											else
												Select_Map = "Ice"
											end

											handlers[7].Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Select_Map)
											handlers[45].wt(0.2)

											local ok5 = handlers[35].Backpack:FindFirstChild("Special Microchip")

											if not ok5 then
												ok5 = not (not handlers[35].Character:FindFirstChild("Special Microchip") or not (handlers[35].Character.Humanoid.Health > 0))
											end

											if ok5 then
												if handlers[30] == 4442272183 and handlers[35].Character.Humanoid.Health > 0 then
													local t164 = {}

													fireclickdetector(handlers[19].Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector, 1)
													t164[2] = 0

													while true do
														t164[2] += 1
														handlers[45].wt(1)

														if t164[2] >= 20 then
															break
														elseif handlers[35].PlayerGui.Main.Timer.Visible then
															break
														end
													end
												elseif handlers[30] == 7449423635 then
													handlers[31](CFrame.new(-5034, 315, -2951), 1.5)

													if (CFrame.new(-5034, 315, -2951).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 and handlers[35].Character.Humanoid.Health > 0 then
														local t165 = {}

														fireclickdetector(handlers[19].Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector, 1)
														t165[2] = 0

														while true do
															t165[2] += 1
															handlers[45].wt(1)

															if t165[2] >= 20 then
																break
															elseif handlers[35].PlayerGui.Main.Timer.Visible then
																break
															end
														end
													end
												end
											elseif not handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible then
												if handlers[35].Data.Fragments.Value >= 5000 then
													if not (handlers[35].Data.Beli.Value >= 3000000) then
														return
													end

													handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw")

													if handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw") == 1 then
														Electric_Claw_C = true
													elseif handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw") == 2 then
														Electric_Claw_C = true

														return
													end

													return
												end

												table.sort(handlers[45].GetFruits(), function(p68, p69)
													local t166 = {
														[2] = p68,
														[3] = p69
													}

													if t166[2].Value < 100000 then
														if t166[2].Value < 100000 then
															return t166[2].Value < t166[3].Value
														end
													end
												end)
												handlers[45].wt(1)

												if #handlers[45].GetFruits() > 0 and not Electric_Claw_C then
													warn()
													handlers[45].wt(2)

													if not handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible then
														if handlers[35].Character.Humanoid.Health > 0 and handlers[35].Data.Fragments.Value < 5000 then
															handlers[7].Remotes.CommF_:InvokeServer("LoadFruit", handlers[45].GetFruits()[1].Name)
														elseif handlers[17].Value < 5000 then
															return
														end

														if handlers[35].Data.DevilFruit.Value == "Dark-Dark" then
															Select_Map = "Dark"
														elseif handlers[35].Data.DevilFruit.Value == "Sand-Sand" then
															Select_Map = "Sand"
														elseif handlers[35].Data.DevilFruit.Value == "Magma-Magma" then
															Select_Map = "Magma"
														elseif handlers[35].Data.DevilFruit.Value == "Rumble-Rumble" then
															Select_Map = "Rumble"
														elseif handlers[35].Data.DevilFruit.Value == "Flame-Flame" then
															Select_Map = "Flame"
														elseif handlers[35].Data.DevilFruit.Value == "Ice-Ice" then
															Select_Map = "Ice"
														elseif handlers[35].Data.DevilFruit.Value == "Light-Light" then
															Select_Map = "Light"
														elseif handlers[35].Data.DevilFruit.Value == "String-String" then
															Select_Map = "String"
														elseif handlers[35].Data.DevilFruit.Value == "Quake-Quake" then
															Select_Map = "Quake"
														elseif handlers[35].Data.DevilFruit.Value == "Buddha-Buddha" then
															Select_Map = "Buddha"
														else
															Select_Map = "Ice"
														end

														handlers[7].Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Select_Map)

														if handlers[30] == 4442272183 and handlers[35].Character.Humanoid.Health > 0 then
															local t167 = {}

															fireclickdetector(handlers[19].Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector, 1)
															t167[2] = 0

															repeat
																t167[2] += 1
																handlers[45].wt(1)
															until t167[2] >= 20 or handlers[35].PlayerGui.Main.Timer.Visible
														elseif handlers[30] == 7449423635 then
															handlers[31](CFrame.new(-5034, 315, -2951), 1.5)

															if (CFrame.new(-5034, 315, -2951).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 and handlers[35].Character.Humanoid.Health > 0 then
																local t168 = {}

																fireclickdetector(handlers[19].Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector, 1)
																t168[2] = 0

																while true do
																	t168[2] += 1
																	handlers[45].wt(1)

																	if t168[2] >= 20 then
																		break
																	elseif handlers[35].PlayerGui.Main.Timer.Visible then
																		break
																	end
																end
															end
														end
													end
												else
													Quest = nil
													handlers[45].Status(handlers[3]({
														" Status : Auto Farm ",
														"Level"
													}))
													handlers[39]()
												end
											end
										end
									end
								end

								if Electric_Claw_C then
									return
								end
							end

							Electric_Claw_C = true

							return
						end

						if Electric_Claw_C_M and not Dragon_Talon_C and handlers[24].Value >= 1100 then
							if Dragon_Talon_C then
								return
							end

							while true do
								handlers[45].wt()
								handlers[14]()

								if handlers[45].ffc(handlers[35].Backpack, "Dragon Talon") or handlers[45].ffc(handlers[35].Character, "Dragon Talon") then
									break
								end

								if not Dragon_Talon_C and handlers[24].Value >= 1100 then
									if not (handlers[17].Value >= 5000) then
										if handlers[17].Value < 5000 then
											if handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible and handlers[17].Value < 5000 and not Dragon_Talon_C then
												handlers[45].Status(" Status : Farm Raid")

												if #handlers[45].GetMobRaid() == 0 then
													if Select_Map == "Magma" or Select_Map == "Flame" then
														for k, descendant in pairs(handlers[19]:GetDescendants()) do
															local t169 = {
																k,
																[3] = descendant
															}

															if t169[3].Name == "Lava" then
																t169[3]:Destroy()
															end
														end
													end

													if handlers[45].GetRaid("Island 5", 2500) ~= nil then
														handlers[31](handlers[45].GetRaid("Island 5", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
													elseif handlers[45].GetRaid("Island 4", 2500) ~= nil then
														handlers[31](handlers[45].GetRaid("Island 4", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
													elseif handlers[45].GetRaid("Island 3", 2500) ~= nil then
														handlers[31](handlers[45].GetRaid("Island 3", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
													elseif handlers[45].GetRaid("Island 2", 2500) ~= nil then
														handlers[31](handlers[45].GetRaid("Island 2", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
													elseif handlers[45].GetRaid("Island 1", 2500) ~= nil then
														handlers[31](handlers[45].GetRaid("Island 1", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
													end
												else
													for k, child in pairs(handlers[40]:GetChildren()) do
														local t170 = {
															[2] = k,
															[3] = child
														}

														if t170[3]:FindFirstChild("HumanoidRootPart") then
															if t170[3]:FindFirstChild("Humanoid") then
																if t170[3]:FindFirstChild("Humanoid").Health > 0 and (handlers[35].Character.HumanoidRootPart.CFrame.Position - t170[3].HumanoidRootPart.CFrame.Position).Magnitude <= 5000 then
																	repeat
																		handlers[45].wt(0.1)

																		if Select_Map == "Magma" or Select_Map == "Flame" then
																			for k2, descendant in pairs(handlers[19]:GetDescendants()) do
																				local t172 = {
																					[3] = k2,
																					descendant
																				}

																				if t172[1].Name == "Lava" then
																					t172[1]:Destroy()
																				end
																			end
																		end

																		local t171 = { math.random(1, 5) }

																		if t171[1] == 1 then
																			t171[2] = CFrame.new(0, 30, 1)
																		elseif t171[1] == 2 then
																			t171[2] = CFrame.new(0, 30, 15)
																		elseif t171[1] == 3 then
																			t171[2] = CFrame.new(1, 30, -15)
																		elseif t171[1] == 4 then
																			t171[2] = CFrame.new(15, 30, 0)
																		elseif t171[1] == 5 then
																			t171[2] = CFrame.new(-15, 30, 0)
																		end

																		handlers[31](t170[3].HumanoidRootPart.CFrame * t171[2], 1.5)

																		if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
																			handlers[7].Remotes.CommF_:InvokeServer("Buso")
																		end

																		handlers[14]()
																	until not t170[3].Parent or t170[3].Humanoid.Health <= 0 or #handlers[45].GetMobRaid() == 0
																end
															end
														end
													end
												end
											else
												if handlers[35].Data.DevilFruit.Value == "Dark-Dark" then
													Select_Map = "Dark"
												elseif handlers[35].Data.DevilFruit.Value == "Sand-Sand" then
													Select_Map = "Sand"
												elseif handlers[35].Data.DevilFruit.Value == "Magma-Magma" then
													Select_Map = "Magma"
												elseif handlers[35].Data.DevilFruit.Value == "Rumble-Rumble" then
													Select_Map = "Rumble"
												elseif handlers[35].Data.DevilFruit.Value == "Flame-Flame" then
													Select_Map = "Flame"
												elseif handlers[35].Data.DevilFruit.Value == "Ice-Ice" then
													Select_Map = "Ice"
												elseif handlers[35].Data.DevilFruit.Value == "Light-Light" then
													Select_Map = "Light"
												elseif handlers[35].Data.DevilFruit.Value == "String-String" then
													Select_Map = "String"
												elseif handlers[35].Data.DevilFruit.Value == "Quake-Quake" then
													Select_Map = "Quake"
												elseif handlers[35].Data.DevilFruit.Value == "Buddha-Buddha" then
													Select_Map = "Buddha"
												else
													Select_Map = "Ice"
												end

												handlers[7].Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Select_Map)
												handlers[45].wt(0.2)

												local ok3 = handlers[35].Backpack:FindFirstChild("Special Microchip")

												if not ok3 then
													ok3 = not (not handlers[35].Character:FindFirstChild("Special Microchip") or not (handlers[35].Character.Humanoid.Health > 0))
												end

												if ok3 then
													if handlers[30] == 4442272183 and handlers[35].Character.Humanoid.Health > 0 then
														fireclickdetector(handlers[19].Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector, 1)

														local t173 = { 0 }

														while true do
															t173[1] += 1
															handlers[45].wt(1)

															if t173[1] >= 20 then
																break
															elseif handlers[35].PlayerGui.Main.Timer.Visible then
																break
															end
														end
													elseif handlers[30] == 7449423635 then
														handlers[31](CFrame.new(-5034, 315, -2951), 1.5)

														if (CFrame.new(-5034, 315, -2951).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 and handlers[35].Character.Humanoid.Health > 0 then
															local t174 = {}

															fireclickdetector(handlers[19].Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector, 1)
															t174[2] = 0

															while true do
																t174[2] += 1
																handlers[45].wt(1)

																if t174[2] >= 20 then
																	break
																elseif handlers[35].PlayerGui.Main.Timer.Visible then
																	break
																end
															end
														end
													end
												elseif not handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible then
													if handlers[35].Data.Fragments.Value >= 5000 then
														if not (handlers[35].Data.Beli.Value >= 3000000) then
															return
														end

														handlers[7].Remotes.CommF_:InvokeServer("BuyDragonTalon")
														Dragon_Talon_C = true

														return
													end

													table.sort(handlers[45].GetFruits(), function(p70, p71)
														local t175 = {
															p70,
															p71
														}

														if t175[1].Value < 100000 and t175[1].Value < 100000 then
															return t175[1].Value < t175[2].Value
														end
													end)
													handlers[45].wt(1)

													if #handlers[45].GetFruits() > 0 and not Dragon_Talon_C then
														warn()
														handlers[45].wt(2)

														if not handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible then
															if handlers[35].Character.Humanoid.Health > 0 and handlers[35].Data.Fragments.Value < 5000 then
																handlers[7].Remotes.CommF_:InvokeServer("LoadFruit", handlers[45].GetFruits()[1].Name)
															elseif handlers[17].Value < 5000 then
																return
															end

															if handlers[35].Data.DevilFruit.Value == "Dark-Dark" then
																Select_Map = "Dark"
															elseif handlers[35].Data.DevilFruit.Value == "Sand-Sand" then
																Select_Map = "Sand"
															elseif handlers[35].Data.DevilFruit.Value == "Magma-Magma" then
																Select_Map = "Magma"
															elseif handlers[35].Data.DevilFruit.Value == "Rumble-Rumble" then
																Select_Map = "Rumble"
															elseif handlers[35].Data.DevilFruit.Value == "Flame-Flame" then
																Select_Map = "Flame"
															elseif handlers[35].Data.DevilFruit.Value == "Ice-Ice" then
																Select_Map = "Ice"
															elseif handlers[35].Data.DevilFruit.Value == "Light-Light" then
																Select_Map = "Light"
															elseif handlers[35].Data.DevilFruit.Value == "String-String" then
																Select_Map = "String"
															elseif handlers[35].Data.DevilFruit.Value == "Quake-Quake" then
																Select_Map = "Quake"
															elseif handlers[35].Data.DevilFruit.Value == "Buddha-Buddha" then
																Select_Map = "Buddha"
															else
																Select_Map = "Ice"
															end

															handlers[7].Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Select_Map)

															if handlers[30] == 4442272183 and handlers[35].Character.Humanoid.Health > 0 then
																local t176 = {}

																fireclickdetector(handlers[19].Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector, 1)
																t176[2] = 0

																repeat
																	t176[2] += 1
																	handlers[45].wt(1)
																until t176[2] >= 20 or handlers[35].PlayerGui.Main.Timer.Visible
															elseif handlers[30] == 7449423635 then
																handlers[31](CFrame.new(-5034, 315, -2951), 1.5)

																if (CFrame.new(-5034, 315, -2951).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 and handlers[35].Character.Humanoid.Health > 0 then
																	fireclickdetector(handlers[19].Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector, 1)

																	local t177 = { 0 }

																	while true do
																		t177[1] += 1
																		handlers[45].wt(1)

																		if t177[1] >= 20 then
																			break
																		elseif handlers[35].PlayerGui.Main.Timer.Visible then
																			break
																		end
																	end
																end
															end
														end
													else
														Quest = nil
														handlers[45].Status(handlers[3]({
															" Status : Auto Farm ",
															"Level"
														}))
														handlers[39]()
													end
												end
											end
										end
									elseif handlers[1].Value >= 3000000 then
										Quest = nil
										handlers[45].Status(handlers[3]({
											" Status : Auto Farm ",
											"Bone"
										}))
										handlers[45].FarmBone(true)
									else
										handlers[14]()
										Quest = nil
										handlers[45].Status(handlers[3]({
											" Status : Auto Farm ",
											"Level"
										}))
										handlers[39]()
									end
								end

								if Dragon_Talon_C then
									return
								end
							end

							Dragon_Talon_C = true

							return
						end

						if Dragon_Talon_C_M and not God_Human_C and handlers[24].Value >= 1100 then
							if God_Human_C then
								return
							end

							while true do
								handlers[45].wt()
								handlers[14]()

								if handlers[45].ffc(handlers[35].Backpack, "Godhuman") or handlers[45].ffc(handlers[35].Character, "Godhuman") then
									break
								end

								if not God_Human_C and handlers[24].Value >= 1100 then
									if not (handlers[17].Value >= 5000) then
										if handlers[17].Value < 5000 then
											if handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible and handlers[17].Value < 5000 and not God_Human_C then
												handlers[45].Status(" Status : Farm Raid")

												if #handlers[45].GetMobRaid() == 0 then
													if Select_Map == "Magma" or Select_Map == "Flame" then
														for k, descendant in pairs(handlers[19]:GetDescendants()) do
															local t178 = {
																[3] = k,
																descendant
															}

															if t178[1].Name == "Lava" then
																t178[1]:Destroy()
															end
														end
													end

													if handlers[45].GetRaid("Island 5", 2500) ~= nil then
														handlers[31](handlers[45].GetRaid("Island 5", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
													elseif handlers[45].GetRaid("Island 4", 2500) ~= nil then
														handlers[31](handlers[45].GetRaid("Island 4", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
													elseif handlers[45].GetRaid("Island 3", 2500) ~= nil then
														handlers[31](handlers[45].GetRaid("Island 3", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
													elseif handlers[45].GetRaid("Island 2", 2500) ~= nil then
														handlers[31](handlers[45].GetRaid("Island 2", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
													elseif handlers[45].GetRaid("Island 1", 2500) ~= nil then
														handlers[31](handlers[45].GetRaid("Island 1", 2500).CFrame * CFrame.new(0, 120, 0), 1.5)
													end
												else
													for k, child in pairs(handlers[40]:GetChildren()) do
														local t179 = {
															[2] = k,
															child
														}

														if t179[1]:FindFirstChild("HumanoidRootPart") then
															if t179[1]:FindFirstChild("Humanoid") then
																if t179[1]:FindFirstChild("Humanoid").Health > 0 and (handlers[35].Character.HumanoidRootPart.CFrame.Position - t179[1].HumanoidRootPart.CFrame.Position).Magnitude <= 5000 then
																	repeat
																		local t180 = {}

																		handlers[45].wt(0.1)

																		if Select_Map == "Magma" or Select_Map == "Flame" then
																			for k2, descendant in pairs(handlers[19]:GetDescendants()) do
																				local t181 = {
																					[2] = k2,
																					descendant
																				}

																				if t181[1].Name == "Lava" then
																					t181[1]:Destroy()
																				end
																			end
																		end

																		t180[2] = math.random(1, 5)

																		if t180[2] == 1 then
																			t180[1] = CFrame.new(0, 30, 1)
																		elseif t180[2] == 2 then
																			t180[1] = CFrame.new(0, 30, 15)
																		elseif t180[2] == 3 then
																			t180[1] = CFrame.new(1, 30, -15)
																		elseif t180[2] == 4 then
																			t180[1] = CFrame.new(15, 30, 0)
																		elseif t180[2] == 5 then
																			t180[1] = CFrame.new(-15, 30, 0)
																		end

																		handlers[31](t179[1].HumanoidRootPart.CFrame * t180[1], 1.5)

																		if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
																			handlers[7].Remotes.CommF_:InvokeServer("Buso")
																		end

																		handlers[14]()
																	until not t179[1].Parent or t179[1].Humanoid.Health <= 0 or #handlers[45].GetMobRaid() == 0
																end
															end
														end
													end
												end
											else
												if handlers[35].Data.DevilFruit.Value == "Dark-Dark" then
													Select_Map = "Dark"
												elseif handlers[35].Data.DevilFruit.Value == "Sand-Sand" then
													Select_Map = "Sand"
												elseif handlers[35].Data.DevilFruit.Value == "Magma-Magma" then
													Select_Map = "Magma"
												elseif handlers[35].Data.DevilFruit.Value == "Rumble-Rumble" then
													Select_Map = "Rumble"
												elseif handlers[35].Data.DevilFruit.Value == "Flame-Flame" then
													Select_Map = "Flame"
												elseif handlers[35].Data.DevilFruit.Value == "Ice-Ice" then
													Select_Map = "Ice"
												elseif handlers[35].Data.DevilFruit.Value == "Light-Light" then
													Select_Map = "Light"
												elseif handlers[35].Data.DevilFruit.Value == "String-String" then
													Select_Map = "String"
												elseif handlers[35].Data.DevilFruit.Value == "Quake-Quake" then
													Select_Map = "Quake"
												elseif handlers[35].Data.DevilFruit.Value == "Buddha-Buddha" then
													Select_Map = "Buddha"
												else
													Select_Map = "Ice"
												end

												handlers[7].Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Select_Map)
												handlers[45].wt(0.2)

												local ok = handlers[35].Backpack:FindFirstChild("Special Microchip")

												if not ok then
													ok = not (not handlers[35].Character:FindFirstChild("Special Microchip") or not (handlers[35].Character.Humanoid.Health > 0))
												end

												if ok then
													if handlers[30] == 4442272183 and handlers[35].Character.Humanoid.Health > 0 then
														local t182 = {}

														fireclickdetector(handlers[19].Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector, 1)
														t182[2] = 0

														while true do
															t182[2] += 1
															handlers[45].wt(1)

															if t182[2] >= 20 then
																break
															elseif handlers[35].PlayerGui.Main.Timer.Visible then
																break
															end
														end
													elseif handlers[30] == 7449423635 then
														handlers[31](CFrame.new(-5034, 315, -2951), 1.5)

														if (CFrame.new(-5034, 315, -2951).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 and handlers[35].Character.Humanoid.Health > 0 then
															fireclickdetector(handlers[19].Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector, 1)

															local t183 = { 0 }

															while true do
																t183[1] += 1
																handlers[45].wt(1)

																if t183[1] >= 20 then
																	break
																elseif handlers[35].PlayerGui.Main.Timer.Visible then
																	break
																end
															end
														end
													end
												elseif not handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible then
													if handlers[35].Data.Fragments.Value >= 5000 then
														if not (handlers[35].Data.Beli.Value >= 3000000) then
															return
														end

														handlers[7].Remotes.CommF_:InvokeServer("BuyGodHuman")
														God_Human_C = true

														return
													end

													table.sort(handlers[45].GetFruits(), function(p72, p73)
														local t184 = {
															[2] = p72,
															p73
														}

														if t184[2].Value < 100000 and t184[2].Value < 100000 then
															return t184[2].Value < t184[1].Value
														end
													end)
													handlers[45].wt(1)

													if #handlers[45].GetFruits() > 0 and not God_Human_C then
														warn()
														handlers[45].wt(2)

														if not handlers[35].PlayerGui.Main.TopHUDList.RaidTimer.Visible then
															if handlers[35].Character.Humanoid.Health > 0 and handlers[35].Data.Fragments.Value < 5000 then
																handlers[7].Remotes.CommF_:InvokeServer("LoadFruit", handlers[45].GetFruits()[1].Name)
															elseif handlers[17].Value < 5000 then
																return
															end

															if handlers[35].Data.DevilFruit.Value == "Dark-Dark" then
																Select_Map = "Dark"
															elseif handlers[35].Data.DevilFruit.Value == "Sand-Sand" then
																Select_Map = "Sand"
															elseif handlers[35].Data.DevilFruit.Value == "Magma-Magma" then
																Select_Map = "Magma"
															elseif handlers[35].Data.DevilFruit.Value == "Rumble-Rumble" then
																Select_Map = "Rumble"
															elseif handlers[35].Data.DevilFruit.Value == "Flame-Flame" then
																Select_Map = "Flame"
															elseif handlers[35].Data.DevilFruit.Value == "Ice-Ice" then
																Select_Map = "Ice"
															elseif handlers[35].Data.DevilFruit.Value == "Light-Light" then
																Select_Map = "Light"
															elseif handlers[35].Data.DevilFruit.Value == "String-String" then
																Select_Map = "String"
															elseif handlers[35].Data.DevilFruit.Value == "Quake-Quake" then
																Select_Map = "Quake"
															elseif handlers[35].Data.DevilFruit.Value == "Buddha-Buddha" then
																Select_Map = "Buddha"
															else
																Select_Map = "Ice"
															end

															handlers[7].Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Select_Map)

															if handlers[30] == 4442272183 and handlers[35].Character.Humanoid.Health > 0 then
																local t185 = {}

																fireclickdetector(handlers[19].Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector, 1)
																t185[2] = 0

																repeat
																	t185[2] += 1
																	handlers[45].wt(1)
																until t185[2] >= 20 or handlers[35].PlayerGui.Main.Timer.Visible
															elseif handlers[30] == 7449423635 then
																handlers[31](CFrame.new(-5034, 315, -2951), 1.5)

																if (CFrame.new(-5034, 315, -2951).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 and handlers[35].Character.Humanoid.Health > 0 then
																	fireclickdetector(handlers[19].Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector, 1)

																	local t186 = { 0 }

																	while true do
																		t186[1] += 1
																		handlers[45].wt(1)

																		if t186[1] >= 20 then
																			break
																		elseif handlers[35].PlayerGui.Main.Timer.Visible then
																			break
																		end
																	end
																end
															end
														end
													else
														Quest = nil
														handlers[45].Status(handlers[3]({
															" Status : Auto Farm ",
															"Level"
														}))
														handlers[39]()
													end
												end
											end
										end
									elseif handlers[1].Value >= 5000000 then
										Quest = "Godhuman"
									else
										handlers[14]()
										Quest = nil
										handlers[45].Status(handlers[3]({
											" Status : Auto Farm ",
											"Level"
										}))
										handlers[39]()
									end
								end

								if God_Human_C then
									return
								end
							end

							God_Human_C = true

							return
						end

						if handlers[24].Value >= 700 and not New_World and not Three_World then
							Quest = "World 2"

							return
						end

						if New_World and CheckFindWaterKey and handlers[24].Value >= 1500 then
							if handlers[7].Remotes.CommF_:InvokeServer("TalkTrevor", "1") == 0 and not handlers[45].IsHall() and handlers[45].IsHeavenly() then
								Quest = "TravelZou"

								return
							end
						end

						Quest = nil
						handlers[45].Status(handlers[3]({
							" Status : Auto Farm ",
							"Level"
						}))
						handlers[39]()
					end
				end
			end
		end, warn)
	end
end)
task.spawn(function()
	while handlers[45].wt() do
		xpcall(function()
			if Quest ~= nil then
				handlers[45].Status(" Status : " .. Quest)
			end

			if Quest == "Saber" then
				local t187 = {}

				if not old_World then
					handlers[7].Remotes.CommF_:InvokeServer("TravelMain")
				end

				t187[2] = handlers[7].Remotes.CommF_:InvokeServer("ProQuestProgress")

				if t187[2].UsedTorch == false then
					for k, child in pairs(game:GetService("Workspace").Map.Jungle.QuestPlates:GetChildren()) do
						local t188 = {
							[3] = k,
							[2] = child
						}

						if table.find({
							"Plate1",
							"Plate2",
							"Plate3",
							"Plate4",
							"Plate5"
						}, t188[2].Name) then
							t188[2].Button.CFrame = handlers[35].Character.HumanoidRootPart.CFrame
						end
					end

					handlers[7].Remotes.CommF_:InvokeServer("ProQuestProgress", "GetTorch")
					handlers[45].Equip("Torch")
					handlers[7].Remotes.CommF_:InvokeServer("ProQuestProgress", "DestroyTorch")
				elseif t187[2].UsedCup == false then
					handlers[7].Remotes.CommF_:InvokeServer("ProQuestProgress", "GetCup")
					handlers[45].Equip("Cup")
					handlers[7].Remotes.CommF_:InvokeServer("ProQuestProgress", "FillCup", game:GetService("Players").LocalPlayer.Character.Cup)
					handlers[7].Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan")
				elseif t187[2].KilledMob == false then
					local t189 = {}

					handlers[7].Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
					t189[2] = handlers[45].ffc(handlers[40], "Mob Leader")

					if t189[2] then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t190 = {
								[2] = k,
								[3] = child
							}

							if t190[3].Name == "Mob Leader" then
								repeat
									handlers[45].wt()
									handlers[31](t190[3].HumanoidRootPart.CFrame * CFrame.new(0, 20, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t190[3].Parent or t190[3].Humanoid.Health <= 0 or handlers[45].gi("Saber")

								handlers[7].Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
							end
						end
					else
						handlers[31](CFrame.new(-2848.59399, 7.4272871, 5342.44043), 1.5)
					end
				elseif t187[2].UsedRelic == false then
					handlers[7].Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
					handlers[45].Equip("Relic")
					handlers[31](CFrame.new(-1406.60925, 29.8520069, 4.5805192), 1.5)
				elseif handlers[45].ffc(handlers[40], "Saber Expert") then
					for k, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						local t191 = {
							k,
							[3] = child
						}

						if t191[3].Name == "Saber Expert" then
							repeat
								handlers[45].wt()
								handlers[31](t191[3].HumanoidRootPart.CFrame * CFrame.new(0, 25, 0), 1.5)

								if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
									handlers[7].Remotes.CommF_:InvokeServer("Buso")
								end

								handlers[14]()
							until not t191[3].Parent or t191[3].Humanoid.Health <= 0 or handlers[45].gi("Saber")
						end
					end
				else
					handlers[31](CFrame.new(-1458.89502, 29.8870335, -50.633564, 0.858821094, 1.13848939e-08, 0.512275636, -4.85649254e-09, 1, -1.40823326e-08, -0.512275636, 9.6063415e-09, 0.858821094), 1.5)

					if (CFrame.new(-1458.89502, 29.8870335, -50.633564, 0.858821094, 1.13848939e-08, 0.512275636, -4.85649254e-09, 1, -1.40823326e-08, -0.512275636, 9.6063415e-09, 0.858821094).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 then
						handlers[45].wt(0.5)

						if not handlers[45].ffc(handlers[40], "Saber Expert") then
							handlers[45].wt(0.1)
							handlers[10]:Teleport(handlers[30], handlers[35])
						end
					end
				end
			elseif Quest == "World 2" then
				local t192 = { (handlers[7].Remotes.CommF_:InvokeServer(handlers[3]({
					"DressrosaQuestProgre",
					"ss"
				}))) }

				if t192[1].UsedKey == false then
					handlers[31](CFrame.new(1347.32947, 37.349369, -1325.44922, 0.538348913, 8.57539106e-08, 0.842722058, 8.61935634e-10, 1, -1.0230886e-07, -0.842722058, 5.58042359e-08, 0.538348913), 1.5)
					handlers[7].Remotes.CommF_:InvokeServer(handlers[3]({
						"DressrosaQuestProgre",
						"ss"
					}), "Detective")
					handlers[45].Equip("Key")
				elseif t192[1].KilledIceBoss == false then
					if handlers[45].ffc(handlers[40], "Ice Admiral") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t193 = {
								k,
								child
							}

							if t193[2].Name == "Ice Admiral" and t193[2].Humanoid.Health > 0 then
								repeat
									handlers[45].wt(0.1)
									handlers[31](t193[2].HumanoidRootPart.CFrame * CFrame.new(0, 20, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t193[2].Parent or t193[2].Humanoid.Health <= 0 or not getgenv().AutoFarm or t192[1].KilledIceBoss

								handlers[45].wt(2)
								handlers[7].Remotes.CommF_:InvokeServer("TravelDressrosa")
								TleP = true
								handlers[45].wt(25)
							end
						end
					elseif handlers[45].ffc(handlers[7], "Ice Admiral") then
						handlers[31](CFrame.new(1144.5270996094, 7.3292083740234, -1164.7322998047), 1.5)
					end
				elseif t192[1].KilledIceBoss == true then
					handlers[7].Remotes.CommF_:InvokeServer("TravelDressrosa")
					TleP = true
					handlers[45].wt(25)
				end
			elseif Quest == "Pole (1st Form)" then
				if not handlers[45].CheckBoss("Thunder God") then
					return
				end

				repeat
					handlers[45].wt()

					if handlers[45].ffc(handlers[40], "Thunder God") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t194 = {
								[3] = k,
								child
							}

							if t194[1].Name == "Thunder God" and t194[1].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()

									if (CFrame.new(-7894.6181640625, 5547.1420898438, -380.29098510742).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
										handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", vector.create(-7894.6181640625, 5547.1420898438, -380.29098510742))
									end

									handlers[31](t194[1].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t194[1].Parent or t194[1].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Thunder God")
							end
						end
					elseif handlers[45].ffc(handlers[7], "Thunder God") then
						for k, child in pairs(handlers[7]:GetChildren()) do
							local t195 = {
								[2] = k,
								[3] = child
							}

							if t195[3].Name == "Thunder God" and t195[3].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()

									if (CFrame.new(-7894.6181640625, 5547.1420898438, -380.29098510742).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
										handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", vector.create(-7894.6181640625, 5547.1420898438, -380.29098510742))
									end

									handlers[31](t195[3].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t195[3].Parent or t195[3].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Thunder God")
							end
						end
					end
				until not handlers[45].CheckBoss("Thunder God")
			elseif Quest == "Shark Saw" then
				if not handlers[45].CheckBoss("The Saw") then
					return
				end

				repeat
					handlers[45].wt()

					if handlers[45].ffc(handlers[40], "The Saw") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t196 = {
								k,
								[3] = child
							}

							if t196[3].Name == "The Saw" and t196[3].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()

									if (CFrame.new(-7894.6181640625, 5547.1420898438, -380.29098510742).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
										handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", vector.create(-7894.6181640625, 5547.1420898438, -380.29098510742))
									end

									handlers[31](t196[3].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t196[3].Parent or t196[3].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("The Saw")
							end
						end
					elseif handlers[45].ffc(handlers[7], "The Saw") then
						for k, child in pairs(handlers[7]:GetChildren()) do
							local t197 = {
								k,
								[3] = child
							}

							if t197[3].Name == "The Saw" and t197[3].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()

									if (CFrame.new(-7894.6181640625, 5547.1420898438, -380.29098510742).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
										handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", vector.create(-7894.6181640625, 5547.1420898438, -380.29098510742))
									end

									handlers[31](t197[3].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t197[3].Parent or t197[3].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("The Saw")
							end
						end
					end
				until not handlers[45].CheckBoss("The Saw")
			elseif Quest == "Flail" then
				if not handlers[45].CheckBoss("Smoke Admiral") then
					return
				end

				repeat
					handlers[45].wt()

					if handlers[45].ffc(handlers[40], "Smoke Admiral") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t198 = {
								[2] = k,
								child
							}

							if t198[1].Name == "Smoke Admiral" and t198[1].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()

									if (CFrame.new(-7894.6181640625, 5547.1420898438, -380.29098510742).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
										handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", vector.create(-7894.6181640625, 5547.1420898438, -380.29098510742))
									end

									handlers[31](t198[1].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t198[1].Parent or t198[1].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Smoke Admiral")
							end
						end
					elseif handlers[45].ffc(handlers[7], "Smoke Admiral") then
						for k, child in pairs(handlers[7]:GetChildren()) do
							local t199 = {
								k,
								child
							}

							if t199[2].Name == "Smoke Admiral" and t199[2].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()

									if (CFrame.new(-7894.6181640625, 5547.1420898438, -380.29098510742).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
										handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", vector.create(-7894.6181640625, 5547.1420898438, -380.29098510742))
									end

									handlers[31](t199[2].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t199[2].Parent or t199[2].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Smoke Admiral")
							end
						end
					end
				until not handlers[45].CheckBoss("Smoke Admiral")
			elseif Quest == "Wardens Sword" then
				if not handlers[45].CheckBoss("Chief Warden") then
					return
				end

				repeat
					handlers[45].wt()

					if handlers[45].ffc(handlers[40], "Chief Warden") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t200 = {
								[2] = k,
								child
							}

							if t200[1].Name == "Chief Warden" and t200[1].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()

									if (CFrame.new(-7894.6181640625, 5547.1420898438, -380.29098510742).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
										handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", vector.create(-7894.6181640625, 5547.1420898438, -380.29098510742))
									end

									handlers[31](t200[1].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t200[1].Parent or t200[1].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Chief Warden")
							end
						end
					elseif handlers[45].ffc(handlers[7], "Chief Warden") then
						for k, child in pairs(handlers[7]:GetChildren()) do
							local t201 = {
								k,
								child
							}

							if t201[2].Name == "Chief Warden" and t201[2].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()

									if (CFrame.new(-7894.6181640625, 5547.1420898438, -380.29098510742).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
										handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", vector.create(-7894.6181640625, 5547.1420898438, -380.29098510742))
									end

									handlers[31](t201[2].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t201[2].Parent or t201[2].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Chief Warden")
							end
						end
					end
				until not handlers[45].CheckBoss("The Saw")
			elseif Quest == "Magma Blaster" then
				if not handlers[45].CheckBoss("Magma Admiral") then
					return
				end

				repeat
					handlers[45].wt()

					if handlers[45].ffc(handlers[40], "Magma Admiral") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t202 = {
								k,
								child
							}

							if t202[2].Name == "Magma Admiral" and t202[2].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()

									if (CFrame.new(-7894.6181640625, 5547.1420898438, -380.29098510742).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
										handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", vector.create(-7894.6181640625, 5547.1420898438, -380.29098510742))
									end

									handlers[31](t202[2].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()

									if not t202[2].Parent then
										break
									end

									if t202[2].Humanoid.Health <= 0 then
										break
									end

									if not getgenv().AutoFarm then
										break
									end
								until not handlers[45].CheckBoss("Magma Admiral")
							end
						end
					elseif handlers[45].ffc(handlers[7], "Magma Admiral") then
						for k, child in pairs(handlers[7]:GetChildren()) do
							local t203 = {
								[2] = k,
								[3] = child
							}

							if t203[3].Name == "Magma Admiral" and t203[3].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()

									if (CFrame.new(-7894.6181640625, 5547.1420898438, -380.29098510742).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
										handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", vector.create(-7894.6181640625, 5547.1420898438, -380.29098510742))
									end

									handlers[31](t203[3].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t203[3].Parent or t203[3].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Magma Admiral")
							end
						end
					end
				until not handlers[45].CheckBoss("Magma Admiral")
			elseif Quest == "Bazooka" then
				if not handlers[45].CheckBoss("Wysper") then
					return
				end

				repeat
					handlers[45].wt()

					if handlers[45].ffc(handlers[40], "Wysper") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t204 = {
								[3] = k,
								[2] = child
							}

							if t204[2].Name == "Wysper" and t204[2].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()

									if (CFrame.new(-7894.6181640625, 5547.1420898438, -380.29098510742).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
										handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", vector.create(-7894.6181640625, 5547.1420898438, -380.29098510742))
									end

									handlers[31](t204[2].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t204[2].Parent or t204[2].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Wysper")
							end
						end
					elseif handlers[45].ffc(handlers[7], "Wysper") then
						for k, child in pairs(handlers[7]:GetChildren()) do
							local t205 = {
								[3] = k,
								child
							}

							if t205[1].Name == "Wysper" and t205[1].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()

									if (CFrame.new(-7894.6181640625, 5547.1420898438, -380.29098510742).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
										handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", vector.create(-7894.6181640625, 5547.1420898438, -380.29098510742))
									end

									handlers[31](t205[1].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t205[1].Parent or t205[1].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Wysper")
							end
						end
					end
				until not handlers[45].CheckBoss("Wysper")
			elseif Quest == "Twin Hooks" then
				if not handlers[45].CheckBoss("Captain Elephant") then
					return
				end

				repeat
					handlers[45].wt()

					if handlers[45].ffc(handlers[40], "Captain Elephant") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t206 = {
								[2] = k,
								[3] = child
							}

							if t206[3].Name == "Captain Elephant" and t206[3].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()

									if (CFrame.new(-7894.6181640625, 5547.1420898438, -380.29098510742).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
										handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", vector.create(-7894.6181640625, 5547.1420898438, -380.29098510742))
									end

									handlers[31](t206[3].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t206[3].Parent or t206[3].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Captain Elephant")
							end
						end
					elseif handlers[45].ffc(handlers[7], "Captain Elephant") then
						for k, child in pairs(handlers[7]:GetChildren()) do
							local t207 = {
								k,
								child
							}

							if t207[2].Name == "Captain Elephant" and t207[2].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()

									if (CFrame.new(-7894.6181640625, 5547.1420898438, -380.29098510742).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 7500 then
										handlers[7]:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("requestEntrance", vector.create(-7894.6181640625, 5547.1420898438, -380.29098510742))
									end

									handlers[31](t207[2].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()

									if not t207[2].Parent then
										break
									end

									if t207[2].Humanoid.Health <= 0 then
										break
									end

									if not getgenv().AutoFarm then
										break
									end
								until not handlers[45].CheckBoss("Captain Elephant")
							end
						end
					end
				until not handlers[45].CheckBoss("Wysper")
			elseif Quest == "Gravity Blade" then
				if not handlers[45].CheckBoss("Orbitus") then
					return
				end

				repeat
					handlers[45].wt()

					if handlers[45].ffc(handlers[40], "Orbitus") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t208 = {
								[2] = k,
								child
							}

							if t208[1].Name == "Orbitus" and t208[1].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()
									handlers[31](t208[1].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t208[1].Parent or t208[1].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Orbitus")
							end
						end
					elseif handlers[45].ffc(handlers[7], "Orbitus") then
						for k, child in pairs(handlers[7]:GetChildren()) do
							local t209 = {
								[3] = k,
								[2] = child
							}

							if t209[2].Name == "Orbitus" and t209[2].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()
									handlers[31](t209[2].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t209[2].Parent or t209[2].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Orbitus")
							end
						end
					end
				until not handlers[45].CheckBoss("Orbitus")
			elseif Quest == "Longsword" then
				if not handlers[45].CheckBoss("Diamond") then
					return
				end

				repeat
					handlers[45].wt()

					if handlers[45].ffc(handlers[40], "Diamond") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t210 = {
								[3] = k,
								[2] = child
							}

							if t210[2].Name == "Diamond" and t210[2].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()
									handlers[31](t210[2].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t210[2].Parent or t210[2].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Diamond")
							end
						end
					elseif handlers[45].ffc(handlers[7], "Diamond") then
						for k, child in pairs(handlers[7]:GetChildren()) do
							local t211 = {
								[2] = k,
								[3] = child
							}

							if t211[3].Name == "Diamond" and t211[3].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()
									handlers[31](t211[3].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t211[3].Parent or t211[3].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Diamond")
							end
						end
					end
				until not handlers[45].CheckBoss("Diamond")
			elseif Quest == "Rengoku" then
				if not handlers[45].CheckBoss("Awakened Ice Admiral") then
					return
				end

				repeat
					handlers[45].wt()

					if handlers[45].ffc(handlers[40], "Awakened Ice Admiral") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t212 = {
								[3] = k,
								[2] = child
							}

							if t212[2].Name == "Awakened Ice Admiral" and t212[2].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()
									handlers[31](t212[2].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t212[2].Parent or t212[2].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Awakened Ice Admiral")
							end
						end
					elseif handlers[45].ffc(handlers[7], "Awakened Ice Admiral") then
						for k, child in pairs(handlers[7]:GetChildren()) do
							local t213 = {
								[3] = k,
								[2] = child
							}

							if t213[2].Name == "Awakened Ice Admiral" and t213[2].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()
									handlers[31](t213[2].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t213[2].Parent or t213[2].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Awakened Ice Admiral")
							end
						end
					end
				until not handlers[45].CheckBoss("Awakened Ice Admiral")
			elseif Quest == "BartiloQuest" then
				if New_World then
					local t214 = { (handlers[7].Remotes.CommF_:InvokeServer("BartiloQuestProgress")) }

					if t214[1].KilledBandits == false then
						if not handlers[35].PlayerGui.Main.Quest.Visible or not handlers[45].sf(handlers[35].PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") or not handlers[45].sf(handlers[35].PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") then
							handlers[7].Remotes.CommF_:InvokeServer("StartQuest", "BartiloQuest", 1)
						elseif handlers[45].ffc(handlers[40], "Swan Pirate") then
							for k, child in pairs(handlers[40]:GetChildren()) do
								local t215 = {
									k,
									child
								}

								if t215[2].Name == "Swan Pirate" and t215[2].Humanoid.Health > 0 then
									handlers[7].Remotes.CommF_:InvokeServer("SetSpawnPoint")

									repeat
										handlers[45].wt()
										handlers[45].BN(t215[2].Name)
										handlers[31](t215[2].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

										if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
											handlers[7].Remotes.CommF_:InvokeServer("Buso")
										end

										handlers[14]()
									until (t215[2].HumanoidRootPart.Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 50 or t215[2].Humanoid.Health <= 0 or not getgenv().AutoFarm
								end
							end
						else
							handlers[31](CFrame.new(976.467651, 111.174057, 1229.1084), 1.5)
						end
					elseif t214[1].KilledSpring == false then
						if handlers[45].ffc(handlers[40], "Jeremy") then
							for k, child in pairs(handlers[40]:GetChildren()) do
								local t216 = {
									[3] = k,
									child
								}

								if t216[1].Name == "Jeremy" then
									repeat
										handlers[45].wt()
										handlers[31](t216[1].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

										if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
											handlers[7].Remotes.CommF_:InvokeServer("Buso")
										end

										handlers[14]()
									until not t216[1].Parent or t216[1].Humanoid.Health <= 0 or not getgenv().AutoFarm
								end
							end
						elseif handlers[45].ffc(handlers[7], "Jeremy") then
							handlers[31](handlers[7]:FindFirstChild("Jeremy").HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)
						elseif not handlers[45].ffc(handlers[40], "Jeremy") and not handlers[45].ffc(handlers[7], "Jeremy") then
							handlers[39]()
						end
					elseif t214[1].DidPlates == false then
						repeat
							handlers[45].wt(0.3)
							handlers[31](CFrame.new(-1836, 11, 1714), 1.5)
						until (Vector3.new(-1836, 11, 1714) - handlers[35].Character.HumanoidRootPart.Position).Magnitude < 10

						handlers[45].wt(1)
						handlers[7].Remotes.CommF_:InvokeServer("BartiloQuestProgress", "DidPlates")
					end
				else
					handlers[7].Remotes.CommF_:InvokeServer("TravelDressrosa")
				end
			elseif Quest == "Find Water Key" then
				if not New_World then
					handlers[7].Remotes.CommF_:InvokeServer("TravelDressrosa")
				elseif handlers[35].Backpack:FindFirstChild("Water Key") or handlers[45].ffc(handlers[35].Character, "Water Key") then
					handlers[45].Status(handlers[3]({
						" Status : Use Water ",
						"Key"
					}))
					handlers[45].Equip("Water Key")
					handlers[45].wait(0)
					handlers[46].Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
					CheckFindWaterKey = true
				else
					if handlers[45].ffc(handlers[35].Backpack, "Water Key") or handlers[45].ffc(handlers[35].Character, "Water Key") then
						return
					end

					if handlers[45].ffc(handlers[40], "Tide Keeper") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t217 = {
								k,
								child
							}

							if t217[2].Name == "Tide Keeper" then
								if t217[2]:FindFirstChild("Humanoid") then
									if t217[2]:FindFirstChild("Humanoid").Health > 0 then
										repeat
											task.wait()
											handlers[31](t217[2].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

											if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
												handlers[7].Remotes.CommF_:InvokeServer("Buso")
											end

											handlers[14]()
										until not t217[2].Parent or t217[2].Humanoid.Health <= 0 or not getgenv().AutoFarm
									end
								end
							end
						end
					elseif handlers[45].ffc(handlers[7], "Tide Keeper") then
						for k, child in pairs(handlers[7]:GetChildren()) do
							local t218 = {
								k,
								child
							}

							if t218[2].Name == "Tide Keeper" then
								if t218[2]:FindFirstChild("Humanoid") then
									if t218[2]:FindFirstChild("Humanoid").Health > 0 then
										repeat
											handlers[45].wt()
											handlers[31](t218[2].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

											if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
												handlers[7].Remotes.CommF_:InvokeServer("Buso")
											end

											handlers[14]()
										until not t218[2].Parent or t218[2].Humanoid.Health <= 0 or not getgenv().AutoFarm
									end
								end
							end
						end
					else
						handlers[35]:Kick("Hop")
						handlers[45].wt(0.1)
						handlers[10]:Teleport(handlers[30], handlers[35])
					end
				end
			elseif Quest == "Evo Race V1" then
				if not New_World then
					handlers[7].Remotes.CommF_:InvokeServer("TravelDressrosa")
				elseif not Start_Quest_Evo_V1 then
					if handlers[7].Remotes.CommF_:InvokeServer("Alchemist", "1") == 1 then
						Start_Quest_Evo_V1 = true
					elseif handlers[7].Remotes.CommF_:InvokeServer("Alchemist", "1") == 2 then
						Start_Quest_Evo_V1 = true
						handlers[7].Remotes.CommF_:InvokeServer("Alchemist", "2")

						return
					end

					handlers[7].Remotes.CommF_:InvokeServer("Alchemist", "2")
				elseif not handlers[45].ffc(handlers[35].Backpack, "Flower 3") and not handlers[45].ffc(handlers[35].Character, "Flower 3") then
					if (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(976.467651, 111.174057, 1229.1084)).Magnitude <= 800 then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t219 = {
								[2] = k,
								child
							}

							if t219[1].Humanoid.Health > 0 and (t219[1].HumanoidRootPart.Position - Vector3.new(976.467651, 111.174057, 1229.1084)).Magnitude <= 800 then
								repeat
									handlers[45].wt()
									handlers[31](t219[1].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t219[1].Parent or t219[1].Humanoid.Health <= 0 or handlers[45].ffc(handlers[35].Backpack, "Flower 3") or handlers[45].ffc(handlers[35].Character, "Flower 3") or not getgenv().AutoFarm
							end
						end
					else
						handlers[31](CFrame.new(976.467651, 111.174057, 1229.1084), 1.5)
					end
				elseif not handlers[45].ffc(handlers[35].Backpack, "Flower 2") and not handlers[45].ffc(handlers[35].Character, "Flower 2") then
					if handlers[45].ffc(handlers[19], "Flower2") then
						handlers[31](handlers[19].Flower2.CFrame, 1.5)

						if (handlers[35].Character.HumanoidRootPart.Position - handlers[19].Flower2.Position).Magnitude <= 5 then
							handlers[2]:SendKeyEvent(true, "Space", false, game)
							handlers[45].wt(0.5)
							handlers[2]:SendKeyEvent(false, "Space", false, game)
						end
					end
				elseif handlers[45].ffc(handlers[35].Backpack, "Flower 1") or handlers[45].ffc(handlers[35].Character, "Flower 1") then
					handlers[7].Remotes.CommF_:InvokeServer("Alchemist", "3")
				else
					handlers[31](handlers[19].Flower1.CFrame, 1.5)

					if (handlers[35].Character.HumanoidRootPart.Position - handlers[19].Flower1.Position).Magnitude <= 5 and handlers[19].Flower1.Transparency == 0 then
						handlers[2]:SendKeyEvent(true, "Space", false, game)
						handlers[45].wt(0.5)
						handlers[2]:SendKeyEvent(false, "Space", false, game)
					end

					handlers[45].wt(1)
				end
			elseif Quest == "Evo Race V2" then
				if not New_World then
					handlers[7].Remotes.CommF_:InvokeServer("TravelDressrosa")
				elseif handlers[35].Data.Race.Value == "Human" then
					if Quest_Start_Evo_Human_V3 then
						if not handlers[45].ffc(handlers[40], "Orbitus") and not handlers[45].ffc(handlers[7], "Orbitus") and not Kill_Orbitus then
							handlers[45].HopLowServer(4)
							wait(0.2)
							handlers[35]:Kick("Hop")
							handlers[45].wt(0.1)
							handlers[10]:Teleport(handlers[30], handlers[35])
						end

						if not handlers[45].ffc(handlers[40], "Jeremy") and not handlers[45].ffc(handlers[7], "Jeremy") and not Kill_Jeremy then
							handlers[45].HopLowServer(4)
							wait(0.2)
							handlers[35]:Kick("Hop")
							handlers[45].wt(0.1)
							handlers[10]:Teleport(handlers[30], handlers[35])
						end

						if not handlers[45].ffc(handlers[40], "Diamond") and not handlers[45].ffc(handlers[7], "Diamond") and not Kill_Diamond then
							handlers[45].HopLowServer(4)
							wait(0.2)
							handlers[35]:Kick("Hop")
							handlers[45].wt(0.1)
							handlers[10]:Teleport(handlers[30], handlers[35])
						end

						if not Kill_Orbitus then
							repeat
								handlers[45].wt()
								pcall(function()
									if handlers[45].ffc(handlers[40], "Orbitus") or handlers[45].ffc(handlers[7], "Orbitus") then
										if handlers[45].ffc(handlers[40], "Orbitus") then
											for k, child in pairs(handlers[40]:GetChildren()) do
												local t220 = {
													[3] = k,
													child
												}

												if t220[1].Name == "Orbitus" and t220[1].Humanoid.Health > 0 then
													repeat
														handlers[45].wt()

														if not t220[1]:FindFirstChild("HumanoidRootPart") then
															Kill_Orbitus = true

															break
														end

														handlers[31](t220[1].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

														if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
															handlers[7].Remotes.CommF_:InvokeServer("Buso")
														end

														handlers[14]()
													until not t220[1].Parent or t220[1].Humanoid.Health <= 0 or not getgenv().AutoFarm

													Kill_Orbitus = true
												end
											end
										elseif handlers[45].ffc(handlers[7], "Orbitus") then
											handlers[31](handlers[7].Orbitus.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)
										end
									end
								end)
							until Kill_Orbitus
						end

						if not Kill_Jeremy then
							repeat
								handlers[45].wt()
								pcall(function()
									if handlers[45].ffc(handlers[40], "Jeremy") or handlers[45].ffc(handlers[7], "Jeremy") then
										if handlers[45].ffc(handlers[40], "Jeremy") then
											for k, child in pairs(handlers[40]:GetChildren()) do
												local t221 = {
													[2] = k,
													[3] = child
												}

												if t221[3].Name == "Jeremy" and t221[3].Humanoid.Health > 0 then
													while true do
														handlers[45].wt()

														if not t221[3]:FindFirstChild("HumanoidRootPart") then
															Kill_Jeremy = true

															break
														end

														handlers[31](t221[3].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

														if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
															handlers[7].Remotes.CommF_:InvokeServer("Buso")
														end

														handlers[14]()

														if t221[3].Parent then
															if not (t221[3].Humanoid.Health <= 0) then
																if t221[3]:FindFirstChild("HumanoidRootPart") and getgenv().AutoFarm then
																	continue
																end
															end
														end

														break
													end

													Kill_Jeremy = true
												end
											end
										elseif handlers[45].ffc(handlers[7], "Jeremy") then
											handlers[31](handlers[7].Jeremy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)
										end
									end
								end)
							until Kill_Orbitus
						end

						if not Kill_Diamond then
							repeat
								handlers[45].wt()
								pcall(function()
									if handlers[45].ffc(handlers[40], "Diamond") or handlers[45].ffc(handlers[7], "Diamond") then
										if handlers[45].ffc(handlers[40], "Diamond") then
											for k, child in pairs(handlers[40]:GetChildren()) do
												local t222 = {
													[2] = k,
													child
												}

												if t222[1].Name == "Diamond" and t222[1].Humanoid.Health > 0 then
													repeat
														handlers[45].wt()

														if not t222[1]:FindFirstChild("HumanoidRootPart") then
															Kill_Diamond = true

															break
														end

														handlers[31](t222[1].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

														if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
															handlers[7].Remotes.CommF_:InvokeServer("Buso")
														end

														handlers[14]()
													until not t222[1].Parent or t222[1].Humanoid.Health <= 0 or not getgenv().AutoFarm

													Kill_Diamond = true
												end
											end
										elseif handlers[45].ffc(handlers[7], "Diamond") then
											handlers[31](handlers[7].Diamond.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)
										end
									end
								end)
							until Kill_Diamond
						end
					else
						handlers[7].Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
						handlers[45].wt(1)
						handlers[7].Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
						warn()

						if handlers[7].Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 1 then
							Quest_Start_Evo_Human_V3 = true
						elseif handlers[7].Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 2 then
							Quest_Start_Evo_Human_V3 = true

							return
						end
					end
				elseif handlers[35].Data.Race.Value == "Fishman" then
					if Quest_Start_Evo_Fishman_V3 then
						local t223 = {
							false,
							[3] = false
						}

						for k, child in pairs(handlers[19].SeaBeasts:GetChildren()) do
							local t224 = {
								[2] = k,
								[3] = child
							}

							if t224[3]:FindFirstChild("Health") and t224[3].Health.Value > 0 and (Vector3.new(-3823.9206542969, 76.979339599609, -11685.7734375) - t224[3].HumanoidRootPart.Position).Magnitude >= 1500 then
								t223[1] = true
								handlers[7].Remotes.CommF_:InvokeServer("BuyFishmanKarate")
								Tejao = true
								PositionSkillMasteryDevilFruit = t224[3].HumanoidRootPart.CFrame
								handlers[35].Character.Humanoid.Sit = false
								wait(1)

								if handlers[35].Character.Humanoid.Sit == false then
									Boat = nil
								end

								while true do
									wait()
									handlers[31](t224[3].HumanoidRootPart.CFrame * CFrame.new(0, 3, 0), 1.5)

									if (t224[3].HumanoidRootPart.Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 5 then
										break
									elseif not getgenv().AutoFarm then
										break
									end
								end

								repeat
									wait()
									handlers[45].Equip("Fishman Karate")

									if handlers[35].PlayerGui.Main.Skills:FindFirstChild("Fishman Karate") and tostring(handlers[35].PlayerGui.Main.Skills["Fishman Karate"].Z.Title.TextColor) == "Institutional white" and handlers[35].PlayerGui.Main.Skills["Fishman Karate"].Z.Cooldown.AbsoluteSize.X == 0 then
										handlers[45].Equip("Fishman Karate")
										handlers[31](t224[3].HumanoidRootPart.CFrame * CFrame.new(0, 3, 0), 1.5)
										wait(0.5)
										PositionSkillMasteryDevilFruit = t224[3].HumanoidRootPart.Position

										if t224[3].Health.Value > 0 then
											handlers[2]:SendKeyEvent(true, "Z", false, game)
											wait(0.5)
											handlers[2]:SendKeyEvent(false, "Z", false, game)
											wait(0.2)
										end
									elseif handlers[35].PlayerGui.Main.Skills:FindFirstChild("Fishman Karate") and tostring(handlers[35].PlayerGui.Main.Skills["Fishman Karate"].X.Title.TextColor) == "Institutional white" and handlers[35].PlayerGui.Main.Skills["Fishman Karate"].X.Cooldown.AbsoluteSize.X == 0 then
										handlers[45].Equip("Fishman Karate")
										handlers[31](t224[3].HumanoidRootPart.CFrame * CFrame.new(0, 3, 0), 1.5)
										wait(0.5)
										PositionSkillMasteryDevilFruit = t224[3].HumanoidRootPart.Position

										if t224[3].Health.Value > 0 then
											handlers[2]:SendKeyEvent(true, "X", false, game)
											wait(0.5)
											handlers[2]:SendKeyEvent(false, "X", false, game)
											wait(0.2)
										end
									elseif handlers[35].PlayerGui.Main.Skills:FindFirstChild("Fishman Karate") and tostring(handlers[35].PlayerGui.Main.Skills["Fishman Karate"].C.Title.TextColor) == "Institutional white" and handlers[35].PlayerGui.Main.Skills["Fishman Karate"].C.Cooldown.AbsoluteSize.X == 0 then
										handlers[45].Equip("Fishman Karate")
										handlers[31](t224[3].HumanoidRootPart.CFrame * CFrame.new(0, 3, 0), 1.5)
										wait(0.5)
										PositionSkillMasteryDevilFruit = t224[3].HumanoidRootPart.Position

										if t224[3].Health.Value > 0 then
											handlers[2]:SendKeyEvent(true, "C", false, game)
											wait(0.5)
											handlers[2]:SendKeyEvent(false, "C", false, game)
											wait(0.2)
										end
									end
								until not t224[3].Parent or t224[3].Health.Value <= 0 or not getgenv().AutoFarm

								Tejao = false
								handlers[7].Remotes.CommF_:InvokeServer("Wenlocktoad", "3")
								wait(1)
							end
						end

						if not t223[1] then
							for k, child in pairs(handlers[19].Boats:GetChildren()) do
								local t225 = {
									[3] = k,
									child
								}

								if t225[1].Name == "Dinghy" and tostring(t225[1].Owner.Value) == handlers[35].Name then
									t223[3] = true

									if not ((Vector3.new(3017.2006835938, -4.25, -2686.3325195312) - t225[1].VehicleSeat.Position).Magnitude >= 30) then
										if handlers[35].Character.Humanoid.Sit then
											vu:Button1Down(Vector2.new(1280, 600))
											wait(1)
										elseif (handlers[35].Character.HumanoidRootPart.Position - t225[1].VehicleSeat.Position).Magnitude >= 10 then
											Boat = nil
											handlers[31](t225[1].VehicleSeat.CFramem, 1.5)
										else
											Boat = "Bit"
											handlers[35].Character.HumanoidRootPart.CFrame = t225[1].VehicleSeat.CFrame * CFrame.new(0, 1, 0)
											wait(3)
										end
									elseif handlers[35].Character.Humanoid.Sit then
										Boat = "Bit"
										TPBoat(CFrame.new(1550, -4.25, -2759), t225[1].VehicleSeat, 200)
									elseif (handlers[35].Character.HumanoidRootPart.Position - t225[1].VehicleSeat.Position).Magnitude >= 10 then
										Boat = nil
										handlers[31](t225[1].VehicleSeat.CFrame, 1.5)
									else
										Boat = "Bit"
										handlers[35].Character.HumanoidRootPart.CFrame = t225[1].VehicleSeat.CFrame * CFrame.new(0, 1, 0)
										wait(3)
									end
								end
							end
						end

						if not t223[3] and not t223[1] then
							handlers[31](CFrame.new(-1935, 6, -2564), 1.5)

							if (Vector3.new(-1935, 6, -2564) - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 then
								handlers[7].Remotes.CommF_:InvokeServer("BuyBoat", "Dinghy")
								wait(1)
								Boat = "bit"
							end
						end
					else
						handlers[7].Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
						wait(1)
						handlers[7].Remotes.CommF_:InvokeServer("Wenlocktoad", "2")

						if handlers[7].Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 1 then
							Quest_Start_Evo_Fishman_V3 = true
						elseif handlers[7].Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 2 then
							Quest_Start_Evo_Fishman_V3 = true

							return
						end
					end
				end
			elseif Quest == "Don Swan" then
				repeat
					handlers[45].wt()

					if handlers[45].ffc(handlers[40], "Don Swan") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t226 = {
								k,
								child
							}

							if t226[2].Name == "Don Swan" and t226[2].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()
									handlers[31](t226[2].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t226[2].Parent or t226[2].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Don Swan")
							end
						end
					elseif handlers[45].ffc(handlers[7], "Don Swan") then
						for k, child in pairs(handlers[7]:GetChildren()) do
							local t227 = {
								[3] = k,
								child
							}

							if t227[1].Name == "Don Swan" and t227[1].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()
									handlers[31](t227[1].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t227[1].Parent or t227[1].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Don Swan")
							end
						end
					else
						handlers[45].HopLowServer(3)
						handlers[45].wt(0.2)
						handlers[35]:Kick("Hop")
						handlers[45].wt(0.1)
						handlers[10]:Teleport(handlers[30], handlers[35])
					end
				until not handlers[45].CheckBoss("Don Swan")
			elseif Quest == "TravelZou" then
				if handlers[7].Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 1 then
					handlers[7].Remotes.CommF_:InvokeServer("TravelZou")
				end

				if not Kill_Don then
					if okokok then
						handlers[14]()
						Quest = nil
						handlers[45].Status(handlers[3]({
							" Status : Auto Farm ",
							"Level"
						}))
						handlers[39]()
					else
						handlers[7].Remotes.CommF_:InvokeServer("ZQuestProgress", "Check")
						handlers[7].Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
						handlers[45].wt(3)

						for k, child in pairs(handlers[40]:GetChildren()) do
							if ({
								k,
								[3] = child
							})[3].Name == "rip_indra" then
								Kill_Don = true
							end
						end

						okokok = true
					end
				elseif handlers[45].ffc(handlers[40], "rip_indra") then
					for k, child in pairs(handlers[40]:GetChildren()) do
						local t228 = {
							k,
							[3] = child
						}

						if t228[3].Name == "rip_indra" and t228[3].Humanoid.Health > 0 then
							if handlers[45].ffc(t228[3].Humanoid, "Animator") then
								t228[3].Humanoid.Animator:Destroy()
							end

							while true do
								handlers[45].wt(0.1)
								handlers[14]()
								handlers[31](t228[3].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

								if not (t228[3].Humanoid.Health <= 0) and t228[3].Parent then
									if handlers[7].Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 1 then
										break
									end
								else
									break
								end
							end

							if handlers[7].Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 1 then
								handlers[7].Remotes.CommF_:InvokeServer("TravelZou")
								TleP = true
								handlers[45].wt(30)
							end
						end
					end
				elseif handlers[7].Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 1 then
					handlers[7].Remotes.CommF_:InvokeServer("TravelZou")
					TleP = true
					handlers[45].wt(30)
				elseif not game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") then
					handlers[7].Remotes.CommF_:InvokeServer("ZQuestProgress", "Check")
					handlers[7].Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
					handlers[45].wt(3)
				end
			elseif Quest == "Yama" then
				if not ((handlers[19].Map.Waterfall.SealedKatana.Hitbox.Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 300) then
					handlers[31](handlers[19].Map.Waterfall.SealedKatana.Hitbox.CFrame, 1.5)
				elseif handlers[45].ffc(handlers[40], "Ghost") then
					for k, child in pairs(handlers[40]:GetChildren()) do
						local t229 = {
							[2] = k,
							[3] = child
						}

						if t229[3].Name == "Ghost" and t229[3].Humanoid.Health > 0 then
							if handlers[45].ffc(t229[3].Humanoid, "Animator") then
								t229[3].Humanoid.Animator:Destroy()
							end

							while true do
								wait(0.1)
								handlers[14]()
								t229[3].HumanoidRootPart.Size = Vector3.new(50, 50, 50)
								handlers[31](t229[3].HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 1.5)
								handlers[33]:Button1Down(Vector2.new(1280, 600))

								if not t229[3].Parent then
									break
								elseif t229[3].Humanoid.Health <= 0 then
									break
								end
							end
						end
					end
				elseif handlers[45].ffc(handlers[7], "Ghost") then
					handlers[31](handlers[7]:FindFirstChild("Ghost").HumanoidRootPart.CFrame, 1.5)
				elseif not handlers[45].ffc(handlers[40], "Ghost") and not handlers[45].ffc(handlers[7], "Ghost") then
					handlers[31](handlers[19].Map.Waterfall.SealedKatana.Hitbox.CFrame, 1.5)

					for k, child in pairs(handlers[35].Character:GetChildren()) do
						local t230 = {
							[2] = k,
							[3] = child
						}

						if t230[3]:IsA("Tool") then
							t230[3].Parent = handlers[35].Backpack
						end
					end

					fireclickdetector(handlers[19].Map.Waterfall.SealedKatana.Hitbox.ClickDetector, 1)
				end
			elseif Quest == "Quest Electric Claw" then
				if handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw", true) == "Nah." then
					handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw", "Start")
					handlers[35].Character.HumanoidRootPart.CFrame = CFrame.new(-12548, 337, -7481)
				elseif handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw", true) == 4 then
					handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw", "Start")
					handlers[35].Character.HumanoidRootPart.CFrame = CFrame.new(-12548, 337, -7481)

					return
				elseif handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw", true) == 3 then
					Electric_Claw_C = true
				elseif handlers[7].Remotes.CommF_:InvokeServer("BuyElectricClaw", true) == 0 then
					Electric_Claw_C = true

					return
				end
			elseif Quest == "Venom Bow" then
				if not handlers[45].CheckBoss("Hydra Leader") then
					return
				end

				repeat
					handlers[45].wt()

					if handlers[45].ffc(handlers[40], "Hydra Leader") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t231 = {
								[2] = k,
								child
							}

							if t231[1].Name == "Hydra Leader" and t231[1].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()
									handlers[31](t231[1].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t231[1].Parent or t231[1].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Hydra Leader")
							end
						end
					elseif handlers[45].ffc(handlers[7], "Hydra Leader") then
						for k, child in pairs(handlers[7]:GetChildren()) do
							local t232 = {
								k,
								child
							}

							if t232[2].Name == "Hydra Leader" and t232[2].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()
									handlers[31](t232[2].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t232[2].Parent or t232[2].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Hydra Leader")
							end
						end
					end
				until not handlers[45].CheckBoss("Hydra Leader")
			elseif Quest == "Godhuman" then
				if handlers[45].CheckItem("Fish Tail") >= 20 and handlers[45].CheckItem("Magma Ore") >= 20 and handlers[45].CheckItem("Mystic Droplet") >= 10 and handlers[45].CheckItem("Dragon Scale") >= 10 then
					handlers[7].Remotes.CommF_:InvokeServer("BuyGodhuman", true)
					Godhuman = true
				elseif handlers[45].CheckItem("Fish Tail") < 20 or handlers[45].CheckItem("Magma Ore") < 20 or handlers[45].CheckItem("Mystic Droplet") < 10 or handlers[45].CheckItem("Dragon Scale") < 10 then
					local t233 = {
						[2] = nil,
						[3] = nil,
						[4] = nil,
						[5] = nil
					}

					if handlers[45].CheckItem("Fish Tail") < 20 then
						t233[5] = "Fishman Warrior"
						t233[4] = "Fishman Commando"
						t233[3] = CFrame.new(60946.6094, 65.6735229, 1525.91687)
						t233[2] = CFrame.new(61902.7383, 32.4828358, 1478.33936)

						if (CFrame.new(61164, 12, 1820).Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude >= 2000 then
							handlers[35].Character.HumanoidRootPart.CFrame = CFrame.new(61164, 12, 1820)
						end

						if not Old_World then
							handlers[7].Remotes.CommF_:InvokeServer("TravelMain")
							TleP = true
							handlers[45].wt(50)
						end
					elseif handlers[45].CheckItem("Magma Ore") < 20 then
						t233[5] = "Magma Ninja"
						t233[4] = "Lava Pirate"
						t233[3] = CFrame.new(-5466.06445, 77.6952019, -5837.42822)
						t233[2] = CFrame.new(-5169.71729, 54.1234779, -4669.73633)

						if not New_World then
							handlers[7].Remotes.CommF_:InvokeServer("TravelDressrosa")
							TleP = true
							handlers[45].wt(50)
						end
					elseif handlers[45].CheckItem("Mystic Droplet") < 10 then
						t233[5] = "Sea Soldier"
						t233[4] = "Water Fighter"
						t233[3] = CFrame.new(-3115.78223, 63.8785706, -9808.38574)
						t233[2] = CFrame.new(-3212.99683, 263.809296, -10551.8799)

						if not New_World then
							handlers[7].Remotes.CommF_:InvokeServer("TravelDressrosa")
							TleP = true
							handlers[45].wt(50)
						end
					elseif handlers[45].CheckItem("Dragon Scale") < 10 then
						t233[5] = "Dragon Crew Warrior"
						t233[4] = "Dragon Crew Archer"
						t233[3] = CFrame.new(6241.9951171875, 51.522083282471, -1243.9771728516)
						t233[2] = CFrame.new(6488.9155273438, 383.38375854492, -110.66246032715)

						if not Three_World then
							handlers[7].Remotes.CommF_:InvokeServer("TravelZou")
							TleP = true
							handlers[45].wt(50)
						end
					end

					if t233[5] ~= nil then
						repeat
							handlers[45].wt()
							handlers[31](t233[3])
						until (t233[3].Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3

						if handlers[45].ffc(handlers[40], t233[5]) then
							for k, child in pairs(game.Workspace.Enemies:GetChildren()) do
								local t234 = {
									[2] = k,
									[3] = child
								}

								if t234[3].Name == t233[5] and t234[3].Humanoid.Health > 0 then
									StatrMagnet = true

									while true do
										handlers[45].wt()
										handlers[31](t234[3].HumanoidRootPart.CFrame * CFrame.new(0, 20, 0), 1.5)
										handlers[14]()
										handlers[45].BN(t234[3].Name)

										if not t234[3].Parent then
											break
										elseif t234[3].Humanoid.Health <= 0 then
											break
										end
									end

									StatrMagnet = false
								end
							end
						end
					end

					if t233[4] ~= nil then
						repeat
							handlers[45].wt()
							handlers[31](t233[2], 1.5)
						until (t233[2].Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3

						if game.Workspace.Enemies:FindFirstChild(t233[4]) then
							for k, child in pairs(game.Workspace.Enemies:GetChildren()) do
								local t235 = {
									[2] = k,
									[3] = child
								}

								if t235[3].Name == t233[4] and t235[3].Humanoid.Health > 0 then
									StatrMagnet = true

									while true do
										handlers[45].wt()
										handlers[31](t235[3].HumanoidRootPart.CFrame * CFrame.new(0, 20, 0), 1.5)
										handlers[14]()
										handlers[45].BN(t235[3].Name)

										if not t235[3].Parent then
											break
										elseif t235[3].Humanoid.Health <= 0 then
											break
										end
									end

									StatrMagnet = false
								end
							end
						end
					end
				end
			elseif Quest == "Longma" then
				repeat
					handlers[45].wt()

					if handlers[45].ffc(handlers[40], "Longma") then
						for k, child in pairs(handlers[40]:GetChildren()) do
							local t236 = {
								[3] = k,
								[2] = child
							}

							if t236[2].Name == "Longma" and t236[2].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()
									handlers[31](t236[2].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t236[2].Parent or t236[2].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Longma")
							end
						end
					elseif handlers[45].ffc(handlers[7], "Longma") then
						for k, child in pairs(handlers[7]:GetChildren()) do
							local t237 = {
								[2] = k,
								[3] = child
							}

							if t237[3].Name == "Longma" and t237[3].Humanoid.Health > 0 then
								repeat
									handlers[45].wt()
									handlers[31](t237[3].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

									if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
										handlers[7].Remotes.CommF_:InvokeServer("Buso")
									end

									handlers[14]()
								until not t237[3].Parent or t237[3].Humanoid.Health <= 0 or not getgenv().AutoFarm or not handlers[45].CheckBoss("Longma")
							end
						end
					else
						handlers[45].HopLowServer(3)
						handlers[45].wt(0.2)
						handlers[35]:Kick("Hop")
						handlers[45].wt(0.1)
						handlers[10]:Teleport(handlers[30], handlers[35])
					end
				until not handlers[45].CheckBoss("Longma")
			elseif Quest == "Soul Guitar" then
				if not (handlers[45].CheckItem("Bones") < 500) then
					if not (handlers[45].CheckItem("Ectoplasm") < 250) then
						if not Three_World then
							handlers[7].Remotes.CommF_:InvokeServer("TravelZou")
							TleP = true
							wait(50)
						elseif tostring(game:GetService("Workspace").Map["Haunted Castle"].SwampWater.BrickColor) == "Maroon" then
							if handlers[7].Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check") ~= nil then
								if handlers[7].Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check").Swamp == false then
									repeat
										wait()
										handlers[31](CFrame.new(-10147.779296875, 138.6266784668, 5939.5600585938), 1.5)
									until (Vector3.new(-10147.779296875, 138.6266784668, 5939.5600585938) - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3

									wait(1)
									get_mon = {}
									handlers[45].GetMon_Soul()

									if #get_mon >= 6 then
										for k, child in pairs(handlers[35].Character:GetChildren()) do
											local t238 = {
												[3] = k,
												[2] = child
											}

											if t238[2]:IsA("Tool") then
												t238[2].Parent = handlers[35].Backpack
											end
										end

										handlers[31](CFrame.new(-10147.779296875, 158.6266784668, 5939.5600585938), 1.5)

										local next_ = next
										local children, v721 = game:GetService("Workspace").Enemies:GetChildren()

										for k, v in next_, children, v721 do
											local t239 = {
												[2] = k,
												v
											}

											if (t239[1].HumanoidRootPart.Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 500 then
												t239[1].HumanoidRootPart.CFrame = handlers[35].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 20)
												sethiddenproperty(handlers[35], "SimulationRadius", math.huge)
											end
										end

										wait(1)
										handlers[14]()
										wait(2)
									end
								end
							end
						elseif handlers[7].Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check") ~= nil then
							local t240 = {
								[2] = handlers[7].Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check")
							}

							if not Quest_Soul_Guitar then
								repeat
									wait(0.1)
									handlers[31](CFrame.new(-9680.7412109375, 6.1591067314148, 6346.1552734375), 1.5)
								until (Vector3.new(-9680.7412109375, 6.1591067314148, 6346.1552734375) - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 5

								wait(1)

								for k, v in pairs(handlers[7].Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check")) do
									local t241 = {
										[3] = k,
										v
									}

									if t241[1] == false then
										handlers[7].Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", t241[3])
									end
								end

								wait(2)

								for k, v in pairs(handlers[7].Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check")) do
									local t242 = {
										[3] = k,
										v
									}

									if t242[1] == false then
										handlers[7].Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", t242[3])
									end
								end

								wait(1)
								Quest_Soul_Guitar = true
							end
						elseif tostring(game:GetService("Workspace").Map["Haunted Castle"].SwampWater.BrickColor) ~= "Maroon" then
							if handlers[7].Remotes.CommF_:InvokeServer("gravestoneEvent", 2) == true then
								handlers[7].Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)
							else
								handlers[31](CFrame.new(-8652.6416015625, 141.10939025879, 6168.810546875), 1.5)
							end
						end
					elseif not New_World then
						handlers[7].Remotes.CommF_:InvokeServer("TravelDressrosa")
						TleP = true
						wait(50)
					elseif (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(921.30249023438, 125.400390625, 32937.34375)).Magnitude >= 3000 then
						repeat
							handlers[45].wt()
							handlers[31](CFrame.new(921.30249023438, 125.400390625, 32937.34375), 1.5)
						until (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(921.30249023438, 125.400390625, 32937.34375)).Magnitude <= 3
					elseif (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(921.30249023438, 125.400390625, 32937.34375)).Magnitude < 3000 then
						Monster = nil

						for i = 1500, 0, -300 do
							handlers[45].GetMonster(({
								[2] = i
							})[2])
						end

						if Monster ~= nil and Monster.Humanoid.Health > 0 then
							PosMon_X = Monster.HumanoidRootPart.CFrame
							StatrMagnet = true

							while true do
								wait()
								handlers[31](Monster.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0), 1.5)
								handlers[14]()

								if not Monster.Parent then
									break
								elseif Monster.Humanoid.Health <= 0 then
									break
								end
							end

							StatrMagnet = false
						elseif Monster == nil then
							for i = 1500, 0, -300 do
								handlers[45].GetMonster(({
									[2] = i
								})[2])
							end

							if Monster == nil then
								handlers[31](CFrame.new(921.30249023438, 125.400390625, 32937.34375), 1.5)
							end
						end
					end
				elseif Three_World then
					handlers[45].FarmBone(false)
				else
					handlers[7].Remotes.CommF_:InvokeServer("TravelZou")
					TleP = true
					wait(50)
				end
			elseif Quest == "RGB" then
				local t243 = { nil }

				if handlers[7].Remotes.CommF_:InvokeServer("HornedMan", "Bet") == nil then
					if handlers[35].PlayerGui.Main.Quest.Visible then
						local t244 = { game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text }

						if string.find(t244[1], "Stone") and (handlers[45].ffc(handlers[40], "Stone") or handlers[45].ffc(handlers[7], "Stone")) then
							t243[1] = "Stone"
						end

						if string.find(t244[1], "Hydra Leader") and (handlers[45].ffc(handlers[40], "Hydra Leader") or handlers[45].ffc(handlers[7], "Hydra Leader")) then
							t243[1] = "Hydra Leader"
						end

						if string.find(t244[1], "Kilo Admiral") and (handlers[45].ffc(handlers[40], "Kilo Admiral") or handlers[45].ffc(handlers[7], "Kilo Admiral")) then
							t243[1] = "Kilo Admiral"
						end

						if string.find(t244[1], "Captain Elephant") and (handlers[45].ffc(handlers[40], "Captain Elephant") or handlers[45].ffc(handlers[7], "Captain Elephant")) then
							t243[1] = "Captain Elephant"
						end

						if string.find(t244[1], "Beautiful Pirate") and (handlers[45].ffc(handlers[40], "Beautiful Pirate") or handlers[45].ffc(handlers[7], "Beautiful Pirate")) then
							t243[1] = "Beautiful Pirate"
						end

						if t243[1] == nil then
							if handlers[7].Remotes.CommF_:InvokeServer("HornedMan", "Bet") == 1 then
								return
							end

							handlers[35]:Kick("Hop")
							handlers[45].wt(0.1)
							handlers[10]:Teleport(handlers[30], handlers[35])
						elseif handlers[45].ffc(handlers[40], t243[1]) then
							for k, child in pairs(handlers[40]:GetChildren()) do
								local t245 = {
									[2] = k,
									[3] = child
								}

								if t245[3].Name == t243[1] and t245[3].Humanoid.Health > 0 then
									repeat
										handlers[45].wt()
										handlers[31](t245[3].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

										if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
											handlers[7].Remotes.CommF_:InvokeServer("Buso")
										end

										handlers[14]()
									until not t245[3].Parent or t245[3].Humanoid.Health <= 0 or not getgenv().AutoFarm
								end
							end
						elseif handlers[45].ffc(handlers[7], t243[1]) then
							for k, child in pairs(handlers[7]:GetChildren()) do
								local t246 = {
									[3] = k,
									child
								}

								if t246[1].Name == t243[1] and t246[1].Humanoid.Health > 0 then
									repeat
										handlers[45].wt()
										handlers[31](t246[1].HumanoidRootPart.CFrame * CFrame.new(0, 40, 0), 1.5)

										if not handlers[45].ffc(handlers[35].Character, "HasBuso") then
											handlers[7].Remotes.CommF_:InvokeServer("Buso")
										end

										handlers[14]()
									until not t246[1].Parent or t246[1].Humanoid.Health <= 0 or not getgenv().AutoFarm
								end
							end
						end
					end
				elseif handlers[7].Remotes.CommF_:InvokeServer("HornedMan", "Bet") == 1 then
					return
				end
			elseif Quest == "Pull Lerver" then
				if not ExSeb then
					if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check") == 1 then
						local t247 = { {
							"RaceV4Progress",
							"Check"
						} }

						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(t247[1]))
						t247[3] = {
							"RaceV4Progress",
							"Begin"
						}
						game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(t247[3]))
					elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check") == 2 then
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(({ {
							"RaceV4Progress",
							"Check"
						} })[1]))

						repeat
							wait()
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2959.87231, 2282.42139, -7216.23193)

							local t248 = {
								{
									"RaceV4Progress",
									"Teleport"
								}
							}

							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(t248[1]))
						until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(28286.35546875, 14896.5078125, 102.62469482422)).Magnitude <= 15
					elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check") == 3 then
						ExSeb = true

						if not ujihfdg then
							local t249 = {
								[3] = {
									"RaceV4Progress",
									"Check"
								}
							}

							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(t249[3]))
							wait(1)
							t249[2] = {
								"RaceV4Progress",
								"Continue"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(t249[2]))
							ujihfdg = true
						end
					elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check") == 4 then
						ExSeb = true
					end
				elseif game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
					if handlers[35].Character.Humanoid.Sit == true then
						handlers[35].Character.Humanoid.Sit = false
						wait(0.5)
						handlers[35].Character.HumanoidRootPart.CFrame *= CFrame.new(0, 15, 0)
						wait(1)
					else
						local t250 = { game:GetService("Workspace").Map:FindFirstChild("MysticIsland").WorldPivot * CFrame.new(0, 500, 0) }

						if (t250[1].Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 25 then
							task.spawn(function()
								while true do
									wait(0.2)
									handlers[19].CurrentCamera.CFrame = CFrame.lookAt(handlers[19].CurrentCamera.CFrame.Position, handlers[16]:GetMoonDirection() + handlers[19].CurrentCamera.CFrame.Position)

									if not StopCamera then
										if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
											if not handlers[7].Remotes.CommF_:InvokeServer("CheckTempleDoor") then
												continue
											end
										end

										break
									end

									break
								end
							end)
							handlers[7]:WaitForChild("Remotes"):WaitForChild("CommE"):FireServer("ActivateAbility")
							wait(17)

							for k, child in pairs(game:GetService("Workspace").Map.MysticIsland:GetChildren()) do
								local t251 = {
									[3] = k,
									child
								}

								if t251[1].ClassName == "MeshPart" and t251[1].Name == "Part" and t251[1].Transparency == 0 then
									while true do
										wait(0.2)
										StopCamera = true
										handlers[31](t251[1].CFrame, 1.5)
										wait(0.5)
										handlers[2]:SendKeyEvent(true, "Space", false, game)
										wait(0.5)
										handlers[2]:SendKeyEvent(false, "Space", false, game)

										if t251[1].Transparency == 1 then
											break
										end

										if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
											if not handlers[7].Remotes.CommF_:InvokeServer("CheckTempleDoor") then
												continue
											end
										end

										break
									end

									wait(0.5)
								end
							end
						else
							handlers[31](t250[1], 1.5)
						end
					end
				end
			elseif Quest == "Cursed Dual Katana" then
				if handlers[7].Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor") == "opened" then
					local t252 = {
						[2] = handlers[7].Remotes.CommF_:InvokeServer("CDKQuest", "Progress")
					}

					if t252[2].Good == 0 or t252[2].Good == -3 then
						CDK_Q_S_C = 3

						if t252[2].Good == 0 then
							handlers[45].GetQuest("Good")
						elseif t252[2].Good == -3 then
							repeat
								wait()
								handlers[31](CFrame.new(-4600.37, 15.1245, -2881.18), 1.5)

								if (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(-4600.37, 15.1245, -2881.18)).Magnitude <= 3 then
									wait(1)
									handlers[7].Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", handlers[25].NPCs:FindFirstChild("Luxury Boat Dealer"), "Check")
									handlers[7].Remotes.CommF_:InvokeServer("GetUnlockables")
									handlers[7].Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", handlers[25].NPCs:FindFirstChild("Luxury Boat Dealer"))
									wait(0.5)
									Q_Boat_1 = true
								end
							until Q_Boat_1

							repeat
								wait()
								handlers[31](CFrame.new(-2068.63, 3.37222, -9887.08), 1.5)

								if (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(-2068.63, 3.37222, -9887.08)).Magnitude <= 3 then
									wait(1)
									handlers[7].Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", handlers[25].NPCs:FindFirstChild("Luxury Boat Dealer"), "Check")
									handlers[7].Remotes.CommF_:InvokeServer("GetUnlockables")
									handlers[7].Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", handlers[25].NPCs:FindFirstChild("Luxury Boat Dealer"))
									wait(0.5)
									Q_Boat_2 = true
								end
							until Q_Boat_2

							repeat
								wait()
								handlers[31](CFrame.new(-9531.19, 5.91675, -8377.75), 1.5)

								if (handlers[35].Character.HumanoidRootPart.Position - Vector3.new(-9531.19, 5.91675, -8377.75)).Magnitude <= 3 then
									wait(1)
									handlers[7].Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", handlers[25].NPCs:FindFirstChild("Luxury Boat Dealer"), "Check")
									handlers[7].Remotes.CommF_:InvokeServer("GetUnlockables")
									handlers[7].Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", handlers[25].NPCs:FindFirstChild("Luxury Boat Dealer"))
									wait(0.5)
									Q_Boat_3 = true
								end
							until Q_Boat_3

							Q_Boat_1 = false
							Q_Boat_2 = false
							Q_Boat_3 = false
						end
					elseif t252[2].Evil == 0 or t252[2].Evil == -3 then
						CDK_Q_S_C = 4

						if t252[2].Evil == 0 then
							handlers[45].GetQuest("Evil")
						elseif t252[2].Evil == -3 then
							Stop_Fast_Attack = true

							for k, child in pairs(handlers[40]:GetChildren()) do
								local t253 = {
									[2] = k,
									[3] = child
								}

								if t253[3]:FindFirstChild("HumanoidRootPart") and (t253[3].HumanoidRootPart.Position - Vector3.new(-13347.6982, 332.378143, -7652.27783)).Magnitude > 10 then
									t253[3].HumanoidRootPart.CFrame = CFrame.new(-13347.6982, 332.378143, -7652.27783)
									sethiddenproperty(handlers[35], "SimulationRadius", math.huge)
								end
							end

							handlers[31](CFrame.new(-13347.6982, 332.378143, -7652.27783, -0.97929436, 4.50812898e-08, -0.202441484, 4.58302409e-08, 1, 9.8789521e-10, 0.202441484, -8.31050162e-09, -0.97929436), 1.5)
						end
					elseif t252[2].Evil == 1 or t252[2].Evil == -4 then
						Stop_Fast_Attack = false
						CDK_Q_S_C = 5

						if t252[2].Evil == 1 then
							handlers[45].GetQuest("Evil")
						elseif t252[2].Evil == -4 and handlers[45].ffc(handlers[35], "QuestHaze") then
							if Quest_Kill == nil then
								for k, child in pairs(handlers[35].QuestHaze:GetChildren()) do
									local t254 = {
										[2] = k,
										child
									}

									if tonumber(t254[1].Value) > 0 and Quest_Kill == nil then
										SelectMonster = t254[1].Name
										CFrameMon = nil
										CheckLevel2()

										if CFrameMon ~= nil then
											Quest_Kill = t254[1].Name
										end
									end
								end
							else
								local ok = not handlers[45].ffc(handlers[35].QuestHaze, Quest_Kill)

								if not ok then
									ok = not (tonumber(handlers[35].QuestHaze:FindFirstChild(Quest_Kill).Value) <= 0)
								end

								if ok then
									if handlers[45].ffc(handlers[35].QuestHaze, Quest_Kill) then
										if not (tonumber(handlers[35].QuestHaze:FindFirstChild(Quest_Kill).Value) > 0) then
											Quest_Kill = nil

											return
										end

										for k, child in pairs(handlers[40]:GetChildren()) do
											local t255 = {
												k,
												child
											}

											if t255[2]:FindFirstChild("Humanoid") and t255[2].Humanoid.Health > 0 then
												if t255[2]:FindFirstChild("HazeESP") then
													while true do
														wait(0.1)
														handlers[31](t255[2].HumanoidRootPart.CFrame * CFrame.new(0, 25, 0), 1.5)
														handlers[14]()

														if not t255[2].Parent then
															break
														elseif t255[2].Humanoid.Health <= 0 then
															break
														end
													end
												end
											end
										end

										handlers[31](CFrameMon, 1.5)
									else
										Quest_Kill = nil
									end
								else
									Quest_Kill = nil
								end
							end
						end
					elseif t252[2].Good == 1 or t252[2].Good == -4 then
						CDK_Q_S_C = 6

						if t252[2].Good == 1 then
							handlers[45].GetQuest("Good")
						elseif t252[2].Good == -4 then
							handlers[31](CFrame.new(-5543.0805664062, 313.76550292969, -2969.4846191406), 1.5)

							if (Vector3.new(-5543.0805664062, 313.76550292969, -2969.4846191406) - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 1500 then
								for k, child in pairs(handlers[40]:GetChildren()) do
									local t256 = {
										[3] = k,
										child
									}

									if t256[1]:FindFirstChild("Humanoid") and t256[1].Humanoid.Health > 0 and (t256[1].HumanoidRootPart.Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 1500 then
										while true do
											wait(0.3)
											handlers[14]()
											handlers[31](t256[1].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

											if not t256[1].Parent then
												break
											elseif t256[1].Humanoid.Health <= 0 then
												break
											end
										end
									end
								end
							end
						end
					elseif t252[2].Good == 2 or t252[2].Good == -5 then
						CDK_Q_S_C = 7

						if t252[2].Good == 2 then
							handlers[45].GetQuest("Good")
						elseif t252[2].Good == -5 then
							if not Kill_Boss_Cake then
								if handlers[45].ffc(handlers[40], "Cake Queen") then
									for k, child in pairs(handlers[40]:GetChildren()) do
										local t257 = {
											[3] = k,
											[2] = child
										}

										if t257[2].Name == "Cake Queen" and t257[2].Humanoid.Health > 0 and not Kill_Boss_Cake then
											repeat
												wait(0.3)

												if not handlers[45].ffc(t257[2], "HumanoidRootPart") then
													break
												end

												handlers[31](t257[2].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)
												handlers[14]()
											until not t257[2].Parent or t257[2].Humanoid.Health <= 0

											Kill_Boss_Cake = true
											wait(1)
										end
									end
								else
									handlers[31](CFrame.new(-714.643066, 381.565613, -11021.0566), 1.5)
								end
							elseif not handlers[19].Map:FindFirstChild("HeavenlyDimension") then
								if not handlers[19].Map:FindFirstChild("HeavenlyDimension") then
									wait(5)

									if not handlers[19].Map:FindFirstChild("HeavenlyDimension") then
										Kill_Boss_Cake = false
									end
								end
							elseif not Ceyma_HeavenlyDimension then
								repeat
									wait(0.1)
									handlers[31](handlers[19].Map:FindFirstChild("HeavenlyDimension").WorldPivot, 1.5)
								until (handlers[19].Map:FindFirstChild("HeavenlyDimension").WorldPivot.Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 5

								wait(1)
								Ceyma_HeavenlyDimension = true
							elseif Ceyma_HeavenlyDimension then
								handlers[14]()

								if handlers[40]:FindFirstChildOfClass("Model") then
									for k, child in pairs(handlers[40]:GetChildren()) do
										local t258 = {
											[3] = k,
											[2] = child
										}

										if t258[2]:FindFirstChild("HumanoidRootPart") then
											if t258[2]:FindFirstChild("Humanoid") then
												if (handlers[19].Map:FindFirstChild("HeavenlyDimension").WorldPivot.Position - t258[2].HumanoidRootPart.Position).Magnitude <= 1000 and t258[2].Humanoid.Health > 0 then
													while true do
														wait()
														handlers[31](t258[2].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)
														handlers[14]()

														if not t258[2].Parent then
															break
														elseif t258[2].Humanoid.Health <= 0 then
															break
														end
													end
												end
											end
										end
									end
								elseif not handlers[40]:FindFirstChildOfClass("Model") then
									handlers[45].GetTorch("Torch1")

									if not handlers[40]:FindFirstChildOfClass("Model") then
										handlers[45].GetTorch("Torch2")

										if not handlers[40]:FindFirstChildOfClass("Model") then
											handlers[45].GetTorch("Torch3")

											if not handlers[40]:FindFirstChildOfClass("Model") then
												if handlers[19].Map:FindFirstChild("HeavenlyDimension") then
													handlers[19].Map.HeavenlyDimension.Exit.CFrame = handlers[35].Character.HumanoidRootPart.CFrame
													wait(1)
												end
											end
										end
									end
								end
							end
						end
					elseif t252[2].Evil == 2 or t252[2].Evil == -5 then
						CDK_Q_S_C = 8

						if t252[2].Evil == 2 then
							handlers[45].GetQuest("Evil")
						elseif t252[2].Evil == -5 then
							if not handlers[19].Map:FindFirstChild("HellDimension") then
								if not handlers[19].Map:FindFirstChild("HellDimension") then
									local ok2 = handlers[40]:FindFirstChild("Soul Reaper")

									if not ok2 then
										ok2 = game.ReplicatedStorage:FindFirstChild("Soul Reaper")
									end

									if ok2 then
										Stop_Fast_Attack = true

										if not handlers[40]:FindFirstChild("Soul Reaper") then
											if game.ReplicatedStorage:FindFirstChild("Soul Reaper") then
												repeat
													wait(0.2)
													handlers[31](game.ReplicatedStorage:FindFirstChild("Soul Reaper").HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)
												until handlers[40]:FindFirstChild("Soul Reaper")

												wait(1)
											end
										end

										if handlers[40]:FindFirstChild("Soul Reaper") then
											handlers[31](handlers[40]:FindFirstChild("Soul Reaper").HumanoidRootPart.CFrame * CFrame.new(0, 0, 2), 1.5)
											wait(1)
										end
									elseif handlers[7].Remotes.CommF_:InvokeServer("Bones", "Check") > 0 and handlers[45].CheckItem("Bones") > 500 then
										repeat
											wait(0.2)
											handlers[7].Remotes.CommF_:InvokeServer("Bones", "Check")
											handlers[7].Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
										until handlers[7].Remotes.CommF_:InvokeServer("Bones", "Check") == 0

										wait(1)

										if not Dragon_Talon_C and (handlers[45].ffc(handlers[35].Backpack, "Fire Essence") or handlers[45].ffc(handlers[35].Character, "Fire Essence")) then
											while true do
												handlers[45].Status(handlers[3]({
													" Status : Use Fire E",
													"ssence"
												}))
												handlers[45].Equip("Fire Essence")
												handlers[45].wt(0.5)
												handlers[7].Remotes.CommF_:InvokeServer("BuyDragonTalon", true)
												handlers[7].Remotes.CommF_:InvokeServer("BuyDragonTalon")

												if handlers[45].ffc(handlers[35].Backpack, "Fire Essence") then
													continue
												end

												if not handlers[45].ffc(handlers[35].Character, "Fire Essence") then
													break
												end
											end

											handlers[7].Remotes.CommF_:InvokeServer("BuyDragonTalon")
											Dragon_Talon_C = true
										end

										if handlers[45].ffc(handlers[35].Backpack, "Hallow Essence") or handlers[45].ffc(handlers[35].Character, "Hallow Essence") then
											while true do
												handlers[45].Status(handlers[3]({
													" Status : Use Hallow",
													" Essence"
												}))
												handlers[45].Equip("Hallow Essence")
												handlers[31](CFrame.new(-8932.86, 143.258, 6063.31), 1.5)

												if handlers[45].ffc(handlers[35].Backpack, "Hallow Essence") then
													continue
												end

												if not handlers[45].ffc(handlers[35].Character, "Hallow Essence") then
													break
												end
											end
										end
									elseif not handlers[40]:FindFirstChild("Soul Reaper") then
										if not handlers[7]:FindFirstChild("Soul Reaper") then
											handlers[45].FarmBone()
										end
									end
								end
							elseif (handlers[19].Map:FindFirstChild("HellDimension").WorldPivot.Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude > 1200 then
								repeat
									wait(0.1)
									handlers[31](handlers[19].Map:FindFirstChild("HellDimension").WorldPivot, 1.5)
								until (handlers[19].Map:FindFirstChild("HellDimension").WorldPivot.Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 10

								wait(1)
							elseif (handlers[19].Map:FindFirstChild("HellDimension").WorldPivot.Position - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 1200 then
								handlers[14]()

								if handlers[40]:FindFirstChildOfClass("Model") then
									for k, child in pairs(handlers[40]:GetChildren()) do
										local t259 = {
											[2] = k,
											child
										}

										if t259[1]:FindFirstChild("HumanoidRootPart") then
											if t259[1]:FindFirstChild("Humanoid") then
												if (handlers[19].Map:FindFirstChild("HellDimension").WorldPivot.Position - t259[1].HumanoidRootPart.Position).Magnitude <= 1000 and t259[1].Humanoid.Health > 0 then
													while true do
														wait()
														handlers[31](t259[1].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)
														handlers[14]()

														if not t259[1].Parent then
															break
														elseif t259[1].Humanoid.Health <= 0 then
															break
														end
													end
												end
											end
										end
									end
								elseif not handlers[40]:FindFirstChildOfClass("Model") then
									handlers[45].GetTorchX("Torch1")

									if not handlers[40]:FindFirstChildOfClass("Model") then
										handlers[45].GetTorchX("Torch2")

										if not handlers[40]:FindFirstChildOfClass("Model") then
											handlers[45].GetTorchX("Torch3")

											if not handlers[40]:FindFirstChildOfClass("Model") then
												if handlers[19].Map:FindFirstChild("HellDimension") then
													handlers[19].Map.HellDimension.Exit.CFrame = handlers[35].Character.HumanoidRootPart.CFrame
													wait(1)
												end
											end
										end
									end
								end
							end
						end
					elseif t252[2].Evil == 3 then
						repeat
							wait()
							handlers[31](CFrame.new(-12392.2637, 603.319763, -6503.27832), 1.5)
						until (Vector3.new(-12392.2637, 603.319763, -6503.27832) - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 2

						if handlers[4]:FindFirstChild("     ") then
							handlers[4]["     "].Enabled = false
						end

						wait(1)
						handlers[2]:SendKeyEvent(true, "E", false, game)
						wait(1)
						handlers[2]:SendKeyEvent(false, "E", false, game)
						wait(1)
						handlers[45].click(handlers[35].PlayerGui.Main.Dialogue)
					elseif t252[2].Good == 3 then
						repeat
							wait()
							handlers[31](CFrame.new(-12392.5068, 603.319763, -6596.00586), 1.5)
						until (Vector3.new(-12392.5068, 603.319763, -6596.00586) - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 2

						if handlers[4]:FindFirstChild("     ") then
							handlers[4]["     "].Enabled = false
						end

						wait(1)
						handlers[2]:SendKeyEvent(true, "E", false, game)
						wait(1)
						handlers[2]:SendKeyEvent(false, "E", false, game)
						wait(1)
						handlers[45].click(handlers[35].PlayerGui.Main.Dialogue)
					elseif t252[2].Good == 4 and t252[2].Evil == 4 and handlers[19].Map.Turtle.Cursed.BossDoor.Position.Y > 584 then
						handlers[14]()

						repeat
							wait(0.1)
							handlers[31](CFrame.new(-12359.1719, 603.319702, -6550.59717, 0.481593847, 0, -0.87639451, 0, 1, 0, 0.87639451, 0, 0.481593847), 1.5)
						until (Vector3.new(-12359.1719, 603.319702, -6550.59717) - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3

						if handlers[4]:FindFirstChild("     ") then
							handlers[4]["     "].Enabled = false
						end

						wait(1)
						handlers[2]:SendKeyEvent(true, "E", false, game)
						wait(1)
						handlers[2]:SendKeyEvent(false, "E", false, game)
						wait(1)
						handlers[45].click(handlers[35].PlayerGui.Main.Dialogue)
					elseif handlers[19].Map.Turtle.Cursed.BossDoor.Position.Y <= 584 then
						if handlers[4]:FindFirstChild("     ") then
							handlers[4]["     "].Enabled = true
						end

						local t260 = { handlers[7].Remotes.CommF_:InvokeServer("getInventory") }

						for k, v in pairs(t260[1]) do
							local t261 = {
								k,
								[3] = v
							}

							if t261[3].Type == "Sword" and t261[3].Name == "Cursed Dual Katana" then
								return
							end
						end

						CDK_Q_S_C = 10

						if (Vector3.new(-12297.5605, 598.726013, -6532.96436) - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 100 then
							while true do
								wait()
								handlers[31](CFrame.new(-12379.1406, 601.433167, -6543.60742), 1.5)

								if Boss_Extant then
									break
								elseif (Vector3.new(-12379.1406, 601.433167, -6543.60742) - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3 then
									break
								end
							end

							repeat
								wait()
								handlers[31](CFrame.new(-12330.197265625, 603.31982421875, -6549.1186523438), 1.5)

								for k, child in pairs(handlers[40]:GetChildren()) do
									local t262 = {
										[2] = k,
										[3] = child
									}

									if t262[3].Name == "Cursed Skeleton Boss" then
										Boss_Extant = true
										handlers[35].Character.HumanoidRootPart.CFrame = t262[3].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
									end
								end
							until Boss_Extant or (Vector3.new(-12330.197265625, 603.31982421875, -6549.1186523438) - handlers[35].Character.HumanoidRootPart.Position).Magnitude <= 3

							wait(1)

							for k, child in pairs(handlers[40]:GetChildren()) do
								local t263 = {
									[2] = k,
									[3] = child
								}

								if t263[3].Name == "Cursed Skeleton Boss" then
									while true do
										wait(0.1)
										handlers[45].Get_Item_Inventory("Tushita")
										handlers[45].Equip("Tushita")
										handlers[31](t263[3].HumanoidRootPart.CFrame * CFrame.new(0, 30, 0), 1.5)

										if not t263[3].Parent then
											break
										elseif t263[3].Humanoid.Health <= 0 then
											break
										end
									end

									for k2, v in pairs(t260[1]) do
										local t264 = {
											[2] = k2,
											v
										}

										if t264[1].Type == "Sword" and t264[1].Name == "Cursed Dual Katana" then
											return
										end
									end
								end
							end
						elseif (Vector3.new(-12297.5605, 598.726013, -6532.96436) - handlers[35].Character.HumanoidRootPart.Position).Magnitude > 100 then
							handlers[31](CFrame.new(-12297.5605, 598.726013, -6532.96436), 1.5)
						end
					end
				else
					handlers[7].Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
				end
			end
		end, warn)
	end
end)
task.spawn(function()
	while handlers[45].wt() do
		xpcall(function()
			for k, child in pairs(handlers[40]:GetChildren()) do
				local t265 = {
					[2] = k,
					child
				}

				if handlers[45].ffc(t265[1], "Humanoid") and t265[1].Humanoid.Health <= 0 and handlers[45].ffc(t265[1], "HumanoidRootPart") and t265[1].Humanoid.Health <= 0 then
					t265[1]:Destroy()
				end
			end

			if handlers[45].ffc(handlers[35].Character, "Black Leg") then
				handlers[2]:SendKeyEvent(true, "V", false, game)
				handlers[45].wt(0.1)
				handlers[2]:SendKeyEvent(false, "V", false, game)
			end

			if handlers[45].ffc(handlers[35].Character, "HumanoidRootPart") and not handlers[45].ffc(handlers[35].Character.HumanoidRootPart, "Lock") then
				local t266 = { (handlers[35].Character:FindFirstChild("Humanoid")) }

				if t266[1] and t266[1].Sit then
					t266[1].Sit = false
				end

				t266[2] = Instance.new("BodyVelocity")
				t266[2].Name = "Lock"
				t266[2].MaxForce = Vector3.new(1e9, 1e9, 1e9)
				t266[2].Velocity = Vector3.new(0, 0, 0)
				t266[2].P = 10000
				t266[2].Parent = handlers[35].Character.HumanoidRootPart
			end
		end, warn)
	end
end)
task.spawn(function()
	while handlers[45].wt(1) do
		pcall(function()
			if not handlers[45].ffc(handlers[35].Character, "Highlight") then
				local t267 = { (Instance.new("Highlight")) }

				t267[1].Name = "Highlight"
				t267[1].FillColor = Color3.fromRGB(0, 0, 0)
				t267[1].OutlineColor = Color3.fromRGB(255, 255, 255)
				t267[1].FillTransparency = 0.5
				t267[1].OutlineTransparency = 0.2
				t267[1].Adornee = handlers[35].Character
				t267[1].Parent = handlers[35].Character
			end
		end)
	end
end)
redeem = {
	"Sub2Fer999",
	"Enyu_is_Pro",
	"JCWK",
	"StarcodeHEO",
	"MagicBUS",
	"KittGaming",
	"Sub2CaptainMaui",
	"Sub2OfficialNoobie",
	"TheGreatAce",
	"Sub2NoobMaster123",
	"Sub2Daigrock",
	"Axiore",
	"StrawHatMaine",
	"TantaiGaming",
	"Bluxxy",
	"SUB2GAMERROBOT_EXP1",
	"GAMER_ROBOT_1M",
	"SUBGAMERROBOT_RESET",
	"RESET_5B",
	handlers[3]({
		"SUB2GAMERROBOT_RESET",
		"1"
	}),
	"Sub2UncleKizaru",
	"ADMIN_TROLL ",
	"DRAGONABUSE ",
	"DEVSCOOKING "
}
task.spawn(function()
	for k, v in pairs(redeem) do
		handlers[46].Remotes.Redeem:InvokeServer(({
			[2] = k,
			v
		})[1])
	end
end)
task.spawn(function()
	while handlers[45].wt(150) do
		handlers[2]:SendKeyEvent(true, "Space", false, game)
		wait(0.5)
		handlers[2]:SendKeyEvent(false, "Space", false, game)
	end
end)
handlers[9] = game:GetService("Players")
handlers[37] = handlers[9].LocalPlayer
handlers[44] = function()
	while true do
		if not handlers[37].Character then
			task.wait(0.5)

			continue
		end

		if not handlers[37].Character:FindFirstChild("HumanoidRootPart") then
			task.wait(0.5)

			continue
		end

		break
	end

	return handlers[37].Character:WaitForChild("HumanoidRootPart")
end
handlers[18] = handlers[44]().Position
handlers[28] = 0
handlers[36] = 1
task.spawn(function()
	while task.wait() do
		if Quest ~= "Cursed Dual Katana" then
			if Quest ~= "Evo Race V2" and Quest ~= "Evo Race V1" then
				if not SROP then
					local t268 = {}

					task.wait(handlers[36])
					t268[2] = handlers[44]().Position
					t268[1] = (t268[2] - handlers[18]).Magnitude

					if t268[1] <= 1 then
						handlers[28] += handlers[36]

						if handlers[28] >= 30 then
							if not (Quest == "Cursed Dual Katana" or Quest == "Evo Race V2" or Quest == "Evo Race V1" or SROP) then
								handlers[45].HopLowServer(9)
							end
						end
					else
						handlers[28] = 0
						handlers[18] = t268[2]
					end
				end
			end
		end
	end
end)
task.spawn(function()
	while task.wait() do
		if handlers[25].Map:FindFirstChild("Heavenly") then
			fireproximityprompt(handlers[25].Map.HeavenlyDimension.Torch1.ProximityPrompt)
			fireproximityprompt(handlers[25].Map.HeavenlyDimension.Torch2.ProximityPrompt)
			fireproximityprompt(handlers[25].Map.HeavenlyDimension.Torch3.ProximityPrompt)
		end

		if handlers[25].Map:FindFirstChild("HellDimension") then
			fireproximityprompt(handlers[25].Map.HellDimension.Torch1.ProximityPrompt)
			fireproximityprompt(handlers[25].Map.HellDimension.Torch2.ProximityPrompt)
			fireproximityprompt(handlers[25].Map.HellDimension.Torch3.ProximityPrompt)
		end
	end
end)
handlers[37].PlayerGui.Notifications.Enabled = false
task.spawn(function()
	while task.wait() do
		pcall(function()
			if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Lock") then
				local t269 = {}

				if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit == true then
					game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit = false
				end

				t269[2] = Instance.new("BodyVelocity")
				t269[2].Name = "Lock"
				t269[2].Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
				t269[2].MaxForce = Vector3.new(9e9, 9e9, 9e9)
				t269[2].Velocity = Vector3.new(0, 0, 0)
			end
		end)
	end
end)
handlers[45].wt(5)
_G.Ew = false
Ewx = false
task.spawn(function()
	while handlers[45].wt() do
		pcall(function()
			if handlers[1].Value >= 2500000 and New_World then
				handlers[7].Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1")
				handlers[7].Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2")
				handlers[7].Remotes.CommF_:InvokeServer("LegendarySwordDealer", "3")
			end

			if handlers[45].tf(Configs.Gun, "Kabucha") and handlers[17].Value >= 10000 and not handlers[45].gi("Kabucha") then
				handlers[7].Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "2")
			end

			if handlers[1].Value >= 3000000 then
				if handlers[45].tf(Configs.Sword, "Bisento") and not handlers[45].gi("Bisento") then
					handlers[7].Remotes.CommF_:InvokeServer("BuyItem", "Bisento")
				end

				if handlers[45].tf(Configs.Sword, "Cutlass") and not handlers[45].gi("Cutlass") then
					handlers[7].Remotes.CommF_:InvokeServer("BuyItem", "Cutlass")
				end

				if handlers[45].tf(Configs.Sword, "Katana") and not handlers[45].gi("Katana") then
					handlers[7].Remotes.CommF_:InvokeServer("BuyItem", "Katana")
				end

				if handlers[45].tf(Configs.Sword, "Dual Katana") and not handlers[45].gi("Dual Katana") then
					handlers[7].Remotes.CommF_:InvokeServer("BuyItem", "Dual Katana")
				end

				if handlers[45].tf(Configs.Sword, "Soul Cane") and not handlers[45].gi("Soul Cane") then
					handlers[7].Remotes.CommF_:InvokeServer("BuyItem", "Soul Cane")
				end

				if handlers[45].tf(Configs.Sword, "Triple Katana") and not handlers[45].gi("Triple Katana") then
					handlers[7].Remotes.CommF_:InvokeServer("BuyItem", "Triple Katana")
				end

				if handlers[45].tf(Configs.Sword, "Iron Mace") and not handlers[45].gi("Iron Mace") then
					handlers[7].Remotes.CommF_:InvokeServer("BuyItem", "Iron Mace")
				end

				if handlers[45].tf(Configs.Sword, "Pipe") and not handlers[45].gi("Pipe") then
					handlers[7].Remotes.CommF_:InvokeServer("BuyItem", "Pipe")
				end

				if handlers[45].tf(Configs.Sword, "Dual-Headed Blade") and not handlers[45].gi("Dual-Headed Blade") then
					handlers[7].Remotes.CommF_:InvokeServer("BuyItem", "Dual-Headed Blade")
				end

				if handlers[45].tf(Configs.Gun, "Musket") and not handlers[45].gi("Musket") then
					handlers[7].Remotes.CommF_:InvokeServer("BuyItem", "Musket")
				end

				if handlers[45].tf(Configs.Gun, "Flintlock") and not handlers[45].gi("Flintlock") then
					handlers[7].Remotes.CommF_:InvokeServer("BuyItem", "Flintlock")
				end

				if handlers[45].tf(Configs.Gun, "Refined Slingshot") and not handlers[45].gi("Refined Slingshot") then
					handlers[7].Remotes.CommF_:InvokeServer("BuyItem", "Refined Slingshot")
				end

				if handlers[45].tf(Configs.Gun, "Dual Flintlock") and not handlers[45].gi("Dual Flintlock") then
					handlers[7].Remotes.CommF_:InvokeServer("BuyItem", "Dual Flintlock")
				end

				if handlers[45].tf(Configs.Gun, "Cannon") and not handlers[45].gi("Cannon") then
					handlers[7].Remotes.CommF_:InvokeServer("BuyItem", "Cannon")
				end
			end

			if handlers[45].tf(Configs.Sword, "Midnight Blade") then
				if handlers[7].Remotes.CommF_:InvokeServer("Ectoplasm", "Check") >= 100 and not handlers[45].gi("Midnight Blade") then
					handlers[7].Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 3)
				end
			end

			if not klmdlkgf and handlers[24].Value >= 2000 then
				handlers[7].Remotes.CommF_:InvokeServer("BuyHaki", "Geppo")
				handlers[7].Remotes.CommF_:InvokeServer("BuyHaki", "Soru")
				handlers[7].Remotes.CommF_:InvokeServer("KenTalk", "Buy")
				klmdlkgf = true
			end

			if not klmdlkgfx and handlers[24].Value >= 1000 then
				handlers[7].Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
				klmdlkgfx = true
			end

			handlers[45].wt(100)
		end)
	end
end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/notify"))()

