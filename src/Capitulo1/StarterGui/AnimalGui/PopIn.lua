local TweenService = game:GetService("TweenService")
local frame = script.Parent

-- Centraliza o frame
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)

-- Inicialmente invisível e tamanho 0
frame.Visible = false
frame.Size = UDim2.new(0, 0, 0, 0)

-- Função para pop in
local function popIn()
	frame.Visible = true
	local popInTween = TweenService:Create(
		frame,
		TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = UDim2.new(0.638, 0, 0.766, 0)} -- tamanho final
	)
	popInTween:Play()
end

-- Checa quando o frame for ativado (Visible = true) pelo script do model
frame:GetPropertyChangedSignal("Visible"):Connect(function()
	if frame.Visible then
		popIn()
	end
end)
