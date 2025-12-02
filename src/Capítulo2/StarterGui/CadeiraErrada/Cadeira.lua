local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local DialogoCadeiraEvent = ReplicatedStorage:WaitForChild("DialogoCadeiraEvent")

local gui = script.Parent
local frame = gui:WaitForChild("DialogFrame")
local nomeLabel = frame:WaitForChild("NomeLabel")
local textLabel = frame:WaitForChild("TextLabel")
local nextButton = frame:WaitForChild("NextButton")

frame.Visible = false
nextButton.Visible = false

local function digitarTexto(texto)
	textLabel.Text = ""
	for i = 1, #texto do
		textLabel.Text = string.sub(texto, 1, i)
		task.wait(0.03)
	end
end

DialogoCadeiraEvent.OnClientEvent:Connect(function(nome, mensagem)
	frame.Visible = true
	nextButton.Visible = false
	nextButton.Active = false  -- garante que não seja clicável antes da digitação

	nomeLabel.Text = nome
	digitarTexto(mensagem)

	-- Quando o texto terminar de digitar
	nextButton.Visible = true
	nextButton.Active = true

	nextButton.MouseButton1Click:Once(function()
		frame.Visible = false
	end)
end)
