extends Area3D

# Exported variable to allow for enemies that always
# damage you on contact, defaults to false
@export var always_enabled = self.monitoring

func _ready() -> void:
	self.monitoring = always_enabled

func start_attack() -> void:
	self.monitoring = true

func stop_attack() -> void:
	self.monitoring = false

	
