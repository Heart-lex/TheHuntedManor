extends Node3D

@onready var background_viewport: SubViewport = $base_camera/background_viewport_container/background_viewport
@onready var foreground_viewport: SubViewport = $base_camera/foreground_viewport_container/foreground_viewport
@onready var background_camera: Camera3D = $base_camera/background_viewport_container/background_viewport/background_camera
@onready var foreground_camera: Camera3D = $base_camera/foreground_viewport_container/foreground_viewport/foreground_camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resize()
	
func resize():
	background_viewport.size = DisplayServer.window_get_size()
	foreground_viewport.size = DisplayServer.window_get_size()
