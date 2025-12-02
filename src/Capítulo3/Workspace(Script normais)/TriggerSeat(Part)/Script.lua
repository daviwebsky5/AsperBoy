local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local trigger = workspace:WaitForChild("TriggerSeat")
local OnibusObjetivoEvent = ReplicatedStorage:WaitForChild("OnibusObjetivoEvent")

local debounce = {}

local function onTouched(hit)
	local character = hit.Parent
	local player = Players:GetPlayerFromCharacter(character)
	if not player then return end

	local userId = player.UserId
	if debounce[userId] then return end
	debounce[userId] = true

	print("[Server] jogador "..player.Name.." tocou no trigger - enviando objetivo")
	OnibusObjetivoEvent:FireClient(player, true) -- 🔥 importante o TRUE aqui
end

trigger.Touched:Connect(onTouched)
