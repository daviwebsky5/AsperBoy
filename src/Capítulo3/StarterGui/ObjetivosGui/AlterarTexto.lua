-- LocalScript (colocar dentro do TextLabel que exibe o texto)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FadeText = require(ReplicatedStorage:WaitForChild("FadeTextModule"))
local FadeStroke = require(ReplicatedStorage:WaitForChild("FadeStrokeModule"))
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Se o LocalScript está dentro do TextLabel, script.Parent é o label
local label = script.Parent
if not label or not label:IsA("TextLabel") then
	warn("[Client] O LocalScript não está filho de um TextLabel. Ajuste a variável 'label'.")
	local pg = player:WaitForChild("PlayerGui")
	local gui = pg:FindFirstChild("ObjetivosGui")
	if gui then
		label = gui:FindFirstChildWhichIsA("TextLabel") or label
	end
end

local stroke = label and label:FindFirstChildWhichIsA("UIStroke")

-- Eventos dos objetivos
local OnibusObjetivoEvent = ReplicatedStorage:WaitForChild("OnibusObjetivoEvent")
local PuzzleObjetivoEvent = ReplicatedStorage:FindFirstChild("PuzzleObjetivoEvent")
local SairOnibusObjetivoEvent = ReplicatedStorage:WaitForChild("SairOnibusObjetivoEvent")
local TPObjetivoEvent = ReplicatedStorage:WaitForChild("TpSairOnibusEvent")


-- flags de controle
local objetivoOnibusAtivo = false
local objetivoPuzzleAtivo = false
local objetivoSairOnibusAtivo = false
local objetivoTPAtivo = false

local tamanhoOriginal = label and label.TextSize or 24
local tamanhoFinal = math.max(14, tamanhoOriginal - 7)






TPObjetivoEvent.OnClientEvent:Connect(function(ativo)
	print("[Client] Recebi TPObjetivoEvent:", ativo)
	objetivoTPAtivo = ativo and true or false
end)

SairOnibusObjetivoEvent.OnClientEvent:Connect(function(ativo)
	print("[Client] Recebi SairOnibusObjetivoEvent:", ativo)
	objetivoSairOnibusAtivo = ativo and true or false
end)


-- Recebe ativação do objetivo do ônibus
OnibusObjetivoEvent.OnClientEvent:Connect(function(ativo)
	print("[Client] Recebi OnibusObjetivoEvent:", ativo)
	objetivoOnibusAtivo = ativo and true or false
end)

-- Recebe ativação do objetivo do puzzle
if PuzzleObjetivoEvent then
	PuzzleObjetivoEvent.OnClientEvent:Connect(function(ativo)
		print("[Client] Recebi PuzzleObjetivoEvent:", ativo)
		objetivoPuzzleAtivo = ativo and true or false
	end)
end

local function getObjetivoTexto()
	if objetivoTPAtivo then
		return "- Vá para a sua casa!"
	end

	if objetivoSairOnibusAtivo then
		return "- Pense em como sair do ônibus"
	end

	if objetivoPuzzleAtivo then
		return "- Vá para o seu lugar!"
	end

	if objetivoOnibusAtivo then
		return "- Fale com o Professor para pegar um lugar no ônibus!"
	end

	return ""
end



-- Loop que atualiza o texto quando algo mudar
task.spawn(function()
	while true do
		if not label then break end

		local novoTexto = getObjetivoTexto()
		if label.Text ~= novoTexto then
			pcall(function()
				FadeText.FadeOut(label, 0.3)
				if stroke then FadeStroke.FadeOut(stroke, 0.3) end
			end)

			label.Text = novoTexto
			label.TextSize = tamanhoOriginal

			pcall(function()
				FadeText.FadeIn(label, 0.3)
				if stroke then FadeStroke.FadeIn(stroke, 0.3) end
			end)
		end

		task.wait(1)
	end
end)

-- Inicialização
if label then
	label.TextTransparency = 0
	if stroke then stroke.Transparency = 0 end
	label.Text = getObjetivoTexto()
end
