local HookFunc = {}

function HookFunc:AddHook(new_func, order)
	for i,exist_func in ipairs(self.funcs) do
		order = order or (type(new_func) == "table" and new_func.order) or 0
		if order < self.func_orders[exist_func] then
			array.insert(self.funcs, i, new_func)
			self.func_orders[new_func] = order
			return
		end
	end
	--fallthrough to end if no existing funcs earlier in order were found
	array.insert(self.funcs, new_func)
	self.func_orders[new_func] = 0
end

function HookFunc:RemoveHook(func)
	for i,exist_func in ipairs(self.funcs) do
		if exist_func == func then
			table.remove(self.funcs, i)
			self.func_orders[func] = nil
			return
		end
	end
end

local HookFunc_class = {
	__index = HookFunc,
	__call = function(self, ...)
		local higher_return_vals = self.return_vals --don't lose return values from higher stack levels
		self.return_vals = {}
		for i,func in ipairs(self.funcs) do
			if func == self then
				func = self.main_fn -- redirect own entry to main_fn. avoid infinite loops!
			end
			local new_return_vals = {func(self, ...)} --pack values to avoid losing multi-returns
			for i,val in ipairs(new_return_vals) do
				self.return_vals[i] = val
			end
		end
		local return_vals = self.return_vals --prepare to return this call's return values while restoring higher stack's values
		self.return_vals = higher_return_vals
		return unpack(return_vals)
	end,
	type = "HookFunc",
}

setmetatable(HookFunc_class, {
	__call = function(self, main_fn)
		local object = {}
		setmetatable(object, self)
		object.main_fn = main_fn
		object.funcs = {object}
		object.func_orders = {[object] = 0}
		return object
	end,
})

return HookFunc_class