local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Towers = require(ReplicatedStorage.Shared.Towers)
local Value = Fusion.Value

local TowerDetails = require(StarterPlayer.StarterPlayerScripts.Client.Interface.Components.TowerDetails)
local TowerDetailsState = require(StarterPlayer.StarterPlayerScripts.Client.Interface.States.TowerDetailsState)

return function(widget: Frame)
	local state = TowerDetailsState()
	state.Tower:set(Towers["Scout"])
	state.Stats:set({
		{
			Name = "Attack",
			Value = Value(100),
		},
		{
			Name = "AttackInterval",
			Value = Value(100),
		},
		{
			Name = "Defense",
			Value = Value(100),
		},
		{
			Name = "Range",
			Value = Value(100),
		},
	} :: { TowerDetailsState.Stats })
	state.UpgradeStatus = {
		{ Value("All"), Value("All"), Value("All"), Value("Some"), Value("None") },
		{ Value("None"), Value("None"), Value("None"), Value("None"), Value("None") },
		{ Value("All"), Value("All"), Value("None"), Value("None"), Value("None") },
	}
	state.PathStatus = {
		Value("Primary"),
		Value("Locked"),
		Value("Secondary"),
	}

	local props = {
		State = state,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
	} :: TowerDetails.Props

	local frame = TowerDetails(props)
	frame.Parent = widget

	state.Health.Current:set(50)

	return function()
		frame:Destroy()
	end
end
