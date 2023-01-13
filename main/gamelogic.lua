local gamelogic = {}

gamelogic.TARGET_SELF = hash"target_self"
gamelogic.TARGET_ALLY = hash"target_ally"
gamelogic.TARGET_ALLY_NOSELF = hash"target_ally_noself"
gamelogic.TARGET_FOE = hash"target_foe"

gamelogic.target_funcs = {
	[gamelogic.TARGET_SELF] = function (user, target)
		return user == target
	end,
	[gamelogic.TARGET_ALLY] = function (user, target)
		return user.enemy == target.enemy
	end,
	[gamelogic.TARGET_ALLY_NOSELF] = function (user, target)
		return user.enemy == target.enemy and user ~= target
	end,
	[gamelogic.TARGET_FOE] = function (user, target)
		return user.enemy ~= target.enemy
	end,
}

gamelogic.GetExDesc_common = function (self, s, target)
	if s == "low" then return self:power_func(target, 0)
	elseif s == "high" then return self:power_func(target, 1) end
	if string.sub(s, 1, 5) == "user." then
		return self.user[string.sub(s, 6)]
	elseif string.sub(s, 1, 7) == "target." then
		return target[string.sub(s, 8)]
	end
	return self[s]
end

return gamelogic