local function fix(s)
    for _, p in ipairs({
        {"BANANA CAT HUB","Duck Hub"},
        {"Banana Cat Hub","Duck Hub"},
        {"BANANA HUB","Duck Hub"},
        {"Banana Hub","Duck Hub"},
        {"BananaHub","DuckHub"},
        {"BANANA","DUCK"},
        {"Banana","Duck"},
        {"banana","duck"},
    }) do
        s = s:gsub(p[1]:gsub("%p","%%%0"), p[2])
    end
    return s
end

-- Doi chu trong moi script ma no tai them
if hookfunction then
    local old; old = hookfunction(game.HttpGet, function(self, url, ...)
        local r = old(self, url, ...)
        if typeof(r) == "string" and #r > 0 then return fix(r) end
        return r
    end)
end

-- Doi chu tren moi nhan UI hien ra
local function patch(o)
    if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then
        local function chk() if o.Text:lower():find("banana") then o.Text = fix(o.Text) end end
        chk(); o:GetPropertyChangedSignal("Text"):Connect(chk)
    end
end
local roots = {game:GetService("CoreGui"), game.Players.LocalPlayer:WaitForChild("PlayerGui")}
if gethui then table.insert(roots, gethui()) end
for _, r in ipairs(roots) do
    for _, d in ipairs(r:GetDescendants()) do patch(d) end
    r.DescendantAdded:Connect(patch)
end

loadstring(fix(game:HttpGet("https://vxezestudio.online/api/scripts/script_JJiynqcQCJ8Iu/stream/init")))()
