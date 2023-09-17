

function love.load()
    state = {menu=true, playing=false}
    wf = require "Libraries/windfield"
    camera  = require "Libraries/camera"
    sti = require 'Libraries/sti'
    --gameMap = sti('map/testmap.lua')
    --gameMap:init('map/testmap.lua', '', -5, 0)
    cam = camera()
    --menu = wf.newWorld(0, 1000)
    if love.filesystem.getInfo('savefile') ~= nil then
        contents, size = love.filesystem.read( 'savefile', 1 )
        unlockedlvls = tonumber(contents)
        level = 'map/level1.lua'
    else 
        unlockedlvls = 0
        level = 'map/level1.lua'
        file = love.filesystem.newFile('savefile')
        success, message = love.filesystem.write( 'savefile', unlockedlvls, 1 )
    end
    loadworld()
    floor_detect = 0
    --deathobj = world:newBSGRectangleCollider(0, 180, 100, 50, 30)
    --wallL = world:newRectangleCollider(-10, -1000, 10, 1600)
    --wallR = world:newRectangleCollider(800, -1000, 10, 1600)
    --platformtop0 = world:newRectangleCollider(0, 230, 600, 5)
    --platformbottom0 = world:newRectangleCollider(0, 235, 600, 5)
    --platforml0 = world:newRectangleCollider(-5, 230, 5, 10)
    --platformr0 = world:newRectangleCollider(600, 230, 5, 10)
    --platformtop1 = world:newRectangleCollider(310, -55, 490, 5)
    --platformbottom1 = world:newRectangleCollider(310, -50, 490, 5)
    --platforml1 = world:newRectangleCollider(305, -55, 5, 10)
    --platformr1 = world:newRectangleCollider(800, -55, 5, 10)
    --wallR:setType('static')
    --wallL:setType('static')
    --platformtop0:setType('static')
    --platformbottom0:setType('static')
    --platforml0:setType('static')
    --platformr0:setType('static')
    --platformtop1:setType('static')
    --platformbottom1:setType('static')
    --platforml1:setT ype('static')
    --platformr1:setType('static')
    --spikes:setType('static')
    --wallL:setCollisionClass('LWall')
    --wallR:setCollisionClass('RWall')
    --platformr0:setCollisionClass('LWall')
    --platforml0:setCollisionClass('RWall')
    --platformtop0:setCollisionClass('Floor')
    --platformr1:setCollisionClass('LWall')
    --platformbottom0:setCollisionClass('PlatformB')
    --platforml1:setCollisionClass('RWall')
    --platformtop1:setCollisionClass('Floor')
    --platformbottom1:setCollisionClass('PlatformB')
    --spikes:setCollisionClass('DeathObjects')


end
function unloadworld()
    world:destroy()
    if love.filesystem.getInfo('savefile') ~= nil then
        contents, size = love.filesystem.read( 'savefile', 1 )
        unlockedlvls = tonumber(contents)
    end
