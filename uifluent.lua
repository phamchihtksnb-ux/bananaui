-- StarterPlayer > StarterPlayerScripts > MaruHubUI_Locked.client.lua
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Cam = workspace.CurrentCamera

local player = Players.LocalPlayer
if not player then return end
local playerGui = player:WaitForChild("PlayerGui")

-- ===== MÀU SẮC =====
local C = {
	bgMain    = Color3.fromRGB(8, 8, 10),     
	bgPanel   = Color3.fromRGB(14, 14, 18),   
	bgRow     = Color3.fromRGB(20, 20, 26),   
	border    = Color3.fromRGB(40, 40, 50),   
	text      = Color3.fromRGB(255, 255, 255),
	dim       = Color3.fromRGB(140, 140, 150),
	accent    = Color3.fromRGB(0, 255, 200),  
	toggleOff = Color3.fromRGB(50, 50, 60),   
	tabActiveBg = Color3.fromRGB(255, 255, 255), 
	tabActiveTx = Color3.fromRGB(0, 0, 0),       
	tabIdleBg   = Color3.fromRGB(20, 20, 26),    
	tabIdleTx   = Color3.fromRGB(150, 150, 165),
}

-- Kích thước khung
local vp = Cam.ViewportSize
local W = math.clamp(vp.X * 0.75, 350, 650) 
local H = math.clamp(vp.Y * 0.75, 280, 500)

-- Tạo GUI gốc
local gui = Instance.new("ScreenGui")
gui.Name = "MaruHubUI"
gui.ResetOnSpawn = false -- <<<< QUAN TRỌNG: Giữ UI khi chết/respawn
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- ===== KHUNG CHÍNH (CỐ ĐỊNH GIỮA) =====
local root = Instance.new("Frame")
root.Size = UDim2.fromOffset(W, H)
root.Position = UDim2.fromScale(0.5, 0.5) -- Tâm màn hình
root.AnchorPoint = Vector2.new(0.5, 0.5)  -- Khớp tâm frame với tâm position
root.BackgroundColor3 = C.bgMain
root.BorderSizePixel = 0
root.ZIndex = 10
root.Draggable = false -- <<<< QUAN TRỌNG: Khóa không cho kéo đi
root.Active = true     -- Cho phép click vào nền đen nhưng không xuyên qua game (tuỳ chọn)
root.Parent = gui

local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(0, 4); rc.Parent = root
local rs = Instance.new("UIStroke"); rs.Color = C.border; rs.Thickness = 1; rs.Parent = root

-- Helper Bo góc
local function deco(f, r)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 2); c.Parent = f
end

-- ===== HEADER (LOGO + TABS) =====
local header = Instance.new("Frame")
header.Size = UDim2.new(1, -20, 0, 40)
header.Position = UDim2.new(0, 10, 0, 10)
header.BackgroundTransparency = 1
header.ZIndex = 11
header.Parent = root

-- LOGO MARU
local logoBox = Instance.new("Frame")
logoBox.Size = UDim2.fromOffset(32, 32)
logoBox.Position = UDim2.new(0, 0, 0.5, -16)
logoBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
logoBox.BorderSizePixel = 0
logoBox.ZIndex = 12
logoBox.Parent = header
deco(logoBox, 2) 

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = C.accent
logoStroke.Thickness = 1
logoStroke.Transparency = 0
logoStroke.Parent = logoBox

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.fromScale(1, 1)
logoText.BackgroundTransparency = 1
logoText.Text = "M" 
logoText.TextColor3 = C.text
logoText.Font = Enum.Font.GothamBlack
logoText.TextSize = 16
logoText.ZIndex = 13
logoText.Parent = logoBox

-- CONTAINER CHO TABS
local tabsContainer = Instance.new("Frame")
tabsContainer.Size = UDim2.new(1, -38, 1, 0) 
tabsContainer.Position = UDim2.new(0, 38, 0, 0)
tabsContainer.BackgroundTransparency = 1
tabsContainer.ZIndex = 12
tabsContainer.Parent = header

