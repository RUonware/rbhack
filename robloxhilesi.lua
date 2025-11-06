-- 🛠 RUON FLY GUI SYSTEM v2 (Reklamlı, Sürüklenebilir Hız)
-- 🔹 Kamera yönüne göre uçuş
-- 🔹 Sürüklenebilir hız çubuğu (10–500)
-- 🔹 Site reklamı animasyonlu ve tıklanabilir
-- 🔹 Mobil + PC destekli

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 🧩 Değişkenler
local flying = false
local flySpeed = 100
local BV, BG, HRP
local siteURL = "https://ruonpanel.great-site.net"

-- 🧱 GUI oluştur
local gui = Instance.new("ScreenGui")
gui.Name = "RuonFlyGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 230)
frame.Position = UDim2.new(0.05, 0, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.1
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "RUON FLY SYSTEM"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1
title.Parent = frame

-- ✈️ Fly butonu
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(1, -20, 0, 35)
flyBtn.Position = UDim2.new(0, 10, 0, 35)
flyBtn.Text = "Fly: Kapalı ❌"
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 18
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
flyBtn.Parent = frame
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 6)

-- ⚙️ Hız etiketi
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 80)
speedLabel.Text = "Hız: " .. tostring(flySpeed)
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 16
speedLabel.BackgroundTransparency = 1
speedLabel.Parent = frame

-- 🔵 Slider arka plan
local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.new(1, -40, 0, 6)
sliderBack.Position = UDim2.new(0, 20, 0, 115)
sliderBack.BackgroundColor3 = Color3.fromRGB(60,60,60)
sliderBack.Parent = frame
Instance.new("UICorner", sliderBack).CornerRadius = UDim.new(1, 0)

-- 🟢 Sürüklenebilir top
local slider = Instance.new("Frame")
slider.Size = UDim2.new(0, 20, 0, 20)
slider.Position = UDim2.new(0, (flySpeed/500)*(sliderBack.AbsoluteSize.X-20), 0, -7)
slider.BackgroundColor3 = Color3.fromRGB(0,255,100)
slider.Parent = sliderBack
Instance.new("UICorner", slider).CornerRadius = UDim.new(1, 0)

-- 🧲 Sürükleme sistemi
local dragging = false
slider.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

RunService.RenderStepped:Connect(function()
	if dragging then
		local mouseX = UserInputService:GetMouseLocation().X
		local sliderX = math.clamp(mouseX - sliderBack.AbsolutePosition.X, 0, sliderBack.AbsoluteSize.X - 20)
		slider.Position = UDim2.new(0, sliderX, 0, -7)
		flySpeed = math.floor((sliderX / (sliderBack.AbsoluteSize.X - 20)) * 500)
		if flySpeed < 10 then flySpeed = 10 end
		speedLabel.Text = "Hız: " .. tostring(flySpeed)
	end
end)

-- 🌐 Reklam paneli
local adBtn = Instance.new("TextButton")
adBtn.Size = UDim2.new(1, -20, 0, 30)
adBtn.Position = UDim2.new(0, 10, 0, 160)
adBtn.Text = "🔗 Ziyaret Et: ruonpanel.great-site.net"
adBtn.Font = Enum.Font.GothamBold
adBtn.TextSize = 14
adBtn.TextColor3 = Color3.new(1,1,1)
adBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
adBtn.Parent = frame
Instance.new("UICorner", adBtn).CornerRadius = UDim.new(0, 6)

-- 🔁 Reklam animasyonu (renk geçişi)
task.spawn(function()
	while task.wait(0.1) do
		for i = 0, 255, 10 do
			adBtn.BackgroundColor3 = Color3.fromRGB(i, 120, 255 - i)
			task.wait(0.03)
		end
	end
end)

-- 💡 Siteye yönlendirme
adBtn.MouseButton1Click:Connect(function()
	setclipboard(siteURL)
	adBtn.Text = "📋 Kopyalandı! (" .. siteURL .. ")"
	task.wait(2)
	adBtn.Text = "🔗 Ziyaret Et: ruonpanel.great-site.net"
end)

-- ✈️ Uçuş fonksiyonları
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

-- 🔄 Buton davranışı
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		startFly()
		flyBtn.Text = "Fly: Açık ✅"
		flyBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
	else
		stopFly()
		flyBtn.Text = "Fly: Kapalı ❌"
		flyBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	end
end)

-- 💨 Uçuş mantığı
RunService.RenderStepped:Connect(function()
	if not flying or not BV or not BG or not HRP then return end
	local cam = Camera.CFrame
	local move = Vector3.zero

	if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

	if move.Magnitude > 0 then
		move = move.Unit * flySpeed
	end

	BV.Velocity = move
	BG.CFrame = CFrame.new(HRP.Position, HRP.Position + cam.LookVector)
end)

print("✅ RUON Fly GUI aktif (Reklam + sürüklenebilir hız + mobil destek)")
