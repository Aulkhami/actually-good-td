local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Mobs = require(ReplicatedStorage.Shared.Mobs)

return {
	{
		mobs = {
			{
				mob = Mobs.Basic,
				count = 5,
			},
		},
		spawnDelay = 2,
		waveStall = 120,
	},
}
