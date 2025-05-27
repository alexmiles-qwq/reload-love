
local push = require("libs.push")
require('Engine.core')

local VERSION = 0.02

local PW, PH = love.window.getDesktopDimensions()
local PW, PH = PW * 0.8, PH * 0.8

local TweenService = game.TweenService


function love.load()
   
   
    love.graphics.setDefaultFilter('nearest','nearest')

    workspace.Player = Instance.new("Player")
    workspace.Player.Position.X = 100
    workspace.Camera:SetSubject(workspace.Player)
--[[
    TestTween = TweenService:Create(workspace.Player, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = {X = 100, Y = 200}})
    TestTween:Play()
]]
    -- [ LOVE ]
    love.window.setTitle("Re:Load ver. "..tostring(VEwRSION))
    love.graphics.setDefaultFilter("nearest", "nearest")
    push:setupScreen(game.VW, game.VH, PW, PH, {fullscreen = false, vsync = true, resizable = true})


end

function love.keypressed(key, scancode, isrepeat)
end

function love.update(dt)
    game:Update(dt)
end

function love.resize(w, h)
    push:resize(w, h)
end


function love.draw()
    push:start()

    workspace.Camera:Apply() 

    game:Draw()               

    workspace.Camera:Draw()   

    workspace.Camera:Unapply()

    push:finish()
end
