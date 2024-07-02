local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Shared.Components)

local function UpdateModelAttributes(world)
	for id, record in world:queryChanged(Components.Model) do
		if record.new then
			record.new.model:SetAttribute("clientEntityId", id)
			record.new.model:SetAttribute("serverEntityId", id)
		end
	end
end

return UpdateModelAttributes
