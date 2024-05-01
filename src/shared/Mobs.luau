--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Types)

return {
	Basic = {
		Stats = {
			Health = 100,
			Speed = 8,
		},
		Components = function()
			return {}
		end,
		Description = "The most basic of all basic enemies. Moves at a medium pace and has a decent chunk of health.",
	} :: Types.Mob,
}
