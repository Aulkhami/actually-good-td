export type Mob = {
	Stats: {
		Health: number,
		Speed: number,
	},
	Components: () -> { { [string]: any } },
	Description: string,
}

export type Path = { Vector3 }

export type Wave = {
	mobs: { { mob: Mob, count: number, spawnDelay: number? } },
	spawnDelay: number,
	waveStall: number?,
}

export type GameStateUiState = {
	displayed: { number },
}

export type GlobalState = {
	gameStateUiState: GameStateUiState,
	debugEnabled: boolean,
}

return {}
