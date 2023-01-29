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
		significant = true,
	},
	dog = {
		name = "Faenine",
		icon = "portraits/dog64",
		iconcolor = vmath.vector4(.6, .4, .0, 1),
		hpmax = 70,
		attack = 25,
		defense = 17,
		magicattack = 23,
		magicdefense = 16,
		accuracy = 25,
		evasion = 23,
		skill_ids = {"attack", "attack", "buff_attack", "defend"},
		perk_ids = {"stat_attack", "stat_accuracy", "stat_hp", "stat_evasion", "stat_defense", "stat_magicdefense"},
		reward_xp = 25,
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
		evasion = 20,
        skill_ids = {"attack"},
		perk_ids = {"stat_attack", "stat_defense", "stat_magicdefense", "stat_evasion", "stat_accuracy", "stat_hp"},
		reward_xp = 10,
    },
	dolphin = {
		name = "Nemesis",
		icon = "portraits/dolphin64",
		iconcolor = vmath.vector4(.6, .4, .5, 1),
		hpmax = 300,
		attack = 27,
		defense = 18,
		magicattack = 13,
		magicdefense = 18,
		accuracy = 22,
		evasion = 18,
		skill_ids = {"attack", "heal"},
		perk_ids = {"double_actions", "stat_attack", "stat_magicattack", "stat_defense", "stat_magicdefense", "stat_evasion", "stat_accuracy", "stat_hp"},
		reward_xp = 100,
		significant = true,
	}
}
for k, v in pairs(chars) do
	v.id = k
end
return chars
