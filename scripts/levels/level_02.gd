extends Node3D

@onready var rogue: Rogue = $Heroes/Rogue
@onready var knight: Knight = $Heroes/Knight
@onready var shop: Shop = $UI/shop
@onready var camera_rig: CameraRig = $Heroes/camera_rig

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransitionAnimation.animation_player.play("fade_out")
	get_tree().reload_current_scene()
	
	GameManager.is_main_menu_active = false
	GameManager.set_heroes(knight, rogue)
	GameManager.set_knight_as_active()
	
	shop.shop_card.create_card(EnumClass.card_type.RED_POTION)
	shop.shop_card.coin_count.text = "10"
	shop.shop_card_2.create_card(EnumClass.card_type.DOOR_KEY)
	shop.shop_card_2.coin_count.text = "7"
	shop.shop_card_3.create_card(EnumClass.card_type.BLUE_POTION)
	shop.shop_card_3.coin_count.text = "9"
