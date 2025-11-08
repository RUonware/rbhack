-- RUON HACK GUI v-updated (GUI görünüm iyileştirmesi + animasyonlar)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
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

-- Genel button oluşturucu (yeni: hover & click efektleri)
local function mkButton(parent, txt, width)
    width = width or 100
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, width, 0, 36)
    b.BackgroundColor3 = Color3.fromRGB(20,20,20)
    b.TextColor3 = Color3.fromRGB(235,235,235)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Text = txt
    b.AutoButtonColor = false
    b.BackgroundTransparency = 0
    local corner = Instance.new("UICorner", b)
    corner.CornerRadius = UDim.new(0,8)
    local stroke = Instance.new("UIStroke", b)
    stroke.Thickness = 1
    stroke.Transparency = 0.75
    stroke.Color = Color3.fromRGB(30,30,30)

    -- hover & click
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
    end)
    b.MouseButton1Down:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.06), {BackgroundTransparency = 0.15}):Play()
    end)
    b.MouseButton1Up:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.06), {BackgroundTransparency = 0}):Play()
    end)

    b.Parent = parent
    return b
end

-- Ana frame
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(580,640)
main.Position = UDim2.fromOffset(20,20)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.AnchorPoint = Vector2.new(0,0)
main.ClipsDescendants = true
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0,12)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 1
mainStroke.Transparency = 0.8
mainStroke.Color = Color3.fromRGB(18,18,18)

-- subtle shadow (frame)
local shadow = Instance.new("Frame", screenGui)
shadow.BackgroundTransparency = 0
shadow.Size = UDim2.new(0, main.Size.X.Offset+10, 0, main.Size.Y.Offset+10)
shadow.Position = UDim2.new(0, main.Position.X.Offset-5, 0, main.Position.Y.Offset-5)
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.ZIndex = 0
shadow.ClipsDescendants = true
local shadowCorner = Instance.new("UICorner", shadow)
shadowCorner.CornerRadius = UDim.new(0,14)
local shadowStroke = Instance.new("UIGradient", shadow)
shadowStroke.Rotation = 90

main.Position = UDim2.fromOffset(20,20)
main.Parent = screenGui

local layout = Instance.new("UIListLayout", main)
layout.FillDirection = Enum.FillDirection.Vertical
layout.Padding = UDim.new(0,8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Başlık çubuğu (sürükleme + minimize + close)
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, -16, 0, 48)
titleBar.Position = UDim2.new(0,8,0,8)
titleBar.BackgroundTransparency = 1
titleBar.LayoutOrder = 1
titleBar.AnchorPoint = Vector2.new(0,0)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0,0,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(240,240,240)
titleLabel.Text = "RUON HACK TEAM"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.RichText = true
titleLabel.LayoutOrder = 1

local subtitle = Instance.new("TextLabel", titleBar)
subtitle.Size = UDim2.new(1, -120, 1, 0)
subtitle.Position = UDim2.new(0,0,0,18)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 11
subtitle.TextColor3 = Color3.fromRGB(170,170,170)
subtitle.Text = "v3 · Ruon"
subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- minimize & close
local btnContainer = Instance.new("Frame", titleBar)
btnContainer.Size = UDim2.new(0, 110, 1, 0)
btnContainer.Position = UDim2.new(1, -110, 0, 0)
btnContainer.BackgroundTransparency = 1

local minimizeBtn = Instance.new("TextButton", btnContainer)
minimizeBtn.Size = UDim2.new(0, 36, 0, 36)
minimizeBtn.Position = UDim2.new(0, 0, 0, 6)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 22
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
local minCorner = Instance.new("UICorner", minimizeBtn)
minCorner.CornerRadius = UDim.new(0,8)

local closeBtn = Instance.new("TextButton", btnContainer)
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(0, 40, 0, 6)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BackgroundColor3 = Color3.fromRGB(180,35,35)
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,8)

-- main içerik container
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -16, 1, -72)
content.Position = UDim2.new(0,8,0,56)
content.BackgroundTransparency = 1
content.LayoutOrder = 2
content.ClipsDescendants = true

