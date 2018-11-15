function initPlayerObject(playerName, playerType)
	--
	local playerData = {}
	
	-- Populate demographic array
	playerData[1] = {playerName, playerType}

	-- Populate sprite and movement array
	local movementCounter = 1
	local movementState = 1
	local spriteSheet = "../gfx/char/"..playerType..".png"
	playerData[2] = {movementCounter, movementState, spriteSheet}

	return playerData
end