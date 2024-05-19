local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local Model = Components.Model
local Position = Components.Position
local Speed = Components.Speed

local EnumList = require(ReplicatedStorage.Types.EnumList)

local function MoveModel(world: Matter.World)
	for id: number, model: Components.ModelComp, _, speed: Components.Speed in world:query(Model, Position, Speed) do
		local primaryPart = model.model.PrimaryPart
		if not primaryPart then
			continue
		end

		--primaryPart.CFrame = primaryPart.CFrame
		--	+ (primaryPart.CFrame.LookVector * (speed.speed * Matter.useDeltaTime()))
	end

	for id: number, record: Components.Record<Components.Position> in world:queryChanged(Position) do
		if not record.new then
			continue
		end

		local model: Components.ModelComp? = world:get(id, Model)
		if not model then
			continue
		end

		local primaryPart = model.model.PrimaryPart
		if not primaryPart then
			continue
		end

		primaryPart.CFrame = record.new.position
	end
end

return {
	system = MoveModel,
	priority = EnumList.Priority.Misc,
}
