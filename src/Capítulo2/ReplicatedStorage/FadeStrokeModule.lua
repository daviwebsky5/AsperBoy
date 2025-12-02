-- Módulo para animar fade-in/fade-out de UIStroke.Transparency
local TweenService = game:GetService("TweenService")

local FadeStroke = {}

function FadeStroke.FadeOut(stroke, duration)
	if stroke then
		local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(stroke, tweenInfo, {Transparency = 1})
		tween:Play()
		tween.Completed:Wait()
	end
end

function FadeStroke.FadeIn(stroke, duration)
	if stroke then
		local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local tween = TweenService:Create(stroke, tweenInfo, {Transparency = 0})
		tween:Play()
		tween.Completed:Wait()
	end
end

return FadeStroke

