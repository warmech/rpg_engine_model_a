function fromCSV (s)
	local t = {}        -- table to collect fields
	local fieldstart = 1
	repeat
		local nexti = string.find(s, ',', fieldstart)
		table.insert(t, string.sub(s, fieldstart, nexti - 1))
		fieldstart = nexti + 1
	until fieldstart > string.len(s)
	return t
end

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

function loadTable(path)
    local tableIn = loadfile(path)
    return tableIn()
end

function openMapFile(fileName, mapWidth, mapHeight)
    --Open map data file
    local mapFile = io.open(fileName, "r")
    io.input(mapFile)
    --Read a row and parse it to map table
    local map = {}
    for row = 1, mapHeight do
        local line = readNumericalCSV(io.read())
        map[row] = {}
        for column = 1, mapWidth do
            map[row][column] = line[column]
        end
    end
    --Close tilemap file
    io.close(mapFile)
    return map
end
    