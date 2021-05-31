--[[
Script made by Certified_Rice
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ChatService = require(ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))
local Players = game:GetService("Players")
local dev = {"Certified_Rice", "1232coolboy1232", "awesomefireddude134", "HammyLammyYT", "ExploadingCreeps", "VenoBlade"}

ChatService.SpeakerAdded:Connect(
    function(PlrName)
        local Speaker = ChatService:GetSpeaker(PlrName)
        for _, v in pairs(dev) do
            if Players[PlrName].Name == v then
                Speaker:SetExtraData("Tags", {{TagText = "🔨Developer", TagColor = Color3.fromRGB(85, 255, 255)}})
            end
        end
    end
)