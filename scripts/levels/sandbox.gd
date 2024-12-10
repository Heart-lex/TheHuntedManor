extends Node3D

@onready var camera1 = $Knight/CameraPivot/IsometricCamera
@onready var camera2 = $Rogue/CameraPivot/IsometricCamera
@onready var rogue: Rogue = $Rogue
@onready var knight: Knight = $Knight

var temp_state

# UI
@onready var coin_collector_ui: CanvasLayer = $UI/coin_collector_ui
@onready var interaction_prompt: CanvasLayer = $UI/InteractionPrompt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	knight.active = true
	rogue.active = false
	
	interaction_prompt.visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_switch"):
		temp_state = !knight.active
		rogue.active = knight.active
		knight.active = temp_state
		
		print("Knight status:", knight.active)  # Debug print
		print("Rogue status:", rogue.active)    # Debug print
		
		print("Groups:", rogue.get_groups())  # Debugging line
		
		if camera1.is_current():
			camera1.clear_current(true)
		elif camera2.is_current():
			camera2.clear_current(true)

# Signal handler to update the UI when a coin stack is collected
func _on_coin_collected() -> void:
	coin_collector_ui.update_coin_count(5)  # Add 5 coins
	
func _on_interaction_prompt() -> void:
	# Display interaction prompt
	interaction_prompt.visible = true
	
func _on_interaction_prompt_close() -> void:
	# Close interaction prompt
	interaction_prompt.visible = false
