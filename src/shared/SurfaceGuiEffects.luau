local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Future = require(ReplicatedStorage.Packages.Future)
local New = Fusion.New
local Children = Fusion.Children
local PartCache = require(ReplicatedStorage.Packages.PartCache)

local Assets = require(script.Parent.Assets)

local SurfaceGuiEffects = {}

-- Tweens table, to store and track the progress of the Tweens
SurfaceGuiEffects.Tweens = {} :: { [Instance]: Tween }
local function Tween(part: Part, tweenInfo: TweenInfo, goal: { [any]: any })
	if SurfaceGuiEffects.Tweens[part] then
		SurfaceGuiEffects.Tweens[part].Completed:Wait()
	end

	local tween = TweenService:Create(part, tweenInfo, goal)
	SurfaceGuiEffects.Tweens[part] = tween

	tween:Play()
	tween.Completed:Wait()

	SurfaceGuiEffects.Tweens[part] = nil
end

-- Highlight --
-- The template, created using Fusion
local highlightTemplate = New("Part")({
	CanCollide = false,
	Transparency = 1,
	Shape = Enum.PartType.Cylinder,
	Size = Vector3.new(0.1, 3, 3),

	[Children] = {
		New("SurfaceGui")({
			Face = Enum.NormalId.Right,
			LightInfluence = 3,
			ResetOnSpawn = false,

			[Children] = {
				New("ImageLabel")({
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Image = Assets.SurfaceGui.Highlight,
					Interactable = false,
				} :: any & ImageLabel),
			},
		} :: any & SurfaceGui),
	},
} :: any & Part)
local highlightParts = PartCache.new(highlightTemplate, 100)
local highlightTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

-- Get a new Highlight part
function SurfaceGuiEffects.GetHighlight(position: Vector3, size: number)
	local part = highlightParts:GetPart()
	part.CFrame = CFrame.fromOrientation(0, 0, math.rad(90)) + position

	Future.new(
		Tween,
		part,
		highlightTweenInfo,
		{
			Size = Vector3.new(0.1, size, size),
		} :: any & Part
	)

	return part
end

-- Return an unused Highlight part
function SurfaceGuiEffects.ReturnHighlight(part: Part)
	Future.new(
		Tween,
		part,
		highlightTweenInfo,
		{
			Size = Vector3.new(0.1, 0, 0),
		} :: any & Part
	):After(function()
		highlightParts:ReturnPart(part)
	end)
end

-- RangeVisual --
-- The template, created using Fusion
local rangeVisualTemplate = New("Part")({
	CanCollide = false,
	Transparency = 1,
	Shape = Enum.PartType.Cylinder,
	Size = Vector3.new(0, 0.1, 0),

	[Children] = {
		New("SurfaceGui")({
			Face = Enum.NormalId.Right,
			LightInfluence = 3,
			ResetOnSpawn = false,

			[Children] = {
				New("ImageLabel")({
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Image = Assets.SurfaceGui.RangeVisual,
					Interactable = false,
				} :: any & ImageLabel),
			},
		} :: any & SurfaceGui),
	},
} :: any & Part)
local rangeVisualParts = PartCache.new(rangeVisualTemplate, 100)
local rangeVisualTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

-- Get a new RangeVisual part
function SurfaceGuiEffects.GetRangeVisual(position: Vector3, range: number)
	local part = rangeVisualParts:GetPart()
	part.CFrame = CFrame.fromOrientation(0, 0, math.rad(90)) + position

	Future.new(
		Tween,
		part,
		rangeVisualTweenInfo,
		{
			Size = Vector3.new(0.1, range, range),
		} :: any & Part
	)

	return part
end

-- Return an unused RangeVisual part
function SurfaceGuiEffects.ReturnRangeVisual(part: Part)
	Future.new(
		Tween,
		part,
		highlightTweenInfo,
		{
			Size = Vector3.new(0.1, 0, 0),
		} :: any & Part
	):After(function()
		rangeVisualParts:ReturnPart(part)
	end)
end

return SurfaceGuiEffects
