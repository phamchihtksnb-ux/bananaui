-- ============================================================
-- DUCK HUB LOADER (NO KEY) — theme tự động + load raw
-- ============================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- ==== LINK RAW (tách để tránh lộ string search) ====
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

-- ==== NOTIFICATION ĐƠN GIẢN ====
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
            message.TextColor3 = Color3.fromRGB(235, 225, 180)
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
local _ThemePlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local function _isPurple(c)
    if not c then return false end
    local r, g, b = c.R * 255, c.G * 255, c.B * 255
    return b > 80 and r > 60 and g < math.min(r, b) * 0.75
end

local function _themeInstance(d)
    if not d or not d.Parent then return end

    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
        if type(d.Text) == "string" and d.Text ~= "" then
            local n = d.Text:gsub("Teddy", "Duck"):gsub("TEDDY", "DUCK"):gsub("teddy", "duck")
            if n ~= d.Text then pcall(function() d.Text = n end) end
        end
        if d.TextColor3 and _isPurple(d.TextColor3) then
            pcall(function() d.TextColor3 = THEME_GOLD end)
        end
    end

    if d:IsA("Frame") or d:IsA("TextButton") or d:IsA("ImageButton") then
        if d.BackgroundColor3 and _isPurple(d.BackgroundColor3) then
            pcall(function() d.BackgroundColor3 = THEME_BG_DARK end)
        end
    end

    if d:IsA("UIStroke") and d.Color and _isPurple(d.Color) then
        pcall(function() d.Color = THEME_GOLD end)
    end

    if d:IsA("UIGradient") and d.Color then
        local ks, ch = {}, false
        for _, kp in ipairs(d.Color.Keypoints) do
            local c = kp.Value
            if _isPurple(c) then c = THEME_GOLD_LIGHT; ch = true end
            ks[#ks + 1] = ColorSequenceKeypoint.new(kp.Time, c)
        end
        if ch then pcall(function() d.Color = ColorSequence.new(ks) end) end
    end

    if (d:IsA("ImageLabel") or d:IsA("ImageButton")) and d.Image and d.Image ~= "" then
        local sx = d.AbsoluteSize.X
        if sx > 0 and sx <= 100 then
            pcall(function() d.Image = THEME_IMAGE_ID end)
        end
    end
end

local function _themeGui(g)
    if not g or not g.Parent then return end
    for _, d in ipairs(g:GetDescendants()) do pcall(_themeInstance, d) end
end

local function _isOurGui(g)
    return g.Name == "DuckNotifyGui" or g.Name == "NotificationHolder"
        or g.Name == "KeySystemGui"
end

local function _scanAll()
    for _, g in ipairs(_ThemePlayerGui:GetChildren()) do
        if g:IsA("ScreenGui") and not _isOurGui(g) then
            _themeGui(g)
        end
    end
end

-- Hook TRƯỚC khi load raw
for _, g in ipairs(_ThemePlayerGui:GetChildren()) do
    if g:IsA("ScreenGui") and not _isOurGui(g) then
        _themeGui(g)
        g.DescendantAdded:Connect(function(d) pcall(_themeInstance, d) end)
    end
end

_ThemePlayerGui.ChildAdded:Connect(function(g)
    if g:IsA("ScreenGui") and not _isOurGui(g) then
        _themeGui(g)
        g.DescendantAdded:Connect(function(d) pcall(_themeInstance, d) end)
    end
end)

-- Loop 60fps 6 giây đầu để bắt mọi thứ ngay frame đầu
task.spawn(function()
    local t0 = os.clock()
    while os.clock() - t0 < 6 do
        _scanAll()
        task.wait()
    end
    while task.wait(2) do _scanAll() end
end)

-- ==== LOAD RAW ====
local SCRIPT_LOAD_STARTED = false
local function AutoLoadScript()
    if SCRIPT_LOAD_STARTED then return end
    SCRIPT_LOAD_STARTED = true

    pcall(Notify, "DUCK Hub", "Dang tai hub...", 3)

    task.spawn(function()
        local ok = pcall(function()
            local loader = loadstring or load
            if type(loader) ~= "function" then error("no loadstring") end
            local src = game:HttpGet(SCRIPT_LINK)
            if type(src) ~= "string" or #src < 10 then error("download fail") end
            local fn = loader(src, "=DuckHubScript")
            if type(fn) ~= "function" then error("parse fail") end
            fn()
            _scanAll()
        end)

        if not ok then
            SCRIPT_LOAD_STARTED = false
            warn("[DUCK Hub] AutoLoadScript failed")
            pcall(Notify, "DUCK Hub", "Loi tai hub. Lien he admin.", 6)
        end
    end)
end

AutoLoadScript()

return
