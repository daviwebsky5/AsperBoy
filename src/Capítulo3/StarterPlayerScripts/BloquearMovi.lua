-- Este script bloqueia o movimento do jogador quando qualquer Frame visível é aberto em qualquer ScreenGui habilitado.
-- Ele restaura o movimento corretamente quando todos os Frames estão fechados.
-- Agora com debug em português para saber se há algum Frame aberto.
-- Ignora Frames dentro de LeftPanel ou RightPanel da ScreenGui "DialagoOnibus" e LeftPanel ou RightPanel da "DialagoCinema".
-- Agora também ignora qualquer Frame dentro do ScreenGui "FadeGui" ou "SobreCarga".
-- Agora ignora qualquer Frame (e seus filhos) dentro do ScreenGui "ProximityPrompts".
-- Agora ignora qualquer Frame dentro do ScreenGui "TelaPretaGui".
-- Agora ignora o Frame chamado "ImageFrame" dentro do ScreenGui "TelaPreta".

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function deveIgnorar(frame)
	-- Ignora Frames dentro dos painéis específicos ou dentro dos GUIs ignorados
	local gui = frame:FindFirstAncestorWhichIsA("ScreenGui")
	if not gui then return false end

	if gui.Name == "FadeGui" or gui.Name == "SobreCarga" then
		return true
	end

	if gui.Name == "DialagoOnibus" or gui.Name == "DialagoCinema" then
		local parent = frame.Parent
		if parent and (parent.Name == "LeftPanel" or parent.Name == "RightPanel") then
			return true
		end
	end

	-- Ignorar qualquer Frame (ou descendente) dentro do ScreenGui "ProximityPrompts"
	if gui.Name == "ProximityPrompts" then
		return true
	end

	-- Ignorar qualquer Frame dentro do ScreenGui "TelaPretaGui"
	if gui.Name == "TelaPretaGui" then
		return true
	end

	-- Ignorar o Frame chamado "ImageFrame" dentro do ScreenGui "TelaPreta"
	if gui.Name == "TelaPreta" and frame.Name == "ImageFrame" then
		return true
	end

	return false
end

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

	-- Função modificada para retornar o Frame aberto
	local function algumFrameAberto()
		for _, gui in guiFolder:GetChildren() do
			if gui:IsA("ScreenGui") and gui.Enabled == true then
				for _, obj in gui:GetDescendants() do
					if obj:IsA("Frame") and obj.Visible == true and not deveIgnorar(obj) then
						return true, obj, gui
					end
				end
			end
		end
		return false, nil, nil
	end

	local function checar()
		local aberto, frameAberto, guiAberto = algumFrameAberto()
		if aberto then
			travar()
			if frameAberto and guiAberto then
				print("[DEBUG] Frame aberto detectado: '" .. frameAberto.Name .. "' dentro do ScreenGui '" .. guiAberto.Name .. "'")
			end
		else
			liberar()
		end
	end

	-- Monitorar mudanças de visibilidade e adição/remoção de GUIs
	local connections = {}

	local function conectarMudancas(obj)
		if obj:IsA("Frame") then
			table.insert(connections, obj:GetPropertyChangedSignal("Visible"):Connect(checar))
		end
		for _, child in obj:GetChildren() do
			conectarMudancas(child)
		end
	end

	local function conectarGui(gui)
		if gui:IsA("ScreenGui") then
			table.insert(connections, gui:GetPropertyChangedSignal("Enabled"):Connect(checar))
			for _, obj in gui:GetDescendants() do
				conectarMudancas(obj)
			end
			table.insert(connections, gui.DescendantAdded:Connect(function(desc)
				conectarMudancas(desc)
				checar()
			end))
			table.insert(connections, gui.DescendantRemoving:Connect(function(desc)
				checar()
			end))
		end
	end

	-- Limpar conexões antigas ao respawnar personagem
	local function limparConexoes()
		for _, conn in connections do
			conn:Disconnect()
		end
		connections = {}
	end

	-- Conectar em todos GUIs atuais
	for _, gui in guiFolder:GetChildren() do
		conectarGui(gui)
	end

	-- Conectar em novos GUIs adicionados
	table.insert(connections, guiFolder.ChildAdded:Connect(function(child)
		conectarGui(child)
		checar()
	end))
	table.insert(connections, guiFolder.ChildRemoved:Connect(function(child)
		checar()
	end))

	-- Checar inicialmente
	checar()

	-- Limpar conexões ao morrer/despawnar
	char.AncestryChanged:Connect(function(_, parent)
		if not parent then
			limparConexoes()
		end
	end)
end

player.CharacterAdded:Connect(setupCharacter)

if player.Character then
	setupCharacter(player.Character)
end

