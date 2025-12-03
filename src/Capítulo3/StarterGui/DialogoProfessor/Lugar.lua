local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Evento para trocar o objetivo
local TrocarParaObjetivoLugar = ReplicatedStorage:WaitForChild("PuzzleObjetivoEvent")

-- GUI do puzzle
local puzzleGui = playerGui:WaitForChild("DialogoProfessor")
local puzzleFrame = puzzleGui:WaitForChild("Frame")

-- Evento do servidor que abre o puzzle
local eventoAbrir = ReplicatedStorage:WaitForChild("AbrirPuzzleEvent")

-- GUI de diálogo
local dialogoGui = playerGui:WaitForChild("Dialog")
local dialogoFrame = dialogoGui:WaitForChild("Frame")
local botaoNext = dialogoFrame:WaitForChild("NextButton")
local dialogoTexto = dialogoFrame:WaitForChild("DialogLabel")
local dialogoNome = dialogoFrame:WaitForChild("NameLabel")

-- Fade por imagem
local telaPretaGui = playerGui:WaitForChild("TelaPreta")
local imagemFade = telaPretaGui:WaitForChild("ImageFrame"):WaitForChild("Imagem")

-- Botões do puzzle
local b1 = puzzleFrame:WaitForChild("Choice1")
local b2 = puzzleFrame:WaitForChild("Choice2")
local b3 = puzzleFrame:WaitForChild("Choice3")
local b4 = puzzleFrame:WaitForChild("Choice4")

-- Resposta correta
local correta = 3

-- Textos de cada escolha
local textosEscolhas = {
	[1] = "Sente em qualquer um.",
	[2] = "Todos estão sentados, sente-se você também.",
	[3] = "Claro, esse é um direito seu.",
	[4] = "Só sente em qualquer lugar."
}

local nomeNPC = "Professor"

-- Local do jogador ao ser expulso
local pontoSaida = workspace:WaitForChild("PontoDeSaidaOnibus")

-- Highlight + seat da cadeira certa
local cadeiraCerta = workspace:WaitForChild("CadeiraCerta")
local highlight = cadeiraCerta:WaitForChild("Highlight")
local seat = cadeiraCerta:WaitForChild("Seat")

-- Evento para apagar rig
local apagarRigEvent = ReplicatedStorage:WaitForChild("ApagarRigProfessorEvent")

-- Variáveis de estado
local errouAgora = false
local mostrandoTelaPreta = false
local teleportado = false

-------------------------------------------------
-- Função de digitação
-------------------------------------------------
local function digitarTexto(label, texto, tempoPorLetra)
	label.Text = ""
	tempoPorLetra = tempoPorLetra or 0.05
	for i = 1, #texto do
		label.Text = string.sub(texto, 1, i)
		task.wait(tempoPorLetra)
	end
end

-------------------------------------------------
-- Abrir diálogo do professor
-------------------------------------------------
local function abrirDialogo(texto, nome)
	dialogoNome.Text = nome or nomeNPC
	dialogoGui.Enabled = true
	dialogoFrame.Visible = true
	puzzleFrame.Visible = false
	puzzleGui.Enabled = false

	digitarTexto(dialogoTexto, texto)
end

-------------------------------------------------
-- NOVA FUNÇÃO DE FADE COM IMAGEM
-------------------------------------------------
local function fadeImagem(imageLabel, fadeIn, tempo)
	tempo = tempo or 0.5
	local passos = 20
	local dt = tempo / passos

	if fadeIn then
		imageLabel.ImageTransparency = 1
		imageLabel.Visible = true
		for i = 1, passos do
			imageLabel.ImageTransparency = 1 - (i / passos)
			task.wait(dt)
		end
		imageLabel.ImageTransparency = 0
	else
		for i = 1, passos do
			imageLabel.ImageTransparency = i / passos
			task.wait(dt)
		end
		imageLabel.ImageTransparency = 1
		imageLabel.Visible = false
	end
end

-------------------------------------------------
-- Abrir tela preta + diálogo do protagonista
-------------------------------------------------
local function abrirTelaPreta()
	mostrandoTelaPreta = true
	fadeImagem(imagemFade, true, 0.5)

	dialogoGui.Enabled = true
	dialogoFrame.Visible = true
	dialogoNome.Text = "Você"

	digitarTexto(dialogoTexto, "Parece que essa frase não vai funcionar...")

	-- Teleporta o jogador
	if not teleportado then
		local char = player.Character or player.CharacterAdded:Wait()
		local root = char:WaitForChild("HumanoidRootPart")
		root.CFrame = pontoSaida.CFrame + Vector3.new(0, 3, 0)
		teleportado = true
	end
end

-------------------------------------------------
-- Verificar escolha
-------------------------------------------------
local function verificar(num)
	local texto = textosEscolhas[num] or "Sem texto configurado."
	abrirDialogo(texto, nomeNPC)

	if num == correta then
		errouAgora = false

		highlight.Enabled = true
		seat.Disabled = false

		apagarRigEvent:FireServer()

		-- Atualiza objetivo
		ReplicatedStorage.PuzzleObjetivoEvent:FireServer()

	else
		errouAgora = true
		teleportado = false
	end
end

-------------------------------------------------
-- Botões do puzzle
-------------------------------------------------
b1.MouseButton1Click:Connect(function() verificar(1) end)
b2.MouseButton1Click:Connect(function() verificar(2) end)
b3.MouseButton1Click:Connect(function() verificar(3) end)
b4.MouseButton1Click:Connect(function() verificar(4) end)

-------------------------------------------------
-- Botão NEXT do diálogo
-------------------------------------------------
botaoNext.MouseButton1Click:Connect(function()
	dialogoFrame.Visible = false
	dialogoGui.Enabled = false

	if errouAgora and not mostrandoTelaPreta then
		abrirTelaPreta()

	elseif mostrandoTelaPreta then
		fadeImagem(imagemFade, false, 0.5)
		mostrandoTelaPreta = false
	end
end)

-------------------------------------------------
-- Evento do servidor para abrir puzzle
-------------------------------------------------
eventoAbrir.OnClientEvent:Connect(function()
	puzzleGui.Enabled = true
	puzzleFrame.Visible = true
end)
