local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = playerGui:WaitForChild("SairOnibus")
local frame = gui:WaitForChild("OpcoesFrame")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TPObjetivoEvent = ReplicatedStorage:WaitForChild("TpSairOnibusEvent")

-- FRAME DA CUTSCENE
local cutsceneFrame = gui:WaitForChild("CutsceneFrame")
local cutsceneImage = cutsceneFrame:WaitForChild("ImageLabel")

-- Botão inicial
local palavraInicial = frame:WaitForChild("PalavraInicial")

-- Opções
local opcoes = {
	frame:WaitForChild("Opção1"),
	frame:WaitForChild("Opção2"),
	frame:WaitForChild("Opção3"),
	frame:WaitForChild("Opção4")
}

-- Caminhos finais
local caminhos = {
	frame:WaitForChild("Caminho1"),
	frame:WaitForChild("Caminho2"),
	frame:WaitForChild("Caminho3"),
	frame:WaitForChild("Caminho4")
}

-- Ícones
local protagonista = frame:WaitForChild("ProtagonistaIcon") -- Ônibus
local carro = frame:WaitForChild("CarroIcon") -- Obstáculo

-- Label de completado
local completadoLabel = frame:WaitForChild("CompletadoLabel")

-- Pontos intermediários do ônibus (caminho certo)
local pontoA = frame:WaitForChild("PontoA")
local pontoB = frame:WaitForChild("PontoB")
local pontoC = frame:WaitForChild("PontoC")

-- Opção correta
local correta = 1

local TweenService = game:GetService("TweenService")
local velocidade = 0.5

-- Posições iniciais
local posInicial = protagonista.Position
local posCarroInicial = carro.Position

-- 🔒 Controle de clique (NOVO)
local podeClicar = true


----------------------------------------------------------
-- FUNÇÕES
----------------------------------------------------------

local function moverProtagonista(dest)
	local t = TweenService:Create(
		protagonista,
		TweenInfo.new(velocidade, Enum.EasingStyle.Quad),
		{ Position = dest.Position }
	)
	t:Play()
	return t
end

local function moverProtagonistaBordaEsquerda(destinoGui)
	local posAntes = UDim2.new(
		destinoGui.Position.X.Scale - protagonista.Size.X.Scale,
		destinoGui.Position.X.Offset - protagonista.Size.X.Offset,
		destinoGui.Position.Y.Scale,
		destinoGui.Position.Y.Offset
	)

	local tween = TweenService:Create(
		protagonista,
		TweenInfo.new(velocidade, Enum.EasingStyle.Quad),
		{ Position = posAntes }
	)
	tween:Play()
	return tween
end

local function moverCarro(destinoGui)
	local t = TweenService:Create(
		carro,
		TweenInfo.new(velocidade, Enum.EasingStyle.Quad),
		{ Position = destinoGui.Position }
	)
	t:Play()
	return t
end

local function pontoAntesDoCarro(carroGui, protagonistaGui)
	return UDim2.new(
		carroGui.Position.X.Scale - protagonistaGui.Size.X.Scale,
		carroGui.Position.X.Offset - protagonistaGui.Size.X.Offset,
		carroGui.Position.Y.Scale,
		carroGui.Position.Y.Offset
	)
end


----------------------------------------------------------
-- FADE IN / OUT
----------------------------------------------------------

local function fadeInCutscene()
	cutsceneFrame.Visible = true
	cutsceneFrame.BackgroundTransparency = 1
	cutsceneImage.ImageTransparency = 1

	local t1 = TweenService:Create(cutsceneFrame, TweenInfo.new(1), { BackgroundTransparency = 0 })
	local t2 = TweenService:Create(cutsceneImage, TweenInfo.new(1), { ImageTransparency = 0 })

	t1:Play()
	t2:Play()
	t2.Completed:Wait()
end

local function fadeOutCutscene()
	local t1 = TweenService:Create(cutsceneFrame, TweenInfo.new(1), { BackgroundTransparency = 1 })
	local t2 = TweenService:Create(cutsceneImage, TweenInfo.new(1), { ImageTransparency = 1 })

	t1:Play()
	t2:Play()
	t2.Completed:Wait()

	cutsceneFrame.Visible = false
