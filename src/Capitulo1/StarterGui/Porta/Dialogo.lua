-- Referências
local player = game.Players.LocalPlayer
local frame = script.Parent
local speakerLabel = frame:WaitForChild("SpeakerName")
local textLabel = frame:WaitForChild("DialogueText")
local nextButton = frame:WaitForChild("NextButton")

frame.Visible = false

-- Diálogos personalizados por porta
local dialogos = {
	default = {
		{speaker = "Você", text = "Não posso entrar aqui."}
	},
	porta1 = {
		{speaker = "Você", text = "Não quero ir no banheiro agora."}
	},
	porta2 = {
		{speaker = "Você", text = "Não posso ir para a biblioteca, tenho que ir para a aula."}
	},
	porta3 = {
		{speaker = "Você", text = "Não tem porque entrar na sala do zelador."}
	},
	porta4 = {
		{speaker = "Você", text = "Essa é a sala de outra turma."}
	}
}

local indice = 1
local mostrando = false
local falaAtual = {}

-- Função para mostrar texto letra por letra
local function mostrarFala(dialogo)
	mostrando = true
	speakerLabel.Text = dialogo.speaker
	textLabel.Text = ""
	for i = 1, #dialogo.text do
		textLabel.Text = string.sub(dialogo.text, 1, i)
		task.wait(0.03)
	end
	mostrando = false
end

-- Inicia o diálogo
local function iniciarDialogo(falas)
	falaAtual = falas
	indice = 1
	frame.Visible = true
	mostrarFala(falaAtual[indice])
end

-- Avança para a próxima fala
nextButton.MouseButton1Click:Connect(function()
	if mostrando then return end
	indice += 1
	if indice <= #falaAtual then
		mostrarFala(falaAtual[indice])
	else
		frame.Visible = false
	end
end)

-- Recebe evento da porta errada
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local evento = ReplicatedStorage:WaitForChild("PortaErradaEvent")

evento.OnClientEvent:Connect(function(nomePorta)
	local chave = string.lower(nomePorta)
	local falas = dialogos[chave] or dialogos.default
	iniciarDialogo(falas)
end)