-- İçerik layout
local contentLayout = Instance.new("UIListLayout", content)
contentLayout.FillDirection = Enum.FillDirection.Vertical
contentLayout.Padding = UDim.new(0,10)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Fly frame (aynı düzen, görünüm iyileştirme)
local flyFrame = Instance.new("Frame", content)
flyFrame.Size = UDim2.new(1,0,0,40)
flyFrame.BackgroundTransparency = 1
flyFrame.LayoutOrder = 1
local flyLayout = Instance.new("UIListLayout", flyFrame)
flyLayout.FillDirection = Enum.FillDirection.Horizontal
flyLayout.Padding = UDim.new(0,10)
flyLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local flyBtn = mkButton(flyFrame,"Fly: Kapalı",140)
local noclipBtn = mkButton(flyFrame,"Noclip: Kapalı",140)

-- Hız kutusu
local speedFrame = Instance.new("Frame", content)
speedFrame.Size = UDim2.new(1,0,0,36)
speedFrame.BackgroundTransparency = 1
speedFrame.LayoutOrder = 2

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(0,160,1,0)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Text = "Uçuş Hızı: 50"
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedBox = Instance.new("TextBox", speedFrame)
speedBox.Size = UDim2.new(0,120,1,0)
speedBox.Position = UDim2.new(0,170,0,0)
speedBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Text = "50"
speedBox.Font = Enum.Font.GothamBold
speedBox.TextSize = 14
local speedBoxCorner = Instance.new("UICorner", speedBox)
speedBoxCorner.CornerRadius = UDim.new(0,6)
speedBox.ClearTextOnFocus = false

-- Butonlar
local buttonFrame = Instance.new("Frame", content)
buttonFrame.Size = UDim2.new(1,0,0,36)
buttonFrame.BackgroundTransparency = 1
buttonFrame.LayoutOrder = 3
local buttonLayout = Instance.new("UIListLayout", buttonFrame)
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.Padding = UDim.new(0,10)
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

local boostBtn = mkButton(buttonFrame,"SUPER BOOST",140)
local aimModes = {"Kapalı","Düşmanlar","Herkes"}; local aimIndex=1
local aimBtn = mkButton(buttonFrame,"Aimlock: Kapalı",160)
local espModes = {"Kapalı","Düşmanlar","Herkes"}; local espIndex=1
local espBtn = mkButton(buttonFrame,"ESP: Kapalı",120)
local rainbowBtn = mkButton(buttonFrame,"Rainbow GUI: Kapalı",160)
local triggerBtn = mkButton(buttonFrame,"TriggerBot: Kapalı",160)

-- Player List
local listFrame = Instance.new("Frame", content)
listFrame.Size = UDim2.new(1,0,0,200)
listFrame.BackgroundTransparency = 1
listFrame.LayoutOrder = 4

local scroll = Instance.new("ScrollingFrame", listFrame)
scroll.Size = UDim2.new(1,0,1,0)
scroll.BackgroundColor3 = Color3.fromRGB(38,38,38)
scroll.ScrollBarThickness = 8
scroll.CanvasSize = UDim2.new(0,0,0,0)
local scrollCorner = Instance.new("UICorner", scroll)
scrollCorner.CornerRadius = UDim.new(0,8)
local listLayout = Instance.new("UIListLayout",scroll)
listLayout.Padding = UDim.new(0,6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function makePlayerButton(plr)
    local btn = Instance.new("TextButton")
    btn.Size=UDim2.new(1,-12,0,28)
    btn.Text=plr.Name
    btn.BackgroundColor3=Color3.fromRGB(18,18,18)
    btn.TextColor3=Color3.new(1,1,1)
    btn.Font=Enum.Font.Gotham
    btn.TextSize=14
    btn.AutoButtonColor=false
    local c = Instance.new("UICorner",btn)
    c.CornerRadius = UDim.new(0,6)
    btn.Parent = scroll
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(28,28,28)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(18,18,18)}):Play()
    end)
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
    scroll.CanvasSize = UDim2.new(0,0,0,math.max(1,count*34))
