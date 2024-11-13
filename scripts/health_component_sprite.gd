extends Sprite3D

@export var health_component: HealthComponent:
	set(value):
		health_component = value
		$SubViewport/HealthbarDisplay.health_component = value
