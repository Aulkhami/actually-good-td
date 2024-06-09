local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)

local paths = require(script.paths)
local pathWidth = require(script.pathWidth)

type MapProducer = Reflex.Producer<MapState, MapActions>

export type MapState = {
	paths: paths.PathsState,
	pathWidth: pathWidth.PathWidthState,
}

export type MapActions = paths.PathsActions & pathWidth.PathWidthActions

return Reflex.combineProducers({
	paths = paths.pathsSlice,
	pathWidth = pathWidth.pathWidthSlice,
})
