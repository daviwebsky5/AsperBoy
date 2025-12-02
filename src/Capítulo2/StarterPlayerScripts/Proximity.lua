-- LocalScript (StarterPlayerScripts)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local alterarTextoEvent = ReplicatedStorage:WaitForChild("AlterarTextoPuzzleCinema")
local rigProfessor = Workspace:WaitForChild("Professor")
local prompt = rigProfessor:WaitForChild("ProximityPrompt")

-- começa desativado
prompt.Enabled = false

-- quando o evento for disparado (puzzle do cinema completo)
alterarTextoEvent.Event:Connect(function()
	task.wait(0.5)
	print("✅ Objetivo: Fale com o professor — prompt ativado!")
	prompt.Enabled = true
end)
