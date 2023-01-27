local init_perk = function(user, perk_id, tier)
	local perk = table.deepcopy(content.perks[perk_id])
	perk.tier = tier
	perk.user = user
	return perk
end

local Player = {}

function Player:AddPerk(perk)
	if type(perk) == "string" then
		perk = init_perk(self, perk, 1)
	end
	self:RemovePerk(perk.id)
	perk.user = self
	if perk.OnEquip then perk:OnEquip() end
    table.insert(self.perks, perk)
	return perk
end

function Player:RemovePerk(perk)
	local exists_at
	if type(perk) == "string" then
		exists_at = table.find_if(self.perks, function(perk_object) return perk_object.id == perk end)
		perk = exists_at and self.perks[exists_at]
	else
		exists_at = table.find(self.perks, perk)
	end
	if exists_at then
		if perk.OnUnequip then perk:OnUnequip() end
		perk = table.remove(self.perks, exists_at)
		perk.user = nil
	end
	return perk
end

function Player:SumLevelsSpent()
	local sum = 0
	for i, perk in pairs(self.perks) do
		sum = sum + perk.tier
	end
	return sum
end

local Player_data = {}
setmetatable(Player_data, {mode = "k"})

local Player_class = {
	__index = function(object, k)
		if Player[k] then return Player[k] end
		if Player_data[object][k] then return Player_data[object][k] end
		return rawget(object, k)
	end,
	__newindex = function(object, k, v)
		if k == "level" then
			Player_data[object][k] = v
			if Player_data[object].level_mod then
				for _, stat in pairs {"hpmax", "attack", "defense", "magicattack", "magicdefense", "accuracy", "evasion"} do
					object[stat]:RemoveMod(Player_data[object].level_mod)
				end
			end
			Player_data[object].level_mod = {Apply = function(self, value) return content.formulas.statscaling(value, v) end}
			for _, stat in pairs {"hpmax", "attack", "defense", "magicattack", "magicdefense", "accuracy", "evasion"} do
				object[stat]:AddMod(Player_data[object].level_mod)
			end
        elseif k == "xp" then
			while v >= content.formulas.xpmax(object.level) do
				v = v - content.formulas.xpmax(object.level)
				object.level = object.level + 1
			end
			Player_data[object][k] = v
		else
			rawset(object, k, v)
		end
	end,
	type = "Player",
}

setmetatable(Player_class, {
	__call = function(self, def)
		local object = table.deepcopy(content.chars[def])
		setmetatable(object, self)
		Player_data[object] = {}
		for _, stat in pairs {"hpmax", "attack", "defense", "magicattack", "magicdefense", "accuracy", "evasion"} do
			object[stat] = ModStat(object[stat])
		end
		object.level = 1
		object.xp = 0
		object.perks = {}
		return object
	end,
})

return Player_class
