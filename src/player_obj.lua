function initPlayerObject(playerName, playerType)
	--Populate demographic information
	local playerInfo =
    {
        name = playerName,
        race = playerType
    }

	-- Populate sprite and movement array
    local playerGFX =
    {
        tileSize = 16,
        movementCounter = 1,
        movementState = 1,
        movementMaxDuration = 16,
        movementCurrentDuration = 1,
        movementLockout = false,
        xDelta = 0,
        yDelta = 0,
        spriteSheet = "/gfx/char/"..playerType..".png",
        xTilePosition = 0,
        yTilePosition = 0,
        xPixelPosition = 0,
        yPixelPosition = 0,
        distToCenterX = 7.5,
        distToCenterY = 4,
        zoomX = 3,
        zoomY = 3
    }

    --Build movement tileset
    local playerQuads = {}
    local playerCharacterSprite = love.graphics.newImage(playerGFX.spriteSheet)
    local filter_min = "nearest"
    local filter_mag = "nearest"
    playerCharacterSprite:setFilter(filter_min, filter_mag)

    --Iterate across the tileset's columns by multiples of tileSize pixels (16 is default)
    for x = 1, (playerCharacterSprite:getWidth() / playerGFX.tileSize) do
        playerQuads[x] = love.graphics.newQuad((x - 1) * playerGFX.tileSize, 0 * playerGFX.tileSize, playerGFX.tileSize, playerGFX.tileSize, playerCharacterSprite:getWidth(), playerCharacterSprite:getHeight())
    end

    local playerData = {info = playerInfo, gfx = playerGFX, tileset = playerQuads, sprite = playerCharacterSprite}
	return playerData
end