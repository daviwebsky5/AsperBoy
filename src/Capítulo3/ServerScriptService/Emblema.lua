local BadgeService = game:GetService("BadgeService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- coloque o ID do emblema do capítulo 3
local BADGE_CAP3 = 4446194636020704  -- 🟥 substitua pelo ID do seu emblema

local evento3 = ReplicatedStorage:WaitForChild("PuzzleConcluido3")

evento3.OnServerEvent:Connect(function(player)
	if not BadgeService:UserHasBadgeAsync(player.UserId, BADGE_CAP3) then
		BadgeService:AwardBadge(player.UserId, BADGE_CAP3)
	end
end)
