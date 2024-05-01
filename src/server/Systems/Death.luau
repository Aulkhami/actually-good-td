local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)
local EnumList = require(ReplicatedStorage.Types.EnumList)

local Components = require(ReplicatedStorage.Shared.Components)
local Health = Components.Health

local function Death(world: Matter.World)
	for id: number, health: Components.Health in world:query(Health) do
		if health.current > 0 then
			continue
		end

		-- TODO: add some death animation components or smthn
		-- to signal the client to play a death animation
		-- and wait a couple of seconds for the death animation to play

		world:despawn(id)
	end
end

return {
	system = Death,
	priority = EnumList.Priority.Deletion,
}
