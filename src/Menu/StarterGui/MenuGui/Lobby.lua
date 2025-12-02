local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local button = script.Parent -- Botão Carregar
local menuGui = playerGui:WaitForChild("MenuGui")

button.MouseButton1Click:Connect(function()
	-- Esconde o menu
	menuGui.Enabled = false

end)
