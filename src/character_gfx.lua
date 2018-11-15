function loadPlayerCharacterGFX(spritesheet, filter1, filter2)

  -- Load spritesheet for player character
  playerCharacterSprite = love.graphics.newImage(sprite)
  -- Set filter as defined by player; this is nearest/nearest by default
  playerCharacterSprite:setFilter(filter1, filter2)
  -- Set tile size for creating quads
  tileSize = 16
  -- Initialize movement counter; once this reaches a maximum of 16, the next walk animation frame is drawn
  movementCounter = 1
  movementState = 1

  playerCharacterGFX = {}

  -- Walking Down :: Frame 001
  playerCharacterGFX[1] = love.graphics.newQuad(0 * tileSize, 0 * tileSize, tileSize, tileSize, playerCharacterSprite:getWidth(), playerCharacterSprite:getHeight())
  -- Walking Down :: Frame 002
  playerCharacterGFX[2] = love.graphics.newQuad(1 * tileSize, 0 * tileSize, tileSize, tileSize, playerCharacterSprite:getWidth(), playerCharacterSprite:getHeight())
  -- Walking Right :: Frame 001
  playerCharacterGFX[3] = love.graphics.newQuad(2 * tileSize, 0 * tileSize, tileSize, tileSize, playerCharacterSprite:getWidth(), playerCharacterSprite:getHeight())
  -- Walking Right :: Frame 002
  playerCharacterGFX[4] = love.graphics.newQuad(3 * tileSize, 0 * tileSize, tileSize, tileSize, playerCharacterSprite:getWidth(), playerCharacterSprite:getHeight())
  -- Walking Left :: Frame 001
  playerCharacterGFX[5] = love.graphics.newQuad(4 * tileSize, 0 * tileSize, tileSize, tileSize, playerCharacterSprite:getWidth(), playerCharacterSprite:getHeight())
  -- Walking Left :: Frame 002
  playerCharacterGFX[6] = love.graphics.newQuad(5 * tileSize, 0 * tileSize, tileSize, tileSize, playerCharacterSprite:getWidth(), playerCharacterSprite:getHeight())
  -- Walking Up :: Frame 001
  playerCharacterGFX[7] = love.graphics.newQuad(6 * tileSize, 0 * tileSize, tileSize, tileSize, playerCharacterSprite:getWidth(), playerCharacterSprite:getHeight())
  -- Walking Up :: Frame 002
  playerCharacterGFX[8] = love.graphics.newQuad(7 * tileSize, 0 * tileSize, tileSize, tileSize, playerCharacterSprite:getWidth(), playerCharacterSprite:getHeight())

  --tilesetBatch = love.graphics.newSpriteBatch(tilesetImage, tilesDisplayWidth * tilesDisplayHeight)

  return playerCharacterGFX
end



function drawPlayerCharacter(counter, state)

  -- Set idle animation frame
  if(counter == 16) then
    if((movementState % 2) == 1) then
      movementState = movementState + 1
    else
      movementState = movementState - 1
    counter = 1
  else
    counter = counter + 1

  --



  

end
