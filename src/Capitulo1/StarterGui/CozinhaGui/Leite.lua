local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local gui = script.Parent
local jarra = gui:WaitForChild("Jarra")
local copo = gui:WaitForChild("CopoFrame")
local nivel = copo:WaitForChild("Nivel")
local completadoLabel2 = gui:WaitForChild("CompletadoLabel2")
local tempoEsgotadoLabel = gui:WaitForChild("TempoEsgotadoLabel")
local barra = gui:WaitForChild("BarraTempo")
local piaFrame = gui:WaitForChild("Pia") -- a pia da GUI

-- CONFIG
local inclinacaoFinal = -30
local taxaPreenchimento = 40
local inclinacaoMinParaDerramar = 20
local tempoVidaPingo = 2
local tamanhoPingo = Vector2.new(10,10)
local taxaDePingosPorSegundo = 30

-- TEMPO
local tempoTotal = 10
local tempoRestante = tempoTotal

-- ESTADO
local segurandoJarra = false
local offset = Vector2.new()
local nivelAtual = 0
local puzzleCompleto = false
local perdeu = false -- impede burlar, se perdeu uma vez, trava até reset

local posicaoInicial = jarra.Position
local rotacaoInicial = jarra.Rotation
local tempoUltimoPingo = 0
local alturaMaxima = 110

-- Função de reset
local function resetPuzzle()
	nivelAtual = 0
	nivel.Size = UDim2.new(1,0,0,0)
	nivel.Position = UDim2.new(0,0,1,0)
	jarra.Position = posicaoInicial
	jarra.Rotation = rotacaoInicial
	tempoRestante = tempoTotal
	puzzleCompleto = false
	perdeu = false
	completadoLabel2.Visible = false
	tempoEsgotadoLabel.Visible = false
	gui.Visible = true
end

-- Função para encher copo
local function encherCopo()
	if not puzzleCompleto and not perdeu then
		nivelAtual = math.clamp(nivelAtual + (taxaPreenchimento / taxaDePingosPorSegundo), 0, alturaMaxima)
		nivel.Size = UDim2.new(1,0,0,nivelAtual)
		nivel.Position = UDim2.new(0,0,1,-nivelAtual)

		if nivelAtual >= alturaMaxima then
			puzzleCompleto = true
			completadoLabel2.Text = "Completado!"
			completadoLabel2.Visible = true

			local tweenVoltar = TweenService:Create(jarra, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = posicaoInicial,
				Rotation = rotacaoInicial
			})
			tweenVoltar:Play()

			task.delay(3, function()
				local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
				for _, child in ipairs(gui:GetDescendants()) do
					if child:IsA("GuiObject") then
						local goal = {}
						if child:IsA("ImageButton") or child:IsA("ImageLabel") then
							goal.ImageTransparency = 1
						elseif child:IsA("TextLabel") or child:IsA("TextButton") then
							goal.TextTransparency = 1
						end
						if child:IsA("Frame") or child:IsA("GuiObject") then
							goal.BackgroundTransparency = 1
						end
						if next(goal) then
							local tween = TweenService:Create(child, tweenInfo, goal)
							tween:Play()
						end
					end
				end
				task.wait(1)
				gui.Visible = false

				for _, child in ipairs(gui:GetDescendants()) do
					if child:IsA("GuiObject") then
						if child:IsA("ImageButton") or child:IsA("ImageLabel") then
							child.ImageTransparency = 0
						elseif child:IsA("TextLabel") or child:IsA("TextButton") then
							child.TextTransparency = 0
						end
						if child:IsA("Frame") or child:IsA("GuiObject") then
							child.BackgroundTransparency = 0
						end
					end
				end
			end)
		end
	end
end

