local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Matter = require(ReplicatedStorage.Packages.Matter)
local Components = require(ReplicatedStorage.Shared.Components)
local Mob = Components.Mob
local Name = Components.Name
local Model = Components.Model
local Position = Components.Position
local PositionOffset = Components.PositionOffset

local Types = require(ReplicatedStorage.Types)
local EnumList = require(ReplicatedStorage.Types.EnumList)

local function MobModel(world: Matter.World)
	for id: number, _, name: Components.Name, position: Components.Position in
		world:query(Mob, Name, Position):without(Model)
	do
		local model: Types.HumanoidlessCharacter = ReplicatedStorage.Assets.Mobs:FindFirstChild(name.name)
		assert(model, `Model for mob {name.name} is missing`)
		model = model:Clone()

		local root = model.HumanoidRootPart
		local rightLeg = model["Right Leg"]
		local upOffset = (root.Size.Y / 2) + rightLeg.Size.Y - 0.5 -- TODO: CHANGE THIS -0.5 ONCE MAP STATE ON WAYPOINT HEIGHT EXISTS

		root.CFrame = position.position + (position.position.UpVector * upOffset)
		model.Parent = Workspace

		world:insert(
			id,
			Model({
				model = model,
			} :: Components.ModelComp),
			PositionOffset({
				up = upOffset,
			} :: Components.PositionOffset)
		)
	end
end

return {
	system = MobModel,
	priority = EnumList.Priority.Creation,
}
