local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CadeiraPuzzleConcluidoBindable = ReplicatedStorage:WaitForChild("CadeiraPuzzleConcluidoBindable")

-- Quando o jogador completar o puzzle:
local function onPuzzleConcluido()
	print("Puzzle da cadeira finalizado!")
	CadeiraPuzzleConcluidoBindable:Fire()
end

-- Exemplo: jogador senta na cadeira
workspace:WaitForChild("CadeiraTrigger").Touched:Connect(function(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player then
		onPuzzleConcluido()
	end
end)
