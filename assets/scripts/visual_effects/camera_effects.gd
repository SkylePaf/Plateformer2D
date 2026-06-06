extends Node2D

var noise_shake_speed: float = 30.0
var noise_shake_strength: float = 60.0
var shake_decay_rate: float = 5.0

@onready var camera = $"."

var rand: RandomNumberGenerator = RandomNumberGenerator.new()
var noise: FastNoiseLite = FastNoiseLite.new()

var noise_i: float = 0.0
var shake_strength: float = 0.0
var is_shaking: bool = false
var should_loop: bool = false
var target_shake_strength: float = 0.0
var original_offset: Vector2 = Vector2.ZERO

var fade_in_duration: float = 0.1
var fade_in_timer: float = 0.0
var is_fading_in: bool = false

func _ready() -> void:
	rand.randomize()
	noise.seed = rand.randi()
	noise.frequency = 0.5

func start_shake(strength: float = 60.0, speed: float = 30.0, decay_rate: float = 5.0, loop: bool = false) -> void:
	if not is_shaking:
		original_offset = camera.offset
	
	noise_shake_strength = strength
	noise_shake_speed = speed
	shake_decay_rate = decay_rate
	should_loop = loop
	target_shake_strength = strength
	shake_strength = 0.0
	is_shaking = true
	is_fading_in = true
	fade_in_timer = 0.0

func stop_shake() -> void:
	should_loop = false
	is_shaking = false
	shake_strength = 0.0
	is_fading_in = false
	camera.offset = original_offset

func _process(delta: float) -> void:
	if is_shaking:
		if is_fading_in:
			fade_in_timer += delta
			var fade_progress = min(fade_in_timer / fade_in_duration, 1.0)
			shake_strength = lerp(0.0, target_shake_strength, fade_progress)
			
			if fade_progress >= 1.0:
				is_fading_in = false
		else:
			shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
		
		if shake_strength < 0.5 and not is_fading_in:
			if should_loop:
				# Redémarrer le fade in
				is_fading_in = true
				fade_in_timer = 0.0
			else:
				stop_shake()
				return
		
		camera.offset = original_offset + get_noise_offset(delta)

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * noise_shake_speed
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)
