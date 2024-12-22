extends Area3D

@onready var coin_collecting: AudioStreamPlayer = $CoinCollecting


func _on_body_entered(body: Node3D)-> void:
	if body.is_in_group("player"):
		AudioManager.play_sound(AudioManager.COIN_COLLECTING, 0.25, 1)
		CoinCollector.update_coin_count(5)
		queue_free()
