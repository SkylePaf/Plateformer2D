extends Node2D
class_name PlayerSoundsController

@onready var jump_sounds: Array[AudioStream] = [
	preload("res://assets/sounds/sound_effects/player/jump_1.MP3"), 
	preload("res://assets/sounds/sound_effects/player/jump_2.MP3"),
	preload("res://assets/sounds/sound_effects/player/jump_3.MP3")
]


@onready var jump_player: AudioStreamPlayer2D = $Jumps/jump

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()

var audio_pool: Array[AudioStreamPlayer2D] = []
const POOL_SIZE: int = 4

func _ready() -> void:
	for i in range(POOL_SIZE):
		var player = AudioStreamPlayer2D.new()
		player.bus = "SFX"  
		add_child(player)
		audio_pool.append(player)

func _play_jump_sound() -> void:
	var audio_player: AudioStreamPlayer2D = null
	for player in audio_pool:
		if not player.playing:
			audio_player = player
			break
	
	if audio_player == null:
		audio_player = audio_pool[0]
	
	audio_player.stream = jump_sounds[RNG.randi_range(0, jump_sounds.size() - 1)]
	audio_player.volume_db = -8.0
	audio_player.play()
