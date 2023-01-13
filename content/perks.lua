local gamelogic = require "main/gamelogic"

local function SimpleStatPerk (data)
	return {
		name = dataname,
		OnEquip = function (self, user)
			self.stat_mod = {Apply = function(self,value) return value + 10 end}
			user[data.stat_id]:AddMod(self.stat_mod)
		end,
		OnUnequip = function (self, user)
			user[data.stat_id]:RemoveMod(self.stat_mod)
		end,
	}
end

return {
	stat_hp = SimpleStatPerk{name = "Endurance", stat_id = "maxhp"},
	stat_attack = SimpleStatPerk{name = "Strength", stat_id = "attack"},
	stat_defense = SimpleStatPerk{name = "Defense", stat_id = "defense"},
	stat_magicattack = SimpleStatPerk{name = "Intelligence", stat_id = "magicattack"},
	stat_magicdefense = SimpleStatPerk{name = "Resistance", stat_id = "magicdefense"},
	stat_accuracy = SimpleStatPerk{name = "Dexterity", stat_id = "accuracy"},
	stat_evasion = SimpleStatPerk{name = "Agility", stat_id = "evasion"},
}