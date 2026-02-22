local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- 기존 UI 제거
local old = Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("RemoteExecutorUI")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RemoteExecutorUI"
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- [공통 스타일 함수]
local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 10)
    corner.Parent = parent
end

local function applyTextStyle(obj, size, isBold)
    obj.TextColor3 = Color3.new(1, 1, 1)
    obj.TextSize = size or 16
    obj.Font = isBold and Enum.Font.GothamBold or Enum.Font.Gotham
end

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- [메인 UI]
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 480)
Main.Position = UDim2.new(0.5, -190, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
addCorner(Main)
makeDraggable(Main)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
TopBar.Parent = Main
addCorner(TopBar)

local Title = Instance.new("TextLabel")
Title.Text = "  리모트 실행기"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = "Left"
applyTextStyle(Title, 20, true)
Title.Parent = TopBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -45)
ContentFrame.Position = UDim2.new(0, 0, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = Main

-- [최소화/닫기 버튼]
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "×"
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.Parent = TopBar
applyTextStyle(CloseBtn, 22, true)
addCorner(CloseBtn, UDim.new(1, 0))
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MinBtn = Instance.new("TextButton")
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -80, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
MinBtn.Parent = TopBar
applyTextStyle(MinBtn, 22, true)
addCorner(MinBtn, UDim.new(1, 0))

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ContentFrame.Visible = not isMinimized
    Main.Size = isMinimized and UDim2.new(0, 380, 0, 45) or UDim2.new(0, 380, 0, 480)
end)

-- [인수 영역]
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -165)
Scroll.Position = UDim2.new(0, 10, 0, 15)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 4
Scroll.Parent = ContentFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = Scroll
ListLayout.Padding = UDim.new(0, 8)
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)
end)

local argList = {}
local function addArg()
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 45)
    row.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    row.Parent = Scroll
    addCorner(row)

    local tBtn = Instance.new("TextButton")
    tBtn.Size = UDim2.new(0, 85, 1, -8)
    tBtn.Position = UDim2.new(0, 4, 0, 4)
    tBtn.Text = "string"
    tBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    tBtn.Parent = row
    applyTextStyle(tBtn, 16, true)
    addCorner(tBtn)

    local val = Instance.new("TextBox")
    val.Size = UDim2.new(1, -145, 1, -8)
    val.Position = UDim2.new(0, 95, 0, 4)
    val.PlaceholderText = "값 입력"
    val.Text = ""
    val.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    val.Parent = row
    applyTextStyle(val, 16, false)
    addCorner(val)

    local del = Instance.new("TextButton")
    del.Text = "×"
    del.Size = UDim2.new(0, 35, 1, -8)
    del.Position = UDim2.new(1, -39, 0, 4)
    del.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
    del.Parent = row
    applyTextStyle(del, 20, true)
    addCorner(del)

    local data = {type = "string", input = val}
    table.insert(argList, data)

    tBtn.MouseButton1Click:Connect(function()
        if data.type == "string" then data.type = "number"
        elseif data.type == "number" then data.type = "boolean"
        else data.type = "string" end
        tBtn.Text = data.type
    end)
    del.MouseButton1Click:Connect(function()
        for i, v in ipairs(argList) do if v == data then table.remove(argList, i) break end end
        row:Destroy()
    end)
end

-- [하단 버튼]
local ControlPanel = Instance.new("Frame")
ControlPanel.Size = UDim2.new(1, 0, 0, 140)
ControlPanel.Position = UDim2.new(0, 0, 1, -140)
ControlPanel.BackgroundTransparency = 1
ControlPanel.Parent = ContentFrame

local AddBtn = Instance.new("TextButton")
AddBtn.Text = "+ 인수 추가"
AddBtn.Size = UDim2.new(1, -20, 0, 35)
AddBtn.Position = UDim2.new(0, 10, 0, 0)
AddBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
AddBtn.Parent = ControlPanel
applyTextStyle(AddBtn, 17, true)
addCorner(AddBtn)
AddBtn.MouseButton1Click:Connect(addArg)

local DelayBox = Instance.new("TextBox")
DelayBox.Size = UDim2.new(1, -20, 0, 40)
DelayBox.Position = UDim2.new(0, 10, 0, 40)
DelayBox.Text = "0.1"
DelayBox.PlaceholderText = "딜레이 (0 = 즉시)"
DelayBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
DelayBox.Parent = ControlPanel
applyTextStyle(DelayBox, 17, false)
addCorner(DelayBox)

local FireBtn = Instance.new("TextButton")
FireBtn.Text = "모든 리모트 실행"
FireBtn.Size = UDim2.new(1, -20, 0, 50)
FireBtn.Position = UDim2.new(0, 10, 0, 85)
FireBtn.BackgroundColor3 = Color3.fromRGB(70, 170, 90)
FireBtn.Parent = ControlPanel
applyTextStyle(FireBtn, 20, true)
addCorner(FireBtn)

