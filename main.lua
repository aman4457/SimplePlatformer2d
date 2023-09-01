

function love.load()
    wf = require "Libraries/windfield"
    world = wf.newWorld(0, 1000)
    world:addCollisionClass('Floor')
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
    platformtop = world:newRectangleCollider(210, 230, 390, 5)
    platformbottom = world:newRectangleCollider(210, 235, 390, 5)
    platforml = world:newRectangleCollider(205, 230, 5, 10)
    platformr = world:newRectangleCollider(600, 230, 5, 10)
    ground:setType('static')
    wallR:setType('static')
    wallL:setType('static')
    platformtop:setType('static')
    platformbottom:setType('static')
    platforml:setType('static')
    platformr:setType('static')
    ground:setCollisionClass('Floor')
    wallL:setCollisionClass('LWall')
    wallR:setCollisionClass('RWall')
    platformr:setCollisionClass('LWall')
    platforml:setCollisionClass('RWall')
    platformtop:setCollisionClass('Floor')
    floor_detect = 0
    player.collider:setFixedRotation(true)

end

function love.update(dt)


    world:update(dt)
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
end

function love.draw()
    world:draw()
end