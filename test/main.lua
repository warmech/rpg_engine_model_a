




function initPlayerObject(playerName, playerType)
	--
	local playerData = {}
	
	-- Populate demographic array
	playerData[1] = {playerName, playerType}

	-- Populate sprite and movement array
	local tileSize = 16
	local movementCounter = 1
	local movementState = 1
	local spriteSheet = "/gfx/char/"..playerType..".png"
	local xTilePosition = 0
	local yTilePosition = 0
	local xPixelPosition = 0
	local yPixelPosition = 0
	local movementCounter = 1
	local movementMaxDuration = 16
	local movementState = 1
	local filter1 = "nearest"
	local filter2 = "nearest"
	local playerCharacterSprite = love.graphics.newImage(spriteSheet)
	local movementFlag = 0
	playerCharacterSprite:setFilter(filter1, filter2)
	playerData[2] = {movementCounter, movementState, spriteSheet, xTilePosition, yTilePosition, xPixelPosition, yPixelPosition, movementCounter, movementMaxDuration, movementState, playerCharacterSprite, filter1, filter2, movementFlag}
	
	-- Initialize movement data tables
	playerData[3] = {}
	
	for x = 1, (playerCharacterSprite:getWidth() / tileSize) do
		playerData[3][x] = love.graphics.newQuad((x - 1) * tileSize, 0 * tileSize, tileSize, tileSize, playerCharacterSprite:getWidth(), playerCharacterSprite:getHeight())
	end

	return playerData
end

function drawPlayerCharacter(counter, state)

  -- Set idle animation frame
	if(counter == 17) then
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


function love.keypressed(key)
	if key == "up" then
		if((player_01[2][2] % 2) == 1) then
			player_01[2][2] = 7
		else
			player_01[2][2] = 8
		end

		player_01[2][14] = 1

	elseif key == "down" then
		if((player_01[2][2] % 2) == 1) then
			player_01[2][2] = 1
		else
			player_01[2][2] = 2
		end
	elseif key == "left" then
		if((player_01[2][2] % 2) == 1) then
			player_01[2][2] = 5
		else
			player_01[2][2] = 6
		end
	elseif key == "right" then
		if((player_01[2][2] % 2) == 1) then
			player_01[2][2] = 3
		else
			player_01[2][2] = 4
		end
	end
end


function love.update(dt)

	dt = math.min(dt, 1/30)
	drawPlayerCharacter(player_01[2][1], player_01[2][2])

end



function love.draw()
	love.graphics.print("COUNTER: "..player_01[2][1], 40, 40)
	love.graphics.print("STATE: "..player_01[2][2], 40, 50)
	love.graphics.draw(player_01[2][11], player_01[3][player_01[2][2]], 10, 10, 0, 3, 3)
end



















