extends Area3D

signal coin_collected
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D


func _on_body_entered(body: Node3D)-> void:
	if body.is_in_group("player"):
		audio_player.play()
		emit_signal("coin_collected")
		queue_free()
