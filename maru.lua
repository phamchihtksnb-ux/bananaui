-- DUCK HUB - BLOX FRUITS
-- GOLD BRIGHT + HIDE OLD BRAND WHILE PATCHING
-- Khong bypass key system cua hub goc.

local HUB_URL = "https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/BloxFruits.lua"

local TITLE = "DUCK HUB"
local IMAGE = "rbxassetid://132401977734278"

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- GOLD BRIGHT THEME
local GOLD = Color3.fromRGB(255, 210, 35)
local GOLD_LIGHT = Color3.fromRGB(255, 245, 145)
local GOLD_BUTTON = Color3.fromRGB(180, 130, 10)
local GOLD_PANEL = Color3.fromRGB(55, 40, 8)
local GOLD_BACKGROUND = Color3.fromRGB(30, 24, 8)
local GOLD_TEXT = Color3.fromRGB(255, 250, 215)

local patched = {}
local originalEnabled = {}

local function getText(obj)
    local ok, value = pcall(function()
        return obj.Text
    end)

    if ok and type(value) == "string" then
        return value
    end
end

local function replaceText(obj)
    local txt = getText(obj)
    if not txt then return end

    local lower = string.lower(txt)

    if lower:find("teddyhub", 1, true)
    or lower:find("teddy hub", 1, true) then

        txt = txt:gsub("[Tt]eddy[Hh]ub", TITLE)
        txt = txt:gsub("[Tt]eddy [Hh]ub", TITLE)

        pcall(function()
            obj.Text = txt
        end)
    end

    if string.lower(txt):find("duck hub", 1, true) then
        pcall(function()
            obj.TextColor3 = GOLD
            obj.TextStrokeColor3 = GOLD_BUTTON
            obj.TextStrokeTransparency = 0.3
        end)
    end
end

local function isHub(gui)
    if not gui:IsA("ScreenGui") then
        return false
    end

    local name = string.lower(gui.Name)

    if name:find("teddy", 1, true)
    or name:find("blox", 1, true)
    or name:find("notify", 1, true) then
        return true
    end

    for _, obj in ipairs(gui:GetDescendants()) do
        local txt = getText(obj)

        if txt then
            local lower = string.lower(txt)

            if lower:find("teddyhub", 1, true)
            or lower:find("teddy hub", 1, true)
            or lower:find("blox fruits", 1, true) then
                return true
            end
        end
    end

    return false
end

local function patchObject(obj)

    replaceText(obj)

    -- BACKGROUND
    if obj:IsA("Frame")
    or obj:IsA("ScrollingFrame") then

        pcall(function()
            if obj.BackgroundTransparency < 1 then
                obj.BackgroundColor3 = GOLD_BACKGROUND
                obj.BorderSizePixel = 0
            end
        end)

    -- BUTTONS
    elseif obj:IsA("TextButton") then

        pcall(function()
            obj.BackgroundColor3 = GOLD_BUTTON
            obj.TextColor3 = GOLD_LIGHT
            obj.BorderSizePixel = 0
            obj.AutoButtonColor = true
        end)

    -- TEXT
    elseif obj:IsA("TextLabel") then

        pcall(function()
            if not string.lower(obj.Text):find("duck hub", 1, true) then
                obj.TextColor3 = GOLD_TEXT
            end
        end)

    elseif obj:IsA("TextBox") then

        pcall(function()
            obj.TextColor3 = GOLD_TEXT
            obj.BackgroundColor3 = GOLD_PANEL
        end)

    -- BORDER
    elseif obj:IsA("UIStroke") then

        pcall(function()
            obj.Color = GOLD
            obj.Transparency = 0
        end)
    end

    -- LOGO / BUTTON IMAGE
    if obj:IsA("ImageLabel")
    or obj:IsA("ImageButton") then

        local name = string.lower(obj.Name)

        local isLogo =
            name:find("logo", 1, true)
            or name:find("brand", 1, true)
            or name:find("hubicon", 1, true)

        local isTopLeft = false

        pcall(function()
            local pos = obj.AbsolutePosition
            local size = obj.AbsoluteSize

            isTopLeft =
                pos.X < 100
                and pos.Y < 75
                and size.X >= 12
                and size.Y >= 12
                and size.X <= 70
                and size.Y <= 70
        end)

        if isLogo or isTopLeft then
            pcall(function()
                obj.Image = IMAGE
                obj.ImageColor3 = Color3.new(1, 1, 1)
            end)
        end
    end
end

local function patchGui(gui)
    if not isHub(gui) then
        return false
    end

    for _, obj in ipairs(gui:GetDescendants()) do
        pcall(patchObject, obj)
    end

    if not patched[gui] then
        patched[gui] = true

        gui.DescendantAdded:Connect(function(obj)
            task.defer(function()
                pcall(patchObject, obj)
            end)
        end)
    end

    return true
end

-- WATCHER: BAT UI MOI TRONG LUC DOI TEN VA ANH
local function watch(root)

    root.DescendantAdded:Connect(function(obj)

        if not obj:IsA("ScreenGui") then
            return
        end

        if originalEnabled[obj] ~= nil then
            return
        end

        originalEnabled[obj] = obj.Enabled

        -- An tam thoi khi giao dien vua duoc tao.
        pcall(function()
            obj.Enabled = false
        end)

        task.defer(function()

            task.wait()

            local success = false

            for _ = 1, 12 do
                if not obj.Parent then
                    break
                end

                if patchGui(obj) then
                    success = true
                    break
                end

                task.wait(0.1)
            end

            if obj.Parent then
                if success then
                    obj.Enabled = originalEnabled[obj]
                else
                    obj.Enabled = originalEnabled[obj]
                end
            end

            originalEnabled[obj] = nil
        end)
    end)
end

-- CAI WATCHER TRUOC KHI LOAD HUB
watch(PlayerGui)
watch(CoreGui)

-- LOAD BLOX FRUITS
local success, err = pcall(function()

    local source = game:HttpGet(HUB_URL)
    local fn = loadstring(source)

    assert(type(fn) == "function", "Cannot load hub")

    fn()
end)

if not success then
    warn("[DUCK HUB] Load error: " .. tostring(err))
end

-- QUET UI LIEN TUC
task.spawn(function()

    for _ = 1, 120 do

        for _, root in ipairs({
            PlayerGui,
            CoreGui
        }) do

            local ok, descendants = pcall(function()
                return root:GetDescendants()
            end)

            if ok then
                for _, obj in ipairs(descendants) do

                    if obj:IsA("ScreenGui") then
                        pcall(patchGui, obj)
                    end
                end
            end
        end

        task.wait(0.5)
    end
end)

print("[DUCK HUB] GOLD BRIGHT LOADED")
