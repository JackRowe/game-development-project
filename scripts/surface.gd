extends Node3D

@export var area: float = 1.0  # surface area in square meters
@export var lift_coefficient: float = 0.5
@export var drag_coefficient: float = 0.05

# Reference to the aircraft body to get velocity
var body: RigidBody3D

func _ready() -> void:
	# Get reference to the aircraft body
	body = get_parent().get_parent().find_child("Body")

func calculate_forces() -> PackedVector3Array:
	if not body:
		return PackedVector3Array([Vector3.ZERO, Vector3.ZERO])
	
	# Get velocity at this surface's position
	var velocity = body.linear_velocity
	var speed_squared = velocity.length_squared()
	
	if speed_squared < 0.01:  # avoid calculations at very low speeds
		return PackedVector3Array([Vector3.ZERO, Vector3.ZERO])
	
	# Air density (kg/m³)
	var air_density = 1.225
	
	# Calculate lift (perpendicular to velocity and surface normal)
	var surface_normal = global_transform.basis.y
	var lift_direction = velocity.cross(surface_normal).cross(velocity).normalized()
	var lift_force = lift_direction * lift_coefficient * 0.5 * air_density * speed_squared * area
	
	# Calculate drag (opposite to velocity)
	var drag_force = -velocity.normalized() * drag_coefficient * 0.5 * air_density * speed_squared * area
	
	# Total force
	var total_force = lift_force + drag_force
	
	# Calculate torque (force applied at this surface's position relative to body)
	var offset = global_position - body.global_position
	var total_torque = offset.cross(total_force)
	
	return PackedVector3Array([total_force, total_torque])
