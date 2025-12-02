local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sairEvent = ReplicatedStorage:WaitForChild("SairOnibusObjetivoEvent")

sairEvent.OnServerEvent:Connect(function(player)
	print("[Server] Jogador levantou, ativando objetivo.")
	sairEvent:FireClient(player, true)
end)
