local gamelogic = {}

gamelogic.TARGET_SELF = hash"target_self"
gamelogic.TARGET_ALLY = hash"target_ally"
gamelogic.TARGET_ALLY_NOSELF = hash"target_ally_noself"
gamelogic.TARGET_FOE = hash"target_foe"

local function target_func_common(user, target)
	return target.hp > 0
end

gamelogic.target_funcs = {
	[gamelogic.TARGET_SELF] = function (user, target)
		return user == target
	end,
	[gamelogic.TARGET_ALLY] = function (user, target)
		return user.enemy == target.enemy and target_func_common(user, target)
	end,
	[gamelogic.TARGET_ALLY_NOSELF] = function (user, target)
		return user.enemy == target.enemy and user ~= target and target_func_common(user, target)
	end,
	[gamelogic.TARGET_FOE] = function (user, target)
		return user.enemy ~= target.enemy and target_func_common(user, target)
	end,
}

local function get_value_or_self (self, k) return (type(self[k]) == "table") and self[k].GetValue and self[k]:GetValue() or self[k] end
gamelogic.GetExDesc_common = function (self, s, target)
	if s == "low" then return self:power_func(target, 0)
	elseif s == "high" then return self:power_func(target, 1) end
	if string.sub(s, 1, 5) == "user." then
		return get_value_or_self(self.user, string.sub(s, 6))
	elseif string.sub(s, 1, 7) == "target." then
		return get_value_or_self(target,string.sub(s, 8))
	end
	return get_value_or_self(self, s)
end

return gamelogic