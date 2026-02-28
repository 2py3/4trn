local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

-- [ 1. 중복 UI 제거 ]
-- CoreGui 내의 기존 UI를 찾아 삭제합니다.
local existingUI = CoreGui:FindFirstChild("XenoFinalV17")
if existingUI then
    existingUI:Destroy()
end

-- [ 변수 설정 ]
local isPlatformActive, Platform = false, nil
local movingUp, movingDown = false, false
local currentOffset = 3.5
local isCheatMoveActive = false
local isHardLockActive = false

-- [ 2. UI 생성 - CoreGui 기준 ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XenoFinalV17"
ScreenGui.Parent = CoreGui -- PlayerGui 대신 CoreGui 설정
ScreenGui.ResetOnSpawn = false
-- 실행 권한 문제 방지를 위해 IgnoreGuiInset 설정
ScreenGui.IgnoreGuiInset = true 

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 165) 
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -82)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

-- 상단 바 (드래그 영역)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -35, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "XENO ULTIMATE V17 (CORE)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- 닫기 버튼
local CloseButton = Instance.new("TextButton", TopBar)
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.MouseButton1Click:Connect(function() 
    isPlatformActive = false
    isCheatMoveActive = false
    isHardLockActive = false
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.Anchored = false
    end
    if Platform then Platform:Destroy() end
    ScreenGui:Destroy() 
end)

-- [ 3. 높이 조절 UI ]
local HeightFrame = Instance.new("Frame", MainFrame)
HeightFrame.Size = UDim2.new(0, 40, 0, 90)
HeightFrame.Position = UDim2.new(1, 5, 0, 35)
HeightFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
HeightFrame.Visible = false
HeightFrame.BorderSizePixel = 0

local function SetupHoldButton(text, pos, moveType)
    local btn = Instance.new("TextButton", HeightFrame)
    btn.Size = UDim2.new(1, -6, 0, 40)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Down:Connect(function() 
        if moveType == "Up" then movingUp = true else movingDown = true end 
    end)
end
SetupHoldButton("▲", UDim2.new(0, 3, 0, 3), "Up")
SetupHoldButton("▼", UDim2.new(0, 3, 0, 47), "Down")

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        movingUp = false 
        movingDown = false 
    end
end)

-- [ 4. 메인 루프 (핵심 로직) ]
RunService.Heartbeat:Connect(function()
    local Char = Player.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    local Hum = Char and Char:FindFirstChild("Humanoid")
    local Cam = workspace.CurrentCamera
    if not Root or not Hum then return end

    if isCheatMoveActive or isHardLockActive then
        Root.Anchored = true
        Root.Velocity = Vector3.zero
        Root.RotVelocity = Vector3.zero
        
        if isCheatMoveActive then
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Cam.CFrame.RightVector end
            
            local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
            if hDir.Magnitude > 0 then
                Root.CFrame += (hDir.Unit * (Hum.WalkSpeed / 60))
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                Root.CFrame += Vector3.new(0, Hum.JumpPower / 60, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                Root.CFrame -= Vector3.new(0, Hum.WalkSpeed / 60, 0)
            end
        end
    else
        -- 기능을 껐을 때만 Anchor 해제 (단, 플랫폼 활성화 시 제외할 수도 있음)
        if not isPlatformActive then
            Root.Anchored = false 
        end
    end

    if isPlatformActive and Platform then
        local liftSpeed = 0.5
        if movingUp then 
            Root.CFrame *= CFrame.new(0, liftSpeed, 0)
        elseif movingDown then 
            Root.CFrame *= CFrame.new(0, -liftSpeed, 0)
        end
        Platform.CFrame = Root.CFrame * CFrame.new(0, -currentOffset, 0)
    end
end)

-- [ 5. 기능 토글 버튼 생성 함수 ]
local function MakeToggle(name, yPos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        callback(active)
    end)
end

MakeToggle("Air Platform / Elevate", 40, function(state)
    isPlatformActive = state
    HeightFrame.Visible = state
    if state then
        if Platform then Platform:Destroy() end
        Platform = Instance.new("Part", workspace)
        Platform.Name = "XenoPlatform"
        Platform.Size = Vector3.new(12, 1, 12)
        Platform.Anchored = true
        Platform.CanCollide = true
        Platform.Transparency = 0.5
        Platform.Color = Color3.fromRGB(0, 255, 255)
    else
        if Platform then Platform:Destroy() Platform = nil end
    end
end)

MakeToggle("Hard Lock Pos", 80, function(state)
    isHardLockActive = state
end)

MakeToggle("Cheat Move (Fixed)", 120, function(state)
    isCheatMoveActive = state
end)

-- [ 6. 드래그 기능 구현 ]
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
        dragging = true 
        dragStart = i.Position 
        startPos = MainFrame.Position 
    end 
end)

UserInputService.InputChanged:Connect(function(i) 
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end 
end)

UserInputService.InputEnded:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
        dragging = false 
    end 
end)
