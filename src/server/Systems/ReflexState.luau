local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Store = require(ServerScriptService.Server.Store)
local Matter = require(ReplicatedStorage.Packages.Matter)
local Sift = require(ReplicatedStorage.Packages.Sift)
local Types = require(ReplicatedStorage.Types)

local EnumList = require(ReplicatedStorage.Types.EnumList)

local function ReflexState(world: Matter.World, state: Types.GlobalState, ui)
	local gameState = Store:getState()

	local zippedTable = Sift.Array.zip(Sift.Dictionary.keys(gameState), Sift.Dictionary.values(gameState))
	local stringifiedTable = Sift.Array.map(zippedTable, function(value: { any }, index)
		local row = { tostring(index), tostring(value[1]), tostring(value[2]) }

		return row
	end)

	local mainClosed = ui.window({
		title = "Global Game State",
		movable = true,
		resizable = true,
		closable = true,
	}, function()
		local rowSelected = ui.table(stringifiedTable, { selectable = true }):selected()
		if rowSelected then
			table.clear(state.gameStateUiState.displayed)
			table.insert(state.gameStateUiState.displayed, tonumber(rowSelected[1]) :: number)
		end
	end):closed()

	if mainClosed then
		table.clear(state.gameStateUiState.displayed)
	end

	for i, selectedRow in pairs(state.gameStateUiState.displayed) do
		local selected = zippedTable[selectedRow][2]

		if typeof(selected) == "table" then
			local newZippedTable = Sift.Array.zip(Sift.Dictionary.keys(selected), Sift.Dictionary.values(selected))
			stringifiedTable = Sift.Array.map(newZippedTable, function(value: { any }, index)
				local row = { tostring(index), tostring(value[1]), tostring(value[2]) }

				return row
			end)

			local closed = ui.window({
				title = zippedTable[selectedRow][1],
				movable = true,
				resizable = true,
				closable = true,
			}, function()
				local rowSelected = ui.table(stringifiedTable, { selectable = true }):selected()

				if rowSelected then
					while #state.gameStateUiState.displayed >= i + 1 do
						table.remove(state.gameStateUiState.displayed)
					end
					table.insert(state.gameStateUiState.displayed, tonumber(rowSelected[1]) :: number)
				end
			end):closed()

			if closed then
				while #state.gameStateUiState.displayed >= i do
					table.remove(state.gameStateUiState.displayed)
				end

				break
			end

			zippedTable = newZippedTable
		end
	end
end

return {
	system = ReflexState,
	priority = EnumList.Priority.Misc,
}
