#    －＞  Ｈｅａｄｅｒ
extends Node2D
class_name ParticlesHandler

#           /$$$$$$$   /$$$$$$  /$$$$$$$  /$$$$$$$$ /$$$$$$  /$$$$$$  /$$       /$$$$$$$$  /$$$$$$        /$$   /$$  /$$$$$$  /$$   /$$ /$$$$$$$  /$$       /$$$$$$$$ /$$$$$$$ 
#          | $$__  $$ /$$__  $$| $$__  $$|__  $$__/|_  $$_/ /$$__  $$| $$      | $$_____/ /$$__  $$      | $$  | $$ /$$__  $$| $$$ | $$| $$__  $$| $$      | $$_____/| $$__  $$
#          | $$  \ $$| $$  \ $$| $$  \ $$   | $$     | $$  | $$  \__/| $$      | $$      | $$  \__/      | $$  | $$| $$  \ $$| $$$$| $$| $$  \ $$| $$      | $$      | $$  \ $$
#          | $$$$$$$/| $$$$$$$$| $$$$$$$/   | $$     | $$  | $$      | $$      | $$$$$   |  $$$$$$       | $$$$$$$$| $$$$$$$$| $$ $$ $$| $$  | $$| $$      | $$$$$   | $$$$$$$/
#          | $$____/ | $$__  $$| $$__  $$   | $$     | $$  | $$      | $$      | $$__/    \____  $$      | $$__  $$| $$__  $$| $$  $$$$| $$  | $$| $$      | $$__/   | $$__  $$
#          | $$      | $$  | $$| $$  \ $$   | $$     | $$  | $$    $$| $$      | $$       /$$  \ $$      | $$  | $$| $$  | $$| $$\  $$$| $$  | $$| $$      | $$      | $$  \ $$
#          | $$      | $$  | $$| $$  | $$   | $$    /$$$$$$|  $$$$$$/| $$$$$$$$| $$$$$$$$|  $$$$$$/      | $$  | $$| $$  | $$| $$ \  $$| $$$$$$$/| $$$$$$$$| $$$$$$$$| $$  | $$
#          |__/      |__/  |__/|__/  |__/   |__/   |______/ \______/ |________/|________/ \______/       |__/  |__/|__/  |__/|__/  \__/|_______/ |________/|________/|__/  |__/
#                                                                                                                                                                              
#                                                                                                                                                                              
#                                                                                                                                                                              
#                      ╻ ╻┏━┓╻  ╺┳┓┏━┓   ┏━┓┏━┓┏━┓╺┳╸╻┏━╸╻  ┏━╸┏━┓   ┏━┓╻╺┳╸╻ ╻┏━┓╺┳╸╻┏━┓┏┓╻┏━┓╻     ┏━┓╻ ╻┏━┓╺┳╸┏━╸┏┳┓ 
#                ╺━╸   ┣━┫┃ ┃┃   ┃┃┗━┓   ┣━┛┣━┫┣┳┛ ┃ ┃┃  ┃  ┣╸ ┗━┓   ┗━┓┃ ┃ ┃ ┃┣━┫ ┃ ┃┃ ┃┃┗┫┣━┫┃     ┗━┓┗┳┛┗━┓ ┃ ┣╸ ┃┃┃ 
#                      ╹ ╹┗━┛┗━╸╺┻┛┗━┛   ╹  ╹ ╹╹┗╸ ╹ ╹┗━╸┗━╸┗━╸┗━┛   ┗━┛╹ ╹ ┗━┛╹ ╹ ╹ ╹┗━┛╹ ╹╹ ╹┗━╸   ┗━┛ ╹ ┗━┛ ╹ ┗━╸╹ ╹╹

#                                                                                 
#                                                                                 
#          ████▄  ▄▄▄▄▄  ▄▄▄▄ ▄▄     ▄▄▄  ▄▄▄▄   ▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄  ▄▄▄▄ 
#    ▄▄▄   ██  ██ ██▄▄  ██▀▀▀ ██    ██▀██ ██▄█▄ ██▀██  ██   ██ ██▀██ ███▄██ ███▄▄ 
#          ████▀  ██▄▄▄ ▀████ ██▄▄▄ ██▀██ ██ ██ ██▀██  ██   ██ ▀███▀ ██ ▀██ ▄▄██▀ 
#                                                                                 

