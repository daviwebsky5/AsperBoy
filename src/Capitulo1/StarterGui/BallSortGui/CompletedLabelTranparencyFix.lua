-- Este script deve ser colocado como LocalScript dentro de TubesFrame
local tubesFrame = script.Parent

-- Função para garantir transparência do CompletedLabel
local function setCompletedLabelTransparent(label)
    if label and label:IsA("TextLabel") then
        label.BackgroundTransparency = 1
    end
end

-- Função para conectar listeners ao CompletedLabel
local function connectCompletedLabel(label)
    if not label or not label:IsA("TextLabel") then return end

    -- Sempre que mudar algo relevante, garantir transparência
    label.Changed:Connect(function(property)
        if property == "Visible" or property == "Text" or property == "BackgroundTransparency" then
            setCompletedLabelTransparent(label)
        end
    end)

    -- Aplicar imediatamente
    setCompletedLabelTransparent(label)
end

-- Conecta ao evento que indica que o puzzle foi concluído
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local puzzleCompletedEvent = ReplicatedStorage:FindFirstChild("BallSortPuzzleCompletedEvent")

local completedLabel = tubesFrame:FindFirstChild("CompletedLabel")
connectCompletedLabel(completedLabel)

if puzzleCompletedEvent then
    puzzleCompletedEvent.OnClientEvent:Connect(function()
        local label = tubesFrame:FindFirstChild("CompletedLabel")
        setCompletedLabelTransparent(label)
    end)
end

-- Caso CompletedLabel seja recriado dinamicamente
tubesFrame.ChildAdded:Connect(function(child)
    if child.Name == "CompletedLabel" and child:IsA("TextLabel") then
        connectCompletedLabel(child)
    end
end)

