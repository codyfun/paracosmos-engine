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

return GL