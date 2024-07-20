local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local Selected = Components.Selected
local Position = Components.Position
local Range = Components.Range
local Size = Components.Size
local Highlight = Components.Highlight
local RangeVisual = Components.RangeVisual

local SurfaceGuiEffects = require(ReplicatedStorage.Shared.SurfaceGuiEffects)

local EnumList = require(ReplicatedStorage.Types.EnumList)

local ROTATION_PER_SECOND = 45

local function SelectedFX(world: Matter.World)
	for _, _, highlight: Components.Highlight in world:query(Selected, Highlight) do
		local dt = Matter.useDeltaTime()

		local rx, ry, rz = highlight.part.CFrame:ToOrientation()
		highlight.part.CFrame = CFrame.fromOrientation(rx, ry + (math.rad(ROTATION_PER_SECOND) * dt), rz)
			+ highlight.part.CFrame.Position

		highlight.part.SurfaceGui.LightInfluence = 5
	end

	for id: number, _, position: Components.Position, size: Components.Size in
		world:query(Selected, Position, Size):without(Highlight)
	do
		local highlightPart = SurfaceGuiEffects.GetHighlight(position.position.Position, size.size)
		world:insert(id, Highlight({ part = highlightPart }))
	end

	for id: number, _, position: Components.Position, range: Components.Range in
		world:query(Selected, Position, Range):without(RangeVisual)
	do
		local rangeVisualPart = SurfaceGuiEffects.GetRangeVisual(position.position.Position, range.range)
		world:insert(id, RangeVisual({ part = rangeVisualPart }))
	end

	for id: number, record: Components.Record<Components.Selected> in world:queryChanged(Selected) do
		if record.new or not world:contains(id) then
			continue
		end

		world:remove(id, RangeVisual)

		local highlight: Components.Highlight? = world:get(id, Highlight)
		if highlight then
			highlight.part.SurfaceGui.LightInfluence = 3
		end
	end

	for id: number, record: Components.Record<Components.Position> in world:queryChanged(Position) do
		local position = record.new
		if not position then
			continue
		end

		local rangeVisual: Components.RangeVisual?, highlight: Components.Highlight? =
			world:get(id, RangeVisual, Highlight)
		if rangeVisual then
			rangeVisual.part.CFrame = rangeVisual.part.CFrame.Rotation + position.position.Position
		end
		if highlight then
			highlight.part.CFrame = highlight.part.CFrame.Rotation + position.position.Position
		end
	end
end

return {
	system = SelectedFX,
	priority = EnumList.Priority.Modification,
	event = "RenderStepped",
}
