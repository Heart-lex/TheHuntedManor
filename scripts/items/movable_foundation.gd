extends CharacterBody3D

@onready var foundation: Node3D = $Model

# None, PositiveX, NegativeX, PositiveZ, NegativeZ
enum Zones { NONE, POS_X, NEG_X, POS_Z, NEG_Z }

# Set initial zone to "None"
var current_zone : Zones = Zones.NONE

func _process(delta: float) -> void:
	
	move_and_slide()
	
	if Input.is_action_just_pressed("interact") and current_zone != Zones.NONE:
		print("Currently at: " + Zones.keys()[current_zone]) # debug
		move(current_zone)

# # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Moves based on the zone in which the Knight is at.
#
# Moves towards the according direction of the X/Y axis,
# "away" from the zone that the Knight is touching.
# # # # # # # # # # # # # # # # # # # # # # # # # # # #
func move(zone: Zones) -> void:
	match zone:
		Zones.NONE:
			pass
		Zones.POS_X:
			velocity.x += 1
		Zones.NEG_X:
			velocity.x -= 1
		Zones.POS_Z:
			velocity.z += 1
		Zones.NEG_Z:
			velocity.z -= 1
		
		# I used the following when it was a simple Node3D:
		#Zones.POS_X:
			#foundation.position.x += 1
		#Zones.NEG_X:
			#foundation.position.x -= 1
		#Zones.POS_Z:
			#foundation.position.z += 1
		#Zones.NEG_Z:
			#foundation.position.z -= 1

# ~~ ZONE SIGNAL FUNCTIONS ~~ #

func _on_zone_positive_x_body_entered(body: Node3D) -> void:
	if body.is_in_group("soldier"):
		current_zone = Zones.POS_X


func _on_zone_positive_x_body_exited(body: Node3D) -> void:
	if body.is_in_group("soldier"):
		current_zone = Zones.NONE


func _on_zone_negative_x_body_entered(body: Node3D) -> void:
	if body.is_in_group("soldier"):
		current_zone = Zones.NEG_X


func _on_zone_negative_x_body_exited(body: Node3D) -> void:
	if body.is_in_group("soldier"):
		current_zone = Zones.NONE 


func _on_zone_negative_z_body_entered(body: Node3D) -> void:
	if body.is_in_group("soldier"):
		current_zone = Zones.NEG_Z


func _on_zone_negative_z_body_exited(body: Node3D) -> void:
	if body.is_in_group("soldier"):
		current_zone = Zones.NONE


func _on_zone_positive_z_body_entered(body: Node3D) -> void:
	if body.is_in_group("soldier"):
		current_zone = Zones.POS_Z


func _on_zone_positive_z_body_exited(body: Node3D) -> void:
	if body.is_in_group("knight"):
		current_zone = Zones.NONE
