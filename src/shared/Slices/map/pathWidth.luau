local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)

type PathWidthProducer = Reflex.Producer<PathWidthState, PathWidthActions>

export type PathWidthState = number

export type PathWidthActions = {
	SetPathWidth: (width: number) -> (),
}

local initialState: PathWidthState = 2
local pathWidthSlice: PathWidthProducer = Reflex.createProducer(initialState, {
	SetPathWidth = function(_, width: number)
		return width
	end,
})

return {
	pathWidthSlice = pathWidthSlice,
}
