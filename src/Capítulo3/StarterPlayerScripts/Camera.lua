local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

repeat task.wait() until player.Character
local character = player.Character

camera.FieldOfView = 8
camera.CameraType = Enum.CameraType.Scriptable

local playerGui = player:WaitForChild("PlayerGui")

---------------------------------------------------------------------
-- GUI DA TELA PRETA
---------------------------------------------------------------------
local screenGui = playerGui:WaitForChild("TelaPretaGui")
local blackFrame = screenGui:WaitForChild("Frame")

---------------------------------------------------------------------
-- GUI DE DIÁLOGO DURANTE A TELA PRETA
---------------------------------------------------------------------
local dialogGui = playerGui:WaitForChild("Dialog2")
local dialogFrame = dialogGui:WaitForChild("Frame")
local dialogLabel = dialogFrame:WaitForChild("DialogLabel")
local nameLabel = dialogFrame:WaitForChild("NameLabel")
local nextButton = dialogFrame:WaitForChild("NextButton")

dialogGui.Enabled = false  -- começa desligado

---------------------------------------------------------------------
-- FUNÇÕES GERAIS
---------------------------------------------------------------------
local function tween(object, properties, duration, style, direction)
	style = style or Enum.EasingStyle.Linear
	direction = direction or Enum.EasingDirection.InOut
	local info = TweenInfo.new(duration, style, direction)
	return TweenService:Create(object, info, properties)
end

-- FADE IN: escurece a tela e PARA
local function fadeBlackIn(timeIn)
	blackFrame.BackgroundTransparency = 1
	tween(blackFrame, {BackgroundTransparency = 0}, timeIn):Play()
	task.wait(timeIn)
end

-- FADE OUT: tira a tela preta
local function fadeBlackOut(timeOut)
	tween(blackFrame, {BackgroundTransparency = 1}, timeOut):Play()
	task.wait(timeOut)
end


---------------------------------------------------------------------
-- SISTEMA DE DIÁLOGO COM BOTÃO
---------------------------------------------------------------------
local function executarDialogosComBotao(lista)
	if not lista or #lista == 0 then return end

	dialogGui.Enabled = true
	dialogFrame.Visible = true

	local index = 1
	local total = #lista

	local function mostrar(i)
		local fala = lista[i]
		dialogLabel.Text = fala.texto or ""
		nameLabel.Text = fala.nome or ""
	end

	mostrar(index)

	local connection
	connection = nextButton.MouseButton1Click:Connect(function()
		index += 1

		if index > total then
			connection:Disconnect()
			dialogGui.Enabled = false
			return
		end

		mostrar(index)
	end)

	repeat task.wait() until index > total
end

---------------------------------------------------------------------
-- ATUALIZAÇÃO DA CÂMERA
---------------------------------------------------------------------
RunService.RenderStepped:Connect(function()
	if not (character and character:FindFirstChild("HumanoidRootPart")) then return end

	local HR = character.HumanoidRootPart
	local HRPos = HR.Position

	if activeCamera then
		local camPart = workspace:FindFirstChild(activeCamera.cameraPartName)
		if camPart then
			if activeCamera.mode == "followPlayer" then
				camera.CFrame = CFrame.new(camPart.Position, HRPos)

			elseif activeCamera.mode == "lookAtPart" then
				local look = workspace:FindFirstChild(activeCamera.lookAtPartName)
				if look then
					camera.CFrame = CFrame.new(camPart.Position, look.Position)
				else
					camera.CFrame = camPart.CFrame
				end
			end
		end
	else
		camera.CFrame = CFrame.new(
			Vector3.new(HRPos.X + 180, HRPos.Y + 100, HRPos.Z),
			HRPos
		)
	end
end)

