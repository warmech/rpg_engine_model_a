 function buildMap(mapNumber, startX, startY)

    local function buildTileset(fileName)
        --Create quad table and import the appropriate tileset file
        local tileset = {}
        local tilesetFile = love.graphics.newImage(fileName)
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
                tileset[tilesetQuadIndex] = love.graphics.newQuad(((x - 1) * tileSize), ((y - 1) * tileSize), tileSize, tileSize, tilesetFile:getWidth(), tilesetFile:getHeight())
                tilesetQuadIndex = tilesetQuadIndex + 1
            end
        end
        return tileset, tilesetFile
    end

    local function buildSpriteBatch(layer)
        --Create a new sprite batch (the viewable area of the map) with the tileset file
        local tilesetSpriteBatch = love.graphics.newSpriteBatch(tilesetFile, metadata.tilesDisplayWidth * metadata.tilesDisplayHeight)
        --Clear out the viewable area of the map
        tilesetSpriteBatch:clear()
        --Iterate down the rows of the map tiles displayed on screen
        for y = 0, (metadata.tilesDisplayHeight - 1) do
            --Iterate across the columns of the map tiles displayed on screen
            for x = 0, (metadata.tilesDisplayWidth - 1) do
                --Write the appropriate tile to the current cell in the sprite batch
                tilesetSpriteBatch:add(tileset[(layer[y + math.floor(metadata.mapY)][x + math.floor(metadata.mapX)])], x * tileSize, y * tileSize)
            end
        end
        --Send data to GPU
        tilesetSpriteBatch:flush()
        return tilesetSpriteBatch
    end

    --Declare file names for data files
    local metadataFileName = "rpg_engine_model_a/dat/maps/"..mapNumber.."/metadata.dat"
    local tilemapBottomLayer = "rpg_engine_model_a/dat/maps/"..mapNumber.."/tilemap_bottom_layer.map"
    local tilemapTopLayer = "rpg_engine_model_a/dat/maps/"..mapNumber.."/tilemap_top_layer.map"
    local tilemapCollisionLayer = "rpg_engine_model_a/dat/maps/"..mapNumber.."/tilemap_collision_layer.map"
    local tilesetFileName = "dat/maps/"..mapNumber.."/tileset.png"

    --Load tilemap metadata file
    local metadata = loadTable(metadataFileName)
    metadata.mapX = startX
    metadata.mapY = startY

    --Load tilemap layer files
    local tilemap = 
    {
        bottom = openMapFile(tilemapBottomLayer, metadata.mapWidth, metadata.mapHeight),
        top = openMapFile(tilemapTopLayer, metadata.mapWidth, metadata.mapHeight),
        collision = openMapFile(tilemapCollisionLayer, metadata.mapWidth, metadata.mapHeight)
    }

    tileset, tilesetFile = buildTileset(tilesetFileName)

    layers = 
    {
        bottom = buildSpriteBatch(tilemap.bottom),
        top = buildSpriteBatch(tilemap.top)
    }

    local mapObject = {tilemap = tilemap, metadata = metadata, tileset = tileset, layers = layers}
    return mapObject
end

function updateTilesetSpriteBatch()
    --Clear out the viewable area of the map
    currentMap.layers.bottom:clear()
    currentMap.layers.top:clear()

    --Iterate down the rows of the map tiles displayed on screen
    for y = 0, (currentMap.metadata.tilesDisplayHeight - 1) do
        --Iterate across the columns of the map tiles displayed on screen
        for x = 0, (currentMap.metadata.tilesDisplayWidth - 1) do
            --Write the appropriate tile to the current cell in the sprite batch
            currentMap.layers.bottom:add(currentMap.tileset[currentMap.tilemap.bottom[y + math.floor(currentMap.metadata.mapY)][x + math.floor(currentMap.metadata.mapX)]], x * tileSize, y * tileSize)
            currentMap.layers.top:add(currentMap.tileset[currentMap.tilemap.top[y + math.floor(currentMap.metadata.mapY)][x + math.floor(currentMap.metadata.mapX)]], x * tileSize, y * tileSize)
        end
    end

    --Render data to GPU and return updated map sprite batch
    currentMap.layers.bottom:flush()
    currentMap.layers.top:flush()
end

function moveMap()
    local oldMapX = currentMap.metadata.mapX
    local oldMapY = currentMap.metadata.mapY
    currentMap.metadata.mapX = math.max(math.min(currentMap.metadata.mapX + playerCharacter.gfx.xDelta, currentMap.metadata.mapWidth - currentMap.metadata.tilesDisplayWidth + currentMap.metadata.mapBoundaryOffset), 1)
    currentMap.metadata.mapY = math.max(math.min(currentMap.metadata.mapY + playerCharacter.gfx.yDelta, currentMap.metadata.mapHeight - currentMap.metadata.tilesDisplayHeight + currentMap.metadata.mapBoundaryOffset), 1)

    -- only update if we actually moved
    if math.floor(currentMap.metadata.mapX) ~= math.floor(oldMapX) or math.floor(currentMap.metadata.mapY) ~= math.floor(oldMapY) then
        updateTilesetSpriteBatch()
    end
