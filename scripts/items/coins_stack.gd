extends Area3D

signal coin_collected

func _on_body_entered(body: Node3D)-> void:

	if body.is_in_group("player"):
		emit_signal("coin_collected")
		queue_free()
