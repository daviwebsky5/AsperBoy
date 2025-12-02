local seat = script.Parent
local Players = game:GetService("Players")

seat:GetPropertyChangedSignal("Occupant"):Connect(function()
	local humanoid = seat.Occupant

	if humanoid then
		local character = humanoid.Parent
		local player = Players:GetPlayerFromCharacter(character)

		if player then
			-- Espera 5 segundos sentado
			task.wait(2)

			-- Verifica se o jogador ainda está sentado
			if seat.Occupant == humanoid then
				-- Mostra a GUI "Cinema"
				local playerGui = player:WaitForChild("PlayerGui")
				local gui = playerGui:WaitForChild("Cinema")
				gui.Enabled = true
			end
		end
	end
end)
