-- RUON HACK TEAM - Rainbow GUI + Fly + Noclip + Box ESP + Aimlock + Player List + TriggerBot
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RuonHackGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui
screenGui.Enabled = true

-- Rainbow toggle
local rainbowEnabled = false
local rainbowHue = 0

-- Genel button oluşturucu
local function mkButton(parent, txt)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,100,0,36)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(0,0,0)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    Instance.new("UICorner",b).CornerRadius=UDim.new(0)
    b.Parent = parent
    return b
end

-- Ana frame
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.fromOffset(580,640)
main.Position = UDim2.fromOffset(20,20)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
local layout = Instance.new("UIListLayout", main)
layout.FillDirection = Enum.FillDirection.Vertical
layout.Padding = UDim.new(0,10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Başlık
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,36)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Text = "RUON HACK TEAM"

-- Fly değişkenleri
local flySpeed = 50
local flying = false
local noclip = false
local BV, BG

-- Fly frame
local flyFrame = Instance.new("Frame", main)
flyFrame.Size = UDim2.new(1,0,0,40)
flyFrame.BackgroundTransparency = 1
local flyLayout = Instance.new("UIListLayout", flyFrame)
flyLayout.FillDirection = Enum.FillDirection.Horizontal
flyLayout.Padding = UDim.new(0,10)
local flyBtn = mkButton(flyFrame,"Fly: Kapalı")
local noclipBtn = mkButton(flyFrame,"Noclip: Kapalı")

-- Hız kutusu
local speedFrame = Instance.new("Frame", main)
speedFrame.Size = UDim2.new(1,0,0,36)
speedFrame.BackgroundTransparency = 1
local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(0,160,1,0)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 16
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Text = "Uçuş Hızı: "..flySpeed
local speedBox = Instance.new("TextBox", speedFrame)
speedBox.Size = UDim2.new(0,120,1,0)
speedBox.Position = UDim2.new(0,170,0,0)
speedBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Text = tostring(flySpeed)
speedBox.Font = Enum.Font.GothamBold
speedBox.TextSize = 16
Instance.new("UICorner",speedBox).CornerRadius=UDim.new(0,6)
speedBox.FocusLost:Connect(function()
    local v = tonumber(speedBox.Text)
    if v and v>0 then flySpeed=v; speedLabel.Text="Uçuş Hızı: "..flySpeed
    else speedBox.Text=tostring(flySpeed) end
end)

-- Butonlar
local buttonFrame = Instance.new("Frame", main)
buttonFrame.Size = UDim2.new(1,0,0,36)
buttonFrame.BackgroundTransparency = 1
local buttonLayout = Instance.new("UIListLayout", buttonFrame)
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.Padding = UDim.new(0,10)

local boostBtn = mkButton(buttonFrame,"SUPER BOOST")
local aimModes = {"Kapalı","Düşmanlar","Herkes"}; local aimIndex=1
local aimBtn = mkButton(buttonFrame,"Aimlock: "..aimModes[aimIndex])
local espModes = {"Kapalı","Düşmanlar","Herkes"}; local espIndex=1
local espBtn = mkButton(buttonFrame,"ESP: "..espModes[espIndex])
local rainbowBtn = mkButton(buttonFrame,"Rainbow GUI: Kapalı")
local triggerBtn = mkButton(buttonFrame,"TriggerBot: Kapalı")

-- Player List
local listFrame = Instance.new("Frame", main)
listFrame.Size = UDim2.new(1,0,0,200)
listFrame.BackgroundTransparency = 1
local scroll = Instance.new("ScrollingFrame", listFrame)
scroll.Size = UDim2.new(1,0,1,0)
scroll.BackgroundColor3 = Color3.fromRGB(38,38,38)
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UICorner",scroll).CornerRadius=UDim.new(0,8)
local listLayout = Instance.new("UIListLayout",scroll)
listLayout.Padding = UDim.new(0,6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function makePlayerButton(plr)
    local btn = Instance.new("TextButton")
    btn.Size=UDim2.new(1,-12,0,28)
    btn.Text=plr.Name
    btn.BackgroundColor3=Color3.fromRGB(0,0,0)
    btn.TextColor3=Color3.new(1,1,1)
    btn.Font=Enum.Font.Gotham
    btn.TextSize=16
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local tHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp and tHRP then hrp.CFrame = tHRP.CFrame + Vector3.new(0,3,0) end
    end)
end

local function refreshList()
    for _,c in ipairs(scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local count=0
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer then makePlayerButton(p); count+=1 end
    end
    scroll.CanvasSize = UDim2.new(0,0,0,count*34)
end

refreshList()
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)
task.spawn(function() while true do task.wait(5); refreshList() end end)

