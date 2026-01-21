extends Node3D

var body: RigidBody3D
var input: Node

@export var surface_area: float = 1.0
@export var lift_coefficient: float = 0.5
@export var drag_coefficient: float = 0.05

@export var deflection: float = 0.0
@export var max_deflection: float = 0.0
enum ControlMethod { NONE, PITCH, ROLL, YAW }
@export var controlMethod: ControlMethod = ControlMethod.NONE
@export var inverted = false


var air_density: float = 1.225

func _ready() -> void:
	body = get_parent().get_parent()
	input = body.get_parent().find_child("Input")

# TODO! 
# torque

func calculate_forces() -> PackedVector3Array:
	if not body:
		return PackedVector3Array([Vector3.ZERO, Vector3.ZERO])
	
	var force = Vector3.ZERO
	var torque = Vector3.ZERO
	
	var localVelocity = body.global_transform.basis.inverse() * body.linear_velocity
	var speed = localVelocity.z * localVelocity.z #local_velocity.dot(global_transform.basis.x) * body.linear_velocity.dot(global_transform.basis.x)
	
	# lift
	var magnitude = 0.5 * air_density * speed * surface_area * lift_coefficient
	var direction = body.basis.y
	force = direction * magnitude
	
	# drag
	magnitude = 0.5 * air_density * body.linear_velocity.length_squared() * surface_area * drag_coefficient
	direction = -direction
	force += direction * magnitude
	
	# torque
	var arm = position + body.position - body.position
	torque = arm.cross(force)
	
	return PackedVector3Array([force, torque])
