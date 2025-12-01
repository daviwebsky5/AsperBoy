local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")


-- Função auxiliar de fade in/out
local function fadeBlack(duration, fadeIn)
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	local fadeGui = playerGui:WaitForChild("FadeGui")
	local frame = fadeGui:WaitForChild("BlackFrame")

	local tweenInfo = TweenInfo.new(duration or 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local goal = {}

	if fadeIn then
		goal.BackgroundTransparency = 0
	else
		goal.BackgroundTransparency = 1
	end

	local tween = TweenService:Create(frame, tweenInfo, goal)
	tween:Play()
	tween.Completed:Wait()
end

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Espera o personagem carregar
repeat task.wait() until player.Character
local character = player.Character

local zoom = 100
camera.FieldOfView = 8
camera.CameraType = Enum.CameraType.Scriptable

local activeCamera = nil -- guarda info da câmera ativa

-- Função auxiliar de Tween
local function tween(object, properties, duration, easingStyle, easingDirection)
	easingStyle = easingStyle or Enum.EasingStyle.Linear
	easingDirection = easingDirection or Enum.EasingDirection.InOut
	local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
	return TweenService:Create(object, tweenInfo, properties)
end

-- Atualização da câmera a cada frame
RunService.RenderStepped:Connect(function()
	if not (character and character:FindFirstChild("HumanoidRootPart")) then return end
	local HR = character.HumanoidRootPart
	local HRPosition = HR.Position

	if activeCamera then
		local camPart = workspace:FindFirstChild(activeCamera.cameraPartName)
		if camPart then
			if activeCamera.mode == "followPlayer" then
				camera.CFrame = CFrame.new(camPart.Position, HRPosition)
			elseif activeCamera.mode == "lookAtPart" and activeCamera.lookAtPartName then
				local lookAt = workspace:FindFirstChild(activeCamera.lookAtPartName)
				if lookAt then
					camera.CFrame = CFrame.new(camPart.Position, lookAt.Position)
				else
					camera.CFrame = camPart.CFrame
				end
			else
				camera.CFrame = camPart.CFrame
			end
		end
	else
		-- Câmera padrão seguindo o jogador
		camera.CFrame = CFrame.new(Vector3.new(HRPosition.X + 180, HRPosition.Y + zoom, HRPosition.Z), HRPosition)
	end
end)

-- Lista de câmeras/triggers
local cameraList = {
	-- Exemplo de câmera com teleport
	{
		name = "Corredor",
		type = "touch",
		triggerName = "CorredorTrigger",
		cameraPartName = "CameraPartCorredor",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Cozinha",
		type = "touch",
		triggerName = "SaidaCorredorTrigger",
		cameraPartName = "CameraPartCozinha",
		mode = "followPlayer",
		fov = 45
	},
	{
		name = "Escola",
		type = "click",
		triggerName = "PortaLabirinto",
		cameraPartName = "CameraPartEscola1",
		mode = "lookAtPart",
		lookAtPartName = "Parede1",
		fov = 55
	},
	{
		name = "Escola2",
		type = "touch",
		triggerName = "CorredorEscola1",
		cameraPartName = "CameraEscola2",
		mode = "lookAtPart",
		lookAtPartName = "Parede2",
		fov = 70
	},
	{
		name = "Escola3",
		type = "touch",
		triggerName = "CorredorEscola2",
		cameraPartName = "CameraEscola3",
		mode = "lookAtPart",
		lookAtPartName = "Parede3",
		fov = 80
	},
	{
		name = "Escola4",
		type = "touch",
		triggerName = "CorredorEscola3",
		cameraPartName = "CameraEscola4",
		mode = "lookAtPart",
		lookAtPartName = "Parede4",
		fov = 70
	},
	{
		name = "Escola5",
		type = "touch",
		triggerName = "CorredorEscolha",
		cameraPartName = "CameraEscolha",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Escola6",
		type = "touch",
		triggerName = "CorredorEscola4",
		cameraPartName = "CameraEscola5",
		mode = "lookAtPart",
		lookAtPartName = "Parede5",
		fov = 60
	},
	{
		name = "Escola7",
		type = "touch",
		triggerName = "CorredorEscola5",
		cameraPartName = "CameraEscola6",
		mode = "lookAtPart",
		lookAtPartName = "Parede5",
		fov = 60
	},
	{
		name = "Escola8",
		type = "touch",
		triggerName = "CorredorEscolha2",
		cameraPartName = "CameraEscolha2",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Escola9",
		type = "touch",
		triggerName = "CorredorEscola6",
		cameraPartName = "CameraEscola7",
		mode = "lookAtPart",
		lookAtPartName = "Parede6",
		fov = 70
	},
	{
		name = "Escola10",
		type = "touch",
		triggerName = "CorredorEscola7",
		cameraPartName = "CameraEscola8",
		mode = "lookAtPart",
		lookAtPartName = "Parede7",
		fov = 70
	},
	{
		name = "Escola11",
		type = "touch",
		triggerName = "CorredorEscolha3",
		cameraPartName = "CameraEscolha3",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Escola12",
		type = "touch",
		triggerName = "CorredorEscola8",
		cameraPartName = "CameraEscola9",
		mode = "lookAtPart",
		lookAtPartName = "Parede11",
		fov = 60
	},
	{
		name = "Escola13",
		type = "touch",
		triggerName = "CorredorEscola9",
		cameraPartName = "CameraEscola10",
		mode = "lookAtPart",
		lookAtPartName = "Parede10",
		fov = 80
	},
	{
		name = "Escola14",
		type = "touch",
		triggerName = "CorredorEscola10",
		cameraPartName = "CameraEscola11",
		mode = "lookAtPart",
		lookAtPartName = "Parede6",
		fov = 70
	},
	{
		name = "Escola15",
		type = "touch",
		triggerName = "CorredorEscola12",
		cameraPartName = "CameraEscola13",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Escola16",
		type = "touch",
		triggerName = "CorredorEscola13",
		cameraPartName = "CameraEscola14",
		mode = "lookAtPart",
		lookAtPartName = "Parede12",
		fov = 100
	},
	{
		name = "Escola17",
		type = "touch",
		triggerName = "CorredorEscola14",
		cameraPartName = "CameraEscola15",
		mode = "lookAtPart",
		lookAtPartName = "Parede8",
		fov = 80
	},
	{
		name = "Escola18",
		type = "touch",
		triggerName = "CorredorEscola15",
		cameraPartName = "CameraEscola16",
		mode = "lookAtPart",
		lookAtPartName = "Parede9",
		fov = 100
	},
	{
		name = "Escola19",
		type = "touch",
		triggerName = "CorredorEscola16",
		cameraPartName = "CameraEscola17",
		mode = "lookAtPart",
		lookAtPartName = "Porta2",
		fov = 90
	},
	{
		name = "TeleportEscola",
		type = "touch",
		triggerName = "TriggerTeleportEscola", -- Part que o jogador pisa
		cameraPartName = "CameraPartEscola1",
		mode = "lookAtPart",
		lookAtPartName = "Parede1",
		fov = 70,
		teleportTo = "Destino", -- Part do teleport
	},
	{
		name = "TeleportEscola2",
		type = "touch",
		triggerName = "TpEscola2", -- Part que o jogador pisa
		cameraPartName = "CameraPartEscola1",
		mode = "lookAtPart",
		lookAtPartName = "Parede1",
		fov = 70,
		teleportTo = "Destino", -- Part do teleport
	},	
	{
		name = "TeleportEscola3",
		type = "touch",
		triggerName = "TpEscola3", -- Part que o jogador pisa
		cameraPartName = "CameraPartEscola1",
		mode = "lookAtPart",
		lookAtPartName = "Parede1",
		fov = 70,
		teleportTo = "Destino", -- Part do teleport
	},
	{
		name = "TeleportEscola4",
		type = "touch",
		triggerName = "TpEscola4", -- Part que o jogador pisa
		cameraPartName = "CameraPartEscola1",
		mode = "lookAtPart",
		lookAtPartName = "Parede1",
		fov = 70,
		teleportTo = "Destino", -- Part do teleport
	},
	{
		name = "TeleportEscola5",
		type = "touch",
		triggerName = "TpEscola5", -- Part que o jogador pisa
		cameraPartName = "CameraPartEscola1",
		mode = "lookAtPart",
		lookAtPartName = "Parede1",
		fov = 70,
		teleportTo = "Destino", -- Part do teleport
	},
	{
		name = "TeleportEscola6",
		type = "click",
		triggerName = "PortaEscola", 
		cameraPartName = "CameraEscolaEntrada",
		mode = "followPlayer",
		fov = 70,
		teleportTo = "EscolaTP", -- Part do teleport
	},
	{
		name = "Escola20",
		type = "touch",
		triggerName = "Escola",
		cameraPartName = "CameraEscola18",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Escola21",
		type = "touch",
		triggerName = "Escola2",
		cameraPartName = "CameraEscola19",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Escola22",
		type = "touch",
		triggerName = "Escola3",
		cameraPartName = "CameraEscola20",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Escola23",
		type = "touch",
		triggerName = "Escola4",
		cameraPartName = "CameraEscola21",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Escola24",
		type = "touch",
		triggerName = "Escola5",
		cameraPartName = "CameraEscola22",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Escola25",
		type = "touch",
		triggerName = "Escola6",
		cameraPartName = "CameraEscola23",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Escola26",
		type = "touch",
		triggerName = "Escola7",
		cameraPartName = "CameraEscola24",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Escola27",
		type = "touch",
		triggerName = "Escola8",
		cameraPartName = "CameraEscola25",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Escola28",
		type = "touch",
		triggerName = "Escola2112",
		cameraPartName = "CameraLabi1",
		mode = "lookAtPart",
		lookAtPartName = "aqui",
		fov = 90
	},

	-- Adicione aqui todas as outras câmeras da escola...
}

-- Conectando triggers dinamicamente
for _, cam in ipairs(cameraList) do
	local camPart = workspace:WaitForChild(cam.cameraPartName)

	if cam.type == "touch" then
		local trigger = workspace:WaitForChild(cam.triggerName)
		trigger.Touched:Connect(function(hit)
			if hit.Parent == character then
				activeCamera = cam
				tween(camera, {FieldOfView = cam.fov}, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()

				-- Teleport
				local dialogActive = false

				if cam.teleportTo then
					task.spawn(function()
						if dialogActive then return end
						dialogActive = true

						local TweenService = game:GetService("TweenService")
						local playerGui = player:WaitForChild("PlayerGui")

						-- 🔹 Referências da tela preta
						local fadeGui = playerGui:WaitForChild("FadeGui")
						local blackFrame = fadeGui:WaitForChild("BlackFrame")

						-- 🔹 Referências do diálogo
						local caminhoErradoGui = playerGui:WaitForChild("CaminhoErrado")
						local frame = caminhoErradoGui:WaitForChild("CaminhoErradoFrame")
						local speakerLabel = frame:WaitForChild("SpeakerLabel")
						local dialogueLabel = frame:WaitForChild("DialogueText")

						-- 🔹 Forçar GUI na frente
						caminhoErradoGui.Parent = playerGui
						fadeGui.DisplayOrder = 1
						caminhoErradoGui.DisplayOrder = 2

						-- 🔹 Fade in (tela preta escurece)
						local tweenIn = TweenService:Create(
							blackFrame,
							TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{BackgroundTransparency = 0}
						)
						tweenIn:Play()
						tweenIn.Completed:Wait()

						-- 🔹 Mostrar frame e texto instantâneo
						frame.Visible = true
						speakerLabel.Text = "Você"
						dialogueLabel.Text = "Acho que esse não é o caminho para a escola... Vou voltar para o começo!"
						speakerLabel.TextTransparency = 0
						dialogueLabel.TextTransparency = 0

						-- Espera 2 segundos para o jogador ler
						task.wait(2)

						-- 🔹 Teleporta o jogador
						local destino = workspace:WaitForChild(cam.teleportTo)
						if character and character:FindFirstChild("HumanoidRootPart") then
							local pos = destino.Position + Vector3.new(0, 3, 30)
							character.HumanoidRootPart.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(180), 0)
						end

						-- 🔹 Esconde o diálogo
						frame.Visible = false

						-- 🔹 Fade out da tela preta
						local tweenOut = TweenService:Create(
							blackFrame,
							TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
							{BackgroundTransparency = 1}
						)
						tweenOut:Play()
						tweenOut.Completed:Wait()

						dialogActive = false
					end)
				end
			end
		end)

	elseif cam.type == "click" then
		local porta = workspace:WaitForChild(cam.triggerName)
		local clickDetector = porta:WaitForChild("ClickDetector")

		local cutsceneJaRodou = false -- só para PortaLabirinto

		clickDetector.MouseClick:Connect(function(clickedPlayer)
			if clickedPlayer ~= player then return end

			task.spawn(function()
				-- 🔹 Se for a PortaLabirinto e ainda não rodou, faz cutscene
				if cam.triggerName == "PortaLabirinto" and not cutsceneJaRodou then
					cutsceneJaRodou = true

					local playerGui = player:WaitForChild("PlayerGui")
					local cutsceneGui = playerGui:WaitForChild("CutSceneLabi")
					local imagem = cutsceneGui:WaitForChild("ImageFrame")

					-- Fade in da imagem
					imagem.ImageTransparency = 1
					imagem.Visible = true
					TweenService:Create(imagem, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
					task.wait(1.5)

					-- 🔹 Atualiza câmera
					activeCamera = cam
					camera.FieldOfView = cam.fov

					-- Teleporte
					if cam.teleportTo then
						local destino = workspace:WaitForChild(cam.teleportTo)
						if character:FindFirstChild("HumanoidRootPart") then
							character.HumanoidRootPart.CFrame =
								CFrame.new(destino.Position + Vector3.new(0,3,30)) * CFrame.Angles(0, math.rad(180), 0)
						end
					end

					task.wait(1)
					-- Fade out da imagem
					TweenService:Create(imagem, TweenInfo.new(1), {ImageTransparency = 1}):Play()
					task.wait(1)
					imagem.Visible = false

					-- 🔹 Qualquer outra porta: apenas teleporte + câmera
				else
					-- Atualiza câmera
					activeCamera = cam
					camera.FieldOfView = cam.fov

					-- Teleporte
					if cam.teleportTo then
						local destino = workspace:WaitForChild(cam.teleportTo)
						if character:FindFirstChild("HumanoidRootPart") then
							character.HumanoidRootPart.CFrame =
								CFrame.new(destino.Position + Vector3.new(0,3,30)) * CFrame.Angles(0, math.rad(180), 0)
						end
					end
				end
			end)
		end)
	end
end
