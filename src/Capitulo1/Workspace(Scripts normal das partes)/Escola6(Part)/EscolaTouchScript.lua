local part = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Escola6ObjetivoEvent = ReplicatedStorage:WaitForChild("Escola6ObjetivoEvent")

part.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:GetPlayerFromCharacter(character)
	if player then
		-- dispara evento para ativar os puzzles da escola
		Escola6ObjetivoEvent:FireClient(player)
	end
end)
