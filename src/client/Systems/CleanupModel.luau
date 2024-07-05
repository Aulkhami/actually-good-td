local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local Model = Components.Model
local Highlight = Components.Highlight
local RangeVisual = Components.RangeVisual

local EnumList = require(ReplicatedStorage.Types.EnumList)

local function CleanupModel(world: Matter.World)
	for _, record: Components.Record<Components.ModelComp> in world:queryChanged(Model) do
		if record.old and not record.new then
			local model = record.old
			model.model:Destroy()
		end
	end

	for _, record: Components.Record<Components.Highlight> in world:queryChanged(Highlight) do
		if record.old and not record.new then
			local model = record.old
			model.part:Destroy()
		end
	end

	for _, record: Components.Record<Components.RangeVisual> in world:queryChanged(RangeVisual) do
		if record.old and not record.new then
			local model = record.old
			model.part:Destroy()
		end
	end
end

return {
	system = CleanupModel,
	priority = EnumList.Priority.Deletion,
}