local tl = Instance.new("UIListLayout")
tl.FillDirection = Enum.FillDirection.Horizontal
tl.HorizontalAlignment = Enum.HorizontalAlignment.Left
tl.VerticalAlignment = Enum.VerticalAlignment.Center
tl.Padding = UDim.new(0, 4)
tl.SortOrder = Enum.SortOrder.LayoutOrder
tl.Parent = tabsContainer

-- ===== BODY (KHUNG CHỨA NỘI DUNG) =====
local body = Instance.new("Frame")
body.Size = UDim2.new(1, -20, 1, -60)
body.Position = UDim2.new(0, 10, 0, 55)
body.BackgroundTransparency = 1
body.ZIndex = 11
body.Parent = root

local bl = Instance.new("UIListLayout")
bl.FillDirection = Enum.FillDirection.Horizontal
bl.VerticalAlignment = Enum.VerticalAlignment.Top
bl.Padding = UDim.new(0, 8)
bl.SortOrder = Enum.SortOrder.LayoutOrder
bl.Parent = body

-- Hàm tạo Column Left/Right
local function createColumn(order)
	local col = Instance.new("Frame")
	col.Size = UDim2.new(0.5, -4, 1, 0)
	col.BackgroundColor3 = C.bgPanel
	col.BorderSizePixel = 0
	col.LayoutOrder = order
	col.ZIndex = 12
	col.Parent = body
	deco(col, 4) 
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = C.border
	stroke.Thickness = 1
	stroke.Transparency = 0.5
	stroke.Parent = col
	
	local sc = Instance.new("ScrollingFrame")
	sc.Name = "ContentScroller"
	sc.Size = UDim2.new(1, -10, 1, -10)
	sc.Position = UDim2.new(0, 5, 0, 5)
	sc.BackgroundTransparency = 1
	sc.ScrollBarThickness = 2
	sc.ScrollBarImageColor3 = C.dim
	sc.CanvasSize = UDim2.new(0, 0, 0, 0)
	sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sc.ZIndex = 13
	sc.Parent = col
	
	local lay = Instance.new("UIListLayout")
	lay.SortOrder = Enum.SortOrder.LayoutOrder
	lay.Padding = UDim.new(0, 4)
	lay.Parent = sc
	
	return sc
end

local leftCol = createColumn(1)
local rightCol = createColumn(2)

-- Biến lưu trạng thái Order Counter cho từng cột
local orders = {[leftCol]=0, [rightCol]=0}
local function getOrder(p)
	orders[p] += 1
	return orders[p]
end

-- ==========================================
-- CÁC HÀM VẼ COMPONENT (AN TOÀN)
-- ==========================================

local function addSection(parent, text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 20)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = C.dim
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 10
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.LayoutOrder = getOrder(parent)
	lbl.ZIndex = 14
	lbl.Parent = parent
end

