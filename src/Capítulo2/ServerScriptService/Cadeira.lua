local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DialogoCadeiraEvent = ReplicatedStorage:WaitForChild("DialogoCadeiraEvent")

local dialogos = {
	["Cadeira1"] = { nome = "Você", texto = "Muito no meio do ônibus..." },
	["Cadeira2"] = { nome = "Você", texto = "Perto da janela e tem uma pessoa ali sentado no lado..." },
	["Cadeira3"] = { nome = "Você", texto = "Tem uma pessoa ali no lado..." },
	["Cadeira4"] = { nome = "Você", texto = "Muito perto da Janela..." }
}

for nomeCadeira, dados in pairs(dialogos) do
	local cadeira = workspace:WaitForChild(nomeCadeira)
	local clickDetector = cadeira:FindFirstChildOfClass("ClickDetector")

	if clickDetector then
		clickDetector.MouseClick:Connect(function(player)
			DialogoCadeiraEvent:FireClient(player, dados.nome, dados.texto)
		end)
	end
end
