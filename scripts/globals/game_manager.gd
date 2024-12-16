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
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("use_blue_potion"):
		if CoinCollector.blue_potion_count > 0: 
			CoinCollector.blue_potion_count -=1
	if Input.is_action_just_pressed("use_green_potion"):
		if CoinCollector.green_potion_count > 0: 
			CoinCollector.green_potion_count -=1
	if Input.is_action_just_pressed("use_red_potion"):
		if CoinCollector.red_potion_count > 0: 
			CoinCollector.red_potion_count -=1
			if hero_knight.active:
				hero_knight.health_component += 10
			else:
				hero_rogue.health_component += 10
	if Input.is_action_just_pressed("use_purple_potion"):
		if CoinCollector.purple_potion_count > 0: 
			CoinCollector.purple_potion_count -=1
	
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
