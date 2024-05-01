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
	IncrementMobsCurrent: () -> (),
	IncrementMobsCount: () -> (),
	NextWave: () -> (),
	ResetMobsState: () -> (),
	ResetState: () -> (),
}

local initialState: MobsState = {
	current = 0,
	count = 0,
}
local function ResetMobsState()
	return {
		current = 0,
		count = 0,
	} :: MobsState
end
local mobsSlice: MobsProducer = Reflex.createProducer(initialState, {
	IncrementMobsCurrent = function(state: MobsState)
		return Immut.produce(state, function(draft: MobsState)
			draft.current += 1
			draft.count = 0

			return draft
		end)
	end,
	IncrementMobsCount = function(state: MobsState)
		return Immut.produce(state, function(draft: MobsState)
			draft.count += 1
			return draft
		end)
	end,

	NextWave = ResetMobsState,
	ResetMobsState = ResetMobsState,
	ResetState = ResetMobsState,
})

return {
	mobsSlice = mobsSlice,
}
