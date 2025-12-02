local TeleportService = game:GetService("TeleportService")

local CAP2_PLACE_ID = 76209674829214 -- coloque o ID do cap2

script.Parent.ProximityPrompt.Triggered:Connect(function(player)
	TeleportService:Teleport(CAP2_PLACE_ID, player)
end)
