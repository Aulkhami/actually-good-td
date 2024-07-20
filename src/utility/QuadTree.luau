local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.Packages.Sift)

-- Types
type Point = {
	position: Vector2,
	id: string,
}

type Boundary = {
	topLeft: Vector2,
	bottomRight: Vector2,
}

type Node = Boundary & {
	points: { Point }?,
	branch: { { Node } }?,

	depth: number,
	parent: Node?,
}

local QuadTree = {}
QuadTree.__index = QuadTree

type self = {
	_maxPoints: number,
	_maxDepth: number,

	references: { [string]: { number } },
	tree: Node,

	sizePoints: number,
	sizeNodes: number,
}

export type Class = typeof(setmetatable({} :: self, QuadTree))

-- Utility functions
local function isInLeftHalf(p: Vector2, node: Node)
	return ((node.topLeft.X + node.bottomRight.X) / 2) >= p.X
end

local function isInTopHalf(p: Vector2, node: Node)
	return ((node.topLeft.Y + node.bottomRight.Y) / 2) < p.Y
end

-- The Class
function QuadTree.new(topLeft: Vector2, bottomRight: Vector2, config: { maxPoints: number?, maxDepth: number? }?)
	local self = setmetatable({} :: self, QuadTree)

	local _config = config or {}
	self._maxPoints = _config.maxPoints or 8
	self._maxDepth = _config.maxDepth or 4

	self.references = {}
	self.tree = {
		topLeft = topLeft,
		bottomRight = bottomRight,

		points = table.create(self._maxPoints),

		depth = 1,
	}

	self.sizePoints = 0
	self.sizeNodes = 1

	return self
end

function QuadTree.GetNode(self: Class, node: Node, index1: number, index2: number)
	local branch = node.branch
	if not branch then
		branch = { {}, {} }
		node.branch = branch
	end

	local newNode = branch[index1][index2]
	if not newNode then
		local topLeft = node.topLeft
		local bottomRight = node.bottomRight

		if index1 == 1 and index2 == 1 then
			topLeft = topLeft
			bottomRight = (topLeft + bottomRight) / 2
		elseif index1 == 2 and index2 == 1 then
			topLeft = Vector2.new(topLeft.X, (topLeft.Y + bottomRight.Y) / 2)
			bottomRight = Vector2.new((topLeft.X + bottomRight.X) / 2, bottomRight.Y)
		elseif index1 == 1 and index2 == 2 then
			topLeft = Vector2.new((topLeft.X + bottomRight.X) / 2, topLeft.Y)
			bottomRight = Vector2.new(bottomRight.X, (topLeft.Y + bottomRight.Y) / 2)
		elseif index1 == 2 and index2 == 2 then
			topLeft = (topLeft + bottomRight) / 2
			bottomRight = bottomRight
		else
			error("Invalid index numbers")
		end

		newNode = {
			topLeft = topLeft,
			bottomRight = bottomRight,

			points = table.create(self._maxPoints),

			depth = node.depth + 1,
			parent = node,
		}

		branch[index1][index2] = newNode

		self.sizeNodes += 1
	end

	return newNode
end

function QuadTree.DestroyNode(self: Class, node: Node)
	node.points = nil
	node.branch = nil

	local parent = node.parent
	if not parent then
		return
	end

	local parentEmpty = true
	for index1, row in parent.branch do
		for index2, child in row do
			if child == node then
				parent.branch[index1][index2] = nil
			else
				parentEmpty = false
			end
		end
	end

	self.sizeNodes -= 1

	if parentEmpty then
		self:DestroyNode(parent)
	end
end

