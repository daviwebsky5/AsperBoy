local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local evt = game.ReplicatedStorage:FindFirstChild("SetObjetivosConcluidos")
print("Evento encontrado?", evt)

ReplicatedStorage:WaitForChild("SetObjetivosConcluidos")


local evt = ReplicatedStorage:WaitForChild("SetObjetivosConcluidos")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("ObjetivosGui")
local texto = gui.TextObjetivoss
print("Evento existe?", game.ReplicatedStorage:FindFirstChild("SetObjetivosConcluidos"))

texto:GetPropertyChangedSignal("Text"):Connect(function()
	print("TEXTO MUDOU PARA:", texto.Text)  -- DEBUG

	if texto.Text == "Todos os objetivos concluídos!" then
		print("ENVIANDO PARA O SERVIDOR: true") -- DEBUG
		evt:FireServer(true)
	end
end)
