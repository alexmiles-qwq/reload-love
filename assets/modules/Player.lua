local utils = require "assets/modules/utils"
local anim8 = require "assets/modules/anim8/anim8"

local Player = {}
Player.WalkSpeed = 100
Player.Direction = "Down" -- Up Left Right
Player.Scale = 3

Player.Debug = true

Player.Position = {}
Player.Position.X = 0
Player.Position.Y = 0

Player.Sheets = {}
Player.Sheets.WalkUp = love.graphics.newImage("assets/Zenn-Up.png")         -- Size of frame = 36x83
Player.Sheets.WalkDown = love.graphics.newImage("assets/Zenn-Down.png")     -- Size of frame = 36x82
Player.Sheets.WalkLeft = love.graphics.newImage("assets/Zenn-Left.png")     -- Size of frame = 32x80
Player.Sheets.WalkRight = love.graphics.newImage("assets/Zenn-Right.png")   -- Size of frame = 32x80

Player.Grids = {
    WalkUp = anim8.newGrid(36, 83, Player.Sheets.WalkUp:getWidth(), Player.Sheets.WalkUp:getHeight()),
    WalkDown = anim8.newGrid(36, 82, Player.Sheets.WalkDown:getWidth(), Player.Sheets.WalkDown:getHeight()),
    WalkLeft = anim8.newGrid(32, 80, Player.Sheets.WalkLeft:getWidth(), Player.Sheets.WalkLeft:getHeight()),
    WalkRight = anim8.newGrid(32, 80, Player.Sheets.WalkRight:getWidth(), Player.Sheets.WalkRight:getHeight()),
}   

Player.AnimationSpeed = 0.25

Player.Animations = {
    WalkUp = anim8.newAnimation(Player.Grids.WalkUp('1-4', 1), Player.AnimationSpeed or 0.15),
    WalkDown = anim8.newAnimation(Player.Grids.WalkDown('1-4', 1), Player.AnimationSpeed or 0.15),
    WalkLeft = anim8.newAnimation(Player.Grids.WalkLeft('1-4', 1), Player.AnimationSpeed or 0.15),
    WalkRight = anim8.newAnimation(Player.Grids.WalkRight('1-4', 1), Player.AnimationSpeed or 0.15),
}

Player.CurrentAnimation = Player.Animations.WalkDown


function Player:SetPosition(XV, YV)
    self.Position.X = XV
    self.Position.Y = YV
end

function Player:SetSpeed(speedv)
    if speedv < 0 then return end

    self.WalkSpeed = speedv
end

function Player:SetDirection(dir)
    local avaliableTable = {"Up", "Down", "Left", "Right"}
    if not utils.FindValueInTable(avaliableTable, dir) then error("Player's direction cannot be '" .. tostring(dir) .. "'." ) end

    self.Direction = dir
end




function Player:Update(dt)
    local X = Player.Position.X
    local Y = Player.Position.Y
    
    local isMoving = false
    

    if love.keyboard.isDown("left") and love.keyboard.isDown("right") or love.keyboard.isDown("up") and love.keyboard.isDown("down") then return end



    -- Walk left and right

    if love.keyboard.isDown("left") then
        X = X - 1 * self.WalkSpeed * dt
        Player:SetDirection("Left")
        isMoving = true
    end

    if love.keyboard.isDown("right") then
        X = X + 1 * self.WalkSpeed * dt
        Player:SetDirection("Right")
        isMoving = true
    end

    -- Walk up and down

    if love.keyboard.isDown("up") then
        Y = Y - 1 * self.WalkSpeed * dt 
        Player:SetDirection("Up")
        isMoving = true
    end

    if love.keyboard.isDown("down") then
        Y = Y + 1 * self.WalkSpeed * dt
        Player:SetDirection("Down")
        isMoving = true
    end

    Player:SetPosition(X, Y)

    Player.CurrentAnimation:update(dt)

    if not isMoving then
        Player.CurrentAnimation:gotoFrame(1)
    end
end

function Player:Draw()
    --love.graphics.circle("fill",Player.Position.X,Player.Position.Y,100)

    local Texture

    if self.Direction == "Up" then
        Texture = Player.Sheets.WalkUp
    elseif self.Direction == "Down" then
        Texture = Player.Sheets.WalkDown
    elseif self.Direction == "Left" then
        Texture = Player.Sheets.WalkLeft
    elseif self.Direction == "Right" then
        Texture = Player.Sheets.WalkRight
    end

    self.CurrentAnimation:draw(Texture, self.Position.X, self.Position.Y, nil, self.Scale, self.Scale)

    if self.Debug then
        love.graphics.print("Direction = ".. tostring(self.Direction))
    end

    
end

return Player