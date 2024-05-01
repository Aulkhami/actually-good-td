local Slices = require(script.Parent.Slices)

local Selectors = {}

function Selectors.SelectCurrentWaveNumber(state: Slices.SharedState)
	return state.wave.current
end

function Selectors.SelectCurrentWave(state: Slices.SharedState)
	return state.wave.waves[state.wave.current]
end

function Selectors.SelectWaveMobState(state: Slices.SharedState)
	return state.wave.mobs
end

return Selectors
