local frame = script.Parent
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Add UIScale if not present
local uiScale = frame:FindFirstChildOfClass("UIScale")
if not uiScale then
    uiScale = Instance.new("UIScale")
    uiScale.Parent = frame
end

-- Store the original size of the frame (in pixels)
local originalSize = frame.AbsoluteSize

-- Reference resolution (should match the design resolution in Studio)
local referenceWidth = 1920
local referenceHeight = 1080

-- Center the frame on the screen
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)

-- Function to update scale based on screen size
local function updateScale()
    local viewportSize = camera.ViewportSize

    -- Calculate the scale so the frame keeps a similar size to its original
    local scaleX = viewportSize.X / referenceWidth
    local scaleY = viewportSize.Y / referenceHeight
    local scale = math.min(scaleX, scaleY)

    -- Calculate the desired scale to keep the frame at its original pixel size
    local desiredScaleX = viewportSize.X / originalSize.X
    local desiredScaleY = viewportSize.Y / originalSize.Y
    local desiredScale = math.min(desiredScaleX, desiredScaleY)

    -- Clamp the scale to avoid too small or too large frame
    local minScale = 0.7
    local maxScale = 1.3
    local finalScale = math.clamp(desiredScale, minScale, maxScale)

    uiScale.Scale = finalScale

    -- Update children to use scale-based sizing/positioning
    local parentSize = frame.AbsoluteSize
    for _, child in frame:GetChildren() do
        if child:IsA("GuiObject") then
            -- Convert Offset-based Size to Scale
            if child.Size.X.Offset ~= 0 or child.Size.Y.Offset ~= 0 then
                child.Size = UDim2.new(
                    child.Size.X.Scale + child.Size.X.Offset / math.max(parentSize.X, 1),
                    0,
                    child.Size.Y.Scale + child.Size.Y.Offset / math.max(parentSize.Y, 1),
                    0
                )
            end
            -- Convert Offset-based Position to Scale
            if child.Position.X.Offset ~= 0 or child.Position.Y.Offset ~= 0 then
                child.Position = UDim2.new(
                    child.Position.X.Scale + child.Position.X.Offset / math.max(parentSize.X, 1),
                    0,
                    child.Position.Y.Scale + child.Position.Y.Offset / math.max(parentSize.Y, 1),
                    0
                )
            end
        end
    end
end

-- Initial update
updateScale()

-- Listen for screen size changes
camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

