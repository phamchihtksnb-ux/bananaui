--[[
    Duck Hub UI  (giao dien giong anh mau)
    - Thanh tab ngang: Farming / Race V4 / Hop / Fishing / Quest & Item / Teleport / Shop / Setting
    - Panel ben phai: tu dong lay thong tin tai khoan + avatar 3D mac dung do dang mac + FPS
    - 3 nut: Thong tin (xem thong tin acc), Cai dat, Giao dien (doi mau)
    - Keo thanh tieu de de di chuyen, nut thu nho / phong to / dong, LeftControl de an/hien
    Cach noi chuc nang cua ban: xem phan "NOI CHUC NANG" o cuoi file.
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

------------------------------------------------------------------ THEME
local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end
local THEMES = {
	Mono = { bg = rgb(10, 10, 10), panel = rgb(18, 18, 18), card = rgb(26, 26, 26), line = rgb(44, 44, 44), text = rgb(245, 245, 245), mut = rgb(140, 140, 140), on = rgb(214, 214, 214), off = rgb(56, 56, 56), knobOn = rgb(40, 40, 40), knobOff = rgb(200, 200, 200), btnText = rgb(16, 16, 16) },
	Graphite = { bg = rgb(16, 16, 16), panel = rgb(22, 22, 22), card = rgb(30, 30, 30), line = rgb(46, 46, 46), text = rgb(244, 244, 244), mut = rgb(140, 140, 140), on = rgb(255, 159, 67), off = rgb(58, 58, 58), knobOn = rgb(20, 20, 20), knobOff = rgb(200, 200, 200), btnText = rgb(20, 20, 20) },
	Midnight = { bg = rgb(13, 14, 20), panel = rgb(18, 20, 28), card = rgb(24, 27, 36), line = rgb(38, 42, 58), text = rgb(236, 238, 245), mut = rgb(134, 140, 160), on = rgb(124, 140, 255), off = rgb(48, 52, 70), knobOn = rgb(15, 16, 24), knobOff = rgb(190, 194, 210), btnText = rgb(10, 10, 18) },
	Crimson = { bg = rgb(14, 10, 11), panel = rgb(20, 15, 16), card = rgb(28, 20, 21), line = rgb(46, 32, 35), text = rgb(246, 234, 236), mut = rgb(154, 132, 136), on = rgb(255, 77, 94), off = rgb(60, 42, 45), knobOn = rgb(20, 10, 12), knobOff = rgb(210, 190, 194), btnText = rgb(20, 8, 10) },
	Ocean = { bg = rgb(9, 16, 18), panel = rgb(13, 23, 26), card = rgb(18, 33, 39), line = rgb(29, 48, 55), text = rgb(232, 244, 246), mut = rgb(125, 152, 160), on = rgb(39, 211, 230), off = rgb(36, 58, 66), knobOn = rgb(8, 18, 20), knobOff = rgb(190, 214, 220), btnText = rgb(6, 18, 20) },
}
local T = THEMES.Mono
local reg, hooks = {}, {}

local function bind(inst, prop, key)
	inst[prop] = T[key]
	reg[#reg + 1] = { inst, prop, key }
end
local function setTheme(name)
	if not THEMES[name] then return end
	T = THEMES[name]
	for _, e in ipairs(reg) do
		if e[1] and e[1].Parent then e[1][e[2]] = T[e[3]] end
	end
	for _, f in ipairs(hooks) do pcall(f) end
end

------------------------------------------------------------------ HELPERS
local function new(class, props, kids)
	local o = Instance.new(class)
	local parent
	for k, v in pairs(props or {}) do
		if k == "Parent" then parent = v else o[k] = v end
	end
	for _, c in ipairs(kids or {}) do c.Parent = o end
	if parent then o.Parent = parent end
	return o
end
local function corner(r) return new("UICorner", { CornerRadius = UDim.new(0, r) }) end
local function stroke(key, th)
	local s = new("UIStroke", { Thickness = th or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
	bind(s, "Color", key)
	return s
end
local function pad(l, t, r, b)
	return new("UIPadding", { PaddingLeft = UDim.new(0, l), PaddingTop = UDim.new(0, t), PaddingRight = UDim.new(0, r), PaddingBottom = UDim.new(0, b) })
end
local function label(parent, text, size, font, colorKey, pos, sz, xAlign)
	local l = new("TextLabel", {
		Parent = parent, BackgroundTransparency = 1, Text = text, TextSize = size, Font = font,
		Position = pos or UDim2.new(), Size = sz or UDim2.new(1, 0, 0, size + 2),
		TextXAlignment = xAlign or Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
	})
	bind(l, "TextColor3", colorKey)
	return l
end
local function isPress(i)
	return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end
local function isMove(i)
	return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch
end
local function makeDraggable(handle, target)
	local dragging, startPos, origin
	handle.InputBegan:Connect(function(i)
		if isPress(i) then
			dragging, startPos, origin = true, i.Position, target.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and isMove(i) then
			local d = i.Position - startPos
			target.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
		end
	end)
end

------------------------------------------------------------------ GUI ROOT
local parentGui = (function()
	if gethui then
		local ok, h = pcall(gethui)
		if ok and h then return h end
	end
	local ok = pcall(function() return CoreGui.Name end)
	if ok then return CoreGui end
	return lp:WaitForChild("PlayerGui")
end)()
for _, n in ipairs({ "DuckHubUI" }) do
	local old = parentGui:FindFirstChild(n)
	if old then old:Destroy() end
end

local gui = new("ScreenGui", { Name = "DuckHubUI", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 200, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
gui.Parent = parentGui

local holder = new("Frame", { Parent = gui, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 0, 0, 0) })
local main = new("Frame", { Parent = holder, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(), Size = UDim2.new(0, 720, 0, 410), ClipsDescendants = false }, { corner(16), stroke("line", 1) })
bind(main, "BackgroundColor3", "bg")
local uiScale = new("UIScale", { Parent = main })

local userMul, baseScale = 1, 1
local function applyScale() uiScale.Scale = baseScale * userMul end
local function fitScale()
	local cam = workspace.CurrentCamera
	if not cam then return end
	local v = cam.ViewportSize
	baseScale = math.clamp(math.min(v.X / 760, v.Y / 450), 0.45, 1)
	applyScale()
end
fitScale()
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitScale) end

------------------------------------------------------------------ TOP BAR
local topbar = new("Frame", { Parent = main, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 46) })
makeDraggable(topbar, holder)

local logo = new("Frame", { Parent = topbar, Position = UDim2.new(0, 14, 0, 9), Size = UDim2.new(0, 28, 0, 28) }, { corner(9) })
bind(logo, "BackgroundColor3", "on")
local logoTxt = label(logo, "D", 15, Enum.Font.GothamBold, "btnText", UDim2.new(), UDim2.new(1, 0, 1, 0), Enum.TextXAlignment.Center)
label(topbar, "Duck Hub", 14, Enum.Font.GothamBold, "text", UDim2.new(0, 50, 0, 7), UDim2.new(0, 90, 0, 16))
label(topbar, "More themes", 10, Enum.Font.Gotham, "mut", UDim2.new(0, 50, 0, 24), UDim2.new(0, 90, 0, 12))

local tabStrip = new("ScrollingFrame", {
	Parent = topbar, BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0, 150, 0, 0), Size = UDim2.new(1, -150 - 112, 1, 0),
	ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.X, ScrollingDirection = Enum.ScrollingDirection.X,
})
new("UIListLayout", { Parent = tabStrip, FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })

local function ctrlBtn(text, x)
	local b = new("TextButton", {
		Parent = topbar, AutoButtonColor = false, Text = text, Font = Enum.Font.GothamBold, TextSize = 13,
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, x, 0, 10), Size = UDim2.new(0, 26, 0, 26),
	}, { corner(8) })
	bind(b, "BackgroundColor3", "card")
	bind(b, "TextColor3", "mut")
	return b
end
local btnClose = ctrlBtn("✕", -10)
local btnMax = ctrlBtn("□", -40)
local btnMin = ctrlBtn("—", -70)

local sep = new("Frame", { Parent = main, Position = UDim2.new(0, 0, 0, 46), Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0 })
bind(sep, "BackgroundColor3", "line")

local body = new("Frame", { Parent = main, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 47), Size = UDim2.new(1, 0, 1, -47) })
local pagesHolder = new("Frame", { Parent = body, BackgroundTransparency = 1, Position = UDim2.new(0, 14, 0, 10), Size = UDim2.new(1, -14 - 250, 1, -20) })

------------------------------------------------------------------ FLAGS / TABS
local Flags = getgenv().DuckFlags or {}
getgenv().DuckFlags = Flags

local tabs, activeTab = {}, nil
local function selectTab(t)
	for _, x in ipairs(tabs) do
		local on = (x == t)
		x.page.Visible = on
		x.under.Visible = on
		x.btn.TextColor3 = on and T.text or T.mut
		x.active = on
	end
	activeTab = t
end
hooks[#hooks + 1] = function() if activeTab then selectTab(activeTab) end end

local function seaNumber()
	local id = game.PlaceId
	if id == 2753915549 or id == 85211729168715 then return 1 end
	if id == 4442272183 or id == 79091703265657 then return 2 end
	if id == 7449423635 or id == 100117331123089 then return 3 end
	return 0
end

local function makeTab(name, title)
	local tab = { name = name, active = false }
	local w = TextService:GetTextSize(name, 13, Enum.Font.GothamMedium, Vector2.new(1000, 30)).X + 22
	local btn = new("TextButton", {
		Parent = tabStrip, AutoButtonColor = false, BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamMedium, TextSize = 13,
		Size = UDim2.new(0, w, 0, 32), LayoutOrder = #tabs + 1,
	})
	bind(btn, "TextColor3", "mut")
	local under = new("Frame", { Parent = btn, AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, 0), Size = UDim2.new(1, -16, 0, 2), BorderSizePixel = 0, Visible = false }, { corner(2) })
	bind(under, "BackgroundColor3", "on")
	tab.btn, tab.under = btn, under

	local page = new("Frame", { Parent = pagesHolder, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false })
	tab.page = page
	label(page, title or name, 20, Enum.Font.GothamBold, "text", UDim2.new(0, 2, 0, 0), UDim2.new(0.5, 0, 0, 30))
	local chip = new("Frame", { Parent = page, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 3), Size = UDim2.new(0, 150, 0, 24) }, { corner(12), stroke("line", 1) })
	bind(chip, "BackgroundColor3", "card")
	local dot = new("Frame", { Parent = chip, Position = UDim2.new(0, 10, 0.5, -3), Size = UDim2.new(0, 6, 0, 6) }, { corner(3) })
	bind(dot, "BackgroundColor3", "on")
	local chipTxt = label(chip, "", 11, Enum.Font.Gotham, "mut", UDim2.new(0, 22, 0, 0), UDim2.new(1, -28, 1, 0))
	tab.chipTxt = chipTxt

	local scroll = new("ScrollingFrame", {
		Parent = page, BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 38), Size = UDim2.new(1, 0, 1, -38),
		ScrollBarThickness = 3, ScrollBarImageColor3 = T.line, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
	})
	new("UIListLayout", { Parent = scroll, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })
	new("UIPadding", { Parent = scroll, PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6) })
	local order = 0
	local function nextOrder() order = order + 1 return order end

	btn.MouseButton1Click:Connect(function() selectTab(tab) end)
	tabs[#tabs + 1] = tab

	local function card(h)
		local f = new("Frame", { Parent = scroll, Size = UDim2.new(1, 0, 0, h), LayoutOrder = nextOrder() }, { corner(10), stroke("line", 1) })
		bind(f, "BackgroundColor3", "card")
		return f
	end

	function tab:AddSection(text)
		local l = label(scroll, string.upper(text), 11, Enum.Font.GothamBold, "mut", nil, UDim2.new(1, 0, 0, 16))
		l.LayoutOrder = nextOrder()
		return l
	end

	function tab:AddLabel(text)
		local f = card(34)
		local l = label(f, text, 12, Enum.Font.Gotham, "mut", UDim2.new(0, 14, 0, 0), UDim2.new(1, -28, 1, 0))
		return { Set = function(_, t) l.Text = tostring(t) end }
	end

	function tab:AddToggle(o)
		local f = card(o.Desc and 46 or 38)
		label(f, o.Name, 13, Enum.Font.GothamMedium, "text", UDim2.new(0, 14, 0, o.Desc and 7 or 0), UDim2.new(1, -80, 0, o.Desc and 16 or 38))
		if o.Desc then label(f, o.Desc, 11, Enum.Font.Gotham, "mut", UDim2.new(0, 14, 0, 24), UDim2.new(1, -80, 0, 14)) end
		local pill = new("TextButton", { Parent = f, AutoButtonColor = false, Text = "", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.new(0, 40, 0, 22) }, { corner(11) })
		local knob = new("Frame", { Parent = pill, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.new(0, 16, 0, 16) }, { corner(8) })
		local state = o.Default == true
		local function visual(anim)
			local ti = TweenInfo.new(anim and 0.15 or 0)
			TS:Create(pill, ti, { BackgroundColor3 = state and T.on or T.off }):Play()
			TS:Create(knob, ti, { Position = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = state and T.knobOn or T.knobOff }):Play()
		end
		visual(false)
		hooks[#hooks + 1] = function() visual(false) end
		local obj = {}
		local function set(v, silent)
			state = v and true or false
			if o.Flag then Flags[o.Flag] = state end
			visual(true)
			if not silent and o.Callback then task.spawn(o.Callback, state) end
		end
		pill.MouseButton1Click:Connect(function() set(not state) end)
		if o.Flag then Flags[o.Flag] = state end
		if state and o.Callback then task.defer(o.Callback, state) end
		function obj:Set(v) set(v) end
		function obj:Get() return state end
		return obj
	end

	function tab:AddSlider(o)
		local f = card(54)
		label(f, o.Name, 13, Enum.Font.GothamMedium, "text", UDim2.new(0, 14, 0, 8), UDim2.new(0.6, 0, 0, 16))
		local val = label(f, "", 12, Enum.Font.Gotham, "mut", UDim2.new(1, -14, 0, 8), UDim2.new(0.4, 0, 0, 16), Enum.TextXAlignment.Right)
		val.AnchorPoint = Vector2.new(1, 0)
		local track = new("TextButton", { Parent = f, AutoButtonColor = false, Text = "", Position = UDim2.new(0, 14, 0, 36), Size = UDim2.new(1, -28, 0, 6) }, { corner(3) })
		bind(track, "BackgroundColor3", "off")
		local fill = new("Frame", { Parent = track, Size = UDim2.new(0, 0, 1, 0), BorderSizePixel = 0 }, { corner(3) })
		bind(fill, "BackgroundColor3", "on")
		local knob = new("Frame", { Parent = track, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 0, 0.5, 0) }, { corner(6) })
		bind(knob, "BackgroundColor3", "text")
		local min, max, suffix = o.Min or 0, o.Max or 100, o.Suffix or ""
		local value = math.clamp(o.Default or min, min, max)
		local function render()
			local r = (value - min) / math.max(max - min, 1e-6)
			fill.Size = UDim2.new(r, 0, 1, 0)
			knob.Position = UDim2.new(r, 0, 0.5, 0)
			val.Text = tostring(value) .. (suffix ~= "" and (" " .. suffix) or "")
		end
		local function set(v, silent)
			v = math.clamp(math.floor(v + 0.5), min, max)
			if v == value and not silent then return end
			value = v
			if o.Flag then Flags[o.Flag] = value end
			render()
			if not silent and o.Callback then task.spawn(o.Callback, value) end
		end
		local dragging = false
		local function fromX(x)
			local r = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
			set(min + (max - min) * r)
		end
		track.InputBegan:Connect(function(i) if isPress(i) then dragging = true fromX(i.Position.X) end end)
		UIS.InputChanged:Connect(function(i) if dragging and isMove(i) then fromX(i.Position.X) end end)
		UIS.InputEnded:Connect(function(i) if isPress(i) then dragging = false end end)
		render()
		if o.Flag then Flags[o.Flag] = value end
		if o.Callback then task.defer(o.Callback, value) end
		return { Set = function(_, v) set(v) end, Get = function() return value end }
	end

	function tab:AddButtons(list)
		local row = new("Frame", { Parent = scroll, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), LayoutOrder = nextOrder() })
		new("UIListLayout", { Parent = row, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })
		local n = #list
		for i, b in ipairs(list) do
			local btn = new("TextButton", {
				Parent = row, AutoButtonColor = false, Text = b.Name, Font = Enum.Font.GothamBold, TextSize = 13, LayoutOrder = i,
				Size = UDim2.new(b.Wide or (1 / n), -(8 * (n - 1) / n), 1, 0),
			}, { corner(10) })
			local function paint()
				if b.Primary then
					btn.BackgroundColor3, btn.TextColor3 = T.on, T.btnText
				else
					btn.BackgroundColor3, btn.TextColor3 = T.card, T.text
				end
			end
			paint()
			hooks[#hooks + 1] = paint
			if not b.Primary then stroke("line", 1).Parent = btn end
			btn.MouseButton1Click:Connect(function()
				TS:Create(btn, TweenInfo.new(0.08), { BackgroundTransparency = 0.25 }):Play()
				task.delay(0.1, function() TS:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0 }):Play() end)
				if b.Callback then task.spawn(b.Callback) end
			end)
		end
	end

	function tab:AddButton(o) return tab:AddButtons({ o }) end

	function tab:AddDropdown(o)
		local opts = o.Options or {}
		local current = o.Default or opts[1]
		local f = card(40)
		f.ClipsDescendants = true
		label(f, o.Name, 13, Enum.Font.GothamMedium, "text", UDim2.new(0, 14, 0, 0), UDim2.new(0.5, 0, 0, 40))
		local head = new("TextButton", { Parent = f, AutoButtonColor = false, BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 0, 40) })
		local cur = label(head, "", 12, Enum.Font.GothamMedium, "on", UDim2.new(1, -14, 0, 0), UDim2.new(0.5, 0, 1, 0), Enum.TextXAlignment.Right)
		cur.AnchorPoint = Vector2.new(1, 0)
		local list = new("Frame", { Parent = f, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 42), Size = UDim2.new(1, -16, 0, #opts * 28) })
		new("UIListLayout", { Parent = list, Padding = UDim.new(0, 2) })
		local open = false
		local function refresh() cur.Text = tostring(current) .. (open and " ▴" or " ▾") end
		for _, op in ipairs(opts) do
			local b = new("TextButton", { Parent = list, AutoButtonColor = false, BackgroundTransparency = 1, Text = tostring(op), Font = Enum.Font.Gotham, TextSize = 12, Size = UDim2.new(1, 0, 0, 26) }, { corner(6) })
			bind(b, "TextColor3", "text")
			b.MouseButton1Click:Connect(function()
				current = op
				if o.Flag then Flags[o.Flag] = current end
				open = false
				TS:Create(f, TweenInfo.new(0.15), { Size = UDim2.new(1, 0, 0, 40) }):Play()
				refresh()
				if o.Callback then task.spawn(o.Callback, current) end
			end)
		end
		head.MouseButton1Click:Connect(function()
			open = not open
			TS:Create(f, TweenInfo.new(0.15), { Size = UDim2.new(1, 0, 0, open and (46 + #opts * 28) or 40) }):Play()
			refresh()
		end)
		refresh()
		if o.Flag then Flags[o.Flag] = current end
		if current and o.Callback then task.defer(o.Callback, current) end
		return { Get = function() return current end }
	end

	return tab
end

------------------------------------------------------------------ RIGHT PANEL (thong tin tai khoan)
local side = new("Frame", { Parent = body, Position = UDim2.new(1, -240, 0, 10), Size = UDim2.new(0, 226, 1, -20) }, { corner(14), stroke("line", 1) })
bind(side, "BackgroundColor3", "panel")

label(side, "Người dùng:", 10, Enum.Font.Gotham, "mut", UDim2.new(0, 14, 0, 10), UDim2.new(1, -28, 0, 12))
local nameLbl = label(side, lp.DisplayName, 14, Enum.Font.GothamBold, "text", UDim2.new(0, 14, 0, 23), UDim2.new(1, -50, 0, 18))
local star = label(side, "★", 12, Enum.Font.GothamBold, "on", UDim2.new(0, 14, 0, 23), UDim2.new(0, 14, 0, 18))
local function placeStar()
	local w = TextService:GetTextSize(nameLbl.Text, 14, Enum.Font.GothamBold, Vector2.new(400, 20)).X
	star.Position = UDim2.new(0, 14 + w + 5, 0, 23)
end
placeStar()
label(side, "Script: ", 10, Enum.Font.Gotham, "mut", UDim2.new(0, 14, 0, 43), UDim2.new(0, 36, 0, 12))
label(side, "Duck Hub", 10, Enum.Font.GothamBold, "text", UDim2.new(0, 48, 0, 43), UDim2.new(1, -60, 0, 12))

-- avatar
local avatarBox = new("Frame", { Parent = side, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 60), Size = UDim2.new(1, -20, 0, 188), ClipsDescendants = true })
local glow1 = new("Frame", { Parent = avatarBox, AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -4), Size = UDim2.new(0, 150, 0, 22), BackgroundTransparency = 0.8 }, { corner(11) })
bind(glow1, "BackgroundColor3", "on")
local glow2 = new("Frame", { Parent = avatarBox, AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -8), Size = UDim2.new(0, 96, 0, 12), BackgroundTransparency = 0.6 }, { corner(6) })
bind(glow2, "BackgroundColor3", "on")
local thumb = new("ImageLabel", { Parent = avatarBox, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 0), Size = UDim2.new(0, 170, 0, 170), ScaleType = Enum.ScaleType.Fit })
task.spawn(function()
	local ok, img = pcall(function()
		return Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.AvatarThumbnail, Enum.ThumbnailSize.Size420x420)
	end)
	if ok then thumb.Image = img end
end)
local vp = new("ViewportFrame", { Parent = avatarBox, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Ambient = rgb(185, 185, 185), LightColor = rgb(255, 255, 255), LightDirection = Vector3.new(-0.6, -0.8, -0.7), Visible = false })

local avatarModel, avatarAngle = nil, 160
local function buildAvatar()
	local ok = pcall(function()
		local char = lp.Character or lp.CharacterAdded:Wait()
		char:WaitForChild("HumanoidRootPart", 5)
		char.Archivable = true
		local clone = char:Clone()
		if not clone then error("no clone") end
		if avatarModel then avatarModel:Destroy() end
		for _, d in ipairs(clone:GetDescendants()) do
			if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Tool") or d:IsA("BillboardGui") or d:IsA("Sound") or d:IsA("ForceField") then
				d:Destroy()
			elseif d:IsA("BasePart") then
				d.Anchored = true
			end
		end
		local hum = clone:FindFirstChildOfClass("Humanoid")
		if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
		clone:PivotTo(CFrame.new(0, 0, 0))
		clone.Parent = vp
		avatarModel = clone
		local cam = vp.CurrentCamera
		if not cam then
			cam = new("Camera", { Parent = vp })
			vp.CurrentCamera = cam
		end
		local cf, size = clone:GetBoundingBox()
		local h = math.max(size.Y, 5)
		cam.FieldOfView = 38
		cam.CFrame = CFrame.lookAt(cf.Position + Vector3.new(0, h * 0.05, h * 1.9), cf.Position + Vector3.new(0, h * 0.02, 0))
		vp.Visible = true
		thumb.Visible = false
	end)
	if not ok then vp.Visible = false thumb.Visible = true end
end
task.spawn(buildAvatar)
lp.CharacterAdded:Connect(function() task.wait(1.5) buildAvatar() end)
RS.RenderStepped:Connect(function(dt)
	if avatarModel and avatarModel.Parent and gui.Parent and holder.Visible then
		avatarAngle = (avatarAngle + dt * 40) % 360
		pcall(function() avatarModel:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(avatarAngle), 0)) end)
	end
