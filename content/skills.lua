local gamelogic = require "main/gamelogic"
local content_statuses = require "content/statuses"

local function SimpleAttackSkill (data)
	local skill = {
		desc = "Damage an enemy.",
		target = gamelogic.target_funcs[gamelogic.TARGET_FOE],
		power_func = function (self, target, variance)
			return math.floor(self.power * self.user.attack / target.defense * (1 - self.variance + 2 * self.variance * variance) + 0.5)
		end,
		GetExDesc = function (self, target)
			return string.gsub("Do <color=red>{low}-{high}</color> damage to {target.name}\n\n(Based on <color=red>Attack</color> vs. <color=blue>Defense</color> = <color=red>{user.attack}</color>/<color=blue>{target.defense}</color>x{power}<color=grey>~10%</color>)", "%{(.-)%}", function(s)
				return gamelogic.GetExDesc_common(self, s, target)
			end), true
		end,
		OnUse = function (self, target, variance)
			local damage = self:power_func(target, variance)
			target.hp = target.hp - damage
			return string.format("%s does %d damage to %s", self.user.name, damage, target.name)
		end,
	}
	for k,v in pairs(data) do skill[k] = v end
	return skill
end

return {
	attack = SimpleAttackSkill{name = "Strike", icon="icons/fist", iconcolor=vmath.vector4(0.5, 0, 0, 1), power = 10, variance = 0.1},
	defend = {
		name = "Defend",
		icon="icons/shield",
		iconcolor=vmath.vector4(0.0, 0, 0.5, 1),
		desc = "Double your Defense and Magic Defense this turn.",
		target = gamelogic.target_funcs[gamelogic.TARGET_SELF],
		OnUse = function (self, target)
			table.insert(self.user.statuses, table.copy(content_statuses["defending"]))
			return string.format("%s defends", self.user.name)
		end,
	},
	skip_turn = {
		name = "Skip Turn",
		icon="icons/empty-hourglass",
		iconcolor=vmath.vector4(0.35, 0.35, 0.2, 1),
		desc = "Do nothing and end your turn.",
		target = gamelogic.target_funcs[gamelogic.TARGET_SELF],
	},
	heal = {
		name = "Heal",
		icon="icons/health-normal",
		iconcolor=vmath.vector4(0.0, 0.5, 0, 1),
		desc = "Restore an ally's HP.",
		target = gamelogic.target_funcs[gamelogic.TARGET_ALLY],
		power = 2,
		variance = 0.1,
		power_func = function (self, target, variance)
			return math.floor(self.power * self.user.magicattack * (1 - self.variance + 2 * self.variance * variance) + 0.5)
		end,
		GetExDesc = function (self, target)
			return string.gsub("Restore <color=green>{low}-{high}</color> HP to {target.name}\n\n(Based on <color=blue>Magic Attack</color>: <color=blue>{user.magicattack}</color>x{power}<color=grey>~10%</color>)", "%{(.-)%}", function(s)
				return gamelogic.GetExDesc_common(self, s, target)
			end), true
		end,
		OnUse = function (self, target, variance)
			local healing = self:power_func(target, variance)
			target.hp = math.min(target.hpmax, target.hp + healing)
			return string.format("%s restores %d HP to %s", self.user.name, healing, target.name)
		end,
	},
	buff_attack = {
		name = "Flex",
		desc = "Boost an ally's attack.",
		target = gamelogic.target_funcs[gamelogic.TARGET_ALLY],
		OnUse = function (self, target)
			
			return string.format("%s buffs %s's attack", self.user.name, target.name)
		end,
	},
}