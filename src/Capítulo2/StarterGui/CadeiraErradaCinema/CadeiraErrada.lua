-- LocalScript - Detecta cliques em cadeiras erradas e mostra diálogo do protagonista
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Nome da GUI de diálogo
local gui = playerGui:WaitForChild("CadeiraErradaCinema")
local frame = gui:WaitForChild("Frame")
local nameLabel = frame:WaitForChild("NameLabel")
local dialogLabel = frame:WaitForChild("DialogLabel")
local nextButton = frame:WaitForChild("NextButton")

-- RemoteEvent que vai desativar os diálogos
local desativarDialogoEvent = ReplicatedStorage:WaitForChild("DesativarDialogoCadeiras")

-- Nome da cadeira certa
local nomeCadeiraCerta = "CadeiraCinema"

-- Falas específicas por cadeira
local falasPorCadeira = {
	["Cadera de cine1"] = {
		"Está longe o suficiente da tela, mas eu não quero sentar aqui..."
	},
	["Cadera de cine2"] = {
		"Muito no meio do cinema, está cheio de pessoas, não quero sentar aqui..."
	},
	["Cadera de cine3"] = {
		"Ainda está perto da tela, não quero sentar aqui..."
	},
	["Cadera de cine4"] = {
		"Muito perto da tela, isso me incomoda."
	},
	["Cadera de cine5"] = {
		"Não está perto da porta, não quero sentar aqui."
	},
	["cadeira5"] = {
		"Está no fundo, mas eu não quero sentar no meio da fileira."
	},
}

-- Controle para impedir cliques simultâneos
local dialogoAtivo = false
local dialogosHabilitados = true -- esse será desativado pelo RemoteEvent

-- Função: efeito de digitação no texto
local function digitarTexto(texto)
	dialogLabel.Text = ""
	for i = 1, #texto do
		dialogLabel.Text = string.sub(texto, 1, i)
		task.wait(0.02)
	end
end

-- Função: mostra o diálogo com botão "Próximo"
local function mostrarDialogo(texto)
	dialogoAtivo = true
	frame.Visible = true
	nameLabel.Text = "Você"
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nextButton.Visible = false

	digitarTexto(texto)
	task.wait(0.2)
	nextButton.Visible = true

	local clicked = false
	local conn
	conn = nextButton.MouseButton1Click:Connect(function()
		clicked = true
		conn:Disconnect()
	end)

	repeat task.wait() until clicked
	frame.Visible = false
	dialogoAtivo = false
end

-- Evento para desativar definitivamente os diálogos
desativarDialogoEvent.OnClientEvent:Connect(function()
	dialogosHabilitados = false
	print("💬 Diálogos das cadeiras erradas desativados.")
end)

-- Conecta todos os ClickDetectors das cadeiras
for _, obj in pairs(workspace:GetDescendants()) do
	if obj:IsA("ClickDetector") then
		local cadeira = obj.Parent

		obj.MouseClick:Connect(function(clickPlayer)
			if clickPlayer ~= player then return end
			if dialogoAtivo then return end
			if not dialogosHabilitados then return end -- bloqueia se o evento foi chamado

			local nome = cadeira.Name

			if nome == nomeCadeiraCerta then
				print("Cadeira certa clicada!")
				-- Aqui você pode colocar o código pra sentar
				return
			end

			local falas = falasPorCadeira[nome]
			if falas then
				local fala = falas[math.random(1, #falas)]
				mostrarDialogo(fala)
			end
		end)
	end
end
