--[[
    MADE BY FAKIE (ALSO KNOWN AS HAMMYLAMMYYT ON ROBLOX)
]]

local TweenService = game:GetService("TweenService") -- Tweening is faster than using a loop with wait()
local TransparencyInfo = TweenInfo.new(0.75, Enum.EasingStyle.Linear)
local TweenGoal = {Transparency = 1}

local HexagonHoneyComb = {}
HexagonHoneyComb.__index = HexagonHoneyComb

local chance = 15 -- Default is 15, meaning theres a 1 in 15 chance a platform will be instafall. Changing this number to something higher will make it occur rarely, while changing it to something lower will make it occur more often.

-- This function randomizes which part will instantly fall if touched. Technically, it can be run more than once, to make it have more instafall platforms.
function HexagonHoneyComb:RandomizeInstantFall()
	math.randomseed(os.time())
	for _, hexagon in pairs(self.hexagons) do
		if math.random(1, chance) == 1 and not hexagon:GetAttribute("InstantFall") then
			hexagon:SetAttribute("InstantFall", true)
			hexagon.Color = Color3.new(0.733333, 0.733333, 0.733333)
		end
	end
end

-- This function adds logic to every part in self.hexagons.
function HexagonHoneyComb:AddLogic()
	local connections = {}
	for _, hexagon in pairs(self.hexagons) do
		connections[hexagon] = hexagon.Touched:Connect(function(hit)
			if hit.Parent:FindFirstChildOfClass("Humanoid") then
				connections[hexagon]:Disconnect()
				if not hexagon:GetAttribute("InstantFall") then
					local tween = TweenService:Create(hexagon, TransparencyInfo, TweenGoal)
					tween:Play()
					tween.Completed:Wait()
				end
				hexagon:Destroy() -- Usually, you won't ever need the part again, so removing it from workspace is the best
			end
		end)
	end
end

return {
	new = function(hexagons)
		if not hexagons then
			error("Parameter 'hexagons' must be specified when using HexagonHoneyComb.new(). Usually, this is gonna be the Hexagons inside the folder.")
		end
		local newHexagonHoneyComb = setmetatable({}, HexagonHoneyComb)
		newHexagonHoneyComb.hexagons = hexagons
		return newHexagonHoneyComb
	end,
	configurations = { -- You can change this. The MainRoundSystem script will get the game name, round length, etc. from this "configurations" table.
		-- Empty for now
	}
}