end)

-- FPS
local fpsRow = new("Frame", { Parent = side, BackgroundTransparency = 1, Position = UDim2.new(0, 14, 0, 252), Size = UDim2.new(1, -28, 0, 30) })
label(fpsRow, "⏱", 18, Enum.Font.GothamBold, "mut", UDim2.new(), UDim2.new(0, 24, 1, 0))
label(fpsRow, "FPS:", 9, Enum.Font.Gotham, "mut", UDim2.new(0, 30, 0, 2), UDim2.new(0, 50, 0, 11))
local fpsLbl = label(fpsRow, "-- FPS", 15, Enum.Font.GothamBold, "text", UDim2.new(0, 30, 0, 12), UDim2.new(0, 100, 0, 18))
local fpsDot = new("Frame", { Parent = fpsRow, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 7, 0, 7), BackgroundColor3 = rgb(70, 220, 110) }, { corner(4) })
do
	local frames, last = 0, os.clock()
	RS.RenderStepped:Connect(function()
		frames = frames + 1
		local now = os.clock()
		if now - last >= 0.5 then
			local fps = math.floor(frames / (now - last) + 0.5)
			frames, last = 0, now
			fpsLbl.Text = fps .. " FPS"
			fpsDot.BackgroundColor3 = fps >= 45 and rgb(70, 220, 110) or (fps >= 25 and rgb(240, 190, 60) or rgb(240, 80, 80))
		end
	end)
