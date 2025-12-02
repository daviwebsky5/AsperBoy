-- Script robusto: detecta corretamente levantar da CadeiraCinema/CinemaSeat
-- Mantém todos os diálogos e comportamentos que você já tinha.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer

-- espera Character / Humanoid (trata respawn)
local function waitCharacter()
	if player.Character and player.Character.Parent then
		return player.Character
	end
	return player.CharacterAdded:Wait()
end

local character = waitCharacter()
local humanoid = character:WaitForChild("Humanoid")

-- GUI e elementos (assume o script está dentro da GUI ou PlayerGui)
local gui = script.Parent
local frame = gui:WaitForChild("Frame")
local nameLabel = frame:WaitForChild("NameLabel")
local dialogLabel = frame:WaitForChild("DialogLabel")
local nextButton = frame:WaitForChild("NextButton")

frame.Visible = false
nextButton.Visible = false

-- Fade frame (mantive seu layout)
local fadeFrame = Instance.new("Frame")
fadeFrame.Size = UDim2.new(1,0,1,0)
fadeFrame.BackgroundColor3 = Color3.new(0,0,0)
fadeFrame.BackgroundTransparency = 1
fadeFrame.Visible = false
fadeFrame.Parent = gui

local fadeText = Instance.new("TextLabel")
fadeText.Size = UDim2.new(1,0,1,0)
fadeText.BackgroundTransparency = 1
fadeText.Text = "Algum tempo depois..."
fadeText.TextScaled = true
fadeText.Font = Enum.Font.SourceSansBold
fadeText.TextColor3 = Color3.new(1,1,1)
fadeText.Visible = false
fadeText.Parent = fadeFrame

-- Efeitos visuais
local blur = Instance.new("BlurEffect", Lighting)
local color = Instance.new("ColorCorrectionEffect", Lighting)
local bloom = Instance.new("BloomEffect", Lighting)
blur.Size = 0
color.Brightness = 0
color.Contrast = 0
color.Saturation = 0
bloom.Intensity = 0

-- Sons (cria localmente como antes, mantenha seus IDs)
local ofegante = Instance.new("Sound")
ofegante.SoundId = "rbxassetid://92875447524747"
ofegante.Volume = 0
ofegante.Looped = true
ofegante.Parent = SoundService

local calma = Instance.new("Sound")
calma.SoundId = "rbxassetid://72074438555314"
calma.Volume = 0
calma.Looped = true
calma.Parent = SoundService


-- Diálogos (mantidos)
local sobrecargaDialogos = {
	{nome = "Você", texto = "Tá tudo muito barulhento…", cor = Color3.fromRGB(255, 255, 255)},
	{nome = "Você", texto = "Não aguento, preciso sair.", cor = Color3.fromRGB(255, 255, 255)},
}

local banheiroDialogosParte1 = {
	{efeito = "Banheiro"},
	{nome = "Você", texto = "Aqui é mais calmo.", cor = Color3.fromRGB(255, 255, 255)},
	{nome = "Você", texto = "Só preciso respirar.", cor = Color3.fromRGB(255, 255, 255)},
}

local banheiroDialogosParte2 = {
	{nome = "Professor", texto = "(distante) Pessoal, o filme acabou! Vamos para o ônibus!", cor = Color3.fromRGB(255,255,255)},
	{nome = "Colega", texto = "(distante) Professor, cadê o AsperBoy? Acho que foi pro banheiro.", cor = Color3.fromRGB(255,255,255)},
	{nome = "Você", texto = "Já tá na hora de ir… acho que posso sair agora.", cor = Color3.fromRGB(255, 255, 255)},
}

-- 🧩 Funções de diálogo (corrigida ordem das funções)

local indice = 1
local listaAtual = nil
local esperandoClique = false

local function mostrarTexto(nome, texto, cor)
	nameLabel.Text = nome
	nameLabel.TextColor3 = cor
	dialogLabel.Text = ""
	nextButton.Visible = false

	for i = 1, #texto do
		dialogLabel.Text = string.sub(texto, 1, i)
		task.wait(0.03)
	end

	nextButton.Visible = true
end

-- ⚙️ declaramos aqui primeiro para evitar erro de referência
local executarDialogo

