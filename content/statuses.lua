local gamelogic = require "main/gamelogic"

local function SimpleStatBoost (data)
	return table.merge(data, {
		desc = data.name,
		stacks = 3,
		OnApply = function (self)
			self.stat_mod = {Apply = function(self,value) return math.floor(value * 1.334 + 0.5) end}
			self.user[data.stat_id]:AddMod(self.stat_mod)
		end,
		OnTurnStart = function (self)
			self.stacks = self.stacks - 1
			if self.stacks == 0 then
				self.user:RemoveStatus(self)
			end
		end,
		OnRemove = function (self)
			self.user[data.stat_id]:RemoveMod(self.stat_mod)
		end,
	})
end

return {
	defending = {
		name = "Defending",
		icon="icons/shield",
		iconcolor=vmath.vector4(0.3, 0.3, 1, 1),
		desc = "200% Defense and Magic Defense for 1 turn.",
		stat_mod = {Apply = function(self,value) return value * 2 end},
		OnApply = function(self)
			self.user.defense:AddMod(self.stat_mod)
			self.user.magicdefense:AddMod(self.stat_mod)
		end,
		OnTurnStart = function(self)
			self.user:RemoveStatus(self)
		end,
		OnRemove = function(self)
			self.user.defense:RemoveMod(self.stat_mod)
			self.user.magicdefense:RemoveMod(self.stat_mod)
		end,
	},
	buffed_attack = SimpleStatBoost{name = "Attack Up", stat_id = "attack", icon="icons/fist", iconcolor=vmath.vector4(0.5, 0.7, 0.3, 1),},
	buffed_defense = SimpleStatBoost{name = "Defense Up", stat_id = "defense"},
	buffed_magicattack = SimpleStatBoost{name = "Magic Attack Up", stat_id = "magicattack"},
	buffed_magicdefense = SimpleStatBoost{name = "Magic Defense Up", stat_id = "magicdefense"},
	buffed_accuracy = SimpleStatBoost{name = "Accuracy Up", stat_id = "accuracy"},
	buffed_evasion = SimpleStatBoost{name = "Evasion Up", stat_id = "evasion"},
}