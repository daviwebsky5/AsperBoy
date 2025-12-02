-- Script para deixar TableFrame responsivo e proporcional ao TubesFrame

local tableFrame = script.Parent

-- Adiciona UISizeConstraint para limitar tamanho da mesa
if not tableFrame:FindFirstChildOfClass("UISizeConstraint") then
    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(50, 50)
    sizeConstraint.MaxSize = Vector2.new(700, 280)
    sizeConstraint.Parent = tableFrame
end

-- Ajusta TableFrame para ocupar toda a largura do TubesFrame e diminuir altura
tableFrame.Size = UDim2.new(1, 0, 0.13, 0) -- 100% largura, 13% altura do TubesFrame

