local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local Model = Components.Model

local EnumList = require(ReplicatedStorage.Types.EnumList)

local function CleanupModel(world: Matter.World)
	for _, record: Components.Record<Components.ModelComp> in world:queryChanged(Model) do
		if record.old and not record.new then
			local model = record.old
			model.model:Destroy()
		end
	end
end

return {
	system = CleanupModel,
	priority = EnumList.Priority.Deletion,
}
