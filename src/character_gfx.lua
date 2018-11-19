function loadPlayerCharacterGFX(spriteSheet, filter1, filter2, tileSize)

    --Load spritesheet for player character
    local playerCharacterSprite = love.graphics.newImage(spriteSheet)
    --Set filter as defined by player; this is nearest/nearest by default
    playerCharacterSprite:setFilter(filter1, filter2)
    --Initialize movement counter; once this reaches a maximum of 16, the next walk animation frame is drawn
    local playerCharacterGFX = {}

    for x = 1, playerCharacterSprite:getWidth(), tileSize do
        playerCharacterGFX[x] = love.graphics.newQuad((x - 1) * tileSize, 0 * tileSize, tileSize, tileSize, playerCharacterSprite:getWidth(), playerCharacterSprite:getHeight())
    end

    return playerCharacterGFX
end

function drawPlayerCharacter()

  --Set idle animation frame
    if(playerCharacter.gfx.movementCounter == 16) then
        if((playerCharacter.gfx.movementState % 2) == 1) 
        then
            playerCharacter.gfx.movementState = playerCharacter.gfx.movementState + 1
        else
            playerCharacter.gfx.movementState = playerCharacter.gfx.movementState - 1
        end
        playerCharacter.gfx.movementCounter = 1
    else
        playerCharacter.gfx.movementCounter = playerCharacter.gfx.movementCounter + 1
    end

    --Update sprite location
    playerCharacter.gfx.xTilePosition = currentMap.metadata.mapX + playerCharacter.gfx.distToCenterX
    playerCharacter.gfx.yTilePosition = currentMap.metadata.mapY + playerCharacter.gfx.distToCenterY
end



--[[


player.gfx.movementCounter
player.gfx.movementState

        tileSize = 16,
        movementCounter = 1,
        movementState = 1,
        movementMaxDuration = 16,
        spriteSheet = "/gfx/char/"..playerType..".png",
        xTilePosition = 0,
        yTilePosition = 0,
        xPixelPosition = 0,
        yPixelPosition = 0,
        orientation = 1


function drawPlayerCharacter()

  -- Set idle animation frame
    if(counter == 16) then
        if((state % 2) == 1) 
        then
            state = state + 1
        else
            state = state - 1
        end
        counter = 1
    else
        counter = counter + 1
    end
    
    player_01[2][1] = counter
    player_01[2][2] = state
    

end



player_01 = initPlayerObject("Will", "human_m")


function love.update(dt)

    drawPlayerCharacter(player_01[2][1], player_01[2][2])

end



function love.draw()
    love.graphics.print("COUNTER: "..player_01[2][1], 40, 40)
    love.graphics.print("STATE: "..player_01[2][2], 40, 50)
    love.graphics.draw(player_01[2][11], player_01[3][(player_01[2][2])], 10, 10)
end


]]