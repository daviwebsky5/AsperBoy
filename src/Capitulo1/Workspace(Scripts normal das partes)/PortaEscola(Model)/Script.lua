local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LabirintoConcluidoEvent = ReplicatedStorage:WaitForChild("LabirintoConcluidoEvent")

local porta = workspace:WaitForChild("PortaEscola")

local clickDetector = porta:FindFirstChildOfClass("ClickDetector")
if not clickDetector then
	clickDetector = Instance.new("ClickDetector")
	clickDetector.MaxActivationDistance = 32
	clickDetector.Parent = porta
end

clickDetector.MouseClick:Connect(function(player)
	-- marca objetivo do labirinto como concluído
	LabirintoConcluidoEvent:FireClient(player)
end)