-- [로그 창]
local function createLogWindow()
    local allLogs = {}
    local LogWin = Instance.new("Frame")
    LogWin.Size = UDim2.new(0, 350, 0, 300)
    LogWin.Position = UDim2.new(0.5, 200, 0.5, -150)
    LogWin.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    LogWin.Active = true
    LogWin.Parent = ScreenGui
    addCorner(LogWin)
    makeDraggable(LogWin)

    local LTop = Instance.new("Frame")
    LTop.Size = UDim2.new(1, 0, 0, 35)
    LTop.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    LTop.Parent = LogWin
    addCorner(LTop)

    local LTitle = Instance.new("TextLabel")
    LTitle.Text = "  실행 로그"
    LTitle.Size = UDim2.new(0.4, 0, 1, 0)
    LTitle.BackgroundTransparency = 1
    LTitle.TextXAlignment = "Left"
    applyTextStyle(LTitle, 14, true)
    LTitle.Parent = LTop

    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Text = "Copy All"
    CopyBtn.Size = UDim2.new(0, 70, 0, 25)
    CopyBtn.Position = UDim2.new(1, -110, 0.5, -12)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 160)
    CopyBtn.Parent = LTop
    applyTextStyle(CopyBtn, 12, true)
    addCorner(CopyBtn, UDim.new(0, 5))

    CopyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(table.concat(allLogs, "\n"))
            CopyBtn.Text = "Copied!"
            task.wait(1)
            CopyBtn.Text = "Copy All"
        end
    end)

    local LClose = Instance.new("TextButton")
    LClose.Text = "×"
    LClose.Size = UDim2.new(0, 25, 0, 25)
    LClose.Position = UDim2.new(1, -30, 0.5, -12)
    LClose.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    LClose.Parent = LTop
    addCorner(LClose, UDim.new(1, 0))
    LClose.MouseButton1Click:Connect(function() LogWin:Destroy() end)

    local LScroll = Instance.new("ScrollingFrame")
    LScroll.Size = UDim2.new(1, -10, 1, -45)
    LScroll.Position = UDim2.new(0, 5, 0, 40)
    LScroll.BackgroundTransparency = 1
    LScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    LScroll.ScrollBarThickness = 3
    LScroll.Parent = LogWin

    local LList = Instance.new("UIListLayout")
    LList.Parent = LScroll
    LList.Padding = UDim.new(0, 4)
    LList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        LScroll.CanvasSize = UDim2.new(0, 0, 0, LList.AbsoluteContentSize.Y + 20)
    end)

    return LScroll, LTitle, allLogs
end

-- [로그 추가 (짤림 방지 보정)]
local function addLogEntry(scroll, text, allLogs, color)
    table.insert(allLogs, text)
    local entry = Instance.new("TextLabel")
    -- 높이를 0으로 두어 자동 크기 조절(AutomaticSize) 활성화
    entry.Size = UDim2.new(1, -10, 0, 0)
    entry.AutomaticSize = Enum.AutomaticSize.Y 
    entry.BackgroundTransparency = 1
    entry.Text = text
    entry.TextColor3 = color or Color3.new(1, 1, 1)
    entry.TextXAlignment = "Left"
    entry.TextWrapped = true -- 긴 이름 줄바꿈
    applyTextStyle(entry, 12, false)
    entry.Parent = scroll
    
    scroll.CanvasPosition = Vector2.new(0, 99999)
end

FireBtn.MouseButton1Click:Connect(function()
    local waitTime = tonumber(DelayBox.Text) or 0
    local instant = (waitTime == 0)
    local args = {}
    for _, d in ipairs(argList) do
        local t = d.input.Text
        if d.type == "number" then table.insert(args, tonumber(t) or 0)
        elseif d.type == "boolean" then table.insert(args, t:lower() == "true")
        else table.insert(args, tostring(t)) end
    end

    local LogScroll, StatusLabel, allLogs = createLogWindow()
    
    task.spawn(function()
        local count = 0
        local targets = {game.Workspace, game.ReplicatedStorage, game.Players, game.StarterGui}
        for _, svc in ipairs(targets) do
            for _, obj in ipairs(svc:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    count = count + 1
                    StatusLabel.Text = "  실행 중 (" .. count .. ")"
                    addLogEntry(LogScroll, "[" .. count .. "] " .. obj:GetFullName(), allLogs)
                    obj:FireServer(unpack(args))
                    if not instant then task.wait(waitTime) end
                end
            end
        end
        count = count + 1
        StatusLabel.Text = "  완료!"
        addLogEntry(LogScroll, "[" .. count .. "] Remote_excuter.Done", allLogs, Color3.fromRGB(100, 255, 100))
    end)
end)
