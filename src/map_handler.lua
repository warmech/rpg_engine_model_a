function buildMap(tilemapFileName, metadataFileName, tilesetFileName, tileSize)
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

	--Open metadata file and parse it to the metadata table
	local metadataFile = io.open(metadataFileName, "r")
	io.input(metadataFile)
	local metadataTable = readNumericalCSV(io.read())

    local mapMetadata = 
    {
        mapX = metadataTable[1],
        mapY = metadataTable[2],
        aspectX = metadataTable[3],
        aspectY = metadataTable[4],
        widthBuffer = metadataTable[5],
        heightBuffer = metadataTable[6],
        zoomX = metadataTable[7],
        zoomY = metadataTable[8],
        mapWidth = columnCount,
        mapHeight = rowCount,
        tilesDisplayWidth = (metadataTable[3] + metadataTable[5]),
        tilesDisplayHeight = (metadataTable[4] + metadataTable[6]),
        mapBoundaryOffset = .5
    }

	--Close metadata file
	io.close(metadataFile)

    --Open tiledata file and parse it to the tiledata table
    local tiledataFile = io.open(tiledataFileName, "r")
    io.input(tiledataFile)
    local tiledataTable = fromCSV(io.read())

    local tileMetadata = 
    {
        tileType = tonumber(tiledataTable[1]),
        originMap = tiledataTable[2],
        originX = tonumber(tiledataTable[3]),
        originY = tonumber(tiledataTable[4]),
        destMap = tiledataTable[5],
        destX = tonumber(tiledataTable[6]),
        destY = tonumber(tiledataTable[7]),
        active = tonumber(tiledataTable[8]),
        transition = tonumber(tiledataTable[9]),
        event = tonumber(tiledataTable[10])
    }

    --Close metadata file
    io.close(tiledataFile)

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
	local newTilesetSpriteBatch = love.graphics.newSpriteBatch(tilesetFile, mapMetadata.tilesDisplayWidth * mapMetadata.tilesDisplayHeight)

	--Clear out the viewable area of the map
	newTilesetSpriteBatch:clear()

	--Iterate down the rows of the map tiles displayed on screen
	for y = 0, (mapMetadata.tilesDisplayHeight - 1) do
		--Iterate across the columns of the map tiles displayed on screen
		for x = 0, (mapMetadata.tilesDisplayWidth - 1) do
			--Write the appropriate tile to the current cell in the sprite batch
            --newTilesetSpriteBatch:add(tilesetQuads[tonumber(mapTable[y + math.floor(mapMetadata.mapY)][x + math.floor(mapMetadata.mapX)])], x * tileSize, y * tileSize)
			newTilesetSpriteBatch:add(tilesetQuads[mapTable[y + math.floor(mapMetadata.mapY)][x + math.floor(mapMetadata.mapX)]], x * tileSize, y * tileSize)
		end
	end

	--Send data to GPU
	newTilesetSpriteBatch:flush()

	--Compile and return map object
	local mapObject = {tilemap = mapTable, metadata = mapMetadata, tiledata = tileMetadata, tileset = tilesetQuads, tilesetSpriteBatch = newTilesetSpriteBatch}
	return mapObject
end

function updateTilesetSpriteBatch()
    --Clear out the viewable area of the map
    currentMap.tilesetSpriteBatch:clear()

    --Iterate down the rows of the map tiles displayed on screen
    for y = 0, (currentMap.metadata.tilesDisplayHeight - 1) do
        --Iterate across the columns of the map tiles displayed on screen
        for x = 0, (currentMap.metadata.tilesDisplayWidth - 1) do
            --Write the appropriate tile to the current cell in the sprite batch
            currentMap.tilesetSpriteBatch:add(currentMap.tileset[currentMap.tilemap[y + math.floor(currentMap.metadata.mapY)][x + math.floor(currentMap.metadata.mapX)]], x * 16, y * 16)
        end
    end

    --Render data to GPU and return updated map sprite batch
    currentMap.tilesetSpriteBatch:flush()

end

--[[
function moveMap(dx, dy)
    local oldMapX = currentMap.metadata.mapX
    local oldMapY = currentMap.metadata.mapY
    currentMap.metadata.mapX = math.max(math.min(currentMap.metadata.mapX + dx, currentMap.metadata.mapWidth - currentMap.metadata.tilesDisplayWidth + currentMap.metadata.mapBoundaryOffset), 1)
    currentMap.metadata.mapY = math.max(math.min(currentMap.metadata.mapY + dy, currentMap.metadata.mapHeight - currentMap.metadata.tilesDisplayHeight + currentMap.metadata.mapBoundaryOffset), 1)

    -- only update if we actually moved
    if math.floor(currentMap.metadata.mapX) ~= math.floor(oldMapX) or math.floor(currentMap.metadata.mapY) ~= math.floor(oldMapY) then
        updateTilesetSpriteBatch()
    end
end
]]

function moveMap()
    local oldMapX = currentMap.metadata.mapX
    local oldMapY = currentMap.metadata.mapY
    currentMap.metadata.mapX = math.max(math.min(currentMap.metadata.mapX + playerCharacter.gfx.xDelta, currentMap.metadata.mapWidth - currentMap.metadata.tilesDisplayWidth + currentMap.metadata.mapBoundaryOffset), 1)
    currentMap.metadata.mapY = math.max(math.min(currentMap.metadata.mapY + playerCharacter.gfx.yDelta, currentMap.metadata.mapHeight - currentMap.metadata.tilesDisplayHeight + currentMap.metadata.mapBoundaryOffset), 1)
    --print("mapX + xDelta: "..currentMap.metadata.mapX + playerCharacter.gfx.xDelta)
    --print("mapWidth + tilesDisplayWidth + offset: "..currentMap.metadata.mapWidth - currentMap.metadata.tilesDisplayWidth + currentMap.metadata.mapBoundaryOffset)

    -- only update if we actually moved
    if math.floor(currentMap.metadata.mapX) ~= math.floor(oldMapX) or math.floor(currentMap.metadata.mapY) ~= math.floor(oldMapY) then
        updateTilesetSpriteBatch()
    end
end

function preCollisionMovementCheck(direction)
    -- body
    if direction == 2 then
        return false
        --return true
    else
        return true
    end
end

function preCollisionAction()
    -- body

end

function postCollisionAction()
    -- body
end

































