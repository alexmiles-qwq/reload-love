--[[
TweenService Module for LÖVE 2D
Assumes a global 'Enum' table exists with:
  Enum.EasingStyle = { Linear, Sine, Quad, Cubic, Quart, Quint, Expo, Circ, Back, Elastic, Bounce }
  Enum.EasingDirection = { In, Out, InOut }

Example Usage:

-- main.lua (or similar)
-- Make sure your global Enum is defined before requiring TweenService
-- Enum = {
--    EasingStyle = { Linear = "Linear", Sine = "Sine", -- ... and so on
--    },
--    EasingDirection = { In = "In", Out = "Out", InOut = "InOut" }
-- }

local TweenService = require("TweenService") -- Assuming file is TweenService.lua
local ts = TweenService:new()
ts.Debug = true

local myObject = { x = 50, y = 50, rotation = 0, scale = 1, color = {1, 1, 1, 1} }

function love.load()
    -- Ensure Enum is available globally if not already
    if not Enum then
        print("WARNING: Global Enum not found. TweenService might not work as expected.")
        -- Define a minimal Enum for the example to run if you don't have one yet
        Enum = {
            EasingStyle = { Linear = "Linear", Sine = "Sine", Quad = "Quad", Cubic = "Cubic", Quart = "Quart", Quint = "Quint", Expo = "Expo", Circ = "Circ", Back = "Back", Elastic = "Elastic", Bounce = "Bounce" },
            EasingDirection = { In = "In", Out = "Out", InOut = "InOut" }
        }
    end

    local tweenInfo = {
        Duration = 2,
        EasingStyle = Enum.EasingStyle.Elastic, -- Using global Enum
        EasingDirection = Enum.EasingDirection.Out, -- Using global Enum
        Delay = 0.5,
        RepeatCount = 1,
        Reverses = true
    }
    local properties = {
        x = 400,
        y = 300,
        rotation = math.pi * 2,
        scale = 2,
        color = {0.5, 0.2, 0.8, 0.5}
    }

    local myTween = ts:Create(myObject, tweenInfo, properties)

    myTween.Completed:Connect(function()
        print("Tween completed!")
    end)

    myTween:Play()
end

function love.update(dt)
    ts:Update(dt)
end

function love.draw()
    love.graphics.setColor(myObject.color[1], myObject.color[2], myObject.color[3], myObject.color[4])
    love.graphics.translate(myObject.x, myObject.y)
    love.graphics.rotate(myObject.rotation)
    love.graphics.scale(myObject.scale)
    love.graphics.rectangle("fill", -25, -25, 50, 50)
    love.graphics.origin()

    ts:Draw()
end

--]]

local TweenService = {}
TweenService.__index = TweenService

local activeTweens = {}

-- Lerp function (handles numbers and tables with numeric values)
local function lerp(a, b, t)
    if type(a) == "number" and type(b) == "number" then
        return a + (b - a) * t
    elseif type(a) == "table" and type(b) == "table" then
        local result = {}
        for k, vA in pairs(a) do
            local vB = b[k]
            if type(vA) == "number" and type(vB) == "number" then
                result[k] = vA + (vB - vA) * t
            else
                result[k] = t < 0.5 and vA or vB
            end
        end
        return result
    else
        return t < 0.5 and a or b
    end
end

