local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local SurfaceGuiEffects = require(ReplicatedStorage.Shared.SurfaceGuiEffects)
local Tower = Components.Tower
local Name = Components.Name
local Position = Components.Position
local TowerUpgrades = Components.TowerUpgrades
local Size = Components.Size
local Model = Components.Model
local PositionOffset = Components.PositionOffset
local Highlight = Components.Highlight

local TowerModels = ReplicatedStorage.Assets.Towers

local Types = require(ReplicatedStorage.Types)
local EnumList = require(ReplicatedStorage.Types.EnumList)

local function TowerModel(world: Matter.World)
	for
		id: number,
		_,
		name: Components.Name,
		position: Components.Position,
		upgrades: Components.TowerUpgrades,
		size: Components.Size
	in world:query(Tower, Name, Position, TowerUpgrades, Size):without(Model) do
		local towerModel: Types.TowerModel = TowerModels:FindFirstChild(name.name)
		if not towerModel then
			error(`Model missing for tower {name.name}`)
		end
		local upgradesFolder = towerModel.Upgrades

		local model = towerModel.Base:Clone()
		-- Set the correct model appearance according to the Tower's upgrade levels
		for path, level in upgrades.upgrades do
			if level == 0 then
				continue
			end

			local upgradePathFolder: Folder = upgradesFolder:FindFirstChild(tostring(path))
			if not upgradePathFolder then
				continue
			end

			for i = 1, level, 1 do
				local upgradeAsset = upgradePathFolder:FindFirstChild(tostring(i)) :: Types.UpgradeAsset
				if not upgradeAsset then
					continue
				end

				local assembleFunc = require(upgradeAsset.Assemble) :: Types.AssembleFunc
				assembleFunc(model)
			end
		end

		local root = model.HumanoidRootPart
		local rightLeg = model["Right Leg"]
		local upOffset = (root.Size.Y / 2) + rightLeg.Size.Y

		root.CFrame = position.position + (position.position.UpVector * upOffset)
		model.Parent = Workspace

		local highlightPart = SurfaceGuiEffects.GetHighlight(position.position.Position, size.size)

		world:insert(
			id,
			Model({ model = model }),
			PositionOffset({ up = upOffset }),
			Highlight({ part = highlightPart })
		)
	end
end

return {
	system = TowerModel,
	priority = EnumList.Priority.Creation,
}