local function addToggle(parent, label, defaultState, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 30)
	row.BackgroundColor3 = C.bgRow
	row.BorderSizePixel = 0
	row.LayoutOrder = getOrder(parent)
	row.ZIndex = 14
	row.Parent = parent
	deco(row, 3)
	
	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1, -40, 1, 0)
	txt.Position = UDim2.new(0, 8, 0, 0)
	txt.BackgroundTransparency = 1
	txt.Text = label
	txt.TextColor3 = C.text
	txt.Font = Enum.Font.GothamMedium
	txt.TextSize = 12
	txt.TextXAlignment = Enum.TextXAlignment.Left
	txt.TextWrapped = true
	txt.ZIndex = 15
	txt.Parent = row
	
	local btnArea = Instance.new("Frame")
	btnArea.Size = UDim2.fromOffset(20, 20)
	btnArea.Position = UDim2.new(1, -28, 0.5, -10)
	btnArea.BackgroundTransparency = 1
	btnArea.ZIndex = 15
	btnArea.Parent = row
	
	local circleBtn = Instance.new("TextButton")
	circleBtn.Size = UDim2.fromScale(1, 1)
	circleBtn.BackgroundColor3 = defaultState and C.accent or C.toggleOff
	circleBtn.Text = ""
	circleBtn.AutoButtonColor = false
	circleBtn.ZIndex = 16
	circleBtn.Parent = btnArea
	deco(circleBtn, 999)
	
	local checkIcon = Instance.new("TextLabel")
	checkIcon.Size = UDim2.fromScale(1, 1)
	checkIcon.BackgroundTransparency = 1
	checkIcon.Text = "✓"
	checkIcon.TextColor3 = Color3.fromRGB(0, 0, 0)
	checkIcon.Font = Enum.Font.GothamBold
	checkIcon.TextSize = 12
	checkIcon.ZIndex = 17
	checkIcon.Visible = defaultState
	checkIcon.Parent = circleBtn
	
	local state = defaultState
	
	local function setState(newVal)
		state = newVal
		if state then
			TweenService:Create(circleBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.accent}):Play()
			checkIcon.Visible = true
		else
			TweenService:Create(circleBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.toggleOff}):Play()
			checkIcon.Visible = false
		end
		if callback then pcall(callback, state) end
	end
	
	circleBtn.MouseButton1Click:Connect(function()
		setState(not state)
	end)
	
	circleBtn.BackgroundColor3 = state and C.accent or C.toggleOff
	checkIcon.Visible = state
end

local function addDropdown(parent, label, options, startIndex, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 30)
	row.BackgroundColor3 = C.bgRow
	row.BorderSizePixel = 0
	row.LayoutOrder = getOrder(parent)
	row.ZIndex = 14
	row.Parent = parent
	deco(row, 3)
	
	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1, -70, 1, 0)
	txt.Position = UDim2.new(0, 8, 0, 0)
	txt.BackgroundTransparency = 1
	txt.Text = label
	txt.TextColor3 = C.dim
	txt.Font = Enum.Font.GothamMedium
	txt.TextSize = 11
	txt.TextXAlignment = Enum.TextXAlignment.Left
	txt.ZIndex = 15
	txt.Parent = row
	
	local valBtn = Instance.new("TextButton")
	valBtn.Size = UDim2.fromOffset(60, 20)
	valBtn.Position = UDim2.new(1, -68, 0.5, -10)
	valBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	valBtn.Text = options[startIndex] .. " ▼"
	valBtn.TextColor3 = C.text
	valBtn.Font = Enum.Font.GothamMedium
	valBtn.TextSize = 10
	valBtn.AutoButtonColor = true
	valBtn.ZIndex = 15
	valBtn.Parent = row
	deco(valBtn, 2)
	
	local list = Instance.new("Frame")
	list.Size = UDim2.fromOffset(60, #options * 18 + 4)
	list.Position = UDim2.new(1, -68, 1, 2) 
	list.BackgroundColor3 = C.bgMain
	list.BorderSizePixel = 0
	list.ZIndex = 50
	list.Visible = false
	list.Parent = row 
	deco(list, 2)
	local ls = Instance.new("UIStroke"); ls.Color = C.border; ls.Thickness=1; ls.Parent=list
	
	local ll = Instance.new("UIListLayout")
	ll.SortOrder = Enum.SortOrder.LayoutOrder
	ll.Padding = UDim.new(0, 1)
	ll.Parent = list
	
	local currentIdx = startIndex
	local isOpen = false
	
	local function refreshList()
		for _, c in ipairs(list:GetChildren()) do
			if c:IsA("TextButton") then c:Destroy() end
		end
		for i, opt in ipairs(options) do
			local item = Instance.new("TextButton")
			item.Size = UDim2.new(1, -2, 0, 16)
			item.BackgroundColor3 = (i == currentIdx) and C.accent or Color3.fromRGB(25,25,35)
			item.TextColor3 = (i == currentIdx) and Color3.new(0,0,0) or C.dim
			item.Text = opt
			item.Font = Enum.Font.GothamMedium
			item.TextSize = 10
			item.TextXAlignment = Enum.TextXAlignment.Left
			item.LayoutOrder = i
			item.ZIndex = 51
			item.Parent = list
			deco(item, 1)
			
			item.MouseButton1Click:Connect(function()
				currentIdx = i
				valBtn.Text = opt .. " ▼"
				isOpen = false
				list.Visible = false
				refreshList()
				if callback then pcall(callback, opt, i) end
			end)
		end
	end
	refreshList()
	
	valBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		list.Visible = isOpen
	end)
