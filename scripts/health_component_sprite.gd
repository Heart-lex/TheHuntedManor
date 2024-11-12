extends Sprite3D

@export var health_component: HealthComponent:
	set(value):
		health_component = value
		healthbar_display.health_component = value

@onready var healthbar_display: Control = $SubViewport/HealthbarDisplay
