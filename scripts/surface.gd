extends Node3D

var body: RigidBody3D
var input: Node

@export_category("aerodynamic properties")
@export var surface_area: float = 1.0
@export var lift_coefficient: float = 0.5
@export var drag_coefficient: float = 0.05
@export var lift_slope: float = 2.0 * PI
@export var stall_angle: float = 15.0
@export var zero_lift_aoa: float = 0.0

@export_category("input properties")
@export var deflection: float = 0.0
@export var max_deflection: float = 0.0
@export var trim: float = 0.0
enum ControlMethod { NONE, PITCH, ROLL, YAW }
@export var control_method: ControlMethod = ControlMethod.NONE
@export var inverted = false

var air_density: float = 1.225

func _ready() -> void:
	body = get_parent().get_parent()
	input = body.get_parent().find_child("Input")

func _physics_process(_delta: float) -> void:
	update_deflection()

# TODO!
# control surfaces
# fix torque?

func update_deflection() -> void:
	if not input or max_deflection == 0.0 or control_method == ControlMethod.NONE: return
	
	var value: float = 0.0
	
	match control_method:
		ControlMethod.PITCH:
			value = input.pitchValue
		ControlMethod.ROLL:
			value = input.rollValue
		ControlMethod.YAW:
			value = input.yawValue
		ControlMethod.NONE:
			deflection = 0.0
			return
	
	if inverted: value = -value
	deflection = value * max_deflection

func calculate_lift_coefficient(aoa: float) -> float:
	var aoaFromZero = aoa - zero_lift_aoa
	if(abs(aoaFromZero) < stall_angle): return lift_slope * deg_to_rad(aoaFromZero)
	
	var signed = 1.0 if aoaFromZero > 0 else -1.0
	var stall = lift_slope * deg_to_rad(stall_angle)
	return signed * stall * (exp(-abs(aoaFromZero - stall_angle) / 10.0))

func calculate_drag_coefficient(aoa: float, cl: float) -> float:
	var induced = cl * cl / (PI * 6.0) # should be aspect ratio but whatever for now
	var additional = abs(sin(deg_to_rad(aoa)) * 0.5)
	
	return drag_coefficient + induced + additional

func calculate_forces() -> PackedVector3Array:
	if not body:
		return PackedVector3Array([Vector3.ZERO, Vector3.ZERO])
	
	var force = Vector3.ZERO
	var torque = Vector3.ZERO
	
	var localVelocity = body.global_transform.basis.inverse() * body.linear_velocity
	var speed = localVelocity.length_squared()
	
	# aoa
	var aoa = rad_to_deg(atan2(-localVelocity.y, localVelocity.z))
	if(localVelocity.length() <= 0.01): aoa = 0.0
	aoa += deflection + trim
	
	# lift 
	var coefficient = calculate_lift_coefficient(aoa)
	var magnitude = 0.5 * air_density * speed * surface_area * coefficient
	var airflow = -body.linear_velocity.normalized()
	var span = global_transform.basis.x   # hinge line / wingspan direction
	var lift_dir = airflow.cross(span).normalized()
	var direction = lift_dir
	force = direction * magnitude
	
	# drag
	coefficient = calculate_drag_coefficient(aoa, coefficient)
	magnitude = 0.5 * air_density * speed * surface_area * coefficient
	direction = airflow
	force += direction * magnitude
	
	# torque
	torque = position.cross(force)
	
	return PackedVector3Array([force, torque])
