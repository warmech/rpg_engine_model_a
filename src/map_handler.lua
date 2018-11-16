function loadTilemap(fileName)
  --open tilemap
  local tilemapFile = io.open(fileName, "r")
  io.input(tilemapFile)
  
  --count number of rows in tilemap
  local row_count = countRows(fileName)
  
  --count number of columns in tilemap
  local column_count = countColumns()

  --jump to start of tilemap file
  tilemapFile:seek("set", 0)

  --read a line and parse to tilemap
  local mapTable = {}

  for row = 1, row_count do
      local line = fromCSV(io.read())
      mapTable[row] = {}
      for column = 1, column_count do
          mapTable[row][column] = line[column]
      end    
  end

  mapWidth = column_count
  mapHeight = row_count
end

function defineMapView()
  mapX = 41.5
  mapY = 44

  widthBuffer = 2
  heightBuffer = 2

  tilesDisplayWidth = (16 + widthBuffer)
  tilesDisplayHeight = (9 + heightBuffer)

  zoomX = 3
  zoomY = 3
end

function loadTileset(fileName, filter1, filter2, tileSize)
  local tilesetFile = love.graphics.newImage(fileName)
  tilesetFile:setFilter(filter1, filter2) -- this "linear filter" removes some artifacts if we were to scale the tiles
  local quadIndex = 1

  for y = 1, (tilesetFile:getHeight() / tileSize) do
    for x = 1, (tilesetFile:getWidth() / tileSize) do
      tileQuads[quadIndex] = love.graphics.newQuad(((x - 1) * tileSize), ((y - 1) * tileSize), tileSize, tileSize, tilesetFile:getWidth(), tilesetFile:getHeight())
    end
  end

  tilesetBatch = love.graphics.newSpriteBatch(tilesetFile, tilesDisplayWidth * tilesDisplayHeight)
 
  updateTilesetBatch()
end

function updateTilesetBatch()
  tilesetBatch:clear()

  for y = 0, tilesDisplayHeight - 1 do
    for x = 0, tilesDisplayWidth - 1 do
      tilesetBatch:add(tileQuads[tonumber(map[y + math.floor(mapY)][x + math.floor(mapX)])], x * tileSize, y * tileSize)
    end
  end
  tilesetBatch:flush()
end


-- central function for moving the map
function moveMap(dx, dy)
  oldMapX = mapX
  oldMapY = mapY
  mapX = math.max(math.min(mapX + dx, mapWidth - tilesDisplayWidth), 1)
  mapY = math.max(math.min(mapY + dy, mapHeight - tilesDisplayHeight), 1)

  -- only update if we actually moved
  if math.floor(mapX) ~= math.floor(oldMapX) or math.floor(mapY) ~= math.floor(oldMapY) then
    updateTilesetBatch()
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













