end
function loadworld()
    gameMap = sti(level)
    world = wf.newWorld(0, 1000)
    world:addCollisionClass('Floor')
    world:addCollisionClass('PlatformB')
    world:addCollisionClass('LWall')
    world:addCollisionClass('RWall')
    world:addCollisionClass('DeathObjects')
    world:addCollisionClass('WinObjects')
    player = {}
    player.dead = 0
    player.x = 5
    player.y = 500
    player.speed = 100
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 50, 100, 15)
    player.collider:setFixedRotation(true)
    platformtops = {}
    if gameMap.layers["PlatformTop"] then
        for i, obj in pairs(gameMap.layers["PlatformTop"].objects) do
            local ox, oy = 0;
            ox = obj.x + gameMap.layers["PlatformTop"].x 
            oy = obj.y + gameMap.layers["PlatformTop"].y 
            local ground = world:newRectangleCollider(ox, oy, obj.width, obj.height)
            ground:setType('static')
            ground:setCollisionClass('Floor')
            table.insert(platformtops, ground)
        end
    end
    platformbottoms = {}
    if gameMap.layers["PlatfromBottom"] then
        for i, obj in pairs(gameMap.layers["PlatfromBottom"].objects) do
            local ox, oy = 0;
            ox = obj.x + gameMap.layers["PlatfromBottom"].x 
            oy = obj.y + gameMap.layers["PlatfromBottom"].y 
            local bottoms = world:newRectangleCollider(ox, oy, obj.width, obj.height)
            bottoms:setType('static')
            bottoms:setCollisionClass('PlatformB')
            table.insert(platformbottoms, bottoms)
        end
    end
    Lwalls = {}
    if gameMap.layers["Lwall"] then
        for i, obj in pairs(gameMap.layers["Lwall"].objects) do
            local ox, oy = 0;
            ox = obj.x + gameMap.layers["Lwall"].x 
            oy = obj.y + gameMap.layers["Lwall"].y 
            local wallL  = world:newRectangleCollider(ox, oy, obj.width, obj.height)
            wallL:setType('static')
            wallL:setCollisionClass('LWall')
            table.insert(Lwalls, wallL)
        end
    end

    Rwalls = {}
    if gameMap.layers["Rwall"] then
        for i, obj in pairs(gameMap.layers["Rwall"].objects) do
            local ox, oy = 0;
            ox = obj.x + gameMap.layers["Rwall"].x 
            oy = obj.y + gameMap.layers["Rwall"].y 
            local wallR  = world:newRectangleCollider(ox, oy, obj.width, obj.height)
            wallR:setType('static')
            wallR:setCollisionClass('RWall')
            table.insert(Rwalls, wallR)
        end
    end

    DeathObject = {}
    if gameMap.layers["DeathObjects"] then
        for i, obj in pairs(gameMap.layers["DeathObjects"].objects) do
            local ox, oy = 0;
            ox = obj.x + gameMap.layers["DeathObjects"].x 
            oy = obj.y + gameMap.layers["DeathObjects"].y 
            local deathobj  = world:newBSGRectangleCollider(ox, oy, obj.width, obj.height, 30)
            deathobj:setType('static')
            deathobj:setCollisionClass('DeathObjects')
            table.insert(DeathObject, deathobj)
        end
    end
    platformls = {}
    if gameMap.layers["platformL"] then
        for i, obj in pairs(gameMap.layers["platformL"].objects) do
            local ox, oy = 0;
            ox = obj.x + gameMap.layers["platformL"].x 
            oy = obj.y + gameMap.layers["platformL"].y 
            local platforml  = world:newRectangleCollider(ox, oy, obj.width, obj.height)
            platforml:setType('static')
            platforml:setCollisionClass('RWall')
            table.insert(platformls, platforml)
        end
    end
    platformrs = {}
    if gameMap.layers["platformR"] then
        for i, obj in pairs(gameMap.layers["platformR"].objects) do
            local ox, oy = 0;
            ox = obj.x + gameMap.layers["platformR"].x 
            oy = obj.y + gameMap.layers["platformR"].y 
            local platformr  = world:newRectangleCollider(ox, oy, obj.width, obj.height)
            platformr:setType('static')
            platformr:setCollisionClass('LWall')
            table.insert(platformrs, platformr)
        end
    end
    winzones = {}
    if gameMap.layers["levelcomplete"] then
        for i, obj in pairs(gameMap.layers["levelcomplete"].objects) do
            local ox, oy = 0;
            ox = obj.x + gameMap.layers["levelcomplete"].x 
            oy = obj.y + gameMap.layers["levelcomplete"].y 
            local platformr  = world:newRectangleCollider(ox, oy, obj.width, obj.height)
            platformr:setType('static')
            platformr:setCollisionClass('WinObjects')
            table.insert(winzones, platformr)
        end
    end
end
function love.update(dt)
    if state.playing then
        updateplaying(dt)
    end
end
function love.mousepressed(x, y, button, istouch)
    if state.menu then
        if button == 1 then 
            if levelbutton ~= true then
                if x > 350 and x < 450 and y > 285 and y < 305 then
                    startbutton = true
                end
                if unlockedlvls >= 1 then
                    if x > 350 and x < 450 and y > 306 and y < 326 then
                        levelbutton = true
                    end
                end
            else
                if x > 730 and x < 800 and y > 0 and y < 15 then
                    mainmenu = true
                end
                for i = 0, unlockedlvls, 1 do
                    if x > 350 and x < 450 and y > 285 + i * 20 and y < 305 + i * 20 then
                        levelnum = i + 1
                        levelstart = true
                    end
                end
            end
        end
    end
    if state.playing then
        if button == 1 then 
            if x > 730 and x < 800 and y > 0 and y < 15 then
            mainmenu = true
            end
        end
    end
end
function love.draw()
    if state.playing then 
        cam:attach()
        gameMap:drawLayer(gameMap.layers["background"])
        world:draw()
        cam:detach()
        love.graphics.print("main menu",725,0)
        if mainmenu then
            love.graphics.clear(0,0,0,0)
            unloadworld()
            state.menu=true
            state.playing=false
            mainmenu = false
        end
    end 
    if state.menu then
        --smenu:draw()
        love.graphics.setBackgroundColor( 0, 0, 0)
        love.graphics.setColor(1, 1, 1)
        --love.graphics.draw('text', 25, 25)
        love.graphics.print("begin game",350,285 )
        if unlockedlvls >= 1 then
            love.graphics.print("level select",350,310)
        end
        if startbutton then
            love.graphics.clear(0,0,0,0)
            loadworld()
            state.menu=false
            state.playing=true
            startbutton = false
        end
        if mainmenu then
            love.graphics.clear(0,0,0,0)
            state.menu=false
            state.menu=true
            mainmenu = false
            levelbutton = false
        end
        if levelbutton then
            love.graphics.clear(0,0,0,0)
            love.graphics.print("main menu",725,0)
            for i = 0, unlockedlvls, 1 do
                love.graphics.print(("level " .. i + 1),350,(285 + i * 20))
            end
            
        end
        if levelstart then
            love.graphics.clear(0,0,0,0)
            level = ("map/level"..levelnum..".lua")
            loadworld()
            state.menu=false
            state.playing=true
            levelstart = false
            levelbutton = false
        end
    end
