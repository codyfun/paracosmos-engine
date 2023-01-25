if not table.copy then --check if already loaded

	function xor(a, b)
		return (not a and not b) or (a and b)
	end

	function table.copy(t, target)
		local res = target or {}
		for k, v in pairs(t) do
			res[k] = v
		end
		return res
    end
	
	function table.deepcopy(t)
		local res = {}
        for k, v in pairs(t) do
			if type(v) == "table" then
				res[k] = table.deepcopy(v)
			else
				res[k] = v
			end
		end
		return res
	end

	function table.find(t, v)
		for k, v2 in pairs(t) do
			if v == v2 then
				return k
			end
		end
		return nil
	end

	function table.find_if(t, fn)
		for k, v in pairs(t) do
			if fn(v) then
				return k
			end
		end
		return nil
	end

	function table.merge(t, t2)
		local res = table.copy(t2)
		for k, v in pairs(t) do
			res[k] = v
		end
		return res
	end

	function table.remove_value(t, v)
		local k = table.find(t, v)
		if k then
			if type(k) == "number" then
				return table.remove(t, k)
			else
				table[k] = nil
				return v
			end
		end
		return nil
    end
	
	function table.map(t, fn)
        local res = {}
		for k,v in pairs(t) do
			res[k] = fn(v)
        end
		return res
    end
	
    function table.keys(t)
        local res = {}
		for k,v in pairs(t) do
			table.insert(res, k)
        end
		return res
    end
	
	function table.count(t)
		local res = 0
		for k, v in pairs(t) do
			res = res + 1
		end
		return res
	end

	function math.round(x)
		return math.floor(x + 0.5)
	end

	function math.clamp(x, min, max)
		return math.min(math.max(x, min), max)
	end

end
