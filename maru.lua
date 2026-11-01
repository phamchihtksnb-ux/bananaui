-- ============================================================
-- DUCK HUB LOADER (NO KEY) — theme an toàn + load raw
-- ============================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- ==== LINK RAW ====
local _LINK_PARTS = {
    "https://raw.githubusercontent.com/",
    "teddyhubdev/diepvy/refs/heads/main/",
    "BloxFruits.lua"
}
local SCRIPT_LINK = table.concat(_LINK_PARTS)
_LINK_PARTS = nil

-- ==== THEME CONFIG ====
local THEME_GOLD       = Color3.fromRGB(255, 215, 0)
local THEME_GOLD_LIGHT = Color3.fromRGB(255, 235, 120)
local THEME_BG_DARK    = Color3.fromRGB(25, 22, 10)
local THEME_TEXT_LIGHT = Color3.fromRGB(240, 230, 180)
local THEME_IMAGE_ID   = "rbxassetid://132401977734278"
local DEBUG_MODE       = false   -- bật true nếu muốn xem log

-- ==== UI PARENT ====
local function getUiParent()
    if type(gethui) == "function" then
        local ok, p = pcall(gethui)
        if ok and p then return p end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
end
local UI_PARENT = getUiParent()

-- ==== NOTIFICATION ====
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "DuckNotifyGui"
NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifGui.ResetOnSpawn = false
if type(syn) == "table" and type(syn.protect_gui) == "function" then
    pcall(syn.protect_gui, NotifGui)
end
NotifGui.Parent = UI_PARENT

local NotifContainer = Instance.new("Frame")
NotifContainer.BackgroundTransparency = 1
NotifContainer.Position = UDim2.new(1, -20, 1, -20)
NotifContainer.Size = UDim2.new(0, 340, 0, 500)
NotifContainer.AnchorPoint = Vector2.new(1, 1)
NotifContainer.Parent = NotifGui

local activeNotifs = {}

local function Notify(title, content, duration)
    duration = math.max(1, math.min(15, tonumber(duration) or 3))
    task.spawn(function()
        if not NotifContainer or not NotifContainer.Parent then return end
        local ok, frame = pcall(function()
            local item = Instance.new("Frame")
            item.Size = UDim2.new(1, 0, 0, 75)
            item.Position = UDim2.new(0, 360, 1, -85)
            item.BackgroundColor3 = THEME_BG_DARK
            item.BorderSizePixel = 0
            item.Parent = NotifContainer

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = item
            local stroke = Instance.new("UIStroke")
            stroke.Color = THEME_GOLD
            stroke.Thickness = 2
            stroke.Transparency = 0.3
            stroke.Parent = item

            local heading = Instance.new("TextLabel")
            heading.BackgroundTransparency = 1
            heading.Position = UDim2.new(0, 16, 0, 10)
            heading.Size = UDim2.new(1, -32, 0, 20)
            heading.Font = Enum.Font.GothamBold
            heading.Text = tostring(title or "DUCK Hub")
            heading.TextColor3 = THEME_GOLD
            heading.TextSize = 15
            heading.TextXAlignment = Enum.TextXAlignment.Left
            heading.Parent = item

            local message = Instance.new("TextLabel")
            message.BackgroundTransparency = 1
            message.Position = UDim2.new(0, 16, 0, 32)
            message.Size = UDim2.new(1, -32, 0, 32)
            message.Font = Enum.Font.Gotham
            message.Text = tostring(content or "")
            message.TextColor3 = THEME_TEXT_LIGHT
            message.TextSize = 13
            message.TextWrapped = true
            message.TextXAlignment = Enum.TextXAlignment.Left
            message.TextYAlignment = Enum.TextYAlignment.Top
            message.Parent = item
            return item
        end)
        if not ok or not frame then return end

        for _, existing in ipairs(activeNotifs) do
            if existing and existing.Parent then
                existing.Position = existing.Position - UDim2.new(0, 0, 0, 82)
            end
        end
        table.insert(activeNotifs, frame)
        pcall(function()
            TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 1, -85)
            }):Play()
        end)

        task.delay(duration, function()
            pcall(function()
                TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                    Position = UDim2.new(0, 360, frame.Position.Y.Scale, frame.Position.Y.Offset),
                    BackgroundTransparency = 1
                }):Play()
            end)
            task.wait(0.35)
            for i = #activeNotifs, 1, -1 do
                if activeNotifs[i] == frame then
                    table.remove(activeNotifs, i)
                    break
                end
            end
            pcall(function() frame:Destroy() end)
        end)
    end)
end

-- ==== THEME ENGINE (an toàn) ====
local function _log(...)
    if DEBUG_MODE then warn("[DUCK THEME]", ...) end
end

