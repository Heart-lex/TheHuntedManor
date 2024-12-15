extends Area3D

@export var health_component: HealthComponent

func _ready() -> void:
	self.hide()

func start_attack() -> void:
	self.show()

func stop_attack() -> void:
	self.hide()
	