end

local function addStat(parent, text)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 26)
	row.BackgroundColor3 = C.bgRow
	row.BorderSizePixel = 0
	row.LayoutOrder = getOrder(parent)
	row.ZIndex = 14
	row.Parent = parent
	deco(row, 3)
	
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -16, 1, 0)
	lbl.Position = UDim2.new(0, 8, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = C.dim
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 15
	lbl.Parent = row
end

-- ==========================================
-- LOGIC CHUYỂN TAB & LOAD NỘI DUNG
-- ==========================================

local tabNames = {"General", "Farm", "Items", "Combat"}
local tabButtons = {}
local currentTabName = "General"

-- Xóa sạch nội dung cũ
local function clearColumns()
	for _, child in ipairs(leftCol:GetChildren()) do
		if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
			child:Destroy()
		end
	end
	for _, child in ipairs(rightCol:GetChildren()) do
		if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
			child:Destroy()
		end
	end
	orders[leftCol] = 0
	orders[rightCol] = 0
end

-- Hàm tải nội dung Tab
local function loadTabContent(tabName)
	clearColumns()
	currentTabName = tabName
	
	-- Cập nhật màu nút Tab
	for _, b in ipairs(tabButtons) do
		if b.Name == tabName then
			b.BackgroundColor3 = C.tabActiveBg
			b.TextColor3 = C.tabActiveTx
		else
			b.BackgroundColor3 = C.tabIdleBg
			b.TextColor3 = C.tabIdleTx
		end
	end

	---------------------------------------------------------
	-- 1. TAB GENERAL
	---------------------------------------------------------
	if tabName == "General" then
		addSection(leftCol, "HOME MENU")
		addToggle(leftCol, "Auto Farm Level", false, function(on) print("[Gen] AFK:", on) end)
		addToggle(leftCol, "Enable Dressrosa Quests", false, function(on) print("[Gen] Dressrosa:", on) end)
		
		addSection(rightCol, "SETTINGS")
		
		local timerLabel = Instance.new("TextLabel")
		timerLabel.Size = UDim2.new(1, 0, 0, 26)
		timerLabel.BackgroundColor3 = C.bgRow
		timerLabel.BorderSizePixel = 0
		timerLabel.Text = "00:00:00"
		timerLabel.TextColor3 = C.accent
		timerLabel.Font = Enum.Font.Code
		timerLabel.TextSize = 13
		timerLabel.TextXAlignment = Enum.TextXAlignment.Center
		timerLabel.LayoutOrder = getOrder(rightCol)
		timerLabel.ZIndex = 14
		timerLabel.Parent = rightCol
		deco(timerLabel, 3)
		
		task.spawn(function()
			local startT = os.clock()
			while currentTabName == "General" and timerLabel.Parent do
				task.wait(1)
				local s = math.floor(os.clock() - startT)
				timerLabel.Text = string.format("%02d:%02d:%02d", s//3600, (s%3600)//60, s%60)
			end
		end)

		addDropdown(rightCol, "Weapon Type", {"Melee", "Sword", "Gun", "Fruit"}, 1, function(v) print("[Gen] Weapon:", v) end)
		addToggle(rightCol, "Fast Attack", true, function(on) print("[Gen] FastAtk:", on) end)
		addToggle(rightCol, "Damage Text Off", false, function(on) print("[Gen] NoDmg:", on) end)
		
		addSection(rightCol, "STATS")
		addStat(rightCol, "Level: 1")
		addStat(rightCol, "Exp: 0 / 100")
		addStat(rightCol, "Kills: 0")

	---------------------------------------------------------
	-- 2. TAB FARM
	---------------------------------------------------------
	elseif tabName == "Farm" then
		addSection(leftCol, "AUTO FARM SETTINGS")
		addToggle(leftCol, "Enable Auto Farm", false, function(on) print("[Farm] Enable:", on) end)
		addToggle(leftCol, "Use Fruit Skills", true, function(on) print("[Farm] UseSkills:", on) end)
		addToggle(leftCol, "Use Sword Skills", false, function(on) print("[Farm] UseSword:", on) end)
		
		addSection(rightCol, "TARGET SELECTION")
		addDropdown(rightCol, "Mob Target", {"Bandits", "Monkeys", "Gorillas", "Pirates"}, 1, function(v) print("[Farm] Mob:", v) end)
		addDropdown(rightCol, "Location", {"Pirate Village", "Marine Fortress", "Jungle"}, 1, function(v) print("[Farm Loc]:", v) end)
		
		addSection(rightCol, "PROTECTION")
		addToggle(rightCol, "Anti-AFK", true, function(on) print("[Farm] AntiAFK:", on) end)
		addToggle(rightCol, "Auto Heal", false, function(on) print("[Farm] Heal:", on) end)

	---------------------------------------------------------
	-- 3. TAB ITEMS
	---------------------------------------------------------
	elseif tabName == "Items" then
		addSection(leftCol, "INVENTORY QUICK USE")
		addToggle(leftCol, "Auto Eat Donuts", false, function(on) print("[Items] Donuts:", on) end)
		addToggle(leftCol, "Auto Buy Potions", false, function(on) print("[Items] Potions:", on) end)
		
		addSection(rightCol, "FRUIT MANAGEMENT")
		addDropdown(rightCol, "Selected Fruit Slot", {"Slot 1", "Slot 2", "Slot 3"}, 1, function(v) print("[Items] Slot:", v) end)
		addToggle(rightCol, "Drop Unwanted Fruits", false, function(on) print("[Items] Drop:", on) end)
		
		addSection(rightCol, "SELL OPTIONS")
		addToggle(rightCol, "Sell Common Materials", false, function(on) print("[Items] SellMat:", on) end)
		addToggle(rightCol, "Sell Rare Materials", false, function(on) print("[Items] SellRare:", on) end)

	---------------------------------------------------------
	-- 4. TAB COMBAT
	---------------------------------------------------------
	elseif tabName == "Combat" then
		addSection(leftCol, "COMBAT MODE")
		addToggle(leftCol, "God Mode (Test Only)", false, function(on) print("[Combat] GodMode:", on) end)
		addToggle(leftCol, "One Hit Kill (Test Only)", false, function(on) print("[Combat] OHK:", on) end)
		
		addSection(rightCol, "AIMBOT / ESP")
		addToggle(rightCol, "Enable Aimbot", false, function(on) print("[Combat] Aimbot:", on) end)
		addToggle(rightCol, "Show Enemy HP Bar", true, function(on) print("[Combat] ShowHP:", on) end)
		addToggle(rightCol, "Highlight Bosses", false, function(on) print("[Combat] Highlight:", on) end)
		
		addSection(rightCol, "SKILLS CONFIG")
        addDropdown(rightCol, "Priority Skill", {"Z", "X", "C", "V"}, 1, function(v) print("[Combat] Priority:", v) end)
	end
end

-- Tạo các nút Tab
for i, name in ipairs(tabNames) do
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.fromOffset(70, 24)
	btn.BackgroundColor3 = (name == "General") and C.tabActiveBg or C.tabIdleBg
	btn.TextColor3 = (name == "General") and C.tabActiveTx or C.tabIdleTx
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.AutoButtonColor = false
	btn.LayoutOrder = i
	btn.ZIndex = 13
	btn.Parent = tabsContainer
	deco(btn, 2)
	
	table.insert(tabButtons, btn)
	
	btn.MouseButton1Click:Connect(function()
		loadTabContent(name)
	end)
end

-- Load tab đầu tiên
loadTabContent("General")

print("[MaruHub] UI Loaded & Locked.")
