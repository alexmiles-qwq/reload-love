local Classes = {}
Classes['Run Service'] = require("Engine.Classes.RunService")
Classes['TweenService'] = require("Engine.Classes.TweenService")
Classes.Event = require("Engine.Classes.Event") 
Classes.Player = require("Engine.Classes.Player")
Classes.Camera = require("Engine.Classes.Camera")

local Instance = {}

function Instance.new(classname, custom)
    local classModule = Classes[classname]
    local self = {}

    if not custom then
        
        if not classModule then 
            error("No class " .. tostring(classname) .. " exist!") 
        end

        if type(classModule.new) ~= "function" then
            error("Class " .. tostring(classname) .. " does not have a 'new' constructor.")
        end

        self  = classModule:new() 
    end


    self.ClassName = self.ClassName or classname
    if not self.Name then 
        self.Name = classname
    end


    local originalSelf = self

    function self:Clone()
        local clone = Instance.new(self.ClassName) 
        
        for k, v in pairs(originalSelf) do
            if type(v) ~= "function" then
                clone[k] = v
            end
        end
        clone.Name = self.Name
        return clone
    end

    function self:Destroy()
        for k in pairs(self) do
            self[k] = nil
        end
        setmetatable(self, nil) 
    end

    function self:IsA(class)
        return self.ClassName == class
    end

    return self
end

return Instance