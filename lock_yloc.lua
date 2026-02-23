-- LocalScript

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local character = nil
local hrp = nil

local y = nil
local ctrlHolding = false
local lockConnection = nil

-- 캐릭터 설정 함수 (리셋 대응)
local function setupCharacter(char)
	character = char
	hrp = character:WaitForChild("HumanoidRootPart")

	-- Ctrl 누른 상태에서 리셋되었으면 다시 고정
	if ctrlHolding and y then
		if lockConnection then
			lockConnection:Disconnect()
		end

		lockConnection = RunService.RenderStepped:Connect(function()
			if hrp then
				hrp.CFrame = CFrame.new(
					hrp.Position.X,
					y,
					hrp.Position.Z
				)
			end
		end)
	end
end

-- 처음 캐릭터
if player.Character then
	setupCharacter(player.Character)
end

-- 리셋(사망) 후 캐릭터 재생성
player.CharacterAdded:Connect(setupCharacter)

-- Ctrl 눌렀을 때 (처음 1회만)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.LeftControl
	or input.KeyCode == Enum.KeyCode.RightControl then

		if ctrlHolding then return end
		ctrlHolding = true

		if not hrp then return end

		-- 처음 누를 때만 Y 저장
		y = hrp.Position.Y

		-- Y 고정
		lockConnection = RunService.RenderStepped:Connect(function()
			if hrp then
				hrp.CFrame = CFrame.new(
					hrp.Position.X,
					y,
					hrp.Position.Z
				)
			end
		end)
	end
end)

-- Ctrl 뗐을 때
UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftControl
	or input.KeyCode == Enum.KeyCode.RightControl then

		ctrlHolding = false
		y = nil

		if lockConnection then
			lockConnection:Disconnect()
			lockConnection = nil
		end
	end
end)
