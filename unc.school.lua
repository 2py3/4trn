local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- 기존 GUI 제거
if CoreGui:FindFirstChild("DraggableTestGui") then CoreGui.DraggableTestGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DraggableTestGui"

-- [ 메인 프레임 ]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 500)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -250)
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
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
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

-- [ UI 생성 함수 ]
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
    input.Size = UDim2.new(1, -20, 0, 30)
    input.Position = pos
    input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Text = text
    input.ClearTextOnFocus = false
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
    return input
end

local function createToggle(text, pos, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.3, -5, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 10
    Instance.new("UICorner", btn)
    return btn
end

-- [ 설정 영역 ]
createLabel("메시지 (\\n: 줄바꿈)", UDim2.new(0, 10, 0, 10), MainFrame)
local MsgInput = createInput("안녕하세요\\n테스트", UDim2.new(0, 10, 0, 30), MainFrame)

createLabel("대기 시간 (최소 0.1)", UDim2.new(0, 10, 0, 65), MainFrame)
local WaitInput = createInput("0.5", UDim2.new(0, 10, 0, 85), MainFrame)

createLabel("폰트 크기", UDim2.new(0, 10, 0, 120), MainFrame)
local SizeInput = createInput("15", UDim2.new(0, 10, 0, 140), MainFrame) -- 기본값 15 설정

createLabel("색상 (R,G,B 형식)", UDim2.new(0, 10, 0, 175), MainFrame)
local ColorInput = createInput("255,255,255", UDim2.new(0, 10, 0, 195), MainFrame)

-- [ 스타일 토글 ]
local isBold, isItalic, isUnderline = false, false, false
local BoldBtn = createToggle("볼드", UDim2.new(0, 10, 0, 235), MainFrame)
local ItalicBtn = createToggle("기울기", UDim2.new(0.33, 10, 0, 235), MainFrame)
local UnderBtn = createToggle("밑줄", UDim2.new(0.66, 10, 0, 235), MainFrame)

BoldBtn.MouseButton1Click:Connect(function() isBold = not isBold; BoldBtn.Text = "볼드: " .. (isBold and "ON" or "OFF") end)
ItalicBtn.MouseButton1Click:Connect(function() isItalic = not isItalic; ItalicBtn.Text = "기울기: " .. (isItalic and "ON" or "OFF") end)
UnderBtn.MouseButton1Click:Connect(function() isUnderline = not isUnderline; UnderBtn.Text = "밑줄: " .. (isUnderline and "ON" or "OFF") end)

-- [ 모드 및 태그 ]
local mode = "Plain"
local ModeBtn = Instance.new("TextButton", MainFrame)
ModeBtn.Size = UDim2.new(0.5, -15, 0, 35)
ModeBtn.Position = UDim2.new(0, 10, 0, 280)
ModeBtn.Text = "모드: Plain"
ModeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ModeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", ModeBtn)

local UseTag = false
local TagBtn = Instance.new("TextButton", MainFrame)
TagBtn.Size = UDim2.new(0.5, -15, 0, 35)
TagBtn.Position = UDim2.new(0.5, 5, 0, 280)
TagBtn.Text = "태그: OFF"
TagBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TagBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", TagBtn)

ModeBtn.MouseButton1Click:Connect(function()
    mode = (mode == "Plain") and "Simple" or "Plain"
    ModeBtn.Text = "모드: " .. mode
end)

TagBtn.MouseButton1Click:Connect(function()
    UseTag = not UseTag
    TagBtn.Text = "태그: " .. (UseTag and "ON" or "OFF")
end)

-- [ 버튼 ]
local StartBtn = Instance.new("TextButton", MainFrame)
StartBtn.Size = UDim2.new(1, -20, 0, 45)
StartBtn.Position = UDim2.new(0, 10, 0, 330)
StartBtn.Text = "시작"
StartBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
StartBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", StartBtn)

local StopBtn = Instance.new("TextButton", MainFrame)
StopBtn.Size = UDim2.new(1, -20, 0, 45)
StopBtn.Position = UDim2.new(0, 10, 0, 385)
StopBtn.Text = "종료"
StopBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
StopBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", StopBtn)

-- [ 실행 ]
_G.TestLoop = false
StartBtn.MouseButton1Click:Connect(function()
    if _G.TestLoop then return end
    _G.TestLoop = true
    task.spawn(function()
        while _G.TestLoop do
            local waitTime = math.max(tonumber(WaitInput.Text) or 0.5, 0.1)
            local fontSize = tonumber(SizeInput.Text) or 15 -- 입력값이 없으면 기본 15
            local baseText = string.gsub(MsgInput.Text, "\\n", "\n")
            
            local r, g, b = ColorInput.Text:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
            local hex = string.format("#%02X%02X%02X", r or 255, g or 255, b or 255)

            local tagText = ""
            if UseTag then
                tagText = " {" .. string.lower(string.sub(HttpService:GenerateGUID(false), 1, 5)) .. "}"
            end

            local finalMsg = baseText .. tagText
            if isBold then finalMsg = "<b>" .. finalMsg .. "</b>" end
            if isItalic then finalMsg = "<i>" .. finalMsg .. "</i>" end
            if isUnderline then finalMsg = "<u>" .. finalMsg .. "</u>" end
            
            if mode == "Simple" then
                finalMsg = string.format("<font color='%s' size='%d'>%s</font>", hex, fontSize, finalMsg)
            else
                finalMsg = string.format("<font size='%d'>%s</font>", fontSize, finalMsg)
            end

            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("SendChat")
            if remote then remote:FireServer(finalMsg) end
            task.wait(waitTime)
        end
    end)
end)
StopBtn.MouseButton1Click:Connect(function() _G.TestLoop = false end)