-- Blacklist ScreenGui của Roblox / game core → KHÔNG đụng vào
local ROBLOX_GUI_BLACKLIST = {
    ["RobloxGui"]        = true,
    ["Chat"]             = true,
    ["PlayerList"]       = true,
    ["Backpack"]         = true,
    ["Health"]           = true,
    ["TouchGui"]         = true,
    ["BubbleChat"]       = true,
    ["EmotesMenu"]       = true,
    ["VoiceChat"]        = true,
    ["Topbar"]           = true,
    ["Startup"]          = true,
    ["Notification"]     = true,
    ["ThemeProvider"]    = true,
    ["ControlFrame"]     = true,
}

-- GUI do chính script này tạo → không đụng
local function _isOurGui(g)
    return g.Name == "DuckNotifyGui"
        or g.Name == "NotificationHolder"
        or g.Name == "KeySystemGui"
end

-- Đánh dấu thời điểm raw load để phân biệt hub với GUI game
local RAW_LOAD_TIME = nil

-- Xác định GUI thuộc hub hay không (an toàn tuyệt đối)
local function _isHubGui(g)
    if not g or not g.Name then return false end
    if ROBLOX_GUI_BLACKLIST[g.Name] then return false end
    if _isOurGui(g) then return false end
    -- 1) Tên chứa keyword hub → chắc chắn là hub
    local ln = g.Name:lower()
    if ln:find("teddy") or ln:find("hub") or ln:find("duck") then
        return true
    end
    -- 2) Được tạo sau khi raw load (trong 3 phút) → gần như chắc chắn là hub
    if RAW_LOAD_TIME and (tick() - RAW_LOAD_TIME) < 180 then
        return true
    end
    return false
end

-- Nhận diện màu tím (rộng hơn để bắt cả tím nhạt)
local function _isPurple(c)
    if not c then return false end
    local r, g, b = c.R * 255, c.G * 255, c.B * 255
    if b < 60 then return false end
    if g > b - 20 then return false end
    return (b - g) > 30 and (r - g) > 10
end

-- Đổi chuỗi Teddy → Duck Hub (giữ "Hub" nếu đã có)
local function _replaceText(s)
    if type(s) ~= "string" or s == "" then return s end
    local hasHub = s:lower():find("hub") ~= nil
    local repl  = hasHub and "Duck" or "Duck Hub"

    s = s:gsub("Teddy Hub", "Duck Hub")
    s = s:gsub("TEDDY HUB", "DUCK HUB")
    s = s:gsub("teddy hub", "duck hub")
    s = s:gsub("TeddyHub", "DuckHub")
    s = s:gsub("TEDDYHUB", "DUCKHUB")
    s = s:gsub("teddyhub", "duckhub")

    s = s:gsub("Teddy", repl)
    s = s:gsub("TEDDY", repl:upper())
    s = s:gsub("teddy", repl:lower())
    return s
end

local changeCount = 0

-- Chỉ theme các instance NẰM TRONG ScreenGui của hub
local function _themeInstance(d, hubGui)
    if not d or not d.Parent then return end

    -- ============ TEXT ============
    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
        if type(d.Text) == "string" and d.Text ~= "" then
            local n = _replaceText(d.Text)
            if n ~= d.Text then
                pcall(function() d.Text = n end)
                changeCount = changeCount + 1
                _log("Renamed:", d.Text, "->", n)
            end
        end
        if d.TextColor3 and _isPurple(d.TextColor3) then
            pcall(function() d.TextColor3 = THEME_GOLD end)
            changeCount = changeCount + 1
        end
    end

    -- ============ NỀN ============
    if d:IsA("Frame") or d:IsA("TextButton") or d:IsA("ImageButton") then
        if d.BackgroundColor3 and _isPurple(d.BackgroundColor3) then
            pcall(function() d.BackgroundColor3 = THEME_BG_DARK end)
            changeCount = changeCount + 1
        end
    end

    -- ============ VIỀN ============
    if d:IsA("UIStroke") and d.Color and _isPurple(d.Color) then
        pcall(function() d.Color = THEME_GOLD end)
        changeCount = changeCount + 1
    end

    -- ============ GRADIENT ============
    if d:IsA("UIGradient") and d.Color then
        local ks, ch = {}, false
        for _, kp in ipairs(d.Color.Keypoints) do
            local c = kp.Value
            if _isPurple(c) then c = THEME_GOLD_LIGHT; ch = true end
            ks[#ks + 1] = ColorSequenceKeypoint.new(kp.Time, c)
        end
        if ch then
            pcall(function() d.Color = ColorSequence.new(ks) end)
            changeCount = changeCount + 1
        end
    end

    -- ============ ẢNH (CHỈ TRONG HUB, SIZE NHỎ) ============
    -- Chỉ đổi khi:
    --   1) Nằm trong ScreenGui của hub (đã xác định bởi _isHubGui)
    --   2) ImageLabel/ImageButton
    --   3) Kích thước ≤ 200px (logo/icon/button, KHÔNG phải background)
    --   4) Name chứa keyword an toàn HOẶC nằm trong UI hub rõ ràng
    if (d:IsA("ImageLabel") or d:IsA("ImageButton")) and d.Image and d.Image ~= "" then
        if d.Image ~= THEME_IMAGE_ID then
            local sx = d.AbsoluteSize.X
            local sy = d.AbsoluteSize.Y
            local safeSize = sx > 0 and sy > 0 and sx <= 200 and sy <= 200
            local nameLower = (d.Name or ""):lower()
            -- Tên an toàn — chỉ đổi những cái rõ ràng là icon/logo/avatar của hub
            local safeName = nameLower:find("logo") or nameLower:find("icon")
                or nameLower:find("avatar") or nameLower:find("image")
                or nameLower:find("button") or nameLower:find("title")
                or nameLower:find("profile") or nameLower:find("user")

            if safeSize and safeName then
                pcall(function() d.Image = THEME_IMAGE_ID end)
                changeCount = changeCount + 1
                _log("Image -> new:", d:GetFullName(), "(" .. sx .. "x" .. sy .. ")")
            end
        end
    end
