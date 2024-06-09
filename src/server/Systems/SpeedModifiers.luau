local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local Speed = Components.Speed
local PathFinished = Components.PathFinished
local PathBlocked = Components.PathBlocked

local EnumList = require(ReplicatedStorage.Types.EnumList)

local function SpeedModifiers(world: Matter.World)
	for id: number, speed: Components.Speed in world:query(Speed) do
		if world:get(id, PathFinished) or world:get(id, PathBlocked) then
			world:insert(
				id,
				speed:patch({
					speed = 0,
				})
			)

			continue
		end
	end
end

return {
	system = SpeedModifiers,
	priority = EnumList.Priority.Modification,
}