-- Criar pingos
local function criarPingo(x, y)
	if perdeu or puzzleCompleto then return end

	local pingo = Instance.new("Frame")
	pingo.Size = UDim2.new(0, tamanhoPingo.X, 0, tamanhoPingo.Y)
	pingo.BackgroundColor3 = Color3.fromRGB(255,255,255)
	pingo.BorderSizePixel = 0
	pingo.Position = UDim2.new(0, x, 0, y)
	pingo.Parent = gui

	local conections = {}
	local function checkCollision()
		if perdeu then
			pingo:Destroy()
			for _, conn in pairs(conections) do conn:Disconnect() end
			return
		end

		local pingoPos = pingo.AbsolutePosition
		local copoPos, copoSize = copo.AbsolutePosition, copo.AbsoluteSize
		local piaPos, piaSize = piaFrame.AbsolutePosition, piaFrame.AbsoluteSize

		-- SE TOCAR A PIA = PERDE INSTANTANEAMENTE
		if pingoPos.X >= piaPos.X and pingoPos.X <= piaPos.X + piaSize.X and pingoPos.Y >= piaPos.Y and pingoPos.Y <= piaPos.Y + piaSize.Y then
			perdeu = true
			pingo:Destroy()
			for _, conn in pairs(conections) do conn:Disconnect() end

			tempoEsgotadoLabel.Text = "Você derramou o leite!"
			tempoEsgotadoLabel.Visible = true

			task.delay(1.5, function()
				resetPuzzle()
			end)
			return
		end

		-- Se tocar o copo (só conta se ainda não perdeu)
		if not perdeu and pingoPos.X >= copoPos.X and pingoPos.X <= copoPos.X + copoSize.X and pingoPos.Y >= copoPos.Y and pingoPos.Y <= copoPos.Y + copoSize.Y then
			encherCopo()
			pingo:Destroy()
			for _, conn in pairs(conections) do conn:Disconnect() end
		end
	end

	conections.renderStep = RunService.RenderStepped:Connect(checkCollision)
	Debris:AddItem(pingo, tempoVidaPingo)

	local tween = TweenService:Create(pingo, TweenInfo.new(tempoVidaPingo, Enum.EasingStyle.Linear), {Position = UDim2.new(0, x, 0, y + 300)})
	tween:Play()
end

-- Pegar jarra
jarra.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not puzzleCompleto and not perdeu then
		segurandoJarra = true
		local mousePos = UserInputService:GetMouseLocation()
		local jarraPos = jarra.AbsolutePosition
		offset = Vector2.new(mousePos.X - jarraPos.X, mousePos.Y - jarraPos.Y)

		local tween = TweenService:Create(jarra, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = inclinacaoFinal})
		tween:Play()
	end
end)

-- Soltar jarra
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not puzzleCompleto then
		segurandoJarra = false
		local tween = TweenService:Create(jarra, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0})
		tween:Play()
	end
end)

-- Loop principal
RunService.RenderStepped:Connect(function(dt)
	if segurandoJarra and not puzzleCompleto and not perdeu then
		local mousePos = UserInputService:GetMouseLocation()
		local guiPos = gui.AbsolutePosition
		local localMouse = Vector2.new(mousePos.X - guiPos.X, mousePos.Y - guiPos.Y)
		jarra.Position = UDim2.new(0, localMouse.X - offset.X, 0, localMouse.Y - offset.Y)

		local rotacao = jarra.Rotation
		if math.abs(rotacao) >= inclinacaoMinParaDerramar and os.clock() - tempoUltimoPingo > (1 / taxaDePingosPorSegundo) then
			tempoUltimoPingo = os.clock()

			local rad = math.rad(rotacao)
			local cosRot = math.cos(rad)
			local sinRot = math.sin(rad)
			local halfWidth = jarra.AbsoluteSize.X / 2
			local halfHeight = jarra.AbsoluteSize.Y / 2
			local offsetX, offsetY = -50, -50

			local relativeX = halfWidth + offsetX * cosRot - offsetY * sinRot
			local relativeY = halfHeight + offsetX * sinRot + offsetY * cosRot

			local bicoX = jarra.AbsolutePosition.X + relativeX
			local bicoY = jarra.AbsolutePosition.Y + relativeY

			criarPingo(
				bicoX - gui.AbsolutePosition.X + math.random(-3,3),
				bicoY - gui.AbsolutePosition.Y + math.random(-3,3)
			)
		end
	end
end)

-- Timer da barra
RunService.RenderStepped:Connect(function(dt)
	if gui.Visible and not puzzleCompleto and not perdeu then
		local pia = workspace:FindFirstChild("Pia")
		if pia then
			for _, obj in ipairs(pia:GetDescendants()) do
				if obj:IsA("Highlight") then
					obj.Enabled = false
				end
			end
		end

		tempoRestante = tempoRestante - dt
		if tempoRestante < 0 then tempoRestante = 0 end

		local proporcao = math.clamp(tempoRestante / tempoTotal, 0, 1)
		local corAlvo
		if proporcao > 0.5 then
			corAlvo = Color3.fromRGB(0,255,0)
		elseif proporcao > 0.25 then
			corAlvo = Color3.fromRGB(255,255,0)
		else
			corAlvo = Color3.fromRGB(255,0,0)
		end

		local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
		local tween = TweenService:Create(barra, tweenInfo, {
			Size = UDim2.new(proporcao, 0, barra.Size.Y.Scale, barra.Size.Y.Offset),
			BackgroundColor3 = corAlvo
		})
		tween:Play()

		if tempoRestante <= 0 then
			perdeu = true
			barra.Size = UDim2.new(0,0,barra.Size.Y.Scale, barra.Size.Y.Offset)
			tempoEsgotadoLabel.Text = "Tempo Esgotado!"
			tempoEsgotadoLabel.Visible = true
			task.wait(2)
			resetPuzzle()
		end
	end
end)
