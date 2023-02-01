local function SimpleStatPerk(data)
    local multiplier = data.multiplier
	local mult_display = (multiplier-1)*100
	return table.copy(data, {
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
    return table.copy(data, {
        icon = data.icon,
		icon_color = data.icon_color,
		GetDesc = function(self)
			return "Lets you use \"" .. content.skills[skill_id].name .. "\":\n" .. GL.GetDesc(content.skills[skill_id]) .. "\nFills a " .. string.firstupper(data.skill_type) .. " skill slot."
		end,
        cost = 0,
		OnEquip = function(self)
			array.insert(self.user.skill_ids, skill_id)
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
	skill_heal = SimpleSkillPerk {name = "Heal", icon = "icons/health-normal",
        iconcolor = vmath.vector4(0.0, 0.5, 0, 1), skill_id = "heal",
		skill_type = "support",
	},
	skill_buff_attack = SimpleSkillPerk {name = "Flex", icon = "icons/fist",
		iconcolor = vmath.vector4(0.5, 0.7, 0.3, 1), skill_id = "buff_attack",
		skill_type = "support",},
    stat_actions = {
        name = "Double Time",
        desc = "Gain an additional action every turn.",
        OnBattleStart = function(self)
            array.insert(self.user.skills, {
                name = "Double Time",
				desc = "Gains an additional action every turn."
			})
		end,
		OnTurnStart = function(self)
			self.user.actions = self.user.actions + 1
		end,
		CanDrop = function(self) return false end,
	},
    stat_hp2 = SimpleStatPerk {name = "Health+ 2", stat_id = "hpmax", stat_name = "Max HP", multiplier = 1.13,
		desc = "Increase health by 15% more, requires Health+",
		CanEquip = function(self, user)
			return table.find_if(user.perks, function (perk) return perk.id == "stat_hp" end)
		end},
}
for k, v in pairs(perks) do
	v.id = k
end
return perks
