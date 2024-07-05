opt server_output = './Server.luau'
opt client_output = './Client.luau'

-- Towers --
type Tower = struct {
	Name: string(3..20),
	UpgradePath: u8(0..5)[3],
	Position: Vector3,
}

funct PlaceTowers = {
	call: Async,
	args: Tower[1..20],
	rets: enum { Success, Fail }
}
