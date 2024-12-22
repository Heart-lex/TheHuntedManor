extends Node

const COIN_COLLECTING = preload("res://sounds/sound_effects/CoinCollecting.ogg")
const SHOPKEEPER = preload("res://sounds/sound_effects/ShopKeeper.ogg")
const GAME_OVER = preload("res://sounds/sound_effects/game_over.ogg")
const BAT_ATTACK = preload("res://sounds/sound_effects/bat_attack.ogg")
const SPIDER_ATTACK = preload("res://sounds/sound_effects/spider_attack.ogg")
const LIGHT_ATTACK = preload("res://sounds/sound_effects/light_attack.ogg")
const HEAVY_ATTACK = preload("res://sounds/sound_effects/heavy_attack.ogg")
const JUMP = preload("res://sounds/sound_effects/jump.ogg")
const WALKING = preload("res://sounds/sound_effects/walking.ogg")
const LANDING = preload("res://sounds/sound_effects/landing.ogg")
const DOOR_OPENING = preload("res://sounds/sound_effects/door_opening.ogg")
const LEVEL_SUCCESS = preload("res://sounds/sound_effects/level_success.ogg")
const LEVER_PULL = preload("res://sounds/sound_effects/lever_pull.ogg")
const PURCHASE = preload("res://sounds/sound_effects/purchase.ogg")
const SPIKE_TRAP = preload("res://sounds/sound_effects/spike_trap.ogg")
const POTION_DRINKING = preload("res://sounds/sound_effects/potion_drinking.ogg")
const KEY_UNLOCKING = preload("res://sounds/sound_effects/key_unlocking.ogg")
const PUSH = preload("res://sounds/sound_effects/push.ogg")

var audio_players: Array = []

func play_sound(audioStream: AudioStreamOggVorbis, offset: float = 0, volume: float = 0, delay : float = 0):
	var player = AudioStreamPlayer.new()
	add_child(player)

	player.stream = audioStream
	player.pitch_scale = randf_range(0.9, 1.1)
	player.volume_db = volume
	
	if delay:
		await get_tree().create_timer(delay).timeout
		
	player.play(offset)

	# Connect the finished signal to the handler
	player.connect("finished", Callable(player, "_on_audio_finished") )
	
	# Add player to the list of active audio players
	audio_players.append(player)

# This method will be called when the sound finishes
func _on_audio_finished():
	var player = get_parent()
	player.queue_free()
	audio_players.erase(player)  # Remove the player from the list
