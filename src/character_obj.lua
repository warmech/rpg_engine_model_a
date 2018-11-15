function initCharacterObject(characterName, characterType)
	-- 
	local characterData = {}
	local initialCharacterData = {}

	--fromCSV to read init data goes here

	characterData[1] = {characterName, characterType}

	-- Populate sprite and movement array
	local movementCounter = 1
	local movementState = 1
	local spriteSheet = "gfx/char/"..characterType..".png"
	characterData[2] = {movementCounter, movementState, spriteSheet}

	-- Populate character stats
	local characterStrength = 
	local characterDefense = 
	local characterAgility = 
	local characterMana = 
	local characterCurrentHP = 
	local characterMaxHP = 
	characterData[3] = {}

	-- Populate inventory data


	characterInventory = {}

	return characterData
end

function initNpcObject()
	-- body
end