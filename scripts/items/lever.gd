extends CharacterBody3D

@onready var detection_area: Area3D = $DetectionArea
@onready var animation_tree: AnimationTree = $AnimationTree

var active: bool = false

signal trigger_door
signal interact_prompt
signal interact_prompt_close

func _ready() -> void:
	animation_tree.set("parameters/LeverToggle/transition_request", "Idle")
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and active == true:
		emit_signal("trigger_door")
		animation_tree.set("parameters/LeverToggle/transition_request", "Toggle")
		

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("rogue"):
		emit_signal("interact_prompt") # signal to allow interaction with current active player
		active = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("rogue"):
		emit_signal("interact_prompt_close") # signal to allow interaction with current active player
		active = false
		
