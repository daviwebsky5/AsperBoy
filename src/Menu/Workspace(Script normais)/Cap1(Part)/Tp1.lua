local TeleportService = game:GetService("TeleportService")

local CAP1_PLACE_ID = 108232611417164 -- coloque o ID do cap1

script.Parent.ProximityPrompt.Triggered:Connect(function(player)
	TeleportService:Teleport(CAP1_PLACE_ID, player)
end)
