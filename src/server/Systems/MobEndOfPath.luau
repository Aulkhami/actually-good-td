local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Store = require(ServerScriptService.Server.Store)
local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local Health = Components.Health
local Mob = Components.Mob
local PathFinished = Components.PathFinished

local EnumList = require(ReplicatedStorage.Types.EnumList)

local function MobEndOfPath(world: Matter.World)
	for id: number, health: Components.Health, _, _ in world:query(Health, Mob, PathFinished) do
		if health.current > 0 then
			Store.IncrementHealth(-health.current)
			world:despawn(id)
		end
	end
end

return {
	system = MobEndOfPath,
	priority = EnumList.Priority.Deletion,
}
