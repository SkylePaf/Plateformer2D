#    >>  Header
@tool
extends Node2D
class_name GrassGeneration

#           /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$        /$$$$$$  /$$$$$$$$ /$$   /$$ /$$$$$$$$ /$$$$$$$   /$$$$$$  /$$$$$$$$ /$$$$$$  /$$$$$$  /$$   /$$
#          /$$__  $$| $$__  $$ /$$__  $$ /$$__  $$ /$$__  $$      /$$__  $$| $$_____/| $$$ | $$| $$_____/| $$__  $$ /$$__  $$|__  $$__/|_  $$_/ /$$__  $$| $$$ | $$
#         | $$  \__/| $$  \ $$| $$  \ $$| $$  \__/| $$  \__/     | $$  \__/| $$      | $$$$| $$| $$      | $$  \ $$| $$  \ $$   | $$     | $$  | $$  \ $$| $$$$| $$
#         | $$ /$$$$| $$$$$$$/| $$$$$$$$|  $$$$$$ |  $$$$$$      | $$ /$$$$| $$$$$   | $$ $$ $$| $$$$$   | $$$$$$$/| $$$$$$$$   | $$     | $$  | $$  | $$| $$ $$ $$
#         | $$|_  $$| $$__  $$| $$__  $$ \____  $$ \____  $$     | $$|_  $$| $$__/   | $$  $$$$| $$__/   | $$__  $$| $$__  $$   | $$     | $$  | $$  | $$| $$  $$$$
#         | $$  \ $$| $$  \ $$| $$  | $$ /$$  \ $$ /$$  \ $$     | $$  \ $$| $$      | $$\  $$$| $$      | $$  \ $$| $$  | $$   | $$     | $$  | $$  | $$| $$\  $$$
#         |  $$$$$$/| $$  | $$| $$  | $$|  $$$$$$/|  $$$$$$/     |  $$$$$$/| $$$$$$$$| $$ \  $$| $$$$$$$$| $$  | $$| $$  | $$   | $$    /$$$$$$|  $$$$$$/| $$ \  $$
#          \______/ |__/  |__/|__/  |__/ \______/  \______/       \______/ |________/|__/  \__/|________/|__/  |__/|__/  |__/   |__/   |______/ \______/ |__/  \__/

#                                                                                 
#                                                                                 
#          ████▄  ▄▄▄▄▄  ▄▄▄▄ ▄▄     ▄▄▄  ▄▄▄▄   ▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄  ▄▄▄▄ 
#    ▄▄▄   ██  ██ ██▄▄  ██▀▀▀ ██    ██▀██ ██▄█▄ ██▀██  ██   ██ ██▀██ ███▄██ ███▄▄ 
#          ████▀  ██▄▄▄ ▀████ ██▄▄▄ ██▀██ ██ ██ ██▀██  ██   ██ ▀███▀ ██ ▀██ ▄▄██▀ 
#                                                                                 

#region Declarations

#    >>  Constants
const PLAYER_NODE_NAME: String = "player"
const LVL_TYPE_NODE_NAME: String = "LVL_Type"
const LVL_TYPE_META_KEY: String = "LVL_TYPE"
const FADE_DURATION: float = 1.0
const IN_OPACITY: float = 1.0
const OUT_OPACITY: float = 0.7
const DECELERATION_MULTIPLIER: float = 0.97
const ANIMATION_SPEED_NORMAL: float = 1.0
const ANIMATION_SPEED_EFFECT: float = 25.0

