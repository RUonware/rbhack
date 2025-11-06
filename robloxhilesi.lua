-- 🧠 Ruon Fly + Noclip GUI (Tam Sürüm)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- GUI oluştur
local gui = Instance.new("ScreenGui")
gui.Name = "RuonGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 280)
frame.Position = UDim2.new(0.5, -150, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "RUONware"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0,255,0)
title.BackgroundTransparency = 1
title.Parent = frame

-- site tanıtımı
local siteBtn = Instance.new("TextButton")
siteBtn.Size = UDim2.new(1, -10, 0, 30)
siteBtn.Position = UDim2.new(0, 5, 0, 40)
siteBtn.Text = "🔗 https://ruonpanel.great-site.net"
siteBtn.Font = Enum.Font.Gotham
siteBtn.TextSize = 14
siteBtn.TextColor3 = Color3.fromRGB(0,200,255)
siteBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
siteBtn.Parent = frame
siteBtn.MouseButton1Click:Connect(function()
	setclipboard("https://ruonpanel.great-site.net")
	game.StarterGui:SetCore("SendNotification", {
		Title = "Ruon Panel",
		Text = "Site linki kopyalandı!",
		Duration = 3
	})
end)

-- noclip
local noclipEnabled = false
local noclipConn
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(1, -10, 0, 30)
noclipBtn.Position = UDim2.new(0, 5, 0, 80)
noclipBtn.Text = "Noclip: Kapalı"
noclipBtn.Font = Enum.Font.Gotham
noclipBtn.TextSize = 14
noclipBtn.TextColor3 = Color3.new(1,1,1)
noclipBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
noclipBtn.Parent = frame

noclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipBtn.Text = noclipEnabled and "Noclip: Açık" or "Noclip: Kapalı"
	if noclipEnabled then
		noclipConn = RunService.Stepped:Connect(function()
			if Character then
				for _, v in pairs(Character:GetChildren()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConn then
			noclipConn:Disconnect()
		end
	end
end)

-- fly sistemi
local flyEnabled = false
local flySpeed = 50
local BV, BG

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(1, -10, 0, 30)
flyBtn.Position = UDim2.new(0, 5, 0, 120)
flyBtn.Text = "Fly: Kapalı"
flyBtn.Font = Enum.Font.Gotham
flyBtn.TextSize = 14
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
flyBtn.Parent = frame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, -10, 0, 30)
speedBox.Position = UDim2.new(0, 5, 0, 160)
speedBox.Text = tostring(flySpeed)
speedBox.PlaceholderText = "Hız girin (örn. 100)"
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedBox.Parent = frame

speedBox.FocusLost:Connect(function()
	local num = tonumber(speedBox.Text)
	if num and num > 0 then
		flySpeed = num
		speedBox.Text = tostring(flySpeed)
	else
		speedBox.Text = tostring(flySpeed)
	end
end)

local function startFly()
	local hrp = Character:WaitForChild("HumanoidRootPart")
	BV = Instance.new("BodyVelocity")
	BG = Instance.new("BodyGyro")
	BV.MaxForce = Vector3.new(1e5,1e5,1e5)
	BG.MaxTorque = Vector3.new(1e5,1e5,1e5)
	BV.Parent = hrp
	BG.Parent = hrp
	RunService.RenderStepped:Connect(function()
		if flyEnabled then
			local move = Vector3.zero
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
			BV.Velocity = move * flySpeed
			BG.CFrame = Camera.CFrame
		end
	end)
end

local function stopFly()
	if BV then BV:Destroy() end
	if BG then BG:Destroy() end
end

flyBtn.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	if flyEnabled then
		flyBtn.Text = "Fly: Açık"
		startFly()
	else
		flyBtn.Text = "Fly: Kapalı"
		stopFly()
	end
end)

-- GUI kapatma
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 80, 0, 25)
closeBtn.Position = UDim2.new(1, -85, 0, 5)
closeBtn.Text = "Kapat (X)"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

