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
	return 0.0

func calculate_drag_coefficient(aoa: float, cl: float) -> float:
	return 0.0

func calculate_forces() -> PackedVector3Array:
	if not body:
		return PackedVector3Array([Vector3.ZERO, Vector3.ZERO])
	
	var force = Vector3.ZERO
	var torque = Vector3.ZERO
	
	return PackedVector3Array([force, torque])
