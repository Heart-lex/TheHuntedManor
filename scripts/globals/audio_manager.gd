extends Node3D

@onready var shop_keeper: AudioStreamPlayer = $ShopKeeper
@onready var coin_collecting: AudioStreamPlayer = $CoinCollecting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func manageAudio(audio_type: EnumClass.audio_type) -> void:
	match audio_type:
		EnumClass.audio_type.COIN_COLLECTING:
			coin_collecting.play()
			
