local init_perk = function(user, perk_id)
	local perk = table.copy(content.perks[perk_id])
	perk.user = user
	return perk
end

local Player = {}

function Player:AddPerk(perk)
	if type(perk) == "string" then
		perk = init_perk(self, perk)
	end
	perk.user = self
	if perk.OnEquip then perk:OnEquip() end
	table.insert(self.perks, perk)
end

function Player:RemovePerk(perk)
	if type(perk) == "string" then
		perk = self.perks[table.find_if(self.perks, function(perk_object) return perk_object.id == perk end)]
	end
	if perk.OnUnequip then perk:OnUnequip() end
    table.remove(self.perks, table.find(self.perks, perk))
    perk.user = nil
end

local Player_class = {
	__index = Player,
	type = "Player",
}

setmetatable(Player_class, {
	__call = function(self, def)
		local object = table.copy(content.chars[def])
		setmetatable(object, self)
		for _, stat in pairs {"hpmax", "attack", "defense", "magicattack", "magicdefense", "accuracy", "evasion"} do
			object[stat] = ModStat(object[stat])
		end
		object.level = 1
		object.exp = 0
        object.perks = {}
		return object
	end,
})

return Player_class
