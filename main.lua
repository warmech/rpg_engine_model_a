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

    dofile("rpg_engine_model_a/dat/init/control.init")

    mapNumber = "09"
    --mapNumber = "01"
    tileSize = 16
    playerName = "Will"
    playerType = "human_m"

    startX = 42.5
    startY = 27
    --startX = 53.5
    --startY = 54

    currentMap = buildMap(mapNumber, startX, startY)

    playerCharacter = initPlayerObject(playerName, playerType)

    playerCharacter.gfx.xTilePosition = currentMap.metadata.mapX + playerCharacter.gfx.distToCenterX
    playerCharacter.gfx.yTilePosition = currentMap.metadata.mapY + playerCharacter.gfx.distToCenterY
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
    --Iterator for drawing the map and sprite objects
    for i = 1, currentMap.metadata.mapDrawLayers do
        if (currentMap.metadata.mapDrawOrder[i] == "bottomLayer") then
            --Draw Bottom Layer
            love.graphics.draw(
                currentMap.layers.bottom, 
                math.floor(-(currentMap.metadata.zoomX) * ((currentMap.metadata.mapX) % 1) * tileSize), 
                math.floor(-(currentMap.metadata.zoomY) * ((currentMap.metadata.mapY) % 1) * tileSize), 
                0, 
                (currentMap.metadata.zoomX), 
                (currentMap.metadata.zoomY)
            )
        elseif (currentMap.metadata.mapDrawOrder[i] == "spriteLayer") then
            --Draw character sprite
            love.graphics.draw(
                playerCharacter.sprite, 
                playerCharacter.tileset[playerCharacter.gfx.movementState], 
                (playerCharacter.gfx.tileSize * currentMap.metadata.zoomX) * playerCharacter.gfx.distToCenterX, 
                (playerCharacter.gfx.tileSize * currentMap.metadata.zoomY) * playerCharacter.gfx.distToCenterY, 
                0, 
                playerCharacter.gfx.zoomX, 
                playerCharacter.gfx.zoomY
            )
        elseif (currentMap.metadata.mapDrawOrder[i] == "topLayer") then
            --Draw Top Layer
            love.graphics.draw(
                currentMap.layers.top, 
                math.floor(-(currentMap.metadata.zoomX) * ((currentMap.metadata.mapX) % 1) * tileSize), 
                math.floor(-(currentMap.metadata.zoomY) * ((currentMap.metadata.mapY) % 1) * tileSize), 
                0, 
                (currentMap.metadata.zoomX), 
                (currentMap.metadata.zoomY)
            )
        end
    end   
end