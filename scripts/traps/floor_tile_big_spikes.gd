extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox: Area3D = $Hurtbox
@onready var timer: Timer = $Timer

enum States {ACTIVE, INACTIVE}

var state : States = States.INACTIVE

var active : bool = false

var bodies : Array = []

func _process(delta: float) -> void:
	if state == States.ACTIVE:
		for body in hurtbox.get_overlapping_bodies():
			if body.is_in_group("knight") and GameManager.green_potion and GameManager.hero_knight.active:
				pass
			elif body.is_in_group("rogue") and GameManager.green_potion and GameManager.hero_rogue.active:
				pass
			else: 
				if body not in bodies:
					body.health_component.apply_damage(20)
					bodies.append(body)
		timer.start()

func activate() -> void:
	state = States.ACTIVE
	AudioManager.play_sound(AudioManager.SPIKE_TRAP, 0, -20)
	hurtbox.monitoring = true
	
func deactivate() -> void:
	state = States.INACTIVE
	hurtbox.monitoring = false

func _on_timer_timeout() -> void:
	bodies.clear()