end

------------------------------------------------------------------ POPUPS
local overlay = new("TextButton", { Parent = main, AutoButtonColor = false, Text = "", BackgroundColor3 = rgb(0, 0, 0), BackgroundTransparency = 0.45, Size = UDim2.new(1, 0, 1, 0), Visible = false, ZIndex = 40 }, { corner(16) })
local popup = new("Frame", { Parent = overlay, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 380, 0, 300), ZIndex = 41, Active = true }, { corner(14), stroke("line", 1) })
bind(popup, "BackgroundColor3", "panel")
local popTitle = label(popup, "", 16, Enum.Font.GothamBold, "text", UDim2.new(0, 16, 0, 12), UDim2.new(1, -60, 0, 22))
popTitle.ZIndex = 42
local popClose = new("TextButton", { Parent = popup, AutoButtonColor = false, Text = "✕", Font = Enum.Font.GothamBold, TextSize = 13, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 10), Size = UDim2.new(0, 26, 0, 26), ZIndex = 42 }, { corner(8) })
bind(popClose, "BackgroundColor3", "card")
bind(popClose, "TextColor3", "mut")
local popBody = new("ScrollingFrame", { Parent = popup, BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0, 14, 0, 46), Size = UDim2.new(1, -28, 1, -58), ScrollBarThickness = 3, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 42 })
new("UIListLayout", { Parent = popBody, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })
local popTick
local function closePopup() overlay.Visible = false popTick = nil end
popClose.MouseButton1Click:Connect(closePopup)
overlay.MouseButton1Click:Connect(closePopup)

