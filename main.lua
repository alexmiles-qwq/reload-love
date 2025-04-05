

function love.load()
   

    -- [ LOVE ]
    love.window.setTitle("Re:Load")
    love.graphics.setDefaultFilter("nearest", "nearest")

    req = require "assets/modules/loadModule"
    --Player = require "assets/modules/Player"
    Player = req("assets/modules/Player")

    OnUpdateFunctions = {}

    function BindOnUpdate(name, f)
        OnUpdateFunctions[name] = f
    end

    function UnBindOnUpdate(name)
        if OnUpdateFunctions[name] then OnUpdateFunctions[name] = nil end
    end

    ModLoader = require "assets/modules/ModLoader"
    ModLoader:Load()

end

function love.update(dt)

    
    Player:Update(dt)
   --l love.window.setTitle(tostring(Player.Direction))

    for i, func in pairs(OnUpdateFunctions) do
        func(dt)
    end
    
end

function love.draw()
    Player:Draw()
end