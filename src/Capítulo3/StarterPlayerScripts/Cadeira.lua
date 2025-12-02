local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

print("LocalScript carregado!")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local playerGui = player:WaitForChild("PlayerGui")
local TransicaoGui = playerGui:WaitForChild("TransicaoGui")
local TelaPreta = TransicaoGui:WaitForChild("TelaPreta")
local Mensagem = TelaPreta:WaitForChild("Mensagem")
local PuzzleGui = playerGui:WaitForChild("SairOnibus")

-- Evento para ativar o objetivo de sair do ônibus
local SairOnibusObjetivoEvent = ReplicatedStorage:WaitForChild("SairOnibusObjetivoEvent")

local cadeiraModel = workspace:WaitForChild("CadeiraCerta")
local cadeiraSeat = cadeiraModel:WaitForChild("Seat")

-- Pega o highlight da cadeira (se existir)
local highlight = cadeiraModel:FindFirstChildWhichIsA("Highlight")

local sentado = false

-- Função de fade
local function fade(uiObject, alvo, tempo)
	local tween = TweenService:Create(
		uiObject,
		TweenInfo.new(tempo, Enum.EasingStyle.Quad),
		{BackgroundTransparency = alvo}
	)
	tween:Play()
	return tween
end

-- Quando o jogador senta
humanoid.Seated:Connect(function(active, seatPart)
	if active and seatPart == cadeiraSeat and not sentado then
		print("Protagonista sentou na CadeiraCerta!")
		sentado = true

		-- Delay da cutscene
		task.wait(2)

		TelaPreta.Visible = true
		TelaPreta.BackgroundTransparency = 1
		Mensagem.TextTransparency = 1
		Mensagem.Text = "chegando na escola..."

		fade(TelaPreta, 0, 1)
		TweenService:Create(Mensagem, TweenInfo.new(1), {TextTransparency = 0}):Play()

		task.wait(3)

		fade(TelaPreta, 1, 1)
		TweenService:Create(Mensagem, TweenInfo.new(1), {TextTransparency = 1}):Play()

		task.wait(1)
		TelaPreta.Visible = false

		-- Soltar o jogador da cadeira
		cadeiraSeat:Sit(nil)
		task.wait(0.1)

		-- Desativar o highlight
		if highlight then
			highlight.Enabled = false
		end

		-- Desativar completamente o Seat
		cadeiraSeat.Parent = nil

		-- Abrir GUI do puzzle
		PuzzleGui.Enabled = true
	end
end)

-- Detectar quando o jogador LEVANTAR da cadeira
humanoid.Seated:Connect(function(active, seatPart)
	if not active and sentado then
		print("Jogador levantou da cadeira! Enviando objetivo...")

		-- Ativar objetivo no servidor
		SairOnibusObjetivoEvent:FireServer()
	end
end)
