local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Sift = require(ReplicatedStorage.Packages.Sift)
local Assets = require(ReplicatedStorage.Shared.Assets)
local New = Fusion.New
local Children = Fusion.Children
local ForValues = Fusion.ForValues
local OnEvent = Fusion.OnEvent
local OnChange = Fusion.OnChange
local Value = Fusion.Value
local Computed = Fusion.Computed

local States = script.Parent.Parent.States
local State = require(States.TowerDetailsState)

local Types = require(ReplicatedStorage.Types)

local Theme = require(StarterPlayer.StarterPlayerScripts.Client.Interface.Theme)

-- The upgrade section --
-- Displays the upgrade path's buttons, and their respective upgrade levels
local function UpgradeButtons(props: {
	Upgrade: Types.Upgrade,
	Status: State.UpgradeStatus,

	OnClick: () -> (),
	State: State.TowerDetailsState,

	IsHovered: Fusion.Value<boolean>,
	Locked: boolean,
})
	return New("TextButton")({
		Text = "",

		ClipsDescendants = true,
		LayoutOrder = props.Upgrade.Id,
		Active = Computed(function()
			return not (props.State.UpgradeDisabled:get() or props.Locked)
		end),

		BackgroundTransparency = Computed(function()
			if props.State.UpgradeDisabled:get() or props.Locked then
				return 1
			end

			return if props.IsHovered:get() then 0.75 else 1
		end),
		BackgroundColor3 = Color3.fromHex(Theme.color.primary),
		Size = UDim2.new(UDim.new(0, 50), UDim.new(1, 0)),

		[OnEvent("Activated")] = props.OnClick,
		[OnEvent("MouseEnter")] = function()
			props.IsHovered:set(true)
		end,
		[OnEvent("MouseLeave")] = function()
			props.IsHovered:set(false)
		end,

		[Children] = {
			New("UIStroke")({
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromHex(Theme.color.primary),
				Thickness = 1,
			} :: any & UIStroke),

			New("ImageLabel")({
				Visible = Computed(function()
					return props.Status:get() == "Some"
				end),

				Size = UDim2.fromScale(1.05, 1.05),
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				BackgroundTransparency = 1,

				Image = Assets.MiscGui.RightTriangleBL,
				ImageTransparency = 0.25,
				ImageColor3 = Color3.fromHex(Theme.color.primary),
				ScaleType = Enum.ScaleType.Stretch,
			} :: any & ImageLabel),

			New("Frame")({
				Visible = Computed(function()
					return props.Status:get() == "All"
				end),

				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 0.25,

				BackgroundColor3 = Color3.fromHex(Theme.color.primary),
			} :: any & Frame),

			New("ImageLabel")({
				Visible = props.Locked,

				Size = UDim2.fromScale(1.05, 1.05),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,

				Image = Assets.MiscGui.XCross,
				ImageTransparency = 0.25,
				ImageColor3 = Color3.fromHex(Theme.color.primary),
				ScaleType = Enum.ScaleType.Stretch,
			} :: any & ImageLabel),
		},
	} :: any & TextButton)
end

