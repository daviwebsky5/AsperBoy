local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local apagarRigEvent = ReplicatedStorage:WaitForChild("ApagarRigProfessorEvent")

-- Nome do rig e do prompt
local nomeDoRig = "RigMarcado"
local professorModel = Workspace:WaitForChild("Professor")
local prompt = professorModel:WaitForChild("ProximityPrompt")

apagarRigEvent.OnServerEvent:Connect(function(player)
	print("Jogador acertou o puzzle! Apagando rig e desativando prompt...")

	-- Apaga o rig
	local rig = Workspace:FindFirstChild(nomeDoRig)
	if rig then
		rig:Destroy()
		print("Rig destruído!")
	end

	-- Desativa o ProximityPrompt (não dá mais para abrir o puzzle)
	if prompt then
		prompt.Enabled = false
		print("Prompt desativado!")
	end
end)
