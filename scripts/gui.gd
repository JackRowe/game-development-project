extends Control

@onready var body = get_parent().get_parent().get_parent().get_parent()
@onready var input = body.find_child("Input")
@onready var list = find_child("List")
@onready var list2 = find_child("List2")

func snap_vec(v: Vector3) -> Vector3:
	return Vector3(
		snapped(v.x, 0.001),
		snapped(v.y, 0.001),
		snapped(v.z, 0.001)
	)


func _process(_delta: float) -> void:
	list.find_child("Position").text = "Position: " + str(snap_vec(body.position))
	list.find_child("Rotation").text = "Rotation: " + str(snap_vec(body.rotation))
	list.find_child("LinearVelocity").text = "Linear Velocity: " + str(snap_vec(body.linear_velocity))
	list.find_child("AngularVelocity").text = "Angular Velocity: " + str(snap_vec(body.angular_velocity))
	list.find_child("Force").text = "Force: " + str(snap_vec(body.lastForce))
	list.find_child("Torque").text = "Torque: " + str(snap_vec(body.lastTorque))
	list.find_child("Speed").text = "Speed: " + str(body.linear_velocity.length())
	
	list2.find_child("Airspeed").text = "Airspeed: " + str(snapped(body.linear_velocity.length(), 0.1)) + " m/s"
	list2.find_child("Altitude").text = "Altitude: " + str(snapped(body.position.y, 0.1)) + " m"
	list2.find_child("Angle").text = "Aoa: " + str(snapped(body.global_basis.y.angle_to(-body.linear_velocity) - (PI / 2.0), 0.1))
