local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local ClientPosition = Components.ClientPosition
local PositionOffset = Components.PositionOffset
local Model = Components.Model

local EnumList = require(ReplicatedStorage.Types.EnumList)

local function ModelPosition(world: Matter.World)
	for id: number, record: Components.Record<Components.ClientPosition> in world:queryChanged(ClientPosition) do
		if not record.new then
			continue
		end
		local position = record.new

		local model: Components.ModelComp? = world:get(id, Model)
		if not model then
			continue
		end

		local rootPart = model.model.PrimaryPart
		if not rootPart then
			return
		end

		local finalCF = position.position
		local posOffset: Components.PositionOffset? = world:get(id, PositionOffset)
		if posOffset then
			finalCF = finalCF + (finalCF.UpVector * posOffset.up)
			finalCF = finalCF + (finalCF.RightVector * posOffset.right)
			finalCF = finalCF + (finalCF.LookVector * posOffset.look)
		end

		rootPart.CFrame = finalCF
	end
end

return {
	system = ModelPosition,
	priority = EnumList.Priority.Misc,
}