local function clearPop()
	for _, c in ipairs(popBody:GetChildren()) do
		if not c:IsA("UIListLayout") then c:Destroy() end
	end
end
local function popRow(k, order)
	local r = new("Frame", { Parent = popBody, Size = UDim2.new(1, 0, 0, 30), LayoutOrder = order, ZIndex = 43 }, { corner(8) })
	bind(r, "BackgroundColor3", "card")
	local a = label(r, k, 12, Enum.Font.Gotham, "mut", UDim2.new(0, 12, 0, 0), UDim2.new(0.45, 0, 1, 0))
	local b = label(r, "", 12, Enum.Font.GothamMedium, "text", UDim2.new(1, -12, 0, 0), UDim2.new(0.55, 0, 1, 0), Enum.TextXAlignment.Right)
	b.AnchorPoint = Vector2.new(1, 0)
	a.ZIndex, b.ZIndex = 44, 44
	return b
end

-- doc du lieu tai khoan
local function dataVal(name)
	local d = lp:FindFirstChild("Data")
	local o = d and d:FindFirstChild(name)
	return o and o.Value
end
local function fmt(n)
	if type(n) ~= "number" then return tostring(n or "?") end
	local s = tostring(math.floor(n))
	return (s:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end
local function getInfo()
	local bounty
	pcall(function()
		local ls = lp:FindFirstChild("leaderstats")
		local b = ls and (ls:FindFirstChild("Bounty/Honor") or ls:FindFirstChild("Bounty"))
		bounty = b and b.Value
	end)
	local ping
	pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5) end)
	local sea = seaNumber()
	return {
		{ "Tên hiển thị", lp.DisplayName },
		{ "Username", "@" .. lp.Name },
		{ "User ID", tostring(lp.UserId) },
		{ "Tuổi tài khoản", lp.AccountAge .. " ngày" },
		{ "Sea", sea > 0 and ("Sea " .. sea) or "Không rõ" },
		{ "Level", fmt(dataVal("Level")) },
		{ "Beli", fmt(dataVal("Beli")) },
		{ "Fragments", fmt(dataVal("Fragments")) },
		{ "Bounty / Honor", fmt(bounty) },
		{ "Race", tostring(dataVal("Race") or "?") },
		{ "Trái ác quỷ", tostring(dataVal("DevilFruit") or "Không có") },
		{ "Ping", ping and (ping .. " ms") or "?" },
		{ "Người chơi trong server", #Players:GetPlayers() .. "/" .. Players.MaxPlayers },
		{ "Job ID", string.sub(game.JobId, 1, 13) .. (#game.JobId > 13 and "…" or "") },
	}
end

local function openInfo()
	clearPop()
	popTitle.Text = "Thông tin tài khoản"
	local cells = {}
	for i, row in ipairs(getInfo()) do cells[i] = popRow(row[1], i) end
	local function refresh()
		for i, row in ipairs(getInfo()) do if cells[i] then cells[i].Text = tostring(row[2]) end end
	end
	refresh()
	overlay.Visible = true
	local my = {}
	popTick = my
	task.spawn(function()
		while popTick == my and overlay.Visible do
			task.wait(1)
			pcall(refresh)
		end
	end)
end

local fpsToggleObj
local function openSettings()
	clearPop()
	popTitle.Text = "Cài đặt"
	-- cai dat don gian dung lai controls
	local function pRow(h)
		local r = new("Frame", { Parent = popBody, Size = UDim2.new(1, 0, 0, h), ZIndex = 43 }, { corner(8) })
		bind(r, "BackgroundColor3", "card")
		return r
	end
	-- hien FPS
	local r1 = pRow(38)
	label(r1, "Hiện FPS", 13, Enum.Font.GothamMedium, "text", UDim2.new(0, 12, 0, 0), UDim2.new(0.6, 0, 1, 0)).ZIndex = 44
	local pill = new("TextButton", { Parent = r1, AutoButtonColor = false, Text = "", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0, 40, 0, 22), ZIndex = 44 }, { corner(11) })
	local knob = new("Frame", { Parent = pill, AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(0, 16, 0, 16), ZIndex = 45 }, { corner(8) })
	local function vis()
		local on = fpsRow.Visible
		pill.BackgroundColor3 = on and T.on or T.off
		knob.Position = on and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
		knob.BackgroundColor3 = on and T.knobOn or T.knobOff
	end
	vis()
	pill.MouseButton1Click:Connect(function() fpsRow.Visible = not fpsRow.Visible vis() end)
	-- kich thuoc UI
	local r2 = pRow(54)
	label(r2, "Kích thước UI", 13, Enum.Font.GothamMedium, "text", UDim2.new(0, 12, 0, 8), UDim2.new(0.6, 0, 0, 16)).ZIndex = 44
	local v = label(r2, math.floor(userMul * 100) .. "%", 12, Enum.Font.Gotham, "mut", UDim2.new(1, -12, 0, 8), UDim2.new(0.4, 0, 0, 16), Enum.TextXAlignment.Right)
	v.AnchorPoint, v.ZIndex = Vector2.new(1, 0), 44
	local track = new("TextButton", { Parent = r2, AutoButtonColor = false, Text = "", Position = UDim2.new(0, 12, 0, 36), Size = UDim2.new(1, -24, 0, 6), ZIndex = 44 }, { corner(3) })
	track.BackgroundColor3 = T.off
	local fill = new("Frame", { Parent = track, BackgroundColor3 = T.on, BorderSizePixel = 0, ZIndex = 45 }, { corner(3) })
	local function paint() fill.Size = UDim2.new((userMul - 0.7) / 0.6, 0, 1, 0) v.Text = math.floor(userMul * 100 + 0.5) .. "%" end
	paint()
	local dragging = false
	local function fromX(x)
		local r = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
		userMul = math.floor((0.7 + 0.6 * r) * 20 + 0.5) / 20
		applyScale() paint()
	end
	track.InputBegan:Connect(function(i) if isPress(i) then dragging = true fromX(i.Position.X) end end)
	UIS.InputChanged:Connect(function(i) if dragging and isMove(i) then fromX(i.Position.X) end end)
	UIS.InputEnded:Connect(function(i) if isPress(i) then dragging = false end end)
	-- phim tat
	local r3 = pRow(34)
	label(r3, "Ẩn/hiện menu: phím LeftControl hoặc nút tròn khi thu nhỏ", 11, Enum.Font.Gotham, "mut", UDim2.new(0, 12, 0, 0), UDim2.new(1, -24, 1, 0)).ZIndex = 44
	overlay.Visible = true
end

local function openThemes()
	clearPop()
	popTitle.Text = "Giao diện"
	local names = { "Mono", "Graphite", "Midnight", "Crimson", "Ocean" }
	for i, n in ipairs(names) do
		local th = THEMES[n]
		local r = new("TextButton", { Parent = popBody, AutoButtonColor = false, Text = "", Size = UDim2.new(1, 0, 0, 40), LayoutOrder = i, ZIndex = 43 }, { corner(8) })
		bind(r, "BackgroundColor3", "card")
		local sw = new("Frame", { Parent = r, Position = UDim2.new(0, 10, 0.5, -10), Size = UDim2.new(0, 20, 0, 20), BackgroundColor3 = th.on, ZIndex = 44 }, { corner(6) })
		local sw2 = new("Frame", { Parent = r, Position = UDim2.new(0, 34, 0.5, -10), Size = UDim2.new(0, 20, 0, 20), BackgroundColor3 = th.bg, ZIndex = 44 }, { corner(6), new("UIStroke", { Color = th.line, Thickness = 1 }) })
		label(r, n, 13, Enum.Font.GothamMedium, "text", UDim2.new(0, 66, 0, 0), UDim2.new(1, -80, 1, 0)).ZIndex = 44
		r.MouseButton1Click:Connect(function() setTheme(n) pcall(function() getgenv().DuckTheme = n end) end)
	end
	overlay.Visible = true
end

-- 3 nut o cuoi panel
local function sideBtn(icon, text, idx, fn)
	local w = (226 - 28 - 12) / 3
	local b = new("TextButton", { Parent = side, AutoButtonColor = false, Text = "", Position = UDim2.new(0, 14 + (idx - 1) * (w + 6), 1, -66), Size = UDim2.new(0, w, 0, 54) }, { corner(10), stroke("line", 1) })
	bind(b, "BackgroundColor3", "card")
	label(b, icon, 17, Enum.Font.GothamBold, "text", UDim2.new(0, 0, 0, 6), UDim2.new(1, 0, 0, 22), Enum.TextXAlignment.Center)
	label(b, text, 10, Enum.Font.GothamMedium, "mut", UDim2.new(0, 0, 0, 31), UDim2.new(1, 0, 0, 14), Enum.TextXAlignment.Center)
	b.MouseButton1Click:Connect(fn)
	return b
end
sideBtn("👤", "Thông tin", 1, openInfo)
sideBtn("⚙", "Cài đặt", 2, openSettings)
sideBtn("🎨", "Giao diện", 3, openThemes)

------------------------------------------------------------------ WINDOW CONTROLS
local floatBtn = new("TextButton", { Parent = gui, AutoButtonColor = false, Text = "🦆", TextSize = 22, Font = Enum.Font.GothamBold, Position = UDim2.new(0, 16, 0.5, -22), Size = UDim2.new(0, 44, 0, 44), Visible = false }, { corner(22), stroke("line", 1) })
bind(floatBtn, "BackgroundColor3", "bg")
makeDraggable(floatBtn, floatBtn)

local function showWindow(v)
	holder.Visible = v
	floatBtn.Visible = not v
end
btnMin.MouseButton1Click:Connect(function() showWindow(false) end)
floatBtn.MouseButton1Click:Connect(function() showWindow(true) end)
local maxed = false
btnMax.MouseButton1Click:Connect(function() maxed = not maxed userMul = maxed and 1.15 or 1 applyScale() end)
btnClose.MouseButton1Click:Connect(function() gui:Destroy() end)
UIS.InputBegan:Connect(function(i, gp)
	if not gp and i.KeyCode == Enum.KeyCode.LeftControl then showWindow(not holder.Visible) end
end)

------------------------------------------------------------------ CHIP (Limit: nguoi choi - Ban)
local function updateChips()
	local txt = string.format("Limit: %d/%d - Bản %d", #Players:GetPlayers(), Players.MaxPlayers, seaNumber())
	for _, t in ipairs(tabs) do t.chipTxt.Text = txt end
end
task.spawn(function()
	while gui.Parent do
		pcall(updateChips)
		task.wait(3)
	end
end)

------------------------------------------------------------------ TAO TAB (giong anh)
local Farming = makeTab("Farming")
local RaceV4 = makeTab("Race V4")
local Hop = makeTab("Hop")
local Fishing = makeTab("Fishing")
local Quest = makeTab("Quest & Item", "Quest & Item")
local Teleport = makeTab("Teleport")
local Shop = makeTab("Shop")
local Setting = makeTab("Setting")

------------------------------------------------------------------ NOI CHUC NANG
-- Moi toggle/slider ghi vao getgenv().DuckFlags[Flag] va goi Callback.
-- Doi cac dong Callback ben duoi thanh bien cua script ban, vi du:
--   Callback = function(v) _G.Level = v end
local function HopServer()
	local TPS, Http = game:GetService("TeleportService"), game:GetService("HttpService")
	local cursor, found = "", false
	repeat
		local ok, res = pcall(function()
			return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. cursor)
		end)
		if not ok or not res then break end
		local d = Http:JSONDecode(res)
		for _, s in ipairs(d.data or {}) do
			if s.playing < s.maxPlayers and s.id ~= game.JobId then
				found = true
				TPS:TeleportToPlaceInstance(game.PlaceId, s.id)
				break
			end
		end
		cursor = d.nextPageCursor or ""
	until cursor == "" or found
end

local autoLevel
Farming:AddSection("Auto Farm")
autoLevel = Farming:AddToggle({ Name = "Auto Farm Level", Desc = "Tự nhận quest khi đánh quái", Flag = "AutoFarmLevel", Callback = function(v) _G.Level = v end })
Farming:AddToggle({ Name = "Bring Mobs", Desc = "Gom quái về một chỗ", Default = true, Flag = "BringMobs", Callback = function(v) _B = v end })
Farming:AddToggle({ Name = "Auto Farm Boss", Desc = "Săn boss đang spawn", Flag = "AutoFarmBoss", Callback = function(v) _G.FarmBoss = v end })
Farming:AddSlider({ Name = "Độ cao bay", Min = 5, Max = 40, Default = 12, Suffix = "stud", Flag = "FarmHeight", Callback = function(v) getgenv().FarmHeight = v _G.FarmHeight = v end })
Farming:AddButtons({
	{ Name = "Start Farm", Primary = true, Callback = function() autoLevel:Set(true) end },
	{ Name = "Hop Server", Callback = HopServer },
})

RaceV4:AddSection("Race V4")
RaceV4:AddToggle({ Name = "Auto Trial V4", Flag = "AutoTrialV4", Callback = function(v) _G.AutoTrialV4 = v end })
RaceV4:AddToggle({ Name = "Auto Skill Z/X/C", Flag = "AutoSkillRace", Callback = function(v) _G.AutoSkillRace = v end })

Hop:AddSection("Hop Server")
Hop:AddButtons({
	{ Name = "Hop Server ít người", Primary = true, Callback = HopServer },
	{ Name = "Rejoin", Callback = function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp) end },
})

Fishing:AddSection("Fishing")
Fishing:AddToggle({ Name = "Auto Fishing", Flag = "AutoFishing", Callback = function(v) _G.AutoFishing = v end })

Quest:AddSection("Quest & Item")
Quest:AddToggle({ Name = "Auto Quest", Flag = "AutoQuest", Callback = function(v) _G.AutoQuest = v end })

Teleport:AddSection("Teleport")
Teleport:AddLabel("Thêm chức năng teleport bằng Teleport:AddButton({Name=..., Callback=...})")

Shop:AddSection("Shop")
Shop:AddLabel("Thêm chức năng mua đồ bằng Shop:AddButton({Name=..., Callback=...})")

Setting:AddSection("Setting")
Setting:AddToggle({ Name = "Anti AFK", Default = true, Flag = "AntiAFK", Callback = function(v)
	if v then
		local vu = game:GetService("VirtualUser")
		lp.Idled:Connect(function() vu:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame) end)
	end
end })

selectTab(Farming)
updateChips()

getgenv().DuckUI = { Gui = gui, Tabs = { Farming = Farming, RaceV4 = RaceV4, Hop = Hop, Fishing = Fishing, Quest = Quest, Teleport = Teleport, Shop = Shop, Setting = Setting }, SetTheme = setTheme, Flags = Flags }
return getgenv().DuckUI
