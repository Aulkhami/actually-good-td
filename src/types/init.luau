local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)

-- Mobs
export type Mob = {
	Name: string,
	Description: string,

	Components: () -> { { [string]: any } },
}

-- Towers
export type Tower = {
	Name: string,
	Description: string,

	Components: () -> { { [string]: any } },

	Cost: number,
	UpgradePath: {
		{
			{
				Cost: number,
				Insert: (world: Matter.World, id: number) -> { { [string]: any } },
				Remove: (world: Matter.World, id: number) -> { { [string]: any } },
			}
		}
	},
}

-- Map
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

-- Global states
export type GameStateUiState = {
	displayed: { number },
}

export type GlobalState = {
	gameStateUiState: GameStateUiState,
	debugEnabled: boolean,
}

-- Instance types
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
