extends Node

# control surface deflection angles
# https://cessna172r.blogspot.com/2012/08/cessna-172-control.html
var Rudder: float = 17.0

# TODO implement trim?
var ElevatorMax: float = 28
var ElevatorMin: float = -23

var AileronMax: float = 20
var AileronMin: float = 15

# TODO flaps

func GetRudderAngle(value: float, radians: bool) -> float:
	if(radians): return deg_to_rad(Deflections.Rudder * value)
	return Deflections.Rudder * value

func GetElevatorAngle(value: float, radians: bool) -> float:
	var angle: float = 0
	if(value >= 0): angle = Deflections.ElevatorMax * value
	else: angle =  Deflections.ElevatorMin * -value
	
	if(radians): return deg_to_rad(angle)
	return angle

func GetAileronAngle(value: float, radians: bool) -> float:
	var angle: float = 0
	if(value >= 0): angle = Deflections.AileronMax * value
	else: angle =  Deflections.AileronMin * value
	
	if(radians): return deg_to_rad(angle)
	return angle
