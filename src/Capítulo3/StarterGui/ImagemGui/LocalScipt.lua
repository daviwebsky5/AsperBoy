local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI da imagem
local gui = playerGui:WaitForChild("ImagemGui")
local imagem = gui:WaitForChild("Imagem")

-- GUI do diálogo
local dialogGui = playerGui:WaitForChild("Dialog")
local dialogFrame = dialogGui:WaitForChild("Frame")
local botao = dialogFrame:WaitForChild("NextButton")
local nome = dialogFrame:WaitForChild("NameLabel")
local fala = dialogFrame:WaitForChild("DialogLabel")

-- GUI final
local obrigadoGui = playerGui:WaitForChild("ObrigadoGui")
local imagemFinal = obrigadoGui:WaitForChild("ImagemFinal")
local textoFinal = obrigadoGui:WaitForChild("Texto")

local porta = workspace:WaitForChild("Porta")
local clickDetector = porta:WaitForChild("ClickDetector")

----------------------------------------------------------
-- TEXTO APARECENDO LETRA POR LETRA
----------------------------------------------------------
local function typeWriter(label, text, speed)
	label.Text = ""
	for i = 1, #text do
		label.Text = string.sub(text, 1, i)
		task.wait(speed)
	end
end

----------------------------------------------------------
-- TRAVA PARA IMPEDIR DOUBLE CLICK
----------------------------------------------------------
local podeClicar = true

clickDetector.MouseClick:Connect(function()

	if not podeClicar then return end  -- impede spam
	podeClicar = false				  -- trava imediatamente

	----------------------------------------------------------
	-- 1) FADE IN DA PRIMEIRA IMAGEM
	----------------------------------------------------------
	gui.Enabled = true
	imagem.ImageTransparency = 1

	local tween = TweenService:Create(
		imagem,
		TweenInfo.new(1, Enum.EasingStyle.Linear),
		{ ImageTransparency = 0 }
	)
	tween:Play()

	tween.Completed:Connect(function()

		----------------------------------------------------------
		-- 2) MOSTRAR DIÁLOGO
		----------------------------------------------------------
		dialogGui.Enabled = true

		fala.TextColor3 = Color3.fromRGB(255, 158, 224)
		nome.BackgroundColor3 = Color3.fromRGB(246, 149, 255)

		nome.Text = "Mãe"
		local textoFala = "Oi filho, como foi a aula? Me conta tudo!"

		typeWriter(fala, textoFala, 0.03)

		----------------------------------------------------------
		-- 3) BOTÃO FECHA DIÁLOGO
		----------------------------------------------------------
		botao.MouseButton1Click:Connect(function()

			dialogGui.Enabled = false

			------------------------------------------------------
			-- ESPERAR 2 SEGUNDOS ANTES DA IMAGEM FINAL
			------------------------------------------------------
			task.wait(2)

			------------------------------------------------------
			-- 4) MOSTRAR A IMAGEM FINAL CENTRALIZADA
			------------------------------------------------------
			obrigadoGui.Enabled = true

			imagemFinal.AnchorPoint = Vector2.new(0.5, 0.5)
			imagemFinal.Position = UDim2.new(0.5, 0, 0.5, 0)

			textoFinal.AnchorPoint = Vector2.new(0.5, 0.5)
			textoFinal.Position = UDim2.new(0.5, 0, 0.5, 0)

			imagemFinal.ImageTransparency = 1
			textoFinal.TextTransparency = 1

			local fadeFinal = TweenService:Create(
				imagemFinal,
				TweenInfo.new(1),
				{ ImageTransparency = 0 }
			)
			fadeFinal:Play()

			local fadeTexto = TweenService:Create(
				textoFinal,
				TweenInfo.new(1),
				{ TextTransparency = 0 }
			)
			fadeTexto:Play()
		end)

		-- Evento do capítulo
		local evento = ReplicatedStorage:WaitForChild("PuzzleConcluido3")
		evento:FireServer()
	end)
end)
