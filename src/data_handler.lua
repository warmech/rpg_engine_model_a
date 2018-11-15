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