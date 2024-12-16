extends Node3D

@onready var rogue: Rogue = $Heroes/Rogue
@onready var knight: Knight = $Heroes/Knight
@onready var coin_stack_scene: PackedScene = preload("res://scenes/items/coins_stack.tscn")
@onready var mage_dialogue: CanvasLayer = $MageDialogue
@onready var mage: CharacterBody3D = $Mage
@onready var lever: CharacterBody3D = $Lever
@onready var lever_door: Node3D = $DungeonDoor/LeverDoor
@export var shop: Shop
@onready var camera_rig: CameraRig = $Heroes/camera_rig

var triggered_door: bool = false
var temp_state

# UI
@onready var interaction_prompt: CanvasLayer = $UI/InteractionPrompt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	GameManager.is_main_menu_active = false
	GameManager.set_heroes(knight, rogue)
	GameManager.set_knight_as_active()
	
	shop.shop_card.create_card(CardType.card_type.RED_POTION)
	shop.shop_card.coin_count.text = "10"
	shop.shop_card_2.create_card(CardType.card_type.DOOR_KEY)
	shop.shop_card_2.coin_count.text = "7"
	shop.shop_card_3.create_card(CardType.card_type.BLUE_POTION)
	shop.shop_card_3.coin_count.text = "9"
