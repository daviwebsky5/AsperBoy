local TweenService = game:GetService("TweenService") 
local puzzleFrame2 = script.Parent:WaitForChild("PuzzleFrame2")
local materiaisFrame = puzzleFrame2:WaitForChild("MateriaisFrame")
local mochilaGUI = puzzleFrame2:WaitForChild("MochilaGUI")
local completedLabel2 = puzzleFrame2:WaitForChild("CompletedLabel2")

--REMOVER HIGHLIGHT QUANDO TERMINAR O PUZZLE
local mochila = workspace:WaitForChild("Mochila")
local highlight = mochila:WaitForChild("Highlight")

--TENTAR FAZER SCALE IN FUNCIONAR
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local abrirPuzzleMochilaEvent = ReplicatedStorage:WaitForChild("AbrirPuzzleMochilaEvent")
--ACABA AQUI

local FadeModule = require(ReplicatedStorage:WaitForChild("FadeModule"))

-- CONFIGURAÇÃO DE FASES (listas de materiais)
-- Cada fase é um grupo de 5 imagens
local fases = {
	{"Material1","Material2","Material3","Material4","Material5"},
	{"Material6","Material7","Material8","Material9","Material10"}
}

local faseAtual = 1
local totalMateriais = 0
local colocados = 0
local materialSelecionado = nil

script.Parent:SetAttribute("Concluido", false)

-- GUIs exclusivas e seus estados anteriores
local exclusiveGuiNames = {
    "CaixadeBrinquedos",
    "BiscoitoGui",
    "CozinhaGui"
}
local previousGuiStates = {}

-- Função para carregar os materiais de uma fase
local function carregarFase(faseIndex)
	-- Primeiro esconde tudo
	for _, mat in ipairs(materiaisFrame:GetChildren()) do
		if mat:IsA("ImageButton") then
			mat.Visible = false
			mat.BorderSizePixel = 0
		end
	end

	totalMateriais = 0
	colocados = 0

	-- Ativa apenas os da fase
	for _, nome in ipairs(fases[faseIndex]) do
		local mat = materiaisFrame:FindFirstChild(nome)
		if mat and mat:IsA("ImageButton") then
			mat.Visible = true
			if mat:GetAttribute("PodeLevar") then
				totalMateriais += 1
			end
		end
	end
end

-- Mostrar X
local function mostrarX(mat)
	local xLabel = mat:FindFirstChild("X")
	if xLabel then
		xLabel.Visible = true
		task.wait(0.5)
		xLabel.Visible = false
	end
end

-- Selecionar material
for _, mat in ipairs(materiaisFrame:GetChildren()) do
	if mat:IsA("ImageButton") then
		mat.MouseButton1Click:Connect(function()
			if not script.Parent:GetAttribute("Concluido") and mat.Visible then
				materialSelecionado = mat
				-- Resetar bordas
				for _, m in ipairs(materiaisFrame:GetChildren()) do
					if m:IsA("ImageButton") then
						m.BorderSizePixel = 0
					end
				end
				if mat:GetAttribute("PodeLevar") then
					mat.BorderSizePixel = 3
					mat.BorderColor3 = Color3.fromRGB(50,200,50)
				else
					mat.BorderSizePixel = 3
					mat.BorderColor3 = Color3.fromRGB(200,50,50)
					mostrarX(mat)
				end
			end
		end)
	end
end

-- Animação de colocar na mochila
local function moverParaMochila(mat)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local goal = {Position = mochilaGUI.Position}
	local tween = TweenService:Create(mat, tweenInfo, goal)
	tween:Play()
	tween.Completed:Wait()
	mat.Visible = false
end

-- Quando clicar na mochila
mochilaGUI.MouseButton1Click:Connect(function()
	if materialSelecionado and not script.Parent:GetAttribute("Concluido") then
		if materialSelecionado:GetAttribute("PodeLevar") then
			moverParaMochila(materialSelecionado)
			colocados += 1
		else
			print("Material errado")
		end
		materialSelecionado = nil

		-- Resetar bordas
		for _, m in ipairs(materiaisFrame:GetChildren()) do
			if m:IsA("ImageButton") then
				m.BorderSizePixel = 0
			end
		end

		-- Verificar fase concluída
		if colocados == totalMateriais then
			if faseAtual < #fases then
				-- Vai para próxima fase
				faseAtual += 1
				carregarFase(faseAtual)
			else
				-- Puzzle completo
				completedLabel2.Visible = true
				highlight.Enabled = false
				task.wait(2)
				completedLabel2.Visible = false
				
				FadeModule.FadeOutAllUIMochila(puzzleFrame2, 1)
				-- Desativa completamente o PuzzleFrame (não apenas invisível)
				puzzleFrame2.Active = false
				wait(1.1)
				puzzleFrame2.Visible = false
				script.Parent:SetAttribute("Concluido", true)

				-- Restaurar GUIs exclusivas ao estado anterior
				local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
				if PlayerGui then
					for _, guiName in ipairs(exclusiveGuiNames) do
						local gui = PlayerGui:FindFirstChild(guiName)
						if gui and previousGuiStates[guiName] ~= nil then
							gui.Enabled = previousGuiStates[guiName]
						end
					end
				end
			end
		end
	end
end)

-- Função para abrir o Puzzle com animação
local function abrirPuzzle()
	puzzleFrame2.Visible = true
	puzzleFrame2.Active = true

	-- Garante que tenha um UIScale
	local uiScale = puzzleFrame2:FindFirstChildOfClass("UIScale")
	if not uiScale then
		uiScale = Instance.new("UIScale")
		uiScale.Parent = puzzleFrame2
	end

	-- Começa menor
	uiScale.Scale = 0.8

	-- Faz o "pop in"
	local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local tween = TweenService:Create(uiScale, tweenInfo, { Scale = 1 })
	tween:Play()
end

-- Iniciar com a primeira fase
--carregarFase(faseAtual)
abrirPuzzleMochilaEvent.OnClientEvent:Connect(function()
    local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    -- Salva o estado anterior das GUIs exclusivas
    previousGuiStates = {}
    for _, guiName in ipairs(exclusiveGuiNames) do
        local gui = PlayerGui:FindFirstChild(guiName)
        if gui then
            previousGuiStates[guiName] = gui.Enabled
            if gui.Enabled then
                gui.Enabled = false
            end
        end
    end

	abrirPuzzle() -- aqui vai a função que faz o PuzzleFrame dar o "zoom in"
	carregarFase(faseAtual) -- começa o puzzle de fato
end)

