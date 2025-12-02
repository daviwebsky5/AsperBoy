local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tpEvent = ReplicatedStorage:WaitForChild("TpSairOnibusEvent")

local destino = workspace:WaitForChild("TpPuzzleSair") -- Part onde o player vai aparecer

tpEvent.OnServerEvent:Connect(function(player)
	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- Teleporta o player
	hrp.CFrame = destino.CFrame + Vector3.new(0, 3, 0)
end)
