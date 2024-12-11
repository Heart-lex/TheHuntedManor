extends Node3D

@onready var camera1 = $Knight/CameraPivot/IsometricCamera
@onready var camera2 = $Rogue/CameraPivot/IsometricCamera
@onready var rogue: Rogue = $Rogue
@onready var knight: Knight = $Knight
@onready var coin_stack_scene: PackedScene = preload("res://scenes/items/coins_stack.tscn")
@onready var mage_dialogue: CanvasLayer = $MageDialogue
@onready var mage: CharacterBody3D = $Mage
@onready var lever: CharacterBody3D = $Lever
@onready var lever_door: Node3D = $DungeonDoor/LeverDoor

var triggered_door: bool = false
var temp_state

# UI
@onready var coin_collector_ui: CanvasLayer = $UI/coin_collector_ui
@onready var interaction_prompt: CanvasLayer = $UI/InteractionPrompt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	knight.active = true
	rogue.active = false
	
	mage.connect("client_entered", Callable(self, "_on_mage_client_entered"))
	mage_dialogue.visible = false
	
	lever.connect("interact_prompt", Callable(self, "_on_interaction_prompt"))
	lever.connect("interact_prompt_close", Callable(self, "_on_interaction_prompt_close"))
	interaction_prompt.visible = false
	
	lever_door.connect("trigger_door", Callable(self, "_on_lever_trigger"))
	
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
			
# Function to spawn a coin stack at a specific position
func _spawn_coin_stack(position: Vector3) -> void:
	var coin_stack_instance = coin_stack_scene.instantiate()  # Instantiate the coin stack scene
	coin_stack_instance.global_transform.origin = position  # Set its position
	add_child(coin_stack_instance)  # Add the coin stack to the scene

	# Connect the signal to the _on_coin_collected function
	coin_stack_instance.connect("coin_collected", Callable(self, "_on_coin_collected"))  

# Signal handler to update the UI when a coin stack is collected
func _on_coin_collected() -> void:
	coin_collector_ui.update_coin_count(5)  # Add 5 coins
	
func _on_mage_client_entered() -> void:
	# Show the Mage dialogue
	mage_dialogue.visible = true
	
func _on_interaction_prompt() -> void:
	# Display interaction prompt
	if not triggered_door:
		interaction_prompt.visible = true
	
func _on_interaction_prompt_close() -> void:
	# Close interaction prompt
	interaction_prompt.visible = false
	
func _on_lever_trigger() -> void:
	triggered_door = true
	interaction_prompt.visible = false
	lever_door.open()
