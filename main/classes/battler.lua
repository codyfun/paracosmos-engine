local init_skill = function (user, skill_id)
	local skill = table.copy(content.skills[skill_id])
	skill.user = user
	return skill
end

local Battler = {}

function Battler:AddStatus(status)
	if type(status) == "string" then
		status = table.copy(content.statuses[status])
	end
	status.user = self
	if status.OnApply then status:OnApply() end
	table.insert(self.statuses, status)
end

function Battler:RemoveStatus(status)
	if type(status) == "string" then
		status = self.statuses[table.find_if(self.statuses, function(status_object) return status_object.id == status end)]
	end
	if status.OnRemove then status:OnRemove() end
	table.remove(self.statuses, table.find(self.statuses, status))
end

local Battler_data = {}
setmetatable(Battler_data, {mode = "k"})

local Battler_class = {
	__index = function (object, k)
		if Battler[k] then return Battler[k] end
		if Battler_data[object][k] then return Battler_data[object][k] end
		return rawget(object, k)
	end,
	__newindex = function (object, k, v)
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
	__call = function(self, def, enemy)
		local object = table.copy(content.chars[def])
		setmetatable(object, self)
		Battler_data[object] = {}
		for _,stat in pairs{"hpmax", "attack", "defense", "magicattack", "magicdefense", "accuracy", "evasion"} do
			object[stat] = ModStat(object[stat])
		end
		object.hp = object.hpmax:GetValue()
		object.skills = {}
		for i,skill_id in ipairs(object.skill_ids) do
			table.insert(object.skills, init_skill(object, skill_id))
		end
		object.enemy = enemy
		if not enemy then
			table.insert(object.skills, init_skill(object, "defend"))
			table.insert(object.skills, init_skill(object, "skip_turn"))
		end
		object.statuses = {}
		return object
	end,
})

return Battler_class