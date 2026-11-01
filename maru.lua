-- ============================================================
-- DUCK HUB LOADER (NO KEY) - Hard Fixed (Chống spam ảnh + Khóa màu vàng)
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

            -- ẢNH TRONG NOTIFY
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

-- ==== THEME ENGINE (HARD FIX) ====
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

local function isHubGui(g)
    if not g or not g.Name then return false end
    if ROBLOX_GUI_BLACKLIST[g.Name] or _isOurGui(g) then return false end
    return true
end

local function _isPurple(c)
    if not c then return false end
    local r, g, b = c.R * 255, c.G * 255, c.B * 255
    -- Nhận diện mọi màu sắc có ánh xanh/tím
    if b > 60 and b >= r and b >= g then return true end
    if r > 100 and b > 100 and g < 80 then return true end
    return false
end

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

local function enforceTheme(d)
    if not d or not d.Parent then return end

    -- TEXT (Ép buộc mọi chữ thành màu vàng)
    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
        if type(d.Text) == "string" and d.Text ~= "" then
            local n = _replaceText(d.Text)
            if n ~= d.Text then
                d.Text = n
            end
        end
        if d.TextColor3 ~= THEME_GOLD then
            d.TextColor3 = THEME_GOLD
        end
    end

    -- BACKGROUND (Chỉ đổi nếu là màu tím)
    if d:IsA("Frame") or d:IsA("TextButton") or d:IsA("ImageButton") then
        if _isPurple(d.BackgroundColor3) then
            d.BackgroundColor3 = THEME_BG_DARK
        end
    end

    -- STROKE
    if d:IsA("UIStroke") and _isPurple(d.Color) then
        d.Color = THEME_GOLD
    end

    -- GRADIENT
    if d:IsA("UIGradient") and d.Color then
        local ks, ch = {}, false
        for _, kp in ipairs(d.Color.Keypoints) do
            local c = kp.Value
            if _isPurple(c) then c = THEME_GOLD_LIGHT; ch = true end
            ks[#ks + 1] = ColorSequenceKeypoint.new(kp.Time, c)
        end
        if ch then
            d.Color = ColorSequence.new(ks)
        end
    end

    -- IMAGE (CHỈ ĐỔI Ở NÚT BẤM)
    if (d:IsA("ImageLabel") or d:IsA("ImageButton")) and d.Image and d.Image ~= "" then
        if d.Image ~= THEME_IMAGE_ID then
            local isBtn = d:IsA("ImageButton")
            local isInsideBtn = d.Parent and (d.Parent:IsA("TextButton") or d.Parent:IsA("ImageButton"))
            -- Tránh đổi ảnh nền to đùng
            local isSmall = d.AbsoluteSize.X <= 150 and d.AbsoluteSize.Y <= 150

            if (isBtn or isInsideBtn) and isSmall then
                d.Image = THEME_IMAGE_ID
            end
        end
    end
end

-- Hook Property Changed để CHẶN script gốc ghi đè màu
local function hookInstance(d)
    enforceTheme(d)
    
    local function hookProp(prop)
        local ok, sig = pcall(function() return d:GetPropertyChangedSignal(prop) end)
        if ok and sig then
            sig:Connect(function()
                enforceTheme(d)
            end)
        end
    end

    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
        hookProp("Text")
        hookProp("TextColor3")
    elseif d:IsA("ImageLabel") or d:IsA("ImageButton") then
        hookProp("Image")
    elseif d:IsA("Frame") then
        hookProp("BackgroundColor3")
    elseif d:IsA("UIStroke") then
        hookProp("Color")
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

local function scanGui(g)
    if not isHubGui(g) then return end
    for _, d in ipairs(g:GetDescendants()) do
        pcall(hookInstance, d)
    end
    g.DescendantAdded:Connect(function(d)
        if isHubGui(g) then
            pcall(hookInstance, d)
        end
    end)
end

local function hookParent(parent)
    parent.ChildAdded:Connect(function(g)
        if (g:IsA("ScreenGui") or g:IsA("LayerCollector")) then
            scanGui(g)
        end
    end)
    for _, g in ipairs(parent:GetChildren()) do
        if (g:IsA("ScreenGui") or g:IsA("LayerCollector")) then
            scanGui(g)
        end
    end
end

for _, p in ipairs(_getAllParents()) do
    pcall(hookParent, p)
end

-- Backup Loop 1 giây/lần quét lại cho chắc
task.spawn(function()
    while true do
        task.wait(1)
        for _, parent in ipairs(_getAllParents()) do
            for _, g in ipairs(parent:GetChildren()) do
                if (g:IsA("ScreenGui") or g:IsA("LayerCollector")) and isHubGui(g) then
                    for _, d in ipairs(g:GetDescendants()) do
                        pcall(enforceTheme, d)
                    end
                end
            end
        end
    end
end)

-- ==== LOAD RAW ====
local SCRIPT_LOAD_STARTED = false
local function AutoLoadScript()
    if SCRIPT_LOAD_STARTED then return end
    SCRIPT_LOAD_STARTED = true

    pcall(Notify, "Duck Hub", "Dang tai hub...", 3)

    task.spawn(function()
        local ok, err = pcall(function()
            local loader = loadstring or load
            if type(loader) ~= "function" then error("no loadstring") end
            local src = game:HttpGet(SCRIPT_LINK)
            if type(src) ~= "string" or #src < 10 then error("download fail") end
            local fn = loader(src, "=DuckHubScript")
            if type(fn) ~= "function" then error("parse fail") end
            fn()
        end)

        if not ok then
            SCRIPT_LOAD_STARTED = false
            pcall(Notify, "Duck Hub", "Loi tai hub: " .. tostring(err), 6)
        end
    end)
end

AutoLoadScript()

return
