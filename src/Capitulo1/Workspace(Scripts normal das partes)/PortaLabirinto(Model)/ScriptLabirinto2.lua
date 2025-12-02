local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EscolaObjetivoEvent = ReplicatedStorage:WaitForChild("EscolaObjetivoEvent") -- 🆕 linha adicionada
local porta = workspace:WaitForChild("PortaLabirinto")
local destino = workspace:WaitForChild("Destino")

local clickDetector = porta:FindFirstChild("ClickDetector")
if not clickDetector then
	clickDetector = Instance.new("ClickDetector")
	clickDetector.MaxActivationDistance = 32
	clickDetector.Parent = porta
end

clickDetector.MouseClick:Connect(function(player)
	-- 🆕 ativa o novo objetivo
	EscolaObjetivoEvent:FireClient(player)

	local character = player.Character
	if not character then return end
	local root = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChild("Humanoid")
	if not root or not humanoid then return end

	-- trava movimento
	local oldWalkSpeed = humanoid.WalkSpeed
	local oldJumpPower = humanoid.JumpPower
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0

	-- teleporta e rotaciona
	local pos = destino.Position + Vector3.new(0,3,30)
	root.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(180), 0)

	-- libera movimento
	humanoid.WalkSpeed = oldWalkSpeed
	humanoid.JumpPower = oldJumpPower
end)
