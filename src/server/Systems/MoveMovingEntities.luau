local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Store = require(ServerScriptService.Server.Store)
local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local Selectors = require(ReplicatedStorage.Shared.Selectors)
local Position = Components.Position
local PositionOffset = Components.PositionOffset
local Speed = Components.Speed
local Path = Components.Path
local PathBlocked = Components.PathBlocked
local PathFinished = Components.PathFinished

local EnumList = require(ReplicatedStorage.Types.EnumList)
local Types = require(ReplicatedStorage.Types)

local function getSubjectiveWaypoint(pathArray: Types.Path, path: Components.Path, rightOffset: number)
	local currentWaypoint = pathArray[path.current]
	local lastWaypoint: Vector3? = pathArray[path.current - 1]
	local nextWaypoint: Vector3? = pathArray[path.current + 1]

	if not lastWaypoint then
		if not nextWaypoint then
			return currentWaypoint
		end

		return currentWaypoint + (CFrame.lookAt(currentWaypoint, nextWaypoint).RightVector * rightOffset)
	end

	local lastToCurrent = CFrame.lookAt(lastWaypoint, currentWaypoint)
	local currentLookVector = lastToCurrent.LookVector
	local currentRightVector = lastToCurrent.RightVector

	if not nextWaypoint then
		return currentWaypoint + (currentRightVector * rightOffset)
	end

	local nextLookVector = CFrame.lookAt(currentWaypoint, nextWaypoint).LookVector
	local turnAngle = math.atan2(
		(nextLookVector.Z * currentLookVector.X) - (nextLookVector.X * currentLookVector.Z),
		(nextLookVector.X * currentLookVector.X) + (nextLookVector.Z * currentLookVector.Z)
	)

	return currentWaypoint
		+ (currentRightVector * rightOffset)
		- (currentLookVector * (rightOffset / math.tan(turnAngle / 2)))
end

local function MoveMovingEntities(world: Matter.World)
	for id: number, position: Components.Position, speed: Components.Speed, path: Components.Path in
		world:query(Position, Speed, Path):without(PathBlocked, PathFinished)
	do
		local newPath = path
		local newPosition = position

		-- Get the actual path
		local pathArray = Store:getState(Selectors.SelectMapPath(path.path))
		local currentWaypoint = pathArray[newPath.current]
		if not currentWaypoint then
			world:insert(id, PathFinished())
			continue
		end

		-- Calculate the new waypoint if the entity has a position offset
		local offsets: Components.PositionOffset? = world:get(id, PositionOffset)
		if offsets and (offsets.right ~= 0) then
			currentWaypoint = getSubjectiveWaypoint(pathArray, newPath, offsets.right)
		end

		-- If the entity has reached the waypoint, then update the current waypoint
		if position.position.Position == currentWaypoint then
			newPath = newPath:patch({
				current = newPath.current + 1,
			})
			world:insert(id, newPath)

			currentWaypoint = pathArray[newPath.current]
			if not currentWaypoint then
				world:insert(id, PathFinished())
				continue
			end

			if offsets and (offsets.right ~= 0) then
				currentWaypoint = getSubjectiveWaypoint(pathArray, newPath, offsets.right)
			end

			newPosition = newPosition:patch({
				position = CFrame.lookAt(
					newPosition.position.Position,
					Vector3.new(currentWaypoint.X, newPosition.position.Position.Y, currentWaypoint.Z)
				),
			})
		end

		-- Move the entity
		local currentCF = newPosition.position
		local distance = (currentWaypoint - currentCF.Position).Magnitude
		local moveDirection = (currentWaypoint - currentCF.Position).Unit
		local moveVector = moveDirection * math.clamp(speed.speed * Matter.useDeltaTime(), 0, distance)

		newPosition = newPosition:patch({
			position = currentCF + moveVector,
		})
		world:insert(id, newPosition)
	end
end

return {
	system = MoveMovingEntities,
	priority = EnumList.Priority.Modification,
}
