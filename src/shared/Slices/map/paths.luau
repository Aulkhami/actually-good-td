local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)
local Types = require(ReplicatedStorage.Types)

type PathsProducer = Reflex.Producer<PathsState, PathsActions>

export type PathsState = { Types.Path }

export type PathsActions = {
	SetMapPaths: (paths: { Types.Path }) -> (),
}

local initialState: PathsState = {}
local pathsSlice: PathsProducer = Reflex.createProducer(initialState, {
	SetMapPaths = function(_, paths: { Types.Path })
		return paths
	end,
})

return {
	pathsSlice = pathsSlice,
}
