--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)
local Immut = require(ReplicatedStorage.Packages.Immut)

type MobsProducer = Reflex.Producer<MobsState, MobsActions>

export type MobsState = {
	current: number,
	count: number,
}

export type MobsActions = {
	IncrementCurrent: () -> (),
	IncrementCount: () -> (),
	ResetState: () -> (),
}

local initialState: MobsState = {
	current = 0,
	count = 0,
}
local mobsSlice: MobsProducer = Reflex.createProducer(initialState, {
	IncrementCurrent = function(state: MobsState)
		return Immut.produce(state, function(draft: MobsState)
			draft.current += 1
			return draft
		end)
	end,
	IncrementCount = function(state: MobsState)
		return Immut.produce(state, function(draft: MobsState)
			draft.count += 1
			return draft
		end)
	end,
	ResetState = function()
		return {
			current = 0,
			count = 0,
		} :: MobsState
	end,
})

return {
	mobsSlice = mobsSlice,
}
