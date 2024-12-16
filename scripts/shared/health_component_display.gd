class_name HealthComponent
extends Node

signal target_is_dead

@export var max_health: float = 100
@export var health: float = max_health

func apply_damage(damage: float) -> void:
	health = clamp(health - damage, 0, max_health)
	if health <= 0:
		target_is_dead.emit()
		
func gain_health(gained_health: float) -> void:
		health = clamp(health + gained_health, 0, max_health)
