--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = {}

-- Health
type raw_HealthInstance = {
	current: number,
	max: number,
}
export type HealthInstance = raw_HealthInstance & {
	patch: (self: HealthInstance, data: {
		current: number?,
		max: number?,
	}) -> HealthInstance,
}

Components.Health = Matter.component(
	"Health",
	{
		current = 100,
		max = 100,
	} :: raw_HealthInstance
) :: typeof(setmetatable(
	{},
	{} :: {
		__call: (raw_HealthInstance?) -> HealthInstance,
	}
))

return Components
