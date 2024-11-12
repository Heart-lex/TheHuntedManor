extends Control

@onready var exit_button: Button = $exitButton
@onready var volume: HSlider = $MarginContainer/VBoxContainer/Volume

signal exit_options_menu


func _ready() -> void:
	exit_button.button_down.connect(_on_exit_pressed)
	set_process(false)
	
	# Set initial volume to maximum
	AudioServer.set_bus_volume_db(0, 0)  # 0 dB is typically the max volume

	# Set the slider to match the initial volume
	volume.max_value = 0   # Assuming the maximum volume is 0 dB
	volume.min_value = -30 # Assuming -80 dB is the lowest volume (you can adjust this)
	volume.value = 0       # Initial volume at -20 dB (slightly above the middle)


func _on_exit_pressed() -> void:
	exit_options_menu.emit()
	set_process(false)


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value)


func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)

func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))
