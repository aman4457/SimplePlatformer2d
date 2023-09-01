

function love.load()
    wf = require "Libraries/windfield"
    camera  = require "Libraries/camera"
    cam = camera()
    world = wf.newWorld(0, 1000)
    world:addCollisionClass('Floor')
    world:addCollisionClass('PlatformB')
    world:addCollisionClass('LWall')
    world:addCollisionClass('RWall')
    world:addCollisionClass('LWall')
    world:addCollisionClass('RWall')
    player = {}
    player.x = 5
    player.y = 500
    player.speed = 100
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 50, 100, 15)
    ground = world:newRectangleCollider(0, 600, 800, 10)
    wallL = world:newRectangleCollider(-10, -1000, 10, 1600)
    wallR = world:newRectangleCollider(800, -1000, 10, 1600)
    platformtop0 = world:newRectangleCollider(210, 230, 390, 5)
    platformbottom0 = world:newRectangleCollider(210, 235, 390, 5)
    platforml0 = world:newRectangleCollider(205, 230, 5, 10)
    platformr0 = world:newRectangleCollider(600, 230, 5, 10)
    platformtop1 = world:newRectangleCollider(310, -55, 490, 5)
    platformbottom1 = world:newRectangleCollider(310, -50, 490, 5)
    platforml1 = world:newRectangleCollider(305, -55, 5, 10)
    platformr1 = world:newRectangleCollider(800, -55, 5, 10)
    ground:setType('static')
    wallR:setType('static')
    wallL:setType('static')
    platformtop0:setType('static')
    platformbottom0:setType('static')
    platforml0:setType('static')
    platformr0:setType('static')
    platformtop1:setType('static')
    platformbottom1:setType('static')
    platforml1:setType('static')
    platformr1:setType('static')
    ground:setCollisionClass('Floor')
    wallL:setCollisionClass('LWall')
    wallR:setCollisionClass('RWall')
    platformr0:setCollisionClass('LWall')
    platforml0:setCollisionClass('RWall')
    platformtop0:setCollisionClass('Floor')
    platformr1:setCollisionClass('LWall')
    platformbottom0:setCollisionClass('PlatformB')
    platforml1:setCollisionClass('RWall')
    platformtop1:setCollisionClass('Floor')
    platformbottom1:setCollisionClass('PlatformB')
    floor_detect = 0
    player.collider:setFixedRotation(true)

end

function love.update(dt)
    if player.collider:enter('Floor') then
        floor_detect = 1
    elseif player.collider:exit('Floor') then
        floor_detect = 0
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
    elseif player.collider:exit('PlatformB') then
        player.collider:applyLinearImpulse(0, 1)
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
        elseif love.keyboard.isDown('d')  then
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

end

function love.draw()
    cam:attach()
        world:draw()
    cam:detach()
end