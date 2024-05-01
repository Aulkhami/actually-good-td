local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)

type CurrentWaveProducer = Reflex.Producer<CurrentWaveState, CurrentWaveActions>

export type CurrentWaveState = number

export type CurrentWaveActions = {
	NextWave: () -> (),
}

local initialState: CurrentWaveState = 0
local currentWaveSlice: CurrentWaveProducer = Reflex.createProducer(initialState, {
	NextWave = function(state: CurrentWaveState)
		return state + 1
	end,
})

return {
	currentWaveSlice = currentWaveSlice,
}
