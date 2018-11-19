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

    tilemapFileName = "rpg_engine_model_a/dat/maps/01_first_world.map"
    metadataFileName = "rpg_engine_model_a/dat/init/mapView_init.dat"
    tilesetFileName = "gfx/tile/tileset_overworld.png"
    tileSize = 16
    playerName = "Will"
    playerType = "human_m"

    currentMap = buildMap(tilemapFileName, metadataFileName, tilesetFileName, tileSize)

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
    math.floor(-(currentMap.metadata.zoomX) * ((currentMap.metadata.mapX) % 1) * tileSize), 
    math.floor(-(currentMap.metadata.zoomY) * ((currentMap.metadata.mapY) % 1) * tileSize), 
    0, 
    (currentMap.metadata.zoomX), 
    (currentMap.metadata.zoomY)
    )

  love.graphics.draw(
    playerCharacter.sprite, 
    playerCharacter.tileset[playerCharacter.gfx.movementState], 
    (playerCharacter.gfx.tileSize * currentMap.metadata.zoomX) * playerCharacter.gfx.distToCenterX, 
    (playerCharacter.gfx.tileSize * currentMap.metadata.zoomY) * playerCharacter.gfx.distToCenterY, 
    0, 
    playerCharacter.gfx.zoomX, 
    playerCharacter.gfx.zoomY
    )
  print("X: "..playerCharacter.gfx.xTilePosition)
  print("Y: "..playerCharacter.gfx.yTilePosition)
end

