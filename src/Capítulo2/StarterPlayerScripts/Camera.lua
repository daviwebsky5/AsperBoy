local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Espera o personagem carregar
repeat task.wait() until player.Character
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")

camera.FieldOfView = 8
camera.CameraType = Enum.CameraType.Scriptable

local activeCamera = nil
local lastActiveCamera = nil -- guarda a última câmera antes de sentar

-- Função Tween
local function tween(object, properties, duration, easingStyle, easingDirection)
	easingStyle = easingStyle or Enum.EasingStyle.Linear
	easingDirection = easingDirection or Enum.EasingDirection.InOut
	local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
	return TweenService:Create(object, tweenInfo, properties)
end

-- Atualização da câmera
RunService.RenderStepped:Connect(function()
	if not (character and character:FindFirstChild("HumanoidRootPart")) then return end
	local HR = character.HumanoidRootPart
	local HRPosition = HR.Position

	if activeCamera then
		local camPart = workspace:FindFirstChild(activeCamera.cameraPartName, true)
		if camPart then
			if activeCamera.mode == "followPlayer" then
				camera.CFrame = CFrame.new(camPart.Position, HRPosition)

			elseif activeCamera.mode == "lookAtPart" and activeCamera.lookAtPartName then
				local lookAt = workspace:FindFirstChild(activeCamera.lookAtPartName, true)
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
		-- Câmera padrão quando nenhuma ativa
		camera.CFrame = CFrame.new(
			Vector3.new(HRPosition.X + 180, HRPosition.Y + 100, HRPosition.Z),
			HRPosition
		)
	end
end)

-- LISTA DE CÂMERAS
local cameraList = {
	{
		name = "Onibus",
		type = "touch",
		triggerName = "CorredorOnibus",
		cameraPartName = "CameraOnibus",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Cinema",
		type = "touch",
		triggerName = "CinemaTrigger",
		cameraPartName = "CameraCinema1",
		mode = "lookAtPart",
		lookAtPartName = "Parede1",
		fov = 80
	},	
	{
		name = "Cinema2",
		type = "touch",
		triggerName = "Meio",
		cameraPartName = "CameraMeio",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Cinema3",
		type = "touch",
		triggerName = "CadeirasTrigger",
		cameraPartName = "Camerasala4",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Cinema4",
		type = "touch",
		triggerName = "Cadeiras2",
		cameraPartName = "Camerasala5",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Cinema5",
		type = "touch",
		triggerName = "Cadeiras3",
		cameraPartName = "Camerasala6",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Cinema6",
		type = "touch",
		triggerName = "Meio2",
		cameraPartName = "CameraMeio2",
		mode = "followPlayer",
		fov = 80
	},

	-- ✅ CÂMERA DO SEAT
	{
		name = "CameraNoSeat",
		type = "seat",
		seatName = "CinemaSeat", -- << ALTERE ESTE NOME
		cameraPartName = "CameraCinema2", -- << ALTERE ESTE NOME
		mode = "lookAtPart",
		lookAtPartName = "Tela",
		fov = 60
	},
	{
		name = "Cinema7",
		type = "touch",
		triggerName = "Meio3",
		cameraPartName = "CameraMeio3",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Cinema8",
		type = "touch",
		triggerName = "CadeirasCinema1",
		cameraPartName = "CameraCinema3",
		mode = "followPlayer",
		fov = 60
	},
	{
		name = "Banheiro",
		type = "touch",
		triggerName = "BanheiroTrigger",
		cameraPartName = "CameraBanheiro",
		mode = "followPlayer",
		fov = 60
	},
}

-- Conecta cada câmera
for _, cam in ipairs(cameraList) do

	if cam.type == "touch" then
		local trigger = workspace:WaitForChild(cam.triggerName)
		trigger.Touched:Connect(function(hit)
			if hit.Parent == character then
				activeCamera = cam
				tween(camera, {FieldOfView = cam.fov}, 1):Play()
			end
		end)

	elseif cam.type == "click" then
		local porta = workspace:WaitForChild(cam.triggerName)
		local clickDetector = porta:WaitForChild("ClickDetector")
		clickDetector.MouseClick:Connect(function(clickedPlayer)
			if clickedPlayer == player then
				activeCamera = cam
				tween(camera, {FieldOfView = cam.fov}, 1):Play()
			end
		end)

	elseif cam.type == "seat" then
		local seat = workspace:FindFirstChild(cam.seatName, true)

		humanoid.Seated:Connect(function(isSeated, seatObj)
			if isSeated and seatObj == seat then
				-- Guarda a câmera anterior
				lastActiveCamera = activeCamera

				-- Ativa a câmera do seat
				activeCamera = cam
				tween(camera, {FieldOfView = cam.fov}, 1):Play()

			elseif not isSeated and activeCamera == cam then
				-- Levantou: volta para última câmera usada antes de sentar
				if lastActiveCamera then
					activeCamera = lastActiveCamera
					tween(camera, {FieldOfView = lastActiveCamera.fov or 8}, 1):Play()
				else
					activeCamera = nil
					tween(camera, {FieldOfView = 8}, 1):Play()
				end
			end
		end)
	end
end
