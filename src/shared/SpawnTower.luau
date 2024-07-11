local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local Tower = Components.Tower
local Name = Components.Name
local TowerUpgrades = Components.TowerUpgrades

local Types = require(ReplicatedStorage.Types)

local function SpawnTower(world: Matter.World, tower: Types.Tower, upgrades: { number })
	local id: number = world:spawn(
		Tower(),
		TowerUpgrades({
			upgrades = upgrades,
		}),
		Name({
			name = tower.Name,
		}),
		table.unpack(tower.Components())
	)

	for upgradePathNum, upgradeLevel in upgrades do
		if upgradeLevel == 0 then
			continue
		end

		local upgradePath = tower.UpgradePath[upgradePathNum]
		for i = 1, upgradeLevel, 1 do
			local upgrade = upgradePath.Upgrades[i]
			world:insert(id, table.unpack(upgrade.Insert(world, id)))
			world:remove(id, table.unpack(upgrade.Remove(world, id)))
		end
	end

	return id
end

return SpawnTower
