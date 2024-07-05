--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)
local Types = require(ReplicatedStorage.Types)

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

-- TowerUpgrades
type raw_TowerUpgrades = { [number]: number }
export type TowerUpgrades = raw_TowerUpgrades & Component<raw_TowerUpgrades>
Components.TowerUpgrades = Matter.component(
	"TowerUpgrades",
	{
		[1] = 0,
		[2] = 0,
		[3] = 0,
	} :: TowerUpgrades
) :: Constructor<raw_TowerUpgrades>

-- Attack
type raw_Attack = {
	attack: number,
	interval: number,
}
export type Attack = raw_Attack & Component<raw_Attack>
Components.Attack = Matter.component(
	"Attack",
	{
		attack = 20,
		interval = 1,
	} :: Attack
) :: Constructor<raw_Attack>

-- Range
type raw_Range = {
	range: number,
}
export type Range = raw_Range & Component<raw_Range>
Components.Range = Matter.component(
	"Range",
	{
		range = 15,
	} :: Range
) :: Constructor<raw_Range>

-- Defense
type raw_Defense = {
	defense: number,
}
export type Defense = raw_Defense & Component<raw_Defense>
Components.Defense = Matter.component(
	"Defense",
	{
		defense = 0,
	} :: Defense
) :: Constructor<raw_Defense>

-- Size
type raw_Size = {
	size: number,
}
export type Size = raw_Size & Component<raw_Size>
Components.Size = Matter.component(
	"Size",
	{
		size = 5,
	} :: Size
) :: Constructor<raw_Size>

-- GhostPlacement
export type GhostPlacement = {}
Components.GhostPlacement = Matter.component("GhostPlacement", {} :: GhostPlacement)

-- RangeVisual
type raw_RangeVisual = {
	part: Types.HighlightPart,
}
export type RangeVisual = raw_RangeVisual & Component<raw_RangeVisual>
Components.RangeVisual = Matter.component("RangeVisual", {} :: RangeVisual) :: Constructor<raw_RangeVisual>

-- Highlight
type raw_Highlight = {
	part: Types.HighlightPart,
}
export type Highlight = raw_Highlight & Component<raw_Highlight>
Components.Highlight = Matter.component("Highlight", {} :: Highlight) :: Constructor<raw_Highlight>

-- Selected
export type Selected = {}
Components.Selected = Matter.component("Selected", {} :: Selected)

return Components
