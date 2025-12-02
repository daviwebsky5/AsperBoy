local label = script.Parent -- TextLabel "TextObjetivoss"
local Workspace = game:GetService("Workspace")
local portaLabirinto = Workspace:FindFirstChild("PortaLabirinto")
local clickDetector = nil

if portaLabirinto then
    clickDetector = portaLabirinto:FindFirstChildWhichIsA("ClickDetector", true)
end

local DISTANCIA_PADRAO = 10 -- Valor padrão para ativação do ClickDetector

local function atualizarInteracao()
    if not clickDetector then return end
    if label.Text == "Todos os objetivos concluídos!" then
        clickDetector.MaxActivationDistance = DISTANCIA_PADRAO
    else
        clickDetector.MaxActivationDistance = 0
    end
end

-- Atualiza sempre que o texto mudar
task.spawn(function()
    while true do
        atualizarInteracao()
        task.wait(1)
    end
end)

-- Atualiza imediatamente ao iniciar
atualizarInteracao()

