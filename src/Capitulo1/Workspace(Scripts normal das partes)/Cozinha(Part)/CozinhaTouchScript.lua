local part = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CozinhaObjetivoEvent = ReplicatedStorage:WaitForChild("CozinhaObjetivoEvent")
local Players = game:GetService("Players")

local touched = false

part.Touched:Connect(function(hit)
    if touched then return end
    local character = hit.Parent
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        local player = Players:GetPlayerFromCharacter(character)
        if player then
            touched = true
            CozinhaObjetivoEvent:FireClient(player)
        end
    end
end)