#region Declarations

#    －＞  Ｃｏｎｓｔａｎｔｓ
const TRAIL_AMOUNT: int = 100
const TRAIL_LIFETIME: float = 0.3
const TRAIL_EXPLOSIVENESS: float = 0.0
const TRAIL_RANDOMNESS: float = 0.0
const TRAIL_VELOCITY_MIN: float = 0.0
const TRAIL_VELOCITY_MAX: float = 0.0
const TRAIL_RECT_EXTENTS: Vector2 = Vector2(2.0, 1.0)
const TRAIL_DIRECTION: Vector2 = Vector2.ZERO
const TRAIL_SPREAD: float = 0.0
const FRICTION_GRAVITY: Vector2 = Vector2(0.0, -60.0)
const PARTICLE_OFFSET_LEFT: Vector2 = Vector2(-3.0, -1.0)
const PARTICLE_OFFSET_RIGHT: Vector2 = Vector2(3.0, -1.0)

#    －＞  Ｎｏｄｅｓ  Ｉｍｐｏｒｔｓ
@onready var player_controller: PlayerController = get_parent()
@onready var particles_friction_more: CPUParticles2D = $FrictionSmokeMore
@onready var particles_airborn_trail: CPUParticles2D = $AirbornTrail
@onready var particles_friction_less: CPUParticles2D = $FrictionSmokeLess
@onready var trail_light: PointLight2D = $TrailLight
@onready var all_particles: Array[CPUParticles2D] = [
	particles_friction_more, 
	particles_airborn_trail, 
	particles_friction_less
]

#    －＞  Ｖａｒｉａｂｌｅｓ
var is_little_fog_active: bool = false

#    －＞  Ｃａｃｈｅ
var _is_on_floor: bool = false
var _is_wall_standing: bool = false
var _velocity_x: float = 0.0
#endregion

#                                                                                                                                         
#                                                                                                                                         
#          █████▄  ▄▄▄  ▄▄▄▄  ▄▄▄▄▄▄ ▄▄  ▄▄▄▄ ▄▄    ▄▄▄▄▄  ▄▄▄▄   ██ ▄▄  ▄▄ ▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄    ▄▄  ▄▄▄▄  ▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄ 
#    ▄▄▄   ██▄▄█▀ ██▀██ ██▄█▄   ██   ██ ██▀▀▀ ██    ██▄▄  ███▄▄   ██ ███▄██ ██   ██   ██ ██▀██ ██    ██ ███▄▄ ██▀██  ██   ██ ██▀██ ███▄██ 
#          ██     ██▀██ ██ ██   ██   ██ ▀████ ██▄▄▄ ██▄▄▄ ▄▄██▀   ██ ██ ▀██ ██   ██   ██ ██▀██ ██▄▄▄ ██ ▄▄██▀ ██▀██  ██   ██ ▀███▀ ██ ▀██ 
#                                                                                                                                         

#region Particles Initialisation

#    －＞  Ｏｎ  Ｌｏａｄ  Ｅｘｅｃｕｔｏｒ
func _ready() -> void:
	_initialize_particles()
	_configure_trail_particles()
	_configure_friction_particles()

#    －＞  Ｐａｒｔｉｃｌｅｓ  Ｉｎｉｔｉａｌｉｓａｔｏｒ
func _initialize_particles() -> void:
	for particle in all_particles:
		particle.emitting = false
	trail_light.visible = false

#    －＞  ＡｉｒＢｏｒｎ  Ｔｒａｉｌ  Ｃｏｎｆｉｇｕｒａｔｏｒ
func _configure_trail_particles() -> void:
	particles_airborn_trail.amount = TRAIL_AMOUNT
	particles_airborn_trail.lifetime = TRAIL_LIFETIME
	particles_airborn_trail.explosiveness = TRAIL_EXPLOSIVENESS
	particles_airborn_trail.randomness = TRAIL_RANDOMNESS
	particles_airborn_trail.initial_velocity_min = TRAIL_VELOCITY_MIN
	particles_airborn_trail.initial_velocity_max = TRAIL_VELOCITY_MAX
	particles_airborn_trail.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	particles_airborn_trail.emission_rect_extents = TRAIL_RECT_EXTENTS
	particles_airborn_trail.direction = TRAIL_DIRECTION
	particles_airborn_trail.spread = TRAIL_SPREAD

