local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

local GlobalUIState = require(ReplicatedStorage.Shared.GlobalUIState)
local EnumList = require(ReplicatedStorage.Types.EnumList)

local function UpdateUIState(world: Matter.World)
	-- THIS IS A TEMPORARY SOLUTION
	GlobalUIState.WorldStateUpdate:Fire(world)
end

return {
	system = UpdateUIState,
	priority = EnumList.Priority.Misc,
}
