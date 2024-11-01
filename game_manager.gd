extends Node

@onready var rogue: CharacterBody3D = $"."

@export var soldier_character: CharacterBody3D  # Soldier (Knight) character
@export var rogue_character: CharacterBody3D    # Rogue (Player 2) character

# Variable to track the currently active character
var active_character: CharacterBody3D = null

func _ready():
	# Start with the Soldier as the active character
	active_character = soldier_character
	set_active_character(active_character)

func _process(delta):
	# Switch to Rogue (Player 2) when "2" is pressed
	if Input.is_action_just_pressed("switch_to_rogue"):
		set_active_character(rogue_character)

func set_active_character(character: CharacterBody3D):
	# Deactivate the current active character's physics process
	if active_character:
		active_character.set_physics_process(false)
	
	# Activate the selected character and make it the new active character
	active_character = character
	active_character.set_physics_process(true)
