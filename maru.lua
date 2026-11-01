-- DUCK HUB - ĐỔI TÊN + MÀU VÀNG - BẢN FIX CHẮC CHẮN LÊN
local url = "https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub.lua"
local code = game:HttpGet(url)

-- 1. ĐỔI TÊN TEDDY -> DUCK HUB (đổi trước khi chạy)
code = code:gsub("TeddyHub", "Duck Hub")
code = code:gsub("Teddy Hub", "Duck Hub")
code = code:gsub("Teddy", "Duck")
code = code:gsub("teddy", "duck")

-- 2. ĐỔI MÀU THÀNH VÀNG - tìm các mã màu chủ đạo và thay bằng vàng
-- Vàng gold: 255, 215, 0
code = code:gsub("Color3%.fromRGB%(%s*88%s*,%s*101%s*,%s*242%s*%)", "Color3.fromRGB(255, 215, 0)") -- màu xanh Fluent thường
code = code:gsub("Color3%.fromRGB%(%s*0%s*,%s*122%s*,%s*255%s*%)", "Color3.fromRGB(255, 215, 0)")
code = code:gsub("Color3%.fromRGB%(%s*170%s*,%s*170%s*,%s*255%s*%)", "Color3.fromRGB(255, 215, 0)")

-- 3. Nếu hub dùng hex màu
code = code:gsub("#5865F2", "#FFD700") -- xanh Discord -> vàng gold
code = code:gsub("#%x%x%x%x%x%x", function(hex)
    -- Giữ nguyên, chỉ đổi nếu là màu accent
    return hex
end)

-- Chạy hub đã đổi tên
local func, err = loadstring(code)
if func then
    func()
else
    warn("Lỗi load: "..tostring(err))
    -- fallback load gốc
    loadstring(game:HttpGet(url))()
end

-- 4. ĐỔI MÀU VÀNG + ẢNH NÚT Ở NGOÀI (sau khi UI đã tạo)
task.wait(2)

-- Chỗ để ảnh nút - BRO THAY ID Ở ĐÂY
getgenv().DuckButtonImage = "rbxassetid://132401977734278" -- <-- THAY ID ẢNH NÚT CON VỊT Ở ĐÂY

spawn(function()
    while task.wait(0.5) do
        pcall(function()
            for _, v in ipairs(game:GetService("CoreGui"):GetDescendants()) do
                -- Đổi tất cả text còn sót Teddy -> Duck Hub
                if v:IsA("TextLabel") and v.Text:lower():find("duck") == nil and v.Text:lower():find("teddy") then
                    v.Text = "Duck Hub"
                end
                if v:IsA("TextLabel") and v.Text == "Duck Hub" then
                    v.TextColor3 = Color3.fromRGB(255, 215, 0)
                end
                -- Đổi màu UIStroke sang vàng
                if v:IsA("UIStroke") then
                    v.Color = Color3.fromRGB(255, 215, 0)
                end
                -- Đổi ảnh nút
                if (v:IsA("ImageButton") or v:IsA("ImageLabel")) and v.Image ~= "" then
                    local n = v.Name:lower()
                    if n:find("logo") or n:find("icon") or n:find("button") or n:find("open") or v.AbsoluteSize.X < 100 then
                        if getgenv().DuckButtonImage ~= "rbxassetid://123456789" then
                            v.Image = getgenv().DuckButtonImage
                        end
                    end
                end
                -- Đổi background của header thành vàng
                if v:IsA("Frame") and v.Name:lower():find("header") or v.Name:lower():find("topbar") or v.Name:lower():find("title") then
                    if v.BackgroundColor3.B < 200 then -- nếu là màu tối/xanh thì đổi
                        -- v.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                    end
                end
            end
        end)
    end
end)

print("✅ Duck Hub - Màu vàng - Đã đổi tên xong!")
