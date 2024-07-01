local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

if not RunService:IsClient() then
	error("Tried to require a Client-only module")
end

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Value = Fusion.Value

local state = {
	ViewportSize = Value(Workspace.CurrentCamera.ViewportSize),
	ViewTowerModel = Value(false),
}

-- ViewportSize
Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	state.ViewportSize:set(Workspace.CurrentCamera.ViewportSize)
end)

return state
