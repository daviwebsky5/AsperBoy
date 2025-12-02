local part = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- garante que o evento exista
local event = ReplicatedStorage:FindFirstChild("CutsceneInicialEvent") or Instance.new("RemoteEvent", ReplicatedStorage)
event.Name = "CutsceneInicialEvent"

local playersActivated = {}

part.Touched:Connect(function(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player and not playersActivated[player] then
		playersActivated[player] = true
		print("[SERVER] Ativando cutscene para:", player.Name)
		event:FireClient(player)
	end
end)
