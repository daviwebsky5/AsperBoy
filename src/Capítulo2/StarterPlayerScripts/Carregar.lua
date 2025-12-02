local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local loadingGui = playerGui:WaitForChild("LoadingGui")
local blackFrame = loadingGui:WaitForChild("BlackFrame")
local loadingText = blackFrame:WaitForChild("LoadingText")

-- CENTRALIZAR TEXTO NA TELA
loadingText.AnchorPoint = Vector2.new(0.5, 0.5)
loadingText.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingText.TextScaled = true
loadingText.TextWrapped = true
-----------------------------------------------------
-- FUNÇÃO: MOSTRAR TELA PRETA
-----------------------------------------------------
local function showBlack()
	blackFrame.BackgroundTransparency = 0
	blackFrame.Visible = true
	loadingText.TextTransparency = 0
end

-----------------------------------------------------
-- FUNÇÃO: ESCONDER TELA PRETA COM FADE
-----------------------------------------------------
local function hideBlack()
	local tween1 = TweenService:Create(
		blackFrame,
		TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundTransparency = 1}
	)

	local tween2 = TweenService:Create(
		loadingText,
		TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{TextTransparency = 1}
	)

	tween1:Play()
	tween2:Play()
	tween1.Completed:Wait()

	blackFrame.Visible = false
end

-----------------------------------------------------
-- 1) MOSTRA TELA PRETA
-----------------------------------------------------
showBlack()
loadingText.Text = "Carregando mapa..."

-----------------------------------------------------
-- ESCANEIA O MAPA AUTOMATICAMENTE
-----------------------------------------------------
local keywords = { "Trigger", "Camera", "Cam", "Tp", "Tele", "Porta", "Corredor", "Escola", "Destino", "Parede","parede","meio","Meio" }

local requiredObjects = {}

local function containsKeyword(name)
	for _, key in ipairs(keywords) do
		if string.find(string.lower(name), string.lower(key)) then
			return true
		end
	end
	return false
end

local function scanFolder(folder)
	for _, obj in ipairs(folder:GetChildren()) do
		if containsKeyword(obj.Name) then
			table.insert(requiredObjects, obj)
		end
		if #obj:GetChildren() > 0 then
			scanFolder(obj)
		end
	end
end

scanFolder(workspace)

print("🔍 Objetos detectados para carregar:", #requiredObjects)

-----------------------------------------------------
-- 2) CARREGAR IMAGENS AQUI
-----------------------------------------------------

-- COLOQUE SEUS IDs AQUI
local imageIds = {
	"rbxassetid://136003618946155"
}

loadingText.Text = "Carregando imagens..."

local ok, err = pcall(function()
	ContentProvider:PreloadAsync(imageIds)
end)

if not ok then
	warn("Erro ao pré-carregar imagens:", err)
end

-----------------------------------------------------
-- 3) CARREGAMENTO DOS OBJETOS COM PROGRESSO
-----------------------------------------------------

local total = #requiredObjects
local carregados = 0

for _, obj in ipairs(requiredObjects) do
	if obj and obj.Parent then
		repeat task.wait() until obj:IsDescendantOf(workspace)
	end

	carregados += 1
	loadingText.Text = "Carregando objetos (" .. carregados .. "/" .. total .. ")..."
	task.wait(0.03)
end

-----------------------------------------------------
-- 4) ESPERA PERSONAGEM
-----------------------------------------------------
loadingText.Text = "Carregando personagem..."

repeat task.wait() until player.Character
repeat task.wait() until player.Character:FindFirstChild("HumanoidRootPart")

task.wait(0.2)

-----------------------------------------------------
-- 5) FINALIZAR
-----------------------------------------------------
loadingText.Text = "Finalizando..."
task.wait(0.5)

hideBlack()

print("✔️ Tudo carregado com sucesso!")
