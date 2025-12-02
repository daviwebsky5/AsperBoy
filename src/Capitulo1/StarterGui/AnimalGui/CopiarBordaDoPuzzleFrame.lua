local player = game:GetService("Players").LocalPlayer
local playerGui = player:FindFirstChild("PlayerGui")
local animalFrame = script.Parent

-- Função para encontrar PuzzleFrame em StarterGui ou PlayerGui
local function findPuzzleFrame()
    -- Tenta em PlayerGui
    if playerGui then
        local caixadeBrinquedosGui = playerGui:FindFirstChild("CaixadeBrinquedos")
        if caixadeBrinquedosGui then
            local pf = caixadeBrinquedosGui:FindFirstChild("PuzzleFrame")
            if pf then return pf end
        end
        local puzzleGui = playerGui:FindFirstChild("PuzzleGui")
        if puzzleGui then
            local pf = puzzleGui:FindFirstChild("PuzzleFrame")
            if pf then return pf end
        end
    end
    -- Tenta em StarterGui
    local starterGui = game:GetService("StarterGui")
    local caixadeBrinquedosGui = starterGui:FindFirstChild("CaixadeBrinquedos")
    if caixadeBrinquedosGui then
        local pf = caixadeBrinquedosGui:FindFirstChild("PuzzleFrame")
        if pf then return pf end
    end
    local puzzleGui = starterGui:FindFirstChild("PuzzleGui")
    if puzzleGui then
        local pf = puzzleGui:FindFirstChild("PuzzleFrame")
        if pf then return pf end
    end
    return nil
end

local puzzleFrame = findPuzzleFrame()

if puzzleFrame then
    local puzzleStroke = puzzleFrame:FindFirstChildOfClass("UIStroke")
    local puzzleCorner = puzzleFrame:FindFirstChildOfClass("UICorner")

    -- Copia propriedades do UIStroke
    if puzzleStroke then
        local animalStroke = animalFrame:FindFirstChildOfClass("UIStroke")
        if not animalStroke then
            animalStroke = Instance.new("UIStroke")
            animalStroke.Parent = animalFrame
        end
        animalStroke.Color = puzzleStroke.Color
        animalStroke.Thickness = puzzleStroke.Thickness
        animalStroke.Transparency = puzzleStroke.Transparency
        animalStroke.ApplyStrokeMode = puzzleStroke.ApplyStrokeMode
        animalStroke.LineJoinMode = puzzleStroke.LineJoinMode
    end

    -- Copia propriedades do UICorner
    if puzzleCorner then
        local animalCorner = animalFrame:FindFirstChildOfClass("UICorner")
        if not animalCorner then
            animalCorner = Instance.new("UICorner")
            animalCorner.Parent = animalFrame
        end
        animalCorner.CornerRadius = puzzleCorner.CornerRadius
    end
else
    warn("PuzzleFrame não encontrado para copiar borda!")
end

