local formulas = {
	statscaling = function (base, level)
		return math.round(base * 1.08 ^ level)
	end,
	xpscaling = function (level)
		return (level + 1) * 1.1 ^ level
	end,
}
return formulas
