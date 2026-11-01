source leak by hoàng

getgenv().K4HalloweenCandyHUD = nil
getgenv().K4HalloweenCodeAttempts = {}
task.wait(0.1)
game:IsLoaded()
game:IsLoaded()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 20)
local CommF_ = Remotes:WaitForChild("CommF_", 10)
Remotes:WaitForChild("HalloweenEvent", 10)
local Modules = ReplicatedStorage:WaitForChild("Modules", 10)
local Net = Modules:WaitForChild("Net", 10)
Net:WaitForChild("RE/RegisterAttack", 10)
Net:WaitForChild("RE/RegisterHit", 10)
local PlayerScripts = Players.LocalPlayer:FindFirstChild("PlayerScripts")
PlayerScripts:FindFirstChildOfClass("LocalScript")

getgenv().K4Halloween = {
	Config = {
		AttackInterval = 0.03,
		AttackRange = 80,
		AutoHalloweenBosses = true,
		AutoMelee = true,
		AutoRandomCandy = true,
		AutoStoreFruit = true,
		AutoSummonGreatPumpkin = true,
		BringMobs = true,
		FPSBoost = true,
		HideNotifications = true,
		PrepareBefore = 300,
		Speed = 220,
		Team = "Pirates"
	},
	DoorsOpened = 0,
	Enabled = true,
	Errors = 0,
	Hits = 0,
	Mode = "Starting"
}

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local descendants = PlayerGui:GetDescendants()

for i, v in ipairs(descendants) do
	local result = v.Name:lower()
	result:find("notification", 1, true)
	v.Enabled = false
	local changedSignal = v:GetPropertyChangedSignal("Enabled")

	changedSignal:Connect(function()
	end)
end

PlayerGui.DescendantAdded:Connect(function(descendant)
	local result3 = descendant.Name:lower()
	result3:find("notification", 1, true)
	descendant.Enabled = false
	local changedSignal5 = descendant:GetPropertyChangedSignal("Enabled")

	changedSignal5:Connect(function()
	end)
end)

Lighting.GlobalShadows = false
Lighting.ShadowSoftness = 0
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
local result2 = settings()
result2.Rendering.QualityLevel = Enum.QualityLevel.Level01
local UserSettings = game:GetService("UserSettings")
local UserGameSettings = UserSettings:GetService("UserGameSettings")
UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
local descendants2 = workspace:GetDescendants()

for i2, item2 in ipairs(descendants2) do
	item2.Enabled = false
end

local descendants3 = Lighting:GetDescendants()

for i3, item3 in ipairs(descendants3) do
	item3.Enabled = false
end

workspace.DescendantAdded:Connect(function(descendant2)
	descendant2.Enabled = false
end)

Lighting.DescendantAdded:Connect(function(descendant3)
	descendant3.Enabled = false
end)

local Util = ReplicatedStorage:FindFirstChild("Util")

for _, item in ipairs({
	{ replicatedStorage = ReplicatedStorage, childName = "EffectContainer" },
	{ replicatedStorage = Util, childName = "Particles" },
}) do
	local EffectContainer = item.replicatedStorage:FindFirstChild(item.childName)
	local descendants4 = EffectContainer:GetDescendants()

	for i4, item4 in ipairs(descendants4) do
		item4.Enabled = false
	end

	EffectContainer.DescendantAdded:Connect(function(descendant4)
		descendant4.Enabled = false
	end)
end

local descendants6 = workspace.CurrentCamera:GetDescendants()

for i6, item5 in ipairs(descendants6) do
	item5.Enabled = false
end

workspace.CurrentCamera.DescendantAdded:Connect(function(descendant6)
	descendant6.Enabled = false
end)

local changedSignal2 = workspace:GetPropertyChangedSignal("CurrentCamera")

changedSignal2:Connect(function()
	local descendants8 = workspace.CurrentCamera:GetDescendants()

	for i14, item6 in ipairs(descendants8) do
		item6.Enabled = false
	end

	workspace.CurrentCamera.DescendantAdded:Connect(function(descendant7)
		getgenv().K4HalloweenCandyHUD = nil
		descendant7.Enabled = false
	end)
end)

RunService.Heartbeat:Connect(function(deltaTime)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end)

Players.LocalPlayer.CharacterRemoving:Connect(function(character)
end)

Players.LocalPlayer.CharacterAdded:Connect(function(character2)
end)

task.spawn(function()
	for _, text in ipairs({
		"SUB2GAMERROBOT_EXP1", "SUB2CAPTAINMAUI", "Enyu_is_Pro", "Starcodeheo", "Sub2Fer999",
		"Magicbus", "JCWK", "kittgaming", "Bluxxy", "Axiore", "Sub2Daigrock", "Sub2NoobMaster123",
		"StrawHatMaine", "TantaiGaming", "TheGreatAce", "Sub2OfficialNoobie",
	}) do
		CommF_:InvokeServer("Redeem", text)
		task.wait(0.8)
	end
end)

