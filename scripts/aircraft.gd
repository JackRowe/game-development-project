extends RigidBody3D

@onready var input: Node = find_child("Input")
@onready var surfaces: Node = find_child("Surfaces")

@export var lastForce = Vector3.ZERO
@export var lastTorque = Vector3.ZERO

# TODO
# add fuselage drag

func _physics_process(_delta: float) -> void:
	# engine
	var force = global_transform.basis.z * (input.thrustValue * 100)
	var torque = Vector3.ZERO
	
	for surface in surfaces.get_children():
		if(surface.name == "Rudder"): continue
		var result = surface.calculate_forces()
		force += result[0]
		torque += result[1]
	
	force = global_transform.basis * force
	
	lastForce = Vector3(force.x / 1000.0, force.y / 1000.0, force.z / 1000.0)
	lastTorque = Vector3(torque.x / 1000.0, torque.y / 1000.0, torque.z / 1000.0)
	apply_central_force(Vector3(force.x / 1000.0, force.y / 1000.0, force.z / 1000.0))
	apply_torque(Vector3(torque.x / 1000.0, torque.y / 1000.0, torque.z / 1000.0))
