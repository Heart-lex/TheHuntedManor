extends Control

@onready var background_music: AudioStreamPlayer2D = $backgroundMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_music.play()

func _on_start_pressed() -> void:
	background_music.stop()
	get_tree().change_scene_to_file("res://scenes/levels/level01.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
