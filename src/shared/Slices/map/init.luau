local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)

local paths = require(script.paths)

type MapProducer = Reflex.Producer<MapState, MapActions>

export type MapState = {
	paths: paths.PathsState,
}

export type MapActions = paths.PathsActions

return Reflex.combineProducers({
	paths = paths.pathsSlice,
})
