--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Wave = require(script.Parent.Wave)
local Store = require(ServerScriptService.Server.Store)
local Matter = require(ReplicatedStorage.Packages.Matter)
local Selectors = require(ReplicatedStorage.Shared.Selectors)

local Components = require(ReplicatedStorage.Shared.Components)
local Mob = Components.Mob
local Name = Components.Name
local Health = Components.Health
local Position = Components.Position
local PositionOffset = Components.PositionOffset
local Path = Components.Path
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

	local path = Store:getState(Selectors.SelectMapPath(currentMob.path or 1))
	local position = CFrame.lookAt(path[1], path[2])
	local rightOffset = (math.random() - 0.5) * 3 -- TODO: REPLACE WITH MAP GLOBAL STATE
	position = position + (position.RightVector * rightOffset)

	world:spawn(
		Mob(),
		Name({
			name = mob.Name,
		} :: Components.Name),
		Health({
			current = mobStats.Health,
			max = mobStats.Health,
		} :: Components.Health),
		Position({
			position = position,
		} :: Components.Position),
		PositionOffset({
			right = rightOffset,
		} :: Components.PositionOffset),
		Path({
			path = currentMob.path or 1,
			current = 1,
		} :: Components.Path),
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
