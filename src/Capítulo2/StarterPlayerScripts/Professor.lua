local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local cadeira = Workspace:WaitForChild("CadeiraCinema")
local highlight = cadeira:WaitForChild("Highlight")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

local dialogGui = gui:WaitForChild("DialogResultGui")
local frame = dialogGui:WaitForChild("Frame")
local nameLabel = frame:WaitForChild("NameLabel")
local dialogLabel = frame:WaitForChild("DialogLabel")
local nextButton = frame:WaitForChild("NextButton")

local apagarRigEvent = ReplicatedStorage:WaitForChild("ApagarRigEvent")
local prompt = Workspace:WaitForChild("Professor"):WaitForChild("ProximityPrompt")

-- 🌟 Cor fixa do Professor
local professorColor = Color3.fromRGB(99, 113, 203)

-- Função de digitação
local function typeText(label, text, speed)
	label.Text = ""
	for i = 1, #text do
		label.Text = string.sub(text, 1, i)
		task.wait(speed or 0.03)
	end
end

-- Função de fade
local function fadeScreen(duration, reverse)
	local fadeGui = gui:FindFirstChild("FadeGui")
	if not fadeGui then
		fadeGui = Instance.new("ScreenGui")
		fadeGui.Name = "FadeGui"
		fadeGui.DisplayOrder = 9999
		fadeGui.IgnoreGuiInset = true
		fadeGui.Parent = gui
	end

	local frameFade = fadeGui:FindFirstChild("Frame")
	if not frameFade then
		frameFade = Instance.new("Frame")
		frameFade.Name = "Frame"
		frameFade.Size = UDim2.new(1,0,1,0)
		frameFade.BackgroundColor3 = Color3.new(0,0,0)
		frameFade.BackgroundTransparency = 1
		frameFade.BorderSizePixel = 0
		frameFade.Parent = fadeGui
	end

	local targetTransparency = reverse and 1 or 0
	local tween = TweenService:Create(frameFade, TweenInfo.new(duration), {BackgroundTransparency = targetTransparency})
	tween:Play()
	tween.Completed:Wait()
end

prompt.Triggered:Connect(function()
	dialogGui.Enabled = true
	prompt.Enabled = false

	-- ✅ Salvar estado ORIGINAL (antes de mudar qualquer coisa)
	local originalNameColor = nameLabel.BackgroundColor3
	local originalDialogColor = dialogLabel.TextColor3
	local originalNameText = nameLabel.Text

	local falas = {
		{nome="Professor", texto="O que foi, Jhon Asperboy?"},
		{nome="Você", texto="Não querem sair do lugar que eu quero, e eu tenho asperger, outros lugares eu me sentiria desconfortável..."},
		{nome="Professor", texto="Entendido. Vou tentar resolver isso."},

		{nome="FADE", texto="FADE"},

		{nome="Professor", texto="Tudo certo agora, Jhon AsperBoy. Resolvi o problema."},
		{nome="Você", texto="Obrigado, professor!"}
	}

	local indice = 1
	local typingFinished = false
	nextButton.Visible = true
	nextButton.Text = "Próximo"
	local connection

	local function applySpeakerColor(name)
		-- Sempre começa restaurando as cores originais
		nameLabel.BackgroundColor3 = originalNameColor
		dialogLabel.TextColor3 = originalDialogColor

		-- Se for o Professor → cor azul
		if name == "Professor" then
			nameLabel.BackgroundColor3 = professorColor
			dialogLabel.TextColor3 = professorColor
		end
	end

	local function showNext()
		if not typingFinished then return end
		if connection then connection:Disconnect() end

		if indice > #falas then
			-- ✅ Restaurar tudo no final do diálogo
			nameLabel.BackgroundColor3 = originalNameColor
			dialogLabel.TextColor3 = originalDialogColor
			nameLabel.Text = originalNameText
			dialogGui.Enabled = false

			-- ✅ DISPARA O OBJETIVO
			local PuzzleProfessorCompleted = ReplicatedStorage:WaitForChild("PuzzleProfessorCompleted")
			PuzzleProfessorCompleted:Fire() -- ou FireServer() se for RemoteEvent

			return
		end


		local falaAtual = falas[indice]

		-- Evento especial FADE
		if falaAtual.nome == "FADE" then
			typingFinished = false
			apagarRigEvent:FireServer()

			-- ⭐ Liga o highlight da cadeira
			highlight.Enabled = true


			task.spawn(function()
				fadeScreen(0.2, false)
				task.wait(2)
				fadeScreen(1, true)
				typingFinished = true
			end)

			indice += 1

			if indice <= #falas then
				local proxima = falas[indice]
				applySpeakerColor(proxima.nome)
				nameLabel.Text = proxima.nome
				typingFinished = false
				task.spawn(function()
					typeText(dialogLabel, proxima.texto, 0.03)
					typingFinished = true
				end)
				indice += 1
			end

			connection = nextButton.MouseButton1Click:Connect(showNext)
			return
		end

		applySpeakerColor(falaAtual.nome)
		nameLabel.Text = falaAtual.nome

		typingFinished = false
		task.spawn(function()
			typeText(dialogLabel, falaAtual.texto, 0.03)
			typingFinished = true
		end)

		indice += 1
		connection = nextButton.MouseButton1Click:Connect(showNext)
	end

	-- Primeira fala
	local primeira = falas[indice]
	applySpeakerColor(primeira.nome)
	nameLabel.Text = primeira.nome

	typingFinished = false
	task.spawn(function()
		typeText(dialogLabel, primeira.texto, 0.03)
		typingFinished = true
	end)

	indice += 1
	connection = nextButton.MouseButton1Click:Connect(showNext)
end)
