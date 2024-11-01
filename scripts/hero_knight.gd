extends CharacterBody3D
class_name HeroKnight

@export var SPEED: float = 8.0
@export var ACCELERATION: float = 7.0
@export var JUMP_VELOCITY: float = 3.5
@export var ROTATION_SPEED: float = 12.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumping: bool = false
var last_floor: bool = true
var attacks := [
	"1H_Melee_Attack_Slice_Diagonal",
	"1H_Melee_Attack_Slice_Horizontal",
	"1H_Melee_Attack_Chop"
]

@onready var model: Node3D = $Rig
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var anim_state: Variant = anim_tree.get("parameters/playback")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	get_move_input(delta)

	move_and_slide()
	
	if velocity.length() > 1.0:
		var direction_angle = -atan2((model.position.x - velocity.normalized().x), -(model.position.z - velocity.normalized().z))
		model.rotation.y = lerp_angle(model.rotation.y, direction_angle, ROTATION_SPEED * delta)
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		jumping = true
		anim_tree.set("parameters/conditions/jumping", true)
		anim_tree.set("parameters/conditions/grounded", false)
		
	if is_on_floor() and not last_floor:
		jumping = false
		anim_tree.set("parameters/conditions/jumping", false)
		anim_tree.set("parameters/conditions/grounded", true)
	if not is_on_floor() and not jumping:
		anim_state.travel("Jump_Idle")
		anim_tree.set("parameters/conditions/grounded", false)
	last_floor = is_on_floor()

func get_move_input(delta: float) -> void:
	var vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_backwards")
	var direction = Vector3(-input.x, 0, -input.y)
	velocity = lerp(velocity, direction * SPEED, ACCELERATION * delta)
	var vl = velocity * model.transform.basis
	anim_tree.set("parameters/IdleWalkRun/blend_position", Vector2(vl.x, -vl.z) / SPEED)
	velocity.y = vy

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("light_attack"):
		anim_state.travel(attacks.pick_random())
