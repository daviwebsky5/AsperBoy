local player = game.Players.LocalPlayer
local gui = script.Parent
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse() 
local gui = script.Parent
local draggingObject
local mouseOffset = Vector2.new()

-- Guardar posição inicial dos biscoitos
local initialPositions = {}

-- Jarras do puzzle
local jarras = {
	Quadrado = gui:WaitForChild("JarraQuadrado"),
	Triangulo = gui:WaitForChild("JarraTriangulo"),
	Circulo = gui:WaitForChild("JarraCirculo"),
	Estrela = gui:WaitForChild("JarraEstrela"),
}

-- Label de completado
local completadoLabel = gui:WaitForChild("CompletadoLabel")
completadoLabel.Visible = false -- começa invisível

-- Guardar todos os biscoitos
local cookies = {}
for _, obj in ipairs(gui:GetChildren()) do
	if obj:IsA("ImageButton") and obj.Name:match("Biscoito") then
		table.insert(cookies, obj)
		initialPositions[obj] = obj.Position
	end
end

-- Função startDrag: Pega o offset de onde o mouse clicou no biscoito
local function startDrag(button)
	if not button.Active then return end
	draggingObject = button

	mouseOffset = Vector2.new(
		mouse.X - button.AbsolutePosition.X, 
		mouse.Y - button.AbsolutePosition.Y
	)
	button.ZIndex = 10
end

-- Parar arrasto
local function stopDrag()
	if draggingObject then
		draggingObject.ZIndex = 1
		draggingObject = nil
	end
end

-- Função updateDrag: Move o biscoito
local function updateDrag()
	if draggingObject then
		local screenSize = workspace.CurrentCamera.ViewportSize

		-- Sem ajustes manuais, pois mouse.X/Y já compensa
		local newX_pixel = (mouse.X - mouseOffset.X)
		local newY_pixel = (mouse.Y - mouseOffset.Y) 

		-- Converte os pixels corrigidos para Scale
		draggingObject.Position = UDim2.new(newX_pixel / screenSize.X, 0, newY_pixel / screenSize.Y, 0)
	end
end
-- Checar se sobrepõe
local function isOverlapping(obj1, obj2)
	local pos1 = obj1.AbsolutePosition
	local size1 = obj1.AbsoluteSize
	local pos2 = obj2.AbsolutePosition
	local size2 = obj2.AbsoluteSize
	return not (pos1.X + size1.X < pos2.X or pos1.X > pos2.X + size2.X or
		pos1.Y + size1.Y < pos2.Y or pos1.Y > pos2.Y + size2.Y)
end

-- Contar cookies corretos
local placedCount = 0

-- Verificar colocação
local function checkPlacement(cookie)
	for forma, jarra in pairs(jarras) do
		if cookie.Name:match(forma) then
			if isOverlapping(cookie, jarra) then
				-- Coloca cookie na jarra
				cookie.Position = jarra.Position
				cookie.Size = jarra.Size
				cookie.Active = false
				cookie.ZIndex = 2

				-- Garante que o cookie não fique preso no mouse
				if draggingObject == cookie then
					draggingObject = nil
				end

				placedCount += 1
				print(cookie.Name .. " colocado corretamente!")

				-- Puzzle completo
				if placedCount == #cookies then
					completadoLabel.Visible = true
					task.wait(2)

					-- Desativa Highlight do model tabelBiscoito
					local tabelaBiscoito = workspace:FindFirstChild("tableBiscoito")
					if tabelaBiscoito then
						local highlight = tabelaBiscoito:FindFirstChildOfClass("Highlight")
						if highlight then
							highlight.Enabled = false
						end
					end

					
				end
				return true
			end
		end
	end

	-- Se soltar fora, volta para a posição inicial
	cookie.Position = initialPositions[cookie]
	return false
end

-- Conectar eventos de arrasto
for _, cookie in ipairs(cookies) do
	cookie.MouseButton1Down:Connect(function()
		startDrag(cookie)
	end)
end

-- Soltar
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and draggingObject then
		checkPlacement(draggingObject)
		stopDrag()
	end
end)

-- Atualizar por frame
local renderSteppedConnection
renderSteppedConnection = RunService.RenderStepped:Connect(function()
	if draggingObject then
		updateDrag()
	end
end)

-- Limpar quando GUI for destruída
gui.Destroying:Connect(function()
	renderSteppedConnection:Disconnect()
end)
