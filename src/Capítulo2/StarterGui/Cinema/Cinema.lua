local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local gui = script.Parent
local frame = gui:WaitForChild("Frame")
local nameLabel = frame:WaitForChild("NameLabel")
local dialogLabel = frame:WaitForChild("DialogLabel")
local nextButton = frame:WaitForChild("NextButton")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local seat = workspace:WaitForChild("CadeiraCinema"):WaitForChild("CinemaSeat")

local ObjetivoVoltarProfessor = ReplicatedStorage:WaitForChild("ObjetivoVoltarProfessor")
local highlightProfessor = Workspace:WaitForChild("CadeiraCinema"):WaitForChild("Highlight")

local dialogos = {
	{nome = "Aluno", texto = "Olha, o moleque autista que precisa de um lugar especifico! Hahaha!"},
	{nome = "Aluno 2", texto = "É muito esquisito..."},
	{nome = "Aluno 3", texto = "É mesmo."},
	{nome = "Você", texto = "*Por que eles estão fazendo isso comigo?*"},
	{nome = "Você", texto = "Ahhhhh!!!"},
}

local indice = 1
local escrevendo = false

local function escreverTexto(texto)
	escrevendo = true
	nextButton.Active = false -- 🔒 Bloqueia o botão
	dialogLabel.Text = ""

	for i = 1, #texto do
		dialogLabel.Text = string.sub(texto, 1, i)
		task.wait(0.03)
		if not escrevendo then
			nextButton.Active = true -- 🔓 Libera se pulou o texto
			return
		end
	end

	escrevendo = false
	nextButton.Active = true -- 🔓 Libera quando terminar de escrever
end


local function mostrarDialogo()
	local fala = dialogos[indice]
	if not fala then
		gui.Enabled = false
		return
	end

	if fala.nome == "Você" then
		nameLabel.BackgroundColor3 = Color3.fromRGB(121, 157, 211)
		dialogLabel.TextColor3 = Color3.fromRGB(121, 157, 211)
	end

	nameLabel.Text = fala.nome
	escreverTexto(fala.texto)
end

nextButton.MouseButton1Click:Connect(function()
	if escrevendo then
		dialogLabel.Text = dialogos[indice].texto
		escrevendo = false
		nextButton.Active = true
		return
	end

	indice += 1

	if indice > #dialogos then
		gui.Enabled = false

		if seat.Occupant == humanoid then
			task.wait(2)
			humanoid.Sit = false
		end

		highlightProfessor.Enabled = false
		ObjetivoVoltarProfessor:Fire()
		return
	end

	mostrarDialogo()
end)

gui:GetPropertyChangedSignal("Enabled"):Connect(function()
	if gui.Enabled == true then
		indice = 1
		mostrarDialogo()
	end
end)
