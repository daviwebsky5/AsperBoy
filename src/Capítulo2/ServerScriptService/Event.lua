-- ServerScriptService: OnibusObjetivoSetup.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- cria só se não existir
if not ReplicatedStorage:FindFirstChild("OnibusObjetivoEvent") then
	local event = Instance.new("RemoteEvent")
	event.Name = "OnibusObjetivoEvent"
	event.Parent = ReplicatedStorage
	print("[Server] OnibusObjetivoEvent criado no ReplicatedStorage")
end

if not ReplicatedStorage:FindFirstChild("CadeiraPuzzleConcluidoBindable") then
	local bindable = Instance.new("BindableEvent")
	bindable.Name = "CadeiraPuzzleConcluidoBindable"
	bindable.Parent = ReplicatedStorage
	print("[Server] CadeiraPuzzleConcluidoBindable criado no ReplicatedStorage")
end
