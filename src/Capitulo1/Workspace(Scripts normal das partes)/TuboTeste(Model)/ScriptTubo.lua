local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AbrirTubesFrameEvent = ReplicatedStorage:WaitForChild("AbrirTubesFrameEvent")

local tubo = script.Parent
local clickDetector = tubo:FindFirstChildOfClass("ClickDetector")

-- Variável para controlar se o frame já está aberto
local frameAberto = false

clickDetector.MouseClick:Connect(function(player)
    if not frameAberto then
        AbrirTubesFrameEvent:FireClient(player)
        frameAberto = true
    end
end)