end

-- Liệt kê parent có thể chứa ScreenGui
local function _getAllParents()
    local list = {}
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then list[#list + 1] = cg end
    local pg = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg then list[#list + 1] = pg end
    if type(gethui) == "function" then
        local ok2, h = pcall(gethui)
        if ok2 and h and h ~= cg and h ~= pg then list[#list + 1] = h end
    end
    return list
end

-- Theme toàn bộ hub ScreenGui
local function _themeHubGui(g)
    if not _isHubGui(g) then return end
    for _, d in ipairs(g:GetDescendants()) do
        pcall(_themeInstance, d, g)
    end
end

-- Scan một lần
local function _scanOnce()
    for _, parent in ipairs(_getAllParents()) do
        for _, g in ipairs(parent:GetChildren()) do
            if (g:IsA("ScreenGui") or g:IsA("LayerCollector")) and _isHubGui(g) then
                for _, d in ipairs(g:GetDescendants()) do
                    pcall(_themeInstance, d, g)
                end
            end
        end
    end
end

-- Hook DescendantAdded để bắt ngay khi UI mới được thêm
local function _hookParent(parent)
    parent.ChildAdded:Connect(function(g)
        if (g:IsA("ScreenGui") or g:IsA("LayerCollector")) and _isHubGui(g) then
            _log("New hub GUI detected:", g.Name)
            _themeHubGui(g)
            g.DescendantAdded:Connect(function(d)
                pcall(_themeInstance, d, g)
            end)
        end
    end)
    for _, g in ipairs(parent:GetChildren()) do
        if (g:IsA("ScreenGui") or g:IsA("LayerCollector")) and _isHubGui(g) then
            _themeHubGui(g)
            g.DescendantAdded:Connect(function(d)
                pcall(_themeInstance, d, g)
            end)
        end
    end
end

for _, p in ipairs(_getAllParents()) do
    pcall(_hookParent, p)
end

-- Loop vĩnh viễn nhẹ
task.spawn(function()
    _log("Theme engine started")
    while true do
        pcall(_scanOnce)
        task.wait(0.2)
    end
end)

-- Log tổng kết
task.spawn(function()
    while true do
        task.wait(15)
        if changeCount > 0 then
            _log("Total theme changes:", changeCount)
        end
    end
end)

-- ==== LOAD RAW ====
local SCRIPT_LOAD_STARTED = false
local function AutoLoadScript()
    if SCRIPT_LOAD_STARTED then return end
    SCRIPT_LOAD_STARTED = true

    pcall(Notify, "DUCK Hub", "Dang tai hub...", 3)

    task.spawn(function()
        _log("Fetching raw...")
        RAW_LOAD_TIME = tick()   -- đánh dấu thời điểm load raw

        local ok, err = pcall(function()
            local loader = loadstring or load
            if type(loader) ~= "function" then error("no loadstring") end
            local src = game:HttpGet(SCRIPT_LINK)
            if type(src) ~= "string" or #src < 10 then error("download fail") end
            _log("Downloaded", #src, "bytes — executing...")
            local fn = loader(src, "=DuckHubScript")
            if type(fn) ~= "function" then error("parse fail") end
            fn()
            RAW_LOAD_TIME = tick()   -- refresh sau khi raw chạy xong
            _scanOnce()
            _log("Raw executed — theme continues running")
        end)

        if not ok then
            SCRIPT_LOAD_STARTED = false
            warn("[DUCK Hub] AutoLoadScript failed:", tostring(err))
            pcall(Notify, "DUCK Hub", "Loi tai hub: " .. tostring(err), 6)
        end
    end)
end

AutoLoadScript()

return