end

function updateplaying(dt)
    if player.dead == 1 then
        player.dead = 0
        player.collider:setX(100)
        player.collider:setY(500)
        player.collider:setLinearVelocity( 0, 0 )
    end
    if player.collider:enter('Floor') then
        floor_detect = 1
    elseif player.collider:exit('Floor') then
        floor_detect = 0
    end
    if player.collider:enter('WinObjects') then
        win_detect = 1
    end
    if player.collider:enter('LWall') then
        Lwall_detect = 1
    elseif player.collider:exit('LWall') then
        Lwall_detect = 0
    end
    if player.collider:enter('RWall') then
        Rwall_detect = 1
    elseif player.collider:exit('RWall') then
        Rwall_detect = 0
    end
    if player.collider:enter('PlatformB') then
        player.collider:applyLinearImpulse(0, 1)
    end
    if player.collider:enter('DeathObjects') then
        player.dead = 1
    end
    if player.y > 700 then
        player.dead = 1
    end
    if floor_detect == 1 then
        playervelx = 0

        local px, py = player.collider:getLinearVelocity()
        if love.keyboard.isDown('left') then
            playervelx = player.speed * -1
        elseif love.keyboard.isDown('right') then
            playervelx = player.speed * 1
        elseif love.keyboard.isDown('a') then
            playervelx = player.speed * -1
        elseif love.keyboard.isDown('d')  then
            playervelx = player.speed * 1
        end
        player.collider:applyLinearImpulse(playervelx, 0)
    else
        playervelx = 0

        local px, py = player.collider:getLinearVelocity()
        if love.keyboard.isDown('left') then
            playervelx = player.speed * -0.2
        elseif love.keyboard.isDown('right') then
            playervelx = player.speed * 0.2
        elseif love.keyboard.isDown('a') then
            playervelx = player.speed * -0.2
        elseif love.keyboard.isDown('d') then
            playervelx = player.speed * 0.2
        end
        player.collider:applyLinearImpulse(playervelx, 0)
    end
    if Lwall_detect == 1 then
        if love.keyboard.isDown('space') then  
            local x, y = player.collider:getLinearVelocity()
            player.collider:setLinearVelocity( 350, y )
            player.collider:applyLinearImpulse(0, -2000)
        end
        if love.keyboard.isDown('up') then  
            local x, y = player.collider:getLinearVelocity()
            player.collider:setLinearVelocity( 350, y )
            player.collider:applyLinearImpulse(0, -2000)
        end
        if love.keyboard.isDown('w') then  
            local x, y = player.collider:getLinearVelocity()
            x = x
            player.collider:setLinearVelocity( 350, y )
            player.collider:applyLinearImpulse(0, -2000)
        end
    end
    if Rwall_detect == 1 then
        if love.keyboard.isDown('space') then  
            local x, y = player.collider:getLinearVelocity()
            player.collider:setLinearVelocity( -350, y )
            player.collider:applyLinearImpulse(0, -2000)
        end
        if love.keyboard.isDown('up') then  
            local x, y = player.collider:getLinearVelocity()
            player.collider:setLinearVelocity( -350, y )
            player.collider:applyLinearImpulse(0, -2000)
        end
        if love.keyboard.isDown('w') then  
            local x, y = player.collider:getLinearVelocity()
            player.collider:setLinearVelocity( -350, y )
            player.collider:applyLinearImpulse(0, -2000)
        end
    end
    if floor_detect == 1 and Rwall_detect ~= 1 and Lwall_detect ~= 1 then
        if love.keyboard.isDown('space') then  
            player.collider:applyLinearImpulse(0, -2700)
        end
        if love.keyboard.isDown('up') then  
            player.collider:applyLinearImpulse(0, -2700)
        end
        if love.keyboard.isDown('w') then  
            player.collider:applyLinearImpulse(0, -2700)
        end
    end
    player.x = player.collider:getX()
    player.y = player.collider:getY()
    cam:lookAt(400, player.y)
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    if cam.y > 300 then
        cam.y = 300 
    end
    world:update(dt)
    gameMap:update(dt)
    if win_detect == 1 then
        if unlockedlvls <= 0 then
            success, message = love.filesystem.write( 'savefile', unlockedlvls + 1, 1 )
        end
        win_detect = 0
        love.graphics.clear(0,0,0,0)
        unloadworld()
        state.menu=true
        state.playing=false
        mainmenu = false
    end
end