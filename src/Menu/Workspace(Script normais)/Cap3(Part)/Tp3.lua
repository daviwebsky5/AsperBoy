local TeleportService = game:GetService("TeleportService")


local CAP3_PLACE_ID = 3333333333

script.Parent.ProximityPrompt.Triggered:Connect(function(player)
	TeleportService:Teleport(CAP3_PLACE_ID, player)
end)
