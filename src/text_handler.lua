function selectFont()
	love.graphics.setDefaultFilter("nearest","nearest")
	local fontPath = "/gfx/font/text_std_vwf_main.png"
	local font = love.graphics.newImageFont(fontPath," ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!\',.-?@#$%&*()_+=~<>{}`|/")
	love.graphics.setFont(font)
end

function buildTextbox(startX, startY, width, height)

    local function buildTileset(fileName, _tileSize)
        --Create quad table and import the appropriate tileset file
        local tileset = {}
        local tilesetFile = love.graphics.newImage(fileName)
        --This filter is configurable based upon game settings, but should probably be locked to nearest/nearest
        local filter_min = "nearest"
        local filter_mag = "nearest"
        tilesetFile:setFilter(filter_min, filter_mag)
        local tilesetQuadIndex = 1
        --Iterate down the tileset's rows by multiples of tileSize pixels (16 is default)
        for y = 1, (tilesetFile:getHeight() / _tileSize) do
            --Iterate across the tileset's columns by multiples of tileSize pixels (16 is default)
            for x = 1, (tilesetFile:getWidth() / _tileSize) do
                --Read the (tileSize * tileSize) pixel group at ((x - 1) * tileSize), ((y - 1) * tileSize) into a new quad
                tileset[tilesetQuadIndex] = love.graphics.newQuad(((x - 1) * _tileSize), ((y - 1) * _tileSize), _tileSize, _tileSize, tilesetFile:getWidth(), tilesetFile:getHeight())
                tilesetQuadIndex = tilesetQuadIndex + 1
            end
        end
        return tileset, tilesetFile
    end

    local function buildSpriteBatch(tileset, tilesetFile, textboxTable, _tileSize)
        --Create a new sprite batch the size fo the textbox with the tileset file
        local tilesetSpriteBatch = love.graphics.newSpriteBatch(tilesetFile, width * height)
        --Clear out the textbox canvas
        tilesetSpriteBatch:clear()
        --Iterate down the rows of the textbox
        for y = 0, (height - 1) do
            --Iterate across the columns of the textbox
            for x = 0, (width - 1) do
                --Write the appropriate tile to the current cell in the sprite batch
                tilesetSpriteBatch:add(tileset[(textboxTable[y + 1][x + 1])], x * _tileSize, y * _tileSize)
            end
        end
        --Send data to GPU
        tilesetSpriteBatch:flush()
        return tilesetSpriteBatch
    end

    local function buildTextboxTable(width, height)
        --Build textbox table and populate borders and body with corresponding tile IDs
        local textboxTable = {}
        for y = 1, height do
            textboxTable[y] = {}
            for x = 1, width do
                if (y == 1 and x == 1) then
                    --Upper-Left Corner
                    textboxTable[y][x] = 1
                elseif (y == 1 and x > 1 and x < width) then
                    --Upper Border
                    textboxTable[y][x] = 6
                elseif (y == 1 and x == width) then
                    --Upper-Right Corner
                    textboxTable[y][x] = 2
                elseif (y > 1 and y < height and x == 1) then
                    --Left Border
                    textboxTable[y][x] = 7
                elseif (y > 1 and y < height and x > 1 and x < width) then
                    --Whitespace
                    textboxTable[y][x] = 9
                elseif (y > 1 and y < height and x == width) then
                    --Right Border
                    textboxTable[y][x] = 5
                elseif (y == height and x == 1) then
                    --Lower-Left Corner
                    textboxTable[y][x] = 3
                elseif (y == height and x > 1 and x < width) then
                    --Lower Border
                    textboxTable[y][x] = 8
                elseif (y == height and x == width) then
                    --Lower-Right Corner
                    textboxTable[y][x] = 4
                end
            end
        end

        return textboxTable
    end

    --Declare file name for tileset image and declare the tile size
    local tilesetFileName = "gfx/font/text_box.png"
    local _tileSize = 8

    --Build tileset, sprite batch, and textbox object
    local tileset, tilesetFile = buildTileset(tilesetFileName, _tileSize)
    local textboxTable = buildTextboxTable(width, height)
    local boxLayer = buildSpriteBatch(tileset, tilesetFile, textboxTable, _tileSize)
    local textbox = {tileset = tileset, boxLayer = boxLayer, startX = startX, startY = startY}

    return textbox
end

function advanceText(dt)
    text.metadata.timer = text.metadata.timer + dt
    while text.metadata.timer > text.metadata.speed do
        text.metadata.iterator = text.metadata.iterator + 1
        text.metadata.timer = text.metadata.timer - text.metadata.speed
    end
end

function drawText()
    love.graphics.scale(3)
    local textSegment = sampleText:sub(1, text.metadata.iterator)
    love.graphics.print(textSegment, 10, 10)
end

















