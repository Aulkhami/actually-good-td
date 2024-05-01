--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Wave = require(script.Parent.Wave)
local Store = require(ServerScriptService.Server.Store)
local Matter = require(ReplicatedStorage.Packages.Matter)
local Selectors = require(ReplicatedStorage.Shared.Selectors)

local Components = require(ReplicatedStorage.Shared.Components)
local Mob = Components.Mob
local Health = Components.Health
local Position = Components.Position
local Path = Components.Path
local PathCurrent = Components.PathCurrent
local Speed = Components.Speed

local function WaveSpawn(world: Matter.World)
	local waveState = Store:getState(Selectors.SelectCurrentWave)
	if not waveState then
		return
	end

	local mobState = Store:getState(Selectors.SelectWaveMobState)
	local currentMob = waveState.mobs[mobState.current]

	if not currentMob then
		return
	end

	if not Matter.useThrottle(currentMob.spawnDelay or waveState.spawnDelay) then
		return
	end

	if mobState.count >= currentMob.count then
		Store.IncrementMobsCurrent()
		mobState = Store:getState(Selectors.SelectWaveMobState)

		currentMob = waveState.mobs[mobState.current]
		if not currentMob then
			return
		end
	end

	Store.IncrementMobsCount()

	local mob = currentMob.mob
	local mobStats = mob.Stats

	world:spawn(
		Mob(),
		Health({
			current = mobStats.Health,
			max = mobStats.Health,
		} :: Components.Health),
		Position({
			-- TODO: add spawn position from map state
		} :: Components.Position),
		Path({
			-- TODO: get path from map state
		} :: Components.Path),
		PathCurrent(),
		Speed({
			speed = mobStats.Speed,
			baseSpeed = mobStats.Speed,
		} :: Components.Speed),
		table.unpack(mob.Components())
	)
end

return {
	system = WaveSpawn,
	after = { Wave },
}
