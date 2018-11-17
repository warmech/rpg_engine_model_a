function loadTilemap(tilemapFileName)
	--Open tilemap data file
	local tilemapFile = io.open(tilemapFileName, "r")
	io.input(tilemapFile)

	--Count number of rown in tilemap
	local row_count = countRows(tilemapFileName)

	--Count number of columns in tilemap
	local column_count = countColumns(fromCSV(io.read()))
	tilemapFile:seek("set", 0)

	--Read a row and parse it to map table
	local mapTable = {}
	for row = 1, row_count do
			local line = fromCSV(io.read())
			mapTable[row] = {}
			for column = 1, column_count do
				mapTable[row][column] = line[column]
			end
	end
	
	--Close file and return the map table, map width, and map height
	io.close(tilemapFile)
	return mapTable, column_count, row_count
end

function loadMetadata(metadataFileName, mapWidth, mapHeight)
	--Open metadata file and parse it to the metadata table
	local metadataFile = io.open(metadataFileName, "r")
	io.input(metadataFile)
	local mapMetadata = fromCSV(io.read())
	
	--Append map size (in tiles) to table
	table.insert(mapMetadata, mapWidth)
	table.insert(mapMetadata, mapHeight)
	
	--Append tilesDisplayWidth and tilesDisplayHeight to table
	table.insert(mapMetadata, (mapMetadata[3] + mapMetadata[5]))
	table.insert(mapMetadata, (mapMetadata[4] + mapMetadata[6]))
	
	--Close file and return metadata table
	io.close(metadataFile)
	return mapMetadata
end

function loadTileset(tilesetFileName, filter1, filter2, tileSize, tilesDisplayWidth, tilesDisplayHeight)
	--Create quad table and import the appropriate tileset file
	local tilesetQuads = {}
	local tilesetFile = love.graphics.newImage(tilesetFileName)
	--This filter is configurable based upon game settings, but should probably be locked to nearest/nearest
	tilesetFile:setFilter(filter1, filter2)
	local tilesetQuadIndex = 1

	--Iterate down the tileset's rows by multiples of 16 pixels
	for y = 1, (tilesetFile:getHeight() / tileSize) do
		--Iterate across the tileset's columns by multiples of 16 pixels
		for x = 1, (tilesetFile:getWidth() / tileSize) do
			--Read the 16 * 16 pixel group at ((x - 1) * tileSize), ((y - 1) * tileSize) into a new quad
			tilesetQuads[tilesetQuadIndex] = love.graphics.newQuad(((x - 1) * tileSize), ((y - 1) * tileSize), tileSize, tileSize, tilesetFile:getWidth(), tilesetFile:getHeight())
			tilesetQuadIndex = tilesetQuadIndex + 1
		end
	end

	--Create a new sprite batch (the viewable area of the map) with the tileset file and return both the quad table and the sprite batch
	local tilesetSpriteBatch = love.graphics.newSpriteBatch(tilesetFile, tilesDisplayWidth * tilesDisplayHeight)
	return tilesetQuads, tilesetSpriteBatch
end

function updateTilesetSpriteBatch(tilesetSpriteBatch, tilesetQuads, tilemap, tileSize, tilesDisplayWidth, tilesDisplayHeight, mapX, mapY)
	--Clear out the viewable area of the map
	tilesetSpriteBatch:clear()

	--Iterate down the rows of the map tiles displayed on screen
	for y = 0, (tilesDisplayHeight - 1) do
		--Iterate across the columns of the map tiles displayed on screen
		for x = 0, (tilesDisplayWidth - 1) do
			--Write the appropriate tile to the current cell in the sprite batch
			tilesetSpriteBatch:add(tilesetQuads[tonumber(tilemap[y + math.floor(mapY)][x + math.floor(mapX)])], x * tileSize, y * tileSize)
		end
	end

	--Render data to GPU and return updated map sprite batch
	tilesetSpriteBatch:flush()
	return tilesetSpriteBatch
end


-- central function for moving the map
function moveMap(dx, dy)
	oldMapX = mapX
	oldMapY = mapY
	mapX = math.max(math.min(mapX + dx, mapWidth - tilesDisplayWidth), 1)
	mapY = math.max(math.min(mapY + dy, mapHeight - tilesDisplayHeight), 1)

	-- only update if we actually moved
	if math.floor(mapX) ~= math.floor(oldMapX) or math.floor(mapY) ~= math.floor(oldMapY) then
		updateTilesetSpriteBatch()
	end
end


--[[
function love.update(dt)
  if love.keyboard.isDown("up")  then
    moveMap(0, -1 * tileSize * dt)
  end
  if love.keyboard.isDown("down")  then
    moveMap(0, 1 * tileSize * dt)
  end
  if love.keyboard.isDown("left")  then
    moveMap(-1 * tileSize * dt, 0)
  end
  if love.keyboard.isDown("right")  then
    moveMap(1 * tileSize * dt, 0)
  end
end

]]

function buildMap(tilemapFileName, metadataFileName, tilesetFileName, filter1, filter2, tileSize)
	--Load tilemap
	local tilemap, mapWidth, mapHeight = loadTilemap(tilemapFileName)
	--Load metadata
	local metadata = loadMetadata(metadataFileName, mapWidth, mapHeight)
	--Load tileset and spriteBatch data
	local tileset, tilesetSpriteBatch = loadTileset(tilesetFileName, filter1, filter2, tileSize, metadata[11], metadata[12])
	--Render initial map
	tilesetSpriteBatch = updateTilesetSpriteBatch(tilesetSpriteBatch, tileset, tilemap, tileSize, metadata[11], metadata[12], metadata[1], metadata[2])
	
	map = {tilemap, metadata, tileset, tilesetSpriteBatch}
	return map
end







































