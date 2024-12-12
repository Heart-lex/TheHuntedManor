extends Control

@onready var background_music: AudioStreamPlayer2D = $backgroundMusic
@onready var options_menu: Control = $OptionsMenu
@onready var main: Control = $Main
@onready var start_button: Button = $Main/VBoxContainer/startButton
@onready var options_button: Button = $Main/VBoxContainer/optionsButton
@onready var exit_button: Button = $Main/VBoxContainer/exitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options_menu.visible = false
	handle_connecting_signals()
	background_music.play()
	CoinCollector.visible = false

func _on_start_pressed() -> void:
	background_music.stop()
	get_tree().change_scene_to_file("res://scenes/levels/level01.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
	
func _on_options_pressed() -> void:
	options_menu.visible = true
	options_menu.set_process(true)
	main.visible = false
	
func _on_exit_options_menu() -> void:
	options_menu.visible = false
	main.visible = true
	
func handle_connecting_signals() -> void:
	start_button.button_down.connect(_on_start_pressed)
	options_button.button_down.connect(_on_options_pressed)
	exit_button.button_down.connect(_on_exit_pressed)
	options_menu.exit_options_menu.connect(_on_exit_options_menu)
	
	
