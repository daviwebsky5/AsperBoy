local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local gui = script.Parent

-- BindableEvent para avisar que o puzzle foi concluído
local TubosPuzzleConcluidoBindable = ReplicatedStorage:WaitForChild("TubosPuzzleConcluidoBindable")

-- Labels e Frames
local tubesFrame = gui:WaitForChild("TubesFrame")
local completedLabel = tubesFrame:FindFirstChild("CompletedLabel")
if completedLabel then completedLabel.Visible = false end

-- Pega todos os tubos
local tubeFrames = {}
for _, child in tubesFrame:GetChildren() do
	if child:IsA("ImageButton") then
		table.insert(tubeFrames, child)
	end
end

-- Configuração de níveis
local LEVELS = {
	{
		BALLS_PER_TUBE = 4,
		COLORS = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,150,255)},
		TUBES_COUNT = 4
	},
	{
		BALLS_PER_TUBE = 4,
		COLORS = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,150,255), Color3.fromRGB(227, 227, 0)},
		TUBES_COUNT = 5
	}
}

local ANIM_SPEED = 0.4
local tubes = {}
local selectedTube = nil
local currentLevel = 1
local moving = false
local tubeConnections = {}

-- Shuffle
local function shuffle(tbl)
	for i = #tbl, 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
end

-- Limpar tubo visual
local function clearTubeVisual(tube)
	for _, c in tube:GetChildren() do
		if c:IsA("Frame") then c:Destroy() end
	end
end

-- Criar bola
local function createBall(color, positionY)
	local ball = Instance.new("Frame")
	ball.Size = UDim2.new(0.8,0,0.18,0)
	ball.Position = UDim2.new(0.1,0,positionY,0)
	ball.BackgroundColor3 = color
	ball.BorderSizePixel = 0
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1,0)
	corner.Parent = ball
	return ball
end

-- Atualizar visual do tubo
local function updateTubeVisual(tube, data)
	clearTubeVisual(tube)
	for i, color in data do
		local y = 1 - i * 0.2
		local ball = createBall(color, y)
		ball.Parent = tube
	end
end

-- Verificar se puzzle resolvido
local function isSolved()
	for i = 1, LEVELS[currentLevel].TUBES_COUNT do
		local tube = tubes[i]
		if #tube > 0 then
			local first = tube[1]
			for j = 2, #tube do
				if tube[j] ~= first then return false end
			end
			if #tube < LEVELS[currentLevel].BALLS_PER_TUBE then return false end
		end
	end
	return true
end

-- Animação da bola
local function animateBallMove(fromFrame, toFrame, color, toHeight)
	local ball = createBall(color, 0)
	ball.Parent = gui
	ball.Position = UDim2.new(0, fromFrame.AbsolutePosition.X, 0, fromFrame.AbsolutePosition.Y)
	ball.Size = UDim2.new(0, fromFrame.AbsoluteSize.X * 0.8, 0, fromFrame.AbsoluteSize.Y * 0.18)

	local targetX = toFrame.AbsolutePosition.X
	local targetY = toFrame.AbsolutePosition.Y + toFrame.AbsoluteSize.Y * (1 - toHeight * 0.2)

	local moveUp = TweenService:Create(ball, TweenInfo.new(ANIM_SPEED/1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = ball.Position - UDim2.new(0,0,0,30)})
	moveUp:Play()
	moveUp.Completed:Wait()

	local moveAcross = TweenService:Create(ball, TweenInfo.new(ANIM_SPEED/1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, targetX, 0, ball.Position.Y.Offset)})
	moveAcross:Play()
	moveAcross.Completed:Wait()

	local moveDown = TweenService:Create(ball, TweenInfo.new(ANIM_SPEED/1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0, targetX, 0, targetY)})
	moveDown:Play()
	moveDown.Completed:Wait()

	ball:Destroy()
end

-- Pop da bola
local function popBall(ballFrame)
	if not ballFrame then return end
	local tweenUp = TweenService:Create(ballFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.9,0,0.22,0)})
	local tweenDown = TweenService:Create(ballFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0.8,0,0.18,0)})
	tweenUp:Play()
	tweenUp.Completed:Wait()
	tweenDown:Play()
end

-- ============================
-- Movimento
-- ============================
local function canMoveBall(fromTube, toTube)
	if #fromTube == 0 then return false end
	if #toTube >= LEVELS[currentLevel].BALLS_PER_TUBE then return false end
	return true
