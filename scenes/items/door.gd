extends Node3D

@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	animation_tree.set("parameters/DoorMovement/transition_request", "Opened")

func open() -> void:
	animation_tree.set("parameters/DoorMovement/transition_request", "Open")
	print("Door opened")
