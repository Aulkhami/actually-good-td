local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Sift = require(ReplicatedStorage.Packages.Sift)
local GlobalUIState = require(ReplicatedStorage.Shared.GlobalUIState)
local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed
local ForPairs = Fusion.ForPairs

local Theme = require(StarterPlayer.StarterPlayerScripts.Client.Interface.Theme)

local TowerButtonState = require(script.Parent.Parent.States.TowerButtonState)

type raw_Props = {
	State: TowerButtonState.TowerButtonState,

	OnClick: () -> (),
	OnEnter: () -> (),
	OnLeave: () -> (),
}
export type Props = raw_Props & UIStroke

return function(props: Props)
	local upgradeLevelIndicators = ForPairs(props.State.UpgradeLevels, function(key, level: number)
		local strips = table.create(level)
		if level > 0 then
			for i = 1, level, 1 do
				table.insert(
					strips,
					New("Frame")({
						BackgroundColor3 = Color3.fromHex(Theme.color.primary),

						Size = UDim2.new(UDim.new(0, 2), UDim.new(0, 6)),
					} :: any & Frame)
				)
			end
		end

		return key,
			New("Frame")({
				LayoutOrder = key,
				BackgroundTransparency = 0.8,
				BackgroundColor3 = Color3.fromHex(Theme.color.background_200),
				Size = UDim2.fromOffset(21, 10),

				[Children] = Sift.Array.append({
					New("UIListLayout")({
						Padding = UDim.new(0, 2),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					} :: any & UIListLayout),
					New("UIPadding")({
						PaddingLeft = UDim.new(0, 1),
						PaddingRight = UDim.new(0, 1),
					} :: any & UIPadding),
				}, strips),
			} :: any & Frame)
	end, Fusion.cleanup)

	return New("Frame")({
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromHex(Theme.color.background_100),

		[Children] = {
			New("UIAspectRatioConstraint")({
				AspectRatio = 1,
			} :: any & UIAspectRatioConstraint),
			New("UIGradient")({
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.8),
					NumberSequenceKeypoint.new(0.5, 0.8),
					NumberSequenceKeypoint.new(1, 0.6),
				}),
				Rotation = 90,
			} :: any & UIGradient),
			New("UIStroke")({
				Thickness = props.Thickness or 2,
				LineJoinMode = Enum.LineJoinMode.Miter,
				Transparency = props.Transparency or 0.25,
				Color = Color3.fromHex(Theme.color.text),
			} :: any & UIStroke),

			New("TextButton")({
				Text = Computed(function()
					return if GlobalUIState.ViewTowerModel:get() then "" else props.State.Tower:get().Name
				end),
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				FontFace = Theme.font.heading,
				TextColor3 = Color3.fromHex(Theme.color.text),
				BackgroundTransparency = 1,
				ZIndex = math.huge,

				Size = UDim2.fromScale(1, 1),

				[OnEvent("Activated")] = props.OnClick,
				[OnEvent("MouseEnter")] = props.OnEnter,
				[OnEvent("MouseLeave")] = props.OnLeave,

				[Children] = {
					New("UIPadding")({
						PaddingLeft = UDim.new(0, 8),
						PaddingTop = UDim.new(0, 10),
					} :: any & UIPadding),
				},
			} :: any & TextButton),

			-- Upgrade levels visual
			New("Frame")({
				AnchorPoint = Vector2.new(1, 1),
				BackgroundTransparency = 1,
				Position = UDim2.new(UDim.new(1, -5), UDim.new(1, -5)),
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.fromOffset(10, 10),

				[Children] = Computed(function()
					return Sift.Array.append({
						New("UIListLayout")({
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 2),
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Right,
							VerticalAlignment = Enum.VerticalAlignment.Top,
						} :: any & UIListLayout),
					}, upgradeLevelIndicators:get())
				end),
			} :: any & Frame),
		},
	} :: any & Frame)
end
