local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Server = require(ReplicatedStorage.Network.Server)
local Future = require(ReplicatedStorage.Packages.Future)
local Matter = require(ReplicatedStorage.Packages.Matter)
local Signal = require(ReplicatedStorage.Packages.Signal)

local Components = require(ReplicatedStorage.Shared.Components)
local SpawnTower = require(ReplicatedStorage.Shared.SpawnTower)
local Position = Components.Position

local Towers = require(ReplicatedStorage.Shared.Towers)

local EnumList = require(ReplicatedStorage.Types.EnumList)

local PlaceTowerSignal = Signal()
Server.PlaceTowers.SetCallback(function(player: Player, towers: { Server.Tower }): "Fail" | "Success"
	PlaceTowerSignal:Fire(player, towers)

	return "Success"
end)

-- TEMPORARY TEST, PLEASE FUCKING REMOVE LATER
Future.new(function()
	task.wait(20)
	PlaceTowerSignal:Fire(game:GetService("Players")["Rakha2828"], {
		{
			Name = "Scout",
			Position = Vector3.new(-110, 1.2, -110),
			UpgradePath = { 0, 0, 0 },
		},
	})
end)

local function PlaceTower(world: Matter.World)
	for _, player: Player, towers: { Server.Tower } in Matter.useEvent(PlaceTowerSignal, PlaceTowerSignal) do
		for _, tower in towers do
			local towerClass = Towers[tower.Name]
			if not towerClass then
				continue
			end

			-- TODO: check player's money/resource points, and see if the player can actually afford the towers

			-- TODO: check if tower's position is valid

			local id = SpawnTower(world, towerClass, tower.UpgradePath)
			world:insert(
				id,
				Position({
					position = tower.Position,
				})
			)
		end
	end
end

return {
	system = PlaceTower,
	priority = EnumList.Priority.Creation,
}
