local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)

local waves = require(script.waves)
local current = require(script.current)
local mobs = require(script.mobs)

type WaveProducer = Reflex.Producer<WaveState, WaveActions>

export type WaveState = {
	waves: waves.WavesState,
	current: current.CurrentWaveState,
	mobs: mobs.MobsState,
}

export type WaveActions = waves.WavesActions & current.CurrentWaveActions & mobs.MobsActions

return Reflex.combineProducers({
	waves = waves.wavesSlice,
	current = current.currentWaveSlice,
	mobs = mobs.mobsSlice,
})
