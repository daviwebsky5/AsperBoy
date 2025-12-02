local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local LocalPlayer = Players.LocalPlayer

-- Desabilita controles padrão
ContextActionService:BindActionAtPriority(
	"DisableMovement",
	function() return Enum.ContextActionResult.Sink end,
	false,
	Enum.ContextActionPriority.High.Value,
	Enum.PlayerActions.CharacterForward,
	Enum.PlayerActions.CharacterBackward,
	Enum.PlayerActions.CharacterLeft,
	Enum.PlayerActions.CharacterRight,
	Enum.PlayerActions.CharacterJump
)

local function getCharacter()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function moveToMousePosition()
	local character = getCharacter()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not rootPart then return end

	local mouse = LocalPlayer:GetMouse()
	local targetPos = nil

	-- Raycast do mouse para o chão
	local unitRay = workspace.CurrentCamera:ScreenPointToRay(mouse.X, mouse.Y)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {character}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

	local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 500, raycastParams)
	if raycastResult then
		targetPos = raycastResult.Position
	end

	if targetPos then
		humanoid:MoveTo(targetPos)
	end
end

-- Controle do evento de clique
local mouseConnection = nil

function _G.SetMovimentoMouseEnabled(enabled)
	if enabled then
		if not mouseConnection then
			mouseConnection = UserInputService.InputBegan:Connect(function(input, processed)
				if processed then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					moveToMousePosition()
				end
			end)
		end
	else
		if mouseConnection then
			mouseConnection:Disconnect()
			mouseConnection = nil
		end
	end
end

-- Ativa por padrão
_G.SetMovimentoMouseEnabled(true)

