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
filter1 = "nearest"
filter2 = "nearest"
tileSize = 16

map_01 = buildMap(tilemapFileName, metadataFileName, tilesetFileName, filter1, filter2, tileSize)

function love.draw()
  love.graphics.draw(map_01[4], math.floor(-(map_01[2][7]) * ((map_01[2][1]) % 1) * tileSize), math.floor(-(map_01[2][8]) * ((map_01[2][2]) % 1) * tileSize), 0, (map_01[2][7]), (map_01[2][8]))
end