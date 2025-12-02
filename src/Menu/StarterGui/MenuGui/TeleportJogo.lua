local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local placeId = 108232611417164 -- coloque aqui o ID do jogo principal

script.Parent.MouseButton1Click:Connect(function()
	TeleportService:Teleport(placeId, player)
end)