task.spawn(function()
	local Data = Players.LocalPlayer:FindFirstChild("Data")
	Data:FindFirstChild("Points")
	warn("[K4 Halloween] Luraph Script:1235: Luraph Script:1138: [string \"Luraph  \"]:1: attempt to compare number < userdata")
	task.wait(2)
	task.wait(0.03)
	local PlayerScripts2 = Players.LocalPlayer:WaitForChild("PlayerScripts", 15)
	local HalloweenLocal = PlayerScripts2:WaitForChild("HalloweenLocal", 15)
	require(ReplicatedStorage.DialogueController)
	require(ReplicatedStorage.Global)
	require(ReplicatedStorage.Controllers.UI.ConcentrationGame)
	require(HalloweenLocal.GhostChase)
	require(HalloweenLocal.DoorMovementLock)
	local module = require(HalloweenLocal.MysteryCast)
	require(HalloweenLocal.MysteryHall)
	require(ReplicatedStorage.ItemConfig)
	require(ReplicatedStorage.Controllers.GachaClient)

	module.play = function(arg3, arg4)
		module.play(arg3, arg4)
	end

	module.lineUp = function(arg5, arg6)
		module.lineUp(arg5, arg6)
	end

	local Map = workspace:FindFirstChild("Map")
	local descendants7 = Map:GetDescendants()

	for i7, item7 in ipairs(descendants7) do
	end

	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	warn("[K4 Halloween] Luraph Script:1236: Luraph Script:1178: Luraph Script:367: [string \"Luraph  \"]:1: attempt to compare number < userdata")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	warn("[K4 Halloween] Luraph Script:1237: Luraph Script:367: [string \"Luraph  \"]:1: attempt to compare number < userdata")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	warn("[K4 Halloween] Luraph Script:1237: Luraph Script:367: [string \"Luraph  \"]:1: attempt to compare number < userdata")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	task.wait(0.03)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
end)

task.spawn(function()
	local Backpack = Players.LocalPlayer:FindFirstChild("Backpack")
	local children = Backpack:GetChildren()

	for i8, item8 in ipairs(children) do
		item8:GetAttribute("ItemId")
		item8:GetAttribute("OriginalName")
	end

	local children2 = Players.LocalPlayer.Character:GetChildren()

	for i9, item9 in ipairs(children2) do
		item9:GetAttribute("ItemId")
		item9:GetAttribute("OriginalName")
	end

	workspace:GetServerTimeNow()
	task.wait(1)
	local Backpack2 = Players.LocalPlayer:FindFirstChild("Backpack")
	local children3 = Backpack2:GetChildren()

	for i10, item10 in ipairs(children3) do
		item10:GetAttribute("ItemId")
		item10:GetAttribute("OriginalName")
	end

	local children4 = Players.LocalPlayer.Character:GetChildren()

	for i11, item11 in ipairs(children4) do
		item11:GetAttribute("ItemId")
		item11:GetAttribute("OriginalName")
	end

	workspace:GetServerTimeNow()
	task.wait(1)
end)

local K4HalloweenCandyHUD = Instance.new("ScreenGui")
K4HalloweenCandyHUD.Name = "K4HalloweenCandyHUD"
K4HalloweenCandyHUD.ResetOnSpawn = false
K4HalloweenCandyHUD.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
K4HalloweenCandyHUD.DisplayOrder = 100
getgenv().K4HalloweenCandyHUD = K4HalloweenCandyHUD
local UIScale = Instance.new("UIScale")
UIScale.Parent = K4HalloweenCandyHUD
local changedSignal3 = workspace:GetPropertyChangedSignal("CurrentCamera")

local connection = changedSignal3:Connect(function()
	connection2:Disconnect()
	UIScale.Scale = 0.75
	local changedSignal6 = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize")

	local connection3 = changedSignal6:Connect(function()
		UIScale.Scale = 0.75
	end)
end)

UIScale.Scale = 0.75
local changedSignal4 = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize")

local connection2 = changedSignal4:Connect(function()
	UIScale.Scale = 0.75
end)

