local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local pia = script.Parent
local clickDetector = pia:FindFirstChildWhichIsA("ClickDetector", true)

local function ensureGui(player, guiName)
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return nil end

    local gui = playerGui:FindFirstChild(guiName)
    if not gui then
        local template = StarterGui:FindFirstChild(guiName)
        if template then
            gui = template:Clone()
            gui.Parent = playerGui
        end
    end
    return gui
end

local function onClicked(player)
    local gui = ensureGui(player, "CozinhaGui")
    if gui then
        gui.Enabled = true
        gui.Parent = player:FindFirstChild("PlayerGui")
    end
end

if clickDetector then
    clickDetector.MouseClick:Connect(onClicked)
end

