extends Node

@onready var controller: RigidBody3D = get_parent()

func applyThrust() -> void:
	var forward = controller.global_transform.basis.z
	var scaledThrust = controller.thrustValue / 100.0
	# maybe reduce efficiency with speed
	var force = scaledThrust * Physics.GetMaxThrust()
	controller.apply_central_force(forward * force)

# lift = 0.5 * airDensity * velocityRelativeToAir ^ 2 * area * coefficientOfLift
func applyLift() -> void:
	pass

# force = 0.5 * airDensity * velocityRelativeToAir ^ 2 * coefficient
func applyDrag() -> void:
	pass

func _physics_process(_delta: float) -> void:
	applyThrust()
	applyLift()
	applyDrag()
