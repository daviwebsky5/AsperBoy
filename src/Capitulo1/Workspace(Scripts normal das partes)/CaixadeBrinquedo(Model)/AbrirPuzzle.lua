local clickDetector = script.Parent:WaitForChild("ClickDetector")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local abrirPuzzleBrinquedosEvent = ReplicatedStorage:WaitForChild("AbrirPuzzleBrinquedosEvent")

clickDetector.MouseClick:Connect(function(player)
	abrirPuzzleBrinquedosEvent:FireClient(player) -- avisa só para o jogador que clicou
end)