end

local function moveBall(fromIndex, toIndex)
	if moving then return end
	moving = true

	local fromTube = tubes[fromIndex]
	local toTube = tubes[toIndex]

	if not canMoveBall(fromTube, toTube) then
		moving = false
		return
	end

	local color = fromTube[#fromTube]
	table.remove(fromTube)
	updateTubeVisual(tubeFrames[fromIndex], fromTube)

	local toHeight = #toTube + 1
	animateBallMove(tubeFrames[fromIndex], tubeFrames[toIndex], color, toHeight)

	table.insert(toTube, color)
	updateTubeVisual(tubeFrames[toIndex], toTube)

	moving = false

	if isSolved() then
		if currentLevel < #LEVELS then
			currentLevel = currentLevel + 1
			setupPuzzle()
		else
			if completedLabel then
				completedLabel.Visible = true

				-- Remove highlight da Part TuboTeste
				local tuboPart = workspace:FindFirstChild("TuboTeste")
				if tuboPart then
					local highlight = tuboPart:FindFirstChildOfClass("Highlight")
					if highlight then highlight.Enabled = false end
				end

				-- 🔔 Dispara BindableEvent para atualizar objetivos
				TubosPuzzleConcluidoBindable:Fire()

				task.delay(2, function()
					-- Fade-out GUI
					local fadeTime = 1
					for _, descendant in ipairs(gui:GetDescendants()) do
						if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
							TweenService:Create(descendant, TweenInfo.new(fadeTime), {ImageTransparency = 1}):Play()
						elseif descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
							TweenService:Create(descendant, TweenInfo.new(fadeTime), {TextTransparency = 1}):Play()
						elseif descendant:IsA("Frame") then
							TweenService:Create(descendant, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()
						end
					end
					task.wait(fadeTime)
					print("Tentando disparar evento do puzzle…")

					ReplicatedStorage.PuzzleCompletado2:FireServer()
					print("foi")
					gui:Destroy()
					

				end)
			end
		end
	end
end

-- Clique nos tubos
local function onTubeClicked(i)
	local balls = {}
	for _, child in tubeFrames[i]:GetChildren() do
		if child:IsA("Frame") then
			table.insert(balls, child)
		end
	end
	local topBall = balls[#balls]

	if selectedTube == nil then
		selectedTube = i
		popBall(topBall)
	else
		if selectedTube == i then
			selectedTube = nil
			return
		end
		moveBall(selectedTube, i)
		selectedTube = nil
	end
end

-- Hover efeito
local function addTubeHoverEffect(tubeFrame)
	local hoverStroke = Instance.new("UIStroke")
	hoverStroke.Color = Color3.fromRGB(255, 255, 100)
	hoverStroke.Thickness = 3
	hoverStroke.Transparency = 1
	hoverStroke.Parent = tubeFrame

	tubeFrame.MouseEnter:Connect(function()
		hoverStroke.Transparency = 0
	end)
	tubeFrame.MouseLeave:Connect(function()
		hoverStroke.Transparency = 1
	end)
end

-- Inicialização do puzzle
function setupPuzzle()
	for _, conn in tubeConnections do
		conn:Disconnect()
	end
	tubeConnections = {}

	local level = LEVELS[currentLevel]
	shuffle(level.COLORS)

	tubes = {}
	local allBalls = {}
	for _, color in level.COLORS do
		for i = 1, level.BALLS_PER_TUBE do
			table.insert(allBalls, color)
		end
	end
	shuffle(allBalls)

	local idx = 1
	for i = 1, #tubeFrames do
		clearTubeVisual(tubeFrames[i])
		tubeFrames[i].Visible = i <= level.TUBES_COUNT

		if tubeFrames[i].Visible then
			addTubeHoverEffect(tubeFrames[i])
			local conn = tubeFrames[i].MouseButton1Click:Connect(function()
				onTubeClicked(i)
			end)
			table.insert(tubeConnections, conn)
		end

		tubes[i] = {}
		for j = 1, level.BALLS_PER_TUBE do
			if idx <= #allBalls then
				table.insert(tubes[i], allBalls[idx])
				idx += 1
			end
		end
		updateTubeVisual(tubeFrames[i], tubes[i])
	end

	if completedLabel then
		completedLabel.Visible = false
	end
end

setupPuzzle()
