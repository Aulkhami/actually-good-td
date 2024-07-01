local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Value = Fusion.Value

local TowerButtonState = require(script.Parent.TowerButtonState)

export type TowerHotbarState = {
	TowerButtons: Fusion.Value<{ TowerButtonState.TowerButtonState }>,

	_lastSelected: Fusion.Value<number | false>,
	Selected: Fusion.Value<number | false>,

	SelectFn: (state: TowerButtonState.TowerButtonState) -> boolean,
}

return function(): TowerHotbarState
	return {
		TowerButtons = Value({}),

		_lastSelected = Value(false),
		Selected = Value(false),

		SelectFn = function()
			return true
		end,
	}
end