end

refreshList()
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)
task.spawn(function() while true do task.wait(5); refreshList() end end)

-- Fly değişkenleri (orijinal)
local flySpeed = 50
local flying = false
local noclip = false
local BV, BG

-- Fly logic (aynı kod)
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

-- RenderStepped loop (orijinal mantık korunmuştur)
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Rainbow arka plan
    if rainbowEnabled then
        rainbowHue = (rainbowHue + 0.005) % 1
        main.BackgroundColor3 = Color3.fromHSV(rainbowHue,0.8,0.12)
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
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
        if move.Magnitude>0 then move=move.Unit*flySpeed end
        BV.Velocity = move
        BG.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.LookVector)
    end
end)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then startFly() else stopFly() end
    flyBtn.Text = "Fly: "..(flying and "Açık" or "Kapalı")
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = "Noclip: "..(noclip and "Açık" or "Kapalı")
end)

boostBtn.MouseButton1Click:Connect(function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.Velocity = Camera.CFrame.LookVector*(flySpeed*6) end
end)

-- ESP (orijinal)
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

-- Aimlock (orijinal)
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

-- Lighting renkleri (aynı)
local Lighting = game:GetService("Lighting")
local worldFrame = Instance.new("Frame", content)
worldFrame.Size = UDim2.new(1,0,0,40)
worldFrame.BackgroundTransparency = 1
worldFrame.LayoutOrder = 5
local worldLayout = Instance.new("UIListLayout", worldFrame)
worldLayout.FillDirection = Enum.FillDirection.Horizontal
worldLayout.Padding = UDim.new(0,10)

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
    btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
    btn.TextColor3 = Color3.fromRGB(235,235,235)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    local c = Instance.new("UICorner",btn)
    c.CornerRadius = UDim.new(0,6)
    btn.Parent = worldFrame

    btn.MouseButton1Click:Connect(function()
        Lighting.Ambient = data.Color
        Lighting.OutdoorAmbient = data.Color
        Lighting.ColorShift_Top = data.Color
        Lighting.ColorShift_Bottom = data.Color
        print("[Ruon] Ortam rengi değişti:", data.Name)
    end)
end

-- TriggerBot (orijinal)
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

-- GUI Toggle Insert & Home (aynı)
local GUI_ACTION = "Ruon_Toggle_GUI"
local toggleCooldown = false
local function toggleGUI(actionName,inputState,inputObj)
    if inputState==Enum.UserInputState.Begin and not toggleCooldown then
        toggleCooldown=true
        screenGui.Enabled = not screenGui.Enabled
        task.delay(0.15,function() toggleCooldown=false end)
    end
end
ContextActionService:BindAction(GUI_ACTION, toggleGUI, false, Enum.KeyCode.Insert)
ContextActionService:BindAction(GUI_ACTION.."_Home", toggleGUI, false, Enum.KeyCode.Home)

-- GUI Sürükleme (başlık üzerinden)
local dragging = false
local dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
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

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        shadow.Position = UDim2.new(0, main.Position.X.Offset-5, 0, main.Position.Y.Offset-5)
    end
end)

-- Minimize / Restore animasyon (geliştirilmiş)
local originalSize = main.Size
local minimized = false
local function setMinimized(state)
    minimized = state
    if minimized then
        -- animasyonla küçült
        local tween = TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 260, 0, 56)})
        tween:Play()
        -- içerikleri gizle (animasyon sonrası)
        task.delay(0.18, function()
            for _,child in pairs(content:GetChildren()) do
                if child ~= nil then child.Visible = false end
            end
            minimizeBtn.Text = "+"
        end)
    else
        -- geri aç
        for _,child in pairs(content:GetChildren()) do
            if child ~= nil then child.Visible = true end
        end
        local tween = TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Size = originalSize})
        tween:Play()
        minimizeBtn.Text = "-"
    end
