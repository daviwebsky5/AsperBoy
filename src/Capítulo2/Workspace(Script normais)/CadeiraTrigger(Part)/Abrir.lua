local clickDetector = script.Parent:WaitForChild("ClickDetector")

clickDetector.MouseClick:Connect(function(player)
	local gui = player:WaitForChild("PlayerGui"):WaitForChild("DialagoOnibus"):WaitForChild("DialogoFrame")

	gui.Visible = true
end)


