-- HOP BOSS CUSTOM - FLUENT UI - DOI TEN + SUBTITLE + ICON - [KHONG CAT CODE]
-- Loader: loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/HopBoss.lua"))()

--------------- CAU HINH CHUNG - THAY O DAY ----------------
local TEN_MOI    = "NoiJo Hop Boss"   -- Ten hub moi
local SUBTITLE_MOI = "Gold Edition - No Key"  -- Subtitle moi
local PRESET     = "gold"    -- "gold" | "dark" | "neon" | "light" | "ocean"

-- ICON: ID rbxassetid
local ID_LOGO    = "132401977734278"   -- Icon logo tren title
local ID_BUTTON  = "132401977734278"   -- Icon nut tron bat/tat
local SCALE      = "Fit"              -- "Fit" | "Crop"

local TEN_ICON_LOGO   = ""            -- De trong = tu tim
local TEN_ICON_BUTTON = ""
-----------------------------------------------

print("[HopBoss Custom] Dang tai HopBoss.lua...")
-- Tai hub goc truoc
local ok, result = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/HopBoss.lua")
end)

if ok and result then
    print("[HopBoss Custom] Tai duoc, length:", #result)
    -- Patch ten truoc khi chay (neu la code khong obfuscate)
    -- Vi file nay obfuscated Luraph nen patch string kho, se dung theme applier sau
    local func, err = loadstring(result)
    if func then
        task.spawn(function()
            pcall(func)
        end)
        print("[HopBoss Custom] Hub da chay")
    else
        warn("[HopBoss Custom] loadstring fail:", err)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/HopBoss.lua"))()
    end
else
    warn("[HopBoss Custom] Tai that bai, thu load truc tiep")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/HopBoss.lua"))()
end

task.wait(2) -- Doi hub len

-- ============ THEME + DOI TEN + ICON - FLUENT UI ============
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local pg  = plr:WaitForChild("PlayerGui")

local THEMES = {
    gold = {
        Nen    = Color3.fromRGB(22, 18, 10),
        NenPhu = Color3.fromRGB(34, 29, 17),
        The    = Color3.fromRGB(46, 40, 23),
        Nut    = Color3.fromRGB(64, 55, 31),
        Viet   = Color3.fromRGB(255, 201, 64),
        An     = Color3.fromRGB(255, 184, 0),
        Chu    = Color3.fromRGB(255, 248, 231),
        ChuPhu = Color3.fromRGB(255, 210, 74),
        Goc    = UDim.new(0, 10),
        Font   = Font.fromEnum(Enum.Font.GothamBold),
    },
    dark = {
        Nen    = Color3.fromRGB(18, 18, 24),
        NenPhu = Color3.fromRGB(28, 28, 38),
        The    = Color3.fromRGB(36, 36, 48),
        Nut    = Color3.fromRGB(48, 48, 64),
        Viet   = Color3.fromRGB(120, 120, 140),
        An     = Color3.fromRGB(0, 170, 255),
        Chu    = Color3.fromRGB(235, 235, 242),
        ChuPhu = Color3.fromRGB(140, 140, 155),
        Goc    = UDim.new(0, 6),
        Font   = nil,
    },
}

local T       = THEMES[PRESET] or THEMES.gold
local TAG     = "HopBossCustomDone"

-- Tu khoa de tim hub - them nhieu tu khoa HopBoss
local KHOA = {
    "HopBoss", "Hop Boss", "TeddyHub", "Teddy Hub", "DiepVy", 
    "RealKid", "Nousigi", "Hop Farm", "Boss", "Teddy",
    "Server Uptime", "Search", "Stack Farming"
}

-- Tu khoa ten cu can doi
local TEN_CU_LIST = {"HopBoss", "Hop Boss", "TeddyHub", "Teddy Hub", "Teddy", "DiepVy"}

local function doiTen(txt)
    if type(txt) ~= "string" then return txt, false end
    local moi = txt
    local doi = false
    for _, tenCu in ipairs(TEN_CU_LIST) do
        if moi:find(tenCu, 1, true) then
            moi = moi:gsub(tenCu, TEN_MOI)
            doi = true
        end
    end
    -- Doi subtitle
    if moi:find("Hop", 1, true) or moi:find("Boss", 1, true) or #moi < 50 then
        -- Co the la subtitle
        if SUBTITLE_MOI and SUBTITLE_MOI ~= "" then
            -- Neu text ngan va giong subtitle thi doi
            if #moi < 100 and (moi:lower():find("hub") or moi:lower():find("boss") or moi:lower():find("hop") or moi:lower():find("teddy")) then
                -- Giu lai neu la title, doi neu la subtitle
                -- Check neu co tu khoa subtitle
                if moi:len() > 5 and moi:len() < 60 then
                    -- Doi thanh subtitle moi neu la subtitle cu
                end
            end
        end
    end
    return moi, doi
end

local function doiSubtitle(txt)
    if type(txt) ~= "string" then return txt, false end
    -- Tim subtitle - thuong la text nho duoi title
    if #txt > 3 and #txt < 80 then
        if txt:find("Boss",1,true) or txt:find("Hop",1,true) or txt:find("Teddy",1,true) or txt:find("Hub",1,true) then
            return SUBTITLE_MOI, true
        end
    end
    return txt, false
end

local function laMauNhan(c)
    local mx = math.max(c.R, c.G, c.B)
    local mn = math.min(c.R, c.G, c.B)
    return (mx - mn) > 0.30 and mx > 0.40
end

local function nenTuMau(c)
    if laMauNhan(c) then return T.An end
    local lum = 0.299*c.R + 0.587*c.G + 0.114*c.B
    if lum > 0.55 then return T.The end
    if lum > 0.22 then return T.NenPhu end
    return T.Nen
end

local function apply(v)
    local class = v.ClassName
    local laGD = v:IsA("GuiObject")
    if not laGD and class ~= "UICorner" and class ~= "UIStroke" and class ~= "UIGradient" then return end
    if v:GetAttribute(TAG) then return end
    v:SetAttribute(TAG, true)

    if class == "TextLabel" or class == "TextButton" or class == "TextBox" then
        local ok, txt = pcall(function() return v.Text end)
        if ok and txt and type(txt)=="string" and #txt>0 then
            -- Doi ten
            local moi, dcDoi = doiTen(txt)
            if dcDoi then pcall(function() v.Text = moi end) txt = moi end
            
            -- Doi subtitle - neu text nho va o gan title
            if v.TextTransparency and v.TextSize and v.TextSize < 18 then
                -- Co the la subtitle
                if txt:len() < 60 and txt:len() > 3 then
                    -- Check parent co title khong
                    local parent = v.Parent
                    if parent then
                        for _, sibling in ipairs(parent:GetChildren()) do
                            if sibling ~= v and sibling:IsA("TextLabel") and sibling.TextSize and sibling.TextSize > v.TextSize then
                                -- Day la subtitle
                                if SUBTITLE_MOI and SUBTITLE_MOI ~= "" then
                                    pcall(function() v.Text = SUBTITLE_MOI end)
                                end
                                break
                            end
                        end
                    end
                end
            end
        end

        -- Doi mau chu
        pcall(function()
            if laMauNhan(v.TextColor3) then
                v.TextColor3 = T.An
            else
                if class == "TextButton" then
                    v.TextColor3 = T.ChuPhu
                else
                    v.TextColor3 = T.Chu
                end
            end
            if T.Font then v.FontFace = T.Font end
        end)

        if v.BackgroundTransparency < 1 then
            pcall(function()
                local bgGoc = v.BackgroundColor3
                local nenNhan = laMauNhan(bgGoc)
                if class == "TextButton" then
                    v.BackgroundColor3 = nenNhan and T.An or T.Nut
                    if nenNhan then v.TextColor3 = T.Nen end
                else
                    v.BackgroundColor3 = nenTuMau(bgGoc)
                end
                v.BorderSizePixel = 0
            end)
        end

    elseif class == "Frame" or class == "ScrollingFrame" then
        pcall(function()
            if v.BackgroundTransparency < 1 then
                v.BackgroundColor3 = nenTuMau(v.BackgroundColor3)
                v.BorderSizePixel  = 0
            end
            if class == "ScrollingFrame" then
                v.ScrollBarImageColor3 = T.An
                v.ScrollBarThickness   = 4
            end
        end)

    elseif class == "ImageLabel" or class == "ImageButton" then
        pcall(function()
            if v.BackgroundTransparency < 1 then
                v.BackgroundColor3 = nenTuMau(v.BackgroundColor3)
                v.BorderSizePixel  = 0
            end
        end)

    elseif class == "UICorner" then
        v.CornerRadius = T.Goc
    elseif class == "UIStroke" then
        v.Color = T.Viet
    end
end

local roots = { pg }
do
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then table.insert(roots, cg) end
end

local function laHub(gui)
    if not gui:IsA("ScreenGui") then return false end
    -- Check ten gui
    if gui.Name:lower():find("hop") or gui.Name:lower():find("teddy") or gui.Name:lower():find("boss") or gui.Name:lower():find("fluent") then
        return true
    end
    for _, v in ipairs(gui:GetDescendants()) do
        local ok, txt = pcall(function() return v.Text end)
        if ok and type(txt) == "string" and #txt > 0 then
            for _, k in ipairs(KHOA) do
                if txt:find(k, 1, true) then return true end
            end
        end
    end
    return false
end

local cacHub = {}

local function theme(gui)
    for _, v in ipairs(gui:GetDescendants()) do
        pcall(apply, v)
    end
    gui.DescendantAdded:Connect(function(v)
        task.defer(function() pcall(apply, v) end)
    end)
end

local function quet()
    for _, root in ipairs(roots) do
        local ok, ds = pcall(function() return root:GetDescendants() end)
        if ok and ds then
            for _, g in ipairs(ds) do
                if g:IsA("ScreenGui") and laHub(g) and not cacHub[g] then
                    table.insert(cacHub, g)
                    cacHub[g] = true
                    theme(g)
                    print(("[HopBoss Custom] Theme '%s' -> %s"):format(PRESET, g.Name))
                end
            end
        end
    end
end

-- Quet lien tuc
task.spawn(function()
    for _ = 1, 90 do
        pcall(quet)
        if #cacHub > 0 then
            -- Doi them 2s de chac chan hub load het
            task.wait(2)
            pcall(quet)
            break
        end
        task.wait(0.5)
    end
    if #cacHub == 0 then
        warn("[HopBoss Custom] KHONG tim thay hub - thu quet lai sau 3s")
        task.wait(3)
        pcall(quet)
    end
end)

-- Loop doi ten lien tuc - Fluent UI doi ten lien tuc
task.spawn(function()
    local sach = 0
    for _ = 1, 240 do
        task.wait(1.5)
        local daDoi = 0
        for _, gui in ipairs(cacHub) do
            for _, v in ipairs(gui:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextButton") then
                    local ok, txt = pcall(function() return v.Text end)
                    if ok and txt and type(txt)=="string" and #txt>0 then
                        local moi, dcDoi = doiTen(txt)
                        if dcDoi then 
                            pcall(function() v.Text = moi end) 
                            daDoi = daDoi + 1 
                        end
                        -- Doi subtitle - tim text nho
                        if v.TextSize and v.TextSize <= 16 and #txt < 60 and #txt > 3 then
                            -- Check co phai subtitle khong
                            if txt:find("Teddy",1,true) or txt:find("Hop",1,true) or txt:find("Boss",1,true) or txt:lower():find("hub") then
                                if SUBTITLE_MOI and SUBTITLE_MOI ~= "" and txt ~= SUBTITLE_MOI and txt ~= TEN_MOI then
                                    -- Chi doi neu khong phai title
                                    if not (txt == TEN_MOI) then
                                        pcall(function() v.Text = SUBTITLE_MOI end)
                                        daDoi = daDoi + 1
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if daDoi > 0 then sach = 0 else sach = sach + 1 if sach >= 15 then break end end
    end
end)

-- ============ DOI ICON - NUT BUTTON + LOGO ============
local SC = Enum.ScaleType[SCALE] or Enum.ScaleType.Fit
local function urlOf(id) return "rbxassetid://" .. tostring(id) end

local function apIcon(img, id)
    local url = urlOf(id)
    local ok, kq = pcall(function()
        if img:IsA("ImageLabel") or img:IsA("ImageButton") then
            local cu = img.Image
            img.Image = url
            img.ImageColor3 = Color3.new(1, 1, 1)
            img.ScaleType = SC
            return ("anh: %s -> %s"):format(tostring(cu), url)
        elseif img:IsA("TextLabel") or img:IsA("TextButton") then
            -- Tao ImageLabel con
            local cu = img.Text
            local con = img:FindFirstChild("CustomIcon")
            if not con then
                con = Instance.new("ImageLabel")
                con.Name = "CustomIcon"
                con.BackgroundTransparency = 1
                con.Size     = UDim2.fromScale(1, 1)
                con.Position = UDim2.fromScale(0, 0)
                con.ZIndex   = (img.ZIndex or 1) + 1
                con.Parent   = img
            end
            con.Image = url
            con.ImageColor3 = Color3.new(1, 1, 1)
            con.ScaleType = SC
            pcall(function() img.Text = "" end)
            return ("chu -> anh")
        end
        return "lop khong ho tro"
    end)
    if ok then return kq else return "LOI: " .. tostring(kq) end
end

local function layAnhNho(gui)
    local kq = {}
    local ok, ds = pcall(function() return gui:GetDescendants() end)
    if ok and ds then
        for _, v in ipairs(ds) do
            if v:IsA("ImageLabel") or v:IsA("ImageButton") then
                local ok2, sz = pcall(function() return v.AbsoluteSize end)
                if ok2 and sz.X <= 120 and sz.Y <= 120 and sz.X >= 10 then
                    table.insert(kq, v)
                end
            end
        end
    end
    return kq
end

local function khoangGocTraiTren(v)
    local ok, ap = pcall(function() return v.AbsolutePosition end)
    if not ok then return math.huge end
    return math.abs(ap.X) + math.abs(ap.Y)
end

local dsChay = {}
task.spawn(function()
    for _ = 1, 80 do if #cacHub > 0 then break end task.wait(0.5) end
    if #cacHub == 0 then warn("[HopBoss ICON] khong tim thay hub"); return end
    task.wait(2) -- Doi hub load xong
    
    for _, gui in ipairs(cacHub) do
        -- Tim nut button tron (thuong ten la Button, Toggle, Open, Close)
        local allImgs = layAnhNho(gui)
        -- Sort theo vi tri - logo o goc trai tren, nut o giua hoac goc
        table.sort(allImgs, function(a,b) return khoangGocTraiTren(a) < khoangGocTraiTren(b) end)
        
        if #allImgs > 0 then
            -- Logo la anh dau tien (goc trai tren)
            local logo = allImgs[1]
            print("[HopBoss ICON] LOGO:", logo.Name, apIcon(logo, ID_LOGO))
            table.insert(dsChay, {img=logo, id=ID_LOGO})
            
            -- Nut button la anh thu 2 hoac anh co ten Button/Toggle
            for _, v in ipairs(gui:GetDescendants()) do
                if v:IsA("ImageButton") or (v:IsA("ImageLabel") and v.Name:lower():find("button")) then
                    if v ~= logo then
                        print("[HopBoss ICON] BUTTON:", v.Name, apIcon(v, ID_BUTTON))
                        table.insert(dsChay, {img=v, id=ID_BUTTON})
                        break
                    end
                end
            end
            -- Neu khong tim thay button thi lay anh thu 2
            if #allImgs >= 2 and #dsChay < 2 then
                local btn = allImgs[2]
                print("[HopBoss ICON] BUTTON (anh thu 2):", btn.Name, apIcon(btn, ID_BUTTON))
                table.insert(dsChay, {img=btn, id=ID_BUTTON})
            end
        end
    end
    print(("[HopBoss ICON] Da ap dung %d icon (Scale=%s)"):format(#dsChay, SCALE))
end)

-- Giu icon khong bi doi lai
task.spawn(function()
    for _ = 1, 40 do
        task.wait(2)
        for _, d in ipairs(dsChay) do
            pcall(function()
                if d.img:IsA("ImageLabel") or d.img:IsA("ImageButton") then
                    if d.img.Image ~= urlOf(d.id) then d.img.Image = urlOf(d.id) end
                end
            end)
        end
    end
end)

print("[HopBoss Custom] Loaded - Ten:", TEN_MOI, "Sub:", SUBTITLE_MOI, "Icon:", ID_LOGO)
print("[HopBoss Custom] Fluent UI - Gold Edition")

