extends Node3D

var body: RigidBody3D
var input: Node

@export_category("aerodynamic properties")
@export_range(0.0, 100.0, 0.001, "suffix: m2") var surface_area: float = 1.0
@export var lift_curve: Curve = preload("res://curves/lift_curve.tres")
@export var drg_curve: Curve = preload("res://curves/drag_curve.tres")
@export_range(-100.0, 0.0, 0.001, "or_greater", "exp", "suffix:cl") var min_lift_coefficient = -1.6
@export_range(0.0, 100.0, 0.001, "or_greater", "exp", "suffix:cl") var max_lift_coefficient = 1.6
@export_range(0.0, 190.0, 0.001, "or_greater", "exp", "suffix:cd") var min_drag_coefficient = 0.02
@export_range(0.0, 100.0, 0.001, "or_greater", "exp", "suffix:cd") var max_drag_coefficient = 0.8

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
	var sample: float = lift_curve.sample_baked(
		remap(aoa, -PI, PI, lift_curve.min_domain, lift_curve.max_domain)
	)
	
	if sign(sample) == 1.0: return sample * (max_lift_coefficient / lift_curve.max_value)
	return sample * (abs(min_lift_coefficient) / abs(lift_curve.min_value))

func calculate_drag_coefficient(aoa: float) -> float:
	var sample: float = drg_curve.sample_baked(
		remap(aoa, -PI, PI, drg_curve.min_domain, drg_curve.max_domain)
	)
	return remap(sample, drg_curve.min_value, drg_curve.max_value, min_drag_coefficient, max_drag_coefficient)

func calculate_forces() -> PackedVector3Array:
	if not body:
		return PackedVector3Array([Vector3.ZERO, Vector3.ZERO])
	
	var force = Vector3.ZERO
	var torque = Vector3.ZERO
	
	var vel = body.get_linear_velocity()
	var speed = vel.length()
	var pressure = 0.5 * air_density * speed * speed
	
	var aoa = global_basis.y.angle_to(-vel) - (PI / 2.0)
	
	var cl = calculate_lift_coefficient(aoa)
	var cd = calculate_drag_coefficient(aoa)
	
	var dragDirection = -vel.normalized()
	var dragMagnitude = (pressure * surface_area * cd)
	force += dragMagnitude * dragDirection
	
	var liftMagnitude = pressure * surface_area * cl 
	var liftDirection = dragDirection.cross(-vel.cross(global_transform.basis.y).normalized()).normalized()
	force += liftMagnitude * liftDirection
	
	torque = position.cross(force)
	
	return PackedVector3Array([force, torque])
