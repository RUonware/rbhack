-- 🧠 Ruon Hack GUI - Tam Sürüm
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Camera = workspace.CurrentCamera

-- GUI
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RuonHackGui"
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 260)
frame.Position = UDim2.new(0.5, -150, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = " Ruon hile"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 30)
title.Parent = frame

-- Reklam Butonu
local siteAd = Instance.new("TextButton")
siteAd.Text = "Ziyaret Et: https://ruonpanel.great-site.net"
siteAd.Font = Enum.Font.Gotham
siteAd.TextSize = 14
siteAd.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
siteAd.TextColor3 = Color3.fromRGB(0, 200, 255)
siteAd.Size = UDim2.new(1, -10, 0, 30)
siteAd.Position = UDim2.new(0, 5, 0, 35)
siteAd.Parent = frame
siteAd.MouseButton1Click:Connect(function()
	setclipboard("https://ruonpanel.great-site.net")
	game.StarterGui:SetCore("SendNotification", {
		Title = "Ruon Panel",
		Text = "Site linki panoya kopyalandı!",
		Duration = 3
	})
end)

-- Noclip
local noclipEnabled = false
local noclipButton = Instance.new("TextButton")
noclipButton.Text = "Noclip: Kapalı"
noclipButton.Font = Enum.Font.Gotham
noclipButton.TextSize = 14
noclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.Size = UDim2.new(1, -10, 0, 30)
noclipButton.Position = UDim2.new(0, 5, 0, 75)
noclipButton.Parent = frame

local noclipConnection
noclipButton.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipButton.Text = noclipEnabled and "Noclip: Açık" or "Noclip: Kapalı"
	if noclipEnabled then
		noclipConnection = RunService.Stepped:Connect(function()
			if Character and Character:FindFirstChild("HumanoidRootPart") then
				for _, part in pairs(Character:GetChildren()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConnection then
			noclipConnection:Disconnect()
		end
	end
end)

-- 🛸 Fly (uçuş)
local flyEnabled = false
local flySpeed = 50
local flyButton = Instance.new("TextButton")
flyButton.Text = "Fly: Kapalı (H)"
flyButton.Font = Enum.Font.Gotham
flyButton.TextSize = 14
flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Size = UDim2.new(1, -10, 0, 30)
flyButton.Position = UDim2.new(0, 5, 0, 115)
flyButton.Parent = frame

local bodyVel, bodyGyro

local function setFly(state)
	flyEnabled = state
	if flyEnabled then
		Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local root = Character:WaitForChild("HumanoidRootPart")
		bodyVel = Instance.new("BodyVelocity")
		bodyGyro = Instance.new("BodyGyro")
		bodyVel.MaxForce = Vector3.new(400000, 400000, 400000)
		bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
		bodyVel.Velocity = Vector3.zero
		bodyVel.Parent = root
		bodyGyro.Parent = root
		RunService.RenderStepped:Connect(function()
			if flyEnabled and root then
				bodyGyro.CFrame = Camera.CFrame
				local moveDir = Vector3.zero
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
				bodyVel.Velocity = moveDir * flySpeed
			end
		end)
	else
		if bodyVel then bodyVel:Destroy() end
		if bodyGyro then bodyGyro:Destroy() end
	end
	flyButton.Text = flyEnabled and "Fly: Açık (H)" or "Fly: Kapalı (H)"
end

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.H then
		setFly(not flyEnabled)
	end
end)

-- GUI Aç/Kapa (O tuşu)
local guiVisible = true
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.O then
		guiVisible = not guiVisible
		frame.Visible = guiVisible
	end
end)

-- Kapatma Butonu
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "Kapat (X)"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Size = UDim2.new(0, 80, 0, 25)
closeBtn.Position = UDim2.new(1, -85, 0, 0)
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)
