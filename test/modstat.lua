return function()
	context("ModStats", function()
		test("ModStat arithmetic", function()
			local ModStat = require("main.modstat")

			local number_stat = ModStat(1)

			assert(number_stat:GetValue() == 1)

			number_stat:AddMod({Apply = function(self,value) return value + 1 end})

			assert(number_stat:GetValue() == 2)
		end)

		test("ModStat mod priority", function()
			local ModStat = require("main.modstat")
			local order_testing_stat = ModStat("a")

			order_testing_stat:AddMod({Apply = function(self,value) return value .. "d" end})
			order_testing_stat:AddMod({Apply = function(self,value) return value .. "b" end, priority = 2})
			order_testing_stat:AddMod({Apply = function(self,value) return value .. "c" end, priority = 1})
			order_testing_stat:AddMod({Apply = function(self,value) return value .. "e" end})

			assert(order_testing_stat:GetValue() == "abcde")
		end)
	end)
end