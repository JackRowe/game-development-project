extends Node3D

@onready var surfaces: Node = find_child("Surfaces")
@onready var body: RigidBody3D = find_child("Body")
@onready var input: Node = find_child("Input")

func _physics_process(_delta: float) -> void:
	# engine
	var force = global_transform.basis.z * (input.thrustValue * 100)
	var torque = Vector3.ZERO # Vector3(0.0, 0.0, -0.5).cross(force)
	
	print("hello?")
	for surface in surfaces.get_children():
		var result = surface.calculate_forces()
		force += result[0]
		torque += result[1]
		print(surface, "force: ", result[0], " torque: ", result[1])
	
	body.apply_central_force(Vector3(force.x / 1000.0, force.y / 1000.0, force.z / 1000.0))
	body.apply_torque(Vector3(torque.x / 1000.0, torque.y / 1000.0, torque.z / 1000.0))
