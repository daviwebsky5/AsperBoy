local workspace = game:GetService("Workspace")

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local objetivosGui = playerGui:WaitForChild("ObjetivosGui")

local texto = objetivosGui.TextObjetivoss
local objetivoFlag = workspace:WaitForChild("ObjetivosConcluidos")

local function checar()
	if texto.Text == "Todos os objetivos concluídos!" then
		-- habilita a porta para abrir
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local evt = ReplicatedStorage:WaitForChild("SetObjetivosConcluidos")

		evt:FireServer(true)

	end
end

texto:GetPropertyChangedSignal("Text"):Connect(checar)
