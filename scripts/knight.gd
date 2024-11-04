class_name Knight

extends CharacterBody3D

@onready var model: Node3D = $Rig
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var pivot: Node3D = $CameraPivot
@onready var aim_direction: Marker3D = $AimDirection
@onready var camera: Camera3D = $CameraPivot/IsometricCamera

var currState = state.IDLE
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_look_direction: Vector3 = Vector3.ZERO

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5
const ROTATION_SPEED: float = 12.0
const RAY_LENGTH = 1000.0

enum state {IDLE, WALK, RUN, JUMP, ATTACK, BLOCK}

# MOUSE-CONTROLLED ROTATION
#func _input(event):
	#if event is InputEventMouseMotion:
		#var from = camera.project_ray_origin(event.position)
		#var to = from + camera.project_ray_normal(event.position) * RAY_LENGTH
		#mouse_look_direction = to

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump()
		
	var input_dir = Input.get_vector("strafe_left", "strafe_right","move_forward","move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		currState = state.RUN
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		currState = state.IDLE
		
	move_and_slide()
	handle_animations(delta)

	# MOUSE-CONTROLLED ROTATION
	# model.rotation.y = lerp_angle(model.rotation.y,  aim_direction.position.angle_to(mouse_look_direction), ROTATION_SPEED * delta)

	
	if velocity.length() > 1.0:
		var direction_angle = atan2((model.position.x - velocity.normalized().x), (model.position.z - velocity.normalized().z))
		model.rotation.y = lerp_angle(model.rotation.y,  direction_angle, ROTATION_SPEED * delta)

func handle_animations(delta: float) -> void:
	match currState:
		state.IDLE:
			anim_tree.set("parameters/Movement/transition_request", "Idle")
		state.WALK:
			anim_tree.set("parameters/Movement/transition_request", "Walk")			
		state.RUN: 
			anim_tree.set("parameters/Movement/transition_request","Run")
		state.JUMP:
			anim_tree.set("parameters/Movement/transition_request","Jump")
		
func jump():
	anim_tree.set("parameters/Jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
