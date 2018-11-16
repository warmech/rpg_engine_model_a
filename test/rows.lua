function loadTilemap(fileName)
	
	

	--open tilemap
	local tilemapFile = io.open(fileName, "r")
	io.input(tilemapFile)

	local column_count = countColumns()
	local row_count = countRows(fileName)

	print(row_count)
	print(column_count)
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

function countRows(fileName)
	local row_count = 0
	for _ in io.lines(fileName) do
		row_count = row_count + 1
	end
	return row_count
end

function countColumns()
	local column_count = 0
	local firstLine = fromCSV(io.read())
	for key, value in ipairs(firstLine) do
		column_count = column_count + 1
	end
	return column_count
end


loadTilemap("01_first_world.tmx")
