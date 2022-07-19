return function()
	context("HookFuncs", function()
		test("HookFunc addition, execution, and removal", function()
			local HookFunc = require("main.hookfunc")

			local tracker = {}
			
			local hook_func = HookFunc(function() table.insert(tracker, 2) end)
			
			local hook1 = function() table.insert(tracker, 3) end
			hook_func:AddHook(hook1)
			
			local hook2 = function() table.insert(tracker, 1) end
			hook_func:AddHook(hook2, -1)
			
			hook_func()
			
			assert_same(tracker, {1,2,3})
			
			hook_func:RemoveHook(hook1)
			
			hook_func:RemoveHook(hook2)
			
			hook_func()
			
			assert_same(tracker, {1,2,3,2})
		end)
		
		test("HookFunc return value replacement", function()
			local HookFunc = require("main.hookfunc")

			local hook_func = HookFunc(function() return 1,2 end)
			
			hook_func:AddHook(function(self) return self.return_vals[1] + 1 end)
			
			local output = {hook_func()}
			
			assert_same(output, {2,2})
		end)
		
		test("HookFunc recursive calls return values", function()
			local HookFunc = require("main.hookfunc")
			
			local object = {tracker = {}} --can't create a self-referencing hookfunc directly
			
			object.hook_func = HookFunc(function(self, i, str)
				str = str or ""
				if i > 1 then
					return object.hook_func(i-1, tostring(i) .. str)
				else
					return tostring(i) .. str
				end
			end)
			
			object.hook_func:AddHook(function(self, i) table.insert(object.tracker, i) end, -1)
			object.hook_func:AddHook(function(self, i) table.insert(object.tracker, i) end)
			
			local str = object.hook_func(3)
			
			assert(str == "123")
			for k,v in pairs(object.tracker) do print(v) end
			assert_same(object.tracker, {3,2,1,1,2,3})
		end)
	end)
end