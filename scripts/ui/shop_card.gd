class_name ShopCards

extends Control

@onready var buy_button: Button = $PanelContainer/MarginContainer/ButtonMarginContainer/buyButton
@onready var coin_count: Label = $PanelContainer/MarginContainer/CoinBox/CoinContainer/CoinCount
@onready var image: TextureRect = $PanelContainer/MarginContainer/CoinBox/ImgMarginContainer/HBoxImgContainer/Image
@onready var title_text: Label = $PanelContainer/MarginContainer/CoinBox/TitleMarginContainer/HBoxContainer/TitleText
@onready var description_text: Label = $PanelContainer/MarginContainer/CoinBox/DescriptionMarginContainer/HBoxContainer/DescriptionText
@onready var error_message: CanvasLayer = $ErrorMessage

enum card_type { RED_POTION, GREEN_POTION, BLUE_POTION ,PURPLE_POTION, DOOR_KEY }
var type : card_type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_card (name: String) -> void:
	match name:
		"RED POTION":
			type = card_type.RED_POTION
			image.texture = preload("res://assets/red_potion.png") 
			title_text.text = "red potion"
			description_text.text = "a mystical brew that pulses with life energy. Consuming it grants 10xp, fueling your journey toward greater power skill."
		"GREEN POTION":
			type = card_type.GREEN_POTION
			image.texture = preload("res://assets/green_potion.png") 
			title_text.text = "green potion"
			description_text.text = "drink to gain a magical shield that makes you immune to all damage for 30 seconds. perfect for daring escapes or bold attacks"
		"PURPLE POTION":
			type = card_type.PURPLE_POTION
			image.texture = preload("res://assets/purple_potion.png") 
			title_text.text = "purple potion"
			description_text.text = "this potion allows rogues to cast a unique spell, like unlocking doors or triggering mechanisms without a key or lever"
		"BLUE POTION":
			type = card_type.BLUE_POTION
			image.texture = preload("res://assets/blue_potion.png") 
			title_text.text = "blue potion"
			description_text.text = "drink to gain a burst of speed outrunning enemies or completing tasks in record time!"
		"DOOR KEY":
			type = card_type.DOOR_KEY
			image.texture = preload("res://assets/door_key.png") 
			title_text.text = "door key"
			description_text.text = "this key will help you unlock a closed door. careful! you do not want those with a lever"
		
func _on_buy_button_pressed() -> void:
		# Disable the button
	var coin_collector_total = CoinCollector.coin_count
	var card_total = int(coin_count.text)
	if coin_collector_total > card_total:
		buy_button.disabled = true
		if type == card_type.RED_POTION:
			CoinCollector.red_potion_count += 1
			CoinCollector.update_visibility()
		if type == card_type.GREEN_POTION:
			CoinCollector.green_potion_count += 1
			CoinCollector.update_visibility()
		if type == card_type.PURPLE_POTION:
			CoinCollector.purple_potion_count += 1
			CoinCollector.update_visibility()
		if type == card_type.BLUE_POTION:
			CoinCollector.blue_potion_count += 1
			CoinCollector.update_visibility()
		if type == card_type.DOOR_KEY:
			CoinCollector.door_key_count += 1
			CoinCollector.update_visibility()
	error_message.visible = true  
	await get_tree().create_timer(2).timeout
	error_message.visible = false  
