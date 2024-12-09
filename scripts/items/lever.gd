extends CharacterBody3D

@onready var detection_area: Area3D = $DetectionArea

var active: bool = false

signal trigger
signal interact_prompt
signal interact_prompt_close

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and active:
		emit_signal("trigger")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("rogue"):
		emit_signal("interact_prompt") # signal to allow interaction with current active player
		active = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("rogue"):
		emit_signal("interact_prompt_close") # signal to allow interaction with current active player
		active = false
		
