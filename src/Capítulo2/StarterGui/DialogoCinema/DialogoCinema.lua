-- Serviços
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local gui = script.Parent
local frame = gui:WaitForChild("DialogoFrame")
local leftPanel = frame:WaitForChild("LeftPanel")
local rightPanel = frame:WaitForChild("RightPanel")
local resultLabel = frame:WaitForChild("ResultLabel")

-- Puzzle
local correctId = 1
local selectedLeft = nil
local solved = false

-- BindableEvent para atualizar objetivo
local alterarTextoEvent = ReplicatedStorage:FindFirstChild("AlterarTextoPuzzleCinema")
if not alterarTextoEvent then
	alterarTextoEvent = Instance.new("BindableEvent")
	alterarTextoEvent.Name = "AlterarTextoPuzzleCinema"
	alterarTextoEvent.Parent = ReplicatedStorage
end

-- RemoteEvent para apagar o rig
local apagarRigEvent = ReplicatedStorage:WaitForChild("ApagarRigEvent")

-- Seat
local seat = Workspace:WaitForChild("CadeiraCinema"):WaitForChild("CinemaSeat")
seat.Disabled = true

-- Botões
local leftButtons = {
	leftPanel:WaitForChild("Left1"),
	leftPanel:WaitForChild("Left2"),
	leftPanel:WaitForChild("Left3"),
	leftPanel:WaitForChild("Left4")
}
local rightButtons = {
	rightPanel:WaitForChild("Right1"),
	rightPanel:WaitForChild("Right2"),
	rightPanel:WaitForChild("Right3"),
	rightPanel:WaitForChild("Right4")
}

for i, btn in ipairs(leftButtons) do
	btn:SetAttribute("pairId", i)
end
for i, btn in ipairs(rightButtons) do
	btn:SetAttribute("pairId", i)
end

local function resetColors()
	for _, b in ipairs(leftButtons) do b.BackgroundColor3 = Color3.fromRGB(255,255,255) end
	for _, b in ipairs(rightButtons) do b.BackgroundColor3 = Color3.fromRGB(255,255,255) end
end

local function showMessage(text, color)
	resultLabel.Text = text
	if color then resultLabel.TextColor3 = color end
	resultLabel.Visible = true
end

local function typeText(label, text, speed)
	label.Text = ""
	for i = 1, #text do
		label.Text = string.sub(text, 1, i)
		task.wait(speed or 0.03)
	end
end

-- ✅ AQUI ESTÁ A FUNÇÃO CORRIGIDA COMPLETA
local function showDialog()
	local playerGui = player:WaitForChild("PlayerGui")
	local dialogGui = playerGui:WaitForChild("DialogResultGui")
	if not dialogGui then return end

	dialogGui.Enabled = true
	local frame = dialogGui:WaitForChild("Frame")
	local nameLabel = frame:WaitForChild("NameLabel")
	local dialogLabel = frame:WaitForChild("DialogLabel")
	local nextButton = frame:WaitForChild("NextButton")
	nextButton.Visible = true
	nextButton.Text = "Continuar"

	-- Salvar estado ORIGINAL (nome e cores)
	local originalNameText = nameLabel.Text
	local originalNameColor = nameLabel.BackgroundColor3
	local originalDialogColor = dialogLabel.TextColor3

	local falas = {
		{nome = "Você", texto = "'Ok é só falar igual a última vez!'"},
		{nome = "Você", texto = "Licença posso ficar nesse lugar? 'Mostrar o cracha de autista'"},
		{nome = "Aluno", texto = "Não, some daqui moleque."},
		{nome = "Você", texto = "Ah... *triste*"}
	}

	local index = 1
	local typingFinished = false
	local connection

	local function aplicarCor(fala)
		-- Volta pro original
		nameLabel.BackgroundColor3 = originalNameColor
		dialogLabel.TextColor3 = originalDialogColor

		-- Se for Random, usa cor especial
		if fala.nome == "Aluno" then
			nameLabel.BackgroundColor3 = Color3.fromRGB(125, 0, 0)
			dialogLabel.TextColor3 = Color3.fromRGB(125, 0, 0)
		end
	end

	local function nextFala()
		if not typingFinished then return end
		if connection then connection:Disconnect() end

		if index <= #falas then
			local falaAtual = falas[index]
			nameLabel.Text = falaAtual.nome
			aplicarCor(falaAtual)

			typingFinished = false
			task.spawn(function()
				typeText(dialogLabel, falaAtual.texto, 0.03)
				typingFinished = true
			end)

			index += 1
			nextButton.Text = (index > #falas) and "Fechar" or "Continuar"
			connection = nextButton.MouseButton1Click:Connect(nextFala)
		else
			-- ✅ Restaurar TUDO ao final
			dialogGui.Enabled = false
			nameLabel.BackgroundColor3 = originalNameColor
			dialogLabel.TextColor3 = originalDialogColor
			nameLabel.Text = originalNameText
			alterarTextoEvent:Fire()
		end
	end

	-- Primeira fala
	local primeira = falas[index]
	nameLabel.Text = primeira.nome
	aplicarCor(primeira)

	typingFinished = false
	task.spawn(function()
		typeText(dialogLabel, primeira.texto, 0.03)
		typingFinished = true
	end)
	index += 1

	connection = nextButton.MouseButton1Click:Connect(nextFala)
end

apagarRigEvent.OnClientEvent:Connect(function()
	seat.Disabled = false
end)

for _, leftBtn in ipairs(leftButtons) do
	leftBtn.MouseButton1Click:Connect(function()
		if solved then return end
		resetColors()
		selectedLeft = leftBtn
		leftBtn.BackgroundColor3 = Color3.fromRGB(80,80,120)
	end)
end

for _, rightBtn in ipairs(rightButtons) do
	rightBtn.MouseButton1Click:Connect(function()
		if solved or not selectedLeft then return end

		local leftId = selectedLeft:GetAttribute("pairId")
		local rightId = rightBtn:GetAttribute("pairId")

		resetColors()
		selectedLeft.BackgroundColor3 = Color3.fromRGB(100,100,150)
		rightBtn.BackgroundColor3 = Color3.fromRGB(100,100,150)
		task.wait(0.3)

		if leftId == rightId then
			if leftId == correctId then
				solved = true
				selectedLeft.BackgroundColor3 = Color3.fromRGB(60,150,60)
				rightBtn.BackgroundColor3 = Color3.fromRGB(60,150,60)
				showMessage("✅ Você pensou na frase certa!", Color3.fromRGB(0,255,0))
				task.wait(2)
				gui.Enabled = false
				showDialog()
			else
				showMessage("Não vai funcionar se eu fizer isso.", Color3.fromRGB(255,0,0))
				task.delay(2, function() resultLabel.Visible = false end)
			end
		else
			if leftId == correctId or rightId == correctId then
				showMessage("🟡 Uma parte está certa, mas não completamente.", Color3.fromRGB(255,255,0))
				task.delay(2.5, function() resultLabel.Visible = false end)
			else
				showMessage("❌ Combinação incorreta!", Color3.fromRGB(255,0,0))
				task.delay(2, function() resultLabel.Visible = false end)
			end
		end

		selectedLeft = nil
	end)
end
