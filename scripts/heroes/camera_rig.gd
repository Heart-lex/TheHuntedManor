class_name CameraRig

extends Camera3D

@onready var background_viewport: SubViewport = $background_viewport_container/background_viewport
@onready var foreground_viewport: SubViewport = $foreground_viewport_container/foreground_viewport
@onready var background_camera: Camera3D = $background_viewport_container/background_viewport/background_camera
@onready var foreground_camera: Camera3D = $foreground_viewport_container/foreground_viewport/foreground_camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resize()
	
func resize():
	background_viewport.size = DisplayServer.window_get_size()
	foreground_viewport.size = DisplayServer.window_get_size()

func _process(delta: float) -> void:
	if GameManager.hero_knight.active == true:
		background_camera.global_transform = GameManager.hero_knight.pivot.global_transform
		foreground_camera.global_transform = GameManager.hero_knight.pivot.global_transform
	elif GameManager.hero_rogue.active == true:
		background_camera.global_transform = GameManager.hero_rogue.pivot.global_transform
		foreground_camera.global_transform = GameManager.hero_rogue.pivot.global_transform
		
