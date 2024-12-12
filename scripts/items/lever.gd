extends CharacterBody3D

@export var door : Door

@onready var detection_area: Area3D = $DetectionArea
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var interaction_prompt: CanvasLayer = $InteractionPrompt

var active: bool = false
var is_triggered: bool = false

func _ready() -> void:
	interaction_prompt.visible = false
	animation_tree.set("parameters/LeverToggle/transition_request", "Idle")
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and active == true and not is_triggered:
		door.open()
		is_triggered = true
		interaction_prompt.visible = false
		animation_tree.set("parameters/LeverToggle/transition_request", "Toggle")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("rogue"):
		active = true
		if not is_triggered:
			interaction_prompt.visible = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("rogue"):
		active = false
		interaction_prompt.visible = false
		
