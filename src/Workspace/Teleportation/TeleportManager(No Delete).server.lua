--Variables
local tele1 = script.Parent.Tele1
local tele2 = script.Parent.Tele2
local debounce = 0 -- set to 0 as "default"
local cooldown = 3

--Functions
tele1.Touched:Connect(function(touched)
    if touched.Parent:FindFirstChild("Humanoid") and os.time() >= debounce + cooldown then -- debounce + cooldown = the time when the next
        local char = touched.Parent                                                           -- teleportation can occur
        local humanoidrootpart = char.HumanoidRootPart

        humanoidrootpart.Position = tele2.Position
        debounce = os.time()
    end
end)

tele2.Touched:Connect(function(touched)
    if touched.Parent:FindFirstChild("Humanoid") and os.time() >= debounce + cooldown then -- view above ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        local char = touched.Parent
        local humanoidrootpart = char.HumanoidRootPart

        humanoidrootpart.Position = tele1.Position
        debounce = os.time()
    end
end)