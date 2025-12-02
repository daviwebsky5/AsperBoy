-- Este script deve ser colocado em CompletedLabel dentro de CaixadeBrinquedos
local label = script.Parent

label:GetPropertyChangedSignal("Visible"):Connect(function()
    if label.Visible then
        label:SetAttribute("WasVisible", true)
    end
end)

-- Estado inicial
if label.Visible then
    label:SetAttribute("WasVisible", true)
end

