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

function serialize(object, multiline, depth, name)
    --Credit for this serialization function goes to Vadim at https://yal.cc
    --also known as yellowafterlife. He may be reached at yellowafterlife@hotmail.com
    --or @yellowafterlife
    depth = depth or 0
    if multiline == nil then multiline = true end
    local padding = string.rep('    ', depth) -- can use '\t' if printing to file
    local r = padding -- result string
    if name then -- should start from name
        r = r .. (
            -- enclose in brackets if not string or not a valid identifier
            -- thanks to Boolsheet from #love@irc.oftc.net for string pattern
            (type(name) ~= 'string' or name:find('^([%a_][%w_]*)$') == nil)
            and ('[' .. (
                (type(name) == 'string')
                and string.format('%q', name)
                or tostring(name))
                .. ']')
            or tostring(name)) .. ' = '
    end
    if type(object) == 'table' then
        r = r .. '{' .. (multiline and '\n' or ' ')
        local length = 0
        for i, v in ipairs(object) do
            r = r .. serialize(v, multiline, multiline and (depth + 1) or 0) .. ','
                .. (multiline and '\n' or ' ')
            length = i
        end
        for i, v in pairs(object) do
            local itype = type(i) -- convert type into something easier to compare:
            itype =(itype == 'number') and 1
                or (itype == 'string') and 2
                or (itype == 'boolean') and 3
                or error('Serialize: Unsupported index type "' .. itype .. '"')
            local skip = -- detect if item should be skipped
                ((itype == 1) and ((i % 1) == 0) and (i >= 1) and (i <= length)) -- ipairs part
                or ((itype == 2) and (string.sub(i, 1, 1) == '_')) -- prefixed string
            if not skip then
                r = r .. serialize(v, multiline, multiline and (depth + 1) or 0, i) .. ','
                    .. (multiline and '\n' or ' ')
            end
        end
        r = r .. (multiline and padding or '') .. '}'
    elseif type(object) == 'string' then
        r = r .. string.format('%q', object)
    elseif type(object) == 'number' or type(object) == 'boolean' then
        r = r .. tostring(object)
    else
        error('Unserializeable value "' .. tostring(object) .. '"')
    end
    return r
end