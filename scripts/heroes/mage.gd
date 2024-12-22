class_name Mage

extends CharacterBody3D

@export var shop : Shop
var is_sound_heard: bool = false

@export var mage_dialogue : MageDialogue
var entered : bool = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("buy") and entered:
		shop.visible = true
		mage_dialogue.visible = false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if not is_sound_heard:
			AudioManager.play_sound(AudioManager.SHOPKEEPER, 0.25, 1)
			is_sound_heard = true
		mage_dialogue.visible = true
		entered = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		mage_dialogue.visible = false
		entered = false
