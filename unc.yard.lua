local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- [ 기존 GUI 제거 ]
if CoreGui:FindFirstChild("DraggableTestGui") then 
    CoreGui.DraggableTestGui:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DraggableTestGui"

-- [ 메인 프레임 ]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 280)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

-- [ 드래그 기능 ]
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() 
            if input.UserInputState == Enum.UserInputState.End then dragging = false end 
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- [ UI 생성 유틸리티 ]
local function createLabel(text, pos, parent)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = pos
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 12
    label.Font = Enum.Font.SourceSansBold
    return label
end

local function createInput(text, pos, parent)
    local input = Instance.new("TextBox", parent)
    input.Size = UDim2.new(1, -20, 0, 35)
    input.Position = pos
    input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Text = text
    input.ClearTextOnFocus = false
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
    return input
end

-- [ 랜덤 한글 태그 생성 함수 ]
local function getKoreanTag(length)
    local res = ""
    for i = 1, length do
        -- 가(44032) ~ 힣(55203) 사이의 유니코드 랜덤 추출
        local randomCode = math.random(44032, 55203)
        res = res .. utf8.char(randomCode)
    end
    return res
end

-- [ 설정 영역 ]
createLabel("메시지 (\\n: 줄바꿈)", UDim2.new(0, 10, 0, 15), MainFrame)
local MsgInput = createInput("안녕하세요\\n테스트", UDim2.new(0, 10, 0, 35), MainFrame)

createLabel("대기 시간 (최소 0.1)", UDim2.new(0, 10, 0, 80), MainFrame)
local WaitInput = createInput("0.5", UDim2.new(0, 10, 0, 100), MainFrame)

-- [ 태그 버튼 ]
local UseTag = false
local TagBtn = Instance.new("TextButton", MainFrame)
TagBtn.Size = UDim2.new(1, -20, 0, 35)
TagBtn.Position = UDim2.new(0, 10, 0, 145)
TagBtn.Text = "태그(랜덤 한글): OFF"
TagBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TagBtn.TextColor3 = Color3.new(1, 1, 1)
TagBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", TagBtn)

TagBtn.MouseButton1Click:Connect(function()
    UseTag = not UseTag
    TagBtn.Text = "태그(랜덤 한글): " .. (UseTag and "ON" or "OFF")
    TagBtn.BackgroundColor3 = UseTag and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(70, 70, 70)
end)

-- [ 실행/종료 버튼 ]
local StartBtn = Instance.new("TextButton", MainFrame)
StartBtn.Size = UDim2.new(0.5, -15, 0, 45)
StartBtn.Position = UDim2.new(0, 10, 0, 210)
StartBtn.Text = "시작"
StartBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
StartBtn.TextColor3 = Color3.new(1, 1, 1)
StartBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", StartBtn)

local StopBtn = Instance.new("TextButton", MainFrame)
StopBtn.Size = UDim2.new(0.5, -15, 0, 45)
StopBtn.Position = UDim2.new(0.5, 5, 0, 210)
StopBtn.Text = "종료"
StopBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
StopBtn.TextColor3 = Color3.new(1, 1, 1)
StopBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", StopBtn)

-- [ 로직 실행 ]
_G.TestLoop = false
StartBtn.MouseButton1Click:Connect(function()
    if _G.TestLoop then return end
    _G.TestLoop = true
    
    task.spawn(function()
        while _G.TestLoop do
            local waitTime = math.max(tonumber(WaitInput.Text) or 0.5, 0.1)
            local baseText = string.gsub(MsgInput.Text, "\\n", "\n")
            
            local tagText = ""
            if UseTag then
                -- 한글 2글자 랜덤 태그
                tagText = " [" .. getKoreanTag(2) .. "]"
            end

            local finalMsg = baseText .. tagText
            
            -- 리모트 경로 설정
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Folder") 
            if remote then 
                remote = remote:FindFirstChild("채팅")
                if remote and remote:IsA("RemoteEvent") then
                    remote:FireServer(finalMsg)
                end
            end
            
            task.wait(waitTime)
        end
    end)
end)

StopBtn.MouseButton1Click:Connect(function()
    _G.TestLoop = false
end)
