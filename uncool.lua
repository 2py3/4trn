local CollectionService = game:GetService("CollectionService")
local ProximityPromptService = game:GetService("ProximityPromptService")

-- 프롬프트 설정을 변경하는 함수
local function removeCooldown(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0 -- 대기 시간을 0으로 설정
        -- prompt.ClickablePrompt = true -- (선택사항) 클릭 가능하게 변경
    end
end

-- 1. 현재 맵에 있는 모든 프롬프트 처리
for _, prompt in ipairs(game:GetDescendants()) do
    removeCooldown(prompt)
end

-- 2. 앞으로 게임 중에 생성되는 모든 프롬프트 감시 및 처리
ProximityPromptService.PromptShown:Connect(function(prompt)
    removeCooldown(prompt)
end)