-- Fly logic
local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(1e5,1e5,1e5)
    BV.Velocity = Vector3.zero
    BV.Parent = hrp
    BG = Instance.new("BodyGyro")
    BG.MaxTorque = Vector3.new(1e5,1e5,1e5)
    BG.CFrame = hrp.CFrame
    BG.Parent = hrp
end

local function stopFly()
    if BV then BV:Destroy(); BV=nil end
    if BG then BG:Destroy(); BG=nil end
end

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Rainbow arka plan
    if rainbowEnabled then
        rainbowHue = (rainbowHue + 0.005) % 1
        main.BackgroundColor3 = Color3.fromHSV(rainbowHue,1,1)
    end

    -- Noclip
    if noclip then
        for _,part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide=false end
        end
    end
	

    -- Fly
    if flying and BV and BG then
        local move = Vector3.zero
        local cam = Camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
move -= Vector3.new(0,1,0) end
if move.Magnitude>0 then move=move.Unit*flySpeed end
BV.Velocity = move
BG.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.LookVector)
end
end)

flyBtn.MouseButton1Click:Connect(function()
flying = not flying
if flying then startFly() else stopFly() end
flyBtn.Text="Fly: "..(flying and "Açık" or "Kapalı")
end)

noclipBtn.MouseButton1Click:Connect(function()
noclip = not noclip
noclipBtn.Text="Noclip: "..(noclip and "Açık" or "Kapalı")
end)

boostBtn.MouseButton1Click:Connect(function()
local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp then hrp.Velocity = Camera.CFrame.LookVector*(flySpeed*6) end
end)

-- ESP
local espMap = {}
local function clearESP(plr)
    if espMap[plr] then
        espMap[plr]:Destroy()
        espMap[plr] = nil
    end
end

local function applyESP(plr)
    clearESP(plr)
    local ch = plr.Character
    if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = hrp
    box.Size = Vector3.new(4, 7, 2)
    box.ZIndex = 0
    box.Transparency = 0.4
    box.Color3 = Color3.fromRGB(0, 255, 0)
    box.AlwaysOnTop = true
    box.Parent = hrp
    espMap[plr] = box
end

local function refreshESP()
    if espIndex == 1 then
        for plr,_ in pairs(espMap) do clearESP(plr) end
        return
    end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if espIndex==3 or (espIndex==2 and plr.Team~=LocalPlayer.Team) then
                applyESP(plr)
            else
                clearESP(plr)
            end
        end
    end
end

espBtn.MouseButton1Click:Connect(function()
    espIndex = espIndex % #espModes + 1
    espBtn.Text = "ESP: " .. espModes[espIndex]
    refreshESP()
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() task.wait(0.3); refreshESP() end)
end)

Players.PlayerRemoving:Connect(function(plr)
    clearESP(plr)
end)

refreshESP()

-- Aimlock
local function isVisible(part)
if not part or not part.Position then return false end
local origin = Camera.CFrame.Position
local dir = (part.Position - origin)
local params = RaycastParams.new()
params.FilterDescendantsInstances = {LocalPlayer.Character}
params.FilterType = Enum.RaycastFilterType.Blacklist
local hit = workspace:Raycast(origin, dir, params)
return hit and hit.Instance and hit.Instance:IsDescendantOf(part.Parent)
end

local function getClosestTarget()
local bestHead, bestDist = nil, math.huge
local mouse = UserInputService:GetMouseLocation()
for _,p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer then
if aimIndex==3 or (aimIndex==2 and p.Team~=LocalPlayer.Team) then
local head = p.Character and p.Character:FindFirstChild("Head")
if head then
local sp,onScreen = Camera:WorldToScreenPoint(head.Position)
if onScreen and isVisible(head) then
local d = (Vector2.new(sp.X, sp.Y)-Vector2.new(mouse.X, mouse.Y)).Magnitude
if d<bestDist then bestDist=d; bestHead=head end
end
end
end
end
end
return bestHead
end

RunService.RenderStepped:Connect(function()
if aimIndex ~= 1 then
local targetHead = getClosestTarget()
if targetHead then
Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
end
end
end)

aimBtn.MouseButton1Click:Connect(function()
aimIndex = aimIndex % #aimModes + 1
aimBtn.Text = "Aimlock: "..aimModes[aimIndex]
end)

-- Rainbow toggle
rainbowBtn.MouseButton1Click:Connect(function()
rainbowEnabled = not rainbowEnabled
rainbowBtn.Text = "Rainbow GUI: " .. (rainbowEnabled and "Açık" or "Kapalı")
if not rainbowEnabled then main.BackgroundColor3 = Color3.fromRGB(25,25,25) end
end)
-- Etraf (Lighting) Renk Değiştirme Sistemi
local Lighting = game:GetService("Lighting")

