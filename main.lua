require "/src/data_handler"
require "/src/map_handler"
require "/src/player_obj"
require "/src/character_gfx"

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



--[[
function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    elseif key == "up" then
        if((playerCharacter.gfx.movementState % 2) == 1) then
            playerCharacter.gfx.movementState = 7
        else
            playerCharacter.gfx.movementState = 8
        end
    elseif key == "down" then
        if((playerCharacter.gfx.movementState % 2) == 1) then
            playerCharacter.gfx.movementState = 1
        else
            playerCharacter.gfx.movementState = 2
        end
    elseif key == "left" then
        if((playerCharacter.gfx.movementState % 2) == 1) then
            playerCharacter.gfx.movementState = 5
        else
            playerCharacter.gfx.movementState = 6
        end
    elseif key == "right" then
        if((playerCharacter.gfx.movementState % 2) == 1) then
            playerCharacter.gfx.movementState = 3
        else
            playerCharacter.gfx.movementState = 4
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")

    elseif key == "up" then
        if playerCharacter.gfx.movementLockout == false then
            if((playerCharacter.gfx.movementState % 2) == 1) then
                playerCharacter.gfx.movementState = 7
            else
                playerCharacter.gfx.movementState = 8
            end
            playerCharacter.gfx.movementLockout = true
            playerCharacter.gfx.xDelta = 0
            playerCharacter.gfx.yDelta = -0.0625
        end
    elseif key == "down" then
        if playerCharacter.gfx.movementLockout == false then
            if((playerCharacter.gfx.movementState % 2) == 1) then
                playerCharacter.gfx.movementState = 1
            else
                playerCharacter.gfx.movementState = 2
            end
            playerCharacter.gfx.movementLockout = true
            playerCharacter.gfx.xDelta = 0
            playerCharacter.gfx.yDelta = 0.0625
        end
    elseif key == "left" then
        if playerCharacter.gfx.movementLockout == false then
            if((playerCharacter.gfx.movementState % 2) == 1) then
                playerCharacter.gfx.movementState = 5
            else
                playerCharacter.gfx.movementState = 6
            end
            playerCharacter.gfx.movementLockout = true
            playerCharacter.gfx.xDelta = -0.0625
            playerCharacter.gfx.yDelta = 0
        end
    elseif key == "right" then
        if playerCharacter.gfx.movementLockout == false then
            if((playerCharacter.gfx.movementState % 2) == 1) then
                playerCharacter.gfx.movementState = 3
            else
                playerCharacter.gfx.movementState = 4
            end
            playerCharacter.gfx.movementLockout = true
            playerCharacter.gfx.xDelta = 0.0625
            playerCharacter.gfx.yDelta = 0
        end
    end
end

function love.update(dt)
    if playerCharacter.gfx.movementLockout == true then
        if playerCharacter.gfx.movementCurrentDuration == playerCharacter.gfx.movementMaxDuration then
            moveTileMap()
            playerCharacter.gfx.movementCurrentDuration = 1
            playerCharacter.gfx.movementLockout = false
        else
            moveTileMap()
            playerCharacter.gfx.movementCurrentDuration = playerCharacter.gfx.movementCurrentDuration + 1
        end
    end

    drawPlayerCharacter()
end
]]

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    end
end

function love.update(dt)
    if love.keyboard.isDown("up")  then
        if playerCharacter.gfx.movementLockout == false then
            if((playerCharacter.gfx.movementState % 2) == 1) then
                playerCharacter.gfx.movementState = 7
            else
                playerCharacter.gfx.movementState = 8
            end
            playerCharacter.gfx.movementLockout = true
            playerCharacter.gfx.xDelta = 0
            playerCharacter.gfx.yDelta = -0.0625
        end
    end

    if love.keyboard.isDown("down")  then
        if playerCharacter.gfx.movementLockout == false then
            if((playerCharacter.gfx.movementState % 2) == 1) then
                playerCharacter.gfx.movementState = 1
            else
                playerCharacter.gfx.movementState = 2
            end
            playerCharacter.gfx.movementLockout = true
            playerCharacter.gfx.xDelta = 0
            playerCharacter.gfx.yDelta = 0.0625
        end
    end

    if love.keyboard.isDown("left")  then
        if playerCharacter.gfx.movementLockout == false then
            if((playerCharacter.gfx.movementState % 2) == 1) then
                playerCharacter.gfx.movementState = 5
            else
                playerCharacter.gfx.movementState = 6
            end
            playerCharacter.gfx.movementLockout = true
            playerCharacter.gfx.xDelta = -0.0625
            playerCharacter.gfx.yDelta = 0
        end
    end

    if love.keyboard.isDown("right")  then
        if playerCharacter.gfx.movementLockout == false then
            if((playerCharacter.gfx.movementState % 2) == 1) then
                playerCharacter.gfx.movementState = 3
            else
                playerCharacter.gfx.movementState = 4
            end
            playerCharacter.gfx.movementLockout = true
            playerCharacter.gfx.xDelta = 0.0625
            playerCharacter.gfx.yDelta = 0
        end
    end

    if playerCharacter.gfx.movementLockout == true then
        if playerCharacter.gfx.movementCurrentDuration == playerCharacter.gfx.movementMaxDuration then
            moveTileMap()
            playerCharacter.gfx.movementCurrentDuration = 1
            playerCharacter.gfx.movementLockout = false
        else
            moveTileMap()
            playerCharacter.gfx.movementCurrentDuration = playerCharacter.gfx.movementCurrentDuration + 1
        end
    end

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

  --print("State: "..playerCharacter.gfx.movementState)
  --print("Counter: "..playerCharacter.gfx.movementCounter)


end

