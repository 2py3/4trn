-- [[ 데이터 리스트: 여기서 쉽게 추가/수정하세요 ]]
local PlaceData = {
    {name = "검열 없는 학교", id = 104572694002074, scriptUrl = "https://raw.githubusercontent.com/2py3/4trn/refs/heads/main/unc.school.lua"},
    {name = "검열 없는 공터", id = 74062476597814, scriptUrl = "https://raw.githubusercontent.com/2py3/4trn/refs/heads/main/unc.yard.lua"},
    {name = "검열 없는 호텔", id = 129569457601448, scriptUrl = "https://raw.githubusercontent.com/2py3/4trn/refs/heads/main/unc.hotel.lua"},
    {name = "채팅 되는 게임", id = 104272520136094, scriptUrl = "https://raw.githubusercontent.com/2py3/4trn/refs/heads/main/unc.youcanusechatgame.lua"}
}

-- UI 생성 (ScreenGui)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui")) -- CoreGui에 넣어 실행기 종료 후에도 유지
ScreenGui.Name = "ExcuterPlaceManager"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Main.Active = true
Main.Draggable = true -- 드래그 가능

-- 왼쪽 목록 (ScrollingFrame)
local ListFrame = Instance.new("ScrollingFrame", Main)
ListFrame.Size = UDim2.new(0, 180, 1, -20)
ListFrame.Position = UDim2.new(0, 10, 0, 10)
ListFrame.CanvasSize = UDim2.new(0, 0, 0, #PlaceData * 45)
ListFrame.ScrollBarThickness = 3

local UIList = Instance.new("UIListLayout", ListFrame)
UIList.Padding = UDim.new(0, 5)

-- 오른쪽 정보창
local InfoFrame = Instance.new("Frame", Main)
InfoFrame.Size = UDim2.new(0, 240, 1, -20)
InfoFrame.Position = UDim2.new(0, 200, 0, 10)
InfoFrame.BackgroundTransparency = 1

local DisplayName = Instance.new("TextLabel", InfoFrame)
DisplayName.Size = UDim2.new(1, 0, 0, 40)
DisplayName.Text = "채팅 되는 게임 / 검열 없는 게임 허브 0.1v"
DisplayName.TextColor3 = Color3.new(1, 1, 1)
DisplayName.BackgroundTransparency = 1

local DisplayId = Instance.new("TextLabel", InfoFrame)
DisplayId.Size = UDim2.new(1, 0, 0, 30)
DisplayId.Position = UDim2.new(0, 0, 0, 40)
DisplayId.Text = "ID: -"
DisplayId.TextColor3 = Color3.fromRGB(180, 180, 180)
DisplayId.BackgroundTransparency = 1

-- 버튼: 체험 이동
local TeleportBtn = Instance.new("TextButton", InfoFrame)
TeleportBtn.Size = UDim2.new(1, 0, 0, 45)
TeleportBtn.Position = UDim2.new(0, 0, 0, 150)
TeleportBtn.Text = "체험으로 이동"
TeleportBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
TeleportBtn.TextColor3 = Color3.new(1, 1, 1)

-- 버튼: 스크립트 실행
local ScriptBtn = Instance.new("TextButton", InfoFrame)
ScriptBtn.Size = UDim2.new(1, 0, 0, 45)
ScriptBtn.Position = UDim2.new(0, 0, 0, 205)
ScriptBtn.Text = "스크립트 실행"
ScriptBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
ScriptBtn.TextColor3 = Color3.new(1, 1, 1)

-- 기능 연결
local selectedData = nil

for _, data in ipairs(PlaceData) do
    local b = Instance.new("TextButton", ListFrame)
    b.Size = UDim2.new(1, -5, 0, 40)
    b.Text = data.name
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    b.TextColor3 = Color3.new(1, 1, 1)
    
    b.MouseButton1Click:Connect(function()
        selectedData = data
        DisplayName.Text = data.name
        DisplayId.Text = "ID: " .. tostring(data.id)
    end)
end

TeleportBtn.MouseButton1Click:Connect(function()
    if selectedData then
        game:GetService("TeleportService"):Teleport(selectedData.id, game.Players.LocalPlayer)
    end
end)

ScriptBtn.MouseButton1Click:Connect(function()
    if selectedData and selectedData.scriptUrl ~= "" then
        -- 요청하신 구문 그대로 실행
        loadstring(game:HttpGet(selectedData.scriptUrl))()
    end
end)

-- 닫기 버튼 (우측 상단 X)
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Position = UDim2.new(1, -25, 0, 5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.new(1, 0, 0)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
