local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FadeText = require(ReplicatedStorage:WaitForChild("FadeTextModule"))
local FadeStroke = require(ReplicatedStorage:WaitForChild("FadeStrokeModule"))
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local label = script.Parent
local stroke = label:FindFirstChildWhichIsA("UIStroke")
local tamanhoOriginal = label.TextSize

-- Eventos
local OnibusObjetivoEvent = ReplicatedStorage:WaitForChild("OnibusObjetivoEvent")
local PuzzleCompletedEvent = ReplicatedStorage:WaitForChild("DialogPuzzleCompleted")
local AlterarTextoPuzzleCinema = ReplicatedStorage:WaitForChild("AlterarTextoPuzzleCinema")
local PuzzleProfessorCompleted = ReplicatedStorage:WaitForChild("PuzzleProfessorCompleted")
local ObjetivoVoltarProfessor = ReplicatedStorage:WaitForChild("ObjetivoVoltarProfessor") -- ✅ usado para tudo

-- Estados
local onibusObjetivoAtivo = false
local puzzleCompleto = false
local cinemaObjetivoAtivo = false
local cadeirasObjetivoAtivo = false
local faleComProfessor = false
local sentarNoLugarProfessor = false
local faleComProfessorDeNovo = false

local function atualizarTexto(novoTexto)
	if label.Text == novoTexto then return end

	pcall(function()
		FadeText.FadeOut(label, 0.3)
		if stroke then FadeStroke.FadeOut(stroke, 0.3) end
	end)
	task.wait(0.3)

	label.Text = novoTexto
	label.TextSize = tamanhoOriginal

	pcall(function()
		FadeText.FadeIn(label, 0.3)
		if stroke then FadeStroke.FadeIn(stroke, 0.3) end
	end)
end

local function getObjetivoTexto()
	if faleComProfessorDeNovo then
		return "Saia da sala e ache um lugar mais calmo"
	elseif sentarNoLugarProfessor then
		return "Sente no lugar que você queria"
	elseif faleComProfessor then
		return "Fale com o professor"
	elseif cadeirasObjetivoAtivo then
		return "Sente em uma cadeira: \n- Sentar atrás \n- Perto do Corredor da porta"
	elseif cinemaObjetivoAtivo then
		return "- Vá para a sala 4 do cinema, e converse com o bilheteiro"
	elseif puzzleCompleto then
		return "Sente no seu lugar!"
	elseif onibusObjetivoAtivo then
		return "Ache o seu lugar: \n- Longe da Janela \n- Sozinho na Frente \n- Perto da porta"
	else
		return ""
	end
end

local function connectEvent(obj, callback)
	if obj:IsA("RemoteEvent") then
		obj.OnClientEvent:Connect(callback)
	else
		obj.Event:Connect(callback)
	end
end

connectEvent(OnibusObjetivoEvent, function(ativo)
	onibusObjetivoAtivo = ativo == true
end)

connectEvent(PuzzleCompletedEvent, function()
	puzzleCompleto = true
	onibusObjetivoAtivo = false
end)

connectEvent(AlterarTextoPuzzleCinema, function()
	faleComProfessor = true
	cinemaObjetivoAtivo = false
	cadeirasObjetivoAtivo = false
end)

connectEvent(PuzzleProfessorCompleted, function()
	faleComProfessor = false
	sentarNoLugarProfessor = true
end)

-- 🧩 Substituindo o antigo BlindageEvent: tudo acontece aqui
connectEvent(ObjetivoVoltarProfessor, function()
	print("[Cliente] ObjetivoVoltarProfessor recebido")

	-- 🔹 Rigs a apagar
	local rigsParaApagar = {
		"Professor",
		"Rig2",
		"Rig1",
		"Bilheteiro",
		"TriggerBilheteiro"
	}

	-- 🔹 Nome do Seat a destruir
	local nomeSeat = "CinemaSeat"

	-- 1️⃣ Apagar rigs localmente (caso ainda existam)
	for _, nome in ipairs(rigsParaApagar) do
		local rig = Workspace:FindFirstChild(nome)
		if rig then
			rig:Destroy()
			print("Apagado (cliente):", nome)
		end
	end

	-- 2️⃣ Destruir seat localmente
	local seat = Workspace:FindFirstChild(nomeSeat, true)
	if seat and seat:IsA("Seat") then
		seat:Destroy()
		print("Seat destruído (cliente):", seat:GetFullName())
	else
		warn("Seat não encontrado:", nomeSeat)
	end

	-- 3️⃣ Atualizar objetivo
	sentarNoLugarProfessor = false
	faleComProfessorDeNovo = true
	print("[Cliente] Objetivo alterado para: sair da sala")
end)

-- 🔸 Detectar triggers do mapa
local cinemaTrigger = Workspace:WaitForChild("CinemaTrigger")
local cadeirasTrigger = Workspace:WaitForChild("CadeirasTrigger")

cinemaTrigger.Touched:Connect(function(hit)
	if hit:IsDescendantOf(player.Character) and puzzleCompleto and not cinemaObjetivoAtivo then
		cinemaObjetivoAtivo = true
	end
end)

cadeirasTrigger.Touched:Connect(function(hit)
	if hit:IsDescendantOf(player.Character) and cinemaObjetivoAtivo and not cadeirasObjetivoAtivo then
		cadeirasObjetivoAtivo = true
	end
end)

-- 🔸 Loop de atualização do texto
task.spawn(function()
	while true do
		atualizarTexto(getObjetivoTexto())
		task.wait(1)
	end
end)

label.Text = getObjetivoTexto()
