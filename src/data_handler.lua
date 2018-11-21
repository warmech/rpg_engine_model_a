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