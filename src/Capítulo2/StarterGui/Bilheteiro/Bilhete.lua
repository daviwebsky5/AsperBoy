local ReplicatedStorage = game:GetService("ReplicatedStorage") 
local Players = game:GetService("Players")

-- RemoteEvent para avisar o servidor
local RemoveProximityEvent = ReplicatedStorage:WaitForChild("RemoveProximityEvent")

local player = Players.LocalPlayer
local gui = script.Parent
local frame = gui:WaitForChild("Frame")
local nameLabel = frame:WaitForChild("NameLabel")
local dialogLabel = frame:WaitForChild("DialogLabel")
local nextButton = frame:WaitForChild("NextButton")

-- Eventos vindos do servidor
local BilheteiroDialogEvent = ReplicatedStorage:WaitForChild("BilheteiroDialogEvent")
local AvisoBilheteiroEvent = ReplicatedStorage:WaitForChild("AvisoBilheteiroEvent")

-- Controle para mostrar apenas uma vez
local jaFalouComBilheteiro = false
local jaMostrouAviso = false

-- Função de diálogo
local function executarDialogo(personagem, falas)
	frame.Visible = true

	for _, fala in ipairs(falas) do
		nameLabel.Text = personagem
		dialogLabel.Text = ""

		-- ⛔ Esconde o botão antes de escrever a fala
		nextButton.Visible = false

		-- Escreve letra por letra
		for i = 1, #fala do
			dialogLabel.Text = string.sub(fala, 1, i)
			task.wait(0.03)
		end

		-- ✅ Só APÓS terminar de escrever, o botão aparece
		nextButton.Visible = true

		nextButton.MouseButton1Click:Wait()
	end

	frame.Visible = false
end

-- Quando o jogador fala com o bilheteiro
BilheteiroDialogEvent.OnClientEvent:Connect(function()
	if not jaFalouComBilheteiro then
		executarDialogo("Bilheteiro", {
			"Boa tarde! Vou falar algumas regras do cinema antes de você entrar...",
			"1º Não trazer comida de fora\n2º Não fumar\n3º Não usar óculos escuros",
			"4º Não gravar o filme\n5º Não usar o celular.",
			"Com isso em mente, tenha um bom filme!"
		})

		jaFalouComBilheteiro = true
		RemoveProximityEvent:FireServer() -- avisa o servidor para remover o ProximityPrompt
	end
end)

-- Quando o jogador tenta entrar sem falar com o bilheteiro
AvisoBilheteiroEvent.OnClientEvent:Connect(function()
	if not jaFalouComBilheteiro and not jaMostrouAviso then
		executarDialogo("Bilheteiro", {
			"Ei! Você esqueceu de falar comigo!",
			"Venha aqui antes de entrar, por favor."
		})

		jaMostrouAviso = true
	end
end)
