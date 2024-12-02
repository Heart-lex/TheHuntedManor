extends CanvasLayer

var coin_count: int = 0

# Reference to the Label node
@onready var coin_label: Label = $HBoxContainer/coin_label

# Function to update the coin count
func update_coin_count(amount: int) -> void:
	coin_count += amount
	print("Coin count updated:", coin_count)  # Debug message
	coin_label.text = str(coin_count)
