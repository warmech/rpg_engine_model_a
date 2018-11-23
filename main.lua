require "/src/data_handler"
require "/src/map_handler"
require "/src/player_obj"
require "/src/character_gfx"
require "/src/input_handler"

--[[
cwd = love.filesystem.getWorkingDirectory()
print()
print("CWD: "..cwd)
]]

function love.load()
    love.window.setMode(768, 432)

    tilemapFileName =   "rpg_engine_model_a/dat/maps/01/map"
    metadataFileName =  "rpg_engine_model_a/dat/maps/01/metadata"
    tilesetFileName =   "dat/maps/01/tileset.png"
    tileSize = 16
    playerName = "Will"
    playerType = "human_m"

    startX = 51.5
    startY = 54

    currentMap = buildMap(tilemapFileName, metadataFileName, tilesetFileName, tileSize, startX, startY)
    --previousMap = currentMap

    playerCharacter = initPlayerObject(playerName, playerType)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    end
end

function love.update(dt)
    mapInputDetect()
    drawPlayerCharacter()
end

function love.draw()
  love.graphics.draw(
    currentMap.tilesetSpriteBatch, 
    math.floor(-(currentMap.metadata.mapMetadata.zoomX) * ((currentMap.metadata.mapMetadata.mapX) % 1) * tileSize), 
    math.floor(-(currentMap.metadata.mapMetadata.zoomY) * ((currentMap.metadata.mapMetadata.mapY) % 1) * tileSize), 
    0, 
    (currentMap.metadata.mapMetadata.zoomX), 
    (currentMap.metadata.mapMetadata.zoomY)
    )

  love.graphics.draw(
    playerCharacter.sprite, 
    playerCharacter.tileset[playerCharacter.gfx.movementState], 
    (playerCharacter.gfx.tileSize * currentMap.metadata.mapMetadata.zoomX) * playerCharacter.gfx.distToCenterX, 
    (playerCharacter.gfx.tileSize * currentMap.metadata.mapMetadata.zoomY) * playerCharacter.gfx.distToCenterY, 
    0, 
    playerCharacter.gfx.zoomX, 
    playerCharacter.gfx.zoomY
    )
  --print("X: "..playerCharacter.gfx.xTilePosition)
  --print("Y: "..playerCharacter.gfx.yTilePosition)
end

