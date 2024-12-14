extends Node

var camera_rig : CameraRig
var hero_knight : Knight
var hero_rogue : Rogue
var temp_state : bool
	
	
func set_heroes(knight : Knight, rogue: Rogue) -> void:
	hero_knight = knight
	hero_rogue = rogue
	
	
func set_knight_as_active() -> void:
	hero_knight.active = true
	hero_rogue.active = false
	
	
func set_rogue_as_active() -> void:
	hero_rogue.active = true
	hero_knight.active = false
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_switch"):
		temp_state = !hero_knight.active
		hero_rogue.active = hero_knight.active
		hero_knight.active = temp_state
		
		if hero_knight.camera.is_current():
			hero_knight.camera.clear_current(true)
		elif hero_rogue.camera.is_current():
			hero_rogue.camera.clear_current(true)
