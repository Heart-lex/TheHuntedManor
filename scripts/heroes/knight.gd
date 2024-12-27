class_name Knight

extends CharacterBody3D

@export var camera: CameraRig
@onready var pivot: Node3D = $CameraPoint

@onready var model: Node3D = $Rig
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var health_component: HealthComponent = $HealthComponent
@onready var shield: MeshInstance3D = $MeshInstance3D
@onready var hitbox: Area3D = $Hitbox
@onready var hurtbox: Area3D = $Rig/Hurtbox

@onready var active 


var is_attacking : bool = false
var is_dead: bool = false

var currState = State.IDLE
var attackType = AttackType.NONE
var look_rotation : float
var is_running_sound_playing: bool = false 
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var was_on_floor: bool = true

var attack_cooldown : float

var SPEED: float = 5.0

const JUMP_VELOCITY: float = 4.5
const ROTATION_SPEED: float = 12.0
const RAY_LENGTH = 2000.0

enum State { IDLE, WALK, RUN, JUMP, LIGHT_ATTACK, HEAVY_ATTACK, BLOCK, DIE }

enum AttackType { NONE, LIGHT_ATK, HEAVY_ATK, AERIAL_LIGHT_ATK, AERIAL_HEAVY_ATK }

func _ready() -> void:
	is_dead = false
	health_component.target_is_dead.connect(character_death)

func activate_shield() -> void:
	shield.visible = true
	hitbox.monitorable = false
	start_timer()
	
# MOUSE-BASED CHARACTER ROTATION
func _input(event):
	if event is InputEventMouseMotion:
		# Get center of screen
		var screen_size := Vector2(get_viewport().get_visible_rect().size.x / 2, get_viewport().get_visible_rect().size.y / 2)
		# Calculate where the mouse is relative to the center of the screen and offset it by 90 degrees
		look_rotation = atan2(event.position.x - screen_size.x, event.position.y - screen_size.y) + PI / 2
		
func _physics_process(delta: float) -> void:
	
	if health_component.health == 0:
		currState = State.DIE
		is_dead = true
	
	if not is_dead:
		move_and_slide()
		handle_animations(delta)
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if is_on_floor() and not was_on_floor:
		land()
	
	if active and not is_dead:
		
		model.rotation.y = look_rotation
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump()
		
		if not is_attacking:
			if Input.is_action_just_pressed("light_attack") or Input.is_action_just_pressed("heavy_attack"):
				
				is_attacking = true
				
				if Input.is_action_just_pressed("light_attack"):
					currState = State.LIGHT_ATTACK
					if is_on_floor():
						attackType = AttackType.LIGHT_ATK
					else:
						attackType = AttackType.AERIAL_LIGHT_ATK
					light_attack()
				
				elif Input.is_action_just_pressed("heavy_attack"):
					currState = State.HEAVY_ATTACK
					if is_on_floor():
						attackType = AttackType.HEAVY_ATK
					else:
						attackType = AttackType.AERIAL_HEAVY_ATK
					heavy_attack()
		
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
			currState = State.RUN
			if is_on_floor():
				run()
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			currState = State.IDLE
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		currState = State.IDLE
		
	was_on_floor = is_on_floor()

func handle_animations(delta: float) -> void:
	if active:
		match currState:
			State.IDLE:
				anim_tree.set("parameters/Movement/transition_request", "Idle")
			State.WALK:
				anim_tree.set("parameters/Movement/transition_request", "Walk")
			State.RUN: 
				anim_tree.set("parameters/Movement/transition_request","Run")
				anim_tree.set("parameters/Running Animation/blend_position", Vector2(-velocity.z, -velocity.x).normalized())
				run()
				await  get_tree().create_timer(2).timeout
			State.JUMP:
				jump()
			State.LIGHT_ATTACK:
				pass
			State.HEAVY_ATTACK:
				pass
	else:
		anim_tree.set("parameters/Movement/transition_request", "Idle")

func run():
	if not is_running_sound_playing:
		is_running_sound_playing = true
		AudioManager.play_sound(AudioManager.WALKING, 0.25, 10, 0.3)
		await get_tree().create_timer(0.5).timeout
		is_running_sound_playing = false
		
func land():
	AudioManager.play_sound(AudioManager.LANDING, 0.25, 5)

func jump():
	anim_tree.set("parameters/Jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	AudioManager.play_sound(AudioManager.JUMP, 0.25, 1)
	was_on_floor = false
	
func light_attack():
	anim_tree.set("parameters/LightAttack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	AudioManager.play_sound(AudioManager.LIGHT_ATTACK, 0, 0.8, 0.55)
	match attackType:
		AttackType.LIGHT_ATK:
			attack_cooldown = 0.6
		AttackType.AERIAL_LIGHT_ATK:
			velocity.y = 4.0
			attack_cooldown = 1.0
	
	is_attacking = true
	await get_tree().create_timer(attack_cooldown).timeout
	is_attacking = false
	
func heavy_attack():
	anim_tree.set("parameters/HeavyAttack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	AudioManager.play_sound(AudioManager.HEAVY_ATTACK, 0.25, 1, 0.6)
	match attackType:
		AttackType.HEAVY_ATK:
			attack_cooldown = 1.2
		AttackType.AERIAL_HEAVY_ATK:
			velocity.y = -4.0
			attack_cooldown = 1.4
			
	is_attacking = true
	await get_tree().create_timer(attack_cooldown).timeout
	is_attacking = false

func character_death():
	AudioManager.play_sound(AudioManager.GAME_OVER, 0.25, 1)
	hitbox.monitorable = false
	hurtbox.monitorable = false
	GameManager.character_dead = true
	is_dead = true
	anim_tree.set("parameters/Movement/transition_request", "Die")
	start_timer()

func calc_damage() -> int:
	var damage : int
	
	match attackType:
		AttackType.NONE:
			damage = 0
		AttackType.LIGHT_ATK:
			damage = 8
		AttackType.AERIAL_LIGHT_ATK:
			damage = 12
		AttackType.HEAVY_ATK:
			damage = 18
		AttackType.AERIAL_HEAVY_ATK:
			damage = 25
	return damage
		
func _on_hurtbox_area_entered(area: Area3D) -> void:
	area.health_component.apply_damage(calc_damage())
	
func start_timer(): 
	var timer = Timer.new()
	add_child(timer)
	if is_dead:
		timer.wait_time = 1
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
		
