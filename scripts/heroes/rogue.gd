class_name Rogue

extends CharacterBody3D

@export var camera : CameraRig
@export var camera_offset : float = 0

@onready var pivot: Node3D = $CameraPoint

@onready var model: Node3D = $Rig
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox: Area3D = $Hitbox

@onready var active 
@onready var shield: MeshInstance3D = $MeshInstance3D

var was_on_floor: bool = true  # Tracks if the character was on the floor

var currState
var is_dead: bool = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_running_sound_playing: bool = false 

var SPEED: float = 5.0
const JUMP_VELOCITY: float = 6.5
const ROTATION_SPEED: float = 12.0

enum state {RUN, JUMP, IDLE, LANDING}

func activate_shield() -> void:
	shield.visible = true
	hitbox.monitorable = false
	start_timer()

func _ready() -> void:
	health_component.target_is_dead.connect(character_death)

func _physics_process(delta: float) -> void:
	
	if not is_dead:
		move_and_slide()
		handle_animations(delta)
	
	if health_component.health == 0:
		is_dead = true

	if not is_on_floor():
		velocity.y -= gravity * delta

	if is_on_floor() and not was_on_floor:
		land()
	if active:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump()
			
		var input_dir := Input.get_vector("strafe_left", "strafe_right","move_forward","move_backwards")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		# rotate by camera pivot's rotation so that the movement always stays "upright"
		# regardless of node's rotation (e.g. can be placed on a level and rotated and "up" is always camera's up
		direction = direction.rotated(Vector3.UP, pivot.rotation.y)
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			currState = state.RUN
			if is_on_floor():
				run()
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			currState = state.IDLE

		if velocity.length() > 1.0:
			var direction_angle = atan2(direction.x, direction.z)
			model.rotation.y = lerp_angle(model.rotation.y, direction_angle + camera_offset, ROTATION_SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		currState = state.IDLE
		
	was_on_floor = is_on_floor()
		
func handle_animations(delta: float) -> void:
	if active:
		match currState:
			state.IDLE:
				anim_tree.set("parameters/Movement/transition_request", "Idle")
			state.RUN: 
				anim_tree.set("parameters/Movement/transition_request","RJ")
			state.JUMP:
				jump()
	else:
		anim_tree.set("parameters/Movement/transition_request", "Idle")
		
func jump():
	anim_tree.set("parameters/Jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	AudioManager.play_sound(AudioManager.JUMP, 0.25, 1)
	was_on_floor = false
	
func land():
	AudioManager.play_sound(AudioManager.LANDING, 0.25, 5)
	
func run():
	if not is_running_sound_playing:
		is_running_sound_playing = true
		AudioManager.play_sound(AudioManager.WALKING, 0.25, 10)
		await get_tree().create_timer(0.5).timeout
		is_running_sound_playing = false
	
func character_death() -> void:
	AudioManager.play_sound(AudioManager.GAME_OVER, 0.25, 1)
	hitbox.monitorable = false
	GameManager.character_dead = true
	is_dead = true
	anim_tree.set("parameters/Movement/transition_request", "Death")
	start_timer()
	
func start_timer(): 
	var timer = Timer.new()
	add_child(timer)
	if is_dead:
		timer.wait_time = 3
	else: 
		timer.wait_time = 15
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	
func _on_timer_timeout():
	if is_dead:
		GameManager.restart_level()
	else:
		GameManager.green_potion = false
		shield.visible = false
		hitbox.monitorable = true
