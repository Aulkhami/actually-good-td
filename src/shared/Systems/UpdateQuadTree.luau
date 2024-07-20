local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local Tower = Components.Tower
local Mob = Components.Mob
local GhostPlacement = Components.GhostPlacement
local Position = Components.Position

local Types = require(ReplicatedStorage.Types)
local EnumList = require(ReplicatedStorage.Types.EnumList)

local function UpdateQuadTree(world: Matter.World, state: Types.GlobalState)
	for id: number, record: Components.Record<Components.Position> in world:queryChanged(Position) do
		local strId = tostring(id)

		local positionComp = record.new
		if not positionComp then
			state.mobQuadTree:Remove(strId)
			state.towerQuadTree:Remove(strId)

			continue
		end

		if world:get(id, GhostPlacement) then
			continue
		end

		local quadTree
		if world:get(id, Tower) then
			quadTree = state.towerQuadTree
		elseif world:get(id, Mob) then
			quadTree = state.mobQuadTree
		else
			continue
		end

		local point = {
			position = Vector2.new(positionComp.position.X, positionComp.position.Y),
			id = strId,
		}

		if quadTree.references[strId] then
			quadTree:UpdatePoint(point)
		else
			quadTree:Insert(point)
		end
	end
end

return {
	system = UpdateQuadTree,
	priority = EnumList.Priority.Creation - 1,
}
