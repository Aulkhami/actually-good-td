local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)
local Loader = require(ReplicatedStorage.Packages.Loader)

local world = Matter.World.new()

local systems = Loader.LoadChildren(script.Systems)
