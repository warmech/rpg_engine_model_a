function buildMap(tilemapFileName, metadataFileName, tilesetFileName, tileSize)
	--Open tilemap data file
	local tilemapFile = io.open(tilemapFileName, "r")
	io.input(tilemapFile)

	--Count number of rown in tilemap
	local mapHeight = countRows(tilemapFileName)

	--Count number of columns in tilemap
	local mapWidth = countColumns(fromCSV(io.read()))
	tilemapFile:seek("set", 0)

	--Read a row and parse it to map table
	local mapTable = {}
	for row = 1, mapHeight do
			local line = fromCSV(io.read())
			mapTable[row] = {}
			for column = 1, mapWidth do
				mapTable[row][column] = line[column]
			end
	end
	
	--Close tilemap file
	io.close(tilemapFile)

	--Open metadata file and parse it to the metadata table
	local metadataFile = io.open(metadataFileName, "r")
	io.input(metadataFile)
	local mapMetadata = fromCSV(io.read())
	
	--Append map size (in tiles) to table
	table.insert(mapMetadata, mapWidth)
	table.insert(mapMetadata, mapHeight)
	
	--Append tilesDisplayWidth and tilesDisplayHeight to table
    local mapX = mapMetadata[1]
    local mapY = mapMetadata[2]
	local tilesDisplayWidth = (mapMetadata[3] + mapMetadata[5])
	local tilesDisplayHeight = (mapMetadata[4] + mapMetadata[6])
    local zoomX = mapMetadata[7]
    local zoomY = mapMetadata[8]

	table.insert(mapMetadata, tilesDisplayWidth)
	table.insert(mapMetadata, tilesDisplayHeight)
	
	--Close metadata file
	io.close(metadataFile)

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
	local tilesetSpriteBatch = love.graphics.newSpriteBatch(tilesetFile, tilesDisplayWidth * tilesDisplayHeight)

	--Clear out the viewable area of the map
	tilesetSpriteBatch:clear()

	--Iterate down the rows of the map tiles displayed on screen
	for y = 0, (tilesDisplayHeight - 1) do
		--Iterate across the columns of the map tiles displayed on screen
		for x = 0, (tilesDisplayWidth - 1) do
			--Write the appropriate tile to the current cell in the sprite batch
			tilesetSpriteBatch:add(tilesetQuads[tonumber(mapTable[y + math.floor(mapY)][x + math.floor(mapX)])], x * tileSize, y * tileSize)
		end
	end

	--Send data to GPU
	tilesetSpriteBatch:flush()

	--Compile and return map object
	mapObject = {mapTable, mapMetadata, tilesetQuads, tilesetSpriteBatch}
	return mapObject
end

function updateTilesetSpriteBatch()
    --Clear out the viewable area of the map
    --tilesetSpriteBatch:clear()
    map_01[4]:clear()

    --Iterate down the rows of the map tiles displayed on screen
    --for y = 0, (tilesDisplayHeight - 1) do
    for y = 0, (map_01[2][12] - 1) do
        --Iterate across the columns of the map tiles displayed on screen
        --for x = 0, (tilesDisplayWidth - 1) do
        for x = 0, (map_01[2][11] - 1) do
            --Write the appropriate tile to the current cell in the sprite batch
            --tilesetSpriteBatch:add(tilesetQuads[tonumber(mapTable[y + math.floor(mapY)][x + math.floor(mapX)])], x * tileSize, y * tileSize)
            map_01[4]:add(map_01[3][tonumber(map_01[1][y + math.floor(map_01[2][2])][x + math.floor(map_01[2][1])])], x * 16, y * 16)
        end
    end

    --Render data to GPU and return updated map sprite batch
    map_01[4]:flush()

end

-- central function for moving the map
function moveMap(dx, dy)
    local oldMapX = map_01[2][1]
    local oldMapY = map_01[2][2]
    map_01[2][1] = math.max(math.min(map_01[2][1] + dx, map_01[2][9] - map_01[2][11]), 1)
    map_01[2][2] = math.max(math.min(map_01[2][2] + dy, map_01[2][10] - map_01[2][12]), 1)

    -- only update if we actually moved
    if math.floor(map_01[2][1]) ~= math.floor(oldMapX) or math.floor(map_01[2][2]) ~= math.floor(oldMapY) then
        updateTilesetSpriteBatch()
    end
end

--[[
function updateTilesetSpriteBatch()
	--Clear out the viewable area of the map
	tilesetSpriteBatch:clear()

	--Iterate down the rows of the map tiles displayed on screen
	for y = 0, (tilesDisplayHeight - 1) do
		--Iterate across the columns of the map tiles displayed on screen
		for x = 0, (tilesDisplayWidth - 1) do
			--Write the appropriate tile to the current cell in the sprite batch
			tilesetSpriteBatch:add(tilesetQuads[tonumber(mapTable[y + math.floor(mapY)][x + math.floor(mapX)])], x * tileSize, y * tileSize)
		end
	end

	--Render data to GPU and return updated map sprite batch
	tilesetSpriteBatch:flush()
	return tilesetSpriteBatch
end

-- central function for moving the map
function moveMap(dx, dy)
	local oldMapX = mapX
	local oldMapY = mapY
	mapX = math.max(math.min(mapX + dx, mapWidth - tilesDisplayWidth), 1)
	mapY = math.max(math.min(mapY + dy, mapHeight - tilesDisplayHeight), 1)

	-- only update if we actually moved
	if math.floor(mapX) ~= math.floor(oldMapX) or math.floor(mapY) ~= math.floor(oldMapY) then
		updateTilesetSpriteBatch(tilesetSpriteBatch, tilesetQuads, tilemap, tileSize, tilesDisplayWidth, tilesDisplayHeight, mapX, mapY)
	end
end
]]






































