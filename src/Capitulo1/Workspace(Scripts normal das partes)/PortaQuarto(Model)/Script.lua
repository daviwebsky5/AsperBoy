local objetivoFlag = workspace:WaitForChild("ObjetivosConcluidos")
print("PORTA INICIOU. FLAG =", objetivoFlag.Value)


local TweenService = game:GetService("TweenService")
local workspace = game:GetService("Workspace")

local hinge = script.Parent.Doorframe.Hinge
local prompt = script.Parent.Base.ProximityPrompt
local objetivoFlag = workspace:WaitForChild("ObjetivosConcluidos")

local goalOpen = {CFrame = hinge.CFrame * CFrame.Angles(0, math.rad(90), 0)}
local goalClose = {CFrame = hinge.CFrame * CFrame.Angles(0, 0, 0)}

local tweenInfo = TweenInfo.new(1)
local tweenOpen = TweenService:Create(hinge, tweenInfo, goalOpen)
local tweenClose = TweenService:Create(hinge, tweenInfo, goalClose)

prompt.Triggered:Connect(function()
	print("AO CLICAR NA PORTA, FLAG É:", objetivoFlag.Value)
	if not objetivoFlag.Value then
		-- opcional: avisar o jogador
		prompt.ObjectText = "Conclua todos os objetivos primeiro!"
		task.wait(1)
		prompt.ObjectText = "Porta"
		return
	end

	if prompt.ActionText == "Close" then
		tweenClose:Play()
		prompt.ActionText = "Open"
	else
		tweenOpen:Play()
		prompt.ActionText = "Close"
	end
end)
