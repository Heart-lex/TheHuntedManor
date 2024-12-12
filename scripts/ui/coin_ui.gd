extends CanvasLayer

@onready var key_1: TextureRect = $MarginContainer/HBoxContainer/Key1
@onready var door_key: TextureRect = $MarginContainer/HBoxContainer/DoorKey
@onready var key_2: TextureRect = $MarginContainer/HBoxContainer/Key2
@onready var red_potion: TextureRect = $MarginContainer/HBoxContainer/RedPotion
@onready var key_3: TextureRect = $MarginContainer/HBoxContainer/Key3
@onready var blue_potion: TextureRect = $MarginContainer/HBoxContainer/BluePotion
@onready var key_4: TextureRect = $MarginContainer/HBoxContainer/Key4
@onready var green_potion: TextureRect = $MarginContainer/HBoxContainer/GreenPotion
@onready var key_5: TextureRect = $MarginContainer/HBoxContainer/Key5
@onready var purple_potion: TextureRect = $MarginContainer/HBoxContainer/PurplePotion

var coin_count: int = 0
var door_key_count: int = 0
var red_potion_count: int = 0
var blue_potion_count: int = 0
var green_potion_count: int = 0
var purple_potion_count: int = 0

# Reference to the Label node
@onready var coin_label: Label = $HBoxContainer/coin_label

func _ready() -> void:
	self.visible = true
	door_key.visible = false
	key_1.visible = false
	red_potion.visible = false
	key_2.visible = false
	blue_potion.visible = false
	key_3.visible = false
	green_potion.visible = false
	key_4.visible = false
	purple_potion.visible = false
	key_5.visible = false
	
func _process(delta: float) -> void:
		if door_key_count == 0: 
			door_key.visible = false
			key_1.visible = false
		else:
			door_key.visible = true
			key_1.visible = true
		if red_potion_count == 0:
			red_potion.visible = false
			key_2.visible = false
		else:
			red_potion.visible = true
			key_2.visible = true
		if blue_potion_count == 0: 
			blue_potion.visible = false
			key_3.visible = false
		else:
			blue_potion.visible = true
			key_3.visible = true
		if green_potion_count == 0:
			green_potion.visible = false
			key_4.visible = false
		else: 
			green_potion.visible = true
			key_4.visible = true
		if purple_potion_count == 0: 
			purple_potion.visible = false
			key_5.visible = false
		else: 
			purple_potion.visible = true
			key_5.visible = true
	
# Function to update the coin count
func update_coin_count(amount: int) -> void:
	coin_count += amount
	coin_label.text = str(coin_count)
