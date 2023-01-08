local function SimpleStatPerk (name, stat_id, stat_amount)
	return {
		name = name,
		OnEquip = function (self, user)
			self.stat_mod = {Apply = function(self,value) return value + stat_amount end}
			user[stat_id]:AddMod(self.stat_mod)
		end,
		OnUnequip = function (self, user)
			user[stat_id]:RemoveMod(self.stat_mod)
		end,
	}
end

return {
	stat_hp = SimpleStatPerk("Endurance", "maxhp", 10),
	stat_attack = SimpleStatPerk("Strength", "attack", 10),
	stat_defense = SimpleStatPerk("Defense", "defense", 10),
	stat_magicattack = SimpleStatPerk("Intelligence", "magicattack", 10),
	stat_magicdefense = SimpleStatPerk("Resistance", "magicdefense", 10),
	stat_accuracy = SimpleStatPerk("Dexterity", "accuracy", 10),
	stat_evasion = SimpleStatPerk("Agility", "evasion", 10),
}