const GRASS_DATAS: Dictionary = {
	"SMALL": {
		"QUANTITY": 2,
		"Y_OFFSET": 8.0,
		"PARTICLES": {
			"SHAPE_RECT": Vector2i(5, 5),
			"AMOUNT": 2
		},
		"REGULAR_ICED": {
			"REGIONS_RECTS": [Rect2(0.0, 0.0, 16.0, 16.0), Rect2(0.0, 16.0, 16.0, 16.0)],
			"COLOR": Color(0.545, 0.713, 0.466)
		},
		"BLUE_ICED": {
			"REGIONS_RECTS": [Rect2(16.0, 0.0, 16.0, 16.0), Rect2(16.0, 16.0, 16.0, 16.0)],
			"COLOR": Color(0.341, 0.464, 0.874)
		},
		"PURPLE_ICED": {
			"REGIONS_RECTS": [Rect2(32.0, 0.0, 16.0, 16.0), Rect2(32.0, 16.0, 16.0, 16.0)],
			"COLOR": Color(0.482, 0.345, 0.662)
		}
	},
	"MEDIUM": {
		"QUANTITY": 2,
		"Y_OFFSET": 8.0,
		"PARTICLES": {
			"SHAPE_RECT": Vector2i(10, 5),
			"AMOUNT": 4
		},
		"REGULAR_ICED": {
			"REGIONS_RECTS": [Rect2(0.0, 32.0, 32.0, 16.0), Rect2(0.0, 48.0, 32.0, 16.0)],
			"COLOR": Color(0.545, 0.713, 0.466)
		},
		"BLUE_ICED": {
			"REGIONS_RECTS": [Rect2(32.0, 32.0, 32.0, 16.0), Rect2(32.0, 48.0, 32.0, 16.0)],
			"COLOR": Color(0.341, 0.464, 0.874)
		},
		"PURPLE_ICED": {
			"REGIONS_RECTS": [Rect2(64.0, 32.0, 32.0, 16.0), Rect2(64.0, 48.0, 32.0, 16.0)],
			"COLOR": Color(0.482, 0.345, 0.662)
		}
	},
	"LARGE": {
		"QUANTITY": 2,
		"Y_OFFSET": 16.0,
		"PARTICLES": {
			"SHAPE_RECT": Vector2i(25, 10),
			"AMOUNT": 8
		},
		"REGULAR_ICED": {
			"REGIONS_RECTS": [Rect2(0.0, 64.0, 64.0, 32.0), Rect2(0.0, 96.0, 64.0, 32.0)],
			"COLOR": Color(0.545, 0.713, 0.466)
		},
		"BLUE_ICED": {
			"REGIONS_RECTS": [Rect2(64.0, 64.0, 64.0, 32.0), Rect2(64.0, 96.0, 64.0, 32.0)],
			"COLOR": Color(0.341, 0.464, 0.874)
		},
		"PURPLE_ICED": {
			"REGIONS_RECTS": [Rect2(128.0, 64.0, 64.0, 32.0), Rect2(128.0, 96.0, 64.0, 32.0)],
			"COLOR": Color(0.482, 0.345, 0.662)
		}
	}
}

const GRASS_ANIMATION_NAMES: Dictionary = {
	"SMALL": "grass",
	"MEDIUM": "grass",
	"LARGE": "large_grass"
}

#    >>  Nodes Imports
@onready var animation_player: AnimationPlayer = $Animation/AnimationPlayer
@onready var grass_sprite: Sprite2D = $Animation/grassSprite
@onready var grass_collision: Area2D = $Animation/grassSprite/GrassCollision
@onready var particles_grass: CPUParticles2D = $Animation/grassSprite/ParticlesGrass
@onready var particles_grass_bis: CPUParticles2D = $Animation/grassSprite/ParticlesGrassBis

@onready var collision_polygons: Dictionary = {
	"SMALL": $Animation/grassSprite/GrassCollision/SMALL_collision_polygon,
	"MEDIUM": $Animation/grassSprite/GrassCollision/MEDIUM_collision_polygon,
	"LARGE": $Animation/grassSprite/GrassCollision/LARGE_collision_polygon
}

#    >>  Variables Exports
@export var grass_type: String = "SMALL"

#    >>  Variables
var _player_controller: PlayerController = null
var _lvl_type: String = ""
var _is_background: bool = false
var _is_effect_applied: bool = false
var _is_player_colliding: bool = false
var _is_faded: bool = false
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _current_tween: Tween = null
var _all_particles: Array[CPUParticles2D] = []
var _grass_data: Dictionary = {}
var _current_collision_polygon: CollisionPolygon2D = null
#endregion

#                                                                
#          ██     ▄▄  ▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄ ▄▄  ▄▄ ▄▄▄▄▄ ▄▄▄▄   ▄▄▄▄ 
#    ▄▄▄   ██     ██ ███▄▄   ██   ██▄▄  ███▄██ ██▄▄  ██▄█▄ ███▄▄ 
#          ██████ ██ ▄▄███   ██   ██▄▄▄ ██ ▀██ ██▄▄▄ ██ ██ ▄▄███▀ 

#region Listeners

#    >>  Ready Function
func _ready() -> void:
	_cache_references()
	_initialize_grass_system()

