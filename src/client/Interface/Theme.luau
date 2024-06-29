-- Fonts
local heading = Font.fromEnum(Enum.Font.Jura)
heading.Weight = Enum.FontWeight.ExtraBold

local body = Font.fromEnum(Enum.Font.Jura)

local sub = Font.fromEnum(Enum.Font.Jura)
sub.Weight = Enum.FontWeight.Light

local number = Font.fromEnum(Enum.Font.SciFi)
number.Weight = Enum.FontWeight.Bold

return {
	font = {
		heading = heading,
		body = body,
		sub = sub,
		number = number,
	},

	color = {
		text = "#f0f7ff",
		background_50 = "#001533",
		background_100 = "#000f22",
		background_200 = "#000914",
		primary = "#ff204e",
		secondary = "#1307a2",
		tertiary = "#4000ff",
	},
}
