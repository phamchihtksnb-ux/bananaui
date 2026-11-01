-- DUCK HUB - TEDDYHUB BLOX FRUITS
-- Gold Theme + Custom Logo

local HUB_URL = "https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/BloxFruits.lua"

local DUCK_IMAGE = "rbxassetid://132401977734278"
local NEW_TITLE = "DUCK HUB"

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function safeGetText(obj)
    local ok, value = pcall(function()
        return obj.Text
    end)
    return ok and type(value) == "string" and value or nil
end

local function isBrandText(value)
    local lower = string.lower(value)
    return lower:find("teddyhub", 1, true)
        or lower:find("teddy hub", 1, true)
end

local function replaceBrandText(obj)
    local value = safeGetText(obj)
    if not value then return end

    if isBrandText(value) then
        pcall(function()
            obj.Text = value:gsub("[Tt]eddy[Hh]ub", NEW_TITLE)
                :gsub("[Tt]eddy [Hh]ub", NEW_TITLE)
        end)
    end
end

local function hasNamePart(obj, parts)
    local name = string.lower(obj.Name)

    for _, part in ipairs(parts) do
        if name:find(part, 1, true) then
            return true
        end
    end

    return false
end

local function isTargetGui(gui)
    if not gui:IsA("ScreenGui") then
        return false
    end

    if hasNamePart(gui, {
        "teddy", "notification", "notify"
    }) then
        return true
    end

    for _, item in ipairs(gui:GetDescendants()) do
        local value = safeGetText(item)

        if value and isBrandText(value) then
            return true
        end
    end

    return false
end

local function patchGui(gui)
    if not isTargetGui(gui) then return end

    for _, item in ipairs(gui:GetDescendants()) do
        replaceBrandText(item)

        -- GOLD THEME
        if item:IsA("Frame")
        or item:IsA("ScrollingFrame") then

            pcall(function()
                item.BackgroundColor3 =
                    Color3.fromRGB(28, 23, 12)
                item.BorderSizePixel = 0
            end)

        elseif item:IsA("TextButton") then

            pcall(function()
                item.BackgroundColor3 =
                    Color3.fromRGB(75, 59, 22)

                item.TextColor3 =
                    Color3.fromRGB(255, 224, 130)

                item.BorderSizePixel = 0
            end)

        elseif item:IsA("TextLabel")
        or item:IsA("TextBox") then

            pcall(function()
                item.TextColor3 =
                    Color3.fromRGB(255, 239, 190)
            end)

        elseif item:IsA("UIStroke") then

            pcall(function()
                item.Color =
                    Color3.fromRGB(230, 177, 45)
            end)
        end

        -- CUSTOM IMAGE
        if item:IsA("ImageLabel")
        or item:IsA("ImageButton") then

            if hasNamePart(item, {
                "logo",
                "icon",
                "button",
                "notify",
                "notification"
            }) then

                pcall(function()
                    item.Image = DUCK_IMAGE
                    item.ImageColor3 = Color3.new(1, 1, 1)
                end)
            end
        end
    end

    gui.DescendantAdded:Connect(function(item)
        task.defer(function()
            pcall(function()
                replaceBrandText(item)

                if (item:IsA("ImageLabel")
                or item:IsA("ImageButton"))
                and hasNamePart(item, {
                    "logo",
                    "icon",
                    "button",
                    "notify",
                    "notification"
                }) then

                    item.Image = DUCK_IMAGE
                    item.ImageColor3 = Color3.new(1, 1, 1)
                end
            end)
        end)
    end)
end

-- LOAD ORIGINAL BLOX FRUITS HUB
-- Does not bypass key system.

local ok, err = pcall(function()
    local source = game:HttpGet(HUB_URL)
    local chunk = loadstring(source)

    assert(type(chunk) == "function",
        "Cannot compile BloxFruits.lua")

    chunk()
end)

if not ok then
    warn("[DUCK HUB] Load error: " .. tostring(err))
end

-- SCAN UI
task.spawn(function()
    local CoreGui = game:GetService("CoreGui")

    for _ = 1, 90 do
        for _, root in ipairs({
            playerGui,
            CoreGui
        }) do

            local okDesc, descendants =
                pcall(function()
                    return root:GetDescendants()
                end)

            if okDesc then
                for _, item in ipairs(descendants) do
                    if item:IsA("ScreenGui") then
                        pcall(patchGui, item)
                    end
                end
            end
        end

        task.wait(0.5)
    end
end)

print("[DUCK HUB] Gold Theme Loaded!")