-- Displays the different upgrade paths
local function UpgradePath(props: {
	UpgradePath: Types.UpgradePath,
	PathStatus: State.PathStatus,

	State: State.TowerDetailsState,
})
	-- Here we're getting the upgrade status of each upgrade's levels
	local upgradeStatus = props.State.UpgradeStatus[props.UpgradePath.Id]
	local upgrades: {
		{
			Upgrade: Types.Upgrade,
			Status: State.UpgradeStatus,
		}
	} = Sift.Array.map(
		props.UpgradePath.Upgrades,
		function(value: Types.Upgrade, index: number)
			return {
				Upgrade = value,
				Status = upgradeStatus[index],

				IsHovered = Value(false),
			}
		end
	)

	-- The upgrade buttons
	local upgradeButtons = ForValues(upgrades, function(upgrade)
		-- Locked logic to decide whether the upgrade level button is locked or not
		local locked = false
		if
			(props.PathStatus:get() == "Locked")
			or ((props.PathStatus:get() == "Secondary") and (upgrade.Upgrade.Id > 2))
		then
			locked = true
		end

		return UpgradeButtons(Sift.Dictionary.merge(upgrade, {
			OnClick = function()
				props.State.UpgradeFn(props.UpgradePath.Id, upgrade.Upgrade.Id)
			end,
			State = props.State,

			Locked = locked,
		}))
	end, function(inst: Instance)
		inst:Destroy()
	end)

	-- IsHovered logic to make previous upgrade levels also glow when the upgrade level buttons after it is hovered

	local upgradePathSize: Fusion.Value<Vector2> = Value(Vector2.zero)
	local parentFrameSize: Fusion.Value<Vector2> = Value(Vector2.zero)

	return New("Frame")({
		LayoutOrder = props.UpgradePath.Id,
		BackgroundTransparency = 0.1,
		BackgroundColor3 = Color3.fromHex(Theme.color.background_200),
		Size = UDim2.new(UDim.new(1, 0), UDim.new(0, 30)),

		[OnChange("AbsoluteSize")] = function(size)
			parentFrameSize:set(size)
		end,
		[Children] = {
			New("TextLabel")({
				Text = props.UpgradePath.Name,
				BackgroundTransparency = 1,
				Size = Computed(function()
					return UDim2.new(UDim.new(0, parentFrameSize:get().X - upgradePathSize:get().X), UDim.new(1, 0))
				end),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = 15,
				FontFace = Theme.font.body,
				TextColor3 = Color3.fromHex(Theme.color.text),
				TextTruncate = Enum.TextTruncate.AtEnd,

				LayoutOrder = -1,

				[Children] = {
					New("UIPadding")({
						PaddingTop = UDim.new(0, 5),
						PaddingBottom = UDim.new(0, 5),
						PaddingLeft = UDim.new(0, 15),
						PaddingRight = UDim.new(0, 15),
					} :: any & UIPadding),
				},
			} :: any & TextLabel),

			New("Frame")({
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.fromScale(0.5, 1),
				Position = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),

				[OnChange("AbsoluteSize")] = function(size)
					upgradePathSize:set(size)
				end,
				[Children] = Computed(function()
					return Sift.Array.append({
						New("UIListLayout")({
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Right,
							FillDirection = Enum.FillDirection.Horizontal,
							Padding = UDim.new(0, 5),
						} :: any & UIListLayout),
						New("UIPadding")({
							PaddingTop = UDim.new(0, 5),
							PaddingBottom = UDim.new(0, 5),
							PaddingLeft = UDim.new(0, 5),
							PaddingRight = UDim.new(0, 5),
						} :: any & UIPadding),
					}, upgradeButtons:get())
				end),
			} :: any & Frame),
		},
	} :: any & Frame)
end

-- The container for the 3 upgrade paths
local function UpgradePathContainer(props: {
	State: State.TowerDetailsState,
})
	local upgradePaths = Computed(function()
		return props.State.Tower:get().UpgradePath
	end)
	local upgradePathFrames = ForValues(upgradePaths, function(upgradePath: Types.UpgradePath)
		return UpgradePath({
			State = props.State,

			UpgradePath = upgradePath,
			PathStatus = props.State.PathStatus[upgradePath.Id],
		})
	end, function(inst: Instance)
		inst:Destroy()
	end)
	return New("Frame")({
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(UDim.new(0, 10), UDim.new(1, -10)),
		Size = UDim2.new(UDim.new(0.9, 0), UDim.new(0, 50)),
		AutomaticSize = Enum.AutomaticSize.Y,

		[Children] = Computed(function()
			return Sift.Array.append({
				New("UIListLayout")({
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 4),
				} :: any & UIListLayout),

				New("TextLabel")({
					LayoutOrder = -1,
					Size = UDim2.fromOffset(100, 25),
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromHex(Theme.color.text),
					BackgroundColor3 = Color3.fromHex(Theme.color.background_200),
					FontFace = Theme.font.heading,
					TextSize = 18,

					Text = "UPGRADES",
				} :: any & TextLabel),
			}, upgradePathFrames:get())
		end),
	} :: any & Frame)
