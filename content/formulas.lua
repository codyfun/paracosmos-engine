local formulas = {
	statscaling = function (base, level)
		return math.round(base * 1.08 ^ (level - 1))
	end,
	xpmax = function (level)
		return level * 100 * 1.1 ^ (level - 1)
	end,
}
return formulas
