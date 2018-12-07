function love.conf(t)
	t.window.vsync = 1                  -- Vertical sync mode (number)
end


function love.load()
    love.window.setMode(768, 432)
    fileName = "water.png"
    tileSize = 16
    frameCounter = 2

    tilesetPrime, tilesetFilePrime = buildTileset()
    tilesetSpriteBatchPrime = buildSpriteBatch(1)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    end
end

function buildTileset()
    --Create quad table and import the appropriate tileset file
    tileset = {}
    tilesetFile = love.graphics.newImage(fileName)
    --This filter is configurable based upon game settings, but should probably be locked to nearest/nearest
    filter_min = "nearest"
    filter_mag = "nearest"
    tilesetFile:setFilter(filter_min, filter_mag)
    tilesetQuadIndex = 1
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

function buildSpriteBatch(frame)
    --Create a new sprite batch (the viewable area of the map) with the tileset file
    tilesetSpriteBatch = love.graphics.newSpriteBatch(tilesetFilePrime, 1)
    --Clear out the viewable area of the map
    tilesetSpriteBatch:clear()
    --Iterate down the rows of the map tiles displayed on screen
    for y = 0, (0) do
        --Iterate across the columns of the map tiles displayed on screen
        for x = 0, (0) do
            --Write the appropriate tile to the current cell in the sprite batch
            tilesetSpriteBatch:add(tilesetPrime[frame], 0, 0)
        end
    end
    --Send data to GPU
    tilesetSpriteBatch:flush()
    return tilesetSpriteBatch
end

function updateTilesetSpriteBatch()


    --Clear out the viewable area of the map
    tilesetSpriteBatchPrime:clear()

    --Iterate down the rows of the map tiles displayed on screen
    for y = 0, (0) do
        --Iterate across the columns of the map tiles displayed on screen
        for x = 0, (0) do
            --Write the appropriate tile to the current cell in the sprite batch
            tilesetSpriteBatchPrime:add(tilesetPrime[frameCounter], 0, 0)
        end
    end

    --Render data to GPU and return updated map sprite batch
    tilesetSpriteBatchPrime:flush()
end

function love.update(dt)
    updateTilesetSpriteBatch()

    if frameCounter == 17 then
        frameCounter = 2
    else
        frameCounter = frameCounter + 1
    end
end

function love.draw()
    love.graphics.draw(
        tilesetSpriteBatchPrime, 
        20, 
        20, 
        0, 
        3, 
        3
    )
end




--[[
Thoughts...

This works by having a global frame counter that increments every turn and loops back to "one" (frame 2) 
in the tileset. In a more expanded tileset, the numbers will need to be hardcoced into the metadata file 
for the map as to what the transparent tile (frame zero), initial tile (frame one), and final tile (frame 
sixteen) are. There should be a rewrite function that either exists as part of the map handler (best option) 
or gets loaded into the metadata table for that map only (less good). This will mean changing how the game
updates the maps sprite batch. Currently, it only updates if there is movement; this will need to be moved
out of the moveMap routine in the map handler and made part of the general love.update routine. The onscreen
draw area is small enough that this should have no real effect on performance.


function animatedTileRewrite()
    --work goes here
end



]]











