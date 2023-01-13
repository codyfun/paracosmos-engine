local gamelogic = require "main/gamelogic"

local function SimpleAttackSkill (data)
	local skill = {
		desc = "Damage an enemy.",
		target = gamelogic.target_funcs[gamelogic.TARGET_FOE],
		damage_func = function (self, target, variance)
			return math.floor(self.power * self.user.attack / target.defense * (1 - self.variance + 2 * self.variance * variance) + 0.5)
		end,
		GetExDesc = function (self, target)
			return string.format("Will do %d-%d (%dx%d/%d~10%%) damage to %s", self:damage_func(target, 0), self:damage_func(target, 1), self.power, self.user.attack, target.defense, target.name)
		end,
		OnUse = function (self, target, variance)
			local damage = self:damage_func(target, variance)
			target.hp = target.hp - damage
			return string.format("%s does %d damage to %s", self.user.name, damage, target.name)
		end,
	}
	for k,v in pairs(data) do skill[k] = v end
	return skill
end

return {
	attack = SimpleAttackSkill{name = "Strike", power = 10, variance = 0.1},
	defend = {
		name = "Defend",
		desc = "Reduce incoming attack damage by 50% this turn.",
		target = gamelogic.target_funcs[gamelogic.TARGET_SELF],
		OnUse = function (self, target)
			
			return string.format("%s defends", self.user.name)
		end,
	},
	skip_turn = {
		name = "Skip Turn",
		desc = "Do nothing and end your turn.",
		target = gamelogic.target_funcs[gamelogic.TARGET_SELF],
	},
	heal = {
		name = "Heal",
		desc = "Restore the HP of an ally.",
		target = gamelogic.target_funcs[gamelogic.TARGET_ALLY],
		power = 2,
		variance = 0.1,
		healing_func = function (self, target, variance)
			return math.floor(self.power * self.user.magicattack * (1 - self.variance + 2 * self.variance * variance) + 0.5)
		end,
		GetExDesc = function (self, target)
			return string.format("Will restore %d-%d (%dx%d) HP to %s", self:healing_func(target,0), self:healing_func(target,1), self.power, self.user.magicattack, target.name)
		end,
		OnUse = function (self, target, variance)
			local healing = self:healing_func(target, variance)
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