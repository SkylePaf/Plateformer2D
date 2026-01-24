
#    －＞  Ｈｅａｄｅｒ
extends Path2D
class_name MovingPlatform

#           /$$      /$$  /$$$$$$  /$$    /$$ /$$$$$$ /$$   /$$  /$$$$$$        /$$$$$$$  /$$        /$$$$$$  /$$$$$$$$ /$$$$$$$$ /$$$$$$$$ /$$$$$$  /$$$$$$$  /$$      /$$
#          | $$$    /$$$ /$$__  $$| $$   | $$|_  $$_/| $$$ | $$ /$$__  $$      | $$__  $$| $$       /$$__  $$|__  $$__/| $$_____/| $$_____//$$__  $$| $$__  $$| $$$    /$$$
#          | $$$$  /$$$$| $$  \ $$| $$   | $$  | $$  | $$$$| $$| $$  \__/      | $$  \ $$| $$      | $$  \ $$   | $$   | $$      | $$     | $$  \ $$| $$  \ $$| $$$$  /$$$$
#          | $$ $$/$$ $$| $$  | $$|  $$ / $$/  | $$  | $$ $$ $$| $$ /$$$$      | $$$$$$$/| $$      | $$$$$$$$   | $$   | $$$$$   | $$$$$  | $$  | $$| $$$$$$$/| $$ $$/$$ $$
#          | $$  $$$| $$| $$  | $$ \  $$ $$/   | $$  | $$  $$$$| $$|_  $$      | $$____/ | $$      | $$__  $$   | $$   | $$__/   | $$__/  | $$  | $$| $$__  $$| $$  $$$| $$
#          | $$\  $ | $$| $$  | $$  \  $$$/    | $$  | $$\  $$$| $$  \ $$      | $$      | $$      | $$  | $$   | $$   | $$      | $$     | $$  | $$| $$  \ $$| $$\  $ | $$
#          | $$ \/  | $$|  $$$$$$/   \  $/    /$$$$$$| $$ \  $$|  $$$$$$/      | $$      | $$$$$$$$| $$  | $$   | $$   | $$$$$$$$| $$     |  $$$$$$/| $$  | $$| $$ \/  | $$
#          |__/     |__/ \______/     \_/    |______/|__/  \__/ \______/       |__/      |________/|__/  |__/   |__/   |________/|__/      \______/ |__/  |__/|__/     |__/
#                                                                                                                                                                          
#                                                                                                                                                                          
# 
#                      ╻ ╻┏━┓╻  ╺┳┓┏━┓   ┏━┓╻┏┳┓┏━┓╻  ┏━╸   ┏┳┓┏━┓╻ ╻╻┏┓╻┏━╸   ┏━┓╻  ┏━┓╺┳╸┏━╸┏━╸┏━┓┏━┓┏┳┓┏━┓   ┏━┓┏┓╻╻┏┳┓┏━┓╺┳╸╻┏━┓┏┓╻ 
#                ╺━╸   ┣━┫┃ ┃┃   ┃┃┗━┓   ┗━┓┃┃┃┃┣━┛┃  ┣╸    ┃┃┃┃ ┃┃┏┛┃┃┗┫┃╺┓   ┣━┛┃  ┣━┫ ┃ ┣╸ ┣╸ ┃ ┃┣┳┛┃┃┃┗━┓   ┣━┫┃┗┫┃┃┃┃┣━┫ ┃ ┃┃ ┃┃┗┫ 
#                      ╹ ╹┗━┛┗━╸╺┻┛┗━┛   ┗━┛╹╹ ╹╹  ┗━╸┗━╸   ╹ ╹┗━┛┗┛ ╹╹ ╹┗━┛   ╹  ┗━╸╹ ╹ ╹ ┗━╸╹  ┗━┛╹┗╸╹ ╹┗━┛   ╹ ╹╹ ╹╹╹ ╹╹ ╹ ╹ ╹┗━┛╹ ╹╹                                                                                                                                                                      

