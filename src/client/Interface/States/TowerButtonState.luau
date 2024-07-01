local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Value = Fusion.Value

local Types = require(ReplicatedStorage.Types)

export type TowerButtonState = {
	Tower: Fusion.Value<Types.Tower>,
	UpgradeLevels: Fusion.Value<{ number }>,

	Cost: Fusion.Value<number>,
}

return function(): TowerButtonState
	return {
		Tower = Value({}),
		UpgradeLevels = Fusion.Value({ 0, 0, 0 }),

		Cost = Value(0),
	}
end
