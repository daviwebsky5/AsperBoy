local TweenService = game:GetService("TweenService")

local FadeModule = {}

-- Fades out all UI elements inside the given frame (including itself)
function FadeModule.FadeOutAllUI(PuzzleFrame, duration)
    -- Fade out PuzzleFrame background
    local frameTween = TweenService:Create(
        PuzzleFrame,
        TweenInfo.new(duration),
        {BackgroundTransparency = 1}
    )
    frameTween:Play()

    -- Fade out all descendants
    for _, ui in PuzzleFrame:GetDescendants() do
        local tweens = {}

        -- Fade out background transparency if applicable
        if ui:IsA("Frame") or ui:IsA("TextButton") or ui:IsA("ImageButton") or ui:IsA("ScrollingFrame") then
            table.insert(tweens, TweenService:Create(ui, TweenInfo.new(duration), {BackgroundTransparency = 1}))
        end

        -- Fade out image transparency if applicable
        if ui:IsA("ImageLabel") or ui:IsA("ImageButton") then
            table.insert(tweens, TweenService:Create(ui, TweenInfo.new(duration), {ImageTransparency = 1}))
        end

        -- Fade out text transparency if applicable
        if ui:IsA("TextLabel") or ui:IsA("TextButton") then
            table.insert(tweens, TweenService:Create(ui, TweenInfo.new(duration), {TextTransparency = 1}))
		end
		
		-- Fade out UIStroke transparency if applicable
		if ui:IsA("UIStroke") then
			table.insert(tweens, TweenService:Create(ui, TweenInfo.new(duration), {Transparency = 1}))
		end

        -- Play all tweens for this UI element
        for _, tween in tweens do
            tween:Play()
        end
    end
end

function FadeModule.FadeOutAllUIMochila(PuzzleFrame2, duration)
	-- Fade out PuzzleFrame background
	local frameTween = TweenService:Create(
		PuzzleFrame2,
		TweenInfo.new(duration),
		{BackgroundTransparency = 1}
	)
	frameTween:Play()

	-- Fade out all descendants
	for _, ui in PuzzleFrame2:GetDescendants() do
		local tweens = {}

		-- Fade out background transparency if applicable
		if ui:IsA("Frame") or ui:IsA("TextButton") or ui:IsA("ImageButton") or ui:IsA("ScrollingFrame") then
			table.insert(tweens, TweenService:Create(ui, TweenInfo.new(duration), {BackgroundTransparency = 1}))
		end

		-- Fade out image transparency if applicable
		if ui:IsA("ImageLabel") or ui:IsA("ImageButton") then
			table.insert(tweens, TweenService:Create(ui, TweenInfo.new(duration), {ImageTransparency = 1}))
		end

		-- Fade out text transparency if applicable
		if ui:IsA("TextLabel") or ui:IsA("TextButton") then
			table.insert(tweens, TweenService:Create(ui, TweenInfo.new(duration), {TextTransparency = 1}))
		end

		-- Fade out UIStroke transparency if applicable
		if ui:IsA("UIStroke") then
			table.insert(tweens, TweenService:Create(ui, TweenInfo.new(duration), {Transparency = 1}))
		end

		-- Play all tweens for this UI element
		for _, tween in tweens do
			tween:Play()
		end
	end
end

return FadeModule