-- Renk butonları için küçük bir frame
local worldFrame = Instance.new("Frame", main)
worldFrame.Size = UDim2.new(1,0,0,40)
worldFrame.BackgroundTransparency = 1
local worldLayout = Instance.new("UIListLayout", worldFrame)
worldLayout.FillDirection = Enum.FillDirection.Horizontal
worldLayout.Padding = UDim.new(0,10)

-- Ortam renkleri
local worldColors = {
    {Name="Mavi", Color=Color3.fromRGB(0,120,255)},
    {Name="Kırmızı", Color=Color3.fromRGB(255,60,60)},
    {Name="Yeşil", Color=Color3.fromRGB(60,255,100)},
    {Name="Beyaz", Color=Color3.fromRGB(255,255,255)},
    {Name="Koyu", Color=Color3.fromRGB(20,20,20)}
}

for _,data in ipairs(worldColors) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,100,0,36)
    btn.Text = data.Name
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,6)
    btn.Parent = worldFrame

    btn.MouseButton1Click:Connect(function()
        Lighting.Ambient = data.Color
        Lighting.OutdoorAmbient = data.Color
        Lighting.ColorShift_Top = data.Color
        Lighting.ColorShift_Bottom = data.Color
        print("[Ruon] Ortam rengi değişti:", data.Name)
    end)
end

-- TriggerBot
local triggerEnabled = false
local HoldClick = true
local Hotkey = 't'
local HotkeyToggle = true
local CurrentlyPressed = false

local Mouse = LocalPlayer:GetMouse()
local Toggle = (Hotkey ~= '')

triggerBtn.MouseButton1Click:Connect(function()
triggerEnabled = not triggerEnabled
triggerBtn.Text = "TriggerBot: "..(triggerEnabled and "Açık" or "Kapalı")
end)

Mouse.KeyDown:Connect(function(key)
if HotkeyToggle == true and key == Hotkey then
triggerEnabled = not triggerEnabled
triggerBtn.Text = "TriggerBot: "..(triggerEnabled and "Açık" or "Kapalı")
elseif key == Hotkey then
triggerEnabled = true
end
end)

Mouse.KeyUp:Connect(function(key)
if not HotkeyToggle and key == Hotkey then
triggerEnabled = false
end
end)

RunService.RenderStepped:Connect(function()
if triggerEnabled then
if Mouse.Target and Mouse.Target.Parent:FindFirstChild('Humanoid') then
if HoldClick then
if not CurrentlyPressed then
CurrentlyPressed = true
mouse1press()
end
task.wait(0)
mouse1release()
CurrentlyPressed = false
else
mouse1click()
end
end
end
end)

-- GUI Toggle Insert & Home
local GUI_ACTION = "Ruon_Toggle_GUI"
local toggleCooldown = false
local function toggleGUI(actionName,inputState,inputObj)
local dragging = false
local dragInput, dragStart, startPos
if inputState==Enum.UserInputState.Begin and not toggleCooldown then
toggleCooldown=true
screenGui.Enabled = not screenGui.Enabled
task.delay(0.15,function() toggleCooldown=false end)
end
end
ContextActionService:BindAction(GUI_ACTION, toggleGUI, false, Enum.KeyCode.Insert)
ContextActionService:BindAction(GUI_ACTION.."_Home", toggleGUI, false, Enum.KeyCode.Home)

-- GUI Sürükleme ve Küçültme Sistemi

-- === Sürükleme ===
local dragging = false
local dragInput, dragStart, startPos

main.Active = true
main.Draggable = false -- eski sürüm, elle yapıyoruz
main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- === Küçültme / Büyültme Sistemi (Tam Uyumluluk) ===
local minimized = false
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 36, 0, 36)
minimizeBtn.Position = UDim2.new(1, -46, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 24
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,6)
minimizeBtn.Parent = main

-- orijinal boyut yedeği
local originalSize = main.Size

-- minimize işlemi
local function setMinimized(state)
	minimized = state
	if minimized then
		-- alt frame’leri gizle
		for _,child in pairs(main:GetChildren()) do
			if child:IsA("Frame") or child:IsA("ScrollingFrame") or child:IsA("TextButton") then
				if child ~= minimizeBtn then
					child.Visible = false
				end
			end
		end
		main.Size = UDim2.new(0, 240, 0, 50)
		minimizeBtn.Text = "+"
	else
		for _,child in pairs(main:GetChildren()) do
			if child:IsA("Frame") or child:IsA("ScrollingFrame") or child:IsA("TextButton") then
				child.Visible = true
			end
		end
		main.Size = originalSize
		minimizeBtn.Text = "-"
	end
end

-- buton bağlantısı
minimizeBtn.MouseButton1Click:Connect(function()
	setMinimized(not minimized)
end)




print("[Ruon] Rainbow GUI + Fly + ESP + Aimlock + Player List + TriggerBot hazır!")
