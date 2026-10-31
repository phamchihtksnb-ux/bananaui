--[[
    Duck Hub Add-on: EVENT CHECKER + HALLOWEEN 2026 (HELLFIRE)
    ---------------------------------------------------------------
    CACH DUNG (chon 1 trong 2):
      A) Chay file nay SAU KHI Duck Hub da load xong (no tu cho Main UI).
      B) Dan nguyen noi dung file nay vao cuoi file Duck Hub, ngay TRUOC dong cuoi:
             getgenv().__BF_LOADED = game.JobId

    CO GI:
      1) Tab "Event Checker": dem nguoc / trang thai cac event
         (Harvest Moon Halloween, Mirage, Prehistoric, Kitsune, Frozen Dimension,
          Elite Hunter, Raid Castle, Sea Beast, Moon, chest Chalice/Fist, boss awakened hint).
      2) Thong bao khi event bat dau.
      3) [Thu nghiem] Auto Kill Hell Rider  (khop ten gan dung "hell rider").
      4) [Thu nghiem] Auto Knock Halloween Doors (quet ProximityPrompt co chu knock/trick/treat...).

    LUU Y: mon 3 va 4 CHUA duoc kiem chung trong game (ten instance cua update moi
    chua cong bo day du), mac dinh TAT. Muon doi tu khoa cua cua:
         getgenv().HalloweenPromptKeywords = { "knock", "trick", "treat" }
]]

