extends Node3D

@onready var anim_tree: AnimationTree = $AnimationTree
var currState
var knight: Node3D =  null

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5
const ROTATION_SPEED: float = 12.0

enum state {SIT, WINGS, FLY, HANG}

func _ready() -> void:
	currState = state.HANG
	self.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
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

# Κωδικός για την κίνηση προς τον στόχο
func chase_target(delta: float) -> void:
	var direction = (knight.global_position - global_position).normalized()  # Υπολογίστε τη διεύθυνση προς τον στόχο
	var speed = 5.0  # Ορίστε την ταχύτητα κίνησης
	global_position += direction * speed * delta  # Κίνηση προς τον στόχο


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
