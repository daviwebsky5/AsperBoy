local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event = ReplicatedStorage:WaitForChild("CutsceneBusEvent")

local gui = script.Parent
local frame = gui:WaitForChild("Frame")
local nameLabel = frame:WaitForChild("NameLabel")
local dialogueLabel = frame:WaitForChild("DialogueLabel")
local nextButton = frame:WaitForChild("NextButton")
local backgroundImage = gui:WaitForChild("BackgroundImage")
local TweenService = game:GetService("TweenService")

frame.Visible = false
nextButton.Visible = false

-- 🖼️ Lista de falas (cada uma pode ter sua própria imagem)
local dialogues = {
	{
		speaker = "Você",
		text = "Está na hora da aula passeio.",
		image = "rbxassetid://136003618946155" 
	},
	{
		speaker = "Você",
		text = "Vou achar o meu lugar.",
	},
	{
		speaker = "Motorista",
		text = "Entra logo, já vamos sair.",
	},
}

-- ✍️ Efeito de digitação
local function typeText(label, text)
	label.Text = ""
	for i = 1, #text do
		label.Text = string.sub(text, 1, i)
		task.wait(0.03)
	end
end

-- 🎬 Função principal da cutscene
local function playCutscene()
	print("[CLIENT] Cutscene iniciada")
	frame.Visible = true

	-- Fade in da imagem de fundo
	backgroundImage.ImageTransparency = 1
	backgroundImage.Image = dialogues[1].image or ""
	TweenService:Create(backgroundImage, TweenInfo.new(1), {ImageTransparency = 0}):Play()

	frame.BackgroundTransparency = 1
	TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()

	for _, dialogue in ipairs(dialogues) do
		if dialogue.image then
			backgroundImage.Image = dialogue.image
		end

		nameLabel.Text = dialogue.speaker
		typeText(dialogueLabel, dialogue.text)

		nextButton.Visible = true
		nextButton.MouseButton1Click:Wait()
		nextButton.Visible = false
	end

	-- Fade out
	TweenService:Create(backgroundImage, TweenInfo.new(1), {ImageTransparency = 1}):Play()
	TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	task.wait(1)
	frame.Visible = false
end

-- 🟢 Ativar quando o servidor mandar
event.OnClientEvent:Connect(playCutscene)
