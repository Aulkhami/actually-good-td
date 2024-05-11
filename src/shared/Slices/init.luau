local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)

local wave = require(script.wave)
local map = require(script.map)

type SharedProducer = Reflex.Producer<SharedState, SharedActions>

export type SharedState = {
	wave: wave.WaveState,
	map: map.MapState,
}

export type SharedActions = wave.WaveActions & map.MapActions

return {
	wave = wave,
	map = map,
}
