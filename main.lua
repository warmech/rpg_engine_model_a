require "/src/data_handler"
require "/src/map_handler"

--[[
cwd = love.filesystem.getWorkingDirectory()
print()
print("CWD: "..cwd)
]]

function love.load()
  love.window.setMode(768, 432)
end

tilemapFileName = "rpg_engine_model_a/dat/maps/01_first_world.map"
metadataFileName = "rpg_engine_model_a/dat/init/mapView_init.dat"
tilesetFileName = "gfx/tile/tileset_overworld.png"
tileSize = 16

map_01 = buildMap(tilemapFileName, metadataFileName, tilesetFileName, tileSize)


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
  love.graphics.draw(map_01[4], math.floor(-(map_01[2][7]) * ((map_01[2][1]) % 1) * tileSize), math.floor(-(map_01[2][8]) * ((map_01[2][2]) % 1) * tileSize), 0, (map_01[2][7]), (map_01[2][8]))
end

