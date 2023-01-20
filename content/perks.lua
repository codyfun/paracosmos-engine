local function SimpleStatPerk(data)
	return table.merge(data, {
		desc = "Increases your base " .. data.stat_name .. " by 15% per tier.",
		cost = 1,
		OnEquip = function(self)
			self.stat_mod = {Apply = function(self, value) return math.round(value * 1.15) end}
			self.user[data.stat_id]:AddMod(self.stat_mod)
		end,
		OnUnequip = function(self)
			self.user[data.stat_id]:RemoveMod(self.stat_mod)
		end,
	})
end

local function SimpleSkillPerk(data)
	return table.merge(data, {
		desc = "Lets you use \"" .. content.skills[data.skill_id].name .. "\":\n" .. content.skills[data.skill_id].desc,
		cost = 1,
		OnEquip = function(self)
			table.insert(self.user.skill_ids, data.skill_id)
		end,
		OnUnequip = function(self)
			table.remove_value(self.user.skill_ids, data.skill_id)
		end,
	})
end

local perks = {
	stat_hp = SimpleStatPerk {name = "Health Boost", stat_id = "hpmax", stat_name = "Max HP"},
	stat_attack = SimpleStatPerk {name = "Strength Boost", stat_id = "attack", stat_name = "Attack"},
	stat_defense = SimpleStatPerk {name = "Armor Boost", stat_id = "defense", stat_name = "Defense"},
	stat_magicattack = SimpleStatPerk {name = "Magic Boost", stat_id = "magicattack", stat_name = "Magic Attack"},
	stat_magicdefense = SimpleStatPerk {name = "Resistance Boost", stat_id = "magicdefense", stat_name = "Magic Defense"},
	stat_accuracy = SimpleStatPerk {name = "Aim Boost", stat_id = "accuracy", stat_name = "Accuracy"},
	stat_evasion = SimpleStatPerk {name = "Dodge Boost", stat_id = "evasion", stat_name = "Evasion"},
	skill_heal = SimpleSkillPerk {name = "Heal", skill_id = "heal"},
	skill_buff_attack = SimpleSkillPerk {name = "Flex", skill_id = "buff_attack"},
}
for k, v in pairs(perks) do
	v.id = k
end
return perks
