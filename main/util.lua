if not array then --check if already loaded
	
    array = {}
    bool = {}
	
    array.insert = table.insert
    array.remove = table.remove
	array.sort = table.sort

	function table.copy(t, out)
		out = out or {}
		for k, v in pairs(t) do
			out[k] = v
		end
		return out
    end
	
	function array.copy(t, out)
		out = out or {}
		for i, v in ipairs(t) do
			array.insert(out, v)
		end
		return out
	end
	
	function table.deepcopy(t, out) --can't handle circular refs, may need a variant with caching or blacklist
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
	
	function table.filter(t, fn)
		local out = {}
		for k, v in pairs(t) do
			if fn(v) then
				out[k] = v
			end
        end
		return out
    end
	
	function array.filter(t, fn)
		local out = {}
		for i, v in ipairs(t) do
			if fn(v) then
				array.insert(out, v)
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
	
	function array.reverse(t)
        local out = {}
		local size = #t
		for i, v in ipairs(t) do
			out[size - i + 1] = v
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
			array.insert(out, k)
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

	function table.sane_get(t, idxs, ...) --safe nested index
		if type(idxs) ~= "table" then
			idxs = {idxs}
		end
		for _, idx in ipairs(idxs) do
			if type(t) == "table" then
				t = t[idx]
			else
				return nil
			end
		end
		if t then
			return t
		end
	end
	
    function table.sane_call(t, idxs, ...)
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

	function bool.xor(a, b)
		return (not a and not b) or (a and b)
    end
	
	function bool.truthy(x)
        if not x then return false
		elseif x == 0 then return false
		elseif x == "" then return false end
		if type(x) == "table" then
			return table.count(x) ~= 0
        end
		return true
	end
	
	function string.firstupper(s)
		return (s:gsub("^%l", string.upper))
	end

	function math.round(x)
		return math.floor(x + 0.5)
	end

	function math.clamp(x, min, max) --if min > max, return min
		return math.max(math.min(x, max), min)
	end

end
