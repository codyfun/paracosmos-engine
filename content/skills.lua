local function get_value_or_self(self, k) return (type(self[k]) == "table") and self[k].GetValue and self[k]:GetValue() or self[k] end
local GetExDesc_common = function(self, s, target)
	if s == "low" then return self:power_func(target, 0)
	elseif s == "high" then return self:power_func(target, 1) end
	if string.sub(s, 1, 5) == "user." then
		return get_value_or_self(self.user, string.sub(s, 6))
	elseif string.sub(s, 1, 7) == "target." then
		return get_value_or_self(target, string.sub(s, 8))
	end
	return get_value_or_self(self, s)
end

local function SimpleAttackSkill(data)
	return table.merge(data, {
		target = GL.target_funcs.target_foe,
		power_func = function(self, target, variance)
			return math.round(self.power * self.user.attack:GetValue() / target.defense:GetValue() * (1 - self.variance + 2 * self.variance * variance))
		end,
		GetExDesc = function(self, target)
			return string.gsub("Do <color=red>{low}-{high}</color> damage to {target.name}\n\n<color=red>Attack</color> vs. <color=blue>Defense</color> = {power}×<color=red>{user.attack}</color>÷<color=blue>{target.defense}</color><color=grey>±10%</color>", "%{(.-)%}", function(s)
				return GetExDesc_common(self, s, target)
			end), true
		end,
		OnUse = function(self, target)
			local damage = self:power_func(target, RNG.battle:random())
			target.hp = target.hp - damage
			return string.format("%s does %d damage to %s", self.user.name, damage, target.name)
		end,
	})
end

local skills = {
	attack = SimpleAttackSkill{
		name = "Strike",
		desc = "Damage an enemy.",
		icon = "icons/fist",
		iconcolor = vmath.vector4(0.5, 0, 0, 1),
		power = 10,
		variance = 0.1,
	},
	defend = {
		name = "Defend",
		icon = "icons/shield",
		iconcolor = vmath.vector4(0.0, 0, 0.5, 1),
		desc = "Double your Defense and Magic Defense this turn.",
		target = GL.target_funcs.target_self,
		OnUse = function(self, target)
			self.user:AddStatus("defending")
			return string.format("%s defends", self.user.name)
		end,
	},
	skip_turn = {
		name = "Skip Turn",
		icon = "icons/empty-hourglass",
		iconcolor = vmath.vector4(0.35, 0.35, 0.2, 1),
		desc = "Do nothing and end your turn.",
		target = GL.target_funcs.target_self,
	},
	heal = {
		name = "Heal",
		icon = "icons/health-normal",
		iconcolor = vmath.vector4(0.0, 0.5, 0, 1),
		desc = "Restore an ally's HP.",
		target = GL.target_funcs.target_ally,
		power = 1,
		variance = 0.1,
		power_func = function(self, target, variance)
			return math.round(self.power * self.user.magicattack:GetValue() * (1 - self.variance + 2 * self.variance * variance))
		end,
		GetExDesc = function(self, target)
			return string.gsub("Restore <color=green>{low}-{high}</color> HP to {target.name}\n\n<color=purple>Magic Attack</color>: <color=purple>{user.magicattack}</color><color=grey>±10%</color>", "%{(.-)%}", function(s)
				return GetExDesc_common(self, s, target)
			end), true
		end,
		OnUse = function(self, target)
			local healing = self:power_func(target, RNG.battle:random())
			local prehp = target.hp
			target.hp = target.hp + healing
			return string.format("%s restores %d HP to %s", self.user.name, target.hp - prehp, target.name)
		end,
	},
	buff_attack = {
		name = "Flex",
		icon = "icons/fist",
		iconcolor = vmath.vector4(0.5, 0.7, 0.3, 1),
		desc = "Boost an ally's attack.",
		target = GL.target_funcs.target_ally,
		stacks = 40,
		OnUse = function(self, target)
			target:AddStatus("buffed_attack", {stacks = self.stacks})
			return string.format("%s buffs %s's attack to %s%%", self.user.name, target.name, self.stacks)
		end,
	},
}
for k, v in pairs(skills) do
	v.id = k
end
return skills
