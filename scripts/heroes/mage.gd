extends CharacterBody3D

signal client_entered

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		emit_signal("client_entered")
		
		
