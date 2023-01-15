if not table.copy then --check if already loaded

function table.copy(t)
	local res = {}
	for k,v in pairs(t) do
		res[k] = v
	end
	return res
end

function table.find(t, a)
	for k,v in pairs(t) do
		if a == v then
			return k
		end
	end
end

function table.merge(t, t2)
	local res = table.copy(t2)
	for k,v in pairs(t) do
		res[k] = v
	end
	return res
end

end