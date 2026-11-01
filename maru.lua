-- ============================================================
-- DUCK HUB LOADER (NO KEY) - Theme an toàn + Không tràn lan
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
local DEBUG_MODE       = false -- Bật true nếu muốn xem log ở F9

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

            -- THÊM ẢNH VÀO NOTIFY
            local icon = Instance.new("ImageLabel")
            icon.BackgroundTransparency = 1
            icon.Position = UDim2.new(0, 12, 0, 15)
            icon.Size = UDim2.new(0, 40, 0, 40)
            icon.Image = THEME_IMAGE_ID
            icon.Parent = item

            local heading = Instance.new("TextLabel")
            heading.BackgroundTransparency = 1
            heading.Position = UDim2.new(0, 60, 0, 10)
            heading.Size = UDim2.new(1, -72, 0, 20)
            heading.Font = Enum.Font.GothamBold
            heading.Text = tostring(title or "Duck Hub")
            heading.TextColor3 = THEME_GOLD
            heading.TextSize = 15
            heading.TextXAlignment = Enum.TextXAlignment.Left
            heading.Parent = item

            local message = Instance.new("TextLabel")
            message.BackgroundTransparency = 1
            message.Position = UDim2.new(0, 60, 0, 32)
            message.Size = UDim2.new(1, -72, 0, 32)
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

-- ==== THEME ENGINE ====
local function _log(...)
    if DEBUG_MODE then warn("[DUCK THEME]", ...) end
end

local ROBLOX_GUI_BLACKLIST = {
    ["RobloxGui"] = true, ["Chat"] = true, ["PlayerList"] = true,
    ["Backpack"] = true, ["Health"] = true, ["TouchGui"] = true,
    ["BubbleChat"] = true, ["EmotesMenu"] = true, ["VoiceChat"] = true,
    ["Topbar"] = true, ["Startup"] = true, ["Notification"] = true,
    ["ThemeProvider"] = true, ["ControlFrame"] = true
}

local function _isOurGui(g)
    return g.Name == "DuckNotifyGui" or g.Name == "NotificationHolder" or g.Name == "KeySystemGui"
end

local RAW_LOAD_TIME = nil

local function _isHubGui(g)
    if not g or not g.Name then return false end
    if ROBLOX_GUI_BLACKLIST[g.Name] or _isOurGui(g) then return false end
    local ln = g.Name:lower()
    if ln:find("teddy") or ln:find("hub") or ln:find("duck") then return true end
    if RAW_LOAD_TIME and (tick() - RAW_LOAD_TIME) < 180 then return true end
    return false
end

-- Bắt màu tím siêu mạnh (để đổi Title đang bị tím)
local function _isPurple(c)
    if not c then return false end
    local r, g, b = c.R * 255, c.G * 255, c.B * 255
    -- Nếu Blue trội hơn Green và Red cũng có mặt -> là tím
    if b > 60 and r > 30 and b > g + 20 then
        return true
    end
    return false
end

-- Đổi chữ Teddy -> Duck Hub
local function _replaceText(s)
    if type(s) ~= "string" or s == "" then return s end
    s = s:gsub("Teddy Hub", "Duck Hub")
    s = s:gsub("TEDDY HUB", "DUCK HUB")
    s = s:gsub("teddy hub", "duck hub")
    s = s:gsub("TeddyHub", "DuckHub")
    s = s:gsub("teddyhub", "duckhub")
    s = s:gsub("Teddy", "Duck Hub")
    s = s:gsub("TEDDY", "DUCK HUB")
    s = s:gsub("teddy", "duck hub")
    return s
end

local changeCount = 0

local function _themeInstance(d, hubGui)
    if not d or not d.Parent then return end

    -- 1. Đổi chữ và màu chữ
    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
        if type(d.Text) == "string" and d.Text ~= "" then
            local n = _replaceText(d.Text)
            if n ~= d.Text then
                pcall(function() d.Text = n end)
            end
        end
        if d.TextColor3 and _isPurple(d.TextColor3) then
            pcall(function() d.TextColor3 = THEME_GOLD end)
            changeCount = changeCount + 1
        end
    end

    -- 2. Đổi nền và viền
    if d:IsA("Frame") or d:IsA("TextButton") or d:IsA("ImageButton") then
        if d.BackgroundColor3 and _isPurple(d.BackgroundColor3) then
            pcall(function() d.BackgroundColor3 = THEME_BG_DARK end)
            changeCount = changeCount + 1
        end
    end
    if d:IsA("UIStroke") and d.Color and _isPurple(d.Color) then
        pcall(function() d.Color = THEME_GOLD end)
        changeCount = changeCount + 1
    end

    -- 3. Gradient
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

    -- 4. ĐỔI ẢNH (CHỈ NÚT BẤM VÀ NOTIFY)
    -- Loại bỏ ảnh tràn lan (không đổi avatar, background, góc trái trên)
    if (d:IsA("ImageLabel") or d:IsA("ImageButton")) and d.Image and d.Image ~= "" then
        if d.Image ~= THEME_IMAGE_ID then
            local isNotify = hubGui and hubGui.Name == "DuckNotifyGui"
            
            -- Chỉ đổi nếu nằm trong Nút bấm (Button), hoặc là Notify
            local isBtn = d:IsA("ImageButton") or (d.Parent and (d.Parent:IsA("TextButton") or d.Parent:IsA("ImageButton")))
            
            -- HOẶC tên có chứa chữ "icon", "logo" và kích thước nhỏ (tránh ảnh to)
            local nameLower = (d.Name or ""):lower()
            local isSafeIcon = (nameLower:find("icon") or nameLower:find("logo") or nameLower:find("image")) and d.AbsoluteSize.X <= 150

            if isNotify or isBtn or isSafeIcon then
                -- Chặn không cho đổi ảnh của nhân vật/avatar to đùng
                if d.AbsoluteSize.X <= 200 and d.AbsoluteSize.Y <= 200 then
                    pcall(function() d.Image = THEME_IMAGE_ID end)
                    changeCount = changeCount + 1
                    _log("Image -> new:", d:GetFullName())
                end
            end
        end
    end
end

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

local function _themeHubGui(g)
    if not _isHubGui(g) then return end
    for _, d in ipairs(g:GetDescendants()) do
        pcall(_themeInstance, d, g)
    end
end

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

local function _hookParent(parent)
    parent.ChildAdded:Connect(function(g)
        if (g:IsA("ScreenGui") or g:IsA("LayerCollector")) and _isHubGui(g) then
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

task.spawn(function()
    while true do
        pcall(_scanOnce)
        task.wait(0.2)
    end
end)

-- ==== LOAD RAW ====
local SCRIPT_LOAD_STARTED = false
local function AutoLoadScript()
    if SCRIPT_LOAD_STARTED then return end
    SCRIPT_LOAD_STARTED = true

    pcall(Notify, "Duck Hub", "Dang tai hub...", 3)

    task.spawn(function()
        RAW_LOAD_TIME = tick()

        local ok, err = pcall(function()
            local loader = loadstring or load
            if type(loader) ~= "function" then error("no loadstring") end
            local src = game:HttpGet(SCRIPT_LINK)
            if type(src) ~= "string" or #src < 10 then error("download fail") end
            local fn = loader(src, "=DuckHubScript")
            if type(fn) ~= "function" then error("parse fail") end
            fn()
            RAW_LOAD_TIME = tick()
            _scanOnce()
        end)

        if not ok then
            SCRIPT_LOAD_STARTED = false
            pcall(Notify, "Duck Hub", "Loi tai hub: " .. tostring(err), 6)
        end
    end)
end

AutoLoadScript()

return
