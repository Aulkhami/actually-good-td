local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Store = require(ServerScriptService.Server.Store)
local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local Mob = Components.Mob

local useDelay = require(ReplicatedStorage.Shared.Hooks.useDelay)
local Selectors = require(ReplicatedStorage.Shared.Selectors)

-- TEMPORARY
local GRACE_PERIOD = 20
local DEFAULT_STALL = 30

local function WaveSys(world: Matter.World)
	local waveState = Store:getState(Selectors.SelectCurrentWave)
	local mobState = Store:getState(Selectors.SelectWaveMobState)

	if not waveState then
		-- TODO: actually do stuff
		return
	end

	if mobState.current == 0 then
		if not useDelay(GRACE_PERIOD) then
			return
		end

		Store.IncrementMobsCurrent()
		mobState = Store:getState(Selectors.SelectWaveMobState)
	end

	if mobState.current <= #waveState.mobs then
		return
	end

	local nextMob = world:query(Mob):next()
	if nextMob then
		if not useDelay(waveState.waveStall or DEFAULT_STALL) then
			return
		end
	end

	-- If there are no more mobs remaining, or the stall timer has run out, go to the next wave
	Store.NextWave()
end

return {
	system = WaveSys,
	priority = 1,
}