function QuadTree.Insert(self: Class, point: Point, _node: Node?): Node?
	local node = _node or self.tree
	if not self:InBoundary(point.position, node) then
		return
	end

	local reference: { number } = self.references[point.id] or table.create(self._maxDepth + 1)
	self.references[point.id] = reference

	if node.points then
		if (#node.points >= self._maxPoints) and (node.depth < self._maxDepth) then
			local points = table.clone(node.points) :: { Point }
			node.points = nil

			for _, _point in points do
				reference = self.references[_point.id]
				table.remove(reference, #reference)

				self:Insert(_point, node)
			end

			return self:Insert(point, node)
		else
			table.insert(node.points, point)
			table.insert(reference, #node.points)

			self.sizePoints += 1

			return node
		end
	end

	local p = point.position
	local newNode: Node
	if isInLeftHalf(p, node) then
		if isInTopHalf(p, node) then
			newNode = self:GetNode(node, 1, 1)
			table.insert(reference, 1)
		else
			newNode = self:GetNode(node, 2, 1)
			table.insert(reference, 2)
		end

		table.insert(reference, 1)
	else
		if isInTopHalf(p, node) then
			newNode = self:GetNode(node, 1, 2)
			table.insert(reference, 1)
		else
			newNode = self:GetNode(node, 2, 2)
			table.insert(reference, 2)
		end

		table.insert(reference, 2)
	end

	return self:Insert(point, newNode)
end

function QuadTree.Remove(self: Class, id: string, _node: Node?)
	local reference = self.references[id]
	if not reference then
		return
	end

	local node: Node = _node or self:GetFromId(id)
	if not node then
		return
	end
	if not node.points then
		return
	end

	table.remove(node.points, reference[#reference])
	self.references[id] = nil

	self.sizePoints -= 1

	if not Sift.isEmpty(node.points) then
		for index, point in node.points do
			local newReference = self.references[point.id]
			newReference[#newReference] = index
		end
	elseif node.parent then
		self:DestroyNode(node)
	end
end

function QuadTree.UpdatePoint(self: Class, point: Point, _node: Node?, _ref: { number }?): Node?
	local id = point.id

	local reference = _ref or self.references[id]
	if not reference then
		return
	end
	reference = Sift.Array.copy(reference)

	local node: Node = _node or self:GetFromId(id)

	if self.references[id] then
		reference = Sift.Array.pop(reference)

		self:Remove(id, node)
	end

	if (node.branch or node.points) and (self:InBoundary(point.position, node)) then
		self.references[id] = reference

		return self:Insert(point, node)
	else
		reference = Sift.Array.pop(reference, 2)

		return self:UpdatePoint(point, node.parent, reference)
	end
end

function QuadTree.GetFromId(self: Class, id: string)
	local reference = self.references[id]
	if not reference then
		return
	end

	local point: Point
	local node: Node = self.tree
	local lastIndex: number?
	for _, index in reference do
		if node.points then
			node = node
			point = node.points[index]

			break
		end

		if not node.branch then
			error("This QuadTree is broken")
		end

		if lastIndex then
			node = node.branch[lastIndex][index]
			if not node then
				return
			end

			lastIndex = nil
		else
			if not node.branch[index] then
				return
			end

			lastIndex = index
		end
	end

	return node, point
end

function QuadTree.InBoundary(self: Class, p: Vector2, boundary: Boundary)
	return (p.X >= boundary.topLeft.X)
		and (p.X <= boundary.bottomRight.X)
		and (p.Y <= boundary.topLeft.Y)
		and (p.Y >= boundary.bottomRight.Y)
end

function QuadTree.IntersectsBoundary(self: Class, boundary1: Boundary, boundary2: Boundary)
	local a = {
		x1 = boundary1.topLeft.X,
		y1 = boundary1.topLeft.Y,
		x2 = boundary1.bottomRight.X,
		y2 = boundary1.bottomRight.Y,
	}
	local b = {
		x1 = boundary2.topLeft.X,
		y1 = boundary2.topLeft.Y,
		x2 = boundary2.bottomRight.X,
		y2 = boundary2.bottomRight.Y,
	}

	return (a.x1 < b.x2) and (b.x1 < a.x2) and (a.y1 > b.y2) and (b.y1 > a.y2)
end

function QuadTree.FindPointsInBoundary(self: Class, boundary: Boundary, _node: Node?, _results: { Point }?): { Point }
	local results = _results
	local node: Node = _node or self.tree

	if not results then
		local boundarySize = math.abs(boundary.topLeft.X - boundary.bottomRight.X)
			* math.abs(boundary.topLeft.Y - boundary.bottomRight.Y)
		local quadTreeSize = math.abs(self.tree.topLeft.X - self.tree.bottomRight.X)
			* math.abs(self.tree.topLeft.Y - self.tree.bottomRight.Y)

		results =
			table.create(math.clamp(self.sizePoints * (boundarySize / quadTreeSize), 0, self.sizePoints)) :: { Point }
	end

	if not self:IntersectsBoundary(boundary, node) then
		return results
	end

	if node.points then
		for _, point in node.points do
			if self:InBoundary(point.position, boundary) then
				table.insert(results, point)
			end
		end
	elseif node.branch then
		for _, row in node.branch do
			for _, child in row do
				self:FindPointsInBoundary(boundary, child, results)
			end
		end
	end

	return results
end

function QuadTree.FindPointsInCircle(self: Class, center: Vector2, radius: number)
	local boundary: Boundary = {
		topLeft = Vector2.new(center.X - radius, center.Y + radius),
		bottomRight = Vector2.new(center.X + radius, center.Y - radius),
	}
	local results = self:FindPointsInBoundary(boundary)

	return Sift.Array.filter(results, function(point: Point): boolean
		return (point.position - center).Magnitude <= radius
	end)
end

function QuadTree.Destroy(self: Class)
	table.clear(self.references)
	table.clear(self.tree)
end

return QuadTree
