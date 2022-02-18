local gamelogic = {}

gamelogic.TARGET_SELF = hash"target_self"
gamelogic.TARGET_ALLY = hash"target_ally"
gamelogic.TARGET_FOE = hash"target_foe"

local function cast_url(u)
	u = msg.url(u)
	u.fragment="player"
	return u
end
gamelogic.cast_url = cast_url

gamelogic.target_funcs = {
	[gamelogic.TARGET_SELF] = function (user, target)
		return user == target or user.path == target
	end,
	[gamelogic.TARGET_ALLY] = function (user, target)
		return go.get(cast_url(user), "team") == go.get(cast_url(target), "team")
	end,
	[gamelogic.TARGET_FOE] = function (user, target)
		return go.get(cast_url(user), "team") ~= go.get(cast_url(target), "team")
	end,
}

return gamelogic