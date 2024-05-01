local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Loader = require(ReplicatedStorage.Packages.Loader)
local Sift = require(ReplicatedStorage.Packages.Sift)

local waveSets = Sift.Dictionary.freezeDeep(Loader.LoadChildren(script))
return function(waveSetName: string)
	local waveSet = waveSets[waveSetName]
	assert(waveSet, "Waves not found")

	return waveSet
end
