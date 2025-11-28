extends Node

var Scale = 1000 # scaled down mass x1000 bc physics freaked out

var Surfaces = [
	{
		"Name": "LeftWing",
		"Area": 7.4,
		"Slope": 5.7,
		"Offset": Vector3(-1.0, 0.2, 0),
	},
	
	{
		"Name": "RightWing",
		"Area": 7.4,
		"Slope": 5.7,
		"Offset": Vector3(1.0, 0.2, 0),
	},
	
	{
		"Name": "Elevator",
		"Area": 2.3,
		"Slope": 3.5,
		"Offset": Vector3(0, -0.05, -1.6),
		"Control": {
			"MaxDeflection": 28,
			"MinDeflection": 23,
		}
	},
	
	{
		"Name": "Rudder",
		"Area": 1.5,
		"Slope": 2.5,
		"Offset": Vector3(0, 0.15, -1.7),
		"Control": {
			"MaxDeflection": 17,
			"MinDeflection": 17,
		}
	},
	
	{
		"Name": "LeftAileron",
		"Area": 0.8,
		"Slope": 2.8,
		"Offset": Vector3(1.3, 0.15, -0.2),
		"Control": {
			"MaxDeflection": 20,
			"MinDeflection": 15,
		}
	},
	
	{
		"Name": "RightAileron",
		"Area": 0.8,
		"Slope": 2.8,
		"Offset": Vector3(-1.3, 0.15, -0.2),
		"Control": {
			"MaxDeflection": 20,
			"MinDeflection": 15,
		}
	},
]

func GetControlSurfaceAngle(name: String, value: float, radians: bool) -> float:
	for surface in Surfaces:
		if(surface.Name != name): continue
		var angle: float = 0.0
		if value >= 0.0:
			angle = surface["Control"]["MaxDeflection"] * value
		else:
			angle = surface["Control"]["MinDeflection"] * value
		
		if(radians): return deg_to_rad(angle)
		return angle
	
	return 0

func GetSurfaceCL(name: String, aoa: float) -> float:
	for surface in Surfaces:
		if(surface.Name != name): continue
		return clamp(surface.Slope * rad_to_deg(aoa), -2.0, 2.0)
	
	return 0.0

func GetSurfaceArea(name: String) -> float:
	for surface in Surfaces:
		if(surface.Name != name): continue
		return surface.Area
	
	return 0.0

# TODO make it depend on height
func GetAirDensity(height: float) -> float:
	return 1.225

func GetMaxThrust() -> float:
	return 2088.81645 / Scale
