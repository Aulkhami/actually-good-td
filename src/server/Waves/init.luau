local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Loader = require(ReplicatedStorage.Packages.Loader)
local Sift = require(ReplicatedStorage.Packages.Sift)
local Types = require(ReplicatedStorage.Types)

local waveSets = Sift.Dictionary.freezeDeep(Loader.LoadDescendants(script))
return function(waveSetName: string)
	local waveSet = waveSets[waveSetName]
	assert(waveSet, "Waves not found")

	return waveSet :: { Types.Wave }
end
