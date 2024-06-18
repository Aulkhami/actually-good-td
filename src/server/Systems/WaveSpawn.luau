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
local Position = Components.Position
local PositionOffset = Components.PositionOffset
local Path = Components.Path

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

	local path = Store:getState(Selectors.SelectMapPath(currentMob.path or 1))
	local position = CFrame.lookAt(path[1], path[2])
	local rightOffset = (math.random() - 0.5) * Store:getState(Selectors.SelectPathWidth)
	position = position + (position.RightVector * rightOffset)

	world:spawn(
		Mob(),
		Name({
			name = mob.Name,
		} :: Components.Name),
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
		table.unpack(mob.Components())
	)
end

return {
	system = WaveSpawn,
	after = { Wave },
}