local CandyBar = Instance.new("Frame")
CandyBar.Name = "CandyBar"
CandyBar.AnchorPoint = Vector2.new(0.5, 0)
CandyBar.Position = UDim2.new(0.5, 0, 0, 16)
CandyBar.Size = UDim2.new(0, 220, 0, 56)
CandyBar.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
CandyBar.BackgroundTransparency = 0.18
CandyBar.BorderSizePixel = 0
CandyBar.Parent = K4HalloweenCandyHUD
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = CandyBar
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Transparency = 0.85
UIStroke.Thickness = 1.2
UIStroke.Parent = CandyBar
local LiveStatus = Instance.new("Frame")
LiveStatus.Name = "LiveStatus"
LiveStatus.AnchorPoint = Vector2.new(1, 0)
LiveStatus.Position = UDim2.new(1, -10, 0, 6)
LiveStatus.Size = UDim2.new(0, 36, 0, 12)
LiveStatus.BackgroundTransparency = 1
LiveStatus.Parent = CandyBar
local StatusDot = Instance.new("Frame")
StatusDot.Name = "StatusDot"
StatusDot.AnchorPoint = Vector2.new(0, 0.5)
StatusDot.Position = UDim2.new(0, 0, 0.5, 0)
StatusDot.Size = UDim2.new(0, 6, 0, 6)
StatusDot.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = LiveStatus
local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(1, 0)
UICorner2.Parent = StatusDot
local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Color = Color3.fromRGB(16, 185, 129)
UIStroke2.Transparency = 0.35
UIStroke2.Thickness = 2
UIStroke2.Parent = StatusDot
local tween = TweenService:Create(UIStroke2, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Thickness = 4, Transparency = 0.85 })
tween:Play()
local LiveText = Instance.new("TextLabel")
LiveText.Name = "LiveText"
LiveText.AnchorPoint = Vector2.new(0, 0.5)
LiveText.Position = UDim2.new(0, 9, 0.5, 0)
LiveText.Size = UDim2.new(0, 24, 0, 10)
LiveText.BackgroundTransparency = 1
LiveText.Font = Enum.Font.GothamBold
LiveText.Text = "LIVE"
LiveText.TextColor3 = Color3.fromRGB(16, 185, 129)
LiveText.TextSize = 8
LiveText.TextXAlignment = Enum.TextXAlignment.Left
LiveText.Parent = LiveStatus
local TrashHubBrand = Instance.new("TextLabel")
TrashHubBrand.Name = "DuckHubBrand"
TrashHubBrand.AnchorPoint = Vector2.new(0, 1)
TrashHubBrand.Position = UDim2.new(0, 12, 1, -6)
TrashHubBrand.Size = UDim2.new(0, 60, 0, 10)
TrashHubBrand.BackgroundTransparency = 1
TrashHubBrand.Font = Enum.Font.GothamMedium
TrashHubBrand.Text = "Duck hub"
TrashHubBrand.TextColor3 = Color3.fromRGB(148, 163, 184)
TrashHubBrand.TextSize = 9
TrashHubBrand.TextXAlignment = Enum.TextXAlignment.Left
TrashHubBrand.Parent = CandyBar
local CenterGroup = Instance.new("Frame")
CenterGroup.Name = "CenterGroup"
CenterGroup.AnchorPoint = Vector2.new(0.5, 0.5)
CenterGroup.Position = UDim2.new(0.5, 0, 0.5, 0)
CenterGroup.Size = UDim2.new(0, 125, 0, 34)
CenterGroup.BackgroundTransparency = 1
CenterGroup.Parent = CandyBar
local CandyIcon = Instance.new("ImageLabel")
CandyIcon.Name = "CandyIcon"
CandyIcon.AnchorPoint = Vector2.new(0, 0.5)
CandyIcon.Position = UDim2.new(0, 0, 0.5, 0)
CandyIcon.Size = UDim2.new(0, 30, 0, 30)
CandyIcon.BackgroundTransparency = 1
CandyIcon.Image = "rbxassetid://93421335724270"
CandyIcon.ImageRectOffset = Vector2.new(457, 153)
CandyIcon.ImageRectSize = Vector2.new(150, 150)
CandyIcon.Parent = CenterGroup
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Position = UDim2.new(0, 36, 0, 1)
Title.Size = UDim2.new(0, 85, 0, 11)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "CANDY CORN"
Title.TextColor3 = Color3.fromRGB(148, 163, 184)
Title.TextSize = 8.5
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = CenterGroup
local Count = Instance.new("TextLabel")
Count.Name = "Count"
Count.Position = UDim2.new(0, 36, 0, 13)
Count.Size = UDim2.new(0, 85, 0, 20)
Count.BackgroundTransparency = 1
Count.Font = Enum.Font.GothamBlack
Count.Text = "..."
Count.TextColor3 = Color3.fromRGB(251, 191, 36)
Count.TextSize = 18
Count.TextXAlignment = Enum.TextXAlignment.Left
Count.Parent = CenterGroup

K4HalloweenCandyHUD.Destroying:Connect(function()
	connection:Disconnect()
	connection3:Disconnect()
	tween:Cancel()
end)

local PlayerGui2 = Players.LocalPlayer:WaitForChild("PlayerGui")
K4HalloweenCandyHUD.Parent = PlayerGui2

task.spawn(function()
	local ItemReplicationService = ReplicatedStorage:FindFirstChild("ItemReplicationService")
	require(ItemReplicationService)
	task.wait(1)
	local ItemReplicationService2 = ReplicatedStorage:FindFirstChild("ItemReplicationService")
	require(ItemReplicationService2)
	task.wait(1)
end)

warn("[Duck Halloween] Loaded. Stop with getgenv().K4Halloween:Stop()")


