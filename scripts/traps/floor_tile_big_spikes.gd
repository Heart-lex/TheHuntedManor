extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox: Area3D = $Hurtbox

enum States {ACTIVE, INACTIVE}

var state : States = States.INACTIVE

func activate() -> void:
	state = States.ACTIVE
	
func deactivate() -> void:
	state = States.INACTIVE

func _on_hurtbox_body_entered(body: Node3D) -> void:
	if state == States.ACTIVE:
		body.health_component.apply_damage(20)

	
		
