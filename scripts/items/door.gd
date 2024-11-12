extends Node3D

@onready var door_back: Area3D = $doorway/DoorBack
@onready var door_front: Area3D = $doorway/DoorFront
@onready var doorway_door: MeshInstance3D = $doorway/doorway_door


func _on_door_back_body_entered(body: Node3D) -> void:
	if body.is_in_group("RaycastUse"):
		print("I'm behind of the door!")

func _on_door_front_body_entered(body: Node3D) -> void:
	if body.is_in_group("RaycastUse"):
		print("I'm behind of the door!")
