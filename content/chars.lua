local gamelogic = require "main/gamelogic"

return {
	hero = {
		name = "Hero",
		icon = "portraits/human64",
		iconcolor = vmath.vector4(.0, .6, .6, 1),
		hpmax = 125,
		attack = 30,
		defense = 30,
		magicattack = 30,
		magicdefense = 30,
		accuracy = 35,
		evasion = 30,
		skill_ids = {"attack", "heal"}
	},
	uncle = {
		name = "Uncle",
		icon = "portraits/dog64",
		iconcolor = vmath.vector4(.6, .4, .0, 1),
		hpmax = 80,
		attack = 35,
		defense = 25,
		magicattack = 35,
		magicdefense = 25,
		accuracy = 35,
		evasion = 35,
		skill_ids = {"attack", "buff_attack"}
	},
	bun = {
		name = "Bun",
		icon = "portraits/rabbit64",
		iconcolor = vmath.vector4(.7, .7, .2, 1),
		hpmax = 50,
		attack = 25,
		defense = 20,
		magicattack = 25,
		magicdefense = 20,
		accuracy = 30,
		evasion = 35,
		skill_ids = {"attack"}
	}
}