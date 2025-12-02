-- Script para garantir que o Frame principal do BallSortGui e seus filhos fiquem proporcionais e contidos

local frame = script.Parent

-- Adiciona UIAspectRatioConstraint ao Frame se não existir
if not frame:FindFirstChildOfClass("UIAspectRatioConstraint") then
    local aspect = Instance.new("UIAspectRatioConstraint")
    aspect.AspectRatio = 1.3 -- ajuste conforme design
    aspect.Parent = frame
end

-- Adiciona UISizeConstraint ao Frame se não existir
if not frame:FindFirstChildOfClass("UISizeConstraint") then
    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(400, 300)
    sizeConstraint.MaxSize = Vector2.new(900, 700)
    sizeConstraint.Parent = frame
end

-- Função para tornar filhos proporcionais
local function makeChildResponsive(child)
    -- Adapte os nomes dos botões conforme BallSortGui
    local buttonNames = {
        ["BallButton1"] = true,
        ["BallButton2"] = true,
        ["BallButton3"] = true,
        ["BallButton4"] = true,
    }

    if child:IsA("ImageButton") and buttonNames[child.Name] then
        -- Adiciona UIAspectRatioConstraint se não existir
        if not child:FindFirstChildOfClass("UIAspectRatioConstraint") then
            local aspect = Instance.new("UIAspectRatioConstraint")
            aspect.AspectRatio = 1 -- quadrado por padrão
            aspect.Parent = child
        end
        -- Adiciona UISizeConstraint se não existir
        if not child:FindFirstChildOfClass("UISizeConstraint") then
            local sizeConstraint = Instance.new("UISizeConstraint")
            sizeConstraint.MinSize = Vector2.new(50, 50)
            sizeConstraint.MaxSize = Vector2.new(300, 300)
            sizeConstraint.Parent = child
        end
        child.Size = UDim2.new(0.18, 0, 0.18, 0)
        child.AnchorPoint = Vector2.new(0.5, 0.5)
        -- Distribui os botões horizontalmente na parte inferior (Y = 0.75)
        local buttonOrder = {
            ["BallButton1"] = 1,
            ["BallButton2"] = 2,
            ["BallButton3"] = 3,
            ["BallButton4"] = 4,
        }
        local idx = buttonOrder[child.Name]
        if idx then
            local total = 4
            local spacing = 0.18
            local startX = 0.5 - ((total-1)/2)*spacing
            child.Position = UDim2.new(startX + (idx-1)*spacing, 0, 0.75, 0)
        end
    elseif child:IsA("ImageLabel") and child.Name == "BallLabel" then
        -- Centralizado acima dos botões
        if not child:FindFirstChildOfClass("UIAspectRatioConstraint") then
            local aspect = Instance.new("UIAspectRatioConstraint")
            aspect.AspectRatio = 1
            aspect.Parent = child
        end
        if not child:FindFirstChildOfClass("UISizeConstraint") then
            local sizeConstraint = Instance.new("UISizeConstraint")
            sizeConstraint.MinSize = Vector2.new(50, 50)
            sizeConstraint.MaxSize = Vector2.new(300, 300)
            sizeConstraint.Parent = child
        end
        child.Size = UDim2.new(0.22, 0, 0.22, 0)
        child.AnchorPoint = Vector2.new(0.5, 0.5)
        child.Position = UDim2.new(0.5, 0, 0.55, 0)
    elseif child:IsA("TextLabel") then
        -- Remove UIAspectRatioConstraint se existir
        local aspect = child:FindFirstChildOfClass("UIAspectRatioConstraint")
        if aspect then
            aspect:Destroy()
        end
        -- Remove UISizeConstraint se existir
        local sizeConstraint = child:FindFirstChildOfClass("UISizeConstraint")
        if sizeConstraint then
            sizeConstraint:Destroy()
        end

        -- Titulo: topo centralizado, largura quase total
        if child.Name == "Titulo" then
            child.Size = UDim2.new(0.85, 0, 0.13, 0)
            child.Position = UDim2.new(0.5, 0, 0.09, 0)
            child.AnchorPoint = Vector2.new(0.5, 0.5)
            child.TextScaled = true
            child.TextWrapped = true
        -- CompletedLabel: centralizado no meio do Frame
        elseif child.Name == "CompletedLabel" then
            child.Size = UDim2.new(0.7, 0, 0.11, 0)
            child.Position = UDim2.new(0.5, 0, 0.5, 0)
            child.AnchorPoint = Vector2.new(0.5, 0.5)
            child.TextScaled = true
            child.TextWrapped = true
        else
            -- Outros TextLabels: largura média, centralizado
            child.Size = UDim2.new(0.5, 0, 0.12, 0)
            child.Position = UDim2.new(0.5, 0, 0.5, 0)
            child.AnchorPoint = Vector2.new(0.5, 0.5)
            child.TextScaled = true
            child.TextWrapped = true
        end
    end
end

-- Aplica nos filhos atuais
for _, child in frame:GetChildren() do
    makeChildResponsive(child)
end

-- Se adicionar filhos dinamicamente, conecta ChildAdded
frame.ChildAdded:Connect(makeChildResponsive)

