local gamelogic = require "main/gamelogic"

local function SimpleAttackSkill (data)
	return {
		name = data.name,
		desc = "Damage an enemy.",
		target = gamelogic.target_funcs[gamelogic.TARGET_FOE],
		GetExtendedDesc = function (self, target)
			
		end,
		OnUse = function (self, target)
			local damage = 5
			target.hp = target.hp - damage
			return string.format("%s did %d damage to %s", self.name, damage, target.name)
		end,
	}
end

return {
	attack = SimpleAttackSkill{name = "Strike"},
	defend = {
		name = "Defend",
		desc = "Reduce incoming attack damage by 50% this turn.",
		target = gamelogic.target_funcs[gamelogic.TARGET_SELF],
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
		OnUse = function (self, target)
			target.hp = math.min(target.maxhp, target.hp + 5)
			return string.format("%s restored %d HP to %s", self.name, damage, target.name)
		end,
	},
}