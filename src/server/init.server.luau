local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Matter = require(ReplicatedStorage.Packages.Matter)
local Loader = require(ReplicatedStorage.Packages.Loader)

local world = Matter.World.new()

local loop = Matter.Loop.new(world)
local systems = Loader.LoadChildren(script.Systems)

loop:scheduleSystems(systems)
loop:begin({
	default = RunService.Heartbeat,
})
