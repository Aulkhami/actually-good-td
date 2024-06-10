local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local Position = Components.Position
local ClientPosition = Components.ClientPosition
local Speed = Components.Speed

local EnumList = require(ReplicatedStorage.Types.EnumList)

local function ClientPositioning(world: Matter.World)
	for id: number, clientPos: Components.ClientPosition, speed: Components.Speed in world:query(ClientPosition, Speed) do
		world:insert(
			id,
			clientPos:patch({
				position = clientPos.position + (clientPos.position.LookVector * (speed.speed * Matter.useDeltaTime())),
			})
		)
	end

	for id: number, record: Components.Record<Components.Position> in world:queryChanged(Position) do
		if record.new then
			world:insert(
				id,
				ClientPosition({
					position = record.new.position,
				} :: Components.ClientPosition)
			)
		elseif record.old and world:contains(id) then
			world:remove(id, ClientPosition)
		end
	end
end

return {
	system = ClientPositioning,
	priority = EnumList.Priority.Creation,
}
