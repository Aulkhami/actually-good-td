local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerStorage = game:GetService("ServerStorage")

local Sift = require(ReplicatedStorage.Packages.Sift)

return function(mapName: string)
	local map: Model = ServerStorage.Maps:FindFirstChild(mapName)
	assert(map, `Map {mapName} not found`)

	local pathsFolder = map:FindFirstChild("Paths")
	assert(pathsFolder, `Paths Folder missing in {mapName}`)

	local paths = pathsFolder:GetChildren()
	table.sort(paths, function(a0: Instance, a1: Instance): boolean
		return tonumber(a0.Name) < tonumber(a1)
	end)

	return map,
		Sift.Array.map(paths, function(path: Instance)
			local waypoints = path:GetChildren()
			table.sort(waypoints, function(a0: Instance, a1: Instance): boolean
				return tonumber(a0.Name) < tonumber(a1.Name)
			end)

			return Sift.Array.map(waypoints, function(waypoint: BasePart)
				return waypoint.CFrame.Position
			end)
		end)
end
