class_name FlyingBat

extends CharacterBody3D

@onready var model: Node3D = $Armature
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var detection_area: Area3D = $DetectionArea
@onready var health_component: HealthComponent = $HealthComponent
@onready var healthbar_position: Node3D = $HealthbarPosition
@onready var hurtbox: Area3D = $Armature/Hurtbox

var currState
var knight: Node3D =  null

const SPEED: float = 3.0
const ROTATION_SPEED: float = 3.0

enum state {SIT, WINGS, FLY, HANG, DEATH}

func _ready() -> void:
	currState = state.HANG
	detection_area.body_entered.connect(_on_body_entered)
	health_component.target_is_dead.connect(on_target_dead)

func _physics_process(delta: float) -> void:
	move_and_slide()
	handle_animations(delta)
	
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("knight"):  
		knight = body
		currState = state.SIT
		currState = state.WINGS
		currState = state.FLY
		healthbar_position.show()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if knight:
		chase_target(delta)

# Target chase
func chase_target(delta: float) -> void:
	var direction = (knight.global_position - global_position).normalized()  # Calculate the distance to the target
	global_position += direction * SPEED * delta  # Move towards the target
	model.look_at(Vector3(knight.position.x, position.y, knight.position.z), Vector3(0, 1, 0), true)
	

func handle_animations(delta: float) -> void:
	match currState:
		state.SIT:
			anim_tree.set("parameters/Movement/transition_request", "Sit")
		state.HANG: 
			anim_tree.set("parameters/Movement/transition_request","Hang")
		state.WINGS:
			anim_tree.set("parameters/Movement/transition_request","Wings")
		state.FLY:
			anim_tree.set("parameters/Movement/transition_request","Fly")
		state.DEATH:
			# We use this in place of a death animation
			anim_tree.set("parameters/Movement/transition_request","Hang") 

func _on_hurtbox_area_entered(area: Area3D) -> void:
	area.health_component.apply_damage(8)
	
func on_target_dead() -> void:
	currState = state.DEATH
	hurtbox.monitoring = false
	# Wait for the death animation to complete before fading
	await get_tree().create_timer(0.3).timeout  # Adjust duration to match death animation
	queue_free()
