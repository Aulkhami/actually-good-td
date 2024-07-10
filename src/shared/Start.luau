local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStorage.Packages.Matter)
local Plasma = require(ReplicatedStorage.Packages.Plasma)
local Rewire = require(ReplicatedStorage.Packages.Rewire)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Types = require(ReplicatedStorage.Types)
local HotReloader = Rewire.HotReloader

local function start(containers)
	local world = Matter.World.new()
	local state: Types.GlobalState = {
		debugEnabled = false,
		gameStateUiState = {
			displayed = table.create(5),
		},
	}

	local debugger = Matter.Debugger.new(Plasma)

	--[[debugger.findInstanceFromEntity = function(id)
		if not world:contains(id) then
			return
		end

		local model = world:get(id, components.Model)

		return model and model.model or nil
	end]]

	local loop = Matter.Loop.new(world, state, debugger:getWidgets())

	-- Set up hot reloading

	local hotReloader = HotReloader.new()

	local firstRunSystems = {}
	local systemsByModule = {}

	local function loadModule(module, context)
		local originalModule = context.originalModule

		local ok, system = pcall(require, module)

		if not ok then
			warn("Error when hot-reloading system", module.name, system)
			return
		end

		if firstRunSystems then
			table.insert(firstRunSystems, system)
		elseif systemsByModule[originalModule] then
			loop:replaceSystem(systemsByModule[originalModule], system)
			debugger:replaceSystem(systemsByModule[originalModule], system)
		else
			loop:scheduleSystem(system)
		end

		systemsByModule[originalModule] = system
	end

	local function unloadModule(_, context)
		if context.isReloading then
			return
		end

		local originalModule = context.originalModule
		if systemsByModule[originalModule] then
			loop:evictSystem(systemsByModule[originalModule])
			systemsByModule[originalModule] = nil
		end
	end

	for _, container in containers do
		hotReloader:scan(container, loadModule, unloadModule)
	end

	loop:scheduleSystems(firstRunSystems)
	table.clear(firstRunSystems)

	debugger:autoInitialize(loop)

	-- Event tables
	local events = {
		default = RunService.Heartbeat,
		Stepped = RunService.Stepped,
	}

	if RunService:IsClient() then
		-- Additional events for the client
		local postInput = Signal()
		RunService:BindToRenderStep("PostInput", Enum.RenderPriority.Input.Value + 1, function()
			postInput:Fire()
		end)
		events.PostInput = postInput

		events.RenderStepped = RunService.RenderStepped

		-- Debug UI toggle
		UserInputService.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.F4 then
				debugger:toggle()

				state.debugEnabled = debugger.enabled
			end
		end)
	end

	-- Begin running our systems
	loop:begin(events)

	return world, state
end

return start
