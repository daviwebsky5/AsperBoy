local BadgeService = game:GetService("BadgeService")
local ID_CAP2 = 2246122522529258 -- coloque o ID do emblema do capítulo 2

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PuzzleConcluido2 = ReplicatedStorage:WaitForChild("PuzzleConcluido2") -- evento que você cria

local function darEmblema(jogador)
	if not BadgeService:UserHasBadgeAsync(jogador.UserId, ID_CAP2) then
		BadgeService:AwardBadge(jogador.UserId, ID_CAP2)
	end
end

PuzzleConcluido2.OnServerEvent:Connect(function(player)
	darEmblema(player)
end)
