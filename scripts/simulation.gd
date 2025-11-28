extends Node

@onready var controller: RigidBody3D = get_parent()

func calculateThrust() -> Vector3:
	var forward = controller.global_transform.basis.z
	var scaledThrust = controller.thrustValue / 100.0
	# maybe reduce efficiency with speed
	var force = scaledThrust * Physics.GetMaxThrust()
	return forward * force

func calculateSurfaceLift() -> Vector3:
	return Vector3.ZERO

func calculateLift() -> Vector3:
	return Vector3.ZERO

func _physics_process(delta: float) -> void:
	var thrust: Vector3 = calculateThrust()
	controller.apply_central_force(thrust)
