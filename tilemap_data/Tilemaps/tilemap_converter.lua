function readNumericalCSV (s)
    local t = {}        -- table to collect fields
    local fieldstart = 1
    repeat
        local nexti = string.find(s, ',', fieldstart)
        table.insert(t, tonumber(string.sub(s, fieldstart, nexti-1)))
        fieldstart = nexti + 1
    until fieldstart > string.len(s)
    return t
end

function countRows(fileName)
    local row_count = 0
    for _ in io.lines(fileName) do
        row_count = row_count + 1
    end
    return row_count
end

function countColumns(rowData)
    local column_count = (#rowData)
    return column_count
end

--[[
A simple function to print tables or to write tables into files.
Great for debugging but also for data storage.
When writing into files the 'return' keyword will be added automatically,
so the tables can be loaded with 'dofile()' into a variable.
The basic datatypes table, string, number, boolean and nil are supported.
The tables can be nested and have number and string indices.
This function has no protection when writing files without proper permissions and
when datatypes other then the supported ones are used.
--]]

-- t = table
-- f = filename [optional]
function printTable(t, f)

   local function printTableHelper(obj, cnt)

      local cnt = cnt or 0

      if type(obj) == "table" then

         io.write("\n", string.rep("\t", cnt), "{\n")
         cnt = cnt + 1

         for k,v in pairs(obj) do

            if type(k) == "string" then
               io.write(string.rep("\t",cnt), '["'..k..'"]', ' = ')
            end

            if type(k) == "number" then
               io.write(string.rep("\t",cnt), "["..k.."]", " = ")
            end

            printTableHelper(v, cnt)
            io.write(",\n")
         end

         cnt = cnt-1
         io.write(string.rep("\t", cnt), "}")

      elseif type(obj) == "string" then
         io.write(string.format("%q", obj))

      else
         io.write(tostring(obj))
      end 
   end

   if f == nil then
      printTableHelper(t)
   else
      io.output(f)
      io.write("return")
      printTableHelper(t)
      io.output(io.stdout)
   end
end

local bottomFileName = "01/bottom.tmx"
local topFileName = "01/top.tmx"
local collisionFileName = "01/collision.tmx"



--Open tilemap data file
local bottomFile = io.open(bottomFileName, "r")
io.input(bottomFile)

--Count number of rows in tilemap
local rowCount = countRows(bottomFileName)

--Count number of columns in tilemap
local columnCount = countColumns(readNumericalCSV(io.read()))
bottomFile:seek("set", 0)

--Read a row and parse it to map table
local bottom = {}
for row = 1, rowCount do
    local line = readNumericalCSV(io.read())
    bottom[row] = {}
    for column = 1, columnCount do
        bottom[row][column] = line[column]
    end
end
--Close tilemap file
io.close(bottomFile)

--Open tilemap data file
local topFile = io.open(topFileName, "r")
io.input(topFile)

--Count number of rows in tilemap
local rowCount = countRows(topFileName)

--Count number of columns in tilemap
local columnCount = countColumns(readNumericalCSV(io.read()))
topFile:seek("set", 0)

--Read a row and parse it to map table
local top = {}
for row = 1, rowCount do
    local line = readNumericalCSV(io.read())
    top[row] = {}
    for column = 1, columnCount do
        top[row][column] = line[column]
    end
end
--Close tilemap file
io.close(topFile)

--Open tilemap data file
local collisionFile = io.open(collisionFileName, "r")
io.input(collisionFile)

--Count number of rows in tilemap
local rowCount = countRows(collisionFileName)

--Count number of columns in tilemap
local columnCount = countColumns(readNumericalCSV(io.read()))
collisionFile:seek("set", 0)

--Read a row and parse it to map table
local collision = {}
for row = 1, rowCount do
    local line = readNumericalCSV(io.read())
    collision[row] = {}
    for column = 1, columnCount do
        collision[row][column] = line[column]
    end
end
--Close tilemap file
io.close(collisionFile)

map = {bottom = bottom, top = top, collision = collision}
printTable(map, "map.map")





