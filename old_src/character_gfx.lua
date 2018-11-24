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
end