-- ServerScriptService > Script
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Nome do Rig que será apagado
local nomeRigB = "RigMarcado2"

-- RemoteEvent já existente
local apagarRigEvent = ReplicatedStorage:WaitForChild("ApagarRigEvent")

-- Quando o jogador interagir com o Rig A (via ProximityPrompt)
local rigA = Workspace:WaitForChild("Professor") -- Rig que tem o ProximityPrompt
local prompt = rigA:FindFirstChildOfClass("ProximityPrompt")

prompt.Triggered:Connect(function(player)
	-- Apaga o Rig B
	local rigB = Workspace:FindFirstChild(nomeRigB)
	if rigB then
		rigB:Destroy()
		print("🧹 Rig B apagado por " .. player.Name)

		-- Dispara para o cliente liberar o Seat
		apagarRigEvent:FireClient(player)
	else
		warn("⚠️ Rig B não encontrado")
	end

	-- Desativa o prompt do Rig A
	prompt.Enabled = false
end)
