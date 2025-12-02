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
local keywords = { "Trigger", "Camera", "Cam", "Tp", "Tele", "Porta", "Corredor", "Escola", "Destino", "Parede","parede" }

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
	"rbxassetid://100811145404142",
	"rbxassetid://109384571780981",
	"rbxassetid://92162596387546",
	"rbxassetid://103220915368799",
	"rbxassetid://107543006595962",
	"rbxassetid://98536242054710",
	"rbxassetid://122186647277663",
	"rbxassetid://90951414817232",
	"rbxassetid://139156582663971",
	"rbxassetid://104726524085230",
	"rbxassetid://136358303811015",
	"rbxassetid://97006719526367",
	"rbxassetid://77948792731332",
	"rbxassetid://75276425263078",
	"rbxassetid://119442483037849",
	"rbxassetid://100812742011618",
	"rbxassetid://107262932603180",
	"rbxassetid://82423803865787",
	"rbxassetid://125691311296784",
	"rbxassetid://78882466033111",
	"rbxassetid://119584262998592",
	"rbxassetid://132570378525601",
	"rbxassetid://103347133058500",
	"rbxassetid://132231758444940",
	"rbxassetid://80775657709812",
	"rbxassetid://113654071427902",
	"rbxassetid://120778531640663",
	"rbxassetid://140276006664428",
	"rbxassetid://134488280168358",
	"rbxassetid://84440907720870",
	"rbxassetid://81785350925765",
	"rbxassetid://97215575694526",
	"rbxassetid://97542991970409",
	"rbxassetid://138040738287507",
	"rbxassetid://82583904534778",
	"rbxassetid://75911988356148",
	"rbxassetid://108074449175934",
	"rbxassetid://131949336720735",
	"rbxassetid://80153979580050",
	"rbxassetid://89485187975333",
	"rbxassetid://87558072711885",
	"rbxassetid://99187255431738",
	"rbxassetid://91062332023767",
	"rbxassetid://139642176798612",
	"rbxassetid://130907998822300",
	"rbxassetid://139491318799522",
	"rbxassetid://110768437209141",
	"rbxassetid://94888185334388",
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
