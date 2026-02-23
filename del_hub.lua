-- 메인 설정 및 테이블 데이터
local scriptData = {
    {name = "Infinite Yield", url = "https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua"},
    {name = "높이 고정", url = "https://raw.githubusercontent.com/2py3/4trn/refs/heads/main/lock_yloc.lua"},
    {name = "플레이어 순간이동", url = "https://raw.githubusercontent.com/2py3/4trn/refs/heads/main/tptotarget.lua"},
    {name = "리모트 날리기", url = "https://raw.githubusercontent.com/2py3/4trn/refs/heads/main/remote.lua"},
    {name = "fling", url = "https://raw.githubusercontent.com/K1LAS1K/Ultimate-Fling-GUI/main/flingscript.lua"}
}

-- GUI 생성
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local ContentFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- GUI 속성 설정
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "UniversalHub_deluser"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

-- 상단바 (드래그 가능)
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BorderSizePixel = 0

Title.Parent = TopBar
Title.Text = "Universal Hub with deluser"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Size = UDim2.new(1, -30, 1, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 10, 0, 0)

CloseBtn.Parent = TopBar
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- 스크롤 영역
ContentFrame.Parent = MainFrame
ContentFrame.Position = UDim2.new(0, 5, 0, 35)
ContentFrame.Size = UDim2.new(1, -10, 1, -40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.ScrollBarThickness = 4

UIListLayout.Parent = ContentFrame
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 버튼 생성 함수
for _, sk in pairs(scriptData) do
    local btn = Instance.new("TextButton")
    btn.Parent = ContentFrame
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = sk.name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 0
    
    btn.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet(sk.url))()
    end)
end

-- 드래그 기능 스크립트
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)
