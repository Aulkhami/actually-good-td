local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)

local wave = require(script.wave)

type SharedProducer = Reflex.Producer<SharedState, SharedActions>

export type SharedState = {
	wave: wave.WaveState,
}

export type SharedActions = wave.WaveActions

return Reflex.combineProducers({
	wave = wave,
})
