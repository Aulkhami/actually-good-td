--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Shared.Components)
local Health = Components.Health
local Speed = Components.Speed

local Types = require(ReplicatedStorage.Types)

return {
	Basic = {
		Name = "Basic",
		Description = "The most basic of all basic enemies. Moves at a medium pace and has a decent chunk of health.",

		Components = function()
			return {
				Health({
					current = 100,
					max = 100,
				}),
				Speed({
					baseSpeed = 4,
					speed = 4,
				}),
			}
		end,
	} :: Types.Mob,
}
