local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cria os RemoteEvents, se não existirem
local function getOrCreateEvent(name)
	local event = ReplicatedStorage:FindFirstChild(name)
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = name
		event.Parent = ReplicatedStorage
	end
	return event
end

local BilheteiroDialogEvent = getOrCreateEvent("BilheteiroDialogEvent")
local AvisoBilheteiroEvent = getOrCreateEvent("AvisoBilheteiroEvent")

-- Variável pra saber se o jogador já falou com o bilheteiro
local falouComBilheteiro = {}

-- Trigger do bilheteiro (com ProximityPrompt)
local triggerBilheteiro = workspace:WaitForChild("TriggerBilheteiro")
local prompt = triggerBilheteiro:WaitForChild("ProximityPrompt")

prompt.Triggered:Connect(function(player)
	BilheteiroDialogEvent:FireClient(player)
	falouComBilheteiro[player.UserId] = true
end)

-- Trigger do chão que avisa o jogador
local triggerAviso = workspace:WaitForChild("TriggerAviso")

triggerAviso.Touched:Connect(function(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player and not falouComBilheteiro[player.UserId] then
		AvisoBilheteiroEvent:FireClient(player)
	end
end)
