extends Node3D

@onready var camera1 = $Knight/CameraPivot/IsometricCamera
@onready var camera2 = $Rogue/CameraPivot/IsometricCamera
@onready var rogue: Rogue = $Rogue
@onready var knight: Knight = $Knight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	knight.active = true
	rogue.active = false


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("player_switch"):
		var temp_state = !$Knight.active
		$Rogue.active = $Knight.active
		$Knight.active = temp_state
	
	if event.is_action_pressed("player_switch"):
		if camera1.is_current():
			camera1.clear_current(true)
		elif camera2.is_current():
			camera2.clear_current(true)
