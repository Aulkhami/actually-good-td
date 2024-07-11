local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Client = require(ReplicatedStorage.Network.Client)
local Future = require(ReplicatedStorage.Packages.Future)
local Matter = require(ReplicatedStorage.Packages.Matter)
local Sift = require(ReplicatedStorage.Packages.Sift)

local Components = require(ReplicatedStorage.Shared.Components)
local Tower = Components.Tower
local GhostPlacement = Components.GhostPlacement
local Selected = Components.Selected
local Model = Components.Model
local Size = Components.Size
local Position = Components.Position
local PositionOffset = Components.PositionOffset
local Name = Components.Name
local TowerUpgrades = Components.TowerUpgrades

local GlobalUIState = require(ReplicatedStorage.Shared.GlobalUIState)
local SpawnTower = require(ReplicatedStorage.Shared.SpawnTower)
local Towers = require(ReplicatedStorage.Shared.Towers)

local Types = require(ReplicatedStorage.Types)
local EnumList = require(ReplicatedStorage.Types.EnumList)

local ModelAssets = ReplicatedStorage.Assets

-- Constants
local RAYCAST_PARAMS = RaycastParams.new()
RAYCAST_PARAMS.CollisionGroup = "Placement"

local function TowerPlacementGhost(world: Matter.World, tower: Types.Tower, upgrades: { number })
	-- Highlighting the placement areas
	for _, placementPart: BasePart in CollectionService:GetTagged("PlacementArea") do
		if placementPart:GetAttribute("PlacementArea") == tower.PlacementArea then
			placementPart.Color = Color3.new(0, 1, 0)
			placementPart.Transparency = 0.9
		else
			placementPart.Color = Color3.new(1, 0, 0)
			placementPart.Transparency = 0.5
		end
	end

	-- Setting up the tower's placement ghost model thing
	local towerModel: Types.TowerModel =
		assert(ModelAssets.Towers:FindFirstChild(tower.Name), `Missing model for tower {tower.Name}`)
	local ghostModel = towerModel.Base:Clone()
	-- todo: do something about the upgrades model
	for _, inst in ghostModel:GetDescendants() do
		if inst:IsA("BasePart") then
			inst.CanCollide = false
			inst.CanTouch = false
		end
	end

	local highlight = Instance.new("Highlight")
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.FillColor = Color3.new(1, 1, 1)
	highlight.FillTransparency = 0.9
	highlight.OutlineColor = Color3.new(1, 1, 1)
	highlight.OutlineTransparency = 0.1
	highlight.Parent = ghostModel

	ghostModel.Parent = Workspace

	local ghostTowerId = SpawnTower(world, tower, upgrades)
	local ghostSize: Components.Size = world:get(ghostTowerId, Size)

	local position = Players.LocalPlayer:GetMouse().Hit.Position
	local upOffset = ghostModel["Right Leg"].Size.Y + (ghostModel["HumanoidRootPart"].Size.Y / 2)

	world:insert(
		ghostTowerId,
		GhostPlacement(),
		Model({ model = ghostModel }),
		Size({ size = ghostSize.size }),
		Position({ position = CFrame.new(position) }),
		PositionOffset({ up = upOffset }),
		Selected()
	)
end

local function RemovePlacementGhosts(world: Matter.World)
	for id, _ in world:query(GhostPlacement) do
		world:despawn(id)
	end

	-- De-highlighting the placement areas
	for _, placementPart: BasePart in CollectionService:GetTagged("PlacementArea") do
		placementPart.Transparency = 1
	end
end

local function PositionPlacementGhosts(world: Matter.World)
	local mouse = Players.LocalPlayer:GetMouse()
	local raycastResult = Workspace:Raycast(mouse.Origin.Position, mouse.UnitRay.Direction * 1000, RAYCAST_PARAMS)

	if not raycastResult then
		GlobalUIState.CanPlace:set(false)
		return
	end

	local placementPos = raycastResult.Position
	local placementArea = raycastResult.Instance:GetAttribute("PlacementArea")

	for id: number, _, position: Components.Position, name: Components.Name, model: Components.ModelComp in
		world:query(GhostPlacement, Position, Name, Model)
	do
		-- Position the ghost placement model
		world:insert(id, position:patch({ position = position.position.Rotation + placementPos }))

		-- Check if the tower can be placed on the placementArea or not
		local towerClass = Towers[name.name]
		local ghostModel = model.model :: Types.HumanoidlessCharacter & { Highlight: Highlight }
		local highlight = ghostModel.Highlight

		if placementArea ~= towerClass.PlacementArea then
			GlobalUIState.CanPlace:set(false)

			highlight.FillTransparency = 0.5
			highlight.FillColor = Color3.new(1, 0, 0)
		else
			highlight.FillTransparency = 0.9
			highlight.FillColor = Color3.new(1, 1, 1)
		end
	end
end

local function PlaceDownTower(world: Matter.World)
	if not Matter.useEvent(Players.LocalPlayer:GetMouse(), "Button1Up")() then
		return
	end

	local snapshotQuery = world:query(Tower, GhostPlacement, Name, TowerUpgrades, Position):snapshot()
	local query: { Client.Tower } = Sift.Array.map(snapshotQuery, function(value)
		local _, _, _, name: Components.Name, upgrades: Components.TowerUpgrades, position: Components.Position =
			table.unpack(value)

		return {
			Name = name.name,
			UpgradePath = Sift.Array.copy(upgrades.upgrades),
			Position = position.position,
		}
	end)

	Client.PlaceTowers.Call(query)

	if
		not (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl))
	then
		RemovePlacementGhosts(world)
		GlobalUIState.CurrentScreen:set("None" :: GlobalUIState.CurrentScreen)
	end
end

local function PlaceTower(world: Matter.World)
	-- Tower deselected from GUI
	if Matter.useEvent(GlobalUIState, "PlaceTowerCancelSignal")() then
		RemovePlacementGhosts(world)
		GlobalUIState.CurrentScreen:set("None" :: GlobalUIState.CurrentScreen)
	end

	-- Place down the tower ghost placement
	if GlobalUIState.CurrentScreen:get() == "PlaceTowers" then
		PlaceDownTower(world)
	end

	-- Tower selected from GUI
	local _, tower: Types.Tower, upgrades: { number } = Matter.useEvent(GlobalUIState, "PlaceTowerSignal")()
	if tower then
		TowerPlacementGhost(world, tower, upgrades)

		Future.new(function(state: GlobalUIState.Type)
			task.wait(0.1)
			state.CurrentScreen:set("PlaceTowers" :: GlobalUIState.CurrentScreen)
		end, GlobalUIState)
	end

	-- Position the tower ghost placement
	if GlobalUIState.CurrentScreen:get() == "PlaceTowers" then
		PositionPlacementGhosts(world)
	end
end

return {
	system = PlaceTower,
	priority = EnumList.Priority.Creation,
	event = "PostInput",
}
