local gui = script.Parent

-- Helper function to recursively set scale-based sizing for all descendants
local function setScaleRecursive(object)
	if object:IsA("Frame") or object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("ImageLabel") or object:IsA("ImageButton") then
		-- Convert Offset-based Size/Position to Scale-based
		local parent = object.Parent
		if parent and parent:IsA("GuiObject") then
			local parentSize = parent.AbsoluteSize
			if parentSize.X > 0 and parentSize.Y > 0 then
				-- Convert Size
				local absSize = object.AbsoluteSize
				object.Size = UDim2.new(absSize.X / parentSize.X, 0, absSize.Y / parentSize.Y, 0)
				-- Convert Position
				local absPos = object.AbsolutePosition - parent.AbsolutePosition
				object.Position = UDim2.new(absPos.X / parentSize.X, 0, absPos.Y / parentSize.Y, 0)
			end
		end
	end

	-- Centralizar o frame raiz
	if object == gui then
		object.AnchorPoint = Vector2.new(0.5, 0.5)
		object.Position = UDim2.new(0.5, 0, 0.5, 0)
	end

	-- Recursivamente aplicar nos filhos
	for _, child in ipairs(object:GetChildren()) do
		setScaleRecursive(child)
	end
end

-- Initial setup
setScaleRecursive(gui)

-- Update on screen size change
local player = game:GetService("Players").LocalPlayer
local function onScreenResize()
	setScaleRecursive(gui)
end

if player and player:FindFirstChild("PlayerGui") then
	player.PlayerGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(onScreenResize)
end

print("PuzzleGui scaling script loaded and centered.")
