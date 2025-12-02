local trigger = script.Parent 
local objeto = workspace:WaitForChild("Animals")
local model = workspace:WaitForChild("TuboTeste")
local highlight = objeto:WaitForChild("Highlight")
local tableHighlight = model:FindFirstChild("Highlight") 

local Players = game:GetService("Players")

-- Ativar highlight quando o jogador entra
trigger.Touched:Connect(function(hit)
	local player = Players:GetPlayerFromCharacter(hit.Parent)
	if player then
		highlight.Enabled = true
		if tableHighlight then
			tableHighlight.Enabled = true
		end
	end
end)

