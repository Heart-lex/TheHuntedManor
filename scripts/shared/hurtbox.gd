extends Area3D

@export var always_enabled = self.monitoring

func _ready() -> void:
	self.monitoring = always_enabled

func start_attack() -> void:
	self.monitoring = true
	print("ATTACK!")

func stop_attack() -> void:
	self.monitoring = false
	print("Stopped attacking...")

	
