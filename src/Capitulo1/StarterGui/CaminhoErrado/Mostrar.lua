local player = game.Players.LocalPlayer
local gui = script.Parent
local frame = gui:WaitForChild("CaminhoErradoFrame")
local textLabel = frame:WaitForChild("DialogueText")
local nome = frame:WaitForChild("SpeakerLabel")

-- Função que mostra uma fala por alguns segundos
local function showDialogue(text, duration)
	frame.Visible = true
	textLabel.Text = text
	task.wait(duration or 2)
	frame.Visible = false
end

return showDialogue
