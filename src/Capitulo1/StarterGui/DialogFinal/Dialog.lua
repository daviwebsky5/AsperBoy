local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- GUI
local gui = script.Parent
local frame = gui:WaitForChild("DialogueFrame")
local nameLabel = frame:WaitForChild("SpeakerName")
local dialogLabel = frame:WaitForChild("DialogueText")
local nextButton = frame:WaitForChild("NextButton")

-- CONFIG DO DIÁLOGO
local falas = {
	{nome = "Professora", texto = "Muito bem AsperBoy!!!"},
	{nome = "Professora", texto = "Agora iremos para uma aula passeio."},
	{nome = "Professora", texto = "Espero que goste!"},
}

local index = 1
frame.Visible = false  -- fica escondido até iniciar

-- FUNÇÃO PARA MOSTRAR O DIÁLOGO
local function MostrarDialogo()
	frame.Visible = true
	nameLabel.Visible = true
	dialogLabel.Visible = true
	nextButton.Visible = true

	local fala = falas[index]
	nameLabel.Text = fala.nome
	dialogLabel.Text = fala.texto
end

-- NEXT BUTTON
nextButton.MouseButton1Click:Connect(function()
	index += 1

	if index <= #falas then
		local fala = falas[index]
		nameLabel.Text = fala.nome
		dialogLabel.Text = fala.texto
	else
		-- acabou diálogo
		frame.Visible = false

		-- avisa o servidor que terminou
		local finalizarDialogo = ReplicatedStorage:WaitForChild("FinalizarDialogo")
		finalizarDialogo:FireServer()

	end
end)

-- SE VOCÊ USAR UM REMOTEEVENT PARA INICIAR
local remote = ReplicatedStorage:FindFirstChild("DialogoFinal")
if remote then
	remote.OnClientEvent:Connect(function()
		index = 1
		MostrarDialogo()
	end)
end
