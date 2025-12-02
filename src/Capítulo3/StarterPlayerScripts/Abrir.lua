local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Nome da GUI do puzzle
local puzzleGui = playerGui:WaitForChild("DialogoProfessor") -- sua GUI

-- RemoteEvent vindo do ProximityPrompt
local abrirPuzzleEvent = ReplicatedStorage:WaitForChild("AbrirPuzzleEvent")

abrirPuzzleEvent.OnClientEvent:Connect(function()
	puzzleGui.Enabled = true
end)
