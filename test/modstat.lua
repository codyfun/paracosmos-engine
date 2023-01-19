return function()
	context("ModStats", function()
		test("ModStat basic mod arithmetic", function()
			local ModStat = require("main/modstat")

			local number_stat = ModStat(1)

			assert(number_stat:GetValue() == 1)
			
			local mod1 = {Apply = function(self,value) return value + 1 end}
			
			number_stat:AddMod(mod1)

			assert(number_stat:GetValue() == 2)
			
			local mod2 = {Apply = function(self,value) return value * 2 end}
			
			number_stat:AddMod(mod2)
			
			assert(number_stat:GetValue() == 4)
			
			number_stat:RemoveMod(mod1)

			assert(number_stat:GetValue() == 2)
		end)

		test("ModStat mod order", function()
			local ModStat = require("main/modstat")
			
			local text_stat = ModStat("a")

			text_stat:AddMod({Apply = function(self,value) return value .. "d" end})
			text_stat:AddMod({Apply = function(self,value) return value .. "b" end, order = -2})
			text_stat:AddMod({Apply = function(self,value) return value .. "c" end, order = -1})
			text_stat:AddMod({Apply = function(self,value) return value .. "e" end})

			assert(text_stat:GetValue() == "abcde")
		end)

		test("ModStat cached values", function()
			local ModStat = require("main/modstat")
			
			local number_stat = ModStat(1)

			number_stat:GetValue()

			assert(number_stat.cached_value == 1)

			local mod = {Apply = function(self,value) return value end}
			number_stat:AddMod(mod)

			assert(number_stat.cached_value == nil)

			number_stat:GetValue()

			assert(number_stat.cached_value == 1)
			
			number_stat:RemoveMod(mod)

			assert(number_stat.cached_value == nil)
		end)
	end)
end