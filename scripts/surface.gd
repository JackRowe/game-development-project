extends Node3D

var body: RigidBody3D
var input: Node

@export var surface_area: float = 1.0
@export var lift_coefficient: float = 0.5
@export var drag_coefficient: float = 0.05

var air_density: float = 1.225

func _ready() -> void:
	body = get_parent().get_parent()
	input = body.get_parent().find_child("Input")

func calculate_forces() -> PackedVector3Array:
	if not body:
		return PackedVector3Array([Vector3.ZERO, Vector3.ZERO])
	
	var force = Vector3.ZERO
	var torque = Vector3.ZERO
	
	var localVelocity = global_transform.basis.inverse() * body.linear_velocity
	var velocitySquared = localVelocity * localVelocity
	
	var magnitude = 0.5 * air_density * velocitySquared * surface_area * lift_coefficient
	var direction = global_transform.basis.y
	force = direction * magnitude.length()
	
	return PackedVector3Array([force, torque])
