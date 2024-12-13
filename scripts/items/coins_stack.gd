extends Area3D

@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _on_body_entered(body: Node3D)-> void:
	if body.is_in_group("player"):
		audio_player.play()
		CoinCollector.update_coin_count(5)
		queue_free()