#    －＞  Ｆｒｉｃｔｉｏｎ  Ｐａｒｔｉｃｌｅｓ  Ｃｏｎｆｉｇｕｒａｔｏｒ
func _configure_friction_particles() -> void:
	particles_friction_more.gravity = FRICTION_GRAVITY
#endregion

#                                                                
#                                                                
#          ██     ▄▄  ▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄ ▄▄  ▄▄ ▄▄▄▄▄ ▄▄▄▄   ▄▄▄▄ 
#    ▄▄▄   ██     ██ ███▄▄   ██   ██▄▄  ███▄██ ██▄▄  ██▄█▄ ███▄▄ 
#          ██████ ██ ▄▄██▀   ██   ██▄▄▄ ██ ▀██ ██▄▄▄ ██ ██ ▄▄██▀ 
#                                                                

#region Listerners

#    －＞  Ｉｎｐｕｔｓ  Ｄｅｔｅｃｔｏｒ
func _input(event: InputEvent) -> void:
	var jump_or_duck_pressed: bool = Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("duck")
	var jump_or_duck_released: bool = Input.is_action_just_released("jump") or Input.is_action_just_released("duck")
	
	#print("jump_or_duck_pressed: ", jump_or_duck_pressed, " jump_or_duck_released: ", jump_or_duck_released)

	if player_controller.wall_standing:
		if player_controller.lastest_x_velocity > 0:
			_set_particle_position(PARTICLE_OFFSET_RIGHT)
		if player_controller.lastest_x_velocity < 0:
			_set_particle_position(PARTICLE_OFFSET_LEFT)
	if jump_or_duck_pressed or player_controller.is_on_wall():
		is_little_fog_active = true
	elif jump_or_duck_released and not player_controller.is_on_wall():
		is_little_fog_active = false

#    －＞  Ｐｒｏｃｅｓｓ  Ｆｕｎｃｔｉｏｎ
func _process(delta: float) -> void:
	_cache_player_state()
	
	if _is_on_floor or _is_wall_standing:
		_handle_ground_particles()
	else:
		_handle_air_particles()
#endregion

#                                                                                                             
#                                                                                                             
#          ██████ ▄▄▄▄  ▄▄  ▄▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄  ▄▄▄▄   █████▄  ▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄▄ ▄▄    ▄▄▄▄▄  ▄▄▄▄ 
#    ▄▄▄   ██▄▄   ██▄█▄ ██ ██▀▀▀   ██   ██ ██▀██ ███▄██ ███▄▄   ██▄▄█▀ ██▀██  ██   ██ ██▀▀▀ ██    ██▄▄  ███▄▄ 
#          ██     ██ ██ ██ ▀████   ██   ██ ▀███▀ ██ ▀██ ▄▄██▀   ██     ██▀██  ██   ██ ▀████ ██▄▄▄ ██▄▄▄ ▄▄██▀ 
#                                                                                                             

#region Friction Particles

#    －＞  Ｆｒｉｃｔｉｏｎ  Ｐａｒｔｉｃｌｅｓ  Ｃｏｎｄｉｔｉｏｎｓ  Ｈａｎｄｌｅｒ
func _handle_ground_particles() -> void:
	_disable_air_particles()
	
	if _velocity_x > 0.0:
		_set_particle_position(PARTICLE_OFFSET_LEFT)
		_toggle_friction_particles()
	elif _velocity_x < 0.0:
		_set_particle_position(PARTICLE_OFFSET_RIGHT)
		_toggle_friction_particles()
	else:
		_disable_friction_particles()
		if _is_wall_standing:
			particles_friction_less.emitting = true

#    －＞  Ｆｒｉｃｔｉｏｎ  Ｐａｒｔｉｃｌｅｓ  Ｓｗｉｔｃｈｅｓ
func _toggle_friction_particles() -> void:
	if is_little_fog_active:
		particles_friction_more.emitting = false
		particles_friction_less.emitting = true
	else:
		particles_friction_more.emitting = true
		particles_friction_less.emitting = false

