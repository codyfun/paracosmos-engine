GL = {}

local function target_func_common(user, target)
	return target.hp > 0
end

GL.target_funcs = {
	target_self = function (user, target)
		return user == target
	end,
	target_ally = function (user, target)
		return user.enemy == target.enemy and target_func_common(user, target)
	end,
	target_ally_noself = function (user, target)
		return user.enemy == target.enemy and user ~= target and target_func_common(user, target)
	end,
	target_foe = function (user, target)
		return user.enemy ~= target.enemy and target_func_common(user, target)
	end,
}

function GL.float_to_percent(float, is_relative)
	return (float - (is_relative and 1 or 0)) * 100
end
function GL.percent_to_float(percent, is_relative)
	return percent / 100 + (is_relative and 1 or 0)
end

function GL.GetDesc(object)
	return table.sane_call(object, "GetDesc") or object.desc
end

local function get_value(self, k) return table.sane_call(self[k], "GetValue") or self[k] end
function GL.FormatDescField (self, s, target)
    if s == "power_range" then
		local power_min = self:power_func(target, 0)
        local power_max = self:power_func(target, 1)
		if power_min ~= power_max then
			return power_min .. "-" .. power_max
        else
            return power_min
		end
	elseif s == "desc" then return GL.GetDesc(self)
	end
	if string.sub(s, 1, 5) == "user." then
		return get_value(self.user, string.sub(s, 6))
	elseif string.sub(s, 1, 7) == "target." then
		return get_value(target, string.sub(s, 8))
	end
	return get_value(self, s)
end


return GL