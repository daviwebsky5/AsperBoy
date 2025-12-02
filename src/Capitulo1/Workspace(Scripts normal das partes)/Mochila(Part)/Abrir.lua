local clickDetector = script.Parent:WaitForChild("ClickDetector")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local abrirPuzzleMochilaEvent = ReplicatedStorage:WaitForChild("AbrirPuzzleMochilaEvent")

clickDetector.MouseClick:Connect(function(player)
	abrirPuzzleMochilaEvent:FireClient(player) -- avisa só para o jogador que clicou
end)
