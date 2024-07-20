local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)
local Sift = require(ReplicatedStorage.Packages.Sift)
local Squash = require(ReplicatedStorage.Packages.Squash)
local Components = require(ReplicatedStorage.Shared.Components)
local RemoteEvent = ReplicatedStorage.MatterRemote

local function deserializeComponent(
	componentName: string,
	serializedComponent: { [any]: string | { string } }
): { [any]: any }
	local component: Components.Component<any> = Components[componentName]()

	return Sift.Dictionary.map(serializedComponent, function(value, key)
		local dataType = typeof(component[key])

		if dataType == "string" then
			return value
		elseif dataType == "table" then
			if not Sift.Array.is(value) then
				return value
			end

			local arrayDataType = typeof(Components[componentName]()[key][1])
			if arrayDataType == "string" then
				return value
			end

			return Sift.Array.map(value, function(arrayValue: string)
				return Squash[arrayDataType].des(arrayValue)
			end)
		end

		return Squash[dataType].des(value)
	end)
end

local function receiveReplication(world: Matter.World)
	-- A lookup table from server entity IDs to client entity IDs. They're different!
	local entityIdMap = {}

	RemoteEvent.OnClientEvent:Connect(function(entities: {
		[string]: {
			[string]: {
				data: { [any]: string }?,
			},
		},
	})
		-- entities is the data sent from the server. Either the `payload` or `changes` from earlier!

		-- Loop over the entities the server is replicating
		for serverEntityId, componentMap in entities do
			-- Check if we've created this entity on the client before
			local clientEntityId: number = entityIdMap[serverEntityId]

			-- If we've created this entity before, and there are no components inside its list, that means
			-- the entity was despawned on the server. We despawn it here too.
			if clientEntityId and (next(componentMap) == nil) then
				world:despawn(clientEntityId)

				-- Remove it from our lookup table
				entityIdMap[serverEntityId] = nil
				continue
			end

			local componentsToInsert = {}
			local componentsToRemove = {}

			-- Loop over all the components in the entity
			for name, container in componentMap do
				-- If container.data exists, the component was either changed or added.
				if container.data then
					table.insert(componentsToInsert, Components[name](deserializeComponent(name, container.data)))
				else -- if it doesn't exist, it was removed!
					table.insert(componentsToRemove, Components[name])
				end
			end

			-- We haven't created this entity on the client before. create it.
			if clientEntityId == nil then
				clientEntityId = world:spawn(unpack(componentsToInsert))

				-- add the client-side entity id to our lookup table
				entityIdMap[serverEntityId] = clientEntityId
			else -- we've seen this entity before.
				-- Just insert or remove any necessary components.

				if #componentsToInsert > 0 then
					world:insert(clientEntityId, unpack(componentsToInsert))
				end

				if #componentsToRemove > 0 then
					world:remove(clientEntityId, unpack(componentsToRemove))
				end
			end
		end
	end)
end

return receiveReplication
