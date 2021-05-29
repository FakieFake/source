--[[
    Made by Fakie aka HammyLammyYT
]]

local HexagonHoneyComb = {}
HexagonHoneyComb.__index = HexagonHoneyComb

local chance = 10 -- Default is 10, meaning theres a 1 in 10 chance a platform will be instafall. Changing this number to something higher will make it occur rarely, while changing it to something higher will make it occur more often.

-- This function randomizes which part will instantly fall if touched.
function HexagonHoneyComb:RandomizeInstantFall()
    math.randomseed(os.time())
    for _, hexagon in pairs(self.hexagons) do
        if math.random(1, chance) == 1 and not hexagon:GetAttrbiute("InstantFall") then
            hexagon:SetAttribute("InstantFall", true)
            hexagon.Color = Color3.new(205, 205, 205)
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
                if hexagon:GetAttribute("InstantFall") then
                    for i = 0, 1, 0.05 do
                        hexagon.Transparency = i
                        wait()
                    end
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
    end
}
