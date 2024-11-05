class_name FlyingBat

extends CharacterBody3D

@onready var model: Node3D = $Armature
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var hitbox: CollisionShape3D = $CharacterBody3D/Hitbox
@onready var detection_area: Area3D = $DetectionArea

var currState
var knight: Node3D =  null

const SPEED: float = 3.0
const ROTATION_SPEED: float = 3.0

enum state {SIT, WINGS, FLY, HANG}

func _ready() -> void:
	currState = state.HANG
	detection_area.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	move_and_slide()
	handle_animations(delta)
	
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("soldier"):  
		knight = body  
	currState = state.SIT
	currState = state.WINGS
	currState = state.FLY
	
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
