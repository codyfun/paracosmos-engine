local chars = {
	hero = {
		name = "Hero",
		icon = "portraits/human64",
		iconcolor = vmath.vector4(.0, .6, .6, 1),
		hpmax = 100,
		attack = 20,
		defense = 20,
		magicattack = 20,
		magicdefense = 20,
		accuracy = 20,
		evasion = 20,
		skill_ids = {"attack"},
	},
	uncle = {
		name = "Uncle",
		icon = "portraits/dog64",
		iconcolor = vmath.vector4(.6, .4, .0, 1),
		hpmax = 70,
		attack = 25,
		defense = 17,
		magicattack = 23,
		magicdefense = 16,
		accuracy = 25,
		evasion = 23,
		skill_ids = {"attack", "buff_attack"},
	},
	bun = {
		name = "Bun",
		icon = "portraits/rabbit64",
		iconcolor = vmath.vector4(.7, .7, .2, 1),
		hpmax = 40,
		attack = 16,
		defense = 14,
		magicattack = 16,
		magicdefense = 14,
		accuracy = 16,
		evasion = 24,
        skill_ids = {"attack"},
		reward_xp = 15,
	}
}
for k, v in pairs(chars) do
	v.id = k
end
return chars
