extends Node2D
class_name PlayerSoundsController

@onready var jump_sounds: Array[AudioStream] = [
	preload("res://assets/sounds/sound_effects/player/jump_1.MP3"), 
	preload("res://assets/sounds/sound_effects/player/jump_2.MP3"),
	preload("res://assets/sounds/sound_effects/player/jump_3.MP3")
]

@onready var jump_charge_sounds: Array[AudioStream] = [
	preload("res://assets/sounds/sound_effects/player/jump_charge_fadein.MP3"),
	preload("res://assets/sounds/sound_effects/player/jump_charg_loop.MP3")	
]

@onready var wall_standing_sounds: Array[AudioStream] = [
	preload("res://assets/sounds/sound_effects/player/wall_standing_fadein.MP3"),
	preload("res://assets/sounds/sound_effects/player/wall_standing_loop.MP3")
]

@onready var jump_charge_player: AudioStreamPlayer2D = $Jump_charging/jump_charge
@onready var wall_standing_player: AudioStreamPlayer2D = $WallStanding/wall_standing

@onready var player_controller: CharacterBody2D = $".."

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()
var audio_pool: Array[AudioStreamPlayer2D] = []
const POOL_SIZE: int = 4

var is_charge_fading_out: bool = false
var charge_fade_out_time: float = 0.0
var charge_original_volume: float = -16.0

var is_wall_standing_fading_out: bool = false
var wall_standing_fade_out_time: float = 0.0
var wall_standing_original_volume: float = -16.0

const FADE_OUT_DURATION: float = 0.3

func _ready() -> void:
	jump_charge_player.bus = "SFX"
	wall_standing_player.bus = "SFX"
	for i in range(POOL_SIZE):
		var player = AudioStreamPlayer2D.new()
		player.bus = "SFX"
		add_child(player)
		audio_pool.append(player)

func _process(delta: float) -> void:
	if is_charge_fading_out:
		charge_fade_out_time += delta
		var fade_progress: float = charge_fade_out_time / FADE_OUT_DURATION
		if fade_progress >= 1.0:
			_complete_charge_fade_out()
		else:
			jump_charge_player.volume_db = lerp(charge_original_volume, -80.0, fade_progress)

	if is_wall_standing_fading_out:
		wall_standing_fade_out_time += delta
		var fade_progress: float = wall_standing_fade_out_time / FADE_OUT_DURATION
		if fade_progress >= 1.0:
			_complete_wall_standing_fade_out()
		else:
			wall_standing_player.volume_db = lerp(wall_standing_original_volume, -80.0, fade_progress)

	if not player_controller.is_charging_jump:
		if jump_charge_player.playing and not is_charge_fading_out:
			_charge_jump_sound_stop()

	if not player_controller.is_on_wall():
		if wall_standing_player.playing and not is_wall_standing_fading_out:
			_wall_standing_sound_stop()

func _play_jump_sound() -> void:
	var audio_player: AudioStreamPlayer2D = null
	for player in audio_pool:
		if not player.playing:
			audio_player = player
			break

	if audio_player == null:
		return

	audio_player.stream = jump_sounds[RNG.randi_range(0, jump_sounds.size() - 1)]
	audio_player.volume_db = -8.0
	audio_player.play()

func _charge_jump_sound_manager() -> void:
	if jump_charge_player.playing or is_charge_fading_out:
		return

	is_charge_fading_out = false
	_play_charge_jump_sound_fade_in()

func _play_charge_jump_sound_fade_in() -> void:
	jump_charge_player.stream = jump_charge_sounds[0]
	jump_charge_player.volume_db = -16.0
	charge_original_volume = -16.0

	if jump_charge_player.finished.is_connected(_play_charge_jump_sound_loop):
		jump_charge_player.finished.disconnect(_play_charge_jump_sound_loop)

	jump_charge_player.finished.connect(_play_charge_jump_sound_loop, CONNECT_ONE_SHOT)
	jump_charge_player.play(0.0)

func _play_charge_jump_sound_loop() -> void:
	if not player_controller.is_charging_jump:
		_stop_charge_player()
		return

	jump_charge_player.stream = jump_charge_sounds[1]

	if jump_charge_player.finished.is_connected(_loop_charge_sound):
		jump_charge_player.finished.disconnect(_loop_charge_sound)

	jump_charge_player.finished.connect(_loop_charge_sound)
	jump_charge_player.play()

func _loop_charge_sound() -> void:
	if not player_controller.is_charging_jump:
		_stop_charge_player()
		return

	jump_charge_player.play(0.0)

func _charge_jump_sound_stop() -> void:
	if not is_charge_fading_out:
		is_charge_fading_out = true
		charge_fade_out_time = 0.0

func _complete_charge_fade_out() -> void:
	_stop_charge_player()
	is_charge_fading_out = false
	charge_fade_out_time = 0.0

func _stop_charge_player() -> void:
	if jump_charge_player.finished.is_connected(_play_charge_jump_sound_loop):
		jump_charge_player.finished.disconnect(_play_charge_jump_sound_loop)
	if jump_charge_player.finished.is_connected(_loop_charge_sound):
		jump_charge_player.finished.disconnect(_loop_charge_sound)

	jump_charge_player.stop()
	jump_charge_player.volume_db = charge_original_volume

func _wall_standing_sound_manager() -> void:
	if wall_standing_player.playing or is_wall_standing_fading_out:
		return

	is_wall_standing_fading_out = false
	_play_wall_standing_sound_fade_in()

func _play_wall_standing_sound_fade_in() -> void:
	wall_standing_player.stream = wall_standing_sounds[0]
	wall_standing_player.volume_db = -16.0
	wall_standing_original_volume = -16.0

	if wall_standing_player.finished.is_connected(_play_wall_standing_sound_loop):
		wall_standing_player.finished.disconnect(_play_wall_standing_sound_loop)

	wall_standing_player.finished.connect(_play_wall_standing_sound_loop, CONNECT_ONE_SHOT)
	wall_standing_player.play(0.0)

func _play_wall_standing_sound_loop() -> void:
	if not player_controller.is_on_wall():
		_stop_wall_standing_player()
		return

	wall_standing_player.stream = wall_standing_sounds[1]

	if wall_standing_player.finished.is_connected(_loop_wall_standing_sound):
		wall_standing_player.finished.disconnect(_loop_wall_standing_sound)

	wall_standing_player.finished.connect(_loop_wall_standing_sound)
	wall_standing_player.play()

func _loop_wall_standing_sound() -> void:
	if not player_controller.is_on_wall():
		_stop_wall_standing_player()
		return

	wall_standing_player.play(0.0)

func _wall_standing_sound_stop() -> void:
	if not is_wall_standing_fading_out:
		is_wall_standing_fading_out = true
		wall_standing_fade_out_time = 0.0

func _complete_wall_standing_fade_out() -> void:
	_stop_wall_standing_player()
	is_wall_standing_fading_out = false
	wall_standing_fade_out_time = 0.0

func _stop_wall_standing_player() -> void:
	if wall_standing_player.finished.is_connected(_play_wall_standing_sound_loop):
		wall_standing_player.finished.disconnect(_play_wall_standing_sound_loop)
	if wall_standing_player.finished.is_connected(_loop_wall_standing_sound):
		wall_standing_player.finished.disconnect(_loop_wall_standing_sound)

	wall_standing_player.stop()
	wall_standing_player.volume_db = wall_standing_original_volume
