-- ServerScriptService > Script
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Certifica que o RemoteEvent existe
local apagarRigEvent = ReplicatedStorage:FindFirstChild("ApagarRigEvent")
if not apagarRigEvent then
	apagarRigEvent = Instance.new("RemoteEvent")
	apagarRigEvent.Name = "ApagarRigEvent"
	apagarRigEvent.Parent = ReplicatedStorage
end

apagarRigEvent.OnServerEvent:Connect(function(player)
	local rigB = Workspace:FindFirstChild("RigMarcado2") -- 🔁 altere para o nome real
	if rigB then
		rigB:Destroy()
		print("🧹 RigB foi apagado por " .. player.Name)

		-- Informa o cliente que o rig foi apagado
		apagarRigEvent:FireClient(player)
	end
end)
