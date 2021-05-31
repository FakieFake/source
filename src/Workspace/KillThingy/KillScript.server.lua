script.Parent.Touched:Connect(function(Hit)
	if Hit and Hit.Parent and Hit.Parent:FindFirstChild("Humanoid")then
		Hit.Parent.Humanoid.Health = 0
	end
end)