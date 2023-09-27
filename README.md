# Something-i-think
i dont know what this is called lol heres some docs
### [.new()](RadiusInator.lua)
it makes a new instance of this class
```lua
Module.new(Config: {
  Segments = 100,
  Origin = Vector3.new(0, 5, 0),
  Radius = 30,
  SampleWedge = SampleWedge,
  Thickness = 1,
  RaycastParameters = RaycastParams.new(),
  Parent = workspace.Wedges
}): Instance
```
### [:Update()](RadiusInator.lua)
Generates the actual thing you want
```lua
Instance:Update(): {WedgePart}
```
Pro tip changing the Config would automatically change it in the code as well

### [:ClearAllFromView()](RadiusInator.lua)
This method gets all the current part you can see and retire them to somewhere far away
```lua
Instance:ClearAllFromView(): nil
```
### [:Destroy()](RadiusInator.lua)
This method destroys the Instance (dm me if there are memory leak i did not check)
```lua
Instance:Destory(): nil
```
Example code
```lua
local WedgeClass = require(script.RadiusInator)
local SampleWedge = Instance.new("WedgePart")
SampleWedge.Anchored = true

local Config = {
	Segments = 100,
	Origin = Vector3.new(0, 5, 0),
	Radius = 30,
	SampleWedge = SampleWedge,
	Thickness = 1,
	RaycastParameters = RaycastParams.new(),
	Parent = workspace.Wedges
}

local Class = WedgeClass.new(Config)

while task.wait() do
	local Sine = math.sin(tick())
	Config.Radius = Sine * 30 --Very efficient Trust!!
	local Wedges = Class:Update()
	for i, Wedge: BasePart in ipairs(Wedges) do
		Wedge.Color = Color3.new(Sine, Sine, Sine)
	end
end
```

