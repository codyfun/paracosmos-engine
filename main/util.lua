if not table.copy then --check if already loaded

	function xor(a, b)
		return (not a and not b) or (a and b)
	end

	function table.copy(t)
		local res = {}
		for k,v in pairs(t) do
			res[k] = v
		end
		return res
	end

	function table.find(t, v)
		for k,v2 in pairs(t) do
			if v == v2 then
				return k
			end
		end
	end

	function table.find_if(t, fn)
		for k,v in pairs(t) do
			if fn(v) then
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
	
    function table.remove_value(t, v)
		table.remove(t, table.find(t, v))
    end
	
	function math.round(x)
		return math.floor(x + 0.5)
	end

	function math.clamp(x, min, max)
		return math.min(math.max(x, min), max)
	end

end