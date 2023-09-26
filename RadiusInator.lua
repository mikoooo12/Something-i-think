local MakeTris = require(script:WaitForChild("GenerateTris"))
local RadiusInator = {}
RadiusInator.__index = RadiusInator

type Config = {
	Origin: Vector3,
	Radius: number,
	Segments: number,
	SampleWedge: WedgePart,
	Thickness: number,
	RaycastParameters: RaycastParams,
	Parent: Folder
}

local FarCFrame = CFrame.new(0, 10e8, 0)

function RadiusInator.new(Config: Config)
	local self = setmetatable({}, RadiusInator)
	self.Config = Config
	self._Constants = {
		Wedges = {}
	}
	self:_Initialize()
	return self
end

function RadiusInator:_Initialize()
	local Config: Config = self.Config
	local Constants = self._Constants
	local SampleWedge = Config.SampleWedge
	local Params = Config.RaycastParameters
	local Wedges = {}
	
	if #Constants.Wedges > 0 then
		for _, Wedge in ipairs(Constants.Wedges) do
			Wedge:Destroy()
		end
		table.clear(Constants.Wedges)
	end
	
	for i = 1, Config.Segments * 2 do
		local Wedge = SampleWedge:Clone()
		Wedge.CFrame = FarCFrame
		Wedge.Parent = Config.Parent
		Params:AddToFilter(Wedge)
		table.insert(Wedges, Wedge)
	end
	Constants.Wedges = Wedges
end

function RadiusInator:Update()
	local Config: Config = self.Config
	local Constants = self._Constants
	local Radius = Config.Radius
	local Origin = Config.Origin
	local Segments = Config.Segments
	local Params = Config.RaycastParameters
	local Vertices = {}
	local Wedges = {}
	
	for i = 1, Segments do
		local Angle = (i - 1) * (2 * math.pi / Segments)
		local x = Origin.X + Radius * math.cos(Angle)
		local z = Origin.Z + Radius * math.sin(Angle)
		local Point = Vector3.new(x, Origin.Y, z)
		local Raycast = workspace:Raycast(Origin, (Point - Origin), Params)
		
		table.insert(Vertices, Raycast and Raycast.Position or Point)
	end
	
	for i = 1, Segments - 1 do
		local FirstVertex, SecondVertex = Vertices[i], Vertices[i + 1]
		local WedgeData = { MakeTris(FirstVertex, SecondVertex, Origin) }
		local WedgesParts = { Constants.Wedges[i], Constants.Wedges[Segments + i] }
		for i, Wedge in ipairs(WedgesParts) do
			Wedge.CFrame = WedgeData[i][1]
			Wedge.Size = Vector3.new(Config.Thickness, 0, 0) + WedgeData[i][2]
			table.insert(Wedges, Wedge)
		end
	end
	--[[
	Vertices[1] first Vertex
	Vertices[Segments] last Vertex
	]]
	if Vertices[Segments] and Vertices[1] then
		local WedgeData = { MakeTris(Vertices[1], Vertices[Segments], Origin) }
		local WedgesParts = { Constants.Wedges[Segments - 1], Constants.Wedges[Segments] }
		for i, Wedge in ipairs(WedgesParts) do
			Wedge.CFrame = WedgeData[i][1]
			Wedge.Size = Vector3.new(Config.Thickness, 0, 0) + WedgeData[i][2]
			table.insert(Wedges, Wedge)
		end
	end
	
	return Wedges
end

function RadiusInator:ClearAllFromView()
	local Constants = self._Constants
	local Wedges = Constants.Wedges
	for _, Wedge in ipairs(Wedges) do
		Wedge.CFrame = FarCFrame
	end
end

function RadiusInator:Destroy()
	local Constants = self._Constants
	local Wedges = Constants.Wedges
	for _, Wedge in ipairs(Wedges) do
		Wedge:Destroy()
	end
	table.clear(Wedges)
	table.clear(self)
end

return RadiusInator
