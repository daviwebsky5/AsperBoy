-- Módulo para animar fade-in/fade-out de TextLabel.TextTransparency
local TweenService = game:GetService("TweenService")

local FadeText = {}

function FadeText.FadeOut(label, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(label, tweenInfo, {TextTransparency = 1})
    tween:Play()
    tween.Completed:Wait()
end

function FadeText.FadeIn(label, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local tween = TweenService:Create(label, tweenInfo, {TextTransparency = 0})
    tween:Play()
    tween.Completed:Wait()
end

return FadeText

