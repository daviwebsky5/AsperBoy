-- Este script bloqueia o movimento do jogador quando qualquer Frame visível é aberto em qualquer ScreenGui habilitado.
-- Ele restaura o movimento corretamente quando todos os Frames estão fechados.
-- Agora com debug em português para saber se há algum Frame aberto.
-- Ignora Frames dentro de LeftPanel ou RightPanel da ScreenGui "DialagoOnibus" e LeftPanel ou RightPanel da "DialagoCinema".
-- Agora também ignora qualquer Frame dentro do ScreenGui "FadeGui" ou "SobreCarga".

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function setupCharacter(char)
	local humanoid = char:WaitForChild("Humanoid")

	-- Sempre salva os valores originais ao spawnar o personagem
	local originalWalk = humanoid.WalkSpeed
	local originalJump = humanoid.JumpPower

	local guiFolder = player:WaitForChild("PlayerGui")

	local locked = false

	local function travar()
		if not locked then
			humanoid.WalkSpeed = 0
			humanoid.JumpPower = 0
			locked = true
			print("[DEBUG] Movimento bloqueado (travar chamado)")
		end
	end

	local function liberar()
		if locked then
			humanoid.WalkSpeed = originalWalk
			humanoid.JumpPower = originalJump
			locked = false
			print("[DEBUG] Movimento liberado (liberar chamado)")
		end
	end

	-- Função auxiliar para verificar se um Frame está dentro de painéis ignorados
	local function isInsideIgnoredPanel(frame)
		-- Ignora o próprio LeftPanel ou RightPanel da DialagoOnibus
		if frame:IsA("Frame") and (frame.Name == "LeftPanel" or frame.Name == "RightPanel") then
			if frame.Parent and frame.Parent:IsA("Frame") and frame.Parent.Name == "DialogoFrame" then
				if frame.Parent.Parent and frame.Parent.Parent:IsA("ScreenGui") and frame.Parent.Parent.Name == "DialagoOnibus" then
					return true
				end
			end
		end
		-- Ignora qualquer descendente de LeftPanel ou RightPanel da DialagoOnibus
		local parent = frame.Parent
		while parent do
			if parent:IsA("Frame") and (parent.Name == "LeftPanel" or parent.Name == "RightPanel") then
				if parent.Parent and parent.Parent:IsA("Frame") and parent.Parent.Name == "DialogoFrame" then
					if parent.Parent.Parent and parent.Parent.Parent:IsA("ScreenGui") and parent.Parent.Parent.Name == "DialagoOnibus" then
						return true
					end
				end
			end
			parent = parent.Parent
		end

		-- Ignora o próprio LeftPanel ou RightPanel da DialagoCinema
		if frame:IsA("Frame") and (frame.Name == "LeftPanel" or frame.Name == "RightPanel") then
			if frame.Parent and frame.Parent:IsA("Frame") and frame.Parent.Name == "DialogoFrame" then
				if frame.Parent.Parent and frame.Parent.Parent:IsA("ScreenGui") and frame.Parent.Parent.Name == "DialagoCinema" then
					return true
				end
			end
		end
		-- Ignora qualquer descendente de LeftPanel ou RightPanel da DialagoCinema
		parent = frame.Parent
		while parent do
			if parent:IsA("Frame") and (parent.Name == "LeftPanel" or parent.Name == "RightPanel") then
				if parent.Parent and parent.Parent:IsA("Frame") and parent.Parent.Name == "DialogoFrame" then
					if parent.Parent.Parent and parent.Parent.Parent:IsA("ScreenGui") and parent.Parent.Parent.Name == "DialagoCinema" then
						return true
					end
				end
			end
			parent = parent.Parent
		end

		-- Ignora qualquer Frame dentro dos ScreenGuis "FadeGui", "SobreCarga" ou "ProximityPrompts"
		parent = frame
		while parent do
			if parent:IsA("ScreenGui") and (parent.Name == "FadeGui" or parent.Name == "SobreCarga" or parent.Name == "ProximityPrompts") then
				return true
			end
			parent = parent.Parent
		end


		return false
	end

	local function checar()
		local algumFrameNaoIgnoradoAberto = false
		for _, gui in guiFolder:GetChildren() do
			if gui:IsA("ScreenGui") and gui.Enabled == true then
				for _, obj in gui:GetDescendants() do
					if obj:IsA("Frame") and obj.Visible == true then
						-- Ignorar Frames dentro dos painéis ignorados
						if not isInsideIgnoredPanel(obj) then
							algumFrameNaoIgnoradoAberto = true
							print("[DEBUG] Frame aberto detectado: '" .. obj.Name .. "' dentro do ScreenGui '" .. gui.Name .. "'")
							break
						else
							print("[DEBUG] Ignorando Frame '" .. obj.Name .. "' pois está dentro de painel ignorado")
						end
					end
				end
			end
			if algumFrameNaoIgnoradoAberto then break end
		end

		if algumFrameNaoIgnoradoAberto then
			print("[DEBUG] Algum Frame não ignorado está aberto, travando movimento.")
			travar()
		else
			print("[DEBUG] Nenhum Frame não ignorado aberto, liberando movimento.")
			liberar()
		end
	end

	-- Conecta eventos apenas uma vez por personagem
	guiFolder.DescendantAdded:Connect(function(obj)
		if obj:IsA("Frame") then
			obj:GetPropertyChangedSignal("Visible"):Connect(checar)
		end
	end)

	guiFolder.ChildAdded:Connect(function(obj)
		if obj:IsA("ScreenGui") then
			obj:GetPropertyChangedSignal("Enabled"):Connect(checar)
			for _, frame in obj:GetDescendants() do
				if frame:IsA("Frame") then
					frame:GetPropertyChangedSignal("Visible"):Connect(checar)
				end
			end
		end
	end)

	for _, gui in guiFolder:GetChildren() do
		if gui:IsA("ScreenGui") then
			gui:GetPropertyChangedSignal("Enabled"):Connect(checar)
			for _, obj in gui:GetDescendants() do
				if obj:IsA("Frame") then
					obj:GetPropertyChangedSignal("Visible"):Connect(checar)
				end
			end
		end
	end

	checar()
end

player.CharacterAdded:Connect(setupCharacter)

if player.Character then
	setupCharacter(player.Character)
end

