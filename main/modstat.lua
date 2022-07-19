local ModStat = {}

function ModStat:GetValue()
	if self.cached_value then
		return self.cached_value
	else
		local value = self.base_value
		for i,mod in ipairs(self.mods) do
			value = mod:Apply(value)
		end
		self.cached_value = value
		return value
	end
end

function ModStat:AddMod(new_mod)
	new_mod.owner = self
	for i,exist_mod in ipairs(self.mods) do
		if (new_mod.order or 0) < (exist_mod.order or 0) then
			table.insert(self.mods, i, new_mod)
			self:StaleValue()
			return
		end
	end
	--fallthrough to end if no existing mods earlier in order were found
	table.insert(self.mods, new_mod)
	self:StaleValue()
end

function ModStat:RemoveMod(mod)
	for i,exist_mod in ipairs(self.mods) do
		if exist_mod == mod then
			table.remove(self.mods, i)
			self:StaleValue()
			return
		end
	end
end

function ModStat:StaleValue()
	self.cached_value = nil
	if self.OnStaleValue then self:OnStaleValue(value) end
end

local ModStat_class = {
	__index = ModStat,
	type = "ModStat",
}

setmetatable(ModStat_class, {
	__call = function(self, base_value)
		local object = {}
		setmetatable(object, self)
		object.base_value = base_value
		object.mods = {}
		return object
	end,
})

return ModStat_class