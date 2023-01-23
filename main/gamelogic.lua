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

local function get_value_or_self (self, k) return (type(self[k]) == "table") and self[k].GetValue and self[k]:GetValue() or self[k] end
GL.GetExDesc_common = function (self, s, target)
	if s == "low" then return self:power_func(target, 0)
	elseif s == "high" then return self:power_func(target, 1) end
	if string.sub(s, 1, 5) == "user." then
		return get_value_or_self(self.user, string.sub(s, 6))
	elseif string.sub(s, 1, 7) == "target." then
		return get_value_or_self(target,string.sub(s, 8))
	end
	return get_value_or_self(self, s)
end

return GL