-- Easing functions
-- Assumes global Enum.EasingStyle and Enum.EasingDirection are defined
local EasingFunctions = {}
do
    -- Assert that the required Enums exist
    assert(Enum and Enum.EasingStyle and Enum.EasingDirection,
           "TweenService requires a global 'Enum' table with 'EasingStyle' and 'EasingDirection'.")

    local pi = math.pi
    local cos = math.cos
    local sin = math.sin
    local pow = math.pow
    local sqrt = math.sqrt
    local abs = math.abs
    local c1 = 1.70158
    local c2 = c1 * 1.525
    local c3 = c1 + 1
    local c4 = (2 * pi) / 3
    local c5 = (2 * pi) / 4.5
    local n1 = 7.5625
    local d1 = 2.75

    EasingFunctions[Enum.EasingStyle.Linear] = {
        [Enum.EasingDirection.In]    = function(t) return t end,
        [Enum.EasingDirection.Out]   = function(t) return t end,
        [Enum.EasingDirection.InOut] = function(t) return t end,
    }
    EasingFunctions[Enum.EasingStyle.Sine] = {
        [Enum.EasingDirection.In]    = function(t) return 1 - cos((t * pi) / 2) end,
        [Enum.EasingDirection.Out]   = function(t) return sin((t * pi) / 2) end,
        [Enum.EasingDirection.InOut] = function(t) return -(cos(pi * t) - 1) / 2 end,
    }
    EasingFunctions[Enum.EasingStyle.Quad] = {
        [Enum.EasingDirection.In]    = function(t) return t * t end,
        [Enum.EasingDirection.Out]   = function(t) return 1 - (1 - t) * (1 - t) end,
        [Enum.EasingDirection.InOut] = function(t) return t < 0.5 and 2 * t * t or 1 - pow(-2 * t + 2, 2) / 2 end,
    }
    EasingFunctions[Enum.EasingStyle.Cubic] = {
        [Enum.EasingDirection.In]    = function(t) return t * t * t end,
        [Enum.EasingDirection.Out]   = function(t) return 1 - pow(1 - t, 3) end,
        [Enum.EasingDirection.InOut] = function(t) return t < 0.5 and 4 * t * t * t or 1 - pow(-2 * t + 2, 3) / 2 end,
    }
    EasingFunctions[Enum.EasingStyle.Quart] = {
        [Enum.EasingDirection.In]    = function(t) return t * t * t * t end,
        [Enum.EasingDirection.Out]   = function(t) return 1 - pow(1 - t, 4) end,
        [Enum.EasingDirection.InOut] = function(t) return t < 0.5 and 8 * t * t * t * t or 1 - pow(-2 * t + 2, 4) / 2 end,
    }
    EasingFunctions[Enum.EasingStyle.Quint] = {
        [Enum.EasingDirection.In]    = function(t) return t * t * t * t * t end,
        [Enum.EasingDirection.Out]   = function(t) return 1 - pow(1 - t, 5) end,
        [Enum.EasingDirection.InOut] = function(t) return t < 0.5 and 16 * t * t * t * t * t or 1 - pow(-2 * t + 2, 5) / 2 end,
    }
    EasingFunctions[Enum.EasingStyle.Expo] = {
        [Enum.EasingDirection.In]    = function(t) return t == 0 and 0 or pow(2, 10 * t - 10) end,
        [Enum.EasingDirection.Out]   = function(t) return t == 1 and 1 or 1 - pow(2, -10 * t) end,
        [Enum.EasingDirection.InOut] = function(t)
            return t == 0 and 0 or t == 1 and 1 or t < 0.5 and pow(2, 20 * t - 10) / 2 or (2 - pow(2, -20 * t + 10)) / 2
        end,
    }
    EasingFunctions[Enum.EasingStyle.Circ] = {
        [Enum.EasingDirection.In]    = function(t) return 1 - sqrt(1 - pow(t, 2)) end,
        [Enum.EasingDirection.Out]   = function(t) return sqrt(1 - pow(t - 1, 2)) end,
        [Enum.EasingDirection.InOut] = function(t)
            return t < 0.5 and (1 - sqrt(1 - pow(2 * t, 2))) / 2 or (sqrt(1 - pow(-2 * t + 2, 2)) + 1) / 2
        end,
    }
    EasingFunctions[Enum.EasingStyle.Back] = {
        [Enum.EasingDirection.In]    = function(t) return c3 * t * t * t - c1 * t * t end,
        [Enum.EasingDirection.Out]   = function(t) return 1 + c3 * pow(t - 1, 3) + c1 * pow(t - 1, 2) end,
        [Enum.EasingDirection.InOut] = function(t)
            return t < 0.5 and (pow(2 * t, 2) * ((c2 + 1) * 2 * t - c2)) / 2 or (pow(2 * t - 2, 2) * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2
        end,
    }
    EasingFunctions[Enum.EasingStyle.Elastic] = {
        [Enum.EasingDirection.In] = function(t)
            return t == 0 and 0 or t == 1 and 1 or -pow(2, 10 * t - 10) * sin((t * 10 - 10.75) * c4)
        end,
        [Enum.EasingDirection.Out] = function(t)
            return t == 0 and 0 or t == 1 and 1 or pow(2, -10 * t) * sin((t * 10 - 0.75) * c4) + 1
        end,
        [Enum.EasingDirection.InOut] = function(t)
            return t == 0 and 0 or t == 1 and 1 or t < 0.5 and -(pow(2, 20 * t - 10) * sin((20 * t - 11.125) * c5)) / 2 or (pow(2, -20 * t + 10) * sin((20 * t - 11.125) * c5)) / 2 + 1
        end,
    }
    EasingFunctions[Enum.EasingStyle.Bounce] = {
        [Enum.EasingDirection.In] = function(t) return 1 - EasingFunctions[Enum.EasingStyle.Bounce][Enum.EasingDirection.Out](1 - t) end,
        [Enum.EasingDirection.Out] = function(t)
            if t < 1 / d1 then return n1 * t * t
            elseif t < 2 / d1 then t = t - (1.5 / d1); return n1 * t * t + 0.75
            elseif t < 2.5 / d1 then t = t - (2.25 / d1); return n1 * t * t + 0.9375
            else t = t - (2.625 / d1); return n1 * t * t + 0.984375
            end
        end,
        [Enum.EasingDirection.InOut] = function(t)
            return t < 0.5 and (1 - EasingFunctions[Enum.EasingStyle.Bounce][Enum.EasingDirection.Out](1 - 2 * t)) / 2 or (1 + EasingFunctions[Enum.EasingStyle.Bounce][Enum.EasingDirection.Out](2 * t - 1)) / 2
        end,
    }
end

local function ease(t, style, direction)
    -- Ensure Enum references are valid before trying to use them
    if not (Enum and Enum.EasingStyle and Enum.EasingDirection and
            Enum.EasingStyle[tostring(style)] and Enum.EasingDirection[tostring(direction)]) then
        -- Fallback to Linear if global Enum or specific style/direction is missing
        if style ~= "Linear" and style ~= Enum.EasingStyle.Linear then -- Avoid infinite recursion if Linear itself is missing
             print("Warning: Easing style '"..tostring(style).."' or direction '"..tostring(direction).."' not found in global Enum. Falling back to Linear.")
        end
        return t
    end

    local styleSet = EasingFunctions[style]
    if styleSet then
        local easeFunc = styleSet[direction]
        if easeFunc then
            return easeFunc(t)
        end
    end
    -- Fallback to Linear if not found in EasingFunctions (shouldn't happen if Enum keys match)
    return t
end

-- Tween object metatable
local Tween = {}
Tween.__index = Tween

function Tween:Play()
    if self._isPaused then
        self._isPaused = false
    else
        self._time = 0
        self._delayLeft = self._initialDelay
        self._iteration = 0
        self._isCompleted = false
        self._isCancelled = false
        self._isCurrentlyReversed = false

        for p, val in pairs(self._originalStartValues) do
            self._start[p] = val
        end
        for p, val in pairs(self._initialTargetProperties) do
            self._properties[p] = val
        end
    end

    local alreadyActive = false
    for _, activeTween in ipairs(activeTweens) do
        if activeTween == self then
            alreadyActive = true
            break
        end
    end
    if not alreadyActive then
        table.insert(activeTweens, self)
    end
    return self
end

function Tween:Pause()
    self._isPaused = true
    return self
end

function Tween:Resume()
    if self._isPaused then
        self._isPaused = false
        local alreadyActive = false
        for _, activeTween in ipairs(activeTweens) do
            if activeTween == self then
                alreadyActive = true
                break
            end
        end
        if not alreadyActive then
            table.insert(activeTweens, self)
        end
    end
    return self
end

function Tween:Cancel()
    self._isCancelled = true
    self:_removeFromActive()
    return self
end

function Tween:Destroy()
    self:_removeFromActive()
    return self
end

function Tween:_removeFromActive()
    for i = #activeTweens, 1, -1 do
        if activeTweens[i] == self then
            table.remove(activeTweens, i)
            break
        end
    end
end

-- TweenService methods
function TweenService:new()
    local o = {}
    setmetatable(o, self)
    o.Debug = false
    return o
end

function TweenService:Update(deltaTime)
    for i = #activeTweens, 1, -1 do
        local tween = activeTweens[i]

        if tween._isPaused or tween._isCancelled or tween._isCompleted then
            goto continue_loop
        end

        if tween._delayLeft > 0 then
            local consume = math.min(deltaTime, tween._delayLeft)
            tween._delayLeft = tween._delayLeft - consume
            if tween._delayLeft > 0 or deltaTime - consume <= 0.00001 then
                 goto continue_loop
            end
            deltaTime = deltaTime - consume
        end

        tween._time = tween._time + deltaTime
        local alpha = 0
        if tween._duration > 0 then
            alpha = math.min(tween._time / tween._duration, 1)
        else
            alpha = 1
        end

        local easedAlpha = ease(alpha, tween._style, tween._direction)

        for property, goal in pairs(tween._properties) do
            local startValue = tween._start[property]
            tween._target[property] = lerp(startValue, goal, easedAlpha)
        end

        if alpha >= 1 then
            if tween._repeatCount == -1 or tween._iteration < tween._repeatCount then
                tween._iteration = tween._iteration + 1
                tween._time = 0
                tween._delayLeft = 0

                if tween._reverses then
                    tween._isCurrentlyReversed = not tween._isCurrentlyReversed
                    if tween._isCurrentlyReversed then
                        for p, _ in pairs(tween._originalStartValues) do
                            tween._start[p] = tween._initialTargetProperties[p]
                            tween._properties[p] = tween._originalStartValues[p]
                        end
                    else
                        for p, _ in pairs(tween._originalStartValues) do
                            tween._start[p] = tween._originalStartValues[p]
                            tween._properties[p] = tween._initialTargetProperties[p]
                        end
                    end
                else
                    for p, val in pairs(tween._originalStartValues) do
                        tween._start[p] = val
                    end
                    for p, val in pairs(tween._initialTargetProperties) do
                        tween._properties[p] = val
                    end
                end
            else
                tween._isCompleted = true
                if not tween._isCancelled then
                    for _, cb in ipairs(tween._completedCallbacks) do
                        xpcall(cb, function(err)
                            print("Error in Tween.Completed callback: " .. tostring(err))
                            print(debug.traceback())
                        end)
                    end
                end
                tween:_removeFromActive()
            end
        end
        ::continue_loop::
    end
end

function TweenService:Draw()
    if not self.Debug then return end
    love.graphics.push("all")
    love.graphics.setColor(0, 1, 0, 0.7)
    local yPos = 10
    love.graphics.print("Active Tweens: " .. #activeTweens, 10, yPos)
    yPos = yPos + 15

    for i, tween in ipairs(activeTweens) do
        local progress = 0
        if tween._duration > 0 then
            progress = math.floor(tween._time / tween._duration * 100)
        elseif tween._time > 0 then
            progress = 100
        end
        
        local status = ""
        if tween._isPaused then status = " (Paused)"
        elseif tween._isCancelled then status = " (Cancelled)"
        elseif tween._isCompleted and tween._repeatCount ~= -1 then status = " (Completed)"
        elseif tween._delayLeft > 0 then status = " (Delaying)"
        end

        local targetName = "obj"
        if tween._target and tween._target.name then targetName = tostring(tween._target.name) end

        local text = string.format("[%d] %s %s: %d%% | Time:%.2f/%.2f | Delay:%.2f | Iter:%d/%s | Style:%s %s %s",
            i, targetName, status, progress,
            tween._time, tween._duration, tween._delayLeft,
            tween._iteration, tostring(tween._repeatCount),
            tostring(tween._style), tostring(tween._direction),
            (tween._reverses and (tween._isCurrentlyReversed and "(Rev)" or "(Fwd)")) or ""
        )
        love.graphics.print(text, 10, yPos)
        yPos = yPos + 15
    end
    love.graphics.pop()
end

function TweenService:Create(instance, tweenInfo, propertyTable)
    -- Ensure global Enum is available for defaults
    assert(Enum and Enum.EasingStyle and Enum.EasingDirection,
           "TweenService:Create requires a global 'Enum' table with 'EasingStyle' and 'EasingDirection' for default values.")

    local tweenInstance = {
        _target = instance,
        _duration = tweenInfo.Duration or 1,
        _style = tweenInfo.EasingStyle or Enum.EasingStyle.Linear, 
        _direction = tweenInfo.EasingDirection or Enum.EasingDirection.In,
        _initialDelay = tweenInfo.Delay or 0,
        _repeatCount = tweenInfo.RepeatCount or 0,
        _reverses = tweenInfo.Reverses or false,

        _properties = {},
        _start = {},

        _originalStartValues = {},
        _initialTargetProperties = {},

        _time = 0,
        _delayLeft = tweenInfo.Delay or 0,
        _iteration = 0,
        _isCurrentlyReversed = false,

        _isPaused = false,
        _isCompleted = false,
        _isCancelled = false,

        _completedCallbacks = {},
        Completed = {},
    }
    setmetatable(tweenInstance, Tween)

    -- Store original start values from the instance
    for propertyKey, _ in pairs(propertyTable) do -- Iterate to get keys of properties to tween
        local currentInstanceValue = instance[propertyKey] -- Cache the accessed property value

        if currentInstanceValue == nil then
            -- Updated error message for more clarity
            error("TweenService:Create - Property '" .. tostring(propertyKey) .. "' is nil on the target instance. Cannot tween a nil property.", 2)
        end

        if type(currentInstanceValue) == "table" then
            tweenInstance._originalStartValues[propertyKey] = {}
            -- Use the cached 'currentInstanceValue' for pairs
            for k, v in pairs(currentInstanceValue) do 
                tweenInstance._originalStartValues[propertyKey][k] = v
            end
        else
            tweenInstance._originalStartValues[propertyKey] = currentInstanceValue
        end
    end

    -- Store initial target properties (deep copy tables)
    for propertyKey, goalValue in pairs(propertyTable) do
        if type(goalValue) == "table" then
            tweenInstance._initialTargetProperties[propertyKey] = {}
            for k, v in pairs(goalValue) do
                tweenInstance._initialTargetProperties[propertyKey][k] = v
            end
        else
            tweenInstance._initialTargetProperties[propertyKey] = goalValue
        end
    end

    -- Initialize current _start and _properties (for the first play, which is forwards)
    -- These loops use the already processed _originalStartValues and _initialTargetProperties,
    -- which are plain tables, so they should be fine.
    for p, val in pairs(tweenInstance._originalStartValues) do
        if type(val) == "table" then 
             tweenInstance._start[p] = {}
             for k, v_inner in pairs(val) do tweenInstance._start[p][k] = v_inner end
        else
            tweenInstance._start[p] = val
        end
    end
    for p, val in pairs(tweenInstance._initialTargetProperties) do
         if type(val) == "table" then
             tweenInstance._properties[p] = {}
             for k, v_inner in pairs(val) do tweenInstance._properties[p][k] = v_inner end
        else
            tweenInstance._properties[p] = val
        end
    end

    function tweenInstance.Completed:Connect(callback)
        if type(callback) ~= "function" then
            error("Tween.Completed:Connect expects a function.", 2)
            return
        end
        table.insert(tweenInstance._completedCallbacks, callback)
        
        local connection = {}
        function connection:Disconnect()
            for i, cb in ipairs(tweenInstance._completedCallbacks) do
                if cb == callback then
                    table.remove(tweenInstance._completedCallbacks, i)
                    break
                end
            end
        end
        return connection
    end

    return tweenInstance
end

return TweenService