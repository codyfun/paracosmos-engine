if not table.copy then --check if already loaded

	function xor(a, b)
		return (not a and not b) or (a and b)
	end

	function table.copy(t, out)
		out = out or {}
		for k, v in pairs(t) do
			out[k] = v
		end
		return out
    end
	
	function table.deepcopy(t, out)
		out = out or {}
        for k, v in pairs(t) do
			if type(v) == "table" then
                out[k] = table.deepcopy(v, out[k])
			else
				out[k] = v
			end
		end
		return out
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
	
	function table.match(t, fn)
		local out = {}
		for k, v in pairs(t) do
			if fn(v) then
				out[k] = v
			end
        end
		return out
    end
	
	function table.invert(t)
		local out = {}
		for k, v in pairs(t) do
			out[v] = k
        end
		return out
	end

	function table.merge(t, t2)
		local out = table.copy(t2)
		for k, v in pairs(t) do
			out[k] = v
		end
		return out
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
        local out = {}
		for k,v in pairs(t) do
			out[k] = fn(v)
        end
		return out
    end
	
    function table.keys(t)
        local out = {}
		for k,v in pairs(t) do
			table.insert(out, k)
        end
		return out
    end
	
	function table.count(t)
		local count = 0
		for k, v in pairs(t) do
			count = count + 1
		end
		return count
    end
	
    function table.sane_call(t, idxs, ...) --safe nested index
		if type(idxs) ~= "table" then
			idxs = {idxs}
		end
		local parent
		for _, idx in ipairs(idxs) do
            if type(t) == "table" then
				parent = t
                t = t[idx]
            elseif type(t) == "function" then
                parent = t
				t = t[idx](parent)
			else
				return nil
			end
        end
		if t then
			return t(parent, ...)
		end
	end

	function math.round(x)
		return math.floor(x + 0.5)
	end

	function math.clamp(x, min, max) --if min > max, return min
		return math.max(math.min(x, max), min)
	end

end
