function buildMap(tilemapFileName, metadataFileName, tilesetFileName, tileSize, startX, startY)
	--Open tilemap data file
	local tilemapFile = io.open(tilemapFileName, "r")
	io.input(tilemapFile)

	--Count number of rows in tilemap
	local rowCount = countRows(tilemapFileName)

	--Count number of columns in tilemap
	local columnCount = countColumns(readNumericalCSV(io.read()))
	tilemapFile:seek("set", 0)

	--Read a row and parse it to map table
	local mapTable = {}
	for row = 1, rowCount do
			local line = readNumericalCSV(io.read())
			mapTable[row] = {}
			for column = 1, columnCount do
				mapTable[row][column] = line[column]
			end
	end
	
	--Close tilemap file
	io.close(tilemapFile)

    local mapData = loadTable(metadataFileName)
    mapData.mapMetadata.mapX = startX
    mapData.mapMetadata.mapY = startY

	--Create quad table and import the appropriate tileset file
	local tilesetQuads = {}
	local tilesetFile = love.graphics.newImage(tilesetFileName)

	--This filter is configurable based upon game settings, but should probably be locked to nearest/nearest
	local filter_min = "nearest"
	local filter_mag = "nearest"
	tilesetFile:setFilter(filter_min, filter_mag)
	local tilesetQuadIndex = 1

	--Iterate down the tileset's rows by multiples of tileSize pixels (16 is default)
	for y = 1, (tilesetFile:getHeight() / tileSize) do
		--Iterate across the tileset's columns by multiples of tileSize pixels (16 is default)
		for x = 1, (tilesetFile:getWidth() / tileSize) do
			--Read the (tileSize * tileSize) pixel group at ((x - 1) * tileSize), ((y - 1) * tileSize) into a new quad
			tilesetQuads[tilesetQuadIndex] = love.graphics.newQuad(((x - 1) * tileSize), ((y - 1) * tileSize), tileSize, tileSize, tilesetFile:getWidth(), tilesetFile:getHeight())
			tilesetQuadIndex = tilesetQuadIndex + 1
		end
	end

	--Create a new sprite batch (the viewable area of the map) with the tileset file
	local newTilesetSpriteBatch = love.graphics.newSpriteBatch(tilesetFile, mapData.mapMetadata.tilesDisplayWidth * mapData.mapMetadata.tilesDisplayHeight)

	--Clear out the viewable area of the map
	newTilesetSpriteBatch:clear()

	--Iterate down the rows of the map tiles displayed on screen
	for y = 0, (mapData.mapMetadata.tilesDisplayHeight - 1) do
		--Iterate across the columns of the map tiles displayed on screen
		for x = 0, (mapData.mapMetadata.tilesDisplayWidth - 1) do
			--Write the appropriate tile to the current cell in the sprite batch
			newTilesetSpriteBatch:add(tilesetQuads[mapTable[y + math.floor(mapData.mapMetadata.mapY)][x + math.floor(mapData.mapMetadata.mapX)]], x * tileSize, y * tileSize)
		end
	end

	--Send data to GPU
	newTilesetSpriteBatch:flush()

	--Compile and return map object
	local mapObject = {tilemap = mapTable, metadata = mapData, tileset = tilesetQuads, tilesetSpriteBatch = newTilesetSpriteBatch}
	return mapObject
end

function updateTilesetSpriteBatch()
    --Clear out the viewable area of the map
    currentMap.tilesetSpriteBatch:clear()

    --Iterate down the rows of the map tiles displayed on screen
    for y = 0, (currentMap.metadata.mapMetadata.tilesDisplayHeight - 1) do
        --Iterate across the columns of the map tiles displayed on screen
        for x = 0, (currentMap.metadata.mapMetadata.tilesDisplayWidth - 1) do
            --Write the appropriate tile to the current cell in the sprite batch
            currentMap.tilesetSpriteBatch:add(currentMap.tileset[currentMap.tilemap[y + math.floor(currentMap.metadata.mapMetadata.mapY)][x + math.floor(currentMap.metadata.mapMetadata.mapX)]], x * 16, y * 16)
        end
    end

    --Render data to GPU and return updated map sprite batch
    currentMap.tilesetSpriteBatch:flush()



end

function moveMap()
    local oldMapX = currentMap.metadata.mapMetadata.mapX
    local oldMapY = currentMap.metadata.mapMetadata.mapY
    currentMap.metadata.mapMetadata.mapX = math.max(math.min(currentMap.metadata.mapMetadata.mapX + playerCharacter.gfx.xDelta, currentMap.metadata.mapMetadata.mapWidth - currentMap.metadata.mapMetadata.tilesDisplayWidth + currentMap.metadata.mapMetadata.mapBoundaryOffset), 1)
    currentMap.metadata.mapMetadata.mapY = math.max(math.min(currentMap.metadata.mapMetadata.mapY + playerCharacter.gfx.yDelta, currentMap.metadata.mapMetadata.mapHeight - currentMap.metadata.mapMetadata.tilesDisplayHeight + currentMap.metadata.mapMetadata.mapBoundaryOffset), 1)

    -- only update if we actually moved
    if math.floor(currentMap.metadata.mapMetadata.mapX) ~= math.floor(oldMapX) or math.floor(currentMap.metadata.mapMetadata.mapY) ~= math.floor(oldMapY) then
        updateTilesetSpriteBatch()
    end
end

function preCollisionMovementCheck(direction)
    for i = 1, (#currentMap.metadata.mapMetadata.nogoTileTypes) do
        if direction == currentMap.metadata.mapMetadata.nogoTileTypes[i] then
            return false
        end
    end
    return true
end

function preCollisionAction()
    -- body
end

function postCollisionAction()


    for i = 1, (#currentMap.metadata.doorMetadata) do
        if (currentMap.metadata.doorMetadata[i].originX == playerCharacter.gfx.xTilePosition) then
            if (currentMap.metadata.doorMetadata[i].originY == playerCharacter.gfx.yTilePosition) then

                tilemapFileName = "rpg_engine_model_a/dat/maps/"..currentMap.metadata.doorMetadata[i].destMap.."/map"
                metadataFileName = "rpg_engine_model_a/dat/maps/"..currentMap.metadata.doorMetadata[i].destMap.."/metadata"
                tilesetFileName = "dat/maps/"..currentMap.metadata.doorMetadata[i].destMap.."/tileset.png"

                newMapDestX = currentMap.metadata.doorMetadata[i].destX
                newMapDestY = currentMap.metadata.doorMetadata[i].destY

                newMapDrawX = (newMapDestX - 7.5)
                newMapDrawY = (newMapDestY - 4)

                currentMap = buildMap(tilemapFileName, metadataFileName, tilesetFileName, tileSize, newMapDrawX, newMapDrawY)

                playerCharacter.gfx.xTilePosition = currentMap.metadata.mapMetadata.mapX + playerCharacter.gfx.distToCenterX
                playerCharacter.gfx.yTilePosition = currentMap.metadata.mapMetadata.mapY + playerCharacter.gfx.distToCenterY
                
                playerCharacter.gfx.upTile = currentMap.tilemap[newMapDestY - 1][newMapDestX]
                playerCharacter.gfx.rightTile = currentMap.tilemap[newMapDestY][newMapDestX + 1]
                playerCharacter.gfx.downTile = currentMap.tilemap[newMapDestY + 1][newMapDestX]
                playerCharacter.gfx.leftTile = currentMap.tilemap[newMapDestY][newMapDestX - 1]         

                break
            end
        end
    end
        
end

































