local dialogFrame = script.Parent

-- Colado na parte inferior e ocupando todo o eixo X
dialogFrame.AnchorPoint = Vector2.new(0.5, 1) -- base central
dialogFrame.Position = UDim2.new(0.5, 0, 1, 0) -- meio em X, base em Y
dialogFrame.Size = UDim2.new(1, 0, 0.22, 0) -- 100% largura, 22% altura da tela

-- Remover AspectRatioConstraint se já existir (não queremos limitar largura)
for k, v in dialogFrame:GetChildren() do
    if v:IsA("UIAspectRatioConstraint") then
        v:Destroy()
    end
end

-- Tamanho mínimo/máximo (apenas altura relevante)
local sizeConstraint = dialogFrame:FindFirstChildWhichIsA("UISizeConstraint")
if not sizeConstraint then
    sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.Parent = dialogFrame
end
sizeConstraint.MinSize = Vector2.new(400, 120)
sizeConstraint.MaxSize = Vector2.new(9999, 400) -- largura ilimitada, altura máxima 400

-- Ajusta elementos internos proporcionalmente
local dialogText = dialogFrame:FindFirstChild("DialogueText")
if dialogText then
    dialogText.Size = UDim2.new(0.5, 0, 0.5, 0)--era 0.92
    dialogText.Position = UDim2.new(0.04, 0, 0.18, 0)
    dialogText.TextScaled = true
end

local nameText = dialogFrame:FindFirstChild("SpeakerName")
if nameText then
    nameText.Size = UDim2.new(1, 0, 0.15, 0) -- ocupa toda a largura
    nameText.Position = UDim2.new(0, 0, 0.02, 0) -- alinhado à esquerda
    nameText.TextScaled = true
    nameText.TextXAlignment = Enum.TextXAlignment.Left -- texto alinhado à esquerda
end

local continueButton = dialogFrame:FindFirstChild("NextButton")
if continueButton then
    continueButton.Size = UDim2.new(0.22, 0, 0.18, 0)
    continueButton.Position = UDim2.new(0.74, 0, 0.75, 0)
    continueButton.TextScaled = true
end

