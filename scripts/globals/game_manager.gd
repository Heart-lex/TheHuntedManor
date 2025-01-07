extends Node

var camera_rig : CameraRig
var hero_knight : Knight
var hero_rogue : Rogue
var temp_state : bool
var is_main_menu_active: bool = true
var green_potion: bool = false
var character_dead: bool = false

var level_number: int = 1
var base_scene_path: String = "res://scenes/levels/"
	
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
	if event.is_action_pressed("player_switch") and not is_main_menu_active:
		temp_state = !hero_knight.active
		hero_rogue.active = hero_knight.active
		hero_knight.active = temp_state
		
	if not is_main_menu_active: 
		if hero_knight.camera.is_current():
			hero_knight.camera.clear_current(true)
		elif hero_rogue.camera.is_current():
			hero_rogue.camera.clear_current(true)
			
	if Input.is_action_just_pressed("use_blue_potion") and CoinCollector.blue_potion_count > 0:
			CoinCollector.blue_potion_count -=1
			potion_sound()
			if hero_knight.active:
				hero_knight.SPEED += 5.0
				await get_tree().create_timer(15).timeout
				hero_knight.SPEED -= 5.0
			else:
				hero_rogue.SPEED += 5.0
				await get_tree().create_timer(20).timeout
				hero_rogue.SPEED -= 5.0
	if Input.is_action_just_pressed("use_green_potion") and CoinCollector.green_potion_count > 0:
			CoinCollector.green_potion_count -=1
			potion_sound()
			if hero_knight.active:
				hero_knight.activate_shield()
			else:
				hero_rogue.activate_shield()
			green_potion = true
	if Input.is_action_just_pressed("use_red_potion") and CoinCollector.red_potion_count > 0:
			CoinCollector.red_potion_count -=1
			potion_sound()
			if hero_knight.active:
				hero_knight.health_component.gain_health(50.0)
			else:
				hero_rogue.health_component.gain_health(50.0)

func change_level():
		level_number += 1
		if level_number != 6:
			var next_scene_path = base_scene_path + "level0" + str(level_number) + ".tscn"
			get_tree().change_scene_to_file(next_scene_path)
		elif level_number == 6:
			is_main_menu_active = true
			get_tree().change_scene_to_file("res://scenes/ui/end_game.tscn")
	

func potion_sound():
	AudioManager.play_sound(AudioManager.POTION_DRINKING, 0, 1)

func restart_level():
	CoinCollector.restart()
	get_tree().reload_current_scene()
