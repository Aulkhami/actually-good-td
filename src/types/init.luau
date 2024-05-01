export type Mob = {
	Stats: {
		Health: number,
		Speed: number,
	},
	Components: () -> { { [string]: any } },
	Description: string,
}

export type Wave = {
	mobs: { { mob: Mob, count: number, spawnDelay: number? } },
	spawnDelay: number,
	waveStall: number?,
}

return {}
