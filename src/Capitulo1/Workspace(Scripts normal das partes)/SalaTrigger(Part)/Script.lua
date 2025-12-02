local trigger = script.Parent -- A Part da sala
local objeto = workspace:WaitForChild("Pia") -- o objeto que vai ter highlight
local model = workspace:WaitForChild("tableBiscoito") -- a mesa
local highlight = objeto:WaitForChild("Highlight")
local tableHighlight = model:FindFirstChild("Highlight") -- highlight da mesa

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

