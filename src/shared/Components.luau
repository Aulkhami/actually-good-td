--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

type PartialNewData<T> = { [any]: any } & T

export type Component<T> = {
	patch: (self: T, partialNewData: PartialNewData<T>) -> T & Component<T>,
}

local Components = {}

-- Wave
type raw_Wave = {
	current: number,
}
export type Wave = raw_Wave & Component<Wave>
Components.Wave = Matter.component(
	"Wave",
	{
		current = 1,
	} :: raw_Wave
)

-- WaveMobs
type raw_WaveMobs = {
	current: number,
	count: number,
}
export type WaveMobs = raw_WaveMobs & Component<raw_WaveMobs>
Components.WaveMobs = Matter.component(
	"WaveMobs",
	{
		current = 0,
		count = 0,
	} :: raw_WaveMobs
)

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
type raw_Path = { CFrame }
export type Path = raw_Path & Component<raw_Path>
Components.Path = Matter.component(
	"Path",
	{
		CFrame.identity,
	} :: raw_Path
)

-- PathCurrent
type raw_PathCurrent = {
	current: number,
}
export type PathCurrent = raw_PathCurrent & Component<raw_PathCurrent>
Components.PathCurrent = Matter.component(
	"PathCurrent",
	{
		current = 1,
	} :: raw_PathCurrent
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
