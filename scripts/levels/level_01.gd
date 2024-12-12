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
@export var shop: Shop

var triggered_door: bool = false
var temp_state

# UI
@onready var interaction_prompt: CanvasLayer = $UI/InteractionPrompt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	knight.active = true
	rogue.active = false
	
	shop.shop_card.create_card("RED POTION")
	shop.shop_card.coin_count.text = "10"
	shop.shop_card_2.create_card("DOOR KEY")
	shop.shop_card_2.coin_count.text = "7"
	shop.shop_card_3.create_card("BLUE POTION")
	shop.shop_card_3.coin_count.text = "9"
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_switch"):
		temp_state = !knight.active
		rogue.active = knight.active
		knight.active = temp_state
		
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
	CoinCollector.update_coin_count(5)  # Add 5 coins
