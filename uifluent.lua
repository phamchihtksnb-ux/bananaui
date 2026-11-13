local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Maru Hub Premium",
    SubTitle = "Blox Fruits",
    TabWidth = 170,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- ===== LOGO WINEX GÓC TRÊN BÊN TRÁI =====
local LogoBG = Instance.new("Frame")
LogoBG.Name = "LogoBackground"
LogoBG.Size = UDim2.fromOffset(160, 54)
LogoBG.Position = UDim2.fromOffset(10, 34)
LogoBG.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
LogoBG.BorderSizePixel = 0
LogoBG.ZIndex = 9
LogoBG.Parent = Window.Root

local BGCorner = Instance.new("UICorner")
BGCorner.CornerRadius = UDim.new(0, 8)
BGCorner.Parent = LogoBG

local Logo = Instance.new("ImageLabel")
Logo.Name = "WinexLogo"
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://86158935865051"
Logo.Size = UDim2.new(1, -12, 1, -12)
Logo.Position = UDim2.fromOffset(6, 6)
Logo.ScaleType = Enum.ScaleType.Fit
Logo.ZIndex = 10
Logo.Parent = LogoBG

-- ===== NÚT VUÔNG BO GÓC CÓ ẢNH =====
local SquareButton = Instance.new("ImageButton")
SquareButton.Name = "SquareButton"
SquareButton.Size = UDim2.fromOffset(44, 44)
SquareButton.Position = UDim2.fromOffset(10, 100)
SquareButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SquareButton.BorderSizePixel = 0
SquareButton.Image = "rbxassetid://86158935865051"
SquareButton.ScaleType = Enum.ScaleType.Fit
SquareButton.AutoButtonColor = true
SquareButton.ZIndex = 10
SquareButton.Parent = Window.Root

local SquareCorner = Instance.new("UICorner")
SquareCorner.CornerRadius = UDim.new(0, 10)
SquareCorner.Parent = SquareButton

local SquareStroke = Instance.new("UIStroke")
SquareStroke.Color = Color3.fromRGB(255, 255, 255)
SquareStroke.Thickness = 1
SquareStroke.Transparency = 0.7
SquareStroke.Parent = SquareButton

SquareButton.MouseButton1Click:Connect(function()
    print("Nút vuông được bấm")
end)

-- ===== TABS =====
local Tabs = {
    SeaEvent = Window:AddTab({ Title = "Sea Event", Icon = "waves" }),
    Raid     = Window:AddTab({ Title = "Raid", Icon = "swords" }),
    Location = Window:AddTab({ Title = "Location", Icon = "map-pin" }),
    Fruit    = Window:AddTab({ Title = "Fruit", Icon = "apple" }),
    Shop     = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    PvP      = Window:AddTab({ Title = "PvP", Icon = "user" }),
}

-- ===== NỘI DUNG TAB PVP =====
Tabs.PvP:AddToggle("Fly", { Title = "Fly", Default = false }):OnChanged(function(v)
    print("Fly:", v)
end)

Tabs.PvP:AddSection("Aura")
Tabs.PvP:AddToggle("DamageAura", { Title = "Damage Aura", Default = false }):OnChanged(function(v)
    print("Damage Aura:", v)
end)
Tabs.PvP:AddToggle("KillAura", { Title = "Kill Aura", Default = false }):OnChanged(function(v)
    print("Kill Aura:", v)
end)

Tabs.PvP:AddSection("Visual")
Tabs.PvP:AddToggle("ESPPlayers", { Title = "ESP Players", Default = false }):OnChanged(function(v)
    print("ESP Players:", v)
end)

Tabs.PvP:AddSection("Misc")
Tabs.PvP:AddToggle("AutoTurnOnPvP", { Title = "Auto Turn On PvP", Default = false }):OnChanged(function(v)
    print("Auto Turn On PvP:", v)
end)

-- ===== SAVE / INTERFACE =====
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("MaruHub")
SaveManager:SetFolder("MaruHub/BloxFruits")
InterfaceManager:BuildInterfaceSection(Tabs.PvP)
SaveManager:BuildConfigSection(Tabs.PvP)
Window:SelectTab(6)
