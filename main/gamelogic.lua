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

return gamelogic