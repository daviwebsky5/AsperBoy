local PuzzleFrame = script.Parent

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local brinquedos = require(ReplicatedStorage:WaitForChild("Brinquedos"))
local FadeModule = require(ReplicatedStorage:WaitForChild("FadeModule")) -- << ADICIONE AQUI
--local LosFadesModule = require(ReplicatedStorage:WaitForChild("LosFadesModule"))

--REMOVER HIGHLIGHT QUANDO TERMINAR O PUZZLE
local caixaBrinquedos = workspace:WaitForChild("Caixa de Brinquedos")
local highlight = caixaBrinquedos:WaitForChild("Highlight")


--TENTAR FAZER SCALE IN FUNCIONAR
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local abrirPuzzleBrinquedosEvent = ReplicatedStorage:WaitForChild("AbrirPuzzleBrinquedosEvent")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local fecharBiscoitoGuiBindable = nil
local biscoitoGui = playerGui:FindFirstChild("BiscoitoGui")
if biscoitoGui then
	local biscoitoFrame = biscoitoGui:FindFirstChild("BiscoitoFrame")
	if biscoitoFrame then
		fecharBiscoitoGuiBindable = biscoitoFrame:FindFirstChild("FecharBiscoitoGuiBindable")
	end
end
--ACABA AQUI

local frame = script.Parent
local brinquedoLabel = frame:WaitForChild("BrinquedoLabel")
local completedLabel = frame:WaitForChild("CompletedLabel")


-- Configurações responsivas do PuzzleFrame
PuzzleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
PuzzleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
PuzzleFrame.Size = UDim2.new(0.9, 0, 0.8, 0) -- 80% da tela

-- Garante proporção
local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 1.3 -- largura/altura (ajuste conforme o design)
aspect.Parent = PuzzleFrame

-- Garante tamanho mínimo e máximo
local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MinSize = Vector2.new(400, 300)
sizeConstraint.MaxSize = Vector2.new(900, 700)
sizeConstraint.Parent = PuzzleFrame



-- Caixas (ImageButtons)
local caixas = {
	Vermelho = frame:WaitForChild("CaixaVermelha"),
	Azul = frame:WaitForChild("CaixaAzul"),
	Verde = frame:WaitForChild("CaixaVerde"),
	Amarelo = frame:WaitForChild("CaixaAmarela"),
}

local index = 1
local brinquedoAtual = nil

local TweenService = game:GetService('TweenService')
local Frame = script.Parent

-- Função para carregar próximo brinquedo
local function carregarBrinquedo()
	if index > #brinquedos then
		brinquedoLabel.Visible = false
		completedLabel.Visible = true
		--REMOVER HIGHLIGHT QUANDO TERMINAR O PUZZLE
		highlight.Enabled = false
		wait(2)
		completedLabel.Visible = false
		index = 1
		if fecharBiscoitoGuiBindable then
			fecharBiscoitoGuiBindable:Fire()
		end
		FadeModule.FadeOutAllUI(frame, 1)
		-- Desativa completamente o PuzzleFrame (não apenas invisível)
		PuzzleFrame.Active = false
		wait(1.1)
		PuzzleFrame.Visible = false
		if PuzzleFrame:FindFirstChildOfClass("UIScale") then
			PuzzleFrame:FindFirstChildOfClass("UIScale").Scale = 1
		end
		return
	end
	
	brinquedoAtual = brinquedos[index]
	brinquedoLabel.Image = brinquedoAtual.Image
	brinquedoLabel.Visible = true
end

local TweenService = game:GetService("TweenService")
local feedbackFrame = frame:WaitForChild("FeedbackFrame")

-- Função para exibir vinheta
local function mostrarFeedback(cor)
	feedbackFrame.BackgroundColor3 = cor
	feedbackFrame.BackgroundTransparency = 0.6 -- semi-transparente
	feedbackFrame.Visible = true

	-- Tween para desaparecer suavemente
	local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(feedbackFrame, tweenInfo, {BackgroundTransparency = 1})
	tween:Play()
	
	local gradient = feedbackFrame:FindFirstChildOfClass("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, cor),  -- centro
		ColorSequenceKeypoint.new(1, Color3.new(0,0,0)) -- borda escura (ou transparente)
	})
end


-- Clicar nas caixas
for cor, caixa in caixas do
	caixa.MouseButton1Click:Connect(function()
		if brinquedoAtual and cor == brinquedoAtual.Cor then
			-- Correto
			brinquedoLabel.Visible = false
			mostrarFeedback(Color3.fromRGB(0,255,0)) -- verde de feedback
			wait(0.5)
			caixa.BackgroundColor3 = Color3.fromRGB(255,255,255)
			index += 1
			carregarBrinquedo()
		elseif brinquedoAtual then
			-- Errado
			mostrarFeedback(Color3.fromRGB(255,0,0)) -- vermelho de feedback
			wait(0.5)
			caixa.BackgroundColor3 = Color3.fromRGB(255,255,255)
		end
	end)
end

-- Função para abrir o Puzzle com animação
local function abrirPuzzle()
	PuzzleFrame.Visible = true
	PuzzleFrame.Active = true

	-- Garante que tenha um UIScale
	local uiScale = PuzzleFrame:FindFirstChildOfClass("UIScale")
	if not uiScale then
		uiScale = Instance.new("UIScale")
		uiScale.Parent = PuzzleFrame
	end

	-- Começa menor
	uiScale.Scale = 0.8

	-- Faz o "pop in"
	local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local tween = TweenService:Create(uiScale, tweenInfo, { Scale = 1 })
	tween:Play()
end


-- Iniciar
--carregarBrinquedo()

-- Iniciar (somente quando o jogador clicar no objeto)
abrirPuzzleBrinquedosEvent.OnClientEvent:Connect(function()
	abrirPuzzle() -- aqui vai a função que faz o PuzzleFrame dar o "zoom in"
	carregarBrinquedo() -- começa o puzzle de fato
end)

