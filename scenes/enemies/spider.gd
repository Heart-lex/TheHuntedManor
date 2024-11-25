extends CharacterBody3D

const SPEED = 2.0               # Movement speed
const PATROL_DISTANCE = 7.0    # Distance in meters to patrol before turning around
const TURN_DELAY = 1.0          # Pause duration in seconds before turning

@onready var model: Node3D = $Sketchfab_model
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var detection_area: Area3D = $Area3D
@onready var health_component: HealthComponent = $HealthComponent

var patrol_start: Vector3
var patrol_direction: Vector3 = Vector3(0, 0, 1)  # Initial patrol direction
var currState
var knight: Node3D = null
var is_turning: bool = false                     # Prevent movement during turn delay

enum state {ATTACK, DEATH, PATROL, CHASE}

func _ready() -> void:
	currState = state.PATROL
	patrol_start = global_position
	start_patrol()

func _physics_process(delta: float) -> void:
	if currState != state.DEATH and not is_turning:
		move_and_slide()
	handle_animations(delta)

func _process(delta: float) -> void:
	match currState:
		state.PATROL:
			handle_patrol(delta)
		state.CHASE:
			if knight:
				chase_target(delta)

func start_patrol() -> void:
	patrol_direction = Vector3(0, 0, 1)  # Reset patrol direction to forward
	currState = state.PATROL
	anim_tree.set("parameters/Movement/transition_request", "Walk")
	velocity = patrol_direction * SPEED

func handle_patrol(delta: float) -> void:
	if global_position.distance_to(patrol_start) >= PATROL_DISTANCE and not is_turning:
		# Stop movement and start the turn-around delay
		is_turning = true
		velocity = Vector3.ZERO  # Stop the spider
		anim_tree.set("parameters/Movement/transition_request", "Idle")  # Pause animation

		# Start a timer to handle the turn-back
		var timer = Timer.new()
		timer.wait_time = TURN_DELAY
		timer.one_shot = true
		timer.timeout.connect(turn_back)
		add_child(timer)  # Add the timer to the scene
		timer.start()

func turn_back() -> void:
	patrol_direction = -patrol_direction  # Reverse direction
	velocity = patrol_direction * SPEED  # Update velocity for the new direction
	patrol_start = global_position  # Reset patrol start position
	anim_tree.set("parameters/Movement/transition_request", "Walk")  # Resume walking animation
	is_turning = false  # Allow movement again

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
