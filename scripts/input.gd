extends Node

@export var thrustValue: float = 0 # 0 - 100
@export var pitchValue: float = 0 # -1 - 1 
@export var rollValue: float = 0 # -1 - 1 
@export var yawValue: float = 0 # -1 - 1 

@export var thrustState: float = 0 # -1 - 1
@export var pitchState: float = 0 # -1 - 1
@export var rollState: float = 0 # -1 - 1
@export var yawState: float = 0 # -1 - 1

func _input(_event: InputEvent) -> void:
	thrustState = Input.get_action_strength("PositiveThrust") - Input.get_action_strength("NegativeThrust")
	pitchState = Input.get_action_strength("PositivePitch") - Input.get_action_strength("NegativePitch")
	rollState = Input.get_action_strength("PositiveRoll") - Input.get_action_strength("NegativeRoll")
	yawState = Input.get_action_strength("PositiveYaw") - Input.get_action_strength("NegativeYaw")

func _process(delta: float) -> void:
	thrustValue = clamp(thrustValue + ((thrustState * delta) * 25.0), 0.0, 100.0)
	pitchValue = lerp(pitchValue, pitchState, delta * 5.0)
	rollValue = lerp(rollValue, rollState, delta * 5.0)
	yawValue = lerp(yawValue, yawState, delta * 5.0)
