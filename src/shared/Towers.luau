--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.Packages.Sift)
local Components = require(ReplicatedStorage.Shared.Components)
local Health = Components.Health
local Attack = Components.Attack
local Range = Components.Range
local Size = Components.Size

local Types = require(ReplicatedStorage.Types)

local towers: { [string]: Types.Tower } = {
	Scout = {
		Name = "Scout",
		Description = "Scout TF2",

		PlacementArea = "PlacementGround",

		Components = function()
			return {
				Health({
					max = 100,
					current = 100,
				}),
				Attack({
					attack = 5,
					interval = 0.5,
				}),
				Range({
					range = 20,
				}),
				Size({
					size = 3,
				}),
			}
		end,

		Cost = 69,
		UpgradePath = {
			{
				Id = 1,
				Name = "Recon",
				Upgrades = {
					{
						Id = 1,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
					{
						Id = 2,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
					{
						Id = 3,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
					{
						Id = 4,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
					{
						Id = 5,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
				},
			},
			{
				Id = 2,
				Name = "Vanguard",
				Upgrades = {
					{
						Id = 1,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
					{
						Id = 2,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
					{
						Id = 3,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
					{
						Id = 4,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
					{
						Id = 5,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
				},
			},
			{
				Id = 3,
				Name = "Sapper",
				Upgrades = {
					{
						Id = 1,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
					{
						Id = 2,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
					{
						Id = 3,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
					{
						Id = 4,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
					{
						Id = 5,
						Name = "Scouting Hat",
						Insert = function()
							return {}
						end,
						Remove = function()
							return {}
						end,
						Cost = 0,
					},
				},
			},
		},
	},
}
towers = Sift.Dictionary.freezeDeep(towers)

return towers
