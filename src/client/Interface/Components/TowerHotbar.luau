local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Theme = require(StarterPlayer.StarterPlayerScripts.Client.Interface.Theme)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Sift = require(ReplicatedStorage.Packages.Sift)
local GlobalUIState = require(ReplicatedStorage.Shared.GlobalUIState)
local EnumList = require(ReplicatedStorage.Types.EnumList)
local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Spring = Fusion.Spring
local ForValues = Fusion.ForValues
local ForPairs = Fusion.ForPairs
local Observer = Fusion.Observer
local Children = Fusion.Children
local Cleanup = Fusion.Cleanup

local TowerButton = require(script.Parent.TowerButton)
local TowerButtonState = require(script.Parent.Parent.States.TowerButtonState)
local TowerHotbarState = require(script.Parent.Parent.States.TowerHotbarState)

type ItemProps = {
	State: TowerButtonState.TowerButtonState,

	Selected: Fusion.Value<boolean>,
	OnClick: () -> (),
}
local function TowerHotbarItem(props: ItemProps)
	local isHovered: Fusion.Value<boolean> = Value(false)

	return New("Frame")({
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),

		[Children] = {
			New("UIAspectRatioConstraint")({
				AspectRatio = 1,
			} :: any & UIAspectRatioConstraint),

			New("Frame")({
				BackgroundTransparency = 1,
				Position = Spring(
					Computed(function()
						if props.Selected:get() then
							return UDim2.fromScale(0, -0.3)
						end

						return if isHovered:get() then UDim2.fromScale(0, -0.1) else UDim2.fromScale(0, 0)
					end),
					50
				),
				Size = UDim2.fromScale(1, 1),

				[Children] = {
					TowerButton({
						Transparency = Spring(
							Computed(function()
								return if props.Selected:get() then 0 else 0.25
							end),
							25
						),

						State = props.State,

						OnClick = props.OnClick,
						OnEnter = function()
							isHovered:set(true)
						end,
						OnLeave = function()
							isHovered:set(false)
						end,
					} :: TowerButton.Props),

					New("TextLabel")({
						AnchorPoint = Vector2.new(0, 1),
						Position = UDim2.new(UDim.new(0, 1), UDim.new(1, -1)),
						Size = UDim2.fromScale(0.3, 0.3),

						ZIndex = EnumList.ZIndex.Top,

						BackgroundColor3 = Color3.fromHex(Theme.color.background_100),
						TextColor3 = Color3.fromHex(Theme.color.text),
						FontFace = Theme.font.number,

						TextSize = 14,

						Text = props.State.Cost,
					} :: any & TextLabel),
				},
			} :: any & Frame),
		},
	} :: any & Frame)
end

export type Props = {
	State: TowerHotbarState.TowerHotbarState,
}
return function(props: Props)
	local itemsProps = ForValues(props.State.TowerButtons, function(state: TowerButtonState.TowerButtonState)
		return {
			State = state,
			Selected = Value(false),
		} :: ItemProps
	end)
	local items = ForPairs(itemsProps, function(key, itemProps)
		return key,
			TowerHotbarItem(Sift.Dictionary.merge(itemProps, {
				OnClick = function()
					if props.State.Selected:get() == key then
						props.State.Selected:set(false)
						props.State.DeselectFn()

						return
					end

					if props.State.SelectFn(itemProps.State) then
						props.State.Selected:set(key)
					end
				end,
			}))
	end, Fusion.cleanup)

	local observeSelected = Observer(props.State.Selected)
	local disconnect = observeSelected:onChange(function()
		local lastSelected = props.State._lastSelected:get()
		if lastSelected then
			itemsProps:get()[lastSelected].Selected:set(false)
		end

		local currentSelected = props.State.Selected:get()
		if currentSelected then
			itemsProps:get()[currentSelected].Selected:set(true)
		end

		props.State._lastSelected:set(currentSelected)
	end)

	return New("Frame")({
		AnchorPoint = Vector2.new(1, 1),
		Position = Computed(function()
			local viewportHeight = GlobalUIState.ViewportSize:get().Y

			return if viewportHeight < 720
				then UDim2.new(UDim.new(1, -25), UDim.new(1, -25))
				else UDim2.new(UDim.new(1, -75), UDim.new(1, -75))
		end),

		Size = Computed(function()
			local viewportWidth = GlobalUIState.ViewportSize:get().X

			return if viewportWidth < 1280 then UDim2.fromScale(0.1, 0.1) else UDim2.fromScale(0.25, 0.25)
		end),

		BackgroundTransparency = 1,

		[Children] = Computed(function()
			return Sift.Array.append({
				New("UIListLayout")({
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 4),
				} :: any & UIListLayout),
				New("UISizeConstraint")({
					MaxSize = Vector2.new(math.huge, 125),
					MinSize = Vector2.new(100, 100),
				} :: any & UISizeConstraint),
			}, items)
		end),

		[Cleanup] = disconnect,
	} :: any & Frame)
end
