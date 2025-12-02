local frame = script.Parent
local RunService = game:GetService("RunService")

-- Função para aplicar pop in recursivamente
local function popInAll(obj, duration)
    local startTime = tick()
    local initialSizes = {}

    -- Salva tamanhos iniciais e define estado inicial (pequeno e invisível)
    local function saveInitial(o)
        if o:IsA("Frame") or o:IsA("ImageButton") or o:IsA("TextLabel") or o:IsA("TextButton") then
            initialSizes[o] = o.Size
            -- Começa pequeno e invisível
            local sz = o.Size
            o.Size = UDim2.new(sz.X.Scale * 0.2, sz.X.Offset * 0.2, sz.Y.Scale * 0.2, sz.Y.Offset * 0.2)
            if o.Name == "Titulo" and o:IsA("TextLabel") then
                o.BackgroundTransparency = 1
            elseif o == frame then
                o.BackgroundTransparency = 0.2
            else
                o.BackgroundTransparency = 1
            end
            if o:IsA("TextLabel") or o:IsA("TextButton") then
                o.TextTransparency = 1
            end
        end
        for _, child in o:GetChildren() do
            saveInitial(child)
        end
    end

    saveInitial(obj)

    local function setPopIn(o, alpha)
        if initialSizes[o] then
            local targetSize = initialSizes[o]
            local startSize = UDim2.new(targetSize.X.Scale * 0.2, targetSize.X.Offset * 0.2, targetSize.Y.Scale * 0.2, targetSize.Y.Offset * 0.2)
            o.Size = UDim2.new(
                startSize.X.Scale + (targetSize.X.Scale - startSize.X.Scale) * alpha,
                startSize.X.Offset + (targetSize.X.Offset - startSize.X.Offset) * alpha,
                startSize.Y.Scale + (targetSize.Y.Scale - startSize.Y.Scale) * alpha,
                startSize.Y.Offset + (targetSize.Y.Offset - startSize.Y.Offset) * alpha
            )
            if o.Name == "Titulo" and o:IsA("TextLabel") then
                o.BackgroundTransparency = 1
            elseif o == frame then
                o.BackgroundTransparency = 0.2
            else
                o.BackgroundTransparency = 1 - alpha
            end
            if o:IsA("TextLabel") or o:IsA("TextButton") then
                o.TextTransparency = 1 - alpha
            end
        end
        for _, child in o:GetChildren() do
            setPopIn(child, alpha)
        end
    end

    local connection
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local alpha = math.clamp(elapsed / duration, 0, 1)
        setPopIn(obj, alpha)
        if alpha >= 1 then
            -- Garante valores finais
            for o, size in initialSizes do
                o.Size = size
                if o.Name == "Titulo" and o:IsA("TextLabel") then
                    o.BackgroundTransparency = 1
                elseif o == frame then
                    o.BackgroundTransparency = 0.2
                else
                    o.BackgroundTransparency = 0
                end
                if o:IsA("TextLabel") or o:IsA("TextButton") then
                    o.TextTransparency = 0
                end
            end
            connection:Disconnect()
        end
    end)
end

-- Função pública para ser chamada externamente
function PopIn()
    frame.Visible = true
    task.wait(0.05)
    print("PopInTubesFrame: Iniciando efeito pop in")
    popInAll(frame, 0.5)
end

-- Não chama automaticamente o efeito ao carregar o script
-- Para executar: PopIn()

