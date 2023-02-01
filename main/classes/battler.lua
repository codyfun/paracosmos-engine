local init_skill = function(user, skill_id)
	local skill = table.deepcopy(content.skills[skill_id])
	skill.user = user
	return skill
end

local Battler = {}

function Battler:AddStatus(status, data)
	if type(status) == "string" then
		status = table.deepcopy(content.statuses[status])
	end
	if data then
		table.copy(data, status)
	end
	status.user = self
	if status.OnApply then status:OnApply() end
    array.insert(self.statuses, status)
	return status
end

function Battler:GetStatus(status)
	if type(status) == "string" then
		return self.statuses[table.find_if(self.statuses, function(status_object) return status_object.id == status end)]
	else
		return self.statuses[table.find_if(self.statuses, function(status_object) return status_object.id == status.id end)]
	end
end

function Battler:RemoveStatus(status)
	if type(status) == "string" then
		status = self:GetStatus(status)
	end
	if status.OnRemove then status:OnRemove() end
    table.remove(self.statuses, table.find(self.statuses, status))
	return status
end

local Battler_data = {}
setmetatable(Battler_data, {mode = "k"})

local Battler_class = {
	__index = function(object, k)
		if Battler[k] then return Battler[k] end
		if Battler_data[object][k] then return Battler_data[object][k] end
		return rawget(object, k)
	end,
	__newindex = function(object, k, v)
		if k == "hp" then
			if v > object.hpmax:GetValue() then
				v = object.hpmax:GetValue()
			elseif v < 0 then
				v = 0
			end
			Battler_data[object][k] = v
		else
			rawset(object, k, v)
		end
	end,
	type = "Battler",
}

setmetatable(Battler_class, {
	__call = function(self, def, enemylevel)
		if type(def) == "string" then
			def = content.chars[def]
		end
		local object = table.copy(def)
		if enemylevel or def.level then object.level = enemylevel or def.level end
		setmetatable(object, self)
		Battler_data[object] = {}
        for _, stat in pairs {"hpmax", "attack", "defense", "magicattack", "magicdefense", "accuracy", "evasion"} do
			if enemylevel then
				object[stat] = content.formulas.statscaling(object[stat], enemylevel)
			end
			object[stat] = ModStat(type(object[stat]) == "table" and object[stat]:GetValue() or object[stat])
		end
		object.hp = object.hpmax:GetValue()
        object.skills = {}
		for i, skill_id in ipairs(object.skill_ids) do
			array.insert(object.skills, init_skill(object, skill_id))
		end
		object.enemy = enemylevel and true
        if object.enemy then
			object.perks = {}
			local sum = 0
            for i, perk_id in ipairs(object.perk_ids or {}) do
                local perk = table.deepcopy(content.perks[perk_id])
				if sum + (perk.cost or 1) > object.level then
					break
				end
                perk.user = object
				if perk.OnEquip then perk:OnEquip() end
                array.insert(object.perks, perk)
				sum = sum + (perk.cost or 1)
			end
		else
			array.insert(object.skills, init_skill(object, "defend"))
			array.insert(object.skills, init_skill(object, "skip_turn"))
		end
		object.statuses = {}
		return object
	end,
})

return Battler_class
