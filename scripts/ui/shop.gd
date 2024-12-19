class_name Shop

extends CanvasLayer

@export var mage : Mage
@onready var exit_button: Button = $exitButton
@onready var shop_card: ShopCards = $ShopCard
@onready var shop_card_2: ShopCards = $ShopCard2
@onready var shop_card_3: ShopCards = $ShopCard3

func _on_exit_button_pressed() -> void:
		self.visible = false