#    >>  Process Function
func _process(delta: float) -> void:
	if not _is_background:
		_handle_grass_collision()
#endregion

#                                                                                          
#                                                                                          
#          ██ ███  ██ ██ ██████ ██ ▄████▄ ██     ██ ▄█████ ▄████▄ ██████ ██ ▄████▄ ███  ██ 
#    ▄▄▄   ██ ██ ▀▄██ ██   ██   ██ ██▄▄██ ██     ██ ▀▀▀▄▄▄ ██▄▄██   ██   ██ ██  ██ ██ ▀▄██ 
#          ██ ██   ██ ██   ██   ██ ██  ██ ██████ ██ █████▀ ██  ██   ██   ██ ▀████▀ ██   ██ 
#                                                                                          

#region System Initialization

#    >>  Cache All References
func _cache_references() -> void:
	_all_particles = [particles_grass, particles_grass_bis]
	
	var root_parent: Node = get_parent().get_parent().get_parent()
	_player_controller = root_parent.find_child(PLAYER_NODE_NAME, false, true) as PlayerController
	
	var lvl_type_node: Node = root_parent.find_child(LVL_TYPE_NODE_NAME, false, true)
	if lvl_type_node and lvl_type_node.has_meta(LVL_TYPE_META_KEY):
		_lvl_type = lvl_type_node.get_meta(LVL_TYPE_META_KEY) as String

#    >>  Initialize Grass System
func _initialize_grass_system() -> void:
	if not _validate_grass_type():
		return
	
	_check_if_background()
	_cache_grass_data()
	_setup_animation()
	_setup_collision_polygon()
	_setup_particles()
	_setup_light_mask()
	_generate_random_grass()

#    >>  Validate Grass Type
func _validate_grass_type() -> bool:
	if not GRASS_DATAS.has(grass_type):
		push_error("Invalid grass_type: " + grass_type)
		return false
	return true

#    >>  Check If Background Layer
func _check_if_background() -> void:
	var parent = get_parent().get_parent()
	_is_background = (parent.z_index == -3)

#    >>  Cache Grass Data
func _cache_grass_data() -> void:
	_grass_data = GRASS_DATAS[grass_type]
#endregion

#                                             
#                                             
#          ▄█████ ██████ ██████ ██  ██ █████▄ 
#    ▄▄▄   ▀▀▀▄▄▄ ██▄▄     ██   ██  ██ ██▄▄█▀ 
#          █████▀ ██▄▄▄▄   ██   ▀████▀ ██     
#                                             

#region Grass Properties Setup

#    >>  Setup Animation
func _setup_animation() -> void:
	var animation_name: String = GRASS_ANIMATION_NAMES.get(grass_type, "")
	
	if animation_name.is_empty():
		push_error("No animation found for grass_type: " + grass_type)
		return
	
	animation_player.play(animation_name)

#    >>  Setup Collision Polygon
func _setup_collision_polygon() -> void:
	_current_collision_polygon = collision_polygons.get(grass_type) as CollisionPolygon2D
	
	if _current_collision_polygon == null:
		push_error("Collision polygon not found for grass_type: " + grass_type)
		return
	
	_current_collision_polygon.disabled = false

#    >>  Setup Particles Properties
func _setup_particles() -> void:
	var particle_data: Dictionary = _grass_data.get("PARTICLES", {})
	var shape_rect: Vector2i = particle_data.get("SHAPE_RECT", Vector2i(5, 5))
	var amount: int = particle_data.get("AMOUNT", 2)
	
	for particle: CPUParticles2D in _all_particles:
		particle.emission_rect_extents = shape_rect
		particle.amount = amount

#    >>  Setup Light Mask from Parent
func _setup_light_mask() -> void:
	var parent = get_parent().get_parent()
	grass_sprite.set_light_mask(parent.get_light_mask())
#endregion

#                                                                                                                         
#                                                                                                                         
#             ▄████  █████▄  ▄████▄ ▄█████ ▄█████    ▄████  ██████ ███  ██ ██████ █████▄  ▄████▄ ██████ ██ ▄████▄ ███  ██ 
#      ▄▄▄   ██  ▄▄▄ ██▄▄██▄ ██▄▄██ ▀▀▀▄▄▄ ▀▀▀▄▄▄   ██  ▄▄▄ ██▄▄   ██ ▀▄██ ██▄▄   ██▄▄██▄ ██▄▄██   ██   ██ ██  ██ ██ ▀▄██ 
#             ▀███▀  ██   ██ ██  ██ █████▀ █████▀    ▀███▀  ██▄▄▄▄ ██   ██ ██▄▄▄▄ ██   ██ ██  ██   ██   ██ ▀████▀ ██   ██ 
#                                                                                                                         

