extends Control

signal exit_options_menu

@onready var exit_button: Button = $VBoxContainer/exitButton

func _ready() -> void:
	exit_button.button_down.connect(_on_exit_pressed)
	set_process(false)

func _on_exit_pressed() -> void:
	exit_options_menu.emit()
	set_process(false)
