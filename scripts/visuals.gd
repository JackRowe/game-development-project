extends Node

@onready var parent: RigidBody3D = get_parent()
@onready var controller: Node3D = parent.get_parent()
@onready var input: = controller.find_child("Input")
@onready var skeleton: Skeleton3D = find_child("Skeleton3D")

var propellerAngle: float = 0.0
var propellerMultiplier: float = 1.0
var propellerIdle: float = 10.0

func animatePropeller(delta: float) -> void:
	var propellerBone := skeleton.find_bone("Prop")
	if(propellerBone == -1): return
	var idlePose: Transform3D = skeleton.get_bone_rest(propellerBone)
	
	var rotation = (input.thrustValue * propellerMultiplier) + propellerIdle
	propellerAngle += rotation * delta
	propellerAngle = fmod(propellerAngle, TAU)
	
	var basis = Basis.from_euler(Vector3(0, propellerAngle, 0))
	skeleton.set_bone_pose(propellerBone, Transform3D(basis, idlePose.origin))

func animateAilerons(_delta: float) -> void:
	var aileronLeftBone := skeleton.find_bone("AileronLeft")
	var aileronRightBone := skeleton.find_bone("AileronRight")
	if(aileronLeftBone == -1 || aileronRightBone == -1): return
	var leftIdlePose: Transform3D = skeleton.get_bone_rest(aileronLeftBone)
	var rightIdlePose: Transform3D = skeleton.get_bone_rest(aileronRightBone)
	
	#var angleLeft = Physics.GetControlSurfaceAngle("LeftAileron", -input.rollValue, true)
	#var angleRight = Physics.GetControlSurfaceAngle("RightAileron", input.rollValue, true)
	
	#var rotationLeft = Basis.from_euler(Vector3(angleLeft, 0, 0))
	#var rotationRight = Basis.from_euler(Vector3(angleRight, 0, 0))
	
	#skeleton.set_bone_pose(aileronLeftBone, Transform3D(leftIdlePose.basis * rotationLeft, leftIdlePose.origin))
	#skeleton.set_bone_pose(aileronRightBone, Transform3D(rightIdlePose.basis * rotationRight, rightIdlePose.origin))

func animateElevator(_delta: float) -> void:
	var elevatorBone := skeleton.find_bone("Elevator")
	if(elevatorBone == -1): return
	var idlePose: Transform3D = skeleton.get_bone_rest(elevatorBone)
	
	#var rotation = Basis.from_euler(Vector3(Physics.GetControlSurfaceAngle("Elevator", input.pitchValue, true), 0, 0))
	#skeleton.set_bone_pose(elevatorBone, Transform3D(idlePose.basis * rotation, idlePose.origin))

func animateFlaps(_delta: float) -> void:
	pass

func animateRudder(_delta: float) -> void:
	var rudderBone := skeleton.find_bone("Rudder")
	if(rudderBone == -1): return
	var idlePose: Transform3D = skeleton.get_bone_rest(rudderBone)
	
	#var rotation = Basis.from_euler(Vector3(0, 0, Physics.GetControlSurfaceAngle("Rudder", input.yawValue, true)))
	#skeleton.set_bone_pose(rudderBone, Transform3D(idlePose.basis * rotation, idlePose.origin))

func _process(delta: float) -> void:
	animatePropeller(delta)
	animateAilerons(delta)
	animateElevator(delta)
	animateFlaps(delta)
	animateRudder(delta)
