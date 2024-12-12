class_name Shop

extends CanvasLayer

@export var mage : Mage
@onready var exit_button: Button = $exitButton
@onready var shop_card: Control = $ShopCard
@onready var shop_card_2: Control = $ShopCard2
@onready var shop_card_3: Control = $ShopCard3
@onready var error_message: CanvasLayer = $ErrorMessage

func _on_exit_button_pressed() -> void:
		self.visible = false
