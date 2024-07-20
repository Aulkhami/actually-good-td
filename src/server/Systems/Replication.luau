local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)
local Sift = require(ReplicatedStorage.Packages.Sift)
local Components = require(ReplicatedStorage.Shared.Components)
local SerializeDeep = require(ReplicatedStorage.Utility.SerializeDeep)
local RemoteEvent = ReplicatedStorage.MatterRemote

local REPLICATED_COMPONENTS = {
	"Health",
	"Position",
	"Mob",
	"Name",
	"Speed",
	"Tower",
	"TowerUpgrades",
	"Size",
}
local replicatedComponents: { [Components.Component<any>]: boolean } = {}

for _, name in REPLICATED_COMPONENTS do
	replicatedComponents[Components[name]] = true
end

local function Replication(world: Matter.World)
	-- Create a table to buffer up our changes so we only send out at most one remote event per frame
	local changes = {}

	-- Loop over our table of replicated components
	for component in replicatedComponents do
		-- Loop over queryChanged for this component
		for entityId: number, record: { new: { [any]: any }?, old: { [any]: any }? } in world:queryChanged(component) do
			-- We convert the entity ID to a string because tables sent over remote events in Roblox
			-- can only have string keys. (did I just teach you something new?)
			local key = tostring(entityId)

			-- Get the name of the component. This is done with tostring as well because components have
			-- a custom __tostring metamethod that returns their human-readable name.
			local name = tostring(component)

			-- If there aren't any changes from this entity in the buffer so far, create the table for it
			if changes[key] == nil then
				changes[key] = {}
			end

			-- Only send over the changed component if the entity still exists in our world.
			if world:contains(entityId) then
				-- Lua tables can't contain nil as values, this is indistinguishable from the key just
				-- not existing at all.
				-- Instead, we set all values to a table, and then create a key inside that for the real
				-- value. This lets us detect when a component is removed (set to nil)
				if record.new then
					changes[key][name] = { data = SerializeDeep(record.new) }
				else
					changes[key][name] = {}
				end
			end
		end

		-- Check if there are any changes in our buffer before sending the changes to all clients.
		if not Sift.isEmpty(changes) then
			RemoteEvent:FireAllClients(changes)
		end
	end

	-- Run some code every time a player joins
	for _, player in Matter.useEvent(Players, "PlayerAdded") do
		local payload = {}

		-- Loop over the entire World using the world's __iter metamethod implementation
		for entityId: number, entityData: { [Components.Component<any>]: { [any]: any } } in world do
			local entityPayload = {}

			-- Loop over all the components the entity has
			for component, componentData in entityData do
				-- Only if it's in our list of replicated components...
				if replicatedComponents[component] then
					-- Add it to the data we're sending for this entity
					entityPayload[tostring(component)] = { data = SerializeDeep(componentData) }
				end
			end

			-- Add the entity data to our overall payload
			payload[tostring(entityId)] = entityPayload
		end

		RemoteEvent:FireClient(player, payload)
	end
end

return {
	system = Replication,
	priority = math.huge,
}
