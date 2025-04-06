

function love.load()
   

    -- [ LOVE ]
    love.window.setTitle("Re:Load")
    love.graphics.setDefaultFilter("nearest", "nearest")

    req = require "assets/modules/loadModule"
    --Player = require "assets/modules/Player"
    Player = req("assets/modules/Player")
    DialogueMod = req("assets/modules/Dialogue")

    OnUpdateFunctions = {}

    function BindOnUpdate(name, f)
        OnUpdateFunctions[name] = f
    end

    function UnBindOnUpdate(name)
        if OnUpdateFunctions[name] then OnUpdateFunctions[name] = nil end
    end

    fullscreen = false

    boxmod = req("assets/modules/box")
    testbox = boxmod.new()


    ModLoader = require "assets/modules/ModLoader"
    ModLoader:Load()

end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
    end

    if key == "f11" then
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen, "exclusive")
    end




    DialogueMod.keypressed(key, scancode, isrepeat)
 end

function love.update(dt)

    
    Player:Update(dt)
    DialogueMod:update(dt, Player)

   --l love.window.setTitle(tostring(Player.Direction))
    for i, func in pairs(OnUpdateFunctions) do
        func(dt)
    end


    
end

function love.draw()
    testbox:draw()
    Player:Draw()

    DialogueMod:draw()
end