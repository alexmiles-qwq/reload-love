-- dialogue.lua
local Dialogue = {}
Dialogue.__index = Dialogue

function Dialogue.new(data, onEnd)
    local self = setmetatable({}, Dialogue)
    self.data = data
    self.currentIndex = 1
    self.timer = 0
    self.textSpeed = 0.02
    self.charIndex = 0
    self.finished = false
    self.inOptions = false
    self.selectedOption = 1
    self.active = true
    self.sound = love.audio.newSource("assets/sounds/talk.wav", "static")
    self.onEnd = onEnd or function() end
    self.revealY = 20
    self.revealTimer = 1
    return self
end

function Dialogue:update(dt)
    if not self.active then return end

    -- Плавное появление текста
    self.revealTimer = math.max(self.revealTimer - dt * 5, 0)

    if self.inOptions then return end
    self.timer = self.timer + dt

    local line = self.data[self.currentIndex]
    if not line then return end

    while self.timer >= self.textSpeed do
        self.timer = self.timer - self.textSpeed
        self.charIndex = self.charIndex + 1

        if self.charIndex <= #line.text then
            self.sound:stop()
            self.sound:play()
        else
            if line.options then
                self.inOptions = true
            end
            self.finished = true
            break
        end
    end
end

function Dialogue:draw()
    if not self.active then return end
    local line = self.data[self.currentIndex]
    if not line then return end

    -- Диалоговое окно
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 50, 400, 700, 150, 10, 10)

    -- Имя
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(line.name, 60, 410)

    -- Портрет
    if line.portrait then
        love.graphics.draw(line.portrait, 60, 450)
    end

    -- Текст с анимацией появления
    local offsetY = self.revealY * self.revealTimer
    local visibleText = string.sub(line.text, 1, self.charIndex)
    love.graphics.printf(visibleText, 180, 450 - offsetY, 550)

    -- Варианты ответа
    if self.inOptions and line.options then
        for i, option in ipairs(line.options) do
            local y = 510 + i * 25
            if i == self.selectedOption then
                love.graphics.setColor(1, 1, 0)
            else
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.print("> " .. option.text, 180, y)
        end
    end
end

function Dialogue:keypressed(key)
    if not self.active then return end
    local line = self.data[self.currentIndex]
    if not line then return end

    -- Выход из диалога
    if key == "escape" then
        self.active = false
        self.onEnd()
        return
    end

    -- Обработка выбора
    if self.inOptions and line.options then
        if key == "up" then
            self.selectedOption = self.selectedOption - 1
            if self.selectedOption < 1 then
                self.selectedOption = #line.options
            end
        elseif key == "down" then
            self.selectedOption = self.selectedOption + 1
            if self.selectedOption > #line.options then
                self.selectedOption = 1
            end
        elseif key == "return" then
            local chosen = line.options[self.selectedOption]
            if chosen.next then
                self.currentIndex = chosen.next
                self.charIndex = 0
                self.timer = 0
                self.finished = false
                self.inOptions = false
                self.selectedOption = 1
                self.revealTimer = 1
            else
                self.active = false
                self.onEnd()
            end
        end
        return
    end

    -- Переход между репликами
    if key == "return" then
        if not self.finished then
            self.charIndex = #line.text
            self.finished = true
            if line.options then
                self.inOptions = true
            end
        else
            self.currentIndex = self.currentIndex + 1
            if self.currentIndex > #self.data then
                self.active = false
                self.onEnd()
                return
            end
            self.charIndex = 0
            self.timer = 0
            self.finished = false
            self.inOptions = false
            self.selectedOption = 1
            self.revealTimer = 1
        end
    end
end

return Dialogue