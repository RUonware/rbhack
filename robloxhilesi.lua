-- 🛠 RUON FLY GUI SYSTEM (PC + Mobil)
-- Özellikler:
-- 🔹 Kamera yönüne göre uçuş
-- 🔹 3 hız modu (Yavaş / Orta / Hızlı)
-- 🔹 Uçma Aç/Kapa butonu
-- 🔹 Hem PC hem Mobil destekli

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Değişkenler
local flying = false
local flyMode = 2 -- 1 = yavaş, 2 = orta, 3 = hızlı
local flySpeeds = {50, 100, 999}
local BV, BG, HRP

-- GUI oluştur
local gui = Instance.new("ScreenGui")
gui.Name = "RuonFlyGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 110)
frame.Position = UDim2.new(0.05, 0, 0.75, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.1
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "🚀 RUON FLY SYSTEM"
title.Text9 = "başka hileler için -- https://ruonpanel.great-site.net --"
title.TextColor3 = Color3.new(1,1,1)
title.TextColor9 = Color3.new(200,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1
title.Parent = frame

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(1, -20, 0, 35)
flyBtn.Position = UDim2.new(0, 10, 0, 30)
flyBtn.Text = "Fly: Kapalı"
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 18
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
flyBtn.Parent = frame
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 6)

local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(1, -20, 0, 35)
modeBtn.Position = UDim2.new(0, 10, 0, 70)
modeBtn.Text = "Mod: Orta (60)"
modeBtn.Font = Enum.Font.GothamBold
modeBtn.TextSize = 18
modeBtn.TextColor3 = Color3.new(1,1,1)
modeBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
modeBtn.Parent = frame
Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 6)

-- Uçmayı başlat/durdur
local function startFly()
	local char = LocalPlayer.Character
	if not char then return end
	HRP = char:FindFirstChild("HumanoidRootPart")
	if not HRP then return end

	BV = Instance.new("BodyVelocity")
	BV.MaxForce = Vector3.new(1e5,1e5,1e5)
	BV.Velocity = Vector3.zero
	BV.Parent = HRP

	BG = Instance.new("BodyGyro")
	BG.MaxTorque = Vector3.new(1e5,1e5,1e5)
	BG.CFrame = HRP.CFrame
	BG.Parent = HRP
end

local function stopFly()
	if BV then BV:Destroy() BV = nil end
	if BG then BG:Destroy() BG = nil end
end

-- Buton olayları
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		startFly()
		flyBtn.Text = "Fly: Açık ✅"
		flyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		stopFly()
		flyBtn.Text = "Fly: Kapalı ❌"
		flyBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	end
end)

modeBtn.MouseButton1Click:Connect(function()
	flyMode = flyMode % 3 + 1
	modeBtn.Text = "Mod: " .. ({ "Yavaş (25)", "Orta (60)", "Hızlı (100)", "niga999" })[flyMode]
end)

-- Uçuş mantığı
RunService.RenderStepped:Connect(function()
	if not flying or not BV or not BG or not HRP then return end
	local cam = Camera.CFrame
	local move = Vector3.zero

	-- PC kontrolleri
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

	-- Mobilde dokunmatik joystick zaten hareket vektörü gönderir
	if move.Magnitude > 0 then
		move = move.Unit * flySpeeds[flyMode]
	end

	BV.Velocity = move
	BG.CFrame = CFrame.new(HRP.Position, HRP.Position + cam.LookVector)
end)

print("✅ RUON Fly GUI aktif (Mobil + PC uyumlu)")



