-- LocalScript (StarterPlayerScripts)

---------------------------------------------------
-- 서비스
---------------------------------------------------
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

---------------------------------------------------
-- 유틸
---------------------------------------------------
local function addCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 6)
	corner.Parent = instance
end

---------------------------------------------------
-- GUI 생성 (CoreGui)
---------------------------------------------------
-- 중복 생성 방지
if CoreGui:FindFirstChild("TeleportUI") then
	CoreGui.TeleportUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportUI"
screenGui.ResetOnSpawn = false
pcall(function()
	screenGui.Parent = CoreGui
end)

---------------------------------------------------
-- 메인 프레임
---------------------------------------------------
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 350, 0, 380)
frame.Position = UDim2.new(0.5, -175, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
addCorner(frame, 10)

local title = Instance.new("TextLabel", frame)
title.Text = "Teleport Controller"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
addCorner(title, 6)

---------------------------------------------------
-- 이름 입력 + 선택 버튼
---------------------------------------------------
local nameBox = Instance.new("TextBox", frame)
nameBox.PlaceholderText = "플레이어 이름 입력"
nameBox.Size = UDim2.new(0.65, -10, 0, 30)
nameBox.Position = UDim2.new(0, 10, 0, 40)
nameBox.Text = ""
nameBox.TextColor3 = Color3.new(1, 1, 1)
nameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
nameBox.Font = Enum.Font.SourceSans
nameBox.TextSize = 18
addCorner(nameBox, 6)

local selectButton = Instance.new("TextButton", frame)
selectButton.Text = "선택"
selectButton.Size = UDim2.new(0.35, -10, 0, 30)
selectButton.Position = UDim2.new(0.65, 0, 0, 40)
selectButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
selectButton.TextColor3 = Color3.new(1, 1, 1)
selectButton.Font = Enum.Font.SourceSansBold
selectButton.TextSize = 18
addCorner(selectButton, 6)

---------------------------------------------------
-- 플레이어 리스트
---------------------------------------------------
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, -20, 0, 100)
scrollFrame.Position = UDim2.new(0, 10, 0, 80)
scrollFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarImageTransparency = 0.2
scrollFrame.Visible = false
addCorner(scrollFrame, 8)

local uiList = Instance.new("UIListLayout", scrollFrame)
uiList.Padding = UDim.new(0, 5)

-- Canvas 자동 갱신
uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 10)
end)

---------------------------------------------------
-- 오프셋 입력
---------------------------------------------------
local offsetFrame = Instance.new("Frame", frame)
offsetFrame.Size = UDim2.new(1, -20, 0, 30)
offsetFrame.Position = UDim2.new(0, 10, 0, 190)
offsetFrame.BackgroundTransparency = 1

local offsetBoxes = {}
for i, axis in ipairs({"X", "Y", "Z"}) do
	local box = Instance.new("TextBox", offsetFrame)
	box.PlaceholderText = axis
	box.Size = UDim2.new(1/3 - 0.05, 0, 1, 0)
	box.Position = UDim2.new((i-1)/3 + 0.025, 0, 0, 0)
	box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Text = "0"
	box.Font = Enum.Font.SourceSans
	box.TextSize = 18
	addCorner(box, 6)
	offsetBoxes[axis] = box
end

---------------------------------------------------
-- 주기
---------------------------------------------------
local intervalBox = Instance.new("TextBox", frame)
intervalBox.PlaceholderText = "반복 주기 (초)"
intervalBox.Size = UDim2.new(1, -20, 0, 30)
intervalBox.Position = UDim2.new(0, 10, 0, 230)
intervalBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
intervalBox.TextColor3 = Color3.new(1, 1, 1)
intervalBox.Text = "0.5"
intervalBox.Font = Enum.Font.SourceSans
intervalBox.TextSize = 18
addCorner(intervalBox, 6)

---------------------------------------------------
-- 이동 방식
---------------------------------------------------
local moveModes = {"기본", "프레임마다"}
local currentMode = 1

local moveModeButton = Instance.new("TextButton", frame)
moveModeButton.Text = "이동 방식: 기본"
moveModeButton.Size = UDim2.new(1, -20, 0, 30)
moveModeButton.Position = UDim2.new(0, 10, 0, 270)
moveModeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
moveModeButton.TextColor3 = Color3.new(1, 1, 1)
moveModeButton.Font = Enum.Font.SourceSansBold
moveModeButton.TextSize = 18
addCorner(moveModeButton, 6)

moveModeButton.MouseButton1Click:Connect(function()
	currentMode = currentMode % #moveModes + 1
	moveModeButton.Text = "이동 방식: " .. moveModes[currentMode]
end)

---------------------------------------------------
-- ON / OFF
---------------------------------------------------
local teleportEnabled = false

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Text = "Teleport: OFF"
toggleButton.Size = UDim2.new(1, -20, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 310)
toggleButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
addCorner(toggleButton, 8)

toggleButton.MouseButton1Click:Connect(function()
	teleportEnabled = not teleportEnabled
	toggleButton.Text = teleportEnabled and "Teleport: ON" or "Teleport: OFF"
	toggleButton.BackgroundColor3 =
		teleportEnabled and Color3.fromRGB(0, 140, 0) or Color3.fromRGB(120, 0, 0)
end)

---------------------------------------------------
-- 플레이어 리스트 생성 함수
---------------------------------------------------
local function updatePlayerList()
	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local btn = Instance.new("TextButton")
			btn.Parent = scrollFrame
			btn.Size = UDim2.new(1, -10, 0, 25)
			btn.Text = p.Name
			btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.SourceSans
			btn.TextSize = 18
			btn.BorderSizePixel = 0
			addCorner(btn, 5)

			btn.MouseButton1Click:Connect(function()
				nameBox.Text = p.Name
				scrollFrame.Visible = false
			end)
		end
	end
end

selectButton.MouseButton1Click:Connect(function()
	updatePlayerList()
	scrollFrame.Visible = not scrollFrame.Visible
end)

---------------------------------------------------
-- 메인 텔레포트 루프
---------------------------------------------------
task.spawn(function()
	while task.wait(0.05) do
		if not teleportEnabled then continue end

		local target = workspace:FindFirstChild(nameBox.Text)
		local char = player.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")

		if target and hrp and target:FindFirstChild("HumanoidRootPart") then
			local offset = Vector3.new(
				tonumber(offsetBoxes.X.Text) or 0,
				tonumber(offsetBoxes.Y.Text) or 0,
				tonumber(offsetBoxes.Z.Text) or 0
			)

			hrp.CFrame = target.HumanoidRootPart.CFrame + offset
		end
	end
end)
