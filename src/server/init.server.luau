local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Store = require(script.Store)
local Waves = require(script.Waves)

-- TEMPORARY
Store.SetWaves(Waves("Normal"))
Store.NextWave()

-- Start the game
local Start = require(ReplicatedStorage.Shared.Start)
Start({
	script.Systems,
})
