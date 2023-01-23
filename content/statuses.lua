local function SimpleStatBoost(data)
	return table.merge(data, {
		desc = data.stat_name .. " increased.",
		stacks = 5,
		OnApply = function(self)
			local stacks = self.stacks
			self.stat_mod = {Apply = function(self, value) return math.round(value * (1 + 0.01 * stacks)) end}
			self.user[data.stat_id]:AddMod(self.stat_mod)
			self.desc = data.stat_name .. " increased by " .. self.stacks .. "%.\nGoes down by 5% per turn."
		end,
		OnTurnStart = function(self)
			self.user[data.stat_id]:RemoveMod(self.stat_mod)
			self.stacks = self.stacks - 5
			if self.stacks <= 0 then
				self.user:RemoveStatus(self)
			else
				self:OnApply()
			end
		end,
		OnRemove = function(self)
			self.user[data.stat_id]:RemoveMod(self.stat_mod)
		end,
	})
end

local statuses = {
	defending = {
		name = "Defending",
		icon = "icons/shield",
		iconcolor = vmath.vector4(0.3, 0.3, 1, 1),
		desc = "200% Defense and Magic Defense for 1 turn.",
		stat_mod = {Apply = function(self, value) return value * 2 end},
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
	buffed_hpmax = SimpleStatBoost {name = "Max HP Up", stat_id = "attack", stat_name = "Max HP",},
	buffed_attack = SimpleStatBoost {name = "Attack Up", stat_id = "attack", stat_name = "Attack", icon = "icons/fist", iconcolor = vmath.vector4(0.5, 0.7, 0.3, 1),},
	buffed_defense = SimpleStatBoost {name = "Defense Up", stat_id = "defense", stat_name = "Defense"},
	buffed_magicattack = SimpleStatBoost {name = "Magic Attack Up", stat_id = "magicattack", stat_name = "Magic Attack"},
	buffed_magicdefense = SimpleStatBoost {name = "Magic Defense Up", stat_id = "magicdefense", stat_name = "Magic Defense"},
	buffed_accuracy = SimpleStatBoost {name = "Accuracy Up", stat_id = "accuracy", stat_name = "Accuracy"},
	buffed_evasion = SimpleStatBoost {name = "Evasion Up", stat_id = "evasion", stat_name = "Evasion"},
}
for k, v in pairs(statuses) do
	v.id = k
end
return statuses
