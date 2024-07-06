opt server_output = './Server.luau'
opt client_output = './Client.luau'
opt async_lib = 'require(game:GetService("ReplicatedStorage").Packages.Future)'
opt yield_type = 'future'

-- Towers --
type Tower = struct {
	Name: string(3..20),
	UpgradePath: u8(0..5)[3],
	Position: CFrame,
}

funct PlaceTowers = {
	call: Async,
	args: Tower[1..20],
	rets: enum { Success, Fail }
}
