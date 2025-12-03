local startergui = game:GetService("StarterGui")

repeat
	local disabled = pcall(function()
		startergui:SetCore("ResetButtonCallback", false)
	end)
	task.wait(1)
until disabled