end

minimizeBtn.MouseButton1Click:Connect(function()
    setMinimized(not minimized)
end)

-- Close butonu (sadece gizleme)
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Speed & Jump Boost (düzeltme korunmuştur)
local boostFrame = Instance.new("Frame", content)
boostFrame.Size = UDim2.new(1,0,0,80)
boostFrame.BackgroundTransparency = 1
boostFrame.LayoutOrder = 6
local boostLayout = Instance.new("UIListLayout", boostFrame)
boostLayout.FillDirection = Enum.FillDirection.Vertical
boostLayout.Padding = UDim.new(0,6)

-- Speed Boost
local speedBoostFrame = Instance.new("Frame", boostFrame)
speedBoostFrame.Size = UDim2.new(1,0,0,36)
speedBoostFrame.BackgroundTransparency = 1

local speedBoostLabel = Instance.new("TextLabel", speedBoostFrame)
speedBoostLabel.Size = UDim2.new(0,160,1,0)
speedBoostLabel.BackgroundTransparency = 1
speedBoostLabel.Font = Enum.Font.GothamBold
speedBoostLabel.TextSize = 14
speedBoostLabel.TextColor3 = Color3.new(1,1,1)
speedBoostLabel.Text = "Koşma Hızı: Varsayılan"

local speedBoostBox = Instance.new("TextBox", speedBoostFrame)
speedBoostBox.Size = UDim2.new(0,120,1,0)
speedBoostBox.Position = UDim2.new(0,170,0,0)
speedBoostBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
speedBoostBox.TextColor3 = Color3.new(1,1,1)
speedBoostBox.Text = "16"
speedBoostBox.Font = Enum.Font.GothamBold
speedBoostBox.TextSize = 14
local speedBoostCorner = Instance.new("UICorner",speedBoostBox)
speedBoostCorner.CornerRadius=UDim.new(0,6)

speedBoostBox.FocusLost:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local v = tonumber(speedBoostBox.Text)
    if v and v > 0 then
        hum.WalkSpeed = v
        speedBoostLabel.Text = "Koşma Hızı: " .. v
    else
        speedBoostBox.Text = tostring(hum.WalkSpeed)
    end
end)

-- Jump Boost
local jumpBoostFrame = Instance.new("Frame", boostFrame)
jumpBoostFrame.Size = UDim2.new(1,0,0,36)
jumpBoostFrame.BackgroundTransparency = 1

local jumpBoostLabel = Instance.new("TextLabel", jumpBoostFrame)
jumpBoostLabel.Size = UDim2.new(0,160,1,0)
jumpBoostLabel.BackgroundTransparency = 1
jumpBoostLabel.Font = Enum.Font.GothamBold
jumpBoostLabel.TextSize = 14
jumpBoostLabel.TextColor3 = Color3.new(1,1,1)
jumpBoostLabel.Text = "Zıplama Gücü: Varsayılan"

local jumpBoostBox = Instance.new("TextBox", jumpBoostFrame)
jumpBoostBox.Size = UDim2.new(0,120,1,0)
jumpBoostBox.Position = UDim2.new(0,170,0,0)
jumpBoostBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
jumpBoostBox.TextColor3 = Color3.new(1,1,1)
jumpBoostBox.Text = "50"
jumpBoostBox.Font = Enum.Font.GothamBold
jumpBoostBox.TextSize = 14
local jumpBoostCorner = Instance.new("UICorner",jumpBoostBox)
jumpBoostCorner.CornerRadius=UDim.new(0,6)

jumpBoostBox.FocusLost:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local v = tonumber(jumpBoostBox.Text)
    if v and v > 0 then
        hum.JumpPower = v
        jumpBoostLabel.Text = "Zıplama Gücü: " .. v
    else
        jumpBoostBox.Text = tostring(hum.JumpPower)
    end
end)

-- Son: GUI hazır
print("[Ruon] GUI güncellendi: modern stil, animasyon ve ekstra kontroller eklendi.")
