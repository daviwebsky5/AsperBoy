local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Obter módulo de controles
local Controls
local function getControls()
	if Controls then return Controls end
	local playerModule = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
	local module = require(playerModule)
	Controls = module:GetControls()
	return Controls
end

-- Ativar/desativar movimento e mouse
local function setMovementEnabled(enabled)
	local controls = getControls()
	if controls then
		if enabled then
			controls:Enable()
		else
			controls:Disable()
		end
	end

	if _G.SetMovimentoMouseEnabled then
		_G.SetMovimentoMouseEnabled(enabled)
	end
end

-- Função principal
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Estado de conclusão dos puzzles
local puzzlesCompletos = {
	Caixa = false,
	Puzzle2 = false,
	Animal = false
}

-- Verifica se deve bloquear o movimento
local function updateMovement()
	local bloquear = false

	-- CaixadeBrinquedos
	local caixa = playerGui:FindFirstChild("CaixadeBrinquedos")
	local puzzleFrame = caixa and caixa:FindFirstChild("PuzzleFrame")
	if puzzleFrame and puzzleFrame.Visible and not puzzlesCompletos.Caixa then
		bloquear = true
	end

	-- PuzzleGui (puzzle2)
	local puzzleGui = playerGui:FindFirstChild("PuzzleGui")
	local puzzleFrame2 = puzzleGui and puzzleGui:FindFirstChild("PuzzleFrame2")
	if puzzleFrame2 and puzzleFrame2.Visible and not puzzlesCompletos.Puzzle2 then
		bloquear = true
	end

	-- Biscoito e Cozinha
	local biscoito = playerGui:FindFirstChild("BiscoitoGui")
	local cozinha = playerGui:FindFirstChild("CozinhaGui")
	if (biscoito and biscoito:FindFirstChild("BiscoitoFrame") and biscoito.BiscoitoFrame.Visible)
		or (cozinha and cozinha:FindFirstChild("CozinhaFrame") and cozinha.CozinhaFrame.Visible) then
		bloquear = true
	end

	-- Animal
	local animalGui = playerGui:FindFirstChild("AnimalGui")
	local animalFrame = animalGui and (animalGui:FindFirstChild("AnimalQuizFrame") or animalGui:FindFirstChild("AnimalFrame"))
	if animalFrame and animalFrame.Visible and not puzzlesCompletos.Animal then
		bloquear = true
	end

	-- Ball Sort
	local ballSort = playerGui:FindFirstChild("BallSortGui")
	local ballSortFrame = ballSort and ballSort:FindFirstChild("TubesFrame")
	if ballSortFrame and ballSortFrame.Visible then
		bloquear = true
	end

	setMovementEnabled(not bloquear)
end

-- Monitora mudanças
local function conectarVisibilidade(gui)
	if not gui then return end
	for _, obj in ipairs(gui:GetDescendants()) do
		if obj:IsA("GuiObject") then
			obj:GetPropertyChangedSignal("Visible"):Connect(updateMovement)
		end
	end
	gui.DescendantAdded:Connect(function(obj)
		if obj:IsA("GuiObject") then
			obj:GetPropertyChangedSignal("Visible"):Connect(updateMovement)
		end
	end)
end

-- Conecta nas GUIs
for _, nome in ipairs({"CaixadeBrinquedos", "PuzzleGui", "BiscoitoGui", "CozinhaGui", "AnimalGui", "BallSortGui"}) do
	local gui = playerGui:FindFirstChild(nome)
	if gui then conectarVisibilidade(gui) end
end

-- Monitora labels de completado
task.spawn(function()
	while true do
		task.wait(0.2)

		-- Puzzle 1
		local caixa = playerGui:FindFirstChild("CaixadeBrinquedos")
		local label1 = caixa and caixa:FindFirstChild("PuzzleFrame") and caixa.PuzzleFrame:FindFirstChild("CompletedLabel")
		if label1 and (label1.Visible or label1.Text == "Completed") then
			puzzlesCompletos.Caixa = true
		end

		-- Puzzle 2
		local puzzleGui = playerGui:FindFirstChild("PuzzleGui")
		local label2 = puzzleGui and puzzleGui:FindFirstChild("PuzzleFrame2") and puzzleGui.PuzzleFrame2:FindFirstChild("CompletedLabel2")
		if label2 and (label2.Visible or label2.Text == "Completed") then
			puzzlesCompletos.Puzzle2 = true
		end

		-- Animal
		local animalGui = playerGui:FindFirstChild("AnimalGui")
		local frame = animalGui and (animalGui:FindFirstChild("AnimalQuizFrame") or animalGui:FindFirstChild("AnimalFrame"))
		local labelAnimal = frame and frame:FindFirstChild("CompleteLabel")
		if labelAnimal and labelAnimal.Visible then
			puzzlesCompletos.Animal = true
		end

		updateMovement()
	end
end)

-- Inicializa
updateMovement()
