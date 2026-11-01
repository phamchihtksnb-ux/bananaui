local function fix(s)
    for _, p in ipairs({
        {"Trash Hub","Duck Hub"},{"TRASH HUB","DUCK HUB"},{"trash hub","duck hub"},
        {"TrashHub","DuckHub"},{"Trash","Duck"},{"TRASH","DUCK"},{"trash","duck"},
    }) do
        s = s:gsub(p[1]:gsub("%p","%%%0"), p[2])
    end
    return s
end

-- 1) Đổi chữ trong mọi script mà nó tải thêm (giữ nguyên link, chỉ sửa nội dung trả về)
local oldHttpGet; oldHttpGet = hookfunction(game.HttpGet, function(self, url, ...)
    local r = oldHttpGet(self, url, ...)
    if typeof(r) == "string" and #r > 0 and not url:find("%.png") then
        return fix(r)
    end
    return r
end)

-- 2) Đổi chữ trên mọi nhãn UI hiện ra, kể cả cái tạo sau
local function patch(o)
    if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then
        if o.Text:lower():find("trash") then o.Text = fix(o.Text) end
        o:GetPropertyChangedSignal("Text"):Connect(function()
            if o.Text:lower():find("trash") then o.Text = fix(o.Text) end
        end)
    end
end
local roots = {game:GetService("CoreGui"), game.Players.LocalPlayer:WaitForChild("PlayerGui")}
if gethui then table.insert(roots, gethui()) end
for _, r in ipairs(roots) do
    for _, d in ipairs(r:GetDescendants()) do patch(d) end
    r.DescendantAdded:Connect(patch)
end

loadstring(fix(game:HttpGet("https://raw.githubusercontent.com/scriptbloxfruit/Trash-Hub/refs/heads/main/KaitunHalloween")))()
