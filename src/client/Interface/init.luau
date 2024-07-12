local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Matter = require(ReplicatedStorage.Packages.Matter)
local Sift = require(ReplicatedStorage.Packages.Sift)
local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Spring = Fusion.Spring
local Observer = Fusion.Observer
local Children = Fusion.Children

local Components = require(ReplicatedStorage.Shared.Components)
local GhostPlacement = Components.GhostPlacement
local TowerUpgrades = Components.TowerUpgrades
local Health = Components.Health
local Attack = Components.Attack
local Range = Components.Range
local Defense = Components.Defense
local Name = Components.Name

local GlobalUIState = require(ReplicatedStorage.Shared.GlobalUIState)
local Towers = require(ReplicatedStorage.Shared.Towers)

local GuiComponents = script.Components
local TowerHotbar = require(GuiComponents.TowerHotbar)
local TowerDetails = require(GuiComponents.TowerDetails)

local States = script.States
local TowerHotbarState = require(States.TowerHotbarState)
local TowerButtonState = require(States.TowerButtonState)
local TowerDetailsState = require(States.TowerDetailsState)

return function()
	local player = Players.LocalPlayer

	-- Hotbar --
	local hotbarState = TowerHotbarState()
	--|| TEMPORARY
	local scoutButton = TowerButtonState()
	scoutButton.Cost:set(69)
	scoutButton.Tower:set(Towers["Scout"])
	scoutButton.UpgradeLevels:set({ 0, 0, 0 })
	hotbarState.TowerButtons:set({
		scoutButton,
	})
	--||

	hotbarState.SelectFn = function(state)
		GlobalUIState.PlaceTowerSignal:Fire(state.Tower:get(), state.UpgradeLevels:get())

		return true -- TEMPORARY
	end
	hotbarState.DeselectFn = function()
		GlobalUIState.PlaceTowerCancelSignal:Fire()
	end

	local hotbarGui = New("ScreenGui")({
		ResetOnSpawn = false,
		Enabled = true,

		[Children] = {
			TowerHotbar({ State = hotbarState }),
		},
	} :: any & ScreenGui)
	hotbarGui.Parent = player.PlayerGui

	-- PlaceTower --
	local placeTowerState = TowerDetailsState()
	placeTowerState.UpgradeDisabled:set(true)
	local placeTowerEnabled = Computed(function()
		return GlobalUIState.CurrentScreen:get() == "PlaceTowers"
	end)
	local placeTowerScreenPosition = Spring(
		Computed(function()
			return if placeTowerEnabled:get() then UDim2.fromScale(0, 1) else UDim2.fromScale(0, 2)
		end),
		50
	)

	local function updatePlaceTowerState(world: Matter.World)
		for id: number, _ in world:query(GhostPlacement) do
			local upgrades: Components.TowerUpgrades, health: Components.Health, attack: Components.Attack, range: Components.Range, defense: Components.Defense, name: Components.Name =
				world:get(id, TowerUpgrades, Health, Attack, Range, Defense, Name)

			-- Set the tower
			placeTowerState.Tower:set(Towers[name.name])

			-- Upgrade visuals
			local primaryPath: number? = Sift.Array.findWhere(upgrades.upgrades, function(level: number): any
				return level > 2
			end)
			local secondaryPaths: { number } = table.create(2)

			for path, level in upgrades.upgrades do
				if level > 0 then
					table.insert(secondaryPaths, path)
				end

				for i = 1, level, 1 do
					placeTowerState.UpgradeStatus[path][i]:set("All")
				end
			end

			for path, status in placeTowerState.PathStatus do
				if path == primaryPath then
					status:set("Primary")
					continue
				end

				if primaryPath then
					if upgrades.upgrades[path] > 0 then
						status:set("Secondary")
					else
						status:set("Locked")
					end
				elseif #secondaryPaths == 2 then
					if upgrades.upgrades[path] > 0 then
						status:set("Primary")
					else
						status:set("Locked")
					end
				else
					status:set("Primary")
				end
			end

			-- The stats
			placeTowerState.Health.Current:set(health.current)
			placeTowerState.Health.Max:set(health.max)

			local attackDmg = 0
			local attackInt = 0
			local rangeVal = 0
			local defenseVal = 0

			if attack then
				attackDmg = attack.attack
				attackInt = attack.interval
			end
			if range then
				rangeVal = range.range
			end
			if defense then
				defenseVal = defense.defense
			end

			local newStats = false
			local towerStats = placeTowerState.Stats:get()

			if not towerStats[1] then
				newStats = true
				towerStats = Sift.Array.copy(towerStats)

				towerStats[1] = {
					Name = "Attack",
					Value = Value(attackDmg),
				}
			else
				towerStats[1].Value:set(attackDmg)
			end
			if not towerStats[2] then
				newStats = true
				towerStats = Sift.Array.copy(towerStats)

				towerStats[2] = {
					Name = "AttackInterval",
					Value = Value(attackInt),
				}
			else
				towerStats[2].Value:set(attackInt)
			end
			if not towerStats[3] then
				newStats = true
				towerStats = Sift.Array.copy(towerStats)

				towerStats[3] = {
					Name = "Range",
					Value = Value(rangeVal),
				}
			else
				towerStats[3].Value:set(rangeVal)
			end
			if not towerStats[4] then
				newStats = true
				towerStats = Sift.Array.copy(towerStats)

				towerStats[4] = {
					Name = "Defense",
					Value = Value(defenseVal),
				}
			else
				towerStats[4].Value:set(defenseVal)
			end

			if newStats then
				placeTowerState.Stats:set(towerStats)
			end
		end
	end

	local placeTowerScreen = New("ScreenGui")({
		ResetOnSpawn = false,
		Enabled = Computed(function()
			return placeTowerScreenPosition:get().Y.Scale < 2
		end),

		[Children] = {
			TowerDetails({
				State = placeTowerState,

				AnchorPoint = Vector2.new(0, 1),
				Position = placeTowerScreenPosition,
			} :: TowerDetails.Props),
		},
	} :: any & ScreenGui)
	placeTowerScreen.Parent = player.PlayerGui

	-- Screen state Observer --
	local disconnect = function() end
	local screenObserver = Observer(GlobalUIState.CurrentScreen)
	screenObserver:onChange(function()
		if GlobalUIState.CurrentScreen:get() == "None" then
			hotbarState.Selected:set(false)
			disconnect()
		end

		if GlobalUIState.CurrentScreen:get() == "PlaceTowers" then
			task.wait()
			disconnect = GlobalUIState.WorldStateUpdate:Once(updatePlaceTowerState)
		end
	end)
end