#region Grass Generation

#    >>  Generate Random Grass
func _generate_random_grass() -> void:
	var grass_region: Rect2 = _get_random_grass_region()
	_apply_grass_region(grass_region)

#    >>  Get Random Grass Region
func _get_random_grass_region() -> Rect2:
	var lvl_data: Dictionary = _grass_data.get(_lvl_type, {})
	var regions_rects: Array = lvl_data.get("REGIONS_RECTS", [])
	
	if regions_rects.is_empty():
		push_error("No regions found for level type: " + _lvl_type)
		return Rect2()
	
	var quantity: int = _grass_data.get("QUANTITY", 1)
	var random_index: int = _rng.randi_range(0, quantity - 1)
	random_index = clampi(random_index, 0, regions_rects.size() - 1)
	
	return regions_rects[random_index] as Rect2

#    >>  Apply Grass Region to Sprite
func _apply_grass_region(region: Rect2) -> void:
	var y_offset: float = _grass_data.get("Y_OFFSET", 8.0)
	grass_sprite.position = Vector2(0, y_offset)
	grass_sprite.set_region_rect(region)
	grass_sprite.visible = true
#endregion

#                                                                                                                   
#                                                                                                                   
#          █████▄ ██     ▄████▄ ██  ██ ██████ █████▄    ████▄  ██████ ██████ ██████ ▄█████ ██████ ██ ▄████▄ ███  ██ 
#    ▄▄▄   ██▄▄█▀ ██     ██▄▄██  ▀██▀  ██▄▄   ██▄▄██▄   ██  ██ ██▄▄     ██   ██▄▄   ██       ██   ██ ██  ██ ██ ▀▄██ 
#          ██     ██████ ██  ██   ██   ██▄▄▄▄ ██   ██   ████▀  ██▄▄▄▄   ██   ██▄▄▄▄ ▀█████   ██   ██ ▀████▀ ██   ██ 
#                                                                                                                   

#region Player Collision Detection

#    >>  Player Collision Detector
func _detect_player_collision() -> void:
	_is_player_colliding = false
	
	if not grass_collision.has_overlapping_bodies():
		return
	
	for body: Node2D in grass_collision.get_overlapping_bodies():
		if body.name == PLAYER_NODE_NAME:
			_is_player_colliding = true
			return

#    >>  Check If Player Is Moving
func _is_player_moving() -> bool:
	if _player_controller == null:
		return false
	
	return abs(_player_controller.velocity.x) > 0.0 or abs(_player_controller.velocity.y) > 0.0
#endregion

#                                                                                                              
#                                                                                                              
#          ▄█████ ▄████▄ ██     ██     ██ ▄█████ ██ ▄████▄ ███  ██   ██████ ██████ ██████ ██████ ▄█████ ██████ 
#    ▄▄▄   ██     ██  ██ ██     ██     ██ ▀▀▀▄▄▄ ██ ██  ██ ██ ▀▄██   ██▄▄   ██▄▄   ██▄▄   ██▄▄   ██       ██   
#          ▀█████ ▀████▀ ██████ ██████ ██ █████▀ ██ ▀████▀ ██   ██   ██▄▄▄▄ ██     ██     ██▄▄▄▄ ▀█████   ██   
#                                                                                                              

#region Grass Interaction Handler

#    >>  Grass Collision Step Handler
func _handle_grass_collision() -> void:
	_detect_player_collision()
	
	if _is_player_colliding:
		_apply_grass_interaction()
	else:
		_reset_grass_interaction()

#    >>  Apply Grass Interaction Effects
func _apply_grass_interaction() -> void:
	# Handle fade for large grass
	if grass_type == "LARGE" and not _is_faded:
		_handle_fade(OUT_OPACITY)
		_is_faded = true
	
	if _is_player_moving():
		if _player_controller != null:
			_player_controller.collided = false
			_apply_player_deceleration()
		
		if not _is_effect_applied:
			_activate_visual_effects()
	else:
		if _is_effect_applied:
			_deactivate_visual_effects()

