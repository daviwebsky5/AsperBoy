local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BadgeService = game:GetService("BadgeService")

local finalizarDialogo = ReplicatedStorage:WaitForChild("FinalizarDialogo")

-- COLOQUE AQUI O ID DO SEU EMBLEMA
local BADGE_CAPITULO1 = 2262449730729236

local function darBadge(player)
	-- Verifica se o jogador já tem
	local success, hasBadge = pcall(function()
		return BadgeService:UserHasBadgeAsync(player.UserId, BADGE_CAPITULO1)
	end)

	if success and not hasBadge then
		pcall(function()
			BadgeService:AwardBadge(player.UserId, BADGE_CAPITULO1)
		end)

		print("Badge do Capítulo 1 entregue para:", player.Name)
	end
end

-- QUANDO O DIÁLOGO ACABA NO CLIENTE
finalizarDialogo.OnServerEvent:Connect(function(player)
	darBadge(player)

end)
