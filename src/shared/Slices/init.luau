local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)

local wave = require(script.wave)
local map = require(script.map)
local health = require(script.health)

type SharedProducer = Reflex.Producer<SharedState, SharedActions>

export type SharedState = {
	wave: wave.WaveState,
	map: map.MapState,
	health: health.HealthState,
}

export type SharedActions = wave.WaveActions & map.MapActions & health.HealthActions

return {
	wave = wave,
	map = map,
	health = health.healthSlice,
}
