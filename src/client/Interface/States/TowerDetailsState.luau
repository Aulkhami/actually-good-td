local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Value = Fusion.Value

local Towers = require(ReplicatedStorage.Shared.Towers)

local Types = require(ReplicatedStorage.Types)

export type UpgradeStatus = Fusion.Value<"All" | "Some" | "None">
export type PathStatus = Fusion.Value<"Primary" | "Secondary" | "Locked">
export type Stats = {
	Name: string,
	Value: Fusion.Value<number>,
}
export type Health = {
	Current: Fusion.Value<number>,
	Max: Fusion.Value<number>,
}

export type TowerDetailsState = {
	Tower: Fusion.Value<Types.Tower>,
	UpgradeStatus: { { UpgradeStatus } },
	PathStatus: { PathStatus },

	Stats: Fusion.Value<{ Stats }>,
	Health: Health,

	UpgradeDisabled: Fusion.Value<boolean>,
	UpgradeFn: (path: number, level: number) -> (),

	HideDetails: Fusion.Value<boolean>,
	HideHealth: Fusion.Value<boolean>,
}

return function(): TowerDetailsState
	return {
		Tower = Value(Towers["Scout"]),
		UpgradeStatus = { {} },
		PathStatus = { Value("Primary"), Value("Primary"), Value("Primary"), Value("Primary"), Value("Primary") },

		Stats = Value({}),
		Health = {
			Current = Value(100),
			Max = Value(100),
		},

		UpgradeDisabled = Value(false),
		UpgradeFn = function() end,

		HideDetails = Value(false),
		HideHealth = Value(false),
	}
end
