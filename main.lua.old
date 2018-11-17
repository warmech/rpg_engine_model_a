local map -- stores tiledata
local mapWidth, mapHeight -- width and height in tiles
 
local mapX, mapY -- view x,y in tiles. can be a fractional value like 3.25.
 
local tilesDisplayWidth, tilesDisplayHeight -- number of tiles to show
local zoomX, zoomY
 
local tilesetImage
local tileSize -- size of tiles in pixels
local tileQuads = {} -- parts of the tileset used for different tiles
local tilesetSprite
 
function love.load()
  love.window.setMode(768, 432)
  setupMap()
  setupMapView()
  setupTileset()
end

function fromCSV (s)
  local t = {}        -- table to collect fields
  local fieldstart = 1
  repeat
      local nexti = string.find(s, ',', fieldstart)
      table.insert(t, string.sub(s, fieldstart, nexti-1))
      fieldstart = nexti + 1
  until fieldstart > string.len(s)
  return t
end

function setupMap()

  filename = "01_first_world.tmx"
  map = {}

  --count number of rows in tilemap
  row_count = 0
  for _ in io.lines(filename) do
      row_count = row_count + 1
  end

  --open tilemap
  file = io.open(filename, "r")
  io.input(file)

  --count number of columns in tilemap
  column_count = 0
  line = fromCSV(io.read())
  for key, value in ipairs(line) do
      column_count = column_count + 1
  end

  --jump to start of tilemap file
  file:seek("set", 0)

  --read a line and parse to tilemap
  for row = 1, row_count do
      line = fromCSV(io.read())
      map[row] = {}
      for column = 1, column_count do
          map[row][column] = line[column]
          --print(map[row][column])
      end    
  end

  mapWidth = column_count
  mapHeight = row_count

end
 
function setupMapView()
  mapX = 41.5
  mapY = 44
  tilesDisplayWidth = 18
  tilesDisplayHeight = 11
 
  zoomX = 3
  zoomY = 3
end
 
function setupTileset()
  tilesetImage = love.graphics.newImage("tileset.png")
  tilesetImage:setFilter("nearest", "nearest") -- this "linear filter" removes some artifacts if we were to scale the tiles
  tileSize = 16
 
  -- empty
  tileQuads[1] = love.graphics.newQuad(0 * tileSize, 0 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- mountain
  tileQuads[2] = love.graphics.newQuad(1 * tileSize, 0 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- rockfield
  tileQuads[3] = love.graphics.newQuad(2 * tileSize, 0 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- forest
  tileQuads[4] = love.graphics.newQuad(3 * tileSize, 0 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- town
  tileQuads[5] = love.graphics.newQuad(4 * tileSize, 0 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- cave
  tileQuads[6] = love.graphics.newQuad(5 * tileSize, 0 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- tiled roof
  tileQuads[7] = love.graphics.newQuad(6 * tileSize, 0 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- outer pillars
  tileQuads[8] = love.graphics.newQuad(7 * tileSize, 0 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- light roof
  tileQuads[9] = love.graphics.newQuad(8 * tileSize, 0 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- dark roof
  tileQuads[10] = love.graphics.newQuad(9 * tileSize, 0 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- inner pillars
  tileQuads[11] = love.graphics.newQuad(0 * tileSize, 1 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- upper small spires
  tileQuads[12] = love.graphics.newQuad(1 * tileSize, 1 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- lower small spires
  tileQuads[13] = love.graphics.newQuad(2 * tileSize, 1 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- small spire annex
  tileQuads[14] = love.graphics.newQuad(3 * tileSize, 1 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- upper vines
  tileQuads[15] = love.graphics.newQuad(4 * tileSize, 1 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- lower vines
  tileQuads[16] = love.graphics.newQuad(5 * tileSize, 1 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- vine entrance
  tileQuads[17] = love.graphics.newQuad(6 * tileSize, 1 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
 
  tilesetBatch = love.graphics.newSpriteBatch(tilesetImage, tilesDisplayWidth * tilesDisplayHeight)
 
  updateTilesetBatch()
end
 
function updateTilesetBatch()
  tilesetBatch:clear()

  for y = 0, tilesDisplayHeight - 1 do
    for x = 0, tilesDisplayWidth - 1 do
    
      --print(map[x + math.floor(mapX)][y + math.floor(mapY)])

      --tilesetBatch:add(tileQuads[tonumber(map[x + math.floor(mapX)][y + math.floor(mapY)])], x * tileSize, y * tileSize)
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
 
function love.draw()
  love.graphics.draw(tilesetBatch, math.floor(-zoomX * (mapX % 1) * tileSize), math.floor(-zoomY * (mapY % 1) * tileSize), 0, zoomX, zoomY)
end