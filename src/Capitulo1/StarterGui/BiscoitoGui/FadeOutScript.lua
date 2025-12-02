
local frame = script.Parent
local completadoLabel = frame:FindFirstChild("CompletadoLabel")

local function fadeOut()
    for i = 0, 1, 0.05 do
        -- Altera a transparência do fundo do frame
        if frame:IsA("Frame") then
            frame.BackgroundTransparency = i
        end

        -- Itera por todos os descendentes do frame
        for _, child in ipairs(frame:GetDescendants()) do
            if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                child.ImageTransparency = i
            end
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                child.TextTransparency = i
            end
        end
        task.wait(0.05)
    end

    -- Opcional: Desativa o frame para que não seja mais interativo
    frame.Visible = false
end

if completadoLabel then
    print("FadeOutScript: 'CompletadoLabel' encontrada!")
    completadoLabel:GetPropertyChangedSignal("Visible"):Connect(function()
        print("FadeOutScript: 'CompletadoLabel' mudou de visibilidade para: " .. tostring(completadoLabel.Visible))
        if completadoLabel.Visible then
            print("FadeOutScript: Acionando fadeOut().")
            fadeOut()
        end
    end)
    -- Verifica se a label já está visível quando o script é executado
    if completadoLabel.Visible then
        print("FadeOutScript: 'CompletadoLabel' já está visível, acionando fadeOut().")
        fadeOut()
    end
else
    warn("FadeOutScript: Não foi possível encontrar 'CompletadoLabel'. O fade out não será acionado.")
end