---------------------------------------------------------------------
-- LISTA DE CÂMERAS E TRIGGERS
---------------------------------------------------------------------
local cameraList = {
	{
		name = "Estacionamento",
		type = "touch",
		triggerName = "PontoDeSaidaOnibus",
		cameraPartName = "CameraEstacionamento",
		mode = "followPlayer",
		fov = 60
	},

	{
		name = "Onibus",
		type = "touch",
		triggerName = "CorredorOnibus1",
		cameraPartName = "CameraOnibus",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Onibus2",
		type = "touch",
		triggerName = "CorredorOnibus2",
		cameraPartName = "CameraOnibus2",
		mode = "followPlayer",
		fov = 60
	},

	{
		name = "Caminho",
		type = "touch",
		triggerName = "TpPuzzleSair",
		cameraPartName = "CaminhoCamera",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "CaminhoGrande1",
		type = "touch",
		triggerName = "CaminhoGrande1",
		cameraPartName = "CameraCaminhoGrande1",
		mode = "lookAtPart",
		lookAtPartName = "ParedeCaminhoGrande",
		fov = 60
	},

	{
		name = "CaminhoPequeno1",
		type = "touch",
		triggerName = "CaminhoPequeno1",
		cameraPartName = "CameraCaminhoPequeno1",
		mode = "lookAtPart",
		lookAtPartName = "ParedeCaminhoPequeno",
		fov = 90
	},

	{
		name = "CaminhoCerto1",
		type = "touch",
		triggerName = "CaminhoCerto1",
		cameraPartName = "CameraCaminhoCerto1",
		mode = "lookAtPart",
		lookAtPartName = "ParedeCaminhoCerto",
		fov = 90,
		
		dialogos = {
			{nome = "Você", texto = "Esse parece mais calmo..."},
		}
		
	},


	-- CAMINHO ERRADO 1
	{
		name = "TpErrado1",
		type = "touch",
		triggerName = "TriggerCaminhoCurto",
		cameraPartName = "CameraCaminhoPequeno1",
		mode = "lookAtPart",
		lookAtPartName = "ParedeCaminhoPequeno",
		fov = 70,
		teleportTo = "TpPuzzleSair",

		-- SOM AQUI
		soundName = "SomPessoas",

		dialogos = {
			{nome = "Você", texto = "Aqui tem muita pessoas!!"},
			{nome = "Você", texto = "Não consigo ir por aqui..."},
		}
	},


	-- CAMINHO ERRADO 2
	{
		name = "TpErrado2",
		type = "touch",
		triggerName = "TriggerCaminhoLongo",
		cameraPartName = "CaminhoCamera",
		mode = "followPlayer",
		fov = 70,
		teleportTo = "TpPuzzleSair",

		-- SOM AQUI
		soundName = "SomCarro",

		dialogos = {
			{nome = "Você", texto = "Aqui tem muitos carros!!"},
			{nome = "Você", texto = "Não consigo ir por aqui..."},
		}
	},
	
	{
		name = "CaminhoCerto2",
		type = "touch",
		triggerName = "CaminhoCerto2",
		cameraPartName = "CameraCaminhoCerto2",
		mode = "lookAtPart",
		lookAtPartName = "ParedeCaminhoCerto2",
		fov = 90
	},
	{
		name = "CaminhoCerto3",
		type = "touch",
		triggerName = "CaminhoCerto3",
		cameraPartName = "CameraCaminhoCerto3",
		mode = "lookAtPart",
		lookAtPartName = "ParedeCaminhoCerto3",
		fov = 90
	},
	{
		name = "Casa",
		type = "touch",
		triggerName = "TriggerCasa",
		cameraPartName = "CameraCasa",
		mode = "lookAtPart",
		lookAtPartName = "ParedeCasa",
		fov = 90
	},


}

---------------------------------------------------------------------
-- CONECTAR TRIGGERS
---------------------------------------------------------------------
-- CONECTAR TRIGGERS
for _, cam in ipairs(cameraList) do
	local trigger = workspace:WaitForChild(cam.triggerName)

	trigger.Touched:Connect(function(hit)
		if hit.Parent ~= character then return end

		activeCamera = cam
		tween(camera, {FieldOfView = cam.fov}, 1):Play()

		if not cam.teleportTo then
			-- Se tiver dialogo e AINDA não falou
			if cam.dialogos and not cam.jaFalou then
				cam.jaFalou = true
				executarDialogosComBotao(cam.dialogos)
			end
			return
		end

		-- FADE IN: deixa tudo preto
		fadeBlackIn(1)

		-- SOM DO CAMINHO
		local currentSound
		if cam.soundName then
			local s = workspace:FindFirstChild(cam.soundName)
			if s and s:IsA("Sound") then
				currentSound = s
				currentSound:Play()
			end
		end

		-- TELEPORTE
		local destino = workspace:WaitForChild(cam.teleportTo)
		if character:FindFirstChild("HumanoidRootPart") then
			local pos = destino.Position + Vector3.new(0, 3, 0)
			character.HumanoidRootPart.CFrame = CFrame.new(pos)
		end

		task.wait(0.2)

		-- DIÁLOGO enquanto está preto
		if cam.dialogos then
			executarDialogosComBotao(cam.dialogos)
		end

		-- FADE OUT
		fadeBlackOut(1)

		-- PARA O SOM depois do fade
		if currentSound then
			currentSound:Stop()
		end

	end)
end

	
