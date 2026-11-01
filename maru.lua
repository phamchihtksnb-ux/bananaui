getgenv().DuckCustom = {
    Title = "Duck Hub",
    NotifyName = "Duck Hub",
    ButtonImage = "rbxassetid://132401977734278", -- <--- ĐÂY LÀ CHỖ ĐỔI ẢNH NÚT
    Color = Color3.fromRGB(255, 215, 0) -- màu vàng
}

-- Load hub gốc
loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub.lua"))()

task.wait(1.5)

-- ĐỔI ẢNH NÚT BUTTON Ở NGOÀI
spawn(function()
    while task.wait(0.5) do
        pcall(function()
            for _, v in ipairs(game:GetService("CoreGui"):GetDescendants()) do
                -- Tìm nút mở menu (thường là ImageButton có tên Open, Toggle, Logo)
                if v:IsA("ImageButton") or v:IsA("ImageLabel") then
                    local name = v.Name:lower()
                    local parentName = v.Parent and v.Parent.Name:lower() or ""
                    -- Nếu tên chứa button, toggle, open, logo, icon, menu
                    if name:find("button") or name:find("toggle") or name:find("open") or name:find("logo") or name:find("icon") or parentName:find("button") or parentName:find("toggle") then
                        -- Chỉ đổi nếu ảnh cũ là của TeddyHub
                        if v.Image ~= "" and v.Image ~= getgenv().DuckCustom.ButtonImage then
                            v.Image = getgenv().DuckCustom.ButtonImage
                            print("[Duck Hub] Đã đổi ảnh nút: "..v.Name.." -> "..getgenv().DuckCustom.ButtonImage)
                        end
                    end
                    
                    -- Hoặc đổi tất cả ImageButton nhỏ (nút tròn mở menu thường size 40-60)
                    if v:IsA("ImageButton") and v.AbsoluteSize.X < 80 and v.AbsoluteSize.Y < 80 then
                        v.Image = getgenv().DuckCustom.ButtonImage
                    end
                end

                -- Đổi title + màu vàng như trước
                if v:IsA("TextLabel") and v.Text:lower():find("teddy") then
                    v.Text = v.Text:gsub("TeddyHub", "Duck Hub"):gsub("Teddy", "Duck Hub")
                    v.TextColor3 = getgenv().DuckCustom.Color
                end
                if
