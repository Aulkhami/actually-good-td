export type Mob = {
	Name: string,
	Stats: {
		Health: number,
		Speed: number,
	},
	Components: () -> { { [string]: any } },
	Description: string,
}

export type Path = { Vector3 }

export type Wave = {
	mobs: {
		{
			mob: Mob,
			count: number,
			spawnDelay: number?,
			path: number?,
		}
	},
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

export type HumanoidlessCharacter = Model & {
	Head: BasePart,
	HumanoidRootPart: BasePart & {
		["RootJoint"]: Motor6D,
	},
	Torso: BasePart & {
		["Neck"]: Motor6D,
		["Right Shoulder"]: Motor6D,
		["Left Shoulder"]: Motor6D,
		["Right Hip"]: Motor6D,
		["Left Hip"]: Motor6D,
	},
	["Left Arm"]: BasePart,
	["Right Arm"]: BasePart,
	["Left Leg"]: BasePart,
	["Right Leg"]: BasePart,

	AnimationController: AnimationController & {
		Animator: Animator,
	},
}

return {}
