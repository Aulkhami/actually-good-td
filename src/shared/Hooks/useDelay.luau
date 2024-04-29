local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)
local useHookState = Matter.useHookState

local function cleanup(storage)
	return os.clock() < storage.expiry
end

--[=[
	@within Matter

	:::info Topologically-aware function
	This function is only usable if called within the context of [`Loop:begin`](/api/Loop#begin).
	:::

    Exactly the same as useThrottle(), but doesn't return `true` the first time.

	Utility for easy time-based delay.

	Accepts a duration, and returns `true` if it has been that long since the last time this function returned `true`.

	This function returns unique results keyed by script and line number. Additionally, uniqueness can be keyed by a
	unique value, which is passed as a second parameter. This is useful when iterating over a query result, as you can
	throttle doing something to each entity individually.

	```lua
	if useDelay(1) then -- Keyed by script and line number only
		print("only prints every second")
	end

	for id, enemy in world:query(Enemy) do
		if useDelay(5, id) then -- Keyed by script, line number, and the entity id
			print("Recalculate target...")
		end
	end
	```

	@param seconds number -- The number of seconds to throttle for
	@param discriminator? any -- A unique value to additionally key by
	@return boolean -- returns true every x seconds, otherwise false
]=]
local function useDelay(seconds, discriminator)
	local storage = useHookState(discriminator, cleanup)

	if storage.time == nil then
		storage.time = os.clock()
		storage.expiry = os.clock() + seconds

		return false
	end

	if os.clock() - storage.time >= seconds then
		storage.time = os.clock()
		storage.expiry = os.clock() + seconds

		return true
	end

	return false
end

return useDelay