#                                                                                 
#                                                                                 
#          ████▄  ▄▄▄▄▄  ▄▄▄▄ ▄▄     ▄▄▄  ▄▄▄▄   ▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄  ▄▄▄▄ 
#    ▄▄▄   ██  ██ ██▄▄  ██▀▀▀ ██    ██▀██ ██▄█▄ ██▀██  ██   ██ ██▀██ ███▄██ ███▄▄ 
#          ████▀  ██▄▄▄ ▀████ ██▄▄▄ ██▀██ ██ ██ ██▀██  ██   ██ ▀███▀ ██ ▀██ ▄▄██▀ 
#                                                                                 

#region Declarations

#    －＞  Ｃｏｎｓｔａｎｔｓ
const TRAIL_AMOUNT: int = 50
const TRAIL_LIFETIME: float = 0.3
const TRAIL_EXPLOSIVENESS: float = 0.0
const TRAIL_RANDOMNESS: float = 0.0
const TRAIL_VELOCITY_MIN: float = 0.0
const TRAIL_VELOCITY_MAX: float = 0.0
const TRAIL_DIRECTION: Vector2 = Vector2.ZERO
const TRAIL_SPREAD: float = 0.0
const FRICTION_GRAVITY: Vector2 = Vector2(0.0, -60.0)
const PROGRESS_START: float = 0.0
const PROGRESS_END: float = 1.0

#    －＞  Variables  Exports
@export var path_follow_2D: PathFollow2D
@export var ease: Tween.EaseType
@export var transition: Tween.TransitionType
@export var path_time: float = 1.0

@onready var particle1: CPUParticles2D = $"AnimatableBody2D/Sprite2D/particles-1"
@onready var particle2: CPUParticles2D = $"AnimatableBody2D/Sprite2D/particles-2"
@onready var all_particles: Array[CPUParticles2D] = [
	particle1, 
	particle2
]

#endregion

#                                                                
#                                                                
#          ██     ▄▄  ▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄ ▄▄  ▄▄ ▄▄▄▄▄ ▄▄▄▄   ▄▄▄▄ 
#    ▄▄▄   ██     ██ ███▄▄   ██   ██▄▄  ███▄██ ██▄▄  ██▄█▄ ███▄▄ 
#          ██████ ██ ▄▄██▀   ██   ██▄▄▄ ██ ▀██ ██▄▄▄ ██ ██ ▄▄██▀ 
#                                                                

#region Listeners
#    －＞  Ｏｎ  Ｌｏａｄ  Ｅｘｅｃｕｔｏｒ
func _ready() -> void:
	_configure_trail_particles()
	_create_movement_tween()

func _configure_trail_particles() -> void:
	for particle in all_particles:
		particle.emitting = true
		particle.amount = TRAIL_AMOUNT
		particle.lifetime = TRAIL_LIFETIME
		particle.explosiveness = TRAIL_EXPLOSIVENESS
		particle.randomness = TRAIL_RANDOMNESS
		particle.initial_velocity_min = TRAIL_VELOCITY_MIN
		particle.initial_velocity_max = TRAIL_VELOCITY_MAX
		particle.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
		particle.direction = TRAIL_DIRECTION
		particle.spread = TRAIL_SPREAD

#    －＞  Ｐｒｏｃｅｓｓ  Ｆｕｎｃｔｉｏｎ
func _create_movement_tween() -> void:
	var tween: Tween = get_tree().create_tween().set_loops()
	tween.tween_property(path_follow_2D, "progress_ratio", PROGRESS_END, path_time).set_ease(ease).set_trans(transition)
	tween.tween_property(path_follow_2D, "progress_ratio", PROGRESS_START, path_time).set_ease(ease).set_trans(transition)
#endregion

#    ███████ ███    ██ ██████                                                                                                                              
#    ██      ████   ██ ██   ██                                                                                                                             
#    █████   ██ ██  ██ ██   ██     █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ 
#    ██      ██  ██ ██ ██   ██                                                                                                                             
#    ███████ ██   ████ ██████                                                                                                                              
#                                                                                                                                                          
#                                                                                                                                                          
