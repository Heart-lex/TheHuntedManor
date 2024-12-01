extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Το state machine
var current_state: String = "Idle"

func _ready() -> void:
	play_animation("Idle")

# Κάθε frame ελέγχει το state και αναπαράγει το animation αν χρειάζεται
func _process(delta: float) -> void:
	match current_state:
		"Idle":
			if not animation_player.is_playing():
				play_animation("Idle")

# Παίζει το animation με το όνομα που δίνεις
func play_animation(animation_name: String) -> void:
	if animation_player.current_animation != animation_name:
		animation_player.play(animation_name)
