export type AttackPriority = "First" | "Last" | "Strongest" | "Weakest" | "Nearest" | "Furthest" | "Random"

return {
	Priority = {
		Deletion = 100 ^ 0,
		Creation = 100 ^ 1,
		Modification = 100 ^ 2,
		Misc = 100 ^ 3,
	},

	ZIndex = {
		Top = 1000,
		Middle = 500,
		Bottom = 0,
		Under = -500,
	},
}
