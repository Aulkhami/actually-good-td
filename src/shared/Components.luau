--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

type PartialNewData<T> = { [any]: any } & T

type Constructor<T> = (data: PartialNewData<T>) -> Component<T>

export type Component<T> = {
	patch: (self: T, partialNewData: PartialNewData<T>) -> T & Component<T>,
}

export type Record<T> = {
	old: T?,
	new: T?,
}

local Components = {}

-- Name
type raw_Name = {
	name: string,
}
export type Name = raw_Name & Component<raw_Name>
Components.Name = Matter.component(
	"Name",
	{
		name = "Bob",
	} :: Name
) :: Constructor<raw_Name>

-- Model
type raw_Model = {
	model: Model,
}
export type ModelComp = raw_Model & Component<raw_Model>
Components.Model = Matter.component(
	"Model",
	{
		model = Instance.new("Model"),
	} :: raw_Model
) :: Constructor<raw_Model>

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
) :: Constructor<raw_Health>

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
) :: Constructor<raw_Position>

-- PositionOffset
type raw_PositionOffset = {
	up: number,
	look: number,
	right: number,
}
export type PositionOffset = raw_PositionOffset & Component<raw_PositionOffset>
Components.PositionOffset = Matter.component(
	"PositionOffset",
	{
		up = 0,
		look = 0,
		right = 0,
	} :: PositionOffset
) :: Constructor<raw_PositionOffset>

-- ClientPosition
type raw_ClientPosition = {
	position: CFrame,
}
export type ClientPosition = raw_ClientPosition & Component<raw_ClientPosition>
Components.ClientPosition = Matter.component(
	"ClientPosition",
	{
		position = CFrame.identity,
	} :: ClientPosition
) :: Constructor<raw_ClientPosition>

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
) :: Constructor<raw_Path>

-- PathBlocked
type raw_PathBlocked = {}
export type PathBlocked = raw_PathBlocked & Component<raw_PathBlocked>
Components.PathBlocked = Matter.component("PathBlocked", {} :: PathBlocked)

-- PathFinished
type raw_PathFinished = {}
export type PathFinished = raw_PathFinished & Component<raw_PathFinished>
Components.PathFinished = Matter.component("PathFinished", {} :: PathFinished)

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
) :: Constructor<raw_Speed>

-- Tower
export type Tower = {}
Components.Tower = Matter.component("Tower", {} :: Tower)

return Components
