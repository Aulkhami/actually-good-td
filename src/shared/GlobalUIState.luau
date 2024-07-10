local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

if not RunService:IsClient() then
	error("Tried to require a Client-only module")
end

local Signal = require(ReplicatedStorage.Packages.Signal)

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Value = Fusion.Value

export type CurrentScreen = "None" | "PlaceTowers"

local state = {
	ViewportSize = Value(Workspace.CurrentCamera.ViewportSize),
	ViewTowerModel = Value(false),

	CurrentScreen = Value("None") :: Fusion.Value<CurrentScreen>,

	CanPlace = Value(true),

	PlaceTowerSignal = Signal(),
	PlaceTowerCancelSignal = Signal(),

	-- TEMPORARY SOLUTION
	WorldStateUpdate = Signal(),
}

-- ViewportSize
Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	state.ViewportSize:set(Workspace.CurrentCamera.ViewportSize)
end)

export type Type = typeof(state)

return state
