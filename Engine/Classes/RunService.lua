local RunService = {}
RunService.__index = RunService

function RunService:new()
    local o = {} 
    setmetatable(o, self) 

    o.Name = "Run Service"  
    return o
end

function RunService:Update(deltaTime)
    for i, object in pairs(workspace) do
        if object.Update and type(object.Update) == "function" then
            object:Update(deltaTime)
        end
    end
end

function RunService:Draw()
    for i, object in pairs(workspace) do
        if object.Draw and type(object.Draw) == "function" then
            object:Draw()
        end
    end
   
end

return RunService