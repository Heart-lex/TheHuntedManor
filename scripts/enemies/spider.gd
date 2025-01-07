class_name Spider

extends CharacterBody3D

@export var knight: Knight = null
@export var rotation_offset : float
@export var PATROL_DISTANCE : float = 10.0 # Distance in meters to patrol before turning around

@onready var model: Node3D = $Sketchfab_model
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var detection_area: Area3D = $DetectionArea
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox: Area3D = $Hurtbox
var hurtbox_entered : bool = false
var area : Area3D

const SPEED : float = 3.0               # Movement speed
const CHASE_SPEED : float = 8.0 
const TURN_DELAY : float = 0.5          # Pause duration in seconds before turning
const ROTATE_SPEED : float = 1.5

var currState : state

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var patrol_start: Vector3
var patrol_direction: Vector3 = Vector3(0, 0, 1)  # Initial patrol direction
var is_turning: bool = false                     # Prevent movement during turn delay
var is_attacking : bool = false

enum state {ATTACK, DEATH, PATROL, CHASE}

func _ready() -> void:
	currState = state.PATROL
	detection_area.body_entered.connect(_on_body_entered)
	health_component.target_is_dead.connect(on_target_dead)
	patrol_start = global_position
	start_patrol()

func _physics_process(delta: float) -> void:
	if currState != state.DEATH and not is_turning:
		move_and_slide()
	handle_animations(delta)
	
	if not is_on_floor():
		velocity.y -= gravity * delta

func _process(delta: float) -> void:
	match currState:
		state.PATROL:
			handle_patrol(delta)
		state.CHASE:
			if knight:
				chase_target(delta)
	if hurtbox_entered and not is_attacking:
		hurt(area)
		is_attacking = true
		await get_tree().create_timer(0.8).timeout
		is_attacking = false

func start_patrol() -> void:
	patrol_direction = -transform.basis.z.normalized()  # Local forward direction
	currState = state.PATROL
	anim_tree.set("parameters/Movement/transition_request", "Walk")
	velocity = patrol_direction * SPEED

func handle_patrol(delta: float) -> void:
	# Move the spider forward in its patrol direction
	velocity = patrol_direction * SPEED
	# Check if the spider has reached the patrol distance
	if global_position.distance_to(patrol_start) >= PATROL_DISTANCE and not is_turning:
		is_turning = true  # Prevent movement during turning
		velocity = Vector3.ZERO  # Stop the spider
		anim_tree.set("parameters/Movement/transition_request", "Idle")  # Pause animation
		
		turn_back()
		
func turn_back() -> void:
	# Flip patrol direction
	patrol_direction = -patrol_direction  
	var target_rotation = model.rotation.y + PI  # 180-degree turn

	# Use a Tween to smoothly rotate the model
	var tween = get_tree().create_tween()
	tween.tween_property(model, "rotation:y", target_rotation, TURN_DELAY)
	
	# When the rotation is done, resume movement
	tween.finished.connect(func():
		patrol_start = global_position
		velocity = patrol_direction * SPEED
		anim_tree.set("parameters/Movement/transition_request", "Walk")
		is_turning = false
	)
	
func chase_target(delta: float) -> void:
	# Calculate direction to the knight
	var direction = (knight.position - position).normalized()

	# Set velocity toward the knight
	velocity.x = direction.x * CHASE_SPEED
	velocity.z = direction.z * CHASE_SPEED

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Smoothly rotate to face the knight
	var target_rotation = atan2(position.x - knight.position.x, knight.position.z - position.z)
	model.rotation.y = lerp_angle(model.rotation.y, -target_rotation + rotation_offset, ROTATE_SPEED)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("knight"):  
		currState = state.CHASE

func handle_animations(delta: float) -> void:
	match currState:
		state.PATROL:
			anim_tree.set("parameters/Movement/transition_request", "Walk")
		state.CHASE:
			anim_tree.set("parameters/Movement/transition_request", "Walk")
		state.ATTACK:
			anim_tree.set("parameters/Movement/transition_request", "Attack")
		state.DEATH:
			anim_tree.set("parameters/Movement/transition_request", "Death")

func _on_hurtbox_area_entered(area3D: Area3D) -> void:
	hurtbox_entered = true
	area = area3D

func hurt(area : Area3D):
	area.health_component.apply_damage(10)
	AudioManager.play_sound(AudioManager.SPIDER_ATTACK, 0.25, 1)
	await get_tree().create_timer(1).timeout

func on_target_dead() -> void:
	currState = state.DEATH
	hurtbox.monitoring = false
	anim_tree.set("parameters/Movement/transition_request", "Death")
	# Wait for the death animation to complete before fading
	await get_tree().create_timer(1.5).timeout  # Adjust duration to match death animation
	queue_free()

func _on_hurtbox_area_exited(area: Area3D) -> void:
	hurtbox_entered = false
