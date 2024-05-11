--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

type PartialNewData<T> = { [any]: any } & T

export type Component<T> = {
	patch: (self: T, partialNewData: PartialNewData<T>) -> T & Component<T>,
}

local Components = {}

-- Health
type raw_Health = {
	current: number,
	max: number,
}
export type Health = raw_Health & Component<raw_Health>
Components.Health = Matter.component(
	"Health",
	{
		current = 100,
		max = 100,
	} :: raw_Health
)

-- Position
type raw_Position = {
	position: CFrame,
}
export type Position = raw_Position & Component<raw_Position>
Components.Position = Matter.component(
	"Position",
	{
		position = CFrame.identity,
	} :: raw_Position
)

-- Mob
export type Mob = {}
Components.Mob = Matter.component("Mob", {} :: Mob)

-- Path
type raw_Path = {
	current: number,
	path: number,
}
export type Path = raw_Path & Component<raw_Path>
Components.Path = Matter.component(
	"Path",
	{
		current = 1,
		path = 1,
	} :: raw_Path
)

-- Speed
type raw_Speed = {
	baseSpeed: number,
	speed: number,
}
export type Speed = raw_Speed & Component<raw_Speed>
Components.Speed = Matter.component(
	"Speed",
	{
		baseSpeed = 4,
		speed = 4,
	} :: Speed
)

return Components
