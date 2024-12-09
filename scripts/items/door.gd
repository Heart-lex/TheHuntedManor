extends Node3D

@export var locked : bool = false

@onready var doorway_door: MeshInstance3D = $doorway/doorway_door
@onready var anim_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

func _ready() -> void:
	anim_state_machine.start("closed")

func open() -> void:
	anim_state_machine.travel("open")
	print("Door opened")
