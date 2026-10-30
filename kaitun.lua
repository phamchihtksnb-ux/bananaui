
-- Bỏ UI TeddyHub gốc ngay khi tạo
local function RemoveTeddyHubUI()
    pcall(function()
        for _, gui in pairs(game.CoreGui:GetChildren()) do
            if gui.Name:lower():find("teddy") then
                gui:Destroy()
            end
        end
        for _, gui in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
            if gui.Name:lower():find("teddy") then
                gui:Destroy()
            end
        end
    end)
end

-- Hook Instance.new để chặn tạo UI TeddyHub
local oldNew = Instance.new
Instance.new = function(className, parent)
    local obj = oldNew(className, parent)
    -- Nếu là UI của TeddyHub thì chặn
    task.spawn(function()
        task.wait(0.1)
        pcall(function()
            if parent and parent.Parent then
                local g = parent
                while g.Parent and g.Parent ~= game.CoreGui and g.Parent ~= game.Players.LocalPlayer.PlayerGui do
                    g = g.Parent
                end
                if g.Name:lower():find("teddy") then
                    g:Destroy()
                end
            end
        end)
    end)
    return obj
end

-- Load chức năng TeddyHub kaitun gốc (bỏ UI đi)
print("[TeddyHub] Đang lấy chức năng từ TeddyHub-kaitunBF.lua (bỏ UI)...")
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub-kaitunBF.lua"))()
end)

task.wait(1)

-- Bỏ UI và button TeddyHub sau khi load
RemoveTeddyHubUI()
Instance.new = oldNew -- khôi phục

-- Tạo UI Duck Hub cũ đỡ chói + Button Duck Hub kaitun
task.spawn(function()
    task.wait(1)
    pcall(function()
        local CoreGui = game:GetService("CoreGui")
        
        -- Xóa UI còn sót
        for _, gui in pairs(CoreGui:GetChildren()) do
            if gui.Name:lower():find("teddy") or gui.Name == "DuckHubOldUI" then
                gui:Destroy()
            end
        end
        
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "DuckHubOldUI"
        ScreenGui.Parent = CoreGui
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        -- Button Duck Hub kaitun 65x65 tròn trắng Banana style, drag toggle only
        local Button = Instance.new("ImageButton")
        Button.Name = "DuckHubKaitunButton"
        Button.Parent = ScreenGui
        Button.Size = UDim2.new(0, 65, 0, 65)
        Button.Position = UDim2.new(0, 10, 0, 10)
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- đỡ chói
        Button.BackgroundTransparency = 0.3
        Button.Image = "rbxassetid://132401977734278" -- Duck Hub kaitun button
        Button.Draggable = true
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = Button
        
        -- Main UI Duck Hub cũ đỡ chói
        local Main = Instance.new("Frame")
        Main.Name = "Main"
        Main.Parent = ScreenGui
        Main.Size = UDim2.new(0, 500, 0, 350)
        Main.Position = UDim2.new(0.5, -250, 0.5, -175)
        Main.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- đỡ chói không trắng chói
        Main.BackgroundTransparency = 0.3
        Main.Visible = false
        Main.Active = true
        Main.Draggable = true
        
        local MainCorner = Instance.new("UICorner")
        MainCorner.CornerRadius = UDim.new(0, 8)
        MainCorner.Parent = Main
        
        -- Title Duck Hub
        local Title = Instance.new("TextLabel")
        Title.Parent = Main
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Title.BackgroundTransparency = 0.3
        Title.Text = "Duck Hub Kaitun [ Free ]"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 18
        Title.Font = Enum.Font.GothamBold
        
        local TitleCorner = Instance.new("UICorner")
        TitleCorner.CornerRadius = UDim.new(0, 8)
        TitleCorner.Parent = Title
        
        -- Logo 3 cái: 2 shadow 6015897843 không đổi, chỉ đổi logo thứ 3
        local Logo1 = Instance.new("ImageLabel")
        Logo1.Parent = Main
        Logo1.Size = UDim2.new(0, 40, 0, 40)
        Logo1.Position = UDim2.new(0, 10, 0, 5)
        Logo1.BackgroundTransparency = 1
        Logo1.Image = "rbxassetid://6015897843" -- shadow không đổi
        
        local Logo2 = Instance.new("ImageLabel")
        Logo2.Parent = Main
        Logo2.Size = UDim2.new(0, 40, 0, 40)
        Logo2.Position = UDim2.new(0, 12, 0, 7)
        Logo2.BackgroundTransparency = 1
        Logo2.Image = "rbxassetid://6015897843" -- shadow không đổi
        
        local Logo3 = Instance.new("ImageLabel")
        Logo3.Parent = Main
        Logo3.Size = UDim2.new(0, 40, 0, 40)
        Logo3.Position = UDim2.new(0, 10, 0, 5)
        Logo3.BackgroundTransparency = 1
        Logo3.Image = "rbxassetid://132401977734278" -- Duck Hub kaitun
        
        -- Discord discord.gg/z77ytBbcgS
        local Discord = Instance.new("TextButton")
        Discord.Parent = Main
        Discord.Size = UDim2.new(0, 200, 0, 30)
        Discord.Position = UDim2.new(0, 10, 0, 50)
        Discord.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Discord.Text = "discord.gg/z77ytBbcgS"
        Discord.TextColor3 = Color3.fromRGB(255, 255, 255)
        Discord.TextSize = 14
        
        Discord.MouseButton1Click:Connect(function()
            setclipboard("https://discord.gg/z77ytBbcgS")
        end)
        
        -- Toggle không flicker
        local isOpen = false
        Button.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            Main.Visible = isOpen
        end)
        
        -- Fix: bỏ collect giữ store random
        pcall(function()
            if getgenv().Config and getgenv().Config.Items then
                getgenv().Config.Items.AutoCollectFruit = false
                getgenv().Config.Items.AutoRandomFruit = true
                getgenv().Config.Items.AutoStoreFruit = true
            end
            if _G.Config and _G.Config.Items then
                _G.Config.Items.AutoCollectFruit = false
                _G.Config.Items.AutoRandomFruit = true
                _G.Config.Items.AutoStoreFruit = true
            end
        end)
        
        -- Loop xóa UI TeddyHub liên tục để đảm bảo chỉ lấy chức năng
        task.spawn(function()
            while true do
                task.wait(1)
                RemoveTeddyHubUI()
            end
        end)
        
        print("[FINAL] Đã lấy chức năng TeddyHub kaitun (bỏ UI đi) + ghép UI Duck Hub cũ đỡ chói + button Duck Hub kaitun")
        print("[FINAL] Bỏ collect giữ store random")
    end)
end)