func _disable_friction_particles() -> void:
	particles_friction_more.emitting = false
	particles_friction_less.emitting = false
#endregion

#                                                                                                                                         
#                                                                                                                                         
#          ▄████▄ ▄▄ ▄▄▄▄  █████▄  ▄▄▄  ▄▄▄▄  ▄▄  ▄▄   ██████ ▄▄▄▄   ▄▄▄  ▄▄ ▄▄      █████▄  ▄▄▄  ▄▄▄▄  ▄▄▄▄▄▄ ▄▄  ▄▄▄▄ ▄▄    ▄▄▄▄▄  ▄▄▄▄ 
#    ▄▄▄   ██▄▄██ ██ ██▄█▄ ██▄▄██ ██▀██ ██▄█▄ ███▄██     ██   ██▄█▄ ██▀██ ██ ██      ██▄▄█▀ ██▀██ ██▄█▄   ██   ██ ██▀▀▀ ██    ██▄▄  ███▄▄ 
#          ██  ██ ██ ██ ██ ██▄▄█▀ ▀███▀ ██ ██ ██ ▀██     ██   ██ ██ ██▀██ ██ ██▄▄▄   ██     ██▀██ ██ ██   ██   ██ ▀████ ██▄▄▄ ██▄▄▄ ▄▄██▀ 
#                                                                                                                                         

#region AirBorn Trail Particles

#    －＞  ＡｉｒＢｏｒｎ  Ｔｒａｉｌ  Ｐａｒｔｉｃｌｅｓ  Ｃｏｎｄｉｔｉｏｎｓ  Ｈａｎｄｌｅｒ
func _handle_air_particles() -> void:
	particles_friction_more.emitting = false
	particles_friction_less.emitting = false
	
	if not _is_wall_standing:
		_enable_air_particles()

#    －＞  ＡｉｒＢｏｒｎ  Ｔｒａｉｌ  Ｐａｒｔｉｃｌｅｓ  Ｓｗｉｔｃｈｅｓ
func _disable_air_particles() -> void:
	particles_airborn_trail.emitting = false
	trail_light.visible = false
func _enable_air_particles() -> void:
	particles_airborn_trail.emitting = true
	trail_light.visible = true
#endregion

#                                                                                                           
#                                                                                                           
#          ██  ██ ▄▄▄▄▄ ▄▄    ▄▄▄▄  ▄▄▄▄▄ ▄▄▄▄    ██████ ▄▄ ▄▄ ▄▄  ▄▄  ▄▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄  ▄▄▄▄ 
#    ▄▄▄   ██████ ██▄▄  ██    ██▄█▀ ██▄▄  ██▄█▄   ██▄▄   ██ ██ ███▄██ ██▀▀▀   ██   ██ ██▀██ ███▄██ ███▄▄ 
#          ██  ██ ██▄▄▄ ██▄▄▄ ██    ██▄▄▄ ██ ██   ██     ▀███▀ ██ ▀██ ▀████   ██   ██ ▀███▀ ██ ▀██ ▄▄██▀ 
#                                                                                                           

#region Helper Functions

#    －＞  Ｓｅｔ  Ｐａｒｔｉｃｌｅｓ  Ｐｏｓｉｔｉｏｎ．
func _set_particle_position(offset: Vector2) -> void:
	particles_friction_more.position = offset
	particles_friction_less.position = offset

#    －＞  Ｐｌａｙｅｒ  Ｓｔａｔｅ  Ｉｎｄｅｎｔｉｆｉｃａｔｏｒ
func _cache_player_state() -> void:
	_is_on_floor = player_controller.is_on_floor()
	_is_wall_standing = player_controller.wall_standing
	_velocity_x = player_controller.velocity.x
#endregion

#    ███████ ███    ██ ██████                                                                                                                              
#    ██      ████   ██ ██   ██                                                                                                                             
#    █████   ██ ██  ██ ██   ██     █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ 
#    ██      ██  ██ ██ ██   ██                                                                                                                             
#    ███████ ██   ████ ██████                                                                                                                              
#                                                                                                                                                          
#                                                                                                                                                          
