local rep = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local evt = rep:WaitForChild("SetObjetivosConcluidos")
local objetivoFlag = workspace:WaitForChild("ObjetivosConcluidos")

evt.OnServerEvent:Connect(function(player, valor)
	objetivoFlag.Value = valor
	print("Objetivos concluídos = ", valor)
end)
