local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TPObjetivoEvent = ReplicatedStorage:WaitForChild("TpSairOnibusEvent")

TPObjetivoEvent.OnServerEvent:Connect(function(player)
	print("[Server] Ativando objetivo pós-TP para:", player.Name)
	TPObjetivoEvent:FireClient(player, true)
end)
