extends Node3D

@onready var camera1 = $Knight/CameraPivot/IsometricCamera
@onready var camera2 = $Rogue/CameraPivot/IsometricCamera
@onready var rogue: Rogue = $"Collisions/First Floor/Rogue"
@onready var knight: Knight = $Knight

var temp_state
@onready var coin_collector_ui: CanvasLayer = $coin_collector_ui

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	knight.active = true
	rogue.active = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_switch"):
		temp_state = !knight.active
		rogue.active = knight.active
		knight.active = temp_state
		if camera1.is_current():
			camera1.clear_current(true)
		elif camera2.is_current():
			camera2.clear_current(true)
			
func _spawn_coin(coin_scene: PackedScene, position: Vector2) -> void:
	var coin_instance = coin_scene.instantiate()
	coin_instance.position = position
	coin_instance.connect("coin_collected", self._on_coin_collected)
	add_child(coin_instance)

func _on_coin_collected() -> void:
	coin_collector_ui.update_coin_count(1)
