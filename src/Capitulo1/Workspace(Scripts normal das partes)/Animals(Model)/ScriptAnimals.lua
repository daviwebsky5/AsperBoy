local clickDetector = script.Parent:WaitForChild("ClickDetector")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

clickDetector.MouseClick:Connect(function(player)
	local gui = player:WaitForChild("PlayerGui"):WaitForChild("AnimalGui"):WaitForChild("AnimalQuizFrame")

	gui.Visible = true
end)
