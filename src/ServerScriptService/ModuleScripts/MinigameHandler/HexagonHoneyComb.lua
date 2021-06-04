--[[
    MADE BY FAKIE (ALSO KNOWN AS HAMMYLAMMYYT ON ROBLOX)
]]

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService") -- Tweening is faster than using a loop with wait()
local TransparencyInfo = TweenInfo.new(0.75, Enum.EasingStyle.Linear)
local TransparencyGoal = {Transparency = 1}

local HexagonHoneyComb = {}

local chance = 15 -- Default is 15, meaning theres a 1 in 15 chance a platform will be instafall. Changing this number to something higher will make it occur rarely, while changing it to something lower will make it occur more often.

-- This function randomizes which part will instantly fall if touched; technically, it can be run more than once, to make it have more instafall platforms
function HexagonHoneyComb.RandomizeInstantFall(hexagons)
	if not hexagons or #hexagons:GetChildren() == 0 then
		error("'hexagon' value must be an instance containing objects.")
	end

	math.randomseed(os.time())
	for _, hexagon in ipairs(hexagons:GetChildren()) do -- ipairs is faster by 0.0000008s so we'll use ipairs
		if math.random(1, chance) == 1 and not hexagon:GetAttribute("InstantFall") then
			hexagon:SetAttribute("InstantFall", true)
			hexagon.Color = Color3.new(0.733333, 0.733333, 0.733333)
		end
	end
end

-- This function adds logic to every part in 'hexagons'
function HexagonHoneyComb.AddLogic(hexagons, onceTouched, connections)
	if not hexagons or #hexagons:GetChildren() == 0 then
		error("'hexagon' value must be an instance containing objects.")
	end
	if not onceTouched and #onceTouched:GetChildren() >= 0 then
		error("'onceTouched' value must be an instance containing NO objects.")
	end
	if not connections and not typeof(connections) == "table" and #connections >= 0 then
		error("'connections' value must be a table containing NO values.")
	end

	for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
		if player.IsInGame.Value == false then
			return
		end
		connections[player] = RunService.Heartbeat:Connect(function()
			if player.IsInGame.Value == false then
				connections[player]:Disconnect()
				connections[player] = nil
			end

			local char = player.Character or player.CharacterAdded:Wait()
			local origin = char:WaitForChild("HumanoidRootPart").CFrame

			local raycastParams = RaycastParams.new()
			raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
			raycastParams.FilterDescendantsInstances = {hexagons}

			-- BodyScale values to adjust to a player's character
			local BodyWidthScale = char.Humanoid.BodyWidthScale.Value
			local BodyHeightScale = char.Humanoid.BodyHeightScale.Value
			local BodyTypeScale = char.Humanoid.BodyTypeScale.Value + 0.75
			local BodyDepthScale = char.Humanoid.BodyDepthScale.Value

			-- Fires a ray to detect if hexagon was hit
			local raycastResults1 = workspace:Raycast(origin.Position + Vector3.new(0, 1 * BodyHeightScale * BodyTypeScale, 0), Vector3.new(0, -4 * BodyHeightScale * BodyTypeScale, 0), raycastParams) -- middle
			local raycastResults2 = workspace:Raycast((origin * CFrame.new(-1.5 * BodyWidthScale, 1 * BodyHeightScale * BodyTypeScale, 0)).Position, Vector3.new(0, -4 * BodyHeightScale * BodyTypeScale, 0), raycastParams) -- left
			local raycastResults3 = workspace:Raycast((origin * CFrame.new(1.5 * BodyWidthScale, 1 * BodyHeightScale * BodyTypeScale, 0)).Position, Vector3.new(0, -4 * BodyHeightScale * BodyTypeScale, 0), raycastParams) -- right
			local raycastResults4 = workspace:Raycast((origin * CFrame.new(0, 1 * BodyHeightScale * BodyTypeScale, 1 * BodyDepthScale)).Position, Vector3.new(0, -4 * BodyHeightScale * BodyTypeScale, 0), raycastParams) -- backwards
			local raycastResults5 = workspace:Raycast((origin * CFrame.new(0, 1 * BodyHeightScale * BodyTypeScale, -1.25 * BodyDepthScale)).Position, Vector3.new(0, -4 * BodyHeightScale * BodyTypeScale, 0), raycastParams) -- forwards

			local result
			if raycastResults1 then
				result = raycastResults1
			elseif raycastResults2 then
				result = raycastResults2
			elseif raycastResults3 then
				result = raycastResults3
			elseif raycastResults4 then
				result = raycastResults4
			elseif raycastResults5 then
				result = raycastResults5
			end

			if result then
				result.Instance.Parent = onceTouched
				if not result.Instance:GetAttribute("InstantFall") then
					local tween = TweenService:Create(result.Instance, TransparencyInfo, TransparencyGoal)
					tween:Play()
					tween.Completed:Wait()
				end
				result.Instance:Destroy()
			end
		end)
	end
end

-- This function cleans up the specified table from connections, preferrably the table used in .AddLogic()
function HexagonHoneyComb.CleanUp(connections)
	if not connections and not typeof(connections) == "table" and #connections >= 0 then
		error("'connections' value must be a table containing more than one value!")
	end

	for player, connection in pairs(connections) do
		if typeof(connection) == "RBXScriptConnection" then
			player.IsInGame.Value = false
		end
	end
end

-- The configurations for this minigame. If this module is used for other purposes, this may be ignored. Needed for RoundSystem.
HexagonHoneyComb.Configurations = {
	-- Empty for now.
}

return HexagonHoneyComb
