local Camera = {}
Camera.__index = Camera

function Camera:new()
    local o = setmetatable({}, Camera)
    o.Debug = true
    o.CameraType = "Following" -- "Following", "Custom"
    o.CameraSubject = nil

    o.Position = {X = 0, Y = 0}
    o.Zoom = 1.0
    o.OffsetX = 0
    o.OffsetY = 0

    return o
end

function Camera:SetSubject(subject)
    if subject and type(subject) == "table" and type(subject.Position) == "table" then
        self.CameraSubject = subject
        self.Position.X = subject.Position.X + self.OffsetX
        self.Position.Y = subject.Position.Y + self.OffsetY
    else
        error("Camera:SetSubject - Provided subject does not have a valid 'Position' property.")
        self.CameraSubject = nil
    end
end

function Camera:Update(deltaTime)
    if self.CameraType == Enum.CameraType.Following and self.CameraSubject then
        local vw, vh = game.VW, game.VH -- виртуальный размер, указанный при push:setupScreen()
        


        self.Position.X = self.CameraSubject.Position.X - vw / 2 + self.OffsetX
        self.Position.Y = self.CameraSubject.Position.Y - vh / 2 + self.OffsetY
    end
end

function Camera:Apply()
    love.graphics.push()
    love.graphics.scale(self.Zoom)
    love.graphics.translate(-self.Position.X, -self.Position.Y)
end


function Camera:Unapply()
    love.graphics.pop()
end

function Camera:Draw()
    if self.Debug then
        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.circle("fill", self.Position.X, self.Position.Y, 5)
        love.graphics.print("Cam Pos: (" .. math.floor(self.Position.X) .. ", " .. math.floor(self.Position.Y) .. ")",
            self.Position.X + 10, self.Position.Y + 10)

        if self.CameraSubject and self.CameraSubject.Position then
            love.graphics.setColor(0, 0, 1, 0.5)
            love.graphics.circle("fill", self.CameraSubject.Position.X, self.CameraSubject.Position.Y, 5)
            love.graphics.print("Sub Pos: (" .. math.floor(self.CameraSubject.Position.X) .. ", " .. math.floor(self.CameraSubject.Position.Y) .. ")",
                self.CameraSubject.Position.X + 10, self.CameraSubject.Position.Y + 20)
        end

        love.graphics.setColor(1, 1, 1, 1)
    end
end

return Camera
