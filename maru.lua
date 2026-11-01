-- Chay script GOC (khong sua code, khong hook)
task.spawn(function()
    loadstring(game:HttpGet("https://vxezestudio.online/api/scripts/script_JJiynqcQCJ8Iu/stream/init"))()
end)

-- Doi chu tren giao dien, khong phan biet hoa/thuong, giu kieu viet hoa
local function ci(p) return (p:gsub("%a", function(c) return "[" .. c:lower() .. c:upper() .. "]" end)) end
local PAIRS = {
    {ci("banana cat hub"), "Duck Hub", "DUCK HUB"},
    {ci("banana hub"),     "Duck Hub", "DUCK HUB"},
    {ci("bananahub"),      "DuckHub",  "DUCKHUB"},
    {ci("banana"),         "Duck",     "DUCK"},
}
local function fix(t)
    local up = (t == t:upper())
    for _, p in ipairs(PAIRS) do
        t = t:gsub(p[1], up and p[3] or p[2])
    end
    return t
end

local seen = setmetatable({}, {__mode = "k"})
local function patch(o)
    if seen[o] then return end
    local ok, isText = pcall(function() return o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") end)
    if not (ok and isText) then return end
    seen[o] = true
    local function chk()
        pcall(function()
            local t = o.Text
            if t:lower():find("banana", 1, true) then
                local n = fix(t)
                if n ~= t then o.Text = n end
            end
        end)
    end
    chk()
    pcall(function() o:GetPropertyChangedSignal("Text"):Connect(chk) end)
end

local function scan(list) for _, d in ipairs(list) do patch(d) end end

task.spawn(function()
    while true do
        pcall(function()
            scan(game:GetDescendants())                         -- gom ca CoreGui/PlayerGui neu truy cap duoc
            if gethui then scan(gethui():GetDescendants()) end   -- GUI an cua executor
            if getnilinstances then scan(getnilinstances()) end  -- GUI khong co parent
        end)
        task.wait(1)
    end
end)
