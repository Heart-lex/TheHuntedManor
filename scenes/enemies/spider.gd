class_name spider

extends CharacterBody3D

const SPEED = 5.0
const PATROL_DISTANCE = 5.0  
const TURN_DELAY = 0.5       
const JUMP_VELOCITY = 4.5

@onready var model: Node3D = $Sketchfab_model
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var detection_area: Area3D = $Area3D
@onready var health_component: Sprite3D = $HealthbarPosition/HealthComponent

var patrol_start: Vector3
var patrol_direction: Vector3 = Vector3(1, 0, 0)  # Default direction for patrol
var patrol_timer: Timer

var currState
var knight: Node3D =  null

enum state {ATTACK, DEATH, PATROL, CHASE}

func _ready() -> void:
	currState = state.PATROL
	patrol_start = global_position
	patrol_timer = Timer.new()
	add_child(patrol_timer)
	detection_area.body_entered.connect(_on_body_entered)
	health_component.health_component.target_is_dead.connect(on_target_dead)
	
	# Start the patrol
	start_patrol()

func _physics_process(delta: float) -> void:
	if currState != state.DEATH:
		move_and_slide()
	handle_animations(delta)
	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match currState:
		state.PATROL:
			handle_patrol(delta)
		state.CHASE:
			if knight:
				chase_target(delta)

func start_patrol() -> void:
	currState = state.PATROL
	anim_tree.set("parameters/Movement/transition_request", "Walk")
	patrol_direction = Vector3(1, 0, 0)  # Start moving forward

func handle_patrol(delta: float) -> void:
	# Move the spider in the patrol direction
	velocity = patrol_direction * SPEED
	move_and_slide()
	
	# Check distance from patrol start
	if global_position.distance_to(patrol_start) >= PATROL_DISTANCE:
		currState = state.PATROL  # Temporarily pause movement
		patrol_timer.wait_time = TURN_DELAY
		patrol_timer.one_shot = true
		patrol_timer.start()
		patrol_timer.timeout.connect(turn_back)

func turn_back() -> void:
	# Turn back by reversing the patrol direction
	if patrol_direction == Vector3(1,0,0):
		patrol_direction = Vector3(-1,0,0)
	else: 
		patrol_direction = Vector3(1,0,0)
# Target chase
func chase_target(delta: float) -> void:
	var direction = (knight.global_position - global_position).normalized()  # Calculate the distance to the target
	global_position += direction * SPEED * delta  # Move towards the target
	model.look_at(Vector3(knight.position.x, position.y, knight.position.z), Vector3(0, 1, 0), true)
	
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("soldier"):  
		knight = body
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

func _on_hurtbox_area_entered(area: Area3D) -> void:
	area.health_component.apply_damage(6)
	
func on_target_dead() -> void:
	currState = state.DEATH
	$AnimationTree.set("parameters/Movement/transition_request", "Death")
	# Wait for the death animation to complete before fading
	await get_tree().create_timer(1.5).timeout  # Adjust duration to match death animation
	start_fade_out()

func start_fade_out() -> void:
	# Begin reducing the alpha value of the model's modulate property
	var fade_time = 2.0  # Duration of fade-out in seconds
	var fade_step = 1.0 / (fade_time * 60.0)  # Assuming 60 FPS
	var alpha = 1.0

	while alpha > 0:
		alpha -= fade_step
		model.modulate.a = alpha  # Gradually reduce alpha
		await get_tree().create_timer(1.0 / 60.0).timeout  # Wait for the next frame

	# Once fully faded, remove the spider
	queue_free()
