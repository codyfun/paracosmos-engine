local function SimpleStatPerk (data)
    return table.merge(data, {
        desc = "Increases your " .. data.stat_name .. " by 20%\n\n20% per tier",
		cost = 1,
		OnEquip = function (self)
			self.stat_mod = {Apply = function(self,value) return math.round(value * 1.2) end}
			self.user[data.stat_id]:AddMod(self.stat_mod)
		end,
		OnUnequip = function (self)
			self.user[data.stat_id]:RemoveMod(self.stat_mod)
		end,
	})
end

local perks = {
	stat_hp = SimpleStatPerk{name = "Endurance", stat_id = "hpmax", stat_name = "Max HP"},
	stat_attack = SimpleStatPerk {name = "Strength", stat_id = "attack", stat_name = "Attack"},
	stat_defense = SimpleStatPerk {name = "Defense", stat_id = "defense", stat_name = "Defense" },
	stat_magicattack = SimpleStatPerk {name = "Intelligence", stat_id = "magicattack", stat_name = "Magic Attack"},
	stat_magicdefense = SimpleStatPerk {name = "Resistance", stat_id = "magicdefense", stat_name = "Magic Defense"},
	stat_accuracy = SimpleStatPerk {name = "Dexterity", stat_id = "accuracy", stat_name = "Accuracy"},
	stat_evasion = SimpleStatPerk {name = "Agility", stat_id = "evasion", stat_name = "Evasion"},
}
for k,v in pairs(perks) do
	v.id = k
end
return perks