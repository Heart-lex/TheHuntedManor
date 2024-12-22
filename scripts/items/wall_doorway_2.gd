class_name Door

extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var detection_area: Area3D = $wall_doorway/DetectionArea
@onready var interaction_prompt: CanvasLayer = $InteractionPrompt

@export var lever : Lever = null
@export var exitlever : ExitLever = null

var active: bool = false

func _ready() -> void:
	interaction_prompt.visible = false
	animation_player.play("closed")

func open() -> void:
	animation_player.play("open")
	AudioManager.play_sound(AudioManager.DOOR_OPENING, 0.25, 1)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("use_key") and active:
		AudioManager.play_sound(AudioManager.KEY_UNLOCKING, 0, 1)
		active = false
		CoinCollector.door_key_count -= 1
		await  get_tree().create_timer(2).timeout
		AudioManager.play_sound(AudioManager.DOOR_OPENING, 0.25, 1)
		self.open()
		
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("knight") and (CoinCollector.door_key_count > 0) and (lever == null and exitlever == null):
		active = true
		interaction_prompt.label.text = "Press 1 to use the door key"
		interaction_prompt.visible = true
	else:
		active = false
		interaction_prompt.visible = false
	
func _on_body_exited(body: Node3D) -> void:
	active = false
	interaction_prompt.visible = false
