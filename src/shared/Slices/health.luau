local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)

type HealthProducer = Reflex.Producer<HealthState, HealthActions>

export type HealthState = number

export type HealthActions = {
	SetHealth: (health: number) -> (),
	IncrementHealth: (increment: number) -> (),
}

local initialState: HealthState = 0
local healthSlice: HealthProducer = Reflex.createProducer(initialState, {
	SetHealth = function(_, health: number)
		return health
	end,
	IncrementHealth = function(state: HealthState, increment: number)
		return state + increment
	end,
})

return {
	healthSlice = healthSlice,
}
