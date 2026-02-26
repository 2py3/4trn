-- 기초 변수 설정
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")

local targetHost = nil
local isTracking = false
local lastCommand = "" 
local controlFaceLoop = nil

-- UI 생성 (드래그 가능)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 220)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "🛡️ NO-BRACKET AUTO DRILL"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local HostBox = Instance.new("TextBox", MainFrame)
HostBox.Size = UDim2.new(0.85, 0, 0, 30)
HostBox.Position = UDim2.new(0.075, 0, 0.22, 0)
HostBox.PlaceholderText = "호스트 닉네임"
HostBox.Text = ""
HostBox.TextColor3 = Color3.new(1, 1, 1)
HostBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local SelectBtn = Instance.new("TextButton", MainFrame)
SelectBtn.Size = UDim2.new(0.85, 0, 0, 30)
SelectBtn.Position = UDim2.new(0.075, 0, 0.4, 0)
SelectBtn.Text = "👤 호스트 클릭 선택"
SelectBtn.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
SelectBtn.TextColor3 = Color3.new(1, 1, 1)

local StartBtn = Instance.new("TextButton", MainFrame)
StartBtn.Size = UDim2.new(0.4, 0, 0, 40)
StartBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
StartBtn.Text = "시작"
StartBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)

local StopBtn = Instance.new("TextButton", MainFrame)
StopBtn.Size = UDim2.new(0.4, 0, 0, 40)
StopBtn.Position = UDim2.new(0.525, 0, 0.65, 0)
StopBtn.Text = "종료"
StopBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)

--- 기능 함수 ---

local function rotate(degrees)
    local rad = math.rad(degrees)
    Root.CFrame = Root.CFrame * CFrame.Angles(0, rad, 0)
end

-- 호스트 선택
SelectBtn.MouseButton1Click:Connect(function()
    SelectBtn.Text = "캐릭터를 클릭하세요..."
    local Mouse = Player:GetMouse()
    local connection
    connection = Mouse.Button1Down:Connect(function()
        local target = Mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            local p = game.Players:GetPlayerFromCharacter(target.Parent)
            if p then
                targetHost = p
                HostBox.Text = p.Name
            end
        end
        SelectBtn.Text = "👤 호스트 클릭 선택"
        connection:Disconnect()
    end)
end)

-- 핵심 로직: 대괄호 없이 텍스트 매칭
local function checkSign()
    if not isTracking or not targetHost or not targetHost.Character then return end
    
    local sign = targetHost.Character:FindFirstChild("표지판")
    if sign and sign:FindFirstChild("Board") then
        local label = sign.Board:FindFirstChild("SurfaceGui") and sign.Board.SurfaceGui:FindFirstChild("Label")
        if label then
            -- 양옆 공백 제거 후 텍스트 가져오기
            local rawCmd = label.Text:match("^%s*(.-)%s*$")
            
            -- 중복 방지: 이전 명령과 같으면 실행 안 함
            if rawCmd == lastCommand then return end
            lastCommand = rawCmd 
            
            -- 명령어 조건문 (대괄호 제거 버전)
            if rawCmd == "Left face." or rawCmd == "좌향 좌." then
                rotate(90)
            elseif rawCmd == "Right face." or rawCmd == "우향 우." then
                rotate(-90)
            elseif rawCmd == "Left incline." or rawCmd == "좌향 우." then
                rotate(45)
            elseif rawCmd == "Right incline." or rawCmd == "우향 좌." then
                rotate(-45)
            elseif rawCmd == "About face." or rawCmd == "뒤로 돌아." then
                rotate(180)
            elseif rawCmd == "Center face." or rawCmd == "앞을 봐." then
                Root.CFrame = CFrame.new(Root.Position, Root.Position + Vector3.new(0,0,-1))
            elseif rawCmd == "Control face." or rawCmd == "호스트 주시." then
                if not controlFaceLoop then
                    controlFaceLoop = game:GetService("RunService").RenderStepped:Connect(function()
                        if isTracking and targetHost.Character and targetHost.Character:FindFirstChild("HumanoidRootPart") then
                            local targetPos = targetHost.Character.HumanoidRootPart.Position
                            Root.CFrame = CFrame.new(Root.Position, Vector3.new(targetPos.X, Root.Position.Y, targetPos.Z))
                        end
                    end)
                end
            end
            
            -- 주시 명령어가 아닐 경우 루프 해제
            if rawCmd ~= "Control face." and rawCmd ~= "호스트 주시." then
                if controlFaceLoop then
                    controlFaceLoop:Disconnect()
                    controlFaceLoop = nil
                end
            end
        end
    end
end

-- 버튼 제어
StartBtn.MouseButton1Click:Connect(function()
    if isTracking then return end
    isTracking = true
    lastCommand = "" 
    StartBtn.Text = "작동 중..."
    
    spawn(function()
        while isTracking do
            checkSign()
            task.wait(0.1)
        end
    end)
end)

StopBtn.MouseButton1Click:Connect(function()
    isTracking = false
    lastCommand = ""
    StartBtn.Text = "시작"
    if controlFaceLoop then
        controlFaceLoop:Disconnect()
        controlFaceLoop = nil
    end
end)
