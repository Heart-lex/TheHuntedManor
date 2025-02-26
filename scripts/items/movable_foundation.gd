extends CharacterBody3D

@onready var foundation: Node3D = $Model
@onready var interaction_prompt: CanvasLayer = $InteractionPrompt

const SPEED : float = 0.1
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
const JUMP_VELOCITY: float = -400.0

# None, PositiveX, NegativeX, PositiveZ, NegativeZ
enum Zones { NONE, POS_X, NEG_X, POS_Z, NEG_Z }


var current_zone : Zones

func _ready() -> void:
	
	# Set initial zone to "None"
	current_zone = Zones.NONE
	# Set initial prompt visibility
	interaction_prompt.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and current_zone != Zones.NONE:
		AudioManager.play_sound(AudioManager.PUSH, 0, 1)
		move(current_zone)

func _physics_process(delta: float) -> void:
	
	if not is_on_floor:
		velocity.y -= GRAVITY * delta
	
	move_and_slide()
	
	if velocity.x:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if velocity.z:
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		
# # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Moves based on the zone in which the Knight is at.
#
# Moves towards the according direction of the X/Z axis,
# "away" from the zone that the Knight is touching.
# # # # # # # # # # # # # # # # # # # # # # # # # # # #
func move(zone: Zones) -> void:
	match zone:
		Zones.NONE:
			pass
		Zones.POS_X:
			velocity.x = 7
		Zones.NEG_X:
			velocity.x = -7
		Zones.POS_Z:
			velocity.z = 7
		Zones.NEG_Z:
			velocity.z = -7


# ~~ ZONE SIGNAL FUNCTIONS ~~ #

func _on_zone_positive_x_body_entered(body: Node3D) -> void:
	if body.is_in_group("knight"):
		interaction_prompt.visible = true
		current_zone = Zones.POS_X


func _on_zone_positive_x_body_exited(body: Node3D) -> void:
	if body.is_in_group("knight"):
		interaction_prompt.visible = false
		current_zone = Zones.NONE


func _on_zone_negative_x_body_entered(body: Node3D) -> void:
	if body.is_in_group("knight"):
		interaction_prompt.visible = true
		current_zone = Zones.NEG_X


func _on_zone_negative_x_body_exited(body: Node3D) -> void:
	if body.is_in_group("knight"):
		interaction_prompt.visible = false
		current_zone = Zones.NONE 


func _on_zone_negative_z_body_entered(body: Node3D) -> void:
	if body.is_in_group("knight"):
		interaction_prompt.visible = true
		current_zone = Zones.NEG_Z


func _on_zone_negative_z_body_exited(body: Node3D) -> void:
	if body.is_in_group("knight"):
		interaction_prompt.visible = false
		current_zone = Zones.NONE


func _on_zone_positive_z_body_entered(body: Node3D) -> void:
	if body.is_in_group("knight"):
		interaction_prompt.visible = true
		current_zone = Zones.POS_Z

func _on_zone_positive_z_body_exited(body: Node3D) -> void:
	if body.is_in_group("knight"):
		current_zone = Zones.NONE
		interaction_prompt.visible = false
