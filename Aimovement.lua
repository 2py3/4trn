local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local isRunning = false

-- GUI 생성 (CoreGui에 삽입)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FakeMovementAI"
screenGui.Parent = CoreGui

local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 150, 0, 50)
mainButton.Position = UDim2.new(0.5, -75, 0.1, 0)
mainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.Text = "AI Movement: OFF"
mainButton.Font = Enum.Font.GothamBold
mainButton.TextSize = 14
mainButton.Parent = screenGui

-- 라운드 코너 추가
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainButton

-- 이동 로직 변수
local keys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
local currentKey = nil

-- 모든 키 입력 중지 함수
local function releaseAllKeys()
    for _, key in ipairs(keys) do
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end
end

-- 메인 루프
task.spawn(function()
    while true do
        if isRunning then
            -- 1. 무작위 키 선택 (앞, 왼쪽, 오른쪽, 뒤 중 하나)
            currentKey = keys[math.random(1, #keys)]
            local duration = math.random(5, 25) / 10 -- 0.5초 ~ 2.5초 동안 이동
            
            -- 키 누르기 시작
            VirtualInputManager:SendKeyEvent(true, currentKey, false, game)
            
            --[[ 이동 중 무작위 점프 (진짜 플레이어 느낌)
            if math.random(1, 10) > 7 then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end]]
            
            task.wait(duration)
            
            -- 키 떼기 및 잠깐 대기 (자연스러운 멈춤)
            releaseAllKeys()
            task.wait(math.random(2, 10) / 10) 
        else
            task.wait(0.5)
        end
    end
end)

-- 토글 이벤트
mainButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        mainButton.Text = "AI Movement: ON"
        mainButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    else
        mainButton.Text = "AI Movement: OFF"
        mainButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        releaseAllKeys()
    end
end)
