extends Node3D

@onready var body: RigidBody3D = find_child("Body")
@onready var input: Node = find_child("Input")
@onready var surfaces: Node = body.find_child("Surfaces")

@export var lastForce = Vector3.ZERO
@export var lastTorque = Vector3.ZERO

func _physics_process(_delta: float) -> void:
	# engine
	var force = body.global_transform.basis.z * (input.thrustValue * 100)
	var torque = Vector3(0.0, 0.0, 0.5 / 1000.0).cross(force)
	
	for surface in surfaces.get_children():
		var result = surface.calculate_forces()
		force += result[0]
		torque += result[1]
	
	lastForce = Vector3(force.x / 1000.0, force.y / 1000.0, force.z / 1000.0)
	lastTorque = Vector3(torque.x / 1000.0, torque.y / 1000.0, torque.z / 1000.0)
	body.apply_central_force(Vector3(force.x / 1000.0, force.y / 1000.0, force.z / 1000.0))
	body.apply_torque(Vector3(torque.x / 1000.0, torque.y / 1000.0, torque.z / 1000.0))
