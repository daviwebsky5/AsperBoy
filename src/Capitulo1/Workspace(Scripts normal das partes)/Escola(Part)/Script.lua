local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChegouNaEscolaEvent = ReplicatedStorage:WaitForChild("ChegouNaEscolaEvent")

local escolaPart = workspace:WaitForChild("Escola") -- a part que o jogador pisa

local function onTouched(hit)
	local player = game:GetService("Players"):GetPlayerFromCharacter(hit.Parent)
	if player then
		-- dispara evento para atualizar o objetivo
		ChegouNaEscolaEvent:FireClient(player)
	end
end

escolaPart.Touched:Connect(onTouched)
