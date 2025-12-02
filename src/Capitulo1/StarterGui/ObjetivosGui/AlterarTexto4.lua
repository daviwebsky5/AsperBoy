local label = script.Parent
local FadeText = require(game:GetService("ReplicatedStorage"):WaitForChild("FadeTextModule"))
local FadeStroke = require(game:GetService("ReplicatedStorage"):WaitForChild("FadeStrokeModule"))
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game:GetService("Players").LocalPlayer

local stroke = label:FindFirstChildWhichIsA("UIStroke")

-- Eventos
local portaLiberadaEvent = ReplicatedStorage:WaitForChild("PortaQuartoLiberada")
local CozinhaObjetivoEvent = ReplicatedStorage:WaitForChild("CozinhaObjetivoEvent")
local EscolaObjetivoEvent = ReplicatedStorage:WaitForChild("EscolaObjetivoEvent")
local LabirintoConcluidoEvent = ReplicatedStorage:WaitForChild("LabirintoConcluidoEvent")
local ChegouNaEscolaEvent = ReplicatedStorage:WaitForChild("ChegouNaEscolaEvent")
local Escola6ObjetivoEvent = ReplicatedStorage:WaitForChild("Escola6ObjetivoEvent")

-- Novos Bindables para puzzles
local TubosPuzzleConcluidoBindable = ReplicatedStorage:WaitForChild("TubosPuzzleConcluidoBindable")
local AnimaisPuzzleConcluidoBindable = ReplicatedStorage:WaitForChild("AnimaisPuzzleConcluidoBindable")



-- Flags
local mostrouFinal = false
local objetivoCozinhaAtivo = false
local objetivoLabirintoAtivo = false
local chegouNaEscola = false
local objetivosEscola6Ativos = false
local tubosDone = false
local animaisDone = false

local tamanhoOriginal = label.TextSize
local tamanhoFinal = math.max(14, tamanhoOriginal - 7)

-- Conexão dos Bindables
TubosPuzzleConcluidoBindable.Event:Connect(function()
	tubosDone = true
end)

AnimaisPuzzleConcluidoBindable.Event:Connect(function()
	animaisDone = true
end)

-- Função objetivos do quarto
local function getObjetivoTextoOriginal()
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return "" end

	local caixadeBrinquedos = playerGui:FindFirstChild("CaixadeBrinquedos")
	local puzzlegui = playerGui:FindFirstChild("PuzzleGui")

	local completedLabel = caixadeBrinquedos and caixadeBrinquedos:FindFirstChild("PuzzleFrame") and caixadeBrinquedos.PuzzleFrame:FindFirstChild("CompletedLabel")
	local completedLabel2 = puzzlegui and puzzlegui:FindFirstChild("PuzzleFrame2") and puzzlegui.PuzzleFrame2:FindFirstChild("CompletedLabel2")

	local brinquedosDone = completedLabel and completedLabel:GetAttribute("WasVisible")
	local mochilaDone = completedLabel2 and completedLabel2:GetAttribute("WasVisible")

	local objetivos = {}

	if not brinquedosDone then table.insert(objetivos, "- Organize seus brinquedos") end
	if not mochilaDone then table.insert(objetivos, "- Arrume sua mochila") end

	if #objetivos == 0 then
		return "Todos os objetivos concluídos!"
	else
		return table.concat(objetivos, "\n")
	end
end

-- Função objetivos da cozinha/biscoito
local function getObjetivoTextoCozinhaBiscoito()
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return "" end

	local cozinhaGui = playerGui:FindFirstChild("CozinhaGui")
	local biscoitoGui = playerGui:FindFirstChild("BiscoitoGui")

	local function findLabelRecursive(parent, name)
		if not parent then return nil end
		return parent:FindFirstChild(name, true)
	end

	local cozinhaCompletedLabel = cozinhaGui and findLabelRecursive(cozinhaGui, "CompletadoLabel2")
	local biscoitoCompletedLabel = biscoitoGui and findLabelRecursive(biscoitoGui, "CompletadoLabel")

	local cozinhaVisible = cozinhaCompletedLabel and (cozinhaCompletedLabel.Visible or cozinhaCompletedLabel:GetAttribute("WasVisible"))
	local biscoitoVisible = biscoitoCompletedLabel and (biscoitoCompletedLabel.Visible or biscoitoCompletedLabel:GetAttribute("WasVisible"))

	if cozinhaVisible and biscoitoVisible then
		return "Todos os objetivos concluídos!"
	elseif cozinhaVisible then
		return "- Organize os biscoitos na mesa"
	elseif biscoitoVisible then
		return "- Coloque o leite no copo"
	else
		return "- Organize os biscoitos na mesa\n- Coloque o leite no copo"
	end
end


-- Função objetivos da escola (substitui objetivos antigos)
local function getObjetivoTextoEscola6()
	local objetivos = {}
	if not tubosDone then table.insert(objetivos, "- Organize os tubos de ensaio") end
	if not animaisDone then table.insert(objetivos, "- Descubra qual o animal") end

	if #objetivos == 0 then
		return "Todos os objetivos concluídos!" -- Mostra quando todos finalizados
	end
	return table.concat(objetivos, "\n")
end

-- Decide qual texto mostrar
local function getObjetivoTexto()
	if objetivosEscola6Ativos then
		return getObjetivoTextoEscola6()
	elseif chegouNaEscola then
		return "- Vá para a sua sala"
	elseif objetivoLabirintoAtivo then
		return "- Vá para a escola"
	elseif objetivoCozinhaAtivo then
		return getObjetivoTextoCozinhaBiscoito()
	else
		return getObjetivoTextoOriginal()
	end
end

-- Loop de atualização do label
task.spawn(function()
	local bloqueioDesativado = false
	while true do
		local novoTexto = getObjetivoTexto()
		if label.Text ~= novoTexto then
			FadeText.FadeOut(label, 0.3)
			if stroke then FadeStroke.FadeOut(stroke, 0.3) end

			label.Text = novoTexto
			label.TextSize = (novoTexto:find("café") ~= nil) and tamanhoFinal or tamanhoOriginal

			FadeText.FadeIn(label, 0.3)
			if stroke then FadeStroke.FadeIn(stroke, 0.3) end
		end

	
		task.wait(1)
	end
end)

-- Conexão dos eventos originais
portaLiberadaEvent.OnClientEvent:Connect(function() mostrouFinal = true end)
CozinhaObjetivoEvent.OnClientEvent:Connect(function() objetivoCozinhaAtivo = true end)
EscolaObjetivoEvent.OnClientEvent:Connect(function() objetivoLabirintoAtivo = true end)
LabirintoConcluidoEvent.OnClientEvent:Connect(function() objetivoLabirintoAtivo = false end)
ChegouNaEscolaEvent.OnClientEvent:Connect(function() chegouNaEscola = true end)
Escola6ObjetivoEvent.OnClientEvent:Connect(function() objetivosEscola6Ativos = true end)

-- Inicialização
label.TextTransparency = 0
if stroke then stroke.Transparency = 0 end
label.Text = getObjetivoTexto()

