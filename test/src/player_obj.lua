function initPlayerObject(playerName, playerType)
	--
	local playerData = {}
	
	-- Populate demographic array
	playerData[1] = {playerName, playerType}

	-- Populate sprite and movement array
	local movementCounter = 1
	local movementState = 1
	local spriteSheet = "/gfx/char/"..playerType..".png"
	local xTilePosition = 0
	local yTilePosition = 0
	local xPixelPosition = 0
	local yPixelPosition = 0
	playerData[2] = {movementCounter, movementState, spriteSheet, xTilePosition, yTilePosition, xPixelPosition, yPixelPosition}

	return playerData
end