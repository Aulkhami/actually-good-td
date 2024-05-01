local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)

local Types = require(ReplicatedStorage.Types)

type WavesProducer = Reflex.Producer<WavesState, WavesActions>

export type WavesState = { Types.Wave }

export type WavesActions = {
	SetWaves: (waves: { Types.Wave }) -> (),
}

local initialState: WavesState = {}
local wavesSlice: WavesProducer = Reflex.createProducer(initialState, {
	SetWaves = function(_: WavesState, waves: { Types.Wave })
		return waves
	end,
})

return {
	wavesSlice = wavesSlice,
}
