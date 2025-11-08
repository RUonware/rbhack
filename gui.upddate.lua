-- 🧠 RUON GUI SYSTEM v4 (Sekmeli + Küçültme & Genişletme + Yeşil-Siyah Tema)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GUI oluştur
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RuonPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Ana Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 260)
MainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "🧠 RUON PANEL v4"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Küçültme Butonu
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -35, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 22
MinimizeButton.TextColor3 = Color3.fromRGB(0, 255, 0)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Parent = MainFrame

-- Sekme Butonları
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(1, 0, 0, 30)
Tabs.Position = UDim2.new(0, 0, 0, 35)
Tabs.BackgroundTransparency = 1
Tabs.Parent = MainFrame

local TabList = {
	"Fly", "Hız", "Zıplama", "Noclip", "GodMode"
}

local Buttons = {}
local CurrentTab = nil

-- Sekme içerikleri
local Pages = {}

for i, tabName in ipairs(TabList) do
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(0, 60, 1, 0)
	Button.Position = UDim2.new(0, (i - 1) * 65, 0, 0)
	Button.Text = tabName
	Button.Font = Enum.Font.SourceSansBold
	Button.TextSize = 16
	Button.TextColor3 = Color3.fromRGB(0, 255, 0)
	Button.BackgroundTransparency = 1
	Button.Parent = Tabs
	Buttons[tabName] = Button

	-- Sekme sayfası
	local Page = Instance.new("Frame")
	Page.Size = UDim2.new(1, -10, 1, -75)
	Page.Position = UDim2.new(0, 5, 0, 70)
	Page.BackgroundTransparency = 1
	Page.Visible = false
	Page.Parent = MainFrame
	Pages[tabName] = Page

	Button.MouseButton1Click:Connect(function()
		for n, p in pairs(Pages) do
			p.Visible = false
			Buttons[n].TextColor3 = Color3.fromRGB(0, 255, 0)
		end
		Page.Visible = true
		Button.TextColor3 = Color3.fromRGB(255, 255, 255)
		CurrentTab = tabName
	end)
end

-- Sekmelerin içeriği
-- 1️⃣ Fly
local FlyPage = Pages["Fly"]
local FlyButton = Instance.new("TextButton", FlyPage)
FlyButton.Size = UDim2.new(0, 100, 0, 35)
FlyButton.Position = UDim2.new(0, 10, 0, 10)
FlyButton.Text = "Fly Aç/Kapat"
FlyButton.TextColor3 = Color3.fromRGB(0, 255, 0)
FlyButton.Font = Enum.Font.SourceSans
FlyButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FlyButton.BorderSizePixel = 0

-- 2️⃣ Hız
local SpeedPage = Pages["Hız"]
local SpeedBox = Instance.new("TextBox", SpeedPage)
SpeedBox.Size = UDim2.new(0, 80, 0, 30)
SpeedBox.Position = UDim2.new(0, 10, 0, 10)
SpeedBox.PlaceholderText = "Hız"
SpeedBox.Text = ""
SpeedBox.TextColor3 = Color3.fromRGB(0, 255, 0)
SpeedBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SpeedBox.BorderSizePixel = 0

-- 3️⃣ Zıplama
local JumpPage = Pages["Zıplama"]
local JumpBox = Instance.new("TextBox", JumpPage)
JumpBox.Size = UDim2.new(0, 80, 0, 30)
JumpBox.Position = UDim2.new(0, 10, 0, 10)
JumpBox.PlaceholderText = "Zıplama Gücü"
JumpBox.TextColor3 = Color3.fromRGB(0, 255, 0)
JumpBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
JumpBox.BorderSizePixel = 0

-- 4️⃣ Noclip
local NoclipPage = Pages["Noclip"]
local NoclipButton = Instance.new("TextButton", NoclipPage)
NoclipButton.Size = UDim2.new(0, 100, 0, 35)
NoclipButton.Position = UDim2.new(0, 10, 0, 10)
NoclipButton.Text = "Noclip Aç/Kapat"
NoclipButton.TextColor3 = Color3.fromRGB(0, 255, 0)
NoclipButton.Font = Enum.Font.SourceSans
NoclipButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
NoclipButton.BorderSizePixel = 0

-- 5️⃣ God Mode
local GodPage = Pages["GodMode"]
local GodButton = Instance.new("TextButton", GodPage)
GodButton.Size = UDim2.new(0, 100, 0, 35)
GodButton.Position = UDim2.new(0, 10, 0, 10)
GodButton.Text = "GodMode Aç/Kapat"
GodButton.TextColor3 = Color3.fromRGB(0, 255, 0)
GodButton.Font = Enum.Font.SourceSans
GodButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
GodButton.BorderSizePixel = 0

-- Genişletme Butonu (küçültülünce çıkacak)
local ExpandButton = Instance.new("TextButton")
ExpandButton.Size = UDim2.new(0, 100, 0, 30)
ExpandButton.Position = UDim2.new(0.5, -50, 0.5, -15)
ExpandButton.Text = "RUON PANEL"
ExpandButton.Font = Enum.Font.SourceSansBold
ExpandButton.TextSize = 18
ExpandButton.TextColor3 = Color3.fromRGB(0, 255, 0)
ExpandButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ExpandButton.BorderSizePixel = 0
ExpandButton.Visible = false
ExpandButton.Parent = ScreenGui

local TweenService = game:GetService("TweenService")

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
	if not minimized then
		local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)})
		tween:Play()
		task.wait(0.3)
		MainFrame.Visible = false
		ExpandButton.Visible = true
		minimized = true
	end
end)

ExpandButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 320, 0, 260)})
	tween:Play()
	ExpandButton.Visible = false
	minimized = false
end)

-- Varsayılan olarak Fly sekmesi açık
Buttons["Fly"].MouseButton1Click:Fire()

print("[RUON GUI] Sekmeli sistem aktif ✅")