end

-- The stats section --
-- Displays the tower's stats
local function TowerStats(props: {
	State: State.TowerDetailsState,
})
	local statFrames = ForValues(props.State.Stats, function(stat)
		return New("Frame")({
			BackgroundTransparency = 0.1,
			BackgroundColor3 = Color3.fromHex(Theme.color.background_200),

			[Children] = {
				New("UIPadding")({
					PaddingTop = UDim.new(0, 1),
					PaddingBottom = UDim.new(0, 1),
					PaddingLeft = UDim.new(0, 1),
					PaddingRight = UDim.new(0, 1),
				} :: any & UIPadding),
				New("UIStroke")({
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromHex(Theme.color.background_50),
					Thickness = 2,
					Transparency = 0.5,
				} :: any & UIStroke),

				New("ImageLabel")({
					BackgroundTransparency = 1,
					Image = Computed(function()
						return Assets.StatIcons[stat.Name]
					end),
					Size = UDim2.fromOffset(20, 20),
					ImageRectSize = Vector2.new(20, 20),

					[Children] = {
						New("UIStroke")({
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.fromHex(Theme.color.background_50),
							Thickness = 2,
							Transparency = 0.5,
						} :: any & UIStroke),
					},
				} :: any & ImageLabel),

				New("TextLabel")({
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(22, 0),
					Size = UDim2.fromOffset(50, 20),
					FontFace = Theme.font.number,
					TextSize = 14,
					TextColor3 = Color3.fromHex(Theme.color.text),

					Text = Computed(function()
						if string.find(stat.Name, "Interval") then
							return `{stat.Value:get()} s`
						end

						return tostring(stat.Value:get())
					end),
				} :: any & TextLabel),
			},
		} :: any & Frame)
	end, function(inst: Instance)
		inst:Destroy()
	end)

	return New("Frame")({
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(150, 0),
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,

		[Children] = Computed(function()
			return Sift.Array.append({
				New("UIGridLayout")({
					StartCorner = Enum.StartCorner.TopLeft,
					FillDirection = Enum.FillDirection.Vertical,
					FillDirectionMaxCells = 2,
					CellSize = UDim2.fromOffset(75, 22),
					CellPadding = UDim2.fromOffset(5, 6),
				} :: any & UIGridLayout),
			}, statFrames:get())
		end),
	} :: any & Frame)
end

-- Self-explanatory
local function HealthBar(props: {
	State: State.TowerDetailsState,
})
	return New("Frame")({
		Visible = not props.State.HideHealth:get(),
		BackgroundTransparency = 1,
		Size = UDim2.new(UDim.new(1, 0), UDim.new(0, 5)),

		[Children] = {
			New("UIStroke")({
				Color = Color3.fromHex(Theme.color.tertiary),
				Transparency = 0.5,
				Thickness = 2,
			} :: any & UIStroke),

			New("Frame")({
				BackgroundColor3 = Color3.fromHex(Theme.color.tertiary),
				Size = Computed(function()
					return UDim2.fromScale(props.State.Health.Current:get() / props.State.Health.Max:get(), 1)
				end),
			} :: any & Frame),

			New("Frame")({
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(UDim.new(1, 2), UDim.new(0, 7)),
				BackgroundTransparency = 0.5,
				BackgroundColor3 = Color3.fromHex(Theme.color.tertiary),
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.fromOffset(50, 24),

				[Children] = {
					New("UIPadding")({
						PaddingTop = UDim.new(0, 2),
						PaddingBottom = UDim.new(0, 2),
						PaddingLeft = UDim.new(0, 2),
						PaddingRight = UDim.new(0, 2),
					} :: any & UIPadding),

					New("ImageLabel")({
						BackgroundTransparency = 1,
						Image = Assets.StatIcons.Health,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(UDim.new(0, 0), UDim.new(0.5, 0)),
						Size = UDim2.fromOffset(20, 20),
						ImageRectSize = Vector2.new(20, 20),
					} :: any & ImageLabel),

					New("TextLabel")({
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(20, 0),
						Size = UDim2.new(UDim.new(0, 50), UDim.new(1, 0)),
						FontFace = Theme.font.number,
						TextSize = 14,
						TextColor3 = Color3.fromHex(Theme.color.text),
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.X,

						Text = Computed(function()
							return `{props.State.Health.Current:get()}/{props.State.Health.Max:get()}`
						end),

						[Children] = {
							New("UIPadding")({
								PaddingTop = UDim.new(0, 2),
								PaddingBottom = UDim.new(0, 2),
								PaddingLeft = UDim.new(0, 2),
								PaddingRight = UDim.new(0, 2),
							} :: any & UIPadding),
						},
					} :: any & TextLabel),
				},
			} :: any & Frame),
		},
	} :: any & Frame)