end





function tileAnimate()
    -- body
    
end

function preCollisionMovementCheck(direction)
    --Check if tile is impassable (tile type 1)
    if direction == 1 then
        return false
    else
        return true
    end
end

function preCollisionAction()
    -- body
end


function postCollisionAction()
    --Do nothing if the tile is normal (tile type 0)

    --Do nothing if the tile is impassable (tile type 1) - this is handled by preCollisionMovementCheck()

    --Check if tile is a door/teleporter (tile type 2)
    print("Tile: "..currentMap.tilemap.collision[playerCharacter.gfx.yTilePosition][playerCharacter.gfx.xTilePosition])
    print("X: "..playerCharacter.gfx.xTilePosition)
    print("Y: "..playerCharacter.gfx.yTilePosition)

    if (currentMap.tilemap.collision[playerCharacter.gfx.yTilePosition][playerCharacter.gfx.xTilePosition] == 2) then
       for i = 1, (#currentMap.metadata.doorMetadata) do
            if (currentMap.metadata.doorMetadata[i].originX == playerCharacter.gfx.xTilePosition) then
                if (currentMap.metadata.doorMetadata[i].originY == playerCharacter.gfx.yTilePosition) then

                    newMapDestX = currentMap.metadata.doorMetadata[i].destX
                    newMapDestY = currentMap.metadata.doorMetadata[i].destY

                    newMapDrawX = (newMapDestX - 7.5)
                    newMapDrawY = (newMapDestY - 4)

                    currentMap = buildMap(currentMap.metadata.doorMetadata[i].destMap, newMapDrawX, newMapDrawY)

                    playerCharacter.gfx.xTilePosition = currentMap.metadata.mapX + playerCharacter.gfx.distToCenterX
                    playerCharacter.gfx.yTilePosition = currentMap.metadata.mapY + playerCharacter.gfx.distToCenterY
                    
                    playerCharacter.gfx.upTile = currentMap.tilemap.collision[newMapDestY - 1][newMapDestX]
                    playerCharacter.gfx.rightTile = currentMap.tilemap.collision[newMapDestY][newMapDestX + 1]
                    playerCharacter.gfx.downTile = currentMap.tilemap.collision[newMapDestY + 1][newMapDestX]
                    playerCharacter.gfx.leftTile = currentMap.tilemap.collision[newMapDestY][newMapDestX - 1]

                    break
                end
            end
        end 
    end

    --Check if tile is searchable by the player (tile type 3)

    --Check if tile is a room transformation tile (tile type 4)
    if (currentMap.tilemap.collision[playerCharacter.gfx.yTilePosition][playerCharacter.gfx.xTilePosition] == 4) then
        for i = 1, (#currentMap.metadata.specialTileTable.script) do
            if (currentMap.metadata.specialTileTable.y[i] == playerCharacter.gfx.yTilePosition) then
                if (currentMap.metadata.specialTileTable.x[i] == playerCharacter.gfx.xTilePosition) then
                    local xformScript = "rpg_engine_model_a/dat/maps/"..currentMap.metadata.mapNumber.."/xform_"..currentMap.metadata.specialTileTable.script[i]..".script"
                    dofile(xformScript)
                    break
                end
            end
        end
    end

    --Check if the tile is an event tile (tile type 5)
    if (currentMap.tilemap.collision[playerCharacter.gfx.yTilePosition][playerCharacter.gfx.xTilePosition] == 5) then
        for i = 1, (#currentMap.metadata.specialTileTable.script) do
            if (currentMap.metadata.specialTileTable.y[i] == playerCharacter.gfx.yTilePosition) then
                if (currentMap.metadata.specialTileTable.x[i] == playerCharacter.gfx.xTilePosition) then
                    local eventScript = "rpg_engine_model_a/dat/maps/"..currentMap.metadata.mapNumber.."/event_"..currentMap.metadata.specialTileTable.script[i]..".script"
                    dofile(eventScript)
                    break
                end
            end
        end
    end

    --Check if tile is an elevation switch (tile type 6)
    if (currentMap.tilemap.collision[playerCharacter.gfx.yTilePosition][playerCharacter.gfx.xTilePosition] == 6) then
        for i = 1, (#currentMap.metadata.specialTileTable.script) do
            if (currentMap.metadata.specialTileTable.y[i] == playerCharacter.gfx.yTilePosition) then
                if (currentMap.metadata.specialTileTable.x[i] == playerCharacter.gfx.xTilePosition) then
                    local elevateScript = "rpg_engine_model_a/dat/maps/"..currentMap.metadata.mapNumber.."/elevation_"..currentMap.metadata.specialTileTable.script[i]..".script"
                    dofile(elevateScript)
                    break
                end
            end
        end
    end

    --Check if tile is a damage-dealing tile (tile type 7)

    --Check if tile one-way travel tile (tile type 8)

    --Check if tile partial obfuscation tile (tile type 9)

end


