-- ServerScript dentro de CadeiraCinema
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local desativarDialogoEvent = ReplicatedStorage:WaitForChild("DesativarDialogoCadeiras")

local cadeira = script.Parent
local clickDetector = cadeira:WaitForChild("ClickDetector")

-- Quando o jogador clicar na cadeira certa
clickDetector.MouseClick:Connect(function(player)
	print(player.Name .. " clicou na cadeira certa!")


	-- 🔹 Desativa os diálogos das cadeiras erradas só pra esse jogador
	desativarDialogoEvent:FireClient(player)
end)
