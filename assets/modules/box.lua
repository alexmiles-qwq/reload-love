local box = {}
box.__index = box

box.Texture = love.graphics.newImage("assets/box.png")

box.Position = {}

box.Position.X = 0
box.Position.Y = 0

function box:update()

end

function box:draw()
    love.graphics.draw(self.Texture,self.Position.X,self.Position.Y)
end



function box.new()
    local self = {}
    setmetatable(self, box)

    return self
end

return box