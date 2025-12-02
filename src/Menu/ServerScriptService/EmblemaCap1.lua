local BadgeService = game:GetService("BadgeService")
local TeleportService = game:GetService("TeleportService")

-- IDs DOS BADGES
local BADGE_CAP1 = 2262449730729236   -- jogador precisa disso para desbloquear o capítulo 2
local BADGE_CAP2 = 2246122522529258   -- jogador precisa disso para desbloquear o capítulo 3

-- PLACE IDs
local PLACEID_CAP2 = 76209674829214
local PLACEID_CAP3 = 95713308367639

-- PARTS E PROMPTS DO MENU
local cap2Part = workspace:WaitForChild("Cap2Part")
local prompt2 = cap2Part:WaitForChild("ProximityPrompt")

local cap3Part = workspace:WaitForChild("Cap3Part")
local prompt3 = cap3Part:WaitForChild("ProximityPrompt")

-- prompts começam desativados
prompt2.Enabled = false
prompt3.Enabled = false

-- Quando o jogador entra no menu
game.Players.PlayerAdded:Connect(function(player)

	-----------------------------
	-- LIBERAR CAPÍTULO 2
	-----------------------------
	local sucesso2, temCap1 = pcall(function()
		return BadgeService:UserHasBadgeAsync(player.UserId, BADGE_CAP1)
	end)

	if sucesso2 and temCap1 then
		prompt2.Enabled = true
	end

	-----------------------------
	-- LIBERAR CAPÍTULO 3
	-----------------------------
	local sucesso3, temCap2 = pcall(function()
		return BadgeService:UserHasBadgeAsync(player.UserId, BADGE_CAP2)
	end)

	if sucesso3 and temCap2 then
		prompt3.Enabled = true
	end
end)

-----------------------------------------------------
-- QUANDO O JOGADOR USA O PROMPT → TELEPORTA
-----------------------------------------------------

prompt2.Triggered:Connect(function(player)
	TeleportService:Teleport(PLACEID_CAP2, player)
end)

prompt3.Triggered:Connect(function(player)
	TeleportService:Teleport(PLACEID_CAP3, player)
end)
