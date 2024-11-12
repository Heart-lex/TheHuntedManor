extends Control

@onready var health_component: HealthComponent
@onready var hurtbar: ProgressBar = $Hurtbar
@onready var healthbar: ProgressBar = $Healthbar

func _ready() -> void:
	healthbar.max_value = health_component.max_health
	healthbar.value = health_component.health
	
	hurtbar.max_value = health_component.max_health
	hurtbar.value = health_component.health
	
func _process(delta: float) -> void:
	display_damage()
	
func display_damage() -> void:
	if healthbar.value != health_component.health:
		healthbar.value = health_component.health
		
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(hurtbar, "value", healthbar.value, 0.3)
	
