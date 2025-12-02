local frame = script.Parent
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- BindableEvent para avisar que o puzzle foi concluído
local AnimaisPuzzleConcluidoBindable = ReplicatedStorage:WaitForChild("AnimaisPuzzleConcluidoBindable")

-- Labels e ImageButton
local CompleteLabel = frame:WaitForChild("CompleteLabel")
local FeedbackLabel = frame:WaitForChild("FeedbackLabel")
local AnimalImage = frame:WaitForChild("AnimalImage")

CompleteLabel.Visible = false
FeedbackLabel.Visible = false

-- Botões automáticos
local optionButtons = {}
for i = 1, 3 do
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 150, 0, 50)
	button.Position = UDim2.new(0.05 + (i-1)*0.33, 0, 0.75, 0)
	button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	button.TextColor3 = Color3.fromRGB(0, 0, 0)
	button.Font = Enum.Font.SourceSansBold
	button.TextScaled = true
	button.Parent = frame
	button.Active = true
	button.Selectable = true
	table.insert(optionButtons, button)
end

-- Lista de animais
local animals = {
	{ name = "Gato", soundId = "rbxassetid://76835706388974", imageId = "rbxassetid://97215575694526" },
	{ name = "Cachorro", soundId = "rbxassetid://131557091331562", imageId = "rbxassetid://110768437209141" },
	{ name = "Vaca", soundId = "rbxassetid://111335949694603", imageId = "rbxassetid://139491318799522" },
	{ name = "Leão", soundId = "rbxassetid://127377086736443", imageId = "rbxassetid://138040738287507" },
	{ name = "Elefante", soundId = "rbxassetid://73188363002860", imageId = "rbxassetid://132570378525601" },
	{ name = "Macaco", soundId = "rbxassetid://81055765419338", imageId = "rbxassetid://82583904534778" },
	{ name = "Cavalo", soundId = "rbxassetid://92688501514138", imageId = "rbxassetid://125691311296784" },
	{ name = "Ovelha", soundId = "rbxassetid://76490376677672", imageId = "rbxassetid://108074449175934" }
}

local remainingAnimals = table.clone(animals)
local currentAnimal = nil
local isPlayingSound = false
local currentSound = nil

-- Função para tocar som dentro do frame
local function playAnimalSound(animal)
	if isPlayingSound then return end
	isPlayingSound = true

	if currentSound then
		currentSound:Stop()
		currentSound:Destroy()
		currentSound = nil
	end

	currentSound = Instance.new("Sound")
	currentSound.SoundId = animal.soundId
	currentSound.Volume = 1
	currentSound.Parent = frame
	currentSound:Play()
	currentSound.Ended:Connect(function()
		isPlayingSound = false
		if currentSound then
			currentSound:Destroy()
			currentSound = nil
		end
	end)
end

-- Função de feedback
local function showFeedback(text, color)
	FeedbackLabel.Text = text
	FeedbackLabel.TextColor3 = color
	FeedbackLabel.Visible = true
	task.wait(1)
	FeedbackLabel.Visible = false
end

-- Embaralhar opções
local function shuffle(t)
	for i = #t, 2, -1 do
		local j = math.random(1, i)
		t[i], t[j] = t[j], t[i]
	end
end

-- Fade completo incluindo frame, filhos e UIStroke
local function fadeOutFrame(targetFrame)
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweens = {}

	local function tweenGuiObject(obj)
		if obj:IsA("GuiObject") then
			local props = {BackgroundTransparency = 1}
			if obj:IsA("TextLabel") or obj:IsA("TextButton") then props.TextTransparency = 1 end
			if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then props.ImageTransparency = 1 end
			table.insert(tweens, TweenService:Create(obj, tweenInfo, props))
		end
		local uiStroke = obj:FindFirstChildWhichIsA("UIStroke")
		if uiStroke then
			table.insert(tweens, TweenService:Create(uiStroke, tweenInfo, {Transparency = 1}))
		end
		for _, child in ipairs(obj:GetChildren()) do
			tweenGuiObject(child)
		end
	end

	tweenGuiObject(targetFrame)

	for _, t in ipairs(tweens) do t:Play() end
	for _, t in ipairs(tweens) do t.Completed:Wait() end

	for _, obj in ipairs(targetFrame:GetDescendants()) do
		if obj:IsA("GuiObject") then obj.Visible = false end
		local uiStroke = obj:FindFirstChildWhichIsA("UIStroke")
		if uiStroke then uiStroke.Enabled = false end
	end
	targetFrame.Visible = false
	local frameStroke = targetFrame:FindFirstChildWhichIsA("UIStroke")
	if frameStroke then frameStroke.Enabled = false end
end

-- Atualiza animal atual e botões
local function updateAnimal()
	if #remainingAnimals == 0 then
		CompleteLabel.Visible = true
		task.wait(1.5)

		AnimaisPuzzleConcluidoBindable:Fire()
		print("Tentando disparar evento do puzzle…")

		ReplicatedStorage.PuzzleCompletado1:FireServer()
		print("evento disparado")
		local animalPart = workspace:FindFirstChild("Animals")
		if animalPart then
			local highlight = animalPart:FindFirstChildOfClass("Highlight")
			if highlight then highlight.Enabled = false end
		end

		-- Desativa botões e envia para fora da tela
		for _, obj in ipairs(frame:GetDescendants()) do
			if obj:IsA("TextButton") or obj:IsA("ImageButton") then
				obj.Active = false
				obj.Selectable = false
				obj.Position = UDim2.new(-5, 0, -5, 0)
			end
		end

		-- Fade completo do frame
		fadeOutFrame(frame)
		

		return
	end

	local index = math.random(1, #remainingAnimals)
	currentAnimal = remainingAnimals[index]
	table.remove(remainingAnimals, index)
	AnimalImage.Image = currentAnimal.imageId

	local options = {currentAnimal.name}
	while #options < 3 do
		local randomAnimal = animals[math.random(1, #animals)].name
		if not table.find(options, randomAnimal) then table.insert(options, randomAnimal) end
	end
	shuffle(options)

	for i, button in ipairs(optionButtons) do
		button.Text = options[i]
		button.Active = true
		button.Selectable = true
	end
end

-- Clique na imagem
AnimalImage.MouseButton1Click:Connect(function()
	if currentAnimal then playAnimalSound(currentAnimal) end
end)

-- Clique nos botões
for _, button in ipairs(optionButtons) do
	button.MouseButton1Click:Connect(function()
		if not currentAnimal then return end
		if button.Text == currentAnimal.name then
			if currentSound then
				currentSound:Stop()
				currentSound:Destroy()
				currentSound = nil
				isPlayingSound = false
			end
			showFeedback("Correto!", Color3.fromRGB(0, 255, 0))
			updateAnimal()
		else
			showFeedback("Errado!", Color3.fromRGB(255, 0, 0))
		end
	end)
end

-- Inicializa
updateAnimal()
