local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cria o evento remoto se não existir
local evento = ReplicatedStorage:FindFirstChild("PortaErradaEvent") or Instance.new("RemoteEvent")
evento.Name = "PortaErradaEvent"
evento.Parent = ReplicatedStorage

-- Defina quais são as portas erradas e a correta
local portasErradas = {
	game.Workspace:WaitForChild("Porta1"),
	game.Workspace:WaitForChild("Porta2"),
	game.Workspace:WaitForChild("Porta3"),
	game.Workspace:WaitForChild("Porta4")
}

local portaCorreta = game.Workspace:WaitForChild("Porta5")

-- Conecta as portas erradas ao evento de diálogo
for _, porta in ipairs(portasErradas) do
	local clickDetector = porta:FindFirstChild("ClickDetector") or porta:WaitForChild("ClickDetector")
	clickDetector.MouseClick:Connect(function(player)
		evento:FireClient(player, porta.Name)
	end)
end

-- Faz a porta 5 abrir de verdade
local clickDetectorCorreta = portaCorreta:FindFirstChild("ClickDetector") or portaCorreta:WaitForChild("ClickDetector")

clickDetectorCorreta.MouseClick:Connect(function(player)
	print(player.Name .. " abriu a porta correta!")

	-- Efeito simples de abrir (transparente e sem colisão)
	portaCorreta.CanCollide = false
	portaCorreta.Transparency = 1

end)
