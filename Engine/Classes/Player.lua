-- [ Modules ]
local utils = require("assets.modules.utils")
local anim8 = require("libs.anim8")

local Player = {}
Player.__index = Player

function Player:new()
    local o = {} 
    setmetatable(o, self) 

    o.WalkSpeed = 125
    o.Direction = "Down" -- Up Left Right
    o.Scale = 2

    o.CanMoving = true
    o.Debug = true

    o.Position = {X = 0, Y = 0} 

    o.Sheets = {
        WalkUp = love.graphics.newImage("assets/Zenn-Up.png"),
        WalkDown = love.graphics.newImage("assets/Zenn-Down.png"),
        WalkLeft = love.graphics.newImage("assets/Zenn-Left.png"),
        WalkRight = love.graphics.newImage("assets/Zenn-Right.png"),
    }

    o.Grids = {
        WalkUp = anim8.newGrid(36, 83, o.Sheets.WalkUp:getWidth(), o.Sheets.WalkUp:getHeight()),
        WalkDown = anim8.newGrid(36, 82, o.Sheets.WalkDown:getWidth(), o.Sheets.WalkDown:getHeight()),
        WalkLeft = anim8.newGrid(32, 80, o.Sheets.WalkLeft:getWidth(), o.Sheets.WalkLeft:getHeight()),
        WalkRight = anim8.newGrid(32, 80, o.Sheets.WalkRight:getWidth(), o.Sheets.WalkRight:getHeight()),
    }

    o.AnimationSpeed = 0.25
    o.Animations = {
        WalkUp = anim8.newAnimation(o.Grids.WalkUp('1-4', 1), o.AnimationSpeed),
        WalkDown = anim8.newAnimation(o.Grids.WalkDown('1-4', 1), o.AnimationSpeed),
        WalkLeft = anim8.newAnimation(o.Grids.WalkLeft('1-4', 1), o.AnimationSpeed),
        WalkRight = anim8.newAnimation(o.Grids.WalkRight('1-4', 1), o.AnimationSpeed),
    }

    o.CurrentAnimation = o.Animations.WalkDown

    o.CanRun = true
    o.Running = false

    return o
end

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
    if not utils.FindValueInTable(avaliableTable, dir) then 
        error("Player's direction cannot be '" .. tostring(dir) .. "'.") 
    end
    self.Direction = dir
    self.CurrentAnimation = self.Animations["Walk" .. dir] 
end

function Player:Update(dt)

    local X = self.Position.X
    local Y = self.Position.Y

    local isMoving = false

    if (love.keyboard.isDown("left") and love.keyboard.isDown("right")) or 
       (love.keyboard.isDown("up") and love.keyboard.isDown("down")) then 
      
       self.CurrentAnimation:gotoFrame(1) 
       return 
    end

    if self.CanMoving then
        if love.keyboard.isDown("lshift") and self.CanRun then
            self.WalkSpeed = 275
            self.AnimationSpeed = 1 * 1.5
        else
            self.WalkSpeed = 125
            self.AnimationSpeed = 1
        end

        if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
            X = X - 1 * self.WalkSpeed * dt
            self:SetDirection("Left")
            isMoving = true
        end

        if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            X = X + 1 * self.WalkSpeed * dt
            self:SetDirection("Right")
            isMoving = true
        end

        if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
            Y = Y - 1 * self.WalkSpeed * dt
            self:SetDirection("Up")
            isMoving = true
        end

        if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
            Y = Y + 1 * self.WalkSpeed * dt
            self:SetDirection("Down")
            isMoving = true
        end
    end

    self:SetPosition(X, Y)


    if isMoving then
        self.CurrentAnimation:update(dt * self.AnimationSpeed)
    else
        self.CurrentAnimation:gotoFrame(1)
    end
end

function Player:Draw()
    local Texture


    if self.Direction == "Up" then
        Texture = self.Sheets.WalkUp
    elseif self.Direction == "Down" then
        Texture = self.Sheets.WalkDown
    elseif self.Direction == "Left" then
        Texture = self.Sheets.WalkLeft
    elseif self.Direction == "Right" then
        Texture = self.Sheets.WalkRight
    end

   
    local frameW = self.CurrentAnimation:getDimensions()
    local ox = frameW / 2
    local oy = frameW / 2

    self.CurrentAnimation:draw(Texture, self.Position.X, self.Position.Y, 0, self.Scale, self.Scale, ox, oy)

    if self.Debug then
        love.graphics.print(
            "Direction = ".. tostring(self.Direction) .. 
            " | AnimationSpeed = " .. tostring(self.AnimationSpeed) .. 
            " | Position = " .. math.floor(self.Position.X) .. ", " .. math.floor(self.Position.Y),
            10, 10
        )
    end
end


return Player