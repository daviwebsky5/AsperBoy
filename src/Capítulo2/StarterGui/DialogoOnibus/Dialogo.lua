local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local gui = script.Parent
local frame = gui:WaitForChild("DialogoFrame")

local leftPanel = frame:WaitForChild("LeftPanel")
local rightPanel = frame:WaitForChild("RightPanel")
local resultLabel = frame:WaitForChild("ResultLabel")

local correctId = 3
local selectedLeft = nil
local solved = false
local waitingForSeat = false

-- 🔒 Bloqueia o Seat até o rig desaparecer
local seat = Workspace:WaitForChild("CadeiraTrigger"):WaitForChild("TeleportSeat")
if seat and seat:IsA("Seat") then
	seat.Disabled = true
else
	warn("⚠️ TeleportSeat não encontrado ou não é um Seat!")
end

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

for i,btn in ipairs(leftButtons) do
	btn:SetAttribute("pairId", i)
end
for i,btn in ipairs(rightButtons) do
	btn:SetAttribute("pairId", i)
end

-- Reset cores
local function resetColors()
	for _,b in ipairs(leftButtons) do
		b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end
	for _,b in ipairs(rightButtons) do
		b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end
end

-- Mostra mensagem temporária
local function showMessage(text, color)
	resultLabel.Text = text
	resultLabel.TextColor3 = color
	resultLabel.Visible = true
end

-- 🌀 Fade com ScreenGui + Texto central "No cinema..."
local function fadeScreen(duration)
	local playerGui = player:WaitForChild("PlayerGui")
	local fadeGui = playerGui:FindFirstChild("___FadeGui")

	-- Criar FadeGui se não existir
	if not fadeGui then
		fadeGui = Instance.new("ScreenGui")
		fadeGui.Name = "___FadeGui"
		fadeGui.DisplayOrder = 1000
		fadeGui.ResetOnSpawn = false
		fadeGui.IgnoreGuiInset = true
		fadeGui.Parent = playerGui
	end

	-- Criar fundo preto
	local fadeFrame = fadeGui:FindFirstChild("FadeFrame")
	if not fadeFrame then
		fadeFrame = Instance.new("Frame")
		fadeFrame.Name = "FadeFrame"
		fadeFrame.Size = UDim2.new(1, 0, 1, 0)
		fadeFrame.BackgroundColor3 = Color3.new(0, 0, 0)
		fadeFrame.BackgroundTransparency = 1
		fadeFrame.BorderSizePixel = 0
		fadeFrame.Parent = fadeGui
	end

	-- Criar texto central
	local fadeText = fadeGui:FindFirstChild("FadeText")
	if not fadeText then
		fadeText = Instance.new("TextLabel")
		fadeText.Name = "FadeText"
		fadeText.Size = UDim2.new(1, 0, 1, 0)
		fadeText.BackgroundTransparency = 1
		fadeText.Text = "No cinema..."
		-- Se quiser mudar o texto depois, posso fazer virar parâmetro.
		fadeText.TextColor3 = Color3.fromRGB(255, 255, 255)
		fadeText.TextScaled = true
		fadeText.Font = Enum.Font.FredokaOne
		fadeText.TextTransparency = 1
		fadeText.Visible = true
		fadeText.Parent = fadeGui
	end

	-- Fade IN (tela escurece)
	local tweenIn = TweenService:Create(
		fadeFrame,
		TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ BackgroundTransparency = 0 }
	)
	tweenIn:Play()

	-- Mostrar texto junto com o fade
	local tweenTextIn = TweenService:Create(
		fadeText,
		TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ TextTransparency = 0 }
	)
	tweenTextIn:Play()

	tweenIn.Completed:Wait()
	return fadeGui, fadeFrame, fadeText
end