#    >>  Reset Grass Interaction
func _reset_grass_interaction() -> void:
	# Handle fade for large grass
	if grass_type == "LARGE" and _is_faded:
		_handle_fade(IN_OPACITY)
		_is_faded = false
	
	if _is_effect_applied:
		_deactivate_visual_effects()
#endregion

#                                                                                             
#                                                                                             
#             ▄████  █████▄  ▄████▄ ▄█████ ▄█████   ██████ ██████ ██████ ██████ ▄█████ ██████ 
#      ▄▄▄   ██  ▄▄▄ ██▄▄██▄ ██▄▄██ ▀▀▀▄▄▄ ▀▀▀▄▄▄   ██▄▄   ██▄▄   ██▄▄   ██▄▄   ██       ██   
#             ▀███▀  ██   ██ ██  ██ █████▀ █████▀   ██▄▄▄▄ ██     ██     ██▄▄▄▄ ▀█████   ██   
#                                                                                             

#region Grass Effects

#    >>  Apply Player Deceleration
func _apply_player_deceleration() -> void:
	if _player_controller == null:
		return
	
	_player_controller.velocity *= Vector2(DECELERATION_MULTIPLIER, DECELERATION_MULTIPLIER)

#    >>  Activate Visual Effects
func _activate_visual_effects() -> void:
	animation_player.speed_scale = ANIMATION_SPEED_EFFECT
	_emit_particles()
	_is_effect_applied = true

#    >>  Deactivate Visual Effects
func _deactivate_visual_effects() -> void:
	animation_player.speed_scale = ANIMATION_SPEED_NORMAL
	_stop_particles()
	_is_effect_applied = false

#    >>  Emit Particles
func _emit_particles() -> void:
	var lvl_data: Dictionary = _grass_data.get(_lvl_type, {})
	var particle_color: Color = lvl_data.get("COLOR", Color.WHITE)
	
	for particle: CPUParticles2D in _all_particles:
		particle.color = particle_color
		particle.emitting = true

#    >>  Stop Particles
func _stop_particles() -> void:
	for particle: CPUParticles2D in _all_particles:
		particle.emitting = false
#endregion

#                                                                                                                          
#                                                                                                                          
#             ▄▄▄  ▄▄▄▄   ▄▄▄   ▄▄▄▄ ▄▄ ▄▄▄▄▄▄ ▄▄ ▄▄   ▄▄▄▄▄  ▄▄▄  ▄▄▄▄  ▄▄▄▄▄   ▄▄▄▄▄ ▄▄▄▄▄ ▄▄▄▄▄ ▄▄▄▄▄  ▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄ 
#      ▄▄▄   ██▀██ ██▄█▀ ██▀██ ██▀▀▀ ██   ██   ▀███▀   ██▄▄  ██▀██ ██▀██ ██▄▄    ██▄▄  ██▄▄  ██▄▄  ██▄▄  ██▀▀▀   ██  ███▄▄ 
#            ▀███▀ ██    ██▀██ ▀████ ██   ██     █     ██    ██▀██ ████▀ ██▄▄▄   ██▄▄▄ ██    ██    ██▄▄▄ ▀████   ██  ▄▄██▀ 
#                                                                                                                          

#region Fade Effects

#    >>  Handle Fade Transition
func _handle_fade(target_opacity: float) -> void:
	if _current_tween and _current_tween.is_running():
		_current_tween.kill()
	
	var current_alpha: float = grass_sprite.material.get_shader_parameter("color_modulation").a
	
	_current_tween = get_tree().create_tween()
	_current_tween.tween_method(
		_set_grass_opacity,
		current_alpha,
		target_opacity,
		FADE_DURATION
	)
	_current_tween.play()

#    >>  Set Grass Opacity Value
func _set_grass_opacity(alpha: float) -> void:
	grass_sprite.material.set_shader_parameter("color_modulation", Color(1.0, 1.0, 1.0, alpha))
#endregion

#    ███████ ███    ██ ██████                                                                                                                              
#    ██      ████   ██ ██   ██                                                                                                                             
#    █████   ██ ██  ██ ██   ██     █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ 
#    ██      ██  ██ ██ ██   ██                                                                                                                             
#    ███████ ██   ████ ██████
