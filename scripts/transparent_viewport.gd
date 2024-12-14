extends Camera3D

@onready var background_viewport: SubViewport = $background_container/background_viewport
@onready var foreground_viewport: SubViewport = $foreground_container/foreground_viewport

func _ready() -> void:
	resize()

func resize() -> void:
	background_viewport.size = DisplayServer.window_get_size()
	foreground_viewport.size = DisplayServer.window_get_size()
	
func _process(delta: float) -> void:
	pass
