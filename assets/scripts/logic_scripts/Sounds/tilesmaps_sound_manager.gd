extends Node2D
class_name TilesMapsSoundsController

@onready var footstep_sounds: Dictionary[String, Array] = {
	"grass": [
		preload("res://assets/sounds/sound_effects/tiles_specific_sounds/grass/step_1.MP3"),
		preload("res://assets/sounds/sound_effects/tiles_specific_sounds/grass/step_2.MP3"),
		preload("res://assets/sounds/sound_effects/tiles_specific_sounds/grass/step_3.MP3"),
		preload("res://assets/sounds/sound_effects/tiles_specific_sounds/grass/step_4.MP3"), 
		preload("res://assets/sounds/sound_effects/tiles_specific_sounds/grass/step_5.MP3"),
		preload("res://assets/sounds/sound_effects/tiles_specific_sounds/grass/step_6.MP3")
	],
	"snow": [
		preload("res://assets/sounds/sound_effects/tiles_specific_sounds/snow/step_1.MP3"),
		preload("res://assets/sounds/sound_effects/tiles_specific_sounds/snow/step_2.MP3"),
		preload("res://assets/sounds/sound_effects/tiles_specific_sounds/snow/step_3.MP3"),
		preload("res://assets/sounds/sound_effects/tiles_specific_sounds/snow/step_4.MP3"),
		preload("res://assets/sounds/sound_effects/tiles_specific_sounds/snow/step_5.MP3"),
		preload("res://assets/sounds/sound_effects/tiles_specific_sounds/snow/step_6.MP3")
	]
}

@onready var player_controller: CharacterBody2D = $"../../../player"

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()

var _player_position_x: float = 0.0
var _is_player_moving: bool = false
var current_audio_player: AudioStreamPlayer2D
var audio_pool: Array[AudioStreamPlayer2D] = []
const POOL_SIZE: int = 8

func _ready() -> void:
	for i in range(POOL_SIZE):
		var player = AudioStreamPlayer2D.new()
		player.bus = "SFX"  
		add_child(player)
		audio_pool.append(player)

func _play_footstep_sound_handler(soil_type: String) -> void:	
	if not footstep_sounds.has(soil_type):
		return
		
	current_audio_player = _get_current_audio_player()
	_play_audio(current_audio_player, soil_type)
	

func _get_current_audio_player() -> AudioStreamPlayer2D:
	var audio_player: AudioStreamPlayer2D = null
	for player in audio_pool:
		if not player.playing:
			audio_player = player
			break
	
	if audio_player == null:
		audio_player = audio_pool[0]
	return audio_player

func _play_audio(audio_player: AudioStreamPlayer2D, soil_type: String) -> void:
	audio_player.stream = footstep_sounds[soil_type][RNG.randi_range(0, footstep_sounds[soil_type].size() - 1)]
	audio_player.volume_db = -8
	audio_player.play()

func _process(delta: float) -> void:
	_cache_player_state()
	
	if _is_player_moving:
		_update_position()
		
func _cache_player_state() -> void:
	_player_position_x = player_controller.position.x
	_is_player_moving = player_controller.velocity.x != 0.0
	
	
func _update_position() -> void:
	position.x = _player_position_x