end


----------------------------------------------------------
-- RESET AO ABRIR
----------------------------------------------------------
frame:GetPropertyChangedSignal("Visible"):Connect(function()
	if frame.Visible then
		protagonista.Position = posInicial
		carro.Position = posCarroInicial
		completadoLabel.Visible = false
		podeClicar = true -- 🔒 Reseta a trava ao abrir
	end
end)


----------------------------------------------------------
-- LIBERAR OPÇÕES
----------------------------------------------------------
palavraInicial.MouseButton1Click:Connect(function()
	for _, opc in ipairs(opcoes) do
		opc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end
end)


----------------------------------------------------------
-- SISTEMA DE ESCOLHA
----------------------------------------------------------
for i, opcao in ipairs(opcoes) do
	opcao.MouseButton1Click:Connect(function()

		-- 🔒 Impede clicar durante animação
		if not podeClicar then return end
		podeClicar = false


		---------------------------------------------------
		-- ✔ ACERTOU
		---------------------------------------------------
		if i == correta then

			-- Carro vai para o final (obstáculo sai da frente)
			local carroFinal = TweenService:Create(
				carro,
				TweenInfo.new(velocidade),
				{ Position = caminhos[4].Position }
			)
			carroFinal:Play()

			carroFinal.Completed:Connect(function()

				----------------------------------------------------
				-- 🚍 ÔNIBUS SEGUE A ESTRADA:
				-- A → B → C → CaminhoCorreto
				----------------------------------------------------

				local tA = moverProtagonista(pontoA)
				tA.Completed:Connect(function()

					local tB = moverProtagonista(pontoB)
					tB.Completed:Connect(function()

						local tC = moverProtagonista(pontoC)
						tC.Completed:Connect(function()

							local tFinal = moverProtagonista(caminhos[correta])
							tFinal.Completed:Connect(function()

								completadoLabel.Visible = true
								task.wait(2)

								frame.Visible = false

								-- Cutscene
								fadeInCutscene()
								task.wait(2)
								fadeOutCutscene()

								-- TP
								local tpPart = workspace:FindFirstChild("TpPuzzleSair")
								if tpPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
									player.Character.HumanoidRootPart.CFrame = tpPart.CFrame
									TPObjetivoEvent:FireServer()
								end

								-- 🔓 Libera clique
								podeClicar = true
							end)
						end)
					end)
				end)
			end)


			---------------------------------------------------
			-- ❌ ERROU
			---------------------------------------------------
		else
			local caminhoErrado = caminhos[i]

			local tA = moverProtagonista(pontoA)
			tA.Completed:Connect(function()

				local tB = moverProtagonista(pontoB)
				tB.Completed:Connect(function()

					local tC = moverProtagonista(pontoC)
					tC.Completed:Connect(function()

						local t1 = moverProtagonistaBordaEsquerda(caminhoErrado)
						t1.Completed:Connect(function()

							local tCar = moverCarro(caminhoErrado)
							tCar.Completed:Connect(function()

								local posToque = pontoAntesDoCarro(carro, protagonista)
								local t2 = TweenService:Create(
									protagonista,
									TweenInfo.new(velocidade),
									{ Position = posToque }
								)
								t2:Play()

								t2.Completed:Connect(function()

									local tBackC = moverProtagonista(pontoC)
									tBackC.Completed:Connect(function()

										local tBackB = moverProtagonista(pontoB)
										tBackB.Completed:Connect(function()

											local tBackA = moverProtagonista(pontoA)
											tBackA.Completed:Connect(function()

												local tBack0 = TweenService:Create(
													protagonista,
													TweenInfo.new(velocidade),
													{ Position = posInicial }
												)
												tBack0:Play()

												tBack0.Completed:Connect(function()
													-- 🔓 Libera clique
													podeClicar = true
												end)

											end)
										end)
									end)

								end)
							end)
						end)
					end)
				end)
			end)
		end
	end)
end
