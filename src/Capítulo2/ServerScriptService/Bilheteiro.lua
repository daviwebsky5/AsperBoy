local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- cria o RemoteEvent caso não exista
local RemoveProximityEvent = ReplicatedStorage:FindFirstChild("RemoveProximityEvent")
if not RemoveProximityEvent then
	RemoveProximityEvent = Instance.new("RemoteEvent")
	RemoveProximityEvent.Name = "RemoveProximityEvent"
	RemoveProximityEvent.Parent = ReplicatedStorage
end

-- caminho do seu ProximityPrompt
local prompt = workspace:WaitForChild("TriggerBilheteiro"):WaitForChild("ProximityPrompt")

RemoveProximityEvent.OnServerEvent:Connect(function(player)
	if prompt then
		prompt.Enabled = false
		print("ProximityPrompt removido para o jogador:", player.Name)
	end
end)
