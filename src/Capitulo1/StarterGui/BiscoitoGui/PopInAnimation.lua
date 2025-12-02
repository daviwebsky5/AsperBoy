-- Services
local TweenService = game:GetService("TweenService")

-- Instances
local frame = script.Parent -- The BiscoitoFrame

-- Store the original size
local originalSize = frame.Size

-- Animation Settings (Smoother)
local tweenInfo = TweenInfo.new(
    0.5, -- Duration in seconds
    Enum.EasingStyle.Quint, -- A very smooth easing style
    Enum.EasingDirection.Out,
    0,
    false,
    0
)

-- Define the goal for the animation (only size)
local goal = {
    Size = originalSize
}

-- Create the tween
local popInTween = TweenService:Create(frame, tweenInfo, goal)

-- Function to play the animation
local function playPopIn()
    -- Set initial state for the animation (no rotation)
    frame.Rotation = 0
    frame.Size = UDim2.new(0, 0, 0, 0)

    -- Play the animation
    popInTween:Play()
end

-- Connect to the 'Visible' property change
frame:GetPropertyChangedSignal("Visible"):Connect(function()
    if frame.Visible then
        playPopIn()
    end
end)

-- Play animation on start if already visible
if frame.Visible then
    playPopIn()
end