-- 🔁 Espera o jogador sentar para teleportar
local function setupSeatTeleport()
	waitingForSeat = true
	local seat = Workspace:WaitForChild("CadeiraTrigger"):WaitForChild("TeleportSeat")
	if not seat or not seat:IsA("Seat") then
		warn("⚠️ TeleportSeat não encontrado no Workspace!")
		return
	end

	seat:GetPropertyChangedSignal("Occupant"):Connect(function()
		local occupant = seat.Occupant
		if occupant and waitingForSeat then
			waitingForSeat = false
			local character = player.Character or player.CharacterAdded:Wait()
			local humanoid = character:WaitForChild("Humanoid")
			local humanoidRoot = character:WaitForChild("HumanoidRootPart")
			local teleportPart = Workspace:FindFirstChild("TeleportDestino")

			if teleportPart then
				task.wait(2)
				local fadeGui, fadeFrame = fadeScreen(1)
				task.wait(1)

				humanoid.Sit = false
				task.wait(0.3)

				humanoidRoot.CFrame = teleportPart.CFrame + Vector3.new(0, 3, 0)

				local tweenOut = TweenService:Create(
					fadeFrame,
					TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
					{ BackgroundTransparency = 1 }
				)
				tweenOut:Play()
				tweenOut.Completed:Wait()
				if fadeGui then fadeGui:Destroy() end
			else
				warn("⚠️ TeleportDestino não encontrado no Workspace!")
			end
		end
	end)
end

-- Conexão dos botões do puzzle
for _,leftBtn in ipairs(leftButtons) do
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
				-- ✅ Puzzle completo
				solved = true
				selectedLeft.BackgroundColor3 = Color3.fromRGB(60,150,60)
				rightBtn.BackgroundColor3 = Color3.fromRGB(60,150,60)
				showMessage("✅ Você pensou na frase certa!", Color3.fromRGB(0,255,0))

				task.wait(2)
				gui.Enabled = false

				-- 🗨️ Diálogo final
				local playerGui = player:WaitForChild("PlayerGui")
				local dialogResultGui = playerGui:FindFirstChild("DialogResultGui")

				if dialogResultGui then
					dialogResultGui.Enabled = true
					local frame = dialogResultGui:WaitForChild("Frame")
					local nameLabel = frame:WaitForChild("NameLabel")
					local dialogLabel = frame:WaitForChild("DialogLabel")
					local nextButton = frame:WaitForChild("NextButton")

					nameLabel.Text = "Você:"
					nextButton.Visible = true
					nextButton.Text = "Continuar"

					local typingFinished = false

					local function typeText(label, text, speed)
						label.Text = ""
						for i = 1, #text do
							label.Text = string.sub(text, 1, i)
							task.wait(speed or 0.03)
						end
						typingFinished = true
					end

					-- Primeiro texto
					typingFinished = false
					task.spawn(function()
						typeText(dialogLabel, "'É isso! Agora sei o que dizer...'", 0.03)
					end)

					local connection
					connection = nextButton.MouseButton1Click:Connect(function()
						if not typingFinished then return end
						connection:Disconnect()

						-- Segundo texto
						typingFinished = false
						task.spawn(function()
							typeText(dialogLabel, "Licença, esse é o meu lugar. 'Mostro o crachá de autista'", 0.03)
						end)

						nextButton.Text = "Fechar"
						local closeConnection
						closeConnection = nextButton.MouseButton1Click:Connect(function()
							if not typingFinished then return end
							closeConnection:Disconnect()

							dialogResultGui.Enabled = false

							local rig = Workspace:FindFirstChild("RigMarcado")
							if rig then
								rig:Destroy()
							end

							-- 🔓 Libera o Seat agora que o rig sumiu
							local seat = Workspace:WaitForChild("CadeiraTrigger"):WaitForChild("TeleportSeat")
							if seat then
								seat.Disabled = false
							end

							-- ✅ Ativa o modo de espera do Seat
							setupSeatTeleport()
						end)
					end)
				end

				local event = ReplicatedStorage:FindFirstChild("DialogPuzzleCompleted")
				if event and event:IsA("BindableEvent") then
					event:Fire()
				end

			else
				showMessage("Não vai funcionar se eu fizer isso.", Color3.fromRGB(255,220,120))
				task.delay(2, function() resultLabel.Visible = false end)
			end
		else
			if leftId == correctId or rightId == correctId then
				showMessage("🟡 Uma parte está certa, mas não completamente.", Color3.fromRGB(255,255,100))
				task.delay(2.5, function() resultLabel.Visible = false end)
			else
				showMessage("❌ Combinação incorreta!", Color3.fromRGB(255,80,80))
				task.delay(2, function() resultLabel.Visible = false end)
			end
		end

		selectedLeft = nil
	end)
end
