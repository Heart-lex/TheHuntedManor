extends Node3D

@onready var camera_rig: CameraRig = $Heroes/camera_rig
@onready var rogue: Rogue = $Heroes/Rogue
@onready var knight: Knight = $Heroes/Knight

var temp_state

# UI
@onready var coin_collector_ui: CanvasLayer = $UI/coin_collector_ui
@onready var interaction_prompt: CanvasLayer = $UI/InteractionPrompt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.set_heroes(knight, rogue)
	GameManager.set_knight_as_active()
	
	interaction_prompt.visible = false

# Signal handler to update the UI when a coin stack is collected
func _on_coin_collected() -> void:
	coin_collector_ui.update_coin_count(5)  # Add 5 coins
	
func _on_interaction_prompt() -> void:
	# Display interaction prompt
	interaction_prompt.visible = true
	
func _on_interaction_prompt_close() -> void:
	# Close interaction prompt
	interaction_prompt.visible = false
