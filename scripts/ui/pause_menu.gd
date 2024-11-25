extends Control

@onready var volume: HSlider = $Menu/VBoxContainer/Volume
@onready var menu: Control = $"."


func _ready() -> void:
	$AnimationPlayer.play("RESET")
	
	# Set initial volume to maximum
	AudioServer.set_bus_volume_db(0, 0)  # 0 dB is typically the max volume

	# Set the slider to match the initial volume
	volume.max_value = 0   # Assuming the maximum volume is 0 dB
	volume.min_value = -30 # Assuming -80 dB is the lowest volume (you can adjust this)
	volume.value = 0       # Initial volume at -20 dB (slightly above the middle)
	
	menu.visible = false
	menu.mouse_filter = Control.MOUSE_FILTER_IGNORE

func resume():
	get_tree().paused = false
	menu.visible = false
	menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	get_tree().paused = true
	menu.visible = true
	menu.mouse_filter = Control.MOUSE_FILTER_PASS
	$AnimationPlayer.play("blur")
	
func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_main_menu_pressed() -> void:
	get_tree().quit()

func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()
	
func _process(delta: float) -> void:
	testEsc()


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value)

func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))


func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)