task.spawn(function()
	local ENV = getgenv()
	if ENV.__DH_EVENT_ADDON == game.JobId then
		return
	end
	ENV.__DH_EVENT_ADDON = game.JobId

	local Players = game:GetService("Players")
	local RS = game:GetService("ReplicatedStorage")
	local lp = Players.LocalPlayer

	-- lay bien global cua Duck Hub (thu getgenv, _G, roi moi den global thuong)
	local function G(name)
		local v = ENV[name]
		if v == nil then
			v = _G[name]
		end
		if v == nil then
			local f = loadstring("return " .. name)
			if f then
				local ok, r = pcall(f)
				if ok then
					v = r
				end
			end
		end
		return v
	end

	local function setting(key, default)
		local s = G("Settings")
		local v = type(s) == "table" and s[key] or nil
		if v == nil then
			return default
		end
		return v
	end

	local function save(key, value)
		local f = G("SaveSettings")
		if type(f) == "function" then
			pcall(f, key, value)
		else
			local s = G("Settings")
			if type(s) == "table" then
				s[key] = value
			end
		end
	end

	-- cho Duck Hub load xong
	local t0 = tick()
	repeat
		task.wait(1)
	until (G("Main") and G("Settings") and G("SaveSettings") and ENV.__BF_LOADED == game.JobId) or tick() - t0 > 180
	if not G("Main") then
		-- truong hop dan chung vao file: Main co san nhung __BF_LOADED chua set
		t0 = tick()
		repeat
			task.wait(0.5)
		until G("Main") or tick() - t0 > 30
	end
	local Main = G("Main")
	if not Main then
		warn("[EventAddon] Khong thay Main UI cua Duck Hub. Hay chay file nay sau khi hub load xong.")
		return
	end

	---------------------------------------------------------------------
	-- Tien ich
	---------------------------------------------------------------------
	local function mmss(sec)
		sec = math.max(0, math.floor(sec))
		return string.format("%02d:%02d", math.floor(sec / 60), sec % 60)
	end

	local function hms(sec)
		sec = math.max(0, math.floor(sec))
		return string.format("%dh %02dm %02ds", math.floor(sec / 3600), math.floor(sec % 3600 / 60), sec % 60)
	end

	local function nowUtc()
		local d = os.date("!*t")
		return d.min, d.sec
	end

	local function notify(title, desc)
		print("[EventAddon] " .. tostring(title) .. ": " .. tostring(desc))
		pcall(function()
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Duck Hub - " .. tostring(title),
				Text = tostring(desc),
				Duration = 8,
			})
		end)
	end

	local function setLabel(lbl, text)
		pcall(function()
			lbl.SetText(text)
		end)
	end

	local function mapHas(name)
		local m = workspace:FindFirstChild("Map")
		return m ~= nil and m:FindFirstChild(name) ~= nil
	end

	local function otherOk()
		return G("StackFarmOther") ~= false
	end

	local function myHrp()
		local c = lp.Character
		return c and c:FindFirstChild("HumanoidRootPart")
	end

	---------------------------------------------------------------------
	-- Bat thong bao trong game (Harvest Moon / Hellfire ...)
	---------------------------------------------------------------------
	local lastAnn = { text = nil, at = 0 }
	local lastHarvestAt = 0

	local function onText(raw)
		if type(raw) ~= "string" or raw == "" then
			return
		end
		local clean = (raw:gsub("<[^>]+>", ""):gsub("{[^}]*}", ""))
		local low = string.lower(clean)
		local hit = low:find("harvest moon", 1, true)
			or low:find("hellfire", 1, true)
			or low:find("hell rider", 1, true)
			or low:find("trick", 1, true)
			or low:find("spooky", 1, true)
		if hit then
			lastAnn.text = clean
			lastAnn.at = os.time()
			if low:find("harvest moon", 1, true) then
				lastHarvestAt = os.time()
			end
		end
	end

	task.spawn(function()
		pcall(function()
			local notifs = lp.PlayerGui:WaitForChild("Notifications", 15)
			if notifs then
				notifs.DescendantAdded:Connect(function(d)
					if d:IsA("TextLabel") then
						task.wait(0.1)
						onText(d.Text)
					end
				end)
			end
		end)
	end)

	task.spawn(function()
		pcall(function()
			local commE = RS:WaitForChild("Remotes", 15):WaitForChild("CommE", 15)
			commE.OnClientEvent:Connect(function(kind, text)
				if kind == "Notify" then
					onText(text)
				end
			end)
		end)
	end)

	---------------------------------------------------------------------
	-- Lich Harvest Moon (moi gio, keo dai 10 phut)
	---------------------------------------------------------------------
	local HARVEST_KEY = "Harvest Moon Start Minute (UTC)"

	local function harvestActive()
		-- uu tien thong bao that trong game
		local age = os.time() - lastHarvestAt
		if lastHarvestAt > 0 and age < 600 then
			return true, 600 - age, "announcement"
		end
		local min, sec = nowUtc()
		local off = tonumber(setting(HARVEST_KEY, 0)) or 0
		local since = ((min - off) % 60) * 60 + sec
		if since < 600 then
			return true, 600 - since, "schedule"
		end
		return false, 3600 - since, "schedule"
	end

	---------------------------------------------------------------------
	-- Hell Rider boss
	---------------------------------------------------------------------
	local function findHellRider()
		local folders = { workspace:FindFirstChild("Enemies"), RS }
		for i = 1, #folders do
			local folder = folders[i]
			if folder then
				for _, m in ipairs(folder:GetChildren()) do
					if m:IsA("Model") then
						local n = string.lower(m.Name)
						if n:find("hell rider", 1, true) or n:find("hellrider", 1, true) then
							local hum = m:FindFirstChildOfClass("Humanoid")
							if hum and hum.Health > 0 and m:FindFirstChild("HumanoidRootPart") then
								return m
							end
						end
					end
				end
			end
		end
		return nil
	end

	---------------------------------------------------------------------
	-- ProximityPrompt cache (chi quet khi bat tinh nang cua / debug)
	---------------------------------------------------------------------
	local promptCache = {}
	local cacheBuilt, cacheBusy = false, false
	local ignoreUntil = {}

	local function addPrompt(d)
		if d:IsA("ProximityPrompt") then
			promptCache[d] = true
		end
	end

	local function ensurePromptCache()
		if cacheBuilt or cacheBusy then
			return
		end
		cacheBusy = true
		workspace.DescendantAdded:Connect(addPrompt)
		local list = workspace:GetDescendants()
		for i = 1, #list do
			addPrompt(list[i])
			if i % 3000 == 0 then
				task.wait()
			end
		end
		cacheBuilt = true
		cacheBusy = false
	end

	local function keywords()
		local k = ENV.HalloweenPromptKeywords
		if type(k) == "table" and #k > 0 then
			return k
		end
		return { "knock", "trick", "treat", "spooky", "halloween", "hellfire" }
	end

	local function promptText(p)
		local parts = {}
		local function add(v)
			parts[#parts + 1] = tostring(v)
		end
		pcall(function()
			add(p.ActionText)
			add(p.ObjectText)
			add(p.Name)
			if p.Parent then
				add(p.Parent.Name)
				if p.Parent.Parent then
					add(p.Parent.Parent.Name)
				end
			end
		end)
		return string.lower(table.concat(parts, " "))
	end

	local function promptMatches(p)
		local txt = promptText(p)
		local ks = keywords()
		for i = 1, #ks do
			if txt:find(string.lower(ks[i]), 1, true) then
				return true
			end
		end
		return false
	end

	local function promptPos(p)
		local par = p.Parent
		if not par then
			return nil
		end
		if par:IsA("BasePart") then
			return par.Position
		end
		if par:IsA("Attachment") then
			return par.WorldPosition
		end
		if par:IsA("Model") then
			local ok, cf = pcall(par.GetPivot, par)
			if ok then
				return cf.Position
			end
		end
		return nil
	end

	local function nearestPrompt()
		local hrp = myHrp()
		if not hrp then
			return nil, nil
		end
		local best, bestD
		for p in pairs(promptCache) do
			if not p:IsDescendantOf(workspace) then
				promptCache[p] = nil
			elseif p.Enabled and (ignoreUntil[p] or 0) < tick() and promptMatches(p) then
				local pos = promptPos(p)
				if pos then
					local d = (pos - hrp.Position).Magnitude
					if not bestD or d < bestD then
						best, bestD = p, d
					end
				end
			end
		end
		return best, bestD
	end

	---------------------------------------------------------------------
	-- UI
	---------------------------------------------------------------------
	local Page = Main.CreatePage({ Page_Name = "Event Checker", Page_Title = "Event Checker" })

	local SecHW = Page.CreateSection("Halloween 2026 - Hellfire")
	local lblHarvest = SecHW.CreateLabel({ Title = "Harvest Moon : ..." })
	local lblAnn = SecHW.CreateLabel({ Title = "Last Announcement : none" })
	local lblBoss = SecHW.CreateLabel({ Title = "Hell Rider Boss : ..." })
	local lblPrompts = SecHW.CreateLabel({ Title = "Halloween Prompts : (bat Auto Knock / Debug de quet)" })

	SecHW.CreateSlider({
		Title = HARVEST_KEY,
		Min = 0,
		Max = 59,
		Default = tonumber(setting(HARVEST_KEY, 0)) or 0,
		Precise = true,
	}, function(v)
		save(HARVEST_KEY, v)
	end)

	SecHW.CreateToggle({
		Title = "Notify Event Start",
		Desc = "Thong bao khi event bat dau",
		Default = setting("Notify Event Start", true) == true,
	}, function(v)
		save("Notify Event Start", v)
	end)

	SecHW.CreateToggle({
		Title = "Auto Kill Hell Rider [Experimental]",
		Desc = "Danh boss co ten chua 'hell rider' khi boss xuat hien",
		Default = setting("Auto Kill Hell Rider", false) == true,
	}, function(v)
		save("Auto Kill Hell Rider", v)
	end)

	SecHW.CreateToggle({
		Title = "Auto Knock Halloween Doors [Experimental]",
		Desc = "Chi chay trong luc Harvest Moon. Chua giai duoc minigame",
		Default = setting("Auto Knock Halloween Doors", false) == true,
	}, function(v)
		save("Auto Knock Halloween Doors", v)
	end)

	SecHW.CreateToggle({
		Title = "Debug Halloween Prompts",
		Desc = "In ra console cac prompt gan ban de kiem tra tu khoa",
		Default = false,
	}, function(v)
		ENV.__DH_DEBUG_PROMPTS = v
	end)

	local SecOther = Page.CreateSection("Other Events")
	local EVENTS = {
		{
			name = "Mirage Island",
			fn = function()
				return mapHas("MysticIsland")
			end,
		},
		{
			name = "Prehistoric Island",
			fn = function()
				return mapHas("PrehistoricIsland")
			end,
		},
		{
			name = "Kitsune Island",
			fn = function()
				return mapHas("KitsuneIsland")
			end,
		},
		{
			name = "Frozen Dimension",
			fn = function()
				local l = workspace:FindFirstChild("_WorldOrigin")
				l = l and l:FindFirstChild("Locations")
				return l ~= nil and l:FindFirstChild("Frozen Dimension") ~= nil
			end,
		},
		{
			name = "Elite Hunter",
			fn = function()
				local f = G("DetectEliteHunter")
				return type(f) == "function" and f() ~= nil
			end,
		},
		{
			name = "Raid Castle",
			fn = function()
				local f = G("GetPirateRaid")
				if type(f) ~= "function" then
					return false
				end
				return (f() or f(true)) ~= nil
			end,
		},
		{
			name = "Sea Beast",
			fn = function()
				local sb = workspace:FindFirstChild("SeaBeasts")
				return sb ~= nil and #sb:GetChildren() > 0
			end,
		},
	}
	for i = 1, #EVENTS do
		EVENTS[i].label = SecOther.CreateLabel({ Title = EVENTS[i].name .. " : ..." })
	end

	local SecTimer = Page.CreateSection("Timers")
	local lblMoon = SecTimer.CreateLabel({ Title = "Moon : ..." })
	local lblChest = SecTimer.CreateLabel({ Title = "Chalice / Fist Chest : ..." })
	local lblHint = SecTimer.CreateLabel({ Title = "Next Awakened Boss : ..." })

	---------------------------------------------------------------------
	-- Hint boss awakened (RF/RequestNextRaidHint) - goi trong thread rieng
	---------------------------------------------------------------------
	local hint = { data = nil, fetchedAt = 0, busy = false }
	local function pollHint()
		if hint.busy or tick() - hint.fetchedAt < 20 then
			return
		end
		hint.busy = true
		hint.fetchedAt = tick()
		task.spawn(function()
			local ok, res = pcall(function()
				return RS.Modules.Net["RF/RequestNextRaidHint"]:InvokeServer()
			end)
			hint.data = (ok and type(res) == "table") and res or nil
			hint.fetchedAt = tick()
			hint.busy = false
		end)
	end

	---------------------------------------------------------------------
	-- Theo doi bat/tat event de thong bao
	---------------------------------------------------------------------
	local state, since = {}, {}
	local function track(name, on, detail)
		local was = state[name]
		state[name] = on and true or false
		if on and not was then
			since[name] = tick()
			if was ~= nil and setting("Notify Event Start", true) == true then
				notify(name, detail or "started")
			end
		elseif not on then
			since[name] = nil
		end
	end

	---------------------------------------------------------------------
	-- Vong cap nhat (1 giay)
	---------------------------------------------------------------------
	local lastPromptScan = 0
	task.spawn(function()
		while task.wait(1) do
			pcall(function()
				-- Harvest Moon
				local on, rem, src = harvestActive()
				track("Harvest Moon", on, "Trick-or-Treat dang bat dau (10 phut)")
				if on then
					setLabel(lblHarvest, "Harvest Moon : ACTIVE - con " .. mmss(rem) .. " (" .. src .. ")")
				else
					local off = tonumber(setting(HARVEST_KEY, 0)) or 0
					setLabel(
						lblHarvest,
						"Harvest Moon : next in " .. mmss(rem) .. " (starts at :" .. string.format("%02d", off) .. " UTC)"
					)
				end

				-- thong bao gan nhat
				if lastAnn.text then
					local txt = lastAnn.text
					if #txt > 60 then
						txt = txt:sub(1, 57) .. "..."
					end
					local m, s = nowUtc()
					setLabel(
						lblAnn,
						"Last Announcement : " .. txt .. " (" .. mmss(os.time() - lastAnn.at) .. " truoc)"
					)
				end

				-- Hell Rider
				local boss = findHellRider()
				track("Hell Rider Boss", boss ~= nil, "Boss da xuat hien")
				if boss then
					local hum = boss:FindFirstChildOfClass("Humanoid")
					local hrp, mine = boss:FindFirstChild("HumanoidRootPart"), myHrp()
					local pct = hum and math.floor(hum.Health / math.max(hum.MaxHealth, 1) * 100) or 0
					local dist = (hrp and mine) and math.floor((hrp.Position - mine.Position).Magnitude) or 0
					setLabel(lblBoss, "Hell Rider Boss : SPAWNED - " .. boss.Name .. " | HP " .. pct .. "% | " .. dist .. " studs")
				else
					setLabel(lblBoss, "Hell Rider Boss : not spawned")
				end

				-- prompt
				if cacheBuilt and tick() - lastPromptScan > 3 then
					lastPromptScan = tick()
					local n = 0
					for p in pairs(promptCache) do
						if p:IsDescendantOf(workspace) and p.Enabled and promptMatches(p) then
							n = n + 1
						end
					end
					setLabel(lblPrompts, "Halloween Prompts : " .. n .. " khop tu khoa")
				end

				-- event khac
				for i = 1, #EVENTS do
					local ev = EVENTS[i]
					local ok, res = pcall(ev.fn)
					local active = ok and res == true
					track(ev.name, active, "da xuat hien")
					if active then
						local ago = since[ev.name] and (" (" .. mmss(tick() - since[ev.name]) .. ")") or ""
						setLabel(ev.label, ev.name .. " : ACTIVE" .. ago)
					else
						setLabel(ev.label, ev.name .. " : not found")
					end
				end

				-- Moon
				local cm, f8 = G("CheckMoon"), G("function8")
				if type(cm) == "function" then
					local ok, phase = pcall(cm)
					local ok2, detail = true, ""
					if type(f8) == "function" then
						ok2, detail = pcall(f8)
					end
					if ok then
						setLabel(lblMoon, "Moon : " .. tostring(phase) .. (ok2 and (" | " .. tostring(detail)) or ""))
					end
				end

				-- Chest Chalice / Fist
				local go = G("GetOldestLocation")
				if type(go) == "function" then
					local ok, loc = pcall(go)
					if ok and loc then
						local q = loc:GetAttribute("TimeIn")
						if q then
							local elapsed = tick() - 25200 - q
							local cycle = 14400
							local remain = cycle - elapsed % cycle
							setLabel(lblChest, "Chalice / Fist Chest : next in " .. hms(remain))
						end
					end
				end

				-- Boss awakened hint
				pollHint()
				local d = hint.data
				if d and d.Boss and d.Island then
					local secs = (tonumber(d.Seconds) or 0) - (tick() - hint.fetchedAt)
					setLabel(
						lblHint,
						"Next Awakened Boss : " .. tostring(d.Boss) .. " @ " .. tostring(d.Island) .. " in " .. mmss(secs)
					)
				else
					setLabel(lblHint, "Next Awakened Boss : no data (Sea 1 only)")
				end
			end)
		end
	end)

	---------------------------------------------------------------------
	-- [Thu nghiem] Auto Kill Hell Rider
	---------------------------------------------------------------------
	task.spawn(function()
		while task.wait(0.4) do
			if setting("Auto Kill Hell Rider", false) == true and otherOk() then
				pcall(function()
					local boss = findHellRider()
					if not boss then
						return
					end
					local sizepart, tween, click, flock, alive =
						G("sizepart"), G("toTarget"), G("ClickM1"), G("UsedualFlock"), G("IsMobAlive")
					if not (sizepart and tween and click and alive) then
						return
					end
					local buddhaY = G("BuddhaFarmY")
					repeat
						task.wait()
						pcall(ENV.BuddhaBossGuard)
						local hrp = boss:FindFirstChild("HumanoidRootPart")
						if not hrp then
							break
						end
						sizepart(boss)
						local weapon = setting("Select Weapon Farm", nil) or setting("Select Weapon", nil)
						if weapon == "Blox Fruit" then
							tween(hrp.CFrame * CFrame.new(-7, 20, 0))
						else
							local y = type(buddhaY) == "function" and buddhaY() or 20
							tween(hrp.CFrame * CFrame.new(7, y, 0))
						end
						if flock then
							flock()
						end
						click(boss)
					until not alive(boss) or setting("Auto Kill Hell Rider", false) ~= true
				end)
			end
		end
	end)

	---------------------------------------------------------------------
	-- [Thu nghiem] Auto Knock Halloween Doors
	---------------------------------------------------------------------
	task.spawn(function()
		while task.wait(0.4) do
			local wantDoors = setting("Auto Knock Halloween Doors", false) == true
			if wantDoors or ENV.__DH_DEBUG_PROMPTS then
				pcall(ensurePromptCache)
			end

			if ENV.__DH_DEBUG_PROMPTS and cacheBuilt and tick() - (ENV.__DH_LAST_DBG or 0) > 5 then
				ENV.__DH_LAST_DBG = tick()
				pcall(function()
					local hrp = myHrp()
					local shown = 0
					for p in pairs(promptCache) do
						if hrp and p:IsDescendantOf(workspace) then
							local pos = promptPos(p)
							if pos and (pos - hrp.Position).Magnitude < 150 and shown < 8 then
								shown = shown + 1
								print("[EventAddon][prompt]", p:GetFullName(), "|", promptText(p), "| match=", promptMatches(p))
							end
						end
					end
				end)
			end

			if wantDoors and otherOk() and cacheBuilt and (harvestActive()) then
				pcall(function()
					local best, dist = nearestPrompt()
					if not best then
						return
					end
					local pos = promptPos(best)
					if not pos then
						return
					end
					if dist > 12 then
						local tween = G("toTarget")
						if tween then
							tween(CFrame.new(pos + Vector3.new(0, 3, 5)))
						end
					else
						if fireproximityprompt then
							local hd = best.HoldDuration
							pcall(function()
								best.HoldDuration = 0
							end)
							fireproximityprompt(best)
							pcall(function()
								best.HoldDuration = hd
							end)
						end
						ignoreUntil[best] = tick() + 30
						task.wait(3)
					end
				end)
			end
		end
	end)

	print("[DuckHub Event Addon] loaded - tab 'Event Checker'")
end)
