local function SimpleStatPerk(data)
    local multiplier = data.multiplier
	local mult_display = (multiplier-1)*100
	return table.merge(data, {
		desc = "Increases your base " .. data.stat_name .. " by " .. mult_display .. "%.",
        cost = 1,
		OnEquip = function(self)
			self.stat_mod = {Apply = function(self, value) return math.round(value * multiplier) end}
			self.user[data.stat_id]:AddMod(self.stat_mod)
		end,
		OnUnequip = function(self)
			self.user[data.stat_id]:RemoveMod(self.stat_mod)
		end,
	})
end

local function SimpleSkillPerk(data)
	local skill_id = data.skill_id
	return table.merge(data, {
		GetDesc = function(self)
			return "Lets you use \"" .. content.skills[skill_id].name .. "\":\n" .. (table.sane_call(content.skills, {skill_id, "GetDesc"}, content.skills[skill_id]) or content.skills[skill_id].desc), true
		end,
        cost = 1,
		OnEquip = function(self)
			table.insert(self.user.skill_ids, skill_id)
		end,
		OnUnequip = function(self)
			table.remove_value(self.user.skill_ids, skill_id)
		end,
	})
end

local perks = {
	stat_hp = SimpleStatPerk {name = "Health+", stat_id = "hpmax", stat_name = "Max HP", multiplier = 1.15},
	stat_attack = SimpleStatPerk {name = "Strength+", stat_id = "attack", stat_name = "Attack", multiplier = 1.15},
	stat_defense = SimpleStatPerk {name = "Armor+", stat_id = "defense", stat_name = "Defense", multiplier = 1.15},
	stat_magicattack = SimpleStatPerk {name = "Magic+", stat_id = "magicattack", stat_name = "Magic Attack", multiplier = 1.15},
	stat_magicdefense = SimpleStatPerk {name = "Resistance+", stat_id = "magicdefense", stat_name = "Magic Defense", multiplier = 1.15},
	stat_accuracy = SimpleStatPerk {name = "Aim+", stat_id = "accuracy", stat_name = "Accuracy", multiplier = 1.15},
	stat_evasion = SimpleStatPerk {name = "Dodge+", stat_id = "evasion", stat_name = "Evasion", multiplier = 1.15},
	skill_heal = SimpleSkillPerk {name = "Heal", skill_id = "heal"},
	skill_buff_attack = SimpleSkillPerk {name = "Flex", skill_id = "buff_attack"},
}
for k, v in pairs(perks) do
	v.id = k
end
return perks
