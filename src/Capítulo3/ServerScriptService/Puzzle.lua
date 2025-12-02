local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PuzzleObjetivoEvent = ReplicatedStorage:WaitForChild("PuzzleObjetivoEvent")

PuzzleObjetivoEvent.OnServerEvent:Connect(function(player)
	print("[Server] Jogador terminou o puzzle:", player.Name)

	-- Agora sim pode mandar para o cliente
	PuzzleObjetivoEvent:FireClient(player, true)
end)
