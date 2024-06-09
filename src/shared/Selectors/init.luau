local Slices = require(script.Parent.Slices)

local Selectors = {}

--# Wave Selectors

function Selectors.SelectCurrentWaveNumber(state: Slices.SharedState)
	return state.wave.current
end

function Selectors.SelectCurrentWave(state: Slices.SharedState)
	return state.wave.waves[state.wave.current]
end

function Selectors.SelectWaveMobState(state: Slices.SharedState)
	return state.wave.mobs
end

--# Map Selectors

function Selectors.SelectMapAllPaths(state: Slices.SharedState)
	return state.map.paths
end

function Selectors.SelectMapPath(path: number)
	return function(state: Slices.SharedState)
		return state.map.paths[path]
	end
end

function Selectors.SelectPathWidth(state: Slices.SharedState)
	return state.map.pathWidth
end

return Selectors
