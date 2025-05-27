-- I love roblox coding style, so i just recreating roblox apis here LMAOOOOOO

local game = {}

game.VW = 800    
game.VH = 600

_G.Enum = require("Engine.Enum")
_G.Instance = require("Engine.Instance")
_G.TweenInfo = require("Engine.TweenInfo")






game['Run Service'] = Instance.new("Run Service")
game['TweenService'] = Instance.new("TweenService")

function game:GetService(servicename)
    if game[servicename] and game[servicename].ClassName == "Service" then
        return game[servicename]
    else
        error(tostring(servicename) .. " Does not exist or its not a service.")
    end
end

_G.game = game

_G.game.Workspace = {}
_G.workspace = _G.game.Workspace

workspace.Camera = Instance.new("Camera")



function game:Update(dt)
     game['TweenService']:Update(dt)
    game['Run Service']:Update(dt)
end

function game:Draw()
     game['TweenService']:Draw()
    game['Run Service']:Draw()
end
