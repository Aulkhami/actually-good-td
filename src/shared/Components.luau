--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)
export type Component = typeof(Matter.component()())

local Components = {}

-- Wave
export type Wave = {
	current: number,
}
Components.Wave = Matter.component(
	"Wave",
	{
		current = 0,
	} :: Wave
)

-- WaveMobs
export type WaveMobs = {
	current: number,
	count: number,
}
Components.WaveMobs = Matter.component(
	"WaveMobs",
	{
		current = 0,
		count = 0,
	} :: WaveMobs
)

-- Health
export type Health = {
	current: number,
	max: number,
}
Components.Health = Matter.component(
	"Health",
	{
		current = 100,
		max = 100,
	} :: Health
)

-- Position
export type Position = {
	position: CFrame,
}
Components.Position = Matter.component(
	"Position",
	{
		position = CFrame.identity,
	} :: Position
)

-- Mob
export type Mob = {}
Components.Mob = Matter.component("Mob", {} :: Mob)

-- Path
export type Path = { CFrame }
Components.Path = Matter.component(
	"Path",
	{
		CFrame.identity,
	} :: Path
)

-- PathCurrent
export type PathCurrent = {
	current: number,
}
Components.PathCurrent = Matter.component(
	"PathCurrent",
	{
		current = 1,
	} :: PathCurrent
)

-- Speed
export type Speed = {
	baseSpeed: number,
	speed: number,
}
Components.Speed = Matter.component(
	"Speed",
	{
		baseSpeed = 4,
		speed = 4,
	} :: Speed
)

return Components