end

type raw_Props = {
	State: State.TowerDetailsState,
}
export type Props = raw_Props & Frame

return function(props: Props)
	return New("Frame")({
		BackgroundColor3 = Color3.fromHex(Theme.color.background_100),

		Position = props.Position or UDim2.fromOffset(0, 0),
		Size = props.Size or UDim2.fromOffset(500, 180),
		AnchorPoint = props.AnchorPoint or Vector2.zero,

		[Children] = {
			New("UIGradient")({
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.25),
					NumberSequenceKeypoint.new(0.5, 0.75),
					NumberSequenceKeypoint.new(1, 1),
				}),
			} :: any & UIGradient),

			-- Tower info
			New("Frame")({
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromOffset(0, 30),
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,

				[Children] = {
					New("UIListLayout")({
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 10),
					} :: any & UIListLayout),
					New("UIPadding")({
						PaddingLeft = UDim.new(0, 10),
					} :: any & UIPadding),

					New("Frame")({
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y,

						[Children] = {
							-- Tower name
							New("TextLabel")({
								Position = UDim2.fromOffset(-10, 0),
								Size = UDim2.fromOffset(150, 50),

								BackgroundTransparency = 0.1,
								TextColor3 = Color3.fromHex(Theme.color.text),
								BackgroundColor3 = Color3.fromHex(Theme.color.background_200),
								FontFace = Theme.font.heading,
								TextSize = 18,
								TextYAlignment = Enum.TextYAlignment.Center,
								TextWrapped = true,

								Text = "Scout",

								[Children] = {
									New("UIPadding")({
										PaddingTop = UDim.new(0, 15),
										PaddingBottom = UDim.new(0, 15),
										PaddingLeft = UDim.new(0, 20),
										PaddingRight = UDim.new(0, 20),
									} :: any & UIPadding),
									New("UIStroke")({
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = Color3.fromHex(Theme.color.background_50),
										Thickness = 2,
										Transparency = 0.5,
									} :: any & UIStroke),
								},
							} :: any & TextLabel),

							-- Tower stats
							TowerStats({ State = props.State }),
						},
					} :: any & Frame),

					-- Tower description
					New("TextLabel")({
						Visible = not props.State.HideDetails:get(),
						AnchorPoint = Vector2.new(0, 1),
						Size = UDim2.new(UDim.new(1, 0), UDim.new(0, 25)),
						AutomaticSize = Enum.AutomaticSize.Y,

						BackgroundTransparency = 0.8,
						TextColor3 = Color3.fromHex(Theme.color.text),
						BackgroundColor3 = BrickColor.new("Dark grey").Color,
						FontFace = Theme.font.heading,
						TextSize = 15,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,

						Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",

						[Children] = {
							New("UIPadding")({
								PaddingTop = UDim.new(0, 5),
								PaddingBottom = UDim.new(0, 5),
								PaddingLeft = UDim.new(0, 10),
								PaddingRight = UDim.new(0, 10),
							} :: any & UIPadding),
						},
					} :: any & TextLabel),

					-- Health bar
					HealthBar({ State = props.State }),
				},
			} :: any & Frame),

			-- Upgrade paths
			UpgradePathContainer({ State = props.State }),
		},
	} :: any & Frame)
end
