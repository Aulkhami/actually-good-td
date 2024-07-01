local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Towers = require(ReplicatedStorage.Shared.Towers)
local TowerHotbar = require(StarterPlayer.StarterPlayerScripts.Client.Interface.Components.TowerHotbar)
local TowerButtonState = require(StarterPlayer.StarterPlayerScripts.Client.Interface.States.TowerButtonState)
local TowerHotbarState = require(StarterPlayer.StarterPlayerScripts.Client.Interface.States.TowerHotbarState)

return function(widget: Frame)
	local state = TowerHotbarState()
	state.TowerButtons:set({ TowerButtonState(), TowerButtonState(), TowerButtonState() })

	for _, v in state.TowerButtons:get() do
		v.Tower:set(Towers["Scout"])
	end

	local frame = TowerHotbar({ State = state })
	frame.Parent = widget

	state.TowerButtons:get()[1].Cost:set(100)
	state.TowerButtons:get()[1].UpgradeLevels:set({ 5, 0, 2 })
	state.Selected:set(1)

	return function()
		frame:Destroy()
	end
end
