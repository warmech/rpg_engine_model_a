function loadPlayerCharacterGFX(spriteSheet, filter1, filter2, tileSize)

	-- Load spritesheet for player character
	local playerCharacterSprite = love.graphics.newImage(spriteSheet)
	-- Set filter as defined by player; this is nearest/nearest by default
	playerCharacterSprite:setFilter(filter1, filter2)
	-- Initialize movement counter; once this reaches a maximum of 16, the next walk animation frame is drawn
	local movementCounter = 1
	local movementMaxDuration = 16
	local movementState = 1
	local playerCharacterMovement = {movementCounter, movementMaxDuration, movementState}

	local playerCharacterGFX = {}
	

	for x = 1, playerCharacterSprite:getWidth(), tileSize do
		playerCharacterGFX[x] = love.graphics.newQuad(0 * tileSize, 0 * tileSize, tileSize, tileSize, playerCharacterSprite:getWidth(), playerCharacterSprite:getHeight())
	end

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
	end
	else
		counter = counter + 1
	end
  --



  

end
