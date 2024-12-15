class_name Knight

extends CharacterBody3D

@export var camera: CameraRig
@onready var pivot: Node3D = $CameraPoint

@onready var model: Node3D = $Rig
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var aim_direction: Marker3D = $AimDirection
@onready var health_component: HealthComponent = $HealthComponent

@onready var active 

var is_attacking : bool = false

var currState = state.IDLE
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_look_direction: Vector3 = Vector3.ZERO
var rayOrigin: Vector3
var rayEnd: Vector3

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5
const ROTATION_SPEED: float = 12.0
const RAY_LENGTH = 1000.0

enum state {IDLE, WALK, RUN, JUMP, LIGHT_ATTACK, HEAVY_ATTACK, BLOCK, DIE}

func _ready() -> void:
	health_component.target_is_dead.connect(character_death)

# MOUSE-CONTROLLED ROTATION
func _input(event):
	if event is InputEventMouseMotion:
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * RAY_LENGTH
		mouse_look_direction = to

func _physics_process(delta: float) -> void:
	
	move_and_slide()
	handle_animations(delta)
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if active: 
		var space_state := get_world_3d().direct_space_state
		
		var mouse_pos := get_viewport().get_mouse_position()
		
		rayOrigin = camera.project_ray_origin(mouse_pos)
		
		rayEnd = rayOrigin + camera.project_ray_normal(mouse_pos) * RAY_LENGTH
		
		var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd);
		
		# Get the intersection point of the camera's ray and the world
		var intersection = space_state.intersect_ray(query)
		
		# If the ray collides with something
		if not intersection.is_empty():
			var pos = intersection.position
			
			# position.y refers to this node's instance and is used so that
			# the model "looks" ahead in a straight line instead of at an angle
			# (which would happen since the intersection doesn't necessarily happen at character-height)
			model.look_at(Vector3(pos.x, position.y, pos.z), Vector3(0, 1, 0))
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump()
		
		if Input.is_action_just_pressed("light_attack") and not is_attacking:
			currState = state.LIGHT_ATTACK
			light_attack()
			
		if Input.is_action_just_pressed("heavy_attack") and not is_attacking:
			currState = state.HEAVY_ATTACK
		
		# Get input vector
		var input_dir := Input.get_vector("strafe_left", "strafe_right","move_forward","move_backwards")
		
		# Calculate character's direction based on vector
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		# rotate by camera pivot's rotation so that the movement always stays "upright"
		# regardless of node's rotation (e.g. can be placed on a level and rotated and "up" is always camera's up
		direction = direction.rotated(Vector3.UP, pivot.rotation.y)
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			currState = state.RUN
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			currState = state.IDLE
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		currState = state.IDLE

func handle_animations(delta: float) -> void:
	if active:
		match currState:
			state.IDLE:
				anim_tree.set("parameters/Movement/transition_request", "Idle")
			state.WALK:
				anim_tree.set("parameters/Movement/transition_request", "Walk")
			state.RUN: 
				anim_tree.set("parameters/Movement/transition_request","Run")
				anim_tree.set("parameters/Running Animation/blend_position", Vector2(-velocity.z, -velocity.x).normalized())
			state.JUMP:
				anim_tree.set("parameters/Movement/transition_request","Jump")
			state.LIGHT_ATTACK:
				pass
			state.HEAVY_ATTACK:
				pass
			state.DIE:
				anim_tree.set("parameters/Death/transition_request", "Die")
	else:
		anim_tree.set("parameters/Movement/transition_request", "Idle")
		
func jump():
	anim_tree.set("parameters/Jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
func light_attack():
	anim_tree.set("parameters/LightAttack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func character_death() -> void:
	pass

func _on_hurtbox_area_entered(area: Area3D) -> void:
	area.health_component.apply_damage(10)