-- 🔁 execução passo a passo
local function executarProximo()
	if not listaAtual then return end

	if indice > #listaAtual then
		if listaAtual == sobrecargaDialogos then
			-- fim da sobrecarga → NÃO chama nada
			nextButton.Visible = false
			return
		elseif listaAtual == banheiroDialogosParte1 then
			nextButton.Visible = false
			frame.Visible = false

			-- 🕓 Fade e transição
			fadeFrame.Visible = true
			fadeText.Visible = true
			TweenService:Create(fadeFrame, TweenInfo.new(2), {BackgroundTransparency = 0}):Play()
			task.wait(2)
			TweenService:Create(fadeText, TweenInfo.new(1), {TextTransparency = 0}):Play()
			task.wait(2)
			TweenService:Create(fadeFrame, TweenInfo.new(2), {BackgroundTransparency = 1}):Play()
			fadeText.Visible = false
			task.wait(1)
			fadeFrame.Visible = false

			-- parar respiração calma
			TweenService:Create(calma, TweenInfo.new(1), {Volume = 0}):Play()
			task.wait(1)
			calma:Stop()

			task.defer(function()
				executarDialogo(banheiroDialogosParte2)
			end)

			return
		elseif listaAtual == banheiroDialogosParte2 then
			-- 🔚 FINAL DO CAPÍTULO 2

			frame.Visible = false

			-- 🏆 ENTREGAR EMBLEMA DO CAPÍTULO 2
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local concluirCap2 = ReplicatedStorage:WaitForChild("PuzzleConcluido2")
			concluirCap2:FireServer()

			-- 🎬 FADE DE SAÍDA
			fadeFrame.Visible = true
			TweenService:Create(fadeFrame, TweenInfo.new(2), {BackgroundTransparency = 0}):Play()
			task.wait(2)

			-- 🚪 TELEPORTAR PARA O CAPÍTULO 3
			local TeleportService = game:GetService("TeleportService")
			local ID_CAP3 = 95713308367639
			TeleportService:Teleport(ID_CAP3, Players.LocalPlayer)

			return
		end
	end

	local d = listaAtual[indice]
	indice += 1

	if d.efeito == "Banheiro" then
		-- transição de ambiente
		TweenService:Create(blur, TweenInfo.new(3), {Size = 0}):Play()
		TweenService:Create(color, TweenInfo.new(3), {Brightness = 0, Contrast = 0, Saturation = 0}):Play()
		TweenService:Create(bloom, TweenInfo.new(3), {Intensity = 0}):Play()

		TweenService:Create(ofegante, TweenInfo.new(2), {Volume = 0}):Play()
		task.wait(2)
		ofegante:Stop()

		SoundService.AmbientReverb = Enum.ReverbType.Bathroom
		calma:Play()
		TweenService:Create(calma, TweenInfo.new(3), {Volume = 1}):Play()

		task.wait(2)
		executarProximo()
		return
	end

	-- MOSTRA DIÁLOGO NORMAL
	mostrarTexto(d.nome, d.texto, d.cor)

	----------------------------------------------------------------------
	-- 🟦 AUTO-SUMIÇO DO ÚLTIMO DIÁLOGO DA SOBRECARGA
	----------------------------------------------------------------------
	if listaAtual == sobrecargaDialogos and indice > #listaAtual then
		-- botão continua aparecendo normal
		nextButton.Visible = true  

		task.delay(3, function()
			if listaAtual == sobrecargaDialogos then
				frame.Visible = false
			end
		end)
	end
end

-- Agora a função existe antes de ser usada
executarDialogo = function(lista)
	listaAtual = lista
	indice = 1
	frame.Visible = true
	executarProximo()
end

nextButton.MouseButton1Click:Connect(function()
	if nextButton.Visible and not esperandoClique then
		esperandoClique = true
		executarProximo()
		task.wait(0.1)
		esperandoClique = false
	end
end)

-- TARGET SEAT (usando caminho fixo)
local success, cadeiraCinema = pcall(function()
	return Workspace:WaitForChild("CadeiraCinema", 5):WaitForChild("CinemaSeat", 5)
end)
if not success or not cadeiraCinema then
	warn("[DEBUG] Não encontrou Workspace.CadeiraCinema.CinemaSeat — verifique nomes no Explorer")
end

-- Trigger do banheiro (aguarda)
local banheiroTrigger = nil
for i = 1, 20 do
	banheiroTrigger = Workspace:FindFirstChild("BanheiroTrigger")
	if banheiroTrigger then break end
	task.wait(1)
end

if not banheiroTrigger then
	warn("🚫 Não foi possível encontrar o BanheiroTrigger no Workspace!")
else
	print("✅ BanheiroTrigger encontrado:", banheiroTrigger:GetFullName())
end

-- Controle/flags
local podeAtivarBanheiro = false
local banheiroAtivo = false
local lastSeat = nil
local debounceSeat = false

-- Função que liga o comportamento de sobrecarga
local function ativarSobrecarga()
	if debounceSeat then
		print("[DEBUG] Sobrecarga já em andamento — ignorando nova ativação")
		return
	end
	debounceSeat = true

	print("[DEBUG] Ativando sobrecarga: sons e efeitos")

	pcall(function() ofegante:Play() end)

	TweenService:Create(blur, TweenInfo.new(3), {Size = 20}):Play()
	TweenService:Create(color, TweenInfo.new(3), {Brightness = 0.5, Contrast = 0.4, Saturation = 0.5}):Play()
	TweenService:Create(bloom, TweenInfo.new(3), {Intensity = 0.7}):Play()
	TweenService:Create(ofegante, TweenInfo.new(3), {Volume = 0.7}):Play()

	task.wait(1)
	executarDialogo(sobrecargaDialogos)
	podeAtivarBanheiro = true
	task.delay(2, function() debounceSeat = false end)
end

-- Bind do humanoid
local function bindHumanoid(hum)
	if not hum then return end
	hum.Seated:Connect(function(active, seat)
		if active then
			lastSeat = seat
		else
			local used = seat or lastSeat
			if cadeiraCinema and used == cadeiraCinema then
				ativarSobrecarga()
			end
			lastSeat = nil
		end
	end)
end

-- binding inicial / respawn
if player.Character then
	local hum = player.Character:FindFirstChild("Humanoid")
	if hum then bindHumanoid(hum) end
end
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	bindHumanoid(humanoid)
end)

-- Trigger banheiro
if banheiroTrigger then
	banheiroTrigger.Touched:Connect(function(hit)
		local char = player.Character
		if not podeAtivarBanheiro or banheiroAtivo or not char then
			return
		end
		if hit and hit:IsDescendantOf(char) then
			banheiroAtivo = true
			dialogLabel.Text = ""
			nameLabel.Text = ""
			frame.Visible = false
			executarDialogo(banheiroDialogosParte1)
		end
	end)
end

print("[DEBUG] Script carregado")
