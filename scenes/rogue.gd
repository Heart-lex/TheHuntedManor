extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0
@export var rotation_speed := 12.0

@onready var camera_pivot: Node3D = %CameraPivot
@onready var camera: Camera3D = %Camera3D
@onready var rig: Node3D = %Rig

var _last_movement_direction := Vector3.BACK
var _camera_input_direction := Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction= event.screen_relative * mouse_sensitivity
		
func _physics_process(delta: float) -> void:
	camera_pivot.rotation.x += _camera_input_direction.y * delta
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI/6.0, PI/3.0)
	camera_pivot.rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
	
	var raw_input := Input.get_vector("move_forward", "move_backwards", "strafe_left", "strafe_right")
	var forward := camera.global_basis.z
	var right := camera.global_basis.x
	
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	move_and_slide()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
		var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
		rig.global_rotation.y = lerp_angle(rig.rotation.y, target_angle, rotation_speed * delta)
