local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)
local Sift = require(ReplicatedStorage.Packages.Sift)

local SharedSlices = require(ReplicatedStorage.Shared.Slices)
--local ServerSlices = require(script.Slices)

export type RootProducer = Reflex.Producer<RootState, RootActions>

export type RootState = SharedSlices.SharedState --& ServerSlices.ServerState
export type RootActions = SharedSlices.SharedActions --& ServerSlices.ServerActions

local Slices = {}
Slices = Sift.Dictionary.merge(Slices, SharedSlices)
--Slices = TableUtil.Assign(Slices, ServerSlices)

local RootProducer: RootProducer = Reflex.combineProducers(Slices)

--[[
local broadcaster = Reflex.createBroadcaster({
	producers = SharedSlices,

	dispatch = function(player: Player, actions)
		--Net:Fire(player, "Dispatch", actions)
	end,
})

Net:On("Start", function(player)
	broadcaster:start(player)
end)

RootProducer:applyMiddleware(broadcaster.middleware)
]]

return RootProducer
